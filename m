Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C66610BBF7
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731245AbfK0VR0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:17:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:43938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732841AbfK0VMr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:12:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4DC42086A;
        Wed, 27 Nov 2019 21:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574889166;
        bh=8kYFHItWInMAG8PoGc34q1EWgNv6Miqr2youev64kvg=;
        h=From:To:Cc:Subject:Date:From;
        b=Amic1HcdWcTndxHDxF9AbDdOjcMvsnlbvIOU/qau8YoXrdSkWfFfuehiJif3SfM0I
         NZJkumMBe43FyzO45n+vvEG9pDw6S9V3DXPnSX5NQGW5vaGa6ZKWqSIZde0TdDh9g8
         c0GR0YqQeUFo6KvopvBMuG0fHcn4yZ2XDgCgkWZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.4 00/66] 5.4.1-stable review
Date:   Wed, 27 Nov 2019 21:31:55 +0100
Message-Id: <20191127202632.536277063@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.1-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.1-rc1
X-KernelTest-Deadline: 2019-11-29T20:28+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.1 release.
There are 66 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 29 Nov 2019 20:18:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.1-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.1-rc1

Michael Ellerman <mpe@ellerman.id.au>
    KVM: PPC: Book3S HV: Flush link stack on guest exit to host kernel

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/book3s64: Fix link stack flush on context switch

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

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Disable audio component for legacy Nvidia HDMI codecs

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

Thomas Gleixner <tglx@linutronix.de>
    futex: Prevent exit livelock

Thomas Gleixner <tglx@linutronix.de>
    futex: Provide distinct return value when owner is exiting

Thomas Gleixner <tglx@linutronix.de>
    futex: Add mutex around futex exit

Thomas Gleixner <tglx@linutronix.de>
    futex: Provide state handling for exec() as well

Thomas Gleixner <tglx@linutronix.de>
    futex: Sanitize exit state handling

Thomas Gleixner <tglx@linutronix.de>
    futex: Mark the begin of futex exit explicitly

Thomas Gleixner <tglx@linutronix.de>
    futex: Set task::futex_state to DEAD right after handling futex exit

Thomas Gleixner <tglx@linutronix.de>
    futex: Split futex_mm_release() for exit/exec

Thomas Gleixner <tglx@linutronix.de>
    exit/exec: Seperate mm_release()

Thomas Gleixner <tglx@linutronix.de>
    futex: Replace PF_EXITPIDONE with a state

Thomas Gleixner <tglx@linutronix.de>
    futex: Move futex exit handling into futex code

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

Geoffrey D. Bennett <g@b4.vu>
    ALSA: usb-audio: Fix Scarlett 6i6 Gen 2 port data

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

Navid Emamdoost <navid.emamdoost@gmail.com>
    nbd: prevent memory leak

Waiman Long <longman@redhat.com>
    x86/speculation: Fix redundant MDS mitigation message

Waiman Long <longman@redhat.com>
    x86/speculation: Fix incorrect MDS/TAA mitigation status

Alexander Kapshuk <alexander.kapshuk@gmail.com>
    x86/insn: Fix awk regexp warnings

John Pittman <jpittman@redhat.com>
    md/raid10: prevent access of uninitialized resync_pages offset

Mike Snitzer <snitzer@redhat.com>
    Revert "dm crypt: use WQ_HIGHPRI for the IO and crypt workqueues"

Adam Ford <aford173@gmail.com>
    Revert "Bluetooth: hci_ll: set operational frequency earlier"

Christian Lamparter <chunkeey@gmail.com>
    ath10k: restore QCA9880-AR1A (v1) detection

Bjorn Andersson <bjorn.andersson@linaro.org>
    ath10k: Fix HOST capability QMI incompatibility

Hui Peng <benquike@gmail.com>
    ath10k: Fix a NULL-ptr-deref bug in ath10k_usb_alloc_urb_from_pipe

Denis Efremov <efremov@linux.com>
    ath9k_hw: fix uninitialized variable data

Tomas Bortoli <tomasbortoli@gmail.com>
    Bluetooth: Fix invalid-free in bcsp_close()


-------------

Diffstat:

 Documentation/admin-guide/hw-vuln/mds.rst          |   7 +-
 .../admin-guide/hw-vuln/tsx_async_abort.rst        |   5 +-
 Documentation/admin-guide/kernel-parameters.txt    |  11 +
 .../bindings/net/wireless/qcom,ath10k.txt          |   6 +
 Makefile                                           |   4 +-
 arch/powerpc/include/asm/asm-prototypes.h          |   3 +
 arch/powerpc/include/asm/security_features.h       |   3 +
 arch/powerpc/kernel/entry_64.S                     |   6 +
 arch/powerpc/kernel/security.c                     |  57 +++-
 arch/powerpc/kvm/book3s_hv_rmhandlers.S            |  30 ++
 arch/x86/entry/entry_32.S                          | 211 +++++++++-----
 arch/x86/include/asm/cpu_entry_area.h              |  18 +-
 arch/x86/include/asm/pgtable_32_types.h            |   8 +-
 arch/x86/include/asm/segment.h                     |  12 +
 arch/x86/kernel/cpu/bugs.c                         |  30 +-
 arch/x86/kernel/doublefault.c                      |   3 +
 arch/x86/kernel/head_32.S                          |  10 +
 arch/x86/mm/cpu_entry_area.c                       |   4 +-
 arch/x86/tools/gen-insn-attr-x86.awk               |   4 +-
 arch/x86/xen/xen-asm_32.S                          |  75 ++---
 drivers/block/nbd.c                                |   5 +-
 drivers/bluetooth/hci_bcsp.c                       |   3 +
 drivers/bluetooth/hci_ll.c                         |  39 ++-
 drivers/cpufreq/cpufreq.c                          |   6 +
 drivers/md/dm-crypt.c                              |   9 +-
 drivers/md/raid10.c                                |   2 +-
 drivers/media/platform/vivid/vivid-kthread-cap.c   |   8 +-
 drivers/media/platform/vivid/vivid-kthread-out.c   |   8 +-
 drivers/media/platform/vivid/vivid-sdr-cap.c       |   8 +-
 drivers/media/platform/vivid/vivid-vid-cap.c       |   3 -
 drivers/media/platform/vivid/vivid-vid-out.c       |   3 -
 drivers/media/rc/imon.c                            |   3 +-
 drivers/media/rc/mceusb.c                          | 141 ++++++---
 drivers/media/usb/b2c2/flexcop-usb.c               |   3 +
 drivers/media/usb/dvb-usb/cxusb.c                  |   3 +-
 drivers/media/usb/usbvision/usbvision-video.c      |  29 +-
 drivers/media/usb/uvc/uvc_driver.c                 |  28 +-
 drivers/net/wireless/ath/ath10k/pci.c              |  36 ++-
 drivers/net/wireless/ath/ath10k/qmi.c              |  13 +-
 drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.c     |  22 ++
 drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.h     |   1 +
 drivers/net/wireless/ath/ath10k/snoc.c             |  11 +
 drivers/net/wireless/ath/ath10k/snoc.h             |   1 +
 drivers/net/wireless/ath/ath10k/usb.c              |   8 +
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |   2 +-
 drivers/staging/comedi/drivers/usbduxfast.c        |  21 +-
 drivers/usb/misc/appledisplay.c                    |   8 +-
 drivers/usb/misc/chaoskey.c                        |  24 +-
 drivers/usb/serial/cp210x.c                        |   1 +
 drivers/usb/serial/mos7720.c                       |   4 -
 drivers/usb/serial/mos7840.c                       |  16 +-
 drivers/usb/serial/option.c                        |   7 +
 drivers/usb/usbip/Kconfig                          |   1 +
 drivers/usb/usbip/stub_rx.c                        |  50 ++--
 fs/exec.c                                          |   2 +-
 include/linux/compat.h                             |   2 -
 include/linux/futex.h                              |  40 ++-
 include/linux/sched.h                              |   3 +-
 include/linux/sched/mm.h                           |   6 +-
 kernel/exit.c                                      |  30 +-
 kernel/fork.c                                      |  40 +--
 kernel/futex.c                                     | 324 ++++++++++++++++++---
 sound/pci/hda/patch_hdmi.c                         |  22 --
 sound/usb/mixer.c                                  |   3 +
 sound/usb/mixer_scarlett_gen2.c                    |  36 +--
 tools/arch/x86/tools/gen-insn-attr-x86.awk         |   4 +-
 tools/testing/selftests/x86/mov_ss_trap.c          |   3 +-
 tools/testing/selftests/x86/sigreturn.c            |  13 +
 tools/usb/usbip/libsrc/usbip_host_common.c         |   2 +-
 69 files changed, 1091 insertions(+), 473 deletions(-)


