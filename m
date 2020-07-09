Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAB6F219C31
	for <lists+stable@lfdr.de>; Thu,  9 Jul 2020 11:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgGIJ26 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jul 2020 05:28:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:34130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726302AbgGIJ25 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Jul 2020 05:28:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9004F206A1;
        Thu,  9 Jul 2020 09:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594286936;
        bh=UVqULLdCv7+1XBcxAV/Uc1EcZGwb2ykSw7KYc8KPJhM=;
        h=From:To:Cc:Subject:Date:From;
        b=UsSPBXC0uy2Mu/89y6QErSE3SvLF34gyhSdwgAd/iG2nWZCdGETujnNcQ6kDJHsyR
         3WVSvlayp+60iAkj44oONtZfp5rOm+jMZIYkzjwEw/sVSqTB25DPhbdfXsZGMg/52p
         ojzCcVarkhwEXNsWqxcreldAtpOHMav5fArvxlrc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.188
Date:   Thu,  9 Jul 2020 11:28:51 +0200
Message-Id: <159428693110397@kroah.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.188 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                |    2 
 arch/mips/kernel/traps.c                                |    1 
 crypto/af_alg.c                                         |   26 +--
 crypto/algif_aead.c                                     |    9 -
 crypto/algif_hash.c                                     |    9 -
 crypto/algif_skcipher.c                                 |    9 -
 drivers/block/virtio_blk.c                              |    1 
 drivers/edac/amd64_edac.c                               |    2 
 drivers/firmware/efi/Kconfig                            |   11 +
 drivers/firmware/efi/efi.c                              |    2 
 drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c                  |    5 
 drivers/hwmon/acpi_power_meter.c                        |    4 
 drivers/hwmon/max6697.c                                 |    7 
 drivers/i2c/algos/i2c-algo-pca.c                        |    3 
 drivers/irqchip/irq-gic.c                               |   14 -
 drivers/md/dm-zoned-target.c                            |    2 
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c       |   18 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32_parse.h |  122 ++++++++++------
 drivers/net/ethernet/chelsio/cxgb4/sge.c                |    2 
 drivers/net/usb/smsc95xx.c                              |    2 
 drivers/usb/misc/usbtest.c                              |    1 
 fs/btrfs/extent-tree.c                                  |   19 +-
 fs/btrfs/inode.c                                        |   35 +++-
 fs/cifs/connect.c                                       |    3 
 fs/cifs/inode.c                                         |   10 +
 fs/nfsd/vfs.c                                           |    6 
 include/crypto/if_alg.h                                 |    4 
 kernel/debug/debug_core.c                               |    4 
 mm/slub.c                                               |   30 +++
 mm/swap_state.c                                         |    3 
 sound/usb/card.h                                        |    4 
 sound/usb/endpoint.c                                    |   43 -----
 sound/usb/endpoint.h                                    |    1 
 sound/usb/pcm.c                                         |    2 
 34 files changed, 238 insertions(+), 178 deletions(-)

Anand Jain (1):
      btrfs: cow_file_range() num_bytes and disk_num_bytes are same

Borislav Petkov (1):
      EDAC/amd64: Read back the scrub rate PCI register on F15h

Chen-Yu Tsai (1):
      drm: sun4i: hdmi: Remove extra HPD polling

Chris Packham (1):
      i2c: algo-pca: Add 0x78 as SCL stuck low status for PCA9665

Chu Lin (1):
      hwmon: (max6697) Make sure the OVERT mask is set correctly

Dongli Zhang (1):
      mm/slub.c: fix corrupted freechain in deactivate_slab()

Douglas Anderson (1):
      kgdb: Avoid suspicious RCU usage warning

Filipe Manana (2):
      btrfs: fix a block group ref counter leak after failure to remove block group
      btrfs: fix data block group relocation failure due to concurrent scrub

Greg Kroah-Hartman (2):
      Revert "ALSA: usb-audio: Improve frames size computation"
      Linux 4.14.188

Hauke Mehrtens (1):
      MIPS: Add missing EHB in mtc0 -> mfc0 sequence for DSPen

Herbert Xu (1):
      crypto: af_alg - fix use-after-free in af_alg_accept() due to bh_lock_sock()

Hou Tao (2):
      virtio-blk: free vblk-vqs in error path of virtblk_probe()
      dm zoned: assign max_io_len correctly

Hugh Dickins (1):
      mm: fix swap cache node allocation mask

J. Bruce Fields (1):
      nfsd: apply umask on fs without ACL support

Marc Zyngier (1):
      irqchip/gic: Atomically update affinity

Misono Tomohiro (1):
      hwmon: (acpi_power_meter) Fix potential memory leak in acpi_power_meter_add()

Paul Aurich (2):
      SMB3: Honor 'seal' flag for multiuser mounts
      SMB3: Honor persistent/resilient handle flags for multiuser mounts

Peter Jones (1):
      efi: Make it possible to disable efivar_ssdt entirely

Qian Cai (1):
      mm/slub: fix stack overruns with SLUB_STATS

Rahul Lakkireddy (2):
      cxgb4: use unaligned conversion for fetching timestamp
      cxgb4: parse TC-U32 key values and masks natively

Tuomas Tynkkynen (1):
      usbnet: smsc95xx: Fix use-after-free after removal

Zhang Xiaoxu (1):
      cifs: Fix the target file was deleted when rename failed.

Zqiang (1):
      usb: usbtest: fix missing kfree(dev->buf) in usbtest_disconnect

