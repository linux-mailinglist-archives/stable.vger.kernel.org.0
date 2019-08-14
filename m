Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2DCE8D973
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729640AbfHNRId (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:08:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:58572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728245AbfHNRIc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:08:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E7EB214DA;
        Wed, 14 Aug 2019 17:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802510;
        bh=tw9sX6xJydPXQBNos0BWM6PJjs1Qy3ZuoKCfKJVlCvw=;
        h=From:To:Cc:Subject:Date:From;
        b=QJ3b4uytIziv2gulH2GAYjjSlulDp7NW+qI0B3KNk8PMPguFvlp1CpcM/bMo+wwMo
         TC27xT50WO79o7z5v817if2rUiclgh+vWdiMoW5q9lh13GCALdylR8PpwnPngqZ7Eh
         IjCuRiJLtBkUhGsE2OsJrTZ58CJdFVkvLqinobRI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/91] 4.19.67-stable review
Date:   Wed, 14 Aug 2019 19:00:23 +0200
Message-Id: <20190814165748.991235624@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.67-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.67-rc1
X-KernelTest-Deadline: 2019-08-16T16:57+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.67 release.
There are 91 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri 16 Aug 2019 04:55:34 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.67-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.67-rc1

Luca Coelho <luciano.coelho@intel.com>
    iwlwifi: mvm: fix version check for GEO_TX_POWER_LIMIT support

Luca Coelho <luciano.coelho@intel.com>
    iwlwifi: mvm: don't send GEO_TX_POWER_LIMIT on version < 41

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: mvm: fix an out-of-bound access

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: don't unmap as page memory that was mapped as single

Brian Norris <briannorris@chromium.org>
    mwifiex: fix 802.11n/WPA detection

Wanpeng Li <wanpengli@tencent.com>
    KVM: Fix leak vCPU's VMCS value into other pCPU

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Fix an Oops in nfs4_do_setattr

Steve French <stfrench@microsoft.com>
    smb3: send CAP_DFS capability during session setup

Pavel Shilovsky <pshilov@microsoft.com>
    SMB3: Fix deadlock in validate negotiate hits reconnect

Vivek Goyal <vgoyal@redhat.com>
    dax: dax_layout_busy_page() should not unmap cow pages

Brian Norris <briannorris@chromium.org>
    mac80211: don't WARN on short WMM parameters from AP

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Workaround for crackled sound on AMD controller (1022:1457)

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Don't override global PCM hw info flag

Wenwen Wang <wenwen@cs.uga.edu>
    ALSA: hiface: fix multiple memory leak bugs

Wenwen Wang <wenwen@cs.uga.edu>
    ALSA: firewire: fix a memory leak bug

Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
    drm/i915: Fix wrong escape clock divisor init for GLK

Guenter Roeck <linux@roeck-us.net>
    hwmon: (nct7802) Fix wrong detection of in4 presence

Tomas Bortoli <tomasbortoli@gmail.com>
    can: peak_usb: pcan_usb_fd: Fix info-leaks to USB devices

Tomas Bortoli <tomasbortoli@gmail.com>
    can: peak_usb: pcan_usb_pro: Fix info-leaks to USB devices

Wenwen Wang <wenwen@cs.uga.edu>
    ALSA: usb-audio: fix a memory leak bug

Nick Desaulniers <ndesaulniers@google.com>
    x86/purgatory: Do not use __builtin_memcpy and __builtin_memset

Roderick Colenbrander <roderick@gaikai.com>
    HID: sony: Fix race condition between rumble and device remove.

Halil Pasic <pasic@linux.ibm.com>
    s390/dma: provide proper ARCH_ZONE_DMA_BITS value

Leonard Crestez <leonard.crestez@nxp.com>
    perf/core: Fix creating kernel counters for PMUs that override event->cpu

Peter Zijlstra <peterz@infradead.org>
    tty/ldsem, locking/rwsem: Add missing ACQUIRE to read_failed sleep loop

Wenwen Wang <wenwen@cs.uga.edu>
    test_firmware: fix a memory leak bug

Hannes Reinecke <hare@suse.de>
    scsi: scsi_dh_alua: always use a 2 second delay before retrying RTPG

Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
    scsi: ibmvfc: fix WARN_ON during event pool release

Junxiao Bi <junxiao.bi@oracle.com>
    scsi: megaraid_sas: fix panic on loading firmware crashdump

Arnd Bergmann <arnd@arndb.de>
    ARM: dts: bcm: bcm47094: add missing #cells for mdio-bus-mux

Arnd Bergmann <arnd@arndb.de>
    ARM: davinci: fix sleep.S build error on ARMv4

Marta Rybczynska <mrybczyn@kalray.eu>
    nvme: fix multipath crash when ANA is deactivated

Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
    ACPI/IORT: Fix off-by-one check in iort_dev_find_its_id()

Arnd Bergmann <arnd@arndb.de>
    drbd: dynamically allocate shash descriptor

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf probe: Avoid calling freeing routine multiple times for same pointer

Jiri Olsa <jolsa@kernel.org>
    perf tools: Fix proper buffer size for feature processing

Charles Keepax <ckeepax@opensource.cirrus.com>
    ALSA: compress: Be more restrictive about when a drain is allowed

Charles Keepax <ckeepax@opensource.cirrus.com>
    ALSA: compress: Don't allow paritial drain operations on capture streams

Charles Keepax <ckeepax@opensource.cirrus.com>
    ALSA: compress: Prevent bypasses of set_params

Charles Keepax <ckeepax@opensource.cirrus.com>
    ALSA: compress: Fix regression on compressed capture streams

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qdio: add sanity checks to the fast-requeue path

Wen Yang <wen.yang99@zte.com.cn>
    cpufreq/pasemi: fix use-after-free in pas_cpufreq_cpu_init()

Qian Cai <cai@lca.pw>
    drm: silence variable 'conn' set but not used

Björn Gerhart <gerhart@posteo.de>
    hwmon: (nct6775) Fix register address and added missed tolerance for nct6106

Navid Emamdoost <navid.emamdoost@gmail.com>
    allocate_flower_entry: should check for null deref

Brian Norris <briannorris@chromium.org>
    mac80211: don't warn about CW params when not using them

John Crispin <john@phrozen.org>
    nl80211: fix NL80211_HE_MAX_CAPABILITY_LEN

Thomas Tai <thomas.tai@oracle.com>
    iscsi_ibft: make ISCSI_IBFT dependson ACPI instead of ISCSI_IBFT_FIND

Tai Man <taiman.wong@amd.com>
    drm/amd/display: Increase size of audios array

Alvin Lee <alvin.lee2@amd.com>
    drm/amd/display: Only enable audio if speaker allocation exists

Julian Parkin <julian.parkin@amd.com>
    drm/amd/display: Fix dc_create failure handling and 666 color depths

Tai Man <taiman.wong@amd.com>
    drm/amd/display: use encoder's engine id to find matched free audio device

SivapiriyanKumarasamy <sivapiriyan.kumarasamy@amd.com>
    drm/amd/display: Wait for backlight programming completion in set backlight level

Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
    scripts/sphinx-pre-install: fix script for RHEL/CentOS

Laura Garcia Liebana <nevola@gmail.com>
    netfilter: nft_hash: fix symhash with modulus one

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: always store window size un-scaled

Miaohe Lin <linmiaohe@huawei.com>
    netfilter: Fix rpfilter dropping vrf packets by mistake

Farhan Ali <alifm@linux.ibm.com>
    vfio-ccw: Set pa_nr to 0 if memory allocation fails for pa_iova_pfn

Florian Westphal <fw@strlen.de>
    netfilter: nfnetlink: avoid deadlock due to synchronous request_module

Stephane Grosjean <s.grosjean@peak-system.com>
    can: peak_usb: fix potential double kfree_skb()

Nikita Yushchenko <nikita.yoush@cogentembedded.com>
    can: rcar_canfd: fix possible IRQ storm on high load

Guenter Roeck <linux@roeck-us.net>
    usb: typec: tcpm: Ignore unsupported/unknown alternate mode requests

Guenter Roeck <linux@roeck-us.net>
    usb: typec: tcpm: Add NULL check before dereferencing config

Li Jun <jun.li@nxp.com>
    usb: typec: tcpm: remove tcpm dir if no children

Li Jun <jun.li@nxp.com>
    usb: typec: tcpm: free log buf memory when remove debug file

Suzuki K Poulose <suzuki.poulose@arm.com>
    usb: yurex: Fix use-after-free in yurex_delete

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    usb: host: xhci-rcar: Fix timeout in xhci_suspend()

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: gfs2_walk_metadata fix

Nick Desaulniers <ndesaulniers@google.com>
    x86/purgatory: Use CFLAGS_REMOVE rather than reset KBUILD_CFLAGS

Thomas Richter <tmricht@linux.ibm.com>
    perf record: Fix module size on s390

Adrian Hunter <adrian.hunter@intel.com>
    perf db-export: Fix thread__exec_comm()

Thomas Richter <tmricht@linux.ibm.com>
    perf annotate: Fix s390 gap between kernel end and module start

Joerg Roedel <jroedel@suse.de>
    mm/vmalloc: Sync unmappings in __purge_vmap_area_lazy()

Joerg Roedel <jroedel@suse.de>
    x86/mm: Sync also unmappings in vmalloc_sync_all()

Joerg Roedel <jroedel@suse.de>
    x86/mm: Check for pfn instead of page in vmalloc_sync_one()

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: synaptics - enable RMI mode for HP Spectre X360

Kai-Heng Feng <kai.heng.feng@canonical.com>
    Input: elantech - enable SMBus on new (2018+) systems

Oliver Neukum <oneukum@suse.com>
    Input: usbtouchscreen - initialize PM mutex before using it

Mikulas Patocka <mpatocka@redhat.com>
    loop: set PF_MEMALLOC_NOIO for the worker thread

Kevin Hao <haokexin@gmail.com>
    mmc: cavium: Add the missing dma unmap when the dma has finished.

Kevin Hao <haokexin@gmail.com>
    mmc: cavium: Set the correct dma max segment size for mmc_host

Wenwen Wang <wenwen@cs.uga.edu>
    sound: fix a memory leak bug

Oliver Neukum <oneukum@suse.com>
    usb: iowarrior: fix deadlock on disconnect

Gavin Li <git@thegavinli.com>
    usb: usbfs: fix double-free of usb memory upon submiturb error

Gary R Hook <gary.hook@amd.com>
    crypto: ccp - Ignore tag length when decrypting GCM ciphertext

Gary R Hook <gary.hook@amd.com>
    crypto: ccp - Add support for valid authsize values less than 16

Gary R Hook <gary.hook@amd.com>
    crypto: ccp - Fix oops by properly managing allocated structures

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    staging: android: ion: Bail out upon SIGKILL when allocating memory.

Ivan Bornyakov <brnkv.i1@gmail.com>
    staging: gasket: apex: fix copy-paste typo

Joe Perches <joe@perches.com>
    iio: adc: max9611: Fix misuse of GENMASK macro

Gwendal Grignou <gwendal@chromium.org>
    iio: cros_ec_accel_legacy: Fix incorrect channel setting


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/bcm47094-linksys-panamera.dts    |   3 +
 arch/arm/mach-davinci/sleep.S                      |   1 +
 arch/powerpc/kvm/powerpc.c                         |   5 +
 arch/s390/include/asm/page.h                       |   2 +
 arch/x86/boot/string.c                             |   8 +
 arch/x86/include/asm/kvm_host.h                    |   1 +
 arch/x86/kvm/svm.c                                 |   6 +
 arch/x86/kvm/vmx.c                                 |   6 +
 arch/x86/kvm/x86.c                                 |  16 ++
 arch/x86/mm/fault.c                                |  15 +-
 arch/x86/purgatory/Makefile                        |  36 ++++-
 arch/x86/purgatory/purgatory.c                     |   6 +
 arch/x86/purgatory/string.c                        |  25 ----
 drivers/acpi/arm64/iort.c                          |   4 +-
 drivers/block/drbd/drbd_receiver.c                 |  14 +-
 drivers/block/loop.c                               |   2 +-
 drivers/cpufreq/pasemi-cpufreq.c                   |  23 ++-
 drivers/crypto/ccp/ccp-crypto-aes-galois.c         |  14 ++
 drivers/crypto/ccp/ccp-ops.c                       |  33 +++--
 drivers/firmware/Kconfig                           |   5 +-
 drivers/firmware/iscsi_ibft.c                      |   4 +
 drivers/gpu/drm/amd/display/dc/core/dc.c           |   6 +-
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c  |  11 +-
 drivers/gpu/drm/amd/display/dc/dce/dce_abm.c       |   4 +
 drivers/gpu/drm/amd/display/dc/inc/core_types.h    |   2 +-
 drivers/gpu/drm/amd/display/dc/inc/hw/hw_shared.h  |   1 +
 drivers/gpu/drm/drm_framebuffer.c                  |   2 +-
 drivers/gpu/drm/i915/vlv_dsi_pll.c                 |   4 +-
 drivers/hid/hid-sony.c                             |  15 +-
 drivers/hwmon/nct6775.c                            |   3 +-
 drivers/hwmon/nct7802.c                            |   6 +-
 drivers/iio/accel/cros_ec_accel_legacy.c           |   1 -
 drivers/iio/adc/max9611.c                          |   2 +-
 drivers/input/mouse/elantech.c                     |  54 ++++---
 drivers/input/mouse/synaptics.c                    |   1 +
 drivers/input/touchscreen/usbtouchscreen.c         |   2 +
 drivers/mmc/host/cavium.c                          |   4 +-
 drivers/net/can/rcar/rcar_canfd.c                  |   9 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |   8 +-
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c         |   2 +-
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c        |   2 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c   |   3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  29 +++-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |   2 +
 drivers/net/wireless/marvell/mwifiex/main.h        |   1 +
 drivers/net/wireless/marvell/mwifiex/scan.c        |   3 +-
 drivers/nvme/host/multipath.c                      |   8 +-
 drivers/nvme/host/nvme.h                           |   6 +-
 drivers/s390/cio/qdio_main.c                       |  12 +-
 drivers/s390/cio/vfio_ccw_cp.c                     |   4 +-
 drivers/scsi/device_handler/scsi_dh_alua.c         |   7 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                     |   2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c          |   3 +
 drivers/staging/android/ion/ion_page_pool.c        |   3 +
 drivers/staging/gasket/apex_driver.c               |   2 +-
 drivers/tty/tty_ldsem.c                            |   5 +-
 drivers/usb/core/devio.c                           |   2 -
 drivers/usb/host/xhci-rcar.c                       |   9 +-
 drivers/usb/misc/iowarrior.c                       |   7 +-
 drivers/usb/misc/yurex.c                           |   2 +-
 drivers/usb/typec/tcpm.c                           |  58 +++++---
 fs/cifs/smb2pdu.c                                  |   7 +-
 fs/dax.c                                           |   2 +-
 fs/gfs2/bmap.c                                     | 164 +++++++++++++--------
 fs/nfs/nfs4proc.c                                  |   2 +-
 include/linux/ccp.h                                |   2 +
 include/linux/kvm_host.h                           |   1 +
 include/sound/compress_driver.h                    |   5 +-
 include/uapi/linux/nl80211.h                       |   2 +-
 kernel/events/core.c                               |   2 +-
 lib/test_firmware.c                                |   5 +-
 mm/vmalloc.c                                       |   9 ++
 net/ipv4/netfilter/ipt_rpfilter.c                  |   1 +
 net/ipv6/netfilter/ip6t_rpfilter.c                 |   8 +-
 net/mac80211/driver-ops.c                          |  13 +-
 net/mac80211/mlme.c                                |  10 ++
 net/netfilter/nf_conntrack_proto_tcp.c             |   8 +-
 net/netfilter/nfnetlink.c                          |   2 +-
 net/netfilter/nft_hash.c                           |   2 +-
 scripts/sphinx-pre-install                         |   2 +-
 sound/core/compress_offload.c                      |  60 ++++++--
 sound/firewire/packets-buffer.c                    |   2 +-
 sound/pci/hda/hda_controller.c                     |  13 +-
 sound/pci/hda/hda_controller.h                     |   2 +-
 sound/pci/hda/hda_intel.c                          |  63 +++++++-
 sound/sound_core.c                                 |   3 +-
 sound/usb/hiface/pcm.c                             |  11 +-
 sound/usb/stream.c                                 |   1 +
 tools/perf/arch/s390/util/machine.c                |  31 +++-
 tools/perf/builtin-probe.c                         |  10 ++
 tools/perf/util/header.c                           |   2 +-
 tools/perf/util/machine.c                          |   3 +-
 tools/perf/util/machine.h                          |   2 +-
 tools/perf/util/symbol.c                           |   7 +-
 tools/perf/util/symbol.h                           |   1 +
 tools/perf/util/thread.c                           |  12 +-
 virt/kvm/kvm_main.c                                |  25 +++-
 98 files changed, 738 insertions(+), 297 deletions(-)


