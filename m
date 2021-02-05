Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C75E53110F9
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 20:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233436AbhBERhu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 12:37:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:54098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233312AbhBEP51 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 10:57:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BA52650D6;
        Fri,  5 Feb 2021 14:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612535326;
        bh=E4Njdi9BsEi+SiQz271rhceilEwdMI3Du63Bkz6PWUE=;
        h=From:To:Cc:Subject:Date:From;
        b=Ywsvbl+GbjilSmfPFGuHaVOld7B16NpnW0QnZ/4w22Vn2PMnd4WrPCAo3VkOoZALf
         xWpBIAAAir8LyT61L3dSQl/6HRpPMmVvD/Z0KRMGM39dH3NUQppTLLXuC1/Cem5AGZ
         vmh8hNOTADSVhEWyQOH1+WT60kkEv/5SaG+roErw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.256
Date:   Fri,  5 Feb 2021 15:26:36 +0100
Message-Id: <1612534196241236@kroah.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.256 kernel.

This, and the 4.9.256 release are a little bit "different" than normal.

This contains only 1 patch, just the version bump from .255 to .256 which ends
up causing the userspace-visable LINUX_VERSION_CODE to behave a bit differently
than normal due to the "overflow".

With this release, KERNEL_VERSION(4, 4, 256) is the same as KERNEL_VERSION(4, 5, 0).

Nothing in the kernel build itself breaks with this change, but given that this
is a userspace visible change, and some crazy tools (like glibc and gcc) have
logic that checks the kernel version for different reasons, I wanted to do this
release as an "empty" release to ensure that everything still works properly.

So, this is a YOU MUST UPGRADE requirement of a release.  If you rely on the
4.4.y kernel, please throw this release into your test builds and rebuild the
world and let us know if anything breaks, or if all is well.

Go forth and do full system rebuilds!  Yocto and Gentoo are great for this, as
will systems that use buildroot.

I'll try to hold off on doing a "real" 4.4.y release for a week to give
everyone a chance to test this out and get back to me.  The pending patches in
the 4.4.y queue are pretty serious, so I am loath to wait longer than that,
consider yourself warned...

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Greg Kroah-Hartman (1):
      Linux 4.4.256

