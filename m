Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE9375E9F50
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235297AbiIZKXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235299AbiIZKWn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:22:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C0C44C629;
        Mon, 26 Sep 2022 03:16:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4620CB80918;
        Mon, 26 Sep 2022 10:16:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FED3C433D6;
        Mon, 26 Sep 2022 10:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187386;
        bh=jsK0z8rxApO12lI7UPyM33peW43fSxvguH2sUoYVigw=;
        h=From:To:Cc:Subject:Date:From;
        b=WD93qahtmA2Bg/pSjjzqhRX1TbbgYSWYGk6HTe83bZNcgwc7GWawXJRT1x/sYQfJw
         RzmPcKPpN6SsHQZLwB0peqV+niahOKrBVqDMlzi5IV/c5E2IqipGo0mAUwpScNr3u9
         yWE/01mO51DBAUtkVfXQdE8yfPPLa2qe/lK6kMTw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 4.14 00/40] 4.14.295-rc1 review
Date:   Mon, 26 Sep 2022 12:11:28 +0200
Message-Id: <20220926100738.148626940@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.295-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.295-rc1
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

This is the start of the stable review cycle for the 4.14.295 release.
There are 40 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 28 Sep 2022 10:07:26 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.295-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.295-rc1

Dongliang Mu <mudongliangabcd@gmail.com>
    media: em28xx: initialize refcount before kref_get

Jan Kara <jack@suse.cz>
    ext4: make directory inode spreading reflect flexbg size

Vitaly Kuznetsov <vkuznets@redhat.com>
    Drivers: hv: Never allocate anything besides framebuffer from framebuffer memory region

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: fix Oops in dasd_alias_get_start_dev due to missing pavgroup

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: tegra: Use uart_xmit_advance(), fixes icount.tx accounting

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: Create uart_xmit_advance()

Sean Anderson <seanga2@gmail.com>
    net: sunhme: Fix packet reception for len < RX_COPY_THRESHOLD

Adrian Hunter <adrian.hunter@intel.com>
    perf kcore_copy: Do not check /proc/modules is unchanged

Marc Kleine-Budde <mkl@pengutronix.de>
    can: gs_usb: gs_can_open(): fix race dev->can.state condition

Florian Westphal <fw@strlen.de>
    netfilter: ebtables: fix memory leak when blob is malformed

Liang He <windhl@126.com>
    of: mdio: Add of_node_put() when breaking out of for_each_xx

Randy Dunlap <rdunlap@infradead.org>
    MIPS: lantiq: export clk_get_io() for lantiq_wdt.ko

Benjamin Poirier <bpoirier@nvidia.com>
    net: team: Unsync device addresses on ndo_stop

Lu Wei <luwei32@huawei.com>
    ipvlan: Fix out-of-bound bugs caused by unset skb->mac_header

Brett Creeley <brett.creeley@intel.com>
    iavf: Fix cached head and tail value for iavf_get_tx_pending

David Leadbeater <dgl@dgl.cx>
    netfilter: nf_conntrack_irc: Tighten matching on DCC message

Igor Ryzhov <iryzhov@nfware.com>
    netfilter: nf_conntrack_sip: fix ct_sip_walk_headers

Fabio Estevam <festevam@denx.de>
    arm64: dts: rockchip: Remove 'enable-active-low' from rk3399-puma

Chao Yu <chao.yu@oppo.com>
    mm/slub: fix to return errno if kmalloc() fails

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

Siddh Raman Pant <code@siddh.me>
    wifi: mac80211: Fix UAF in ieee80211_scan_rx()

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/sigmatel: Fix unused variable warning for beep power change

Hyunwoo Kim <imv4bel@gmail.com>
    video: fbdev: pxa3xx-gcu: Fix integer overflow in pxa3xx_gcu_write

Youling Tang <tangyouling@loongson.cn>
    mksysmap: Fix the mismatch of 'L0' symbols in System.map

Alexander Sverdlin <alexander.sverdlin@nokia.com>
    MIPS: OCTEON: irq: Fix octeon_irq_force_ciu_mapping()

jerry.meng <jerry-meng@foxmail.com>
    net: usb: qmi_wwan: add Quectel RM520N

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/sigmatel: Keep power up while beep is enabled

Xiaolei Wang <xiaolei.wang@windriver.com>
    regulator: pfuze100: Fix the global-out-of-bounds access in pfuze100_regulator_probe()

Takashi Iwai <tiwai@suse.de>
    ASoC: nau8824: Fix semaphore unbalance at error paths

Stefan Metzmacher <metze@samba.org>
    cifs: don't send down the destination address to sendmsg for a SOCK_STREAM

Ard Biesheuvel <ardb@kernel.org>
    efi: libstub: Disable struct randomization

Sami Tolvanen <samitolvanen@google.com>
    efi/libstub: Disable Shadow Call Stack

Yang Yingliang <yangyingliang@huawei.com>
    parisc: ccio-dma: Add missing iounmap in error path in ccio_probe()

Stuart Menefy <stuart.menefy@mathembedded.com>
    drm/meson: Correct OSD1 global alpha value

Pali Rohár <pali@kernel.org>
    gpio: mpc8xxx: Fix support for IRQ_TYPE_LEVEL_LOW flow_type in mpc85xx

Sergey Shtylyov <s.shtylyov@omp.ru>
    of: fdt: fix off-by-one error in unflatten_dt_nodes()


-------------

Diffstat:

 Makefile                                      |  4 ++--
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi |  1 -
 arch/mips/cavium-octeon/octeon-irq.c          | 10 ++++++++
 arch/mips/lantiq/clk.c                        |  1 +
 drivers/firmware/efi/libstub/Makefile         | 10 ++++++++
 drivers/gpio/gpio-mpc8xxx.c                   |  1 +
 drivers/gpu/drm/meson/meson_plane.c           |  2 +-
 drivers/hv/vmbus_drv.c                        | 10 +++++++-
 drivers/media/usb/em28xx/em28xx-cards.c       |  4 ++--
 drivers/net/can/usb/gs_usb.c                  |  4 ++--
 drivers/net/ethernet/intel/i40evf/i40e_txrx.c |  5 +++-
 drivers/net/ethernet/sun/sunhme.c             |  4 ++--
 drivers/net/ipvlan/ipvlan_core.c              |  6 +++--
 drivers/net/team/team.c                       | 24 ++++++++++++++-----
 drivers/net/usb/qmi_wwan.c                    |  1 +
 drivers/of/fdt.c                              |  2 +-
 drivers/of/of_mdio.c                          |  1 +
 drivers/parisc/ccio-dma.c                     |  1 +
 drivers/regulator/pfuze100-regulator.c        |  2 +-
 drivers/s390/block/dasd_alias.c               |  9 +++++--
 drivers/tty/serial/serial-tegra.c             |  5 ++--
 drivers/usb/core/hub.c                        |  2 +-
 drivers/usb/serial/option.c                   |  6 +++++
 drivers/video/fbdev/pxa3xx-gcu.c              |  2 +-
 fs/cifs/transport.c                           |  4 ++--
 fs/ext4/ialloc.c                              |  2 +-
 include/linux/serial_core.h                   | 17 ++++++++++++++
 mm/slub.c                                     |  5 +++-
 net/bridge/netfilter/ebtables.c               |  4 +++-
 net/mac80211/scan.c                           | 11 +++++----
 net/netfilter/nf_conntrack_irc.c              | 34 ++++++++++++++++++++++-----
 net/netfilter/nf_conntrack_sip.c              |  4 ++--
 scripts/mksysmap                              |  2 +-
 sound/pci/hda/hda_intel.c                     |  2 ++
 sound/pci/hda/patch_hdmi.c                    |  1 +
 sound/pci/hda/patch_sigmatel.c                | 24 +++++++++++++++++++
 sound/soc/codecs/nau8824.c                    | 17 ++++++++------
 tools/perf/util/symbol-elf.c                  |  7 ++----
 38 files changed, 192 insertions(+), 59 deletions(-)


