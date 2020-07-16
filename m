Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4AAC2218EA
	for <lists+stable@lfdr.de>; Thu, 16 Jul 2020 02:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbgGPA1b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 20:27:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:54318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726770AbgGPA1b (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Jul 2020 20:27:31 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26E14206F5;
        Thu, 16 Jul 2020 00:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594859250;
        bh=vT3xLEFkOcP2t0RQKK47xJd9RemOzqIloLTiufJQd4Y=;
        h=Date:From:To:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=kAoQdChEIX4MqzOUSzrMPY4WnlT19MA6/fV6gGgwCcffezv6pcP5+Eh1Fmluju7IU
         6Viv4UyzyeaBHBqCSMkX2HklOH+aDW5BIJTmbEcEw62t52hozBdPlt5+xp6OviJ0Nq
         n+iBKI40FLQNzbItGY5e/dZwz2sUORRI881jj5R0=
Date:   Thu, 16 Jul 2020 00:27:29 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
To:     Eric Biggers <ebiggers@google.com>
To:     linux-security-module@vger.kernel.org
Cc:     syzkaller-bugs@googlegroups.com, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] Smack: fix use-after-free in smk_write_relabel_self()
In-Reply-To: <20200708201520.140376-1-ebiggers@kernel.org>
References: <20200708201520.140376-1-ebiggers@kernel.org>
Message-Id: <20200716002730.26E14206F5@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 38416e53936e ("Smack: limited capability for changing process label").

The bot has tested the following trees: v5.7.8, v5.4.51, v4.19.132, v4.14.188, v4.9.230, v4.4.230.

v5.7.8: Build OK!
v5.4.51: Build OK!
v4.19.132: Failed to apply! Possible dependencies:
    b17103a8b8ae9 ("Smack: Abstract use of cred security blob")

v4.14.188: Failed to apply! Possible dependencies:
    03450e271a160 ("fs: add ksys_fchmod() and do_fchmodat() helpers and ksys_chmod() wrapper; remove in-kernel calls to syscall")
    312db1aa1dc7b ("fs: add ksys_mount() helper; remove in-kernel calls to sys_mount()")
    3a18ef5c1b393 ("fs: add ksys_umount() helper; remove in-kernel call to sys_umount()")
    447016e968196 ("fs: add ksys_chdir() helper; remove in-kernel calls to sys_chdir()")
    819671ff849b0 ("syscalls: define and explain goal to not call syscalls in the kernel")
    9481769208b5e ("->file_open(): lose cred argument")
    a16fe33ab5572 ("fs: add ksys_chroot() helper; remove-in kernel calls to sys_chroot()")
    ae2bb293a3e8a ("get rid of cred argument of vfs_open() and do_dentry_open()")
    af04fadcaa932 ("Revert "fs: fold open_check_o_direct into do_dentry_open"")
    b17103a8b8ae9 ("Smack: Abstract use of cred security blob")
    c7248321a3d42 ("fs: add ksys_dup{,3}() helper; remove in-kernel calls to sys_dup{,3}()")
    d19dfe58b7ecb ("Smack: Privilege check on key operations")
    dcb569cf6ac99 ("Smack: ptrace capability use fixes")
    e3f20ae21079e ("security_file_open(): lose cred argument")
    e7a3e8b2edf54 ("fs: add ksys_write() helper; remove in-kernel calls to sys_write()")

v4.9.230: Failed to apply! Possible dependencies:
    078c73c63fb28 ("apparmor: add profile and ns params to aa_may_manage_policy()")
    121d4a91e3c12 ("apparmor: rename sid to secid")
    12557dcba21b0 ("apparmor: move lib definitions into separate lib include")
    2bd8dbbf22fe9 ("apparmor: add ns being viewed as a param to policy_view_capable()")
    5ac8c355ae001 ("apparmor: allow introspecting the loaded policy pre internal transform")
    637f688dc3dc3 ("apparmor: switch from profiles to using labels on contexts")
    73688d1ed0b8f ("apparmor: refactor prepare_ns() and make usable from different views")
    9481769208b5e ("->file_open(): lose cred argument")
    98849dff90e27 ("apparmor: rename namespace to ns to improve code line lengths")
    9a2d40c12d00e ("apparmor: add strn version of aa_find_ns")
    a6f233003b1af ("apparmor: allow specifying the profile doing the management")
    b17103a8b8ae9 ("Smack: Abstract use of cred security blob")
    cff281f6861e7 ("apparmor: split apparmor policy namespaces code into its own file")
    d19dfe58b7ecb ("Smack: Privilege check on key operations")
    dcb569cf6ac99 ("Smack: ptrace capability use fixes")
    f28e783ff668c ("Smack: Use cap_capable in privilege check")
    fd2a80438d736 ("apparmor: add ns being viewed as a param to policy_admin_capable()")
    fe6bb31f590c9 ("apparmor: split out shared policy_XXX fns to lib")

v4.4.230: Failed to apply! Possible dependencies:
    078c73c63fb28 ("apparmor: add profile and ns params to aa_may_manage_policy()")
    121d4a91e3c12 ("apparmor: rename sid to secid")
    12557dcba21b0 ("apparmor: move lib definitions into separate lib include")
    2bd8dbbf22fe9 ("apparmor: add ns being viewed as a param to policy_view_capable()")
    5ac8c355ae001 ("apparmor: allow introspecting the loaded policy pre internal transform")
    637f688dc3dc3 ("apparmor: switch from profiles to using labels on contexts")
    73688d1ed0b8f ("apparmor: refactor prepare_ns() and make usable from different views")
    79be093500791 ("Smack: File receive for sockets")
    9481769208b5e ("->file_open(): lose cred argument")
    98849dff90e27 ("apparmor: rename namespace to ns to improve code line lengths")
    9a2d40c12d00e ("apparmor: add strn version of aa_find_ns")
    a6f233003b1af ("apparmor: allow specifying the profile doing the management")
    b17103a8b8ae9 ("Smack: Abstract use of cred security blob")
    c60b906673eeb ("Smack: Signal delivery as an append operation")
    cff281f6861e7 ("apparmor: split apparmor policy namespaces code into its own file")
    d19dfe58b7ecb ("Smack: Privilege check on key operations")
    dcb569cf6ac99 ("Smack: ptrace capability use fixes")
    f28e783ff668c ("Smack: Use cap_capable in privilege check")
    fd2a80438d736 ("apparmor: add ns being viewed as a param to policy_admin_capable()")
    fe6bb31f590c9 ("apparmor: split out shared policy_XXX fns to lib")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
