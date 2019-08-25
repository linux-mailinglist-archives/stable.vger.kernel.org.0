Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5C4B9C4C4
	for <lists+stable@lfdr.de>; Sun, 25 Aug 2019 17:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728158AbfHYPx6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Aug 2019 11:53:58 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43625 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727050AbfHYPx6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Aug 2019 11:53:58 -0400
Received: by mail-pf1-f196.google.com with SMTP id v12so9962092pfn.10;
        Sun, 25 Aug 2019 08:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FDl+OPYvzNcmHiVejML7TYhhlj9FdlDLFIRxJ//0FWU=;
        b=TItu/FenacBkqkBUJnmvtZG2+DniG/yHGd2S8RKbT+sapVtu+/uHEi1Dh/cP8pDPle
         xLT88J/ORaVwydZ+vW7a5A7Rd5ZU8ddBYN6FnxunLQ6oDFui1hjsQ//GUzSvAPQP5vVW
         /VeG43LWApiwAGleo8ERh18zpEpJDFXUXnYcFBoYjHtKF5BeGDiRchlVoQjffJYjlWSf
         Uiu9JC5gBGeQiOdBOhKNUnwRV6FfvPj/yflRo5UcToU1p51Tn6Kz9AG0Wr0CchO0s1+C
         UiHZp+0b8LqVxzEk+PTCr0U7GHKn1xn4XYEFbbPFufikZbzYvZ8XV8SmW/ZHS5a4Y2ru
         ouNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FDl+OPYvzNcmHiVejML7TYhhlj9FdlDLFIRxJ//0FWU=;
        b=uEq0vyEUHaCvQ8gGVuWWOX78T5+rjdGN8RQOv5xvFlBK/JLh4H0SNsBnDlwPpICc6j
         YuFNPjiNZDW34ZotyHWknF33HwUs0o3JVymsJVcNnFmtju8W4KIj6OjVB/z408RYeDD1
         Kn4XKFsEipI0NzPjrigrmn+h7D5srDzGSubzAhjsPnV7LjZUoLaM77GMwyTbtksDwtEe
         HJVPDr00Gi7Y2Z3oNAMSUcKFOMnKmjDyUohHpDTxjtA+0f5Sz7qE7IC/fkDP0fzzCpRD
         k4rWHIWXYOBC/hd4ZcGGP6/sdZN7JtieHrH7MxewzOqfS3D3sFVM3uWtCBCyS/nbiz+f
         L5aw==
X-Gm-Message-State: APjAAAW0zlMZB+CxGCeEJp6QT7lKUaTOCmU9P1oGl5WFpxM/1Hnjmrvu
        j0NhlI/sPX5XTdvQn6oDgoD+ovo2vzDufg==
X-Google-Smtp-Source: APXvYqzTeOyhADwokKDQ/J0llgDXqlj81IRUqNeXXPCdahXKof/a1nf2440uPb//LQm5DmJ7BfoqMQ==
X-Received: by 2002:aa7:96ec:: with SMTP id i12mr15800025pfq.125.1566748436957;
        Sun, 25 Aug 2019 08:53:56 -0700 (PDT)
Received: from Gentoo ([103.231.91.74])
        by smtp.gmail.com with ESMTPSA id e17sm10953076pjt.6.2019.08.25.08.53.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 25 Aug 2019 08:53:56 -0700 (PDT)
Date:   Sun, 25 Aug 2019 21:23:42 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, jslaby@suse.cz, lwn@lwn.net
Subject: Re: Linux 5.2.10
Message-ID: <20190825155338.GA10025@Gentoo>
References: <20190825144703.6518-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
In-Reply-To: <20190825144703.6518-1-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

 Thanks, a bunch Sasha.

On 10:47 Sun 25 Aug 2019, Sasha Levin wrote:
>-----BEGIN PGP SIGNED MESSAGE-----
>Hash: SHA512
>
>I'm announcing the release of the 5.2.10 kernel.
>
>All users of the 5.2 kernel series must upgrade.
>
>The updated 5.2.y git tree can be found at:
>        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.=
git linux-5.2.y
>and can be browsed at the normal kernel.org git web browser:
>        https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.g=
it;a=3Dsummary
>
>
>--
>Thanks,
>Sasha
>
>
> Makefile | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>Alan Stern (1):
>      USB: core: Fix races in character device registration and deregistra=
ion
>
>Aleix Roca Nonell (1):
>      io_uring: fix manual setup of iov_iter for fixed buffers
>
>Anders Roxell (1):
>      arm64: KVM: regmap: Fix unexpected switch fall-through
>
>Aneesh Kumar K.V (1):
>      powerpc/nvdimm: Pick nearby online node if the device node is not on=
line
>
>Arnaldo Carvalho de Melo (1):
>      tools perf beauty: Fix usbdevfs_ioctl table generator to handle _IOC=
()
>
>Arnd Bergmann (1):
>      page flags: prioritize kasan bits over last-cpuid
>
>Aya Levin (2):
>      net/mlx5e: Fix false negative indication on tx reporter CQE recovery
>      net/mlx5e: Remove redundant check in CQE recovery flow of tx reporter
>
>Bob Ham (1):
>      USB: serial: option: add the BroadMobi BM818 card
>
>Chen-Yu Tsai (1):
>      net: dsa: Check existence of .port_mdb_add callback before calling it
>
>Chris Packham (1):
>      tipc: initialise addr_trail_end when setting node addresses
>
>Christian K=F6nig (1):
>      drm/amdgpu: fix error handling in amdgpu_cs_process_fence_dep
>
>Christoph Hellwig (2):
>      dma-mapping: check pfn validity in dma_common_{mmap,get_sgtable}
>      mm/hmm: always return EBUSY for invalid ranges in hmm_range_{fault,s=
napshot}
>
>Chuhong Yuan (1):
>      IB/mlx5: Replace kfree with kvfree
>
>Chunyan Zhang (1):
>      clk: sprd: Select REGMAP_MMIO to avoid compile errors
>
>Codrin Ciubotariu (1):
>      clk: at91: generated: Truncate divisor to GENERATED_MAX_DIV + 1
>
>Colin Ian King (1):
>      drm/exynos: fix missing decrement of retry counter
>
>David Ahern (2):
>      netdevsim: Restore per-network namespace accounting for fib entries
>      netlink: Fix nlmsg_parse as a wrapper for strict message parsing
>
>Denis Kirjanov (1):
>      net: usb: pegasus: fix improper read if get_registers() fail
>
>Dirk Morris (1):
>      netfilter: conntrack: Use consistent ct id hash calculation
>
>Don Brace (1):
>      scsi: hpsa: correct scsi command status issue after reset
>
>Eric Dumazet (2):
>      bpf: fix access to skb_shared_info->gso_segs
>      net/packet: fix race in tpacket_snd()
>
>Evan Quan (1):
>      drm/amd/powerplay: fix null pointer dereference around dpm state rel=
ates
>
>Fabio Estevam (1):
>      Revert "i2c: imx: improve the error handling in i2c_imx_dma_request(=
)"
>
>Filipe Manana (1):
>      Btrfs: fix deadlock between fiemap and transaction commits
>
>Florian Westphal (1):
>      netfilter: ebtables: also count base chain policies
>
>Gal Pressman (1):
>      RDMA/restrack: Track driver QP types in resource tracker
>
>Geert Uytterhoeven (1):
>      clk: renesas: cpg-mssr: Fix reset control race condition
>
>Gustavo A. R. Silva (1):
>      sh: kernel: hw_breakpoint: Fix missing break in switch statement
>
>Guy Levi (1):
>      IB/mlx5: Fix MR registration flow to use UMR properly
>
>Haim Dreyfuss (1):
>      iwlwifi: Add support for SAR South Korea limitation
>
>Heiner Kallweit (1):
>      net: phy: consider AN_RESTART status when reading link status
>
>Henry Burns (2):
>      mm/z3fold.c: fix z3fold_destroy_pool() ordering
>      mm/z3fold.c: fix z3fold_destroy_pool() race condition
>
>Hillf Danton (2):
>      HID: hiddev: avoid opening a disconnected device
>      HID: hiddev: do cleanup in failure of opening a device
>
>Hui Peng (2):
>      ALSA: usb-audio: Fix a stack buffer overflow bug in check_input_term
>      ALSA: usb-audio: Fix an OOB bug in parse_audio_mixer_unit
>
>Hui Wang (2):
>      ALSA: hda - Add a generic reboot_notify
>      ALSA: hda - Let all conexant codec enter D3 when rebooting
>
>Huy Nguyen (1):
>      net/mlx5e: Only support tx/rx pause setting for port owner
>
>Ian Abbott (2):
>      staging: comedi: dt3000: Fix signed integer overflow 'divider * base'
>      staging: comedi: dt3000: Fix rounding up of timer divisor
>
>Isaac J. Manjarres (1):
>      mm/usercopy: use memory range to be accessed for wraparound check
>
>Ivan Khoronzhuk (1):
>      net: sched: sch_taprio: fix memleak in error path for sched list par=
se
>
>Jack Morgenstein (1):
>      IB/mad: Fix use-after-free in ib mad completion handling
>
>Jacopo Mondi (1):
>      iio: adc: max9611: Fix temperature reading in probe
>
>Jaegeuk Kim (1):
>      f2fs: fix to read source block before invalidating it
>
>Jakub Kicinski (1):
>      net/tls: prevent skb_orphan() from leaking TLS plain text with offlo=
ad
>
>Jean Delvare (1):
>      platform/x86: pcengines-apuv2: Fix softdep statement
>
>Jeffrey Hugo (1):
>      drm: msm: Fix add_gpu_components
>
>Jia-Ju Bai (1):
>      scsi: qla2xxx: Fix possible fcport null-pointer dereferences
>
>Julien Thierry (1):
>      arm64: Lower priority mask for GIC_PRIO_IRQON
>
>Kees Cook (1):
>      libata: zpodd: Fix small read overflow in zpodd_get_mech_type()
>
>Kent Russell (1):
>      drm/amdkfd: Fix byte align on VegaM
>
>Leon Romanovsky (1):
>      RDMA/mlx5: Release locks during notifier unregister
>
>Lucas Stach (1):
>      irqchip/irq-imx-gpcv2: Forward irq type to parent
>
>Lyude Paul (1):
>      drm/nouveau: Only recalculate PBN/VCPI on mode/connector changes
>
>Manish Chopra (1):
>      bnx2x: Fix VF's VLAN reconfiguration in reload.
>
>Mao Han (1):
>      riscv: Fix perf record without libelf support
>
>Masahiro Yamada (2):
>      tracing: Fix header include guards in trace event headers
>      kbuild: modpost: handle KBUILD_EXTRA_SYMBOLS only for external modul=
es
>
>Masami Hiramatsu (3):
>      arm64: unwind: Prohibit probing on return_address()
>      arm64: kprobes: Recover pstate.D in single-step exception handler
>      arm64: Make debug exception handlers visible from RCU
>
>Max Filippov (1):
>      xtensa: add missing isync to the cpu_reset TLB code
>
>Maxim Mikityanskiy (1):
>      net/mlx5e: Use flow keys dissector to parse packets for ARFS
>
>Mel Gorman (1):
>      mm, vmscan: do not special-case slab reclaim when watermarks are boo=
sted
>
>Michael Chan (2):
>      bnxt_en: Fix VNIC clearing logic for 57500 chips.
>      bnxt_en: Improve RX doorbell sequence.
>
>Michal Kalderon (1):
>      RDMA/qedr: Fix the hca_type and hca_rev returned in device attributes
>
>Miles Chen (1):
>      mm/memcontrol.c: fix use after free in mem_cgroup_iter()
>
>Miquel Raynal (1):
>      ata: libahci: do not complain in case of deferred probe
>
>Mohamad Heib (1):
>      net/mlx5e: ethtool, Avoid setting speed to 56GBASE when autoneg off
>
>Nayna Jain (1):
>      tpm: tpm_ibm_vtpm: Fix unallocated banks
>
>NeilBrown (1):
>      seq_file: fix problem when seeking mid-record
>
>Nianyao Tang (1):
>      irqchip/gic-v3-its: Free unused vpt_page when alloc vpe table fail
>
>Numfor Mbiziwo-Tiapo (1):
>      perf header: Fix use of unitialized value warning
>
>Oliver Neukum (5):
>      HID: holtek: test for sanity of intfdata
>      Input: kbtab - sanity check for endpoint type
>      Input: iforce - add sanity checks
>      usb: cdc-acm: make sure a refcount is taken early enough
>      USB: CDC: fix sanity checks in CDC union parser
>
>Pierre-Eric Pelloux-Prayer (1):
>      drm/amdgpu: fix gfx9 soft recovery
>
>Qian Cai (4):
>      arm64/efi: fix variable 'si' set but not used
>      arm64/mm: fix variable 'pud' set but not used
>      arm64/mm: fix variable 'tag' set but not used
>      asm-generic: fix -Wtype-limits compiler warnings
>
>Rajneesh Bhardwaj (1):
>      platform/x86: intel_pmc_core: Add ICL-NNPI support to PMC Core
>
>Ralph Campbell (1):
>      mm/hmm: fix bad subpage pointer in try_to_unmap_one
>
>Roberto Sassu (1):
>      KEYS: trusted: allow module init if TPM is inactive or deactivated
>
>Rogan Dawes (1):
>      USB: serial: option: add D-Link DWM-222 device ID
>
>Roman Mashak (2):
>      net sched: update skbedit action for batched events operations
>      tc-testing: updated skbedit action tests with batch create/delete
>
>Ross Lagerwall (1):
>      xen/netback: Reset nr_frags before freeing skb
>
>Sasha Levin (1):
>      Linux 5.2.10-rc1
>
>Somnath Kotur (1):
>      bnxt_en: Fix to include flow direction in L2 key
>
>Stephen Boyd (1):
>      kbuild: Check for unknown options with cc-option usage in Kconfig an=
d clang
>
>Takashi Iwai (2):
>      ALSA: hda/realtek - Add quirk for HP Envy x360
>      ALSA: hda - Apply workaround for another AMD chip 1022:1487
>
>Thi=E9baud Weksteen (1):
>      usb: setup authorized_default attributes using usb_bus_notify
>
>Tony Lindgren (1):
>      USB: serial: option: Add Motorola modem UARTs
>
>Tony Luck (1):
>      IB/core: Add mitigation for Spectre V1
>
>Vasundhara Volam (2):
>      bnxt_en: Fix handling FRAG_ERR when NVM_INSTALL_UPDATE cmd fails
>      bnxt_en: Suppress HWRM errors for HWRM_NVM_GET_VARIABLE command
>
>Venkat Duvvuru (1):
>      bnxt_en: Use correct src_fid to determine direction of the flow
>
>Vince Weaver (1):
>      perf header: Fix divide by zero error if f_header.attr_size=3D=3D0
>
>Vincent Chen (2):
>      riscv: Correct the initialized flow of FP register
>      riscv: Make __fstate_clean() work correctly.
>
>Viresh Kumar (1):
>      cpufreq: schedutil: Don't skip freq update when limits change
>
>Wang Xiayang (1):
>      drm/amdgpu: fix a potential information leaking bug
>
>Wei Yongjun (1):
>      RDMA/hns: Fix error return code in hns_roce_v1_rsv_lp_qp()
>
>Wenwen Wang (2):
>      ALSA: hda - Fix a memory leak bug
>      net/mlx4_en: fix a memory leak bug
>
>Will Deacon (1):
>      arm64: ftrace: Ensure module ftrace trampoline is coherent with I-si=
de
>
>Xi Wang (1):
>      RDMA/hns: Fix sg offset non-zero issue
>
>Xin Long (1):
>      sctp: fix the transport error_count check
>
>Yang Shi (3):
>      mm: mempolicy: make the behavior consistent when MPOL_MF_MOVE* and M=
POL_MF_STRICT were specified
>      mm: mempolicy: handle vma with unmovable pages mapped correctly in m=
bind
>      Revert "kmemleak: allow to coexist with fault injection"
>
>Yoshiaki Okamoto (1):
>      USB: serial: option: Add support for ZTE MF871A
>
>Yoshihiro Shimoda (1):
>      usb: gadget: udc: renesas_usb3: Fix sysfs interface of "role"
>
>YueHaibing (7):
>      xen/pciback: remove set but not used variable 'old_state'
>      drm/bridge: lvds-encoder: Fix build error while CONFIG_DRM_KMS_HELPE=
R=3Dm
>      drm/bridge: tc358764: Fix build error
>      ocfs2: remove set but not used variable 'last_hash'
>      Input: psmouse - fix build error of multiple definition
>      bonding: Add vlan tx offload to hw_enc_features
>      team: Add vlan tx offload to hw_enc_features
>
>Yuki Tsunashima (1):
>      ALSA: pcm: fix lost wakeup event scenarios in snd_pcm_drain
>
>zhengbin (2):
>      blk-mq: move cancel of requeue_work to the front of blk_exit_queue
>      sctp: fix memleak in sctp_send_reset_streams
>
>-----BEGIN PGP SIGNATURE-----
>
>iQIzBAEBCgAdFiEE4n5dijQDou9mhzu83qZv95d3LNwFAl1inmcACgkQ3qZv95d3
>LNzabRAAjqvSCmJchMUM45PSlfkYCRyeCASyBbxDifS5cqjMkNEohxgV/Fel9B9W
>Q8rPpLG+pUtGetRRTi/SPuC8Zd4Wyru27WgBz/JcRI6ZZzYFW9aMMJhIVNF4cthZ
>GaxrXCTXye/sI1gifriO4yrL81shh7byl4TJFeZoR7/50AR8c703DFmkboVBaSHY
>FveMOt5Ic5o50KsapYDOiwgfYiUCGJzydh8e48thLTVwCAa8vXxoA/OrjIH4Exak
>peIjJoZEdvWswZ+CIkTmP8THHn5KzoKmImhHI3BR4/3ai40c4M9glLtin3SYC1I7
>d4VDi8mIpJTFanD63pv7gaIxBUoIQVnXEbc3qMhgegTZzqqp/JxUGghb/j9I/g/G
>LfU3GgUyeAIcXR7nRVcNY+yBzln1yzmLe/rzmXb5bSU2oa3+bUnGzr8wUBTb8BIE
>XXEmamsFPW+FdMGvOeVu6+iPVVE0gw+BH+uW9ILE11H1uXr5BjeZzIb2m6jD9YnY
>0slHXaSU8dLnujx+uAVD0oaJd3bc9iX+qiVXtnC4gtMiR/nNXazfLDTuhPr7j1rR
>urazhJ0FYcTfy7yc2U5WVllBklx+MpnA27tefVrd/NACiJAFVwQ5O0ER8W5S9Z7h
>YesJ0Duym0GPTWna/8IMB31XuwTqsU7+zxiaXa27OOjAIU42WGk=3D
>=3DBhSJ
>-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAl1irv8ACgkQsjqdtxFL
KRWk1Af9GFGOmpJQKTsbKtZ53FkheT8SoRzDNncSCn6qID1NqdvXev1GUKVLuzC4
E5ykSdllnnfGDLrlBDzn7Zt7PsDq0G95VXYx/7R1TFUjZGVlD1OKpNeqfW2bz9em
yU6dFfKJclsxrc7POOIYWmCnkZTS7MeT2NreCVgo1pVGNpf4+qnLhS4LTkC2cirJ
oyzodpnLkmwbIx1qq6bwmOFR5dCZNlSi2Ypo/a6gzkUMo1+ZGQPaqviCb4MrwrlK
oCkCl0/wbpKcuaCmnCJ3dU44ci9eXkTKtPrJh6eNXGsibLodVy/jTMc3HpdTM1ZJ
Ckj0stFfhqHaLZfDPak9NNa3dx8VWA==
=YvsE
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--
