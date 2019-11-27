Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8C5A10BC40
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732992AbfK0VKO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:10:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:37186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727317AbfK0VKN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:10:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 423E92154A;
        Wed, 27 Nov 2019 21:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574889011;
        bh=+ts+6SNqEuzNPp2CBTnNWetvaqUpchiAmv+tkiawNdE=;
        h=From:To:Cc:Subject:Date:From;
        b=Rr7RPd35n2uM0T0qV8HwEDl0fSV1VzeGdor5eKmZb7iZ4Mf11HK4Vvd2XzIv60cXa
         LfV+1PCCrsbsXytCw6h1b04jsdqa/vhrmVEjuUTYawD4Q4OW1cOcaxAyjVqlrm3UuC
         PU7ErtDvlLMzqHvi2RxifIwOg50mYY8kLRwph+Qs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.3 00/95] 5.3.14-stable review
Date:   Wed, 27 Nov 2019 21:31:17 +0100
Message-Id: <20191127202845.651587549@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.3.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.3.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.3.14-rc1
X-KernelTest-Deadline: 2019-11-29T20:30+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.3.14 release.
There are 95 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 29 Nov 2019 20:18:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.14-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.3.14-rc1

Michael Ellerman <mpe@ellerman.id.au>
    KVM: PPC: Book3S HV: Flush link stack on guest exit to host kernel

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/book3s64: Fix link stack flush on context switch

Christopher M. Riedl <cmr@informatik.wtf>
    powerpc/64s: support nospectre_v2 cmdline option

Bernd Porr <mail@berndporr.me.uk>
    staging: comedi: usbduxfast: usbduxfast_ai_cmdtest rounding error

Aleksander Morgado <aleksander@aleksander.es>
    USB: serial: option: add support for Foxconn T77W968 LTE modules

Aleksander Morgado <aleksander@aleksander.es>
    USB: serial: option: add support for DW5821e with eSIM support

Johan Hovold <johan@kernel.org>
    USB: serial: mos7840: fix remote wakeup

Johan Hovold <johan@kernel.org>
    USB: serial: mos7720: fix remote wakeup

Pavel Löbl <pavel@loebl.cz>
    USB: serial: mos7840: add USB ID to support Moxa UPort 2210

Oliver Neukum <oneukum@suse.com>
    appledisplay: fix error handling in the scheduled work

Oliver Neukum <oneukum@suse.com>
    USB: chaoskey: fix error case of a timeout

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    usb-serial: cp201x: support Mark-10 digital force gauge

Suwan Kim <suwan.kim027@gmail.com>
    usbip: Fix uninitialized symbol 'nents' in stub_recv_cmd_submit()

Hewenliang <hewenliang4@huawei.com>
    usbip: tools: fix fd leakage in the function of read_attr_usbip_status

Oliver Neukum <oneukum@suse.com>
    USBIP: add config dependency for SGL_ALLOC

Alexander Potapenko <glider@google.com>
    mm/slub.c: init_on_free=1 should wipe freelist ptr for bulk allocations

A Sun <as1033x@comcast.net>
    media: mceusb: fix out of bounds read in MCE receiver buffer

Sean Young <sean@mess.org>
    media: imon: invalid dereference in imon_touch_event

Vito Caputo <vcaputo@pengaru.com>
    media: cxusb: detect cxusb_ctrl_msg error in query

Oliver Neukum <oneukum@suse.com>
    media: b2c2-flexcop-usb: add sanity checking

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: uvcvideo: Fix error path in control parsing failure

Kai Shen <shenkai8@huawei.com>
    cpufreq: Add NULL checks to show() and store() methods of cpufreq

Alan Stern <stern@rowland.harvard.edu>
    media: usbvision: Fix races among open, close, and disconnect

Alan Stern <stern@rowland.harvard.edu>
    media: usbvision: Fix invalid accesses after device disconnect

Alexander Popov <alex.popov@linux.com>
    media: vivid: Fix wrong locking that causes race conditions on streaming stop

Vandana BN <bnvandana@gmail.com>
    media: vivid: Set vid_cap_streaming and vid_out_streaming to true

Jouni Hogander <jouni.hogander@unikie.com>
    net-sysfs: Fix reference count leak in rx|netdev_queue_add_kobject

Oliver Neukum <oneukum@suse.com>
    nfc: port100: handle command failure cleanly

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix NULL dereference at parsing BADD

Yang Tao <yang.tao172@zte.com.cn>
    futex: Prevent robust futex exit race

Andy Lutomirski <luto@kernel.org>
    x86/entry/32: Fix FIXUP_ESPFIX_STACK with user CR3

Ingo Molnar <mingo@kernel.org>
    x86/pti/32: Calculate the various PTI cpu_entry_area sizes correctly, make the CPU_ENTRY_AREA_PAGES assert precise

Andy Lutomirski <luto@kernel.org>
    selftests/x86/sigreturn/32: Invalidate DS and ES when abusing the kernel

Andy Lutomirski <luto@kernel.org>
    selftests/x86/mov_ss_trap: Fix the SYSENTER test

Peter Zijlstra <peterz@infradead.org>
    x86/entry/32: Fix NMI vs ESPFIX

Andy Lutomirski <luto@kernel.org>
    x86/entry/32: Unwind the ESPFIX stack earlier on exception entry

Andy Lutomirski <luto@kernel.org>
    x86/entry/32: Move FIXUP_FRAME after pushing %fs in SAVE_ALL

Andy Lutomirski <luto@kernel.org>
    x86/entry/32: Use %ss segment where required

Peter Zijlstra <peterz@infradead.org>
    x86/entry/32: Fix IRET exception

Thomas Gleixner <tglx@linutronix.de>
    x86/cpu_entry_area: Add guard page for entry stack on 32bit

Thomas Gleixner <tglx@linutronix.de>
    x86/pti/32: Size initial_page_table correctly

Andy Lutomirski <luto@kernel.org>
    x86/doublefault/32: Fix stack canaries in the double fault handler

Jan Beulich <jbeulich@suse.com>
    x86/xen/32: Simplify ring check in xen_iret_crit_fixup()

Jan Beulich <jbeulich@suse.com>
    x86/xen/32: Make xen_iret_crit_fixup() independent of frame layout

Jan Beulich <jbeulich@suse.com>
    x86/stackframe/32: Repair 32-bit Xen PV

Adi Suresh <adisuresh@google.com>
    gve: fix dma sync bug where not all pages synced

Navid Emamdoost <navid.emamdoost@gmail.com>
    nbd: prevent memory leak

Waiman Long <longman@redhat.com>
    x86/speculation: Fix redundant MDS mitigation message

Waiman Long <longman@redhat.com>
    x86/speculation: Fix incorrect MDS/TAA mitigation status

Alexander Kapshuk <alexander.kapshuk@gmail.com>
    x86/insn: Fix awk regexp warnings

Chester Lin <clin@suse.com>
    ARM: 8904/1: skip nomap memblocks while finding the lowmem/highmem boundary

Geert Uytterhoeven <geert+renesas@glider.be>
    mdio_bus: Fix init if CONFIG_RESET_CONTROLLER=n

John Pittman <jpittman@redhat.com>
    md/raid10: prevent access of uninitialized resync_pages offset

Mike Snitzer <snitzer@redhat.com>
    Revert "dm crypt: use WQ_HIGHPRI for the IO and crypt workqueues"

Adam Ford <aford173@gmail.com>
    Revert "Bluetooth: hci_ll: set operational frequency earlier"

Denis Efremov <efremov@linux.com>
    ath9k_hw: fix uninitialized variable data

Hui Peng <benquike@gmail.com>
    ath10k: Fix a NULL-ptr-deref bug in ath10k_usb_alloc_urb_from_pipe

Bjorn Andersson <bjorn.andersson@linaro.org>
    ath10k: Fix HOST capability QMI incompatibility

Christian Lamparter <chunkeey@gmail.com>
    ath10k: restore QCA9880-AR1A (v1) detection

Tomas Bortoli <tomasbortoli@gmail.com>
    Bluetooth: Fix invalid-free in bcsp_close()

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/userptr: Try to acquire the page lock around set_page_dirty()

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/pmu: "Frequency" is reported as accumulated cycles

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Don't oops in dumb_create ioctl if we have no crtcs

Evan Quan <evan.quan@amd.com>
    drm/amd/powerplay: issue no PPSMC_MSG_GetCurrPkgPwr on unsupported ASICs

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: disable gfxoff on original raven

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: disable gfxoff when using register read interface

Andrey Ryabinin <aryabinin@virtuozzo.com>
    mm/ksm.c: don't WARN if page is still mapped in remove_stable_node()

David Hildenbrand <david@redhat.com>
    mm/memory_hotplug: don't access uninitialized memmaps in shrink_zone_span()

Joseph Qi <joseph.qi@linux.alibaba.com>
    Revert "fs: ocfs2: fix possible null-pointer dereferences in ocfs2_xa_prepare_entry()"

Wei Wang <wei.w.wang@intel.com>
    virtio_balloon: fix shrinker count

Halil Pasic <pasic@linux.ibm.com>
    virtio_ring: fix return code on DMA mapping fails

Laurent Vivier <lvivier@redhat.com>
    virtio_console: allocate inbufs in add_port() only if it is needed

Sun Ke <sunke32@huawei.com>
    nbd:fix memory leak in nbd_get_socket()

Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
    fork: fix pidfd_poll()'s return type

Laura Abbott <labbott@redhat.com>
    tools: gpio: Correctly add make dependencies for gpio_utils

Thierry Reding <treding@nvidia.com>
    gpio: bd70528: Use correct unit for debounce times

Thierry Reding <treding@nvidia.com>
    gpio: max77620: Fixup debounce delays

Stefano Garzarella <sgarzare@redhat.com>
    vhost/vsock: split packets to send using multiple buffers

Shani Shapp <shanish@mellanox.com>
    net/mlx5: Update the list of the PCI supported devices

Eran Ben Elisha <eranbe@mellanox.com>
    net/mlx5e: Do not use non-EXT link modes in EXT mode

Eli Cohen <eli@mellanox.com>
    net/mlx5e: Fix error flow cleanup in mlx5e_tc_tun_create_header_ipv4/6

Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
    net/ipv4: fix sysctl max for fib_multipath_hash_policy

Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
    taprio: don't reject same mqprio settings

Hangbin Liu <liuhangbin@gmail.com>
    ipv6/route: return if there is no fib_nh_gw_family

Willem de Bruijn <willemb@google.com>
    net/tls: enable sk_msg redirect to tls socket egress

Maor Gottlieb <maorg@mellanox.com>
    net/mlx5: Fix auto group size calculation

Roi Dayan <roid@mellanox.com>
    net/mlx5e: Fix set vf link state error flow

Eran Ben Elisha <eranbe@mellanox.com>
    net/mlxfw: Verify FSM error code translation doesn't exceed array size

Martin Habets <mhabets@solarflare.com>
    sfc: Only cancel the PPS workqueue if it exists

Xin Long <lucien.xin@gmail.com>
    net: sched: ensure opts_len <= IP_TUNNEL_OPTS_MAX in act_tunnel_key

Davide Caratti <dcaratti@redhat.com>
    net/sched: act_pedit: fix WARN() in the traffic path

Dan Carpenter <dan.carpenter@oracle.com>
    net: rtnetlink: prevent underflows in do_setvfinfo()

Tariq Toukan <tariqt@mellanox.com>
    net/mlx4_en: Fix wrong limitation for number of TX rings

Luigi Rizzo <lrizzo@google.com>
    net/mlx4_en: fix mlx4 ethtool -N insertion

Petr Machata <petrm@mellanox.com>
    mlxsw: spectrum_router: Fix determining underlay for a GRE tunnel


-------------

Diffstat:

 Documentation/admin-guide/hw-vuln/mds.rst          |   7 +-
 .../admin-guide/hw-vuln/tsx_async_abort.rst        |   5 +-
 Documentation/admin-guide/kernel-parameters.txt    |  11 ++
 .../bindings/net/wireless/qcom,ath10k.txt          |   6 +
 Makefile                                           |   4 +-
 arch/arm/mm/mmu.c                                  |   3 +
 arch/powerpc/include/asm/asm-prototypes.h          |   3 +
 arch/powerpc/include/asm/security_features.h       |   3 +
 arch/powerpc/kernel/entry_64.S                     |   6 +
 arch/powerpc/kernel/security.c                     |  74 +++++++-
 arch/powerpc/kvm/book3s_hv_rmhandlers.S            |  30 +++
 arch/x86/entry/entry_32.S                          | 211 +++++++++++++--------
 arch/x86/include/asm/cpu_entry_area.h              |  18 +-
 arch/x86/include/asm/pgtable_32_types.h            |   8 +-
 arch/x86/include/asm/segment.h                     |  12 ++
 arch/x86/kernel/cpu/bugs.c                         |  30 ++-
 arch/x86/kernel/doublefault.c                      |   3 +
 arch/x86/kernel/head_32.S                          |  10 +
 arch/x86/mm/cpu_entry_area.c                       |   4 +-
 arch/x86/tools/gen-insn-attr-x86.awk               |   4 +-
 arch/x86/xen/xen-asm_32.S                          |  75 +++-----
 drivers/block/nbd.c                                |   6 +-
 drivers/bluetooth/hci_bcsp.c                       |   3 +
 drivers/bluetooth/hci_ll.c                         |  39 ++--
 drivers/char/virtio_console.c                      |  28 ++-
 drivers/cpufreq/cpufreq.c                          |   6 +
 drivers/gpio/gpio-bd70528.c                        |   6 +-
 drivers/gpio/gpio-max77620.c                       |   6 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c            |   6 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |   9 +-
 drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c   |  23 ++-
 drivers/gpu/drm/i915/display/intel_display.c       |   3 +
 drivers/gpu/drm/i915/gem/i915_gem_userptr.c        |  22 ++-
 drivers/gpu/drm/i915/i915_pmu.c                    |   4 +-
 drivers/md/dm-crypt.c                              |   9 +-
 drivers/md/raid10.c                                |   2 +-
 drivers/media/platform/vivid/vivid-kthread-cap.c   |   8 +-
 drivers/media/platform/vivid/vivid-kthread-out.c   |   8 +-
 drivers/media/platform/vivid/vivid-sdr-cap.c       |   8 +-
 drivers/media/platform/vivid/vivid-vid-cap.c       |   3 -
 drivers/media/platform/vivid/vivid-vid-out.c       |   3 -
 drivers/media/rc/imon.c                            |   3 +-
 drivers/media/rc/mceusb.c                          | 141 +++++++++-----
 drivers/media/usb/b2c2/flexcop-usb.c               |   3 +
 drivers/media/usb/dvb-usb/cxusb.c                  |   3 +-
 drivers/media/usb/usbvision/usbvision-video.c      |  29 ++-
 drivers/media/usb/uvc/uvc_driver.c                 |  28 +--
 drivers/net/ethernet/google/gve/gve_tx.c           |   9 +-
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c    |   9 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c     |   9 +
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    |  18 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  12 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  10 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h  |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   1 +
 drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c    |   2 +
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |  19 +-
 drivers/net/ethernet/sfc/ptp.c                     |   3 +-
 drivers/net/phy/mdio_bus.c                         |  11 +-
 drivers/net/wireless/ath/ath10k/pci.c              |  36 ++--
 drivers/net/wireless/ath/ath10k/qmi.c              |  13 +-
 drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.c     |  22 +++
 drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.h     |   1 +
 drivers/net/wireless/ath/ath10k/snoc.c             |  11 ++
 drivers/net/wireless/ath/ath10k/snoc.h             |   1 +
 drivers/net/wireless/ath/ath10k/usb.c              |   8 +
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |   2 +-
 drivers/nfc/port100.c                              |   2 +-
 drivers/staging/comedi/drivers/usbduxfast.c        |  21 +-
 drivers/usb/misc/appledisplay.c                    |   8 +-
 drivers/usb/misc/chaoskey.c                        |  24 ++-
 drivers/usb/serial/cp210x.c                        |   1 +
 drivers/usb/serial/mos7720.c                       |   4 -
 drivers/usb/serial/mos7840.c                       |  16 +-
 drivers/usb/serial/option.c                        |   7 +
 drivers/usb/usbip/Kconfig                          |   1 +
 drivers/usb/usbip/stub_rx.c                        |  50 +++--
 drivers/vhost/vsock.c                              |  66 +++++--
 drivers/virtio/virtio_balloon.c                    |   2 +-
 drivers/virtio/virtio_ring.c                       |   4 +-
 fs/ocfs2/xattr.c                                   |  56 +++---
 include/net/tls.h                                  |   2 +
 kernel/fork.c                                      |   6 +-
 kernel/futex.c                                     |  58 +++++-
 mm/ksm.c                                           |  14 +-
 mm/memory_hotplug.c                                |  16 +-
 mm/slub.c                                          |  22 ++-
 net/core/net-sysfs.c                               |  24 +--
 net/core/rtnetlink.c                               |  23 ++-
 net/ipv4/sysctl_net_ipv4.c                         |   2 +-
 net/ipv6/route.c                                   |   2 +-
 net/sched/act_pedit.c                              |  12 +-
 net/sched/act_tunnel_key.c                         |   4 +
 net/sched/sch_taprio.c                             |  28 ++-
 net/tls/tls_main.c                                 |   1 +
 net/tls/tls_sw.c                                   |  11 ++
 net/vmw_vsock/virtio_transport_common.c            |  15 +-
 sound/usb/mixer.c                                  |   3 +
 tools/gpio/Build                                   |   1 +
 tools/gpio/Makefile                                |  10 +-
 tools/objtool/arch/x86/tools/gen-insn-attr-x86.awk |   4 +-
 tools/testing/selftests/x86/mov_ss_trap.c          |   3 +-
 tools/testing/selftests/x86/sigreturn.c            |  13 ++
 tools/usb/usbip/libsrc/usbip_host_common.c         |   2 +-
 105 files changed, 1173 insertions(+), 501 deletions(-)


