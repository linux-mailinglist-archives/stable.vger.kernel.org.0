Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C78BB3E7E45
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbhHJRcN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:32:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:59544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230317AbhHJRcM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:32:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5684460F41;
        Tue, 10 Aug 2021 17:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616709;
        bh=k+b4fpuTCOMkXtRY8R7n+DtNPKiq76MgxDFHJuo2idc=;
        h=From:To:Cc:Subject:Date:From;
        b=CMgVWrOl665E76wSjlQUw2QmOmvPYmsjd58yDXcJjnizEpaoK47oc+meVPTa8ajl8
         GRUXD2NCkcwzR6NzeELuvUeEL02tqsq0CcWhJPaQ5qyN5CqDjdhbM9WxMKWjLq2HvU
         gwJPIqxzLxIalQPQAVnDcpsBoHIVTEoVmf4zfiG4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.19 00/54] 4.19.203-rc1 review
Date:   Tue, 10 Aug 2021 19:29:54 +0200
Message-Id: <20210810172944.179901509@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.203-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.203-rc1
X-KernelTest-Deadline: 2021-08-12T17:29+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.203 release.
There are 54 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 12 Aug 2021 17:29:30 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.203-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.203-rc1

Anson Huang <Anson.Huang@nxp.com>
    ARM: imx: add mmdc ipg clock operation for mmdc

Letu Ren <fantasquex@gmail.com>
    net/qla3xxx: fix schedule while atomic in ql_wait_for_drvr_lock and ql_adapter_reset

Prarit Bhargava <prarit@redhat.com>
    alpha: Send stop IPI to send to online CPUs

Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>
    reiserfs: check directory items on read from disk

Yu Kuai <yukuai3@huawei.com>
    reiserfs: add check for root_inode in reiserfs_fill_super

Christoph Hellwig <hch@lst.de>
    libata: fix ata_pio_sector for CONFIG_HIGHMEM

Reinhard Speyerer <rspmn@arcor.de>
    qmi_wwan: add network device usage statistics for qmimux devices

Like Xu <likexu@tencent.com>
    perf/x86/amd: Don't touch the AMD64_EVENTSEL_HOSTONLY bit inside the guest

Dongliang Mu <mudongliangabcd@gmail.com>
    spi: meson-spicc: fix memory leak in meson_spicc_remove

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Fix per-cpu counter corruption on 32-bit builds

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: accept userspace interrupt only if no event is injected

Zheyu Ma <zheyuma97@gmail.com>
    pcmcia: i82092: fix a null pointer dereference bug

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: Malta: Do not byte-swap accesses to the CBUS UART

Maciej W. Rozycki <macro@orcam.me.uk>
    serial: 8250: Mask out floating 16/32-bit bus bits

Theodore Ts'o <tytso@mit.edu>
    ext4: fix potential htree corruption when growing large_dir directories

Alex Xu (Hello71) <alex_y_xu@yahoo.ca>
    pipe: increase minimum default pipe size to 2 pages

Johan Hovold <johan@kernel.org>
    media: rtl28xxu: fix zero-length control request

Xiangyang Zhang <xyz.sun.ok@gmail.com>
    staging: rtl8723bs: Fix a resource leak in sd_int_dpc

Jens Wiklander <jens.wiklander@linaro.org>
    tee: add tee_shm_alloc_kernel_buf()

Tyler Hicks <tyhicks@linux.microsoft.com>
    optee: Clear stale cache entries during initialization

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing/histogram: Rename "cpu" to "common_cpu"

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing / histogram: Give calculation hist_fields a size

Hui Su <suhui@zeku.com>
    scripts/tracing: fix the bug that can't parse raw_trace_func

Dmitry Osipenko <digetx@gmail.com>
    usb: otg-fsm: Fix hrtimer list corruption

Maxim Devaev <mdevaev@gmail.com>
    usb: gadget: f_hid: idle uses the highest byte for duration

Phil Elwell <phil@raspberrypi.com>
    usb: gadget: f_hid: fixed NULL pointer dereference

Maxim Devaev <mdevaev@gmail.com>
    usb: gadget: f_hid: added GET_IDLE and SET_IDLE handlers

Alexander Tsoy <alexander@tsoy.me>
    ALSA: usb-audio: Add registration quirk for JBL Quantum 600

Anirudh Rayabharam <mail@anirudhrb.com>
    firmware_loader: fix use-after-free in firmware_fallback_sysfs

Anirudh Rayabharam <mail@anirudhrb.com>
    firmware_loader: use -ETIMEDOUT instead of -EAGAIN in fw_load_sysfs_fallback

David Bauer <mail@david-bauer.net>
    USB: serial: ftdi_sio: add device ID for Auto-M3 OP-COM v2

Willy Tarreau <w@1wt.eu>
    USB: serial: ch341: fix character loss at high transfer rates

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add Telit FD980 composition 0x1056

Qiang.zhang <qiang.zhang@windriver.com>
    USB: usbtmc: Fix RCU stall warning

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    Bluetooth: defer cleanup of resources in hci_unregister_dev()

Yu Kuai <yukuai3@huawei.com>
    blk-iolatency: error out if blk_get_queue() failed in iolatency_set_limit()

Pavel Skripkin <paskripkin@gmail.com>
    net: vxge: fix use-after-free in vxge_device_unregister

Pavel Skripkin <paskripkin@gmail.com>
    net: fec: fix use-after-free in fec_drv_remove

Pavel Skripkin <paskripkin@gmail.com>
    net: pegasus: fix uninit-value in get_interrupt_interval

Dan Carpenter <dan.carpenter@oracle.com>
    bnx2x: fix an error code in bnx2x_nic_load()

H. Nikolaus Schaller <hns@goldelico.com>
    mips: Fix non-POSIX regexp

Antoine Tenart <atenart@kernel.org>
    net: ipv6: fix returned variable type in ip6_skb_dst_mtu

Fei Qin <fei.qin@corigine.com>
    nfp: update ethtool reporting of pauseframe control

Xin Long <lucien.xin@gmail.com>
    sctp: move the active_key update after sh_keys is added

Wang Hai <wanghai38@huawei.com>
    net: natsemi: Fix missing pci_disable_device() in probe and remove

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: videobuf2-core: dequeue if start_streaming fails

Li Manyi <limanyi@uniontech.com>
    scsi: sr: Return correct event when media event code is 3

H. Nikolaus Schaller <hns@goldelico.com>
    omap5-board-common: remove not physically existing vdds_1v8_main fixed-regulator

Dario Binacchi <dariobin@libero.it>
    clk: stm32f4: fix post divisor setup for I2S/SAI PLLs

chihhao.chen <chihhao.chen@mediatek.com>
    ALSA: usb-audio: fix incorrect clock source setting

Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
    ARM: dts: colibri-imx6ull: limit SDIO clock to 25MHz

Yang Yingliang <yangyingliang@huawei.com>
    ARM: imx: add missing iounmap()

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Fix racy deletion of subscriber

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    Revert "ACPICA: Fix memory leak caused by _CID repair function"


-------------

Diffstat:

 Documentation/trace/histogram.rst                  |  2 +-
 Makefile                                           |  4 +-
 arch/alpha/kernel/smp.c                            |  2 +-
 arch/arm/boot/dts/imx6ull-colibri-wifi.dtsi        |  1 +
 arch/arm/boot/dts/omap5-board-common.dtsi          |  9 +--
 arch/arm/mach-imx/mmdc.c                           | 21 +++++-
 arch/mips/Makefile                                 |  2 +-
 arch/mips/mti-malta/malta-platform.c               |  3 +-
 arch/x86/events/perf_event.h                       |  3 +-
 arch/x86/kvm/mmu.c                                 |  2 +-
 arch/x86/kvm/x86.c                                 | 13 +++-
 block/blk-iolatency.c                              |  6 +-
 drivers/acpi/acpica/nsrepair2.c                    |  7 --
 drivers/ata/libata-sff.c                           | 35 +++++++---
 drivers/base/firmware_loader/fallback.c            | 14 ++--
 drivers/base/firmware_loader/firmware.h            | 10 ++-
 drivers/base/firmware_loader/main.c                |  2 +
 drivers/clk/clk-stm32f4.c                          | 10 +--
 drivers/media/common/videobuf2/videobuf2-core.c    | 13 +++-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c            | 11 +++-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |  3 +-
 drivers/net/ethernet/freescale/fec_main.c          |  2 +-
 drivers/net/ethernet/natsemi/natsemi.c             |  8 +--
 drivers/net/ethernet/neterion/vxge/vxge-main.c     |  6 +-
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |  2 +
 drivers/net/ethernet/qlogic/qla3xxx.c              |  6 +-
 drivers/net/usb/pegasus.c                          | 14 +++-
 drivers/net/usb/qmi_wwan.c                         | 76 ++++++++++++++++++++--
 drivers/pcmcia/i82092.c                            |  1 +
 drivers/scsi/sr.c                                  |  2 +-
 drivers/spi/spi-meson-spicc.c                      |  2 +
 drivers/staging/rtl8723bs/hal/sdio_ops.c           |  2 +
 drivers/tee/optee/call.c                           | 36 +++++++++-
 drivers/tee/optee/core.c                           |  9 +++
 drivers/tee/optee/optee_private.h                  |  1 +
 drivers/tee/tee_shm.c                              | 18 +++++
 drivers/tty/serial/8250/8250_port.c                | 12 +++-
 drivers/usb/class/usbtmc.c                         |  9 +--
 drivers/usb/common/usb-otg-fsm.c                   |  6 +-
 drivers/usb/gadget/function/f_hid.c                | 44 +++++++++++--
 drivers/usb/serial/ch341.c                         |  1 +
 drivers/usb/serial/ftdi_sio.c                      |  1 +
 drivers/usb/serial/ftdi_sio_ids.h                  |  3 +
 drivers/usb/serial/option.c                        |  2 +
 fs/ext4/namei.c                                    |  2 +-
 fs/pipe.c                                          | 19 +++++-
 fs/reiserfs/stree.c                                | 31 +++++++--
 fs/reiserfs/super.c                                |  8 +++
 include/linux/tee_drv.h                            |  1 +
 include/linux/usb/otg-fsm.h                        |  1 +
 include/net/bluetooth/hci_core.h                   |  1 +
 include/net/ip6_route.h                            |  2 +-
 kernel/trace/trace.c                               |  4 ++
 kernel/trace/trace_events_hist.c                   | 25 +++++--
 net/bluetooth/hci_core.c                           | 16 ++---
 net/bluetooth/hci_sock.c                           | 49 +++++++++-----
 net/bluetooth/hci_sysfs.c                          |  3 +
 net/sctp/auth.c                                    | 14 ++--
 scripts/tracing/draw_functrace.py                  |  6 +-
 sound/core/seq/seq_ports.c                         | 39 +++++++----
 sound/usb/clock.c                                  |  6 ++
 sound/usb/quirks.c                                 |  1 +
 62 files changed, 512 insertions(+), 152 deletions(-)


