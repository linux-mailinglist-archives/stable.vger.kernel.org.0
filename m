Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46A622F168E
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387755AbhAKNxx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:53:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:55876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731046AbhAKNIZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:08:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D67BE22AAF;
        Mon, 11 Jan 2021 13:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370464;
        bh=Elw8csTZ5UYj2nDRPXURSHpV4xdwISYf0lIgsK110ew=;
        h=From:To:Cc:Subject:Date:From;
        b=Aiv1PoVU6Ab/ENAW21RuobefKcl3cPu9gfvJdUhc1C9dltQEL7uDawgpdwRKIyjYs
         lPdBRodyi4h2AF8iQlm+U9rqc0o3mqSiHcj/Q9Pif269Ag+qhqOAr1BuEbDX4nlY+m
         XNcyqD550NNs39ceFojk7NDxb8udrvp4bP/O7ytU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 4.19 00/77] 4.19.167-rc1 review
Date:   Mon, 11 Jan 2021 14:01:09 +0100
Message-Id: <20210111130036.414620026@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.167-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.167-rc1
X-KernelTest-Deadline: 2021-01-13T13:00+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.167 release.
There are 77 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 13 Jan 2021 13:00:19 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.167-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.167-rc1

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: fix shift out of bounds reported by UBSAN

Ying-Tsun Huang <ying-tsun.huang@amd.com>
    x86/mtrr: Correct the range check before performing MTRR type lookups

Florian Westphal <fw@strlen.de>
    netfilter: xt_RATEEST: reject non-null terminated string from userspace

Vasily Averin <vvs@virtuozzo.com>
    netfilter: ipset: fix shift-out-of-bounds in htable_bits()

Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
    netfilter: x_tables: Update remaining dereference to RCU

Roger Pau Monne <roger.pau@citrix.com>
    xen/pvh: correctly setup the PV EFI interface for dom0

Bard Liao <yung-chuan.liao@linux.intel.com>
    Revert "device property: Keep secondary firmware node secondary by type"

Filipe Manana <fdmanana@suse.com>
    btrfs: send: fix wrong file path when there is an inode with a pending rmdir

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Fix speaker volume control on Lenovo C940

bo liu <bo.liu@senarytech.com>
    ALSA: hda/conexant: add a new hda codec CX11970

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/via: Fix runtime PM for Clevo W35xSS

Dan Williams <dan.j.williams@intel.com>
    x86/mm: Fix leak of pmd ptlock

Johan Hovold <johan@kernel.org>
    USB: serial: keyspan_pda: remove unused variable

Eddie Hung <eddie.hung@mediatek.com>
    usb: gadget: configfs: Fix use-after-free issue with udc_name

Chandana Kishori Chiluveru <cchiluve@codeaurora.org>
    usb: gadget: configfs: Preserve function ordering after bind failure

Sriharsha Allenki <sallenki@codeaurora.org>
    usb: gadget: Fix spinlock lockup on usb_function_deactivate

Yang Yingliang <yangyingliang@huawei.com>
    USB: gadget: legacy: fix return error code in acm_ms_bind()

Manish Narani <manish.narani@xilinx.com>
    usb: gadget: u_ether: Fix MTU size mismatch with RX packet size

Zqiang <qiang.zhang@windriver.com>
    usb: gadget: function: printer: Fix a memory leak for interface descriptor

Jerome Brunet <jbrunet@baylibre.com>
    usb: gadget: f_uac2: reset wMaxPacketSize

Arnd Bergmann <arnd@arndb.de>
    usb: gadget: select CONFIG_CRC32

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix UBSAN warnings for MIDI jacks

Johan Hovold <johan@kernel.org>
    USB: usblp: fix DMA to stack

Johan Hovold <johan@kernel.org>
    USB: yurex: fix control-URB timeout handling

Bjørn Mork <bjorn@mork.no>
    USB: serial: option: add Quectel EM160R-GL

Daniel Palmer <daniel@0x0f.com>
    USB: serial: option: add LongSung M5710 module support

Johan Hovold <johan@kernel.org>
    USB: serial: iuu_phoenix: fix DMA from stack

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: uas: Add PNY USB Portable SSD to unusual_uas

Randy Dunlap <rdunlap@infradead.org>
    usb: usbip: vhci_hcd: protect shift size

Michael Grzeschik <m.grzeschik@pengutronix.de>
    USB: xhci: fix U1/U2 handling for hardware with XHCI_INTEL_HOST quirk set

Yu Kuai <yukuai3@huawei.com>
    usb: chipidea: ci_hdrc_imx: add missing put_device() call in usbmisc_get_init_data()

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    usb: dwc3: ulpi: Use VStsDone to detect PHY regs access completion

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    USB: cdc-wdm: Fix use after free in service_outstanding_interrupt().

Sean Young <sean@mess.org>
    USB: cdc-acm: blacklist another IR Droid device

taehyun.cho <taehyun.cho@samsung.com>
    usb: gadget: enable super speed plus

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    staging: mt7621-dma: Fix a resource leak in an error handling path

Ard Biesheuvel <ardb@kernel.org>
    crypto: ecdh - avoid buffer overflow in ecdh_set_secret()

Dexuan Cui <decui@microsoft.com>
    video: hyperv_fb: Fix the mmap() regression for v5.4.y and older

Hans de Goede <hdegoede@redhat.com>
    Bluetooth: revert: hci_h5: close serdev device and free hu in h5_close

Florian Fainelli <f.fainelli@gmail.com>
    net: systemport: set dev->max_mtu to UMAC_MAX_MTU_SIZE

Antoine Tenart <atenart@kernel.org>
    net-sysfs: take the rtnl lock when accessing xps_rxqs_map and num_tc

Antoine Tenart <atenart@kernel.org>
    net-sysfs: take the rtnl lock when storing xps_rxqs

Randy Dunlap <rdunlap@infradead.org>
    net: sched: prevent invalid Scell_log shift count

Yunjian Wang <wangyunjian@huawei.com>
    vhost_net: fix ubuf refcount incorrectly when sendmsg fails

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: work around power-saving bug on some chip versions

Bjørn Mork <bjorn@mork.no>
    net: usb: qmi_wwan: add Quectel EM160R-GL

Roland Dreier <roland@kernel.org>
    CDC-NCM: remove "connected" log message

Xie He <xie.he.0141@gmail.com>
    net: hdlc_ppp: Fix issues when mod_timer is called while timer is running

Cong Wang <cong.wang@bytedance.com>
    erspan: fix version 1 check in gre_parse_header()

Yunjian Wang <wangyunjian@huawei.com>
    net: hns: fix return value check in __lb_other_process()

Guillaume Nault <gnault@redhat.com>
    ipv4: Ignore ECN bits for fib lookups in fib_compute_spec_dst()

Yunjian Wang <wangyunjian@huawei.com>
    tun: fix return value when the number of iovs exceeds MAX_SKB_FRAGS

Grygorii Strashko <grygorii.strashko@ti.com>
    net: ethernet: ti: cpts: fix ethtool output when no ptp_clock registered

Antoine Tenart <atenart@kernel.org>
    net-sysfs: take the rtnl lock when accessing xps_cpus_map and num_tc

Antoine Tenart <atenart@kernel.org>
    net-sysfs: take the rtnl lock when storing xps_cpus

Dinghao Liu <dinghao.liu@zju.edu.cn>
    net: ethernet: Fix memleak in ethoc_probe

John Wang <wangzhiqiang.bj@bytedance.com>
    net/ncsi: Use real net-device for response handler

Petr Machata <me@pmachata.org>
    net: dcb: Validate netlink message in DCB handler

Jeff Dike <jdike@akamai.com>
    virtio_net: Fix recursive call to cpus_read_lock()

Manish Chopra <manishc@marvell.com>
    qede: fix offload for IPIP tunnel packets

Stefan Chulski <stefanc@marvell.com>
    net: mvpp2: Fix GoP port 3 Networking Complex Control configurations

Dan Carpenter <dan.carpenter@oracle.com>
    atm: idt77252: call pci_disable_device() on error path

Rasmus Villemoes <rasmus.villemoes@prevas.dk>
    ethernet: ucc_geth: set dev->max_mtu to 1518

Rasmus Villemoes <rasmus.villemoes@prevas.dk>
    ethernet: ucc_geth: fix use-after-free in ucc_geth_remove()

Stefan Chulski <stefanc@marvell.com>
    net: mvpp2: prs: fix PPPoE with ipv6 packet parse

Stefan Chulski <stefanc@marvell.com>
    net: mvpp2: Add TCAM entry to drop flow control pause frames

Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
    i40e: Fix Error I40E_AQ_RC_EINVAL when removing VFs

Alexey Dobriyan <adobriyan@gmail.com>
    proc: fix lookup in /proc/net subdirectories after setns(2)

Alexey Dobriyan <adobriyan@gmail.com>
    proc: change ->nlink under proc_subdir_lock

Linus Torvalds <torvalds@linux-foundation.org>
    depmod: handle the case of /sbin/depmod without /sbin in PATH

Huang Shijie <sjhuang@iluvatar.ai>
    lib/genalloc: fix the overflow when size is too big

Bart Van Assche <bvanassche@acm.org>
    scsi: scsi_transport_spi: Set RQF_PM for domain validation commands

Bart Van Assche <bvanassche@acm.org>
    scsi: ide: Do not set the RQF_PREEMPT flag for sense requests

Adrian Hunter <adrian.hunter@intel.com>
    scsi: ufs-pci: Ensure UFS device is in PowerDown mode for suspend-to-disk ->poweroff()

Bean Huo <beanhuo@micron.com>
    scsi: ufs: Fix wrong print message in dev_err()

Yunfeng Ye <yeyunfeng@huawei.com>
    workqueue: Kick a worker based on the actual activation of delayed works

Dominique Martinet <asmadeus@codewreck.org>
    kbuild: don't hardcode depmod path


-------------

Diffstat:

 Makefile                                           |  6 +-
 arch/x86/kernel/cpu/mtrr/generic.c                 |  6 +-
 arch/x86/kvm/mmu.h                                 |  2 +-
 arch/x86/mm/pgtable.c                              |  2 +
 arch/x86/xen/efi.c                                 | 12 ++--
 arch/x86/xen/enlighten_pv.c                        |  2 +-
 arch/x86/xen/enlighten_pvh.c                       |  4 ++
 arch/x86/xen/xen-ops.h                             |  4 +-
 crypto/ecdh.c                                      |  3 +-
 drivers/atm/idt77252.c                             |  2 +-
 drivers/base/core.c                                |  2 +-
 drivers/bluetooth/hci_h5.c                         |  8 +--
 drivers/ide/ide-atapi.c                            |  1 -
 drivers/ide/ide-io.c                               |  5 --
 drivers/net/ethernet/broadcom/bcmsysport.c         |  1 +
 drivers/net/ethernet/ethoc.c                       |  3 +-
 drivers/net/ethernet/freescale/ucc_geth.c          |  3 +-
 drivers/net/ethernet/hisilicon/hns/hns_ethtool.c   |  4 ++
 drivers/net/ethernet/intel/i40e/i40e.h             |  3 +
 drivers/net/ethernet/intel/i40e/i40e_main.c        | 10 ++++
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  4 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |  2 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c     | 38 +++++++++++-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.h     |  2 +-
 drivers/net/ethernet/qlogic/qede/qede_fp.c         |  5 ++
 drivers/net/ethernet/realtek/r8169.c               |  6 +-
 drivers/net/ethernet/ti/cpts.c                     |  2 +
 drivers/net/tun.c                                  |  2 +-
 drivers/net/usb/cdc_ncm.c                          |  3 -
 drivers/net/usb/qmi_wwan.c                         |  1 +
 drivers/net/virtio_net.c                           | 12 ++--
 drivers/net/wan/hdlc_ppp.c                         |  7 +++
 drivers/scsi/scsi_transport_spi.c                  | 27 ++++++---
 drivers/scsi/ufs/ufshcd-pci.c                      | 34 ++++++++++-
 drivers/scsi/ufs/ufshcd.c                          |  2 +-
 drivers/staging/mt7621-dma/mtk-hsdma.c             |  4 +-
 drivers/usb/chipidea/ci_hdrc_imx.c                 |  6 +-
 drivers/usb/class/cdc-acm.c                        |  4 ++
 drivers/usb/class/cdc-wdm.c                        | 16 ++++-
 drivers/usb/class/usblp.c                          | 21 ++++++-
 drivers/usb/dwc3/core.h                            |  1 +
 drivers/usb/dwc3/ulpi.c                            |  2 +-
 drivers/usb/gadget/Kconfig                         |  2 +
 drivers/usb/gadget/composite.c                     | 10 +++-
 drivers/usb/gadget/configfs.c                      | 19 ++++--
 drivers/usb/gadget/function/f_printer.c            |  1 +
 drivers/usb/gadget/function/f_uac2.c               | 69 +++++++++++++++++-----
 drivers/usb/gadget/function/u_ether.c              |  9 +--
 drivers/usb/gadget/legacy/acm_ms.c                 |  4 +-
 drivers/usb/host/xhci.c                            | 24 ++++----
 drivers/usb/misc/yurex.c                           |  3 +
 drivers/usb/serial/iuu_phoenix.c                   | 20 +++++--
 drivers/usb/serial/keyspan_pda.c                   |  2 -
 drivers/usb/serial/option.c                        |  3 +
 drivers/usb/storage/unusual_uas.h                  |  7 +++
 drivers/usb/usbip/vhci_hcd.c                       |  2 +
 drivers/vhost/net.c                                |  6 +-
 drivers/video/fbdev/hyperv_fb.c                    |  6 +-
 fs/btrfs/send.c                                    | 49 +++++++++------
 fs/proc/generic.c                                  | 55 +++++++++++------
 fs/proc/internal.h                                 |  7 +++
 fs/proc/proc_net.c                                 | 16 -----
 include/linux/proc_fs.h                            |  8 ++-
 include/net/red.h                                  |  4 +-
 kernel/workqueue.c                                 | 13 +++-
 lib/genalloc.c                                     | 25 ++++----
 net/core/net-sysfs.c                               | 65 ++++++++++++++++----
 net/dcb/dcbnl.c                                    |  2 +
 net/ipv4/fib_frontend.c                            |  2 +-
 net/ipv4/gre_demux.c                               |  2 +-
 net/ipv4/netfilter/arp_tables.c                    |  2 +-
 net/ipv4/netfilter/ip_tables.c                     |  2 +-
 net/ipv6/netfilter/ip6_tables.c                    |  2 +-
 net/ncsi/ncsi-rsp.c                                |  2 +-
 net/netfilter/ipset/ip_set_hash_gen.h              | 20 ++-----
 net/netfilter/xt_RATEEST.c                         |  3 +
 net/sched/sch_choke.c                              |  2 +-
 net/sched/sch_gred.c                               |  2 +-
 net/sched/sch_red.c                                |  2 +-
 net/sched/sch_sfq.c                                |  2 +-
 scripts/depmod.sh                                  |  2 +
 sound/pci/hda/hda_intel.c                          |  2 -
 sound/pci/hda/patch_conexant.c                     |  1 +
 sound/pci/hda/patch_realtek.c                      |  6 ++
 sound/pci/hda/patch_via.c                          | 13 ++++
 sound/usb/midi.c                                   |  4 ++
 86 files changed, 556 insertions(+), 230 deletions(-)


