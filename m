Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6A5106E3C
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731333AbfKVLG5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:06:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:35664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731908AbfKVLGz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:06:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CFE720C01;
        Fri, 22 Nov 2019 11:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420814;
        bh=pux/dURxd4K/ejrcOLbJpQEdQJ40asiQBQCXGwd/McU=;
        h=From:To:Cc:Subject:Date:From;
        b=Gh7wnjF/f8zHqS/YDN05LavdjTM/K1M8oOEFaa0JCK9I0kZWQ2F2U6kFkN27BitU4
         uuRyDS/bWbuwCGykwy+tk133qdRujToKW3Ddz3sJ+2pSVgqHlGS41QKQL//1jilU66
         XufyiYLb4h/Ybu3BQtVJc5wgH9cZ4vaSerLdtHeM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.3 0/6] 5.3.13-stable review
Date:   Fri, 22 Nov 2019 11:30:02 +0100
Message-Id: <20191122100320.878809004@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.3.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.3.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.3.13-rc1
X-KernelTest-Deadline: 2019-11-24T10:03+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.3.13 release.
There are 6 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 24 Nov 2019 09:59:19 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.13-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.3.13-rc1

Daniel Vetter <daniel.vetter@ffwll.ch>
    fbdev: Ditch fb_edid_add_monspecs

Pavel Tatashin <pasha.tatashin@soleen.com>
    arm64: uaccess: Ensure PAN is re-enabled after unhandled uaccess fault

David Hildenbrand <david@redhat.com>
    mm/memory_hotplug: fix updating the node span

David Hildenbrand <david@redhat.com>
    mm/memory_hotplug: don't access uninitialized memmaps in shrink_pgdat_span()

Paolo Valente <paolo.valente@linaro.org>
    block, bfq: deschedule empty bfq_queues not referred by any process

Dan Carpenter <dan.carpenter@oracle.com>
    net: cdc_ncm: Signedness bug in cdc_ncm_set_dgram_size()


-------------

Diffstat:

 Makefile                          |  4 +-
 arch/arm64/lib/clear_user.S       |  1 +
 arch/arm64/lib/copy_from_user.S   |  1 +
 arch/arm64/lib/copy_in_user.S     |  1 +
 arch/arm64/lib/copy_to_user.S     |  1 +
 block/bfq-iosched.c               | 32 ++++++++++---
 drivers/net/usb/cdc_ncm.c         |  2 +-
 drivers/video/fbdev/core/fbmon.c  | 96 ---------------------------------------
 drivers/video/fbdev/core/modedb.c | 57 -----------------------
 include/linux/fb.h                |  3 --
 mm/memory_hotplug.c               | 74 ++++++++----------------------
 11 files changed, 53 insertions(+), 219 deletions(-)


