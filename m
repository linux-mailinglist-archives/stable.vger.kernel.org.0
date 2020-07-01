Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E52EB210CAB
	for <lists+stable@lfdr.de>; Wed,  1 Jul 2020 15:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730742AbgGANt6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 09:49:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:53456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729503AbgGANt5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 09:49:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D64E920663;
        Wed,  1 Jul 2020 13:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593611395;
        bh=cpNSP58mlJWhyK5Moif5s3O4SNZ45NM7qdkIT4WCGZY=;
        h=From:To:Cc:Subject:Date:From;
        b=mWvS57oPh1h4gSnIupZFmfjzKEcb/rKuDle+QUCsQQSbn5P/gUYt6mbJHXiIKvY/C
         +RRK1dbFKpFWiLL4ySJPDP/6VIApC+hWE4/8ViK7r4eiWVlYc0kZFD2OKALytqHGUH
         XmJvJykcMXQB9RKb2ntFCi8RF6ZMWt4Sk/C7nl9Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc:     lwn@lwn.net, jslaby@suse.cz, gregkh@linuxfoundation.org
Subject: Linux 5.7.7
Date:   Wed,  1 Jul 2020 09:49:52 -0400
Message-Id: <20200701134953.2688293-1-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

I'm announcing the release of the 5.7.7 kernel.

All users of the 5.7 kernel series must upgrade.

The updated 5.7.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.7.y
and can be browsed at the normal kernel.org git web browser:
        https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary


Thanks,
Sasha


 Makefile                      |  2 +-
 arch/arm64/kernel/fpsimd.c    | 25 ++++++++++++++++++-------
 drivers/nvme/host/core.c      |  8 --------
 drivers/nvme/host/multipath.c | 36 ++++++++++++++++++++++++++----------
 drivers/nvme/host/nvme.h      |  2 ++
 drivers/tty/hvc/hvc_console.c | 16 ++++++++++++++--
 6 files changed, 61 insertions(+), 28 deletions(-)

Aaron Plattner (1):
      ALSA: hda: Add NVIDIA codec IDs 9a & 9d through a0 to patch table

Adam Ford (1):
      drm/panel-simple: fix connector type for LogicPD Type28 Display

Aditya Pakki (3):
      rocker: fix incorrect error handling in dma_rings_init
      RDMA/rvt: Fix potential memory leak caused by rvt_alloc_rq
      test_objagg: Fix potential memory leak in error handling

Al Cooper (1):
      xhci: Fix enumeration issue when setting max packet size for FS devices.

Al Viro (1):
      fix a braino in "sparc32: fix register window handling in genregs32_[gs]et()"

Alexander Lobakin (10):
      net: ethtool: add missing string for NETIF_F_GSO_TUNNEL_REMCSUM
      net: ethtool: add missing NETIF_F_GSO_FRAGLIST feature string
      net: qed: fix left elements count calculation
      net: qed: fix async event callbacks unregistering
      net: qede: stop adding events on an already destroyed workqueue
      net: qed: fix NVMe login fails over VFs
      net: qed: fix excessive QM ILT lines consumption
      net: qede: fix PTP initialization on recovery
      net: qede: fix use-after-free on recovery and AER handling
      net: qed: reset ILT block sizes before recomputing to fix crashes

Alexander Usyskin (1):
      mei: me: add tiger lake point device ids for H platforms.

Anand Moon (1):
      Revert "usb: dwc3: exynos: Add support for Exynos5422 suspend clk"

Anson Huang (1):
      soc: imx8m: Correct i.MX8MP UID fuse offset

Anton Eidelman (2):
      nvme-multipath: fix deadlock between ana_work and scan_work
      nvme-multipath: fix deadlock due to head->lock

Ard Biesheuvel (1):
      net: phy: mscc: avoid skcipher API for single block AES encryption

Arseny Solokha (1):
      powerpc/fsl_booke/32: Fix build with CONFIG_RANDOMIZE_BASE

Arvind Sankar (1):
      efi/x86: Setup stack correctly for efi_pe_entry

Babu Moger (1):
      x86/resctrl: Fix memory bandwidth counter width for AMD

Ben Widawsky (1):
      mm/memory_hotplug.c: fix false softlockup during pfn range removal

Bernard Zhao (1):
      drm/amd: fix potential memleak in err branch

Borislav Petkov (1):
      EDAC/amd64: Read back the scrub rate PCI register on F15h

Chaitanya Kulkarni (1):
      nvmet: fail outstanding host posted AEN req

Charles Keepax (1):
      regmap: Fix memory leak from regmap_register_patch

Christoffer Nielsen (1):
      ALSA: usb-audio: Add registration quirk for Kingston HyperX Cloud Flight S

Christopher Swenson (1):
      ALSA: usb-audio: Set 48 kHz rate for Rodecaster

Chuck Lever (2):
      SUNRPC: Properly set the @subbuf parameter of xdr_buf_subsegment()
      xprtrdma: Fix handling of RDMA_ERROR replies

Chuhong Yuan (1):
      USB: ohci-sm501: Add missed iounmap() in remove

Claudiu Beznea (3):
      net: macb: undo operations in case of failure
      net: macb: call pm_runtime_put_sync on failure path
      net: macb: free resources on failure path of at91ether_open()

Claudiu Manoil (1):
      enetc: Fix tx rings bitmap iteration range, irq handling

Colin Ian King (1):
      qed: add missing error test for DBG_STATUS_NO_MATCHING_FRAMING_MODE

Cong Wang (1):
      genetlink: clean up family attributes allocations

Dan Carpenter (3):
      x86/resctrl: Fix a NULL vs IS_ERR() static checker warning in rdt_cdp_peer_get()
      usb: gadget: udc: Potential Oops in error handling code
      Staging: rtl8723bs: prevent buffer overflow in update_sta_support_rate()

Daniel Gomez (1):
      drm: rcar-du: Fix build error

Daniel Vetter (1):
      drm/fb-helper: Fix vt restore

Dave Martin (1):
      arm64/sve: Eliminate data races on sve_default_vl

David Christensen (1):
      tg3: driver sleeps indefinitely when EEH errors exceed eeh_max_freezes

David Howells (3):
      rxrpc: Fix notification call on completion of discarded calls
      rxrpc: Fix handling of rwind from an ACK packet
      afs: Fix storage of cell names

David Milburn (1):
      nvmet: cleanups the loop in nvmet_async_events_process

David Rientjes (3):
      dma-direct: re-encrypt memory if dma_direct_alloc_pages() fails
      dma-direct: check return value when encrypting or decrypting memory
      dma-direct: add missing set_memory_decrypted() for coherent mapping

Dejin Zheng (1):
      net: phy: smsc: fix printing too many logs

Denis Efremov (2):
      drm/amd/display: Use kfree() to free rgb_user in calculate_user_regamma_ramp()
      drm/radeon: fix fb_div check in ni_init_smc_spll_table()

Denis Kirjanov (1):
      tcp: don't ignore ECN CWR on pure ACK

Dennis Dalessandro (1):
      IB/hfi1: Fix module use count flaw due to leftover module put calls

Dinghao Liu (1):
      hwrng: ks-sa - Fix runtime PM imbalance on error

Dmitry Baryshkov (1):
      pinctrl: qcom: spmi-gpio: fix warning about irq chip reusage

Doug Berger (1):
      net: bcmgenet: use hardware padding of runt frames

Drew Fustini (1):
      ARM: dts: am335x-pocketbeagle: Fix mmc0 Write Protect

Eddie James (1):
      i2c: fsi: Fix the port number field in status register

Eric Dumazet (2):
      net: increment xmit_recursion level in dev_direct_xmit()
      tcp: grow window for OOO packets only for SACK flows

Fabian Vogt (1):
      efi/tpm: Verify event log header before parsing

Fan Guo (1):
      RDMA/mad: Fix possible memory leak in ib_mad_post_receive_mads()

Filipe Manana (7):
      btrfs: fix a block group ref counter leak after failure to remove block group
      btrfs: fix bytes_may_use underflow when running balance and scrub in parallel
      btrfs: fix data block group relocation failure due to concurrent scrub
      btrfs: check if a log root exists before locking the log_mutex on unlink
      btrfs: fix hang on snapshot creation after RWF_NOWAIT write
      btrfs: fix failure of RWF_NOWAIT write into prealloc extent beyond eof
      btrfs: fix RWF_NOWAIT write not failling when we need to cow

Florian Fainelli (3):
      net: phy: Check harder for errors in get_phy_id()
      of: of_mdio: Correct loop scanning logic
      net: dsa: bcm_sf2: Fix node reference count

Frieder Schrempf (2):
      ARM: dts: imx6ul-kontron: Move watchdog from Kontron i.MX6UL/ULL board to SoM
      ARM: dts: imx6ul-kontron: Change WDOG_ANY signal from push-pull to open-drain

Gal Pressman (1):
      RDMA/efa: Set maximum pkeys device attribute

Gao Xiang (1):
      erofs: fix partially uninitialized misuse in z_erofs_onlinepage_fixup

Gaurav Singh (2):
      ethtool: Fix check in ethtool_rx_flow_rule_create
      bpf, xdp, samples: Fix null pointer dereference in *_user code

Geliang Tang (1):
      mptcp: drop sndr_key in mptcp_syn_options

Harish (1):
      selftests/powerpc: Fix build failure in ebb tests

Heikki Krogerus (1):
      usb: typec: mux: intel_pmc_mux: Fix DP alternate mode entry

Heiner Kallweit (1):
      r8169: fix firmware not resetting tp->ocp_base

Huaisheng Ye (1):
      dm writecache: correct uncommitted_block when discarding uncommitted entry

Huy Nguyen (1):
      xfrm: Fix double ESP trailer insertion in IPsec crypto offload.

Ido Schimmel (1):
      mlxsw: spectrum: Do not rely on machine endianness

Igor Mammedov (1):
      kvm: lapic: fix broken vcpu hotplug

Ilya Ponetayev (1):
      sch_cake: don't try to reallocate or unshare skb unconditionally

Jason A. Donenfeld (5):
      wireguard: device: avoid circular netns references
      wireguard: receive: account for napi_gro_receive never returning GRO_DROP
      socionext: account for napi_gro_receive never returning GRO_DROP
      wil6210: account for napi_gro_receive never returning GRO_DROP
      ACPI: configfs: Disallow loading ACPI tables when locked down

Jeremy Kerr (1):
      net: usb: ax88179_178a: fix packet alignment padding

Jiping Ma (1):
      arm64: perf: Report the PC value in REGS_ABI_32 mode

Jiri Slaby (1):
      syscalls: Fix offset type of ksys_ftruncate()

Joakim Tjernlund (1):
      cdc-acm: Add DISABLE_ECHO quirk for Microchip/SMSC chip

Johannes Weiner (1):
      mm: memcontrol: handle div0 crash race condition in memory.low

John van der Kamp (1):
      drm/amdgpu/display: Unlock mutex on error

Julian Wiedmann (1):
      s390/qeth: fix error handling for isolation mode cmds

Junxiao Bi (4):
      ocfs2: avoid inode removal while nfsd is accessing it
      ocfs2: load global_inode_alloc
      ocfs2: fix value of OCFS2_INVALID_SLOT
      ocfs2: fix panic on nfs server over ocfs2

Juri Lelli (2):
      sched/deadline: Initialize ->dl_boosted
      sched/core: Fix PI boosting between RT and DEADLINE tasks

Kai-Heng Feng (3):
      xhci: Poll for U0 after disabling USB2 LPM
      xhci: Return if xHCI doesn't support LPM
      ALSA: hda/realtek: Add mute LED and micmute LED support for HP systems

Kees Cook (1):
      x86/cpu: Use pinning mask for CR4 bits needing to be 0

Keith Busch (1):
      nvme-multipath: set bdi capabilities once

Krzysztof Kozlowski (1):
      spi: spi-fsl-dspi: Free DMA memory with matching function

Laurence Tratt (1):
      ALSA: usb-audio: Add implicit feedback quirk for SSL2+.

Leon Romanovsky (1):
      RDMA/core: Check that type_attrs is not NULL prior access

Li Jun (1):
      usb: typec: tcpci_rt1711h: avoid screaming irq causing boot hangs

Longfang Liu (1):
      USB: ehci: reopen solution for Synopsys HC bug

Lorenzo Bianconi (2):
      openvswitch: take into account de-fragmentation/gso_size in execute_check_pkt_len
      samples/bpf: xdp_redirect_cpu: Set MAX_CPUS according to NR_CPUS

Lu Baolu (3):
      iommu/vt-d: Set U/S bit in first level page table by default
      iommu/vt-d: Enable PCI ACS for platform opt in hint
      iommu/vt-d: Update scalable mode paging structure coherency

Luis Chamberlain (1):
      blktrace: break out of blktrace setup on concurrent calls

Macpaul Lin (2):
      usb: host: xhci-mtk: avoid runtime suspend when removing hcd
      ALSA: usb-audio: add quirk for Samsung USBC Headset (AKG)

Mans Rullgard (1):
      i2c: core: check returned size of emulated smbus block read

Marcelo Ricardo Leitner (1):
      sctp: Don't advertise IPv4 addresses if ipv6only is set on the socket

Mark Zhang (1):
      RDMA/cma: Protect bind_list and listen_list while finding matching cm id

Martin (1):
      bareudp: Fixed multiproto mode configuration

Martin Fuzzey (1):
      regulator: da9063: fix LDO9 suspend and warning.

Masahiro Yamada (1):
      kbuild: improve cc-option to clean up all temporary files

Masami Hiramatsu (2):
      kprobes: Suppress the suspicious RCU warning on kprobes
      tracing: Fix event trigger to accept redundant spaces

Mathias Nyman (1):
      xhci: Fix incorrect EP_STATE_MASK

Matt Fleming (1):
      x86/asm/64: Align start of __clear_user() loop to 16-bytes

Matthew Hagan (3):
      ARM: bcm: Select ARM_TIMER_SP804 for ARCH_BCM_NSP
      ARM: dts: NSP: Disable PL330 by default, add dma-coherent property
      ARM: dts: NSP: Correct FA2 mailbox node

Mauricio Faria de Oliveira (1):
      bcache: check and adjust logical block size for backing devices

Michael Chan (3):
      bnxt_en: Store the running firmware version code.
      bnxt_en: Do not enable legacy TX push on older firmware.
      bnxt_en: Fix statistics counters issue during ifdown with older firmware.

Michal Kalderon (1):
      RDMA/qedr: Fix KASAN: use-after-free in ucma_event_handler+0x532

Mikulas Patocka (1):
      dm writecache: add cond_resched to loop in persistent_memory_claim()

Minas Harutyunyan (1):
      usb: dwc2: Postponed gadget registration to the udc class driver

Muchun Song (1):
      mm/memcontrol.c: add missed css_put()

Nathan Chancellor (2):
      s390/vdso: Use $(LD) instead of $(CC) to link vDSO
      ACPI: sysfs: Fix pm_profile_attr type

Nathan Huckleberry (1):
      riscv/atomic: Fix sign extension for RV64I

Navid Emamdoost (1):
      sata_rcar: handle pm_runtime_get_sync failure cases

Neal Cardwell (2):
      tcp_cubic: fix spurious HYSTART_DELAY exit upon drop in min RTT
      bpf: tcp: bpf_cubic: fix spurious HYSTART_DELAY exit upon drop in min RTT

Olga Kornievskaia (1):
      NFSv4 fix CLOSE not waiting for direct IO compeletion

Oskar Holmlund (2):
      ARM: dts: Fix am33xx.dtsi USB ranges length
      ARM: dts: Fix am33xx.dtsi ti,sysc-mask wrong softreset flag

Pavel Begunkov (1):
      io_uring: fix hanging iopoll in case of -EAGAIN

Peter Chen (3):
      usb: cdns3: trace: using correct dir value
      usb: cdns3: ep0: fix the test mode set incorrectly
      usb: cdns3: ep0: add spinlock for cdns3_check_new_setup

Philipp Fent (1):
      efi/libstub: Fix path separator regression

Pierre-Louis Bossart (1):
      ASoC: soc-pcm: fix checks for multi-cpu FE dailinks

Qiushi Wu (2):
      efi/esrt: Fix reference count leak in esre_create_sysfs_entry.
      ASoC: rockchip: Fix a reference count leak.

Rafał Miłecki (1):
      ARM: dts: BCM5301X: Add missing memory "device_type" for Luxul XWC-2000

Rahul Lakkireddy (2):
      cxgb4: move handling L2T ARP failures to caller
      cxgb4: move PTP lock and unlock to caller in Tx path

Reinette Chatre (2):
      x86/cpu: Move resctrl CPUID code to resctrl/
      x86/resctrl: Support CPUID enumeration of MBM counter width

Robin Gong (3):
      regualtor: pfuze100: correct sw1a/sw2 on pfuze3000
      arm64: dts: imx8mm-evk: correct ldo1/ldo2 voltage range
      arm64: dts: imx8mn-ddr4-evk: correct ldo1/ldo2 voltage range

Roman Bolshakov (1):
      scsi: qla2xxx: Keep initiator ports after RSCN

Russell King (3):
      net: phylink: fix ethtool -A with attached PHYs
      net: phylink: ensure manual pause mode configuration takes effect
      netfilter: ipset: fix unaligned atomic access

Sabrina Dubroca (1):
      geneve: allow changing DF behavior after creation

Sagi Grimberg (2):
      nvme: fix possible deadlock when I/O is blocked
      nvme: don't protect ns mutation with ns->head->lock

Sami Tolvanen (1):
      recordmcount: support >64k sections

Sascha Ortmann (1):
      tracing/boottime: Fix kprobe multiple events

Sasha Levin (1):
      Linux 5.7.7-rc1

Sean Christopherson (3):
      KVM: nVMX: Plumb L2 GPA through to PML emulation
      KVM: VMX: Stop context switching MSR_IA32_UMWAIT_CONTROL
      x86/cpu: Reinitialize IA32_FEAT_CTL MSR on BSP during wakeup

SeongJae Park (1):
      scsi: lpfc: Avoid another null dereference in lpfc_sli4_hba_unset()

Shannon Nelson (2):
      ionic: update the queue count on open
      ionic: tame the watchdog timer on reconfig

Shay Drory (1):
      IB/mad: Fix use after free when destroying MAD agent

Shengjiu Wang (1):
      ASoC: fsl_ssi: Fix bclk calculation for mono channel

Srinivas Kandagatla (3):
      ASoC: q6asm: handle EOS correctly
      ASoc: q6afe: add support to get port direction
      ASoC: qcom: common: set correct directions for dailinks

Stanislav Fomichev (1):
      bpf: Don't return EINVAL from {get,set}sockopt when optlen > PAGE_SIZE

Steffen Maier (1):
      scsi: zfcp: Fix panic on ERP timeout for previously dismissed ERP action

Steven Rostedt (VMware) (1):
      ring-buffer: Zero out time extend if it is nested and not absolute

Stylon Wang (1):
      drm/amd/display: Enable output_bpc property on all outputs

Sven Auhagen (1):
      mvpp2: ethtool rxtx stats fix

Sven Schnelle (4):
      s390/seccomp: pass syscall arguments via seccomp_data
      s390/ptrace: return -ENOSYS when invalid syscall is supplied
      s390/ptrace: pass invalid syscall numbers to tracing
      s390/ptrace: fix setting syscall number

Taehee Yoo (3):
      net: core: reduce recursion limit value
      ip6_gre: fix use-after-free in ip6gre_tunnel_lookup()
      ip_tunnel: fix use-after-free in ip_tunnel_lookup()

Takashi Iwai (3):
      ALSA: usb-audio: Fix potential use-after-free of streams
      ALSA: usb-audio: Fix OOB access of mixer element list
      ALSA: hda/realtek - Add quirk for MSI GE63 laptop

Tang Bin (1):
      usb: host: ehci-exynos: Fix error check in exynos_ehci_probe()

Tariq Toukan (1):
      net: Do not clear the sock TX queue in sk_set_socket()

Thierry Reding (1):
      Revert "i2c: tegra: Fix suspending in active runtime PM state"

Thomas Falcon (2):
      ibmveth: Fix max MTU limit
      ibmvnic: Harden device login requests

Thomas Martitz (1):
      net: bridge: enfore alignment for ethernet address

Todd Kjos (1):
      binder: fix null deref of proc->context

Toke Høiland-Jørgensen (3):
      sch_cake: don't call diffserv parsing code when it is not needed
      sch_cake: fix a few style nits
      devmap: Use bpf_map_area_alloc() for allocating hash buckets

Tom Seewald (1):
      RDMA/siw: Fix pointer-to-int-cast warning in siw_rx_pbl()

Tomas Winkler (1):
      mei: me: disable mei interface on Mehlow server platforms

Tomasz Meresiński (1):
      usb: add USB_QUIRK_DELAY_INIT for Logitech C922

Tomi Valkeinen (1):
      drm/panel-simple: fix connector type for newhaven_nhd_43_480272ef_atxl

Tony Lindgren (6):
      bus: ti-sysc: Flush posted write on enable and disable
      bus: ti-sysc: Use optional clocks on for enable and wait for softreset bit
      bus: ti-sysc: Ignore clockactivity unless specified as a quirk
      bus: ti-sysc: Fix uninitialized framedonetv_irq
      ARM: OMAP2+: Fix legacy mode dss_reset
      ARM: dts: Fix duovero smsc interrupt for suspend

Trond Myklebust (1):
      pNFS/flexfiles: Fix list corruption if the mirror count changes

Vasily Averin (1):
      sunrpc: fixed rollback in rpc_gssd_dummy_populate()

Vasundhara Volam (1):
      bnxt_en: Read VPD info only for PFs

Vidya Sagar (1):
      pinctrl: tegra: Use noirq suspend/resume callbacks

Vincent Chen (1):
      clk: sifive: allocate sufficient memory for struct __prci_data

Vincent Guittot (1):
      sched/cfs: change initial value of runnable_avg

Vincenzo Frascino (1):
      s390/vdso: fix vDSO clock_getres()

Vishal Verma (1):
      nvdimm/region: always show the 'align' attribute

Vitaly Kuznetsov (1):
      Revert "KVM: VMX: Micro-optimize vmexit time when not exposing PMU"

Vlastimil Babka (1):
      mm, compaction: make capture control handling safe wrt interrupts

Waiman Long (2):
      mm, slab: fix sign conversion problem in memcg_uncharge_slab()
      mm/slab: use memzero_explicit() in kzfree()

Wang Hai (1):
      mld: fix memory leak in ipv6_mc_destroy_dev()

Wei Yongjun (1):
      mptcp: fix memory leak in mptcp_subflow_create_socket()

Weiping Zhang (1):
      block: update hctx map when use multiple maps

Wenhui Sheng (1):
      drm/amdgpu: add fw release for sdma v5_0

Will Deacon (1):
      arm64: sve: Fix build failure when ARM64_SVE=y and SYSCTL=n

Willem de Bruijn (1):
      selftests/net: report etf errors correctly

Xiaoyao Li (1):
      KVM: X86: Fix MSR range of APIC registers in X2APIC mode

Xiyu Yang (1):
      cifs: Fix cached_fid refcnt leak in open_shroot

Yang Yingliang (1):
      net: fix memleak in register_netdevice()

Yash Shah (1):
      RISC-V: Don't allow write+exec only page mapping request in mmap

Ye Bin (1):
      ata/libata: Fix usage of page address by page_address in ata_scsi_mode_select_xlat function

Yick W. Tse (1):
      ALSA: usb-audio: add quirk for Denon DCD-1500RE

Yoshihiro Shimoda (1):
      usb: renesas_usbhs: getting residue from callback_result

Zekun Shen (1):
      net: alx: fix race condition in alx_remove

Zhang Xiaoxu (2):
      cifs/smb3: Fix data inconsistent when punch hole
      cifs/smb3: Fix data inconsistent when zero file range

Zheng Bin (1):
      loop: replace kill_bdev with invalidate_bdev

guodeqing (1):
      net: Fix the arp error in some cases

yu kuai (2):
      block/bio-integrity: don't free 'buf' if bio_integrity_add_page() failed
      ARM: imx5: add missing put_device() call in imx_suspend_alloc_ocram()

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE4n5dijQDou9mhzu83qZv95d3LNwFAl78lGQACgkQ3qZv95d3
LNw59Q//XtCa8cJn1j0kdhLbwvPmHwwF+gZOjNKm/7phhYGdAFyVi3OSO5qd+s0V
JmeU+ycDrQ5xkNNA4nZR3oToqIUueg+JYFg4UytPzjuGO2kBFsgSRh2kQxjGyIvh
JZeiuPvUje7hk5DT95amKupWchUJV25vrCCBGWo+nFQnhbofQemOXIfdP0qjlhOQ
pJB2bDGGZdVIratvsvWVttuGwyTpflgvebnyY3NpFjaGHP2jQ2l/ghjooNl7/OlM
C4JDpEEiY/KEsx0w3mCYVHY/Twbv+gEXk49uhVHc0BiIcH6kg8zLNx7XJqWjNxuB
wcks5v4CJ+CK54FRmEnAHtWA6vR6TvwYixRpALbnvZlcQIUQqVY796ilTe7qFmjk
V2VfpV0EwuthKTd1I+klAlnbHCFwlVuylwNJn425SfQLHJP3sq7Ptsp2dzIu02yt
0fWgMtF/s4wTVzFU5j+E+U7Dulxp3llIGXhdMQpfo0OoOvddGeorZt3MjbbhNOo7
59MBYw3WJeEoRyL1d7uWyqdlYU4d9/c9Xd94aGFsKM8p6K7kMp2S/Pqqyb0rEdTN
OQBrS/UVYjczn+8BpG2exzz4d56kSUYbGaB2yAklv9pTWjwqThiximozIdP51VOY
MyGYhtY0X8R5JdNlJnbv+gSQ9PTZJNjplMmZSQqHudNTVSJgAC0=
=X90X
-----END PGP SIGNATURE-----
