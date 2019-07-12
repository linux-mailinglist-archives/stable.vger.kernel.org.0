Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C17A66E8F
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728420AbfGLM0N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:26:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:37028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727480AbfGLM0M (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:26:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BF4D208E4;
        Fri, 12 Jul 2019 12:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934370;
        bh=zoLN1X3o1jweztKiW0m/foULzd+pCOKnE8hn3TdfG/s=;
        h=From:To:Cc:Subject:Date:From;
        b=RIUTPwn+hsHyH5IdwXjjtSV6EVUs0eZ1NYi7lQjEoLEyhXpWkSFkGAyi1aHO7h+DT
         xZnP+NcNjJoyc7dEqqxybQIHdXmXpk7xxxnaSm9JCr+VWe9VzJXeFBB2oiJ2S4ShCd
         8PXVPp57JnH6UrjyEMGQlFvx1ZdQAGAxs5UHhgXg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.1 000/138] 5.1.18-stable review
Date:   Fri, 12 Jul 2019 14:17:44 +0200
Message-Id: <20190712121628.731888964@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.1.18-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.1.18-rc1
X-KernelTest-Deadline: 2019-07-14T12:16+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.1.18 release.
There are 138 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun 14 Jul 2019 12:14:36 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.18-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.1.18-rc1

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
    staging: vchiq: make wait events interruptible

Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
    staging: vchiq: revert "switch to wait_for_completion_killable"

Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
    staging: vchiq_2835_arm: revert "quit using custom down_interruptible()"

Vishnu DASA <vdasa@vmware.com>
    VMCI: Fix integer overflow in VMCI handle arrays

Christian Lamparter <chunkeey@gmail.com>
    carl9170: fix misuse of device driver API

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

Takashi Iwai <tiwai@suse.de>
    mwifiex: Abort at too short BSS descriptor element

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

Benjamin Coddington <bcodding@redhat.com>
    NFS4: Only set creation opendata if O_CREAT

Andrew Jones <drjones@redhat.com>
    KVM: arm/arm64: Fix emulated ptimer irq injection

Rasmus Villemoes <rasmus.villemoes@prevas.dk>
    net: dsa: mv88e6xxx: fix shift of FID bits in mv88e6185_g1_vtu_loadpurge()

yangerkun <yangerkun@huawei.com>
    quota: fix a problem about transfer quota

Christoph Hellwig <hch@lst.de>
    powerpc: enable a 30-bit ZONE_DMA for 32-bit pmac

Nilesh Javali <njavali@marvell.com>
    scsi: qedi: Check targetname while finding boot target information

Colin Ian King <colin.king@canonical.com>
    net: lio_core: fix potential sign-extension overflow on large shift

Xin Long <lucien.xin@gmail.com>
    ip6_tunnel: allow not to count pkts on tstats by passing dev as NULL

Dan Carpenter <dan.carpenter@oracle.com>
    drm: return -EFAULT if copy_to_user() fails

Mauro S. M. Rodrigues <maurosr@linux.vnet.ibm.com>
    bnx2x: Check if transceiver implements DDM before access

Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
    md: fix for divide error in status_resync

Mike Marciniszyn <mike.marciniszyn@intel.com>
    IB/hfi1: Handle port down properly in pio

Mike Marciniszyn <mike.marciniszyn@intel.com>
    IB/hfi1: Handle wakeup of orphaned QPs for pio

Mike Marciniszyn <mike.marciniszyn@intel.com>
    IB/hfi1: Wakeup QPs orphaned on wait list after flush

Mike Marciniszyn <mike.marciniszyn@intel.com>
    IB/hfi1: Use aborts to trigger RC throttling

Mike Marciniszyn <mike.marciniszyn@intel.com>
    IB/hfi1: Create inline to get extended headers

Wolfram Sang <wsa+renesas@sang-engineering.com>
    mmc: core: complete HS400 before checking status

Reinhard Speyerer <rspmn@arcor.de>
    qmi_wwan: extend permitted QMAP mux_id value range

Reinhard Speyerer <rspmn@arcor.de>
    qmi_wwan: avoid RCU stalls on device disconnect when in QMAP mode

Reinhard Speyerer <rspmn@arcor.de>
    qmi_wwan: add support for QMAP padding in the RX path

Alexei Starovoitov <ast@kernel.org>
    bpf, x64: fix stack layout of JITed bpf code

Toshiaki Makita <toshiaki.makita1@gmail.com>
    bpf, devmap: Add missing RCU read lock on flush

Toshiaki Makita <toshiaki.makita1@gmail.com>
    bpf, devmap: Add missing bulk queue free

Toshiaki Makita <toshiaki.makita1@gmail.com>
    bpf, devmap: Fix premature entry free on destroying map

Avraham Stern <avraham.stern@intel.com>
    cfg80211: report measurement start TSF correctly

Mordechay Goodstein <mordechay.goodstein@intel.com>
    cfg80211: util: fix bit count off by one

Naftali Goldstein <naftali.goldstein@intel.com>
    mac80211: do not start any work during reconfigure flow

Yibo Zhao <yiboz@codeaurora.org>
    mac80211: only warn once on chanctx_conf being NULL

Steve Longerbeam <slongerbeam@gmail.com>
    gpu: ipu-v3: image-convert: Fix image downsize coefficients

Steve Longerbeam <slongerbeam@gmail.com>
    gpu: ipu-v3: image-convert: Fix input bytesperline for packed formats

Steve Longerbeam <slongerbeam@gmail.com>
    gpu: ipu-v3: image-convert: Fix input bytesperline width/height align

Bartosz Golaszewski <bgolaszewski@baylibre.com>
    ARM: davinci: da8xx: specify dma_coherent_mask for lcdc

Bartosz Golaszewski <bgolaszewski@baylibre.com>
    ARM: davinci: da850-evm: call regulator_has_full_constraints()

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    bpf: fix div64 overflow tests to properly detect errors

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: nVMX: use correct clean fields when copying from eVMCS

Ido Schimmel <idosch@mellanox.com>
    mlxsw: spectrum: Disallow prio-tagged packets when PVID is removed

Dave Martin <Dave.Martin@arm.com>
    KVM: arm/arm64: vgic: Fix kvm_device leak in vgic_its_destroy

Ilya Maximets <i.maximets@samsung.com>
    xdp: check device pointer before clearing

Anson Huang <anson.huang@nxp.com>
    Input: imx_keypad - make sure keyboard can always wake up system

Nick Hu <nickhu@andestech.com>
    riscv: Fix udelay in RV32.

Qian Cai <cai@lca.pw>
    drm/vmwgfx: fix a warning due to missing dma_parms

Thomas Hellstrom <thellstrom@vmware.com>
    drm/vmwgfx: Honor the sg list segment size limitation

Kevin Hilman <khilman@baylibre.com>
    RISC-V: defconfig: enable clocks, serial console

Heiko Carstens <heiko.carstens@de.ibm.com>
    s390/boot: disable address-of-packed-member warning

Teresa Remmet <t.remmet@phytec.de>
    ARM: dts: am335x phytec boards: Fix cd-gpios active level

Thomas Falcon <tlfalcon@linux.ibm.com>
    ibmvnic: Fix unchecked return codes of memory allocations

Thomas Falcon <tlfalcon@linux.ibm.com>
    ibmvnic: Refresh device multicast list after reset

Thomas Falcon <tlfalcon@linux.ibm.com>
    ibmvnic: Do not close unopened driver during reset

Michael Schmitz <schmitzmic@gmail.com>
    net: phy: rename Asix Electronics PHY driver

Fabio Estevam <festevam@gmail.com>
    can: flexcan: Remove unneeded registration message

YueHaibing <yuehaibing@huawei.com>
    can: af_can: Fix error path of can_init()

Eugen Hristev <eugen.hristev@microchip.com>
    can: m_can: implement errata "Needless activation of MRAF irq"

Sean Nyekjaer <sean@geanix.com>
    can: mcp251x: add support for mcp25625

Sean Nyekjaer <sean@geanix.com>
    dt-bindings: can: mcp251x: add mcp25625 support

Guillaume Nault <gnault@redhat.com>
    netfilter: ipv6: nf_defrag: accept duplicate fragments again

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    soundwire: intel: set dai min and max channels correctly

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    soundwire: stream: fix bad unlock balance

Krzesimir Nowak <krzesimir@kinvolk.io>
    tools: bpftool: Fix JSON output when lookup fails

Guillaume Nault <gnault@redhat.com>
    netfilter: ipv6: nf_defrag: fix leakage of unqueued fragments

Takashi Iwai <tiwai@suse.de>
    mwifiex: Fix heap overflow in mwifiex_uap_parse_tail_ies()

Jia-Ju Bai <baijiaju1990@gmail.com>
    iwlwifi: Fix double-free problems in iwl_req_fw_callback()

Matt Chen <matt.chen@intel.com>
    iwlwifi: fix AX201 killer sku loading firmware issue

Shahar S Matityahu <shahar.s.matityahu@intel.com>
    iwlwifi: clear persistence bit according to device family

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: fix load in rfkill flow for unified firmware

Luke Nelson <luke.r.nels@gmail.com>
    bpf, riscv: clear high 32 bits for ALU32 add/sub/neg/lsh/rsh/arsh

Takashi Iwai <tiwai@suse.de>
    mwifiex: Fix possible buffer overflows at parsing bss descriptor

Tony Lindgren <tony@atomide.com>
    ARM: dts: Drop bogus CLKSEL for timer12 on dra7

Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
    mac80211: free peer keys before vif down in mesh

Thomas Pedersen <thomas@eero.com>
    mac80211: mesh: fix RCU warning

Melissa Wen <melissa.srw@gmail.com>
    staging:iio:ad7150: fix threshold mode config bit

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    soundwire: stream: fix out of boundary access on port properties

John Fastabend <john.fastabend@gmail.com>
    bpf: sockmap, fix use after free from sleep in psock backlog workqueue

John Crispin <john@phrozen.org>
    mac80211: fix rate reporting inside cfg80211_calculate_bitrate_he()

Jakub Sitnicki <jakub@cloudflare.com>
    bpf: sockmap, restore sk_write_space when psock gets dropped

Björn Töpel <bjorn.topel@gmail.com>
    bpf, riscv: clear target register high 32-bits for and/or/xor on ALU32

Matteo Croce <mcroce@redhat.com>
    samples, bpf: suppress compiler warning

Chang-Hsien Tsai <luke.tw@gmail.com>
    samples, bpf: fix to change the buffer size for read()

Aaron Ma <aaron.ma@canonical.com>
    Input: elantech - enable middle button support on 2 ThinkPads

Florian Fainelli <f.fainelli@gmail.com>
    soc: bcm: brcmstb: biuctrl: Register writes require a barrier

Florian Fainelli <f.fainelli@gmail.com>
    soc: brcmstb: Fix error path for unsupported CPUs

Keerthy <j-keerthy@ti.com>
    ARM: dts: dra71x: Disable usb4_tm target module

Keerthy <j-keerthy@ti.com>
    ARM: dts: dra71x: Disable rtc target module

Keerthy <j-keerthy@ti.com>
    ARM: dts: dra76x: Disable usb4_tm target module

Keerthy <j-keerthy@ti.com>
    ARM: dts: dra76x: Disable rtc target module

Christophe Leroy <christophe.leroy@c-s.fr>
    crypto: talitos - rename alternative AEAD algos.

Eric Biggers <ebiggers@google.com>
    crypto: lrw - use correct alignmask

Christophe Leroy <christophe.leroy@c-s.fr>
    crypto: talitos - fix hash on SEC1.


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-class-net-qmi      |   4 +-
 Documentation/admin-guide/hw-vuln/index.rst        |   1 +
 Documentation/admin-guide/hw-vuln/spectre.rst      | 697 +++++++++++++++++++++
 Documentation/admin-guide/kernel-parameters.txt    |   6 -
 .../bindings/net/can/microchip,mcp251x.txt         |   1 +
 Documentation/userspace-api/spec_ctrl.rst          |   2 +
 Makefile                                           |   4 +-
 arch/arm/boot/dts/am335x-pcm-953.dtsi              |   2 +-
 arch/arm/boot/dts/am335x-wega.dtsi                 |   2 +-
 arch/arm/boot/dts/dra7-l4.dtsi                     |   4 +-
 arch/arm/boot/dts/dra71-evm.dts                    |   2 +-
 arch/arm/boot/dts/dra71x.dtsi                      |  17 +
 arch/arm/boot/dts/dra76x.dtsi                      |   8 +
 arch/arm/mach-davinci/board-da850-evm.c            |   2 +
 arch/arm/mach-davinci/devices-da8xx.c              |   3 +
 arch/powerpc/include/asm/page.h                    |   7 +
 arch/powerpc/mm/mem.c                              |   3 +-
 arch/powerpc/platforms/powermac/Kconfig            |   1 +
 arch/riscv/configs/defconfig                       |   4 +
 arch/riscv/lib/delay.c                             |   2 +-
 arch/riscv/net/bpf_jit_comp.c                      |  24 +
 arch/s390/Makefile                                 |   1 +
 arch/x86/kernel/ptrace.c                           |   5 +-
 arch/x86/kernel/tls.c                              |   9 +-
 arch/x86/kvm/vmx/nested.c                          |   4 +-
 arch/x86/net/bpf_jit_comp.c                        |  74 +--
 block/bfq-iosched.c                                |   1 +
 crypto/lrw.c                                       |   2 +-
 drivers/android/binder.c                           | 157 +++--
 drivers/android/binder_alloc.c                     |  44 +-
 drivers/android/binder_alloc.h                     |  22 +-
 drivers/char/tpm/tpm-chip.c                        |   6 +-
 drivers/char/tpm/tpm1-cmd.c                        |   7 +-
 drivers/char/tpm/tpm2-cmd.c                        |   7 +-
 drivers/crypto/talitos.c                           |  85 +--
 drivers/gpu/drm/drm_bufs.c                         |   5 +-
 drivers/gpu/drm/drm_ioc32.c                        |   5 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                |   3 +
 drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c         |  10 +-
 drivers/gpu/ipu-v3/ipu-image-convert.c             |  40 +-
 drivers/hid/hid-ids.h                              |   1 +
 drivers/hid/hid-quirks.c                           |   1 +
 drivers/iio/adc/stm32-adc-core.c                   |  21 +-
 drivers/infiniband/hw/hfi1/hfi.h                   |  31 +
 drivers/infiniband/hw/hfi1/pio.c                   |  21 +-
 drivers/infiniband/hw/hfi1/rc.c                    |  53 +-
 drivers/infiniband/hw/hfi1/sdma.c                  |  17 +
 drivers/infiniband/hw/hfi1/ud.c                    |   4 +-
 drivers/infiniband/hw/hfi1/verbs.c                 |  14 +-
 drivers/infiniband/hw/hfi1/verbs.h                 |   1 +
 drivers/input/keyboard/imx_keypad.c                |  18 +-
 drivers/input/mouse/elantech.c                     |   2 +
 drivers/md/md.c                                    |  36 +-
 drivers/media/dvb-frontends/stv0297.c              |   2 +-
 drivers/misc/lkdtm/Makefile                        |   3 +-
 drivers/misc/vmw_vmci/vmci_context.c               |  80 +--
 drivers/misc/vmw_vmci/vmci_handle_array.c          |  38 +-
 drivers/misc/vmw_vmci/vmci_handle_array.h          |  29 +-
 drivers/mmc/core/mmc.c                             |   6 +-
 drivers/net/can/flexcan.c                          |   3 -
 drivers/net/can/m_can/m_can.c                      |  21 +
 drivers/net/can/spi/Kconfig                        |   5 +-
 drivers/net/can/spi/mcp251x.c                      |  25 +-
 drivers/net/dsa/mv88e6xxx/global1_vtu.c            |   2 +-
 drivers/net/ethernet/8390/Kconfig                  |   2 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c    |   3 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.h   |   1 +
 drivers/net/ethernet/cavium/liquidio/lio_core.c    |   2 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |  19 +-
 drivers/net/ethernet/mellanox/mlxsw/reg.h          |   2 +-
 drivers/net/phy/Kconfig                            |   2 +-
 drivers/net/phy/Makefile                           |   2 +-
 drivers/net/phy/{asix.c => ax88796b.c}             |   0
 drivers/net/usb/qmi_wwan.c                         |  27 +-
 drivers/net/wireless/ath/carl9170/usb.c            |  39 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |   1 -
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |   7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  23 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |  17 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |   2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  50 +-
 drivers/net/wireless/intersil/p54/p54usb.c         |  43 +-
 drivers/net/wireless/intersil/p54/txrx.c           |   5 +-
 drivers/net/wireless/marvell/mwifiex/fw.h          |  12 +-
 drivers/net/wireless/marvell/mwifiex/ie.c          |  47 +-
 drivers/net/wireless/marvell/mwifiex/scan.c        |  31 +-
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c   |   4 +-
 drivers/net/wireless/marvell/mwifiex/wmm.c         |   2 +-
 drivers/scsi/qedi/qedi_main.c                      |   3 +
 drivers/soc/bcm/brcmstb/biuctrl.c                  |   6 +-
 drivers/soundwire/intel.c                          |   4 +-
 drivers/soundwire/stream.c                         |   7 +-
 drivers/staging/comedi/drivers/amplc_pci230.c      |   3 +-
 drivers/staging/comedi/drivers/dt282x.c            |   3 +-
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c            |   1 +
 drivers/staging/iio/cdc/ad7150.c                   |  19 +-
 drivers/staging/mt7621-pci/pci-mt7621.c            |   2 +-
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c      | 157 +++--
 .../vc04_services/bcm2835-camera/bcm2835-camera.c  |  43 +-
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
 fs/nfs/nfs4proc.c                                  |  20 +-
 fs/quota/dquot.c                                   |   4 +-
 fs/udf/inode.c                                     |  93 ++-
 include/linux/skmsg.h                              |   2 +
 include/linux/vmw_vmci_defs.h                      |  11 +-
 include/net/ip6_tunnel.h                           |   9 +-
 include/uapi/linux/usb/audio.h                     |  37 ++
 kernel/bpf/devmap.c                                |   9 +-
 net/can/af_can.c                                   |  24 +-
 net/core/skbuff.c                                  |   1 +
 net/ipv6/netfilter/nf_conntrack_reasm.c            |  22 +-
 net/mac80211/ieee80211_i.h                         |   9 +-
 net/mac80211/mesh.c                                |   6 +-
 net/mac80211/util.c                                |   4 +
 net/wireless/pmsr.c                                |   4 +-
 net/wireless/util.c                                |   4 +-
 net/xdp/xdp_umem.c                                 |  11 +-
 samples/bpf/bpf_load.c                             |   2 +-
 samples/bpf/task_fd_query_user.c                   |   2 +-
 sound/pci/hda/patch_realtek.c                      |   2 +-
 sound/usb/mixer.c                                  |  16 +-
 tools/bpf/bpftool/map.c                            |   2 +
 tools/perf/Documentation/intel-pt.txt              |  10 +-
 tools/perf/util/auxtrace.c                         |   3 +-
 tools/perf/util/header.c                           |   1 +
 tools/perf/util/intel-pt.c                         |   3 +-
 tools/perf/util/pmu.c                              |  28 +-
 tools/perf/util/thread-stack.c                     |  30 +-
 .../testing/selftests/bpf/verifier/div_overflow.c  |  14 +-
 virt/kvm/arm/arch_timer.c                          |   5 +-
 virt/kvm/arm/vgic/vgic-its.c                       |   1 +
 149 files changed, 2097 insertions(+), 775 deletions(-)


