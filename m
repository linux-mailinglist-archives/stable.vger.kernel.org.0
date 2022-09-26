Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A08035EA081
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235382AbiIZKjy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236133AbiIZKhg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:37:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8365341D3A;
        Mon, 26 Sep 2022 03:22:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0271BB8092F;
        Mon, 26 Sep 2022 10:22:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 054D1C433D6;
        Mon, 26 Sep 2022 10:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187730;
        bh=dYH5v8D1ri4Ot+4p+PDzFubpTQAoxIyTMWq6X4lvJqU=;
        h=From:To:Cc:Subject:Date:From;
        b=QXwo+0CZ2B/22YDeNDs6QthFFenxiNutKOj7NMgjaiesmZTqFnfrUsZYKAcALjkIS
         kDNJIja1dOJa50lTglzI0BjLoUiLQrmqTWzvWadTUMy1jjnaE5/84B023lDozbkzBx
         0/hvYUTxlqBC5kg8ug3yEvX0GWbd9hSa3D26FwdU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.4 000/120] 5.4.215-rc1 review
Date:   Mon, 26 Sep 2022 12:10:33 +0200
Message-Id: <20220926100750.519221159@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.215-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.215-rc1
X-KernelTest-Deadline: 2022-09-28T10:07+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.215 release.
There are 120 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 28 Sep 2022 10:07:26 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.215-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.215-rc1

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: fix use-after-free when aborting corrupt attr inactivation

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: fix an ABBA deadlock in xfs_rename

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: don't commit sunit/swidth updates to disk if that would cause repair failures

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: split the sunit parameter update into two parts

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: refactor agfl length computation function

Brian Foster <bfoster@redhat.com>
    xfs: use bitops interface for buf log item AIL flag check

Brian Foster <bfoster@redhat.com>
    xfs: stabilize insert range start boundary to avoid COW writeback race

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: fix some memory leaks in log recovery

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: always log corruption errors

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: constify the buffer pointer arguments to error functions

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: convert EIO to EFSCORRUPTED when log contents are invalid

kaixuxia <xiakaixu1987@gmail.com>
    xfs: Fix deadlock between AGI and AGF when target_ip exists in xfs_rename()

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: attach dquots and reserve quota blocks during unwritten conversion

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: range check ri_cnt when recovering log items

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: add missing assert in xfs_fsmap_owner_from_rmap

Christoph Hellwig <hch@lst.de>
    xfs: slightly tweak an assert in xfs_fs_map_blocks

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: replace -EIO with -EFSCORRUPTED for corrupt metadata

Jan Kara <jack@suse.cz>
    ext4: make directory inode spreading reflect flexbg size

Luís Henriques <lhenriques@suse.de>
    ext4: fix bug in extents parsing when eh_entries == 0 and eh_depth > 0

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    workqueue: don't skip lockdep work dependency in cancel_work_sync()

Nathan Huckleberry <nhuck@google.com>
    drm/rockchip: Fix return type of cdn_dp_connector_mode_valid

Yao Wang1 <Yao.Wang1@amd.com>
    drm/amd/display: Limit user regamma to a valid value

Hamza Mahfooz <hamza.mahfooz@amd.com>
    drm/amdgpu: use dirty framebuffer helper

Linus Walleij <linus.walleij@linaro.org>
    gpio: ixp4xx: Make irqchip immutable

Vitaly Kuznetsov <vkuznets@redhat.com>
    Drivers: hv: Never allocate anything besides framebuffer from framebuffer memory region

Stefan Metzmacher <metze@samba.org>
    cifs: always initialize struct msghdr smb_msg completely

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: xhci-mtk: fix issue of out-of-bounds array access

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: fix Oops in dasd_alias_get_start_dev due to missing pavgroup

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: tegra-tcu: Use uart_xmit_advance(), fixes icount.tx accounting

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: tegra: Use uart_xmit_advance(), fixes icount.tx accounting

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: Create uart_xmit_advance()

Hangyu Hua <hbh25y@gmail.com>
    net: sched: fix possible refcount leak in tc_new_tfilter()

Sean Anderson <seanga2@gmail.com>
    net: sunhme: Fix packet reception for len < RX_COPY_THRESHOLD

Adrian Hunter <adrian.hunter@intel.com>
    perf kcore_copy: Do not check /proc/modules is unchanged

Lieven Hey <lieven.hey@kdab.com>
    perf jit: Include program header in ELF files

Marc Kleine-Budde <mkl@pengutronix.de>
    can: gs_usb: gs_can_open(): fix race dev->can.state condition

Florian Westphal <fw@strlen.de>
    netfilter: ebtables: fix memory leak when blob is malformed

Vladimir Oltean <vladimir.oltean@nxp.com>
    net/sched: taprio: make qdisc_leaf() see the per-netdev-queue pfifo child qdiscs

Vladimir Oltean <vladimir.oltean@nxp.com>
    net/sched: taprio: avoid disabling offload when it was never enabled

Liang He <windhl@126.com>
    of: mdio: Add of_node_put() when breaking out of for_each_xx

Michal Jaron <michalx.jaron@intel.com>
    i40e: Fix set max_tx_rate when it is lower than 1 Mbps

Michal Jaron <michalx.jaron@intel.com>
    i40e: Fix VF set max MTU size

Michal Jaron <michalx.jaron@intel.com>
    iavf: Fix set max MTU size with port VLAN and jumbo frames

Norbert Zulinski <norbertx.zulinski@intel.com>
    iavf: Fix bad page state

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    MIPS: Loongson32: Fix PHY-mode being left unspecified

Randy Dunlap <rdunlap@infradead.org>
    MIPS: lantiq: export clk_get_io() for lantiq_wdt.ko

Benjamin Poirier <bpoirier@nvidia.com>
    net: team: Unsync device addresses on ndo_stop

Lu Wei <luwei32@huawei.com>
    ipvlan: Fix out-of-bound bugs caused by unset skb->mac_header

Brett Creeley <brett.creeley@intel.com>
    iavf: Fix cached head and tail value for iavf_get_tx_pending

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nfnetlink_osf: fix possible bogus match in nf_osf_find()

David Leadbeater <dgl@dgl.cx>
    netfilter: nf_conntrack_irc: Tighten matching on DCC message

Igor Ryzhov <iryzhov@nfware.com>
    netfilter: nf_conntrack_sip: fix ct_sip_walk_headers

Fabio Estevam <festevam@denx.de>
    arm64: dts: rockchip: Remove 'enable-active-low' from rk3399-puma

zain wang <wzz@rock-chips.com>
    arm64: dts: rockchip: Set RK3399-Gru PCLK_EDP to 24 MHz

Brian Norris <briannorris@chromium.org>
    arm64: dts: rockchip: Pull up wlan wake# on Gru-Bob

Chao Yu <chao.yu@oppo.com>
    mm/slub: fix to return errno if kmalloc() fails

Ard Biesheuvel <ardb@kernel.org>
    efi: libstub: check Shim mode using MokSBStateRT

Callum Osmotherly <callum.osmotherly@gmail.com>
    ALSA: hda/realtek: Enable 4-speaker output Dell Precision 5530 laptop

Luke D. Jones <luke@ljones.dev>
    ALSA: hda/realtek: Add quirk for ASUS GA503R laptop

Luke D. Jones <luke@ljones.dev>
    ALSA: hda/realtek: Add pincfg for ASUS G533Z HP jack

Luke D. Jones <luke@ljones.dev>
    ALSA: hda/realtek: Add pincfg for ASUS G513 HP jack

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Re-arrange quirk table entries

huangwenhui <huangwenhuia@uniontech.com>
    ALSA: hda/realtek: Add quirk for Huawei WRT-WX9

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ALSA: hda: add Intel 5 Series / 3400 PCI DID

Mohan Kumar <mkumard@nvidia.com>
    ALSA: hda/tegra: set depop delay for tegra

jerry meng <jerry-meng@foxmail.com>
    USB: serial: option: add Quectel RM520N

Carl Yin(殷张成) <carl.yin@quectel.com>
    USB: serial: option: add Quectel BG95 0x0203 composition

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Fix RST error in hub.c

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "usb: gadget: udc-xilinx: replace memcpy with memcpy_toio"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "usb: add quirks for Lenovo OneLink+ Dock"

Pawel Laszczak <pawell@cadence.com>
    usb: cdns3: fix issue with rearming ISO OUT endpoint

Piyush Mehta <piyush.mehta@amd.com>
    usb: gadget: udc-xilinx: replace memcpy with memcpy_toio

Jean-Francois Le Fillatre <jflf_kernel@gmx.com>
    usb: add quirks for Lenovo OneLink+ Dock

Sergiu Moga <sergiu.moga@microchip.com>
    tty: serial: atmel: Preserve previous USART mode if RS485 disabled

Lino Sanfilippo <LinoSanfilippo@gmx.de>
    serial: atmel: remove redundant assignment in rs485_config

Codrin.Ciubotariu@microchip.com <Codrin.Ciubotariu@microchip.com>
    tty/serial: atmel: RS485 & ISO7816: wait for TXRDY before sending data

Siddh Raman Pant <code@siddh.me>
    wifi: mac80211: Fix UAF in ieee80211_scan_rx()

Marcus Folkesson <marcus.folkesson@gmail.com>
    iio: adc: mcp3911: correct "microchip,device-addr" property

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:adc:mcp3911: Switch to generic firmware properties.

Ikjoon Jang <ikjn@chromium.org>
    usb: xhci-mtk: relax TT periodic bandwidth allocation

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: xhci-mtk: allow multiple Start-Split in a microframe

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: xhci-mtk: add some schedule error number

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: xhci-mtk: add a function to (un)load bandwidth info

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: xhci-mtk: use @sch_tt to check whether need do TT schedule

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: xhci-mtk: add only one extra CS for FS/LS INTR

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: xhci-mtk: get the microframe boundary for ESIT

Wesley Cheng <quic_wcheng@quicinc.com>
    usb: dwc3: gadget: Avoid duplicate requests to enable Run/Stop

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Don't modify GEVNTCOUNT in pullup()

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Refactor pullup()

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Prevent repeat pullup()

Wesley Cheng <quic_wcheng@quicinc.com>
    usb: dwc3: Issue core soft reset before enabling run/stop

Wesley Cheng <wcheng@codeaurora.org>
    usb: dwc3: gadget: Avoid starting DWC3 gadget during UDC unbind

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/sigmatel: Fix unused variable warning for beep power change

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    cgroup: Add missing cpus_read_lock() to cgroup_attach_task_all()

Hyunwoo Kim <imv4bel@gmail.com>
    video: fbdev: pxa3xx-gcu: Fix integer overflow in pxa3xx_gcu_write

Youling Tang <tangyouling@loongson.cn>
    mksysmap: Fix the mismatch of 'L0' symbols in System.map

Alexander Sverdlin <alexander.sverdlin@nokia.com>
    MIPS: OCTEON: irq: Fix octeon_irq_force_ciu_mapping()

David Howells <dhowells@redhat.com>
    afs: Return -EAGAIN, not -EREMOTEIO, when a file already locked

jerry.meng <jerry-meng@foxmail.com>
    net: usb: qmi_wwan: add Quectel RM520N

Mohan Kumar <mkumard@nvidia.com>
    ALSA: hda/tegra: Align BDL entry to 4KB boundary

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/sigmatel: Keep power up while beep is enabled

David Howells <dhowells@redhat.com>
    rxrpc: Fix calc of resend age

David Howells <dhowells@redhat.com>
    rxrpc: Fix local destruction being repeated

Xiaolei Wang <xiaolei.wang@windriver.com>
    regulator: pfuze100: Fix the global-out-of-bounds access in pfuze100_regulator_probe()

Takashi Iwai <tiwai@suse.de>
    ASoC: nau8824: Fix semaphore unbalance at error paths

Chandan Babu R <chandan.babu@oracle.com>
    iomap: iomap that extends beyond EOF should be marked dirty

Chandan Babu R <chandan.babu@oracle.com>
    MAINTAINERS: add Chandan as xfs maintainer for 5.4.y

Stefan Metzmacher <metze@samba.org>
    cifs: don't send down the destination address to sendmsg for a SOCK_STREAM

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: revalidate mapping when doing direct writes

Yipeng Zou <zouyipeng@huawei.com>
    tracing: hold caller_addr to hardirq_{enable,disable}_ip

Borislav Petkov <bp@suse.de>
    task_stack, x86/cea: Force-inline stack helpers

Sasha Levin <sashal@kernel.org>
    ALSA: pcm: oss: Fix race at SNDCTL_DSP_SYNC

Ard Biesheuvel <ardb@kernel.org>
    efi: libstub: Disable struct randomization

Sami Tolvanen <samitolvanen@google.com>
    efi/libstub: Disable Shadow Call Stack

Yang Yingliang <yangyingliang@huawei.com>
    parisc: ccio-dma: Add missing iounmap in error path in ccio_probe()

Stuart Menefy <stuart.menefy@mathembedded.com>
    drm/meson: Fix OSD1 RGB to YCbCr coefficient

Stuart Menefy <stuart.menefy@mathembedded.com>
    drm/meson: Correct OSD1 global alpha value

Pali Rohár <pali@kernel.org>
    gpio: mpc8xxx: Fix support for IRQ_TYPE_LEVEL_LOW flow_type in mpc85xx

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Turn off open-by-filehandle and NFS re-export for NFSv4.0

Sergey Shtylyov <s.shtylyov@omp.ru>
    of: fdt: fix off-by-one error in unflatten_dt_nodes()


-------------

Diffstat:

 MAINTAINERS                                        |   3 +-
 Makefile                                           |   4 +-
 arch/arm64/boot/dts/rockchip/rk3399-gru-bob.dts    |   5 +
 .../boot/dts/rockchip/rk3399-gru-chromebook.dtsi   |   9 ++
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi      |   1 -
 arch/mips/cavium-octeon/octeon-irq.c               |  10 ++
 arch/mips/lantiq/clk.c                             |   1 +
 arch/mips/loongson32/common/platform.c             |  16 +-
 arch/x86/include/asm/cpu_entry_area.h              |   2 +-
 drivers/firmware/efi/libstub/Makefile              |  10 ++
 drivers/firmware/efi/libstub/secureboot.c          |   8 +-
 drivers/gpio/gpio-ixp4xx.c                         |  17 ++-
 drivers/gpio/gpio-mpc8xxx.c                        |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c        |   2 +
 .../drm/amd/display/modules/color/color_gamma.c    |   4 +
 drivers/gpu/drm/meson/meson_plane.c                |   2 +-
 drivers/gpu/drm/meson/meson_viu.c                  |   2 +-
 drivers/gpu/drm/rockchip/cdn-dp-core.c             |   5 +-
 drivers/hv/vmbus_drv.c                             |  10 +-
 drivers/iio/adc/mcp3911.c                          |  16 +-
 drivers/net/can/usb/gs_usb.c                       |   4 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  32 +++-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  20 +++
 drivers/net/ethernet/intel/iavf/iavf_txrx.c        |   9 +-
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c    |   7 +-
 drivers/net/ethernet/sun/sunhme.c                  |   4 +-
 drivers/net/ipvlan/ipvlan_core.c                   |   6 +-
 drivers/net/team/team.c                            |  24 ++-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/of/fdt.c                                   |   2 +-
 drivers/of/of_mdio.c                               |   1 +
 drivers/parisc/ccio-dma.c                          |   1 +
 drivers/regulator/pfuze100-regulator.c             |   2 +-
 drivers/s390/block/dasd_alias.c                    |   9 +-
 drivers/tty/serial/atmel_serial.c                  |  32 ++--
 drivers/tty/serial/serial-tegra.c                  |   5 +-
 drivers/tty/serial/tegra-tcu.c                     |   2 +-
 drivers/usb/cdns3/gadget.c                         |   1 +
 drivers/usb/core/hub.c                             |   2 +-
 drivers/usb/dwc3/core.c                            |   2 +-
 drivers/usb/dwc3/core.h                            |   4 +
 drivers/usb/dwc3/gadget.c                          |  81 +++++-----
 drivers/usb/host/xhci-mtk-sch.c                    | 149 ++++++++++--------
 drivers/usb/host/xhci-mtk.h                        |   2 -
 drivers/usb/serial/option.c                        |   6 +
 drivers/video/fbdev/pxa3xx-gcu.c                   |   2 +-
 fs/afs/misc.c                                      |   1 +
 fs/cifs/connect.c                                  |   7 +-
 fs/cifs/file.c                                     |   3 +
 fs/cifs/transport.c                                |   6 +-
 fs/ext4/extents.c                                  |   4 +
 fs/ext4/ialloc.c                                   |   2 +-
 fs/nfs/super.c                                     |  27 ++--
 fs/xfs/libxfs/xfs_alloc.c                          |  27 +++-
 fs/xfs/libxfs/xfs_attr_leaf.c                      |  12 +-
 fs/xfs/libxfs/xfs_bmap.c                           |  16 +-
 fs/xfs/libxfs/xfs_btree.c                          |   5 +-
 fs/xfs/libxfs/xfs_da_btree.c                       |  24 ++-
 fs/xfs/libxfs/xfs_dir2.c                           |   4 +-
 fs/xfs/libxfs/xfs_dir2_leaf.c                      |   4 +-
 fs/xfs/libxfs/xfs_dir2_node.c                      |  12 +-
 fs/xfs/libxfs/xfs_dir2_sf.c                        |  28 +++-
 fs/xfs/libxfs/xfs_ialloc.c                         |  64 ++++++++
 fs/xfs/libxfs/xfs_ialloc.h                         |   1 +
 fs/xfs/libxfs/xfs_inode_fork.c                     |   6 +
 fs/xfs/libxfs/xfs_refcount.c                       |   4 +-
 fs/xfs/libxfs/xfs_rtbitmap.c                       |   6 +-
 fs/xfs/xfs_acl.c                                   |  15 +-
 fs/xfs/xfs_attr_inactive.c                         |  10 +-
 fs/xfs/xfs_attr_list.c                             |   5 +-
 fs/xfs/xfs_bmap_item.c                             |   7 +-
 fs/xfs/xfs_bmap_util.c                             |  12 ++
 fs/xfs/xfs_buf_item.c                              |   2 +-
 fs/xfs/xfs_dquot.c                                 |   2 +-
 fs/xfs/xfs_error.c                                 |  27 +++-
 fs/xfs/xfs_error.h                                 |   7 +-
 fs/xfs/xfs_extfree_item.c                          |   5 +-
 fs/xfs/xfs_fsmap.c                                 |   1 +
 fs/xfs/xfs_inode.c                                 |  40 ++++-
 fs/xfs/xfs_inode_item.c                            |   5 +-
 fs/xfs/xfs_iomap.c                                 |  17 +++
 fs/xfs/xfs_iops.c                                  |  10 +-
 fs/xfs/xfs_log_recover.c                           |  72 ++++++---
 fs/xfs/xfs_message.c                               |   2 +-
 fs/xfs/xfs_message.h                               |   2 +-
 fs/xfs/xfs_mount.c                                 | 168 ++++++++++++++-------
 fs/xfs/xfs_pnfs.c                                  |   4 +-
 fs/xfs/xfs_qm.c                                    |  13 +-
 fs/xfs/xfs_refcount_item.c                         |   5 +-
 fs/xfs/xfs_rmap_item.c                             |   9 +-
 fs/xfs/xfs_trace.h                                 |  21 +++
 include/linux/iomap.h                              |   2 +
 include/linux/sched/task_stack.h                   |   2 +-
 include/linux/serial_core.h                        |  17 +++
 kernel/cgroup/cgroup-v1.c                          |   3 +
 kernel/trace/trace_preemptirq.c                    |   4 +-
 kernel/workqueue.c                                 |   6 +-
 mm/slub.c                                          |   5 +-
 net/bridge/netfilter/ebtables.c                    |   4 +-
 net/mac80211/scan.c                                |  11 +-
 net/netfilter/nf_conntrack_irc.c                   |  34 ++++-
 net/netfilter/nf_conntrack_sip.c                   |   4 +-
 net/netfilter/nfnetlink_osf.c                      |   4 +-
 net/rxrpc/call_event.c                             |   2 +-
 net/rxrpc/local_object.c                           |   3 +
 net/sched/cls_api.c                                |   1 +
 net/sched/sch_taprio.c                             |  18 ++-
 scripts/mksysmap                                   |   2 +-
 sound/core/oss/pcm_oss.c                           |   5 +-
 sound/pci/hda/hda_intel.c                          |   2 +
 sound/pci/hda/hda_tegra.c                          |   3 +-
 sound/pci/hda/patch_hdmi.c                         |   1 +
 sound/pci/hda/patch_realtek.c                      |  31 +++-
 sound/pci/hda/patch_sigmatel.c                     |  24 +++
 sound/soc/codecs/nau8824.c                         |  17 ++-
 tools/perf/util/genelf.c                           |  14 ++
 tools/perf/util/genelf.h                           |   4 +
 tools/perf/util/symbol-elf.c                       |   7 +-
 118 files changed, 1096 insertions(+), 396 deletions(-)


