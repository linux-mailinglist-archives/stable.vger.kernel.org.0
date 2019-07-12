Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEC7266DDC
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728132AbfGLMeN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:34:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:53844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729292AbfGLMeJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:34:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 052C32166E;
        Fri, 12 Jul 2019 12:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934848;
        bh=Tg3b//guk9mChpl243Odm/KtZH9S1/HTILV9teMF4M8=;
        h=From:To:Cc:Subject:Date:From;
        b=x8PTlC7OhF04Yj7R2U8ojFFD0SJXEyMSh29RauMWm0kQv2zcJ1/cRX53fB1Ih0sqr
         5t3vKN4OSR5Ppv57bPl8cdB0KMPKEVQgiQRWl7TShBAGSKr+xjbexLPq8Bu8dMmd+u
         sh+hpIBWmRS+pNHc2FNc9K+WzCSCZizN19A0CjMA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.2 00/61] 5.2.1-stable review
Date:   Fri, 12 Jul 2019 14:19:13 +0200
Message-Id: <20190712121620.632595223@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.2.1-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.1-rc1
X-KernelTest-Deadline: 2019-07-14T12:16+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.2.1 release.
There are 61 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun 14 Jul 2019 12:14:36 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.1-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.2.1-rc1

Arnd Bergmann <arnd@arndb.de>
    staging: rtl8712: reduce stack usage, again

Dave Stevenson <dave.stevenson@raspberrypi.org>
    staging: bcm2835-camera: Handle empty EOS buffers whilst streaming

Dave Stevenson <dave.stevenson@raspberrypi.org>
    staging: bcm2835-camera: Remove check of the number of buffers supplied

Dave Stevenson <dave.stevenson@raspberrypi.org>
    staging: bcm2835-camera: Ensure all buffers are returned on disable

Dave Stevenson <dave.stevenson@raspberrypi.org>
    staging: bcm2835-camera: Replace spinlock protecting context_map with mutex

Colin Ian King <colin.king@canonical.com>
    staging: fsl-dpaa2/ethsw: fix memory leak of switchdev_work

Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
    staging: vchiq: revert "switch to wait_for_completion_killable"

Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
    staging: vchiq: make wait events interruptible

Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
    staging: vchiq_2835_arm: revert "quit using custom down_interruptible()"

Vishnu DASA <vdasa@vmware.com>
    VMCI: Fix integer overflow in VMCI handle arrays

Ross Zwisler <zwisler@chromium.org>
    Revert "x86/build: Move _etext to actual end of .text"

Christian Lamparter <chunkeey@gmail.com>
    carl9170: fix misuse of device driver API

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: tmc-etf: Do not call smp_processor_id from preemptible

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: tmc-etr: alloc_perf_buf: Do not call smp_processor_id from preemptible

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: tmc-etr: Do not call smp_processor_id() from preemptible

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: etb10: Do not call smp_processor_id from preemptible

Dan Carpenter <dan.carpenter@oracle.com>
    coresight: Potential uninitialized variable in probe()

Fabrice Gasnier <fabrice.gasnier@st.com>
    iio: adc: stm32-adc: add missing vdda-supply

Todd Kjos <tkjos@android.com>
    binder: return errors from buffer copy functions

Todd Kjos <tkjos@android.com>
    binder: fix memory leak in error path

Nick Desaulniers <ndesaulniers@google.com>
    lkdtm: support llvm-objcopy

Sebastian Parschauer <s.parschauer@gmx.de>
    HID: Add another Primax PIXART OEM mouse quirk

Sergio Paracuellos <sergio.paracuellos@gmail.com>
    staging: mt7621-pci: fix PCIE_FTS_NUM_LO macro

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: amplc_pci230: fix null pointer deref on interrupt

Stefan Wahren <wahrenst@gmx.net>
    staging: bcm2835-camera: Restore return behavior of ctrl_set_bitrate()

Ajay Singh <ajay.kathat@microchip.com>
    staging: wilc1000: fix error path cleanup in wilc_wlan_initialize()

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: dt282x: fix a null pointer deref on interrupt

Christian Lamparter <chunkeey@gmail.com>
    p54: fix crash during initialization

Nikolaus Voss <nikolaus.voss@loewensteinmedical.de>
    drivers/usb/typec/tps6598x.c: fix 4CC cmd write

Nikolaus Voss <nikolaus.voss@loewensteinmedical.de>
    drivers/usb/typec/tps6598x.c: fix portinfo width

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    usb: renesas_usbhs: add a workaround for a race condition of workqueue

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    usb: dwc2: use a longer AHB idle timeout in dwc2_core_reset()

Kiruthika Varadarajan <Kiruthika.Varadarajan@harman.com>
    usb: gadget: ether: Fix race between gether_disconnect and rx_submit

Fei Yang <fei.yang@intel.com>
    usb: gadget: f_fs: data_len used before properly set

Alan Stern <stern@rowland.harvard.edu>
    p54usb: Fix race between disconnect and firmware loading

Oliver Barta <o.barta89@gmail.com>
    Revert "serial: 8250: Don't service RX FIFO if interrupts are disabled"

Jörgen Storvist <jorgen.storvist@gmail.com>
    USB: serial: option: add support for GosunCn ME3630 RNDIS mode

Andreas Fritiofson <andreas.fritiofson@unjo.com>
    USB: serial: ftdi_sio: add ID for isodebug v1

Brian Norris <briannorris@chromium.org>
    mwifiex: Don't abort on small, spec-compliant vendor IEs

Andy Lutomirski <luto@kernel.org>
    Documentation/admin: Remove the vsyscall=native documentation

Tim Chen <tim.c.chen@linux.intel.com>
    Documentation: Add section about CPU vulnerabilities for Spectre

Dianzhang Chen <dianzhangchen0@gmail.com>
    x86/tls: Fix possible spectre-v1 in do_get_thread_area()

Dianzhang Chen <dianzhangchen0@gmail.com>
    x86/ptrace: Fix possible spectre-v1 in ptrace_get_debugreg()

Song Liu <songliubraving@fb.com>
    perf header: Assign proper ff->ph in perf_event__synthesize_features()

Adrian Hunter <adrian.hunter@intel.com>
    perf thread-stack: Fix thread stack return from kernel for kernel-only case

John Garry <john.garry@huawei.com>
    perf pmu: Fix uncore PMU alias list for ARM64

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix itrace defaults for perf script intel-pt documentation

Adrian Hunter <adrian.hunter@intel.com>
    perf auxtrace: Fix itrace defaults for perf script

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix itrace defaults for perf script

Douglas Anderson <dianders@chromium.org>
    block, bfq: NULL out the bic when it's no longer valid

Ming Lei <ming.lei@redhat.com>
    block: fix .bi_size overflow

Vadim Sukhomlinov <sukhomlinov@google.com>
    tpm: Fix TPM 1.2 Shutdown sequence to prevent future TPM operations

Kees Cook <keescook@chromium.org>
    tpm: Actually fail on TPM errors during "get random"

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Headphone Mic can't record after S3

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix parse of UAC2 Extension Units

Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
    media: stv0297: fix frequency range limit

Steven J. Magnani <steve.magnani@digidescorp.com>
    udf: Fix incorrect final NOT_ALLOCATED (hole) extent length

Hongjie Fang <hongjiefang@asrmicro.com>
    fscrypt: don't set policy for a dead directory

Christophe Leroy <christophe.leroy@c-s.fr>
    crypto: talitos - rename alternative AEAD algos.

Eric Biggers <ebiggers@google.com>
    crypto: lrw - use correct alignmask

Christophe Leroy <christophe.leroy@c-s.fr>
    crypto: talitos - fix hash on SEC1.


-------------

Diffstat:

 Documentation/admin-guide/hw-vuln/index.rst        |   1 +
 Documentation/admin-guide/hw-vuln/spectre.rst      | 697 +++++++++++++++++++++
 Documentation/admin-guide/kernel-parameters.txt    |   6 -
 Documentation/userspace-api/spec_ctrl.rst          |   2 +
 Makefile                                           |   4 +-
 arch/x86/kernel/ptrace.c                           |   5 +-
 arch/x86/kernel/tls.c                              |   9 +-
 arch/x86/kernel/vmlinux.lds.S                      |   6 +-
 block/bfq-iosched.c                                |   1 +
 block/bio.c                                        |  10 +-
 crypto/lrw.c                                       |   2 +-
 drivers/android/binder.c                           | 157 +++--
 drivers/android/binder_alloc.c                     |  44 +-
 drivers/android/binder_alloc.h                     |  22 +-
 drivers/char/tpm/tpm-chip.c                        |   6 +-
 drivers/char/tpm/tpm1-cmd.c                        |   7 +-
 drivers/char/tpm/tpm2-cmd.c                        |   7 +-
 drivers/crypto/talitos.c                           |  85 +--
 drivers/hid/hid-ids.h                              |   1 +
 drivers/hid/hid-quirks.c                           |   1 +
 drivers/hwtracing/coresight/coresight-etb10.c      |   6 +-
 drivers/hwtracing/coresight/coresight-funnel.c     |   1 +
 drivers/hwtracing/coresight/coresight-tmc-etf.c    |   6 +-
 drivers/hwtracing/coresight/coresight-tmc-etr.c    |  13 +-
 drivers/iio/adc/stm32-adc-core.c                   |  21 +-
 drivers/media/dvb-frontends/stv0297.c              |   2 +-
 drivers/misc/lkdtm/Makefile                        |   3 +-
 drivers/misc/vmw_vmci/vmci_context.c               |  80 +--
 drivers/misc/vmw_vmci/vmci_handle_array.c          |  38 +-
 drivers/misc/vmw_vmci/vmci_handle_array.h          |  29 +-
 drivers/net/wireless/ath/carl9170/usb.c            |  39 +-
 drivers/net/wireless/intersil/p54/p54usb.c         |  43 +-
 drivers/net/wireless/intersil/p54/txrx.c           |   5 +-
 drivers/net/wireless/marvell/mwifiex/fw.h          |  12 +-
 drivers/net/wireless/marvell/mwifiex/scan.c        |  18 +-
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c   |   4 +-
 drivers/net/wireless/marvell/mwifiex/wmm.c         |   2 +-
 drivers/staging/comedi/drivers/amplc_pci230.c      |   3 +-
 drivers/staging/comedi/drivers/dt282x.c            |   3 +-
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c            |   1 +
 drivers/staging/mt7621-pci/pci-mt7621.c            |   2 +-
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c      | 157 +++--
 .../vc04_services/bcm2835-camera/bcm2835-camera.c  |  43 +-
 .../vc04_services/bcm2835-camera/controls.c        |  19 +-
 .../vc04_services/bcm2835-camera/mmal-vchiq.c      |  32 +-
 .../vc04_services/bcm2835-camera/mmal-vchiq.h      |   3 +
 .../interface/vchiq_arm/vchiq_2835_arm.c           |   2 +-
 .../vc04_services/interface/vchiq_arm/vchiq_arm.c  |  21 +-
 .../vc04_services/interface/vchiq_arm/vchiq_core.c |  31 +-
 .../vc04_services/interface/vchiq_arm/vchiq_util.c |   6 +-
 drivers/staging/wilc1000/wilc_netdev.c             |  12 +-
 drivers/tty/serial/8250/8250_port.c                |   3 +-
 drivers/usb/dwc2/core.c                            |   2 +-
 drivers/usb/gadget/function/f_fs.c                 |   3 +-
 drivers/usb/gadget/function/u_ether.c              |   6 +-
 drivers/usb/renesas_usbhs/fifo.c                   |  34 +-
 drivers/usb/serial/ftdi_sio.c                      |   1 +
 drivers/usb/serial/ftdi_sio_ids.h                  |   6 +
 drivers/usb/serial/option.c                        |   1 +
 drivers/usb/typec/tps6598x.c                       |   6 +-
 fs/crypto/policy.c                                 |   2 +
 fs/iomap.c                                         |   2 +-
 fs/udf/inode.c                                     |  93 ++-
 fs/xfs/xfs_aops.c                                  |   2 +-
 include/linux/bio.h                                |  18 +-
 include/linux/vmw_vmci_defs.h                      |  11 +-
 include/uapi/linux/usb/audio.h                     |  37 ++
 sound/pci/hda/patch_realtek.c                      |   2 +-
 sound/usb/mixer.c                                  |  16 +-
 tools/perf/Documentation/intel-pt.txt              |  10 +-
 tools/perf/util/auxtrace.c                         |   3 +-
 tools/perf/util/header.c                           |   1 +
 tools/perf/util/intel-pt.c                         |   3 +-
 tools/perf/util/pmu.c                              |  28 +-
 tools/perf/util/thread-stack.c                     |  30 +-
 75 files changed, 1523 insertions(+), 527 deletions(-)


