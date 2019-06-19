Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBB6E4B8B1
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 14:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbfFSMgE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 08:36:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:32884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727068AbfFSMgE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Jun 2019 08:36:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09BC4206BA;
        Wed, 19 Jun 2019 12:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560947762;
        bh=1/lIH/2p/MXIUm/JrRhRFTV3fLYpegY5TY6dkkChqRo=;
        h=Date:From:To:Cc:Subject:From;
        b=x6NhdgVd5rYgAMQuF5kzz7pD0rr6X/AsZ40Yk8K1W/t6sFZ1V3MlySmkGRnVCzyo9
         cRWzb2uEG/WfNpIOHWiIYRFs0t/TK2zim88VzLreejsg+d76SdqGyskcwYbPdp91H2
         FQoY4LxA+/SPOxMkm/H6TtGDJQFldpCtzX89Kips=
Date:   Wed, 19 Jun 2019 14:35:59 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.1.12
Message-ID: <20190619123559.GA6772@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="YiEDa0DAkWCtVeE4"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.1.12 kernel.

All users of the 5.1 kernel series must upgrade.

The updated 5.1.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.1.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                            |    2=20
 arch/arm/kvm/hyp/Makefile                           |    1=20
 arch/arm64/kvm/hyp/Makefile                         |    1=20
 arch/arm64/mm/fault.c                               |    5=20
 arch/arm64/mm/mmu.c                                 |   11=20
 arch/powerpc/include/asm/book3s/64/pgtable.h        |   30 ++
 arch/powerpc/include/asm/kexec.h                    |    3=20
 arch/powerpc/kernel/machine_kexec_32.c              |    4=20
 arch/powerpc/mm/pgtable-book3s64.c                  |    3=20
 arch/s390/kvm/kvm-s390.c                            |   35 +--
 arch/x86/kernel/cpu/microcode/core.c                |    2=20
 arch/x86/kernel/cpu/resctrl/monitor.c               |    3=20
 arch/x86/kvm/pmu.c                                  |   10=20
 arch/x86/kvm/pmu.h                                  |    3=20
 arch/x86/kvm/pmu_amd.c                              |    2=20
 arch/x86/kvm/svm.c                                  |    9=20
 arch/x86/kvm/vmx/nested.c                           |    2=20
 arch/x86/kvm/vmx/pmu_intel.c                        |   26 +-
 arch/x86/kvm/vmx/vmx.c                              |   26 +-
 arch/x86/kvm/vmx/vmx.h                              |    1=20
 arch/x86/kvm/x86.c                                  |    2=20
 arch/x86/mm/kasan_init_64.c                         |    2=20
 arch/x86/mm/kaslr.c                                 |   11=20
 drivers/ata/libata-core.c                           |    9=20
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c             |    4=20
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c               |    1=20
 drivers/gpu/drm/amd/amdgpu/uvd_v6_0.c               |    5=20
 drivers/gpu/drm/amd/amdgpu/uvd_v7_0.c               |    5=20
 drivers/gpu/drm/drm_edid.c                          |   55 ++++
 drivers/gpu/drm/drm_probe_helper.c                  |    7=20
 drivers/gpu/drm/i915/intel_csr.c                    |   18 +
 drivers/gpu/drm/i915/intel_display.c                |   14 -
 drivers/gpu/drm/i915/intel_drv.h                    |    1=20
 drivers/gpu/drm/i915/intel_dsi_vbt.c                |   11=20
 drivers/gpu/drm/i915/intel_sdvo.c                   |   58 ++++-
 drivers/gpu/drm/i915/intel_sdvo_regs.h              |    3=20
 drivers/gpu/drm/nouveau/Kconfig                     |   13 +
 drivers/gpu/drm/nouveau/nouveau_drm.c               |    7=20
 drivers/gpu/drm/nouveau/nouveau_ttm.c               |    4=20
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c             |    7=20
 drivers/hid/hid-core.c                              |   13 -
 drivers/hid/hid-input.c                             |   81 ++++---
 drivers/hid/hid-multitouch.c                        |    7=20
 drivers/hid/wacom_wac.c                             |   71 ++++--
 drivers/i2c/busses/i2c-acorn.c                      |    1=20
 drivers/iommu/arm-smmu.c                            |   15 +
 drivers/md/bcache/bset.c                            |   16 +
 drivers/md/bcache/bset.h                            |   34 +--
 drivers/md/bcache/sysfs.c                           |    7=20
 drivers/media/dvb-core/dvb_frontend.c               |    2=20
 drivers/misc/kgdbts.c                               |    4=20
 drivers/net/ethernet/cadence/macb_main.c            |   16 -
 drivers/net/ethernet/freescale/enetc/enetc.c        |    4=20
 drivers/net/usb/ipheth.c                            |    3=20
 drivers/nvdimm/bus.c                                |    4=20
 drivers/nvdimm/label.c                              |    2=20
 drivers/nvdimm/label.h                              |    2=20
 drivers/nvme/host/core.c                            |   74 ++++--
 drivers/nvme/host/pci.c                             |   14 -
 drivers/perf/arm_spe_pmu.c                          |   10=20
 drivers/platform/x86/pmc_atom.c                     |   33 ++
 drivers/ras/cec.c                                   |   80 +++----
 drivers/scsi/bnx2fc/bnx2fc_hwi.c                    |    2=20
 drivers/scsi/lpfc/lpfc_attr.c                       |   37 +--
 drivers/scsi/lpfc/lpfc_els.c                        |    5=20
 drivers/scsi/lpfc/lpfc_sli.c                        |   84 ++++---
 drivers/scsi/myrs.c                                 |    2=20
 drivers/scsi/qedi/qedi_dbg.c                        |   32 --
 drivers/scsi/qedi/qedi_iscsi.c                      |    4=20
 drivers/scsi/qla2xxx/qla_os.c                       |  221 +++++++--------=
-----
 drivers/usb/core/quirks.c                           |    3=20
 drivers/usb/dwc2/hcd.c                              |   39 ++-
 drivers/usb/dwc2/hcd.h                              |   20 -
 drivers/usb/dwc2/hcd_intr.c                         |    5=20
 drivers/usb/dwc2/hcd_queue.c                        |   10=20
 drivers/usb/serial/option.c                         |    6=20
 drivers/usb/serial/pl2303.c                         |    1=20
 drivers/usb/serial/pl2303.h                         |    3=20
 drivers/usb/storage/unusual_realtek.h               |    5=20
 fs/f2fs/xattr.c                                     |   36 ++-
 fs/f2fs/xattr.h                                     |    2=20
 fs/io_uring.c                                       |    4=20
 fs/ocfs2/dcache.c                                   |   12 +
 include/drm/drm_edid.h                              |    1=20
 include/linux/cgroup.h                              |   10=20
 include/linux/cpuhotplug.h                          |    1=20
 include/linux/hid.h                                 |    2=20
 kernel/Makefile                                     |    1=20
 kernel/cred.c                                       |    9=20
 kernel/ptrace.c                                     |   20 +
 kernel/time/timekeeping.c                           |    5=20
 kernel/trace/trace_events_hist.c                    |    3=20
 kernel/trace/trace_uprobe.c                         |   13 -
 mm/list_lru.c                                       |    2=20
 mm/vmscan.c                                         |    2=20
 net/core/skmsg.c                                    |    7=20
 net/ipv4/tcp_bpf.c                                  |    7=20
 security/selinux/avc.c                              |   10=20
 security/selinux/hooks.c                            |   39 ++-
 security/smack/smack_lsm.c                          |   12 -
 sound/core/seq/seq_clientmgr.c                      |   10=20
 sound/core/seq/seq_ports.c                          |   13 -
 sound/core/seq/seq_ports.h                          |    5=20
 sound/firewire/motu/motu-stream.c                   |    2=20
 sound/firewire/oxfw/oxfw.c                          |    3=20
 sound/pci/hda/patch_realtek.c                       |   91 +++++---
 sound/pci/ice1712/ews.c                             |    2=20
 sound/soc/codecs/cs42xx8.c                          |    1=20
 sound/soc/fsl/fsl_asrc.c                            |    4=20
 sound/soc/soc-core.c                                |    7=20
 sound/soc/soc-dapm.c                                |    3=20
 tools/bpf/bpftool/prog.c                            |    4=20
 tools/io_uring/Makefile                             |    2=20
 tools/kvm/kvm_stat/kvm_stat                         |   16 +
 tools/kvm/kvm_stat/kvm_stat.txt                     |    2=20
 tools/testing/selftests/bpf/bpf_helpers.h           |    2=20
 tools/testing/selftests/kvm/dirty_log_test.c        |    2=20
 tools/testing/selftests/kvm/lib/aarch64/processor.c |    2=20
 tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c   |    5=20
 tools/testing/selftests/net/fib_rule_tests.sh       |    2=20
 tools/testing/selftests/timers/adjtick.c            |    1=20
 tools/testing/selftests/timers/leapcrash.c          |    1=20
 tools/testing/selftests/timers/mqueue-lat.c         |    1=20
 tools/testing/selftests/timers/nanosleep.c          |    1=20
 tools/testing/selftests/timers/nsleep-lat.c         |    1=20
 tools/testing/selftests/timers/raw_skew.c           |    1=20
 tools/testing/selftests/timers/set-tai.c            |    1=20
 tools/testing/selftests/timers/set-tz.c             |    2=20
 tools/testing/selftests/timers/threadtest.c         |    1=20
 tools/testing/selftests/timers/valid-adjtimex.c     |    2=20
 virt/kvm/arm/aarch32.c                              |  121 ----------
 virt/kvm/arm/hyp/aarch32.c                          |  136 ++++++++++++
 132 files changed, 1295 insertions(+), 738 deletions(-)

Alexei Starovoitov (1):
      selftests/bpf: fix bpf_get_current_task

Andrew Jones (2):
      kvm: selftests: aarch64: dirty_log_test: fix unaligned memslot size
      kvm: selftests: aarch64: fix default vm mode

Andrey Ryabinin (1):
      x86/kasan: Fix boot with 5-level paging and KASAN

Baoquan He (1):
      x86/mm/KASLR: Compute the size of the vmemmap section properly

Benjamin Tissoires (4):
      HID: input: make sure the wheel high resolution multiplier is set
      HID: input: fix assignment of .value
      Revert "HID: Increase maximum report size allowed by hid_field_extrac=
t()"
      HID: multitouch: handle faulty Elo touch device

Bernd Eckstein (1):
      usbnet: ipheth: fix racing condition

Borislav Petkov (2):
      RAS/CEC: Fix binary search function
      x86/microcode, cpuhotplug: Add a microcode loader CPU hotplug callback

Casey Schaufler (1):
      Smack: Restore the smackfsdef mount option and add missing prefixes

Chris Packham (1):
      USB: serial: pl2303: add Allied Telesis VT-Kit3

Christian Borntraeger (1):
      KVM: s390: fix memory slot handling for KVM_SET_USER_MEMORY_REGION

Christoph Hellwig (4):
      nvme: fix srcu locking on error return in nvme_get_ns_from_disk
      nvme: remove the ifdef around nvme_nvm_ioctl
      nvme: merge nvme_ns_ioctl into nvme_ioctl
      nvme: release namespace SRCU protection before performing controller =
ioctls

Christophe Leroy (1):
      powerpc: Fix kexec failure on book3s/32

Claudiu Manoil (1):
      enetc: Fix NULL dma address unmap for Tx BD extensions

Colin Ian King (1):
      scsi: bnx2fc: fix incorrect cast to u64 on shift operation

Coly Li (2):
      bcache: fix stack corruption by PRECEDING_KEY()
      bcache: only set BCACHE_DEV_WB_RUNNING when cached device attached

Cong Wang (1):
      RAS/CEC: Convert the timer callback to a workqueue

Dan Carpenter (1):
      KVM: selftests: Fix a condition in test_hv_cpuid()

Daniele Palmas (1):
      USB: serial: option: add Telit 0x1260 and 0x1261 compositions

Dave Airlie (1):
      drm/nouveau: add kconfig option to turn off nouveau legacy contexts. =
(v3)

Douglas Anderson (1):
      usb: dwc2: host: Fix wMaxPacketSize handling (fix webcam regression)

Eiichi Tsukata (1):
      tracing/uprobe: Fix NULL pointer dereference in trace_uprobe_create()

Eric Biggers (1):
      io_uring: fix memory leak of UNIX domain socket inode

Eric W. Biederman (1):
      signal/ptrace: Don't leak unitialized kernel memory with PTRACE_PEEK_=
SIGINFO

Flora Cui (1):
      drm/amdgpu: keep stolen memory on picasso

Gen Zhang (2):
      selinux: fix a missing-check bug in selinux_add_mnt_opt( )
      selinux: fix a missing-check bug in selinux_sb_eat_lsm_opts()

Greg Kroah-Hartman (1):
      Linux 5.1.12

Hangbin Liu (1):
      selftests: fib_rule_tests: fix local IPv4 address typo

Hans de Goede (3):
      libata: Extend quirks for the ST1000LM024 drives with NOLPM quirk
      drm/i915/dsi: Use a fuzzy check for burst mode clock check
      platform/x86: pmc_atom: Add Lex 3I380D industrial PC to critclk_syste=
ms DMI table

Hui Wang (1):
      Revert "ALSA: hda/realtek - Improve the headset mic for Acer Aspire l=
aptops"

James Morse (1):
      KVM: arm/arm64: Move cc/it checks under hyp's Makefile to avoid instr=
umentation

James Smart (3):
      scsi: lpfc: resolve lockdep warnings
      scsi: lpfc: correct rcu unlock issue in lpfc_nvme_info_show
      scsi: lpfc: add check for loss of ndlp when sending RRQ

Jani Nikula (2):
      drm/edid: abstract override/firmware EDID retrieval
      drm: add fallback override/firmware EDID modes workaround

Jann Horn (1):
      ptrace: restore smp_rmb() in __ptrace_may_access()

Jason Gerecke (5):
      HID: wacom: Don't set tool type until we're in range
      HID: wacom: Don't report anything prior to the tool entering range
      HID: wacom: Send BTN_TOUCH in response to INTUOSP2_BT eraser contact
      HID: wacom: Correct button numbering 2nd-gen Intuos Pro over Bluetooth
      HID: wacom: Sync INTUOSP2_BT touch state after each frame if necessary

Jens Axboe (1):
      tools/io_uring: fix Makefile for pthread library link

John Fastabend (4):
      bpf: sockmap, only stop/flush strp if it was enabled at some point
      bpf: sockmap remove duplicate queue free
      bpf: sockmap fix msg->sg.size account on ingress skb
      bpf, tcp: correctly handle DONT_WAIT flags and timeo =3D=3D 0

J=F6rgen Storvist (1):
      USB: serial: option: add support for Simcom SIM7500/SIM7600 RNDIS mode

Kai-Heng Feng (1):
      USB: usb-storage: Add new ID to ums-realtek

Kailang Yang (1):
      ALSA: hda/realtek - Update headset mode for ALC256

Kees Cook (1):
      selftests/timers: Add missing fflush(stdout) calls

Keith Busch (2):
      nvme-pci: Fix controller freeze wait disabling
      nvme-pci: use blk-mq mapping for unmanaged irqs

Kuninori Morimoto (1):
      ASoC: soc-core: fixup references at soc_cleanup_card_resources()

Luca Ceresoli (1):
      net: macb: fix error format in dev_err()

Lucas De Marchi (1):
      drm/i915/dmc: protect against reading random memory

Marco Zatta (1):
      USB: Fix chipmunk-like voice when using Logitech C270 for recording a=
udio.

Mark Rutland (1):
      arm64/mm: Inhibit huge-vmap with ptdump

Martin Schiller (1):
      usb: dwc2: Fix DMA cache alignment issues

Minchan Kim (1):
      mm/vmscan.c: fix trying to reclaim unevictable LRU page

Murray McAllister (2):
      drm/vmwgfx: integer underflow in vmw_cmd_dx_set_shader() leading to a=
n invalid read
      drm/vmwgfx: NULL pointer dereference from vmw_cmd_dx_view_define()

Nicholas Piggin (1):
      powerpc/64s: Fix THP PMD collapse serialisation

Ondrej Mosnacek (1):
      selinux: log raw contexts as untrusted strings

Paolo Bonzini (4):
      KVM: nVMX: really fix the size checks on KVM_SET_NESTED_STATE
      KVM: x86: do not spam dmesg with VMCS/VMCB dumps
      KVM: x86/pmu: mask the result of rdpmc according to the width of the =
counters
      KVM: x86/pmu: do not mask the value that is written to fixed PMUs

Peter Zijlstra (1):
      x86/uaccess, kcov: Disable stack protector

Prarit Bhargava (1):
      x86/resctrl: Prevent NULL pointer dereference when local MBM is disab=
led

Qian Cai (1):
      libnvdimm: Fix compilation warnings with W=3D1

Quinn Tran (1):
      scsi: qla2xxx: Add cleanup for PCI EEH recovery

Randall Huang (1):
      f2fs: fix to avoid accessing xattr across the boundary

Robin Murphy (1):
      iommu/arm-smmu: Avoid constant zero in TLBI writes

Rui Nuno Capela (1):
      ALSA: ice1712: Check correct return value to snd_i2c_sendbytes (EWS/D=
MX 6Fire)

Russell King (1):
      i2c: acorn: fix i2c warning

S.j. Wang (2):
      ASoC: cs42xx8: Add regcache mask dirty
      ASoC: fsl_asrc: Fix the issue about unsupported rate

Sean Young (1):
      media: dvb: warning about dvb frequency limits produces too much noise

Shakeel Butt (1):
      mm/list_lru.c: fix memory leak in __memcg_init_list_lru_node

Shirish S (1):
      drm/amdgpu/{uvd,vcn}: fetch ring's read_ptr after alloc

Stefan Raspl (1):
      tools/kvm_stat: fix fields filter for child events

Steffen Dirkwinkel (1):
      platform/x86: pmc_atom: Add several Beckhoff Automation boards to cri=
tclk_systems DMI table

Takashi Iwai (3):
      ALSA: seq: Protect in-kernel ioctl calls with mutex
      ALSA: seq: Fix race of get-subscription call vs port-delete ioctls
      Revert "ALSA: seq: Protect in-kernel ioctl calls with mutex"

Takashi Sakamoto (2):
      ALSA: oxfw: allow PCM capture for Stanton SCS.1m
      ALSA: firewire-motu: fix destruction of data for isochronous resources

Tejun Heo (1):
      cgroup: Use css_tryget() instead of css_tryget_online() in task_get_c=
ss()

Thomas Backlund (1):
      nouveau: Fix build with CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT disabled

Thomas Gleixner (1):
      timekeeping: Repair ktime_get_coarse*() granularity

Tom Zanussi (1):
      tracing: Prevent hist_field_var_ref() from accessing NULL tracing_map=
_elts

Ville Syrj=E4l=E4 (2):
      drm/i915/sdvo: Implement proper HDMI audio support for SDVO
      drm/i915: Fix per-pixel alpha with CCS

Wanpeng Li (1):
      KVM: LAPIC: Fix lapic_timer_advance_ns parameter overflow

Wengang Wang (1):
      fs/ocfs2: fix race in ocfs2_dentry_attach_lock()

Will Deacon (2):
      drivers/perf: arm_spe: Don't error on high-order pages for aux buf
      arm64: Print physical address of page table base in show_pte()

Yi Wang (1):
      kvm: vmx: Fix -Wmissing-prototypes warnings

Yonghong Song (1):
      tools/bpftool: move set_max_rlimit() before __bpf_object__open_xattr()

Young Xiao (1):
      Drivers: misc: fix out-of-bounds access in function param_set_kgdbts_=
var

YueHaibing (3):
      scsi: qedi: remove memset/memcpy to nfunc and use func instead
      scsi: qedi: remove set but not used variables 'cdev' and 'udev'
      scsi: myrs: Fix uninitialized variable

Yufen Yu (1):
      nvme: fix memory leak for power latency tolerance


--YiEDa0DAkWCtVeE4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl0KLC8ACgkQONu9yGCS
aT7ZzBAAwdZY3DXtjEC/+4ythRLQ8lf2bbMuSXXVd2DJYsp3pfVjeIwqa7r6FZZU
2nuTKOcvD+Ayvhz29BcYyth05zD191H1XslxswoiS3XvR+kvrYb9+t1EbH2HWofD
1fMc+QHYWVG02oNdY5Ti4UZFu991covn4qWklXy74MU4F/zP7gIzcsQ9Y4EqhRel
KLdmYowZk/ghzYOkYb8Vs2lc5ZV0cf7MLlCErYVSovQlKZja1Jt993EPrXHNBz6I
9QCYFjrokrMfShjZi1Mfd2evFEQEdA7EoyBcBzLiwntEgJxEyMOrqZ1+/fVjjfsR
6Kp+aGL+hfIG32DkfXFw9hM6CzqK7AutKfjuZemlZJUz4NNz0GeVoo6TTokXC+C2
g/gRHXXPcGd3IJBhS2WNuLAQKSLpS/Qpm/B/uCEi9gqPHtmsAIfqdGE+cNGQMKGf
Tg+kcurNhSgyjBcF6PN3qS/p2Ly86nkhvIdKPV3Kty3g+rIhSPTSZrDY90XdDyO4
PYzskWCVogwuoIMu9oq1Qbm7F2lSBdS/uzBCSUVT9Ory1fV2j/NDakOfJk2p+Axg
Gs4HfJy7pN1P2bhX9bLV+UIS8h4TwcwpSahqR1zqgw2FCbBH4B0vXhmz5XMaSzHy
hF072XllMr2+c+Kp47eqGyhbaFCY0btOjJ+Rmcy2fQ9XzuR1WRY=
=rnqK
-----END PGP SIGNATURE-----

--YiEDa0DAkWCtVeE4--
