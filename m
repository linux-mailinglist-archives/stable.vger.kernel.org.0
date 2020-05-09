Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C188A1CC14D
	for <lists+stable@lfdr.de>; Sat,  9 May 2020 14:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728552AbgEIMay (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 May 2020 08:30:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:60304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728388AbgEIMay (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 May 2020 08:30:54 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8336121775;
        Sat,  9 May 2020 12:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589027453;
        bh=OwcjYKRbZzqpyx8QeBNflPw0HHuipPQBwm+zLS/vkDE=;
        h=Date:From:To:To:To:To:Cc:Cc:Cc:Cc:Cc:Subject:In-Reply-To:
         References:From;
        b=Kr6hj66rZcU8VVPxHRTeNlogBeZ7ss2vlhiuVmUN9I58gcL96VF9yyymyir6bFJnm
         EzvAxKvYyEOBMCjEFXz92QPq7xbbSQ3hTSPfdcYScb+TEo0R8iTCRt9v1ix1dI35IC
         RvqVjnYmBSMQN1gMMSI99wXkcCRgPfAezSyX50W4=
Date:   Sat, 09 May 2020 12:30:52 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
To:     Oleg Nesterov <oleg@redhat.com>
To:     1vier1@web.de, akpm@linux-foundation.org, dave@stgolabs.net
Cc:     Davidlohr Bueso <dave@stgolabs.net>
Cc:     Markus Elfring <elfring@users.sourceforge.net>
Cc:     <1vier1@web.de>
Cc:     <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [patch 01/15] ipc/mqueue.c: change __do_notify() to bypass check_kill_permission()
In-Reply-To: <20200508013539.Q-iufOGqB%akpm@linux-foundation.org>
References: <20200508013539.Q-iufOGqB%akpm@linux-foundation.org>
Message-Id: <20200509123053.8336121775@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: cc731525f26a ("signal: Remove kernel interal si_code magic").

The bot has tested the following trees: v5.6.11, v5.4.39, v4.19.121, v4.14.179.

v5.6.11: Build OK!
v5.4.39: Build OK!
v4.19.121: Failed to apply! Possible dependencies:
    4cd2e0e70af6 ("signal: Introduce copy_siginfo_from_user and use it's return value")
    ae7795bc6187 ("signal: Distinguish between kernel_siginfo and siginfo")
    efc463adbccf ("signal: Simplify tracehook_report_syscall_exit")

v4.14.179: Failed to apply! Possible dependencies:
    212a36a17efe ("signal: Unify and correct copy_siginfo_from_user32")
    3eb0f5193b49 ("signal: Ensure every siginfo we send has all bits initialized")
    3f7c86b2382e ("arm64: Update fault_info table with new exception types")
    526c3ddb6aa2 ("signal/arm64: Document conflicts with SI_USER and SIGFPE,SIGTRAP,SIGBUS")
    532826f3712b ("arm64: Mirror arm for unimplemented compat syscalls")
    6b4f3d01052a ("usb, signal, security: only pass the cred, not the secid, to kill_pid_info_as_cred and security_task_kill")
    92ff0674f5d8 ("arm64: mm: Rework unhandled user pagefaults to call arm64_force_sig_info")
    ae7795bc6187 ("signal: Distinguish between kernel_siginfo and siginfo")
    af40ff687bc9 ("arm64: signal: Ensure si_code is valid for all fault signals")
    b713da69e4c9 ("signal: unify compat_siginfo_t")
    ea64d5acc8f0 ("signal: Unify and correct copy_siginfo_to_user32")
    efc463adbccf ("signal: Simplify tracehook_report_syscall_exit")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
