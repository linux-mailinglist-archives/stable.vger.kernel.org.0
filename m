Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A902D311291
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 21:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233094AbhBESw4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 13:52:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:45888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233073AbhBEPEk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 10:04:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 119C7650D2;
        Fri,  5 Feb 2021 14:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612535320;
        bh=d7NHusXustUM3ugqt86+TlsodGohZmsDn6SZJsVJO3Q=;
        h=From:To:Cc:Subject:Date:From;
        b=JGG1v5LzYumjqRLZzg8Sdh8FTRtynRHJhEkyZvnSchv0xDdZlUEKy9ntTbYLunsI7
         QfGKxcUgSqfKVY7nEWZgB6SsmcUcl1QtpGS8WIXqJsuphs21tLID+ThXHwiYkoI35k
         oU2fXEsv3LgCaslFDOieYcFDWzKXqbZg1yuI0324=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.256
Date:   Fri,  5 Feb 2021 15:26:18 +0100
Message-Id: <1612535085125226@kroah.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.9.256 kernel.

This, and the 4.4.256 release are a little bit "different" than normal.

This contains only 1 patch, just the version bump from .255 to .256 which ends
up causing the userspace-visable LINUX_VERSION_CODE to behave a bit differently
than normal due to the "overflow".

With this release, KERNEL_VERSION(4, 9, 256) is the same as KERNEL_VERSION(4, 10, 0).

Nothing in the kernel build itself breaks with this change, but given that this
is a userspace visible change, and some crazy tools (like glibc and gcc) have
logic that checks the kernel version for different reasons, I wanted to do this
release as an "empty" release to ensure that everything still works properly.

So, this is a YOU MUST UPGRADE requirement of a release.  If you rely on the
4.9.y kernel, please throw this release into your test builds and rebuild the
world and let us know if anything breaks, or if all is well.

Go forth and do full system rebuilds!  Yocto and Gentoo are great for this, as
will systems that use buildroot.

I'll try to hold off on doing a "real" 4.9.y release for a 9eek to give
everyone a chance to test this out and get back to me.  The pending patches in
the 4.9.y queue are pretty serious, so I am loath to wait longer than that,
consider yourself warned...

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Greg Kroah-Hartman (1):
      Linux 4.9.256

