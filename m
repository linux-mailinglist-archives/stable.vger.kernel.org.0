Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBF34BDE38
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346882AbiBUJDb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:03:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347051AbiBUJAq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:00:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB3C24BD8;
        Mon, 21 Feb 2022 00:55:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B83936112B;
        Mon, 21 Feb 2022 08:55:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A5D7C340E9;
        Mon, 21 Feb 2022 08:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645433738;
        bh=gcyM2tq2YlaRo+IQJGq0P+hBhMp9mYSvqWTu5Lskozg=;
        h=From:To:Cc:Subject:Date:From;
        b=InpbQmMVCJeRxFPdGOT9wXz/rFcKMuwQU2O2jU9Rh5ZH5zY9s+v0MHjCNOZ2/MGEb
         gHBDMaQk4jRNXIoQj6VV53hSW6tzEX4MMk5698xxoEh5p2A2zc0E8gqT7CCOngEpE4
         yXylZv0lTU8PojIu0YXrXN1rjEU5Fb/bcy4gSXXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 4.19 00/58] 4.19.231-rc1 review
Date:   Mon, 21 Feb 2022 09:48:53 +0100
Message-Id: <20220221084911.895146879@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.231-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.231-rc1
X-KernelTest-Deadline: 2022-02-23T08:49+00:00
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

This is the start of the stable review cycle for the 4.19.231 release.
There are 58 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.231-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.231-rc1

Marc St-Amand <mstamand@ciena.com>
    net: macb: Align the dma and coherent dma masks

Slark Xiao <slark_xiao@163.com>
    net: usb: qmi_wwan: Add support for Dell DW5829e

JaeSang Yoo <js.yoo.5b@gmail.com>
    tracing: Fix tp_printk option related with tp_printk_stop_on_boot

Zoltán Böszörményi <zboszor@gmail.com>
    ata: libata-core: Disable TRIM on M88V29

Brenda Streiff <brenda.streiff@ni.com>
    kconfig: let 'shell' return enough output for deep path names

Christian Hewitt <christianshewitt@gmail.com>
    arm64: dts: meson-gx: add ATF BL32 reserved-memory region

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: don't refresh sctp entries in closed state

Guo Ren <guoren@linux.alibaba.com>
    irqchip/sifive-plic: Add missing thead,c900-plic match string

Wan Jiabing <wanjiabing@vivo.com>
    ARM: OMAP2+: hwmod: Add of_node_put() before break

Jim Mattson <jmattson@google.com>
    KVM: x86/pmu: Use AMD64_RAW_EVENT_MASK for PERF_TYPE_RAW

Miaoqian Lin <linmq006@gmail.com>
    Drivers: hv: vmbus: Fix memory leak in vmbus_add_channel_kobj

Kimberly Brown <kimbrownkd@gmail.com>
    Drivers: hv: vmbus: Expose monitor data only when monitor pages are used

david regan <dregan@mail.com>
    mtd: rawnand: brcmnand: Fixed incorrect sub-page ECC status

Kamal Dasu <kdasu.kdev@gmail.com>
    mtd: rawnand: brcmnand: Refactored code to introduce helper functions

Rafał Miłecki <rafal@milecki.pl>
    i2c: brcmstb: fix support for DSL and CM variants

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    dmaengine: sh: rcar-dmac: Check for error num after setting mask

Eric Dumazet <edumazet@google.com>
    net: sched: limit TC_ACT_REPEAT loops

Eliav Farber <farbere@amazon.com>
    EDAC: Fix calculation of returned address and next offset in edac_align_ptr()

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    mtd: rawnand: qcom: Fix clock sequencing in qcom_nandc_probe()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Do not report writeback errors in nfs_getattr()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: LOOKUP_DIRECTORY is also ok with symlinks

Laibin Qiu <qiulaibin@huawei.com>
    block/wbt: fix negative inflight counter when remove scsi device

Zhang Yi <yi.zhang@huawei.com>
    ext4: check for out-of-order index extents in ext4_valid_extent_entries()

Anders Roxell <anders.roxell@linaro.org>
    powerpc/lib/sstep: fix 'ptesync' build error

Mark Brown <broonie@kernel.org>
    ASoC: ops: Fix stereo change notifications in snd_soc_put_volsw_range()

Mark Brown <broonie@kernel.org>
    ASoC: ops: Fix stereo change notifications in snd_soc_put_volsw()

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Fix missing codec probe on Shenker Dock 15

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Fix regression on forced probe mask option

Kees Cook <keescook@chromium.org>
    libsubcmd: Fix use-after-free for realloc(..., 0)

Eric Dumazet <edumazet@google.com>
    bonding: fix data-races around agg_select_timer

Eric Dumazet <edumazet@google.com>
    drop_monitor: fix data-race in dropmon_net_event / trace_napi_poll_hit

Xin Long <lucien.xin@gmail.com>
    ping: fix the dif and sdif check in ping_lookup

Miquel Raynal <miquel.raynal@bootlin.com>
    net: ieee802154: ca8210: Fix lifs/sifs periods

Mans Rullgard <mans@mansr.com>
    net: dsa: lan9303: fix reset on probe

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: pcie: gen2: fix locking when "HW not ready"

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: pcie: fix locking when "HW not ready"

Seth Forshee <sforshee@digitalocean.com>
    vsock: remove vsock from connected table when connect is interrupted by a signal

Christian Löhle <CLoehle@hyperstone.com>
    mmc: block: fix read single on recovery logic

Eric W. Biederman <ebiederm@xmission.com>
    taskstats: Cleanup the use of task->exit_code

Guillaume Nault <gnault@redhat.com>
    xfrm: Don't accidentally set RTO_ONLINK in decode_session4()

Nicholas Bishop <nicholasbishop@google.com>
    drm/radeon: Fix backlight control on iMac 12,1

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: fix use-after-free

Igor Pylypiv <ipylypiv@google.com>
    Revert "module, async: async_synchronize_full() on module init iff async is used"

Sagi Grimberg <sagi@grimberg.me>
    nvme-rdma: fix possible use-after-free in transport error_recovery work

Sagi Grimberg <sagi@grimberg.me>
    nvme: fix a possible use-after-free in controller reset during load

Darrick J. Wong <djwong@kernel.org>
    quota: make dquot_quota_sync return errors from ->sync_fs

Darrick J. Wong <djwong@kernel.org>
    vfs: make freeze_super abort when sync_filesystem returns error

Duoming Zhou <duoming@zju.edu.cn>
    ax25: improve the incomplete fix to avoid UAF and NPD bugs

Yang Xu <xuyang2018.jy@fujitsu.com>
    selftests/zram: Adapt the situation that /dev/zram0 is being used

Yang Xu <xuyang2018.jy@fujitsu.com>
    selftests/zram01.sh: Fix compression ratio calculation

Yang Xu <xuyang2018.jy@fujitsu.com>
    selftests/zram: Skip max_comp_streams interface on newer kernel

Miquel Raynal <miquel.raynal@bootlin.com>
    net: ieee802154: at86rf230: Stop leaking skb's

Dāvis Mosāns <davispuh@gmail.com>
    btrfs: send: in case of IO error log it

John David Anglin <dave.anglin@bell.net>
    parisc: Fix sglist access in ccio-dma.c

John David Anglin <dave.anglin@bell.net>
    parisc: Fix data TLB miss in sba_unmap_sg

Randy Dunlap <rdunlap@infradead.org>
    serial: parisc: GSC: fix build when IOSAPIC is not set

Jann Horn <jannh@google.com>
    net: usb: ax88179_178a: Fix out-of-bounds accesses in RX fixup

Nathan Chancellor <nathan@kernel.org>
    Makefile.extrawarn: Move -Wunaligned-access to W=1


-------------

Diffstat:

 Documentation/ABI/stable/sysfs-bus-vmbus           |  12 +-
 Makefile                                           |   4 +-
 arch/arm/mach-omap2/omap_hwmod.c                   |   4 +-
 arch/arm64/boot/dts/amlogic/meson-gx.dtsi          |   6 +
 arch/powerpc/lib/sstep.c                           |   2 +
 arch/x86/kvm/pmu.c                                 |   2 +-
 block/bfq-iosched.c                                |   2 +
 block/elevator.c                                   |   2 -
 drivers/ata/libata-core.c                          |   1 +
 drivers/dma/sh/rcar-dmac.c                         |   4 +-
 drivers/edac/edac_mc.c                             |   2 +-
 drivers/gpu/drm/radeon/atombios_encoders.c         |   3 +-
 drivers/hv/channel_mgmt.c                          |   1 +
 drivers/hv/hyperv_vmbus.h                          |   2 +
 drivers/hv/vmbus_drv.c                             |  82 ++++++++++++-
 drivers/i2c/busses/i2c-brcmstb.c                   |   2 +-
 drivers/irqchip/irq-sifive-plic.c                  |   1 +
 drivers/mmc/core/block.c                           |  28 ++---
 drivers/mtd/nand/raw/brcmnand/brcmnand.c           | 102 ++++++++++------
 drivers/mtd/nand/raw/qcom_nandc.c                  |  14 +--
 drivers/net/bonding/bond_3ad.c                     |  30 ++++-
 drivers/net/dsa/lan9303-core.c                     |   2 +-
 drivers/net/ethernet/cadence/macb_main.c           |   2 +-
 drivers/net/ieee802154/at86rf230.c                 |  13 +-
 drivers/net/ieee802154/ca8210.c                    |   4 +-
 drivers/net/usb/ax88179_178a.c                     |  68 ++++++-----
 drivers/net/usb/qmi_wwan.c                         |   2 +
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |   2 +
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   |   3 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |   3 +-
 drivers/nvme/host/core.c                           |   9 +-
 drivers/nvme/host/rdma.c                           |   1 +
 drivers/parisc/ccio-dma.c                          |   3 +-
 drivers/parisc/sba_iommu.c                         |   3 +-
 drivers/tty/serial/8250/8250_gsc.c                 |   2 +-
 fs/btrfs/send.c                                    |   4 +
 fs/ext4/extents.c                                  |  21 ++--
 fs/nfs/dir.c                                       |   4 +-
 fs/nfs/inode.c                                     |   9 +-
 fs/quota/dquot.c                                   |  11 +-
 fs/super.c                                         |  19 +--
 include/linux/sched.h                              |   1 -
 include/net/bond_3ad.h                             |   2 +-
 kernel/async.c                                     |   3 -
 kernel/module.c                                    |  25 +---
 kernel/trace/trace.c                               |   4 +
 kernel/tsacct.c                                    |   7 +-
 net/ax25/af_ax25.c                                 |   9 +-
 net/core/drop_monitor.c                            |  11 +-
 net/ipv4/ping.c                                    |  11 +-
 net/ipv4/xfrm4_policy.c                            |   3 +-
 net/netfilter/nf_conntrack_proto_sctp.c            |   9 ++
 net/sched/act_api.c                                |  13 +-
 net/vmw_vsock/af_vsock.c                           |   1 +
 scripts/Makefile.extrawarn                         |   1 +
 scripts/kconfig/preprocess.c                       |   2 +-
 sound/pci/hda/hda_intel.c                          |   5 +-
 sound/soc/soc-ops.c                                |  29 +++--
 tools/lib/subcmd/subcmd-util.h                     |  11 +-
 tools/testing/selftests/zram/zram.sh               |  15 +--
 tools/testing/selftests/zram/zram01.sh             |  33 ++---
 tools/testing/selftests/zram/zram02.sh             |   1 -
 tools/testing/selftests/zram/zram_lib.sh           | 134 ++++++++++++++-------
 63 files changed, 526 insertions(+), 295 deletions(-)


