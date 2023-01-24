Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 993D06790D0
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 07:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231965AbjAXG2e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 01:28:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231851AbjAXG2e (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 01:28:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E84C83802E;
        Mon, 23 Jan 2023 22:28:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9EE94B810C5;
        Tue, 24 Jan 2023 06:28:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04512C433EF;
        Tue, 24 Jan 2023 06:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674541710;
        bh=pOJLAiEFiL06rncRaMQSq2Ld7YXXr4IvtdkUIlGrLMs=;
        h=From:To:Cc:Subject:Date:From;
        b=2ZaN3PHccX6pjInxvm418J+S536wZHuWClB85BG93NQLSP+7QfCTtfEwh3dr+O7Pp
         U9EOrciNNUk5Ww6N6u7tStitv3RL93Y/zf4919j7LSvs7iIM8lpHYfgz9rbN94516q
         ogrG/6T+4e6OQn7Pdkrz/Z0aiiDdwOFzvFYldauU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.304
Date:   Tue, 24 Jan 2023 07:28:26 +0100
Message-Id: <16745417066883@kroah.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.304 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                            |    2 +-
 arch/x86/kernel/fpu/init.c          |    7 ++-----
 drivers/firmware/google/gsmi.c      |    7 ++++---
 drivers/infiniband/ulp/srp/ib_srp.h |    8 +++++---
 drivers/tty/serial/atmel_serial.c   |    8 +-------
 drivers/tty/serial/pch_uart.c       |    2 +-
 drivers/usb/core/hub.c              |   13 +++++++++++++
 drivers/usb/gadget/function/f_ncm.c |    4 +++-
 drivers/usb/gadget/legacy/webcam.c  |    3 +++
 drivers/usb/host/ehci-fsl.c         |    2 +-
 drivers/usb/host/xhci-pci.c         |    2 ++
 drivers/usb/host/xhci-ring.c        |    5 ++++-
 drivers/usb/misc/iowarrior.c        |    2 +-
 drivers/usb/serial/cp210x.c         |    1 +
 drivers/usb/serial/option.c         |   17 +++++++++++++++++
 drivers/usb/storage/uas-detect.h    |   13 +++++++++++++
 drivers/usb/storage/unusual_uas.h   |    7 -------
 fs/f2fs/extent_cache.c              |    3 ++-
 fs/nfs/filelayout/filelayout.c      |    8 ++++++++
 fs/nilfs2/btree.c                   |   15 ++++++++++++---
 kernel/sys.c                        |    2 ++
 net/core/ethtool.c                  |    3 ++-
 22 files changed, 98 insertions(+), 36 deletions(-)

Alexander Stein (1):
      usb: host: ehci-fsl: Fix module alias

Ali Mirghasemi (1):
      USB: serial: option: add Quectel EC200U modem

Daniel Scally (1):
      usb: gadget: g_webcam: Send color matching descriptor per frame

Daniil Tatianin (1):
      net/ethtool/ioctl: return -EOPNOTSUPP if we have no phy stats

Duke Xin(辛安文) (5):
      USB: serial: option: add Quectel EM05-G (GR) modem
      USB: serial: option: add Quectel EM05-G (CS) modem
      USB: serial: option: add Quectel EM05-G (RS) modem
      USB: serial: option: add Quectel EM05CN (SG) modem
      USB: serial: option: add Quectel EM05CN modem

Flavio Suligoi (1):
      usb: core: hub: disable autosuspend for TI TUSB8041

Greg Kroah-Hartman (3):
      prlimit: do_prlimit needs to have a speculation check
      USB: misc: iowarrior: fix up header size for USB_DEVICE_ID_CODEMERCS_IOW100
      Linux 4.14.304

Ilpo Järvinen (1):
      serial: pch_uart: Pass correct sg to dma_unmap_sg()

Jaegeuk Kim (1):
      f2fs: let's avoid panic if extent_tree is not created

Jimmy Hu (1):
      usb: xhci: Check endpoint is valid before dereferencing it

Jiri Slaby (SUSE) (1):
      RDMA/srp: Move large values to a new enum for gcc13

Juhyung Park (1):
      usb-storage: apply IGNORE_UAS only for HIKSEMI MD202 on RTL9210

Khazhismel Kumykov (1):
      gsmi: fix null-deref in gsmi_get_variable

Maciej Żenczykowski (1):
      usb: gadget: f_ncm: fix potential NULL ptr deref in ncm_bitrate()

Michael Adler (1):
      USB: serial: cp210x: add SCALANCE LPE-9000 device id

Olga Kornievskaia (1):
      pNFS/filelayout: Fix coalescing test for single DS

Ricardo Ribalda (1):
      xhci-pci: set the dma max_seg_size

Ryusuke Konishi (1):
      nilfs2: fix general protection fault in nilfs_btree_insert()

Tobias Schramm (1):
      serial: atmel: fix incorrect baudrate setup

YingChi Long (1):
      x86/fpu: Use _Alignof to avoid undefined behavior in TYPE_ALIGN

