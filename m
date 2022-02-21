Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 584C94BE8E6
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235574AbiBUJjd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:39:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352121AbiBUJiE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:38:04 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56ABA1D0F4;
        Mon, 21 Feb 2022 01:16:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EA175CE0E80;
        Mon, 21 Feb 2022 09:16:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D88C340E9;
        Mon, 21 Feb 2022 09:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435010;
        bh=fDazzbPmQwu+IAQJhVw9ofwvsWVTLTZBmHK9clikjNw=;
        h=From:To:Cc:Subject:Date:From;
        b=2bzz8MVR54oqNnZxuYWNdFka4snbtTKtsuVgKXIxgFfz/xUxs9NkVZVSb6/T8u4rr
         L+CttgY0NSdUO/c1TkDUp8/kXtjVkdxJh3OzhISYjTWktpwGML2UwhAYkjyB0c1WqU
         EVAPt8AYmaHYRovv3BysB3c+7YlvvYhhtqVSxcB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.16 000/227] 5.16.11-rc1 review
Date:   Mon, 21 Feb 2022 09:46:59 +0100
Message-Id: <20220221084934.836145070@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.11-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.16.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.16.11-rc1
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

This is the start of the stable review cycle for the 5.16.11 release.
There are 227 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.11-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.16.11-rc1

Jing Leng <jleng@ambarella.com>
    kconfig: fix failing to generate auto.conf

Marc St-Amand <mstamand@ciena.com>
    net: macb: Align the dma and coherent dma masks

Slark Xiao <slark_xiao@163.com>
    net: usb: qmi_wwan: Add support for Dell DW5829e

Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
    drm/amd/display: fix yellow carp wm clamping

Roman Li <Roman.Li@amd.com>
    drm/amd/display: Cap pflip irqs per max otg number

Aaron Liu <aaron.liu@amd.com>
    drm/amdgpu: add utcl2_harvest to gc 10.3.1

Mario Limonciello <mario.limonciello@amd.com>
    display/amd: decrease message verbosity about watermarks table failure

JaeSang Yoo <js.yoo.5b@gmail.com>
    tracing: Fix tp_printk option related with tp_printk_stop_on_boot

Sascha Hauer <s.hauer@pengutronix.de>
    drm/rockchip: dw_hdmi: Do not leave clock enabled in error case

Dan Aloni <dan.aloni@vastdata.com>
    xprtrdma: fix pointer derefs in error cases of rpcrdma_ep_create

Jae Hyun Yoo <jae.hyun.yoo@linux.intel.com>
    soc: aspeed: lpc-ctrl: Block error printing on probe defer cases

Zoltán Böszörményi <zboszor@gmail.com>
    ata: libata-core: Disable TRIM on M88V29

Brenda Streiff <brenda.streiff@ni.com>
    kconfig: let 'shell' return enough output for deep path names

Mario Limonciello <mario.limonciello@amd.com>
    ACPI: PM: Revert "Only mark EC GPE for wakeup on Intel systems"

Shakeel Butt <shakeelb@google.com>
    mm: io_uring: allow oom-killer from io_uring_setup

Axel Rasmussen <axelrasmussen@google.com>
    selftests: fixup build warnings in pidfd / clone3 tests

Axel Rasmussen <axelrasmussen@google.com>
    pidfd: fix test failure due to stack overflow on some arches

Christian Hewitt <christianshewitt@gmail.com>
    arm64: dts: meson-g12: drop BL32 region from SEI510/SEI610

Christian Hewitt <christianshewitt@gmail.com>
    arm64: dts: meson-g12: add ATF BL32 reserved-memory region

Christian Hewitt <christianshewitt@gmail.com>
    arm64: dts: meson-gx: add ATF BL32 reserved-memory region

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: don't align last entry offset in smb2 query directory

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix same UniqueId for dot and dotdot entries

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: don't refresh sctp entries in closed state

Nick Desaulniers <ndesaulniers@google.com>
    x86/bug: Merge annotate_reachable() into _BUG_FLAGS() asm

Guo Ren <guoren@kernel.org>
    irqchip/sifive-plic: Add missing thead,c900-plic match string

Wan Jiabing <wanjiabing@vivo.com>
    phy: phy-mtk-tphy: Fix duplicated argument in phy-mtk-tphy

Padmanabha Srinivasaiah <treasure4paddy@gmail.com>
    staging: vc04_services: Fix RCU dereference check

Al Cooper <alcooperx@gmail.com>
    phy: usb: Leave some clocks running during suspend

Ye Guojin <ye.guojin@zte.com.cn>
    ARM: OMAP2+: adjust the location of put_device() call in omapdss_init_of

Wan Jiabing <wanjiabing@vivo.com>
    ARM: OMAP2+: hwmod: Add of_node_put() before break

Jim Mattson <jmattson@google.com>
    KVM: x86/pmu: Use AMD64_RAW_EVENT_MASK for PERF_TYPE_RAW

Jim Mattson <jmattson@google.com>
    KVM: x86/pmu: Don't truncate the PerfEvtSeln MSR when creating a perf event

Like Xu <likexu@tencent.com>
    KVM: x86/pmu: Refactoring find_arch_event() to pmc_perf_hw_id()

Miaoqian Lin <linmq006@gmail.com>
    Drivers: hv: vmbus: Fix memory leak in vmbus_add_channel_kobj

Miaoqian Lin <linmq006@gmail.com>
    mtd: rawnand: ingenic: Fix missing put_device in ingenic_ecc_get

Dongliang Mu <mudongliangabcd@gmail.com>
    HID: elo: fix memory leak in elo_probe

Cheng Jui Wang <cheng-jui.wang@mediatek.com>
    lockdep: Correct lock_classes index mapping

Rafał Miłecki <rafal@milecki.pl>
    i2c: brcmstb: fix support for DSL and CM variants

Jesse Brandeburg <jesse.brandeburg@intel.com>
    ice: enable parsing IPSEC SPI headers for RSS

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: wm_adsp: Correct control read size when parsing compressed buffer

Mike Christie <michael.christie@oracle.com>
    scsi: qedi: Fix ABBA deadlock in qedi_process_tmf_resp() and qedi_process_cmd_cleanup_resp()

Waiman Long <longman@redhat.com>
    copy_process(): Move fd_install() out of sighand->siglock critical section

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    dmaengine: ptdma: Fix the error handling path in pt_core_init()

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    i2c: qcom-cci: don't put a device tree node before i2c_add_adapter()

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    i2c: qcom-cci: don't delete an unregistered adapter

Christian Brauner <brauner@kernel.org>
    tests: fix idmapped mount_setattr test

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    dmaengine: sh: rcar-dmac: Check for error num after dma_set_max_seg_size

Miaoqian Lin <linmq006@gmail.com>
    dmaengine: stm32-dmamux: Fix PM disable depth imbalance in stm32_dmamux_probe

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    dmaengine: sh: rcar-dmac: Check for error num after setting mask

Eric Dumazet <edumazet@google.com>
    net: sched: limit TC_ACT_REPEAT loops

Eric W. Biederman <ebiederm@xmission.com>
    ucounts: Move RLIMIT_NPROC handling after set_user

Eric W. Biederman <ebiederm@xmission.com>
    rlimit: Fix RLIMIT_NPROC enforcement failure caused by capability calls in set_user

Eric W. Biederman <ebiederm@xmission.com>
    ucounts: Enforce RLIMIT_NPROC not RLIMIT_NPROC+1

Eric W. Biederman <ebiederm@xmission.com>
    ucounts: Handle wrapping in is_ucounts_overlimit

Eric W. Biederman <ebiederm@xmission.com>
    ucounts: Base set_cred_ucounts changes on the real user

Andy Lutomirski <luto@kernel.org>
    x86/ptrace: Fix xfpregs_set()'s incorrect xmm clearing

Eliav Farber <farbere@amazon.com>
    EDAC: Fix calculation of returned address and next offset in edac_align_ptr()

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix pt2pt NVMe PRLI reject LOGO loop

david regan <dregan@mail.com>
    mtd: rawnand: brcmnand: Fixed incorrect sub-page ECC status

Dan Carpenter <dan.carpenter@oracle.com>
    mtd: phram: Prevent divide by zero bug in phram_setup()

Ansuel Smith <ansuelsmth@gmail.com>
    mtd: parsers: qcom: Fix missing free for pparts in cleanup

Ansuel Smith <ansuelsmth@gmail.com>
    mtd: parsers: qcom: Fix kernel panic on skipped partition

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    mtd: rawnand: qcom: Fix clock sequencing in qcom_nandc_probe()

Christoph Hellwig <hch@lst.de>
    block: fix surprise removal for drivers calling blk_set_queue_dying

Linus Torvalds <torvalds@linux-foundation.org>
    tty: n_tty: do not look ahead for EOL character past the end of the buffer

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Do not report writeback errors in nfs_getattr()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: LOOKUP_DIRECTORY is also ok with symlinks

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Remove an incorrect revalidation in nfs4_update_changeattr_locked()

Laibin Qiu <qiulaibin@huawei.com>
    block/wbt: fix negative inflight counter when remove scsi device

Stephen Boyd <swboyd@chromium.org>
    ASoC: qcom: Actually clear DMA interrupt register for HDMI

Martin Povišer <povik+lin@cutebit.org>
    ASoC: tas2770: Insert post reset delay

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: Fix a deadlock in the error handler

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: Remove dead code

Jon Maloy <jmaloy@redhat.com>
    tipc: fix wrong notification node addresses

Steve French <stfrench@microsoft.com>
    smb3: fix snapshot mount option

Christian Eggers <ceggers@arri.de>
    mtd: rawnand: gpmi: don't leak PM reference in error path

Anders Roxell <anders.roxell@linaro.org>
    powerpc/lib/sstep: fix 'ptesync' build error

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/603: Fix boot failure with DEBUG_PAGEALLOC and KFENCE

Woody Suwalski <wsuwalski@gmail.com>
    ACPI: processor: idle: fix lockup regression on 32-bit ThinkPad T40

Steve French <stfrench@microsoft.com>
    cifs: fix confusing unneeded warning message on smb2.1 and earlier

Amir Goldstein <amir73il@gmail.com>
    cifs: fix set of group SID via NTSD xattrs

Mark Brown <broonie@kernel.org>
    ASoC: ops: Fix stereo change notifications in snd_soc_put_xr_sx()

Mark Brown <broonie@kernel.org>
    ASoC: ops: Fix stereo change notifications in snd_soc_put_volsw_sx()

Mark Brown <broonie@kernel.org>
    ASoC: ops: Fix stereo change notifications in snd_soc_put_volsw_range()

Mark Brown <broonie@kernel.org>
    ASoC: ops: Fix stereo change notifications in snd_soc_put_volsw()

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Fix missing codec probe on Shenker Dock 15

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Fix regression on forced probe mask option

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Fix deadlock by COEF mutex

Yu Huang <diwang90@gmail.com>
    ALSA: hda/realtek: Add quirk for Legion Y9000X 2019

Takashi Iwai <tiwai@suse.de>
    ALSA: memalloc: invalidate SG pages before sync

Takashi Iwai <tiwai@suse.de>
    ALSA: memalloc: Fix dma_need_sync() checks

Matteo Martelli <matteomartelli3@gmail.com>
    ALSA: usb-audio: revert to IMPLICIT_FB_FIXED_DEV for M-Audio FastTrack Ultra

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Don't abort resume upon errors

Joakim Tjernlund <joakim.tjernlund@infinera.com>
    arm64: Correct wrong label in macro __init_el2_gicv3

Muhammad Usama Anjum <usama.anjum@collabora.com>
    selftests/exec: Add non-regular to TEST_GEN_PROGS

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf bpf: Defer freeing string after possible strlen() on it

Oleksandr Mazur <oleksandr.mazur@plvision.eu>
    net: bridge: multicast: notify switchdev driver whenever MC processing gets disabled

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: fix use-after-free in ocelot_vlan_del()

Radu Bulie <radu-andrei.bulie@nxp.com>
    dpaa2-eth: Initialize mutex used in one step timestamping path

Tom Rix <trix@redhat.com>
    dpaa2-switch: fix default return of dpaa2_switch_flower_parse_mirror_key

Jon Maloy <jmaloy@redhat.com>
    tipc: fix wrong publisher node address in link publications

Gatis Peisenieks <gatis@mikrotik.com>
    atl1c: fix tx timeout after link flap on Mikrotik 10/25G NIC

DENG Qingfang <dqfext@gmail.com>
    net: phy: mediatek: remove PHY mode check on MT7531

Wen Gu <guwen@linux.alibaba.com>
    net/smc: Avoid overwriting the copies of clcsock callback functions

Kees Cook <keescook@chromium.org>
    libsubcmd: Fix use-after-free for realloc(..., 0)

Danie du Toit <danie.dutoit@corigine.com>
    nfp: flower: netdev offload check for ip6gretap

Eric Dumazet <edumazet@google.com>
    bonding: fix data-races around agg_select_timer

Eric Dumazet <edumazet@google.com>
    crypto: af_alg - get rid of alg_memory_allocated

Eric Dumazet <edumazet@google.com>
    net_sched: add __rcu annotation to netdev->qdisc

Eric Dumazet <edumazet@google.com>
    drop_monitor: fix data-race in dropmon_net_event / trace_napi_poll_hit

Tom Rix <trix@redhat.com>
    mctp: fix use after free

Zhang Changzhong <zhangchangzhong@huawei.com>
    bonding: force carrier update when releasing slave

Xin Long <lucien.xin@gmail.com>
    ping: fix the dif and sdif check in ping_lookup

Miquel Raynal <miquel.raynal@bootlin.com>
    net: ieee802154: ca8210: Fix lifs/sifs periods

Mans Rullgard <mans@mansr.com>
    net: dsa: lan9303: add VLAN IDs to master device

Mans Rullgard <mans@mansr.com>
    net: dsa: lan9303: handle hwaccel VLAN tags

Alexey Khoroshilov <khoroshilov@ispras.ru>
    net: dsa: lantiq_gswip: fix use after free in gswip_remove()

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: mv88e6xxx: flush switchdev FDB workqueue before removing VLAN

Mans Rullgard <mans@mansr.com>
    net: dsa: lan9303: fix reset on probe

Johannes Berg <johannes.berg@intel.com>
    cfg80211: fix race in netlink owner interface destruction

Phil Elwell <phil@raspberrypi.com>
    brcmfmac: firmware: Fix crash in brcm_alt_fw_path

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    mac80211: mlme: check for null after calling kmemdup

Jonas Gorski <jonas.gorski@gmail.com>
    Revert "net: ethernet: bgmac: Use devm_platform_ioremap_resource_byname"

Willem de Bruijn <willemb@google.com>
    ipv6: per-netns exclusive flowlabel checks

Ignat Korchagin <ignat@cloudflare.com>
    ipv6: mcast: use rcu-safe version of ipv6_get_lladdr()

Eric Dumazet <edumazet@google.com>
    ipv6: fix data-race in fib6_info_hw_flags_set / fib6_purge_rt

Eric Dumazet <edumazet@google.com>
    ipv4: fix data races in fib_alias_hw_flags_set

Hangbin Liu <liuhangbin@gmail.com>
    selftests: netfilter: disable rp_filter on router

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_synproxy: unregister hooks on init error path

Hangbin Liu <liuhangbin@gmail.com>
    selftests: netfilter: fix exit value for nft_concat_range

Eric Dumazet <edumazet@google.com>
    netfilter: xt_socket: fix a typo in socket_mt_destroy()

Luca Coelho <luciano.coelho@intel.com>
    iwlwifi: mvm: don't send SAR GEO command for 3160 devices

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    iwlwifi: fix iwl_legacy_rate_to_fw_idx

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    iwlwifi: mvm: fix condition which checks the version of rate_n_flags

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: pcie: gen2: fix locking when "HW not ready"

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: pcie: fix locking when "HW not ready"

Matthew Auld <matthew.auld@intel.com>
    drm/i915/ttm: tweak priority hint selection

Siva Mullati <siva.mullati@intel.com>
    drm/i915/gvt: Make DRM_I915_GVT depend on X86

Robin Murphy <robin.murphy@arm.com>
    drm/cma-helper: Set VM_DONTEXPAND for mmap

Jens Wiklander <jens.wiklander@linaro.org>
    optee: use driver internal tee_context for some rpc

Jens Wiklander <jens.wiklander@linaro.org>
    tee: export teedev_open() and teedev_close_context()

Seth Forshee <sforshee@digitalocean.com>
    vsock: remove vsock from connected table when connect is interrupted by a signal

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Fix mbus join config lookup

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Fix dbuf slice config lookup

Jani Nikula <jani.nikula@intel.com>
    drm/i915/opregion: check port number bounds for SWSCI display power state

Rajib Mahapatra <rajib.mahapatra@amd.com>
    drm/amdgpu: skipping SDMA hw_init and hw_fini for S0ix.

Yifan Zhang <yifan1.zhang@amd.com>
    drm/amd/pm: correct the sequence of sending gpu reset msg

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/atomic: Don't pollute crtc_state->mode_blob with error pointers

Nicholas Bishop <nicholasbishop@google.com>
    drm/radeon: Fix backlight control on iMac 12,1

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    drm/mediatek: mtk_dsi: Avoid EPROBE_DEFER loop with external bridge

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: fix use-after-free

Luca Coelho <luciano.coelho@intel.com>
    iwlwifi: remove deprecated broadcast filtering feature

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: x86: nSVM: mark vmcb01 as dirty when restoring SMM saved state

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: x86: nSVM: fix potential NULL derefernce on nested migration

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: x86: SVM: don't passthrough SMAP/SMEP/PKE bits in !NPT && !gCR0.PG case

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: x86: nSVM/nVMX: set nested_run_pending on VM entry which is a result of RSM

David Woodhouse <dwmw@amazon.co.uk>
    KVM: x86/xen: Fix runstate updates to be atomic when preempting vCPU

Jason A. Donenfeld <Jason@zx2c4.com>
    random: wake up /dev/random writers after zap

Kees Cook <keescook@chromium.org>
    gcc-plugins/stackleak: Use noinstr in favor of notrace

Igor Pylypiv <ipylypiv@google.com>
    Revert "module, async: async_synchronize_full() on module init iff async is used"

Jan Beulich <jbeulich@suse.com>
    x86/Xen: streamline (and fix) PV CPU enumeration

Christian König <christian.koenig@amd.com>
    drm/amdgpu: fix logic inversion in check

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Only run s3 or s0ix if system is configured properly

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: add support to check whether the system is set to s3

Steen Hegelund <steen.hegelund@microchip.com>
    net: sparx5: do not refer to skb after passing it on

Sagi Grimberg <sagi@grimberg.me>
    nvme-rdma: fix possible use-after-free in transport error_recovery work

Sagi Grimberg <sagi@grimberg.me>
    nvme-tcp: fix possible use-after-free in transport error_recovery work

Sagi Grimberg <sagi@grimberg.me>
    nvme: fix a possible use-after-free in controller reset during load

Christian Brauner <brauner@kernel.org>
    mailmap: update Christian Brauner's email address

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Warn users about potential s0ix problems

John Garry <john.garry@huawei.com>
    scsi: pm8001: Fix use-after-free for aborted SSP/STP sas_task

John Garry <john.garry@huawei.com>
    scsi: pm8001: Fix use-after-free for aborted TMF sas_task

Ming Lei <ming.lei@redhat.com>
    scsi: core: Reallocate device's budget map on queue depth change

Vincenzo Frascino <vincenzo.frascino@arm.com>
    kselftest: Fix vdso_test_abi return status

Ajish Koshy <Ajish.Koshy@microchip.com>
    scsi: pm80xx: Fix double completion for SATA devices

Darrick J. Wong <djwong@kernel.org>
    quota: make dquot_quota_sync return errors from ->sync_fs

Darrick J. Wong <djwong@kernel.org>
    vfs: make sync_filesystem return errors from ->sync_fs

Darrick J. Wong <djwong@kernel.org>
    vfs: make freeze_super abort when sync_filesystem returns error

Julian Braha <julianbraha@gmail.com>
    pinctrl: bcm63xx: fix unmet dependency on REGMAP for GPIO_REGMAP

Shyam Prasad N <sprasad@microsoft.com>
    cifs: unlock chan_lock before calling cifs_put_tcp_session

Duoming Zhou <duoming@zju.edu.cn>
    ax25: improve the incomplete fix to avoid UAF and NPD bugs

Cristian Marussi <cristian.marussi@arm.com>
    selftests: skip mincore.check_file_mmap when fs lacks needed support

Cristian Marussi <cristian.marussi@arm.com>
    selftests: openat2: Skip testcases that fail with EOPNOTSUPP

Cristian Marussi <cristian.marussi@arm.com>
    selftests: openat2: Add missing dependency in Makefile

Cristian Marussi <cristian.marussi@arm.com>
    selftests: openat2: Print also errno in failure messages

Yang Xu <xuyang2018.jy@fujitsu.com>
    selftests/zram: Adapt the situation that /dev/zram0 is being used

Yang Xu <xuyang2018.jy@fujitsu.com>
    selftests/zram01.sh: Fix compression ratio calculation

Yang Xu <xuyang2018.jy@fujitsu.com>
    selftests/zram: Skip max_comp_streams interface on newer kernel

Miquel Raynal <miquel.raynal@bootlin.com>
    net: ieee802154: at86rf230: Stop leaking skb's

Florian Westphal <fw@strlen.de>
    selftests: netfilter: reduce zone stress test running time

Li Zhijian <lizhijian@cn.fujitsu.com>
    kselftest: signal all child processes

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    selftests: rtc: Increase test timeout so that all tests run

Michał Winiarski <michal.winiarski@intel.com>
    kunit: tool: Import missing importlib.abc

Mario Limonciello <mario.limonciello@amd.com>
    platform/x86: amd-pmc: Correct usage of SMU version

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    platform/x86: ISST: Fix possible circular locking dependency detected

Yuka Kawajiri <yukx00@gmail.com>
    platform/x86: touchscreen_dmi: Add info for the RWC NANOTE P8 AY07J 2-in-1

Julian Braha <julianbraha@gmail.com>
    ASoC: mediatek: fix unmet dependency on GPIOLIB for SND_SOC_DMIC

Qu Wenruo <wqu@suse.com>
    btrfs: defrag: don't try to defrag extents which are under writeback

Dāvis Mosāns <davispuh@gmail.com>
    btrfs: send: in case of IO error log it

Qu Wenruo <wqu@suse.com>
    btrfs: don't hold CPU for too long when defragging a file

Alex Henrie <alexhenrie24@gmail.com>
    HID: apple: Set the tilde quirk flag on the Wellspring 5 and later

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    parisc: Add ioread64_lo_hi() and iowrite64_lo_hi()

Long Li <longli@microsoft.com>
    PCI: hv: Fix NUMA node assignment when kernel boots with custom NUMA topology

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    HID: amd_sfh: Correct the structure field name

Muhammad Usama Anjum <usama.anjum@collabora.com>
    selftests: kvm: Remove absent target file

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    HID: amd_sfh: Increase sensor command timeout

Daniel Thompson <daniel.thompson@linaro.org>
    HID: i2c-hid: goodix: Fix a lockdep splat

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    HID: amd_sfh: Add illuminance mask to limit ALS max value

Linus Torvalds <torvalds@linux-foundation.org>
    mm: don't try to NUMA-migrate COW pages that have other uses

Christian Löhle <CLoehle@hyperstone.com>
    mmc: block: fix read single on recovery logic

John David Anglin <dave.anglin@bell.net>
    parisc: Fix sglist access in ccio-dma.c

John David Anglin <dave.anglin@bell.net>
    parisc: Fix data TLB miss in sba_unmap_sg

John David Anglin <dave.anglin@bell.net>
    parisc: Drop __init from map_pages declaration

Randy Dunlap <rdunlap@infradead.org>
    serial: parisc: GSC: fix build when IOSAPIC is not set

Helge Deller <deller@gmx.de>
    parisc: Show error if wrong 32/64-bit compiler is being used

Sean Christopherson <seanjc@google.com>
    Revert "svm: Add warning message for AVIC IPI invalid target"

Sergio Costas <rastersoft@gmail.com>
    HID:Add support for UGTABLET WP5540

Hao Luo <haoluo@google.com>
    bpf/selftests: Test PTR_TO_RDONLY_MEM

Hao Luo <haoluo@google.com>
    bpf: Add MEM_RDONLY for helper args that are pointers to rdonly mem.

Hao Luo <haoluo@google.com>
    bpf: Make per_cpu_ptr return rdonly PTR_TO_MEM.

Hao Luo <haoluo@google.com>
    bpf: Convert PTR_TO_MEM_OR_NULL to composable types.

Hao Luo <haoluo@google.com>
    bpf: Introduce MEM_RDONLY flag

Hao Luo <haoluo@google.com>
    bpf: Replace PTR_TO_XXX_OR_NULL with PTR_TO_XXX | PTR_MAYBE_NULL

Hao Luo <haoluo@google.com>
    bpf: Replace RET_XXX_OR_NULL with RET_XXX | PTR_MAYBE_NULL

Hao Luo <haoluo@google.com>
    bpf: Replace ARG_XXX_OR_NULL with ARG_XXX | PTR_MAYBE_NULL

Hao Luo <haoluo@google.com>
    bpf: Introduce composable reg, ret and arg types.

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/pmu/gm200-: use alternate falcon reset sequence


-------------

Diffstat:

 .mailmap                                           |   3 +
 Makefile                                           |   4 +-
 arch/arm/mach-omap2/display.c                      |   2 +-
 arch/arm/mach-omap2/omap_hwmod.c                   |   4 +-
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi  |   6 +
 arch/arm64/boot/dts/amlogic/meson-g12a-sei510.dts  |   8 -
 arch/arm64/boot/dts/amlogic/meson-gx.dtsi          |   6 +
 arch/arm64/boot/dts/amlogic/meson-sm1-sei610.dts   |   8 -
 arch/arm64/include/asm/el2_setup.h                 |   2 +-
 arch/parisc/include/asm/bitops.h                   |   8 +
 arch/parisc/lib/iomap.c                            |  18 +
 arch/parisc/mm/init.c                              |   9 +-
 arch/powerpc/kernel/head_book3s_32.S               |   4 +-
 arch/powerpc/lib/sstep.c                           |   2 +
 arch/x86/include/asm/bug.h                         |  20 +-
 arch/x86/kernel/fpu/regset.c                       |   9 +-
 arch/x86/kernel/ptrace.c                           |   4 +-
 arch/x86/kvm/pmu.c                                 |  15 +-
 arch/x86/kvm/pmu.h                                 |   3 +-
 arch/x86/kvm/svm/avic.c                            |   2 -
 arch/x86/kvm/svm/nested.c                          |  26 +-
 arch/x86/kvm/svm/pmu.c                             |   8 +-
 arch/x86/kvm/svm/svm.c                             |  19 +-
 arch/x86/kvm/vmx/pmu_intel.c                       |   9 +-
 arch/x86/kvm/vmx/vmx.c                             |   1 +
 arch/x86/kvm/xen.c                                 |  97 ++--
 arch/x86/xen/enlighten_pv.c                        |   4 -
 arch/x86/xen/smp_pv.c                              |  26 +-
 block/bfq-iosched.c                                |   2 +
 block/blk-core.c                                   |  10 +-
 block/elevator.c                                   |   2 -
 block/genhd.c                                      |  14 +
 crypto/af_alg.c                                    |   3 -
 drivers/acpi/processor_idle.c                      |   5 +
 drivers/acpi/x86/s2idle.c                          |  12 +-
 drivers/ata/libata-core.c                          |   1 +
 drivers/block/mtip32xx/mtip32xx.c                  |   2 +-
 drivers/block/rbd.c                                |   2 +-
 drivers/block/xen-blkfront.c                       |   2 +-
 drivers/char/random.c                              |   5 +-
 drivers/dma/ptdma/ptdma-dev.c                      |  17 +-
 drivers/dma/sh/rcar-dmac.c                         |   9 +-
 drivers/dma/stm32-dmamux.c                         |   4 +-
 drivers/edac/edac_mc.c                             |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                |  10 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c           |  37 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |   8 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |   2 +-
 drivers/gpu/drm/amd/amdgpu/gfxhub_v2_1.c           |   7 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c             |   8 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   2 +-
 .../drm/amd/display/dc/clk_mgr/dcn31/dcn31_smu.c   |   6 +-
 drivers/gpu/drm/amd/display/dc/core/dc.c           |   2 +
 drivers/gpu/drm/amd/display/dc/dc.h                |   1 +
 .../gpu/drm/amd/display/dc/dcn31/dcn31_hubbub.c    |  61 +--
 .../gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c   |   9 +-
 drivers/gpu/drm/drm_atomic_uapi.c                  |  14 +-
 drivers/gpu/drm/drm_gem_cma_helper.c               |   1 +
 drivers/gpu/drm/i915/Kconfig                       |   1 +
 drivers/gpu/drm/i915/display/intel_opregion.c      |  15 +
 drivers/gpu/drm/i915/gem/i915_gem_ttm.c            |   6 +-
 drivers/gpu/drm/i915/intel_pm.c                    |   4 +-
 drivers/gpu/drm/mediatek/mtk_dsi.c                 | 167 +++----
 drivers/gpu/drm/nouveau/nvkm/falcon/base.c         |   8 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gm200.c    |  31 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gm20b.c    |   2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp102.c    |   2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp10b.c    |   2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/priv.h     |   2 +
 drivers/gpu/drm/radeon/atombios_encoders.c         |   3 +-
 drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c        |  14 +-
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.c             |   4 +-
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.h             |   2 +-
 .../amd-sfh-hid/hid_descriptor/amd_sfh_hid_desc.c  |   4 +-
 drivers/hid/hid-apple.c                            |  16 +-
 drivers/hid/hid-elo.c                              |   1 +
 drivers/hid/hid-ids.h                              |   1 +
 drivers/hid/hid-quirks.c                           |   1 +
 drivers/hid/i2c-hid/i2c-hid-of-goodix.c            |  28 +-
 drivers/hv/vmbus_drv.c                             |   5 +-
 drivers/i2c/busses/i2c-brcmstb.c                   |   2 +-
 drivers/i2c/busses/i2c-qcom-cci.c                  |  16 +-
 drivers/irqchip/irq-sifive-plic.c                  |   1 +
 drivers/md/dm.c                                    |   2 +-
 drivers/mmc/core/block.c                           |  28 +-
 drivers/mtd/devices/phram.c                        |  12 +-
 drivers/mtd/nand/raw/brcmnand/brcmnand.c           |   2 +-
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c         |   3 +-
 drivers/mtd/nand/raw/ingenic/ingenic_ecc.c         |   7 +-
 drivers/mtd/nand/raw/qcom_nandc.c                  |  14 +-
 drivers/mtd/parsers/qcomsmempart.c                 |  33 +-
 drivers/net/bonding/bond_3ad.c                     |  30 +-
 drivers/net/bonding/bond_main.c                    |   5 +-
 drivers/net/dsa/Kconfig                            |   1 +
 drivers/net/dsa/lan9303-core.c                     |  13 +-
 drivers/net/dsa/lantiq_gswip.c                     |   2 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |   7 +
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c    |   2 +-
 drivers/net/ethernet/broadcom/bgmac-platform.c     |  23 +-
 drivers/net/ethernet/cadence/macb_main.c           |   2 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |   2 +-
 .../ethernet/freescale/dpaa2/dpaa2-switch-flower.c |   4 +-
 drivers/net/ethernet/intel/ice/ice_lib.c           |   6 +
 .../net/ethernet/microchip/sparx5/sparx5_packet.c  |   2 +-
 drivers/net/ethernet/mscc/ocelot.c                 |   6 +-
 drivers/net/ethernet/netronome/nfp/flower/cmsg.h   |   2 +
 drivers/net/ieee802154/at86rf230.c                 |  13 +-
 drivers/net/ieee802154/ca8210.c                    |   4 +-
 drivers/net/netdevsim/fib.c                        |   4 +-
 drivers/net/phy/mediatek-ge.c                      |   3 -
 drivers/net/usb/qmi_wwan.c                         |   2 +
 .../broadcom/brcm80211/brcmfmac/firmware.c         |   6 +-
 drivers/net/wireless/intel/iwlwifi/Kconfig         |  13 -
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |  11 +-
 .../net/wireless/intel/iwlwifi/fw/api/commands.h   |   5 -
 drivers/net/wireless/intel/iwlwifi/fw/api/filter.h |  88 ----
 drivers/net/wireless/intel/iwlwifi/fw/api/rs.h     |   1 -
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |   2 -
 drivers/net/wireless/intel/iwlwifi/fw/rs.c         |  33 +-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |   3 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |   2 +
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   | 203 ---------
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  | 240 ----------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  13 -
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   1 -
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   2 +-
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   |   3 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |   3 +-
 drivers/nvme/host/core.c                           |  11 +-
 drivers/nvme/host/multipath.c                      |   2 +-
 drivers/nvme/host/rdma.c                           |   1 +
 drivers/nvme/host/tcp.c                            |   1 +
 drivers/parisc/ccio-dma.c                          |   3 +-
 drivers/parisc/sba_iommu.c                         |   3 +-
 drivers/pci/controller/pci-hyperv.c                |  13 +-
 drivers/phy/broadcom/phy-brcm-usb.c                |  38 ++
 drivers/phy/mediatek/phy-mtk-tphy.c                |   2 +-
 drivers/pinctrl/bcm/Kconfig                        |   1 +
 drivers/platform/x86/amd-pmc.c                     |  13 +-
 .../x86/intel/speed_select_if/isst_if_common.c     |  97 ++--
 drivers/platform/x86/touchscreen_dmi.c             |  24 +
 drivers/scsi/lpfc/lpfc.h                           |   1 +
 drivers/scsi/lpfc/lpfc_attr.c                      |   3 +
 drivers/scsi/lpfc/lpfc_els.c                       |  20 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c                 |   5 +-
 drivers/scsi/pm8001/pm8001_hwi.c                   |  18 -
 drivers/scsi/pm8001/pm8001_sas.c                   |   5 +
 drivers/scsi/pm8001/pm80xx_hwi.c                   |  30 +-
 drivers/scsi/qedi/qedi_fw.c                        |   6 +-
 drivers/scsi/scsi_scan.c                           |  55 ++-
 drivers/scsi/ufs/ufshcd.c                          |  58 +--
 drivers/scsi/ufs/ufshcd.h                          |   2 +
 drivers/soc/aspeed/aspeed-lpc-ctrl.c               |   7 +-
 .../vc04_services/interface/vchiq_arm/vchiq_arm.c  |  20 +-
 drivers/tee/optee/core.c                           |   1 +
 drivers/tee/optee/ffa_abi.c                        |  70 +--
 drivers/tee/optee/optee_private.h                  |   4 +-
 drivers/tee/optee/smc_abi.c                        |  13 +-
 drivers/tee/tee_core.c                             |   6 +-
 drivers/tty/n_tty.c                                |   6 +-
 drivers/tty/serial/8250/8250_gsc.c                 |   2 +-
 fs/btrfs/ioctl.c                                   |   5 +
 fs/btrfs/send.c                                    |   4 +
 fs/cifs/connect.c                                  |   8 +-
 fs/cifs/fs_context.c                               |   4 +-
 fs/cifs/sess.c                                     |  11 +-
 fs/cifs/xattr.c                                    |   2 +
 fs/io_uring.c                                      |   5 +-
 fs/ksmbd/smb2pdu.c                                 |   7 +-
 fs/ksmbd/smb_common.c                              |   5 +-
 fs/ksmbd/vfs.h                                     |   1 +
 fs/nfs/dir.c                                       |   4 +-
 fs/nfs/inode.c                                     |   9 +-
 fs/nfs/nfs4proc.c                                  |   3 +-
 fs/quota/dquot.c                                   |  11 +-
 fs/super.c                                         |  19 +-
 fs/sync.c                                          |  18 +-
 include/linux/blkdev.h                             |   3 +-
 include/linux/bpf.h                                | 101 ++++-
 include/linux/bpf_verifier.h                       |  17 +
 include/linux/compiler.h                           |  21 +-
 include/linux/netdevice.h                          |   2 +-
 include/linux/sched.h                              |   1 -
 include/linux/tee_drv.h                            |  14 +
 include/net/addrconf.h                             |   2 -
 include/net/bond_3ad.h                             |   2 +-
 include/net/dsa.h                                  |   1 +
 include/net/ip6_fib.h                              |  10 +-
 include/net/ipv6.h                                 |   5 +-
 include/net/netns/ipv6.h                           |   3 +-
 kernel/async.c                                     |   3 -
 kernel/bpf/btf.c                                   |  12 +-
 kernel/bpf/cgroup.c                                |   2 +-
 kernel/bpf/helpers.c                               |  12 +-
 kernel/bpf/map_iter.c                              |   4 +-
 kernel/bpf/ringbuf.c                               |   2 +-
 kernel/bpf/syscall.c                               |   2 +-
 kernel/bpf/verifier.c                              | 488 ++++++++++-----------
 kernel/cred.c                                      |   9 +-
 kernel/fork.c                                      |  17 +-
 kernel/locking/lockdep.c                           |   4 +-
 kernel/module.c                                    |  25 +-
 kernel/stackleak.c                                 |   5 +-
 kernel/sys.c                                       |  20 +-
 kernel/trace/bpf_trace.c                           |  26 +-
 kernel/trace/trace.c                               |   4 +
 kernel/ucount.c                                    |   3 +-
 mm/mprotect.c                                      |   2 +-
 net/ax25/af_ax25.c                                 |   9 +-
 net/bridge/br_multicast.c                          |   4 +
 net/core/bpf_sk_storage.c                          |   2 +-
 net/core/drop_monitor.c                            |  11 +-
 net/core/filter.c                                  |  64 +--
 net/core/rtnetlink.c                               |   6 +-
 net/core/sock_map.c                                |   2 +-
 net/dsa/dsa.c                                      |   1 +
 net/dsa/dsa_priv.h                                 |   1 -
 net/dsa/tag_lan9303.c                              |  21 +-
 net/ipv4/fib_lookup.h                              |   7 +-
 net/ipv4/fib_semantics.c                           |   6 +-
 net/ipv4/fib_trie.c                                |  22 +-
 net/ipv4/ping.c                                    |  11 +-
 net/ipv4/route.c                                   |   4 +-
 net/ipv6/addrconf.c                                |   4 +-
 net/ipv6/ip6_flowlabel.c                           |   4 +-
 net/ipv6/mcast.c                                   |   2 +-
 net/ipv6/route.c                                   |  19 +-
 net/mac80211/mlme.c                                |  29 +-
 net/mctp/route.c                                   |  11 +-
 net/netfilter/nf_conntrack_proto_sctp.c            |   9 +
 net/netfilter/nft_synproxy.c                       |   4 +-
 net/netfilter/xt_socket.c                          |   2 +-
 net/sched/act_api.c                                |  13 +-
 net/sched/cls_api.c                                |   6 +-
 net/sched/sch_api.c                                |  22 +-
 net/sched/sch_generic.c                            |  29 +-
 net/smc/af_smc.c                                   |  10 +-
 net/sunrpc/xprtrdma/verbs.c                        |   3 +
 net/tipc/node.c                                    |  13 +-
 net/vmw_vsock/af_vsock.c                           |   1 +
 net/wireless/core.c                                |  17 +-
 scripts/kconfig/confdata.c                         |  13 +-
 scripts/kconfig/preprocess.c                       |   2 +-
 sound/core/memalloc.c                              |  15 +-
 sound/pci/hda/hda_intel.c                          |   5 +-
 sound/pci/hda/patch_realtek.c                      |  40 +-
 sound/soc/codecs/tas2770.c                         |   7 +-
 sound/soc/codecs/wm_adsp.c                         |   3 +-
 sound/soc/mediatek/Kconfig                         |   2 +-
 sound/soc/qcom/lpass-platform.c                    |   8 +-
 sound/soc/soc-ops.c                                |  41 +-
 sound/usb/implicit.c                               |   4 +-
 sound/usb/mixer.c                                  |   9 +-
 tools/lib/subcmd/subcmd-util.h                     |  11 +-
 tools/perf/util/bpf-loader.c                       |   3 +-
 tools/testing/kunit/kunit_kernel.py                |   1 +
 tools/testing/selftests/bpf/prog_tests/ksyms_btf.c |  14 +
 .../bpf/progs/test_ksyms_btf_write_check.c         |  29 ++
 tools/testing/selftests/clone3/clone3.c            |   2 -
 tools/testing/selftests/exec/Makefile              |   4 +-
 tools/testing/selftests/kselftest_harness.h        |   4 +-
 tools/testing/selftests/kvm/Makefile               |   1 -
 tools/testing/selftests/mincore/mincore_selftest.c |  20 +-
 .../selftests/mount_setattr/mount_setattr_test.c   |   4 +-
 .../selftests/netfilter/nft_concat_range.sh        |   2 +-
 tools/testing/selftests/netfilter/nft_fib.sh       |   1 +
 .../testing/selftests/netfilter/nft_zones_many.sh  |  12 +-
 tools/testing/selftests/openat2/Makefile           |   2 +-
 tools/testing/selftests/openat2/helpers.h          |  12 +-
 tools/testing/selftests/openat2/openat2_test.c     |  12 +-
 tools/testing/selftests/pidfd/pidfd.h              |  13 +-
 tools/testing/selftests/pidfd/pidfd_fdinfo_test.c  |  22 +-
 tools/testing/selftests/pidfd/pidfd_test.c         |   6 +-
 tools/testing/selftests/pidfd/pidfd_wait.c         |   5 +-
 tools/testing/selftests/rtc/settings               |   2 +-
 tools/testing/selftests/vDSO/vdso_test_abi.c       | 135 +++---
 tools/testing/selftests/zram/zram.sh               |  15 +-
 tools/testing/selftests/zram/zram01.sh             |  33 +-
 tools/testing/selftests/zram/zram02.sh             |   1 -
 tools/testing/selftests/zram/zram_lib.sh           | 134 ++++--
 281 files changed, 2217 insertions(+), 2070 deletions(-)


