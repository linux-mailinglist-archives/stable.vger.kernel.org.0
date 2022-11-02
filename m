Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9771B616E7D
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 21:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbiKBUVo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 16:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiKBUVn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 16:21:43 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 087EC2705;
        Wed,  2 Nov 2022 13:21:39 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 128so17234667pga.1;
        Wed, 02 Nov 2022 13:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rj8iLYhcYUgebkF2UsROTlZOBY77lAGV8Z7dSlSoG9E=;
        b=R0HTjWDFjL65kyS4WBI9ptHvCNPyy3UmAWPiU1t+3m0zQVxfPYpFAsN5ZYaBDQ/MrR
         BgVYHcjFUJt8XpXhFGDDksOeMDilpOQAQTmJo8GU1nHHJbeTOJP3a8LTkD8FY2dsHL+m
         FEt7dg7AMTYNY3NyfypsWfsYj5ReTY03x6LW1dMMEGKYk7ZH5DpA7rwucdCxRQ+J1B8A
         UaAb4kPMTju4cWQ4F6vXvwToJ1R99MRVfJaJM7iVvRltddPYEVF9H4KkSSinMM3i4eOX
         AF9KrFmG966mXr1dEzttfTfqqZ6gS6gfybMuzeaGcZXa6FJr2UU+bzZzdKSsbmYE6MZ2
         clHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rj8iLYhcYUgebkF2UsROTlZOBY77lAGV8Z7dSlSoG9E=;
        b=aZdlyiW1y6TQKuVYYf/L4/iGSZO/O9zpUi3A/Z4oQSOnEZI/adMJb4f/fm3oQktTGI
         CYQ5mVAaa9twBIxqv7iC/hkOIuBKxBqKEpzrFbEKontiAWvQ1DJMnAs2YyA/tbQ1pYLg
         XVUxKwiXGogWLeaVMNzaO2eq3zHlg+LOiQVNxvsuC6aQBbyPjLCWW/hJX1OjItWjV3+L
         YZa0ZQqr88CWt0gFuGReDBzbOZyfCF+Sj6K8btWQMepx8s2eM3BUaQ6l19tUrCmV9nGy
         uXv6i2eBrTnDEbtzODEFy6YTH23xvqxbYuA9RQ0HFWwfEqBCaZEwgKDI7/93vubjjS8Z
         s2zQ==
X-Gm-Message-State: ACrzQf2KdPJOAFJ2EnS/EGzYLV6Ic5cfIXzAZAUEJ1u+5PLKzAPCmQzC
        rwIsmgRnqhaP1bbfEMa0+VYs5g8sOEnSwVddUSQ=
X-Google-Smtp-Source: AMsMyM4CNao1viA30JZBliLEMkUcuIZJBpAR82EVoHeIbW78w/ffZhhg/QR7ARGimEip9s7a9vxiHJG1AdVBBys0E3g=
X-Received: by 2002:a63:ef48:0:b0:470:3fc:c475 with SMTP id
 c8-20020a63ef48000000b0047003fcc475mr6109210pgk.333.1667420498109; Wed, 02
 Nov 2022 13:21:38 -0700 (PDT)
MIME-Version: 1.0
References: <20221102022111.398283374@linuxfoundation.org>
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Wed, 2 Nov 2022 13:21:27 -0700
Message-ID: <CAJq+SaB8Ri9NoX8yQd4L8gx6tXBpriRa6km2+Lys5KmheUoFkg@mail.gmail.com>
Subject: Re: [PATCH 6.0 000/240] 6.0.7-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
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

> This is the start of the stable review cycle for the 6.0.7 release.
> There are 240 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.0.7-rc1.gz
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
>     Linux 6.0.7-rc1
>
> Kuniyuki Iwashima <kuniyu@amazon.com>
>     tcp/udp: Fix memory leak in ipv6_renew_options().
>
> D Scott Phillips <scott@os.amperecomputing.com>
>     arm64: Add AMPERE1 to the Spectre-BHB affected list
>
> Conor Dooley <conor.dooley@microchip.com>
>     riscv: fix detection of toolchain Zihintpause support
>
> Conor Dooley <conor.dooley@microchip.com>
>     riscv: fix detection of toolchain Zicbom support
>
> Qinglin Pan <panqinglin2020@iscas.ac.cn>
>     riscv: mm: add missing memcpy in kasan_init
>
> Vladimir Oltean <vladimir.oltean@nxp.com>
>     net: enetc: survive memory pressure without crashing
>
> Eric Dumazet <edumazet@google.com>
>     kcm: do not sense pfmemalloc status in kcm_sendpage()
>
> Eric Dumazet <edumazet@google.com>
>     net: do not sense pfmemalloc status in skb_append_pagefrags()
>
> Suresh Devarakonda <ramad@nvidia.com>
>     net/mlx5: Fix crash during sync firmware reset
>
> Roy Novich <royno@nvidia.com>
>     net/mlx5: Update fw fatal reporter state on PCI handlers successful r=
ecover
>
> Ariel Levkovich <lariel@nvidia.com>
>     net/mlx5e: TC, Reject forwarding from internal port to internal port
>
> Tariq Toukan <tariqt@nvidia.com>
>     net/mlx5: Fix possible use-after-free in async command interface
>
> Saeed Mahameed <saeedm@nvidia.com>
>     net/mlx5: ASO, Create the ASO SQ with the correct timestamp format
>
> Paul Blakey <paulb@nvidia.com>
>     net/mlx5e: Update restore chain id for slow path packets
>
> Aya Levin <ayal@nvidia.com>
>     net/mlx5e: Extend SKB room check to include PTP-SQ
>
> Rongwei Liu <rongweil@nvidia.com>
>     net/mlx5: DR, Fix matcher disconnect error flow
>
> Moshe Shemesh <moshe@nvidia.com>
>     net/mlx5: Wait for firmware to enable CRS before pci_restore_state
>
> Hyong Youb Kim <hyonkim@cisco.com>
>     net/mlx5e: Do not increment ESN when updating IPsec ESN state
>
> Zhengchao Shao <shaozhengchao@huawei.com>
>     netdevsim: remove dir in nsim_dev_debugfs_init() when creating ports =
dir failed
>
> Zhengchao Shao <shaozhengchao@huawei.com>
>     netdevsim: fix memory leak in nsim_drv_probe() when nsim_dev_resource=
s_register() failed
>
> Zhengchao Shao <shaozhengchao@huawei.com>
>     netdevsim: fix memory leak in nsim_bus_dev_new()
>
> Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>     net: broadcom: bcm4908_enet: update TX stats after actual transmissio=
n
>
> Nicolas Dichtel <nicolas.dichtel@6wind.com>
>     nh: fix scope used to find saddr when adding non gw nh
>
> Florian Fainelli <f.fainelli@gmail.com>
>     net: bcmsysport: Indicate MAC is in charge of PHY PM
>
> Yang Yingliang <yangyingliang@huawei.com>
>     net: ehea: fix possible memory leak in ehea_register_port()
>
> Aaron Conole <aconole@redhat.com>
>     openvswitch: switch from WARN to pr_warn
>
> Takashi Iwai <tiwai@suse.de>
>     ALSA: aoa: Fix I2S device accounting
>
> Yang Yingliang <yangyingliang@huawei.com>
>     ALSA: aoa: i2sbus: fix possible memory leak in i2sbus_add_dev()
>
> Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
>     net: ethernet: ave: Fix MAC to be in charge of PHY PM
>
> Juergen Borleis <jbe@pengutronix.de>
>     net: fec: limit register access on i.MX6UL
>
> Shang XiaoJing <shangxiaojing@huawei.com>
>     perf vendor events arm64: Fix incorrect Hisi hip08 L3 metrics
>
> Sudeep Holla <sudeep.holla@arm.com>
>     PM: domains: Fix handling of unavailable/disabled idle states
>
> Jisheng Zhang <jszhang@kernel.org>
>     riscv: jump_label: mark arguments as const to satisfy asm constraints
>
> Yang Yingliang <yangyingliang@huawei.com>
>     net: ksz884x: fix missing pci_disable_device() on error in pcidev_ini=
t()
>
> Slawomir Laba <slawomirx.laba@intel.com>
>     i40e: Fix flow-type by setting GL_HASH_INSET registers
>
> Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
>     i40e: Fix VF hang when reset is triggered on another VF
>
> Slawomir Laba <slawomirx.laba@intel.com>
>     i40e: Fix ethtool rx-flow-hash setting for X722
>
> Eric Dumazet <edumazet@google.com>
>     ipv6: ensure sane device mtu in tunnels
>
> Thomas Richter <tmricht@linux.ibm.com>
>     perf list: Fix PMU name pai_crypto in perf list on s390
>
> Kajol Jain <kjain@linux.ibm.com>
>     perf vendor events power10: Fix hv-24x7 metric events
>
> Hans Verkuil <hverkuil-cisco@xs4all.nl>
>     media: vivid: set num_in/outputs to 0 if not supported
>
> Hans Verkuil <hverkuil-cisco@xs4all.nl>
>     media: videodev2.h: V4L2_DV_BT_BLANKING_HEIGHT should check 'interlac=
ed'
>
> Hans Verkuil <hverkuil-cisco@xs4all.nl>
>     media: v4l2-dv-timings: add sanity checks for blanking values
>
> Hans Verkuil <hverkuil-cisco@xs4all.nl>
>     media: vivid: dev->bitmap_cap wasn't freed in all cases
>
> Hans Verkuil <hverkuil-cisco@xs4all.nl>
>     media: vivid: s_fbuf: add more sanity checks
>
> Mario Limonciello <mario.limonciello@amd.com>
>     PM: hibernate: Allow hybrid sleep to work with s2idle
>
> Dongliang Mu <dzm91@hust.edu.cn>
>     can: mcp251x: mcp251x_can_probe(): add missing unregister_candev() in=
 error path
>
> Dongliang Mu <dzm91@hust.edu.cn>
>     can: mscan: mpc5xxx: mpc5xxx_can_probe(): add missing put_clock() in =
error path
>
> Paolo Abeni <pabeni@redhat.com>
>     mptcp: set msk local address earlier
>
> Horatiu Vultur <horatiu.vultur@microchip.com>
>     net: lan966x: Stop replacing tx dcbs and dcbs_buf when changing MTU
>
> Rafael Mendonca <rafaelmendsr@gmail.com>
>     drm/amdkfd: Fix memory leak in kfd_mem_dmamap_userptr()
>
> Jakub Kicinski <kuba@kernel.org>
>     net-memcg: avoid stalls when under memory pressure
>
> Neal Cardwell <ncardwell@google.com>
>     tcp: fix indefinite deferral of RTO with SACK reneging
>
> Lu Wei <luwei32@huawei.com>
>     tcp: fix a signed-integer-overflow bug in tcp_add_backlog()
>
> Zhang Changzhong <zhangchangzhong@huawei.com>
>     net: lantiq_etop: don't free skb when returning NETDEV_TX_BUSY
>
> Zhengchao Shao <shaozhengchao@huawei.com>
>     net: fix UAF issue in nfqnl_nf_hook_drop() when ops_init() failed
>
> Eric Dumazet <edumazet@google.com>
>     kcm: annotate data-races around kcm->rx_wait
>
> Eric Dumazet <edumazet@google.com>
>     kcm: annotate data-races around kcm->rx_psock
>
> =C3=8D=C3=B1igo Huguet <ihuguet@redhat.com>
>     atlantic: fix deadlock at aq_nic_stop
>
> Ankit Nautiyal <ankit.k.nautiyal@intel.com>
>     drm/i915/dp: Reset frl trained flag before restarting FRL training
>
> Anshuman Gupta <anshuman.gupta@intel.com>
>     drm/i915/dgfx: Keep PCI autosuspend control 'on' by default on all dG=
PU
>
> Raju Rangoju <Raju.Rangoju@amd.com>
>     amd-xgbe: add the bit rate quirk for Molex cables
>
> Raju Rangoju <Raju.Rangoju@amd.com>
>     amd-xgbe: fix the SFP compliance codes check for DAC cables
>
> Raju Rangoju <Raju.Rangoju@amd.com>
>     amd-xgbe: Yellow carp devices do not need rrc
>
> Chang S. Bae <chang.seok.bae@intel.com>
>     x86/fpu: Fix copy_xstate_to_uabi() to copy init states correctly
>
> Douglas Anderson <dianders@chromium.org>
>     drm/bridge: ps8640: Add back the 50 ms mystery delay after HPD
>
> Chen Zhongjin <chenzhongjin@huawei.com>
>     x86/unwind/orc: Fix unreliable stack dump with gcov
>
> Anup Patel <apatel@ventanamicro.com>
>     RISC-V: KVM: Fix kvm_riscv_vcpu_timer_pending() for Sstc
>
> Andrew Jones <ajones@ventanamicro.com>
>     RISC-V: Fix compilation without RISCV_ISA_ZICBOM
>
> Andrew Jones <ajones@ventanamicro.com>
>     RISC-V: KVM: Provide UAPI for Zicbom block size
>
> Shang XiaoJing <shangxiaojing@huawei.com>
>     nfc: virtual_ncidev: Fix memory leak in virtual_nci_send()
>
> Sergiu Moga <sergiu.moga@microchip.com>
>     net: macb: Specify PHY PM management done by MAC
>
> Zhengchao Shao <shaozhengchao@huawei.com>
>     net: hinic: fix the issue of double release MBOX callback of VF
>
> Zhengchao Shao <shaozhengchao@huawei.com>
>     net: hinic: fix the issue of CMDQ memory leaks
>
> Zhengchao Shao <shaozhengchao@huawei.com>
>     net: hinic: fix memory leak when reading function table
>
> Zhengchao Shao <shaozhengchao@huawei.com>
>     net: hinic: fix incorrect assignment issue in hinic_set_interrupt_cfg=
()
>
> Benjamin Poirier <bpoirier@nvidia.com>
>     selftests: net: Fix netdev name mismatch in cleanup
>
> Benjamin Poirier <bpoirier@nvidia.com>
>     selftests: net: Fix cross-tree inclusion of scripts
>
> Horatiu Vultur <horatiu.vultur@microchip.com>
>     net: lan966x: Fix the rx drop counter
>
> Yang Yingliang <yangyingliang@huawei.com>
>     net: netsec: fix error handling in netsec_register_mdio()
>
> Xin Long <lucien.xin@gmail.com>
>     tipc: fix a null-ptr-deref in tipc_topsrv_accept
>
> Paul E. McKenney <paulmck@kernel.org>
>     rcu: Keep synchronize_rcu() from enabling irqs in early boot
>
> Maxim Levitsky <mlevitsk@redhat.com>
>     perf/x86/intel/lbr: Use setup_clear_cpu_cap() instead of clear_cpu_ca=
p()
>
> Yang Yingliang <yangyingliang@huawei.com>
>     ALSA: ac97: fix possible memory leak in snd_ac97_dev_register()
>
> Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
>     ASoC: SOF: Intel: pci-tgl: fix ADL-N descriptor
>
> Kai Vehmanen <kai.vehmanen@linux.intel.com>
>     ASoC: SOF: Intel: pci-tgl: use RPL specific firmware definitions
>
> Kai Vehmanen <kai.vehmanen@linux.intel.com>
>     ASoC: Intel: common: add ACPI matching tables for Raptor Lake
>
> Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>
>     ASoC: qcom: lpass-cpu: Mark HDMI TX parity register as volatile
>
> C=C3=A9dric Le Goater <clg@kaod.org>
>     spi: aspeed: Fix window offset of CE1
>
> Sven Schnelle <svens@linux.ibm.com>
>     selftests/ftrace: fix dynamic_events dependency check
>
> Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
>     ASoC: SOF: Intel: pci-mtl: fix firmware name
>
> Geert Uytterhoeven <geert@linux-m68k.org>
>     ASoC: codecs: tlv320adc3xxx: Wrap adc3xxx_i2c_remove() in __exit_p()
>
> Horatiu Vultur <horatiu.vultur@microchip.com>
>     pinctrl: ocelot: Fix incorrect trigger of the interrupt.
>
> Yang Yingliang <yangyingliang@huawei.com>
>     mtd: rawnand: intel: Add missing of_node_put() in ebu_nand_probe()
>
> Martin Blumenstingl <martin.blumenstingl@googlemail.com>
>     mtd: rawnand: intel: Use devm_platform_ioremap_resource_byname()
>
> Martin Blumenstingl <martin.blumenstingl@googlemail.com>
>     mtd: rawnand: intel: Remove unused nand_pa member from ebu_nand_cs
>
> Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>     mtd: core: add missing of_node_get() in dynamic partitions code
>
> Randy Dunlap <rdunlap@infradead.org>
>     arc: iounmap() arg is volatile
>
> Stanislav Fomichev <sdf@google.com>
>     bpf: prevent decl_tag from being referenced in func_proto
>
> Lin Shengwang <linshengwang1@huawei.com>
>     sched/core: Fix comparison in sched_group_cookie_match()
>
> Peter Zijlstra <peterz@infradead.org>
>     perf: Fix missing SIGTRAPs
>
> Chang S. Bae <chang.seok.bae@intel.com>
>     x86/fpu: Exclude dynamic states from init_fpstate
>
> Chang S. Bae <chang.seok.bae@intel.com>
>     x86/fpu: Fix the init_fpstate size check with the actual size
>
> Chang S. Bae <chang.seok.bae@intel.com>
>     x86/fpu: Configure init_fpstate attributes orderly
>
> Robert Marko <robert.marko@sartura.hr>
>     spi: qup: support using GPIO as chip select line
>
> Douglas Anderson <dianders@chromium.org>
>     pinctrl: qcom: Avoid glitching lines when we first mux to output
>
> Gao Xiang <xiang@kernel.org>
>     erofs: fix up inplace decompression success rate
>
> Yue Hu <huyue2@coolpad.com>
>     erofs: fix illegal unmapped accesses in z_erofs_fill_inode_lazy()
>
> Rob Clark <robdclark@chromium.org>
>     drm/msm/a6xx: Fix kvzalloc vs state_kcalloc usage
>
> Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>
>     ASoC: qcom: lpass-cpu: mark HDMI TX registers as volatile
>
> Gavin Shan <gshan@redhat.com>
>     KVM: selftests: Fix number of pages for memory slot in memslot_modifi=
cation_stress_test
>
> Randy Dunlap <rdunlap@infradead.org>
>     ASoC: codec: tlv320adc3xxx: add GPIOLIB dependency
>
> Kuogee Hsieh <quic_khsieh@quicinc.com>
>     drm/msm/dp: cleared DP_DOWNSPREAD_CTRL register before start link tra=
ining
>
> Nathan Huckleberry <nhuck@google.com>
>     drm/msm: Fix return type of mdp4_lvds_connector_mode_valid
>
> Kuogee Hsieh <quic_khsieh@quicinc.com>
>     drm/msm/dp: add atomic_check to bridge ops
>
> Akhil P Oommen <quic_akhilpo@quicinc.com>
>     drm/msm/a6xx: Replace kcalloc() with kvzalloc()
>
> Paul Kocialkowski <paul.kocialkowski@bootlin.com>
>     media: cedrus: Add a Kconfig dependency on RESET_CONTROLLER
>
> Paul Kocialkowski <paul.kocialkowski@bootlin.com>
>     media: sun8i-rotate: Add a Kconfig dependency on RESET_CONTROLLER
>
> Paul Kocialkowski <paul.kocialkowski@bootlin.com>
>     media: sun8i-di: Add a Kconfig dependency on RESET_CONTROLLER
>
> Paul Kocialkowski <paul.kocialkowski@bootlin.com>
>     media: sun4i-csi: Add a Kconfig dependency on RESET_CONTROLLER
>
> Paul Kocialkowski <paul.kocialkowski@bootlin.com>
>     media: sun6i-csi: Add a Kconfig dependency on RESET_CONTROLLER
>
> Paul Kocialkowski <paul.kocialkowski@bootlin.com>
>     media: sun8i-a83t-mipi-csi2: Add a Kconfig dependency on RESET_CONTRO=
LLER
>
> Paul Kocialkowski <paul.kocialkowski@bootlin.com>
>     media: sun6i-mipi-csi2: Add a Kconfig dependency on RESET_CONTROLLER
>
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>     media: sunxi: Fix some error handling path of sun6i_mipi_csi2_probe()
>
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>     media: sunxi: Fix some error handling path of sun8i_a83t_mipi_csi2_pr=
obe()
>
> Dan Carpenter <dan.carpenter@oracle.com>
>     media: atomisp: prevent integer overflow in sh_css_set_black_frame()
>
> Sakari Ailus <sakari.ailus@linux.intel.com>
>     media: sun6i-mipi-csi2: Depend on PHY_SUN6I_MIPI_DPHY
>
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>     media: ov8865: Fix an error handling path in ov8865_probe()
>
> Sakari Ailus <sakari.ailus@linux.intel.com>
>     media: ar0521: Fix return value check in writing initial registers
>
> Yang Yingliang <yangyingliang@huawei.com>
>     media: ar0521: fix error return code in ar0521_power_on()
>
> Alexander Stein <alexander.stein@ew.tq-group.com>
>     media: v4l2: Fix v4l2_i2c_subdev_set_name function documentation
>
> Ming Qian <ming.qian@nxp.com>
>     media: amphion: release m2m ctx when releasing vpu instance
>
> Wei Yongjun <weiyongjun1@huawei.com>
>     net: ieee802154: fix error return code in dgram_bind()
>
> Nicholas Piggin <npiggin@gmail.com>
>     powerpc/64s/interrupt: Fix clear of PACA_IRQS_HARD_DIS when returning=
 to soft-masked context
>
> Manank Patel <pmanank200502@gmail.com>
>     ACPI: PCC: Fix unintentional integer overflow
>
> Micha=C5=82 Miros=C5=82aw <mirq-linux@rere.qmqm.pl>
>     fbdev/core: Avoid uninitialized read in aperture_remove_conflicting_p=
ci_device()
>
> Xin Long <lucien.xin@gmail.com>
>     ethtool: eeprom: fix null-deref on genl_info in dump
>
> Heiko Carstens <hca@linux.ibm.com>
>     s390/pci: add missing EX_TABLE entries to __pcistg_mio_inuser()/__pci=
lg_mio_inuser()
>
> Heiko Carstens <hca@linux.ibm.com>
>     s390/futex: add missing EX_TABLE entry to __futex_atomic_op()
>
> Heiko Carstens <hca@linux.ibm.com>
>     s390/uaccess: add missing EX_TABLE entries to __clear_user()
>
> Peter Oberparleiter <oberpar@linux.ibm.com>
>     s390/cio: fix out-of-bounds access on cio_ignore free
>
> Peter Oberparleiter <oberpar@linux.ibm.com>
>     s390/boot: add secure boot trailer
>
> Adrian Hunter <adrian.hunter@intel.com>
>     perf auxtrace: Fix address filter symbol name match for modules
>
> Pavel Kozlov <pavel.kozlov@synopsys.com>
>     ARC: mm: fix leakage of memory allocated for PTE
>
> Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>
>     Revert "pinctrl: pinctrl-zynqmp: Add support for output-enable and bi=
as-high-impedance"
>
> Siarhei Volkau <lis8215@gmail.com>
>     pinctrl: Ingenic: JZ4755 bug fixes
>
> Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>
>     Revert "dt-bindings: pinctrl-zynqmp: Add output-enable configuration"
>
> Christian A. Ehrhardt <lk@c--e.de>
>     kernfs: fix use-after-free in __kernfs_remove
>
> Hugh Dickins <hughd@google.com>
>     mm: prep_compound_tail() clear page->private
>
> Mel Gorman <mgorman@techsingularity.net>
>     mm/huge_memory: do not clobber swp_entry_t during THP split
>
> Waiman Long <longman@redhat.com>
>     mm/kmemleak: prevent soft lockup in kmemleak_scan()'s object iteratio=
n loops
>
> Rik van Riel <riel@surriel.com>
>     mm,madvise,hugetlb: fix unexpected data loss with MADV_DONTNEED on hu=
getlbfs
>
> Baolin Wang <baolin.wang@linux.alibaba.com>
>     mm: migrate: fix return value if all subpages of THPs are migrated su=
ccessfully
>
> Peter Xu <peterx@redhat.com>
>     mm/uffd: fix vma check on userfault for wp
>
> William Breathitt Gray <william.gray@linaro.org>
>     counter: 104-quad-8: Fix race getting function mode and direction
>
> William Breathitt Gray <william.gray@linaro.org>
>     counter: microchip-tcb-capture: Handle Signal1 read and Synapse
>
> Sascha Hauer <s.hauer@pengutronix.de>
>     mmc: sdhci-esdhc-imx: Propagate ESDHC_FLAG_HS400* only on 8bit bus
>
> Patrick Thompson <ptf@google.com>
>     mmc: sdhci-pci-core: Disable ES for ASUS BIOS on Jasper Lake
>
> Vincent Whitchurch <vincent.whitchurch@axis.com>
>     mmc: core: Fix WRITE_ZEROES CQE handling
>
> Matthew Ma <mahongwei@zeku.com>
>     mmc: core: Fix kernel panic when remove non-standard SDIO card
>
> Christian L=C3=B6hle <CLoehle@hyperstone.com>
>     mmc: queue: Cancel recovery work on cleanup
>
> Christian L=C3=B6hle <CLoehle@hyperstone.com>
>     mmc: block: Remove error check of hw_reset on reset
>
> Brian Norris <briannorris@chromium.org>
>     mmc: sdhci_am654: 'select', not 'depends' REGMAP_MMIO
>
> James Clark <james.clark@arm.com>
>     coresight: cti: Fix hang in cti_disable_hw()
>
> Jean-Philippe Brucker <jean-philippe@linaro.org>
>     random: use arch_get_random*_early() in random_init()
>
> Nathan Huckleberry <nhuck@google.com>
>     crypto: x86/polyval - Fix crashes when keys are not 16-byte aligned
>
> Johan Hovold <johan+linaro@kernel.org>
>     drm/msm/dp: fix bridge lifetime
>
> Johan Hovold <johan+linaro@kernel.org>
>     drm/msm/dp: fix IRQ lifetime
>
> Johan Hovold <johan+linaro@kernel.org>
>     drm/msm/dp: fix aux-bus EP lifetime
>
> Johan Hovold <johan+linaro@kernel.org>
>     drm/msm/dp: fix memory corruption with too many bridges
>
> Johan Hovold <johan+linaro@kernel.org>
>     drm/msm/hdmi: fix IRQ lifetime
>
> Johan Hovold <johan+linaro@kernel.org>
>     drm/msm/hdmi: fix memory corruption with too many bridges
>
> Johan Hovold <johan+linaro@kernel.org>
>     drm/msm/dsi: fix memory corruption with too many bridges
>
> Johan Hovold <johan+linaro@kernel.org>
>     drm/msm: fix use-after-free on probe deferral
>
> Jesse Zhang <jesse.zhang@amd.com>
>     drm/amdkfd: correct the cache info for gfx1036
>
> Prike Liang <Prike.Liang@amd.com>
>     drm/amdkfd: update gfx1037 Lx cache setting
>
> Joaqu=C3=ADn Ignacio Aramend=C3=ADa <samsagax@gmail.com>
>     drm/amd/display: Revert logic for plane modifiers
>
> Chengming Gui <Jack.Gui@amd.com>
>     drm/amdgpu: fix pstate setting issue
>
> Prike Liang <Prike.Liang@amd.com>
>     drm/amdgpu: disallow gfxoff until GC IP blocks complete s2idle resume
>
> Lijo Lazar <lijo.lazar@amd.com>
>     drm/amdgpu: Remove ATC L2 access for MMHUB 2.1.x
>
> Jos=C3=A9 Roberto de Souza <jose.souza@intel.com>
>     drm/i915: Extend Wa_1607297627 to Alderlake-P
>
> Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
>     drm/amdgpu: Fix for BO move issue
>
> Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
>     drm/amdgpu: Fix VRAM BO swap issue
>
> Manish Rangankar <mrangankar@marvell.com>
>     scsi: qla2xxx: Use transport-defined speed mask for supported_speeds
>
> Miquel Raynal <miquel.raynal@bootlin.com>
>     mac802154: Fix LQI recording
>
> Bernd Edlinger <bernd.edlinger@hotmail.de>
>     exec: Copy oldsighand->action under spin-lock
>
> Li Zetao <lizetao1@huawei.com>
>     fs/binfmt_elf: Fix memory leak in load_elf_binary()
>
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>     cpufreq: intel_pstate: hybrid: Use known scaling factor for P-cores
>
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>     cpufreq: intel_pstate: Read all MSRs on the target CPU
>
> Hyunwoo Kim <imv4bel@gmail.com>
>     fbdev: smscufx: Fix several use-after-free bugs
>
> Helge Deller <deller@gmx.de>
>     fbdev: stifb: Fall back to cfb_fillrect() on 32-bit HCRX cards
>
> Matti Vaittinen <mazziesaccount@gmail.com>
>     iio: adxl367: Fix unsafe buffer attributes
>
> Matti Vaittinen <mazziesaccount@gmail.com>
>     iio: adxl372: Fix unsafe buffer attributes
>
> Cosmin Tanislav <cosmin.tanislav@analog.com>
>     iio: temperature: ltc2983: allocate iio channels once
>
> Shreeya Patel <shreeya.patel@collabora.com>
>     iio: light: tsl2583: Fix module unloading
>
> Matti Vaittinen <mazziesaccount@gmail.com>
>     tools: iio: iio_utils: fix digit calculation
>
> Mathias Nyman <mathias.nyman@linux.intel.com>
>     xhci: Remove device endpoints from bandwidth list when freeing the de=
vice
>
> Mario Limonciello <mario.limonciello@amd.com>
>     xhci-pci: Set runtime PM as default policy on all xHC 1.2 or later de=
vices
>
> Mathias Nyman <mathias.nyman@linux.intel.com>
>     xhci: Add quirk to reset host back to default state at shutdown
>
> Phillip Lougher <phillip@squashfs.org.uk>
>     squashfs: fix buffer release race condition in readahead code
>
> Phillip Lougher <phillip@squashfs.org.uk>
>     squashfs: fix extending readahead beyond end of file
>
> Phillip Lougher <phillip@squashfs.org.uk>
>     squashfs: fix read regression introduced in readahead code
>
> Tony O'Brien <tony.obrien@alliedtelesis.co.nz>
>     mtd: rawnand: marvell: Use correct logic for nand-keep-config
>
> Linus Walleij <linus.walleij@linaro.org>
>     mtd: parsers: bcm47xxpart: Fix halfblock reads
>
> Mika Westerberg <mika.westerberg@linux.intel.com>
>     mtd: spi-nor: core: Ignore -ENOTSUPP in spi_nor_init()
>
> Zhang Qilong <zhangqilong3@huawei.com>
>     mtd: rawnand: tegra: Fix PM disable depth imbalance in probe
>
> Jens Glathe <jens.glathe@oldschoolsolutions.biz>
>     usb: xhci: add XHCI_SPURIOUS_SUCCESS to ASM1042 despite being a V0.96=
 controller
>
> Justin Chen <justinpopo6@gmail.com>
>     usb: bdc: change state when port disconnected
>
> Andrey Smirnov <andrew.smirnov@gmail.com>
>     usb: dwc3: Don't switch OTG -> peripheral if extcon is present
>
> Patrice Chotard <patrice.chotard@foss.st.com>
>     usb: dwc3: st: Rely on child's compatible instead of name
>
> Heikki Krogerus <heikki.krogerus@linux.intel.com>
>     usb: typec: ucsi: acpi: Implement resume callback
>
> Heikki Krogerus <heikki.krogerus@linux.intel.com>
>     usb: typec: ucsi: Check the connection on resume
>
> Thinh Nguyen <Thinh.Nguyen@synopsys.com>
>     usb: dwc3: gadget: Don't delay End Transfer on delayed_status
>
> Wesley Cheng <quic_wcheng@quicinc.com>
>     usb: dwc3: gadget: Force sending delayed status during soft disconnec=
t
>
> Thinh Nguyen <Thinh.Nguyen@synopsys.com>
>     usb: dwc3: gadget: Don't set IMI for no_interrupt
>
> Thinh Nguyen <Thinh.Nguyen@synopsys.com>
>     usb: dwc3: gadget: Stop processing more requests on IMI
>
> Joel Stanley <joel@jms.id.au>
>     usb: gadget: aspeed: Fix probe regression
>
> Jeff Vanhoof <qjv001@motorola.com>
>     usb: gadget: uvc: fix sg handling during video encode
>
> Dan Vacura <w36195@motorola.com>
>     usb: gadget: uvc: fix sg handling in error case
>
> Dan Vacura <w36195@motorola.com>
>     usb: gadget: uvc: fix dropped frame after missed isoc
>
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Revert "usb: gadget: uvc: limit isoc_sg to super speed gadgets"
>
> Michael Grzeschik <m.grzeschik@pengutronix.de>
>     usb: gadget: uvc: limit isoc_sg to super speed gadgets
>
> Hannu Hartikainen <hannu@hrtk.in>
>     USB: add RESET_RESUME quirk for NVIDIA Jetson devices in RCM
>
> Jason A. Donenfeld <Jason@zx2c4.com>
>     ALSA: rme9652: use explicitly signed char
>
> Jason A. Donenfeld <Jason@zx2c4.com>
>     ALSA: au88x0: use explicitly signed char
>
> Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
>     ALSA: ca0106: Use snd_ctl_rename() to rename a control
>
> Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
>     ALSA: usb-audio: Use snd_ctl_rename() to rename a control
>
> Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
>     ALSA: ac97: Use snd_ctl_rename() to rename a control
>
> Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
>     ALSA: emu10k1: Use snd_ctl_rename() to rename a control
>
> Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
>     ALSA: hda/realtek: Use snd_ctl_rename() to rename a control
>
> Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
>     ALSA: control: add snd_ctl_rename()
>
> Takashi Iwai <tiwai@suse.de>
>     ALSA: hda/realtek: Add another HP ZBook G9 model quirks
>
> Takashi Iwai <tiwai@suse.de>
>     ALSA: usb-audio: Add quirks for M-Audio Fast Track C400/600
>
> Stefan Binding <sbinding@opensource.cirrus.com>
>     ALSA: hda/realtek: Add quirk for ASUS Zenbook using CS35L41
>
> Steven Rostedt (Google) <rostedt@goodmis.org>
>     ALSA: Use del_timer_sync() before freeing timer
>
> Biju Das <biju.das.jz@bp.renesas.com>
>     can: rcar_canfd: fix channel specific IRQ handling for RZ/G2L
>
> Biju Das <biju.das.jz@bp.renesas.com>
>     can: rcar_canfd: rcar_canfd_handle_global_receive(): fix IRQ storm on=
 global FIFO receive
>
> Anssi Hannula <anssi.hannula@bitwise.fi>
>     can: kvaser_usb: Fix possible completions during init_completion
>
> Yang Yingliang <yangyingliang@huawei.com>
>     can: j1939: transport: j1939_session_skb_drop_old(): spin_unlock_irqr=
estore() before kfree_skb()
>
> Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
>     platform/x86/amd: pmc: remove CONFIG_DEBUG_FS checks
>


Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
