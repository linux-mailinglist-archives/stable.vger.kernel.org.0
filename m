Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66BC3657807
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:46:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232848AbiL1Opw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:45:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233007AbiL1OpV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:45:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8176D12091;
        Wed, 28 Dec 2022 06:45:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC2706153E;
        Wed, 28 Dec 2022 14:45:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A57C433EF;
        Wed, 28 Dec 2022 14:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672238701;
        bh=+Nifc7UA8WtJWOh34jnp8WBelYqsKZO8+dH7CYqJuhs=;
        h=From:To:Cc:Subject:Date:From;
        b=opzmQtSCunYSaeWuTfAf4ut0S04eRcQAw4snOGVErQOiZJSGP+w8ltGgiaUIUGk4f
         8A2dzxJ/nUnt5FIjJ6ZS7FMwha0h0IOhTDL0YxhwtwYns1koEQi/vSlDBE/y74ioLq
         ZAj4oR3Ow9fU7aEAdJSYZNsQ/ax2UkdGoZ/Cg4CA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 6.1 0000/1146] 6.1.2-rc1 review
Date:   Wed, 28 Dec 2022 15:25:39 +0100
Message-Id: <20221228144330.180012208@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.2-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.2-rc1
X-KernelTest-Deadline: 2022-12-30T14:44+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 6.1.2 release.
There are 1146 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 30 Dec 2022 14:41:29 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.2-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.2-rc1

Martin Leung <Martin.Leung@amd.com>
    drm/amd/display: revert Disable DRR actions during state commit

Lin Ma <linma@zju.edu.cn>
    media: dvbdev: fix refcnt bug

Lin Ma <linma@zju.edu.cn>
    media: dvbdev: fix build warning due to comments

Gaosheng Cui <cuigaosheng1@huawei.com>
    net: stmmac: fix errno when create_singlethread_workqueue() fails

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: remove iopoll spinlock

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: protect cq_timeouts with timeout_lock

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/net: fix cleanup after recycle

Jens Axboe <axboe@kernel.dk>
    io_uring/net: ensure compat import handlers clear free_iov

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: improve io_double_lock_ctx fail handling

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: dont remove file from msg_ring reqs

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: add completion locking for iopoll

Stefan Metzmacher <metze@samba.org>
    io_uring/net: introduce IORING_SEND_ZC_REPORT_USAGE flag

Tejun Heo <tj@kernel.org>
    blk-iolatency: Fix memory leak on add_disk() failures

Arun Easi <aeasi@marvell.com>
    scsi: qla2xxx: Fix crash when I/O abort times out

David Hildenbrand <david@redhat.com>
    mm/gup: disallow FOLL_FORCE|FOLL_WRITE on hugetlb mappings

Filipe Manana <fdmanana@suse.com>
    btrfs: do not BUG_ON() on ENOMEM when dropping extent items for a range

Chen Zhongjin <chenzhongjin@huawei.com>
    ovl: fix use inode directly in rcu-walk mode

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    fbdev: fbcon: release buffer when fbcon_do_set_font() failed

Liam Howlett <liam.howlett@oracle.com>
    maple_tree: fix mas_spanning_rebalance() on insufficient data

Liam Howlett <liam.howlett@oracle.com>
    test_maple_tree: add test for mas_spanning_rebalance() on insufficient data

Rickard x Andersson <rickaran@axis.com>
    gcov: add support for checksum field

Yuan Can <yuancan@huawei.com>
    floppy: Fix memory leak in do_floppy_init()

Christophe Leroy <christophe.leroy@csgroup.eu>
    spi: fsl_spi: Don't change speed while chipselect is active

Johan Hovold <johan+linaro@kernel.org>
    regulator: core: fix deadlock on regulator enable

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    iio: addac: ad74413r: fix integer promotion bug in ad74413_get_input_current_offset()

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    iio: adc128s052: add proper .data members in adc128_of_match table

Nuno Sá <nuno.sa@analog.com>
    iio: adc: ad_sigma_delta: do not use internal iio_dev lock

Zeng Heng <zengheng4@huawei.com>
    iio: fix memory leak in iio_device_register_eventset()

Roberto Sassu <roberto.sassu@huawei.com>
    reiserfs: Add missing calls to reiserfs_security_free()

Nathan Chancellor <nathan@kernel.org>
    security: Restrict CONFIG_ZERO_CALL_USED_REGS to gcc or clang > 15.0.6

Schspa Shi <schspa@gmail.com>
    9p: set req refcount to zero to avoid uninitialized usage

Isaac J. Manjarres <isaacmanjarres@google.com>
    loop: Fix the max_loop commandline argument treatment when it is set to 0

Enrik Berkhan <Enrik.Berkhan@inka.de>
    HID: mcp2221: don't connect hidraw

Jason Gerecke <killertofu@gmail.com>
    HID: wacom: Ensure bootloader PID is usable in hidraw mode

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Prevent infinite loop in transaction errors recovery for streams

Miaoqian Lin <linmq006@gmail.com>
    usb: dwc3: qcom: Fix memory leak in dwc3_qcom_interconnect_init

Ferry Toth <ftoth@exalondelft.nl>
    usb: dwc3: core: defer probe on ulpi_read_id timeout

Sven Peter <sven@svenpeter.dev>
    usb: dwc3: Fix race between dwc3_set_mode and __dwc3_set_mode

Li Jun <jun.li@nxp.com>
    clk: imx: imx8mp: add shared clk gate for usb suspend clk

Li Jun <jun.li@nxp.com>
    dt-bindings: clocks: imx8mp: Add ID for usb suspend clock

Johan Hovold <johan+linaro@kernel.org>
    arm64: dts: qcom: sm8250: fix USB-DP PHY registers

Johan Hovold <johan+linaro@kernel.org>
    arm64: dts: qcom: sm6350: fix USB-DP PHY registers

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: xhci-mtk: fix leakage of shared hcd when fail to set wakeup irq

Pawel Laszczak <pawell@cadence.com>
    usb: cdnsp: fix lack of ZLP for ep0

Bastien Nocera <hadess@hadess.net>
    HID: logitech-hidpp: Guard FF init code against non-USB devices

Jiao Zhou <jiaozhou@google.com>
    ALSA: hda/hdmi: Add HP Device 0x8711 to force connect list

Edward Pacman <edward@edward-p.xyz>
    ALSA: hda/realtek: Add quirk for Lenovo TianYi510Pro-14IOB

wangdicheng <wangdicheng@kylinos.cn>
    ALSA: usb-audio: add the quirk for KT0206 device

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Workaround for XRUN at prepare

Jeff LaBundy <jeff@labundy.com>
    dt-bindings: input: iqs7222: Add support for IQS7222A v1.13+

Jeff LaBundy <jeff@labundy.com>
    dt-bindings: input: iqs7222: Correct minimum slider size

Jeff LaBundy <jeff@labundy.com>
    dt-bindings: input: iqs7222: Reduce 'linux,code' to optional

Jeff LaBundy <jeff@labundy.com>
    Input: iqs7222 - add support for IQS7222A v1.13+

Jeff LaBundy <jeff@labundy.com>
    Input: iqs7222 - report malformed properties

Jeff LaBundy <jeff@labundy.com>
    Input: iqs7222 - drop unused device node references

GUO Zihua <guozihua@huawei.com>
    ima: Simplify ima_lsm_copy_rule

John Stultz <jstultz@google.com>
    pstore: Make sure CONFIG_PSTORE_PMSG selects CONFIG_RT_MUTEXES

Sami Tolvanen <samitolvanen@google.com>
    cfi: Fix CFI failure with KASAN

David Howells <dhowells@redhat.com>
    afs: Fix lost servers_outstanding count

Michael Petlan <mpetlan@redhat.com>
    perf test: Fix "all PMU test" to skip parametrized events

Sergio Paracuellos <sergio.paracuellos@gmail.com>
    MIPS: ralink: mt7621: avoid to init common ralink reset controller

Yang Jihong <yangjihong1@huawei.com>
    perf probe: Check -v and -q options in the right place

James Clark <james.clark@arm.com>
    perf tools: Make quiet mode consistent between tools

Yang Jihong <yangjihong1@huawei.com>
    perf debug: Set debug_peo_args and redirect_to_stderr variable to correct values in perf_quiet_option()

Arnd Bergmann <arnd@arndb.de>
    drm/amd/pm: avoid large variable on kernel stack

John Stultz <jstultz@google.com>
    pstore: Switch pmsg_lock to an rt_mutex to avoid priority inversion

Kristina Martsenko <kristina.martsenko@arm.com>
    lkdtm: cfi: Make PAC test work with GCC 7 and 8

Kees Cook <keescook@chromium.org>
    LoadPin: Ignore the "contents" argument of the LSM hooks

Khaled Almahallawy <khaled.almahallawy@intel.com>
    drm/i915/display: Don't disable DDI/Transcoder when setting phy test pattern

Hans de Goede <hdegoede@redhat.com>
    ASoC: rt5670: Remove unbalanced pm_runtime_put()

Wang Jingjin <wangjingjin1@huawei.com>
    ASoC: rockchip: spdif: Add missing clk_disable_unprepare() in rk_spdif_runtime_resume()

Marek Szyprowski <m.szyprowski@samsung.com>
    ASoC: wm8994: Fix potential deadlock

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ALSA: hda/hdmi: fix stream-id config keep-alive for rt suspend

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ALSA: hda/hdmi: set default audio parameters for KAE silent-stream

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ALSA: hda/hdmi: fix i915 silent stream programming flow

Wang Yufen <wangyufen@huawei.com>
    ASoC: mediatek: mt8183: fix refcount leak in mt8183_mt6358_ts3a227_max98357_dev_probe()

Wang Jingjin <wangjingjin1@huawei.com>
    ASoC: rockchip: pdm: Add missing clk_disable_unprepare() in rockchip_pdm_runtime_resume()

Wang Yufen <wangyufen@huawei.com>
    ASoC: audio-graph-card: fix refcount leak of cpu_ep in __graph_for_each_link()

Wang Yufen <wangyufen@huawei.com>
    ASoC: mediatek: mt8173-rt5650-rt5514: fix refcount leak in mt8173_rt5650_rt5514_dev_probe()

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: Skylake: Fix driver hang during shutdown

Yang Yingliang <yangyingliang@huawei.com>
    ASoC: sof_es8336: fix possible use-after-free in sof_es8336_remove()

Yang Yingliang <yangyingliang@huawei.com>
    hwmon: (jc42) Fix missing unlock on error in jc42_write()

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    orangefs: Fix kmemleak in orangefs_{kernel,client}_debug_init()

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    orangefs: Fix kmemleak in orangefs_sysfs_init()

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    orangefs: Fix kmemleak in orangefs_prepare_debugfs_help_string()

Maurizio Lombardi <mlombard@redhat.com>
    scsi: target: iscsi: Fix a race condition between login_work and the login thread

Nathan Chancellor <nathan@kernel.org>
    drm/sti: Fix return type of sti_{dvo,hda,hdmi}_connector_mode_valid()

Nathan Chancellor <nathan@kernel.org>
    drm/fsl-dcu: Fix return type of fsl_dcu_drm_connector_mode_valid()

Kumar Meiyappan <Kumar.Meiyappan@microchip.com>
    scsi: smartpqi: Correct device removal for multi-actuator devices

Mike McGowen <mike.mcgowen@microchip.com>
    scsi: smartpqi: Add new controller PCI IDs

Hawkins Jiawei <yin31149@gmail.com>
    hugetlbfs: fix null-ptr-deref in hugetlbfs_parse_param()

Nathan Chancellor <nathan@kernel.org>
    scsi: elx: libefc: Fix second parameter type in state callbacks

Bjorn Helgaas <bhelgaas@google.com>
    Revert "PCI: Clear PCI_STATUS when setting up device"

Kai Ye <yekai13@huawei.com>
    crypto: hisilicon/qm - increase the memory of local variables

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: Reduce the START STOP UNIT timeout

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Fix hard lockup when reading the rx_monitor from debugfs

Zhiqi Song <songzhiqi1@huawei.com>
    crypto: hisilicon/hpre - fix resource leak in remove process

ChiYuan Huang <cy_huang@richtek.com>
    regulator: core: Fix resolve supply lookup issue

Sven Peter <sven@svenpeter.dev>
    Bluetooth: Add quirk to disable MWS Transport Configuration

Sven Peter <sven@svenpeter.dev>
    Bluetooth: Add quirk to disable extended scanning

Marek Vasut <marex@denx.de>
    Bluetooth: hci_bcm: Add CYW4373A0 support

Jacob Keller <jacob.e.keller@intel.com>
    ice: synchronize the misc IRQ when tearing down Tx tracker

ChiYuan Huang <cy_huang@richtek.com>
    regulator: core: Use different devices for resource allocation and DT lookup

Xiu Jianfeng <xiujianfeng@huawei.com>
    clk: st: Fix memory leak in st_of_quadfs_setup()

Shigeru Yoshida <syoshida@redhat.com>
    media: si470x: Fix use-after-free in si470x_int_in_callback()

Prathamesh Shete <pshete@nvidia.com>
    mmc: sdhci-tegra: Issue CMD and DAT resets together

Wolfram Sang <wsa+renesas@sang-engineering.com>
    mmc: renesas_sdhi: better reset from HS400 mode

Wolfram Sang <wsa+renesas@sang-engineering.com>
    mmc: renesas_sdhi: add quirk for broken register layout

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    mmc: f-sdh30: Add quirks for broken timeout clock capability

Hawkins Jiawei <yin31149@gmail.com>
    nfs: fix possible null-ptr-deref when parsing param

James Hilliard <james.hilliard1@gmail.com>
    selftests/bpf: Fix conflicts with built-in functions in bpf_iter_ksym

Denis Pauk <pauk.denis@gmail.com>
    hwmon: (nct6775) add ASUS CROSSHAIR VIII/TUF/ProArt B550M

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: do not run mt76u_status_worker if the device is not running

Rui Zhang <zr.zhang@vivo.com>
    regulator: core: fix use_count leakage when handling boot-on

Andrii Nakryiko <andrii@kernel.org>
    libbpf: Avoid enum forward-declarations in public API in C++ mode

Artem Lukyanov <dukzcry@ya.ru>
    ASoC: amd: yc: Add Xiaomi Redmi Book Pro 14 2022 into DMI table

Alvin Lee <Alvin.Lee2@amd.com>
    drm/amd/display: Fix DTBCLK disable requests and SRC_SEL programming

Wesley Chalmers <Wesley.Chalmers@amd.com>
    drm/amd/display: Use the largest vready_offset in pipe group

Liang He <windhl@126.com>
    drm/amdgpu: Fix potential double free and null pointer dereference

John Keeping <john@metanate.com>
    ALSA: usb-audio: Add quirk for Tascam Model 12

Ye Bin <yebin10@huawei.com>
    blk-mq: fix possible memleak when register 'hctx' failed

Yunfei Dong <yunfei.dong@mediatek.com>
    media: mediatek: vcodec: Can't set dst buffer to done when lat decode error

Mazin Al Haddad <mazinalhaddad05@gmail.com>
    media: dvb-usb: fix memory leak in dvb_usb_adapter_init()

Lin Ma <linma@zju.edu.cn>
    media: dvbdev: adopts refcnt to avoid UAF

Yan Lei <yan_lei@dahuatech.com>
    media: dvb-frontends: fix leak of memory fw

Maxim Korotkov <korotkov.maxim.s@gmail.com>
    ethtool: avoiding integer overflow in ethtool_phys_id()

Stanislav Fomichev <sdf@google.com>
    bpf: Prevent decl_tag from being referenced in func_proto arg

Yonghong Song <yhs@fb.com>
    bpf: Fix a BTF_ID_LIST bug with CONFIG_DEBUG_INFO_BTF not set

Ilya Bakoulin <Ilya.Bakoulin@amd.com>
    drm/amd/display: Fix display corruption w/ VSR enable

Stanislav Fomichev <sdf@google.com>
    ppp: associate skb with a device at tx

Kees Cook <keescook@chromium.org>
    bpf/verifier: Use kmalloc_size_roundup() to match ksize() usage

Felix Fietkau <nbd@nbd.name>
    net: ethernet: mtk_eth_soc: drop packets to WDMA if the ring is full

Schspa Shi <schspa@gmail.com>
    mrp: introduce active flags to prevent UAF when applicant uninit

Eric Dumazet <edumazet@google.com>
    ipv6/sit: use DEV_STATS_INC() to avoid data-races

Eric Dumazet <edumazet@google.com>
    net: add atomic_long_t to net_device_stats fields

Sagi Grimberg <sagi@grimberg.me>
    nvme-auth: don't override ctrl keys before validation

Aurabindo Pillai <aurabindo.pillai@amd.com>
    drm/amd/display: fix array index out of bound error in bios parser

George Shen <george.shen@amd.com>
    drm/amd/display: Workaround to increase phantom pipe vactive in pipesplit

Jiang Li <jiang.li@ugreen.com>
    md/raid1: stop mdx_raid1 thread when raid1 array run failed

Xiao Ni <xni@redhat.com>
    md/raid0, raid10: Don't set discard sectors for request queue

Li Zhong <floridsleeves@gmail.com>
    drivers/md/md-bitmap: check the return value of md_bitmap_get_counter()

Nathan Chancellor <nathan@kernel.org>
    drm/mediatek: Fix return type of mtk_hdmi_bridge_mode_valid()

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/sti: Use drm_mode_copy()

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/rockchip: Use drm_mode_copy()

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/msm: Use drm_mode_copy()

Wesley Chalmers <Wesley.Chalmers@amd.com>
    drm/amd/display: Disable DRR actions during state commit

Alvin Lee <Alvin.Lee2@amd.com>
    drm/amd/display: Use min transition for SubVP into MPO

Nathan Chancellor <nathan@kernel.org>
    s390/lcs: Fix return type of lcs_start_xmit()

Nathan Chancellor <nathan@kernel.org>
    s390/netiucv: Fix return type of netiucv_tx()

Nathan Chancellor <nathan@kernel.org>
    s390/ctcm: Fix return type of ctc{mp,}m_tx()

Nathan Chancellor <nathan@kernel.org>
    drm/amdgpu: Fix type of second parameter in odn_edit_dpm_table() callback

Nathan Chancellor <nathan@kernel.org>
    drm/amdgpu: Fix type of second parameter in trans_msg() callback

Kees Cook <keescook@chromium.org>
    igb: Do not free q_vector unless new one was allocated

José Expósito <jose.exposito89@gmail.com>
    HID: uclogic: Add support for XP-PEN Deco LW

José Expósito <jose.exposito89@gmail.com>
    HID: input: do not query XP-PEN Deco LW battery

Jisoo Jang <jisoo.jang@yonsei.ac.kr>
    wifi: brcmfmac: Fix potential NULL pointer dereference in 'brcmf_c_preinit_dcmds()'

Minsuk Kang <linuxlovemin@yonsei.ac.kr>
    wifi: brcmfmac: Fix potential shift-out-of-bounds in brcmf_fw_alloc_request()

Nathan Chancellor <nathan@kernel.org>
    hamradio: baycom_epp: Fix return type of baycom_send_packet()

Nathan Chancellor <nathan@kernel.org>
    net: ethernet: ti: Fix return type of netcp_ndo_start_xmit()

Stanislav Fomichev <sdf@google.com>
    bpf: make sure skb->len != 0 when redirecting to a tunneling device

Nathan Chancellor <nathan@kernel.org>
    drm/meson: Fix return type of meson_encoder_cvbs_mode_valid()

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    qed (gcc13): use u16 for fid to be big enough

Rahul Bhattacharjee <quic_rbhattac@quicinc.com>
    wifi: ath11k: Fix qmi_msg_handler data structure initialization

Kerem Karabay <kekrby@gmail.com>
    HID: apple: enable APPLE_ISO_TILDE_QUIRK for the keyboards of Macs with the T2 chip

Kerem Karabay <kekrby@gmail.com>
    HID: apple: fix key translations where multiple quirks attempt to translate the same key

David Jeffery <djeffery@redhat.com>
    blk-mq: avoid double ->queue_rq() because of early timeout

Yuan Can <yuancan@huawei.com>
    drm/rockchip: use pm_runtime_resume_and_get() instead of pm_runtime_get_sync()

Hamza Mahfooz <hamza.mahfooz@amd.com>
    Revert "drm/amd/display: Limit max DSC target bpp for specific monitors"

Hamza Mahfooz <hamza.mahfooz@amd.com>
    drm/edid: add a quirk for two LG monitors to get them to work on 10bpc

gehao <gehao@kylinos.cn>
    drm/amd/display: prevent memory leak

zhikzhai <zhikai.zhai@amd.com>
    drm/amd/display: skip commit minimal transition state

Kees Cook <keescook@chromium.org>
    bnx2: Use kmalloc_size_roundup() to match ksize() usage

Kees Cook <keescook@chromium.org>
    openvswitch: Use kmalloc_size_roundup() to match ksize() usage

Youghandhar Chintala <quic_youghand@quicinc.com>
    wifi: ath10k: Delay the unmapping of the buffer

Zhang Yuchen <zhangyuchen.lcr@bytedance.com>
    ipmi: fix memleak when unload ipmi driver

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ASoC: Intel: avs: Add quirk for KBL-R RVP platform

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ASoC: codecs: rt298: Add quirk for KBL-R RVP platform

Shigeru Yoshida <syoshida@redhat.com>
    wifi: ar5523: Fix use-after-free on ar5523_cmd() timed out

Fedor Pchelkin <pchelkin@ispras.ru>
    wifi: ath9k: verify the expected usb_endpoints are present

Wright Feng <wright.feng@cypress.com>
    brcmfmac: return error when getting invalid max_flowrings from dongle

Ming Qian <ming.qian@nxp.com>
    media: imx-jpeg: Disable useless interrupt to avoid kernel panic

Doug Brown <doug@schmorgal.com>
    drm/etnaviv: add missing quirks for GC300

ZhangPeng <zhangpeng362@huawei.com>
    hfs: fix OOB Read in __hfs_brec_find

Hans de Goede <hdegoede@redhat.com>
    ACPI: x86: Add skip i2c clients quirk for Medion Lifetab S10346

Josef Bacik <josef@toxicpanda.com>
    btrfs: do not panic if we can't allocate a prealloc extent state

Hans de Goede <hdegoede@redhat.com>
    ACPI: x86: Add skip i2c clients quirk for Lenovo Yoga Tab 3 Pro (YT3-X90F)

Mateusz Jończyk <mat.jonczyk@o2.pl>
    x86/apic: Handle no CONFIG_X86_X2APIC on systems with x2APIC enabled by BIOS

Zheng Yejian <zhengyejian1@huawei.com>
    acct: fix potential integer overflow in encode_comp_t()

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix shift-out-of-bounds due to too large exponent of block size

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix shift-out-of-bounds/overflow in nilfs_sb2_bad_offset()

Hans de Goede <hdegoede@redhat.com>
    ACPI: video: Add force_native quirk for Sony Vaio VPCY11S1E

Hans de Goede <hdegoede@redhat.com>
    ACPI: video: Add force_vendor quirk for Sony Vaio PCG-FRV35

Hans de Goede <hdegoede@redhat.com>
    ACPI: video: Change Sony Vaio VPCEH3U1E quirk to force_native

Hans de Goede <hdegoede@redhat.com>
    ACPI: video: Change GIGABYTE GB-BXBT-2807 quirk to force_none

Guenter Roeck <linux@roeck-us.net>
    thermal/core: Ensure that thermal device is registered in thermal_zone_get_temp

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPICA: Fix error code path in acpi_ds_call_control_method()

Mia Kanashi <chad@redpilled.dev>
    ACPI: EC: Add quirk for the HP Pavilion Gaming 15-cx0041ur

Li Zhong <floridsleeves@gmail.com>
    ACPI: processor: idle: Check acpi_fetch_acpi_dev() return value

Hoi Pok Wu <wuhoipok@gmail.com>
    fs: jfs: fix shift-out-of-bounds in dbDiscardAG

Dr. David Alan Gilbert <linux@treblig.org>
    jfs: Fix fortify moan in symlink

Shigeru Yoshida <syoshida@redhat.com>
    udf: Avoid double brelse() in udf_rename()

Dongliang Mu <mudongliangabcd@gmail.com>
    fs: jfs: fix shift-out-of-bounds in dbAllocAG

Marijn Suijten <marijn.suijten@somainline.org>
    arm64: dts: qcom: sm6350: Add apps_smmu with streamID to SDHCI 1/2 nodes

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm8450: disable SDHCI SDR104/SDR50 on all boards

Liu Shixin <liushixin2@huawei.com>
    binfmt_misc: fix shift-out-of-bounds in check_special_flags

Gaurav Kohli <gauravkohli@linux.microsoft.com>
    x86/hyperv: Remove unregister syscore call from Hyper-V cleanup

Guilherme G. Piccoli <gpiccoli@igalia.com>
    video: hyperv_fb: Avoid taking busy spinlock on panic path

Adriana Kobylak <anoo@us.ibm.com>
    ARM: dts: aspeed: rainier,everest: Move reserved memory regions

Mark Rutland <mark.rutland@arm.com>
    arm64: make is_ttbrX_addr() noinstr-safe

Zqiang <qiang1.zhang@intel.com>
    rcu: Fix __this_cpu_read() lockdep warning in rcu_force_quiescent_state()

Wei Fang <wei.fang@nxp.com>
    net: fec: check the return value of build_skb()

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    HID: amd_sfh: Add missing check for dma_alloc_coherent

Matt Johnston <matt@codeconstruct.com.au>
    mctp: Remove device type check at unregister

Arun Ramadoss <arun.ramadoss@microchip.com>
    net: dsa: microchip: remove IRQF_TRIGGER_FALLING in request_threaded_irq

Paulo Alcantara <pc@cjr.nz>
    cifs: don't leak -ENOMEM in smb2_open_file()

Jeremy Kerr <jk@codeconstruct.com.au>
    mctp: serial: Fix starting value for frame check sequence

Eric Dumazet <edumazet@google.com>
    net: stream: purge sk_error_queue in sk_stream_kill_queues()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    myri10ge: Fix an error handling path in myri10ge_probe()

David Howells <dhowells@redhat.com>
    rxrpc: Fix missing unlock in rxrpc_do_sendmsg()

Cong Wang <cong.wang@bytedance.com>
    net_sched: reject TCF_EM_SIMPLE case for complex ematch module

Yang Yingliang <yangyingliang@huawei.com>
    mailbox: zynq-ipi: fix error handling while device_register() fails

Yang Yingliang <yangyingliang@huawei.com>
    mailbox: arm_mhuv2: Fix return value check in mhuv2_probe()

Conor Dooley <conor.dooley@microchip.com>
    mailbox: mpfs: read the system controller's status

Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>
    skbuff: Account for tail adjustment during pull operations

Jakub Kicinski <kuba@kernel.org>
    devlink: protect devlink dump by the instance lock

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mt8183: Fix Mali GPU clock

Chun-Jie Chen <chun-jie.chen@mediatek.com>
    soc: mediatek: pm-domains: Fix the power glitch issue

Eelco Chaudron <echaudro@redhat.com>
    openvswitch: Fix flow lookup to use unmasked key

Jakub Kicinski <kuba@kernel.org>
    selftests: devlink: fix the fd redirect in dummy_reporter_test

Jakub Kicinski <kuba@kernel.org>
    devlink: hold region lock when flushing snapshots

GUO Zihua <guozihua@huawei.com>
    rtc: mxc_v2: Add missing clk_disable_unprepare()

Tan Tee Min <tee.min.tan@linux.intel.com>
    igc: Set Qbv start_time and end_time to end_time if not being configured in GCL

Tan Tee Min <tee.min.tan@linux.intel.com>
    igc: recalculate Qbv end_time by considering cycle time

Tan Tee Min <tee.min.tan@linux.intel.com>
    igc: allow BaseTime 0 enrollment for Qbv

Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
    igc: Add checking for basetime less than zero

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    igc: Use strict cycles for Qbv scheduling

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    igc: Enhance Qbv scheduling by using first flag bit

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: mv88e6xxx: avoid reg_lock deadlock in mv88e6xxx_setup_port()

Ming Lei <ming.lei@redhat.com>
    block: fix use-after-free of q->q_usage_counter

Christoph Hellwig <hch@lst.de>
    block: mark blk_put_queue as potentially blocking

Christoph Hellwig <hch@lst.de>
    block: untangle request_queue refcounting from sysfs

Christoph Hellwig <hch@lst.de>
    block: fix error unwinding in blk_register_queue

Christoph Hellwig <hch@lst.de>
    block: factor out a blk_debugfs_remove helper

Christoph Hellwig <hch@lst.de>
    blk-crypto: pass a gendisk to blk_crypto_sysfs_{,un}register

Christoph Hellwig <hch@lst.de>
    blk-mq: move the srcu_struct used for quiescing to the tagset

Li Zetao <lizetao1@huawei.com>
    r6040: Fix kmemleak in probe and remove

Kirill Tkhai <tkhai@ya.ru>
    unix: Fix race in SOCK_SEQPACKET's unix_dgram_sendmsg()

Minsuk Kang <linuxlovemin@yonsei.ac.kr>
    nfc: pn533: Clear nfc_target before being used

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: enetc: avoid buffer leaks on xdp_do_redirect() failure

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: v4l2-ctrls-api.c: add back dropped ctrl->is_new = 1

Milan Landaverde <milan@mdaverde.com>
    bpf: prevent leak of lsm program after failed attach

Song Liu <song@kernel.org>
    selftests/bpf: Select CONFIG_FUNCTION_ERROR_INJECTION

Yu Kuai <yukuai3@huawei.com>
    block, bfq: fix possible uaf for 'bfqq->bic'

Yang Yingliang <yangyingliang@huawei.com>
    mISDN: hfcmulti: don't call dev_kfree_skb/kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    mISDN: hfcpci: don't call dev_kfree_skb/kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    mISDN: hfcsusb: don't call dev_kfree_skb/kfree_skb() under spin_lock_irqsave()

Hangbin Liu <liuhangbin@gmail.com>
    bonding: do failover when high prio link up

Hangbin Liu <liuhangbin@gmail.com>
    bonding: add missed __rcu annotation for curr_active_slave

Emeel Hakim <ehakim@nvidia.com>
    net: macsec: fix net device access prior to holding a lock

Dan Aloni <dan.aloni@vastdata.com>
    nfsd: under NFSv4.1, fix double svc_xprt_put on rpc_create failure

Dan Carpenter <error27@gmail.com>
    iommu/mediatek: Fix forever loop in error handling

Alexandre Belloni <alexandre.belloni@bootlin.com>
    rtc: pcf85063: fix pcf85063_clkout_control

Gaosheng Cui <cuigaosheng1@huawei.com>
    rtc: pic32: Move devm_rtc_allocate_device earlier in pic32_rtc_probe()

Gaosheng Cui <cuigaosheng1@huawei.com>
    rtc: st-lpc: Add missing clk_disable_unprepare in st_rtc_probe()

Qingfang DENG <dqfext@gmail.com>
    netfilter: flowtable: really fix NAT IPv6 offload

Yang Yingliang <yangyingliang@huawei.com>
    mfd: pm8008: Fix return value check in pm8008_probe()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mfd: qcom_rpm: Fix an error handling path in qcom_rpm_probe()

Matti Vaittinen <mazziesaccount@gmail.com>
    mfd: bd957x: Fix Kconfig dependency on REGMAP_IRQ

Samuel Holland <samuel@sholland.org>
    mfd: axp20x: Do not sleep in the power off handler

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    dt-bindings: mfd: qcom,spmi-pmic: Drop PWM reg dependency

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/pseries/eeh: use correct API for error log size

Shang XiaoJing <shangxiaojing@huawei.com>
    remoteproc: qcom: q6v5: Fix missing clk_disable_unprepare() in q6v5_wcss_qcs404_power_on()

Yuan Can <yuancan@huawei.com>
    remoteproc: qcom_q6v5_pas: Fix missing of_node_put() in adsp_alloc_memory_region()

Luca Weiss <luca.weiss@fairphone.com>
    remoteproc: qcom_q6v5_pas: detach power domains on remove

Luca Weiss <luca.weiss@fairphone.com>
    remoteproc: qcom_q6v5_pas: disable wakeup on probe fail or remove

Shang XiaoJing <shangxiaojing@huawei.com>
    remoteproc: qcom: q6v5: Fix potential null-ptr-deref in q6v5_wcss_init_mmio()

Gaosheng Cui <cuigaosheng1@huawei.com>
    remoteproc: sysmon: fix memory leak in qcom_add_sysmon_subdev()

Anup Patel <apatel@ventanamicro.com>
    RISC-V: KVM: Fix reg_val check in kvm_riscv_vcpu_set_reg_config()

Daniel Golle <daniel@makrotopia.org>
    pwm: mediatek: always use bus clock for PWM on MT7622

xinlei lee <xinlei.lee@mediatek.com>
    pwm: mtk-disp: Fix the parameters calculated by the enabled flag of disp_pwm

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: sifive: Call pwm_sifive_update_clock() while mutex is held

Jason Gunthorpe <jgg@ziepe.ca>
    iommu/sun50i: Remove IOMMU_DOMAIN_IDENTITY

Guenter Roeck <groeck@chromium.org>
    iommu/mediatek: Validate number of phandles associated with "mediatek,larbs"

Yong Wu <yong.wu@mediatek.com>
    iommu/mediatek: Add error path for loop of mm_dts_parse

Yong Wu <yong.wu@mediatek.com>
    iommu/mediatek: Use component_match_add

Yong Wu <yong.wu@mediatek.com>
    iommu/mediatek: Add platform_device_put for recovering the device refcnt

Miaoqian Lin <linmq006@gmail.com>
    selftests/powerpc: Fix resource leaks

Kajol Jain <kjain@linux.ibm.com>
    powerpc/hv-gpci: Fix hv_gpci event list

Yang Yingliang <yangyingliang@huawei.com>
    powerpc/83xx/mpc832x_rdb: call platform_device_put() in error case in of_fsl_spi_probe()

Nicholas Piggin <npiggin@gmail.com>
    powerpc/perf: callchain validate kernel stack pointer bounds

Pali Rohár <pali@kernel.org>
    powerpc: dts: turris1x.dts: Add channel labels for temperature sensor

Li Huafei <lihuafei1@huawei.com>
    kprobes: Fix check for probe enabled in kill_kprobe()

Nayna Jain <nayna@linux.ibm.com>
    powerpc/pseries: fix plpks_read_var() code for different consumers

Nayna Jain <nayna@linux.ibm.com>
    powerpc/pseries: Return -EIO instead of -EINTR for H_ABORTED error

Nayna Jain <nayna@linux.ibm.com>
    powerpc/pseries: Fix the H_CALL error code in PLPKS driver

Nayna Jain <nayna@linux.ibm.com>
    powerpc/pseries: fix the object owners enum value in plpks driver

Yang Yingliang <yangyingliang@huawei.com>
    powerpc/xive: add missing iounmap() in error path in xive_spapr_populate_irq_data()

Gustavo A. R. Silva <gustavoars@kernel.org>
    powerpc/xmon: Fix -Wswitch-unreachable warning in bpt_cmds

Miaoqian Lin <linmq006@gmail.com>
    cxl: Fix refcount leak in cxl_calc_capp_routing

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    powerpc/52xx: Fix a resource leak in an error handling path

Xie Shaowen <studentxswpy@163.com>
    macintosh/macio-adb: check the return value of ioremap()

Yang Yingliang <yangyingliang@huawei.com>
    macintosh: fix possible memory leak in macio_add_one_device()

Yuan Can <yuancan@huawei.com>
    iommu/fsl_pamu: Fix resource leak in fsl_pamu_probe()

Yang Yingliang <yangyingliang@huawei.com>
    iommu/amd: Fix pci device refcount leak in ppr_notifier()

Robin Murphy <robin.murphy@arm.com>
    iommu: Avoid races around device probe

Yang Yingliang <yangyingliang@huawei.com>
    iommu/mediatek: Check return value after calling platform_get_resource()

Alexander Stein <alexander.stein@ew.tq-group.com>
    rtc: pcf85063: Fix reading alarm

Stefan Eichenberger <stefan.eichenberger@toradex.com>
    rtc: snvs: Allow a time difference on clock register read

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    rtc: cmos: Disable ACPI RTC event on removal

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    rtc: cmos: Rename ACPI-related functions

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    rtc: cmos: Eliminate forward declarations of some functions

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    rtc: cmos: Call rtc_wake_setup() from cmos_do_probe()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    rtc: cmos: Call cmos_wake_setup() from cmos_do_probe()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    rtc: pcf2127: Convert to .probe_new()

Shang XiaoJing <shangxiaojing@huawei.com>
    rtc: class: Fix potential memleak in devm_rtc_allocate_device()

Yushan Zhou <katrinzhou@tencent.com>
    rtc: rzn1: Check return value in rzn1_rtc_probe

Fenghua Yu <fenghua.yu@intel.com>
    dmaengine: idxd: Fix crc_val field for completion record

Abdun Nihaal <abdun.nihaal@gmail.com>
    fs/ntfs3: Fix slab-out-of-bounds read in ntfs_trim_fs

Manivannan Sadhasivam <mani@kernel.org>
    phy: qcom-qmp-pcie: Fix sm8450_qmp_gen4x2_pcie_pcs_tbl[] register names

Manivannan Sadhasivam <mani@kernel.org>
    phy: qcom-qmp-pcie: Fix high latency with 4x2 PHY when ASPM is enabled

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    phy: qcom-qmp-pcie: Support SM8450 PCIe1 PHY in EP mode

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    phy: qcom-qmp-pcie: support separate tables for EP mode

Christian Marangi <ansuelsmth@gmail.com>
    phy: qcom-qmp-pcie: split pcs_misc init cfg for ipq8074 pcs table

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    phy: qcom-qmp-pcie: split register tables into common and extra parts

Jon Hunter <jonathanh@nvidia.com>
    pwm: tegra: Ensure the clock rate is not less than needed

Jon Hunter <jonathanh@nvidia.com>
    pwm: tegra: Improve required rate calculation

Matt Redfearn <matt.redfearn@mips.com>
    include/uapi/linux/swab: Fix potentially missing __always_inline

Justin Chen <justinpopo6@gmail.com>
    phy: usb: Fix clock imbalance for suspend/resume

Justin Chen <justinpopo6@gmail.com>
    phy: usb: Use slow clock for wake enabled suspend

Al Cooper <alcooperx@gmail.com>
    phy: usb: s2 WoL wakeup_count not incremented for USB->Eth devices

Johan Hovold <johan+linaro@kernel.org>
    phy: qcom-qmp-usb: fix sc8280xp PCS_USB offset

Xiaochen Shen <xiaochen.shen@intel.com>
    dmaengine: idxd: Make read buffer sysfs attributes invisible for Intel IAA

Michael Riesch <michael.riesch@wolfvision.net>
    iommu/rockchip: fix permission bits in page table entries v2

Jernej Skrabec <jernej.skrabec@gmail.com>
    iommu/sun50i: Implement .iotlb_sync_map

Jernej Skrabec <jernej.skrabec@gmail.com>
    iommu/sun50i: Fix flush size

Jernej Skrabec <jernej.skrabec@gmail.com>
    iommu/sun50i: Fix R/W permission check

Jernej Skrabec <jernej.skrabec@gmail.com>
    iommu/sun50i: Consider all fault sources for reset

Jernej Skrabec <jernej.skrabec@gmail.com>
    iommu/sun50i: Fix reset release

Niklas Schnelle <schnelle@linux.ibm.com>
    iommu/s390: Fix duplicate domain attachments

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    phy: qcom-qmp-usb: correct registers layout for IPQ8074 USB3 PHY

Johan Hovold <johan+linaro@kernel.org>
    phy: qcom-qmp-usb: drop start and pwrdn-ctrl abstraction

Johan Hovold <johan+linaro@kernel.org>
    phy: qcom-qmp-usb: clean up status polling

Johan Hovold <johan+linaro@kernel.org>
    phy: qcom-qmp-usb: drop power-down delay config

Johan Hovold <johan+linaro@kernel.org>
    phy: qcom-qmp-usb: drop sc8280xp power-down delay

Johan Hovold <johan+linaro@kernel.org>
    phy: qcom-qmp-usb: clean up power-down handling

Johan Hovold <johan+linaro@kernel.org>
    phy: qcom-qmp-pcie: fix ipq6018 initialisation

Johan Hovold <johan+linaro@kernel.org>
    phy: qcom-qmp-pcie: fix ipq8074-gen3 initialisation

Johan Hovold <johan+linaro@kernel.org>
    phy: qcom-qmp-pcie: fix sc8180x initialisation

Johan Hovold <johan+linaro@kernel.org>
    phy: qcom-qmp-pcie: replace power-down delay

Johan Hovold <johan+linaro@kernel.org>
    phy: qcom-qmp-pcie: drop power-down delay config

Shengjiu Wang <shengjiu.wang@nxp.com>
    remoteproc: core: Auto select rproc-virtio device id

Martin Povišer <povik+lin@cutebit.org>
    dmaengine: apple-admac: Allocate cache SRAM to channels

Xiaochen Shen <xiaochen.shen@intel.com>
    dmaengine: idxd: Make max batch size attributes in sysfs invisible for Intel IAA

Johan Hovold <johan+linaro@kernel.org>
    phy: qcom-qmp-pcie: drop bogus register update

Pali Rohár <pali@kernel.org>
    phy: marvell: phy-mvebu-a3700-comphy: Reset COMPHY registers before USB 3.0 power on

Dan Carpenter <error27@gmail.com>
    fs/ntfs3: Harden against integer overflows

Shigeru Yoshida <syoshida@redhat.com>
    fs/ntfs3: Avoid UBSAN error on true_sectors_per_clst()

Arnd Bergmann <arnd@arndb.de>
    RDMA/siw: Fix pointer cast warning

Namhyung Kim <namhyung@kernel.org>
    perf stat: Do not delay the workload with --delay

Ard Biesheuvel <ardb@kernel.org>
    ftrace: Allow WITH_ARGS flavour of graph tracer with shadow call stack

Namhyung Kim <namhyung@kernel.org>
    perf off_cpu: Fix a typo in BTF tracepoint name, it should be 'btf_trace_sched_switch'

Luca Weiss <luca@z3ntu.xyz>
    leds: is31fl319x: Fix setting current limit for is31fl319{0,1,3}

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Partially revert gfs2_inode_lookup change

ruanjinjie <ruanjinjie@huawei.com>
    power: supply: fix null pointer dereferencing in power_supply_get_battery_info

James Clark <james.clark@arm.com>
    perf branch: Fix interpretation of branch records

Hans de Goede <hdegoede@redhat.com>
    power: supply: bq25890: Ensure pump_express_work is cancelled on remove

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    power: supply: bq25890: Convert to i2c's .probe_new()

Marek Vasut <marex@denx.de>
    power: supply: bq25890: Factor out regulator registration code

Qiheng Lin <linqiheng@huawei.com>
    power: supply: Fix refcount leak in rk817_charger_probe

Yuan Can <yuancan@huawei.com>
    power: supply: ab8500: Fix error handling in ab8500_charger_init()

Yuan Can <yuancan@huawei.com>
    HSI: omap_ssi_core: Fix error handling in ssi_init()

Shang XiaoJing <shangxiaojing@huawei.com>
    power: supply: cw2015: Fix potential null-ptr-deref in cw_bat_probe()

Zhang Qilong <zhangqilong3@huawei.com>
    power: supply: z2_battery: Fix possible memleak in z2_batt_probe()

Ajay Kaher <akaher@vmware.com>
    perf symbol: correction while adjusting symbol

Leo Yan <leo.yan@linaro.org>
    perf trace: Handle failure when trace point folder is missed

Leo Yan <leo.yan@linaro.org>
    perf trace: Use macro RAW_SYSCALL_ARGS_NUM to replace number

Leo Yan <leo.yan@linaro.org>
    perf trace: Return error if a system call doesn't exist

Mika Westerberg <mika.westerberg@linux.intel.com>
    watchdog: iTCO_wdt: Set NO_REBOOT if the watchdog is not already running

Zeng Heng <zengheng4@huawei.com>
    power: supply: fix residue sysfs file in error handle route of __power_supply_register()

Yang Yingliang <yangyingliang@huawei.com>
    HSI: omap_ssi_core: fix possible memory leak in ssi_probe()

Yang Yingliang <yangyingliang@huawei.com>
    HSI: omap_ssi_core: fix unbalanced pm_runtime_disable()

Namhyung Kim <namhyung@kernel.org>
    perf stat: Move common code in print_metric_headers()

Namhyung Kim <namhyung@kernel.org>
    perf stat: Use evsel__is_hybrid() more

James Clark <james.clark@arm.com>
    perf tools: Fix "kernel lock contention analysis" test by not printing warnings in quiet mode

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    led: qcom-lpg: Fix sleeping in atomic

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    fbdev: uvesafb: Fixes an error handling path in uvesafb_probe()

Randy Dunlap <rdunlap@infradead.org>
    fbdev: uvesafb: don't build on UML

Randy Dunlap <rdunlap@infradead.org>
    fbdev: geode: don't build on UML

Gaosheng Cui <cuigaosheng1@huawei.com>
    fbdev: ep93xx-fb: Add missing clk_disable_unprepare in ep93xxfb_probe()

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    fbdev: vermilion: decrease reference count in error path

Shang XiaoJing <shangxiaojing@huawei.com>
    fbdev: via: Fix error in via_core_init()

Yang Yingliang <yangyingliang@huawei.com>
    fbdev: pm2fb: fix missing pci_disable_device()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    fbdev: ssd1307fb: Drop optional dependency

Bjorn Andersson <andersson@kernel.org>
    thermal/drivers/qcom/lmh: Fix irq handler return value

Luca Weiss <luca.weiss@fairphone.com>
    thermal/drivers/qcom/temp-alarm: Fix inaccurate warning for gen2

Ido Schimmel <idosch@nvidia.com>
    thermal/of: Fix memory leak on thermal_of_zone_register() failure

Keerthy <j-keerthy@ti.com>
    thermal/drivers/k3_j72xx_bandgap: Fix the debug print message

Marcus Folkesson <marcus.folkesson@gmail.com>
    thermal/drivers/imx8mm_thermal: Validate temperature range

Shang XiaoJing <shangxiaojing@huawei.com>
    samples: vfio-mdev: Fix missing pci_disable_device() in mdpy_fb_probe()

Xiu Jianfeng <xiujianfeng@huawei.com>
    ksmbd: Fix resource leak in ksmbd_session_rpc_open()

Zheng Yejian <zhengyejian1@huawei.com>
    tracing/hist: Fix issue of losting command info in error_log

Yang Yingliang <yangyingliang@huawei.com>
    usb: typec: wusb3801: fix fwnode refcount leak in wusb3801_probe()

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    usb: storage: Add check for kcalloc

Zheyu Ma <zheyuma97@gmail.com>
    i2c: ismt: Fix an out-of-bounds bug in ismt_access()

Yang Yingliang <yangyingliang@huawei.com>
    i2c: mux: reg: check return value after calling platform_get_resource()

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    gpiolib: protect the GPIO device against being dropped while in use by user-space

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    gpiolib: cdev: fix NULL-pointer dereferences

Chen Zhongjin <chenzhongjin@huawei.com>
    vme: Fix error not catched in fake_init()

YueHaibing <yuehaibing@huawei.com>
    staging: rtl8192e: Fix potential use-after-free in rtllib_rx_Monitor()

Dan Carpenter <error27@gmail.com>
    staging: rtl8192u: Fix use after free in ieee80211_rx()

Hui Tang <tanghui20@huawei.com>
    i2c: pxa-pci: fix missing pci_disable_device() on error in ce4100_i2c_probe

Joao Martins <joao.m.martins@oracle.com>
    vfio/iova_bitmap: refactor iova_bitmap_set() to better handle page boundaries

Yang Yingliang <yangyingliang@huawei.com>
    chardev: fix error handling in cdev_device_add()

Yang Yingliang <yangyingliang@huawei.com>
    mcb: mcb-parse: fix error handing in chameleon_parse_gdd()

Zhengchao Shao <shaozhengchao@huawei.com>
    drivers: mcb: fix resource leak in mcb_probe()

John Keeping <john@metanate.com>
    usb: gadget: f_hid: fix refcount leak on error path

John Keeping <john@metanate.com>
    usb: gadget: f_hid: fix f_hidg lifetime vs cdev

Yang Yingliang <yangyingliang@huawei.com>
    usb: core: hcd: Fix return value check in usb_hcd_setup_local_mem()

Yang Yingliang <yangyingliang@huawei.com>
    usb: roles: fix of node refcount leak in usb_role_switch_is_parent()

Beau Belgrave <beaub@linux.microsoft.com>
    tracing/user_events: Fix call print_fmt leak

Mike Leach <mike.leach@linaro.org>
    coresight: cti: Fix null pointer error on CTI init before ETM

Yang Shen <shenyang39@huawei.com>
    coresight: trbe: remove cpuhp instance node before remove cpuhp state

Fabrice Gasnier <fabrice.gasnier@foss.st.com>
    counter: stm32-lptimer-cnt: fix the check on arr and cmp registers update

Ramona Bolboaca <ramona.bolboaca@analog.com>
    iio: adis: add '__adis_enable_irq()' implementation

Cosmin Tanislav <cosmin.tanislav@analog.com>
    iio: temperature: ltc2983: make bulk write buffer DMA-safe

Yang Yingliang <yangyingliang@huawei.com>
    cxl: fix possible null-ptr-deref in cxl_pci_init_afu|adapter()

Yang Yingliang <yangyingliang@huawei.com>
    cxl: fix possible null-ptr-deref in cxl_guest_init_afu|adapter()

Yang Yingliang <yangyingliang@huawei.com>
    firmware: raspberrypi: fix possible memory leak in rpi_firmware_probe()

Zheng Wang <zyytlz.wz@163.com>
    misc: sgi-gru: fix use-after-free error in gru_set_context_option, gru_fault and gru_handle_user_call_os

ruanjinjie <ruanjinjie@huawei.com>
    misc: tifm: fix possible memory leak in tifm_7xx1_switch_media()

Yang Yingliang <yangyingliang@huawei.com>
    ocxl: fix pci device refcount leak when calling get_function_0()

Yang Yingliang <yangyingliang@huawei.com>
    misc: ocxl: fix possible name leak in ocxl_file_register_afu()

Zhengchao Shao <shaozhengchao@huawei.com>
    test_firmware: fix memory leak in test_firmware_init()

Yang Yingliang <yangyingliang@huawei.com>
    habanalabs: fix return value check in hl_fw_get_sec_attest_data()

Yuan Can <yuancan@huawei.com>
    serial: sunsab: Fix error handling in sunsab_init()

Gabriel Somlo <gsomlo@gmail.com>
    serial: altera_uart: fix locking in polling mode

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    serial: pch: Fix PCI device refcount leak in pch_request_dma()

Valentin Caron <valentin.caron@foss.st.com>
    serial: stm32: move dma_request_chan() before clk_prepare_enable()

delisun <delisun@pateo.com.cn>
    serial: pl011: Do not clear RX FIFO & RX interrupt in unthrottle.

Jiamei Xie <jiamei.xie@arm.com>
    serial: amba-pl011: avoid SBSA UART accessing DMACR register

Jiantao Zhang <water.zhangjiantao@huawei.com>
    USB: gadget: Fix use-after-free during usb config switch

Marek Vasut <marex@denx.de>
    extcon: usbc-tusb320: Update state on probe even if no IRQ pending

Tony Lindgren <tony@atomide.com>
    usb: musb: omap2430: Fix probe regression for missing resources

Sven Peter <sven@svenpeter.dev>
    usb: typec: tipd: Fix typec_unregister_port error paths

Sven Peter <sven@svenpeter.dev>
    usb: typec: tipd: Fix spurious fwnode_handle_put in error path

Sven Peter <sven@svenpeter.dev>
    usb: typec: tipd: Cleanup resources if devm_tps6598_psy_register fails

Yang Yingliang <yangyingliang@huawei.com>
    usb: typec: tcpci: fix of node refcount leak in tcpci_register_port()

Sven Peter <sven@svenpeter.dev>
    usb: typec: Check for ops->exit instead of ops->enter in altmode_exit

Gaosheng Cui <cuigaosheng1@huawei.com>
    staging: vme_user: Fix possible UAF in tsi148_dma_list_add

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    interconnect: qcom: sc7180: fix dropped const of qcom_icc_bcm

Linus Walleij <linus.walleij@linaro.org>
    usb: fotg210-udc: Fix ages old endianness issues

Rafael Mendonca <rafaelmendsr@gmail.com>
    uio: uio_dmem_genirq: Fix deadlock between irq config and handling

Rafael Mendonca <rafaelmendsr@gmail.com>
    uio: uio_dmem_genirq: Fix missing unlock in irq configuration

Joao Martins <joao.m.martins@oracle.com>
    vfio/iova_bitmap: Fix PAGE_SIZE unaligned bitmaps

Rafael Mendonca <rafaelmendsr@gmail.com>
    vfio: platform: Do not pass return buffer to ACPI _RST method

Yang Yingliang <yangyingliang@huawei.com>
    class: fix possible memory leak in __class_register()

Duoming Zhou <duoming@zju.edu.cn>
    drivers: staging: r8188eu: Fix sleep-in-atomic-context bug in rtw_join_timeout_handler

Yuan Can <yuancan@huawei.com>
    serial: 8250_bcm7271: Fix error handling in brcmuart_init()

Kartik <kkartik@nvidia.com>
    serial: tegra: Read DMA status before terminating

Yang Yingliang <yangyingliang@huawei.com>
    drivers: dio: fix possible memory leak in dio_init()

Alexandre Ghiti <alexghiti@rivosinc.com>
    riscv: Fix P4D_SHIFT definition for 3-level page table mode

Yangtao Li <frank.li@vivo.com>
    f2fs: fix iostat parameter for discard

Palmer Dabbelt <palmer@rivosinc.com>
    RISC-V: Align the shadow stack

Dragos Tatulea <dtatulea@nvidia.com>
    IB/IPoIB: Fix queue count inconsistency for PKEY child interfaces

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    hwrng: geode - Fix PCI device refcount leak

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    hwrng: amd - Fix PCI device refcount leak

Gaosheng Cui <cuigaosheng1@huawei.com>
    crypto: img-hash - Fix variable dereferenced before check 'hdev->req'

Samuel Holland <samuel@sholland.org>
    riscv: Fix crash during early errata patching

Anup Patel <apatel@ventanamicro.com>
    RISC-V: Fix MEMREMAP_WB for systems with Svpbmt

Andrew Bresticker <abrestic@rivosinc.com>
    RISC-V: Fix unannoted hardirqs-on in return to userspace slow-path

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Fix XRC caps on HIP08

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Fix error code of CMD

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Fix page size cap from firmware

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Fix PBL page MTR find

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Fix AH attr queried by query_qp

Yixing Liu <liuyixing1@huawei.com>
    RDMA/hns: Fix the gid problem caused by free mr

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    orangefs: Fix sysfs not cleanup when dev init failed

Francisco Munoz <francisco.munoz.ruiz@linux.intel.com>
    PCI: vmd: Fix secondary bus reset for Intel bridges

Wang Yufen <wangyufen@huawei.com>
    RDMA/srp: Fix error return code in srp_parse_options()

Wang Yufen <wangyufen@huawei.com>
    RDMA/hfi1: Fix error return code in parse_platform_config()

Randy Dunlap <rdunlap@infradead.org>
    RDMA: Disable IB HW for UML

Tong Tiangen <tongtiangen@huawei.com>
    riscv/mm: add arch hook arch_clear_hugepage_flags

Shang XiaoJing <shangxiaojing@huawei.com>
    crypto: omap-sham - Use pm_runtime_resume_and_get() in omap_sham_probe()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    crypto: amlogic - Remove kcalloc without check

Wang Yufen <wangyufen@huawei.com>
    crypto: qat - fix error return code in adf_probe

Mark Zhang <markzhang@nvidia.com>
    RDMA/nldev: Fix failure to send large messages

Yonggil Song <yonggil.song@samsung.com>
    f2fs: avoid victim selection from previous victim section

Sheng Yong <shengyong@oppo.com>
    f2fs: fix to enable compress for newly created file if extension matches

Sheng Yong <shengyong@oppo.com>
    f2fs: set zstd compress level correctly

Yuan Can <yuancan@huawei.com>
    RDMA/nldev: Add checks for nla_nest_start() in fill_stat_counter_qps()

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: core: Fix the polling implementation

Gaosheng Cui <cuigaosheng1@huawei.com>
    scsi: snic: Fix possible UAF in snic_tgt_create()

Chen Zhongjin <chenzhongjin@huawei.com>
    scsi: fcoe: Fix transport not deattached when fcoe_if_init() fails

Shang XiaoJing <shangxiaojing@huawei.com>
    scsi: ipr: Fix WARNING in ipr_init()

Yang Yingliang <yangyingliang@huawei.com>
    scsi: scsi_debug: Fix possible name leak in sdebug_add_host_helper()

Yang Yingliang <yangyingliang@huawei.com>
    scsi: fcoe: Fix possible name leak when device_register() fails

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    scsi: scsi_debug: Fix a warning in resp_report_zones()

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    scsi: scsi_debug: Fix a warning in resp_verify()

Chen Zhongjin <chenzhongjin@huawei.com>
    scsi: efct: Fix possible memleak in efct_device_init()

Yang Yingliang <yangyingliang@huawei.com>
    scsi: hpsa: Fix possible memory leak in hpsa_add_sas_device()

Yang Yingliang <yangyingliang@huawei.com>
    scsi: hpsa: Fix error handling in hpsa_add_sas_host()

Yang Yingliang <yangyingliang@huawei.com>
    scsi: mpt3sas: Fix possible resource leaks in mpt3sas_transport_port_add()

Weili Qian <qianweili@huawei.com>
    crypto: hisilicon/qm - fix 'QM_XEQ_DEPTH_CAP' mask value

Eric Biggers <ebiggers@google.com>
    crypto: arm64/sm3 - fix possible crash with CFI enabled

Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
    crypto: arm64/sm3 - add NEON assembly implementation

Eric Biggers <ebiggers@google.com>
    crypto: x86/sm4 - fix crash with CFI enabled

Eric Biggers <ebiggers@google.com>
    crypto: x86/sm3 - fix possible crash with CFI enabled

Eric Biggers <ebiggers@google.com>
    crypto: x86/sha512 - fix possible crash with CFI enabled

Eric Biggers <ebiggers@google.com>
    crypto: x86/sha256 - fix possible crash with CFI enabled

Eric Biggers <ebiggers@google.com>
    crypto: x86/sha1 - fix possible crash with CFI enabled

Eric Biggers <ebiggers@google.com>
    crypto: x86/aria - fix crash with CFI enabled

Eric Biggers <ebiggers@google.com>
    crypto: x86/aegis128 - fix possible crash with CFI enabled

Daniel Jordan <daniel.m.jordan@oracle.com>
    padata: Fix list iterator in padata_do_serial()

Daniel Jordan <daniel.m.jordan@oracle.com>
    padata: Always leave BHs disabled when running ->parallel()

Zhang Yiqun <zhangyiqun@phytium.com.cn>
    crypto: tcrypt - Fix multibuffer skcipher speed test mem leak

Yuan Can <yuancan@huawei.com>
    scsi: hpsa: Fix possible memory leak in hpsa_init_one()

Frank Li <frank.li@nxp.com>
    PCI: endpoint: pci-epf-vntb: Fix call pci_epc_mem_free_addr() in error path

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    dt-bindings: visconti-pcie: Fix interrupts array max constraints

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    dt-bindings: imx6q-pcie: Fix clock names for imx6sx and imx8mq

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    RDMA/rxe: Fix NULL-ptr-deref in rxe_qp_do_cleanup() when socket create failed

Zhengchao Shao <shaozhengchao@huawei.com>
    RDMA/hns: fix memory leak in hns_roce_alloc_mr()

Mustafa Ismail <mustafa.ismail@intel.com>
    RDMA/irdma: Initialize net_type before checking it

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    crypto: ccree - Make cc_debugfs_global_fini() available for module init function

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    RDMA/hfi: Decrease PCI device reference count in error path

Zeng Heng <zengheng4@huawei.com>
    PCI: Check for alloc failure in pci_request_irq()

Luoyouming <luoyouming@huawei.com>
    RDMA/hns: Fix incorrect sge nums calculation

Luoyouming <luoyouming@huawei.com>
    RDMA/hns: Fix ext_sge num error when post send

Li Zhijian <lizhijian@fujitsu.com>
    RDMA/rxe: Fix mr->map double free

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    crypto: hisilicon/qm - add missing pci_dev_put() in q_num_set()

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: cryptd - Use request context instead of stack for sub-request

Gaosheng Cui <cuigaosheng1@huawei.com>
    crypto: ccree - Remove debugfs when platform_driver_register failed

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    scsi: scsi_debug: Fix a warning in resp_write_scat()

Mustafa Ismail <mustafa.ismail@intel.com>
    RDMA/irdma: Do not request 2-level PBLEs for CQ alloc

Mustafa Ismail <mustafa.ismail@intel.com>
    RDMA/irdma: Fix RQ completion opcode

Mustafa Ismail <mustafa.ismail@intel.com>
    RDMA/irdma: Fix inline for multiple SGE's

Bernard Metzler <bmt@zurich.ibm.com>
    RDMA/siw: Set defined status for work completion with undefined status

Mark Zhang <markzhang@nvidia.com>
    RDMA/nldev: Return "-EAGAIN" if the cm_id isn't from expected port

Mark Zhang <markzhang@nvidia.com>
    RDMA/core: Make sure "ib_port" is valid when access sysfs node

Mark Zhang <markzhang@nvidia.com>
    RDMA/restrack: Release MR restrack when delete

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid accessing uninitialized spinlock

Sascha Hauer <s.hauer@pengutronix.de>
    PCI: imx6: Initialize PHY before deasserting core reset

Nirmal Patel <nirmal.patel@linux.intel.com>
    PCI: vmd: Disable MSI remapping after suspend

Leonid Ravich <lravich@gmail.com>
    IB/mad: Don't call to function that might sleep while in atomic context

Bernard Metzler <bmt@zurich.ibm.com>
    RDMA/siw: Fix immediate work request flush to completion queue

Bart Van Assche <bvanassche@acm.org>
    scsi: qla2xxx: Fix set-but-not-used variable warnings

Shiraz Saleem <shiraz.saleem@intel.com>
    RDMA/irdma: Report the correct link speed

Chao Yu <chao@kernel.org>
    f2fs: fix to destroy sbi->post_read_wq in error path of f2fs_fill_super()

Mukesh Ojha <quic_mojha@quicinc.com>
    f2fs: fix the assign logic of iocb

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: allow to set compression for inlined file

Dongdong Zhang <zhangdongdong1@oppo.com>
    f2fs: fix normal discard process

Yangtao Li <frank.li@vivo.com>
    f2fs: fix gc mode when gc_urgent_high_remaining is 1

Chao Yu <chao@kernel.org>
    f2fs: fix to invalidate dcc->f2fs_issue_discard in error path

Kees Cook <keescook@chromium.org>
    fortify: Do not cast to "unsigned char"

Xiu Jianfeng <xiujianfeng@huawei.com>
    apparmor: Fix memleak in alloc_ns()

Corentin Labbe <clabbe@baylibre.com>
    crypto: rockchip - rework by using crypto_engine

Corentin Labbe <clabbe@baylibre.com>
    crypto: rockchip - remove non-aligned handling

Corentin Labbe <clabbe@baylibre.com>
    crypto: rockchip - better handle cipher key

Corentin Labbe <clabbe@baylibre.com>
    crypto: rockchip - add fallback for ahash

Corentin Labbe <clabbe@baylibre.com>
    crypto: rockchip - add fallback for cipher

Corentin Labbe <clabbe@baylibre.com>
    crypto: rockchip - do not store mode globally

Corentin Labbe <clabbe@baylibre.com>
    crypto: rockchip - do not do custom power management

Zhang Qilong <zhangqilong3@huawei.com>
    f2fs: Fix the race condition of resize flag between resizefs

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    PCI: pci-epf-test: Register notifier if only core_init_notifier is enabled

Leon Romanovsky <leon@kernel.org>
    RDMA/core: Fix order of nldev_exit call

Vidya Sagar <vidyas@nvidia.com>
    PCI: dwc: Fix n_fts[] array overrun

Xiu Jianfeng <xiujianfeng@huawei.com>
    apparmor: Use pointer to struct aa_label for lbs_cred

Bart Van Assche <bvanassche@acm.org>
    scsi: core: Fix a race between scsi_done() and scsi_timeout()

Robert Elliott <elliott@hpe.com>
    crypto: tcrypt - fix return value for multiple subtests

Natalia Petrova <n.petrova@fintech.ru>
    crypto: nitrox - avoid double free on error path in nitrox_sriov_init()

Corentin Labbe <clabbe@baylibre.com>
    crypto: sun8i-ss - use dma_addr instead u32

Weili Qian <qianweili@huawei.com>
    crypto: hisilicon/qm - re-enable communicate interrupt before notifying PF

Weili Qian <qianweili@huawei.com>
    crypto: hisilicon/qm - fix incorrect parameters usage

John Johansen <john.johansen@canonical.com>
    apparmor: Fix regression in stacking due to label flags

John Johansen <john.johansen@canonical.com>
    apparmor: Fix abi check to include v8 abi

John Johansen <john.johansen@canonical.com>
    apparmor: fix lockdep warning when removing a namespace

Gaosheng Cui <cuigaosheng1@huawei.com>
    apparmor: fix a memleak in multi_transaction_new()

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: tag_8021q: avoid leaking ctx on dsa_tag_8021q_register() error path

Bartosz Staszewski <bartoszx.staszewski@intel.com>
    i40e: Fix the inability to attach XDP program on downed interface

Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
    stmmac: fix potential division by 0

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    octeontx2-af: cn10k: mcs: Fix a resource leak in the probe and remove functions

Yang Yingliang <yangyingliang@huawei.com>
    Bluetooth: RFCOMM: don't call kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    Bluetooth: hci_core: don't call kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    Bluetooth: hci_bcsp: don't call kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    Bluetooth: hci_h5: don't call kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    Bluetooth: hci_ll: don't call kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    Bluetooth: hci_qca: don't call kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    Bluetooth: btusb: don't call kfree_skb() under spin_lock_irqsave()

Wang ShaoBo <bobo.shaobowang@huawei.com>
    Bluetooth: btintel: Fix missing free skb in btintel_setup_combined()

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_conn: Fix crash on hci_create_cis_sync

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    Bluetooth: Fix EALREADY and ELOOP cases in bt_status()

Inga Stotland <inga.stotland@intel.com>
    Bluetooth: MGMT: Fix error report for ADD_EXT_ADV_PARAMS

Yang Yingliang <yangyingliang@huawei.com>
    Bluetooth: hci_core: fix error handling in hci_register_dev()

Firo Yang <firo.yang@suse.com>
    sctp: sysctl: make extra pointers netns aware

Eric Pilmore <epilmore@gigaio.com>
    ntb_netdev: Use dev_kfree_skb_any() in interrupt context

Jerry Ray <jerry.ray@microchip.com>
    net: lan9303: Fix read error execution path

Roger Quadros <rogerq@kernel.org>
    net: ethernet: ti: am65-cpsw: Fix PM runtime leakage in am65_cpsw_nuss_ndo_slave_open()

Markus Schneider-Pargmann <msp@baylibre.com>
    can: tcan4x5x: Fix use of register error status mask

Vivek Yadav <vivek.2311@samsung.com>
    can: m_can: Call the RAM init directly from m_can_chip_config

Markus Schneider-Pargmann <msp@baylibre.com>
    can: tcan4x5x: Remove invalid write in clear_interrupts

Tom Lendacky <thomas.lendacky@amd.com>
    net: amd-xgbe: Check only the minimum speed for active/passive cables

Tom Lendacky <thomas.lendacky@amd.com>
    net: amd-xgbe: Fix logic around active and passive cables

Yang Yingliang <yangyingliang@huawei.com>
    af_unix: call proto_unregister() in the error path in af_unix_init()

Richard Gobert <richardbgobert@gmail.com>
    net: setsockopt: fix IPV6_UNICAST_IF option for connected sockets

Yang Yingliang <yangyingliang@huawei.com>
    net: amd: lance: don't call dev_kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    hamradio: don't call dev_kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    net: ethernet: dnet: don't call dev_kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    net: emaclite: don't call dev_kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    net: apple: bmac: don't call dev_kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    net: apple: mace: don't call dev_kfree_skb() under spin_lock_irqsave()

Hangbin Liu <liuhangbin@gmail.com>
    net/tunnel: wait until all sk_user_data reader finish before releasing the sock

Li Zetao <lizetao1@huawei.com>
    net: farsync: Fix kmemleak when rmmods farsync

Yang Yingliang <yangyingliang@huawei.com>
    ethernet: s2io: don't call dev_kfree_skb() under spin_lock_irqsave()

ruanjinjie <ruanjinjie@huawei.com>
    of: overlay: fix null pointer dereferencing in find_dup_cset_node_entry() and find_dup_cset_prop()

Julian Anastasov <ja@ssi.bg>
    ipvs: use u64_stats_t for the per-cpu counters

Yuan Can <yuancan@huawei.com>
    drivers: net: qlcnic: Fix potential memory leak in qlcnic_sriov_init()

Gaosheng Cui <cuigaosheng1@huawei.com>
    net: stmmac: fix possible memory leak in stmmac_dvr_probe()

Zhang Changzhong <zhangchangzhong@huawei.com>
    net: stmmac: selftests: fix potential memleak in stmmac_test_arpoffload()

Yongqiang Liu <liuyongqiang13@huawei.com>
    net: defxx: Fix missing err handling in dfx_init()

Artem Chernyshev <artem.chernyshev@red-soft.ru>
    net: vmw_vsock: vmci: Check memcpy_from_msg()

Xiu Jianfeng <xiujianfeng@huawei.com>
    clk: socfpga: Fix memory leak in socfpga_gate_init()

Björn Töpel <bjorn@rivosinc.com>
    bpf: Do not zero-extend kfunc return values

Yang Jihong <yangjihong1@huawei.com>
    blktrace: Fix output non-blktrace event when blk_classic option enabled

Wang Yufen <wangyufen@huawei.com>
    wifi: brcmfmac: Fix error return code in brcmf_sdio_download_firmware()

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtl8xxxu: Fix the channel width reporting

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtl8xxxu: Add __packed to struct rtl8723bu_c2h

Kris Bahnsen <kris@embeddedTS.com>
    spi: spi-gpio: Don't set MOSI as an input if not 3WIRE mode

Xiu Jianfeng <xiujianfeng@huawei.com>
    clk: samsung: Fix memory leak in _samsung_clk_register_pll()

Geert Uytterhoeven <geert+renesas@glider.be>
    media: staging: stkwebcam: Restore MEDIA_{USB,CAMERA}_SUPPORT dependencies

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    media: coda: Add check for kmalloc

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    media: coda: Add check for dcoda_iram_alloc

Liang He <windhl@126.com>
    media: c8sectpfe: Add of_node_put() when breaking out of loop

Yuan Can <yuancan@huawei.com>
    regulator: qcom-labibb: Fix missing of_node_put() in qcom_labibb_regulator_probe()

Christoph Hellwig <hch@lst.de>
    nvme: pass nr_maps explicitly to nvme_alloc_io_tag_set

Zhen Lei <thunder.leizhen@huawei.com>
    mmc: core: Normalize the error handling branch in sd_read_ext_regs()

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    memstick/ms_block: Add check for alloc_ordered_workqueue

Wolfram Sang <wsa+renesas@sang-engineering.com>
    mmc: renesas_sdhi: alway populate SCC pointer

Yang Yingliang <yangyingliang@huawei.com>
    mmc: mmci: fix return value check of mmc_add_host()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: wbsd: fix return value check of mmc_add_host()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: via-sdmmc: fix return value check of mmc_add_host()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: meson-gx: fix return value check of mmc_add_host()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: omap_hsmmc: fix return value check of mmc_add_host()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: atmel-mci: fix return value check of mmc_add_host()

Gabriel Somlo <gsomlo@gmail.com>
    mmc: litex_mmc: ensure `host->irq == 0` if polling

Yang Yingliang <yangyingliang@huawei.com>
    mmc: wmt-sdmmc: fix return value check of mmc_add_host()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: vub300: fix return value check of mmc_add_host()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: toshsd: fix return value check of mmc_add_host()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: rtsx_usb_sdmmc: fix return value check of mmc_add_host()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: rtsx_pci: fix return value check of mmc_add_host()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: pxamci: fix return value check of mmc_add_host()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: mxcmmc: fix return value check of mmc_add_host()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: moxart: fix return value check of mmc_add_host()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: alcor: fix return value check of mmc_add_host()

Xingjiang Qiao <nanpuyue@gmail.com>
    hwmon: (emc2305) fix pwm never being able to set lower

Xingjiang Qiao <nanpuyue@gmail.com>
    hwmon: (emc2305) fix unable to probe emc2301/2/3

Miaoqian Lin <linmq006@gmail.com>
    bpftool: Fix memory leak in do_build_table_cb

Pu Lehui <pulehui@huawei.com>
    riscv, bpf: Emit fixed-length instructions for BPF_PSEUDO_FUNC

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4.x: Fail client initialisation if state manager thread can't run

Anna Schumaker <Anna.Schumaker@Netapp.com>
    NFS: Allow very small rsize & wsize again

Anna Schumaker <Anna.Schumaker@Netapp.com>
    NFSv4.2: Set the correct size scratch buffer for decoding READ_PLUS

Wang ShaoBo <bobo.shaobowang@huawei.com>
    SUNRPC: Fix missing release socket in rpc_sockname()

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    xprtrdma: Fix regbuf data not freed in rpcrdma_req_create()

Gaosheng Cui <cuigaosheng1@huawei.com>
    pinctrl: thunderbay: fix possible memory leak in thunderbay_build_functions()

Gaosheng Cui <cuigaosheng1@huawei.com>
    ALSA: mts64: fix possible null-ptr-defer in snd_mts64_interrupt

Guoniu.zhou <guoniu.zhou@nxp.com>
    media: ov5640: set correct default link frequency

Liu Shixin <liushixin2@huawei.com>
    media: saa7164: fix missing pci_disable_device()

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Set missing stop_operating flag at undoing trigger start

Eric Dumazet <edumazet@google.com>
    bpf, sockmap: fix race in sock_map_free()

Toke Høiland-Jørgensen <toke@redhat.com>
    bpf: Add dummy type reference to nf_conn___init to fix type deduplication

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    hwmon: (jc42) Restore the min/max/critical temperatures on resume

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    hwmon: (jc42) Convert register access and caching to regmap/regcache

Yang Yingliang <yangyingliang@huawei.com>
    regulator: core: fix resource leak in regulator_register()

Chen Zhongjin <chenzhongjin@huawei.com>
    configfs: fix possible memory leak in configfs_create_dir()

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    hsr: Synchronize sequence number updates.

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    hsr: Synchronize sending frames to have always incremented outgoing seq nr.

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    hsr: Disable netpoll.

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    hsr: Avoid double remove of a node.

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    hsr: Add a rcu-read lock to hsr_forward_skb().

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    Revert "net: hsr: use hlist_head instead of list_head for mac addresses"

Christian Marangi <ansuelsmth@gmail.com>
    clk: qcom: clk-krait: fix wrong div2 functions

Douglas Anderson <dianders@chromium.org>
    clk: qcom: lpass-sc7180: Fix pm_runtime usage

Douglas Anderson <dianders@chromium.org>
    clk: qcom: lpass-sc7280: Fix pm_runtime usage

Yang Yingliang <yangyingliang@huawei.com>
    regulator: core: fix module refcount leak in set_supply()

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    mt76: mt7915: Fix PCI device refcount leak in mt7915_pci_init_hif2()

Deren Wu <deren.wu@mediatek.com>
    wifi: mt76: do not send firmware FW_FEATURE_NON_DL region

Deren Wu <deren.wu@mediatek.com>
    wifi: mt76: mt7921: Add missing __packed annotation of struct mt7921_clc

Deren Wu <deren.wu@mediatek.com>
    wifi: mt76: fix coverity overrun-call in mt76_get_txpower()

YN Chen <YN.Chen@mediatek.com>
    wifi: mt76: mt7921: fix wrong power after multiple SAR set

Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
    wifi: mt76: mt7915: Fix chainmask calculation on mt7915 DBDC

Shayne Chen <shayne.chen@mediatek.com>
    wifi: mt76: mt7915: rework eeprom tx paths and streams init

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: mt7921: fix reporting of TX AGGR histogram

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: mt7915: fix reporting of TX AGGR histogram

Ryder Lee <ryder.lee@mediatek.com>
    wifi: mt76: mt7915: fix mt7915_mac_set_timing()

Sean Wang <sean.wang@mediatek.com>
    wifi: mt76: mt7921: fix antenna signal are way off in monitor mode

Chen Zhongjin <chenzhongjin@huawei.com>
    wifi: cfg80211: Fix not unregister reg_pdev when load_builtin_regdb_keys() fails

Íñigo Huguet <ihuguet@redhat.com>
    wifi: mac80211: fix maybe-unused warning

Zhengchao Shao <shaozhengchao@huawei.com>
    wifi: mac80211: fix memory leak in ieee80211_if_add()

Yuan Can <yuancan@huawei.com>
    wifi: nl80211: Add checks for nla_nest_start() in nl80211_send_iface()

Alexander Sverdlin <alexander.sverdlin@siemens.com>
    spi: spidev: mask SPI_CS_HIGH in SPI_IOC_RD_MODE

Dan Carpenter <error27@gmail.com>
    bonding: uninitialized variable in bond_miimon_inspect()

Pengcheng Yang <yangpc@wangsu.com>
    bpf, sockmap: Fix data loss caused by using apply_bytes on ingress redirect

Pengcheng Yang <yangpc@wangsu.com>
    bpf, sockmap: Fix missing BPF_F_INGRESS flag when using apply_bytes

Pengcheng Yang <yangpc@wangsu.com>
    bpf, sockmap: Fix repeated calls to sock_put() when msg has more_data

Randy Dunlap <rdunlap@infradead.org>
    Input: wistron_btns - disable on UML

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: set icmpv6 redirects as RELATED

Xiu Jianfeng <xiujianfeng@huawei.com>
    clk: visconti: Fix memory leak in visconti_register_pll()

Zhang Qilong <zhangqilong3@huawei.com>
    ASoC: pcm512x: Fix PM disable depth imbalance in pcm512x_probe

Xia Fukun <xiafukun@huawei.com>
    drm/i915/bios: fix a memory leak in generate_lfp_data_ptrs

Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
    drm/amdkfd: Fix memory leakage

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    drm/amdgpu: Fix PCI device refcount leak in amdgpu_atrm_get_bios()

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    drm/radeon: Fix PCI device refcount leak in radeon_atrm_get_bios()

Veerabadhran Gopalakrishnan <veerabadhran.gopalakrishnan@amd.com>
    amdgpu/nv.c: Corrected typo in the video capabilities resolution

Guchun Chen <guchun.chen@amd.com>
    drm/amd/pm/smu11: BACO is supported when it's in BACO state

Daniel Golle <daniel@makrotopia.org>
    clk: mediatek: fix dependency of MT7986 ADC clocks

Ricardo Ribalda <ribalda@chromium.org>
    ASoC: mediatek: mt8173: Enable IRQ when pdata is ready

Ben Greear <greearb@candelatech.com>
    wifi: iwlwifi: mvm: fix double free on tx path.

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtl8xxxu: Fix use after rcu_read_unlock in rtl8xxxu_bss_info_changed

Ziyang Xuan <william.xuanziyang@huawei.com>
    wifi: plfxlc: fix potential memory leak in __lf_x_usb_enable_rx()

Liu Shixin <liushixin2@huawei.com>
    ALSA: asihpi: fix missing pci_disable_device()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix an Oops in nfs_d_automount()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Fix a deadlock between nfs4_open_recover_helper() and delegreturn

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Fix a credential leak in _nfs4_discover_trunking()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4.2: Fix initialisation of struct nfs4_label

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4.2: Fix a memory stomp in decode_attr_security_label

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4.2: Always decode the security label

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4.2: Clear FATTR4_WORD2_SECURITY_LABEL when done decoding

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/mdp5: fix reading hw revision on db410c platform

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    ASoC: mediatek: mtk-btcvsd: Add checks for write and read of mtk_btcvsd_snd

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    ASoC: dt-bindings: wcd9335: fix reset line polarity in example

Zhang Zekun <zhangzekun11@huawei.com>
    drm/tegra: Add missing clk_disable_unprepare() in tegra_dc_probe()

Aakarsh Jain <aakarsh.jain@samsung.com>
    media: s5p-mfc: Add variant data for MFC v7 hardware for Exynos 3250 SoC

Yunfei Dong <yunfei.dong@mediatek.com>
    media: mediatek: vcodec: Core thread depends on core_list

Yunfei Dong <yunfei.dong@mediatek.com>
    media: mediatek: vcodec: Setting lat buf to lat_list when lat decode error

Yunfei Dong <yunfei.dong@mediatek.com>
    media: mediatek: vcodec: Fix h264 set lat buffer error

Yunfei Dong <yunfei.dong@mediatek.com>
    media: mediatek: vcodec: Fix getting NULL pointer for dst buffer

Ming Qian <ming.qian@nxp.com>
    media: amphion: lock and check m2m_ctx in event handler

Ming Qian <ming.qian@nxp.com>
    media: amphion: cancel vpu before release instance

Ming Qian <ming.qian@nxp.com>
    media: amphion: try to wakeup vpu core to avoid failure

Paul Kocialkowski <paul.kocialkowski@bootlin.com>
    media: sun8i-a83t-mipi-csi2: Register async subdev with no sensor attached

Paul Kocialkowski <paul.kocialkowski@bootlin.com>
    media: sun6i-mipi-csi2: Register async subdev with no sensor attached

Paul Kocialkowski <paul.kocialkowski@bootlin.com>
    media: sun8i-a83t-mipi-csi2: Require both pads to be connected for streaming

Paul Kocialkowski <paul.kocialkowski@bootlin.com>
    media: sun6i-mipi-csi2: Require both pads to be connected for streaming

Juergen Gross <jgross@suse.com>
    x86/boot: Skip realmode init code when running as Xen PV guest

Baisong Zhong <zhongbaisong@huawei.com>
    media: dvb-usb: az6027: fix null-ptr-deref in az6027_i2c_xfer()

Chen Zhongjin <chenzhongjin@huawei.com>
    media: dvb-core: Fix ignored return value in dvb_register_frontend()

ZhangPeng <zhangpeng362@huawei.com>
    pinctrl: pinconf-generic: add missing of_node_put()

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    clk: imx8mn: fix imx8mn_enet_phy_sels clocks list

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    clk: imx8mn: fix imx8mn_sai2_sels clocks list

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    clk: imx: rename video_pll1 to video_pll

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    clk: imx: replace osc_hdmi with dummy

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    clk: imx8mn: rename vpu_pll to m7_alt_pll

Marek Vasut <marex@denx.de>
    media: mt9p031: Drop bogus v4l2_subdev_get_try_crop() call from mt9p031_init_cfg()

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: imx: imx7-media-csi: Clear BIT_MIPI_DOUBLE_CMPNT for <16b formats

Gautam Menghani <gautammenghani201@gmail.com>
    media: imon: fix a race condition in send_packet()

Chen Zhongjin <chenzhongjin@huawei.com>
    media: vimc: Fix wrong function called when vimc_init() fails

Jiaxin Yu <jiaxin.yu@mediatek.com>
    ASoC: mediatek: mt8186: Correct I2S shared clocks

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: qcom: cleanup and fix dependency of QCOM_COMMON

Yuan Can <yuancan@huawei.com>
    ASoC: qcom: Add checks for devm_kcalloc

Wang ShaoBo <bobo.shaobowang@huawei.com>
    drbd: destroy workqueue when drbd device was freed

Wang ShaoBo <bobo.shaobowang@huawei.com>
    drbd: remove call to memset before free device/resource/connection

Zheng Yongjun <zhengyongjun3@huawei.com>
    mtd: maps: pxa2xx-flash: fix memory leak in probe

Shang XiaoJing <shangxiaojing@huawei.com>
    mtd: core: Fix refcount error in del_mtd_device()

Hui Tang <tanghui20@huawei.com>
    clk: microchip: check for null return of devm_kzalloc()

Jonathan Toppins <jtoppins@redhat.com>
    bonding: fix link recovery in mode 2 when updelay is nonzero

Stanislav Fomichev <sdf@google.com>
    selftests/bpf: Mount debugfs in setns_by_fd

Stanislav Fomichev <sdf@google.com>
    selftests/bpf: Make sure zero-len skbs aren't redirectable

Jani Nikula <jani.nikula@intel.com>
    drm/i915/guc: make default_lists const data

Yang Yingliang <yangyingliang@huawei.com>
    drm/amdgpu: fix pci device refcount leak

Xiu Jianfeng <xiujianfeng@huawei.com>
    clk: rockchip: Fix memory leak in rockchip_clk_register_pll()

Wang ShaoBo <bobo.shaobowang@huawei.com>
    regulator: core: use kfree_const() to free space conditionally

Baisong Zhong <zhongbaisong@huawei.com>
    ALSA: seq: fix undefined behavior in bit shift for SNDRV_SEQ_FILTER_USE_EVENT

Baisong Zhong <zhongbaisong@huawei.com>
    ALSA: pcm: fix undefined behavior in bit shift for SNDRV_PCM_RATE_KNOT

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Lock substream before snd_pcm_stop()

Lili Li <lili.li@intel.com>
    ASoC: Intel: Skylake: Fix Kconfig dependency

Zong-Zhe Yang <kevin_yang@realtek.com>
    wifi: rtw89: fix physts IE page check

ZhangPeng <zhangpeng362@huawei.com>
    pinctrl: k210: call of_node_put()

Giulio Benetti <giulio.benetti@benettiengineering.com>
    clk: imx: imxrt1050: fix IMXRT1050_CLK_LCDIF_APB offsets

Marcus Folkesson <marcus.folkesson@gmail.com>
    HID: hid-sensor-custom: set fixed size for custom attributes

Stanislav Fomichev <sdf@google.com>
    bpf: Move skb->len == 0 checks into __bpf_redirect

Peng Fan <peng.fan@nxp.com>
    clk: imx93: correct enet clock

Peng Fan <peng.fan@nxp.com>
    clk: imx93: unmap anatop base in error handling path

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    HID: i2c: let RMI devices decide what constitutes wakeup event

Hou Tao <houtao1@huawei.com>
    bpf: Pin the start cgroup in cgroup_iter_seq_init()

Haibo Chen <haibo.chen@nxp.com>
    clk: imx93: correct the flexspi1 clock setting

Allen-KH Cheng <allen-kh.cheng@mediatek.com>
    mtd: spi-nor: Fix the number of bytes for the dummy cycles

Michael Walle <michael@walle.cc>
    mtd: spi-nor: hide jedec_id sysfs attribute if not present

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Return errno in sk->sk_prot->get_port().

Kuniyuki Iwashima <kuniyu@amazon.com>
    udp: Clean up some functions.

Lorenzo Bianconi <lorenzo@kernel.org>
    net: ethernet: mtk_eth_soc: fix RSTCTRL_PPE{0,1} definitions

Christoph Hellwig <hch@lst.de>
    media: videobuf-dma-contig: use dma_mmap_coherent

Yuan Can <yuancan@huawei.com>
    media: amphion: Fix error handling in vpu_driver_init()

Yuan Can <yuancan@huawei.com>
    media: platform: exynos4-is: Fix error handling in fimc_md_init()

Yang Yingliang <yangyingliang@huawei.com>
    media: solo6x10: fix possible memory leak in solo_sysfs_init()

Chen Zhongjin <chenzhongjin@huawei.com>
    media: vidtv: Fix use-after-free in vidtv_bridge_dvb_init()

Ming Qian <ming.qian@nxp.com>
    media: amphion: apply vb2_queue_error instead of setting manually

Ming Qian <ming.qian@nxp.com>
    media: amphion: add lock around vdec_g_fmt

Lorenzo Bianconi <lorenzo@kernel.org>
    net: ethernet: mtk_eth_soc: do not overwrite mtu configuration running reset routine

Gaosheng Cui <cuigaosheng1@huawei.com>
    ASoC: amd: acp: Fix possible UAF in acp_dma_open

Douglas Anderson <dianders@chromium.org>
    Input: elants_i2c - properly handle the reset GPIO when power is off

Hui Tang <tanghui20@huawei.com>
    mtd: lpddr2_nvm: Fix possible null-ptr-deref

Rob Clark <robdclark@chromium.org>
    drm/msm/a6xx: Fix speed-bin detection vs probe-defer

Xiu Jianfeng <xiujianfeng@huawei.com>
    wifi: ath10k: Fix return value in ath10k_pci_init()

Wang Yufen <wangyufen@huawei.com>
    selftests/bpf: fix memory leak of lsm_cgroup

Christoph Hellwig <hch@lst.de>
    dm: track per-add_disk holder relations in DM

Yu Kuai <yukuai3@huawei.com>
    dm: make sure create and remove dm device won't race with open and close table

Christoph Hellwig <hch@lst.de>
    dm: cleanup close_table_device

Christoph Hellwig <hch@lst.de>
    dm: cleanup open_table_device

Christoph Hellwig <hch@lst.de>
    block: clear ->slave_dir when dropping the main slave_dir reference

Xiu Jianfeng <xiujianfeng@huawei.com>
    ima: Fix misuse of dereference of pointer in template_desc_init_fields()

GUO Zihua <guozihua@huawei.com>
    integrity: Fix memory leakage in keyring allocation error path

Takashi Iwai <tiwai@suse.de>
    ALSA: memalloc: Allocate more contiguous pages for fallback case

Brian Starkey <brian.starkey@arm.com>
    drm/fourcc: Fix vsub/hsub for Q410 and Q401

Konrad Dybcio <konrad.dybcio@linaro.org>
    regulator: qcom-rpmh: Fix PMR735a S3 regulator spec

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    wifi: rtw89: Fix some error handling path in rtw89_core_sta_assoc()

Joel Granados <j.granados@samsung.com>
    nvme: return err on nvme_init_non_mdts_limits fail

Dan Carpenter <error27@gmail.com>
    amdgpu/pm: prevent array underflow in vega20_odn_edit_dpm_table()

Yang Yingliang <yangyingliang@huawei.com>
    regulator: core: fix unbalanced of node refcount in regulator_dev_lookup()

Christoph Hellwig <hch@lst.de>
    nvmet: only allocate a single slab for bvecs

Zeng Heng <zengheng4@huawei.com>
    ASoC: pxa: fix null-pointer dereference in filter()

Xinlei Lee <xinlei.lee@mediatek.com>
    drm/mediatek: Modify dpi power on/off sequence.

Martin KaFai Lau <martin.lau@kernel.org>
    selftests/bpf: Fix incorrect ASSERT in the tcp_hdr_options test

Yang Jihong <yangjihong1@huawei.com>
    selftests/bpf: Fix xdp_synproxy compilation failure in 32-bit arch

Randy Dunlap <rdunlap@infradead.org>
    ASoC: codecs: wsa883x: use correct header file

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ASoC: codecs: wsa883x: Use proper shutdown GPIO polarity

Miaoqian Lin <linmq006@gmail.com>
    module: Fix NULL vs IS_ERR checking for module_get_next_page

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: mei: fix potential NULL-ptr deref after clone

Avraham Stern <avraham.stern@intel.com>
    wifi: iwlwifi: mei: avoid blocking sap messages handling due to rtnl lock

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mei: fix tx DHCP packet for devices with new Tx API

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mei: don't send SAP commands if AMT is disabled

Avraham Stern <avraham.stern@intel.com>
    wifi: iwlwifi: mei: make sure ownership confirmed message is sent

Sam Shih <sam.shih@mediatek.com>
    pinctrl: mediatek: fix the pinconf register offset of some pins

Frank Wunderlich <frank-w@public-files.de>
    dt-bindings: pinctrl: update uart/mmc bindings for MT7986 SoC

Hanjun Guo <guohanjun@huawei.com>
    drm/radeon: Add the missed acpi_put_table() to fix memory leak

Khazhismel Kumykov <khazhy@chromium.org>
    bfq: fix waker_bfqq inconsistency crash

Christoph Böhmwalder <christoph.boehmwalder@linbit.com>
    drbd: use blk_queue_max_discard_sectors helper

Yassine Oudjana <y.oudjana@protonmail.com>
    regmap-irq: Use the new num_config_regs property in regmap_add_irq_chip_fwnode

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    drm: rcar-du: Drop leftovers dependencies from Kconfig

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: use u32_encode_bits() to fill MAC quota value

Marek Vasut <marex@denx.de>
    drm: lcdif: Set and enable FIFO Panic threshold

David Howells <dhowells@redhat.com>
    rxrpc: Fix ack.bufferSize to be 0 when generating an ack

David Howells <dhowells@redhat.com>
    net, proc: Provide PROC_FS=n fallback for proc_create_net_single_write()

Cole Robinson <crobinso@redhat.com>
    virt/sev-guest: Add a MODULE_ALIAS

Wolfram Sang <wsa+renesas@sang-engineering.com>
    clk: renesas: r8a779f0: Fix SCIF parent clocks

Wolfram Sang <wsa+renesas@sang-engineering.com>
    clk: renesas: r8a779f0: Fix HSCIF parent clocks

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    media: camss: Do not attach an already attached power domain on MSM8916 platform

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    media: camss: Clean up received buffers on failed start of streaming

Marek Vasut <marex@denx.de>
    wifi: rsi: Fix handling of 802.3 EAPOL frames sent via control port

Randy Dunlap <rdunlap@infradead.org>
    Input: joystick - fix Kconfig warning for JOYSTICK_ADC

Gaosheng Cui <cuigaosheng1@huawei.com>
    mtd: core: fix possible resource leak in init_mtd()

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    mtd: Fix device name leak when register device failed in add_mtd_device()

Manivannan Sadhasivam <mani@kernel.org>
    clk: qcom: gcc-sm8250: Use retention mode for USB GDSCs

Konrad Dybcio <konrad.dybcio@somainline.org>
    clk: qcom: dispcc-sm6350: Add CLK_OPS_PARENT_ENABLE to pixel&byte src

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    clk: qcom: gcc-ipq806x: use parent_data for the last remaining entry

Andrii Nakryiko <andrii@kernel.org>
    bpf: propagate precision across all frames, not just the last one

Andrii Nakryiko <andrii@kernel.org>
    bpf: propagate precision in ALU/ALU64 operations

Yang Yingliang <yangyingliang@huawei.com>
    media: platform: exynos4-is: fix return value check in fimc_md_probe()

Liu Shixin <liushixin2@huawei.com>
    media: vivid: fix compose size exceed boundary

Andrzej Pietrasiewicz <andrzej.p@collabora.com>
    media: rkvdec: Add required padding

Moudy Ho <moudy.ho@mediatek.com>
    media: platform: mtk-mdp3: fix error handling in mdp_probe()

Moudy Ho <moudy.ho@mediatek.com>
    media: platform: mtk-mdp3: fix error handling about components clock_on

Moudy Ho <moudy.ho@mediatek.com>
    media: platform: mtk-mdp3: fix error handling in mdp_cmdq_send()

Marijn Suijten <marijn.suijten@somainline.org>
    drm/msm/dsi: Prevent signed BPG offsets from bleeding into adjacent bits

Marijn Suijten <marijn.suijten@somainline.org>
    drm/msm/dsi: Disallow 8 BPC DSC configuration for alternative BPC values

Marijn Suijten <marijn.suijten@somainline.org>
    drm/msm/dsi: Account for DSC's bits_per_pixel having 4 fractional bits

Marijn Suijten <marijn.suijten@somainline.org>
    drm/msm/dsi: Migrate to drm_dsc_compute_rc_parameters()

Marijn Suijten <marijn.suijten@somainline.org>
    drm/msm/dsi: Appropriately set dsc->mux_word_size based on bpc

Marijn Suijten <marijn.suijten@somainline.org>
    drm/msm/dsi: Reuse earlier computed dsc->slice_chunk_size

Marijn Suijten <marijn.suijten@somainline.org>
    drm/msm/dsi: Use DIV_ROUND_UP instead of conditional increment on modulo

Marijn Suijten <marijn.suijten@somainline.org>
    drm/msm/dsi: Remove repeated calculation of slice_per_intf

Marijn Suijten <marijn.suijten@somainline.org>
    drm/msm/dsi: Remove useless math in DSC calculations

Marijn Suijten <marijn.suijten@somainline.org>
    drm/msm/dpu1: Account for DSC's bits_per_pixel having 4 fractional bits

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Fix slot type check in check_stack_write_var_off

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Clobber stack slot when writing over spilled PTR_TO_BTF_ID

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/hdmi: use devres helper for runtime PM management

GUO Zihua <guozihua@huawei.com>
    ima: Handle -ESTALE returned by ima_filter_rule_match()

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/mdp5: stop overriding drvdata

Gaosheng Cui <cuigaosheng1@huawei.com>
    drm/ttm: fix undefined behavior in bit shift for TTM_TT_FLAG_PRIV_POPULATED

Marek Vasut <marex@denx.de>
    drm/panel/panel-sitronix-st7701: Remove panel on DSI attach failure

Jonathan Neuschäfer <j.neuschaefer@gmx.net>
    spi: Update reference to struct spi_controller

Marek Vasut <marex@denx.de>
    drm/panel/panel-sitronix-st7701: Fix RTNI calculation

Marco Felsch <m.felsch@pengutronix.de>
    drm: lcdif: change burst size to 256B

Marek Vasut <marex@denx.de>
    clk: renesas: r9a06g032: Repair grave increment error

Anshuman Gupta <anshuman.gupta@intel.com>
    drm/i915/dgfx: Grab wakeref at i915_ttm_unmap_virtual

Anshuman Gupta <anshuman.gupta@intel.com>
    drm/i915: Encapsulate lmem rpm stuff in intel_runtime_pm

Nirmoy Das <nirmoy.das@intel.com>
    drm/i915: Refactor ttm ghost obj detection

Tvrtko Ursulin <tvrtko.ursulin@intel.com>
    drm/i915: Handle all GTs on driver (un)load paths

Zhang Qilong <zhangqilong3@huawei.com>
    drm/rockchip: lvds: fix PM usage counter unbalance in poweron

Haiyi Zhou <Haiyi.Zhou@amd.com>
    drm/amd/display: wait for vblank during pipe programming

Sakari Ailus <sakari.ailus@linux.intel.com>
    dw9768: Enable low-power probe on ACPI

Alan Previn <alan.previn.teres.alexis@intel.com>
    drm/i915/guc: Fix GuC error capture sizing estimation and reporting

Alan Previn <alan.previn.teres.alexis@intel.com>
    drm/i915/guc: Add error-capture init warnings when needed

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    ASoC: dt-bindings: rt5682: Set sound-dai-cells to 1

Wolfram Sang <wsa+renesas@sang-engineering.com>
    clk: renesas: r8a779a0: Fix SD0H clock name

Geert Uytterhoeven <geert+renesas@glider.be>
    clk: renesas: r8a779f0: Fix SD0H clock name

Jimmy Assarsson <extja@kvaser.com>
    can: kvaser_usb: Compare requested bittiming parameters with actual parameters in do_set_{,data}_bittiming

Jimmy Assarsson <extja@kvaser.com>
    can: kvaser_usb: Add struct kvaser_usb_busparams

Anssi Hannula <anssi.hannula@bitwise.fi>
    can: kvaser_usb_leaf: Fix bogus restart events

Anssi Hannula <anssi.hannula@bitwise.fi>
    can: kvaser_usb_leaf: Fix wrong CAN state after stopping

Anssi Hannula <anssi.hannula@bitwise.fi>
    can: kvaser_usb_leaf: Fix improved state not being reported

Anssi Hannula <anssi.hannula@bitwise.fi>
    can: kvaser_usb_leaf: Set Warning state even without bus errors

Jimmy Assarsson <extja@kvaser.com>
    can: kvaser_usb: kvaser_usb_leaf: Handle CMD_ERROR_EVENT

Jimmy Assarsson <extja@kvaser.com>
    can: kvaser_usb: kvaser_usb_leaf: Rename {leaf,usbcan}_cmd_error_event to {leaf,usbcan}_cmd_can_error_event

Jimmy Assarsson <extja@kvaser.com>
    can: kvaser_usb: kvaser_usb_leaf: Get capabilities from device

Alan Maguire <alan.maguire@oracle.com>
    libbpf: Btf dedup identical struct test needs check for nested structs/arrays

Marek Szyprowski <m.szyprowski@samsung.com>
    media: exynos4-is: don't rely on the v4l2_async_subdev internals

Rafael Mendonca <rafaelmendsr@gmail.com>
    media: i2c: ov5648: Free V4L2 fwnode data on unbind

Kuniyuki Iwashima <kuniyu@amazon.com>
    soreuseport: Fix socket selection for SO_INCOMING_CPU.

Tang Bin <tangbin@cmss.chinamobile.com>
    venus: pm_helpers: Fix error check in vcodec_domains_get()

Ricardo Ribalda <ribalda@chromium.org>
    media: i2c: ad5820: Fix error path

Rafael Mendonca <rafaelmendsr@gmail.com>
    media: i2c: hi846: Fix memory leak in hi846_parse_dt()

John Harrison <John.C.Harrison@Intel.com>
    drm/i915: Fix compute pre-emption w/a to apply to compute engines

John Harrison <John.C.Harrison@Intel.com>
    drm/i915/guc: Limit scheduling properties to avoid overflow

Yunfei Dong <yunfei.dong@mediatek.com>
    media: mediatek: vcodec: fix h264 cavlc bitstream fail

Jernej Skrabec <jernej.skrabec@gmail.com>
    media: cedrus: hevc: Fix offset adjustments

Jernej Skrabec <jernej.skrabec@gmail.com>
    media: v4l2-ioctl.c: Unify YCbCr/YUV terms in format descriptions

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    media: adv748x: afe: Select input port when initializing AFE

Ming Qian <ming.qian@nxp.com>
    media: amphion: reset instance if it's aborted before codec header parsed

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    media: coda: jpeg: Add check for kmalloc

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    media: v4l2-ctrls: Fix off-by-one error in integer menu control check

Jeff LaBundy <jeff@labundy.com>
    Input: iqs7222 - protect against undefined slider size

Pin-yen Lin <treapking@chromium.org>
    drm/bridge: it6505: Initialize AUX channel in it6505_i2c_probe

Wang Yufen <wangyufen@huawei.com>
    selftests/bpf: fix missing BPF object files

Gerhard Engleder <gerhard@engleder-embedded.com>
    samples/bpf: Fix MAC address swapping in xdp2_kern

Gerhard Engleder <gerhard@engleder-embedded.com>
    samples/bpf: Fix map iteration in xdp1_user

Alexandru Tachici <alexandru.tachici@analog.com>
    net: ethernet: adi: adin1110: Fix SPI transfers

Sean Anderson <sean.anderson@seco.com>
    powerpc: dts: t208x: Mark MAC1 and MAC2 as 10G

Rafael Mendonca <rafaelmendsr@gmail.com>
    drm/amdgpu/powerplay/psm: Fix memory leak in power state init

Asher Song <Asher.Song@amd.com>
    drm/amdgpu: Revert "drm/amdgpu: getting fan speed pwm for vega10 properly"

Andrew Jeffery <andrew@aj.id.au>
    ipmi: kcs: Poll OBF briefly to reduce OBE latency

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Fix potential RX buffer overflow

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Fix DMA mask assignment

Yang Yingliang <yangyingliang@huawei.com>
    pinctrl: ocelot: add missing destroy_workqueue() in error path in ocelot_pinctrl_probe()

Niklas Cassel <niklas.cassel@wdc.com>
    ata: libata: fix NCQ autosense logic

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    drm: lcdif: Switch to limited range for RGB to YUV conversion

Shung-Hsi Yu <shung-hsi.yu@suse.com>
    libbpf: Fix null-pointer dereference in find_prog_by_sec_insn()

Shung-Hsi Yu <shung-hsi.yu@suse.com>
    libbpf: Deal with section with no data gracefully

Shung-Hsi Yu <shung-hsi.yu@suse.com>
    libbpf: Use elf_getshdrnum() instead of e_shnum

Xu Kuohai <xukuohai@huawei.com>
    selftest/bpf: Fix error usage of ASSERT_OK in xdp_adjust_tail.c

Xu Kuohai <xukuohai@huawei.com>
    selftests/bpf: Fix error failure of case test_xdp_adjust_tail_grow

Xu Kuohai <xukuohai@huawei.com>
    selftest/bpf: Fix memory leak in kprobe_multi_test

Xu Kuohai <xukuohai@huawei.com>
    selftests/bpf: Fix memory leak caused by not destroying skeleton

Xu Kuohai <xukuohai@huawei.com>
    libbpf: Fix memory leak in parse_usdt_arg()

Xu Kuohai <xukuohai@huawei.com>
    libbpf: Fix use-after-free in btf_dump_name_dups

Abhinav Kumar <quic_abhinavk@quicinc.com>
    drm/bridge: adv7533: remove dynamic lane switching from adv7533 bridge

Aditya Kumar Singh <quic_adisi@quicinc.com>
    wifi: ath11k: fix firmware assert during bandwidth change for peer sta

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtl8xxxu: Fix reading the vendor of combo chips

Fedor Pchelkin <pchelkin@ispras.ru>
    wifi: ath9k: hif_usb: Fix use-after-free in ath9k_hif_usb_reg_in_cb()

Fedor Pchelkin <pchelkin@ispras.ru>
    wifi: ath9k: hif_usb: fix memory leak of urbs in ath9k_hif_usb_dealloc_tx_urbs()

Thomas Zimmermann <tzimmermann@suse.de>
    drm/atomic-helper: Don't allocate new plane state in CRTC check

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: fix ifdef symbol name

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: check link ID in auth/assoc continuation

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: mlme: fix null-ptr deref on failed assoc

Johannes Berg <johannes.berg@intel.com>
    wifi: fix multi-link element subelement iteration

Jiri Olsa <jolsa@kernel.org>
    selftests/bpf: Add missing bpf_iter_vma_offset__destroy call

James Hurley <jahurley@nvidia.com>
    platform/mellanox: mlxbf-pmc: Fix event typo

Zhengchao Shao <shaozhengchao@huawei.com>
    ipc: fix memory leak in init_mqueue_fs()

Cai Xinchen <caixinchen1@huawei.com>
    rapidio: devices: fix missing put_device in mport_cdev_open

ZhangPeng <zhangpeng362@huawei.com>
    hfs: Fix OOB Write in hfs_asc2mac

Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
    relay: fix type mismatch when allocating memory in relay_create_buf()

Zhang Qilong <zhangqilong3@huawei.com>
    eventfd: change int to __u64 in eventfd_signal() ifndef CONFIG_EVENTFD

Wang Weiyang <wangweiyang2@huawei.com>
    rapidio: fix possible UAF when kfifo_alloc() fails

Chen Zhongjin <chenzhongjin@huawei.com>
    fs: sysv: Fix sysv_nblocks() returns wrong value

Brian Foster <bfoster@redhat.com>
    NFSD: pass range end to vfs_fsync_range() instead of count

Jeff Layton <jlayton@kernel.org>
    nfsd: return error if nfs4_setacl fails

Trond Myklebust <trond.myklebust@hammerspace.com>
    lockd: set other missing fields when unlocking files

Ladislav Michl <ladis@linux-mips.org>
    MIPS: OCTEON: warn only once if deprecated link status is being used

Anastasia Belova <abelova@astralinux.ru>
    MIPS: BCM63xx: Add check for NULL for clk in clk_enable

Yang Yingliang <yangyingliang@huawei.com>
    platform/x86: intel_scu_ipc: fix possible name leak in __intel_scu_ipc_register()

Yu Liao <liaoyu15@huawei.com>
    platform/x86: mxm-wmi: fix memleak in mxm_wmi_call_mx[ds|mx]()

Victor Ding <victording@chromium.org>
    platform/chrome: cros_ec_typec: zero out stale pointers

Gao Xiang <xiang@kernel.org>
    erofs: validate the extent length for uncompressed pclusters

Gao Xiang <xiang@kernel.org>
    erofs: fix missing unmap if z_erofs_get_extent_compressedlen() fails

Chen Zhongjin <chenzhongjin@huawei.com>
    erofs: Fix pcluster memleak when its block address is zero

Hou Tao <houtao1@huawei.com>
    erofs: check the uniqueness of fsid in shared domain in advance

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: runtime: Do not call __rpm_callback() from rpm_idle()

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    xen/privcmd: Fix a possible warning in privcmd_ioctl_mmap_resource()

Xiu Jianfeng <xiujianfeng@huawei.com>
    x86/xen: Fix memory leak in xen_init_lock_cpu()

Xiu Jianfeng <xiujianfeng@huawei.com>
    x86/xen: Fix memory leak in xen_smp_intr_init{_pv}()

Oleg Nesterov <oleg@redhat.com>
    uprobes/x86: Allow to probe a NOP instruction with 0x66 prefix

Li Zetao <lizetao1@huawei.com>
    ACPICA: Fix use-after-free in acpi_ut_copy_ipackage_to_ipackage()

Yang Yingliang <yangyingliang@huawei.com>
    clocksource/drivers/timer-ti-dm: Fix missing clk_disable_unprepare in dmtimer_systimer_init_clock()

Tony Lindgren <tony@atomide.com>
    clocksource/drivers/timer-ti-dm: Fix warning for omap_timer_match

Vincent Donnefort <vdonnefort@google.com>
    cpu/hotplug: Do not bail-out in DYING/STARTING sections

Phil Auld <pauld@redhat.com>
    cpu/hotplug: Make target_store() a nop when target == state

Alexey Izbyshev <izbyshev@ispras.ru>
    futex: Resend potentially swallowed owner death notification

Wolfram Sang <wsa+renesas@sang-engineering.com>
    clocksource/drivers/sh_cmt: Access registers according to spec

Yang Yingliang <yangyingliang@huawei.com>
    rapidio: rio: fix possible name leak in rio_register_mport()

Yang Yingliang <yangyingliang@huawei.com>
    rapidio: fix possible name leaks when rio_add_device() fails

Li Zetao <ocfs2-devel@oss.oracle.com>
    ocfs2: fix memory leak in ocfs2_mount_volume()

Akinobu Mita <akinobu.mita@gmail.com>
    debugfs: fix error when writing negative value to atomic_t debugfs file

Akinobu Mita <akinobu.mita@gmail.com>
    lib/notifier-error-inject: fix error when writing -errno to debugfs file

Akinobu Mita <akinobu.mita@gmail.com>
    libfs: add DEFINE_SIMPLE_ATTRIBUTE_SIGNED for signed value

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    cpufreq: amd_freq_sensitivity: Add missing pci_dev_put()

Yang Yingliang <yangyingliang@huawei.com>
    genirq/irqdesc: Don't try to remove non-existing sysfs files

Jeff Layton <jlayton@kernel.org>
    nfsd: don't call nfsd_file_put from client states seqfile display

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Finish converting the NFSv3 GETACL result encoder

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Finish converting the NFSv2 GETACL result encoder

Yang Yingliang <yangyingliang@huawei.com>
    EDAC/i10nm: fix refcount leak in pci_get_dev_wrapper()

Liu Peibao <liupeibao@loongson.cn>
    irqchip/loongson-liointc: Fix improper error handling in liointc_init()

Wei Yongjun <weiyongjun1@huawei.com>
    irqchip/wpcm450: Fix memory leak in wpcm450_aic_of_init()

Shang XiaoJing <shangxiaojing@huawei.com>
    irqchip: gic-pm: Use pm_runtime_resume_and_get() in gic_probe()

Jianmin Lv <lvjianmin@loongson.cn>
    irqchip/loongson-pch-pic: Fix translate callback for DT path

Yang Yingliang <yangyingliang@huawei.com>
    thermal: core: fix some possible name leaks in error paths

Yuan Can <yuancan@huawei.com>
    platform/chrome: cros_usbpd_notify: Fix error handling in cros_usbpd_notify_init()

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    perf/x86/intel/uncore: Fix reference count leak in __uncore_imc_init_box()

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    perf/x86/intel/uncore: Fix reference count leak in snr_uncore_mmio_map()

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    perf/x86/intel/uncore: Fix reference count leak in hswep_has_limit_sbox()

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    perf/x86/intel/uncore: Fix reference count leak in sad_cfg_iio_topology()

Wang ShaoBo <bobo.shaobowang@huawei.com>
    ACPI: pfr_update: use ACPI_FREE() to free acpi_object

Wang ShaoBo <bobo.shaobowang@huawei.com>
    ACPI: pfr_telemetry: use ACPI_FREE() to free acpi_object

Huisong Li <lihuisong@huawei.com>
    mailbox: pcc: Reset pcc_chan_count to zero in case of PCC probe failure

Yang Yingliang <yangyingliang@huawei.com>
    PNP: fix name memory leak in pnp_alloc_dev()

Zhao Gongyi <zhaogongyi@huawei.com>
    selftests/efivarfs: Add checking of the test return value

Yang Yingliang <yangyingliang@huawei.com>
    MIPS: vpe-cmp: fix possible memory leak while module exiting

Yang Yingliang <yangyingliang@huawei.com>
    MIPS: vpe-mt: fix possible memory leak while module exiting

Manivannan Sadhasivam <mani@kernel.org>
    cpufreq: qcom-hw: Fix the frequency returned by cpufreq_driver->get()

YueHaibing <yuehaibing@huawei.com>
    selftests: cgroup: fix unsigned comparison with less than zero

Shang XiaoJing <shangxiaojing@huawei.com>
    ocfs2: fix memory leak in ocfs2_stack_glue_init()

Gaosheng Cui <cuigaosheng1@huawei.com>
    lib/fonts: fix undefined behavior in bit shift for get_default_font

Alexey Dobriyan <adobriyan@gmail.com>
    proc: fixup uptime selftest

Barnabás Pőcze <pobrn@protonmail.com>
    timerqueue: Use rb_entry_safe() in timerqueue_getnext()

Barnabás Pőcze <pobrn@protonmail.com>
    platform/x86: huawei-wmi: fix return value calculation

wuchi <wuchi.zero@gmail.com>
    lib/debugobjects: fix stat count and optimize debug_objects_mem_init

Chen Zhongjin <chenzhongjin@huawei.com>
    perf: Fix possible memleak in pmu_dev_alloc()

Yipeng Zou <zouyipeng@huawei.com>
    selftests/ftrace: event_triggers: wait longer for test_event_enable

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    ACPI: irq: Fix some kernel-doc issues

Guilherme G. Piccoli <gpiccoli@igalia.com>
    x86/split_lock: Add sysctl to control the misery mode

Chen Hui <judy.chenhui@huawei.com>
    cpufreq: qcom-hw: Fix memory leak in qcom_cpufreq_hw_read_lut()

Ondrej Mosnacek <omosnace@redhat.com>
    fs: don't audit the capability check in simple_xattr_list()

xiongxin <xiongxin@kylinos.cn>
    PM: hibernate: Fix mistake in kerneldoc comment

Reinette Chatre <reinette.chatre@intel.com>
    x86/sgx: Reduce delay and interference of enclave release

Hao Lee <haolee.swjtu@gmail.com>
    sched/psi: Fix possible missing or delayed pending event

Al Viro <viro@zeniv.linux.org.uk>
    alpha: fix syscall entry in !AUDUT_SYSCALL case

Al Viro <viro@zeniv.linux.org.uk>
    alpha: fix TIF_NOTIFY_SIGNAL handling

Ulf Hansson <ulf.hansson@linaro.org>
    cpuidle: dt: Return the correct numbers of parsed idle states

Qais Yousef <qyousef@layalina.io>
    sched/uclamp: Cater for uclamp in find_energy_efficient_cpu()'s early exit condition

Qais Yousef <qyousef@layalina.io>
    sched/uclamp: Make cpu_overutilized() use util_fits_cpu()

Qais Yousef <qyousef@layalina.io>
    sched/uclamp: Make asym_fits_capacity() use util_fits_cpu()

Qais Yousef <qyousef@layalina.io>
    sched/uclamp: Make select_idle_capacity() use util_fits_cpu()

Qais Yousef <qyousef@layalina.io>
    sched/uclamp: Fix fits_capacity() check in feec()

Qais Yousef <qyousef@layalina.io>
    sched/uclamp: Make task_fits_capacity() use util_fits_cpu()

Qais Yousef <qyousef@layalina.io>
    sched/uclamp: Fix relationship between uclamp and migration margin

Amir Goldstein <amir73il@gmail.com>
    ovl: remove privs in ovl_fallocate()

Amir Goldstein <amir73il@gmail.com>
    ovl: remove privs in ovl_copyfile()

Michael Kelley <mikelley@microsoft.com>
    tpm/tpm_crb: Fix error message in __crb_relinquish_locality()

Yuan Can <yuancan@huawei.com>
    tpm/tpm_ftpm_tee: Fix error handling in ftpm_mod_init()

Eddie James <eajames@linux.ibm.com>
    tpm: Add flag to use default cancellation policy

Eddie James <eajames@linux.ibm.com>
    tpm: tis_i2c: Fix sanity check interrupt enable mask

Janne Grunau <j@jannau.net>
    arch: arm64: apple: t8103: Use standard "iommu" node name

Stephen Boyd <swboyd@chromium.org>
    pstore: Avoid kcore oops by vmap()ing with VM_IOREMAP

Doug Brown <doug@schmorgal.com>
    ARM: mmp: fix timer_read delay

Wang Yufen <wangyufen@huawei.com>
    pstore/ram: Fix error return code in ramoops_probe()

Kuniyuki Iwashima <kuniyu@amazon.com>
    seccomp: Move copy_seccomp() to no failure path.

Yicong Yang <yangyicong@hisilicon.com>
    drivers/perf: hisi: Fix some event id for hisi-pcie-pmu

Sven Peter <sven@svenpeter.dev>
    soc: apple: rtkit: Stop casting function pointer signatures

Sven Peter <sven@svenpeter.dev>
    soc: apple: sart: Stop casting function pointer signatures

Pali Rohár <pali@kernel.org>
    arm64: dts: armada-3720-turris-mox: Add missing interrupt for RTC

Pali Rohár <pali@kernel.org>
    ARM: dts: armada-39x: Fix compatible string for gpios

Pali Rohár <pali@kernel.org>
    ARM: dts: armada-38x: Fix compatible string for gpios

Pali Rohár <pali@kernel.org>
    ARM: dts: turris-omnia: Add switch port 6 node

Pali Rohár <pali@kernel.org>
    ARM: dts: turris-omnia: Add ethernet aliases

Pali Rohár <pali@kernel.org>
    ARM: dts: armada-39x: Fix assigned-addresses for every PCIe Root Port

Pali Rohár <pali@kernel.org>
    ARM: dts: armada-38x: Fix assigned-addresses for every PCIe Root Port

Pali Rohár <pali@kernel.org>
    ARM: dts: armada-375: Fix assigned-addresses for every PCIe Root Port

Pali Rohár <pali@kernel.org>
    ARM: dts: armada-xp: Fix assigned-addresses for every PCIe Root Port

Pali Rohár <pali@kernel.org>
    ARM: dts: armada-370: Fix assigned-addresses for every PCIe Root Port

Pali Rohár <pali@kernel.org>
    ARM: dts: dove: Fix assigned-addresses for every PCIe Root Port

Frank Wunderlich <frank-w@public-files.de>
    arm64: dts: mt7986: move wed_pcie node

Vidya Sagar <vidyas@nvidia.com>
    arm64: tegra: Fix non-prefetchable aperture of PCIe C3 controller

Vidya Sagar <vidyas@nvidia.com>
    arm64: tegra: Fix Prefetchable aperture ranges of Tegra234 PCIe controllers

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mediatek: mt6797: Fix 26M oscillator unit name

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mediatek: pumpkin-common: Fix devicetree warnings

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mt2712-evb: Fix usb vbus regulators unit names

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mt2712-evb: Fix vproc fixed regulators unit names

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mt2712e: Fix unit address for pinctrl node

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mt2712e: Fix unit_address_vs_reg warning for oscillators

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mt6779: Fix devicetree build warnings

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mt7896a: Fix unit_address_vs_reg warning for oscillator

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mediatek: mt8195: Fix CPUs capacity-dmips-mhz

Jonathan Neuschäfer <j.neuschaefer@gmx.net>
    ARM: dts: nuvoton: Remove bogus unit addresses from fixed-partition nodes

Conor Dooley <conor.dooley@microchip.com>
    riscv: dts: microchip: remove pcie node from the sev kit

Keerthy <j-keerthy@ti.com>
    arm64: dts: ti: k3-j721s2: Fix the interrupt ranges property for main & wkup gpio intr

Jayesh Choudhary <j-choudhary@ti.com>
    arm64: dts: ti: k3-j7200-mcu-wakeup: Drop dma-coherent in crypto node

Jayesh Choudhary <j-choudhary@ti.com>
    arm64: dts: ti: k3-j721e-main: Drop dma-coherent in crypto node

Jayesh Choudhary <j-choudhary@ti.com>
    arm64: dts: ti: k3-am65-main: Drop dma-coherent in crypto node

Shang XiaoJing <shangxiaojing@huawei.com>
    perf/smmuv3: Fix hotplug callback leak in arm_smmu_pmu_init()

Shang XiaoJing <shangxiaojing@huawei.com>
    perf/arm_dmc620: Fix hotplug callback leak in dmc620_pmu_init()

Yuan Can <yuancan@huawei.com>
    drivers: perf: marvell_cn10k: Fix hotplug callback leak in tad_pmu_init()

Yuan Can <yuancan@huawei.com>
    perf: arm_dsu: Fix hotplug callback leak in dsu_pmu_init()

Mark Rutland <mark.rutland@arm.com>
    arm64: mm: kfence: only handle translation faults

Zhang Qilong <zhangqilong3@huawei.com>
    soc: ti: smartreflex: Fix PM disable depth imbalance in omap_sr_probe

Zhang Qilong <zhangqilong3@huawei.com>
    soc: ti: knav_qmss_queue: Fix PM disable depth imbalance in knav_queue_probe

Conor Dooley <conor.dooley@microchip.com>
    riscv: dts: microchip: fix the icicle's #pwm-cells

Kory Maincent <kory.maincent@bootlin.com>
    arm: dts: spear600: Fix clcd interrupt

Sibi Sankar <quic_sibis@quicinc.com>
    arm64: dts: qcom: sc7280: Mark all Qualcomm reference boards as LTE

Sumit Gupta <sumitg@nvidia.com>
    soc/tegra: cbb: Check firewall before enabling error reporting

Sumit Gupta <sumitg@nvidia.com>
    soc/tegra: cbb: Add checks for potential out of bound errors

Sumit Gupta <sumitg@nvidia.com>
    soc/tegra: cbb: Update slave maps for Tegra234

Sumit Gupta <sumitg@nvidia.com>
    soc/tegra: cbb: Use correct master_id mask for CBB NOC in Tegra194

Frank Wunderlich <frank-w@public-files.de>
    arm64: dts: mt7986: fix trng node name

Yang Yingliang <yangyingliang@huawei.com>
    soc: sifive: ccache: fix missing of_node_put() in sifive_ccache_init()

Yang Yingliang <yangyingliang@huawei.com>
    soc: sifive: ccache: fix missing free_irq() in error path in sifive_ccache_init()

Yang Yingliang <yangyingliang@huawei.com>
    soc: sifive: ccache: fix missing iounmap() in error path in sifive_ccache_init()

Conor Dooley <conor.dooley@microchip.com>
    dt-bindings: pwm: fix microchip corePWM's pwm-cells

Fabrizio Castro <fabrizio.castro.jz@renesas.com>
    arm64: dts: renesas: r9a09g011: Fix I2C SoC specific strings

Fabrizio Castro <fabrizio.castro.jz@renesas.com>
    arm64: dts: renesas: r9a09g011: Fix unit address format error

Wolfram Sang <wsa+renesas@sang-engineering.com>
    arm64: dts: renesas: r8a779f0: Fix SCIF "brg_int" clock

Wolfram Sang <wsa+renesas@sang-engineering.com>
    arm64: dts: renesas: r8a779f0: Fix HSCIF "brg_int" clock

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm6125: fix SDHCI CQE reg names

Marijn Suijten <marijn.suijten@somainline.org>
    arm64: dts: qcom: pm6350: Include header for KEY_POWER

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    soc: qcom: apr: Add check for idr_alloc and of_property_read_string_index

Johan Hovold <johan+linaro@kernel.org>
    arm64: dts: qcom: sm6350: drop bogus DP PHY clock

Johan Hovold <johan+linaro@kernel.org>
    arm64: dts: qcom: sm8250: drop bogus DP PHY clock

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    arm64: dts: qcom: sc7280: fix codec reset line polarity for CRD 1.0/2.0

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    arm64: dts: qcom: sc7280: fix codec reset line polarity for CRD 3.0/3.1

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    arm64: dts: qcom: sm8250-mtp: fix reset line polarity

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    arm64: dts: qcom: msm8996: fix sound card reset line polarity

Johan Hovold <johan+linaro@kernel.org>
    arm64: dts: qcom: sm8450: fix UFS PHY registers

Johan Hovold <johan+linaro@kernel.org>
    arm64: dts: qcom: sm8350: fix UFS PHY registers

Johan Hovold <johan+linaro@kernel.org>
    arm64: dts: qcom: sm8250: fix UFS PHY registers

Johan Hovold <johan+linaro@kernel.org>
    arm64: dts: qcom: sm8150: fix UFS PHY registers

Luca Weiss <luca.weiss@fairphone.com>
    soc: qcom: llcc: make irq truly optional

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sc7180-trogdor-homestar: fully configure secondary I2S pins

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm8250: correct LPASS pin pull down

Marijn Suijten <marijn.suijten@somainline.org>
    arm64: dts: qcom: pm660: Use unique ADC5_VCOIN address in node name

Conor Dooley <conor.dooley@microchip.com>
    riscv: dts: microchip: fix memory node unit address for icicle

Georgi Vlaev <g-vlaev@ti.com>
    firmware: ti_sci: Fix polled mode during system suspend

Chen Jiahao <chenjiahao16@huawei.com>
    drivers: soc: ti: knav_qmss_queue: Mark knav_acc_firmwares as static

Marek Vasut <marex@denx.de>
    ARM: dts: stm32: Fix AV96 WLAN regulator gpio property

Marek Vasut <marex@denx.de>
    ARM: dts: stm32: Drop stm32mp15xc.dtsi from Avenger96

Marco Elver <elver@google.com>
    objtool, kcsan: Add volatile read/write instrumentation to whitelist

Cong Dang <cong.dang.xn@renesas.com>
    memory: renesas-rpc-if: Clear HS bit during hardware initialization

Padmanabhan Rajanbabu <p.rajanbabu@samsung.com>
    arm64: dts: fsd: fix drive strength values as per FSD HW UM

Padmanabhan Rajanbabu <p.rajanbabu@samsung.com>
    arm64: dts: fsd: fix drive strength macros as per FSD HW UM

Stephan Gerhold <stephan.gerhold@kernkonzept.com>
    arm64: dts: qcom: msm8916: Drop MSS fallback compatible

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sdm845-cheza: fix AP suspend pin bias

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sdm630: fix UART1 pin bias

Luca Weiss <luca@z3ntu.xyz>
    ARM: dts: qcom: apq8064: fix coresight compatible

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: msm8996: fix GPU OPP table

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: msm8996: fix supported-hw in cpufreq OPP tables

Yassine Oudjana <y.oudjana@protonmail.com>
    arm64: dts: qcom: msm8996: Add MSM8996 Pro support

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sdm845-xiaomi-polaris: fix codec pin conf name

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm8250-sony-xperia-edo: fix touchscreen bias-disable

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: ipq6018-cp01-c1: use BLSPI1 pins

Geert Uytterhoeven <geert+renesas@glider.be>
    arm64: dts: renesas: r8a779g0: Fix HSCIF0 "brg_int" clock

Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
    usb: musb: remove extra check in musb_gadget_vbus_draw

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    MIPS: DTS: CI20: fix reset line polarity of the ethernet controller


-------------

Diffstat:

 Documentation/ABI/stable/sysfs-driver-dma-idxd     |  12 +
 .../ABI/testing/sysfs-bus-spi-devices-spi-nor      |   3 +
 Documentation/admin-guide/sysctl/kernel.rst        |  23 +
 .../devicetree/bindings/input/azoteq,iqs7222.yaml  |  25 +-
 .../devicetree/bindings/mfd/qcom,spmi-pmic.yaml    |   8 +-
 .../devicetree/bindings/pci/fsl,imx6q-pcie.yaml    |  46 +-
 .../bindings/pci/toshiba,visconti-pcie.yaml        |   7 +-
 .../bindings/pinctrl/mediatek,mt7986-pinctrl.yaml  |  46 +-
 .../devicetree/bindings/pwm/microchip,corepwm.yaml |   4 +-
 .../devicetree/bindings/sound/qcom,wcd9335.txt     |   2 +-
 Documentation/devicetree/bindings/sound/rt5682.txt |   2 +-
 Documentation/driver-api/spi.rst                   |   4 +-
 Documentation/fault-injection/fault-injection.rst  |  10 +-
 Makefile                                           |   4 +-
 arch/Kconfig                                       |   2 +-
 arch/alpha/include/asm/thread_info.h               |   2 +-
 arch/alpha/kernel/entry.S                          |   4 +-
 arch/arm/boot/dts/armada-370.dtsi                  |   2 +-
 arch/arm/boot/dts/armada-375.dtsi                  |   2 +-
 arch/arm/boot/dts/armada-380.dtsi                  |   4 +-
 arch/arm/boot/dts/armada-385-turris-omnia.dts      |  18 +-
 arch/arm/boot/dts/armada-385.dtsi                  |   6 +-
 arch/arm/boot/dts/armada-38x.dtsi                  |   4 +-
 arch/arm/boot/dts/armada-39x.dtsi                  |  10 +-
 arch/arm/boot/dts/armada-xp-mv78230.dtsi           |   8 +-
 arch/arm/boot/dts/armada-xp-mv78260.dtsi           |  16 +-
 arch/arm/boot/dts/aspeed-bmc-ibm-everest.dts       |  17 +-
 arch/arm/boot/dts/aspeed-bmc-ibm-rainier.dts       |  16 +-
 arch/arm/boot/dts/dove.dtsi                        |   2 +-
 arch/arm/boot/dts/nuvoton-npcm730-gbs.dts          |   2 +-
 arch/arm/boot/dts/nuvoton-npcm730-gsj.dts          |   2 +-
 arch/arm/boot/dts/nuvoton-npcm730-kudo.dts         |   6 +-
 arch/arm/boot/dts/nuvoton-npcm750-evb.dts          |   4 +-
 .../boot/dts/nuvoton-npcm750-runbmc-olympus.dts    |   6 +-
 arch/arm/boot/dts/qcom-apq8064.dtsi                |   2 +-
 arch/arm/boot/dts/spear600.dtsi                    |   2 +-
 arch/arm/boot/dts/stm32mp157a-dhcor-avenger96.dts  |   1 -
 arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi |   2 +-
 arch/arm/mach-mmp/time.c                           |  11 +-
 arch/arm64/boot/dts/apple/t8103.dtsi               |   6 +-
 .../boot/dts/marvell/armada-3720-turris-mox.dts    |   3 +
 arch/arm64/boot/dts/mediatek/mt2712-evb.dts        |  12 +-
 arch/arm64/boot/dts/mediatek/mt2712e.dtsi          |  22 +-
 arch/arm64/boot/dts/mediatek/mt6779.dtsi           |   8 +-
 arch/arm64/boot/dts/mediatek/mt6797.dtsi           |   2 +-
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi          |  16 +-
 arch/arm64/boot/dts/mediatek/mt8183.dtsi           |   2 +-
 arch/arm64/boot/dts/mediatek/mt8195.dtsi           |   8 +-
 arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi   |   6 +-
 arch/arm64/boot/dts/nvidia/tegra234.dtsi           |   8 +-
 arch/arm64/boot/dts/qcom/ipq6018-cp01-c1.dts       |   2 +
 arch/arm64/boot/dts/qcom/msm8916.dtsi              |   2 +-
 arch/arm64/boot/dts/qcom/msm8996.dtsi              | 114 ++--
 arch/arm64/boot/dts/qcom/msm8996pro.dtsi           | 266 +++++++++
 arch/arm64/boot/dts/qcom/pm6350.dtsi               |   1 +
 arch/arm64/boot/dts/qcom/pm660.dtsi                |   2 +-
 .../boot/dts/qcom/sc7180-trogdor-homestar.dtsi     |   6 +
 arch/arm64/boot/dts/qcom/sc7280-idp.dts            |   1 -
 arch/arm64/boot/dts/qcom/sc7280-idp.dtsi           |   3 +-
 arch/arm64/boot/dts/qcom/sc7280-qcard.dtsi         |   2 +-
 arch/arm64/boot/dts/qcom/sdm630.dtsi               |   2 +-
 arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi         |   4 +-
 arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts |   2 +-
 arch/arm64/boot/dts/qcom/sm6125.dtsi               |   2 +-
 arch/arm64/boot/dts/qcom/sm6350.dtsi               |  10 +-
 arch/arm64/boot/dts/qcom/sm8150.dtsi               |  10 +-
 arch/arm64/boot/dts/qcom/sm8250-mtp.dts            |   2 +-
 .../boot/dts/qcom/sm8250-sony-xperia-edo.dtsi      |   2 +-
 arch/arm64/boot/dts/qcom/sm8250.dtsi               |  20 +-
 arch/arm64/boot/dts/qcom/sm8350.dtsi               |  10 +-
 .../dts/qcom/sm8450-sony-xperia-nagara-pdx223.dts  |   2 -
 arch/arm64/boot/dts/qcom/sm8450.dtsi               |  13 +-
 arch/arm64/boot/dts/renesas/r8a779f0.dtsi          |  16 +-
 arch/arm64/boot/dts/renesas/r8a779g0.dtsi          |   2 +-
 arch/arm64/boot/dts/renesas/r9a09g011.dtsi         |   6 +-
 arch/arm64/boot/dts/tesla/fsd-pinctrl.dtsi         |  34 +-
 arch/arm64/boot/dts/tesla/fsd-pinctrl.h            |   6 +-
 arch/arm64/boot/dts/ti/k3-am65-main.dtsi           |   1 -
 arch/arm64/boot/dts/ti/k3-j7200-mcu-wakeup.dtsi    |   1 -
 arch/arm64/boot/dts/ti/k3-j721e-main.dtsi          |   1 -
 arch/arm64/boot/dts/ti/k3-j721s2-main.dtsi         |   2 +-
 arch/arm64/boot/dts/ti/k3-j721s2-mcu-wakeup.dtsi   |   2 +-
 arch/arm64/crypto/Kconfig                          |  11 +
 arch/arm64/crypto/Makefile                         |   3 +
 arch/arm64/crypto/sm3-neon-core.S                  | 601 ++++++++++++++++++++
 arch/arm64/crypto/sm3-neon-glue.c                  | 103 ++++
 arch/arm64/include/asm/processor.h                 |   4 +-
 arch/arm64/mm/fault.c                              |   8 +-
 arch/mips/bcm63xx/clk.c                            |   2 +
 arch/mips/boot/dts/ingenic/ci20.dts                |   2 +-
 .../cavium-octeon/executive/cvmx-helper-board.c    |   2 +-
 arch/mips/cavium-octeon/executive/cvmx-helper.c    |   2 +-
 arch/mips/kernel/vpe-cmp.c                         |   4 +-
 arch/mips/kernel/vpe-mt.c                          |   4 +-
 arch/mips/ralink/of.c                              |   4 +-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi |  44 ++
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi |  44 ++
 arch/powerpc/boot/dts/fsl/t2081si-post.dtsi        |   4 +-
 arch/powerpc/boot/dts/turris1x.dts                 |  14 +
 arch/powerpc/include/asm/hvcall.h                  |   3 +-
 arch/powerpc/perf/callchain.c                      |   1 +
 arch/powerpc/perf/hv-gpci-requests.h               |   4 +
 arch/powerpc/perf/hv-gpci.c                        |  35 +-
 arch/powerpc/perf/hv-gpci.h                        |   1 +
 arch/powerpc/perf/req-gen/perf.h                   |  20 +
 arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c      |   1 +
 arch/powerpc/platforms/83xx/mpc832x_rdb.c          |   2 +-
 arch/powerpc/platforms/pseries/eeh_pseries.c       |  11 +-
 arch/powerpc/platforms/pseries/plpks.c             |  32 +-
 arch/powerpc/platforms/pseries/plpks.h             |   2 +-
 arch/powerpc/sysdev/xive/spapr.c                   |   1 +
 arch/powerpc/xmon/xmon.c                           |   7 +-
 .../boot/dts/microchip/mpfs-icicle-kit-fabric.dtsi |   2 +-
 arch/riscv/boot/dts/microchip/mpfs-icicle-kit.dts  |   2 +-
 .../boot/dts/microchip/mpfs-sev-kit-fabric.dtsi    |  29 -
 arch/riscv/include/asm/hugetlb.h                   |   6 +
 arch/riscv/include/asm/io.h                        |   5 +
 arch/riscv/include/asm/pgtable-64.h                |   6 +-
 arch/riscv/kernel/entry.S                          |  18 +-
 arch/riscv/kernel/signal.c                         |  34 +-
 arch/riscv/kernel/traps.c                          |   2 +-
 arch/riscv/kvm/vcpu.c                              |  11 +-
 arch/riscv/mm/physaddr.c                           |   2 +-
 arch/riscv/net/bpf_jit_comp64.c                    |  29 +-
 arch/x86/Kconfig                                   |   4 +-
 arch/x86/crypto/aegis128-aesni-asm.S               |   9 +-
 arch/x86/crypto/aria-aesni-avx-asm_64.S            |  13 +-
 arch/x86/crypto/sha1_ni_asm.S                      |   3 +-
 arch/x86/crypto/sha1_ssse3_asm.S                   |   3 +-
 arch/x86/crypto/sha256-avx-asm.S                   |   3 +-
 arch/x86/crypto/sha256-avx2-asm.S                  |   3 +-
 arch/x86/crypto/sha256-ssse3-asm.S                 |   3 +-
 arch/x86/crypto/sha256_ni_asm.S                    |   3 +-
 arch/x86/crypto/sha512-avx-asm.S                   |   3 +-
 arch/x86/crypto/sha512-avx2-asm.S                  |   3 +-
 arch/x86/crypto/sha512-ssse3-asm.S                 |   3 +-
 arch/x86/crypto/sm3-avx-asm_64.S                   |   3 +-
 arch/x86/crypto/sm4-aesni-avx-asm_64.S             |   7 +-
 arch/x86/crypto/sm4-aesni-avx2-asm_64.S            |   7 +-
 arch/x86/events/intel/uncore_snb.c                 |   3 +
 arch/x86/events/intel/uncore_snbep.c               |   5 +
 arch/x86/hyperv/hv_init.c                          |   2 -
 arch/x86/include/asm/apic.h                        |   3 +-
 arch/x86/include/asm/realmode.h                    |   1 +
 arch/x86/include/asm/x86_init.h                    |   4 +
 arch/x86/kernel/apic/apic.c                        |  13 +-
 arch/x86/kernel/cpu/intel.c                        |  63 ++-
 arch/x86/kernel/cpu/sgx/encl.c                     |  23 +-
 arch/x86/kernel/setup.c                            |   2 +-
 arch/x86/kernel/uprobes.c                          |   4 +-
 arch/x86/kernel/x86_init.c                         |   3 +
 arch/x86/realmode/init.c                           |   8 +-
 arch/x86/xen/enlighten_pv.c                        |   2 +
 arch/x86/xen/smp.c                                 |  24 +-
 arch/x86/xen/smp_pv.c                              |  12 +-
 arch/x86/xen/spinlock.c                            |   6 +-
 block/bfq-iosched.c                                |  16 +-
 block/blk-cgroup.c                                 |   2 +
 block/blk-core.c                                   |  72 +--
 block/blk-crypto-internal.h                        |  10 +-
 block/blk-crypto-sysfs.c                           |  11 +-
 block/blk-ia-ranges.c                              |   3 +-
 block/blk-mq-sysfs.c                               |  11 +-
 block/blk-mq.c                                     |  89 ++-
 block/blk-mq.h                                     |  14 +-
 block/blk-sysfs.c                                  | 134 ++---
 block/blk.h                                        |  13 +-
 block/bsg.c                                        |  11 +-
 block/elevator.c                                   |   2 +-
 block/genhd.c                                      |   4 +-
 crypto/cryptd.c                                    |  36 +-
 crypto/tcrypt.c                                    | 265 +++++----
 drivers/acpi/acpica/dsmethod.c                     |  10 +-
 drivers/acpi/acpica/utcopy.c                       |   7 -
 drivers/acpi/ec.c                                  |  10 +
 drivers/acpi/irq.c                                 |   5 +-
 drivers/acpi/pfr_telemetry.c                       |   6 +-
 drivers/acpi/pfr_update.c                          |   6 +-
 drivers/acpi/processor_idle.c                      |   3 +
 drivers/acpi/video_detect.c                        |  54 +-
 drivers/acpi/x86/utils.c                           |  24 +-
 drivers/ata/libata-sata.c                          |  11 +-
 drivers/base/class.c                               |   5 +
 drivers/base/power/runtime.c                       |  12 +-
 drivers/base/regmap/regmap-irq.c                   |  15 +-
 drivers/block/drbd/drbd_main.c                     |   9 +-
 drivers/block/drbd/drbd_nl.c                       |  10 +-
 drivers/block/floppy.c                             |   4 +-
 drivers/block/loop.c                               |  28 +-
 drivers/bluetooth/btintel.c                        |   5 +-
 drivers/bluetooth/btusb.c                          |   6 +-
 drivers/bluetooth/hci_bcm.c                        |  13 +-
 drivers/bluetooth/hci_bcsp.c                       |   2 +-
 drivers/bluetooth/hci_h5.c                         |   2 +-
 drivers/bluetooth/hci_ll.c                         |   2 +-
 drivers/bluetooth/hci_qca.c                        |   2 +-
 drivers/char/hw_random/amd-rng.c                   |  18 +-
 drivers/char/hw_random/geode-rng.c                 |  36 +-
 drivers/char/ipmi/ipmi_msghandler.c                |   8 +-
 drivers/char/ipmi/kcs_bmc_aspeed.c                 |  24 +-
 drivers/char/tpm/tpm_crb.c                         |   2 +-
 drivers/char/tpm/tpm_ftpm_tee.c                    |   8 +-
 drivers/char/tpm/tpm_tis_core.c                    |  20 +-
 drivers/char/tpm/tpm_tis_core.h                    |   1 +
 drivers/char/tpm/tpm_tis_i2c.c                     |   3 +-
 drivers/clk/imx/clk-imx8mn.c                       | 116 ++--
 drivers/clk/imx/clk-imx8mp.c                       |   4 +-
 drivers/clk/imx/clk-imx93.c                        |  19 +-
 drivers/clk/imx/clk-imxrt1050.c                    |   2 +-
 drivers/clk/mediatek/clk-mt7986-infracfg.c         |   2 +-
 drivers/clk/microchip/clk-mpfs-ccc.c               |   6 +
 drivers/clk/qcom/clk-krait.c                       |   2 +
 drivers/clk/qcom/dispcc-sm6350.c                   |   4 +-
 drivers/clk/qcom/gcc-ipq806x.c                     |   4 +-
 drivers/clk/qcom/gcc-sm8250.c                      |   4 +-
 drivers/clk/qcom/lpassaudiocc-sc7280.c             |  55 +-
 drivers/clk/qcom/lpasscorecc-sc7180.c              |  24 +-
 drivers/clk/renesas/r8a779a0-cpg-mssr.c            |   2 +-
 drivers/clk/renesas/r8a779f0-cpg-mssr.c            |  18 +-
 drivers/clk/renesas/r9a06g032-clocks.c             |   3 +-
 drivers/clk/rockchip/clk-pll.c                     |   1 +
 drivers/clk/samsung/clk-pll.c                      |   1 +
 drivers/clk/socfpga/clk-gate.c                     |   5 +-
 drivers/clk/st/clkgen-fsyn.c                       |   5 +-
 drivers/clk/visconti/pll.c                         |   1 +
 drivers/clocksource/sh_cmt.c                       |  88 +--
 drivers/clocksource/timer-ti-dm-systimer.c         |   4 +-
 drivers/clocksource/timer-ti-dm.c                  |   2 +-
 drivers/counter/stm32-lptimer-cnt.c                |   2 +-
 drivers/cpufreq/amd_freq_sensitivity.c             |   2 +
 drivers/cpufreq/qcom-cpufreq-hw.c                  |  43 +-
 drivers/cpuidle/dt_idle_states.c                   |   2 +-
 drivers/crypto/Kconfig                             |   5 +
 .../crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c    |   2 +-
 drivers/crypto/amlogic/amlogic-gxl-core.c          |   1 -
 drivers/crypto/amlogic/amlogic-gxl.h               |   2 +-
 drivers/crypto/cavium/nitrox/nitrox_mbx.c          |   1 +
 drivers/crypto/ccree/cc_debugfs.c                  |   2 +-
 drivers/crypto/ccree/cc_driver.c                   |  10 +-
 drivers/crypto/hisilicon/hpre/hpre_main.c          |  10 +-
 drivers/crypto/hisilicon/qm.c                      |  11 +-
 drivers/crypto/img-hash.c                          |   8 +-
 drivers/crypto/omap-sham.c                         |   2 +-
 drivers/crypto/qat/qat_4xxx/adf_drv.c              |   1 +
 drivers/crypto/rockchip/rk3288_crypto.c            | 193 +------
 drivers/crypto/rockchip/rk3288_crypto.h            |  53 +-
 drivers/crypto/rockchip/rk3288_crypto_ahash.c      | 197 ++++---
 drivers/crypto/rockchip/rk3288_crypto_skcipher.c   | 413 ++++++++------
 drivers/dio/dio.c                                  |   8 +
 drivers/dma/apple-admac.c                          | 102 +++-
 drivers/dma/idxd/sysfs.c                           |  68 +++
 drivers/edac/i10nm_base.c                          |   3 +-
 drivers/extcon/extcon-usbc-tusb320.c               |  17 +-
 drivers/firmware/raspberrypi.c                     |   1 +
 drivers/firmware/ti_sci.c                          |   5 +-
 drivers/gpio/gpiolib-cdev.c                        | 204 ++++++-
 drivers/gpio/gpiolib.c                             |   4 +
 drivers/gpio/gpiolib.h                             |   5 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c           |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   9 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h           |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c           |   2 -
 drivers/gpu/drm/amd/amdgpu/nv.c                    |  28 +-
 drivers/gpu/drm/amd/amdgpu/soc15.c                 |  24 +-
 drivers/gpu/drm/amd/amdgpu/soc21.c                 |   2 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c  |  35 --
 drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c |  16 +-
 .../amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c   |   2 +-
 drivers/gpu/drm/amd/display/dc/core/dc.c           |  65 ++-
 .../gpu/drm/amd/display/dc/dce60/dce60_resource.c  |   3 +
 .../gpu/drm/amd/display/dc/dce80/dce80_resource.c  |   2 +
 .../drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c  |  30 +-
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c |  35 +-
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dccg.c  |   6 +-
 .../gpu/drm/amd/display/dc/dcn32/dcn32_resource.c  |   2 +-
 .../gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c   |   7 +
 drivers/gpu/drm/amd/include/kgd_pp_interface.h     |   3 +-
 drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c   |   3 +-
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/pp_psm.c    |   2 +
 .../drm/amd/pm/powerplay/hwmgr/vega10_thermal.c    |  25 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c  |   3 +-
 drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c     |   4 +
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c   |  21 +-
 drivers/gpu/drm/bridge/adv7511/adv7511.h           |   3 +-
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c       |  18 +-
 drivers/gpu/drm/bridge/adv7511/adv7533.c           |  25 +-
 drivers/gpu/drm/bridge/ite-it6505.c                |   8 +-
 drivers/gpu/drm/drm_atomic_helper.c                |  10 +-
 drivers/gpu/drm/drm_edid.c                         |  12 +
 drivers/gpu/drm/drm_fourcc.c                       |   8 +-
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c              |  11 +-
 drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_rgb.c          |   5 +-
 drivers/gpu/drm/i915/display/intel_bios.c          |   2 +-
 drivers/gpu/drm/i915/display/intel_dp.c            |  59 --
 drivers/gpu/drm/i915/gem/i915_gem_mman.c           |  21 +-
 drivers/gpu/drm/i915/gem/i915_gem_pm.c             |   2 +-
 drivers/gpu/drm/i915/gem/i915_gem_ttm.c            |  63 ++-
 drivers/gpu/drm/i915/gem/i915_gem_ttm.h            |  18 +-
 drivers/gpu/drm/i915/gem/i915_gem_ttm_move.c       |   2 +-
 drivers/gpu/drm/i915/gt/intel_engine.h             |   6 +
 drivers/gpu/drm/i915/gt/intel_engine_cs.c          |  91 ++-
 drivers/gpu/drm/i915/gt/intel_gt.c                 |   3 -
 drivers/gpu/drm/i915/gt/intel_gt_types.h           |  17 -
 drivers/gpu/drm/i915/gt/sysfs_engines.c            |  25 +-
 drivers/gpu/drm/i915/gt/uc/intel_guc_capture.c     | 109 +++-
 drivers/gpu/drm/i915/gt/uc/intel_guc_fwif.h        |  21 +
 drivers/gpu/drm/i915/gt/uc/intel_guc_log.c         |   6 +-
 drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c  |   8 +
 drivers/gpu/drm/i915/i915_driver.c                 |   3 +-
 drivers/gpu/drm/i915/i915_gem.c                    |  45 +-
 drivers/gpu/drm/i915/intel_runtime_pm.c            |   5 +
 drivers/gpu/drm/i915/intel_runtime_pm.h            |  22 +
 drivers/gpu/drm/mediatek/mtk_dpi.c                 |  12 +-
 drivers/gpu/drm/mediatek/mtk_hdmi.c                |   7 +-
 drivers/gpu/drm/meson/meson_encoder_cvbs.c         |   7 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |  12 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_dsc.c         |  11 +-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c           |  27 +-
 drivers/gpu/drm/msm/dp/dp_display.c                |   2 +-
 drivers/gpu/drm/msm/dsi/dsi_host.c                 | 121 ++--
 drivers/gpu/drm/msm/hdmi/hdmi.c                    |   2 +-
 drivers/gpu/drm/mxsfb/lcdif_kms.c                  |  48 +-
 drivers/gpu/drm/mxsfb/lcdif_regs.h                 |   5 +
 drivers/gpu/drm/panel/panel-sitronix-st7701.c      |  12 +-
 drivers/gpu/drm/radeon/radeon_bios.c               |  19 +-
 drivers/gpu/drm/rcar-du/Kconfig                    |   2 -
 drivers/gpu/drm/rockchip/cdn-dp-core.c             |   2 +-
 drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c    |   2 +-
 drivers/gpu/drm/rockchip/inno_hdmi.c               |   2 +-
 drivers/gpu/drm/rockchip/rk3066_hdmi.c             |   2 +-
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c        |   4 +-
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c       |   2 +-
 drivers/gpu/drm/rockchip/rockchip_lvds.c           |  10 +-
 drivers/gpu/drm/sti/sti_dvo.c                      |   7 +-
 drivers/gpu/drm/sti/sti_hda.c                      |   7 +-
 drivers/gpu/drm/sti/sti_hdmi.c                     |   7 +-
 drivers/gpu/drm/tegra/dc.c                         |   4 +-
 drivers/hid/amd-sfh-hid/amd_sfh_client.c           |   4 +
 drivers/hid/hid-apple.c                            | 118 ++--
 drivers/hid/hid-input.c                            |   6 +
 drivers/hid/hid-logitech-hidpp.c                   |  11 +-
 drivers/hid/hid-mcp2221.c                          |  12 +-
 drivers/hid/hid-rmi.c                              |   2 +
 drivers/hid/hid-sensor-custom.c                    |   2 +-
 drivers/hid/hid-uclogic-params.c                   |  73 +++
 drivers/hid/hid-uclogic-rdesc.c                    |  34 ++
 drivers/hid/hid-uclogic-rdesc.h                    |   7 +
 drivers/hid/i2c-hid/i2c-hid-core.c                 |   3 +-
 drivers/hid/wacom_sys.c                            |   8 +
 drivers/hid/wacom_wac.c                            |   4 +
 drivers/hid/wacom_wac.h                            |   1 +
 drivers/hsi/controllers/omap_ssi_core.c            |  14 +-
 drivers/hv/ring_buffer.c                           |  13 +
 drivers/hwmon/Kconfig                              |   1 +
 drivers/hwmon/emc2305.c                            |  44 +-
 drivers/hwmon/jc42.c                               | 243 +++++----
 drivers/hwmon/nct6775-platform.c                   |   7 +
 drivers/hwtracing/coresight/coresight-cti-core.c   |   2 +-
 drivers/hwtracing/coresight/coresight-trbe.c       |   1 +
 drivers/i2c/busses/i2c-ismt.c                      |   3 +
 drivers/i2c/busses/i2c-pxa-pci.c                   |  10 +-
 drivers/i2c/muxes/i2c-mux-reg.c                    |   5 +-
 drivers/iio/adc/ad_sigma_delta.c                   |   8 +-
 drivers/iio/adc/ti-adc128s052.c                    |  14 +-
 drivers/iio/addac/ad74413r.c                       |   2 +-
 drivers/iio/imu/adis.c                             |  28 +-
 drivers/iio/industrialio-event.c                   |   4 +-
 drivers/iio/temperature/ltc2983.c                  |  10 +-
 drivers/infiniband/Kconfig                         |   2 +
 drivers/infiniband/core/device.c                   |   2 +-
 drivers/infiniband/core/mad.c                      |   5 -
 drivers/infiniband/core/nldev.c                    |   6 +-
 drivers/infiniband/core/restrack.c                 |   2 -
 drivers/infiniband/core/sysfs.c                    |  17 +-
 drivers/infiniband/hw/hfi1/affinity.c              |   2 +
 drivers/infiniband/hw/hfi1/firmware.c              |   6 +
 drivers/infiniband/hw/hns/hns_roce_device.h        |   3 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         | 217 ++++++--
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h         |  13 +-
 drivers/infiniband/hw/hns/hns_roce_main.c          |  18 +-
 drivers/infiniband/hw/hns/hns_roce_mr.c            |   4 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c            | 107 +++-
 drivers/infiniband/hw/irdma/uk.c                   | 170 +++---
 drivers/infiniband/hw/irdma/user.h                 |  20 +-
 drivers/infiniband/hw/irdma/utils.c                |   2 +
 drivers/infiniband/hw/irdma/verbs.c                | 145 ++---
 drivers/infiniband/hw/irdma/verbs.h                |  53 ++
 drivers/infiniband/sw/rxe/rxe_mr.c                 |   9 +-
 drivers/infiniband/sw/rxe/rxe_qp.c                 |   6 +-
 drivers/infiniband/sw/siw/siw_cq.c                 |  24 +-
 drivers/infiniband/sw/siw/siw_qp_tx.c              |   2 +-
 drivers/infiniband/sw/siw/siw_verbs.c              |  40 +-
 drivers/infiniband/ulp/ipoib/ipoib_netlink.c       |   7 +
 drivers/infiniband/ulp/srp/ib_srp.c                |  96 +++-
 drivers/input/joystick/Kconfig                     |   1 +
 drivers/input/misc/Kconfig                         |   2 +-
 drivers/input/misc/iqs7222.c                       | 504 ++++++++++-------
 drivers/input/touchscreen/elants_i2c.c             |   9 +-
 drivers/interconnect/qcom/sc7180.c                 |   2 +-
 drivers/iommu/amd/iommu_v2.c                       |   1 +
 drivers/iommu/fsl_pamu.c                           |   2 +-
 drivers/iommu/iommu.c                              |  28 +-
 drivers/iommu/mtk_iommu.c                          |  53 +-
 drivers/iommu/rockchip-iommu.c                     |  10 +-
 drivers/iommu/s390-iommu.c                         | 106 ++--
 drivers/iommu/sun50i-iommu.c                       |  89 ++-
 drivers/irqchip/irq-gic-pm.c                       |   2 +-
 drivers/irqchip/irq-loongson-liointc.c             |   5 +-
 drivers/irqchip/irq-loongson-pch-pic.c             |   3 +
 drivers/irqchip/irq-wpcm450-aic.c                  |   1 +
 drivers/isdn/hardware/mISDN/hfcmulti.c             |  19 +-
 drivers/isdn/hardware/mISDN/hfcpci.c               |  13 +-
 drivers/isdn/hardware/mISDN/hfcsusb.c              |  12 +-
 drivers/leds/leds-is31fl319x.c                     |   3 +-
 drivers/leds/rgb/leds-qcom-lpg.c                   |  18 +-
 drivers/macintosh/macio-adb.c                      |   4 +
 drivers/macintosh/macio_asic.c                     |   2 +-
 drivers/mailbox/arm_mhuv2.c                        |   4 +-
 drivers/mailbox/mailbox-mpfs.c                     |  31 +-
 drivers/mailbox/pcc.c                              |   1 +
 drivers/mailbox/zynqmp-ipi-mailbox.c               |   4 +-
 drivers/mcb/mcb-core.c                             |   4 +-
 drivers/mcb/mcb-parse.c                            |   2 +-
 drivers/md/dm.c                                    | 123 +++--
 drivers/md/md-bitmap.c                             |  27 +-
 drivers/md/raid0.c                                 |   1 -
 drivers/md/raid1.c                                 |   1 +
 drivers/md/raid10.c                                |   2 -
 drivers/media/dvb-core/dvb_ca_en50221.c            |   2 +-
 drivers/media/dvb-core/dvb_frontend.c              |  10 +-
 drivers/media/dvb-core/dvbdev.c                    |  32 +-
 drivers/media/dvb-frontends/bcm3510.c              |   1 +
 drivers/media/i2c/ad5820.c                         |  10 +-
 drivers/media/i2c/adv748x/adv748x-afe.c            |   4 +
 drivers/media/i2c/dw9768.c                         |  33 +-
 drivers/media/i2c/hi846.c                          |  14 +-
 drivers/media/i2c/mt9p031.c                        |   1 -
 drivers/media/i2c/ov5640.c                         |   3 +-
 drivers/media/i2c/ov5648.c                         |   1 +
 drivers/media/pci/saa7164/saa7164-core.c           |   4 +-
 drivers/media/pci/solo6x10/solo6x10-core.c         |   1 +
 drivers/media/platform/amphion/vdec.c              |  15 +-
 drivers/media/platform/amphion/vpu.h               |   1 +
 drivers/media/platform/amphion/vpu_cmds.c          |  39 +-
 drivers/media/platform/amphion/vpu_drv.c           |   6 +-
 drivers/media/platform/amphion/vpu_malone.c        |   1 +
 drivers/media/platform/amphion/vpu_msgs.c          |   2 +
 drivers/media/platform/amphion/vpu_v4l2.c          |  30 +-
 drivers/media/platform/amphion/vpu_windsor.c       |   1 +
 drivers/media/platform/chips-media/coda-bit.c      |  14 +-
 drivers/media/platform/chips-media/coda-jpeg.c     |  10 +-
 .../media/platform/mediatek/mdp3/mtk-mdp3-cmdq.c   |  51 +-
 .../media/platform/mediatek/mdp3/mtk-mdp3-comp.c   |  24 +-
 .../media/platform/mediatek/mdp3/mtk-mdp3-core.c   |  15 +-
 .../mediatek/vcodec/mtk_vcodec_dec_stateless.c     |  13 +-
 .../mediatek/vcodec/vdec/vdec_h264_req_multi_if.c  |  60 +-
 .../mediatek/vcodec/vdec/vdec_vp9_req_lat_if.c     |  15 +-
 .../platform/mediatek/vcodec/vdec_msg_queue.c      |   2 +-
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg-hw.c  |   4 +-
 drivers/media/platform/qcom/camss/camss-video.c    |   3 +-
 drivers/media/platform/qcom/camss/camss.c          |  11 +
 drivers/media/platform/qcom/venus/pm_helpers.c     |   4 +-
 .../media/platform/samsung/exynos4-is/fimc-core.c  |   2 +-
 .../media/platform/samsung/exynos4-is/media-dev.c  |  12 +-
 drivers/media/platform/samsung/s5p-mfc/s5p_mfc.c   |  17 +-
 .../platform/st/sti/c8sectpfe/c8sectpfe-core.c     |   1 +
 .../sunxi/sun6i-mipi-csi2/sun6i_mipi_csi2.c        |  23 +-
 .../sun8i-a83t-mipi-csi2/sun8i_a83t_mipi_csi2.c    |  23 +-
 drivers/media/radio/si470x/radio-si470x-usb.c      |   4 +-
 drivers/media/rc/imon.c                            |   6 +-
 drivers/media/test-drivers/vidtv/vidtv_bridge.c    |  22 +-
 drivers/media/test-drivers/vimc/vimc-core.c        |   2 +-
 drivers/media/test-drivers/vivid/vivid-vid-cap.c   |   1 +
 drivers/media/usb/dvb-usb/az6027.c                 |   4 +
 drivers/media/usb/dvb-usb/dvb-usb-init.c           |   4 +-
 drivers/media/v4l2-core/v4l2-ctrls-api.c           |   1 +
 drivers/media/v4l2-core/v4l2-ctrls-core.c          |   2 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |  34 +-
 drivers/media/v4l2-core/videobuf-dma-contig.c      |  22 +-
 drivers/memory/renesas-rpc-if.c                    |   3 +
 drivers/memstick/core/ms_block.c                   |   9 +-
 drivers/mfd/Kconfig                                |   1 +
 drivers/mfd/axp20x.c                               |   2 +-
 drivers/mfd/qcom-pm8008.c                          |   4 +-
 drivers/mfd/qcom_rpm.c                             |   4 +-
 drivers/misc/cxl/guest.c                           |  24 +-
 drivers/misc/cxl/pci.c                             |  21 +-
 drivers/misc/habanalabs/common/firmware_if.c       |   2 +-
 drivers/misc/lkdtm/cfi.c                           |   6 +-
 drivers/misc/ocxl/config.c                         |  20 +-
 drivers/misc/ocxl/file.c                           |   7 +-
 drivers/misc/sgi-gru/grufault.c                    |  13 +-
 drivers/misc/sgi-gru/grumain.c                     |  22 +-
 drivers/misc/sgi-gru/grutables.h                   |   2 +-
 drivers/misc/tifm_7xx1.c                           |   2 +-
 drivers/mmc/core/sd.c                              |  11 +-
 drivers/mmc/host/alcor.c                           |   5 +-
 drivers/mmc/host/atmel-mci.c                       |   9 +-
 drivers/mmc/host/litex_mmc.c                       |   1 +
 drivers/mmc/host/meson-gx-mmc.c                    |   4 +-
 drivers/mmc/host/mmci.c                            |   4 +-
 drivers/mmc/host/moxart-mmc.c                      |   4 +-
 drivers/mmc/host/mxcmmc.c                          |   4 +-
 drivers/mmc/host/omap_hsmmc.c                      |   4 +-
 drivers/mmc/host/pxamci.c                          |   7 +-
 drivers/mmc/host/renesas_sdhi.h                    |   1 +
 drivers/mmc/host/renesas_sdhi_core.c               |  14 +-
 drivers/mmc/host/renesas_sdhi_internal_dmac.c      |   4 +-
 drivers/mmc/host/rtsx_pci_sdmmc.c                  |   9 +-
 drivers/mmc/host/rtsx_usb_sdmmc.c                  |  11 +-
 drivers/mmc/host/sdhci-tegra.c                     |   3 +-
 drivers/mmc/host/sdhci.c                           |   5 +
 drivers/mmc/host/sdhci.h                           |   2 +
 drivers/mmc/host/sdhci_f_sdh30.c                   |   3 +
 drivers/mmc/host/toshsd.c                          |   6 +-
 drivers/mmc/host/via-sdmmc.c                       |   4 +-
 drivers/mmc/host/vub300.c                          |  11 +-
 drivers/mmc/host/wbsd.c                            |  12 +-
 drivers/mmc/host/wmt-sdmmc.c                       |   6 +-
 drivers/mtd/lpddr/lpddr2_nvm.c                     |   2 +
 drivers/mtd/maps/pxa2xx-flash.c                    |   2 +
 drivers/mtd/mtdcore.c                              |   9 +-
 drivers/mtd/spi-nor/core.c                         |   3 +-
 drivers/mtd/spi-nor/sysfs.c                        |  14 +
 drivers/net/bonding/bond_main.c                    |  37 +-
 drivers/net/can/m_can/m_can.c                      |  32 +-
 drivers/net/can/m_can/m_can_platform.c             |   4 -
 drivers/net/can/m_can/tcan4x5x-core.c              |  18 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb.h        |  30 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c   | 115 +++-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c  | 160 +++++-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c   | 437 +++++++++++++--
 drivers/net/dsa/lan9303-core.c                     |   4 +-
 drivers/net/dsa/microchip/ksz_common.c             |   3 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |   9 +-
 drivers/net/ethernet/adi/adin1110.c                |  37 +-
 drivers/net/ethernet/amd/atarilance.c              |   2 +-
 drivers/net/ethernet/amd/lance.c                   |   2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c        |  23 +-
 drivers/net/ethernet/apple/bmac.c                  |   2 +-
 drivers/net/ethernet/apple/mace.c                  |   2 +-
 drivers/net/ethernet/broadcom/bnx2.c               |   5 +-
 drivers/net/ethernet/dnet.c                        |   4 +-
 drivers/net/ethernet/freescale/enetc/enetc.c       |  35 +-
 drivers/net/ethernet/freescale/fec_main.c          |   8 +
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  36 +-
 drivers/net/ethernet/intel/ice/ice_ptp.c           |  10 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |   8 +-
 drivers/net/ethernet/intel/igc/igc.h               |   3 +
 drivers/net/ethernet/intel/igc/igc_defines.h       |   2 +
 drivers/net/ethernet/intel/igc/igc_main.c          | 210 ++++++-
 drivers/net/ethernet/intel/igc/igc_tsn.c           |  13 +-
 drivers/net/ethernet/marvell/octeontx2/af/mcs.c    |   6 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |  71 ++-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h        |  11 +-
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c   |   1 +
 drivers/net/ethernet/neterion/s2io.c               |   2 +-
 drivers/net/ethernet/qlogic/qed/qed_debug.c        |   3 +-
 .../ethernet/qlogic/qlcnic/qlcnic_sriov_common.c   |   2 +
 drivers/net/ethernet/rdc/r6040.c                   |   5 +-
 .../net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c  |   3 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   4 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.h   |   2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c |   8 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |  10 +-
 drivers/net/ethernet/ti/netcp_core.c               |   2 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c      |   2 +-
 drivers/net/fddi/defxx.c                           |  22 +-
 drivers/net/hamradio/baycom_epp.c                  |   2 +-
 drivers/net/hamradio/scc.c                         |   6 +-
 drivers/net/macsec.c                               |  34 +-
 drivers/net/mctp/mctp-serial.c                     |   6 +-
 drivers/net/ntb_netdev.c                           |   4 +-
 drivers/net/ppp/ppp_generic.c                      |   2 +
 drivers/net/wan/farsync.c                          |   2 +
 drivers/net/wireless/ath/ar5523/ar5523.c           |   6 +
 drivers/net/wireless/ath/ath10k/core.c             |  16 +
 drivers/net/wireless/ath/ath10k/htc.c              |   9 +
 drivers/net/wireless/ath/ath10k/hw.h               |   2 +
 drivers/net/wireless/ath/ath10k/pci.c              |  20 +-
 drivers/net/wireless/ath/ath11k/core.h             |   2 +
 drivers/net/wireless/ath/ath11k/mac.c              | 122 +++--
 drivers/net/wireless/ath/ath11k/qmi.c              |   3 +
 drivers/net/wireless/ath/ath9k/hif_usb.c           |  46 +-
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  |   8 +-
 .../broadcom/brcm80211/brcmfmac/firmware.c         |   5 +
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |   6 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |   1 +
 drivers/net/wireless/intel/iwlwifi/mei/iwl-mei.h   |   7 +-
 drivers/net/wireless/intel/iwlwifi/mei/main.c      | 172 +++---
 drivers/net/wireless/intel/iwlwifi/mei/net.c       |  10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |   2 +
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |  20 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |   3 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |   4 +
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c |  58 +-
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h |   5 -
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |  23 +-
 drivers/net/wireless/mediatek/mt76/mt7915/pci.c    |  13 +-
 drivers/net/wireless/mediatek/mt76/mt7921/init.c   |   1 +
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |  34 +-
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |   6 +
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h |   4 +-
 drivers/net/wireless/mediatek/mt76/usb.c           |  11 +-
 drivers/net/wireless/purelifi/plfxlc/usb.c         |   1 +
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |   2 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |  28 +-
 drivers/net/wireless/realtek/rtw89/core.c          |   2 +-
 drivers/net/wireless/realtek/rtw89/mac.c           |   6 +-
 drivers/net/wireless/realtek/rtw89/phy.c           |   2 +-
 drivers/net/wireless/rsi/rsi_91x_core.c            |   4 +-
 drivers/net/wireless/rsi/rsi_91x_hal.c             |   6 +-
 drivers/nfc/pn533/pn533.c                          |   4 +
 drivers/nvme/host/core.c                           |  19 +-
 drivers/nvme/host/fc.c                             |   2 +-
 drivers/nvme/host/nvme.h                           |   2 +-
 drivers/nvme/host/rdma.c                           |   4 +-
 drivers/nvme/host/tcp.c                            |   1 +
 drivers/nvme/target/core.c                         |  22 +-
 drivers/nvme/target/io-cmd-file.c                  |  16 +-
 drivers/nvme/target/loop.c                         |   2 +-
 drivers/nvme/target/nvmet.h                        |   3 +-
 drivers/of/overlay.c                               |   4 +-
 drivers/pci/controller/dwc/pci-imx6.c              |  13 +-
 drivers/pci/controller/dwc/pcie-designware.c       |   2 +-
 drivers/pci/controller/vmd.c                       |  27 +-
 drivers/pci/endpoint/functions/pci-epf-test.c      |   2 +-
 drivers/pci/endpoint/functions/pci-epf-vntb.c      |   2 +-
 drivers/pci/irq.c                                  |   2 +
 drivers/pci/probe.c                                |   3 -
 drivers/perf/arm_dmc620_pmu.c                      |   8 +-
 drivers/perf/arm_dsu_pmu.c                         |   6 +-
 drivers/perf/arm_smmuv3_pmu.c                      |   8 +-
 drivers/perf/hisilicon/hisi_pcie_pmu.c             |   8 +-
 drivers/perf/marvell_cn10k_tad_pmu.c               |   6 +-
 drivers/phy/broadcom/phy-brcm-usb-init-synopsys.c  |   9 +-
 drivers/phy/broadcom/phy-brcm-usb-init.h           |   1 -
 drivers/phy/broadcom/phy-brcm-usb.c                |  14 +-
 drivers/phy/marvell/phy-mvebu-a3700-comphy.c       |   3 +
 drivers/phy/qualcomm/phy-qcom-qmp-pcie.c           | 607 ++++++++++++---------
 drivers/phy/qualcomm/phy-qcom-qmp-pcs-pcie-v5_20.h |   2 +
 drivers/phy/qualcomm/phy-qcom-qmp-pcs-v5_20.h      |  14 +
 drivers/phy/qualcomm/phy-qcom-qmp-usb.c            | 142 +----
 drivers/phy/qualcomm/phy-qcom-qmp.h                |   1 +
 drivers/pinctrl/mediatek/pinctrl-mt7986.c          |  24 +-
 drivers/pinctrl/pinconf-generic.c                  |   4 +-
 drivers/pinctrl/pinctrl-k210.c                     |   4 +-
 drivers/pinctrl/pinctrl-ocelot.c                   |  20 +-
 drivers/pinctrl/pinctrl-thunderbay.c               |   8 +-
 drivers/platform/chrome/cros_ec_typec.c            |   3 +
 drivers/platform/chrome/cros_usbpd_notify.c        |   6 +-
 drivers/platform/mellanox/mlxbf-pmc.c              |   2 +-
 drivers/platform/x86/huawei-wmi.c                  |  20 +-
 .../platform/x86/intel/int3472/clk_and_regulator.c |   3 +-
 drivers/platform/x86/intel_scu_ipc.c               |   2 +-
 drivers/platform/x86/mxm-wmi.c                     |   8 +-
 drivers/pnp/core.c                                 |   4 +-
 drivers/power/supply/ab8500_charger.c              |   9 +-
 drivers/power/supply/bq25890_charger.c             |  71 ++-
 drivers/power/supply/cw2015_battery.c              |   3 +
 drivers/power/supply/power_supply_core.c           |   7 +-
 drivers/power/supply/rk817_charger.c               |   4 +-
 drivers/power/supply/z2_battery.c                  |   6 +-
 drivers/pwm/pwm-mediatek.c                         |   2 +-
 drivers/pwm/pwm-mtk-disp.c                         |   5 +-
 drivers/pwm/pwm-sifive.c                           |   5 +-
 drivers/pwm/pwm-tegra.c                            |  15 +-
 drivers/rapidio/devices/rio_mport_cdev.c           |  15 +-
 drivers/rapidio/rio-scan.c                         |   8 +-
 drivers/rapidio/rio.c                              |   9 +-
 drivers/regulator/core.c                           |  25 +-
 drivers/regulator/devres.c                         |   2 +-
 drivers/regulator/of_regulator.c                   |   2 +-
 drivers/regulator/qcom-labibb-regulator.c          |   1 +
 drivers/regulator/qcom-rpmh-regulator.c            |   2 +-
 drivers/regulator/stm32-vrefbuf.c                  |   2 +-
 drivers/remoteproc/qcom_q6v5_pas.c                 |   4 +
 drivers/remoteproc/qcom_q6v5_wcss.c                |   6 +-
 drivers/remoteproc/qcom_sysmon.c                   |   5 +-
 drivers/remoteproc/remoteproc_core.c               |   8 +-
 drivers/rtc/class.c                                |   4 +-
 drivers/rtc/rtc-cmos.c                             | 378 ++++++-------
 drivers/rtc/rtc-mxc_v2.c                           |   4 +-
 drivers/rtc/rtc-pcf2127.c                          |  22 +-
 drivers/rtc/rtc-pcf85063.c                         |  10 +-
 drivers/rtc/rtc-pic32.c                            |   8 +-
 drivers/rtc/rtc-rzn1.c                             |   4 +-
 drivers/rtc/rtc-snvs.c                             |  16 +-
 drivers/rtc/rtc-st-lpc.c                           |   1 +
 drivers/s390/net/ctcm_main.c                       |  11 +-
 drivers/s390/net/lcs.c                             |   8 +-
 drivers/s390/net/netiucv.c                         |   9 +-
 drivers/scsi/elx/efct/efct_driver.c                |   1 +
 drivers/scsi/elx/libefc/efclib.h                   |   6 +-
 drivers/scsi/fcoe/fcoe.c                           |   1 +
 drivers/scsi/fcoe/fcoe_sysfs.c                     |  19 +-
 drivers/scsi/hpsa.c                                |   9 +-
 drivers/scsi/ipr.c                                 |  10 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |   6 +-
 drivers/scsi/mpt3sas/mpt3sas_transport.c           |   2 +
 drivers/scsi/qla2xxx/qla_def.h                     |  22 +-
 drivers/scsi/qla2xxx/qla_init.c                    |  20 +-
 drivers/scsi/qla2xxx/qla_inline.h                  |   4 +-
 drivers/scsi/qla2xxx/qla_os.c                      |   4 +-
 drivers/scsi/scsi_debug.c                          |  11 +-
 drivers/scsi/scsi_error.c                          |  14 +-
 drivers/scsi/smartpqi/smartpqi.h                   |   2 +-
 drivers/scsi/smartpqi/smartpqi_init.c              |  77 ++-
 drivers/scsi/snic/snic_disc.c                      |   3 +
 drivers/soc/apple/rtkit.c                          |   7 +-
 drivers/soc/apple/sart.c                           |   7 +-
 drivers/soc/mediatek/mtk-pm-domains.c              |   2 +-
 drivers/soc/qcom/apr.c                             |  15 +-
 drivers/soc/qcom/llcc-qcom.c                       |   2 +-
 drivers/soc/sifive/sifive_ccache.c                 |  33 +-
 drivers/soc/tegra/cbb/tegra194-cbb.c               |  14 +-
 drivers/soc/tegra/cbb/tegra234-cbb.c               | 170 ++++--
 drivers/soc/ti/knav_qmss_queue.c                   |   3 +-
 drivers/soc/ti/smartreflex.c                       |   1 +
 drivers/spi/spi-fsl-spi.c                          |  19 +-
 drivers/spi/spi-gpio.c                             |  16 +-
 drivers/spi/spidev.c                               |  21 +-
 drivers/staging/media/deprecated/stkwebcam/Kconfig |   2 +-
 drivers/staging/media/imx/imx7-media-csi.c         |   6 +-
 drivers/staging/media/rkvdec/rkvdec-vp9.c          |   3 +
 drivers/staging/media/sunxi/cedrus/cedrus_h265.c   |  25 +-
 drivers/staging/media/sunxi/cedrus/cedrus_regs.h   |   2 +
 drivers/staging/r8188eu/core/rtw_pwrctrl.c         |   2 +-
 drivers/staging/rtl8192e/rtllib_rx.c               |   2 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c  |   4 +-
 drivers/staging/vme_user/vme_fake.c                |   2 +
 drivers/staging/vme_user/vme_tsi148.c              |   1 +
 drivers/target/iscsi/iscsi_target_nego.c           |  12 +-
 drivers/thermal/imx8mm_thermal.c                   |   8 +-
 drivers/thermal/k3_j72xx_bandgap.c                 |   2 +-
 drivers/thermal/qcom/lmh.c                         |   2 +-
 drivers/thermal/qcom/qcom-spmi-temp-alarm.c        |   3 +-
 drivers/thermal/thermal_core.c                     |  18 +-
 drivers/thermal/thermal_helpers.c                  |   7 +-
 drivers/thermal/thermal_of.c                       |   8 +-
 drivers/tty/serial/8250/8250_bcm7271.c             |  10 +-
 drivers/tty/serial/altera_uart.c                   |   5 +-
 drivers/tty/serial/amba-pl011.c                    |  14 +-
 drivers/tty/serial/pch_uart.c                      |   4 +
 drivers/tty/serial/serial-tegra.c                  |   6 +-
 drivers/tty/serial/stm32-usart.c                   |  47 +-
 drivers/tty/serial/sunsab.c                        |   8 +-
 drivers/ufs/core/ufshcd.c                          |  37 +-
 drivers/uio/uio_dmem_genirq.c                      |  13 +-
 drivers/usb/cdns3/cdnsp-ring.c                     |  42 +-
 drivers/usb/core/hcd.c                             |   6 +-
 drivers/usb/dwc3/core.c                            |  23 +-
 drivers/usb/dwc3/dwc3-qcom.c                       |  13 +-
 drivers/usb/gadget/function/f_hid.c                |  53 +-
 drivers/usb/gadget/udc/core.c                      |  12 +-
 drivers/usb/gadget/udc/fotg210-udc.c               |  12 +-
 drivers/usb/host/xhci-mtk.c                        |   1 -
 drivers/usb/host/xhci-ring.c                       |  14 +-
 drivers/usb/host/xhci.h                            |   2 +-
 drivers/usb/musb/musb_gadget.c                     |   2 -
 drivers/usb/musb/omap2430.c                        |  54 ++
 drivers/usb/roles/class.c                          |   5 +-
 drivers/usb/storage/alauda.c                       |   2 +
 drivers/usb/typec/bus.c                            |   2 +-
 drivers/usb/typec/tcpm/tcpci.c                     |   5 +-
 drivers/usb/typec/tipd/core.c                      |  11 +-
 drivers/usb/typec/wusb3801.c                       |   2 +-
 drivers/vfio/iova_bitmap.c                         |  32 +-
 drivers/vfio/platform/vfio_platform_common.c       |   3 +-
 drivers/video/fbdev/Kconfig                        |   2 +-
 drivers/video/fbdev/core/fbcon.c                   |   3 +-
 drivers/video/fbdev/ep93xx-fb.c                    |   4 +-
 drivers/video/fbdev/geode/Kconfig                  |   1 +
 drivers/video/fbdev/hyperv_fb.c                    |   8 +-
 drivers/video/fbdev/pm2fb.c                        |   9 +-
 drivers/video/fbdev/uvesafb.c                      |   1 +
 drivers/video/fbdev/vermilion/vermilion.c          |   4 +-
 drivers/video/fbdev/via/via-core.c                 |   9 +-
 drivers/virt/coco/sev-guest/sev-guest.c            |   1 +
 drivers/watchdog/iTCO_wdt.c                        |  21 +-
 drivers/xen/privcmd.c                              |   2 +-
 fs/afs/fs_probe.c                                  |   5 +-
 fs/binfmt_misc.c                                   |   8 +-
 fs/btrfs/extent-io-tree.c                          |  22 +-
 fs/btrfs/file.c                                    |  10 +-
 fs/char_dev.c                                      |   2 +-
 fs/cifs/smb2file.c                                 |   4 +-
 fs/configfs/dir.c                                  |   2 +
 fs/debugfs/file.c                                  |  28 +-
 fs/erofs/fscache.c                                 |  47 +-
 fs/erofs/internal.h                                |  10 +-
 fs/erofs/super.c                                   |   2 +-
 fs/erofs/zdata.c                                   |   3 +-
 fs/erofs/zmap.c                                    |  11 +-
 fs/f2fs/compress.c                                 |   2 +-
 fs/f2fs/f2fs.h                                     |   2 +-
 fs/f2fs/file.c                                     |   4 +
 fs/f2fs/gc.c                                       |  29 +-
 fs/f2fs/namei.c                                    | 329 ++++++-----
 fs/f2fs/segment.c                                  |   8 +-
 fs/f2fs/super.c                                    |   8 +-
 fs/gfs2/glock.c                                    |   2 +
 fs/hfs/inode.c                                     |   2 +
 fs/hfs/trans.c                                     |   2 +-
 fs/hugetlbfs/inode.c                               |   6 +-
 fs/jfs/jfs_dmap.c                                  |  27 +-
 fs/jfs/namei.c                                     |   2 +-
 fs/ksmbd/mgmt/user_session.c                       |   8 +-
 fs/libfs.c                                         |  22 +-
 fs/lockd/svcsubs.c                                 |  17 +-
 fs/nfs/fs_context.c                                |   6 +
 fs/nfs/internal.h                                  |   6 +-
 fs/nfs/namespace.c                                 |   2 +-
 fs/nfs/nfs42xdr.c                                  |   2 +-
 fs/nfs/nfs4proc.c                                  |  38 +-
 fs/nfs/nfs4state.c                                 |   2 +
 fs/nfs/nfs4xdr.c                                   |  22 +-
 fs/nfsd/nfs2acl.c                                  |  10 -
 fs/nfsd/nfs3acl.c                                  |  30 +-
 fs/nfsd/nfs4callback.c                             |   4 +-
 fs/nfsd/nfs4proc.c                                 |   7 +-
 fs/nfsd/nfs4state.c                                |  51 +-
 fs/nilfs2/the_nilfs.c                              |  73 ++-
 fs/ntfs3/bitmap.c                                  |   2 +-
 fs/ntfs3/super.c                                   |   2 +-
 fs/ntfs3/xattr.c                                   |   2 +-
 fs/ocfs2/journal.c                                 |   2 +-
 fs/ocfs2/journal.h                                 |   1 +
 fs/ocfs2/stackglue.c                               |   8 +-
 fs/ocfs2/super.c                                   |   5 +-
 fs/orangefs/orangefs-debugfs.c                     |  29 +-
 fs/orangefs/orangefs-mod.c                         |   8 +-
 fs/orangefs/orangefs-sysfs.c                       |  71 ++-
 fs/overlayfs/file.c                                |  28 +-
 fs/overlayfs/super.c                               |   7 +-
 fs/pstore/Kconfig                                  |   1 +
 fs/pstore/pmsg.c                                   |   7 +-
 fs/pstore/ram.c                                    |   2 +
 fs/pstore/ram_core.c                               |   6 +-
 fs/reiserfs/namei.c                                |   4 +
 fs/reiserfs/xattr_security.c                       |   2 +-
 fs/sysv/itree.c                                    |   2 +-
 fs/udf/namei.c                                     |   8 +-
 fs/xattr.c                                         |   2 +-
 include/drm/drm_connector.h                        |   6 +
 include/drm/ttm/ttm_tt.h                           |   2 +-
 include/dt-bindings/clock/imx8mn-clock.h           |  24 +-
 include/dt-bindings/clock/imx8mp-clock.h           |   3 +-
 include/linux/blk-mq.h                             |   4 +
 include/linux/blkdev.h                             |  15 +-
 include/linux/btf_ids.h                            |   2 +-
 include/linux/debugfs.h                            |  19 +-
 include/linux/eventfd.h                            |   2 +-
 include/linux/fortify-string.h                     |   2 +-
 include/linux/fs.h                                 |  12 +-
 include/linux/hisi_acc_qm.h                        |   6 +-
 include/linux/hyperv.h                             |   2 +
 include/linux/ieee80211.h                          |   2 +-
 include/linux/iio/imu/adis.h                       |  13 +-
 include/linux/netdevice.h                          |  58 +-
 include/linux/proc_fs.h                            |   2 +
 include/linux/regulator/driver.h                   |   3 +-
 include/linux/skmsg.h                              |   1 +
 include/linux/timerqueue.h                         |   2 +-
 include/media/dvbdev.h                             |  32 +-
 include/net/bluetooth/hci.h                        |  20 +
 include/net/bluetooth/hci_core.h                   |   7 +-
 include/net/dst.h                                  |   5 +-
 include/net/ip_vs.h                                |  10 +-
 include/net/mrp.h                                  |   1 +
 include/net/sock_reuseport.h                       |   2 +
 include/net/tcp.h                                  |   4 +-
 include/sound/hda_codec.h                          |   1 +
 include/sound/pcm.h                                |  36 +-
 include/trace/events/f2fs.h                        |  34 +-
 include/trace/events/ib_mad.h                      |  13 +-
 include/uapi/linux/idxd.h                          |   2 +-
 include/uapi/linux/io_uring.h                      |  18 +
 include/uapi/linux/swab.h                          |   2 +-
 include/uapi/rdma/hns-abi.h                        |  15 +
 include/uapi/sound/asequencer.h                    |   8 +-
 io_uring/io_uring.c                                |   2 +-
 io_uring/msg_ring.c                                |   6 +-
 io_uring/net.c                                     |   9 +-
 io_uring/notif.c                                   |  12 +
 io_uring/notif.h                                   |   3 +
 io_uring/opdef.c                                   |   7 +
 io_uring/opdef.h                                   |   2 +
 io_uring/timeout.c                                 |   4 +-
 ipc/mqueue.c                                       |   6 +-
 kernel/Makefile                                    |   3 -
 kernel/acct.c                                      |   2 +
 kernel/bpf/btf.c                                   |   5 +
 kernel/bpf/cgroup_iter.c                           |  14 +
 kernel/bpf/syscall.c                               |   6 +-
 kernel/bpf/verifier.c                              | 120 ++--
 kernel/cpu.c                                       |  60 +-
 kernel/events/core.c                               |   8 +-
 kernel/fork.c                                      |  17 +-
 kernel/futex/core.c                                |  26 +-
 kernel/gcov/gcc_4_7.c                              |   5 +
 kernel/irq/internals.h                             |   2 +
 kernel/irq/irqdesc.c                               |  15 +-
 kernel/kprobes.c                                   |  16 +-
 kernel/module/decompress.c                         |   8 +-
 kernel/padata.c                                    |  15 +-
 kernel/power/snapshot.c                            |   4 +-
 kernel/rcu/tree.c                                  |   2 +-
 kernel/relay.c                                     |   4 +-
 kernel/sched/core.c                                |  10 +-
 kernel/sched/fair.c                                | 223 +++++++-
 kernel/sched/psi.c                                 |   8 +-
 kernel/sched/sched.h                               |  51 +-
 kernel/trace/blktrace.c                            |   3 +-
 kernel/trace/trace_events_hist.c                   |   2 +-
 kernel/trace/trace_events_user.c                   |   1 +
 lib/debugobjects.c                                 |  10 +
 lib/fonts/fonts.c                                  |   4 +-
 lib/maple_tree.c                                   |   4 +-
 lib/notifier-error-inject.c                        |   2 +-
 lib/test_firmware.c                                |   1 +
 lib/test_maple_tree.c                              |  23 +
 mm/gup.c                                           |   3 +
 net/802/mrp.c                                      |  18 +-
 net/9p/client.c                                    |   5 +
 net/bluetooth/hci_conn.c                           |   2 +-
 net/bluetooth/hci_core.c                           |   4 +-
 net/bluetooth/hci_sync.c                           |   2 +-
 net/bluetooth/lib.c                                |   4 +-
 net/bluetooth/mgmt.c                               |   2 +-
 net/bluetooth/rfcomm/core.c                        |   2 +-
 net/bpf/test_run.c                                 |   3 -
 net/core/dev.c                                     |  14 +-
 net/core/devlink.c                                 |   5 +
 net/core/filter.c                                  |  25 +-
 net/core/skbuff.c                                  |   3 +
 net/core/skmsg.c                                   |   9 +-
 net/core/sock.c                                    |   2 +-
 net/core/sock_map.c                                |   2 +
 net/core/sock_reuseport.c                          |  94 +++-
 net/core/stream.c                                  |   6 +
 net/dsa/tag_8021q.c                                |  11 +-
 net/ethtool/ioctl.c                                |   3 +-
 net/hsr/hsr_debugfs.c                              |  40 +-
 net/hsr/hsr_device.c                               |  32 +-
 net/hsr/hsr_forward.c                              |  14 +-
 net/hsr/hsr_framereg.c                             | 222 ++++----
 net/hsr/hsr_framereg.h                             |  17 +-
 net/hsr/hsr_main.h                                 |   9 +-
 net/hsr/hsr_netlink.c                              |   4 +-
 net/ipv4/af_inet.c                                 |   4 +-
 net/ipv4/inet_connection_sock.c                    |   7 +-
 net/ipv4/ping.c                                    |   2 +-
 net/ipv4/tcp_bpf.c                                 |  19 +-
 net/ipv4/udp.c                                     |  39 +-
 net/ipv4/udp_tunnel_core.c                         |   1 +
 net/ipv6/af_inet6.c                                |   4 +-
 net/ipv6/datagram.c                                |  15 +-
 net/ipv6/sit.c                                     |  22 +-
 net/ipv6/udp.c                                     |  12 +-
 net/mac80211/cfg.c                                 |   2 +-
 net/mac80211/ieee80211_i.h                         |   1 +
 net/mac80211/iface.c                               |   1 +
 net/mac80211/mlme.c                                |  15 +-
 net/mac80211/tx.c                                  |   2 +-
 net/mctp/device.c                                  |  14 +-
 net/netfilter/ipvs/ip_vs_core.c                    |  30 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |  10 +-
 net/netfilter/ipvs/ip_vs_est.c                     |  20 +-
 net/netfilter/nf_conntrack_proto_icmpv6.c          |  53 ++
 net/netfilter/nf_flow_table_offload.c              |   6 +-
 net/openvswitch/datapath.c                         |  25 +-
 net/openvswitch/flow_netlink.c                     |   2 +-
 net/rxrpc/output.c                                 |   2 +-
 net/rxrpc/sendmsg.c                                |   2 +-
 net/sched/ematch.c                                 |   2 +
 net/sctp/sysctl.c                                  |  73 ++-
 net/sunrpc/clnt.c                                  |   2 +-
 net/sunrpc/xprtrdma/verbs.c                        |   2 +-
 net/tls/tls_sw.c                                   |   6 +-
 net/unix/af_unix.c                                 |  12 +-
 net/vmw_vsock/vmci_transport.c                     |   6 +-
 net/wireless/nl80211.c                             |   3 +
 net/wireless/reg.c                                 |   4 +-
 samples/bpf/xdp1_user.c                            |   2 +-
 samples/bpf/xdp2_kern.c                            |   4 +
 samples/vfio-mdev/mdpy-fb.c                        |   8 +-
 security/Kconfig.hardening                         |   3 +
 security/apparmor/apparmorfs.c                     |   4 +-
 security/apparmor/label.c                          |  12 +-
 security/apparmor/lsm.c                            |   4 +-
 security/apparmor/policy.c                         |   2 +-
 security/apparmor/policy_ns.c                      |   2 +-
 security/apparmor/policy_unpack.c                  |   2 +-
 security/integrity/digsig.c                        |   6 +-
 security/integrity/ima/ima_policy.c                |  51 +-
 security/integrity/ima/ima_template.c              |   4 +-
 security/loadpin/loadpin.c                         |  30 +-
 sound/core/memalloc.c                              |  44 +-
 sound/core/pcm_native.c                            |   4 +-
 sound/drivers/mts64.c                              |   3 +
 sound/pci/asihpi/hpioctl.c                         |   2 +-
 sound/pci/hda/hda_codec.c                          |   3 +-
 sound/pci/hda/patch_hdmi.c                         | 120 +++-
 sound/pci/hda/patch_realtek.c                      |  27 +
 sound/soc/amd/acp/acp-platform.c                   |   8 +-
 sound/soc/amd/yc/acp6x-mach.c                      |   7 +
 sound/soc/codecs/pcm512x.c                         |   8 +-
 sound/soc/codecs/rt298.c                           |   7 +
 sound/soc/codecs/rt5670.c                          |   2 -
 sound/soc/codecs/wm8994.c                          |   5 +
 sound/soc/codecs/wsa883x.c                         |   6 +-
 sound/soc/generic/audio-graph-card.c               |   4 +-
 sound/soc/intel/Kconfig                            |   2 +-
 sound/soc/intel/avs/boards/rt298.c                 |  24 +-
 sound/soc/intel/avs/core.c                         |   2 +-
 sound/soc/intel/avs/ipc.c                          |   6 +-
 sound/soc/intel/boards/sof_es8336.c                |   2 +-
 sound/soc/intel/skylake/skl.c                      |   5 +-
 sound/soc/mediatek/common/mtk-btcvsd.c             |   6 +-
 sound/soc/mediatek/mt8173/mt8173-afe-pcm.c         |  20 +-
 sound/soc/mediatek/mt8173/mt8173-rt5650-rt5514.c   |   7 +-
 .../mt8183/mt8183-mt6358-ts3a227-max98357.c        |  14 +-
 .../mt8186/mt8186-mt6366-da7219-max98357.c         |   2 +-
 .../mediatek/mt8186/mt8186-mt6366-rt1019-rt5682s.c |   2 +-
 sound/soc/pxa/mmp-pcm.c                            |   2 +-
 sound/soc/qcom/Kconfig                             |  16 +-
 sound/soc/qcom/common.c                            |   2 -
 sound/soc/qcom/common.h                            |  23 -
 sound/soc/qcom/lpass-sc7180.c                      |   3 +
 sound/soc/rockchip/rockchip_pdm.c                  |   1 +
 sound/soc/rockchip/rockchip_spdif.c                |   1 +
 sound/usb/endpoint.c                               |   7 +
 sound/usb/pcm.c                                    |  13 +-
 sound/usb/quirks-table.h                           |   2 +
 sound/usb/quirks.c                                 |   2 +
 sound/usb/usbaudio.h                               |   4 +
 tools/bpf/bpftool/common.c                         |   1 +
 tools/lib/bpf/bpf.h                                |   7 +
 tools/lib/bpf/btf.c                                |   8 +-
 tools/lib/bpf/btf_dump.c                           |  29 +-
 tools/lib/bpf/libbpf.c                             |  22 +-
 tools/lib/bpf/usdt.c                               |  11 +-
 tools/objtool/check.c                              |  10 +
 tools/perf/Documentation/perf-annotate.txt         |   2 +-
 tools/perf/Documentation/perf-diff.txt             |   2 +-
 tools/perf/Documentation/perf-lock.txt             |   2 +-
 tools/perf/Documentation/perf-probe.txt            |   2 +-
 tools/perf/Documentation/perf-record.txt           |   2 +-
 tools/perf/Documentation/perf-report.txt           |   2 +-
 tools/perf/Documentation/perf-stat.txt             |   4 +-
 tools/perf/bench/numa.c                            |   9 +-
 tools/perf/builtin-annotate.c                      |   2 +-
 tools/perf/builtin-diff.c                          |   2 +-
 tools/perf/builtin-lock.c                          |   2 +-
 tools/perf/builtin-probe.c                         |  22 +-
 tools/perf/builtin-record.c                        |   2 +-
 tools/perf/builtin-report.c                        |   2 +-
 tools/perf/builtin-stat.c                          |  41 +-
 tools/perf/builtin-trace.c                         |  32 +-
 tools/perf/tests/shell/stat_all_pmu.sh             |  13 +-
 tools/perf/ui/util.c                               |   5 +
 tools/perf/util/bpf_off_cpu.c                      |   2 +-
 tools/perf/util/branch.h                           |   3 +-
 tools/perf/util/debug.c                            |   4 +
 tools/perf/util/stat-display.c                     |  33 +-
 tools/perf/util/stat.h                             |   1 -
 tools/perf/util/symbol-elf.c                       |   2 +-
 tools/testing/selftests/bpf/config                 |   1 +
 tools/testing/selftests/bpf/network_helpers.c      |   4 +
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c  |  11 +-
 tools/testing/selftests/bpf/prog_tests/empty_skb.c | 146 +++++
 .../selftests/bpf/prog_tests/kprobe_multi_test.c   |  26 +-
 .../testing/selftests/bpf/prog_tests/lsm_cgroup.c  |  17 +-
 tools/testing/selftests/bpf/prog_tests/map_kptr.c  |   3 +-
 .../selftests/bpf/prog_tests/tcp_hdr_options.c     |   4 +-
 .../selftests/bpf/prog_tests/tracing_struct.c      |   3 +-
 .../selftests/bpf/prog_tests/xdp_adjust_tail.c     |   7 +-
 .../selftests/bpf/prog_tests/xdp_do_redirect.c     |   2 +-
 .../selftests/bpf/prog_tests/xdp_synproxy.c        |   2 +-
 tools/testing/selftests/bpf/progs/bpf_iter_ksym.c  |   6 +-
 tools/testing/selftests/bpf/progs/empty_skb.c      |  37 ++
 tools/testing/selftests/bpf/progs/lsm_cgroup.c     |   8 +
 .../testing/selftests/bpf/test_bpftool_metadata.sh |   7 +-
 tools/testing/selftests/bpf/test_flow_dissector.sh |   6 +-
 tools/testing/selftests/bpf/test_lwt_ip_encap.sh   |  17 +-
 tools/testing/selftests/bpf/test_lwt_seg6local.sh  |   9 +-
 tools/testing/selftests/bpf/test_tc_edt.sh         |   3 +-
 tools/testing/selftests/bpf/test_tc_tunnel.sh      |   5 +-
 tools/testing/selftests/bpf/test_tunnel.sh         |   5 +-
 tools/testing/selftests/bpf/test_xdp_meta.sh       |   9 +-
 tools/testing/selftests/bpf/test_xdp_vlan.sh       |   8 +-
 tools/testing/selftests/bpf/xdp_synproxy.c         |   5 +-
 tools/testing/selftests/cgroup/cgroup_util.c       |   5 +-
 .../selftests/drivers/net/netdevsim/devlink.sh     |   4 +-
 tools/testing/selftests/efivarfs/efivarfs.sh       |   5 +
 .../ftrace/test.d/ftrace/func_event_triggers.tc    |  15 +-
 .../selftests/netfilter/conntrack_icmp_related.sh  |  36 +-
 .../selftests/powerpc/dscr/dscr_sysfs_test.c       |   5 +-
 tools/testing/selftests/proc/proc-uptime-002.c     |   3 +-
 1103 files changed, 13134 insertions(+), 6488 deletions(-)


