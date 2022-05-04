Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA8B51A81B
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355567AbiEDRID (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:08:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354699AbiEDRDA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:03:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C493D4D627;
        Wed,  4 May 2022 09:52:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C84F6181D;
        Wed,  4 May 2022 16:52:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9BCBC385A4;
        Wed,  4 May 2022 16:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683152;
        bh=ZEbexuUv4vyhiqFVyE78qtwvVj+vmjanblDPoxQON68=;
        h=From:To:Cc:Subject:Date:From;
        b=YPal6ndBiOoWxCibmsa6wYSCMF6sLWS422Axud8vlAmRvonxOxKn5Ic19Gmns0+ON
         F7htR2bUakhU86Hf4VqAbCBf8+JEfe387bEJDHotY52jOH7dK6OdConkCXrhMbxMzl
         mCqOxRrHY0fwYf5nvyTAX54VamgtDrzcR+ScKtts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.15 000/177] 5.15.38-rc1 review
Date:   Wed,  4 May 2022 18:43:13 +0200
Message-Id: <20220504153053.873100034@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.38-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.38-rc1
X-KernelTest-Deadline: 2022-05-06T15:31+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.15.38 release.
There are 177 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 06 May 2022 15:25:19 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.38-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.38-rc1

Alexey Kardashevskiy <aik@ozlabs.ru>
    powerpc/64: Add UADDR64 relocation support

Peter Zijlstra <peterz@infradead.org>
    objtool: Fix type of reloc::addend

Peter Zijlstra <peterz@infradead.org>
    objtool: Fix code relocs vs weak symbols

Christophe Leroy <christophe.leroy@csgroup.eu>
    eeprom: at25: Use DMA safe buffers

Namhyung Kim <namhyung@kernel.org>
    perf symbol: Remove arch__symbols__fixup_end()

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix software flow control handling

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix incorrect UA handling

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix reset fifo race condition

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix missing tty wakeup in convergence layer type 2

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix wrong signal octets encoding in MSC

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix wrong command frame length field encoding

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix wrong command retry handling

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix missing explicit ldisc flush

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix wrong DLCI release order

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix insufficient txframe size

Florian Westphal <fw@strlen.de>
    netfilter: nft_socket: only do sk lookups when indev is available

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix malformed counter for out of frame data

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix wrong signal octet encoding in convergence layer type 2

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix mux cleanup after unregister tty device

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix decoupled mux resource

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix restart handling via CLD command

Namhyung Kim <namhyung@kernel.org>
    perf symbol: Update symbols__fixup_end()

Namhyung Kim <namhyung@kernel.org>
    perf symbol: Pass is_kallsyms to symbols__fixup_end()

Borislav Petkov <bp@suse.de>
    x86/cpu: Load microcode during restore_processor_state()

Tim Harvey <tharvey@gateworks.com>
    ARM: dts: imx8mm-venice-gw{71xx,72xx,73xx}: fix OTG controller OC mode

Eugen Hristev <eugen.hristev@microchip.com>
    ARM: dts: at91: sama7g5ek: enable pull-up on flexcom3 console lines

Filipe Manana <fdmanana@suse.com>
    btrfs: fix leaked plug after failure syncing log on zoned filesystems

Kees Cook <keescook@chromium.org>
    thermal: int340x: Fix attr.show callback prototype

Ville Syrjälä <ville.syrjala@linux.intel.com>
    ACPI: processor: idle: Avoid falling back to C3 type C-states

Dinh Nguyen <dinguyen@kernel.org>
    net: ethernet: stmmac: fix write to sgmii_adapter_base

Imre Deak <imre.deak@intel.com>
    drm/i915: Fix SEL_FETCH_PLANE_*(PIPE_B+) register addresses

Jouni Högander <jouni.hogander@intel.com>
    drm/i915: Check EDID for HDR static metadata when choosing blc

Martin Willi <martin@strongswan.org>
    netfilter: Update ip6_route_me_harder to consider L3 domain

Md Sadre Alam <quic_mdalam@quicinc.com>
    mtd: rawnand: qcom: fix memory corruption that causes panic

Zqiang <qiang1.zhang@intel.com>
    kasan: prevent cpu_quarantine corruption when CPU offline and cache shrink occur at same time

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    zonefs: Clear inode information flags on inode creation

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    zonefs: Fix management of open zones

Ville Syrjälä <ville.syrjala@linux.intel.com>
    Revert "ACPI: processor: idle: fix lockup regression on 32-bit ThinkPad T40"

Sidhartha Kumar <sidhartha.kumar@oracle.com>
    selftest/vm: verify remap destination address in mremap_test

Sidhartha Kumar <sidhartha.kumar@oracle.com>
    selftest/vm: verify mmap addr in mremap_test

Alexey Kardashevskiy <aik@ozlabs.ru>
    powerpc/perf: Fix 32bit compile

Duoming Zhou <duoming@zju.edu.cn>
    drivers: net: hippi: Fix deadlock in rr_close()

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: destage any unwritten data to the server before calling copychunk_write

Mikulas Patocka <mpatocka@redhat.com>
    x86: __memcpy_flushcache: fix wrong alignment if size > 2^32

suresh kumar <suresh2514@gmail.com>
    bonding: do not discard lowest hash bit for non layer3+4 hashing

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: set fixed sector size to FS_SECTOR_SIZE_INFORMATION

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: increment reference count of parent fp

Duoming Zhou <duoming@zju.edu.cn>
    arch: xtensa: platforms: Fix deadlock in rs_close()

Ye Bin <yebin10@huawei.com>
    ext4: fix bug_on in start_this_handle during umount filesystem

Zheyu Ma <zheyuma97@gmail.com>
    ASoC: wm8731: Disable the regulator when probing fails

Chao Song <chao.song@linux.intel.com>
    ASoC: Intel: soc-acpi: correct device endpoints for max98373

Pengcheng Yang <yangpc@wangsu.com>
    tcp: fix F-RTO may not work correctly when receiving DSACK

Dany Madden <drt@linux.ibm.com>
    Revert "ibmvnic: Add ethtool private flag for driver-defined queue limits"

Leon Romanovsky <leon@kernel.org>
    ixgbe: ensure IPsec VF<->PF compatibility

Timothy Hayes <timothy.hayes@arm.com>
    perf arm-spe: Fix addresses of synthesized SPE events

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: No short reads or writes upon glock contention

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Make sure not to return short direct writes

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Minor retry logic cleanup

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Prevent endless loops in gfs2_file_buffered_write

Yang Yingliang <yangyingliang@huawei.com>
    net: fec: add missing of_node_put() in fec_enet_init_stop_mode()

Manish Chopra <manishc@marvell.com>
    bnx2x: fix napi API usage sequence

Maxim Mikityanskiy <maximmi@nvidia.com>
    tls: Skip tls_append_frag on zero copy size

Miaoqian Lin <linmq006@gmail.com>
    drm/amd/display: Fix memory leak in dcn21_clock_source_create

David Yat Sin <david.yatsin@amd.com>
    drm/amdkfd: Fix GWS queue count

Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
    netfilter: conntrack: fix udp offload timeout sysctl

Jens Axboe <axboe@kernel.dk>
    io_uring: check reserved fields for recv/recvmsg

Jens Axboe <axboe@kernel.dk>
    io_uring: check reserved fields for send/sendmsg

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    net: dsa: lantiq_gswip: Don't set GSWIP_MII_CFG_RMII_CLK

Samuel Holland <samuel@sholland.org>
    drm/sun4i: Remove obsolete references to PHYS_OFFSET

Nathan Rossi <nathan@nathanrossi.com>
    net: dsa: mv88e6xxx: Fix port_hidden_wait to account for port_base_addr

Baruch Siach <baruch.siach@siklu.com>
    net: phy: marvell10g: fix return value on error

Jonathan Lemon <jonathan.lemon@gmail.com>
    net: bcmgenet: hide status block before TX timestamping

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    cpufreq: qcom-cpufreq-hw: Clear dcvs interrupts

Yang Yingliang <yangyingliang@huawei.com>
    clk: sunxi: sun9i-mmc: check return value after calling platform_get_resource()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    bus: sunxi-rsb: Fix the return value of sunxi_rsb_device_create()

Eric Dumazet <edumazet@google.com>
    tcp: make sure treq->af_specific is initialized

Eric Dumazet <edumazet@google.com>
    tcp: fix potential xmit stalls caused by TCP_NOTSENT_LOWAT

Peilin Ye <peilin.ye@bytedance.com>
    ip_gre, ip6_gre: Fix race condition on o_seqno in collect_md mode

Peilin Ye <peilin.ye@bytedance.com>
    ip6_gre: Make o_seqno start from 0 in native mode

Peilin Ye <peilin.ye@bytedance.com>
    ip_gre: Make o_seqno start from 0 in native mode

liuyacan <liuyacan@corp.netease.com>
    net/smc: sync err code when tcp connection was refused

Jian Shen <shenjian15@huawei.com>
    net: hns3: add return value for mailbox handling in PF

Jian Shen <shenjian15@huawei.com>
    net: hns3: add validity check for message data length

Jie Wang <wangjie125@huawei.com>
    net: hns3: modify the return code of hclge_get_ring_chain_from_mbx

Jian Shen <shenjian15@huawei.com>
    net: hns3: clear inited state and stop client after failed to register netdev

Xiaobing Luo <luoxiaobing0926@gmail.com>
    cpufreq: fix memory leak in sun50i_cpufreq_nvmem_probe

Lv Ruyi <lv.ruyi@zte.com.cn>
    pinctrl: pistachio: fix use of irq_of_parse_and_map()

Fabio Estevam <festevam@denx.de>
    arm64: dts: imx8mn-ddr4-evk: Describe the 32.768 kHz PMIC clock

Max Krummenacher <max.krummenacher@toradex.com>
    ARM: dts: imx6ull-colibri: fix vqmmc regulator

Xin Long <lucien.xin@gmail.com>
    sctp: check asoc strreset_chunk in sctp_generate_reconf_event

Nikolay Aleksandrov <razor@blackwall.org>
    wireguard: device: check for metadata_dst with skb_valid_dst()

Pengcheng Yang <yangpc@wangsu.com>
    tcp: ensure to use the most recently sent skb when filling the rate sample

Marek Vasut <marex@denx.de>
    pinctrl: stm32: Keep pinctrl block clock enabled when LEVEL IRQ requested

Francesco Ruggeri <fruggeri@arista.com>
    tcp: md5: incorrect tcp_header_len for incoming connections

Luca Ceresoli <luca.ceresoli@bootlin.com>
    pinctrl: rockchip: fix RK3308 pinmux bits

Eyal Birger <eyal.birger@gmail.com>
    bpf, lwt: Fix crash when using bpf_skb_set_tunnel_key() from bpf_xmit lwt hook

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_set_rbtree: overlap detection with element re-addition after deletion

Miaoqian Lin <linmq006@gmail.com>
    net: dsa: Add missing of_node_put() in dsa_port_link_register_of

Geert Uytterhoeven <geert+renesas@glider.be>
    memory: renesas-rpc-if: Fix HF/OSPI data transfer in Manual Mode

Marek Vasut <marex@denx.de>
    pinctrl: stm32: Do not call stm32_gpio_get() for edge triggered IRQs in EOI

Oleksandr Ocheretnyi <oocheret@cisco.com>
    mtd: fix 'part' field data corruption in mtd_info

Miaoqian Lin <linmq006@gmail.com>
    mtd: rawnand: Fix return value check of wait_for_completion_timeout

YueHaibing <yuehaibing@huawei.com>
    pinctrl: mediatek: moore: Fix build error

Heiner Kallweit <hkallweit1@gmail.com>
    phy: amlogic: fix error path in phy_g12a_usb3_pcie_probe()

Pengcheng Yang <yangpc@wangsu.com>
    ipvs: correctly print the memory size of ip_vs_conn_tab

Adam Ford <aford173@gmail.com>
    ARM: dts: logicpd-som-lv: Fix wrong pinmuxing on OMAP35

Adam Ford <aford173@gmail.com>
    ARM: dts: am3517-evm: Fix misc pinmuxing

H. Nikolaus Schaller <hns@goldelico.com>
    ARM: dts: Fix mmc order for omap3-gta04

Stephen Boyd <swboyd@chromium.org>
    interconnect: qcom: sdx55: Drop IP0 interconnects

Miaoqian Lin <linmq006@gmail.com>
    phy: ti: Add missing pm_runtime_disable() in serdes_am654_probe

Miaoqian Lin <linmq006@gmail.com>
    phy: mapphone-mdm6600: Fix PM error handling in phy_mdm6600_probe

Claudiu Beznea <claudiu.beznea@microchip.com>
    ARM: dts: at91: fix pinctrl phandles

Claudiu Beznea <claudiu.beznea@microchip.com>
    ARM: dts: at91: sama5d4_xplained: fix pinctrl phandle name

Mark Brown <broonie@kernel.org>
    ARM: dts: at91: Map MCLK for wm8731 on at91sam9g20ek

Miaoqian Lin <linmq006@gmail.com>
    phy: ti: omap-usb2: Fix error handling in omap_usb2_enable_clocks

Tony Lindgren <tony@atomide.com>
    ARM: dts: dra7: Fix suspend warning for vpe powerdomain

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Make omap3 gpt12 quirk handling SoC specific

Miaoqian Lin <linmq006@gmail.com>
    ARM: OMAP2+: Fix refcount leak in omap_gic_of_init

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    phy: samsung: exynos5250-sata: fix missing device put in probe error paths

Miaoqian Lin <linmq006@gmail.com>
    phy: samsung: Fix missing of_node_put() in exynos_sata_phy_probe

Guillaume Giraudon <ggiraudon@prism19.com>
    arm64: dts: meson-sm1-bananapi-m5: fix wrong GPIO pin labeling for CON1

Marek Vasut <marex@denx.de>
    arm64: dts: imx8mn: Fix SAI nodes

Fabio Estevam <festevam@gmail.com>
    ARM: dts: imx6qdl-apalis: Fix sgtl5000 detection issue

Weitao Wang <WeitaoWang-oc@zhaoxin.com>
    USB: Fix xhci event ring dequeue pointer ERDP update issue

Liu Ying <victor.liu@nxp.com>
    arm64: dts: imx8qm: Correct SCU clock controller's compatible property

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    xsk: Fix l2fwd for copy mode + busy poll combo

Chuanhong Guo <gch981213@gmail.com>
    mtd: rawnand: fix ecc parameters for mt7622

Tong Zhang <ztong0001@gmail.com>
    iio:imu:bmi160: disable regulator in error path

Christian Hewitt <christianshewitt@gmail.com>
    arm64: dts: meson: remove CPU opps below 1GHz for SM1 boards

Christian Hewitt <christianshewitt@gmail.com>
    arm64: dts: meson: remove CPU opps below 1GHz for G12B boards

Pavel Skripkin <paskripkin@gmail.com>
    video: fbdev: udlfb: properly check endpoint type

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    cpufreq: qcom-cpufreq-hw: Fix throttle frequency value on EPSS platforms

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    cpufreq: qcom-hw: fix the race between LMH worker and cpuhp

Nikolay Aleksandrov <razor@blackwall.org>
    virtio_net: fix wrong buf address calculation when using xdp

Tejun Heo <tj@kernel.org>
    iocost: don't reset the inuse weight of under-weighted debtors

Thomas Gleixner <tglx@linutronix.de>
    x86/pci/xen: Disable PCI/MSI[-X] masking for XEN_HVM guests

Guo Ren <guoren@linux.alibaba.com>
    riscv: patch_text: Fixup last cpu should be master

Mikulas Patocka <mpatocka@redhat.com>
    hex2bin: fix access beyond string end

Mikulas Patocka <mpatocka@redhat.com>
    hex2bin: make the function hex_to_bin constant-time

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    pinctrl: samsung: fix missing GPIOLIB on ARM64 Exynos config

Johan Hovold <johan@kernel.org>
    arm64: dts: imx8mm-venice: fix spi2 pin configuration

Manivannan Sadhasivam <mani@kernel.org>
    bus: mhi: host: pci_generic: Flush recovery worker during freeze

Manivannan Sadhasivam <mani@kernel.org>
    bus: mhi: host: pci_generic: Add missing poweroff() PM callback

Xiubo Li <xiubli@redhat.com>
    ceph: fix possible NULL pointer dereference for req->r_session

Wang Qing <wangqing@vivo.com>
    arch_topology: Do not set llc_sibling if llc_id is invalid

Maciej W. Rozycki <macro@orcam.me.uk>
    serial: 8250: Correct the clock for EndRun PTP/1588 PCIe device

Maciej W. Rozycki <macro@orcam.me.uk>
    serial: 8250: Also set sticky MCR bits in console restoration

Lino Sanfilippo <LinoSanfilippo@gmx.de>
    serial: amba-pl011: do not time out prematurely when draining tx fifo

Johan Hovold <johan@kernel.org>
    serial: imx: fix overrun interrupts in DMA mode

Sean Anderson <sean.anderson@seco.com>
    usb: phy: generic: Get the vbus supply

Pawel Laszczak <pawell@cadence.com>
    usb: cdns3: Fix issue for clear halt endpoint

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: dwc3: pci: add support for the Intel Meteor Lake-P

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Return proper request status

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: core: Only handle soft-reset in DCTL

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: core: Fix tx/rx threshold settings

Sven Peter <sven@svenpeter.dev>
    usb: dwc3: Try usb-role-switch first in dwc3_drd_init

Vijayavardhan Vennapusa <vvreddy@codeaurora.org>
    usb: gadget: configfs: clear deactivation flag in configfs_composite_unbind()

Dan Vacura <w36195@motorola.com>
    usb: gadget: uvc: Fix crash when encoding data for usb request

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: typec: ucsi: Fix role swapping

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: typec: ucsi: Fix reuse of completion structure

Tasos Sahanidis <tasos@tasossah.com>
    usb: core: Don't hold the device lock while sleeping in do_proc_control()

Hangyu Hua <hbh25y@gmail.com>
    usb: misc: fix improper handling of refcount in uss720_probe()

Fawzi Khaber <fawzi.khaber@tdk.com>
    iio: imu: inv_icm42600: Fix I2C init possible nack

Zheyu Ma <zheyuma97@gmail.com>
    iio: magnetometer: ak8975: Fix the error handling in ak8975_power_on()

Michael Hennerich <michael.hennerich@analog.com>
    iio: dac: ad5446: Fix read_raw not returning set value

Zizhuang Deng <sunsetdzz@gmail.com>
    iio: dac: ad5592r: Fix the missing return value.

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: increase usb U3 -> U0 link resume timeout from 100ms to 500ms

Henry Lin <henryl@nvidia.com>
    xhci: stop polling roothubs after shutdown

Evan Green <evgreen@chromium.org>
    xhci: Enable runtime PM on second Alderlake controller

zhangqilong <zhangqilong3@huawei.com>
    usb: xhci: tegra:Fix PM usage reference leak of tegra_xusb_unpowergate_partitions

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add Telit 0x1057, 0x1058, 0x1075 compositions

Slark Xiao <slark_xiao@163.com>
    USB: serial: option: add support for Cinterion MV32-WA/MV32-WB

Bruno Thomsen <bruno.thomsen@gmail.com>
    USB: serial: cp210x: add PIDs for Kamstrup USB Meter Reader

Kees Cook <keescook@chromium.org>
    USB: serial: whiteheat: fix heap overflow in WHITEHEAT_GET_DTR_RTS

Oliver Neukum <oneukum@suse.com>
    USB: quirks: add STRING quirk for VCOM device

Oliver Neukum <oneukum@suse.com>
    USB: quirks: add a Realtek card reader

Macpaul Lin <macpaul.lin@mediatek.com>
    usb: mtu3: fix USB 3.0 dual-role-switch from device to host


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/am3517-evm.dts                   |  45 ++++-
 arch/arm/boot/dts/am3517-som.dtsi                  |   9 +
 arch/arm/boot/dts/at91-sama5d3_xplained.dts        |   8 +-
 arch/arm/boot/dts/at91-sama5d4_xplained.dts        |   6 +-
 arch/arm/boot/dts/at91-sama7g5ek.dts               |   2 +-
 arch/arm/boot/dts/at91sam9g20ek_common.dtsi        |   6 +
 arch/arm/boot/dts/dra7-l4.dtsi                     |   4 +-
 arch/arm/boot/dts/imx6qdl-apalis.dtsi              |  10 +-
 arch/arm/boot/dts/imx6ull-colibri.dtsi             |   2 +-
 arch/arm/boot/dts/logicpd-som-lv-35xx-devkit.dts   |  15 ++
 arch/arm/boot/dts/logicpd-som-lv-37xx-devkit.dts   |  15 ++
 arch/arm/boot/dts/logicpd-som-lv.dtsi              |  15 --
 arch/arm/boot/dts/omap3-gta04.dtsi                 |   2 +
 arch/arm/mach-exynos/Kconfig                       |   1 -
 arch/arm/mach-omap2/omap4-common.c                 |   2 +
 arch/arm64/boot/dts/amlogic/meson-g12b-a311d.dtsi  |  40 ----
 arch/arm64/boot/dts/amlogic/meson-g12b-s922x.dtsi  |  40 ----
 .../boot/dts/amlogic/meson-sm1-bananapi-m5.dts     |   1 +
 arch/arm64/boot/dts/amlogic/meson-sm1.dtsi         |  20 --
 .../boot/dts/freescale/imx8mm-venice-gw71xx.dtsi   |   4 +-
 .../boot/dts/freescale/imx8mm-venice-gw72xx.dtsi   |   4 +-
 .../boot/dts/freescale/imx8mm-venice-gw73xx.dtsi   |   4 +-
 arch/arm64/boot/dts/freescale/imx8mn-ddr4-evk.dts  |   4 +
 arch/arm64/boot/dts/freescale/imx8mn.dtsi          |  10 +-
 arch/arm64/boot/dts/freescale/imx8qm.dtsi          |   2 +-
 arch/powerpc/kernel/reloc_64.S                     |  67 +++++--
 arch/powerpc/kernel/vmlinux.lds.S                  |   2 -
 arch/powerpc/perf/Makefile                         |   4 +-
 arch/powerpc/tools/relocs_check.sh                 |   7 +-
 arch/riscv/kernel/patch.c                          |   2 +-
 arch/x86/include/asm/microcode.h                   |   2 +
 arch/x86/kernel/cpu/microcode/core.c               |   6 +-
 arch/x86/lib/usercopy_64.c                         |   2 +-
 arch/x86/pci/xen.c                                 |   6 +-
 arch/x86/power/cpu.c                               |  10 +-
 arch/xtensa/platforms/iss/console.c                |   8 -
 block/blk-iocost.c                                 |  12 +-
 drivers/acpi/processor_idle.c                      |   8 +-
 drivers/base/arch_topology.c                       |   2 +-
 drivers/bus/mhi/pci_generic.c                      |   2 +
 drivers/bus/sunxi-rsb.c                            |   2 +
 drivers/bus/ti-sysc.c                              |  16 +-
 drivers/clk/sunxi/clk-sun9i-mmc.c                  |   2 +
 drivers/cpufreq/qcom-cpufreq-hw.c                  |  27 ++-
 drivers/cpufreq/sun50i-cpufreq-nvmem.c             |   4 +-
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |  83 ++++----
 .../gpu/drm/amd/display/dc/dcn21/dcn21_resource.c  |   1 +
 .../gpu/drm/i915/display/intel_dp_aux_backlight.c  |  34 +++-
 drivers/gpu/drm/i915/i915_reg.h                    |   2 +-
 drivers/gpu/drm/sun4i/sun4i_frontend.c             |   3 -
 drivers/iio/dac/ad5446.c                           |   2 +-
 drivers/iio/dac/ad5592r-base.c                     |   2 +-
 drivers/iio/imu/bmi160/bmi160_core.c               |  20 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600_i2c.c    |  15 +-
 drivers/iio/magnetometer/ak8975.c                  |   1 +
 drivers/interconnect/qcom/sdx55.c                  |  21 ---
 drivers/memory/renesas-rpc-if.c                    |  60 ++++--
 drivers/misc/eeprom/at25.c                         |  19 +-
 drivers/mtd/nand/raw/mtk_ecc.c                     |  12 +-
 drivers/mtd/nand/raw/qcom_nandc.c                  |  24 +--
 drivers/mtd/nand/raw/sh_flctl.c                    |  14 +-
 drivers/net/bonding/bond_main.c                    |  13 +-
 drivers/net/dsa/lantiq_gswip.c                     |   3 -
 drivers/net/dsa/mv88e6xxx/port_hidden.c            |   5 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |   9 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |   7 +
 drivers/net/ethernet/freescale/fec_main.c          |   2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   9 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |  31 +--
 drivers/net/ethernet/ibm/ibmvnic.c                 | 129 ++++---------
 drivers/net/ethernet/ibm/ibmvnic.h                 |   6 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c     |   3 +-
 .../net/ethernet/stmicro/stmmac/dwmac-socfpga.c    |  12 +-
 drivers/net/hippi/rrunner.c                        |   2 +
 drivers/net/phy/marvell10g.c                       |   2 +-
 drivers/net/virtio_net.c                           |  20 +-
 drivers/net/wireguard/device.c                     |   3 +-
 drivers/phy/amlogic/phy-meson-g12a-usb3-pcie.c     |  20 +-
 drivers/phy/motorola/phy-mapphone-mdm6600.c        |   3 +-
 drivers/phy/samsung/phy-exynos5250-sata.c          |  21 ++-
 drivers/phy/ti/phy-am654-serdes.c                  |   2 +-
 drivers/phy/ti/phy-omap-usb2.c                     |   2 +-
 drivers/pinctrl/mediatek/Kconfig                   |   1 +
 drivers/pinctrl/pinctrl-pistachio.c                |   6 +-
 drivers/pinctrl/pinctrl-rockchip.c                 |  45 +++--
 drivers/pinctrl/samsung/Kconfig                    |  11 +-
 drivers/pinctrl/stm32/pinctrl-stm32.c              |  23 ++-
 .../intel/int340x_thermal/int3400_thermal.c        |   4 +-
 drivers/tty/n_gsm.c                                | 209 +++++++++++----------
 drivers/tty/serial/8250/8250_pci.c                 |   8 +-
 drivers/tty/serial/8250/8250_port.c                |   2 +-
 drivers/tty/serial/amba-pl011.c                    |   9 +-
 drivers/tty/serial/imx.c                           |   2 +-
 drivers/usb/cdns3/cdns3-gadget.c                   |   7 +-
 drivers/usb/core/devio.c                           |  14 +-
 drivers/usb/core/quirks.c                          |   6 +
 drivers/usb/dwc3/core.c                            |  11 +-
 drivers/usb/dwc3/drd.c                             |  11 +-
 drivers/usb/dwc3/dwc3-pci.c                        |   8 +
 drivers/usb/dwc3/gadget.c                          |  31 ++-
 drivers/usb/gadget/configfs.c                      |   2 +
 drivers/usb/gadget/function/uvc_queue.c            |   2 +
 drivers/usb/host/xhci-hub.c                        |   2 +-
 drivers/usb/host/xhci-pci.c                        |   4 +-
 drivers/usb/host/xhci-ring.c                       |   1 +
 drivers/usb/host/xhci-tegra.c                      |   4 +-
 drivers/usb/host/xhci.c                            |  11 ++
 drivers/usb/misc/uss720.c                          |   3 +-
 drivers/usb/mtu3/mtu3_dr.c                         |   6 +-
 drivers/usb/phy/phy-generic.c                      |   7 +
 drivers/usb/serial/cp210x.c                        |   2 +
 drivers/usb/serial/option.c                        |  12 ++
 drivers/usb/serial/whiteheat.c                     |   5 +-
 drivers/usb/typec/ucsi/ucsi.c                      |  24 ++-
 drivers/video/fbdev/udlfb.c                        |  14 +-
 fs/btrfs/tree-log.c                                |   1 +
 fs/ceph/caps.c                                     |   4 +
 fs/cifs/smb2ops.c                                  |   8 +
 fs/ext4/super.c                                    |  19 +-
 fs/gfs2/file.c                                     |  33 ++--
 fs/io_uring.c                                      |   4 +
 fs/ksmbd/smb2pdu.c                                 |  13 +-
 fs/ksmbd/vfs_cache.c                               |   1 +
 fs/zonefs/super.c                                  |  46 ++++-
 include/linux/kernel.h                             |   2 +-
 include/linux/mtd/mtd.h                            |   6 +-
 include/memory/renesas-rpc-if.h                    |   1 +
 include/net/ip6_tunnel.h                           |   2 +-
 include/net/ip_tunnels.h                           |   2 +-
 include/net/tcp.h                                  |   8 +
 lib/hexdump.c                                      |  41 +++-
 mm/kasan/quarantine.c                              |   7 +
 net/core/lwt_bpf.c                                 |   7 +-
 net/dsa/port.c                                     |   2 +
 net/ipv4/ip_gre.c                                  |  12 +-
 net/ipv4/syncookies.c                              |   8 +-
 net/ipv4/tcp_input.c                               |  15 +-
 net/ipv4/tcp_minisocks.c                           |   2 +-
 net/ipv4/tcp_output.c                              |   1 +
 net/ipv4/tcp_rate.c                                |  11 +-
 net/ipv6/ip6_gre.c                                 |  16 +-
 net/ipv6/netfilter.c                               |  10 +-
 net/ipv6/syncookies.c                              |   3 +-
 net/netfilter/ipvs/ip_vs_conn.c                    |   2 +-
 net/netfilter/nf_conntrack_standalone.c            |   2 +-
 net/netfilter/nft_set_rbtree.c                     |   6 +-
 net/netfilter/nft_socket.c                         |  52 +++--
 net/sctp/sm_sideeffect.c                           |   4 +
 net/smc/af_smc.c                                   |   2 +
 net/tls/tls_device.c                               |  12 +-
 net/xdp/xsk.c                                      |   2 +-
 sound/soc/codecs/wm8731.c                          |  19 +-
 sound/soc/intel/common/soc-acpi-intel-tgl-match.c  |   4 +-
 tools/objtool/check.c                              |   8 +-
 tools/objtool/elf.c                                | 189 ++++++++++++++++---
 tools/objtool/include/objtool/elf.h                |   4 +-
 tools/perf/arch/arm64/util/Build                   |   1 -
 tools/perf/arch/arm64/util/machine.c               |  28 ---
 tools/perf/arch/powerpc/util/Build                 |   1 -
 tools/perf/arch/powerpc/util/machine.c             |  25 ---
 tools/perf/arch/s390/util/machine.c                |  16 --
 tools/perf/util/arm-spe.c                          |   3 +-
 tools/perf/util/symbol-elf.c                       |   2 +-
 tools/perf/util/symbol.c                           |  37 +++-
 tools/perf/util/symbol.h                           |   3 +-
 tools/testing/selftests/vm/mremap_test.c           |  83 +++++++-
 167 files changed, 1477 insertions(+), 903 deletions(-)


