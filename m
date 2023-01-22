Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 191AB676E1A
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbjAVPHE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:07:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbjAVPHD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:07:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A926113E8;
        Sun, 22 Jan 2023 07:07:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BCCDEB80B17;
        Sun, 22 Jan 2023 15:07:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5762C433D2;
        Sun, 22 Jan 2023 15:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400019;
        bh=q62kfWxlcrXmaAWCXp/duzgwUX4OtXecSu8q+AIgqtg=;
        h=From:To:Cc:Subject:Date:From;
        b=K5HwhLOwA9u8DStR56woIf99/7TiI5uYTPXfZ712dMK+kUyh7Rg5tvwyDObOJVydw
         9lDtulzKZZZ6F8VP96UgTc8GjVpy9W47EjBKXO3ANSpSgO7EdWZxt8zhZy+6GMmyQZ
         V+9WwzGi8jChKB94NghuDri0Y1Lid0sIOa/mZkaE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 4.19 00/37] 4.19.271-rc1 review
Date:   Sun, 22 Jan 2023 16:03:57 +0100
Message-Id: <20230122150219.557984692@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.271-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.271-rc1
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

This is the start of the stable review cycle for the 4.19.271 release.
There are 37 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue, 24 Jan 2023 15:02:08 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.271-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.271-rc1

YingChi Long <me@inclyc.cn>
    x86/fpu: Use _Alignof to avoid undefined behavior in TYPE_ALIGN

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "ext4: generalize extents status tree search functions"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "ext4: add new pending reservation mechanism"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "ext4: fix reserved cluster accounting at delayed write time"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "ext4: fix delayed allocation bug in ext4_clu_mapped for bigalloc + inline"

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

Prashant Malani <pmalani@chromium.org>
    usb: typec: altmodes/displayport: Fix pin assignment calculation

Prashant Malani <pmalani@chromium.org>
    usb: typec: altmodes/displayport: Add pin assignment helper

Alexander Stein <alexander.stein@ew.tq-group.com>
    usb: host: ehci-fsl: Fix module alias

Michael Adler <michael.adler@siemens.com>
    USB: serial: cp210x: add SCALANCE LPE-9000 device id

Enzo Matsumiya <ematsumiya@suse.de>
    cifs: do not include page data when checking signature

Samuel Holland <samuel@sholland.org>
    mmc: sunxi-mmc: Fix clock refcount imbalance during unbind

Ian Abbott <abbotti@mev.co.uk>
    comedi: adv_pci1760: Fix PWM instruction handling

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

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Add a flag to disable USB3 lpm on a xhci root port level.

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Fix null pointer dereference when host dies

Jimmy Hu <hhhuuu@google.com>
    usb: xhci: Check endpoint is valid before dereferencing it

Ricardo Ribalda <ribalda@chromium.org>
    xhci-pci: set the dma max_seg_size

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix general protection fault in nilfs_btree_insert()

Shawn.Shao <shawn.shao@jaguarmicro.com>
    Add exception protection processing for vd in axi_chan_handle_err function

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

 Makefile                                       |   4 +-
 arch/x86/kernel/fpu/init.c                     |   7 +-
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c |   6 +
 drivers/firmware/google/gsmi.c                 |   7 +-
 drivers/infiniband/ulp/srp/ib_srp.h            |   8 +-
 drivers/mmc/host/sunxi-mmc.c                   |   8 +-
 drivers/staging/comedi/drivers/adv_pci1760.c   |   2 +-
 drivers/tty/serial/atmel_serial.c              |   8 +-
 drivers/tty/serial/pch_uart.c                  |   2 +-
 drivers/usb/core/hub.c                         |  13 +
 drivers/usb/gadget/function/f_ncm.c            |   4 +-
 drivers/usb/gadget/legacy/webcam.c             |   3 +
 drivers/usb/host/ehci-fsl.c                    |   2 +-
 drivers/usb/host/xhci-pci.c                    |   2 +
 drivers/usb/host/xhci-ring.c                   |   5 +-
 drivers/usb/host/xhci.c                        |  13 +
 drivers/usb/host/xhci.h                        |   1 +
 drivers/usb/misc/iowarrior.c                   |   2 +-
 drivers/usb/serial/cp210x.c                    |   1 +
 drivers/usb/serial/option.c                    |  17 ++
 drivers/usb/storage/uas-detect.h               |  13 +
 drivers/usb/storage/unusual_uas.h              |   7 -
 drivers/usb/typec/altmodes/displayport.c       |  22 +-
 fs/cifs/smb2pdu.c                              |  15 +-
 fs/ext4/ext4.h                                 |   8 +-
 fs/ext4/extents.c                              | 139 +++------
 fs/ext4/extents_status.c                       | 389 ++-----------------------
 fs/ext4/extents_status.h                       |  76 +----
 fs/ext4/inode.c                                |  92 ++----
 fs/ext4/super.c                                |   8 -
 fs/f2fs/extent_cache.c                         |   3 +-
 fs/nfs/filelayout/filelayout.c                 |   8 +
 fs/nilfs2/btree.c                              |  15 +-
 include/trace/events/ext4.h                    |  39 +--
 kernel/sys.c                                   |   2 +
 net/core/ethtool.c                             |   3 +-
 36 files changed, 238 insertions(+), 716 deletions(-)


