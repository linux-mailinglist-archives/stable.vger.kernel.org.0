Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9BBC11B595
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730794AbfLKPRH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:17:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:44386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731835AbfLKPRG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:17:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0608120663;
        Wed, 11 Dec 2019 15:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077425;
        bh=CX/DyLbFYQ0VK3VBVXS1ZxzKwNFGDdD4q45bKTPADPU=;
        h=From:To:Cc:Subject:Date:From;
        b=q+G0XudtpVdCQfWmOjYyLxDBNKeWWrYRFHN7ks+UcKrBYjVuNjeabLqUpCnnaq0oz
         76Si5Jmu+r6tAaZjexZA+037twiK0d0eRTjk3VpXfdtlIvPWMnNZg7G6IAqCIjuTj2
         ualgAK6uexDvhKxYSfY9HUfhWD+GsbA31WnOI5kI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 000/243] 4.19.89-stable review
Date:   Wed, 11 Dec 2019 16:02:42 +0100
Message-Id: <20191211150339.185439726@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.89-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.89-rc1
X-KernelTest-Deadline: 2019-12-13T15:03+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.89 release.
There are 243 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 13 Dec 2019 14:56:06 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.89-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.89-rc1

Jann Horn <jannh@google.com>
    binder: Handle start==NULL in binder_update_page_range()

Jann Horn <jannh@google.com>
    binder: Fix race between mmap() and binder_alloc_print_pages()

Nicolas Pitre <nico@fluxnic.net>
    vcs: prevent write access to vcsu devices

Wei Wang <wvw@google.com>
    thermal: Fix deadlock in thermal thermal_zone_device_check

Jan Kara <jack@suse.cz>
    iomap: Fix pipe page leakage during splicing

Viresh Kumar <viresh.kumar@linaro.org>
    RDMA/qib: Validate ->show()/store() callbacks before calling them

Johan Hovold <johan@kernel.org>
    can: ucan: fix non-atomic allocation in completion handler

Sharvari Harisangam <sharvari@marvell.com>
    mwifiex: update set_mac_address logic

Gregory CLEMENT <gregory.clement@bootlin.com>
    spi: atmel: Fix CS high support

Navid Emamdoost <navid.emamdoost@gmail.com>
    crypto: user - fix memory leak in crypto_report

Ard Biesheuvel <ard.biesheuvel@linaro.org>
    crypto: ecdh - fix big endian bug in ECC library

Mark Salter <msalter@redhat.com>
    crypto: ccp - fix uninitialized list head

Ayush Sawal <ayush.sawal@chelsio.com>
    crypto: af_alg - cast ki_complete ternary op to int

Tudor Ambarus <tudor.ambarus@microchip.com>
    crypto: atmel-aes - Fix IV handling when req->nbytes < ivsize

Christian Lamparter <chunkeey@gmail.com>
    crypto: crypto4xx - fix double-free in crypto4xx_destroy_sdr

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86: Grab KVM's srcu lock when setting nested state

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: fix presentation of TSX feature in ARCH_CAPABILITIES

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: do not modify masked bits of shared MSRs

Zenghui Yu <yuzenghui@huawei.com>
    KVM: arm/arm64: vgic: Don't rely on the wrong pending table

Marek Szyprowski <m.szyprowski@samsung.com>
    arm64: dts: exynos: Revert "Remove unneeded address space mapping for soc node"

Dan Carpenter <dan.carpenter@oracle.com>
    drm/i810: Prevent underflow in ioctl

Johan Hovold <johan@kernel.org>
    drm/msm: fix memleak on release

Jan Kara <jack@suse.cz>
    jbd2: Fix possible overflow in jbd2_log_space_left()

Tejun Heo <tj@kernel.org>
    kernfs: fix ino wrap-around detection

Jouni Hogander <jouni.hogander@unikie.com>
    can: slcan: Fix use-after-free Read in slcan_open

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    tty: vt: keyboard: reject invalid keycodes

Pavel Shilovsky <pshilov@microsoft.com>
    CIFS: Fix SMB2 oplock break processing

Pavel Shilovsky <pshilov@microsoft.com>
    CIFS: Fix NULL-pointer dereference in smb2_push_mandatory_locks

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    xfrm interface: fix management of phydev

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    xfrm interface: fix list corruption for x-netns

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    xfrm interface: avoid corruption on changelink

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    xfrm interface: fix memory leak on creation

Kai-Heng Feng <kai.heng.feng@canonical.com>
    x86/PCI: Avoid AMD FCH XHCI USB PME# from D0 defect

Joerg Roedel <jroedel@suse.de>
    x86/mm/32: Sync only to VMALLOC_END in vmalloc_sync_all()

Navid Emamdoost <navid.emamdoost@gmail.com>
    Input: Fix memory leak in psxpad_spi_probe

Mike Leach <mike.leach@linaro.org>
    coresight: etm4x: Fix input validation for sysfs.

Hans de Goede <hdegoede@redhat.com>
    Input: goodix - add upside-down quirk for Teclast X89 tablet

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    Input: synaptics-rmi4 - don't increment rmiaddr for SMBus transfers

Lucas Stach <l.stach@pengutronix.de>
    Input: synaptics-rmi4 - re-enable IRQs in f34v7_do_reflash

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    Input: synaptics - switch another X1 Carbon 6 to RMI/SMbus

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ALSA: hda - Add mute led support for HP ProBook 645 G4

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: oss: Avoid potential buffer overflows

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Dell headphone has noise on unmute for ALC236

Hui Wang <hui.wang@canonical.com>
    ALSA: hda/realtek - Enable the headset-mic on a Xiaomi's laptop

Jian-Hong Pan <jian-hong@endlessm.com>
    ALSA: hda/realtek - Enable internal speaker of ASUS UX431FLC

Miklos Szeredi <mszeredi@redhat.com>
    fuse: verify attributes

Miklos Szeredi <mszeredi@redhat.com>
    fuse: verify nlink

Xuewei Zhang <xueweiz@google.com>
    sched/fair: Scale bandwidth quota and period without losing quota/period ratio precision

Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>
    net: aquantia: fix RSS table and key sizes

Helen Fornazier <helen.koike@collabora.com>
    media: vimc: fix start stream when link is disabled

Felix Brack <fb@ltec.ch>
    ARM: dts: am335x-pdu001: Fix polarity of card detection input

Rob Herring <robh@kernel.org>
    ARM: dts: sunxi: Fix PMU compatible strings

Ladislav Michl <ladis@linux-mips.org>
    ASoC: max9867: Fix power management

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    clk: renesas: rcar-gen3: Set state when registering SD clocks

YueHaibing <yuehaibing@huawei.com>
    usb: mtu3: fix dbginfo in qmu_tx_zlp_error_handler

Qian Cai <cai@gmx.us>
    mlx4: Use snprintf instead of complicated strcpy

Mike Marciniszyn <mike.marciniszyn@intel.com>
    IB/hfi1: Close VNIC sdma_progress sleep window

Kaike Wan <kaike.wan@intel.com>
    IB/hfi1: Ignore LNI errors before DC8051 transitions to Polling state

Chen-Yu Tsai <wens@csie.org>
    ARM: dts: sun8i: a23/a33: Fix up RTC device node

Nir Dotan <nird@mellanox.com>
    mlxsw: spectrum_router: Relax GRE decap matching check

Geert Uytterhoeven <geert+renesas@glider.be>
    soc: renesas: r8a77990-sysc: Fix initialization order of 3DG-{A,B}

Jakub Audykowicz <jakub.audykowicz@gmail.com>
    sctp: frag_point sanity check

Bjorn Andersson <bjorn.andersson@linaro.org>
    clk: qcom: gcc-msm8998: Disable halt check of UFS clocks

Jonathan Marek <jonathan@marek.ca>
    firmware: qcom: scm: fix compilation error when disabled

Andreas Pape <ap@ca-pape.de>
    media: stkwebcam: Bugfix for wrong return values

Dmitry Safonov <dima@arista.com>
    tty: Don't block on IO when ldisc change is pending

Paul Kocialkowski <paul.kocialkowski@bootlin.com>
    ARM: dts: sun8i: h3: Fix the system-control register range

Ryan Case <ryandcase@chromium.org>
    tty: serial: qcom_geni_serial: Fix softlock

Kieran Bingham <kieran.bingham@ideasonboard.com>
    media: uvcvideo: Abstract streaming object lifetime

zhengbin <zhengbin13@huawei.com>
    nfsd: Return EPERM, not EACCES, in some SETATTR cases

Aaro Koskinen <aaro.koskinen@iki.fi>
    MIPS: OCTEON: cvmx_pko_mem_debug8: use oldest forward compatible definition

Geert Uytterhoeven <geert+renesas@glider.be>
    clk: renesas: r8a77995: Correct parent clock of DU

Takeshi Kihara <takeshi.kihara.df@renesas.com>
    clk: renesas: r8a77990: Correct parent clock of DU

Joel Stanley <joel@jms.id.au>
    powerpc/math-emu: Update macros from GCC

Kees Cook <keescook@chromium.org>
    pstore/ram: Avoid NULL deref in ftrace merging failure path

Erez Alfasi <ereza@mellanox.com>
    net/mlx4_core: Fix return codes of unsupported operations

David Teigland <teigland@redhat.com>
    dlm: fix invalid cluster name warning

Rob Herring <robh@kernel.org>
    ARM: dts: realview: Fix some more duplicate regulator nodes

Neil Armstrong <narmstrong@baylibre.com>
    media: cxd2880-spi: fix probe when dvb_attach fails

Jeffrey Hugo <jhugo@codeaurora.org>
    clk: qcom: Fix MSM8998 resets

Chen-Yu Tsai <wens@csie.org>
    clk: sunxi-ng: h3/h5: Fix CSI_MCLK parent

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    clk: meson: meson8b: fix the offset of vid_pll_dco's N value

Daniel Mack <daniel@zonque.org>
    ARM: dts: pxa: clean up USB controller nodes

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: fix mtd_oobavail() incoherent returned value

Masahiro Yamada <yamada.masahiro@socionext.com>
    kbuild: fix single target build for external module

Paul Walmsley <paul.walmsley@sifive.com>
    modpost: skip ELF local symbols during section mismatch check

Yuchung Cheng <ycheng@google.com>
    tcp: fix SNMP TCP timeout under-estimation

Yuchung Cheng <ycheng@google.com>
    tcp: fix SNMP under-estimation on failed retransmission

Yuchung Cheng <ycheng@google.com>
    tcp: fix off-by-one bug on aborting window-probing socket

Rob Herring <robh@kernel.org>
    ARM: dts: realview-pbx: Fix duplicate regulator nodes

Lubomir Rintel <lkundrak@v3.sk>
    ARM: dts: mmp2: fix the gpio interrupt cell number

Eric Dumazet <edumazet@google.com>
    tcp: make tcp_space() aware of socket backlog

Rob Herring <robh@kernel.org>
    kbuild: disable dtc simple_bus_reg warnings by default

Geert Uytterhoeven <geert+renesas@glider.be>
    soc: renesas: r8a77980-sysc: Correct A3VIP[012] power domain hierarchy

Geert Uytterhoeven <geert+renesas@glider.be>
    soc: renesas: r8a77980-sysc: Correct names of A2DP[01] power domains

Geert Uytterhoeven <geert+renesas@glider.be>
    soc: renesas: r8a77970-sysc: Correct names of A2DP/A2CN power domains

Stephen Boyd <sboyd@kernel.org>
    clk: mediatek: Drop more __init markings for driver probe

Stephen Boyd <sboyd@kernel.org>
    clk: mediatek: Drop __init from mtk_clk_register_cpumuxes()

Yonghong Song <yhs@fb.com>
    tools/bpf: make libbpf _GNU_SOURCE friendly

Martin Schiller <ms@dev.tdt.de>
    net/x25: fix null_x25_address handling

Martin Schiller <ms@dev.tdt.de>
    net/x25: fix called/calling length calculation in x25_parse_address_block

Neil Armstrong <narmstrong@baylibre.com>
    arm64: dts: meson-gxl-khadas-vim: fix GPIO lines names

Neil Armstrong <narmstrong@baylibre.com>
    arm64: dts: meson-gxbb-odroidc2: fix GPIO lines names

Neil Armstrong <narmstrong@baylibre.com>
    arm64: dts: meson-gxbb-nanopi-k2: fix GPIO lines names

Neil Armstrong <narmstrong@baylibre.com>
    arm64: dts: meson-gxl-libretech-cc: fix GPIO lines names

Aaro Koskinen <aaro.koskinen@iki.fi>
    ARM: OMAP1/2: fix SoC name printing

Linus Walleij <linus.walleij@linaro.org>
    gpio: OF: Parse MMC-specific CD and WP properties

Young_X <YangX92@hotmail.com>
    ASoC: au8540: use 64-bit arithmetic instead of 32-bit

Yonghong Song <yhs@fb.com>
    tools: bpftool: fix a bitfield pretty print issue

Yonghong Song <yhs@fb.com>
    bpf: btf: check name validity for various types

Yonghong Song <yhs@fb.com>
    bpf: btf: implement btf_name_valid_identifier()

Scott Mayhew <smayhew@redhat.com>
    nfsd: fix a warning in __cld_pipe_upcall()

YueHaibing <yuehaibing@huawei.com>
    can: xilinx: fix return type of ndo_start_xmit function

Clément Péron <peron.clem@gmail.com>
    ARM: debug: enable UART1 for socfpga Cyclone5

Wen Yang <wen.yang99@zte.com.cn>
    dlm: NULL check before kmem_cache_destroy is not needed

Maxime Ripard <maxime.ripard@bootlin.com>
    ARM: dts: sun8i: v3s: Change pinctrl nodes to avoid warning

Maxime Ripard <maxime.ripard@bootlin.com>
    ARM: dts: sun8i: a23/a33: Fix OPP DTC warnings

Maxime Ripard <maxime.ripard@bootlin.com>
    ARM: dts: sun7i: Fix HDMI output DTC warning

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    ARM: dts: r8a779[01]: Disable unconnected LVDS encoders

Maxime Ripard <maxime.ripard@bootlin.com>
    ARM: dts: sun5i: a10s: Fix HDMI output DTC warning

Maxime Ripard <maxime.ripard@bootlin.com>
    ARM: dts: sun4i: Fix HDMI output DTC warning

Maxime Ripard <maxime.ripard@bootlin.com>
    ARM: dts: sun4i: Fix gpio-keys warning

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: rsnd: tidyup registering method for rsnd_kctrl_new()

Joerg Roedel <jroedel@suse.de>
    iommu/amd: Fix line-break in error log reporting

Xin Long <lucien.xin@gmail.com>
    sctp: increase sk_wmem_alloc when head->truesize is increased

J. Bruce Fields <bfields@redhat.com>
    lockd: fix decoding of TEST results

Thierry Reding <treding@nvidia.com>
    gpu: host1x: Fix syncpoint ID field size on Tegra186

Neil Armstrong <narmstrong@baylibre.com>
    clk: meson: Fix GXL HDMI PLL fractional bits width

Lucas Stach <l.stach@pengutronix.de>
    i2c: imx: don't print error message on probe defer

Stefan Agner <stefan@agner.ch>
    serial: imx: fix error handling in console_setup

Colin Ian King <colin.king@canonical.com>
    altera-stapl: check for a null key before strcasecmp'ing it

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    slimbus: ngd: Fix build error on x86

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    dma-mapping: fix return type of dma_set_max_seg_size()

Keith Busch <keith.busch@intel.com>
    nvme: Free ctrl device name on init failure

David Miller <davem@davemloft.net>
    sparc: Correct ctx->saw_frame_pointer logic.

David Miller <davem@davemloft.net>
    sparc: Fix JIT fused branch convergance.

Sahitya Tummala <stummala@codeaurora.org>
    f2fs: fix to allow node segment for GC by ioctl path

Otavio Salvador <otavio@ossystems.com.br>
    ARM: dts: rockchip: Assign the proper GPIO clocks for rv1108

Otavio Salvador <otavio@ossystems.com.br>
    ARM: dts: rockchip: Fix the PMU interrupt number for rv1108

Yunlong Song <yunlong.song@huawei.com>
    f2fs: change segment to section in f2fs_ioc_gc_range

Yunlong Song <yunlong.song@huawei.com>
    f2fs: fix count of seg_freed to make sec_freed correct

Chao Yu <yuchao0@huawei.com>
    f2fs: fix to account preflush command for noflush_merge mode

Alexey Dobriyan <adobriyan@gmail.com>
    ACPI: fix acpi_find_child_device() invocation in acpi_preset_companion()

Brian Norris <briannorris@chromium.org>
    usb: dwc3: don't log probe deferrals; but do log other error codes

Thinh Nguyen <thinh.nguyen@synopsys.com>
    usb: dwc3: debugfs: Properly print/set link state for HS

Breno Leitao <leitao@debian.org>
    selftests/powerpc: Skip test instead of failing

Breno Leitao <leitao@debian.org>
    selftests/powerpc: Allocate base registers

Colin Ian King <colin.king@canonical.com>
    net: qualcomm: rmnet: move null check on dev before dereferecing it

Christian Lamparter <chunkeey@gmail.com>
    dmaengine: dw-dmac: implement dma protection control setting

Vinod Koul <vkoul@kernel.org>
    dmaengine: coh901318: Remove unused variable

Jia-Ju Bai <baijiaju1990@gmail.com>
    dmaengine: coh901318: Fix a double-lock bug

Hangbin Liu <liuhangbin@gmail.com>
    net/ipv6: re-do dad when interface has IFF_NOARP flag change

Magnus Damm <damm+renesas@opensource.se>
    ravb: Clean up duplex handling

Luca Coelho <luciano.coelho@intel.com>
    iwlwifi: fix cfg structs for 22000 with different RF modules

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cec: report Vendor ID after initialization

Hans Verkuil <hverkuil@xs4all.nl>
    media: pulse8-cec: return 0 when invalidating the logical address

Philipp Zabel <p.zabel@pengutronix.de>
    media: coda: fix memory corruption in case more than 32 instances are opened

Marek Szyprowski <m.szyprowski@samsung.com>
    ARM: dts: exynos: Use Samsung SoC specific compatible for DWC2 module

Baruch Siach <baruch@tkos.co.il>
    rtc: dt-binding: abx80x: fix resistance scale

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    rtc: max8997: Fix the returned value in case of error in 'max8997_rtc_read_alarm()'

Nylon Chen <nylon7@andestech.com>
    nds32: Fix the items of hwcap_str ordering issue.

Vincent Chen <vincentc@andestech.com>
    math-emu/soft-fp.h: (_FP_ROUND_ZERO) cast 0 to void to fix warning

Ursula Braun <ursula.braun@linux.ibm.com>
    net/smc: use after free fix in smc_wr_tx_put_slot()

Aaro Koskinen <aaro.koskinen@iki.fi>
    MIPS: OCTEON: octeon-platform: fix typing

Steve Wise <swise@opengridcomputing.com>
    iw_cxgb4: only reconnect with MPAv1 if the peer aborts

Dave Chinner <dchinner@redhat.com>
    iomap: readpages doesn't zero page tail beyond EOF

Dave Chinner <dchinner@redhat.com>
    iomap: dio data corruption and spurious errors when pipes fill

Dave Chinner <dchinner@redhat.com>
    iomap: sub-block dio needs to zeroout beyond EOF

Dave Chinner <dchinner@redhat.com>
    iomap: FUA is wrong for DIO O_DSYNC writes into unwritten extents

Bruce Allan <bruce.w.allan@intel.com>
    ice: Fix possible NULL pointer de-reference

Dave Ertman <david.m.ertman@intel.com>
    ice: Fix return value from NAPI poll

Xue Chaojing <xuechaojing@huawei.com>
    net-next/hinic: fix a bug in rx data flow

Xue Chaojing <xuechaojing@huawei.com>
    net-next/hinic:fix a bug in set mac address

Dave Chinner <dchinner@redhat.com>
    xfs: extent shifting doesn't fully invalidate page cache

Ji-Ze Hong (Peter Hong) <hpeter@gmail.com>
    USB: serial: f81534: fix reading old/new IC config

Mark Brown <broonie@kernel.org>
    regulator: Fix return value of _set_load() stub

Xin Long <lucien.xin@gmail.com>
    sctp: count sk_wmem_alloc by skb truesize in sctp_packet_transmit

Katsuhiro Suzuki <katsuhiro@katsuster.net>
    clk: rockchip: fix ID of 8ch clock of I2S1 for rk3328

Katsuhiro Suzuki <katsuhiro@katsuster.net>
    clk: rockchip: fix I2S1 clock gate register for rk3328

Janne Huttunen <janne.huttunen@nokia.com>
    mm/vmstat.c: fix NUMA statistics updates

James Hughes <james.hughes@raspberrypi.org>
    firmware: raspberrypi: Fix firmware calls with large buffers

Shreeya Patel <shreeya.patel23498@gmail.com>
    Staging: iio: adt7316: Fix i2c data reading, set the data field

Brian Masney <masneyb@onstation.org>
    pinctrl: qcom: ssbi-gpio: fix gpio-hog related boot issues

Michal Simek <michal.simek@xilinx.com>
    arm64: dts: zynqmp: Fix node names which contain "_"

Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>
    crypto: bcm - fix normal/non key hash algorithm failure

Vitaly Chikunov <vt@altlinux.org>
    crypto: ecc - check for invalid values in the key verification test

Lucas Stach <l.stach@pengutronix.de>
    ARM: dts: imx6: RDU2: fix eGalax touchscreen node

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Fix getting optional clocks in clock_roles

Maxime Jourdan <mjourdan@baylibre.com>
    drivers: soc: Allow building the amlogic drivers without ARCH_MESON

Steffen Maier <maier@linux.ibm.com>
    scsi: zfcp: drop default switch case which might paper over missing case

Steffen Maier <maier@linux.ibm.com>
    scsi: zfcp: update kernel message for invalid FCP_CMND length, it's not the CDB

Andrew Lunn <andrew@lunn.ch>
    net: dsa: mv88e6xxx: Work around mv886e6161 SERDES missing MII_PHYSID2

Maciej W. Rozycki <macro@linux-mips.org>
    MIPS: SiByte: Enable ZONE_DMA32 for LittleSur

David Teigland <teigland@redhat.com>
    dlm: fix missing idr_destroy for recover_idr

John Keeping <john@metanate.com>
    ARM: dts: rockchip: Fix rk3288-rock2 vcc_flash name

Heiko Stuebner <heiko@sntech.de>
    clk: rockchip: fix rk3188 sclk_mac_lbtest parameter ordering

Finley Xiao <finley.xiao@rock-chips.com>
    clk: rockchip: fix rk3188 sclk_smc gate data

Alice Michael <alice.michael@intel.com>
    virtchnl: Fix off by one error

Mitch Williams <mitch.a.williams@intel.com>
    i40e: don't restart nway if autoneg not supported

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    rtc: max77686: Fix the returned value in case of error in 'max77686_rtc_read_time()'

Marek Szyprowski <m.szyprowski@samsung.com>
    rtc: s3c-rtc: Avoid using broken ALMYEAR register

Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
    net: ethernet: ti: cpts: correct debug for expired txq skb

Marek Szyprowski <m.szyprowski@samsung.com>
    extcon: max8997: Fix lack of path setting in USB device mode

Anand Moon <linux.amoon@gmail.com>
    ARM: dts: exynos: Fix LDO13 min values on Odroid XU3/XU4/HC1

Denis V. Lunev <den@openvz.org>
    dlm: fix possible call to kfree() for non-initialized pointer

Lev Faerman <lev.faerman@intel.com>
    ice: Fix NVM mask defines

Jagan Teki <jagan@amarulasolutions.com>
    clk: sunxi-ng: a64: Fix gate bit of DSI DPHY

Moni Shoua <monis@mellanox.com>
    net/mlx5: Release resource on error flow

Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>
    ARC: IOC: panic if kernel was started with previously enabled IOC

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: don't use position attribute on rule replacement

Jan Kara <jack@suse.cz>
    audit: Embed key into chunk

Vincent Whitchurch <vincent.whitchurch@axis.com>
    ARM: 8813/1: Make aligned 2-byte getuser()/putuser() atomic on ARMv6+

Andrei Otcheretianski <andrei.otcheretianski@intel.com>
    iwlwifi: mvm: Send non offchannel traffic via AP sta

Shahar S Matityahu <shahar.s.matityahu@intel.com>
    iwlwifi: trans: Clear persistence bit when starting the FW

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: mvm: synchronize TID queue removal

Arjun Vynipadath <arjun@chelsio.com>
    cxgb4vf: fix memleak in mac_hlist initialization

Douglas Anderson <dianders@chromium.org>
    serial: core: Allow processing sysrq at port unlock time

Wen Yang <wenyang@linux.alibaba.com>
    i2c: core: fix use after free in of_i2c_notify

Chuhong Yuan <hslester96@gmail.com>
    net: ep93xx_eth: fix mismatch of request_mem_region in remove

Chuhong Yuan <hslester96@gmail.com>
    rsxx: add missed destroy_workqueue calls in remove

Vitaly Kuznetsov <vkuznets@redhat.com>
    selftests: kvm: fix build with glibc >= 2.30

Yunhao Tian <t123yh@outlook.com>
    drm/sun4i: tcon: Set min division of TCON0_DCLK to 1.

paulhsia <paulhsia@chromium.org>
    ALSA: pcm: Fix stream lock usage in snd_pcm_period_elapsed()

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    perf/core: Consistently fail fork on allocation failures

Peter Zijlstra <peterz@infradead.org>
    sched/core: Avoid spurious lock dependencies

Pan Bian <bianpan2016@163.com>
    Input: cyttsp4_core - fix use after free bug

Xiaodong Xu <stid.smth@gmail.com>
    xfrm: release device reference for invalid state

Stephan Gerhold <stephan@gerhold.net>
    NFC: nxp-nci: Fix NULL pointer dereference after I2C communication error

Al Viro <viro@zeniv.linux.org.uk>
    audit_get_nd(): don't unlock parent too early

Al Viro <viro@zeniv.linux.org.uk>
    exportfs_decode_fh(): negative pinned may become positive without the parent locked

Mordechay Goodstein <mordechay.goodstein@intel.com>
    iwlwifi: pcie: don't consider IV len in A-MSDU

Sirong Wang <wangsirong@huawei.com>
    RDMA/hns: Correct the value of HNS_ROCE_HEM_CHUNK_LEN

Al Viro <viro@zeniv.linux.org.uk>
    autofs: fix a leak in autofs_expire_indirect()

Chuhong Yuan <hslester96@gmail.com>
    serial: ifx6x60: add missed pm_runtime_disable

Jiangfeng Xiao <xiaojiangfeng@huawei.com>
    serial: serial_core: Perform NULL checks for break_ctl ops

Vincent Whitchurch <vincent.whitchurch@axis.com>
    serial: pl011: Fix DMA ->flush_buffer()

Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
    tty: serial: msm_serial: Fix flow control

Peng Fan <peng.fan@nxp.com>
    tty: serial: fsl_lpuart: use the sg count from dma_map_sg

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    usb: gadget: u_serial: add missing port entry locking

Arnd Bergmann <arnd@arndb.de>
    lp: fix sparc64 LPSETTIMEOUT ioctl

Tuowen Zhao <ztuowen@gmail.com>
    sparc64: implement ioremap_uc

Jon Hunter <jonathanh@nvidia.com>
    arm64: tegra: Fix 'active-low' warning for Jetson TX1 regulator

Navid Emamdoost <navid.emamdoost@gmail.com>
    rsi: release skb if rsi_prepare_beacon fails


-------------

Diffstat:

 .../devicetree/bindings/rtc/abracon,abx80x.txt     |   2 +-
 Makefile                                           |  15 +--
 arch/arc/include/asm/cache.h                       |   2 +
 arch/arc/mm/cache.c                                |  20 +++-
 arch/arm/Kconfig.debug                             |  23 ++--
 arch/arm/boot/dts/am335x-pdu001.dts                |   2 +-
 arch/arm/boot/dts/arm-realview-pb1176.dts          |   4 +-
 arch/arm/boot/dts/arm-realview-pb11mp.dts          |   4 +-
 arch/arm/boot/dts/arm-realview-pbx.dtsi            |   5 +-
 arch/arm/boot/dts/exynos3250.dtsi                  |   2 +-
 arch/arm/boot/dts/exynos5422-odroid-core.dtsi      |   2 +-
 arch/arm/boot/dts/imx6qdl-zii-rdu2.dtsi            |   5 +-
 arch/arm/boot/dts/mmp2.dtsi                        |   2 +-
 arch/arm/boot/dts/pxa27x.dtsi                      |   2 +-
 arch/arm/boot/dts/pxa2xx.dtsi                      |   7 --
 arch/arm/boot/dts/pxa3xx.dtsi                      |   2 +-
 arch/arm/boot/dts/r8a7790-lager.dts                |   2 -
 arch/arm/boot/dts/r8a7791-koelsch.dts              |   2 -
 arch/arm/boot/dts/r8a7791-porter.dts               |   2 -
 arch/arm/boot/dts/rk3288-rock2-som.dtsi            |   2 +-
 arch/arm/boot/dts/rv1108.dtsi                      |  10 +-
 arch/arm/boot/dts/sun4i-a10-inet9f-rev03.dts       |   2 -
 arch/arm/boot/dts/sun4i-a10-pcduino.dts            |   2 -
 arch/arm/boot/dts/sun4i-a10.dtsi                   |   2 -
 arch/arm/boot/dts/sun5i-a10s.dtsi                  |   2 -
 arch/arm/boot/dts/sun6i-a31.dtsi                   |   2 +-
 arch/arm/boot/dts/sun7i-a20.dtsi                   |   4 +-
 arch/arm/boot/dts/sun8i-a23-a33.dtsi               |   6 +-
 arch/arm/boot/dts/sun8i-h3.dtsi                    |   8 +-
 arch/arm/boot/dts/sun8i-r16-bananapi-m2m.dts       |   4 +-
 arch/arm/boot/dts/sun8i-v3s-licheepi-zero.dts      |   4 +-
 arch/arm/boot/dts/sun8i-v3s.dtsi                   |  10 +-
 arch/arm/include/asm/uaccess.h                     |  18 +++
 arch/arm/lib/getuser.S                             |  11 ++
 arch/arm/lib/putuser.S                             |  20 ++--
 arch/arm/mach-omap1/id.c                           |   6 +-
 arch/arm/mach-omap2/id.c                           |   4 +-
 .../boot/dts/amlogic/meson-gxbb-nanopi-k2.dts      |   4 +-
 .../arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts |   4 +-
 .../dts/amlogic/meson-gxl-s905x-khadas-vim.dts     |   4 +-
 .../dts/amlogic/meson-gxl-s905x-libretech-cc.dts   |   4 +-
 arch/arm64/boot/dts/exynos/exynos5433.dtsi         |   6 +-
 arch/arm64/boot/dts/exynos/exynos7.dtsi            |   6 +-
 arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi     |   2 +-
 arch/arm64/boot/dts/xilinx/zynqmp-clk.dtsi         |   4 +-
 arch/arm64/boot/dts/xilinx/zynqmp-zcu100-revC.dts  |   4 +-
 arch/arm64/boot/dts/xilinx/zynqmp-zcu102-revA.dts  |  10 +-
 arch/arm64/boot/dts/xilinx/zynqmp-zcu106-revA.dts  |   2 +-
 arch/arm64/boot/dts/xilinx/zynqmp-zcu111-revA.dts  |   2 +-
 arch/arm64/boot/dts/xilinx/zynqmp.dtsi             |   4 +-
 arch/mips/Kconfig                                  |   1 +
 arch/mips/cavium-octeon/executive/cvmx-cmd-queue.c |   2 +-
 arch/mips/cavium-octeon/octeon-platform.c          |   2 +-
 arch/mips/include/asm/octeon/cvmx-pko.h            |   2 +-
 arch/nds32/kernel/setup.c                          |   3 +-
 arch/powerpc/include/asm/sfp-machine.h             |  92 +++++---------
 arch/sparc/include/asm/io_64.h                     |   1 +
 arch/sparc/net/bpf_jit_comp_64.c                   |  89 +++++++++-----
 arch/x86/kvm/x86.c                                 |  17 ++-
 arch/x86/mm/fault.c                                |   2 +-
 arch/x86/pci/fixup.c                               |  11 ++
 crypto/af_alg.c                                    |   2 +-
 crypto/crypto_user.c                               |   4 +-
 crypto/ecc.c                                       |  45 ++++---
 drivers/android/binder_alloc.c                     |  30 +++--
 drivers/block/rsxx/core.c                          |   2 +
 drivers/bus/ti-sysc.c                              |   9 +-
 drivers/char/lp.c                                  |   4 +
 drivers/clk/mediatek/clk-cpumux.c                  |   8 +-
 drivers/clk/mediatek/clk-mt7622.c                  |   4 +-
 drivers/clk/meson/gxbb.c                           |   8 +-
 drivers/clk/meson/meson8b.c                        |   2 +-
 drivers/clk/qcom/gcc-msm8998.c                     |  44 +++----
 drivers/clk/renesas/r8a77990-cpg-mssr.c            |   4 +-
 drivers/clk/renesas/r8a77995-cpg-mssr.c            |   4 +-
 drivers/clk/renesas/rcar-gen3-cpg.c                |  16 +--
 drivers/clk/rockchip/clk-rk3188.c                  |   8 +-
 drivers/clk/rockchip/clk-rk3328.c                  |   2 +-
 drivers/clk/sunxi-ng/ccu-sun50i-a64.c              |   2 +-
 drivers/clk/sunxi-ng/ccu-sun8i-h3.c                |   2 +-
 drivers/crypto/amcc/crypto4xx_core.c               |   6 +-
 drivers/crypto/atmel-aes.c                         |  53 +++++----
 drivers/crypto/bcm/cipher.c                        |   6 +-
 drivers/crypto/ccp/ccp-dmaengine.c                 |   1 +
 drivers/dma/coh901318.c                            |   5 -
 drivers/dma/dw/core.c                              |   2 +
 drivers/dma/dw/platform.c                          |   6 +
 drivers/dma/dw/regs.h                              |   4 +
 drivers/extcon/extcon-max8997.c                    |  10 +-
 drivers/firmware/raspberrypi.c                     |  35 +++---
 drivers/gpio/gpiolib-of.c                          |  39 ++++++
 drivers/gpu/drm/i810/i810_dma.c                    |   4 +-
 drivers/gpu/drm/msm/msm_debugfs.c                  |   6 +-
 drivers/gpu/drm/sun4i/sun4i_tcon.c                 |   2 +-
 drivers/gpu/host1x/hw/hw_host1x06_uclass.h         |   2 +-
 .../hwtracing/coresight/coresight-etm4x-sysfs.c    |  21 ++--
 drivers/i2c/busses/i2c-imx.c                       |   3 +-
 drivers/i2c/i2c-core-of.c                          |   4 +-
 drivers/infiniband/hw/cxgb4/cm.c                   |   3 +-
 drivers/infiniband/hw/hfi1/chip.c                  |  47 +++++++-
 drivers/infiniband/hw/hfi1/vnic_sdma.c             |  15 +--
 drivers/infiniband/hw/hns/hns_roce_hem.h           |   2 +-
 drivers/infiniband/hw/mlx4/sysfs.c                 |  12 +-
 drivers/infiniband/hw/qib/qib_sysfs.c              |   6 +
 drivers/input/joystick/psxpad-spi.c                |   2 +-
 drivers/input/mouse/synaptics.c                    |   1 +
 drivers/input/rmi4/rmi_f34v7.c                     |   3 +
 drivers/input/rmi4/rmi_smbus.c                     |   2 -
 drivers/input/touchscreen/cyttsp4_core.c           |   7 --
 drivers/input/touchscreen/goodix.c                 |   9 ++
 drivers/iommu/amd_iommu.c                          |  22 ++--
 drivers/media/cec/cec-adap.c                       |   7 ++
 drivers/media/platform/coda/coda-common.c          |  26 ++--
 drivers/media/platform/coda/coda.h                 |   3 +-
 drivers/media/platform/vimc/vimc-common.c          |   2 +
 drivers/media/spi/cxd2880-spi.c                    |   1 +
 drivers/media/usb/pulse8-cec/pulse8-cec.c          |   2 +-
 drivers/media/usb/stkwebcam/stk-webcam.c           |   6 +-
 drivers/media/usb/uvc/uvc_driver.c                 |  54 ++++++---
 drivers/misc/altera-stapl/altera.c                 |   3 +-
 drivers/net/can/slcan.c                            |   1 +
 drivers/net/can/usb/ucan.c                         |   2 +-
 drivers/net/can/xilinx_can.c                       |   2 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |  21 +++-
 drivers/net/ethernet/aquantia/atlantic/aq_cfg.h    |   4 +-
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c    |   2 +-
 .../net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c    |   6 +-
 drivers/net/ethernet/cirrus/ep93xx_eth.c           |   5 +-
 drivers/net/ethernet/huawei/hinic/hinic_main.c     |   7 +-
 drivers/net/ethernet/huawei/hinic/hinic_rx.c       |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |  10 +-
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h    |   6 +-
 drivers/net/ethernet/intel/ice/ice_switch.c        |   3 +
 drivers/net/ethernet/intel/ice/ice_txrx.c          |   3 +-
 drivers/net/ethernet/mellanox/mlx4/main.c          |  11 +-
 drivers/net/ethernet/mellanox/mlx5/core/qp.c       |   4 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |   5 +-
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c |   5 +-
 drivers/net/ethernet/renesas/ravb.h                |   1 -
 drivers/net/ethernet/renesas/ravb_main.c           |  19 +--
 drivers/net/ethernet/ti/cpts.c                     |   4 +-
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |   1 -
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |   7 ++
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  15 +++
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  10 ++
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |   2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  34 +++++-
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  |  20 ++--
 drivers/net/wireless/marvell/mwifiex/main.c        |   6 +-
 drivers/net/wireless/rsi/rsi_91x_mgmt.c            |   1 +
 drivers/nfc/nxp-nci/i2c.c                          |   6 +-
 drivers/nvme/host/core.c                           |   2 +-
 drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c           |  23 +++-
 drivers/rtc/rtc-max77686.c                         |   2 +-
 drivers/rtc/rtc-max8997.c                          |   2 +-
 drivers/rtc/rtc-s3c.c                              |   6 -
 drivers/s390/scsi/zfcp_erp.c                       |   3 -
 drivers/s390/scsi/zfcp_fsf.c                       |   7 +-
 drivers/slimbus/qcom-ngd-ctrl.c                    |   5 +-
 drivers/soc/Makefile                               |   2 +-
 drivers/soc/renesas/r8a77970-sysc.c                |   4 +-
 drivers/soc/renesas/r8a77980-sysc.c                |  10 +-
 drivers/soc/renesas/r8a77990-sysc.c                |  23 +---
 drivers/spi/spi-atmel.c                            |   6 +-
 drivers/staging/iio/addac/adt7316-i2c.c            |   2 +
 drivers/thermal/thermal_core.c                     |   4 +-
 drivers/tty/n_hdlc.c                               |   4 +-
 drivers/tty/n_r3964.c                              |   2 +-
 drivers/tty/n_tty.c                                |   8 +-
 drivers/tty/serial/amba-pl011.c                    |   6 +-
 drivers/tty/serial/fsl_lpuart.c                    |   4 +-
 drivers/tty/serial/ifx6x60.c                       |   3 +
 drivers/tty/serial/imx.c                           |   2 +-
 drivers/tty/serial/msm_serial.c                    |   6 +-
 drivers/tty/serial/qcom_geni_serial.c              |  56 ++++++---
 drivers/tty/serial/serial_core.c                   |   2 +-
 drivers/tty/tty_ldisc.c                            |   7 ++
 drivers/tty/vt/keyboard.c                          |   2 +-
 drivers/tty/vt/vc_screen.c                         |   3 +
 drivers/usb/dwc3/core.c                            |   3 +-
 drivers/usb/dwc3/debug.h                           |  29 +++++
 drivers/usb/dwc3/debugfs.c                         |  19 ++-
 drivers/usb/gadget/function/u_serial.c             |   2 +
 drivers/usb/mtu3/mtu3_qmu.c                        |   2 +-
 drivers/usb/serial/f81534.c                        |  20 +++-
 fs/autofs/expire.c                                 |   5 +-
 fs/cifs/file.c                                     |   7 +-
 fs/cifs/smb2misc.c                                 |   7 +-
 fs/dlm/lockspace.c                                 |   1 +
 fs/dlm/member.c                                    |   2 +-
 fs/dlm/memory.c                                    |   9 +-
 fs/dlm/user.c                                      |   3 +-
 fs/exportfs/expfs.c                                |  31 +++--
 fs/f2fs/file.c                                     |   2 +-
 fs/f2fs/gc.c                                       |  10 +-
 fs/f2fs/segment.c                                  |   2 +
 fs/fuse/dir.c                                      |  27 +++--
 fs/fuse/fuse_i.h                                   |   2 +
 fs/iomap.c                                         |  62 ++++++++--
 fs/kernfs/dir.c                                    |   5 +-
 fs/lockd/clnt4xdr.c                                |  22 +---
 fs/lockd/clntxdr.c                                 |  22 +---
 fs/nfsd/nfs4recover.c                              |  17 +--
 fs/nfsd/vfs.c                                      |  17 ++-
 fs/pstore/ram.c                                    |   2 +-
 fs/xfs/xfs_bmap_util.c                             |   8 +-
 include/dt-bindings/clock/rk3328-cru.h             |   2 +-
 include/dt-bindings/power/r8a77970-sysc.h          |   6 +-
 include/dt-bindings/power/r8a77980-sysc.h          |   6 +-
 include/linux/acpi.h                               |   2 +-
 include/linux/avf/virtchnl.h                       |   4 +-
 include/linux/dma-mapping.h                        |   3 +-
 include/linux/jbd2.h                               |   4 +-
 include/linux/kernfs.h                             |   1 +
 include/linux/mtd/mtd.h                            |   2 +-
 include/linux/platform_data/dma-dw.h               |   6 +
 include/linux/qcom_scm.h                           |   3 +
 include/linux/regulator/consumer.h                 |   2 +-
 include/linux/serial_core.h                        |  37 +++++-
 include/linux/tty.h                                |   7 ++
 include/math-emu/soft-fp.h                         |   2 +-
 include/net/sctp/sctp.h                            |   5 +
 include/net/tcp.h                                  |   2 +-
 include/net/xfrm.h                                 |   1 -
 kernel/audit_tree.c                                |  27 ++---
 kernel/audit_watch.c                               |   2 +-
 kernel/bpf/btf.c                                   |  82 +++++++++++++
 kernel/events/core.c                               |   2 +-
 kernel/sched/core.c                                |   3 +-
 kernel/sched/fair.c                                |  36 +++---
 mm/vmstat.c                                        |   7 +-
 net/ipv4/tcp_output.c                              |   2 +-
 net/ipv4/tcp_timer.c                               |  10 +-
 net/ipv6/addrconf.c                                |  19 ++-
 net/netfilter/nf_tables_api.c                      |  17 ++-
 net/sctp/chunk.c                                   |   6 +
 net/sctp/output.c                                  |  22 +---
 net/sctp/socket.c                                  |   3 +-
 net/smc/smc_wr.c                                   |   4 +-
 net/x25/af_x25.c                                   |  18 +--
 net/xfrm/xfrm_input.c                              |   3 +
 net/xfrm/xfrm_interface.c                          | 132 +++++++--------------
 scripts/Makefile.lib                               |   1 +
 scripts/mod/modpost.c                              |  12 ++
 sound/core/oss/linear.c                            |   2 +
 sound/core/oss/mulaw.c                             |   2 +
 sound/core/oss/route.c                             |   2 +
 sound/core/pcm_lib.c                               |   8 +-
 sound/pci/hda/patch_conexant.c                     |   1 +
 sound/pci/hda/patch_realtek.c                      |  18 ++-
 sound/soc/codecs/max9867.c                         |  72 ++++++-----
 sound/soc/codecs/max9867.h                         |   2 +-
 sound/soc/codecs/nau8540.c                         |   2 +-
 sound/soc/sh/rcar/core.c                           |  12 ++
 sound/soc/sh/rcar/dvc.c                            |   8 --
 tools/bpf/bpftool/btf_dumper.c                     |   6 +-
 tools/lib/bpf/libbpf.c                             |   2 +
 tools/lib/bpf/libbpf_errno.c                       |   1 +
 tools/testing/selftests/kvm/lib/assert.c           |   4 +-
 tools/testing/selftests/powerpc/ptrace/core-pkey.c |   5 +-
 .../testing/selftests/powerpc/ptrace/ptrace-gpr.c  |   2 +-
 .../selftests/powerpc/ptrace/ptrace-tm-gpr.c       |   4 +-
 .../selftests/powerpc/ptrace/ptrace-tm-spd-tar.c   |   2 +-
 .../selftests/powerpc/ptrace/ptrace-tm-spd-vsx.c   |   3 +-
 .../selftests/powerpc/ptrace/ptrace-tm-spr.c       |   2 +-
 .../selftests/powerpc/ptrace/ptrace-tm-tar.c       |   2 +-
 .../selftests/powerpc/ptrace/ptrace-tm-vsx.c       |   3 +-
 virt/kvm/arm/vgic/vgic-v3.c                        |   6 +-
 268 files changed, 1563 insertions(+), 1024 deletions(-)


