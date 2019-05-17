Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2E2D21490
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 09:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728548AbfEQHgu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 03:36:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:46490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728546AbfEQHgu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 May 2019 03:36:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7758120873;
        Fri, 17 May 2019 07:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558078609;
        bh=DleSGz3tKHrCMMW7gwKtHVUi/6wHSrWHCzTSjkHStTs=;
        h=Date:From:To:Cc:Subject:From;
        b=GBXDl6PzVtgKAZHN7dWsUQfpgQfTaD3sa6Z7/ykr/kPq+DR00xuic8HZeJsqRPu+3
         DlcShtqL5JsJ+rD9oRDa0bZUTfo1ZPdDtHKBczw/oBcciDMIPRFYvIre1LenvcS3u+
         LxaOleaJrpDgm5cTtjyiE29iMbWgCWBfNUmgvXj8=
Date:   Fri, 17 May 2019 09:36:46 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.0.17
Message-ID: <20190517073646.GA7786@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.0.17 kernel.

All users of the 5.0 kernel series must upgrade.

The updated 5.0.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.0.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/net/davinci_emac.txt      |    2=20
 Documentation/devicetree/bindings/net/ethernet.txt          |    2=20
 Documentation/devicetree/bindings/net/macb.txt              |    4=20
 Makefile                                                    |    2=20
 arch/arm/Kconfig                                            |    2=20
 arch/arm/Kconfig.debug                                      |    6=20
 arch/arm/kernel/head-nommu.S                                |    2=20
 arch/arm64/kernel/ftrace.c                                  |    9=20
 arch/mips/ath79/setup.c                                     |    6=20
 arch/powerpc/include/asm/book3s/64/pgalloc.h                |    3=20
 arch/powerpc/include/asm/reg_booke.h                        |    2=20
 arch/powerpc/kernel/idle_book3s.S                           |   20=20
 arch/x86/include/uapi/asm/vmx.h                             |    1=20
 arch/x86/kernel/reboot.c                                    |   21=20
 arch/x86/kernel/vmlinux.lds.S                               |    2=20
 arch/x86/kvm/lapic.c                                        |    4=20
 arch/x86/kvm/trace.h                                        |    4=20
 arch/x86/kvm/vmx/nested.c                                   |   22=20
 arch/x86/mm/dump_pagetables.c                               |    3=20
 arch/x86/mm/ioremap.c                                       |    2=20
 block/bfq-iosched.c                                         |    8=20
 block/blk-mq.c                                              |    2=20
 drivers/acpi/nfit/core.c                                    |   12=20
 drivers/char/ipmi/ipmi_si_hardcode.c                        |    2=20
 drivers/clocksource/Kconfig                                 |    1=20
 drivers/clocksource/timer-oxnas-rps.c                       |    2=20
 drivers/dma/bcm2835-dma.c                                   |    2=20
 drivers/gpio/gpiolib.c                                      |   12=20
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                  |    1=20
 drivers/gpu/drm/amd/display/dc/core/dc.c                    |   19=20
 drivers/gpu/drm/amd/display/dc/dc.h                         |    3=20
 drivers/gpu/drm/amd/display/dc/dce/dce_aux.c                |    9=20
 drivers/gpu/drm/amd/display/dc/dce/dce_aux.h                |    6=20
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c                   |    4=20
 drivers/gpu/drm/imx/ipuv3-crtc.c                            |    2=20
 drivers/gpu/drm/rockchip/cdn-dp-reg.c                       |    2=20
 drivers/gpu/drm/sun4i/sun4i_drv.c                           |    7=20
 drivers/gpu/drm/ttm/ttm_bo.c                                |    4=20
 drivers/gpu/drm/virtio/virtgpu_drv.c                        |    4=20
 drivers/gpu/drm/virtio/virtgpu_drv.h                        |    4=20
 drivers/gpu/drm/virtio/virtgpu_prime.c                      |   12=20
 drivers/gpu/ipu-v3/ipu-dp.c                                 |   12=20
 drivers/hid/hid-input.c                                     |   14=20
 drivers/hwmon/occ/sysfs.c                                   |    8=20
 drivers/hwmon/pwm-fan.c                                     |    2=20
 drivers/iio/adc/xilinx-xadc-core.c                          |    3=20
 drivers/infiniband/hw/hns/hns_roce_qp.c                     |    2=20
 drivers/infiniband/hw/mlx5/main.c                           |    2=20
 drivers/infiniband/hw/mlx5/qp.c                             |   11=20
 drivers/input/keyboard/Kconfig                              |    2=20
 drivers/input/rmi4/rmi_driver.c                             |    6=20
 drivers/irqchip/irq-ath79-misc.c                            |   11=20
 drivers/isdn/gigaset/bas-gigaset.c                          |    9=20
 drivers/isdn/mISDN/socket.c                                 |    4=20
 drivers/md/raid5.c                                          |   19=20
 drivers/net/bonding/bond_options.c                          |    7=20
 drivers/net/ethernet/cadence/macb_main.c                    |    6=20
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c              |    2=20
 drivers/net/ethernet/freescale/ucc_geth_ethtool.c           |    8=20
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c             |    2=20
 drivers/net/ethernet/mscc/ocelot.c                          |    2=20
 drivers/net/ethernet/neterion/vxge/vxge-config.c            |    1=20
 drivers/net/ethernet/qlogic/qed/qed.h                       |    7=20
 drivers/net/ethernet/qlogic/qed/qed_dev.c                   |   85 +--
 drivers/net/ethernet/qlogic/qed/qed_int.c                   |   83 ++-
 drivers/net/ethernet/qlogic/qed/qed_int.h                   |    4=20
 drivers/net/ethernet/qlogic/qed/qed_main.c                  |    2=20
 drivers/net/ethernet/qlogic/qede/qede_ptp.c                 |    7=20
 drivers/net/ethernet/seeq/sgiseeq.c                         |    1=20
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c           |    2=20
 drivers/net/phy/phy_device.c                                |   11=20
 drivers/net/phy/spi_ks8995.c                                |    9=20
 drivers/net/tun.c                                           |   14=20
 drivers/net/vrf.c                                           |    2=20
 drivers/net/wireless/marvell/mwl8k.c                        |   13=20
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c         |    1=20
 drivers/net/wireless/st/cw1200/scan.c                       |    5=20
 drivers/nfc/st95hf/core.c                                   |    7=20
 drivers/nvdimm/btt_devs.c                                   |   18=20
 drivers/nvdimm/namespace_devs.c                             |    5=20
 drivers/nvdimm/pmem.c                                       |    8=20
 drivers/nvdimm/security.c                                   |   17=20
 drivers/of/of_net.c                                         |    1=20
 drivers/pci/controller/pci-hyperv.c                         |   23=20
 drivers/platform/x86/dell-laptop.c                          |    6=20
 drivers/platform/x86/sony-laptop.c                          |    8=20
 drivers/platform/x86/thinkpad_acpi.c                        |   72 ++-
 drivers/s390/block/dasd_eckd.c                              |    6=20
 drivers/s390/char/con3270.c                                 |    2=20
 drivers/s390/char/fs3270.c                                  |    3=20
 drivers/s390/char/raw3270.c                                 |    3=20
 drivers/s390/char/raw3270.h                                 |    4=20
 drivers/s390/char/tty3270.c                                 |    3=20
 drivers/s390/crypto/pkey_api.c                              |    3=20
 drivers/s390/net/ctcm_main.c                                |    1=20
 drivers/scsi/aic7xxx/aic7770_osm.c                          |    1=20
 drivers/scsi/aic7xxx/aic7xxx.h                              |    1=20
 drivers/scsi/aic7xxx/aic7xxx_osm.c                          |   10=20
 drivers/scsi/aic7xxx/aic7xxx_osm_pci.c                      |    1=20
 drivers/usb/serial/generic.c                                |   39 +
 drivers/virt/fsl_hypervisor.c                               |   29 -
 drivers/virt/vboxguest/vboxguest_core.c                     |   31 +
 drivers/virtio/virtio_ring.c                                |    1=20
 fs/afs/callback.c                                           |    3=20
 fs/afs/internal.h                                           |    4=20
 fs/afs/server.c                                             |    1=20
 fs/afs/write.c                                              |    1=20
 fs/ceph/inode.c                                             |   16=20
 fs/f2fs/data.c                                              |   17=20
 fs/f2fs/f2fs.h                                              |   13=20
 fs/f2fs/file.c                                              |    2=20
 fs/f2fs/gc.c                                                |    2=20
 fs/f2fs/segment.c                                           |   13=20
 fs/kernfs/dir.c                                             |    5=20
 include/linux/efi.h                                         |    7=20
 include/linux/elevator.h                                    |    1=20
 include/linux/kvm_host.h                                    |   10=20
 include/linux/skbuff.h                                      |    4=20
 include/net/netfilter/nf_conntrack.h                        |    2=20
 include/uapi/rdma/mlx5-abi.h                                |    1=20
 init/main.c                                                 |    4=20
 mm/memory_hotplug.c                                         |    1=20
 mm/page_alloc.c                                             |   33 -
 mm/slab.c                                                   |    1=20
 mm/vmscan.c                                                 |   29 -
 net/8021q/vlan_dev.c                                        |    4=20
 net/bridge/br_if.c                                          |   13=20
 net/core/fib_rules.c                                        |    6=20
 net/core/filter.c                                           |    8=20
 net/core/flow_dissector.c                                   |    3=20
 net/dsa/dsa.c                                               |   11=20
 net/ipv4/raw.c                                              |    4=20
 net/ipv6/sit.c                                              |    2=20
 net/mac80211/mesh_pathtbl.c                                 |    2=20
 net/mac80211/trace_msg.h                                    |    7=20
 net/mac80211/tx.c                                           |    3=20
 net/netfilter/ipvs/ip_vs_core.c                             |    2=20
 net/netfilter/nf_conntrack_core.c                           |   42 +
 net/netfilter/nf_conntrack_netlink.c                        |   34 +
 net/netfilter/nf_conntrack_proto.c                          |    2=20
 net/netfilter/nf_nat_core.c                                 |   11=20
 net/netfilter/nf_tables_api.c                               |    2=20
 net/netfilter/nfnetlink_log.c                               |    2=20
 net/netfilter/nfnetlink_queue.c                             |    2=20
 net/netfilter/xt_time.c                                     |   23=20
 net/packet/af_packet.c                                      |   25 -
 net/sched/act_mirred.c                                      |    3=20
 net/tipc/socket.c                                           |    4=20
 net/wireless/nl80211.c                                      |   18=20
 net/wireless/reg.c                                          |   39 +
 security/selinux/hooks.c                                    |    8=20
 tools/lib/traceevent/event-parse.c                          |    2=20
 tools/perf/builtin-top.c                                    |    1=20
 tools/perf/util/map.c                                       |    4=20
 tools/testing/nvdimm/test/nfit.c                            |   17=20
 tools/testing/selftests/net/fib_tests.sh                    |   94 +--
 tools/testing/selftests/net/run_afpackettests               |    5=20
 tools/testing/selftests/net/run_netsocktests                |    2=20
 tools/testing/selftests/netfilter/Makefile                  |    2=20
 tools/testing/selftests/netfilter/conntrack_icmp_related.sh |  283 +++++++=
+++++
 tools/testing/selftests/netfilter/nft_nat.sh                |   36 +
 tools/testing/selftests/seccomp/seccomp_bpf.c               |   43 -
 virt/kvm/irqchip.c                                          |    5=20
 virt/kvm/kvm_main.c                                         |    6=20
 164 files changed, 1383 insertions(+), 486 deletions(-)

Aditya Pakki (1):
      libnvdimm/btt: Fix a kmemdup failure check

Andrea Parri (1):
      kernfs: fix barrier usage in __kernfs_new_node()

Andrei Otcheretianski (1):
      mac80211: Increase MAX_MSG_LEN

Andrei Vagin (1):
      netfilter: fix nf_l4proto_log_invalid to log invalid packets

Andrey Ryabinin (1):
      mm/page_alloc.c: avoid potential NULL pointer dereference

Antoine Tenart (1):
      net: mvpp2: fix validate for PPv2.1

Ard Biesheuvel (1):
      arm64/module: ftrace: deal with place relative nature of PLTs

Arnd Bergmann (2):
      clocksource/drivers/npcm: select TIMER_OF
      s390: ctcm: fix ctcm_new_device error return code

Christoph Hellwig (1):
      scsi: aic7xxx: fix EISA support

Christophe Leroy (1):
      net: ucc_geth - fix Oops when changing number of buffers in the ring

Claudiu Manoil (1):
      ocelot: Don't sleep in atomic context (irqs_disabled())

Colin Ian King (2):
      vxge: fix return of a free'd memblock on a failed dma mapping
      qede: fix write to free'd pointer error and double free of ptp

Corentin Labbe (1):
      net: ethernet: stmmac: dwmac-sun8i: enable support of unicast filteri=
ng

Damian Kos (1):
      drm/rockchip: fix for mailbox read validation.

Damien Le Moal (1):
      f2fs: Fix use of number of devices

Dan Carpenter (3):
      netfilter: nf_tables: prevent shift wrap in nft_chain_parse_hook()
      drivers/virt/fsl_hypervisor.c: dereferencing error pointers in ioctl
      drivers/virt/fsl_hypervisor.c: prevent integer overflow in ioctl

Dan Williams (2):
      acpi/nfit: Always dump _DSM output payload
      init: initialize jump labels before command line option parsing

Daniel Gomez (2):
      spi: Micrel eth switch: declare missing of table
      spi: ST ST95HF NFC: declare missing of table

Dave Airlie (1):
      Revert "drm/virtio: drop prime import/export callbacks"

Dave Jiang (2):
      libnvdimm/security: provide fix for secure-erase to use zero-key
      tools/testing/nvdimm: Retain security state after overwrite

David Ahern (2):
      selftests: fib_tests: Fix 'Command line is not complete' errors
      ipv4: Fix raw socket lookup for local traffic

David Francis (1):
      drm/amd/display: If one stream full updates, full update all planes

David Hildenbrand (1):
      mm/memory_hotplug.c: drop memory device reference after find_memory_b=
lock()

David Howells (1):
      afs: Fix in-progess ops to ignore server-level callback invalidation

Denis Bolotin (4):
      qed: Delete redundant doorbell recovery types
      qed: Fix the doorbell address sanity check
      qed: Fix missing DORQ attentions
      qed: Fix the DORQ's attentions handling

Dexuan Cui (3):
      PCI: hv: Fix a memory leak in hv_eject_device_work()
      PCI: hv: Add hv_pci_remove_slots() when we unload the driver
      PCI: hv: Add pci_destroy_slot() in pci_devices_present_work(), if nec=
essary

Dmitry Torokhov (3):
      HID: input: add mapping for Expose/Overview key
      HID: input: add mapping for keyboard Brightness Up/Down/Toggle keys
      HID: input: add mapping for "Toggle Display" key

Eric Dumazet (1):
      flow_dissector: disable preemption around BPF calls

Felix Fietkau (2):
      mac80211: fix unaligned access in mesh table hash function
      mac80211: fix memory accounting with A-MSDU aggregation

Florian Westphal (4):
      selftests: netfilter: check icmp pkttoobig errors are set as related
      netfilter: ctnetlink: don't use conntrack/expect object addresses as =
id
      netfilter: nat: fix icmp id randomization
      netfilter: never get/set skb->tstamp

Geert Uytterhoeven (1):
      gpio: Fix gpiochip_add_data_with_key() error path

Greg Kroah-Hartman (1):
      Linux 5.0.17

Gustavo A. R. Silva (2):
      platform/x86: sony-laptop: Fix unintentional fall-through
      rtlwifi: rtl8723ae: Fix missing break in switch statement

Guy Levi (1):
      IB/mlx5: Fix scatter to CQE in DCT QP creation

Hangbin Liu (2):
      fib_rules: return 0 directly if an exactly same rule exists when NLM_=
F_EXCL not supplied
      vlan: disable SIOCSHWTSTAMP in container

Hans de Goede (1):
      virt: vbox: Sanity-check parameter types for hgcm-calls coming from u=
serspace

Harald Freudenberger (1):
      s390/pkey: add one more argument space for debug feature entry

Harini Katakam (1):
      net: macb: Change interrupt and napi enable order in open

Heiner Kallweit (1):
      net: phy: fix phy_validate_pause

Ilan Peer (1):
      cfg80211: Handle WMM rules in regulatory domain intersection

Jacky Bai (1):
      Input: snvs_pwrkey - make it depend on ARCH_MXC

Jarod Wilson (1):
      bonding: fix arp_validate toggling in active-backup mode

Jason Wang (2):
      tuntap: fix dividing by zero in ebpf queue selection
      tuntap: synchronize through tfiles array instead of tun->numqueues

Jeff Layton (1):
      ceph: handle the case where a dentry has been renamed on outstanding =
req

Jens Axboe (1):
      bfq: update internal depth state when queue depth changes

Jian-Hong Pan (1):
      x86/reboot, efi: Use EFI reboot for Acer TravelMate X514-51T

Jiaxun Yang (1):
      platform/x86: thinkpad_acpi: Disable Bluetooth for some machines

Jiri Olsa (2):
      perf top: Always sample time to satisfy needs of use of ordered queui=
ng
      perf tools: Fix map reference counting

Johan Hovold (1):
      USB: serial: fix unthrottle races

Johannes Weiner (1):
      mm: fix inactive list balancing between NUMA nodes and cgroups

John Hurley (1):
      net: sched: fix cleanup NULL pointer exception in act_mirr

Jonas Karlman (1):
      drm: bridge: dw-hdmi: Fix overflow workaround for Rockchip SoCs

Julian Anastasov (1):
      ipvs: do not schedule icmp errors from tunnels

Kangjie Lu (1):
      libnvdimm/namespace: Fix a potential NULL pointer dereference

Kees Cook (1):
      selftests/seccomp: Handle namespace failures gracefully

Laurentiu Tudor (2):
      dpaa_eth: fix SG frame cleanup
      powerpc/booke64: set RI in default MSR

Lei YU (1):
      hwmon: (occ) Fix extended status bits

Li RongQing (1):
      libnvdimm/pmem: fix a possible OOB access when read and write pmem

Lijun Ou (1):
      RDMA/hns: Bugfix for mapping user db

Lin Yi (1):
      drm/ttm: fix dma_fence refcount imbalance on error path

Lucas Stach (2):
      gpu: ipu-v3: dp: fix CSC handling
      drm/imx: don't skip DP channel disable for background plane

Marc Dionne (1):
      afs: Unlock pages for __pagevec_release()

Mario Limonciello (1):
      platform/x86: dell-laptop: fix rfkill functionality

Martin Leung (1):
      drm/amd/display: extending AUX SW Timeout

Martin Schwidefsky (1):
      s390/3270: fix lockdep false positive on view->lock

Miaohe Lin (1):
      net: vrf: Fix operation not supported when set vrf mac

Neil Armstrong (1):
      clocksource/drivers/oxnas: Fix OX820 compatible

Nigel Croxon (1):
      Don't jump to compute_result state from check_result state

Pan Bian (1):
      Input: synaptics-rmi4 - fix possible double free

Paolo Abeni (1):
      selinux: do not report error on connect(AF_UNSPEC)

Paolo Bonzini (2):
      KVM: nVMX: always use early vmcs check when EPT is disabled
      KVM: fix spectrev1 gadgets

Parthasarathy Bhuvaragan (1):
      tipc: fix hanging clients using poll with EPOLLOUT flag

Paul Bolle (1):
      isdn: bas_gigaset: use usb_fill_int_urb() properly

Paul Kocialkowski (3):
      drm/sun4i: Set device driver data at bind time for use in unbind
      drm/sun4i: Fix component unbinding and component master deletion
      drm/sun4i: Unbind components before releasing DRM and memory

Peter Oberparleiter (1):
      s390/dasd: Fix capacity calculation for large volumes

Petr =C5=A0tetiar (3):
      MIPS: perf: ath79: Fix perfcount IRQ assignment
      of_net: Fix residues after of_get_nvmem_mac_address removal
      mwl8k: Fix rate_idx underflow

Po-Hsu Lin (2):
      selftests/net: correct the return value for run_netsocktests
      selftests/net: correct the return value for run_afpackettests

Qian Cai (2):
      slab: store tagged freelist for off-slab slabmgmt
      mm/hotplug: treat CMA pages as unmovable

Rick Lindsley (1):
      powerpc/book3s/64: check for NULL pointer in pgd_alloc()

Rikard Falkeborn (1):
      tools lib traceevent: Fix missing equality check for strcmp

Russell Currey (1):
      powerpc/powernv/idle: Restore IAMR after idle

Russell King (1):
      ARM: fix function graph tracer and unwinder dependencies

Sami Tolvanen (1):
      x86/build/lto: Fix truncated .bss with -fdata-sections

Stefan Wahren (2):
      hwmon: (pwm-fan) Disable PWM if fetching cooling data fails
      dmaengine: bcm2835: Avoid GFP_KERNEL in device_prep_slave_sg

Stephen Suryaputra (1):
      vrf: sit mtu should not be updated when vrf netdev is the link

Sunil Dutt (1):
      nl80211: Add NL80211_FLAG_CLEAR_SKB flag for other NL commands

Sven Van Asbroeck (3):
      iio: adc: xilinx: fix potential use-after-free on remove
      iio: adc: xilinx: fix potential use-after-free on probe
      iio: adc: xilinx: prevent touching unclocked h/w on remove

Tetsuo Handa (1):
      mISDN: Check address length before reading address family

Thomas Bogendoerfer (1):
      net: seeq: fix crash caused by not set dev.parent

Thomas Gleixner (1):
      x86/mm: Prevent bogus warnings with "noexec=3Doff"

Tigran Tadevosyan (1):
      ARM: 8856/1: NOMMU: Fix CCR register faulty initialization when MPU i=
s disabled

Tobin C. Harding (1):
      bridge: Fix error path for kobject_init_and_add()

Tony Camuso (1):
      ipmi: ipmi_si_hardcode.c: init si_type array to fix a crash

Vitaly Kuznetsov (1):
      KVM: x86: avoid misreporting level-triggered irqs as edge-triggered i=
n tracing

Wei Yongjun (1):
      cw1200: fix missing unlock on error in cw1200_hw_scan()

Willem de Bruijn (1):
      bpf: only test gso type on gso packets

YueHaibing (3):
      net: dsa: Fix error cleanup path in dsa_init_module
      packet: Fix error path in packet_init
      virtio_ring: Fix potential mem leak in virtqueue_add_indirect_packed

wentalou (1):
      drm/amdgpu: shadow in shadow_list without tbo.mem.start cause page fa=
ult in sriov TDR


--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAlzeZI4ACgkQONu9yGCS
aT6WchAAnRU131O5VxgWZeUQkdIwbNS7k48JK0i7CrIH983MmW4xHCJsN0AmzzBe
NESMM9Mo1rM0R6eCEjw59+CRDySja8uNcpMqyP2MRgv/t1Ra2h+Tyikam4VSVXPV
WuQU1u/V6LGhUaW4DLStIF1wUyMCa4UNoHhKNB/MF/8WJhx+lffbGqxlmp5Kmrek
dCvMZz2lto9zBO86UKM+rL/qiKJj8qlKHW5nNSvZsAbHo7BwcXucrl7Z5OpEFdM4
dWRg5fdPooN5WSuz0ZF85zwVcL+XWc7pHbzXhHWnQUqb1w/5Ba8YTJOgrZ+3M8OY
t+Hx/wePBqThOdDjKcuQUUMpSGXGquwZfuTBbaTJ6RYQvm3+VzxMhfKfP0p4TC2S
83YY+mz4TPYARB1WMQGGOBid10CVQwqggd7daXM+Y6sXI5BImiDMkVcXnOAsKkTP
mTt9TwssRzjKgW7xIvYCTrArh3CCS/mTtoAH481X2INwRUrtiGpqKnooMTKinovx
AklFqpX7BWI7BwhKPu6F1GVHTsLyFZGX4DvSfySe3JEBTTktjoxGJ1Aqc4reZkQK
1bk6eQgcan/8AUTcqB/NozC/DF5dZ6UyMz/qH5A8oevjq5njeR0OI4CHdaqOPO0P
e1VMefsRhaNFCFcPaBAMd77/6VbOEknraJqhowDRG/m3D7VQZAs=
=6xRG
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
