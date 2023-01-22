Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6233676E18
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:07:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbjAVPHC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:07:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbjAVPHC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:07:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 844DE1E29C;
        Sun, 22 Jan 2023 07:06:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D0A9B80B16;
        Sun, 22 Jan 2023 15:06:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54033C433EF;
        Sun, 22 Jan 2023 15:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400016;
        bh=EAvMcsAOcXo3fRxWrLH8jQ4AGIyXihXNUSTFO7orxQY=;
        h=From:To:Cc:Subject:Date:From;
        b=j4Wt7Xk6d9Kgf0cMB3BxeAKoovKAbtjwHswN2endfYuvnZSCr+hg5Cj1K7WwXEdeu
         9WL+keI1F7sh6L+hNstvBj2r7vi62cSJvdEcpA/89m8+5MajOLsHKwxSzBNg8kP0lA
         iMlT+MJz0nFxUF229lgKgPnYbjVxXWOeCIqbsguw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 4.14 00/25] 4.14.304-rc1 review
Date:   Sun, 22 Jan 2023 16:04:00 +0100
Message-Id: <20230122150217.788215473@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.304-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.304-rc1
X-KernelTest-Deadline: 2023-01-24T15:02+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.304 release.
There are 25 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue, 24 Jan 2023 15:02:08 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.304-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.304-rc1

YingChi Long <me@inclyc.cn>
    x86/fpu: Use _Alignof to avoid undefined behavior in TYPE_ALIGN

Khazhismel Kumykov <khazhy@chromium.org>
    gsmi: fix null-deref in gsmi_get_variable

Tobias Schramm <t.schramm@manjaro.org>
    serial: atmel: fix incorrect baudrate setup

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: pch_uart: Pass correct sg to dma_unmap_sg()

Juhyung Park <qkrwngud825@gmail.com>
    usb-storage: apply IGNORE_UAS only for HIKSEMI MD202 on RTL9210

Maciej Żenczykowski <maze@google.com>
    usb: gadget: f_ncm: fix potential NULL ptr deref in ncm_bitrate()

Daniel Scally <dan.scally@ideasonboard.com>
    usb: gadget: g_webcam: Send color matching descriptor per frame

Alexander Stein <alexander.stein@ew.tq-group.com>
    usb: host: ehci-fsl: Fix module alias

Michael Adler <michael.adler@siemens.com>
    USB: serial: cp210x: add SCALANCE LPE-9000 device id

Flavio Suligoi <f.suligoi@asem.it>
    usb: core: hub: disable autosuspend for TI TUSB8041

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: misc: iowarrior: fix up header size for USB_DEVICE_ID_CODEMERCS_IOW100

Duke Xin(辛安文) <duke_xinanwen@163.com>
    USB: serial: option: add Quectel EM05CN modem

Duke Xin(辛安文) <duke_xinanwen@163.com>
    USB: serial: option: add Quectel EM05CN (SG) modem

Ali Mirghasemi <ali.mirghasemi1376@gmail.com>
    USB: serial: option: add Quectel EC200U modem

Duke Xin(辛安文) <duke_xinanwen@163.com>
    USB: serial: option: add Quectel EM05-G (RS) modem

Duke Xin(辛安文) <duke_xinanwen@163.com>
    USB: serial: option: add Quectel EM05-G (CS) modem

Duke Xin(辛安文) <duke_xinanwen@163.com>
    USB: serial: option: add Quectel EM05-G (GR) modem

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    prlimit: do_prlimit needs to have a speculation check

Jimmy Hu <hhhuuu@google.com>
    usb: xhci: Check endpoint is valid before dereferencing it

Ricardo Ribalda <ribalda@chromium.org>
    xhci-pci: set the dma max_seg_size

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix general protection fault in nilfs_btree_insert()

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: let's avoid panic if extent_tree is not created

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    RDMA/srp: Move large values to a new enum for gcc13

Daniil Tatianin <d-tatianin@yandex-team.ru>
    net/ethtool/ioctl: return -EOPNOTSUPP if we have no phy stats

Olga Kornievskaia <olga.kornievskaia@gmail.com>
    pNFS/filelayout: Fix coalescing test for single DS


-------------

Diffstat:

 Makefile                            |  4 ++--
 arch/x86/kernel/fpu/init.c          |  7 ++-----
 drivers/firmware/google/gsmi.c      |  7 ++++---
 drivers/infiniband/ulp/srp/ib_srp.h |  8 +++++---
 drivers/tty/serial/atmel_serial.c   |  8 +-------
 drivers/tty/serial/pch_uart.c       |  2 +-
 drivers/usb/core/hub.c              | 13 +++++++++++++
 drivers/usb/gadget/function/f_ncm.c |  4 +++-
 drivers/usb/gadget/legacy/webcam.c  |  3 +++
 drivers/usb/host/ehci-fsl.c         |  2 +-
 drivers/usb/host/xhci-pci.c         |  2 ++
 drivers/usb/host/xhci-ring.c        |  5 ++++-
 drivers/usb/misc/iowarrior.c        |  2 +-
 drivers/usb/serial/cp210x.c         |  1 +
 drivers/usb/serial/option.c         | 17 +++++++++++++++++
 drivers/usb/storage/uas-detect.h    | 13 +++++++++++++
 drivers/usb/storage/unusual_uas.h   |  7 -------
 fs/f2fs/extent_cache.c              |  3 ++-
 fs/nfs/filelayout/filelayout.c      |  8 ++++++++
 fs/nilfs2/btree.c                   | 15 ++++++++++++---
 kernel/sys.c                        |  2 ++
 net/core/ethtool.c                  |  3 ++-
 22 files changed, 99 insertions(+), 37 deletions(-)


