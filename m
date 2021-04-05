Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D451353DF5
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237593AbhDEJDL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:03:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:45914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237590AbhDEJDL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:03:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 117E461057;
        Mon,  5 Apr 2021 09:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613384;
        bh=VOVvmKL0DOIb8tIodGJOgssJxagRJREqVn97UkvuPsE=;
        h=From:To:Cc:Subject:Date:From;
        b=H4n1/yBMKehlQzTh2J7/DDQATiPseaDwOyIrmQQ3yrEZ3585Qfs8fFbO/Yk81zEVN
         iaqvwEL366wDY6/tJYW8guTAyMd0wd/2/p8pt/oUrRG17BpURFDw7kQEg5m9fLNy+V
         ij4g1RxYqEk5mft0JaVM74xN8P8aCTkx42R+6W2o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 00/74] 5.4.110-rc1 review
Date:   Mon,  5 Apr 2021 10:53:24 +0200
Message-Id: <20210405085024.703004126@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.110-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.110-rc1
X-KernelTest-Deadline: 2021-04-07T08:50+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.110 release.
There are 74 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 07 Apr 2021 08:50:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.110-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.110-rc1

Du Cheng <ducheng2@gmail.com>
    drivers: video: fbcon: fix NULL dereference in fbcon_cursor()

Atul Gopinathan <atulgopinathan@gmail.com>
    staging: rtl8192e: Change state information from u16 to u8

Atul Gopinathan <atulgopinathan@gmail.com>
    staging: rtl8192e: Fix incorrect source in memcpy()

Artur Petrosyan <Arthur.Petrosyan@synopsys.com>
    usb: dwc2: Prevent core suspend when port connection flag is 0

Artur Petrosyan <Arthur.Petrosyan@synopsys.com>
    usb: dwc2: Fix HPRT0.PrtSusp bit setting for HiKey 960 board.

Tong Zhang <ztong0001@gmail.com>
    usb: gadget: udc: amd5536udc_pci fix null-ptr-dereference

Johan Hovold <johan@kernel.org>
    USB: cdc-acm: fix use-after-free after probe failure

Johan Hovold <johan@kernel.org>
    USB: cdc-acm: fix double free on probe failure

Oliver Neukum <oneukum@suse.com>
    USB: cdc-acm: downgrade message to debug

Oliver Neukum <oneukum@suse.com>
    USB: cdc-acm: untangle a circular dependency between callback and softint

Oliver Neukum <oneukum@suse.com>
    cdc-acm: fix BREAK rx code path adding necessary calls

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: xhci-mtk: fix broken streams issue on 0.96 xHCI

Tony Lindgren <tony@atomide.com>
    usb: musb: Fix suspend with devices connected for a64

Vincent Palatin <vpalatin@chromium.org>
    USB: quirks: ignore remote wake-up on Fibocom L850-GL LTE modem

Shuah Khan <skhan@linuxfoundation.org>
    usbip: vhci_hcd fix shift out-of-bounds in vhci_hub_control()

Zheyu Ma <zheyuma97@gmail.com>
    firewire: nosy: Fix a use-after-free bug in nosy_ioctl()

Dinghao Liu <dinghao.liu@zju.edu.cn>
    extcon: Fix error handling in extcon_dev_register

Krzysztof Kozlowski <krzk@kernel.org>
    extcon: Add stubs for extcon_register_notifier_all() functions

Wang Panzhenzhuan <randy.wang@rock-chips.com>
    pinctrl: rockchip: fix restore error in resume

Jason Gunthorpe <jgg@nvidia.com>
    vfio/nvlink: Add missing SPAPR_TCE_IOMMU depends

Thierry Reding <treding@nvidia.com>
    drm/tegra: sor: Grab runtime PM reference across reset

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    reiserfs: update reiserfs_xattrs_initialized() condition

Xℹ Ruoyao <xry111@mengyan1223.wang>
    drm/amdgpu: check alignment on CPU page for bo map

Nirmoy Das <nirmoy.das@amd.com>
    drm/amdgpu: fix offset calculation in amdgpu_vm_bo_clear_mappings()

Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
    mm: fix race by making init_zero_pfn() early_initcall

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Fix stack trace event size

Adrian Hunter <adrian.hunter@intel.com>
    PM: runtime: Fix ordering in pm_runtime_get_suppliers()

Adrian Hunter <adrian.hunter@intel.com>
    PM: runtime: Fix race getting/putting suppliers at probe

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: move coprocessor_flush to the .text section

Hui Wang <hui.wang@canonical.com>
    ALSA: hda/realtek: call alc_update_headset_mode() in hp_automute_hook

Hui Wang <hui.wang@canonical.com>
    ALSA: hda/realtek: fix a determine_headset_type issue for a Dell AIO

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Add missing sanity checks in PM prepare/complete callbacks

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Re-add dropped snd_poewr_change_state() calls

Ikjoon Jang <ikjn@chromium.org>
    ALSA: usb-audio: Apply sample rate quirk to Logitech Connect

Jesper Dangaard Brouer <brouer@redhat.com>
    bpf: Remove MTU check in __bpf_skb_max_len

Tong Zhang <ztong0001@gmail.com>
    net: wan/lmc: unregister device when no matching device is found

Doug Brown <doug@schmorgal.com>
    appletalk: Fix skb allocation size in loopback case

Nathan Rossi <nathan.rossi@digi.com>
    net: ethernet: aquantia: Handle error cleanup of start on open

Shuah Khan <skhan@linuxfoundation.org>
    ath10k: hold RCU lock when calling ieee80211_find_sta_by_ifaddr()

Luca Pesce <luca.pesce@vimar.com>
    brcmfmac: clear EAP/association status bits on linkdown events

Sasha Levin <sashal@kernel.org>
    can: tcan4x5x: fix max register value

Oleksij Rempel <linux@rempel-privat.de>
    net: introduce CAN specific pointer in the struct net_device

Marc Kleine-Budde <mkl@pengutronix.de>
    can: dev: move driver related infrastructure into separate subdir

Davide Caratti <dcaratti@redhat.com>
    flow_dissector: fix TTL and TOS dissection on IPv4 fragments

Sasha Levin <sashal@kernel.org>
    net: mvpp2: fix interrupt mask/unmask skip condition

zhangyi (F) <yi.zhang@huawei.com>
    ext4: do not iput inode under running transaction in ext4_rename()

Waiman Long <longman@redhat.com>
    locking/ww_mutex: Simplify use_ww_ctx & ww_ctx handling

Manaf Meethalavalappu Pallikunhi <manafm@codeaurora.org>
    thermal/core: Add NULL pointer check before using cooling device stats

Sameer Pujar <spujar@nvidia.com>
    ASoC: rt5659: Update MCLK rate in set_sysclk()

Tong Zhang <ztong0001@gmail.com>
    staging: comedi: cb_pcidas64: fix request_irq() warn

Tong Zhang <ztong0001@gmail.com>
    staging: comedi: cb_pcidas: fix request_irq() warn

Alexey Dobriyan <adobriyan@gmail.com>
    scsi: qla2xxx: Fix broken #endif placement

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    scsi: st: Fix a use after free in st_open()

Laurent Vivier <lvivier@redhat.com>
    vhost: Fix vhost_vq_reset()

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc: Force inlining of cpu_has_feature() to avoid build failure

Olga Kornievskaia <kolga@netapp.com>
    NFSD: fix error handling in NFSv4.0 callbacks

Lucas Tanure <tanureal@opensource.cirrus.com>
    ASoC: cs42l42: Always wait at least 3ms after reset

Lucas Tanure <tanureal@opensource.cirrus.com>
    ASoC: cs42l42: Fix mixer volume control

Lucas Tanure <tanureal@opensource.cirrus.com>
    ASoC: cs42l42: Fix channel width support

Lucas Tanure <tanureal@opensource.cirrus.com>
    ASoC: cs42l42: Fix Bitclock polarity inversion

Hans de Goede <hdegoede@redhat.com>
    ASoC: es8316: Simplify adc_pga_gain_tlv table

Benjamin Rood <benjaminjrood@gmail.com>
    ASoC: sgtl5000: set DAP_AVC_CTRL register to correct default value on probe

Hans de Goede <hdegoede@redhat.com>
    ASoC: rt5651: Fix dac- and adc- vol-tlv values being off by a factor of 10

Hans de Goede <hdegoede@redhat.com>
    ASoC: rt5640: Fix dac- and adc- vol-tlv values being off by a factor of 10

Ritesh Harjani <riteshh@linux.ibm.com>
    iomap: Fix negative assignment to unsigned sis->pages in iomap_swapfile_activate

J. Bruce Fields <bfields@redhat.com>
    rpc: fix NULL dereference on kmalloc failure

Julian Braha <julianbraha@gmail.com>
    fs: nfsd: fix kconfig dependency warning for NFSD_V4

Zhaolong Zhang <zhangzl2013@126.com>
    ext4: fix bh ref count on error paths

Eric Whitney <enwlinux@gmail.com>
    ext4: shrink race window in ext4_should_retry_alloc()

Frank van der Linden <fllinden@amazon.com>
    module: harden ELF info handling

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    module: avoid *goto*s in module_sig_check()

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    module: merge repetitive strings in module_sig_check()

Jakub Kicinski <kuba@kernel.org>
    ipv6: weaken the v4mapped source check

David Brazdil <dbrazdil@google.com>
    selinux: vsock: Set SID for socket returned by accept()


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/powerpc/include/asm/cpu_has_feature.h         |   4 +-
 arch/xtensa/kernel/coprocessor.S                   |  64 ++++----
 drivers/base/power/runtime.c                       |  10 +-
 drivers/extcon/extcon.c                            |   1 +
 drivers/firewire/nosy.c                            |   9 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |  10 +-
 drivers/gpu/drm/tegra/sor.c                        |   7 +
 drivers/net/can/Makefile                           |   7 +-
 drivers/net/can/dev/Makefile                       |   7 +
 drivers/net/can/{ => dev}/dev.c                    |   4 +-
 drivers/net/can/{ => dev}/rx-offload.c             |   0
 drivers/net/can/m_can/tcan4x5x.c                   |   2 +-
 drivers/net/can/slcan.c                            |   4 +-
 drivers/net/can/vcan.c                             |   2 +-
 drivers/net/can/vxcan.c                            |   6 +-
 drivers/net/ethernet/aquantia/atlantic/aq_main.c   |   4 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   4 +-
 drivers/net/wan/lmc/lmc_main.c                     |   2 +
 drivers/net/wireless/ath/ath10k/wmi-tlv.c          |   7 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   7 +-
 drivers/pinctrl/pinctrl-rockchip.c                 |  13 +-
 drivers/scsi/qla2xxx/qla_target.h                  |   2 +-
 drivers/scsi/st.c                                  |   2 +-
 drivers/staging/comedi/drivers/cb_pcidas.c         |   2 +-
 drivers/staging/comedi/drivers/cb_pcidas64.c       |   2 +-
 drivers/staging/rtl8192e/rtllib.h                  |   2 +-
 drivers/staging/rtl8192e/rtllib_rx.c               |   2 +-
 drivers/thermal/thermal_sysfs.c                    |   3 +
 drivers/usb/class/cdc-acm.c                        |  61 +++++---
 drivers/usb/core/quirks.c                          |   4 +
 drivers/usb/dwc2/hcd.c                             |   5 +-
 drivers/usb/gadget/udc/amd5536udc_pci.c            |  10 +-
 drivers/usb/host/xhci-mtk.c                        |  10 +-
 drivers/usb/musb/musb_core.c                       |  12 +-
 drivers/usb/usbip/vhci_hcd.c                       |   2 +
 drivers/vfio/pci/Kconfig                           |   2 +-
 drivers/vhost/vhost.c                              |   2 +-
 drivers/video/fbdev/core/fbcon.c                   |   3 +
 fs/ext4/balloc.c                                   |  38 +++--
 fs/ext4/ext4.h                                     |   1 +
 fs/ext4/inode.c                                    |   6 +-
 fs/ext4/namei.c                                    |  18 +--
 fs/ext4/super.c                                    |   5 +
 fs/ext4/sysfs.c                                    |   7 +
 fs/iomap/swapfile.c                                |  10 ++
 fs/nfsd/Kconfig                                    |   1 +
 fs/nfsd/nfs4callback.c                             |   1 +
 fs/reiserfs/xattr.h                                |   2 +-
 include/linux/can/can-ml.h                         |  12 ++
 include/linux/extcon.h                             |  23 +++
 include/linux/netdevice.h                          |  34 ++++-
 kernel/locking/mutex.c                             |  25 ++--
 kernel/module.c                                    | 166 +++++++++++++++++----
 kernel/module_signature.c                          |   2 +-
 kernel/module_signing.c                            |   2 +-
 kernel/trace/trace.c                               |   3 +-
 mm/memory.c                                        |   2 +-
 net/appletalk/ddp.c                                |  33 ++--
 net/can/af_can.c                                   |  34 +----
 net/can/j1939/main.c                               |  22 +--
 net/can/j1939/socket.c                             |  13 +-
 net/can/proc.c                                     |  19 ++-
 net/core/filter.c                                  |  12 +-
 net/core/flow_dissector.c                          |   6 +-
 net/dccp/ipv6.c                                    |   5 +
 net/ipv6/ip6_input.c                               |  10 --
 net/ipv6/tcp_ipv6.c                                |   5 +
 net/sunrpc/auth_gss/svcauth_gss.c                  |  11 +-
 net/vmw_vsock/af_vsock.c                           |   1 +
 sound/pci/hda/hda_intel.c                          |   8 +
 sound/pci/hda/patch_realtek.c                      |   3 +-
 sound/soc/codecs/cs42l42.c                         |  74 +++++----
 sound/soc/codecs/cs42l42.h                         |  13 +-
 sound/soc/codecs/es8316.c                          |   9 +-
 sound/soc/codecs/rt5640.c                          |   4 +-
 sound/soc/codecs/rt5651.c                          |   4 +-
 sound/soc/codecs/rt5659.c                          |   5 +
 sound/soc/codecs/sgtl5000.c                        |   2 +-
 sound/usb/quirks.c                                 |   1 +
 .../testing/selftests/net/forwarding/tc_flower.sh  |  38 ++++-
 81 files changed, 660 insertions(+), 334 deletions(-)


