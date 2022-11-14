Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6AF1628189
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:44:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236117AbiKNNob (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:44:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbiKNNob (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:44:31 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC34023E9A;
        Mon, 14 Nov 2022 05:44:28 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id f3so3870200pgc.2;
        Mon, 14 Nov 2022 05:44:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=frjgBGDa02KzD4KplDo+xu9E0IxC5G7Rl3iGKt8eX8c=;
        b=UOIfQOMGSXlgSg+N6EechE7N1SdEk8wBhPjj97ysvxJGqkw39Lez23S6enBidrXLWd
         6r6Pdw5v7JNhBzU3OOrK+dfYc+aJfqVyPNQWrVoGVuAQUFo+CAWkFAajnEV2QPqv5HMG
         iXmDrhJQHYEJJ66f+2dEcCSdzXA32RLlzwfMp5oONwkBo76UR1HiPKFoWKHy9sY+tVzZ
         nV9sciOS9ONyRCSrdMMFckBSNWZbGFvpmST9gkBItEyFfvGsvDc4lfBbEW2srX94Ccri
         Kwla+OjyOJ3Od8+T+9T4E5YYkLGQxMPUozaT26w5CTBSJchK/kRHe3KOVH64KT2OH6io
         8O0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=frjgBGDa02KzD4KplDo+xu9E0IxC5G7Rl3iGKt8eX8c=;
        b=rfqjJOI741gnW5xIAQhtTwKn38e0ALjnRQ4rDXypjG/rg7VKjDMLL+kMCQ7BlfNDci
         4D1bZls1XbYaE5qflzhnE9RYcPMYd8VJLrWgBWOypapglRC+iBO1B12wweCRctYAm5zp
         iIBTWn69n6zZAf9JETDIP8pkMyJ5FY3zI9o6gF5flZDmk6w5QBjrN5eFpY0HTFl2y3MS
         4PYLO0PonqVuKBZrfZMO89hMF7YhR0C/WyZ4sUvLztVZ+Rl0Lua4o7bh/j08rgDfPXhP
         jxrVSVxiNwQnnSvAlT1ijQJ81RDkfN13t4aKffkPQqEaKszmF/hb6pIoCT5BwbeAtfK/
         0Bmg==
X-Gm-Message-State: ANoB5pngJzNuggulCkUAEGZSaui3xbiPaeF3xjk0bNvYq/IA8NMn2+uj
        aSinPRSuh7Q4+/PBw8uGpMn8N7qIz9wxoq57itw=
X-Google-Smtp-Source: AA0mqf6b/vFP6N4QCplaO1OBn0m29b7KpHU22GYtQfT95EuYimgUeBWgxF9MNLJluMPbN6XHr/VLeJAzHUvw1QJ/Oc0=
X-Received: by 2002:a63:fe42:0:b0:46f:d4b8:409f with SMTP id
 x2-20020a63fe42000000b0046fd4b8409fmr11932157pgj.475.1668433467797; Mon, 14
 Nov 2022 05:44:27 -0800 (PST)
MIME-Version: 1.0
References: <20221114124458.806324402@linuxfoundation.org>
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
From:   Luna Jernberg <droidbittin@gmail.com>
Date:   Mon, 14 Nov 2022 14:44:15 +0100
Message-ID: <CADo9pHibz9XBHw_PGXwAMpoc8Q5wYyzZBMSDRzMW8UdZSb+5Ng@mail.gmail.com>
Subject: Re: [PATCH 6.0 000/190] 6.0.9-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luna Jernberg <droidbittin@gmail.com>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Works fine on my Arch Linux server with Intel(R) Core(TM) i5-6400 CPU @ 2.7=
0GHz

Tested by: Luna Jernberg <droidbittin@gmail.com>

On Mon, Nov 14, 2022 at 2:01 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.0.9 release.
> There are 190 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Nov 2022 12:44:21 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.0.9-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------
> Pseudo-Shortlog of commits:
>
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 6.0.9-rc1
>
> Takashi Iwai <tiwai@suse.de>
>     ALSA: memalloc: Try dma_alloc_noncontiguous() at first
>
> Philip Yang <Philip.Yang@amd.com>
>     drm/amdkfd: Migrate in CPU page fault use current mm
>
> Tudor Ambarus <tudor.ambarus@microchip.com>
>     dmaengine: at_hdmac: Check return code of dma_async_device_register
>
> Tudor Ambarus <tudor.ambarus@microchip.com>
>     dmaengine: at_hdmac: Fix impossible condition
>
> Tudor Ambarus <tudor.ambarus@microchip.com>
>     dmaengine: at_hdmac: Don't allow CPU to reorder channel enable
>
> Tudor Ambarus <tudor.ambarus@microchip.com>
>     dmaengine: at_hdmac: Fix completion of unissued descriptor in case of=
 errors
>
> Tudor Ambarus <tudor.ambarus@microchip.com>
>     dmaengine: at_hdmac: Fix descriptor handling when issuing it to hardw=
are
>
> Tudor Ambarus <tudor.ambarus@microchip.com>
>     dmaengine: at_hdmac: Fix concurrency over the active list
>
> Tudor Ambarus <tudor.ambarus@microchip.com>
>     dmaengine: at_hdmac: Free the memset buf without holding the chan loc=
k
>
> Tudor Ambarus <tudor.ambarus@microchip.com>
>     dmaengine: at_hdmac: Fix concurrency over descriptor
>
> Tudor Ambarus <tudor.ambarus@microchip.com>
>     dmaengine: at_hdmac: Fix concurrency problems by removing atc_complet=
e_all()
>
> Tudor Ambarus <tudor.ambarus@microchip.com>
>     dmaengine: at_hdmac: Protect atchan->status with the channel lock
>
> Tudor Ambarus <tudor.ambarus@microchip.com>
>     dmaengine: at_hdmac: Do not call the complete callback on device_term=
inate_all
>
> Tudor Ambarus <tudor.ambarus@microchip.com>
>     dmaengine: at_hdmac: Fix premature completion of desc in issue_pendin=
g
>
> Tudor Ambarus <tudor.ambarus@microchip.com>
>     dmaengine: at_hdmac: Start transfer for cyclic channels in issue_pend=
ing
>
> Tudor Ambarus <tudor.ambarus@microchip.com>
>     dmaengine: at_hdmac: Don't start transactions at tx_submit level
>
> Tudor Ambarus <tudor.ambarus@microchip.com>
>     dmaengine: at_hdmac: Fix at_lli struct definition
>
> Oliver Hartkopp <socketcan@hartkopp.net>
>     can: dev: fix skb drop check
>
> Paolo Bonzini <pbonzini@redhat.com>
>     KVM: SVM: move guest vmsave/vmload back to assembly
>
> Paolo Bonzini <pbonzini@redhat.com>
>     KVM: SVM: retrieve VMCB from assembly
>
> Peter Gonda <pgonda@google.com>
>     KVM: SVM: Only dump VMSA to klog at KERN_DEBUG level
>
> Paolo Bonzini <pbonzini@redhat.com>
>     KVM: SVM: adjust register allocation for __svm_vcpu_run()
>
> Paolo Bonzini <pbonzini@redhat.com>
>     KVM: SVM: replace regs argument of __svm_vcpu_run() with vcpu_svm
>
> Paolo Bonzini <pbonzini@redhat.com>
>     KVM: x86: use a separate asm-offsets.c file
>
> Like Xu <likexu@tencent.com>
>     KVM: x86/pmu: Do not speculatively query Intel GP PMCs that don't exi=
st yet
>
> Sean Christopherson <seanjc@google.com>
>     KVM: x86/mmu: Block all page faults during kvm_zap_gfn_range()
>
> Geert Uytterhoeven <geert+renesas@glider.be>
>     can: rcar_canfd: Add missing ECC error checks for channels 2-7
>
> Oliver Hartkopp <socketcan@hartkopp.net>
>     can: isotp: fix tx state handling for echo tx processing
>
> Oliver Hartkopp <socketcan@hartkopp.net>
>     can: j1939: j1939_send_one(): fix missing CAN header initialization
>
> Peter Xu <peterx@redhat.com>
>     mm/shmem: use page_mapping() to detect page cache for uffd continue
>
> Pankaj Gupta <pankaj.gupta@amd.com>
>     mm/memremap.c: map FS_DAX device memory as decrypted
>
> SeongJae Park <sj@kernel.org>
>     mm/damon/dbgfs: check if rm_contexts input is for a real context
>
> Fenghua Yu <fenghua.yu@intel.com>
>     dmaengine: idxd: Do not enable user type Work Queue without Shared Vi=
rtual Addressing
>
> Vasily Gorbik <gor@linux.ibm.com>
>     mm: hugetlb_vmemmap: include missing linux/moduleparam.h
>
> Naoya Horiguchi <naoya.horiguchi@nec.com>
>     arch/x86/mm/hugetlbpage.c: pud_huge() returns 0 when using 2-level pa=
ging
>
> Mika Westerberg <mika.westerberg@linux.intel.com>
>     spi: intel: Use correct mask for flash and protected regions
>
> ZhangPeng <zhangpeng362@huawei.com>
>     udf: Fix a slab-out-of-bounds write bug in udf_find_entry()
>
> Brian Norris <briannorris@chromium.org>
>     mms: sdhci-esdhc-imx: Fix SDHCI_RESET_ALL for CQHCI
>
> Roger Quadros <rogerq@kernel.org>
>     net: ethernet: ti: am65-cpsw: Fix segmentation fault at module unload
>
> Johan Hovold <johan+linaro@kernel.org>
>     phy: qcom-qmp-combo: fix NULL-deref on runtime resume
>
> Jens Axboe <axboe@kernel.dk>
>     io_uring: check for rollover of buffer ID when providing buffers
>
> Johannes Thumshirn <johannes.thumshirn@wdc.com>
>     btrfs: zoned: initialize device's zone info for seeding
>
> Johannes Thumshirn <johannes.thumshirn@wdc.com>
>     btrfs: zoned: clone zoned device info when cloning a device
>
> Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
>     btrfs: selftests: fix wrong error check in btrfs_free_dummy_root()
>
> Liu Shixin <liushixin2@huawei.com>
>     btrfs: fix match incorrectly in dev_args_match_device
>
> Wen Gong <quic_wgong@quicinc.com>
>     wifi: ath11k: avoid deadlock during regulatory update in ath11k_regd_=
update()
>
> Jorge Lopez <jorge.lopez2@hp.com>
>     platform/x86: hp_wmi: Fix rfkill causing soft blocked wifi
>
> Felix Kuehling <Felix.Kuehling@amd.com>
>     drm/amdkfd: Fix error handling in kfd_criu_restore_events
>
> Felix Kuehling <Felix.Kuehling@amd.com>
>     drm/amdkfd: Fix error handling in criu_checkpoint
>
> Guchun Chen <guchun.chen@amd.com>
>     drm/amdgpu: disable BACO on special BEIGE_GOBY card
>
> Christian K=C3=B6nig <christian.koenig@amd.com>
>     drm/amdgpu: workaround for TLB seq race
>
> Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
>     drm/amd/display: Update SR watermarks for DCN314
>
> Tim Huang <tim.huang@amd.com>
>     drm/amd/pm: update SMU IP v13.0.4 msg interface header
>
> Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
>     drm/amd/display: Fix reg timeout in enc314_enable_fifo
>
> Matthew Auld <matthew.auld@intel.com>
>     drm/i915/dmabuf: fix sg_table handling in map_dma_buf
>
> Ryusuke Konishi <konishi.ryusuke@gmail.com>
>     nilfs2: fix use-after-free bug of ns_writer on remount
>
> Ryusuke Konishi <konishi.ryusuke@gmail.com>
>     nilfs2: fix deadlock in nilfs_count_free_blocks()
>
> Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
>     ata: libata-scsi: fix SYNCHRONIZE CACHE (16) command failure
>
> Nathan Chancellor <nathan@kernel.org>
>     vmlinux.lds.h: Fix placement of '.data..decrypted' section
>
> Jussi Laako <jussi@sonarnerd.net>
>     ALSA: usb-audio: Add DSD support for Accuphase DAC-60
>
> Takashi Iwai <tiwai@suse.de>
>     ALSA: usb-audio: Add quirk entry for M-Audio Micro
>
> Takashi Iwai <tiwai@suse.de>
>     ALSA: usb-audio: Yet more regression for for the delayed card registr=
ation
>
> Edson Juliano Drosdeck <edson.drosdeck@gmail.com>
>     ALSA: hda/realtek: Add Positivo C6300 model quirk
>
> Stefan Binding <sbinding@opensource.cirrus.com>
>     ALSA: hda/realtek: Add quirk for ASUS Zenbook using CS35L41
>
> Ye Bin <yebin10@huawei.com>
>     ALSA: hda: fix potential memleak in 'add_widget_node'
>
> Xian Wang <dev@xianwang.io>
>     ALSA: hda/ca0132: add quirk for EVGA Z390 DARK
>
> Evan Quan <evan.quan@amd.com>
>     ALSA: hda/hdmi - enable runtime pm for more AMD display audio
>
> Haibo Chen <haibo.chen@nxp.com>
>     mmc: sdhci-esdhc-imx: use the correct host caps for MMC_CAP_8_BIT_DAT=
A
>
> Brian Norris <briannorris@chromium.org>
>     mmc: sdhci-tegra: Fix SDHCI_RESET_ALL for CQHCI
>
> Brian Norris <briannorris@chromium.org>
>     mmc: sdhci_am654: Fix SDHCI_RESET_ALL for CQHCI
>
> Brian Norris <briannorris@chromium.org>
>     mmc: sdhci-brcmstb: Fix SDHCI_RESET_ALL for CQHCI
>
> Brian Norris <briannorris@chromium.org>
>     mmc: sdhci-of-arasan: Fix SDHCI_RESET_ALL for CQHCI
>
> Brian Norris <briannorris@chromium.org>
>     mmc: cqhci: Provide helper for resetting both SDHCI and CQHCI
>
> Ma Jun <Jun.Ma2@amd.com>
>     drm/amdgpu: Fix the lpfn checking condition in drm buddy
>
> Jiaxun Yang <jiaxun.yang@flygoat.com>
>     MIPS: jump_label: Fix compat branch range check
>
> Ard Biesheuvel <ardb@kernel.org>
>     arm64: efi: Fix handling of misaligned runtime regions and drop warni=
ng
>
> Wei Yongjun <weiyongjun1@huawei.com>
>     eth: sp7021: drop free_netdev() from spl2sw_init_netdev()
>
> Conor Dooley <conor.dooley@microchip.com>
>     riscv: fix reserved memory setup
>
> Jisheng Zhang <jszhang@kernel.org>
>     riscv: vdso: fix build with llvm
>
> Jisheng Zhang <jszhang@kernel.org>
>     riscv: process: fix kernel info leakage
>
> Chuang Wang <nashuiliang@gmail.com>
>     net: macvlan: fix memory leaks of macvlan_common_newlink
>
> Zhengchao Shao <shaozhengchao@huawei.com>
>     ethernet: tundra: free irq when alloc ring failed in tsi108_open()
>
> Takashi Iwai <tiwai@suse.de>
>     ALSA: memalloc: Don't fall back for SG-buffer with IOMMU
>
> Zhengchao Shao <shaozhengchao@huawei.com>
>     net: mv643xx_eth: disable napi when init rxq or txq failed in mv643xx=
_eth_open()
>
> Zhengchao Shao <shaozhengchao@huawei.com>
>     ethernet: s2io: disable napi when start nic failed in s2io_card_up()
>
> Antoine Tenart <atenart@kernel.org>
>     net: atlantic: macsec: clear encryption keys from the stack
>
> Antoine Tenart <atenart@kernel.org>
>     net: phy: mscc: macsec: clear encryption keys when freeing a flow
>
> Yang Yingliang <yangyingliang@huawei.com>
>     stmmac: dwmac-loongson: fix missing of_node_put() while module exitin=
g
>
> Yang Yingliang <yangyingliang@huawei.com>
>     stmmac: dwmac-loongson: fix missing pci_disable_device() in loongson_=
dwmac_probe()
>
> Yang Yingliang <yangyingliang@huawei.com>
>     stmmac: dwmac-loongson: fix missing pci_disable_msi() while module ex=
iting
>
> Zhengchao Shao <shaozhengchao@huawei.com>
>     cxgb4vf: shut down the adapter when t4vf_update_port_info() failed in=
 cxgb4vf_open()
>
> Wei Yongjun <weiyongjun1@huawei.com>
>     mctp: Fix an error handling path in mctp_init()
>
> Tan, Tee Min <tee.min.tan@intel.com>
>     stmmac: intel: Update PCH PTP clock rate from 200MHz to 204.8MHz
>
> Zhengchao Shao <shaozhengchao@huawei.com>
>     net: cxgb3_main: disable napi when bind qsets failed in cxgb_up()
>
> Zhengchao Shao <shaozhengchao@huawei.com>
>     net: cpsw: disable napi in cpsw_ndo_open()
>
> Michal Jaron <michalx.jaron@intel.com>
>     iavf: Fix VF driver counting VLAN 0 filters
>
> Norbert Zulinski <norbertx.zulinski@intel.com>
>     ice: Fix spurious interrupt during removal of trusted VF
>
> Roi Dayan <roid@nvidia.com>
>     net/mlx5e: E-Switch, Fix comparing termination table instance
>
> Jianbo Liu <jianbol@nvidia.com>
>     net/mlx5e: TC, Fix wrong rejection of packet-per-second policing
>
> Roi Dayan <roid@nvidia.com>
>     net/mlx5e: Fix tc acts array not to be dependent on enum order
>
> Maxim Mikityanskiy <maximmi@nvidia.com>
>     net/mlx5e: Add missing sanity checks for max TX WQE size
>
> Shay Drory <shayd@nvidia.com>
>     net/mlx5: fw_reset: Don't try to load device in case PCI isn't workin=
g
>
> Chris Mi <cmi@nvidia.com>
>     net/mlx5: E-switch, Set to legacy mode if failed to change switchdev =
mode
>
> Roy Novich <royno@nvidia.com>
>     net/mlx5: Allow async trigger completion execution on single CPU syst=
ems
>
> Vlad Buslov <vladbu@nvidia.com>
>     net/mlx5: Bridge, verify LAG state when adding bond to bridge
>
> M Chetan Kumar <m.chetan.kumar@linux.intel.com>
>     net: wwan: iosm: fix invalid mux header type
>
> M Chetan Kumar <m.chetan.kumar@linux.intel.com>
>     net: wwan: iosm: fix memory leak in ipc_pcie_read_bios_cfg
>
> Zhengchao Shao <shaozhengchao@huawei.com>
>     net: nixge: disable napi when enable interrupts failed in nixge_open(=
)
>
> Eric Dumazet <edumazet@google.com>
>     net: tun: call napi_schedule_prep() to ensure we own a napi
>
> Zhengchao Shao <shaozhengchao@huawei.com>
>     net: marvell: prestera: fix memory leak in prestera_rxtx_switch_init(=
)
>
> Shigeru Yoshida <syoshida@redhat.com>
>     netfilter: Cleanup nft_net->module_list from nf_tables_exit_net()
>
> Ziyang Xuan <william.xuanziyang@huawei.com>
>     netfilter: nfnetlink: fix potential dead lock in nfnetlink_rcv_msg()
>
> Donglin Peng <dolinux.peng@gmail.com>
>     perf tools: Add the include/perf/ directory to .gitignore
>
> James Clark <james.clark@arm.com>
>     perf test: Fix skipping branch stack sampling test
>
> Athira Rajeev <atrajeev@linux.vnet.ibm.com>
>     perf stat: Fix printing os->prefix in CSV metrics output
>
> Namhyung Kim <namhyung@kernel.org>
>     perf stat: Fix crash with --per-node --metric-only in CSV mode
>
> Zhengchao Shao <shaozhengchao@huawei.com>
>     drivers: net: xgene: disable napi when register irq failed in xgene_e=
net_open()
>
> Ratheesh Kannoth <rkannoth@marvell.com>
>     octeontx2-pf: Fix SQE threshold checking
>
> Zhengchao Shao <shaozhengchao@huawei.com>
>     net: ethernet: mtk-star-emac: disable napi when connect and start PHY=
 failed in mtk_star_enable()
>
> Zhengchao Shao <shaozhengchao@huawei.com>
>     net: lapbether: fix issue of invalid opcode in lapbeth_open()
>
> Amelie Delaunay <amelie.delaunay@foss.st.com>
>     dmaengine: stm32-dma: fix potential race between pause and resume
>
> Yang Yingliang <yangyingliang@huawei.com>
>     dmaengine: ti: k3-udma-glue: fix memory leak when register device fai=
l
>
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>     dmaengine: mv_xor_v2: Fix a resource leak in mv_xor_v2_remove()
>
> Martin Povi=C5=A1er <povik+lin@cutebit.org>
>     dmaengine: apple-admac: Fix grabbing of channels in of_xlate
>
> Fengqian Gao <fengqian.gao@intel.com>
>     dmaengine: idxd: fix RO device state error after been disabled/reset
>
> Xiaochen Shen <xiaochen.shen@intel.com>
>     dmaengine: idxd: Fix max batch size for Intel IAA
>
> Dave Jiang <dave.jiang@intel.com>
>     dmanegine: idxd: reformat opcap output to match bitmap_parse() input
>
> Doug Brown <doug@schmorgal.com>
>     dmaengine: pxa_dma: use platform_get_irq_optional
>
> Xin Long <lucien.xin@gmail.com>
>     tipc: fix the msg->req tlv len check in tipc_nl_compat_name_table_dum=
p_header
>
> YueHaibing <yuehaibing@huawei.com>
>     net: broadcom: Fix BCMGENET Kconfig
>
> Miquel Raynal <miquel.raynal@bootlin.com>
>     dt-bindings: net: tsnep: Fix typo on generic nvmem property
>
> Rasmus Villemoes <linux@rasmusvillemoes.dk>
>     net: stmmac: dwmac-meson8b: fix meson8b_devm_clk_prepare_enable()
>
> Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>
>     drm/i915: Do not set cache_dirty for DGFX
>
> Jouni H=C3=B6gander <jouni.hogander@intel.com>
>     drm/i915/psr: Send update also on invalidate
>
> Zhengchao Shao <shaozhengchao@huawei.com>
>     can: af_can: fix NULL pointer dereference in can_rx_register()
>
> Alexander Potapenko <glider@google.com>
>     ipv6: addrlabel: fix infoleak when sending struct ifaddrlblmsg to net=
work
>
> Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>     platform/x86: p2sb: Don't fail if unknown CPU is found
>
> Lu Wei <luwei32@huawei.com>
>     tcp: prohibit TCP_REPAIR_OPTIONS if data was already sent
>
> Yuan Can <yuancan@huawei.com>
>     drm/vc4: Fix missing platform_unregister_drivers() call in vc4_drm_re=
gister()
>
> HW He <hw.he@mediatek.com>
>     net: wwan: mhi: fix memory leak in mhi_mbim_dellink
>
> HW He <hw.he@mediatek.com>
>     net: wwan: iosm: fix memory leak in ipc_wwan_dellink
>
> Zhengchao Shao <shaozhengchao@huawei.com>
>     hamradio: fix issue of dev reference count leakage in bpq_device_even=
t()
>
> Zhengchao Shao <shaozhengchao@huawei.com>
>     net: lapbether: fix issue of dev reference count leakage in lapbeth_d=
evice_event()
>
> Rafael Mendonca <rafaelmendsr@gmail.com>
>     KVM: s390: pci: Fix allocation size of aift kzdev elements
>
> Nico Boehr <nrb@linux.ibm.com>
>     KVM: s390: pv: don't allow userspace to set the clock under PV
>
> John Thomson <git@johnthomson.fastmail.com.au>
>     phy: ralink: mt7621-pci: add sentinel to quirks table
>
> Gaosheng Cui <cuigaosheng1@huawei.com>
>     capabilities: fix undefined behavior in bit shift for CAP_TO_MASK
>
> Sean Anderson <sean.anderson@seco.com>
>     net: fman: Unregister ethernet device on removal
>
> Alex Barba <alex.barba@broadcom.com>
>     bnxt_en: fix potentially incorrect return value for ndo_rx_flow_steer
>
> Michael Chan <michael.chan@broadcom.com>
>     bnxt_en: Fix possible crash in bnxt_hwrm_set_coal()
>
> Wang Yufen <wangyufen@huawei.com>
>     net: tun: Fix memory leaks of napi_get_frags
>
> Ratheesh Kannoth <rkannoth@marvell.com>
>     octeontx2-pf: NIX TX overwrites SQ_CTX_HW_S[SQ_INT]
>
> Sabrina Dubroca <sd@queasysnail.net>
>     macsec: clear encryption keys from the stack after setting up offload
>
> Sabrina Dubroca <sd@queasysnail.net>
>     macsec: fix detection of RXSCs when toggling offloading
>
> Sabrina Dubroca <sd@queasysnail.net>
>     macsec: fix secy->n_rx_sc accounting
>
> Sabrina Dubroca <sd@queasysnail.net>
>     macsec: delete new rxsc when offload fails
>
> Jiri Benc <jbenc@redhat.com>
>     net: gso: fix panic on frag_list with mixed head alloc types
>
> Youlin Li <liulin063@gmail.com>
>     bpf: Fix wrong reg type conversion in release_reference()
>
> Kumar Kartikeya Dwivedi <memxor@gmail.com>
>     bpf: Add helper macro bpf_for_each_reg_in_vstate
>
> Dexuan Cui <decui@microsoft.com>
>     PCI: hv: Fix the definition of vector in hv_compose_msi_msg()
>
> Cong Wang <cong.wang@bytedance.com>
>     bpf, sock_map: Move cancel_work_sync() out of sock lock
>
> maxime@cerno.tech <maxime@cerno.tech>
>     drm/vc4: hdmi: Fix HSM clock too low on Pi4
>
> Yang Yingliang <yangyingliang@huawei.com>
>     HID: hyperv: fix possible memory leak in mousevsc_probe()
>
> Pu Lehui <pulehui@huawei.com>
>     bpftool: Fix NULL pointer dereference when pin {PROG, MAP, LINK} with=
out FILE
>
> Howard Hsu <howard-yh.hsu@mediatek.com>
>     wifi: mac80211: Set TWT Information Frame Disabled bit as 1
>
> Zhengchao Shao <shaozhengchao@huawei.com>
>     wifi: mac80211: fix general-protection-fault in ieee80211_subif_start=
_xmit()
>
> Wang Yufen <wangyufen@huawei.com>
>     bpf, sockmap: Fix the sk->sk_forward_alloc warning of sk_stream_kill_=
queues
>
> Kees Cook <keescook@chromium.org>
>     bpf, verifier: Fix memory leak in array reallocation for stack state
>
> zhichao.liu <zhichao.liu@mediatek.com>
>     spi: mediatek: Fix package division error
>
> Yang Yingliang <yangyingliang@huawei.com>
>     ALSA: arm: pxa: pxa2xx-ac97-lib: fix return value check of platform_g=
et_irq()
>
> Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>     soundwire: qcom: check for outanding writes before doing a read
>
> Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>     soundwire: qcom: reinit broadcast completion
>
> Arend van Spriel <arend.vanspriel@broadcom.com>
>     wifi: cfg80211: fix memory leak in query_regdb_file()
>
> Johannes Berg <johannes.berg@intel.com>
>     wifi: cfg80211: silence a sparse RCU warning
>
> Dan Carpenter <dan.carpenter@oracle.com>
>     phy: stm32: fix an error code in probe
>
> Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>     hwspinlock: qcom: correct MMIO max register for newer SoCs
>
> Jason Gerecke <killertofu@gmail.com>
>     HID: wacom: Fix logic used for 3rd barrel switch emulation
>
> Dan Williams <dan.j.williams@intel.com>
>     cxl/region: Recycle region ids
>
> Yang Li <yang.lee@linux.alibaba.com>
>     drm/amdkfd: Fix NULL pointer dereference in svm_migrate_to_ram()
>
> Philip Yang <Philip.Yang@amd.com>
>     drm/amdkfd: handle CPU fault on COW mapping
>
> Dillon Varone <Dillon.Varone@amd.com>
>     drm/amd/display: Set memclk levels to be at least 1 for dcn32
>
> Jun Lei <jun.lei@amd.com>
>     drm/amd/display: Limit dcn32 to 1950Mhz display clock
>
> Dillon Varone <Dillon.Varone@amd.com>
>     drm/amd/display: Acquire FCLK DPM levels on DCN32
>
> Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
>     drm/i915/sdvo: Grab mode_config.mutex during LVDS init to avoid WARNs
>
> Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
>     drm/i915: Simplify intel_panel_add_edid_alt_fixed_modes()
>
> Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
>     drm/i915: Allow more varied alternate fixed modes for panels
>
> Hou Wenlong <houwenlong.hwl@antgroup.com>
>     KVM: debugfs: Return retval of simple_attr_open() if it fails
>
> Jason A. Donenfeld <Jason@zx2c4.com>
>     m68k: Rework BI_VIRT_RNG_SEED as BI_RNG_SEED
>
> Jason Gunthorpe <jgg@ziepe.ca>
>     drm/i915/gvt: Add missing vfio_unregister_group_dev() call
>
> Sanjay R Mehta <sanju.mehta@amd.com>
>     thunderbolt: Add DP OUT resource when DP tunnel is discovered
>
>
> -------------
>
> Diffstat:
>
>  .../devicetree/bindings/net/engleder,tsnep.yaml    |   2 +-
>  Documentation/virt/kvm/devices/vm.rst              |   3 +
>  Makefile                                           |   4 +-
>  arch/arm64/kernel/efi.c                            |  52 ++++---
>  arch/m68k/include/uapi/asm/bootinfo-virt.h         |   9 +-
>  arch/m68k/include/uapi/asm/bootinfo.h              |   7 +
>  arch/m68k/kernel/setup_mm.c                        |  12 ++
>  arch/m68k/virt/config.c                            |  11 --
>  arch/mips/kernel/jump_label.c                      |   2 +-
>  arch/riscv/kernel/process.c                        |   2 +
>  arch/riscv/kernel/setup.c                          |   1 +
>  arch/riscv/kernel/vdso/Makefile                    |   2 +-
>  arch/riscv/mm/init.c                               |   1 -
>  arch/s390/kvm/kvm-s390.c                           |  26 ++--
>  arch/s390/kvm/kvm-s390.h                           |   1 -
>  arch/s390/kvm/pci.c                                |   2 +-
>  arch/x86/kernel/asm-offsets.c                      |   6 -
>  arch/x86/kvm/.gitignore                            |   2 +
>  arch/x86/kvm/Makefile                              |  12 ++
>  arch/x86/kvm/kvm-asm-offsets.c                     |  27 ++++
>  arch/x86/kvm/mmu/mmu.c                             |   4 +-
>  arch/x86/kvm/svm/sev.c                             |   2 +-
>  arch/x86/kvm/svm/svm.c                             |  14 +-
>  arch/x86/kvm/svm/svm.h                             |   4 +-
>  arch/x86/kvm/svm/vmenter.S                         | 134 +++++++++++----=
---
>  arch/x86/kvm/vmx/vmenter.S                         |   2 +-
>  arch/x86/kvm/x86.c                                 |  14 +-
>  arch/x86/mm/hugetlbpage.c                          |   4 +
>  drivers/ata/libata-scsi.c                          |   3 +
>  drivers/cxl/core/region.c                          |  20 +++
>  drivers/dma/apple-admac.c                          |   2 +-
>  drivers/dma/at_hdmac.c                             | 153 ++++++++-------=
------
>  drivers/dma/at_hdmac_regs.h                        |  10 +-
>  drivers/dma/idxd/cdev.c                            |  18 +++
>  drivers/dma/idxd/device.c                          |  26 ++--
>  drivers/dma/idxd/idxd.h                            |  34 +++++
>  drivers/dma/idxd/init.c                            |  24 +++-
>  drivers/dma/idxd/registers.h                       |   2 +
>  drivers/dma/idxd/sysfs.c                           |  11 +-
>  drivers/dma/mv_xor_v2.c                            |   1 +
>  drivers/dma/pxa_dma.c                              |   4 +-
>  drivers/dma/stm32-dma.c                            |  14 +-
>  drivers/dma/ti/k3-udma-glue.c                      |   3 +
>  drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h             |  15 ++
>  drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c       |   2 +-
>  drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |  34 ++---
>  drivers/gpu/drm/amd/amdkfd/kfd_events.c            |   3 +-
>  drivers/gpu/drm/amd/amdkfd/kfd_migrate.c           |  49 ++++---
>  .../amd/display/dc/clk_mgr/dcn314/dcn314_clk_mgr.c |  32 ++---
>  .../amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c   |  52 ++++---
>  .../display/dc/dcn314/dcn314_dio_stream_encoder.c  |  24 +++-
>  .../gpu/drm/amd/display/dc/dml/dcn314/dcn314_fpu.c |   4 +-
>  drivers/gpu/drm/amd/display/dc/inc/hw/clk_mgr.h    |  15 +-
>  .../amd/pm/swsmu/inc/pmfw_if/smu_v13_0_4_ppsmc.h   |  15 +-
>  .../drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c    |   4 +-
>  drivers/gpu/drm/i915/display/intel_dp.c            |   2 +-
>  drivers/gpu/drm/i915/display/intel_lvds.c          |   3 +-
>  drivers/gpu/drm/i915/display/intel_panel.c         |  29 ++--
>  drivers/gpu/drm/i915/display/intel_panel.h         |   2 +-
>  drivers/gpu/drm/i915/display/intel_psr.c           |   5 +-
>  drivers/gpu/drm/i915/display/intel_sdvo.c          |   6 +-
>  drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c         |   4 +-
>  drivers/gpu/drm/i915/gem/i915_gem_shmem.c          |   4 +-
>  drivers/gpu/drm/i915/gvt/kvmgt.c                   |   3 +
>  drivers/gpu/drm/vc4/vc4_drv.c                      |   7 +-
>  drivers/gpu/drm/vc4/vc4_hdmi.c                     |  21 ++-
>  drivers/gpu/drm/vc4/vc4_hdmi.h                     |   1 +
>  drivers/hid/hid-hyperv.c                           |   2 +-
>  drivers/hid/wacom_wac.c                            |  11 +-
>  drivers/hwspinlock/qcom_hwspinlock.c               |   2 +-
>  drivers/mmc/host/sdhci-brcmstb.c                   |   3 +-
>  drivers/mmc/host/sdhci-cqhci.h                     |  24 ++++
>  drivers/mmc/host/sdhci-esdhc-imx.c                 |   7 +-
>  drivers/mmc/host/sdhci-of-arasan.c                 |   3 +-
>  drivers/mmc/host/sdhci-tegra.c                     |   3 +-
>  drivers/mmc/host/sdhci_am654.c                     |   7 +-
>  drivers/net/can/at91_can.c                         |   2 +-
>  drivers/net/can/c_can/c_can_main.c                 |   2 +-
>  drivers/net/can/can327.c                           |   2 +-
>  drivers/net/can/cc770/cc770.c                      |   2 +-
>  drivers/net/can/ctucanfd/ctucanfd_base.c           |   2 +-
>  drivers/net/can/dev/skb.c                          |   9 +-
>  drivers/net/can/flexcan/flexcan-core.c             |   2 +-
>  drivers/net/can/grcan.c                            |   2 +-
>  drivers/net/can/ifi_canfd/ifi_canfd.c              |   2 +-
>  drivers/net/can/janz-ican3.c                       |   2 +-
>  drivers/net/can/kvaser_pciefd.c                    |   2 +-
>  drivers/net/can/m_can/m_can.c                      |   2 +-
>  drivers/net/can/mscan/mscan.c                      |   2 +-
>  drivers/net/can/pch_can.c                          |   2 +-
>  drivers/net/can/peak_canfd/peak_canfd.c            |   2 +-
>  drivers/net/can/rcar/rcar_can.c                    |   2 +-
>  drivers/net/can/rcar/rcar_canfd.c                  |  15 +-
>  drivers/net/can/sja1000/sja1000.c                  |   2 +-
>  drivers/net/can/slcan/slcan-core.c                 |   2 +-
>  drivers/net/can/softing/softing_main.c             |   2 +-
>  drivers/net/can/spi/hi311x.c                       |   2 +-
>  drivers/net/can/spi/mcp251x.c                      |   2 +-
>  drivers/net/can/spi/mcp251xfd/mcp251xfd-tx.c       |   2 +-
>  drivers/net/can/sun4i_can.c                        |   2 +-
>  drivers/net/can/ti_hecc.c                          |   2 +-
>  drivers/net/can/usb/ems_usb.c                      |   2 +-
>  drivers/net/can/usb/esd_usb.c                      |   2 +-
>  drivers/net/can/usb/etas_es58x/es58x_core.c        |   2 +-
>  drivers/net/can/usb/gs_usb.c                       |   2 +-
>  drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c   |   2 +-
>  drivers/net/can/usb/mcba_usb.c                     |   2 +-
>  drivers/net/can/usb/peak_usb/pcan_usb_core.c       |   2 +-
>  drivers/net/can/usb/ucan.c                         |   2 +-
>  drivers/net/can/usb/usb_8dev.c                     |   2 +-
>  drivers/net/can/xilinx_can.c                       |   2 +-
>  drivers/net/ethernet/apm/xgene/xgene_enet_main.c   |   4 +-
>  drivers/net/ethernet/aquantia/atlantic/aq_macsec.c |   2 +
>  .../ethernet/aquantia/atlantic/macsec/macsec_api.c |  18 ++-
>  drivers/net/ethernet/broadcom/Kconfig              |   2 +-
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   2 +-
>  drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |   2 +-
>  drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c    |   1 +
>  .../net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c    |   2 +-
>  drivers/net/ethernet/freescale/fman/mac.c          |   9 ++
>  drivers/net/ethernet/intel/iavf/iavf_virtchnl.c    |   2 +
>  drivers/net/ethernet/intel/ice/ice_base.c          |   2 +-
>  drivers/net/ethernet/intel/ice/ice_lib.c           |  25 ++++
>  drivers/net/ethernet/intel/ice/ice_lib.h           |   1 +
>  drivers/net/ethernet/intel/ice/ice_vf_lib.c        |   5 +-
>  drivers/net/ethernet/marvell/mv643xx_eth.c         |   1 +
>  .../ethernet/marvell/octeontx2/nic/otx2_common.c   |   1 +
>  .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   | 135 ++++++++++++++-=
---
>  .../ethernet/marvell/octeontx2/nic/otx2_struct.h   |  57 ++++++++
>  .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |  32 +++--
>  .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.h |   1 +
>  .../net/ethernet/marvell/prestera/prestera_rxtx.c  |   7 +-
>  drivers/net/ethernet/mediatek/mtk_star_emac.c      |   2 +
>  drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |  11 +-
>  .../ethernet/mellanox/mlx5/core/en/rep/bridge.c    |  31 +++++
>  .../ethernet/mellanox/mlx5/core/en/tc/act/act.c    |  92 +++++--------
>  drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |  24 +++-
>  drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   7 +
>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   6 -
>  drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |   5 +
>  drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  14 +-
>  .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  18 +--
>  .../mellanox/mlx5/core/eswitch_offloads_termtbl.c  |  14 +-
>  drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |   3 +-
>  drivers/net/ethernet/neterion/s2io.c               |  29 ++--
>  drivers/net/ethernet/ni/nixge.c                    |   1 +
>  drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c  |  11 +-
>  .../net/ethernet/stmicro/stmmac/dwmac-loongson.c   |  39 ++++--
>  .../net/ethernet/stmicro/stmmac/dwmac-meson8b.c    |   8 +-
>  drivers/net/ethernet/sunplus/spl2sw_driver.c       |   1 -
>  drivers/net/ethernet/ti/am65-cpsw-nuss.c           |   2 +-
>  drivers/net/ethernet/ti/cpsw.c                     |   2 +
>  drivers/net/ethernet/tundra/tsi108_eth.c           |   5 +-
>  drivers/net/hamradio/bpqether.c                    |   2 +-
>  drivers/net/macsec.c                               |  23 ++--
>  drivers/net/macvlan.c                              |   4 +-
>  drivers/net/phy/mscc/mscc_macsec.c                 |   1 +
>  drivers/net/tun.c                                  |  18 ++-
>  drivers/net/wan/lapbether.c                        |   3 +-
>  drivers/net/wireless/ath/ath11k/reg.c              |   6 +-
>  drivers/net/wwan/iosm/iosm_ipc_imem_ops.c          |   8 ++
>  drivers/net/wwan/iosm/iosm_ipc_mux.h               |   1 +
>  drivers/net/wwan/iosm/iosm_ipc_pcie.c              |  11 +-
>  drivers/net/wwan/iosm/iosm_ipc_wwan.c              |   1 +
>  drivers/net/wwan/mhi_wwan_mbim.c                   |   1 +
>  drivers/pci/controller/pci-hyperv.c                |  22 ++-
>  drivers/phy/qualcomm/phy-qcom-qmp-combo.c          |   2 +-
>  drivers/phy/ralink/phy-mt7621-pci.c                |   3 +-
>  drivers/phy/st/phy-stm32-usbphyc.c                 |   2 +
>  drivers/platform/x86/hp-wmi.c                      |  12 +-
>  drivers/platform/x86/p2sb.c                        |  15 +-
>  drivers/soundwire/qcom.c                           |   9 ++
>  drivers/spi/spi-intel.c                            |   8 +-
>  drivers/spi/spi-mt65xx.c                           |  23 ++--
>  drivers/thunderbolt/tb.c                           |  28 ++++
>  fs/btrfs/disk-io.c                                 |   4 +-
>  fs/btrfs/tests/btrfs-tests.c                       |   2 +-
>  fs/btrfs/volumes.c                                 |  39 ++++--
>  fs/btrfs/volumes.h                                 |   2 +-
>  fs/btrfs/zoned.c                                   |  40 ++++++
>  fs/btrfs/zoned.h                                   |  11 ++
>  fs/nilfs2/segment.c                                |  15 +-
>  fs/nilfs2/super.c                                  |   2 -
>  fs/nilfs2/the_nilfs.c                              |   2 -
>  fs/udf/namei.c                                     |   2 +-
>  include/asm-generic/vmlinux.lds.h                  |   2 +-
>  include/linux/bpf_verifier.h                       |  21 +++
>  include/linux/can/dev.h                            |  16 +++
>  include/linux/skmsg.h                              |   2 +-
>  include/uapi/linux/capability.h                    |   2 +-
>  include/uapi/linux/idxd.h                          |   1 +
>  io_uring/kbuf.c                                    |   2 +
>  kernel/bpf/verifier.c                              | 148 ++++++---------=
-----
>  mm/damon/dbgfs.c                                   |   7 +
>  mm/hugetlb_vmemmap.c                               |   1 +
>  mm/memremap.c                                      |   1 +
>  mm/userfaultfd.c                                   |   2 +-
>  net/can/af_can.c                                   |   2 +-
>  net/can/isotp.c                                    |  71 +++++-----
>  net/can/j1939/main.c                               |   3 +
>  net/core/skbuff.c                                  |  36 ++---
>  net/core/skmsg.c                                   |   7 +-
>  net/core/sock_map.c                                |   7 +-
>  net/ipv4/tcp.c                                     |   2 +-
>  net/ipv4/tcp_bpf.c                                 |   8 +-
>  net/ipv6/addrlabel.c                               |   1 +
>  net/mac80211/s1g.c                                 |   3 +
>  net/mac80211/tx.c                                  |   5 +
>  net/mctp/af_mctp.c                                 |   4 +-
>  net/mctp/route.c                                   |   2 +-
>  net/netfilter/nf_tables_api.c                      |   3 +-
>  net/netfilter/nfnetlink.c                          |   1 +
>  net/tipc/netlink_compat.c                          |   2 +-
>  net/wireless/reg.c                                 |  12 +-
>  net/wireless/scan.c                                |   4 +-
>  sound/arm/pxa2xx-ac97-lib.c                        |   4 +-
>  sound/core/memalloc.c                              |  15 +-
>  sound/hda/hdac_sysfs.c                             |   4 +-
>  sound/pci/hda/hda_intel.c                          |   3 +
>  sound/pci/hda/patch_ca0132.c                       |   1 +
>  sound/pci/hda/patch_realtek.c                      |   2 +
>  sound/usb/card.c                                   |  29 ++--
>  sound/usb/quirks-table.h                           |   4 +
>  sound/usb/quirks.c                                 |   1 +
>  tools/bpf/bpftool/common.c                         |   3 +
>  tools/perf/.gitignore                              |   1 +
>  tools/perf/tests/shell/test_brstack.sh             |   5 +-
>  tools/perf/util/parse-branch-options.c             |   4 +-
>  tools/perf/util/stat-display.c                     |   6 +-
>  virt/kvm/kvm_main.c                                |  13 +-
>  230 files changed, 1662 insertions(+), 944 deletions(-)
>
>
