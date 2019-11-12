Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 163A5F98B8
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 19:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbfKLSea (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 13:34:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:54584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727119AbfKLSea (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 13:34:30 -0500
Received: from localhost (unknown [77.241.229.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1736421A49;
        Tue, 12 Nov 2019 18:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573583668;
        bh=Vhx73Avv1CEcfQ89tmCX0tT8B63iRA6fj4Dx63HYEJM=;
        h=Date:From:To:Cc:Subject:From;
        b=Qgik7dcMdUJxnoyB6SfqaKYakeOLfaePCb3Sb2b9NQ/3zbFaqat3rgRrXJhloWWR0
         HNkBQqDYY+JHVgmgHQTK3LNe1jBpYGpWH0YGbEX2quWvbt1auX62WJOaJAq6neDL72
         GXlkXM7A0AbM7x4VJTaQdbvHNj4Ru3Piv6RElxdc=
Date:   Tue, 12 Nov 2019 19:30:24 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.9.201
Message-ID: <20191112183024.GA1827886@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.9.201 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                         |    2=20
 arch/x86/events/amd/ibs.c                        |    8=20
 arch/x86/include/asm/smp.h                       |   10=20
 arch/x86/kernel/apic/apic.c                      |  122 ++--
 drivers/dma/xilinx/xilinx_dma.c                  |    7=20
 drivers/gpu/drm/drm_gem.c                        |    9=20
 drivers/gpu/drm/i915/i915_cmd_parser.c           |  616 +++++++++++++++---=
-----
 drivers/gpu/drm/i915/i915_drv.c                  |    5=20
 drivers/gpu/drm/i915/i915_drv.h                  |  147 +----
 drivers/gpu/drm/i915/i915_gem.c                  |   25=20
 drivers/gpu/drm/i915/i915_gem_context.c          |    5=20
 drivers/gpu/drm/i915/i915_gem_execbuffer.c       |  110 ++--
 drivers/gpu/drm/i915/i915_gem_gtt.c              |   63 +-
 drivers/gpu/drm/i915/i915_gem_gtt.h              |    3=20
 drivers/gpu/drm/i915/i915_gem_request.c          |    4=20
 drivers/gpu/drm/i915/i915_params.c               |    6=20
 drivers/gpu/drm/i915/i915_params.h               |    2=20
 drivers/gpu/drm/i915/i915_reg.h                  |   11=20
 drivers/gpu/drm/i915/intel_drv.h                 |    3=20
 drivers/gpu/drm/i915/intel_pm.c                  |  160 +++++
 drivers/gpu/drm/i915/intel_ringbuffer.c          |   11=20
 drivers/gpu/drm/i915/intel_ringbuffer.h          |   18=20
 drivers/gpu/drm/radeon/si_dpm.c                  |    1=20
 drivers/hid/intel-ish-hid/ishtp/client-buffers.c |    2=20
 drivers/iio/imu/adis16480.c                      |    5=20
 drivers/infiniband/hw/cxgb4/cm.c                 |    2=20
 drivers/net/bonding/bond_main.c                  |    6=20
 drivers/net/can/c_can/c_can.c                    |   25=20
 drivers/net/can/c_can/c_can.h                    |    1=20
 drivers/net/can/flexcan.c                        |    1=20
 drivers/net/can/usb/gs_usb.c                     |    1=20
 drivers/net/can/usb/peak_usb/pcan_usb.c          |   17=20
 drivers/net/can/usb/peak_usb/pcan_usb_core.c     |    2=20
 drivers/net/can/usb/usb_8dev.c                   |    3=20
 drivers/net/ethernet/arc/emac_rockchip.c         |    3=20
 drivers/net/ethernet/hisilicon/hip04_eth.c       |    1=20
 drivers/net/ethernet/intel/e1000/e1000_ethtool.c |    7=20
 drivers/net/ethernet/intel/igb/igb_main.c        |    3=20
 drivers/net/ethernet/qlogic/qede/qede_main.c     |   12=20
 drivers/net/fjes/fjes_main.c                     |   15=20
 drivers/net/usb/cdc_ncm.c                        |    6=20
 drivers/net/usb/qmi_wwan.c                       |    1=20
 drivers/nfc/fdp/i2c.c                            |    2=20
 drivers/nfc/st21nfca/core.c                      |    1=20
 drivers/pci/host/pci-tegra.c                     |    7=20
 drivers/scsi/lpfc/lpfc_nportdisc.c               |    4=20
 drivers/scsi/qla2xxx/qla_bsg.c                   |    6=20
 drivers/scsi/qla2xxx/qla_os.c                    |    4=20
 drivers/usb/core/config.c                        |    5=20
 drivers/usb/dwc3/core.c                          |    3=20
 drivers/usb/gadget/composite.c                   |    4=20
 drivers/usb/gadget/configfs.c                    |  110 +++-
 drivers/usb/gadget/udc/atmel_usba_udc.c          |    6=20
 drivers/usb/gadget/udc/fsl_udc_core.c            |    2=20
 drivers/usb/usbip/stub_rx.c                      |   11=20
 drivers/usb/usbip/vhci_hcd.c                     |   10=20
 fs/ceph/caps.c                                   |   10=20
 fs/configfs/configfs_internal.h                  |   15=20
 fs/configfs/dir.c                                |  137 +++--
 fs/configfs/file.c                               |  294 +++++-----
 fs/configfs/symlink.c                            |   33 +
 fs/fs-writeback.c                                |    9=20
 fs/nfs/delegation.c                              |   10=20
 fs/nfs/delegation.h                              |    1=20
 fs/nfs/nfs4proc.c                                |    7=20
 include/drm/drm_vma_manager.h                    |    1=20
 include/linux/mm.h                               |    5=20
 include/linux/mm_types.h                         |    5=20
 include/linux/page-flags.h                       |   20=20
 include/net/ip_vs.h                              |    1=20
 include/net/neighbour.h                          |    4=20
 include/net/netfilter/nf_tables.h                |    3=20
 include/net/sock.h                               |    4=20
 lib/dump_stack.c                                 |    7=20
 mm/filemap.c                                     |    3=20
 mm/vmstat.c                                      |    2=20
 net/ipv4/fib_semantics.c                         |    2=20
 net/netfilter/ipset/ip_set_core.c                |    8=20
 net/netfilter/ipvs/ip_vs_ctl.c                   |   15=20
 net/nfc/netlink.c                                |    2=20
 sound/core/timer.c                               |    6=20
 sound/firewire/bebob/bebob_focusrite.c           |    3=20
 sound/pci/hda/patch_ca0132.c                     |    2=20
 tools/perf/util/hist.c                           |    2=20
 84 files changed, 1507 insertions(+), 740 deletions(-)

Al Viro (5):
      configfs: stash the data we need into configfs_buffer at open time
      configfs_register_group() shouldn't be (and isn't) called in rmdirabl=
e parts
      configfs: new object reprsenting tree fragments
      configfs: provide exclusion between IO and removals
      configfs: fix a deadlock in configfs_symlink()

Alan Stern (1):
      USB: Skip endpoints with 0 maxpacket length

Aleksander Morgado (1):
      net: usb: qmi_wwan: add support for DW5821e with eSIM support

Alex Deucher (1):
      drm/radeon: fix si_enable_smc_cac() failed issue

Alexandru Ardelean (1):
      iio: imu: adis16480: make sure provided frequency is positive

Ben Hutchings (1):
      drm/i915/cmdparser: Fix jump whitelist clearing

Chandana Kishori Chiluveru (1):
      usb: gadget: composite: Fix possible double free memory bug

Chris Wilson (5):
      drm/i915: Use the precomputed value for whether to enable command par=
sing
      drm/i915/cmdparser: Limit clflush to active cachelines
      drm/i915/gtt: Disable read-only support under GVT
      drm/i915: Prevent writing into a read-only object via a GGTT mmap
      drm/i915: Silence smatch for cmdparser

Chuhong Yuan (1):
      net: ethernet: arc: add the missed clk_disable_unprepare

Cristian Birsan (1):
      usb: gadget: udc: atmel: Fix interrupt storm in FIFO mode.

Dan Carpenter (1):
      netfilter: ipset: Fix an error code in ip_set_sockfn_get()

Daniel Wagner (1):
      scsi: lpfc: Honor module parameter lpfc_use_adisc

David Ahern (1):
      ipv4: Fix table id reference in fib_sync_down_addr

Dou Liyang (2):
      x86/apic: Move pending interrupt check code into it's own function
      x86/apic: Drop logical_smp_processor_id() inline

Eric Dumazet (3):
      net: fix data-race in neigh_event_send()
      ipvs: move old_secure_tcp into struct netns_ipvs
      net: prevent load/store tearing on sk->sk_stamp

Greg Kroah-Hartman (1):
      Linux 4.9.201

Gustavo A. R. Silva (1):
      drivers: usb: usbip: Add missing break statement to switch

Hannes Reinecke (1):
      scsi: qla2xxx: fixup incorrect usage of host_byte

Imre Deak (1):
      drm/i915/gen8+: Add RC6 CTX corruption WA

Jan Beulich (1):
      x86/apic/32: Avoid bogus LDR warnings

Jiangfeng Xiao (1):
      net: hisilicon: Fix "Trying to free already-free IRQ"

Jiri Olsa (1):
      perf tools: Fix time sorting

Joakim Zhang (1):
      can: flexcan: disable completely the ECC mechanism

Johan Hovold (2):
      can: usb_8dev: fix use-after-free on disconnect
      can: peak_usb: fix slab info leak

Jon Bloomfield (12):
      drm/i915/gtt: Add read only pages to gen8_pte_encode
      drm/i915/gtt: Read-only pages for insert_entries on bdw+
      drm/i915: Rename gen7 cmdparser tables
      drm/i915: Disable Secure Batches for gen6+
      drm/i915: Remove Master tables from cmdparser
      drm/i915: Add support for mandatory cmdparsing
      drm/i915: Support ro ppgtt mapped cmdparser shadow buffers
      drm/i915: Allow parsing of unsized batches
      drm/i915: Add gen9 BCS cmdparsing
      drm/i915/cmdparser: Use explicit goto for error paths
      drm/i915/cmdparser: Add support for backward jumps
      drm/i915/cmdparser: Ignore Length operands during command matching

Kevin Hao (1):
      dump_stack: avoid the livelock of the dump_lock

Kim Phillips (2):
      perf/x86/amd/ibs: Fix reading of the IBS OpData register and thus pre=
cise RIP validity
      perf/x86/amd/ibs: Handle erratum #420 only on the affected CPU family=
 (10h)

Konstantin Khlebnikov (1):
      mm/filemap.c: don't initiate writeback if mapping has no dirty pages

Kurt Van Dijck (1):
      can: c_can: c_can_poll(): only read status register after status IRQ

Luis Henriques (1):
      ceph: fix use-after-free in __ceph_remove_cap()

Lukas Wunner (1):
      netfilter: nf_tables: Align nft_expr private data to 64-bit

Manfred Rudigier (1):
      igb: Fix constant media auto sense switching when no cable is connect=
ed

Manish Chopra (1):
      qede: fix NULL pointer deref in __qede_remove()

Matthew Auld (2):
      drm/i915: kick out cmd_parser specific structs from i915_drv.h
      drm/i915: cleanup use of INSTR_CLIENT_MASK

Michal Hocko (1):
      mm, vmstat: hide /proc/pagetypeinfo from normal users

Michal Srb (2):
      drm/i915/cmdparser: Check reg_table_count before derefencing.
      drm/i915/cmdparser: Do not check past the cmd length.

Navid Emamdoost (1):
      can: gs_usb: gs_can_open(): prevent memory leak

Nicholas Piggin (1):
      scsi: qla2xxx: stop timer in shutdown path

Nikhil Badola (1):
      usb: fsl: Check memory resource before releasing it

Nobuo Iwata (1):
      usbip: fix possibility of dereference by NULLL pointer in vhci_hcd.c

Oliver Neukum (1):
      CDC-NCM: handle incomplete transfer of MTU

Pan Bian (3):
      NFC: fdp: fix incorrect free object
      nfc: netlink: fix double device reference drop
      NFC: st21nfca: fix double free

Peter Chen (1):
      usb: gadget: configfs: fix concurrent issue between composite APIs

Potnuri Bharat Teja (1):
      RDMA/iw_cxgb4: Avoid freeing skb twice in arp failure case

Radhey Shyam Pandey (1):
      dmaengine: xilinx_dma: Fix control reg update in vdma_channel_set_con=
fig

Robert Bragg (2):
      drm/i915: return EACCES for check_cmd() failures
      drm/i915: don't whitelist oacontrol in cmd parser

Shuah Khan (2):
      usbip: stub_rx: fix static checker warning on unnecessary checks
      usbip: Fix vhci_urb_enqueue() URB null transfer buffer error path

Stephane Grosjean (1):
      can: peak_usb: fix a potential out-of-sync while decoding packets

Taehee Yoo (1):
      bonding: fix unexpected IFF_BONDING bit unset

Takashi Iwai (2):
      ALSA: timer: Fix incorrectly assigned timer instance
      ALSA: hda/ca0132 - Fix possible workqueue stall

Takashi Sakamoto (1):
      ALSA: bebob: fix to detect configured source of sampling clock for Fo=
cusrite Saffire Pro i/o series

Tejun Heo (1):
      cgroup,writeback: don't switch wbs immediately on dead wbs if the mem=
cg is dead

Thomas Meyer (1):
      configfs: Fix bool initialization/comparison

Trond Myklebust (1):
      NFSv4: Don't allow a cached open with a revoked delegation

Tvrtko Ursulin (1):
      drm/i915: Move engine->needs_cmd_parser to engine->flags

Uma Shankar (1):
      drm/i915: Lower RM timeout to avoid DSI hard hangs

Vidya Sagar (1):
      PCI: tegra: Enable Relaxed Ordering only for Tegra20 & Tegra30

Wenwen Wang (1):
      e1000: fix memory leaks

Will Deacon (1):
      fjes: Handle workqueue allocation failure

Yang Shi (1):
      mm: thp: handle page cache THP correctly in PageTransCompoundMap

Yinbo Zhu (1):
      usb: dwc3: remove the call trace of USBx_GFLADJ

Zhang Lixu (1):
      HID: intel-ish-hid: fix wrong error handling in ishtp_cl_alloc_tx_rin=
g()


--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl3K+kAACgkQONu9yGCS
aT6KxQ//T6WvmFskiHhe77PjIvau7MoPElkVJGX0wZQinji8LYQDG4lmwGZfyvJr
reYsekqPbBYKnM6DpwjcPWS9DygAeChjtmqcNZOrcyzjzWtJrYXSQ9VQDVMbNIe+
iVrBo3t8JUUfacFIQnQ+3IMDzFZYMItJ66YOG4yxzxjZWsGdRzycdaVGzirGAAzU
1bVObnRYG2D8yT/TWpMA/QeK1eH5+AcrjJPfU89LTtUjr/M3Q+l0Dn0TJneoiQGQ
RNmSW9pr1Fs5ZagjtwsRRsHrGwEco/PumPf502qq+qSIqSxKaUUMFBWbTyKzYUTs
Q0saxBAYuZWaLlSSx+8tD/1M85w82S4c8p03mPfQBT2suMfkuitro1lrjnDVeM8T
3AnIOTj0kyqxbMj8L6ZJW/fcbhRkLECRrbQ3fcMvZbIg/o0S8yN4LO9hUIs90kzh
S8nXVkxb40zcKvx7WI5k1ZSCdu+rad7goT+ZrKpUSStrPneMTZesqaxYIyIUFVy1
yE27Vh1CB1vgHKjHVwZORZckO5NhvcNelRUienNL09gtOVEbYNQC3Tr/EOBNrlKP
z0z6Uyp3In5+J2Utv/ACjZ5QkUxD7CxpDnjJmBaRluNA33Da3b0XwBASwVgJQPts
tzTYdlC7DLFMyQcSw5BVcR464J1CLFYLneFGYEieqkIpi+UHveM=
=RQe+
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--
