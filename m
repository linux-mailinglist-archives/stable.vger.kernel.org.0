Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8793FAEA5B
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 14:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728187AbfIJMaE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Sep 2019 08:30:04 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33240 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbfIJMaE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Sep 2019 08:30:04 -0400
Received: by mail-pg1-f194.google.com with SMTP id n190so9731521pgn.0;
        Tue, 10 Sep 2019 05:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pahx3+Ak6TebFPml638WcX6MdpfKxaX+m0NespzBX/k=;
        b=CyVxcenR7kaMqrV4RpB7O4Dkt4OfIfmIr5z/wHDdIc9e/cagGDDNAcWrAv8KwdkDl5
         YwwSFnpPZaqsUFHwa9j10aJ58+IlgFFfEvEdS8iPn/0CfrEqbLbxCmGLJai6S4pCo2dG
         pUOhdkMdwXWaIHYLfOvcuFKZmSk/qzjr5O4+LKwZkoxWUrXb8OLsYRoEincZ2726xXuY
         N1Ca3FYeP992Fp9WtdhC0wEGYGggBoPGCLGGFm6GShuRRpEPWR+0woVQnT6IIceHsI+L
         d5v6ddMgmrWBpx8MeZGoU1M5kZNbDyKwYYsaq6nVtB0X0vx4tNmHrAT7ymbO4VGdgnra
         bdpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=pahx3+Ak6TebFPml638WcX6MdpfKxaX+m0NespzBX/k=;
        b=TdhvNO18kPYd+RVQJhjnc0jn2eqUVekqYSqueoenLTy7dZY04WG5Ee1XXiEzBTiSFm
         5AjTSvWQRx5T4iNxwbkaX8FkoQS27w9kGcSrCZwIgQ5ZNd96MprWvzbXyxwVMHMMplP/
         6i03X4iyaZrGn5jq8EPhWGC5qJdw1bEWPiK6cPxpL3ZCrG9pPmQaDkRHeSUPOlbgZfoV
         i/pkYxY3p7FR/e0GF4kZ04fKCW7B4iviVHzLpqHymeLluMvUZGgpZONMEG85XI8/z0pq
         kqNVzDqmrA0ByEvMwuz462fNoE+b7ZlmJds4qNXNYNeTenuzGAIqOEHXQm2zLIenKMOA
         Ze3w==
X-Gm-Message-State: APjAAAVfKtImn6aqcchrRVlUxI0EJ5eluUkv103s5NrazBLPYvGmeNjy
        Xg55kNiMrC0NoCieV97UNeupV/mv34ToXg==
X-Google-Smtp-Source: APXvYqwBxFk/F9gqNPzcBYMZRnhxA7IH6Ccvo/Le0lHvePPNpV84N9dFitcKYm+UE4B8oAOCeCBOZg==
X-Received: by 2002:aa7:8156:: with SMTP id d22mr8843533pfn.190.1568118603178;
        Tue, 10 Sep 2019 05:30:03 -0700 (PDT)
Received: from debian ([103.231.90.170])
        by smtp.gmail.com with ESMTPSA id x12sm20588975pff.49.2019.09.10.05.29.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2019 05:30:02 -0700 (PDT)
Date:   Tue, 10 Sep 2019 17:59:50 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 5.2.14
Message-ID: <20190910122946.GA32443@debian>
References: <20190910101841.GA7510@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
In-Reply-To: <20190910101841.GA7510@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 11:18 Tue 10 Sep 2019, Greg KH wrote:
>I'm announcing the release of the 5.2.14 kernel.
>
>All users of the 5.2 kernel series must upgrade.
>
>The updated 5.2.y git tree can be found at:
>	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git lin=
ux-5.2.y
>and can be browsed at the normal kernel.org git web browser:
>	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3D=
summary
>
>thanks,
>
>greg k-h
>
>------------
>
> Makefile                                                       |    2
> arch/x86/boot/compressed/pgtable_64.c                          |   13
> arch/x86/include/asm/bootparam_utils.h                         |    1
> arch/x86/kernel/apic/apic.c                                    |    4
> drivers/bluetooth/btqca.c                                      |   24 +
> drivers/bluetooth/btqca.h                                      |    7
> drivers/bluetooth/hci_qca.c                                    |    3
> drivers/clk/clk.c                                              |   49 ++-
> drivers/clk/samsung/clk-exynos5-subcmu.c                       |   16
> drivers/clk/samsung/clk-exynos5-subcmu.h                       |    2
> drivers/clk/samsung/clk-exynos5250.c                           |    7
> drivers/clk/samsung/clk-exynos5420.c                           |  162 +++=
+++----
> drivers/gpio/gpiolib.c                                         |   30 -
> drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c                         |    9
> drivers/gpu/drm/mediatek/mtk_drm_drv.c                         |   49 ++-
> drivers/gpu/drm/mediatek/mtk_drm_drv.h                         |    2
> drivers/hid/hid-cp2112.c                                       |    8
> drivers/hid/intel-ish-hid/ipc/hw-ish.h                         |    1
> drivers/hid/intel-ish-hid/ipc/pci-ish.c                        |    1
> drivers/infiniband/core/cma.c                                  |    6
> drivers/infiniband/hw/bnxt_re/qplib_rcfw.c                     |    8
> drivers/infiniband/hw/bnxt_re/qplib_rcfw.h                     |   11
> drivers/infiniband/hw/hfi1/fault.c                             |   12
> drivers/infiniband/hw/mlx4/mad.c                               |    4
> drivers/input/serio/hyperv-keyboard.c                          |   35 --
> drivers/mmc/core/mmc_ops.c                                     |    2
> drivers/net/ethernet/cavium/common/cavium_ptp.c                |    2
> drivers/net/ethernet/cavium/liquidio/request_manager.c         |    4
> drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c             |    4
> drivers/net/ethernet/ibm/ibmveth.c                             |    9
> drivers/net/ethernet/ibm/ibmvnic.c                             |   11
> drivers/net/ethernet/intel/ixgbe/ixgbe_main.c                  |    5
> drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c       |   12
> drivers/net/ethernet/mellanox/mlx5/core/en_main.c              |    1
> drivers/net/ethernet/myricom/myri10ge/myri10ge.c               |    2
> drivers/net/ethernet/netronome/nfp/flower/offload.c            |    7
> drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c        |    8
> drivers/net/ethernet/renesas/ravb_main.c                       |    8
> drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c                 |    6
> drivers/net/ethernet/toshiba/tc35815.c                         |    2
> drivers/net/ethernet/tundra/tsi108_eth.c                       |    5
> drivers/net/hyperv/netvsc_drv.c                                |    9
> drivers/net/phy/phy-c45.c                                      |   26 +
> drivers/net/phy/phy.c                                          |    2
> drivers/net/usb/cx82310_eth.c                                  |    3
> drivers/net/usb/kalmia.c                                       |    6
> drivers/net/usb/lan78xx.c                                      |    8
> drivers/net/usb/r8152.c                                        |    5
> drivers/net/wimax/i2400m/fw.c                                  |    4
> drivers/nvme/host/core.c                                       |    4
> drivers/nvme/host/multipath.c                                  |    1
> drivers/s390/net/qeth_core.h                                   |    1
> drivers/s390/net/qeth_core_main.c                              |   20 +
> drivers/scsi/lpfc/lpfc.h                                       |    1
> drivers/scsi/lpfc/lpfc_attr.c                                  |   15
> drivers/scsi/lpfc/lpfc_init.c                                  |   10
> drivers/scsi/lpfc/lpfc_sli4.h                                  |    5
> drivers/scsi/qla2xxx/qla_attr.c                                |    2
> drivers/scsi/qla2xxx/qla_os.c                                  |   11
> drivers/target/target_core_user.c                              |    9
> fs/afs/cell.c                                                  |    4
> fs/afs/dir.c                                                   |    3
> fs/afs/yfsclient.c                                             |    2
> fs/ceph/caps.c                                                 |    5
> fs/ceph/inode.c                                                |    7
> fs/ceph/snap.c                                                 |    4
> fs/ceph/super.h                                                |    2
> fs/ceph/xattr.c                                                |   19 -
> fs/read_write.c                                                |   49 ++-
> include/linux/ceph/buffer.h                                    |    3
> include/linux/gpio.h                                           |   24 -
> include/linux/phy.h                                            |    1
> include/net/act_api.h                                          |    4
> include/net/netfilter/nf_tables.h                              |    9
> include/net/psample.h                                          |    1
> kernel/kprobes.c                                               |    8
> kernel/sched/core.c                                            |    5
> net/batman-adv/multicast.c                                     |    2
> net/core/netpoll.c                                             |    6
> net/dsa/tag_8021q.c                                            |    2
> net/ipv4/tcp.c                                                 |   30 +
> net/ipv4/tcp_output.c                                          |    3
> net/ipv6/mcast.c                                               |    5
> net/netfilter/nf_flow_table_core.c                             |   43 +-
> net/netfilter/nf_flow_table_ip.c                               |   43 ++
> net/netfilter/nf_tables_api.c                                  |   15
> net/netfilter/nft_flow_offload.c                               |    9
> net/psample/psample.c                                          |    2
> net/rds/recv.c                                                 |    5
> net/sched/act_bpf.c                                            |    2
> net/sched/act_connmark.c                                       |    2
> net/sched/act_csum.c                                           |    2
> net/sched/act_gact.c                                           |    2
> net/sched/act_ife.c                                            |    2
> net/sched/act_ipt.c                                            |   11
> net/sched/act_mirred.c                                         |    2
> net/sched/act_nat.c                                            |    2
> net/sched/act_pedit.c                                          |    2
> net/sched/act_police.c                                         |    2
> net/sched/act_sample.c                                         |    8
> net/sched/act_simple.c                                         |    2
> net/sched/act_skbedit.c                                        |    2
> net/sched/act_skbmod.c                                         |    2
> net/sched/act_tunnel_key.c                                     |    2
> net/sched/act_vlan.c                                           |    2
> net/sched/sch_cbs.c                                            |   19 -
> net/sched/sch_generic.c                                        |   19 -
> net/sched/sch_taprio.c                                         |   31 +
> tools/bpf/bpftool/common.c                                     |    2
> tools/hv/hv_kvp_daemon.c                                       |    2
> tools/lib/bpf/libbpf.c                                         |   15
> tools/testing/selftests/kvm/include/evmcs.h                    |    2
> tools/testing/selftests/kvm/lib/x86_64/processor.c             |   16
> tools/testing/selftests/kvm/lib/x86_64/vmx.c                   |   20 +
> tools/testing/selftests/kvm/x86_64/evmcs_test.c                |   15
> tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c              |   12
> tools/testing/selftests/kvm/x86_64/platform_info_test.c        |    2
> tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c |   32 -
> virt/kvm/arm/mmio.c                                            |    7
> virt/kvm/arm/vgic/vgic-init.c                                  |   30 +
> 120 files changed, 864 insertions(+), 418 deletions(-)
>
>Alexandre Courbot (2):
>      drm/mediatek: use correct device to import PRIME buffers
>      drm/mediatek: set DMA max segment size
>
>Andre Przywara (1):
>      KVM: arm/arm64: VGIC: Properly initialise private IRQ affinity
>
>Andrea Righi (1):
>      kprobes: Fix potential deadlock in kprobe_optimizer()
>
>Andrew Jones (1):
>      KVM: arm/arm64: Only skip MMIO insn once
>
>Andrii Nakryiko (2):
>      libbpf: fix erroneous multi-closing of BTF FD
>      libbpf: set BTF FD for prog only when there is supported .BTF.ext da=
ta
>
>Anton Eidelman (1):
>      nvme-multipath: fix possible I/O hang when paths are updated
>
>Aya Levin (1):
>      net/mlx5e: Fix error flow of CQE recovery on tx reporter
>
>Benjamin Tissoires (1):
>      HID: cp2112: prevent sleeping function called from invalid context
>
>Bill Kuzeja (1):
>      scsi: qla2xxx: Fix gnl.l memory leak on adapter init failure
>
>Chen-Yu Tsai (1):
>      net: stmmac: dwmac-rk: Don't fail if phy regulator is absent
>
>Cong Wang (1):
>      net_sched: fix a NULL pointer deref in ipt action
>
>Darrick J. Wong (1):
>      vfs: fix page locking deadlocks when deduping files
>
>David Howells (1):
>      afs: Fix leak in afs_lookup_cell_rcu()
>
>Davide Caratti (2):
>      net/sched: pfifo_fast: fix wrong dereference in pfifo_fast_enqueue
>      net/sched: pfifo_fast: fix wrong dereference when qdisc is reset
>
>Dexuan Cui (2):
>      hv_netvsc: Fix a warning of suspicious RCU usage
>      Input: hyperv-keyboard: Use in-place iterator API in the channel cal=
lback
>
>Dmitry Fomichev (1):
>      scsi: target: tcmu: avoid use-after-free after command timeout
>
>Eric Dumazet (2):
>      mld: fix memory leak in mld_del_delrec()
>      tcp: remove empty skb from write queue in error cases
>
>Even Xu (1):
>      HID: intel-ish-hid: ipc: add EHL device id
>
>Feng Sun (1):
>      net: fix skb use after free in netpoll
>
>Florian Westphal (1):
>      netfilter: nf_flow_table: fix offload for flows that are subject to =
xfrm
>
>Fuqian Huang (1):
>      net: tundra: tsi108: use spin_lock_irqsave instead of spin_lock_irq =
in IRQ context
>
>Greg Kroah-Hartman (1):
>      Linux 5.2.14
>
>Guilherme G. Piccoli (1):
>      nvme: Fix cntlid validation when not using NVMEoF
>
>Harish Bandi (1):
>      Bluetooth: hci_qca: Send VS pre shutdown command.
>
>Hayes Wang (2):
>      Revert "r8152: napi hangup fix after disconnect"
>      r8152: remove calling netif_napi_del
>
>Jakub Kicinski (1):
>      tools: bpftool: fix error message (prog -> object)
>
>James Smart (1):
>      scsi: lpfc: Mitigate high memory pre-allocation by SCSI-MQ
>
>Jan Kaisrlik (1):
>      Revert "mmc: core: do not retry CMD6 in __mmc_switch()"
>
>John Hurley (2):
>      nfp: flower: prevent ingress block binds on internal ports
>      nfp: flower: handle neighbour events on internal ports
>
>John S. Gruber (1):
>      x86/boot: Preserve boot_params.secure_boot from sanitizing
>
>Julian Wiedmann (1):
>      s390/qeth: serialize cmd reply with concurrent timeout
>
>Ka-Cheong Poon (1):
>      net/rds: Fix info leak in rds6_inc_info_copy()
>
>Kirill A. Shutemov (2):
>      x86/boot/compressed/64: Fix boot on machines with broken E820 table
>      x86/boot/compressed/64: Fix missing initialization in find_trampolin=
e_placement()
>
>Linus Torvalds (1):
>      Revert "x86/apic: Include the LDR when clearing out APIC registers"
>
>Linus Walleij (1):
>      gpio: Fix irqchip initialization order
>
>Luis Henriques (4):
>      ceph: fix buffer free while holding i_ceph_lock in __ceph_setxattr()
>      ceph: fix buffer free while holding i_ceph_lock in __ceph_build_xatt=
rs_blob()
>      ceph: fix buffer free while holding i_ceph_lock in fill_inode()
>      libceph: allow ceph_buffer_put() to receive a NULL ceph_buffer
>
>Marc Dionne (1):
>      afs: Fix possible oops in afs_lookup trace event
>
>Marco Hartmann (1):
>      Add genphy_c45_config_aneg() function to phy-c45.c
>
>Marek Szyprowski (1):
>      clk: samsung: exynos542x: Move MSCL subsystem clocks to its sub-CMU
>
>Martin Blumenstingl (1):
>      clk: Fix potential NULL dereference in clk_fetch_parent_index()
>
>Matthias Kaehlcke (1):
>      Bluetooth: btqca: Add a short delay before downloading the NVM
>
>Nathan Chancellor (1):
>      net: tc35815: Explicitly check NET_IP_ALIGN is not zero in tc35815_rx
>
>Nicolai H=E4hnle (1):
>      drm/amdgpu: prevent memory leaks in AMDGPU_CS ioctl
>
>Pablo Neira Ayuso (4):
>      netfilter: nf_tables: use-after-free in failing rule with bound set
>      netfilter: nf_flow_table: conntrack picks up expired flows
>      netfilter: nf_flow_table: teardown flow timeout race
>      netfilter: nft_flow_offload: skip tcp rst and fin packets
>
>Paolo Bonzini (4):
>      selftests: kvm: do not try running the VM in vmx_set_nested_state_te=
st
>      selftests: kvm: provide common function to enable eVMCS
>      selftests: kvm: fix vmx_set_nested_state_test
>      selftests: kvm: fix state save/load on processors without XSAVE
>
>Sebastian Andrzej Siewior (1):
>      sched/core: Schedule new worker even if PI-blocked
>
>Selvin Xavier (1):
>      RDMA/bnxt_re: Fix stack-out-of-bounds in bnxt_qplib_rcfw_send_message
>
>Stephen Boyd (1):
>      clk: Fix falling back to legacy parent string matching
>
>Stephen Hemminger (1):
>      net: cavium: fix driver name
>
>Sven Eckelmann (1):
>      batman-adv: Fix netlink dumping of all mcast_flags buckets
>
>Sylwester Nawrocki (2):
>      clk: samsung: Change signature of exynos5_subcmus_init() function
>      clk: samsung: exynos5800: Move MAU subsystem clocks to MAU sub-CMU
>
>Taehee Yoo (1):
>      ixgbe: fix possible deadlock in ixgbe_service_task()
>
>Tho Vu (1):
>      ravb: Fix use-after-free ravb_tstamp_skb
>
>Thomas Falcon (2):
>      ibmveth: Convert multicast list size for little-endian system
>      ibmvnic: Unmap DMA address of TX descriptor buffers after use
>
>Vitaly Kuznetsov (2):
>      Tools: hv: kvp: eliminate 'may be used uninitialized' warning
>      selftests/kvm: make platform_info_test pass on AMD
>
>Vlad Buslov (1):
>      net: sched: act_sample: fix psample group handling on overwrite
>
>Vladimir Oltean (4):
>      taprio: Fix kernel panic in taprio_destroy
>      taprio: Set default link speed to 10 Mbps in taprio_set_picos_per_by=
te
>      net/sched: cbs: Set default link speed to 10 Mbps in cbs_set_port_ra=
te
>      net: dsa: tag_8021q: Future-proof the reserved fields in the custom =
VID
>
>Wenwen Wang (10):
>      cxgb4: fix a memory leak bug
>      liquidio: add cleanup in octeon_setup_iq()
>      net: myri10ge: fix memory leaks
>      lan78xx: Fix memory leaks
>      cx82310_eth: fix a memory leak bug
>      net: kalmia: fix memory leaks
>      wimax/i2400m: fix a memory leak bug
>      IB/mlx4: Fix memory leaks
>      infiniband: hfi1: fix a memory leak bug
>      infiniband: hfi1: fix memory leaks
>
>Willem de Bruijn (1):
>      tcp: inherit timestamp on mtu probe
>
>YueHaibing (2):
>      gpio: Fix build error of function redefinition
>      afs: use correct afs_call_type in yfs_fs_store_opaque_acl2
>
>zhengbin (1):
>      RDMA/cma: fix null-ptr-deref Read in cma_cleanup
>

Thanks, a bunch Greg! :)

Thanks,
Bhaskar

--0OAP2g/MAC+5xKAE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAl13lzcACgkQsjqdtxFL
KRXJ5gf/W+rECZMUZLTuttmbkVnM7CFm3UM64hG2meBjiWqoNE7mmeFMw459gY+D
2Jf0vGiferQe09y8W0tqMIQkXNvMx0KCNPGRngMs1OaP5+K2u08qPeJBEJk7aWYv
/DCEDqD1ybdK29LMw8FPrbcyw/pi34ktGV4ayPzNxI/ez4ppFXz7pUKbhmV5Vxw7
zCyio/8nrtjK7eiqM5sn6XoMJxlY4FTmp4bpHMRiGoJj3sxP+HrLhQIT3lRkvxnR
M4omkU8jzoGmHV/ZcBdjXQq3z9z50gNm7AXepmojCcLnKrtUwIkkfHXIbLgTZEUr
7zR0MH6Da4Xy5oCkBgpYDD/fNz/OmQ==
=/N5B
-----END PGP SIGNATURE-----

--0OAP2g/MAC+5xKAE--
