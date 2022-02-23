Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A84734C125B
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 13:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240214AbiBWMHc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 07:07:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240263AbiBWMHa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 07:07:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD1544B1D6;
        Wed, 23 Feb 2022 04:07:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C80460B4B;
        Wed, 23 Feb 2022 12:07:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5821DC340E7;
        Wed, 23 Feb 2022 12:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645618021;
        bh=L+L4dXeeTkjj3/9FcWHbvR9hRwvicGvGgEaejWfIVVM=;
        h=From:To:Cc:Subject:Date:From;
        b=DUJMijUaD7iMm854sP9p5clhZvpg0VEJlVNXWRyX4r2brDhol6ZXXTK8BSvUxS5sn
         hDsYy/j5tHP+Y2OBHIzePwvrKYZRJ9aCuSDInm6rimXvY8q41lLeUn0HJrTJ3m8wmL
         Or+H6vauV54KSYOwlu0mGFYLpfMQoLu4qzDLqv+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.231
Date:   Wed, 23 Feb 2022 13:06:54 +0100
Message-Id: <164561801554167@kroah.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.231 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/ABI/stable/sysfs-bus-vmbus             |   12 +
 Makefile                                             |    2 
 arch/arm/mach-omap2/omap_hwmod.c                     |    4 
 arch/arm64/boot/dts/amlogic/meson-gx.dtsi            |    6 
 arch/powerpc/lib/sstep.c                             |    2 
 arch/x86/kvm/pmu.c                                   |    2 
 block/bfq-iosched.c                                  |    2 
 block/elevator.c                                     |    2 
 drivers/ata/libata-core.c                            |    1 
 drivers/dma/sh/rcar-dmac.c                           |    4 
 drivers/edac/edac_mc.c                               |    2 
 drivers/gpu/drm/radeon/atombios_encoders.c           |    3 
 drivers/hv/channel_mgmt.c                            |    1 
 drivers/hv/hyperv_vmbus.h                            |    2 
 drivers/hv/vmbus_drv.c                               |   82 +++++++++++
 drivers/i2c/busses/i2c-brcmstb.c                     |    2 
 drivers/irqchip/irq-sifive-plic.c                    |    1 
 drivers/mmc/core/block.c                             |   28 +--
 drivers/mtd/nand/raw/brcmnand/brcmnand.c             |  102 ++++++++------
 drivers/mtd/nand/raw/qcom_nandc.c                    |   14 -
 drivers/net/bonding/bond_3ad.c                       |   30 +++-
 drivers/net/dsa/lan9303-core.c                       |    2 
 drivers/net/ethernet/cadence/macb_main.c             |    2 
 drivers/net/ieee802154/at86rf230.c                   |   13 +
 drivers/net/ieee802154/ca8210.c                      |    4 
 drivers/net/usb/ax88179_178a.c                       |   68 +++++----
 drivers/net/usb/qmi_wwan.c                           |    2 
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c         |    2 
 drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c |    3 
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c      |    3 
 drivers/nvme/host/core.c                             |    9 +
 drivers/nvme/host/rdma.c                             |    1 
 drivers/parisc/ccio-dma.c                            |    3 
 drivers/parisc/sba_iommu.c                           |    3 
 drivers/tty/serial/8250/8250_gsc.c                   |    2 
 fs/btrfs/send.c                                      |    4 
 fs/ext4/extents.c                                    |   21 +-
 fs/nfs/dir.c                                         |    4 
 fs/nfs/inode.c                                       |    9 -
 fs/quota/dquot.c                                     |   11 +
 fs/super.c                                           |   19 +-
 include/linux/sched.h                                |    1 
 include/net/bond_3ad.h                               |    2 
 kernel/async.c                                       |    3 
 kernel/module.c                                      |   25 ---
 kernel/trace/trace.c                                 |    4 
 kernel/tsacct.c                                      |    7 
 lib/iov_iter.c                                       |    2 
 net/ax25/af_ax25.c                                   |    9 -
 net/core/drop_monitor.c                              |   11 +
 net/ipv4/ping.c                                      |   11 +
 net/ipv4/xfrm4_policy.c                              |    3 
 net/netfilter/nf_conntrack_proto_sctp.c              |    9 +
 net/sched/act_api.c                                  |   13 +
 net/vmw_vsock/af_vsock.c                             |    1 
 scripts/Makefile.extrawarn                           |    1 
 scripts/kconfig/preprocess.c                         |    2 
 sound/pci/hda/hda_intel.c                            |    5 
 sound/soc/soc-ops.c                                  |   29 ++--
 tools/lib/subcmd/subcmd-util.h                       |   11 -
 tools/testing/selftests/zram/zram.sh                 |   15 --
 tools/testing/selftests/zram/zram01.sh               |   33 +---
 tools/testing/selftests/zram/zram02.sh               |    1 
 tools/testing/selftests/zram/zram_lib.sh             |  134 ++++++++++++-------
 64 files changed, 527 insertions(+), 294 deletions(-)

Anders Roxell (1):
      powerpc/lib/sstep: fix 'ptesync' build error

Brenda Streiff (1):
      kconfig: let 'shell' return enough output for deep path names

Bryan O'Donoghue (1):
      mtd: rawnand: qcom: Fix clock sequencing in qcom_nandc_probe()

Christian Hewitt (1):
      arm64: dts: meson-gx: add ATF BL32 reserved-memory region

Christian Löhle (1):
      mmc: block: fix read single on recovery logic

Darrick J. Wong (2):
      vfs: make freeze_super abort when sync_filesystem returns error
      quota: make dquot_quota_sync return errors from ->sync_fs

Duoming Zhou (1):
      ax25: improve the incomplete fix to avoid UAF and NPD bugs

Dāvis Mosāns (1):
      btrfs: send: in case of IO error log it

Eliav Farber (1):
      EDAC: Fix calculation of returned address and next offset in edac_align_ptr()

Eric Dumazet (3):
      drop_monitor: fix data-race in dropmon_net_event / trace_napi_poll_hit
      bonding: fix data-races around agg_select_timer
      net: sched: limit TC_ACT_REPEAT loops

Eric W. Biederman (1):
      taskstats: Cleanup the use of task->exit_code

Florian Westphal (1):
      netfilter: conntrack: don't refresh sctp entries in closed state

Greg Kroah-Hartman (1):
      Linux 4.19.231

Guillaume Nault (1):
      xfrm: Don't accidentally set RTO_ONLINK in decode_session4()

Guo Ren (1):
      irqchip/sifive-plic: Add missing thead,c900-plic match string

Igor Pylypiv (1):
      Revert "module, async: async_synchronize_full() on module init iff async is used"

JaeSang Yoo (1):
      tracing: Fix tp_printk option related with tp_printk_stop_on_boot

Jann Horn (1):
      net: usb: ax88179_178a: Fix out-of-bounds accesses in RX fixup

Jiasheng Jiang (1):
      dmaengine: sh: rcar-dmac: Check for error num after setting mask

Jim Mattson (1):
      KVM: x86/pmu: Use AMD64_RAW_EVENT_MASK for PERF_TYPE_RAW

Johannes Berg (3):
      iwlwifi: fix use-after-free
      iwlwifi: pcie: fix locking when "HW not ready"
      iwlwifi: pcie: gen2: fix locking when "HW not ready"

John David Anglin (2):
      parisc: Fix data TLB miss in sba_unmap_sg
      parisc: Fix sglist access in ccio-dma.c

Kamal Dasu (1):
      mtd: rawnand: brcmnand: Refactored code to introduce helper functions

Kees Cook (1):
      libsubcmd: Fix use-after-free for realloc(..., 0)

Kimberly Brown (1):
      Drivers: hv: vmbus: Expose monitor data only when monitor pages are used

Laibin Qiu (1):
      block/wbt: fix negative inflight counter when remove scsi device

Mans Rullgard (1):
      net: dsa: lan9303: fix reset on probe

Marc St-Amand (1):
      net: macb: Align the dma and coherent dma masks

Mark Brown (2):
      ASoC: ops: Fix stereo change notifications in snd_soc_put_volsw()
      ASoC: ops: Fix stereo change notifications in snd_soc_put_volsw_range()

Max Kellermann (1):
      lib/iov_iter: initialize "flags" in new pipe_buffer

Miaoqian Lin (1):
      Drivers: hv: vmbus: Fix memory leak in vmbus_add_channel_kobj

Miquel Raynal (2):
      net: ieee802154: at86rf230: Stop leaking skb's
      net: ieee802154: ca8210: Fix lifs/sifs periods

Nathan Chancellor (1):
      Makefile.extrawarn: Move -Wunaligned-access to W=1

Nicholas Bishop (1):
      drm/radeon: Fix backlight control on iMac 12,1

Rafał Miłecki (1):
      i2c: brcmstb: fix support for DSL and CM variants

Randy Dunlap (1):
      serial: parisc: GSC: fix build when IOSAPIC is not set

Sagi Grimberg (2):
      nvme: fix a possible use-after-free in controller reset during load
      nvme-rdma: fix possible use-after-free in transport error_recovery work

Seth Forshee (1):
      vsock: remove vsock from connected table when connect is interrupted by a signal

Slark Xiao (1):
      net: usb: qmi_wwan: Add support for Dell DW5829e

Takashi Iwai (2):
      ALSA: hda: Fix regression on forced probe mask option
      ALSA: hda: Fix missing codec probe on Shenker Dock 15

Trond Myklebust (2):
      NFS: LOOKUP_DIRECTORY is also ok with symlinks
      NFS: Do not report writeback errors in nfs_getattr()

Wan Jiabing (1):
      ARM: OMAP2+: hwmod: Add of_node_put() before break

Xin Long (1):
      ping: fix the dif and sdif check in ping_lookup

Yang Xu (3):
      selftests/zram: Skip max_comp_streams interface on newer kernel
      selftests/zram01.sh: Fix compression ratio calculation
      selftests/zram: Adapt the situation that /dev/zram0 is being used

Zhang Yi (1):
      ext4: check for out-of-order index extents in ext4_valid_extent_entries()

Zoltán Böszörményi (1):
      ata: libata-core: Disable TRIM on M88V29

david regan (1):
      mtd: rawnand: brcmnand: Fixed incorrect sub-page ECC status

