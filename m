Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06DA210E145
	for <lists+stable@lfdr.de>; Sun,  1 Dec 2019 10:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727316AbfLAJmT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Dec 2019 04:42:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:56510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726256AbfLAJmT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 1 Dec 2019 04:42:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A10272073C;
        Sun,  1 Dec 2019 09:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575193338;
        bh=nhWJHgXk7weEKiUEoI5rltEgw9ouah0/kqkZOfqZmPU=;
        h=Date:From:To:Cc:Subject:From;
        b=j/ikpwndorKuKPhzdQdjjy+ws2Syjt7tZRnj/TQDi9YUbdZ/JgIiBe14/geoMtyQI
         QsarQi9Pjnc8gHK7e4tWhK6GuE5TnH8PB6dVpALy18athT3P8s5Thk0Ze8sG25ZMzj
         lyEyu+bpsp82GuOaAMW+MnZgzaNWesK2My2jng3w=
Date:   Sun, 1 Dec 2019 10:42:15 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.3.14
Message-ID: <20191201094215.GA3797123@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.3.14 kernel.

All users of the 5.3 kernel series must upgrade.

The updated 5.3.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.3.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/admin-guide/hw-vuln/mds.rst                      |    7=20
 Documentation/admin-guide/hw-vuln/tsx_async_abort.rst          |    5=20
 Documentation/admin-guide/kernel-parameters.txt                |   11=20
 Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt |    6=20
 Makefile                                                       |    2=20
 arch/arm/mm/mmu.c                                              |    3=20
 arch/powerpc/include/asm/asm-prototypes.h                      |    3=20
 arch/powerpc/include/asm/security_features.h                   |    3=20
 arch/powerpc/kernel/entry_64.S                                 |    6=20
 arch/powerpc/kernel/security.c                                 |   74 +++
 arch/powerpc/kvm/book3s_hv_rmhandlers.S                        |   30 +
 arch/x86/entry/entry_32.S                                      |  211 ++++=
++----
 arch/x86/include/asm/cpu_entry_area.h                          |   18=20
 arch/x86/include/asm/pgtable_32_types.h                        |    8=20
 arch/x86/include/asm/segment.h                                 |   12=20
 arch/x86/kernel/cpu/bugs.c                                     |   30 +
 arch/x86/kernel/doublefault.c                                  |    3=20
 arch/x86/kernel/head_32.S                                      |   10=20
 arch/x86/mm/cpu_entry_area.c                                   |    4=20
 arch/x86/tools/gen-insn-attr-x86.awk                           |    4=20
 arch/x86/xen/xen-asm_32.S                                      |   75 +--
 drivers/block/nbd.c                                            |    6=20
 drivers/bluetooth/hci_bcsp.c                                   |    3=20
 drivers/bluetooth/hci_ll.c                                     |   39 -
 drivers/char/virtio_console.c                                  |   28 -
 drivers/cpufreq/cpufreq.c                                      |    6=20
 drivers/gpio/gpio-bd70528.c                                    |    6=20
 drivers/gpio/gpio-max77620.c                                   |    6=20
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c                        |    6=20
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c                          |    9=20
 drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c               |   23 -
 drivers/gpu/drm/i915/display/intel_display.c                   |    3=20
 drivers/gpu/drm/i915/gem/i915_gem_userptr.c                    |   22 -
 drivers/gpu/drm/i915/i915_pmu.c                                |    4=20
 drivers/md/dm-crypt.c                                          |    9=20
 drivers/md/raid10.c                                            |    2=20
 drivers/media/platform/vivid/vivid-kthread-cap.c               |    8=20
 drivers/media/platform/vivid/vivid-kthread-out.c               |    8=20
 drivers/media/platform/vivid/vivid-sdr-cap.c                   |    8=20
 drivers/media/platform/vivid/vivid-vid-cap.c                   |    3=20
 drivers/media/platform/vivid/vivid-vid-out.c                   |    3=20
 drivers/media/rc/imon.c                                        |    3=20
 drivers/media/rc/mceusb.c                                      |  141 ++++=
--
 drivers/media/usb/b2c2/flexcop-usb.c                           |    3=20
 drivers/media/usb/dvb-usb/cxusb.c                              |    3=20
 drivers/media/usb/usbvision/usbvision-video.c                  |   29 +
 drivers/media/usb/uvc/uvc_driver.c                             |   28 -
 drivers/net/ethernet/google/gve/gve_tx.c                       |    9=20
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c                |    9=20
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c                 |    9=20
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c            |   18=20
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c           |   12=20
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c              |    2=20
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c              |   10=20
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h              |    1=20
 drivers/net/ethernet/mellanox/mlx5/core/main.c                 |    1=20
 drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c                |    2=20
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c          |   19=20
 drivers/net/ethernet/sfc/ptp.c                                 |    3=20
 drivers/net/phy/mdio_bus.c                                     |   11=20
 drivers/net/wireless/ath/ath10k/pci.c                          |   36 +
 drivers/net/wireless/ath/ath10k/qmi.c                          |   13=20
 drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.c                 |   22 +
 drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.h                 |    1=20
 drivers/net/wireless/ath/ath10k/snoc.c                         |   11=20
 drivers/net/wireless/ath/ath10k/snoc.h                         |    1=20
 drivers/net/wireless/ath/ath10k/usb.c                          |    8=20
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c                 |    2=20
 drivers/nfc/port100.c                                          |    2=20
 drivers/staging/comedi/drivers/usbduxfast.c                    |   21=20
 drivers/usb/misc/appledisplay.c                                |    8=20
 drivers/usb/misc/chaoskey.c                                    |   24 -
 drivers/usb/serial/cp210x.c                                    |    1=20
 drivers/usb/serial/mos7720.c                                   |    4=20
 drivers/usb/serial/mos7840.c                                   |   16=20
 drivers/usb/serial/option.c                                    |    7=20
 drivers/usb/usbip/Kconfig                                      |    1=20
 drivers/usb/usbip/stub_rx.c                                    |   50 +-
 drivers/vhost/vsock.c                                          |   66 ++-
 drivers/virtio/virtio_balloon.c                                |    2=20
 drivers/virtio/virtio_ring.c                                   |    4=20
 fs/ocfs2/xattr.c                                               |   56 +-
 include/net/tls.h                                              |    2=20
 kernel/fork.c                                                  |    6=20
 kernel/futex.c                                                 |   58 ++
 mm/ksm.c                                                       |   14=20
 mm/memory_hotplug.c                                            |   16=20
 mm/slub.c                                                      |   22 -
 net/core/rtnetlink.c                                           |   23 +
 net/ipv4/sysctl_net_ipv4.c                                     |    2=20
 net/ipv6/route.c                                               |    2=20
 net/sched/act_pedit.c                                          |   12=20
 net/sched/act_tunnel_key.c                                     |    4=20
 net/sched/sch_taprio.c                                         |   28 +
 net/tls/tls_main.c                                             |    1=20
 net/tls/tls_sw.c                                               |   11=20
 net/vmw_vsock/virtio_transport_common.c                        |   15=20
 sound/usb/mixer.c                                              |    3=20
 tools/gpio/Build                                               |    1=20
 tools/gpio/Makefile                                            |   10=20
 tools/objtool/arch/x86/tools/gen-insn-attr-x86.awk             |    4=20
 tools/testing/selftests/x86/mov_ss_trap.c                      |    3=20
 tools/testing/selftests/x86/sigreturn.c                        |   13=20
 tools/usb/usbip/libsrc/usbip_host_common.c                     |    2=20
 104 files changed, 1159 insertions(+), 489 deletions(-)

A Sun (1):
      media: mceusb: fix out of bounds read in MCE receiver buffer

Adam Ford (1):
      Revert "Bluetooth: hci_ll: set operational frequency earlier"

Adi Suresh (1):
      gve: fix dma sync bug where not all pages synced

Alan Stern (2):
      media: usbvision: Fix invalid accesses after device disconnect
      media: usbvision: Fix races among open, close, and disconnect

Aleksander Morgado (2):
      USB: serial: option: add support for DW5821e with eSIM support
      USB: serial: option: add support for Foxconn T77W968 LTE modules

Alex Deucher (2):
      drm/amdgpu: disable gfxoff when using register read interface
      drm/amdgpu: disable gfxoff on original raven

Alexander Kapshuk (1):
      x86/insn: Fix awk regexp warnings

Alexander Popov (1):
      media: vivid: Fix wrong locking that causes race conditions on stream=
ing stop

Alexander Potapenko (1):
      mm/slub.c: init_on_free=3D1 should wipe freelist ptr for bulk allocat=
ions

Andrey Ryabinin (1):
      mm/ksm.c: don't WARN if page is still mapped in remove_stable_node()

Andy Lutomirski (7):
      x86/doublefault/32: Fix stack canaries in the double fault handler
      x86/entry/32: Use %ss segment where required
      x86/entry/32: Move FIXUP_FRAME after pushing %fs in SAVE_ALL
      x86/entry/32: Unwind the ESPFIX stack earlier on exception entry
      selftests/x86/mov_ss_trap: Fix the SYSENTER test
      selftests/x86/sigreturn/32: Invalidate DS and ES when abusing the ker=
nel
      x86/entry/32: Fix FIXUP_ESPFIX_STACK with user CR3

Bernd Porr (1):
      staging: comedi: usbduxfast: usbduxfast_ai_cmdtest rounding error

Bjorn Andersson (1):
      ath10k: Fix HOST capability QMI incompatibility

Chester Lin (1):
      ARM: 8904/1: skip nomap memblocks while finding the lowmem/highmem bo=
undary

Chris Wilson (2):
      drm/i915/pmu: "Frequency" is reported as accumulated cycles
      drm/i915/userptr: Try to acquire the page lock around set_page_dirty()

Christian Lamparter (1):
      ath10k: restore QCA9880-AR1A (v1) detection

Christopher M. Riedl (1):
      powerpc/64s: support nospectre_v2 cmdline option

Dan Carpenter (1):
      net: rtnetlink: prevent underflows in do_setvfinfo()

David Hildenbrand (1):
      mm/memory_hotplug: don't access uninitialized memmaps in shrink_zone_=
span()

Davide Caratti (1):
      net/sched: act_pedit: fix WARN() in the traffic path

Denis Efremov (1):
      ath9k_hw: fix uninitialized variable data

Eli Cohen (1):
      net/mlx5e: Fix error flow cleanup in mlx5e_tc_tun_create_header_ipv4/6

Eran Ben Elisha (2):
      net/mlxfw: Verify FSM error code translation doesn't exceed array size
      net/mlx5e: Do not use non-EXT link modes in EXT mode

Evan Quan (1):
      drm/amd/powerplay: issue no PPSMC_MSG_GetCurrPkgPwr on unsupported AS=
ICs

Geert Uytterhoeven (1):
      mdio_bus: Fix init if CONFIG_RESET_CONTROLLER=3Dn

Greg Kroah-Hartman (2):
      usb-serial: cp201x: support Mark-10 digital force gauge
      Linux 5.3.14

Halil Pasic (1):
      virtio_ring: fix return code on DMA mapping fails

Hangbin Liu (1):
      ipv6/route: return if there is no fib_nh_gw_family

Hewenliang (1):
      usbip: tools: fix fd leakage in the function of read_attr_usbip_status

Hui Peng (1):
      ath10k: Fix a NULL-ptr-deref bug in ath10k_usb_alloc_urb_from_pipe

Ingo Molnar (1):
      x86/pti/32: Calculate the various PTI cpu_entry_area sizes correctly,=
 make the CPU_ENTRY_AREA_PAGES assert precise

Ivan Khoronzhuk (1):
      taprio: don't reject same mqprio settings

Jan Beulich (3):
      x86/stackframe/32: Repair 32-bit Xen PV
      x86/xen/32: Make xen_iret_crit_fixup() independent of frame layout
      x86/xen/32: Simplify ring check in xen_iret_crit_fixup()

Johan Hovold (2):
      USB: serial: mos7720: fix remote wakeup
      USB: serial: mos7840: fix remote wakeup

John Pittman (1):
      md/raid10: prevent access of uninitialized resync_pages offset

Joseph Qi (1):
      Revert "fs: ocfs2: fix possible null-pointer dereferences in ocfs2_xa=
_prepare_entry()"

Kai Shen (1):
      cpufreq: Add NULL checks to show() and store() methods of cpufreq

Laura Abbott (1):
      tools: gpio: Correctly add make dependencies for gpio_utils

Laurent Pinchart (1):
      media: uvcvideo: Fix error path in control parsing failure

Laurent Vivier (1):
      virtio_console: allocate inbufs in add_port() only if it is needed

Luc Van Oostenryck (1):
      fork: fix pidfd_poll()'s return type

Luigi Rizzo (1):
      net/mlx4_en: fix mlx4 ethtool -N insertion

Maor Gottlieb (1):
      net/mlx5: Fix auto group size calculation

Marcelo Ricardo Leitner (1):
      net/ipv4: fix sysctl max for fib_multipath_hash_policy

Martin Habets (1):
      sfc: Only cancel the PPS workqueue if it exists

Michael Ellerman (2):
      powerpc/book3s64: Fix link stack flush on context switch
      KVM: PPC: Book3S HV: Flush link stack on guest exit to host kernel

Mike Snitzer (1):
      Revert "dm crypt: use WQ_HIGHPRI for the IO and crypt workqueues"

Navid Emamdoost (1):
      nbd: prevent memory leak

Oliver Neukum (5):
      nfc: port100: handle command failure cleanly
      media: b2c2-flexcop-usb: add sanity checking
      USBIP: add config dependency for SGL_ALLOC
      USB: chaoskey: fix error case of a timeout
      appledisplay: fix error handling in the scheduled work

Pavel L=F6bl (1):
      USB: serial: mos7840: add USB ID to support Moxa UPort 2210

Peter Zijlstra (2):
      x86/entry/32: Fix IRET exception
      x86/entry/32: Fix NMI vs ESPFIX

Petr Machata (1):
      mlxsw: spectrum_router: Fix determining underlay for a GRE tunnel

Roi Dayan (1):
      net/mlx5e: Fix set vf link state error flow

Sean Young (1):
      media: imon: invalid dereference in imon_touch_event

Shani Shapp (1):
      net/mlx5: Update the list of the PCI supported devices

Stefano Garzarella (1):
      vhost/vsock: split packets to send using multiple buffers

Sun Ke (1):
      nbd:fix memory leak in nbd_get_socket()

Suwan Kim (1):
      usbip: Fix uninitialized symbol 'nents' in stub_recv_cmd_submit()

Takashi Iwai (1):
      ALSA: usb-audio: Fix NULL dereference at parsing BADD

Tariq Toukan (1):
      net/mlx4_en: Fix wrong limitation for number of TX rings

Thierry Reding (2):
      gpio: max77620: Fixup debounce delays
      gpio: bd70528: Use correct unit for debounce times

Thomas Gleixner (2):
      x86/pti/32: Size initial_page_table correctly
      x86/cpu_entry_area: Add guard page for entry stack on 32bit

Tomas Bortoli (1):
      Bluetooth: Fix invalid-free in bcsp_close()

Vandana BN (1):
      media: vivid: Set vid_cap_streaming and vid_out_streaming to true

Ville Syrj=E4l=E4 (1):
      drm/i915: Don't oops in dumb_create ioctl if we have no crtcs

Vito Caputo (1):
      media: cxusb: detect cxusb_ctrl_msg error in query

Waiman Long (2):
      x86/speculation: Fix incorrect MDS/TAA mitigation status
      x86/speculation: Fix redundant MDS mitigation message

Wei Wang (1):
      virtio_balloon: fix shrinker count

Willem de Bruijn (1):
      net/tls: enable sk_msg redirect to tls socket egress

Xin Long (1):
      net: sched: ensure opts_len <=3D IP_TUNNEL_OPTS_MAX in act_tunnel_key

Yang Tao (1):
      futex: Prevent robust futex exit race


--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl3jivcACgkQONu9yGCS
aT5VQg//RYgQvsisgPVH8vrfk8k/XCiFILw1TjPZ4PX96mdMcxn9VTAyuLHQMvl3
Us2zly+IlHTSO31tw7Z1JYtMK0IEi1yPm9hcZs62LAO4W5P2BEEN0xjMllE79Fxv
iT5JeDG4jru8ub6gV51Vv2bVOxbwTP6o5LqXEwexfBJKZNLq9JBbdwq72sD+y4jW
ZRRhQWnG5ehqzSuouAVvcCNRt8RDVas2tFWCLA1xFYtAN093jCQwa7659HO8yLFV
Pz7Z25kCKGvhvFRDUFzeD7z/g3cnKZEFBw9atf7ef7cWFVERgnQHospn7Gv9ShqL
TzzjUFV1+CM2R83DKQtHpz7D3L8FHGNwDgtFpbhqBIcZviUBdyBPlEXk1VCt7PFg
6vjc0n0tIC0DqX42lFwtihmaIIQD8b2yAGugbbkJ+6ccPJGrl6UWwjHSELSwf2Q3
qIMKNBkdYHYolDV0KPX841/9l7nokFrg9wOzgrQaMMGS1ORkDOWvUCRECLat88/0
XyZRoLMLt/iqt16UZzwW9uXFYfdUHt/+AxBPQ6eDUXZ1bVFMgE9K//Vs4ZT5mSXv
khMb6wMDzIAHJKiFmpu8n9QRKjxef0Mytut50vy3ecITs9LhcF67ZMuKk1OVz9s1
/1EVHdwTeyhDdN4D+E8Af0pRf/DeNGq2maz97N4DFqREiS5pBRM=
=r9tD
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--
