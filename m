Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD29B4BDD16
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:43:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347057AbiBUJEK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:04:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348493AbiBUJCy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:02:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D88052C670;
        Mon, 21 Feb 2022 00:58:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9EA19B80EA1;
        Mon, 21 Feb 2022 08:58:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4D4CC340EB;
        Mon, 21 Feb 2022 08:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645433890;
        bh=9+L8yr8u8jfdhPOWJluuTOJu4AUUpL/Po627zfOv3OU=;
        h=From:To:Cc:Subject:Date:From;
        b=X65AJFQg7BpbJ5sdgCG4csH/EsKTfYP/iQGXojlsNUhrC91LNERoWvI8vErZFklwf
         HzIReXJLrGZ2W8/kTUliHFceo7wnBqCOStJTQkDi5W+89bcnilrgMvpoDXN3KtTfQI
         seO8fyyrwUZwXphyEyJQ76WDKXMBs2dmYZPXGUOs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.4 00/80] 5.4.181-rc1 review
Date:   Mon, 21 Feb 2022 09:48:40 +0100
Message-Id: <20220221084915.554151737@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.181-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.181-rc1
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

This is the start of the stable review cycle for the 5.4.181 release.
There are 80 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.181-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.181-rc1

Jing Leng <jleng@ambarella.com>
    kconfig: fix failing to generate auto.conf

Marc St-Amand <mstamand@ciena.com>
    net: macb: Align the dma and coherent dma masks

Slark Xiao <slark_xiao@163.com>
    net: usb: qmi_wwan: Add support for Dell DW5829e

JaeSang Yoo <js.yoo.5b@gmail.com>
    tracing: Fix tp_printk option related with tp_printk_stop_on_boot

Sascha Hauer <s.hauer@pengutronix.de>
    drm/rockchip: dw_hdmi: Do not leave clock enabled in error case

Zoltán Böszörményi <zboszor@gmail.com>
    ata: libata-core: Disable TRIM on M88V29

Brenda Streiff <brenda.streiff@ni.com>
    kconfig: let 'shell' return enough output for deep path names

Christian Hewitt <christianshewitt@gmail.com>
    arm64: dts: meson-g12: drop BL32 region from SEI510/SEI610

Christian Hewitt <christianshewitt@gmail.com>
    arm64: dts: meson-g12: add ATF BL32 reserved-memory region

Christian Hewitt <christianshewitt@gmail.com>
    arm64: dts: meson-gx: add ATF BL32 reserved-memory region

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: don't refresh sctp entries in closed state

Guo Ren <guoren@linux.alibaba.com>
    irqchip/sifive-plic: Add missing thead,c900-plic match string

Ye Guojin <ye.guojin@zte.com.cn>
    ARM: OMAP2+: adjust the location of put_device() call in omapdss_init_of

Wan Jiabing <wanjiabing@vivo.com>
    ARM: OMAP2+: hwmod: Add of_node_put() before break

Jim Mattson <jmattson@google.com>
    KVM: x86/pmu: Use AMD64_RAW_EVENT_MASK for PERF_TYPE_RAW

Miaoqian Lin <linmq006@gmail.com>
    Drivers: hv: vmbus: Fix memory leak in vmbus_add_channel_kobj

Rafał Miłecki <rafal@milecki.pl>
    i2c: brcmstb: fix support for DSL and CM variants

Waiman Long <longman@redhat.com>
    copy_process(): Move fd_install() out of sighand->siglock critical section

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    dmaengine: sh: rcar-dmac: Check for error num after setting mask

Eric Dumazet <edumazet@google.com>
    net: sched: limit TC_ACT_REPEAT loops

Eliav Farber <farbere@amazon.com>
    EDAC: Fix calculation of returned address and next offset in edac_align_ptr()

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix pt2pt NVMe PRLI reject LOGO loop

david regan <dregan@mail.com>
    mtd: rawnand: brcmnand: Fixed incorrect sub-page ECC status

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    mtd: rawnand: qcom: Fix clock sequencing in qcom_nandc_probe()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Do not report writeback errors in nfs_getattr()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: LOOKUP_DIRECTORY is also ok with symlinks

Laibin Qiu <qiulaibin@huawei.com>
    block/wbt: fix negative inflight counter when remove scsi device

Jens Wiklander <jens.wiklander@linaro.org>
    optee: use driver internal tee_context for some rpc

Jens Wiklander <jens.wiklander@linaro.org>
    tee: export teedev_open() and teedev_close_context()

Christian Eggers <ceggers@arri.de>
    mtd: rawnand: gpmi: don't leak PM reference in error path

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

Zhang Changzhong <zhangchangzhong@huawei.com>
    bonding: force carrier update when releasing slave

Xin Long <lucien.xin@gmail.com>
    ping: fix the dif and sdif check in ping_lookup

Miquel Raynal <miquel.raynal@bootlin.com>
    net: ieee802154: ca8210: Fix lifs/sifs periods

Mans Rullgard <mans@mansr.com>
    net: dsa: lan9303: fix reset on probe

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_synproxy: unregister hooks on init error path

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: pcie: gen2: fix locking when "HW not ready"

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: pcie: fix locking when "HW not ready"

Christian Löhle <CLoehle@hyperstone.com>
    mmc: block: fix read single on recovery logic

Seth Forshee <sforshee@digitalocean.com>
    vsock: remove vsock from connected table when connect is interrupted by a signal

Tudor Ambarus <tudor.ambarus@microchip.com>
    dmaengine: at_xdmac: Start transfer for cyclic channels in issue_pending

Eric W. Biederman <ebiederm@xmission.com>
    taskstats: Cleanup the use of task->exit_code

Zhang Yi <yi.zhang@huawei.com>
    ext4: prevent partial update of the extent blocks

Zhang Yi <yi.zhang@huawei.com>
    ext4: check for inconsistent extents between index and leaf block

Zhang Yi <yi.zhang@huawei.com>
    ext4: check for out-of-order index extents in ext4_valid_extent_entries()

Nicholas Bishop <nicholasbishop@google.com>
    drm/radeon: Fix backlight control on iMac 12,1

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: fix use-after-free

Mark Rutland <mark.rutland@arm.com>
    arm64: module/ftrace: intialize PLT at load time

Mark Rutland <mark.rutland@arm.com>
    arm64: module: rework special section handling

Mark Rutland <mark.rutland@arm.com>
    module/ftrace: handle patchable-function-entry

Mark Rutland <mark.rutland@arm.com>
    ftrace: add ftrace_init_nop()

Igor Pylypiv <ipylypiv@google.com>
    Revert "module, async: async_synchronize_full() on module init iff async is used"

Christian König <christian.koenig@amd.com>
    drm/amdgpu: fix logic inversion in check

Sagi Grimberg <sagi@grimberg.me>
    nvme-rdma: fix possible use-after-free in transport error_recovery work

Sagi Grimberg <sagi@grimberg.me>
    nvme-tcp: fix possible use-after-free in transport error_recovery work

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

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    selftests: rtc: Increase test timeout so that all tests run

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    platform/x86: ISST: Fix possible circular locking dependency detected

Dāvis Mosāns <davispuh@gmail.com>
    btrfs: send: in case of IO error log it

John David Anglin <dave.anglin@bell.net>
    parisc: Fix sglist access in ccio-dma.c

John David Anglin <dave.anglin@bell.net>
    parisc: Fix data TLB miss in sba_unmap_sg

John David Anglin <dave.anglin@bell.net>
    parisc: Drop __init from map_pages declaration

Randy Dunlap <rdunlap@infradead.org>
    serial: parisc: GSC: fix build when IOSAPIC is not set

Sean Christopherson <seanjc@google.com>
    Revert "svm: Add warning message for AVIC IPI invalid target"

Sergio Costas <rastersoft@gmail.com>
    HID:Add support for UGTABLET WP5540

Nathan Chancellor <nathan@kernel.org>
    Makefile.extrawarn: Move -Wunaligned-access to W=1


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/mach-omap2/display.c                      |   2 +-
 arch/arm/mach-omap2/omap_hwmod.c                   |   4 +-
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi  |   6 +
 arch/arm64/boot/dts/amlogic/meson-g12a-sei510.dts  |   8 --
 arch/arm64/boot/dts/amlogic/meson-gx.dtsi          |   6 +
 arch/arm64/boot/dts/amlogic/meson-sm1-sei610.dts   |   8 --
 arch/arm64/kernel/ftrace.c                         |  55 +++------
 arch/arm64/kernel/module.c                         |  47 ++++++--
 arch/parisc/Makefile                               |   1 -
 arch/parisc/kernel/module.c                        |  10 +-
 arch/parisc/kernel/module.lds                      |   7 --
 arch/parisc/mm/init.c                              |   9 +-
 arch/powerpc/lib/sstep.c                           |   2 +
 arch/x86/kvm/pmu.c                                 |   2 +-
 arch/x86/kvm/svm.c                                 |   2 -
 block/bfq-iosched.c                                |   2 +
 block/elevator.c                                   |   2 -
 drivers/ata/libata-core.c                          |   1 +
 drivers/dma/at_xdmac.c                             |   6 +-
 drivers/dma/sh/rcar-dmac.c                         |   4 +-
 drivers/edac/edac_mc.c                             |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |   2 +-
 drivers/gpu/drm/radeon/atombios_encoders.c         |   3 +-
 drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c        |  14 +--
 drivers/hid/hid-ids.h                              |   1 +
 drivers/hid/hid-quirks.c                           |   1 +
 drivers/hv/vmbus_drv.c                             |   5 +-
 drivers/i2c/busses/i2c-brcmstb.c                   |   2 +-
 drivers/irqchip/irq-sifive-plic.c                  |   1 +
 drivers/mmc/core/block.c                           |  28 ++---
 drivers/mtd/nand/raw/brcmnand/brcmnand.c           |   2 +-
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c         |   3 +-
 drivers/mtd/nand/raw/qcom_nandc.c                  |  14 +--
 drivers/net/bonding/bond_3ad.c                     |  30 ++++-
 drivers/net/bonding/bond_main.c                    |   5 +-
 drivers/net/dsa/lan9303-core.c                     |   2 +-
 drivers/net/ethernet/cadence/macb_main.c           |   2 +-
 drivers/net/ieee802154/at86rf230.c                 |  13 +-
 drivers/net/ieee802154/ca8210.c                    |   4 +-
 drivers/net/usb/qmi_wwan.c                         |   2 +
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |   2 +
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   |   3 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |   3 +-
 drivers/nvme/host/core.c                           |   9 +-
 drivers/nvme/host/rdma.c                           |   1 +
 drivers/nvme/host/tcp.c                            |   1 +
 drivers/parisc/ccio-dma.c                          |   3 +-
 drivers/parisc/sba_iommu.c                         |   3 +-
 .../x86/intel_speed_select_if/isst_if_common.c     |  97 +++++++++------
 drivers/scsi/lpfc/lpfc.h                           |   1 +
 drivers/scsi/lpfc/lpfc_attr.c                      |   3 +
 drivers/scsi/lpfc/lpfc_els.c                       |  20 ++-
 drivers/scsi/lpfc/lpfc_nportdisc.c                 |   5 +-
 drivers/tee/optee/core.c                           |   8 ++
 drivers/tee/optee/optee_private.h                  |   2 +
 drivers/tee/optee/rpc.c                            |   8 +-
 drivers/tee/tee_core.c                             |   6 +-
 drivers/tty/serial/8250/8250_gsc.c                 |   2 +-
 fs/btrfs/send.c                                    |   4 +
 fs/ext4/extents.c                                  |  92 +++++++++-----
 fs/nfs/dir.c                                       |   4 +-
 fs/nfs/inode.c                                     |   9 +-
 fs/quota/dquot.c                                   |  11 +-
 fs/super.c                                         |  19 +--
 include/asm-generic/vmlinux.lds.h                  |  14 +--
 include/linux/ftrace.h                             |  40 +++++-
 include/linux/sched.h                              |   1 -
 include/linux/tee_drv.h                            |  14 +++
 include/net/bond_3ad.h                             |   2 +-
 kernel/async.c                                     |   3 -
 kernel/fork.c                                      |   7 +-
 kernel/module.c                                    |  27 +----
 kernel/trace/ftrace.c                              |   6 +-
 kernel/trace/trace.c                               |   4 +
 kernel/tsacct.c                                    |   7 +-
 net/ax25/af_ax25.c                                 |   9 +-
 net/core/drop_monitor.c                            |  11 +-
 net/ipv4/ping.c                                    |  11 +-
 net/netfilter/nf_conntrack_proto_sctp.c            |   9 ++
 net/netfilter/nft_synproxy.c                       |   4 +-
 net/sched/act_api.c                                |  13 +-
 net/vmw_vsock/af_vsock.c                           |   1 +
 scripts/Makefile.extrawarn                         |   1 +
 scripts/kconfig/confdata.c                         |  13 +-
 scripts/kconfig/preprocess.c                       |   2 +-
 sound/pci/hda/hda_intel.c                          |   5 +-
 sound/soc/soc-ops.c                                |  29 +++--
 tools/lib/subcmd/subcmd-util.h                     |  11 +-
 tools/testing/selftests/rtc/settings               |   2 +-
 tools/testing/selftests/zram/zram.sh               |  15 +--
 tools/testing/selftests/zram/zram01.sh             |  33 ++---
 tools/testing/selftests/zram/zram02.sh             |   1 -
 tools/testing/selftests/zram/zram_lib.sh           | 134 ++++++++++++++-------
 94 files changed, 659 insertions(+), 410 deletions(-)


