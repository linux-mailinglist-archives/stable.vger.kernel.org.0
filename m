Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14FE1659B9A
	for <lists+stable@lfdr.de>; Fri, 30 Dec 2022 20:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbiL3TXy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Dec 2022 14:23:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiL3TXx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Dec 2022 14:23:53 -0500
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F334C1BEBB
        for <stable@vger.kernel.org>; Fri, 30 Dec 2022 11:23:48 -0800 (PST)
Received: by mail-qt1-x833.google.com with SMTP id i20so17778526qtw.9
        for <stable@vger.kernel.org>; Fri, 30 Dec 2022 11:23:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=to:cc:message-id:subject:date:mime-version:from
         :content-transfer-encoding:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T2PZsCU/zoDaabzuYWg/dGeF/TTBnDe7AZ+T8nHxjHQ=;
        b=MdwGsRP70FDt1ONTkSUZGj5Aoxt6fMk/xlFmUcckMHJa8ZXViTKf9wfBshA5Bkd1wc
         owm90U1AWJAbgLr4OC2miPeax8YhQ1LQKn6bCEki15Fc5AqIdqIsHcuHzaxsO/ebN6LB
         rCuneXc4Oj0k2drZ3gFNzwPIWETywVjFzy6Yo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:cc:message-id:subject:date:mime-version:from
         :content-transfer-encoding:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=T2PZsCU/zoDaabzuYWg/dGeF/TTBnDe7AZ+T8nHxjHQ=;
        b=L78XyijX65sjahMfLfMprqqQorpIBef3L7dEutQTCakbk4OSAbuLqt9OoaG5wglrsi
         QKe+iH6Lzd9hGQsfOH9Hauz02Bj9Omw68AonhrGiCGbvo3h5tQaHEe0RVg4fbzN6Ubm7
         J70l6kOdRweYNiKZCgug5amg1AXCj6y/o8o0pyLciaorw3e3thfo5oU2pgopVn2hQdft
         w1IVGCjGnz3LWt+TAvgw/WAfevfJ8TdQnwsFz9/5Q3W4fZG3YQzG3xr7DApSxzQCbZ+N
         x4W+v4O6TX3OzPqAMmRTERWL+MtNQwV9cniR7mFOBXsXXAqwBXnTJRhJhjVqCPn0fR7P
         F3/w==
X-Gm-Message-State: AFqh2kqje0DjQfhj/wisxdhWZ7Ou8hlxuEnKaJ894oNoe+j1gxQPxG4r
        CMsX1uf82uVfeEcCxAmQu/qHzHWEjvwM/BiDEsY=
X-Google-Smtp-Source: AMrXdXsX1Bc6gMzEQeYIojcPbPPJSEcXyo1ydtdCw0mT0zKdeqJBajoDvP9Q91tLhB+Wte6rb9Omnw==
X-Received: by 2002:ac8:4402:0:b0:3a8:1ca5:e7e2 with SMTP id j2-20020ac84402000000b003a81ca5e7e2mr40676030qtn.7.1672428227239;
        Fri, 30 Dec 2022 11:23:47 -0800 (PST)
Received: from smtpclient.apple (c-98-249-43-138.hsd1.va.comcast.net. [98.249.43.138])
        by smtp.gmail.com with ESMTPSA id 195-20020a370ccc000000b006fec1c0754csm15350939qkm.87.2022.12.30.11.23.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Dec 2022 11:23:46 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Joel Fernandes <joel@joelfernandes.org>
Mime-Version: 1.0 (1.0)
Date:   Fri, 30 Dec 2022 14:23:35 -0500
Subject: Re: [PATCH 6.0 0000/1066] 6.0.16-rc2 review
Message-Id: <E1415508-9D22-4E0F-AF2D-E4588F6555A7@joelfernandes.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        "Paul E. McKenney" <paulmck@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: iPhone Mail (20B101)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> On Dec 30, 2022, at 4:50 AM, Greg Kroah-Hartman <gregkh@linuxfoundation.or=
g> wrote:
>=20
> =EF=BB=BFThis is the start of the stable review cycle for the 6.0.16 relea=
se.
> There are 1066 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sun, 01 Jan 2023 09:38:41 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
>    https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.16=
-rc2.gz
> or in the git tree and branch at:
>    git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.gi=
t linux-6.0.y
> and the diffstat can be found below.

All rcutorture scenarios pass, 30 minutes test time each.

Tested-by: Joel Fernandes (Google) <joel@joelfernandes.org>

Thanks,

 - Joel

>=20
> thanks,
>=20
> greg k-h
>=20
> -------------
> Pseudo-Shortlog of commits:
>=20
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>    Linux 6.0.16-rc2
>=20
> Steven Price <steven.price@arm.com>
>    pwm: tegra: Fix 32 bit build
>=20
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>    mfd: qcom_rpm: Use devm_of_platform_populate() to simplify code
>=20
> ChenXiaoSong <chenxiaosong2@huawei.com>
>    cifs: fix use-after-free on the link name
>=20
> Paulo Alcantara <pc@cjr.nz>
>    cifs: fix memory leaks in session setup
>=20
> Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
>    cifs: Fix xid leak in cifs_get_file_info_unix()
>=20
> Paulo Alcantara <pc@cjr.nz>
>    cifs: fix double-fault crash during ntlmssp
>=20
> Yassine Oudjana <y.oudjana@protonmail.com>
>    extcon: usbc-tusb320: Call the Type-C IRQ handler only if a port is reg=
istered
>=20
> Geert Uytterhoeven <geert+renesas@glider.be>
>    clk: renesas: r8a779f0: Fix SD0H clock name
>=20
> Martin Leung <Martin.Leung@amd.com>
>    drm/amd/display: revert Disable DRR actions during state commit
>=20
> Lin Ma <linma@zju.edu.cn>
>    media: dvbdev: fix refcnt bug
>=20
> Lin Ma <linma@zju.edu.cn>
>    media: dvbdev: fix build warning due to comments
>=20
> Gaosheng Cui <cuigaosheng1@huawei.com>
>    net: stmmac: fix errno when create_singlethread_workqueue() fails
>=20
> Pavel Begunkov <asml.silence@gmail.com>
>    io_uring: remove iopoll spinlock
>=20
> Pavel Begunkov <asml.silence@gmail.com>
>    io_uring: protect cq_timeouts with timeout_lock
>=20
> Pavel Begunkov <asml.silence@gmail.com>
>    io_uring/net: fix cleanup after recycle
>=20
> Pavel Begunkov <asml.silence@gmail.com>
>    io_uring: improve io_double_lock_ctx fail handling
>=20
> Pavel Begunkov <asml.silence@gmail.com>
>    io_uring: add completion locking for iopoll
>=20
> Arun Easi <aeasi@marvell.com>
>    scsi: qla2xxx: Fix crash when I/O abort times out
>=20
> David Hildenbrand <david@redhat.com>
>    mm/gup: disallow FOLL_FORCE|FOLL_WRITE on hugetlb mappings
>=20
> Filipe Manana <fdmanana@suse.com>
>    btrfs: do not BUG_ON() on ENOMEM when dropping extent items for a range=

>=20
> Chen Zhongjin <chenzhongjin@huawei.com>
>    ovl: fix use inode directly in rcu-walk mode
>=20
> Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>    fbdev: fbcon: release buffer when fbcon_do_set_font() failed
>=20
> Rickard x Andersson <rickaran@axis.com>
>    gcov: add support for checksum field
>=20
> Yuan Can <yuancan@huawei.com>
>    floppy: Fix memory leak in do_floppy_init()
>=20
> Johan Hovold <johan+linaro@kernel.org>
>    regulator: core: fix deadlock on regulator enable
>=20
> Rasmus Villemoes <linux@rasmusvillemoes.dk>
>    iio: addac: ad74413r: fix integer promotion bug in ad74413_get_input_cu=
rrent_offset()
>=20
> Rasmus Villemoes <linux@rasmusvillemoes.dk>
>    iio: adc128s052: add proper .data members in adc128_of_match table
>=20
> Nuno S=C3=A1 <nuno.sa@analog.com>
>    iio: adc: ad_sigma_delta: do not use internal iio_dev lock
>=20
> Zeng Heng <zengheng4@huawei.com>
>    iio: fix memory leak in iio_device_register_eventset()
>=20
> Roberto Sassu <roberto.sassu@huawei.com>
>    reiserfs: Add missing calls to reiserfs_security_free()
>=20
> Nathan Chancellor <nathan@kernel.org>
>    security: Restrict CONFIG_ZERO_CALL_USED_REGS to gcc or clang > 15.0.6
>=20
> Schspa Shi <schspa@gmail.com>
>    9p: set req refcount to zero to avoid uninitialized usage
>=20
> Isaac J. Manjarres <isaacmanjarres@google.com>
>    loop: Fix the max_loop commandline argument treatment when it is set to=
 0
>=20
> Enrik Berkhan <Enrik.Berkhan@inka.de>
>    HID: mcp2221: don't connect hidraw
>=20
> Jason Gerecke <killertofu@gmail.com>
>    HID: wacom: Ensure bootloader PID is usable in hidraw mode
>=20
> Mathias Nyman <mathias.nyman@linux.intel.com>
>    xhci: Prevent infinite loop in transaction errors recovery for streams
>=20
> Ferry Toth <ftoth@exalondelft.nl>
>    usb: dwc3: core: defer probe on ulpi_read_id timeout
>=20
> Sven Peter <sven@svenpeter.dev>
>    usb: dwc3: Fix race between dwc3_set_mode and __dwc3_set_mode
>=20
> Li Jun <jun.li@nxp.com>
>    clk: imx: imx8mp: add shared clk gate for usb suspend clk
>=20
> Li Jun <jun.li@nxp.com>
>    dt-bindings: clocks: imx8mp: Add ID for usb suspend clock
>=20
> Johan Hovold <johan+linaro@kernel.org>
>    arm64: dts: qcom: sm8250: fix USB-DP PHY registers
>=20
> Johan Hovold <johan+linaro@kernel.org>
>    arm64: dts: qcom: sm6350: fix USB-DP PHY registers
>=20
> Chunfeng Yun <chunfeng.yun@mediatek.com>
>    usb: xhci-mtk: fix leakage of shared hcd when fail to set wakeup irq
>=20
> Pawel Laszczak <pawell@cadence.com>
>    usb: cdnsp: fix lack of ZLP for ep0
>=20
> Bastien Nocera <hadess@hadess.net>
>    HID: logitech-hidpp: Guard FF init code against non-USB devices
>=20
> Jiao Zhou <jiaozhou@google.com>
>    ALSA: hda/hdmi: Add HP Device 0x8711 to force connect list
>=20
> Edward Pacman <edward@edward-p.xyz>
>    ALSA: hda/realtek: Add quirk for Lenovo TianYi510Pro-14IOB
>=20
> wangdicheng <wangdicheng@kylinos.cn>
>    ALSA: usb-audio: add the quirk for KT0206 device
>=20
> Jeff LaBundy <jeff@labundy.com>
>    Input: iqs7222 - add support for IQS7222A v1.13+
>=20
> Jeff LaBundy <jeff@labundy.com>
>    Input: iqs7222 - trim force communication command
>=20
> Jeff LaBundy <jeff@labundy.com>
>    dt-bindings: input: iqs7222: Add support for IQS7222A v1.13+
>=20
> Jeff LaBundy <jeff@labundy.com>
>    dt-bindings: input: iqs7222: Correct minimum slider size
>=20
> Jeff LaBundy <jeff@labundy.com>
>    dt-bindings: input: iqs7222: Reduce 'linux,code' to optional
>=20
> Jeff LaBundy <jeff@labundy.com>
>    Input: iqs7222 - avoid sending empty SYN_REPORT events
>=20
> GUO Zihua <guozihua@huawei.com>
>    ima: Simplify ima_lsm_copy_rule
>=20
> John Stultz <jstultz@google.com>
>    pstore: Make sure CONFIG_PSTORE_PMSG selects CONFIG_RT_MUTEXES
>=20
> David Howells <dhowells@redhat.com>
>    afs: Fix lost servers_outstanding count
>=20
> Michael Petlan <mpetlan@redhat.com>
>    perf test: Fix "all PMU test" to skip parametrized events
>=20
> Sergio Paracuellos <sergio.paracuellos@gmail.com>
>    MIPS: ralink: mt7621: avoid to init common ralink reset controller
>=20
> Yang Jihong <yangjihong1@huawei.com>
>    perf debug: Set debug_peo_args and redirect_to_stderr variable to corre=
ct values in perf_quiet_option()
>=20
> Arnd Bergmann <arnd@arndb.de>
>    drm/amd/pm: avoid large variable on kernel stack
>=20
> John Stultz <jstultz@google.com>
>    pstore: Switch pmsg_lock to an rt_mutex to avoid priority inversion
>=20
> Kristina Martsenko <kristina.martsenko@arm.com>
>    lkdtm: cfi: Make PAC test work with GCC 7 and 8
>=20
> Kees Cook <keescook@chromium.org>
>    LoadPin: Ignore the "contents" argument of the LSM hooks
>=20
> Khaled Almahallawy <khaled.almahallawy@intel.com>
>    drm/i915/display: Don't disable DDI/Transcoder when setting phy test pa=
ttern
>=20
> Hans de Goede <hdegoede@redhat.com>
>    ASoC: rt5670: Remove unbalanced pm_runtime_put()
>=20
> Wang Jingjin <wangjingjin1@huawei.com>
>    ASoC: rockchip: spdif: Add missing clk_disable_unprepare() in rk_spdif_=
runtime_resume()
>=20
> Marek Szyprowski <m.szyprowski@samsung.com>
>    ASoC: wm8994: Fix potential deadlock
>=20
> Kai Vehmanen <kai.vehmanen@linux.intel.com>
>    ALSA: hda/hdmi: fix stream-id config keep-alive for rt suspend
>=20
> Jaroslav Kysela <perex@perex.cz>
>    ALSA: hda/hdmi: Use only dynamic PCM device allocation
>=20
> Kai Vehmanen <kai.vehmanen@linux.intel.com>
>    ALSA: hda/hdmi: set default audio parameters for KAE silent-stream
>=20
> Kai Vehmanen <kai.vehmanen@linux.intel.com>
>    ALSA: hda/hdmi: fix i915 silent stream programming flow
>=20
> Wang Yufen <wangyufen@huawei.com>
>    ASoC: mediatek: mt8183: fix refcount leak in mt8183_mt6358_ts3a227_max9=
8357_dev_probe()
>=20
> Wang Jingjin <wangjingjin1@huawei.com>
>    ASoC: rockchip: pdm: Add missing clk_disable_unprepare() in rockchip_pd=
m_runtime_resume()
>=20
> Wang Yufen <wangyufen@huawei.com>
>    ASoC: audio-graph-card: fix refcount leak of cpu_ep in __graph_for_each=
_link()
>=20
> Wang Yufen <wangyufen@huawei.com>
>    ASoC: mediatek: mt8173-rt5650-rt5514: fix refcount leak in mt8173_rt565=
0_rt5514_dev_probe()
>=20
> Cezary Rojewski <cezary.rojewski@intel.com>
>    ASoC: Intel: Skylake: Fix driver hang during shutdown
>=20
> Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
>    ALSA: hda: add snd_hdac_stop_streams() helper
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    ASoC: sof_es8336: fix possible use-after-free in sof_es8336_remove()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    hwmon: (jc42) Fix missing unlock on error in jc42_write()
>=20
> Wolfram Sang <wsa+renesas@sang-engineering.com>
>    clk: renesas: r8a779f0: Add TMU and parent SASYNC clocks
>=20
> Wolfram Sang <wsa+renesas@sang-engineering.com>
>    clk: renesas: r8a779f0: Add SDH0 clock
>=20
> Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
>    orangefs: Fix kmemleak in orangefs_{kernel,client}_debug_init()
>=20
> Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
>    orangefs: Fix kmemleak in orangefs_sysfs_init()
>=20
> Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
>    orangefs: Fix kmemleak in orangefs_prepare_debugfs_help_string()
>=20
> Maurizio Lombardi <mlombard@redhat.com>
>    scsi: target: iscsi: Fix a race condition between login_work and the lo=
gin thread
>=20
> Nathan Chancellor <nathan@kernel.org>
>    drm/sti: Fix return type of sti_{dvo,hda,hdmi}_connector_mode_valid()
>=20
> Nathan Chancellor <nathan@kernel.org>
>    drm/fsl-dcu: Fix return type of fsl_dcu_drm_connector_mode_valid()
>=20
> Kumar Meiyappan <Kumar.Meiyappan@microchip.com>
>    scsi: smartpqi: Correct device removal for multi-actuator devices
>=20
> Mike McGowen <mike.mcgowen@microchip.com>
>    scsi: smartpqi: Add new controller PCI IDs
>=20
> Hawkins Jiawei <yin31149@gmail.com>
>    hugetlbfs: fix null-ptr-deref in hugetlbfs_parse_param()
>=20
> Nathan Chancellor <nathan@kernel.org>
>    scsi: elx: libefc: Fix second parameter type in state callbacks
>=20
> Bjorn Helgaas <bhelgaas@google.com>
>    Revert "PCI: Clear PCI_STATUS when setting up device"
>=20
> Kai Ye <yekai13@huawei.com>
>    crypto: hisilicon/qm - increase the memory of local variables
>=20
> Bart Van Assche <bvanassche@acm.org>
>    scsi: ufs: Reduce the START STOP UNIT timeout
>=20
> Justin Tee <justin.tee@broadcom.com>
>    scsi: lpfc: Fix hard lockup when reading the rx_monitor from debugfs
>=20
> Zhiqi Song <songzhiqi1@huawei.com>
>    crypto: hisilicon/hpre - fix resource leak in remove process
>=20
> ChiYuan Huang <cy_huang@richtek.com>
>    regulator: core: Fix resolve supply lookup issue
>=20
> Sven Peter <sven@svenpeter.dev>
>    Bluetooth: Add quirk to disable MWS Transport Configuration
>=20
> Sven Peter <sven@svenpeter.dev>
>    Bluetooth: Add quirk to disable extended scanning
>=20
> Marek Vasut <marex@denx.de>
>    Bluetooth: hci_bcm: Add CYW4373A0 support
>=20
> ChiYuan Huang <cy_huang@richtek.com>
>    regulator: core: Use different devices for resource allocation and DT l=
ookup
>=20
> Xiu Jianfeng <xiujianfeng@huawei.com>
>    clk: st: Fix memory leak in st_of_quadfs_setup()
>=20
> Shigeru Yoshida <syoshida@redhat.com>
>    media: si470x: Fix use-after-free in si470x_int_in_callback()
>=20
> Wolfram Sang <wsa+renesas@sang-engineering.com>
>    mmc: renesas_sdhi: better reset from HS400 mode
>=20
> Wolfram Sang <wsa+renesas@sang-engineering.com>
>    mmc: renesas_sdhi: add quirk for broken register layout
>=20
> Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
>    mmc: f-sdh30: Add quirks for broken timeout clock capability
>=20
> Hawkins Jiawei <yin31149@gmail.com>
>    nfs: fix possible null-ptr-deref when parsing param
>=20
> James Hilliard <james.hilliard1@gmail.com>
>    selftests/bpf: Fix conflicts with built-in functions in bpf_iter_ksym
>=20
> Denis Pauk <pauk.denis@gmail.com>
>    hwmon: (nct6775) add ASUS CROSSHAIR VIII/TUF/ProArt B550M
>=20
> Lorenzo Bianconi <lorenzo@kernel.org>
>    wifi: mt76: do not run mt76u_status_worker if the device is not running=

>=20
> Rui Zhang <zr.zhang@vivo.com>
>    regulator: core: fix use_count leakage when handling boot-on
>=20
> Andrii Nakryiko <andrii@kernel.org>
>    libbpf: Avoid enum forward-declarations in public API in C++ mode
>=20
> Artem Lukyanov <dukzcry@ya.ru>
>    ASoC: amd: yc: Add Xiaomi Redmi Book Pro 14 2022 into DMI table
>=20
> Alvin Lee <Alvin.Lee2@amd.com>
>    drm/amd/display: Fix DTBCLK disable requests and SRC_SEL programming
>=20
> Wesley Chalmers <Wesley.Chalmers@amd.com>
>    drm/amd/display: Use the largest vready_offset in pipe group
>=20
> Ye Bin <yebin10@huawei.com>
>    blk-mq: fix possible memleak when register 'hctx' failed
>=20
> Yunfei Dong <yunfei.dong@mediatek.com>
>    media: mediatek: vcodec: Can't set dst buffer to done when lat decode e=
rror
>=20
> Mazin Al Haddad <mazinalhaddad05@gmail.com>
>    media: dvb-usb: fix memory leak in dvb_usb_adapter_init()
>=20
> Lin Ma <linma@zju.edu.cn>
>    media: dvbdev: adopts refcnt to avoid UAF
>=20
> Yan Lei <yan_lei@dahuatech.com>
>    media: dvb-frontends: fix leak of memory fw
>=20
> Maxim Korotkov <korotkov.maxim.s@gmail.com>
>    ethtool: avoiding integer overflow in ethtool_phys_id()
>=20
> Stanislav Fomichev <sdf@google.com>
>    bpf: Prevent decl_tag from being referenced in func_proto arg
>=20
> Yonghong Song <yhs@fb.com>
>    bpf: Fix a BTF_ID_LIST bug with CONFIG_DEBUG_INFO_BTF not set
>=20
> Stanislav Fomichev <sdf@google.com>
>    ppp: associate skb with a device at tx
>=20
> Felix Fietkau <nbd@nbd.name>
>    net: ethernet: mtk_eth_soc: drop packets to WDMA if the ring is full
>=20
> Schspa Shi <schspa@gmail.com>
>    mrp: introduce active flags to prevent UAF when applicant uninit
>=20
> Eric Dumazet <edumazet@google.com>
>    ipv6/sit: use DEV_STATS_INC() to avoid data-races
>=20
> Eric Dumazet <edumazet@google.com>
>    net: add atomic_long_t to net_device_stats fields
>=20
> Sagi Grimberg <sagi@grimberg.me>
>    nvme-auth: don't override ctrl keys before validation
>=20
> Aurabindo Pillai <aurabindo.pillai@amd.com>
>    drm/amd/display: fix array index out of bound error in bios parser
>=20
> George Shen <george.shen@amd.com>
>    drm/amd/display: Workaround to increase phantom pipe vactive in pipespl=
it
>=20
> Jiang Li <jiang.li@ugreen.com>
>    md/raid1: stop mdx_raid1 thread when raid1 array run failed
>=20
> Xiao Ni <xni@redhat.com>
>    md/raid0, raid10: Don't set discard sectors for request queue
>=20
> Li Zhong <floridsleeves@gmail.com>
>    drivers/md/md-bitmap: check the return value of md_bitmap_get_counter()=

>=20
> Nathan Chancellor <nathan@kernel.org>
>    drm/mediatek: Fix return type of mtk_hdmi_bridge_mode_valid()
>=20
> Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
>    drm/sti: Use drm_mode_copy()
>=20
> Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
>    drm/rockchip: Use drm_mode_copy()
>=20
> Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
>    drm/msm: Use drm_mode_copy()
>=20
> Wesley Chalmers <Wesley.Chalmers@amd.com>
>    drm/amd/display: Disable DRR actions during state commit
>=20
> Nathan Chancellor <nathan@kernel.org>
>    s390/lcs: Fix return type of lcs_start_xmit()
>=20
> Nathan Chancellor <nathan@kernel.org>
>    s390/netiucv: Fix return type of netiucv_tx()
>=20
> Nathan Chancellor <nathan@kernel.org>
>    s390/ctcm: Fix return type of ctc{mp,}m_tx()
>=20
> Nathan Chancellor <nathan@kernel.org>
>    drm/amdgpu: Fix type of second parameter in odn_edit_dpm_table() callba=
ck
>=20
> Nathan Chancellor <nathan@kernel.org>
>    drm/amdgpu: Fix type of second parameter in trans_msg() callback
>=20
> Kees Cook <keescook@chromium.org>
>    igb: Do not free q_vector unless new one was allocated
>=20
> Jos=C3=A9 Exp=C3=B3sito <jose.exposito89@gmail.com>
>    HID: input: do not query XP-PEN Deco LW battery
>=20
> Minsuk Kang <linuxlovemin@yonsei.ac.kr>
>    wifi: brcmfmac: Fix potential shift-out-of-bounds in brcmf_fw_alloc_req=
uest()
>=20
> Nathan Chancellor <nathan@kernel.org>
>    hamradio: baycom_epp: Fix return type of baycom_send_packet()
>=20
> Nathan Chancellor <nathan@kernel.org>
>    net: ethernet: ti: Fix return type of netcp_ndo_start_xmit()
>=20
> Stanislav Fomichev <sdf@google.com>
>    bpf: make sure skb->len !=3D 0 when redirecting to a tunneling device
>=20
> Nathan Chancellor <nathan@kernel.org>
>    drm/meson: Fix return type of meson_encoder_cvbs_mode_valid()
>=20
> Jiri Slaby (SUSE) <jirislaby@kernel.org>
>    qed (gcc13): use u16 for fid to be big enough
>=20
> Rahul Bhattacharjee <quic_rbhattac@quicinc.com>
>    wifi: ath11k: Fix qmi_msg_handler data structure initialization
>=20
> Kerem Karabay <kekrby@gmail.com>
>    HID: apple: enable APPLE_ISO_TILDE_QUIRK for the keyboards of Macs with=
 the T2 chip
>=20
> Kerem Karabay <kekrby@gmail.com>
>    HID: apple: fix key translations where multiple quirks attempt to trans=
late the same key
>=20
> David Jeffery <djeffery@redhat.com>
>    blk-mq: avoid double ->queue_rq() because of early timeout
>=20
> Yuan Can <yuancan@huawei.com>
>    drm/rockchip: use pm_runtime_resume_and_get() instead of pm_runtime_get=
_sync()
>=20
> Hamza Mahfooz <hamza.mahfooz@amd.com>
>    Revert "drm/amd/display: Limit max DSC target bpp for specific monitors=
"
>=20
> Hamza Mahfooz <hamza.mahfooz@amd.com>
>    drm/edid: add a quirk for two LG monitors to get them to work on 10bpc
>=20
> gehao <gehao@kylinos.cn>
>    drm/amd/display: prevent memory leak
>=20
> Youghandhar Chintala <quic_youghand@quicinc.com>
>    wifi: ath10k: Delay the unmapping of the buffer
>=20
> Zhang Yuchen <zhangyuchen.lcr@bytedance.com>
>    ipmi: fix memleak when unload ipmi driver
>=20
> Amadeusz S=C5=82awi=C5=84ski <amadeuszx.slawinski@linux.intel.com>
>    ASoC: Intel: avs: Add quirk for KBL-R RVP platform
>=20
> Amadeusz S=C5=82awi=C5=84ski <amadeuszx.slawinski@linux.intel.com>
>    ASoC: codecs: rt298: Add quirk for KBL-R RVP platform
>=20
> Shigeru Yoshida <syoshida@redhat.com>
>    wifi: ar5523: Fix use-after-free on ar5523_cmd() timed out
>=20
> Fedor Pchelkin <pchelkin@ispras.ru>
>    wifi: ath9k: verify the expected usb_endpoints are present
>=20
> Wright Feng <wright.feng@cypress.com>
>    brcmfmac: return error when getting invalid max_flowrings from dongle
>=20
> Ming Qian <ming.qian@nxp.com>
>    media: imx-jpeg: Disable useless interrupt to avoid kernel panic
>=20
> Doug Brown <doug@schmorgal.com>
>    drm/etnaviv: add missing quirks for GC300
>=20
> ZhangPeng <zhangpeng362@huawei.com>
>    hfs: fix OOB Read in __hfs_brec_find
>=20
> Hans de Goede <hdegoede@redhat.com>
>    ACPI: x86: Add skip i2c clients quirk for Medion Lifetab S10346
>=20
> Hans de Goede <hdegoede@redhat.com>
>    ACPI: x86: Add skip i2c clients quirk for Lenovo Yoga Tab 3 Pro (YT3-X9=
0F)
>=20
> Mateusz Jo=C5=84czyk <mat.jonczyk@o2.pl>
>    x86/apic: Handle no CONFIG_X86_X2APIC on systems with x2APIC enabled by=
 BIOS
>=20
> Zheng Yejian <zhengyejian1@huawei.com>
>    acct: fix potential integer overflow in encode_comp_t()
>=20
> Ryusuke Konishi <konishi.ryusuke@gmail.com>
>    nilfs2: fix shift-out-of-bounds due to too large exponent of block size=

>=20
> Ryusuke Konishi <konishi.ryusuke@gmail.com>
>    nilfs2: fix shift-out-of-bounds/overflow in nilfs_sb2_bad_offset()
>=20
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>    ACPICA: Fix error code path in acpi_ds_call_control_method()
>=20
> Mia Kanashi <chad@redpilled.dev>
>    ACPI: EC: Add quirk for the HP Pavilion Gaming 15-cx0041ur
>=20
> Li Zhong <floridsleeves@gmail.com>
>    ACPI: processor: idle: Check acpi_fetch_acpi_dev() return value
>=20
> Hoi Pok Wu <wuhoipok@gmail.com>
>    fs: jfs: fix shift-out-of-bounds in dbDiscardAG
>=20
> Dr. David Alan Gilbert <linux@treblig.org>
>    jfs: Fix fortify moan in symlink
>=20
> Shigeru Yoshida <syoshida@redhat.com>
>    udf: Avoid double brelse() in udf_rename()
>=20
> Dongliang Mu <mudongliangabcd@gmail.com>
>    fs: jfs: fix shift-out-of-bounds in dbAllocAG
>=20
> Marijn Suijten <marijn.suijten@somainline.org>
>    arm64: dts: qcom: sm6350: Add apps_smmu with streamID to SDHCI 1/2 node=
s
>=20
> Liu Shixin <liushixin2@huawei.com>
>    binfmt_misc: fix shift-out-of-bounds in check_special_flags
>=20
> Gaurav Kohli <gauravkohli@linux.microsoft.com>
>    x86/hyperv: Remove unregister syscore call from Hyper-V cleanup
>=20
> Guilherme G. Piccoli <gpiccoli@igalia.com>
>    video: hyperv_fb: Avoid taking busy spinlock on panic path
>=20
> Adriana Kobylak <anoo@us.ibm.com>
>    ARM: dts: aspeed: rainier,everest: Move reserved memory regions
>=20
> Mark Rutland <mark.rutland@arm.com>
>    arm64: make is_ttbrX_addr() noinstr-safe
>=20
> Zqiang <qiang1.zhang@intel.com>
>    rcu: Fix __this_cpu_read() lockdep warning in rcu_force_quiescent_state=
()
>=20
> Jiasheng Jiang <jiasheng@iscas.ac.cn>
>    HID: amd_sfh: Add missing check for dma_alloc_coherent
>=20
> Matt Johnston <matt@codeconstruct.com.au>
>    mctp: Remove device type check at unregister
>=20
> Jeremy Kerr <jk@codeconstruct.com.au>
>    mctp: serial: Fix starting value for frame check sequence
>=20
> Eric Dumazet <edumazet@google.com>
>    net: stream: purge sk_error_queue in sk_stream_kill_queues()
>=20
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>    myri10ge: Fix an error handling path in myri10ge_probe()
>=20
> David Howells <dhowells@redhat.com>
>    rxrpc: Fix missing unlock in rxrpc_do_sendmsg()
>=20
> Cong Wang <cong.wang@bytedance.com>
>    net_sched: reject TCF_EM_SIMPLE case for complex ematch module
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    mailbox: zynq-ipi: fix error handling while device_register() fails
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    mailbox: arm_mhuv2: Fix return value check in mhuv2_probe()
>=20
> Conor Dooley <conor.dooley@microchip.com>
>    mailbox: mpfs: read the system controller's status
>=20
> Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>
>    skbuff: Account for tail adjustment during pull operations
>=20
> Jakub Kicinski <kuba@kernel.org>
>    devlink: protect devlink dump by the instance lock
>=20
> Chen-Yu Tsai <wenst@chromium.org>
>    arm64: dts: mt8183: Fix Mali GPU clock
>=20
> Chun-Jie Chen <chun-jie.chen@mediatek.com>
>    soc: mediatek: pm-domains: Fix the power glitch issue
>=20
> Eelco Chaudron <echaudro@redhat.com>
>    openvswitch: Fix flow lookup to use unmasked key
>=20
> Jakub Kicinski <kuba@kernel.org>
>    selftests: devlink: fix the fd redirect in dummy_reporter_test
>=20
> Jakub Kicinski <kuba@kernel.org>
>    devlink: hold region lock when flushing snapshots
>=20
> GUO Zihua <guozihua@huawei.com>
>    rtc: mxc_v2: Add missing clk_disable_unprepare()
>=20
> Tan Tee Min <tee.min.tan@linux.intel.com>
>    igc: Set Qbv start_time and end_time to end_time if not being configure=
d in GCL
>=20
> Tan Tee Min <tee.min.tan@linux.intel.com>
>    igc: recalculate Qbv end_time by considering cycle time
>=20
> Tan Tee Min <tee.min.tan@linux.intel.com>
>    igc: allow BaseTime 0 enrollment for Qbv
>=20
> Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
>    igc: Add checking for basetime less than zero
>=20
> Vinicius Costa Gomes <vinicius.gomes@intel.com>
>    igc: Use strict cycles for Qbv scheduling
>=20
> Vinicius Costa Gomes <vinicius.gomes@intel.com>
>    igc: Enhance Qbv scheduling by using first flag bit
>=20
> Vladimir Oltean <vladimir.oltean@nxp.com>
>    net: dsa: mv88e6xxx: avoid reg_lock deadlock in mv88e6xxx_setup_port()
>=20
> Li Zetao <lizetao1@huawei.com>
>    r6040: Fix kmemleak in probe and remove
>=20
> Kirill Tkhai <tkhai@ya.ru>
>    unix: Fix race in SOCK_SEQPACKET's unix_dgram_sendmsg()
>=20
> Minsuk Kang <linuxlovemin@yonsei.ac.kr>
>    nfc: pn533: Clear nfc_target before being used
>=20
> Vladimir Oltean <vladimir.oltean@nxp.com>
>    net: enetc: avoid buffer leaks on xdp_do_redirect() failure
>=20
> Hans Verkuil <hverkuil-cisco@xs4all.nl>
>    media: v4l2-ctrls-api.c: add back dropped ctrl->is_new =3D 1
>=20
> Milan Landaverde <milan@mdaverde.com>
>    bpf: prevent leak of lsm program after failed attach
>=20
> Song Liu <song@kernel.org>
>    selftests/bpf: Select CONFIG_FUNCTION_ERROR_INJECTION
>=20
> Yu Kuai <yukuai3@huawei.com>
>    block, bfq: fix possible uaf for 'bfqq->bic'
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    mISDN: hfcmulti: don't call dev_kfree_skb/kfree_skb() under spin_lock_i=
rqsave()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    mISDN: hfcpci: don't call dev_kfree_skb/kfree_skb() under spin_lock_irq=
save()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    mISDN: hfcsusb: don't call dev_kfree_skb/kfree_skb() under spin_lock_ir=
qsave()
>=20
> Hangbin Liu <liuhangbin@gmail.com>
>    bonding: do failover when high prio link up
>=20
> Hangbin Liu <liuhangbin@gmail.com>
>    bonding: add missed __rcu annotation for curr_active_slave
>=20
> Emeel Hakim <ehakim@nvidia.com>
>    net: macsec: fix net device access prior to holding a lock
>=20
> Dan Aloni <dan.aloni@vastdata.com>
>    nfsd: under NFSv4.1, fix double svc_xprt_put on rpc_create failure
>=20
> Dan Carpenter <error27@gmail.com>
>    iommu/mediatek: Fix forever loop in error handling
>=20
> Alexandre Belloni <alexandre.belloni@bootlin.com>
>    rtc: pcf85063: fix pcf85063_clkout_control
>=20
> Gaosheng Cui <cuigaosheng1@huawei.com>
>    rtc: pic32: Move devm_rtc_allocate_device earlier in pic32_rtc_probe()
>=20
> Gaosheng Cui <cuigaosheng1@huawei.com>
>    rtc: st-lpc: Add missing clk_disable_unprepare in st_rtc_probe()
>=20
> Qingfang DENG <dqfext@gmail.com>
>    netfilter: flowtable: really fix NAT IPv6 offload
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    mfd: pm8008: Fix return value check in pm8008_probe()
>=20
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>    mfd: qcom_rpm: Fix an error handling path in qcom_rpm_probe()
>=20
> Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
>    mfd: bd957x: Fix Kconfig dependency on REGMAP_IRQ
>=20
> Samuel Holland <samuel@sholland.org>
>    mfd: axp20x: Do not sleep in the power off handler
>=20
> Bryan O'Donoghue <bryan.odonoghue@linaro.org>
>    dt-bindings: mfd: qcom,spmi-pmic: Drop PWM reg dependency
>=20
> Nathan Lynch <nathanl@linux.ibm.com>
>    powerpc/pseries/eeh: use correct API for error log size
>=20
> Shang XiaoJing <shangxiaojing@huawei.com>
>    remoteproc: qcom: q6v5: Fix missing clk_disable_unprepare() in q6v5_wcs=
s_qcs404_power_on()
>=20
> Yuan Can <yuancan@huawei.com>
>    remoteproc: qcom_q6v5_pas: Fix missing of_node_put() in adsp_alloc_memo=
ry_region()
>=20
> Luca Weiss <luca.weiss@fairphone.com>
>    remoteproc: qcom_q6v5_pas: detach power domains on remove
>=20
> Luca Weiss <luca.weiss@fairphone.com>
>    remoteproc: qcom_q6v5_pas: disable wakeup on probe fail or remove
>=20
> Shang XiaoJing <shangxiaojing@huawei.com>
>    remoteproc: qcom: q6v5: Fix potential null-ptr-deref in q6v5_wcss_init_=
mmio()
>=20
> Gaosheng Cui <cuigaosheng1@huawei.com>
>    remoteproc: sysmon: fix memory leak in qcom_add_sysmon_subdev()
>=20
> Anup Patel <apatel@ventanamicro.com>
>    RISC-V: KVM: Fix reg_val check in kvm_riscv_vcpu_set_reg_config()
>=20
> Daniel Golle <daniel@makrotopia.org>
>    pwm: mediatek: always use bus clock for PWM on MT7622
>=20
> xinlei lee <xinlei.lee@mediatek.com>
>    pwm: mtk-disp: Fix the parameters calculated by the enabled flag of dis=
p_pwm
>=20
> Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
>    pwm: sifive: Call pwm_sifive_update_clock() while mutex is held
>=20
> Jason Gunthorpe <jgg@ziepe.ca>
>    iommu/sun50i: Remove IOMMU_DOMAIN_IDENTITY
>=20
> Guenter Roeck <groeck@chromium.org>
>    iommu/mediatek: Validate number of phandles associated with "mediatek,l=
arbs"
>=20
> Yong Wu <yong.wu@mediatek.com>
>    iommu/mediatek: Add error path for loop of mm_dts_parse
>=20
> Yong Wu <yong.wu@mediatek.com>
>    iommu/mediatek: Use component_match_add
>=20
> Yong Wu <yong.wu@mediatek.com>
>    iommu/mediatek: Add platform_device_put for recovering the device refcn=
t
>=20
> Miaoqian Lin <linmq006@gmail.com>
>    selftests/powerpc: Fix resource leaks
>=20
> Kajol Jain <kjain@linux.ibm.com>
>    powerpc/hv-gpci: Fix hv_gpci event list
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    powerpc/83xx/mpc832x_rdb: call platform_device_put() in error case in o=
f_fsl_spi_probe()
>=20
> Nicholas Piggin <npiggin@gmail.com>
>    powerpc/perf: callchain validate kernel stack pointer bounds
>=20
> Pali Roh=C3=A1r <pali@kernel.org>
>    powerpc: dts: turris1x.dts: Add channel labels for temperature sensor
>=20
> Li Huafei <lihuafei1@huawei.com>
>    kprobes: Fix check for probe enabled in kill_kprobe()
>=20
> Nayna Jain <nayna@linux.ibm.com>
>    powerpc/pseries: fix plpks_read_var() code for different consumers
>=20
> Nayna Jain <nayna@linux.ibm.com>
>    powerpc/pseries: Return -EIO instead of -EINTR for H_ABORTED error
>=20
> Nayna Jain <nayna@linux.ibm.com>
>    powerpc/pseries: Fix the H_CALL error code in PLPKS driver
>=20
> Nayna Jain <nayna@linux.ibm.com>
>    powerpc/pseries: fix the object owners enum value in plpks driver
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    powerpc/xive: add missing iounmap() in error path in xive_spapr_populat=
e_irq_data()
>=20
> Gustavo A. R. Silva <gustavoars@kernel.org>
>    powerpc/xmon: Fix -Wswitch-unreachable warning in bpt_cmds
>=20
> Miaoqian Lin <linmq006@gmail.com>
>    cxl: Fix refcount leak in cxl_calc_capp_routing
>=20
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>    powerpc/52xx: Fix a resource leak in an error handling path
>=20
> Xie Shaowen <studentxswpy@163.com>
>    macintosh/macio-adb: check the return value of ioremap()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    macintosh: fix possible memory leak in macio_add_one_device()
>=20
> Yuan Can <yuancan@huawei.com>
>    iommu/fsl_pamu: Fix resource leak in fsl_pamu_probe()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    iommu/amd: Fix pci device refcount leak in ppr_notifier()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    iommu/mediatek: Check return value after calling platform_get_resource(=
)
>=20
> Alexander Stein <alexander.stein@ew.tq-group.com>
>    rtc: pcf85063: Fix reading alarm
>=20
> Stefan Eichenberger <stefan.eichenberger@toradex.com>
>    rtc: snvs: Allow a time difference on clock register read
>=20
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>    rtc: cmos: Disable ACPI RTC event on removal
>=20
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>    rtc: cmos: Rename ACPI-related functions
>=20
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>    rtc: cmos: Eliminate forward declarations of some functions
>=20
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>    rtc: cmos: Call rtc_wake_setup() from cmos_do_probe()
>=20
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>    rtc: cmos: Call cmos_wake_setup() from cmos_do_probe()
>=20
> Shang XiaoJing <shangxiaojing@huawei.com>
>    rtc: class: Fix potential memleak in devm_rtc_allocate_device()
>=20
> Yushan Zhou <katrinzhou@tencent.com>
>    rtc: rzn1: Check return value in rzn1_rtc_probe
>=20
> Fenghua Yu <fenghua.yu@intel.com>
>    dmaengine: idxd: Fix crc_val field for completion record
>=20
> Abdun Nihaal <abdun.nihaal@gmail.com>
>    fs/ntfs3: Fix slab-out-of-bounds read in ntfs_trim_fs
>=20
> Manivannan Sadhasivam <mani@kernel.org>
>    phy: qcom-qmp-pcie: Fix sm8450_qmp_gen4x2_pcie_pcs_tbl[] register names=

>=20
> Jon Hunter <jonathanh@nvidia.com>
>    pwm: tegra: Ensure the clock rate is not less than needed
>=20
> Jon Hunter <jonathanh@nvidia.com>
>    pwm: tegra: Improve required rate calculation
>=20
> Matt Redfearn <matt.redfearn@mips.com>
>    include/uapi/linux/swab: Fix potentially missing __always_inline
>=20
> Justin Chen <justinpopo6@gmail.com>
>    phy: usb: Fix clock imbalance for suspend/resume
>=20
> Justin Chen <justinpopo6@gmail.com>
>    phy: usb: Use slow clock for wake enabled suspend
>=20
> Al Cooper <alcooperx@gmail.com>
>    phy: usb: s2 WoL wakeup_count not incremented for USB->Eth devices
>=20
> Michael Riesch <michael.riesch@wolfvision.net>
>    iommu/rockchip: fix permission bits in page table entries v2
>=20
> Jernej Skrabec <jernej.skrabec@gmail.com>
>    iommu/sun50i: Implement .iotlb_sync_map
>=20
> Jernej Skrabec <jernej.skrabec@gmail.com>
>    iommu/sun50i: Fix flush size
>=20
> Jernej Skrabec <jernej.skrabec@gmail.com>
>    iommu/sun50i: Fix R/W permission check
>=20
> Jernej Skrabec <jernej.skrabec@gmail.com>
>    iommu/sun50i: Consider all fault sources for reset
>=20
> Jernej Skrabec <jernej.skrabec@gmail.com>
>    iommu/sun50i: Fix reset release
>=20
> Niklas Schnelle <schnelle@linux.ibm.com>
>    iommu/s390: Fix duplicate domain attachments
>=20
> Johan Hovold <johan+linaro@kernel.org>
>    phy: qcom-qmp-pcie: fix ipq8074-gen3 initialisation
>=20
> Martin Povi=C5=A1er <povik+lin@cutebit.org>
>    dmaengine: apple-admac: Allocate cache SRAM to channels
>=20
> Martin Povi=C5=A1er <povik+lin@cutebit.org>
>    dmaengine: apple-admac: Do not use devres for IRQs
>=20
> Johan Hovold <johan+linaro@kernel.org>
>    phy: qcom-qmp-pcie: drop bogus register update
>=20
> Pali Roh=C3=A1r <pali@kernel.org>
>    phy: marvell: phy-mvebu-a3700-comphy: Reset COMPHY registers before USB=
 3.0 power on
>=20
> Dan Carpenter <dan.carpenter@oracle.com>
>    fs/ntfs3: Harden against integer overflows
>=20
> Shigeru Yoshida <syoshida@redhat.com>
>    fs/ntfs3: Avoid UBSAN error on true_sectors_per_clst()
>=20
> Arnd Bergmann <arnd@arndb.de>
>    RDMA/siw: Fix pointer cast warning
>=20
> Namhyung Kim <namhyung@kernel.org>
>    perf stat: Do not delay the workload with --delay
>=20
> Ard Biesheuvel <ardb@kernel.org>
>    ftrace: Allow WITH_ARGS flavour of graph tracer with shadow call stack
>=20
> Namhyung Kim <namhyung@kernel.org>
>    perf off_cpu: Fix a typo in BTF tracepoint name, it should be 'btf_trac=
e_sched_switch'
>=20
> Luca Weiss <luca@z3ntu.xyz>
>    leds: is31fl319x: Fix setting current limit for is31fl319{0,1,3}
>=20
> ruanjinjie <ruanjinjie@huawei.com>
>    power: supply: fix null pointer dereferencing in power_supply_get_batte=
ry_info
>=20
> Hans de Goede <hdegoede@redhat.com>
>    power: supply: bq25890: Ensure pump_express_work is cancelled on remove=

>=20
> Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
>    power: supply: bq25890: Convert to i2c's .probe_new()
>=20
> Marek Vasut <marex@denx.de>
>    power: supply: bq25890: Factor out regulator registration code
>=20
> Yuan Can <yuancan@huawei.com>
>    power: supply: ab8500: Fix error handling in ab8500_charger_init()
>=20
> Yuan Can <yuancan@huawei.com>
>    HSI: omap_ssi_core: Fix error handling in ssi_init()
>=20
> Shang XiaoJing <shangxiaojing@huawei.com>
>    power: supply: cw2015: Fix potential null-ptr-deref in cw_bat_probe()
>=20
> Zheyu Ma <zheyuma97@gmail.com>
>    power: supply: cw2015: Use device managed API to simplify the code
>=20
> Zhang Qilong <zhangqilong3@huawei.com>
>    power: supply: z2_battery: Fix possible memleak in z2_batt_probe()
>=20
> Ajay Kaher <akaher@vmware.com>
>    perf symbol: correction while adjusting symbol
>=20
> Leo Yan <leo.yan@linaro.org>
>    perf trace: Handle failure when trace point folder is missed
>=20
> Leo Yan <leo.yan@linaro.org>
>    perf trace: Use macro RAW_SYSCALL_ARGS_NUM to replace number
>=20
> Leo Yan <leo.yan@linaro.org>
>    perf trace: Return error if a system call doesn't exist
>=20
> Mika Westerberg <mika.westerberg@linux.intel.com>
>    watchdog: iTCO_wdt: Set NO_REBOOT if the watchdog is not already runnin=
g
>=20
> Zeng Heng <zengheng4@huawei.com>
>    power: supply: fix residue sysfs file in error handle route of __power_=
supply_register()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    HSI: omap_ssi_core: fix possible memory leak in ssi_probe()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    HSI: omap_ssi_core: fix unbalanced pm_runtime_disable()
>=20
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>    led: qcom-lpg: Fix sleeping in atomic
>=20
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>    fbdev: uvesafb: Fixes an error handling path in uvesafb_probe()
>=20
> Randy Dunlap <rdunlap@infradead.org>
>    fbdev: uvesafb: don't build on UML
>=20
> Randy Dunlap <rdunlap@infradead.org>
>    fbdev: geode: don't build on UML
>=20
> Gaosheng Cui <cuigaosheng1@huawei.com>
>    fbdev: ep93xx-fb: Add missing clk_disable_unprepare in ep93xxfb_probe()=

>=20
> Xiongfeng Wang <wangxiongfeng2@huawei.com>
>    fbdev: vermilion: decrease reference count in error path
>=20
> Shang XiaoJing <shangxiaojing@huawei.com>
>    fbdev: via: Fix error in via_core_init()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    fbdev: pm2fb: fix missing pci_disable_device()
>=20
> Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>    fbdev: ssd1307fb: Drop optional dependency
>=20
> Bjorn Andersson <andersson@kernel.org>
>    thermal/drivers/qcom/lmh: Fix irq handler return value
>=20
> Luca Weiss <luca.weiss@fairphone.com>
>    thermal/drivers/qcom/temp-alarm: Fix inaccurate warning for gen2
>=20
> Keerthy <j-keerthy@ti.com>
>    thermal/drivers/k3_j72xx_bandgap: Fix the debug print message
>=20
> Marcus Folkesson <marcus.folkesson@gmail.com>
>    thermal/drivers/imx8mm_thermal: Validate temperature range
>=20
> Shang XiaoJing <shangxiaojing@huawei.com>
>    samples: vfio-mdev: Fix missing pci_disable_device() in mdpy_fb_probe()=

>=20
> Xiu Jianfeng <xiujianfeng@huawei.com>
>    ksmbd: Fix resource leak in ksmbd_session_rpc_open()
>=20
> Zheng Yejian <zhengyejian1@huawei.com>
>    tracing/hist: Fix issue of losting command info in error_log
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    usb: typec: wusb3801: fix fwnode refcount leak in wusb3801_probe()
>=20
> Jiasheng Jiang <jiasheng@iscas.ac.cn>
>    usb: storage: Add check for kcalloc
>=20
> Zheyu Ma <zheyuma97@gmail.com>
>    i2c: ismt: Fix an out-of-bounds bug in ismt_access()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    i2c: mux: reg: check return value after calling platform_get_resource()=

>=20
> Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
>    gpiolib: protect the GPIO device against being dropped while in use by u=
ser-space
>=20
> Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
>    gpiolib: cdev: fix NULL-pointer dereferences
>=20
> Chen Zhongjin <chenzhongjin@huawei.com>
>    vme: Fix error not catched in fake_init()
>=20
> YueHaibing <yuehaibing@huawei.com>
>    staging: rtl8192e: Fix potential use-after-free in rtllib_rx_Monitor()
>=20
> Dan Carpenter <error27@gmail.com>
>    staging: rtl8192u: Fix use after free in ieee80211_rx()
>=20
> Hui Tang <tanghui20@huawei.com>
>    i2c: pxa-pci: fix missing pci_disable_device() on error in ce4100_i2c_p=
robe
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    chardev: fix error handling in cdev_device_add()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    mcb: mcb-parse: fix error handing in chameleon_parse_gdd()
>=20
> Zhengchao Shao <shaozhengchao@huawei.com>
>    drivers: mcb: fix resource leak in mcb_probe()
>=20
> John Keeping <john@metanate.com>
>    usb: gadget: f_hid: fix refcount leak on error path
>=20
> John Keeping <john@metanate.com>
>    usb: gadget: f_hid: fix f_hidg lifetime vs cdev
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    usb: core: hcd: Fix return value check in usb_hcd_setup_local_mem()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    usb: roles: fix of node refcount leak in usb_role_switch_is_parent()
>=20
> Beau Belgrave <beaub@linux.microsoft.com>
>    tracing/user_events: Fix call print_fmt leak
>=20
> Yang Shen <shenyang39@huawei.com>
>    coresight: trbe: remove cpuhp instance node before remove cpuhp state
>=20
> Fabrice Gasnier <fabrice.gasnier@foss.st.com>
>    counter: stm32-lptimer-cnt: fix the check on arr and cmp registers upda=
te
>=20
> Ramona Bolboaca <ramona.bolboaca@analog.com>
>    iio: adis: add '__adis_enable_irq()' implementation
>=20
> Cosmin Tanislav <cosmin.tanislav@analog.com>
>    iio: temperature: ltc2983: make bulk write buffer DMA-safe
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    cxl: fix possible null-ptr-deref in cxl_pci_init_afu|adapter()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    cxl: fix possible null-ptr-deref in cxl_guest_init_afu|adapter()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    firmware: raspberrypi: fix possible memory leak in rpi_firmware_probe()=

>=20
> Zheng Wang <zyytlz.wz@163.com>
>    misc: sgi-gru: fix use-after-free error in gru_set_context_option, gru_=
fault and gru_handle_user_call_os
>=20
> ruanjinjie <ruanjinjie@huawei.com>
>    misc: tifm: fix possible memory leak in tifm_7xx1_switch_media()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    ocxl: fix pci device refcount leak when calling get_function_0()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    misc: ocxl: fix possible name leak in ocxl_file_register_afu()
>=20
> Zhengchao Shao <shaozhengchao@huawei.com>
>    test_firmware: fix memory leak in test_firmware_init()
>=20
> Yuan Can <yuancan@huawei.com>
>    serial: sunsab: Fix error handling in sunsab_init()
>=20
> Gabriel Somlo <gsomlo@gmail.com>
>    serial: altera_uart: fix locking in polling mode
>=20
> Jiri Slaby <jirislaby@kernel.org>
>    tty: serial: altera_uart_{r,t}x_chars() need only uart_port
>=20
> Jiri Slaby <jirislaby@kernel.org>
>    tty: serial: clean up stop-tx part in altera_uart_tx_chars()
>=20
> Xiongfeng Wang <wangxiongfeng2@huawei.com>
>    serial: pch: Fix PCI device refcount leak in pch_request_dma()
>=20
> Valentin Caron <valentin.caron@foss.st.com>
>    serial: stm32: move dma_request_chan() before clk_prepare_enable()
>=20
> delisun <delisun@pateo.com.cn>
>    serial: pl011: Do not clear RX FIFO & RX interrupt in unthrottle.
>=20
> Jiamei Xie <jiamei.xie@arm.com>
>    serial: amba-pl011: avoid SBSA UART accessing DMACR register
>=20
> Jiantao Zhang <water.zhangjiantao@huawei.com>
>    USB: gadget: Fix use-after-free during usb config switch
>=20
> Marek Vasut <marex@denx.de>
>    extcon: usbc-tusb320: Update state on probe even if no IRQ pending
>=20
> Marek Vasut <marex@denx.de>
>    extcon: usbc-tusb320: Add USB TYPE-C support
>=20
> Marek Vasut <marex@denx.de>
>    extcon: usbc-tusb320: Factor out extcon into dedicated functions
>=20
> Tony Lindgren <tony@atomide.com>
>    usb: musb: omap2430: Fix probe regression for missing resources
>=20
> Sven Peter <sven@svenpeter.dev>
>    usb: typec: tipd: Fix typec_unregister_port error paths
>=20
> Sven Peter <sven@svenpeter.dev>
>    usb: typec: tipd: Fix spurious fwnode_handle_put in error path
>=20
> Sven Peter <sven@svenpeter.dev>
>    usb: typec: tipd: Cleanup resources if devm_tps6598_psy_register fails
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    usb: typec: tcpci: fix of node refcount leak in tcpci_register_port()
>=20
> Sven Peter <sven@svenpeter.dev>
>    usb: typec: Check for ops->exit instead of ops->enter in altmode_exit
>=20
> Gaosheng Cui <cuigaosheng1@huawei.com>
>    staging: vme_user: Fix possible UAF in tsi148_dma_list_add
>=20
> Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>    interconnect: qcom: sc7180: fix dropped const of qcom_icc_bcm
>=20
> Linus Walleij <linus.walleij@linaro.org>
>    usb: fotg210-udc: Fix ages old endianness issues
>=20
> Rafael Mendonca <rafaelmendsr@gmail.com>
>    uio: uio_dmem_genirq: Fix deadlock between irq config and handling
>=20
> Rafael Mendonca <rafaelmendsr@gmail.com>
>    uio: uio_dmem_genirq: Fix missing unlock in irq configuration
>=20
> Rafael Mendonca <rafaelmendsr@gmail.com>
>    vfio: platform: Do not pass return buffer to ACPI _RST method
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    class: fix possible memory leak in __class_register()
>=20
> Duoming Zhou <duoming@zju.edu.cn>
>    drivers: staging: r8188eu: Fix sleep-in-atomic-context bug in rtw_join_=
timeout_handler
>=20
> Yuan Can <yuancan@huawei.com>
>    serial: 8250_bcm7271: Fix error handling in brcmuart_init()
>=20
> Kartik <kkartik@nvidia.com>
>    serial: tegra: Read DMA status before terminating
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    drivers: dio: fix possible memory leak in dio_init()
>=20
> Alexandre Ghiti <alexghiti@rivosinc.com>
>    riscv: Fix P4D_SHIFT definition for 3-level page table mode
>=20
> Yangtao Li <frank.li@vivo.com>
>    f2fs: fix iostat parameter for discard
>=20
> Palmer Dabbelt <palmer@rivosinc.com>
>    RISC-V: Align the shadow stack
>=20
> Dragos Tatulea <dtatulea@nvidia.com>
>    IB/IPoIB: Fix queue count inconsistency for PKEY child interfaces
>=20
> Xiongfeng Wang <wangxiongfeng2@huawei.com>
>    hwrng: geode - Fix PCI device refcount leak
>=20
> Xiongfeng Wang <wangxiongfeng2@huawei.com>
>    hwrng: amd - Fix PCI device refcount leak
>=20
> Gaosheng Cui <cuigaosheng1@huawei.com>
>    crypto: img-hash - Fix variable dereferenced before check 'hdev->req'
>=20
> Samuel Holland <samuel@sholland.org>
>    riscv: Fix crash during early errata patching
>=20
> Anup Patel <apatel@ventanamicro.com>
>    RISC-V: Fix MEMREMAP_WB for systems with Svpbmt
>=20
> Andrew Bresticker <abrestic@rivosinc.com>
>    RISC-V: Fix unannoted hardirqs-on in return to userspace slow-path
>=20
> Chengchang Tang <tangchengchang@huawei.com>
>    RDMA/hns: Fix XRC caps on HIP08
>=20
> Chengchang Tang <tangchengchang@huawei.com>
>    RDMA/hns: Fix error code of CMD
>=20
> Chengchang Tang <tangchengchang@huawei.com>
>    RDMA/hns: Fix page size cap from firmware
>=20
> Chengchang Tang <tangchengchang@huawei.com>
>    RDMA/hns: Fix PBL page MTR find
>=20
> Chengchang Tang <tangchengchang@huawei.com>
>    RDMA/hns: Fix AH attr queried by query_qp
>=20
> Yixing Liu <liuyixing1@huawei.com>
>    RDMA/hns: Fix the gid problem caused by free mr
>=20
> Wenpeng Liang <liangwenpeng@huawei.com>
>    RDMA/hns: Remove redundant DFX file and DFX ops structure
>=20
> Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
>    orangefs: Fix sysfs not cleanup when dev init failed
>=20
> Francisco Munoz <francisco.munoz.ruiz@linux.intel.com>
>    PCI: vmd: Fix secondary bus reset for Intel bridges
>=20
> Wang Yufen <wangyufen@huawei.com>
>    RDMA/srp: Fix error return code in srp_parse_options()
>=20
> Wang Yufen <wangyufen@huawei.com>
>    RDMA/hfi1: Fix error return code in parse_platform_config()
>=20
> Randy Dunlap <rdunlap@infradead.org>
>    RDMA: Disable IB HW for UML
>=20
> Tong Tiangen <tongtiangen@huawei.com>
>    riscv/mm: add arch hook arch_clear_hugepage_flags
>=20
> Shang XiaoJing <shangxiaojing@huawei.com>
>    crypto: omap-sham - Use pm_runtime_resume_and_get() in omap_sham_probe(=
)
>=20
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>    crypto: amlogic - Remove kcalloc without check
>=20
> Wang Yufen <wangyufen@huawei.com>
>    crypto: qat - fix error return code in adf_probe
>=20
> Mark Zhang <markzhang@nvidia.com>
>    RDMA/nldev: Fix failure to send large messages
>=20
> Yonggil Song <yonggil.song@samsung.com>
>    f2fs: avoid victim selection from previous victim section
>=20
> Sheng Yong <shengyong@oppo.com>
>    f2fs: fix to enable compress for newly created file if extension matche=
s
>=20
> Sheng Yong <shengyong@oppo.com>
>    f2fs: set zstd compress level correctly
>=20
> Yuan Can <yuancan@huawei.com>
>    RDMA/nldev: Add checks for nla_nest_start() in fill_stat_counter_qps()
>=20
> Bart Van Assche <bvanassche@acm.org>
>    scsi: ufs: core: Fix the polling implementation
>=20
> Jie Zhan <zhanjie9@hisilicon.com>
>    scsi: hisi_sas: Fix SATA devices missing issue during I_T nexus reset
>=20
> Jie Zhan <zhanjie9@hisilicon.com>
>    scsi: libsas: Add smp_ata_check_ready_type()
>=20
> Gaosheng Cui <cuigaosheng1@huawei.com>
>    scsi: snic: Fix possible UAF in snic_tgt_create()
>=20
> Chen Zhongjin <chenzhongjin@huawei.com>
>    scsi: fcoe: Fix transport not deattached when fcoe_if_init() fails
>=20
> Shang XiaoJing <shangxiaojing@huawei.com>
>    scsi: ipr: Fix WARNING in ipr_init()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    scsi: scsi_debug: Fix possible name leak in sdebug_add_host_helper()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    scsi: fcoe: Fix possible name leak when device_register() fails
>=20
> Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
>    scsi: scsi_debug: Fix a warning in resp_report_zones()
>=20
> Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
>    scsi: scsi_debug: Fix a warning in resp_verify()
>=20
> Chen Zhongjin <chenzhongjin@huawei.com>
>    scsi: efct: Fix possible memleak in efct_device_init()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    scsi: hpsa: Fix possible memory leak in hpsa_add_sas_device()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    scsi: hpsa: Fix error handling in hpsa_add_sas_host()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    scsi: mpt3sas: Fix possible resource leaks in mpt3sas_transport_port_ad=
d()
>=20
> Daniel Jordan <daniel.m.jordan@oracle.com>
>    padata: Fix list iterator in padata_do_serial()
>=20
> Daniel Jordan <daniel.m.jordan@oracle.com>
>    padata: Always leave BHs disabled when running ->parallel()
>=20
> Zhang Yiqun <zhangyiqun@phytium.com.cn>
>    crypto: tcrypt - Fix multibuffer skcipher speed test mem leak
>=20
> Yuan Can <yuancan@huawei.com>
>    scsi: hpsa: Fix possible memory leak in hpsa_init_one()
>=20
> Frank Li <frank.li@nxp.com>
>    PCI: endpoint: pci-epf-vntb: Fix call pci_epc_mem_free_addr() in error p=
ath
>=20
> Serge Semin <Sergey.Semin@baikalelectronics.ru>
>    dt-bindings: visconti-pcie: Fix interrupts array max constraints
>=20
> Serge Semin <Sergey.Semin@baikalelectronics.ru>
>    dt-bindings: imx6q-pcie: Fix clock names for imx6sx and imx8mq
>=20
> Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
>    RDMA/rxe: Fix NULL-ptr-deref in rxe_qp_do_cleanup() when socket create f=
ailed
>=20
> Zhengchao Shao <shaozhengchao@huawei.com>
>    RDMA/hns: fix memory leak in hns_roce_alloc_mr()
>=20
> Mustafa Ismail <mustafa.ismail@intel.com>
>    RDMA/irdma: Initialize net_type before checking it
>=20
> Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
>    crypto: ccree - Make cc_debugfs_global_fini() available for module init=
 function
>=20
> Xiongfeng Wang <wangxiongfeng2@huawei.com>
>    RDMA/hfi: Decrease PCI device reference count in error path
>=20
> Zeng Heng <zengheng4@huawei.com>
>    PCI: Check for alloc failure in pci_request_irq()
>=20
> Luoyouming <luoyouming@huawei.com>
>    RDMA/hns: Fix incorrect sge nums calculation
>=20
> Luoyouming <luoyouming@huawei.com>
>    RDMA/hns: Fix ext_sge num error when post send
>=20
> Luoyouming <luoyouming@huawei.com>
>    RDMA/hns: Repacing 'dseg_len' by macros in fill_ext_sge_inl_data()
>=20
> Li Zhijian <lizhijian@fujitsu.com>
>    RDMA/rxe: Fix mr->map double free
>=20
> Xiongfeng Wang <wangxiongfeng2@huawei.com>
>    crypto: hisilicon/qm - add missing pci_dev_put() in q_num_set()
>=20
> Herbert Xu <herbert@gondor.apana.org.au>
>    crypto: cryptd - Use request context instead of stack for sub-request
>=20
> Gaosheng Cui <cuigaosheng1@huawei.com>
>    crypto: ccree - Remove debugfs when platform_driver_register failed
>=20
> Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
>    scsi: scsi_debug: Fix a warning in resp_write_scat()
>=20
> Mustafa Ismail <mustafa.ismail@intel.com>
>    RDMA/irdma: Do not request 2-level PBLEs for CQ alloc
>=20
> Mustafa Ismail <mustafa.ismail@intel.com>
>    RDMA/irdma: Fix RQ completion opcode
>=20
> Mustafa Ismail <mustafa.ismail@intel.com>
>    RDMA/irdma: Fix inline for multiple SGE's
>=20
> Bernard Metzler <bmt@zurich.ibm.com>
>    RDMA/siw: Set defined status for work completion with undefined status
>=20
> Mark Zhang <markzhang@nvidia.com>
>    RDMA/nldev: Return "-EAGAIN" if the cm_id isn't from expected port
>=20
> Mark Zhang <markzhang@nvidia.com>
>    RDMA/core: Make sure "ib_port" is valid when access sysfs node
>=20
> Mark Zhang <markzhang@nvidia.com>
>    RDMA/restrack: Release MR restrack when delete
>=20
> Sascha Hauer <s.hauer@pengutronix.de>
>    PCI: imx6: Initialize PHY before deasserting core reset
>=20
> Nirmal Patel <nirmal.patel@linux.intel.com>
>    PCI: vmd: Disable MSI remapping after suspend
>=20
> Leonid Ravich <lravich@gmail.com>
>    IB/mad: Don't call to function that might sleep while in atomic context=

>=20
> Bernard Metzler <bmt@zurich.ibm.com>
>    RDMA/siw: Fix immediate work request flush to completion queue
>=20
> Bart Van Assche <bvanassche@acm.org>
>    scsi: qla2xxx: Fix set-but-not-used variable warnings
>=20
> Shiraz Saleem <shiraz.saleem@intel.com>
>    RDMA/irdma: Report the correct link speed
>=20
> Chao Yu <chao@kernel.org>
>    f2fs: fix to destroy sbi->post_read_wq in error path of f2fs_fill_super=
()
>=20
> Mukesh Ojha <quic_mojha@quicinc.com>
>    f2fs: fix the assign logic of iocb
>=20
> Jaegeuk Kim <jaegeuk@kernel.org>
>    f2fs: allow to set compression for inlined file
>=20
> Dongdong Zhang <zhangdongdong1@oppo.com>
>    f2fs: fix normal discard process
>=20
> Chao Yu <chao@kernel.org>
>    f2fs: fix to invalidate dcc->f2fs_issue_discard in error path
>=20
> Kees Cook <keescook@chromium.org>
>    fortify: Do not cast to "unsigned char"
>=20
> Kees Cook <keescook@chromium.org>
>    fortify: Use SIZE_MAX instead of (size_t)-1
>=20
> Xiu Jianfeng <xiujianfeng@huawei.com>
>    apparmor: Fix memleak in alloc_ns()
>=20
> Corentin Labbe <clabbe@baylibre.com>
>    crypto: rockchip - rework by using crypto_engine
>=20
> Corentin Labbe <clabbe@baylibre.com>
>    crypto: rockchip - remove non-aligned handling
>=20
> Corentin Labbe <clabbe@baylibre.com>
>    crypto: rockchip - better handle cipher key
>=20
> Corentin Labbe <clabbe@baylibre.com>
>    crypto: rockchip - add fallback for ahash
>=20
> Corentin Labbe <clabbe@baylibre.com>
>    crypto: rockchip - add fallback for cipher
>=20
> Corentin Labbe <clabbe@baylibre.com>
>    crypto: rockchip - do not store mode globally
>=20
> Corentin Labbe <clabbe@baylibre.com>
>    crypto: rockchip - do not do custom power management
>=20
> Zhang Qilong <zhangqilong3@huawei.com>
>    f2fs: Fix the race condition of resize flag between resizefs
>=20
> Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
>    PCI: pci-epf-test: Register notifier if only core_init_notifier is enab=
led
>=20
> Leon Romanovsky <leon@kernel.org>
>    RDMA/core: Fix order of nldev_exit call
>=20
> Vidya Sagar <vidyas@nvidia.com>
>    PCI: dwc: Fix n_fts[] array overrun
>=20
> Xiu Jianfeng <xiujianfeng@huawei.com>
>    apparmor: Use pointer to struct aa_label for lbs_cred
>=20
> Bart Van Assche <bvanassche@acm.org>
>    scsi: core: Fix a race between scsi_done() and scsi_timeout()
>=20
> Robert Elliott <elliott@hpe.com>
>    crypto: tcrypt - fix return value for multiple subtests
>=20
> Natalia Petrova <n.petrova@fintech.ru>
>    crypto: nitrox - avoid double free on error path in nitrox_sriov_init()=

>=20
> Corentin Labbe <clabbe@baylibre.com>
>    crypto: sun8i-ss - use dma_addr instead u32
>=20
> Weili Qian <qianweili@huawei.com>
>    crypto: hisilicon/qm - re-enable communicate interrupt before notifying=
 PF
>=20
> Weili Qian <qianweili@huawei.com>
>    crypto: hisilicon/qm - get hardware features from hardware registers
>=20
> Weili Qian <qianweili@huawei.com>
>    crypto: hisilicon/qm - fix missing destroy qp_idr
>=20
> John Johansen <john.johansen@canonical.com>
>    apparmor: Fix regression in stacking due to label flags
>=20
> John Johansen <john.johansen@canonical.com>
>    apparmor: Fix abi check to include v8 abi
>=20
> John Johansen <john.johansen@canonical.com>
>    apparmor: fix lockdep warning when removing a namespace
>=20
> Gaosheng Cui <cuigaosheng1@huawei.com>
>    apparmor: fix a memleak in multi_transaction_new()
>=20
> Vladimir Oltean <vladimir.oltean@nxp.com>
>    net: dsa: tag_8021q: avoid leaking ctx on dsa_tag_8021q_register() erro=
r path
>=20
> Bartosz Staszewski <bartoszx.staszewski@intel.com>
>    i40e: Fix the inability to attach XDP program on downed interface
>=20
> Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
>    stmmac: fix potential division by 0
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    Bluetooth: RFCOMM: don't call kfree_skb() under spin_lock_irqsave()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    Bluetooth: hci_core: don't call kfree_skb() under spin_lock_irqsave()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    Bluetooth: hci_bcsp: don't call kfree_skb() under spin_lock_irqsave()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    Bluetooth: hci_h5: don't call kfree_skb() under spin_lock_irqsave()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    Bluetooth: hci_ll: don't call kfree_skb() under spin_lock_irqsave()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    Bluetooth: hci_qca: don't call kfree_skb() under spin_lock_irqsave()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    Bluetooth: btusb: don't call kfree_skb() under spin_lock_irqsave()
>=20
> Wang ShaoBo <bobo.shaobowang@huawei.com>
>    Bluetooth: btintel: Fix missing free skb in btintel_setup_combined()
>=20
> Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
>    Bluetooth: hci_conn: Fix crash on hci_create_cis_sync
>=20
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>    Bluetooth: Fix EALREADY and ELOOP cases in bt_status()
>=20
> Inga Stotland <inga.stotland@intel.com>
>    Bluetooth: MGMT: Fix error report for ADD_EXT_ADV_PARAMS
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    Bluetooth: hci_core: fix error handling in hci_register_dev()
>=20
> Firo Yang <firo.yang@suse.com>
>    sctp: sysctl: make extra pointers netns aware
>=20
> Eric Pilmore <epilmore@gigaio.com>
>    ntb_netdev: Use dev_kfree_skb_any() in interrupt context
>=20
> Jerry Ray <jerry.ray@microchip.com>
>    net: lan9303: Fix read error execution path
>=20
> Roger Quadros <rogerq@kernel.org>
>    net: ethernet: ti: am65-cpsw: Fix PM runtime leakage in am65_cpsw_nuss_=
ndo_slave_open()
>=20
> Markus Schneider-Pargmann <msp@baylibre.com>
>    can: tcan4x5x: Fix use of register error status mask
>=20
> Vivek Yadav <vivek.2311@samsung.com>
>    can: m_can: Call the RAM init directly from m_can_chip_config
>=20
> Markus Schneider-Pargmann <msp@baylibre.com>
>    can: tcan4x5x: Remove invalid write in clear_interrupts
>=20
> Tom Lendacky <thomas.lendacky@amd.com>
>    net: amd-xgbe: Check only the minimum speed for active/passive cables
>=20
> Tom Lendacky <thomas.lendacky@amd.com>
>    net: amd-xgbe: Fix logic around active and passive cables
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    af_unix: call proto_unregister() in the error path in af_unix_init()
>=20
> Richard Gobert <richardbgobert@gmail.com>
>    net: setsockopt: fix IPV6_UNICAST_IF option for connected sockets
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    net: amd: lance: don't call dev_kfree_skb() under spin_lock_irqsave()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    hamradio: don't call dev_kfree_skb() under spin_lock_irqsave()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    net: ethernet: dnet: don't call dev_kfree_skb() under spin_lock_irqsave=
()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    net: emaclite: don't call dev_kfree_skb() under spin_lock_irqsave()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    net: apple: bmac: don't call dev_kfree_skb() under spin_lock_irqsave()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    net: apple: mace: don't call dev_kfree_skb() under spin_lock_irqsave()
>=20
> Hangbin Liu <liuhangbin@gmail.com>
>    net/tunnel: wait until all sk_user_data reader finish before releasing t=
he sock
>=20
> Li Zetao <lizetao1@huawei.com>
>    net: farsync: Fix kmemleak when rmmods farsync
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    ethernet: s2io: don't call dev_kfree_skb() under spin_lock_irqsave()
>=20
> ruanjinjie <ruanjinjie@huawei.com>
>    of: overlay: fix null pointer dereferencing in find_dup_cset_node_entry=
() and find_dup_cset_prop()
>=20
> Julian Anastasov <ja@ssi.bg>
>    ipvs: use u64_stats_t for the per-cpu counters
>=20
> Thomas Gleixner <tglx@linutronix.de>
>    net: Remove the obsolte u64_stats_fetch_*_irq() users (net).
>=20
> Yuan Can <yuancan@huawei.com>
>    drivers: net: qlcnic: Fix potential memory leak in qlcnic_sriov_init()
>=20
> Gaosheng Cui <cuigaosheng1@huawei.com>
>    net: stmmac: fix possible memory leak in stmmac_dvr_probe()
>=20
> Zhang Changzhong <zhangchangzhong@huawei.com>
>    net: stmmac: selftests: fix potential memleak in stmmac_test_arpoffload=
()
>=20
> Yongqiang Liu <liuyongqiang13@huawei.com>
>    net: defxx: Fix missing err handling in dfx_init()
>=20
> Artem Chernyshev <artem.chernyshev@red-soft.ru>
>    net: vmw_vsock: vmci: Check memcpy_from_msg()
>=20
> Xiu Jianfeng <xiujianfeng@huawei.com>
>    clk: socfpga: Fix memory leak in socfpga_gate_init()
>=20
> Bj=C3=B6rn T=C3=B6pel <bjorn@rivosinc.com>
>    bpf: Do not zero-extend kfunc return values
>=20
> Yang Jihong <yangjihong1@huawei.com>
>    blktrace: Fix output non-blktrace event when blk_classic option enabled=

>=20
> Wang Yufen <wangyufen@huawei.com>
>    wifi: brcmfmac: Fix error return code in brcmf_sdio_download_firmware()=

>=20
> Bitterblue Smith <rtl8821cerfe2@gmail.com>
>    wifi: rtl8xxxu: Fix the channel width reporting
>=20
> Bitterblue Smith <rtl8821cerfe2@gmail.com>
>    wifi: rtl8xxxu: Add __packed to struct rtl8723bu_c2h
>=20
> Kris Bahnsen <kris@embeddedTS.com>
>    spi: spi-gpio: Don't set MOSI as an input if not 3WIRE mode
>=20
> Xiu Jianfeng <xiujianfeng@huawei.com>
>    clk: samsung: Fix memory leak in _samsung_clk_register_pll()
>=20
> Geert Uytterhoeven <geert+renesas@glider.be>
>    media: staging: stkwebcam: Restore MEDIA_{USB,CAMERA}_SUPPORT dependenc=
ies
>=20
> Jiasheng Jiang <jiasheng@iscas.ac.cn>
>    media: coda: Add check for kmalloc
>=20
> Jiasheng Jiang <jiasheng@iscas.ac.cn>
>    media: coda: Add check for dcoda_iram_alloc
>=20
> Liang He <windhl@126.com>
>    media: c8sectpfe: Add of_node_put() when breaking out of loop
>=20
> Yuan Can <yuancan@huawei.com>
>    regulator: qcom-labibb: Fix missing of_node_put() in qcom_labibb_regula=
tor_probe()
>=20
> Zhen Lei <thunder.leizhen@huawei.com>
>    mmc: core: Normalize the error handling branch in sd_read_ext_regs()
>=20
> Jiasheng Jiang <jiasheng@iscas.ac.cn>
>    memstick/ms_block: Add check for alloc_ordered_workqueue
>=20
> Wolfram Sang <wsa+renesas@sang-engineering.com>
>    mmc: renesas_sdhi: alway populate SCC pointer
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    mmc: mmci: fix return value check of mmc_add_host()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    mmc: wbsd: fix return value check of mmc_add_host()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    mmc: via-sdmmc: fix return value check of mmc_add_host()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    mmc: meson-gx: fix return value check of mmc_add_host()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    mmc: omap_hsmmc: fix return value check of mmc_add_host()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    mmc: atmel-mci: fix return value check of mmc_add_host()
>=20
> Gabriel Somlo <gsomlo@gmail.com>
>    mmc: litex_mmc: ensure `host->irq =3D=3D 0` if polling
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    mmc: wmt-sdmmc: fix return value check of mmc_add_host()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    mmc: vub300: fix return value check of mmc_add_host()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    mmc: toshsd: fix return value check of mmc_add_host()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    mmc: rtsx_usb_sdmmc: fix return value check of mmc_add_host()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    mmc: rtsx_pci: fix return value check of mmc_add_host()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    mmc: pxamci: fix return value check of mmc_add_host()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    mmc: mxcmmc: fix return value check of mmc_add_host()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    mmc: moxart: fix return value check of mmc_add_host()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    mmc: alcor: fix return value check of mmc_add_host()
>=20
> Miaoqian Lin <linmq006@gmail.com>
>    bpftool: Fix memory leak in do_build_table_cb
>=20
> Pu Lehui <pulehui@huawei.com>
>    riscv, bpf: Emit fixed-length instructions for BPF_PSEUDO_FUNC
>=20
> Trond Myklebust <trond.myklebust@hammerspace.com>
>    NFSv4.x: Fail client initialisation if state manager thread can't run
>=20
> Anna Schumaker <Anna.Schumaker@Netapp.com>
>    NFS: Allow very small rsize & wsize again
>=20
> Anna Schumaker <Anna.Schumaker@Netapp.com>
>    NFSv4.2: Set the correct size scratch buffer for decoding READ_PLUS
>=20
> Wang ShaoBo <bobo.shaobowang@huawei.com>
>    SUNRPC: Fix missing release socket in rpc_sockname()
>=20
> Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
>    xprtrdma: Fix regbuf data not freed in rpcrdma_req_create()
>=20
> Gaosheng Cui <cuigaosheng1@huawei.com>
>    pinctrl: thunderbay: fix possible memory leak in thunderbay_build_funct=
ions()
>=20
> Gaosheng Cui <cuigaosheng1@huawei.com>
>    ALSA: mts64: fix possible null-ptr-defer in snd_mts64_interrupt
>=20
> Guoniu.zhou <guoniu.zhou@nxp.com>
>    media: ov5640: set correct default link frequency
>=20
> Liu Shixin <liushixin2@huawei.com>
>    media: saa7164: fix missing pci_disable_device()
>=20
> Takashi Iwai <tiwai@suse.de>
>    ALSA: pcm: Set missing stop_operating flag at undoing trigger start
>=20
> Eric Dumazet <edumazet@google.com>
>    bpf, sockmap: fix race in sock_map_free()
>=20
> Martin Blumenstingl <martin.blumenstingl@googlemail.com>
>    hwmon: (jc42) Restore the min/max/critical temperatures on resume
>=20
> Martin Blumenstingl <martin.blumenstingl@googlemail.com>
>    hwmon: (jc42) Convert register access and caching to regmap/regcache
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    regulator: core: fix resource leak in regulator_register()
>=20
> Chen Zhongjin <chenzhongjin@huawei.com>
>    configfs: fix possible memory leak in configfs_create_dir()
>=20
> Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>    hsr: Synchronize sequence number updates.
>=20
> Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>    hsr: Synchronize sending frames to have always incremented outgoing seq=
 nr.
>=20
> Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>    hsr: Disable netpoll.
>=20
> Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>    hsr: Avoid double remove of a node.
>=20
> Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>    hsr: Add a rcu-read lock to hsr_forward_skb().
>=20
> Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>    Revert "net: hsr: use hlist_head instead of list_head for mac addresses=
"
>=20
> Christian Marangi <ansuelsmth@gmail.com>
>    clk: qcom: clk-krait: fix wrong div2 functions
>=20
> Douglas Anderson <dianders@chromium.org>
>    clk: qcom: lpass-sc7180: Fix pm_runtime usage
>=20
> Douglas Anderson <dianders@chromium.org>
>    clk: qcom: lpass-sc7280: Fix pm_runtime usage
>=20
> Taniya Das <quic_tdas@quicinc.com>
>    clk: qcom: lpass: Add support for resets & external mclk for SC7280
>=20
> Taniya Das <quic_tdas@quicinc.com>
>    clk: qcom: lpass: Handle the regmap overlap of lpasscc and lpass_aon
>=20
> Taniya Das <quic_tdas@quicinc.com>
>    dt-bindings: clock: Add support for external MCLKs for LPASS on SC7280
>=20
> Taniya Das <quic_tdas@quicinc.com>
>    dt-bindings: clock: Add resets for LPASS audio clock controller for SC7=
280
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    regulator: core: fix module refcount leak in set_supply()
>=20
> Xiongfeng Wang <wangxiongfeng2@huawei.com>
>    mt76: mt7915: Fix PCI device refcount leak in mt7915_pci_init_hif2()
>=20
> Deren Wu <deren.wu@mediatek.com>
>    wifi: mt76: fix coverity overrun-call in mt76_get_txpower()
>=20
> Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
>    wifi: mt76: mt7915: Fix chainmask calculation on mt7915 DBDC
>=20
> Shayne Chen <shayne.chen@mediatek.com>
>    wifi: mt76: mt7915: rework eeprom tx paths and streams init
>=20
> Lorenzo Bianconi <lorenzo@kernel.org>
>    wifi: mt76: mt7921: fix reporting of TX AGGR histogram
>=20
> Lorenzo Bianconi <lorenzo@kernel.org>
>    wifi: mt76: mt7915: fix reporting of TX AGGR histogram
>=20
> Ryder Lee <ryder.lee@mediatek.com>
>    wifi: mt76: mt7915: fix mt7915_mac_set_timing()
>=20
> Sean Wang <sean.wang@mediatek.com>
>    wifi: mt76: mt7921: fix antenna signal are way off in monitor mode
>=20
> Chen Zhongjin <chenzhongjin@huawei.com>
>    wifi: cfg80211: Fix not unregister reg_pdev when load_builtin_regdb_key=
s() fails
>=20
> =C3=8D=C3=B1igo Huguet <ihuguet@redhat.com>
>    wifi: mac80211: fix maybe-unused warning
>=20
> Zhengchao Shao <shaozhengchao@huawei.com>
>    wifi: mac80211: fix memory leak in ieee80211_if_add()
>=20
> Yuan Can <yuancan@huawei.com>
>    wifi: nl80211: Add checks for nla_nest_start() in nl80211_send_iface()
>=20
> Alexander Sverdlin <alexander.sverdlin@siemens.com>
>    spi: spidev: mask SPI_CS_HIGH in SPI_IOC_RD_MODE
>=20
> Dan Carpenter <error27@gmail.com>
>    bonding: uninitialized variable in bond_miimon_inspect()
>=20
> Pengcheng Yang <yangpc@wangsu.com>
>    bpf, sockmap: Fix data loss caused by using apply_bytes on ingress redi=
rect
>=20
> Pengcheng Yang <yangpc@wangsu.com>
>    bpf, sockmap: Fix missing BPF_F_INGRESS flag when using apply_bytes
>=20
> Pengcheng Yang <yangpc@wangsu.com>
>    bpf, sockmap: Fix repeated calls to sock_put() when msg has more_data
>=20
> Randy Dunlap <rdunlap@infradead.org>
>    Input: wistron_btns - disable on UML
>=20
> Florian Westphal <fw@strlen.de>
>    netfilter: conntrack: set icmpv6 redirects as RELATED
>=20
> Xiu Jianfeng <xiujianfeng@huawei.com>
>    clk: visconti: Fix memory leak in visconti_register_pll()
>=20
> Zhang Qilong <zhangqilong3@huawei.com>
>    ASoC: pcm512x: Fix PM disable depth imbalance in pcm512x_probe
>=20
> Xia Fukun <xiafukun@huawei.com>
>    drm/i915/bios: fix a memory leak in generate_lfp_data_ptrs
>=20
> Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>    drm/amdkfd: Fix memory leakage
>=20
> Xiongfeng Wang <wangxiongfeng2@huawei.com>
>    drm/amdgpu: Fix PCI device refcount leak in amdgpu_atrm_get_bios()
>=20
> Xiongfeng Wang <wangxiongfeng2@huawei.com>
>    drm/radeon: Fix PCI device refcount leak in radeon_atrm_get_bios()
>=20
> Veerabadhran Gopalakrishnan <veerabadhran.gopalakrishnan@amd.com>
>    amdgpu/nv.c: Corrected typo in the video capabilities resolution
>=20
> Guchun Chen <guchun.chen@amd.com>
>    drm/amd/pm/smu11: BACO is supported when it's in BACO state
>=20
> Daniel Golle <daniel@makrotopia.org>
>    clk: mediatek: fix dependency of MT7986 ADC clocks
>=20
> Ricardo Ribalda <ribalda@chromium.org>
>    ASoC: mediatek: mt8173: Enable IRQ when pdata is ready
>=20
> zhichao.liu <zhichao.liu@mediatek.com>
>    spi: mt65xx: Add dma max segment size declaration
>=20
> Ben Greear <greearb@candelatech.com>
>    wifi: iwlwifi: mvm: fix double free on tx path.
>=20
> Bitterblue Smith <rtl8821cerfe2@gmail.com>
>    wifi: rtl8xxxu: Fix use after rcu_read_unlock in rtl8xxxu_bss_info_chan=
ged
>=20
> Ziyang Xuan <william.xuanziyang@huawei.com>
>    wifi: plfxlc: fix potential memory leak in __lf_x_usb_enable_rx()
>=20
> Liu Shixin <liushixin2@huawei.com>
>    ALSA: asihpi: fix missing pci_disable_device()
>=20
> Trond Myklebust <trond.myklebust@hammerspace.com>
>    NFS: Fix an Oops in nfs_d_automount()
>=20
> Trond Myklebust <trond.myklebust@hammerspace.com>
>    NFSv4: Fix a deadlock between nfs4_open_recover_helper() and delegretur=
n
>=20
> Trond Myklebust <trond.myklebust@hammerspace.com>
>    NFSv4: Fix a credential leak in _nfs4_discover_trunking()
>=20
> Trond Myklebust <trond.myklebust@hammerspace.com>
>    NFSv4.2: Fix initialisation of struct nfs4_label
>=20
> Trond Myklebust <trond.myklebust@hammerspace.com>
>    NFSv4.2: Fix a memory stomp in decode_attr_security_label
>=20
> Trond Myklebust <trond.myklebust@hammerspace.com>
>    NFSv4.2: Always decode the security label
>=20
> Trond Myklebust <trond.myklebust@hammerspace.com>
>    NFSv4.2: Clear FATTR4_WORD2_SECURITY_LABEL when done decoding
>=20
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>    drm/msm/mdp5: fix reading hw revision on db410c platform
>=20
> Jiasheng Jiang <jiasheng@iscas.ac.cn>
>    ASoC: mediatek: mtk-btcvsd: Add checks for write and read of mtk_btcvsd=
_snd
>=20
> Dmitry Torokhov <dmitry.torokhov@gmail.com>
>    ASoC: dt-bindings: wcd9335: fix reset line polarity in example
>=20
> Zhang Zekun <zhangzekun11@huawei.com>
>    drm/tegra: Add missing clk_disable_unprepare() in tegra_dc_probe()
>=20
> Aakarsh Jain <aakarsh.jain@samsung.com>
>    media: s5p-mfc: Add variant data for MFC v7 hardware for Exynos 3250 So=
C
>=20
> Yunfei Dong <yunfei.dong@mediatek.com>
>    media: mediatek: vcodec: Core thread depends on core_list
>=20
> Yunfei Dong <yunfei.dong@mediatek.com>
>    media: mediatek: vcodec: Setting lat buf to lat_list when lat decode er=
ror
>=20
> Yunfei Dong <yunfei.dong@mediatek.com>
>    media: mediatek: vcodec: Fix h264 set lat buffer error
>=20
> Yunfei Dong <yunfei.dong@mediatek.com>
>    media: mediatek: vcodec: Fix getting NULL pointer for dst buffer
>=20
> Ming Qian <ming.qian@nxp.com>
>    media: amphion: lock and check m2m_ctx in event handler
>=20
> Ming Qian <ming.qian@nxp.com>
>    media: amphion: cancel vpu before release instance
>=20
> Ming Qian <ming.qian@nxp.com>
>    media: amphion: try to wakeup vpu core to avoid failure
>=20
> Paul Kocialkowski <paul.kocialkowski@bootlin.com>
>    media: sun8i-a83t-mipi-csi2: Register async subdev with no sensor attac=
hed
>=20
> Paul Kocialkowski <paul.kocialkowski@bootlin.com>
>    media: sun6i-mipi-csi2: Register async subdev with no sensor attached
>=20
> Paul Kocialkowski <paul.kocialkowski@bootlin.com>
>    media: sun8i-a83t-mipi-csi2: Require both pads to be connected for stre=
aming
>=20
> Paul Kocialkowski <paul.kocialkowski@bootlin.com>
>    media: sun6i-mipi-csi2: Require both pads to be connected for streaming=

>=20
> Juergen Gross <jgross@suse.com>
>    x86/boot: Skip realmode init code when running as Xen PV guest
>=20
> Baisong Zhong <zhongbaisong@huawei.com>
>    media: dvb-usb: az6027: fix null-ptr-deref in az6027_i2c_xfer()
>=20
> Chen Zhongjin <chenzhongjin@huawei.com>
>    media: dvb-core: Fix ignored return value in dvb_register_frontend()
>=20
> ZhangPeng <zhangpeng362@huawei.com>
>    pinctrl: pinconf-generic: add missing of_node_put()
>=20
> Dario Binacchi <dario.binacchi@amarulasolutions.com>
>    clk: imx8mn: fix imx8mn_enet_phy_sels clocks list
>=20
> Dario Binacchi <dario.binacchi@amarulasolutions.com>
>    clk: imx8mn: fix imx8mn_sai2_sels clocks list
>=20
> Dario Binacchi <dario.binacchi@amarulasolutions.com>
>    clk: imx: rename video_pll1 to video_pll
>=20
> Dario Binacchi <dario.binacchi@amarulasolutions.com>
>    clk: imx: replace osc_hdmi with dummy
>=20
> Dario Binacchi <dario.binacchi@amarulasolutions.com>
>    clk: imx8mn: rename vpu_pll to m7_alt_pll
>=20
> Marek Vasut <marex@denx.de>
>    media: mt9p031: Drop bogus v4l2_subdev_get_try_crop() call from mt9p031=
_init_cfg()
>=20
> Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>    media: imx: imx7-media-csi: Clear BIT_MIPI_DOUBLE_CMPNT for <16b format=
s
>=20
> Gautam Menghani <gautammenghani201@gmail.com>
>    media: imon: fix a race condition in send_packet()
>=20
> Chen Zhongjin <chenzhongjin@huawei.com>
>    media: vimc: Fix wrong function called when vimc_init() fails
>=20
> Yuan Can <yuancan@huawei.com>
>    ASoC: qcom: Add checks for devm_kcalloc
>=20
> Wang ShaoBo <bobo.shaobowang@huawei.com>
>    drbd: destroy workqueue when drbd device was freed
>=20
> Wang ShaoBo <bobo.shaobowang@huawei.com>
>    drbd: remove call to memset before free device/resource/connection
>=20
> Zheng Yongjun <zhengyongjun3@huawei.com>
>    mtd: maps: pxa2xx-flash: fix memory leak in probe
>=20
> Shang XiaoJing <shangxiaojing@huawei.com>
>    mtd: core: Fix refcount error in del_mtd_device()
>=20
> Jonathan Toppins <jtoppins@redhat.com>
>    bonding: fix link recovery in mode 2 when updelay is nonzero
>=20
> Stanislav Fomichev <sdf@google.com>
>    selftests/bpf: Mount debugfs in setns_by_fd
>=20
> Stanislav Fomichev <sdf@google.com>
>    selftests/bpf: Make sure zero-len skbs aren't redirectable
>=20
> Jani Nikula <jani.nikula@intel.com>
>    drm/i915/guc: make default_lists const data
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    drm/amdgpu: fix pci device refcount leak
>=20
> Xiu Jianfeng <xiujianfeng@huawei.com>
>    clk: rockchip: Fix memory leak in rockchip_clk_register_pll()
>=20
> Wang ShaoBo <bobo.shaobowang@huawei.com>
>    regulator: core: use kfree_const() to free space conditionally
>=20
> Baisong Zhong <zhongbaisong@huawei.com>
>    ALSA: seq: fix undefined behavior in bit shift for SNDRV_SEQ_FILTER_USE=
_EVENT
>=20
> Baisong Zhong <zhongbaisong@huawei.com>
>    ALSA: pcm: fix undefined behavior in bit shift for SNDRV_PCM_RATE_KNOT
>=20
> Cezary Rojewski <cezary.rojewski@intel.com>
>    ASoC: Intel: avs: Lock substream before snd_pcm_stop()
>=20
> Zong-Zhe Yang <kevin_yang@realtek.com>
>    wifi: rtw89: fix physts IE page check
>=20
> ZhangPeng <zhangpeng362@huawei.com>
>    pinctrl: k210: call of_node_put()
>=20
> Giulio Benetti <giulio.benetti@benettiengineering.com>
>    clk: imx: imxrt1050: fix IMXRT1050_CLK_LCDIF_APB offsets
>=20
> Marcus Folkesson <marcus.folkesson@gmail.com>
>    HID: hid-sensor-custom: set fixed size for custom attributes
>=20
> Stanislav Fomichev <sdf@google.com>
>    bpf: Move skb->len =3D=3D 0 checks into __bpf_redirect
>=20
> Peng Fan <peng.fan@nxp.com>
>    clk: imx93: correct enet clock
>=20
> Peng Fan <peng.fan@nxp.com>
>    clk: imx93: unmap anatop base in error handling path
>=20
> Dmitry Torokhov <dmitry.torokhov@gmail.com>
>    HID: i2c: let RMI devices decide what constitutes wakeup event
>=20
> Haibo Chen <haibo.chen@nxp.com>
>    clk: imx93: correct the flexspi1 clock setting
>=20
> Allen-KH Cheng <allen-kh.cheng@mediatek.com>
>    mtd: spi-nor: Fix the number of bytes for the dummy cycles
>=20
> Michael Walle <michael@walle.cc>
>    mtd: spi-nor: hide jedec_id sysfs attribute if not present
>=20
> Kuniyuki Iwashima <kuniyu@amazon.com>
>    net: Return errno in sk->sk_prot->get_port().
>=20
> Kuniyuki Iwashima <kuniyu@amazon.com>
>    udp: Clean up some functions.
>=20
> Lorenzo Bianconi <lorenzo@kernel.org>
>    net: ethernet: mtk_eth_soc: fix RSTCTRL_PPE{0,1} definitions
>=20
> Christoph Hellwig <hch@lst.de>
>    media: videobuf-dma-contig: use dma_mmap_coherent
>=20
> Yuan Can <yuancan@huawei.com>
>    media: amphion: Fix error handling in vpu_driver_init()
>=20
> Yuan Can <yuancan@huawei.com>
>    media: platform: exynos4-is: Fix error handling in fimc_md_init()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    media: solo6x10: fix possible memory leak in solo_sysfs_init()
>=20
> Chen Zhongjin <chenzhongjin@huawei.com>
>    media: vidtv: Fix use-after-free in vidtv_bridge_dvb_init()
>=20
> Ming Qian <ming.qian@nxp.com>
>    media: amphion: apply vb2_queue_error instead of setting manually
>=20
> Ming Qian <ming.qian@nxp.com>
>    media: amphion: add lock around vdec_g_fmt
>=20
> Lorenzo Bianconi <lorenzo@kernel.org>
>    net: ethernet: mtk_eth_soc: do not overwrite mtu configuration running r=
eset routine
>=20
> Douglas Anderson <dianders@chromium.org>
>    Input: elants_i2c - properly handle the reset GPIO when power is off
>=20
> Hui Tang <tanghui20@huawei.com>
>    mtd: lpddr2_nvm: Fix possible null-ptr-deref
>=20
> Rob Clark <robdclark@chromium.org>
>    drm/msm/a6xx: Fix speed-bin detection vs probe-defer
>=20
> Xiu Jianfeng <xiujianfeng@huawei.com>
>    wifi: ath10k: Fix return value in ath10k_pci_init()
>=20
> Wang Yufen <wangyufen@huawei.com>
>    selftests/bpf: fix memory leak of lsm_cgroup
>=20
> Christoph Hellwig <hch@lst.de>
>    dm: track per-add_disk holder relations in DM
>=20
> Yu Kuai <yukuai3@huawei.com>
>    dm: make sure create and remove dm device won't race with open and clos=
e table
>=20
> Christoph Hellwig <hch@lst.de>
>    dm: cleanup close_table_device
>=20
> Christoph Hellwig <hch@lst.de>
>    dm: cleanup open_table_device
>=20
> Christoph Hellwig <hch@lst.de>
>    block: clear ->slave_dir when dropping the main slave_dir reference
>=20
> Xiu Jianfeng <xiujianfeng@huawei.com>
>    ima: Fix misuse of dereference of pointer in template_desc_init_fields(=
)
>=20
> GUO Zihua <guozihua@huawei.com>
>    integrity: Fix memory leakage in keyring allocation error path
>=20
> Brian Starkey <brian.starkey@arm.com>
>    drm/fourcc: Fix vsub/hsub for Q410 and Q401
>=20
> Konrad Dybcio <konrad.dybcio@linaro.org>
>    regulator: qcom-rpmh: Fix PMR735a S3 regulator spec
>=20
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>    wifi: rtw89: Fix some error handling path in rtw89_core_sta_assoc()
>=20
> Joel Granados <j.granados@samsung.com>
>    nvme: return err on nvme_init_non_mdts_limits fail
>=20
> Dan Carpenter <error27@gmail.com>
>    amdgpu/pm: prevent array underflow in vega20_odn_edit_dpm_table()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    regulator: core: fix unbalanced of node refcount in regulator_dev_looku=
p()
>=20
> Christoph Hellwig <hch@lst.de>
>    nvmet: only allocate a single slab for bvecs
>=20
> Zeng Heng <zengheng4@huawei.com>
>    ASoC: pxa: fix null-pointer dereference in filter()
>=20
> Xinlei Lee <xinlei.lee@mediatek.com>
>    drm/mediatek: Modify dpi power on/off sequence.
>=20
> Yang Jihong <yangjihong1@huawei.com>
>    selftests/bpf: Fix xdp_synproxy compilation failure in 32-bit arch
>=20
> Randy Dunlap <rdunlap@infradead.org>
>    ASoC: codecs: wsa883x: use correct header file
>=20
> Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>    ASoC: codecs: wsa883x: Use proper shutdown GPIO polarity
>=20
> Miaoqian Lin <linmq006@gmail.com>
>    module: Fix NULL vs IS_ERR checking for module_get_next_page
>=20
> Johannes Berg <johannes.berg@intel.com>
>    wifi: iwlwifi: mei: fix potential NULL-ptr deref after clone
>=20
> Avraham Stern <avraham.stern@intel.com>
>    wifi: iwlwifi: mei: avoid blocking sap messages handling due to rtnl lo=
ck
>=20
> Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>    wifi: iwlwifi: mei: fix tx DHCP packet for devices with new Tx API
>=20
> Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>    wifi: iwlwifi: mei: don't send SAP commands if AMT is disabled
>=20
> Avraham Stern <avraham.stern@intel.com>
>    wifi: iwlwifi: mei: make sure ownership confirmed message is sent
>=20
> Sam Shih <sam.shih@mediatek.com>
>    pinctrl: mediatek: fix the pinconf register offset of some pins
>=20
> Frank Wunderlich <frank-w@public-files.de>
>    dt-bindings: pinctrl: update uart/mmc bindings for MT7986 SoC
>=20
> Hanjun Guo <guohanjun@huawei.com>
>    drm/radeon: Add the missed acpi_put_table() to fix memory leak
>=20
> Khazhismel Kumykov <khazhy@chromium.org>
>    bfq: fix waker_bfqq inconsistency crash
>=20
> Christoph B=C3=B6hmwalder <christoph.boehmwalder@linbit.com>
>    drbd: use blk_queue_max_discard_sectors helper
>=20
> Yassine Oudjana <y.oudjana@protonmail.com>
>    regmap-irq: Use the new num_config_regs property in regmap_add_irq_chip=
_fwnode
>=20
> Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
>    drm: rcar-du: Drop leftovers dependencies from Kconfig
>=20
> Ping-Ke Shih <pkshih@realtek.com>
>    wifi: rtw89: use u32_encode_bits() to fill MAC quota value
>=20
> Marek Vasut <marex@denx.de>
>    drm: lcdif: Set and enable FIFO Panic threshold
>=20
> David Howells <dhowells@redhat.com>
>    rxrpc: Fix ack.bufferSize to be 0 when generating an ack
>=20
> David Howells <dhowells@redhat.com>
>    net, proc: Provide PROC_FS=3Dn fallback for proc_create_net_single_writ=
e()
>=20
> Cole Robinson <crobinso@redhat.com>
>    virt/sev-guest: Add a MODULE_ALIAS
>=20
> Wolfram Sang <wsa+renesas@sang-engineering.com>
>    clk: renesas: r8a779f0: Fix SCIF parent clocks
>=20
> Wolfram Sang <wsa+renesas@sang-engineering.com>
>    clk: renesas: r8a779f0: Fix HSCIF parent clocks
>=20
> Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
>    media: camss: Do not attach an already attached power domain on MSM8916=
 platform
>=20
> Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
>    media: camss: Clean up received buffers on failed start of streaming
>=20
> Marek Vasut <marex@denx.de>
>    wifi: rsi: Fix handling of 802.3 EAPOL frames sent via control port
>=20
> Randy Dunlap <rdunlap@infradead.org>
>    Input: joystick - fix Kconfig warning for JOYSTICK_ADC
>=20
> Gaosheng Cui <cuigaosheng1@huawei.com>
>    mtd: core: fix possible resource leak in init_mtd()
>=20
> Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
>    mtd: Fix device name leak when register device failed in add_mtd_device=
()
>=20
> Manivannan Sadhasivam <mani@kernel.org>
>    clk: qcom: gcc-sm8250: Use retention mode for USB GDSCs
>=20
> Konrad Dybcio <konrad.dybcio@somainline.org>
>    clk: qcom: dispcc-sm6350: Add CLK_OPS_PARENT_ENABLE to pixel&byte src
>=20
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>    clk: qcom: gcc-ipq806x: use parent_data for the last remaining entry
>=20
> Andrii Nakryiko <andrii@kernel.org>
>    bpf: propagate precision across all frames, not just the last one
>=20
> Andrii Nakryiko <andrii@kernel.org>
>    bpf: propagate precision in ALU/ALU64 operations
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    media: platform: exynos4-is: fix return value check in fimc_md_probe()
>=20
> Liu Shixin <liushixin2@huawei.com>
>    media: vivid: fix compose size exceed boundary
>=20
> Andrzej Pietrasiewicz <andrzej.p@collabora.com>
>    media: rkvdec: Add required padding
>=20
> Marijn Suijten <marijn.suijten@somainline.org>
>    drm/msm/dsi: Prevent signed BPG offsets from bleeding into adjacent bit=
s
>=20
> Marijn Suijten <marijn.suijten@somainline.org>
>    drm/msm/dsi: Disallow 8 BPC DSC configuration for alternative BPC value=
s
>=20
> Marijn Suijten <marijn.suijten@somainline.org>
>    drm/msm/dsi: Account for DSC's bits_per_pixel having 4 fractional bits
>=20
> Marijn Suijten <marijn.suijten@somainline.org>
>    drm/msm/dsi: Migrate to drm_dsc_compute_rc_parameters()
>=20
> Marijn Suijten <marijn.suijten@somainline.org>
>    drm/msm/dsi: Appropriately set dsc->mux_word_size based on bpc
>=20
> Marijn Suijten <marijn.suijten@somainline.org>
>    drm/msm/dsi: Reuse earlier computed dsc->slice_chunk_size
>=20
> Marijn Suijten <marijn.suijten@somainline.org>
>    drm/msm/dsi: Use DIV_ROUND_UP instead of conditional increment on modul=
o
>=20
> Marijn Suijten <marijn.suijten@somainline.org>
>    drm/msm/dsi: Remove repeated calculation of slice_per_intf
>=20
> Marijn Suijten <marijn.suijten@somainline.org>
>    drm/msm/dsi: Remove useless math in DSC calculations
>=20
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>    drm/msm/dsi: use drm_dsc_config instead of msm_display_dsc_config
>=20
> Marijn Suijten <marijn.suijten@somainline.org>
>    drm/msm/dpu1: Account for DSC's bits_per_pixel having 4 fractional bits=

>=20
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>    drm/msm/dpu: use drm_dsc_config instead of msm_display_dsc_config
>=20
> Kumar Kartikeya Dwivedi <memxor@gmail.com>
>    bpf: Fix slot type check in check_stack_write_var_off
>=20
> Kumar Kartikeya Dwivedi <memxor@gmail.com>
>    bpf: Clobber stack slot when writing over spilled PTR_TO_BTF_ID
>=20
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>    drm/msm/hdmi: use devres helper for runtime PM management
>=20
> GUO Zihua <guozihua@huawei.com>
>    ima: Handle -ESTALE returned by ima_filter_rule_match()
>=20
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>    drm/msm/mdp5: stop overriding drvdata
>=20
> Gaosheng Cui <cuigaosheng1@huawei.com>
>    drm/ttm: fix undefined behavior in bit shift for TTM_TT_FLAG_PRIV_POPUL=
ATED
>=20
> Marek Vasut <marex@denx.de>
>    drm/panel/panel-sitronix-st7701: Remove panel on DSI attach failure
>=20
> Jonathan Neusch=C3=A4fer <j.neuschaefer@gmx.net>
>    spi: Update reference to struct spi_controller
>=20
> Marco Felsch <m.felsch@pengutronix.de>
>    drm: lcdif: change burst size to 256B
>=20
> Marek Vasut <marex@denx.de>
>    clk: renesas: r9a06g032: Repair grave increment error
>=20
> Zhang Qilong <zhangqilong3@huawei.com>
>    drm/rockchip: lvds: fix PM usage counter unbalance in poweron
>=20
> Haiyi Zhou <Haiyi.Zhou@amd.com>
>    drm/amd/display: wait for vblank during pipe programming
>=20
> Sakari Ailus <sakari.ailus@linux.intel.com>
>    dw9768: Enable low-power probe on ACPI
>=20
> Alan Previn <alan.previn.teres.alexis@intel.com>
>    drm/i915/guc: Fix GuC error capture sizing estimation and reporting
>=20
> Alan Previn <alan.previn.teres.alexis@intel.com>
>    drm/i915/guc: Add error-capture init warnings when needed
>=20
> John Harrison <John.C.Harrison@Intel.com>
>    drm/i915/guc: Make GuC log sizes runtime configurable
>=20
> John Harrison <John.C.Harrison@Intel.com>
>    drm/i915/guc: Fix capture size warning and bump the size
>=20
> Alan Previn <alan.previn.teres.alexis@intel.com>
>    drm/i915/guc: Add a helper for log buffer size
>=20
> N=C3=ADcolas F. R. A. Prado <nfraprado@collabora.com>
>    ASoC: dt-bindings: rt5682: Set sound-dai-cells to 1
>=20
> Wolfram Sang <wsa+renesas@sang-engineering.com>
>    clk: renesas: r8a779a0: Fix SD0H clock name
>=20
> Jimmy Assarsson <extja@kvaser.com>
>    can: kvaser_usb: Compare requested bittiming parameters with actual par=
ameters in do_set_{,data}_bittiming
>=20
> Jimmy Assarsson <extja@kvaser.com>
>    can: kvaser_usb: Add struct kvaser_usb_busparams
>=20
> Anssi Hannula <anssi.hannula@bitwise.fi>
>    can: kvaser_usb_leaf: Fix bogus restart events
>=20
> Anssi Hannula <anssi.hannula@bitwise.fi>
>    can: kvaser_usb_leaf: Fix wrong CAN state after stopping
>=20
> Anssi Hannula <anssi.hannula@bitwise.fi>
>    can: kvaser_usb_leaf: Fix improved state not being reported
>=20
> Anssi Hannula <anssi.hannula@bitwise.fi>
>    can: kvaser_usb_leaf: Set Warning state even without bus errors
>=20
> Jimmy Assarsson <extja@kvaser.com>
>    can: kvaser_usb: kvaser_usb_leaf: Handle CMD_ERROR_EVENT
>=20
> Jimmy Assarsson <extja@kvaser.com>
>    can: kvaser_usb: kvaser_usb_leaf: Rename {leaf,usbcan}_cmd_error_event t=
o {leaf,usbcan}_cmd_can_error_event
>=20
> Jimmy Assarsson <extja@kvaser.com>
>    can: kvaser_usb: kvaser_usb_leaf: Get capabilities from device
>=20
> Alan Maguire <alan.maguire@oracle.com>
>    libbpf: Btf dedup identical struct test needs check for nested structs/=
arrays
>=20
> Marek Szyprowski <m.szyprowski@samsung.com>
>    media: exynos4-is: don't rely on the v4l2_async_subdev internals
>=20
> Rafael Mendonca <rafaelmendsr@gmail.com>
>    media: i2c: ov5648: Free V4L2 fwnode data on unbind
>=20
> Kuniyuki Iwashima <kuniyu@amazon.com>
>    soreuseport: Fix socket selection for SO_INCOMING_CPU.
>=20
> Tang Bin <tangbin@cmss.chinamobile.com>
>    venus: pm_helpers: Fix error check in vcodec_domains_get()
>=20
> Ricardo Ribalda <ribalda@chromium.org>
>    media: i2c: ad5820: Fix error path
>=20
> Rafael Mendonca <rafaelmendsr@gmail.com>
>    media: i2c: hi846: Fix memory leak in hi846_parse_dt()
>=20
> John Harrison <John.C.Harrison@Intel.com>
>    drm/i915: Fix compute pre-emption w/a to apply to compute engines
>=20
> John Harrison <John.C.Harrison@Intel.com>
>    drm/i915/guc: Limit scheduling properties to avoid overflow
>=20
> Yunfei Dong <yunfei.dong@mediatek.com>
>    media: mediatek: vcodec: fix h264 cavlc bitstream fail
>=20
> Jernej Skrabec <jernej.skrabec@gmail.com>
>    media: cedrus: hevc: Fix offset adjustments
>=20
> Jernej Skrabec <jernej.skrabec@gmail.com>
>    media: v4l2-ioctl.c: Unify YCbCr/YUV terms in format descriptions
>=20
> Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatech.se>
>    media: adv748x: afe: Select input port when initializing AFE
>=20
> Ming Qian <ming.qian@nxp.com>
>    media: amphion: reset instance if it's aborted before codec header pars=
ed
>=20
> Jiasheng Jiang <jiasheng@iscas.ac.cn>
>    media: coda: jpeg: Add check for kmalloc
>=20
> Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
>    media: v4l2-ctrls: Fix off-by-one error in integer menu control check
>=20
> Jeff LaBundy <jeff@labundy.com>
>    Input: iqs7222 - protect against undefined slider size
>=20
> Jeff LaBundy <jeff@labundy.com>
>    Input: iqs7222 - report malformed properties
>=20
> Jeff LaBundy <jeff@labundy.com>
>    Input: iqs7222 - drop unused device node references
>=20
> Jeff LaBundy <jeff@labundy.com>
>    Input: iqs7222 - set all ULP entry masks by default
>=20
> Pin-yen Lin <treapking@chromium.org>
>    drm/bridge: it6505: Initialize AUX channel in it6505_i2c_probe
>=20
> Gerhard Engleder <gerhard@engleder-embedded.com>
>    samples/bpf: Fix MAC address swapping in xdp2_kern
>=20
> Gerhard Engleder <gerhard@engleder-embedded.com>
>    samples/bpf: Fix map iteration in xdp1_user
>=20
> Rafael Mendonca <rafaelmendsr@gmail.com>
>    drm/amdgpu/powerplay/psm: Fix memory leak in power state init
>=20
> Andrew Jeffery <andrew@aj.id.au>
>    ipmi: kcs: Poll OBF briefly to reduce OBE latency
>=20
> Cezary Rojewski <cezary.rojewski@intel.com>
>    ASoC: Intel: avs: Fix potential RX buffer overflow
>=20
> Cezary Rojewski <cezary.rojewski@intel.com>
>    ASoC: Intel: avs: Fix DMA mask assignment
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    pinctrl: ocelot: add missing destroy_workqueue() in error path in ocelo=
t_pinctrl_probe()
>=20
> Niklas Cassel <niklas.cassel@wdc.com>
>    ata: libata: fix NCQ autosense logic
>=20
> Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>    drm: lcdif: Switch to limited range for RGB to YUV conversion
>=20
> Shung-Hsi Yu <shung-hsi.yu@suse.com>
>    libbpf: Fix null-pointer dereference in find_prog_by_sec_insn()
>=20
> Shung-Hsi Yu <shung-hsi.yu@suse.com>
>    libbpf: Deal with section with no data gracefully
>=20
> Shung-Hsi Yu <shung-hsi.yu@suse.com>
>    libbpf: Use elf_getshdrnum() instead of e_shnum
>=20
> Andrii Nakryiko <andrii@kernel.org>
>    libbpf: Reject legacy 'maps' ELF section
>=20
> Xu Kuohai <xukuohai@huawei.com>
>    selftest/bpf: Fix error usage of ASSERT_OK in xdp_adjust_tail.c
>=20
> Xu Kuohai <xukuohai@huawei.com>
>    selftests/bpf: Fix error failure of case test_xdp_adjust_tail_grow
>=20
> Xu Kuohai <xukuohai@huawei.com>
>    selftest/bpf: Fix memory leak in kprobe_multi_test
>=20
> Xu Kuohai <xukuohai@huawei.com>
>    selftests/bpf: Fix memory leak caused by not destroying skeleton
>=20
> Yonghong Song <yhs@fb.com>
>    selftests/bpf: Add struct argument tests with fentry/fexit programs.
>=20
> Xu Kuohai <xukuohai@huawei.com>
>    libbpf: Fix memory leak in parse_usdt_arg()
>=20
> Xu Kuohai <xukuohai@huawei.com>
>    libbpf: Fix use-after-free in btf_dump_name_dups
>=20
> Abhinav Kumar <quic_abhinavk@quicinc.com>
>    drm/bridge: adv7533: remove dynamic lane switching from adv7533 bridge
>=20
> Aditya Kumar Singh <quic_adisi@quicinc.com>
>    wifi: ath11k: fix firmware assert during bandwidth change for peer sta
>=20
> Aditya Kumar Singh <quic_adisi@quicinc.com>
>    wifi: ath11k: move firmware stats out of debugfs
>=20
> Bitterblue Smith <rtl8821cerfe2@gmail.com>
>    wifi: rtl8xxxu: Fix reading the vendor of combo chips
>=20
> Fedor Pchelkin <pchelkin@ispras.ru>
>    wifi: ath9k: hif_usb: Fix use-after-free in ath9k_hif_usb_reg_in_cb()
>=20
> Fedor Pchelkin <pchelkin@ispras.ru>
>    wifi: ath9k: hif_usb: fix memory leak of urbs in ath9k_hif_usb_dealloc_=
tx_urbs()
>=20
> Thomas Zimmermann <tzimmermann@suse.de>
>    drm/atomic-helper: Don't allocate new plane state in CRTC check
>=20
> Johannes Berg <johannes.berg@intel.com>
>    wifi: mac80211: fix ifdef symbol name
>=20
> Johannes Berg <johannes.berg@intel.com>
>    wifi: mac80211: check link ID in auth/assoc continuation
>=20
> Johannes Berg <johannes.berg@intel.com>
>    wifi: mac80211: mlme: fix null-ptr deref on failed assoc
>=20
> Johannes Berg <johannes.berg@intel.com>
>    wifi: fix multi-link element subelement iteration
>=20
> James Hurley <jahurley@nvidia.com>
>    platform/mellanox: mlxbf-pmc: Fix event typo
>=20
> Zhengchao Shao <shaozhengchao@huawei.com>
>    ipc: fix memory leak in init_mqueue_fs()
>=20
> Cai Xinchen <caixinchen1@huawei.com>
>    rapidio: devices: fix missing put_device in mport_cdev_open
>=20
> ZhangPeng <zhangpeng362@huawei.com>
>    hfs: Fix OOB Write in hfs_asc2mac
>=20
> Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
>    relay: fix type mismatch when allocating memory in relay_create_buf()
>=20
> Zhang Qilong <zhangqilong3@huawei.com>
>    eventfd: change int to __u64 in eventfd_signal() ifndef CONFIG_EVENTFD
>=20
> Wang Weiyang <wangweiyang2@huawei.com>
>    rapidio: fix possible UAF when kfifo_alloc() fails
>=20
> Chen Zhongjin <chenzhongjin@huawei.com>
>    fs: sysv: Fix sysv_nblocks() returns wrong value
>=20
> Brian Foster <bfoster@redhat.com>
>    NFSD: pass range end to vfs_fsync_range() instead of count
>=20
> Jeff Layton <jlayton@kernel.org>
>    nfsd: return error if nfs4_setacl fails
>=20
> Trond Myklebust <trond.myklebust@hammerspace.com>
>    lockd: set other missing fields when unlocking files
>=20
> Ladislav Michl <ladis@linux-mips.org>
>    MIPS: OCTEON: warn only once if deprecated link status is being used
>=20
> Anastasia Belova <abelova@astralinux.ru>
>    MIPS: BCM63xx: Add check for NULL for clk in clk_enable
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    platform/x86: intel_scu_ipc: fix possible name leak in __intel_scu_ipc_=
register()
>=20
> Yu Liao <liaoyu15@huawei.com>
>    platform/x86: mxm-wmi: fix memleak in mxm_wmi_call_mx[ds|mx]()
>=20
> Victor Ding <victording@chromium.org>
>    platform/chrome: cros_ec_typec: zero out stale pointers
>=20
> Prashant Malani <pmalani@chromium.org>
>    platform/chrome: cros_ec_typec: Get retimer handle
>=20
> Prashant Malani <pmalani@chromium.org>
>    platform/chrome: cros_ec_typec: Cleanup switch handle return paths
>=20
> Gao Xiang <xiang@kernel.org>
>    erofs: validate the extent length for uncompressed pclusters
>=20
> Yue Hu <huyue2@coolpad.com>
>    erofs: support interlaced uncompressed data for compressed files
>=20
> Gao Xiang <xiang@kernel.org>
>    erofs: fix missing unmap if z_erofs_get_extent_compressedlen() fails
>=20
> Chen Zhongjin <chenzhongjin@huawei.com>
>    erofs: Fix pcluster memleak when its block address is zero
>=20
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>    PM: runtime: Do not call __rpm_callback() from rpm_idle()
>=20
> Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
>    xen/privcmd: Fix a possible warning in privcmd_ioctl_mmap_resource()
>=20
> Xiu Jianfeng <xiujianfeng@huawei.com>
>    x86/xen: Fix memory leak in xen_init_lock_cpu()
>=20
> Xiu Jianfeng <xiujianfeng@huawei.com>
>    x86/xen: Fix memory leak in xen_smp_intr_init{_pv}()
>=20
> Oleg Nesterov <oleg@redhat.com>
>    uprobes/x86: Allow to probe a NOP instruction with 0x66 prefix
>=20
> Li Zetao <lizetao1@huawei.com>
>    ACPICA: Fix use-after-free in acpi_ut_copy_ipackage_to_ipackage()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    clocksource/drivers/timer-ti-dm: Fix missing clk_disable_unprepare in d=
mtimer_systimer_init_clock()
>=20
> Tony Lindgren <tony@atomide.com>
>    clocksource/drivers/timer-ti-dm: Fix warning for omap_timer_match
>=20
> Vincent Donnefort <vdonnefort@google.com>
>    cpu/hotplug: Do not bail-out in DYING/STARTING sections
>=20
> Phil Auld <pauld@redhat.com>
>    cpu/hotplug: Make target_store() a nop when target =3D=3D state
>=20
> Alexey Izbyshev <izbyshev@ispras.ru>
>    futex: Resend potentially swallowed owner death notification
>=20
> John Thomson <git@johnthomson.fastmail.com.au>
>    mips: ralink: mt7621: do not use kzalloc too early
>=20
> John Thomson <git@johnthomson.fastmail.com.au>
>    mips: ralink: mt7621: soc queries and tests as functions
>=20
> John Thomson <git@johnthomson.fastmail.com.au>
>    mips: ralink: mt7621: define MT7621_SYSC_BASE with __iomem
>=20
> Wolfram Sang <wsa+renesas@sang-engineering.com>
>    clocksource/drivers/sh_cmt: Access registers according to spec
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    rapidio: rio: fix possible name leak in rio_register_mport()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    rapidio: fix possible name leaks when rio_add_device() fails
>=20
> Li Zetao <ocfs2-devel@oss.oracle.com>
>    ocfs2: fix memory leak in ocfs2_mount_volume()
>=20
> Akinobu Mita <akinobu.mita@gmail.com>
>    debugfs: fix error when writing negative value to atomic_t debugfs file=

>=20
> Akinobu Mita <akinobu.mita@gmail.com>
>    lib/notifier-error-inject: fix error when writing -errno to debugfs fil=
e
>=20
> Akinobu Mita <akinobu.mita@gmail.com>
>    libfs: add DEFINE_SIMPLE_ATTRIBUTE_SIGNED for signed value
>=20
> Xiongfeng Wang <wangxiongfeng2@huawei.com>
>    cpufreq: amd_freq_sensitivity: Add missing pci_dev_put()
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    genirq/irqdesc: Don't try to remove non-existing sysfs files
>=20
> Jeff Layton <jlayton@kernel.org>
>    nfsd: don't call nfsd_file_put from client states seqfile display
>=20
> Chuck Lever <chuck.lever@oracle.com>
>    NFSD: Finish converting the NFSv3 GETACL result encoder
>=20
> Chuck Lever <chuck.lever@oracle.com>
>    NFSD: Finish converting the NFSv2 GETACL result encoder
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    EDAC/i10nm: fix refcount leak in pci_get_dev_wrapper()
>=20
> Liu Peibao <liupeibao@loongson.cn>
>    irqchip/loongson-liointc: Fix improper error handling in liointc_init()=

>=20
> Wei Yongjun <weiyongjun1@huawei.com>
>    irqchip/wpcm450: Fix memory leak in wpcm450_aic_of_init()
>=20
> Shang XiaoJing <shangxiaojing@huawei.com>
>    irqchip: gic-pm: Use pm_runtime_resume_and_get() in gic_probe()
>=20
> Jianmin Lv <lvjianmin@loongson.cn>
>    irqchip/loongson-pch-pic: Fix translate callback for DT path
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    thermal: core: fix some possible name leaks in error paths
>=20
> Yuan Can <yuancan@huawei.com>
>    platform/chrome: cros_usbpd_notify: Fix error handling in cros_usbpd_no=
tify_init()
>=20
> Xiongfeng Wang <wangxiongfeng2@huawei.com>
>    perf/x86/intel/uncore: Fix reference count leak in __uncore_imc_init_bo=
x()
>=20
> Xiongfeng Wang <wangxiongfeng2@huawei.com>
>    perf/x86/intel/uncore: Fix reference count leak in snr_uncore_mmio_map(=
)
>=20
> Xiongfeng Wang <wangxiongfeng2@huawei.com>
>    perf/x86/intel/uncore: Fix reference count leak in hswep_has_limit_sbox=
()
>=20
> Xiongfeng Wang <wangxiongfeng2@huawei.com>
>    perf/x86/intel/uncore: Fix reference count leak in sad_cfg_iio_topology=
()
>=20
> Wang ShaoBo <bobo.shaobowang@huawei.com>
>    ACPI: pfr_update: use ACPI_FREE() to free acpi_object
>=20
> Wang ShaoBo <bobo.shaobowang@huawei.com>
>    ACPI: pfr_telemetry: use ACPI_FREE() to free acpi_object
>=20
> Huisong Li <lihuisong@huawei.com>
>    mailbox: pcc: Reset pcc_chan_count to zero in case of PCC probe failure=

>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    PNP: fix name memory leak in pnp_alloc_dev()
>=20
> Zhao Gongyi <zhaogongyi@huawei.com>
>    selftests/efivarfs: Add checking of the test return value
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    MIPS: vpe-cmp: fix possible memory leak while module exiting
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>    MIPS: vpe-mt: fix possible memory leak while module exiting
>=20
> Manivannan Sadhasivam <mani@kernel.org>
>    cpufreq: qcom-hw: Fix the frequency returned by cpufreq_driver->get()
>=20
> YueHaibing <yuehaibing@huawei.com>
>    selftests: cgroup: fix unsigned comparison with less than zero
>=20
> Shang XiaoJing <shangxiaojing@huawei.com>
>    ocfs2: fix memory leak in ocfs2_stack_glue_init()
>=20
> Gaosheng Cui <cuigaosheng1@huawei.com>
>    lib/fonts: fix undefined behavior in bit shift for get_default_font
>=20
> Alexey Dobriyan <adobriyan@gmail.com>
>    proc: fixup uptime selftest
>=20
> Barnab=C3=A1s P=C5=91cze <pobrn@protonmail.com>
>    timerqueue: Use rb_entry_safe() in timerqueue_getnext()
>=20
> Barnab=C3=A1s P=C5=91cze <pobrn@protonmail.com>
>    platform/x86: huawei-wmi: fix return value calculation
>=20
> wuchi <wuchi.zero@gmail.com>
>    lib/debugobjects: fix stat count and optimize debug_objects_mem_init
>=20
> Chen Zhongjin <chenzhongjin@huawei.com>
>    perf: Fix possible memleak in pmu_dev_alloc()
>=20
> Yipeng Zou <zouyipeng@huawei.com>
>    selftests/ftrace: event_triggers: wait longer for test_event_enable
>=20
> Xiongfeng Wang <wangxiongfeng2@huawei.com>
>    ACPI: irq: Fix some kernel-doc issues
>=20
> Guilherme G. Piccoli <gpiccoli@igalia.com>
>    x86/split_lock: Add sysctl to control the misery mode
>=20
> Chen Hui <judy.chenhui@huawei.com>
>    cpufreq: qcom-hw: Fix memory leak in qcom_cpufreq_hw_read_lut()
>=20
> Ondrej Mosnacek <omosnace@redhat.com>
>    fs: don't audit the capability check in simple_xattr_list()
>=20
> xiongxin <xiongxin@kylinos.cn>
>    PM: hibernate: Fix mistake in kerneldoc comment
>=20
> Reinette Chatre <reinette.chatre@intel.com>
>    x86/sgx: Reduce delay and interference of enclave release
>=20
> Hao Lee <haolee.swjtu@gmail.com>
>    sched/psi: Fix possible missing or delayed pending event
>=20
> Al Viro <viro@zeniv.linux.org.uk>
>    alpha: fix syscall entry in !AUDUT_SYSCALL case
>=20
> Al Viro <viro@zeniv.linux.org.uk>
>    alpha: fix TIF_NOTIFY_SIGNAL handling
>=20
> Ulf Hansson <ulf.hansson@linaro.org>
>    cpuidle: dt: Return the correct numbers of parsed idle states
>=20
> Qais Yousef <qais.yousef@arm.com>
>    sched/uclamp: Cater for uclamp in find_energy_efficient_cpu()'s early e=
xit condition
>=20
> Qais Yousef <qais.yousef@arm.com>
>    sched/uclamp: Make cpu_overutilized() use util_fits_cpu()
>=20
> Qais Yousef <qais.yousef@arm.com>
>    sched/uclamp: Make asym_fits_capacity() use util_fits_cpu()
>=20
> Dietmar Eggemann <dietmar.eggemann@arm.com>
>    sched/core: Introduce sched_asym_cpucap_active()
>=20
> Qais Yousef <qais.yousef@arm.com>
>    sched/uclamp: Make select_idle_capacity() use util_fits_cpu()
>=20
> Qais Yousef <qais.yousef@arm.com>
>    sched/uclamp: Fix fits_capacity() check in feec()
>=20
> Qais Yousef <qais.yousef@arm.com>
>    sched/uclamp: Make task_fits_capacity() use util_fits_cpu()
>=20
> Qais Yousef <qais.yousef@arm.com>
>    sched/uclamp: Fix relationship between uclamp and migration margin
>=20
> Amir Goldstein <amir73il@gmail.com>
>    ovl: remove privs in ovl_fallocate()
>=20
> Amir Goldstein <amir73il@gmail.com>
>    ovl: remove privs in ovl_copyfile()
>=20
> Michael Kelley <mikelley@microsoft.com>
>    tpm/tpm_crb: Fix error message in __crb_relinquish_locality()
>=20
> Yuan Can <yuancan@huawei.com>
>    tpm/tpm_ftpm_tee: Fix error handling in ftpm_mod_init()
>=20
> Eddie James <eajames@linux.ibm.com>
>    tpm: Add flag to use default cancellation policy
>=20
> Eddie James <eajames@linux.ibm.com>
>    tpm: tis_i2c: Fix sanity check interrupt enable mask
>=20
> Janne Grunau <j@jannau.net>
>    arch: arm64: apple: t8103: Use standard "iommu" node name
>=20
> Stephen Boyd <swboyd@chromium.org>
>    pstore: Avoid kcore oops by vmap()ing with VM_IOREMAP
>=20
> Doug Brown <doug@schmorgal.com>
>    ARM: mmp: fix timer_read delay
>=20
> Wang Yufen <wangyufen@huawei.com>
>    pstore/ram: Fix error return code in ramoops_probe()
>=20
> Kuniyuki Iwashima <kuniyu@amazon.com>
>    seccomp: Move copy_seccomp() to no failure path.
>=20
> Yicong Yang <yangyicong@hisilicon.com>
>    drivers/perf: hisi: Fix some event id for hisi-pcie-pmu
>=20
> Sven Peter <sven@svenpeter.dev>
>    soc: apple: rtkit: Stop casting function pointer signatures
>=20
> Sven Peter <sven@svenpeter.dev>
>    soc: apple: sart: Stop casting function pointer signatures
>=20
> Pali Roh=C3=A1r <pali@kernel.org>
>    arm64: dts: armada-3720-turris-mox: Add missing interrupt for RTC
>=20
> Pali Roh=C3=A1r <pali@kernel.org>
>    ARM: dts: armada-39x: Fix compatible string for gpios
>=20
> Pali Roh=C3=A1r <pali@kernel.org>
>    ARM: dts: armada-38x: Fix compatible string for gpios
>=20
> Pali Roh=C3=A1r <pali@kernel.org>
>    ARM: dts: turris-omnia: Add switch port 6 node
>=20
> Pali Roh=C3=A1r <pali@kernel.org>
>    ARM: dts: turris-omnia: Add ethernet aliases
>=20
> Pali Roh=C3=A1r <pali@kernel.org>
>    ARM: dts: armada-39x: Fix assigned-addresses for every PCIe Root Port
>=20
> Pali Roh=C3=A1r <pali@kernel.org>
>    ARM: dts: armada-38x: Fix assigned-addresses for every PCIe Root Port
>=20
> Pali Roh=C3=A1r <pali@kernel.org>
>    ARM: dts: armada-375: Fix assigned-addresses for every PCIe Root Port
>=20
> Pali Roh=C3=A1r <pali@kernel.org>
>    ARM: dts: armada-xp: Fix assigned-addresses for every PCIe Root Port
>=20
> Pali Roh=C3=A1r <pali@kernel.org>
>    ARM: dts: armada-370: Fix assigned-addresses for every PCIe Root Port
>=20
> Pali Roh=C3=A1r <pali@kernel.org>
>    ARM: dts: dove: Fix assigned-addresses for every PCIe Root Port
>=20
> AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
>    arm64: dts: mediatek: mt6797: Fix 26M oscillator unit name
>=20
> AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
>    arm64: dts: mediatek: pumpkin-common: Fix devicetree warnings
>=20
> AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
>    arm64: dts: mt2712-evb: Fix usb vbus regulators unit names
>=20
> AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
>    arm64: dts: mt2712-evb: Fix vproc fixed regulators unit names
>=20
> AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
>    arm64: dts: mt2712e: Fix unit address for pinctrl node
>=20
> AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
>    arm64: dts: mt2712e: Fix unit_address_vs_reg warning for oscillators
>=20
> AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
>    arm64: dts: mt6779: Fix devicetree build warnings
>=20
> AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
>    arm64: dts: mt7896a: Fix unit_address_vs_reg warning for oscillator
>=20
> AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
>    arm64: dts: mediatek: mt8195: Fix CPUs capacity-dmips-mhz
>=20
> Jonathan Neusch=C3=A4fer <j.neuschaefer@gmx.net>
>    ARM: dts: nuvoton: Remove bogus unit addresses from fixed-partition nod=
es
>=20
> Keerthy <j-keerthy@ti.com>
>    arm64: dts: ti: k3-j721s2: Fix the interrupt ranges property for main &=
 wkup gpio intr
>=20
> Jayesh Choudhary <j-choudhary@ti.com>
>    arm64: dts: ti: k3-j721e-main: Drop dma-coherent in crypto node
>=20
> Jayesh Choudhary <j-choudhary@ti.com>
>    arm64: dts: ti: k3-am65-main: Drop dma-coherent in crypto node
>=20
> Shang XiaoJing <shangxiaojing@huawei.com>
>    perf/smmuv3: Fix hotplug callback leak in arm_smmu_pmu_init()
>=20
> Shang XiaoJing <shangxiaojing@huawei.com>
>    perf/arm_dmc620: Fix hotplug callback leak in dmc620_pmu_init()
>=20
> Yuan Can <yuancan@huawei.com>
>    drivers: perf: marvell_cn10k: Fix hotplug callback leak in tad_pmu_init=
()
>=20
> Yuan Can <yuancan@huawei.com>
>    perf: arm_dsu: Fix hotplug callback leak in dsu_pmu_init()
>=20
> Mark Rutland <mark.rutland@arm.com>
>    arm64: mm: kfence: only handle translation faults
>=20
> Zhang Qilong <zhangqilong3@huawei.com>
>    soc: ti: smartreflex: Fix PM disable depth imbalance in omap_sr_probe
>=20
> Zhang Qilong <zhangqilong3@huawei.com>
>    soc: ti: knav_qmss_queue: Fix PM disable depth imbalance in knav_queue_=
probe
>=20
> Kory Maincent <kory.maincent@bootlin.com>
>    arm: dts: spear600: Fix clcd interrupt
>=20
> Frank Wunderlich <frank-w@public-files.de>
>    arm64: dts: mt7986: fix trng node name
>=20
> Conor Dooley <conor.dooley@microchip.com>
>    dt-bindings: pwm: fix microchip corePWM's pwm-cells
>=20
> Fabrizio Castro <fabrizio.castro.jz@renesas.com>
>    arm64: dts: renesas: r9a09g011: Fix unit address format error
>=20
> Wolfram Sang <wsa+renesas@sang-engineering.com>
>    arm64: dts: renesas: r8a779f0: Fix SCIF "brg_int" clock
>=20
> Wolfram Sang <wsa+renesas@sang-engineering.com>
>    arm64: dts: renesas: r8a779f0: Fix HSCIF "brg_int" clock
>=20
> Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>    arm64: dts: qcom: sm6125: fix SDHCI CQE reg names
>=20
> Marijn Suijten <marijn.suijten@somainline.org>
>    arm64: dts: qcom: pm6350: Include header for KEY_POWER
>=20
> Jiasheng Jiang <jiasheng@iscas.ac.cn>
>    soc: qcom: apr: Add check for idr_alloc and of_property_read_string_ind=
ex
>=20
> Johan Hovold <johan+linaro@kernel.org>
>    arm64: dts: qcom: sm6350: drop bogus DP PHY clock
>=20
> Johan Hovold <johan+linaro@kernel.org>
>    arm64: dts: qcom: sm8250: drop bogus DP PHY clock
>=20
> Dmitry Torokhov <dmitry.torokhov@gmail.com>
>    arm64: dts: qcom: sm8250-mtp: fix reset line polarity
>=20
> Dmitry Torokhov <dmitry.torokhov@gmail.com>
>    arm64: dts: qcom: msm8996: fix sound card reset line polarity
>=20
> Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>    arm64: dts: qcom: use GPIO flags for tlmm
>=20
> Johan Hovold <johan+linaro@kernel.org>
>    arm64: dts: qcom: sm8450: fix UFS PHY registers
>=20
> Johan Hovold <johan+linaro@kernel.org>
>    arm64: dts: qcom: sm8350: fix UFS PHY registers
>=20
> Johan Hovold <johan+linaro@kernel.org>
>    arm64: dts: qcom: sm8250: fix UFS PHY registers
>=20
> Johan Hovold <johan+linaro@kernel.org>
>    arm64: dts: qcom: sm8150: fix UFS PHY registers
>=20
> Luca Weiss <luca.weiss@fairphone.com>
>    soc: qcom: llcc: make irq truly optional
>=20
> Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>    arm64: dts: qcom: sc7180-trogdor-homestar: fully configure secondary I2=
S pins
>=20
> Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>    arm64: dts: qcom: sm8250: correct LPASS pin pull down
>=20
> Marijn Suijten <marijn.suijten@somainline.org>
>    arm64: dts: qcom: pm660: Use unique ADC5_VCOIN address in node name
>=20
> Georgi Vlaev <g-vlaev@ti.com>
>    firmware: ti_sci: Fix polled mode during system suspend
>=20
> Chen Jiahao <chenjiahao16@huawei.com>
>    drivers: soc: ti: knav_qmss_queue: Mark knav_acc_firmwares as static
>=20
> Marek Vasut <marex@denx.de>
>    ARM: dts: stm32: Fix AV96 WLAN regulator gpio property
>=20
> Marek Vasut <marex@denx.de>
>    ARM: dts: stm32: Drop stm32mp15xc.dtsi from Avenger96
>=20
> Marco Elver <elver@google.com>
>    objtool, kcsan: Add volatile read/write instrumentation to whitelist
>=20
> Cong Dang <cong.dang.xn@renesas.com>
>    memory: renesas-rpc-if: Clear HS bit during hardware initialization
>=20
> Padmanabhan Rajanbabu <p.rajanbabu@samsung.com>
>    arm64: dts: fsd: fix drive strength values as per FSD HW UM
>=20
> Padmanabhan Rajanbabu <p.rajanbabu@samsung.com>
>    arm64: dts: fsd: fix drive strength macros as per FSD HW UM
>=20
> Stephan Gerhold <stephan.gerhold@kernkonzept.com>
>    arm64: dts: qcom: msm8916: Drop MSS fallback compatible
>=20
> Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>    arm64: dts: qcom: sdm845-cheza: fix AP suspend pin bias
>=20
> Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>    arm64: dts: qcom: sdm630: fix UART1 pin bias
>=20
> Luca Weiss <luca@z3ntu.xyz>
>    ARM: dts: qcom: apq8064: fix coresight compatible
>=20
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>    arm64: dts: qcom: msm8996: fix GPU OPP table
>=20
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>    arm64: dts: qcom: msm8996: fix supported-hw in cpufreq OPP tables
>=20
> Yassine Oudjana <y.oudjana@protonmail.com>
>    arm64: dts: qcom: msm8996: Add MSM8996 Pro support
>=20
> Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>    arm64: dts: qcom: sdm845-xiaomi-polaris: fix codec pin conf name
>=20
> Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>    arm64: dts: qcom: sm8250-sony-xperia-edo: fix touchscreen bias-disable
>=20
> Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>    arm64: dts: qcom: ipq6018-cp01-c1: use BLSPI1 pins
>=20
> Geert Uytterhoeven <geert+renesas@glider.be>
>    arm64: dts: renesas: r8a779g0: Fix HSCIF0 "brg_int" clock
>=20
> Paulo Alcantara <pc@cjr.nz>
>    cifs: fix oops during encryption
>=20
> Paulo Alcantara <pc@cjr.nz>
>    cifs: improve symlink handling for smb2+
>=20
> Enzo Matsumiya <ematsumiya@suse.de>
>    cifs: replace kfree() with kfree_sensitive() for sensitive data
>=20
> Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
>    usb: musb: remove extra check in musb_gadget_vbus_draw
>=20
> Martin Kaiser <martin@kaiser.cx>
>    staging: r8188eu: fix led register settings
>=20
> Martin Kaiser <martin@kaiser.cx>
>    staging: r8188eu: don't check bSurpriseRemoved in SwLedOff
>=20
> Martin Kaiser <martin@kaiser.cx>
>    staging: r8188eu: remove duplicate bSurpriseRemoved check
>=20
>=20
> -------------
>=20
> Diffstat:
>=20
> .../ABI/testing/sysfs-bus-spi-devices-spi-nor      |   3 +
> Documentation/admin-guide/sysctl/kernel.rst        |  23 +
> .../bindings/clock/qcom,sc7280-lpasscorecc.yaml    |  19 +-
> .../devicetree/bindings/input/azoteq,iqs7222.yaml  |  25 +-
> .../devicetree/bindings/mfd/qcom,spmi-pmic.yaml    |   8 +-
> .../devicetree/bindings/pci/fsl,imx6q-pcie.yaml    |  46 +-
> .../bindings/pci/toshiba,visconti-pcie.yaml        |   7 +-
> .../bindings/pinctrl/mediatek,mt7986-pinctrl.yaml  |  46 +-
> .../devicetree/bindings/pwm/microchip,corepwm.yaml |   4 +-
> .../devicetree/bindings/sound/qcom,wcd9335.txt     |   2 +-
> Documentation/devicetree/bindings/sound/rt5682.txt |   2 +-
> Documentation/driver-api/spi.rst                   |   4 +-
> Documentation/fault-injection/fault-injection.rst  |  10 +-
> Makefile                                           |   4 +-
> arch/Kconfig                                       |   2 +-
> arch/alpha/include/asm/thread_info.h               |   2 +-
> arch/alpha/kernel/entry.S                          |   4 +-
> arch/arm/boot/dts/armada-370.dtsi                  |   2 +-
> arch/arm/boot/dts/armada-375.dtsi                  |   2 +-
> arch/arm/boot/dts/armada-380.dtsi                  |   4 +-
> arch/arm/boot/dts/armada-385-turris-omnia.dts      |  18 +-
> arch/arm/boot/dts/armada-385.dtsi                  |   6 +-
> arch/arm/boot/dts/armada-38x.dtsi                  |   4 +-
> arch/arm/boot/dts/armada-39x.dtsi                  |  10 +-
> arch/arm/boot/dts/armada-xp-mv78230.dtsi           |   8 +-
> arch/arm/boot/dts/armada-xp-mv78260.dtsi           |  16 +-
> arch/arm/boot/dts/aspeed-bmc-ibm-everest.dts       |  17 +-
> arch/arm/boot/dts/aspeed-bmc-ibm-rainier.dts       |  16 +-
> arch/arm/boot/dts/dove.dtsi                        |   2 +-
> arch/arm/boot/dts/nuvoton-npcm730-gbs.dts          |   2 +-
> arch/arm/boot/dts/nuvoton-npcm730-gsj.dts          |   2 +-
> arch/arm/boot/dts/nuvoton-npcm730-kudo.dts         |   6 +-
> arch/arm/boot/dts/nuvoton-npcm750-evb.dts          |   4 +-
> .../boot/dts/nuvoton-npcm750-runbmc-olympus.dts    |   6 +-
> arch/arm/boot/dts/qcom-apq8064.dtsi                |   2 +-
> arch/arm/boot/dts/spear600.dtsi                    |   2 +-
> arch/arm/boot/dts/stm32mp157a-dhcor-avenger96.dts  |   1 -
> arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi |   2 +-
> arch/arm/mach-mmp/time.c                           |  11 +-
> arch/arm64/boot/dts/apple/t8103.dtsi               |   6 +-
> .../boot/dts/marvell/armada-3720-turris-mox.dts    |   3 +
> arch/arm64/boot/dts/mediatek/mt2712-evb.dts        |  12 +-
> arch/arm64/boot/dts/mediatek/mt2712e.dtsi          |  22 +-
> arch/arm64/boot/dts/mediatek/mt6779.dtsi           |   8 +-
> arch/arm64/boot/dts/mediatek/mt6797.dtsi           |   2 +-
> arch/arm64/boot/dts/mediatek/mt7986a.dtsi          |   4 +-
> arch/arm64/boot/dts/mediatek/mt8183.dtsi           |   2 +-
> arch/arm64/boot/dts/mediatek/mt8195.dtsi           |   8 +-
> arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi   |   6 +-
> arch/arm64/boot/dts/qcom/apq8096-ifc6640.dts       |   2 +-
> arch/arm64/boot/dts/qcom/ipq6018-cp01-c1.dts       |   2 +
> arch/arm64/boot/dts/qcom/msm8916.dtsi              |   2 +-
> .../dts/qcom/msm8994-sony-xperia-kitakami.dtsi     |   2 +-
> arch/arm64/boot/dts/qcom/msm8994.dtsi              |   3 +-
> arch/arm64/boot/dts/qcom/msm8996.dtsi              | 115 +++--
> arch/arm64/boot/dts/qcom/msm8996pro.dtsi           | 266 +++++++++++
> arch/arm64/boot/dts/qcom/pm6350.dtsi               |   1 +
> arch/arm64/boot/dts/qcom/pm660.dtsi                |   2 +-
> .../boot/dts/qcom/sc7180-trogdor-homestar.dtsi     |   6 +
> arch/arm64/boot/dts/qcom/sdm630.dtsi               |   2 +-
> arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi         |   4 +-
> arch/arm64/boot/dts/qcom/sdm845-db845c.dts         |   4 +-
> .../boot/dts/qcom/sdm845-xiaomi-beryllium.dts      |   2 +-
> arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts |   6 +-
> .../boot/dts/qcom/sdm850-lenovo-yoga-c630.dts      |   2 +-
> arch/arm64/boot/dts/qcom/sdm850-samsung-w737.dts   |   2 +-
> arch/arm64/boot/dts/qcom/sm6125.dtsi               |   2 +-
> arch/arm64/boot/dts/qcom/sm6350.dtsi               |  10 +-
> arch/arm64/boot/dts/qcom/sm8150.dtsi               |  10 +-
> arch/arm64/boot/dts/qcom/sm8250-mtp.dts            |   2 +-
> .../boot/dts/qcom/sm8250-sony-xperia-edo.dtsi      |   2 +-
> arch/arm64/boot/dts/qcom/sm8250.dtsi               |  20 +-
> arch/arm64/boot/dts/qcom/sm8350.dtsi               |  10 +-
> arch/arm64/boot/dts/qcom/sm8450.dtsi               |  10 +-
> arch/arm64/boot/dts/renesas/r8a779f0.dtsi          |  16 +-
> arch/arm64/boot/dts/renesas/r8a779g0.dtsi          |   2 +-
> arch/arm64/boot/dts/renesas/r9a09g011.dtsi         |   2 +-
> arch/arm64/boot/dts/tesla/fsd-pinctrl.dtsi         |  34 +-
> arch/arm64/boot/dts/tesla/fsd-pinctrl.h            |   6 +-
> arch/arm64/boot/dts/ti/k3-am65-main.dtsi           |   1 -
> arch/arm64/boot/dts/ti/k3-j721e-main.dtsi          |   1 -
> arch/arm64/boot/dts/ti/k3-j721s2-main.dtsi         |   2 +-
> arch/arm64/boot/dts/ti/k3-j721s2-mcu-wakeup.dtsi   |   2 +-
> arch/arm64/include/asm/processor.h                 |   4 +-
> arch/arm64/mm/fault.c                              |   8 +-
> arch/mips/bcm63xx/clk.c                            |   2 +
> .../cavium-octeon/executive/cvmx-helper-board.c    |   2 +-
> arch/mips/cavium-octeon/executive/cvmx-helper.c    |   2 +-
> arch/mips/include/asm/mach-ralink/mt7621.h         |   4 +-
> arch/mips/kernel/vpe-cmp.c                         |   4 +-
> arch/mips/kernel/vpe-mt.c                          |   4 +-
> arch/mips/ralink/mt7621.c                          |  97 ++--
> arch/mips/ralink/of.c                              |   4 +-
> arch/powerpc/boot/dts/turris1x.dts                 |  14 +
> arch/powerpc/include/asm/hvcall.h                  |   3 +-
> arch/powerpc/perf/callchain.c                      |   1 +
> arch/powerpc/perf/hv-gpci-requests.h               |   4 +
> arch/powerpc/perf/hv-gpci.c                        |  35 +-
> arch/powerpc/perf/hv-gpci.h                        |   1 +
> arch/powerpc/perf/req-gen/perf.h                   |  20 +
> arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c      |   1 +
> arch/powerpc/platforms/83xx/mpc832x_rdb.c          |   2 +-
> arch/powerpc/platforms/pseries/eeh_pseries.c       |  11 +-
> arch/powerpc/platforms/pseries/plpks.c             |  32 +-
> arch/powerpc/platforms/pseries/plpks.h             |   2 +-
> arch/powerpc/sysdev/xive/spapr.c                   |   1 +
> arch/powerpc/xmon/xmon.c                           |   7 +-
> arch/riscv/include/asm/hugetlb.h                   |   6 +
> arch/riscv/include/asm/io.h                        |   5 +
> arch/riscv/include/asm/pgtable-64.h                |   6 +-
> arch/riscv/kernel/entry.S                          |  18 +-
> arch/riscv/kernel/signal.c                         |  34 +-
> arch/riscv/kernel/traps.c                          |   2 +-
> arch/riscv/kvm/vcpu.c                              |  11 +-
> arch/riscv/mm/physaddr.c                           |   2 +-
> arch/riscv/net/bpf_jit_comp64.c                    |  29 +-
> arch/x86/Kconfig                                   |   4 +-
> arch/x86/events/intel/uncore_snb.c                 |   3 +
> arch/x86/events/intel/uncore_snbep.c               |   5 +
> arch/x86/hyperv/hv_init.c                          |   2 -
> arch/x86/include/asm/apic.h                        |   3 +-
> arch/x86/include/asm/realmode.h                    |   1 +
> arch/x86/include/asm/x86_init.h                    |   4 +
> arch/x86/kernel/apic/apic.c                        |  13 +-
> arch/x86/kernel/cpu/intel.c                        |  63 ++-
> arch/x86/kernel/cpu/sgx/encl.c                     |  23 +-
> arch/x86/kernel/setup.c                            |   2 +-
> arch/x86/kernel/uprobes.c                          |   4 +-
> arch/x86/kernel/x86_init.c                         |   3 +
> arch/x86/realmode/init.c                           |   8 +-
> arch/x86/xen/enlighten_pv.c                        |   2 +
> arch/x86/xen/smp.c                                 |  24 +-
> arch/x86/xen/smp_pv.c                              |  12 +-
> arch/x86/xen/spinlock.c                            |   6 +-
> block/bfq-iosched.c                                |  16 +-
> block/blk-mq-sysfs.c                               |  11 +-
> block/blk-mq.c                                     |  56 ++-
> block/genhd.c                                      |   2 +
> crypto/cryptd.c                                    |  36 +-
> crypto/tcrypt.c                                    | 265 +++++------
> drivers/acpi/acpica/dsmethod.c                     |  10 +-
> drivers/acpi/acpica/utcopy.c                       |   7 -
> drivers/acpi/ec.c                                  |  10 +
> drivers/acpi/irq.c                                 |   5 +-
> drivers/acpi/pfr_telemetry.c                       |   6 +-
> drivers/acpi/pfr_update.c                          |   6 +-
> drivers/acpi/processor_idle.c                      |   3 +
> drivers/acpi/x86/utils.c                           |  24 +-
> drivers/ata/libata-sata.c                          |  11 +-
> drivers/base/class.c                               |   5 +
> drivers/base/power/runtime.c                       |  12 +-
> drivers/base/regmap/regmap-irq.c                   |  15 +-
> drivers/block/drbd/drbd_main.c                     |   9 +-
> drivers/block/drbd/drbd_nl.c                       |  10 +-
> drivers/block/floppy.c                             |   4 +-
> drivers/block/loop.c                               |  28 +-
> drivers/bluetooth/btintel.c                        |   5 +-
> drivers/bluetooth/btusb.c                          |   6 +-
> drivers/bluetooth/hci_bcm.c                        |  13 +-
> drivers/bluetooth/hci_bcsp.c                       |   2 +-
> drivers/bluetooth/hci_h5.c                         |   2 +-
> drivers/bluetooth/hci_ll.c                         |   2 +-
> drivers/bluetooth/hci_qca.c                        |   2 +-
> drivers/char/hw_random/amd-rng.c                   |  18 +-
> drivers/char/hw_random/geode-rng.c                 |  36 +-
> drivers/char/ipmi/ipmi_msghandler.c                |   8 +-
> drivers/char/ipmi/kcs_bmc_aspeed.c                 |  24 +-
> drivers/char/tpm/tpm_crb.c                         |   2 +-
> drivers/char/tpm/tpm_ftpm_tee.c                    |   8 +-
> drivers/char/tpm/tpm_tis_core.c                    |  20 +-
> drivers/char/tpm/tpm_tis_core.h                    |   1 +
> drivers/char/tpm/tpm_tis_i2c.c                     |   3 +-
> drivers/clk/imx/clk-imx8mn.c                       | 116 ++---
> drivers/clk/imx/clk-imx8mp.c                       |   4 +-
> drivers/clk/imx/clk-imx93.c                        |  19 +-
> drivers/clk/imx/clk-imxrt1050.c                    |   2 +-
> drivers/clk/mediatek/clk-mt7986-infracfg.c         |   2 +-
> drivers/clk/qcom/clk-krait.c                       |   2 +
> drivers/clk/qcom/dispcc-sm6350.c                   |   4 +-
> drivers/clk/qcom/gcc-ipq806x.c                     |   4 +-
> drivers/clk/qcom/gcc-sm8250.c                      |   4 +-
> drivers/clk/qcom/lpassaudiocc-sc7280.c             | 117 +++--
> drivers/clk/qcom/lpasscc-sc7280.c                  |  44 --
> drivers/clk/qcom/lpasscorecc-sc7180.c              |  24 +-
> drivers/clk/qcom/lpasscorecc-sc7280.c              |  33 ++
> drivers/clk/renesas/r8a779a0-cpg-mssr.c            |   2 +-
> drivers/clk/renesas/r8a779f0-cpg-mssr.c            |  29 +-
> drivers/clk/renesas/r9a06g032-clocks.c             |   3 +-
> drivers/clk/rockchip/clk-pll.c                     |   1 +
> drivers/clk/samsung/clk-pll.c                      |   1 +
> drivers/clk/socfpga/clk-gate.c                     |   5 +-
> drivers/clk/st/clkgen-fsyn.c                       |   5 +-
> drivers/clk/visconti/pll.c                         |   1 +
> drivers/clocksource/sh_cmt.c                       |  88 ++--
> drivers/clocksource/timer-ti-dm-systimer.c         |   4 +-
> drivers/clocksource/timer-ti-dm.c                  |   2 +-
> drivers/counter/stm32-lptimer-cnt.c                |   2 +-
> drivers/cpufreq/amd_freq_sensitivity.c             |   2 +
> drivers/cpufreq/qcom-cpufreq-hw.c                  |  43 +-
> drivers/cpuidle/dt_idle_states.c                   |   2 +-
> drivers/crypto/Kconfig                             |   5 +
> .../crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c    |   2 +-
> drivers/crypto/amlogic/amlogic-gxl-core.c          |   1 -
> drivers/crypto/amlogic/amlogic-gxl.h               |   2 +-
> drivers/crypto/cavium/nitrox/nitrox_mbx.c          |   1 +
> drivers/crypto/ccree/cc_debugfs.c                  |   2 +-
> drivers/crypto/ccree/cc_driver.c                   |  10 +-
> drivers/crypto/hisilicon/hpre/hpre_main.c          |  14 +-
> drivers/crypto/hisilicon/qm.c                      | 208 ++++++---
> drivers/crypto/hisilicon/sec2/sec_main.c           |   4 +-
> drivers/crypto/hisilicon/zip/zip_main.c            |   4 +-
> drivers/crypto/img-hash.c                          |   8 +-
> drivers/crypto/omap-sham.c                         |   2 +-
> drivers/crypto/qat/qat_4xxx/adf_drv.c              |   1 +
> drivers/crypto/rockchip/rk3288_crypto.c            | 193 +-------
> drivers/crypto/rockchip/rk3288_crypto.h            |  53 +--
> drivers/crypto/rockchip/rk3288_crypto_ahash.c      | 197 ++++----
> drivers/crypto/rockchip/rk3288_crypto_skcipher.c   | 413 +++++++++-------
> drivers/dio/dio.c                                  |   8 +
> drivers/dma/apple-admac.c                          | 129 ++++-
> drivers/edac/i10nm_base.c                          |   3 +-
> drivers/extcon/Kconfig                             |   2 +-
> drivers/extcon/extcon-usbc-tusb320.c               | 247 ++++++++--
> drivers/firmware/raspberrypi.c                     |   1 +
> drivers/firmware/ti_sci.c                          |   5 +-
> drivers/gpio/gpiolib-cdev.c                        | 204 +++++++-
> drivers/gpio/gpiolib.c                             |   4 +
> drivers/gpio/gpiolib.h                             |   5 +
> drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |   2 +-
> drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c           |   1 +
> drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   4 +
> drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h           |   5 +-
> drivers/gpu/drm/amd/amdgpu/nv.c                    |  28 +-
> drivers/gpu/drm/amd/amdgpu/soc15.c                 |  24 +-
> drivers/gpu/drm/amd/amdgpu/soc21.c                 |   2 +-
> .../drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c  |  35 --
> drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c |  16 +-
> .../amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c |   2 +-
> .../gpu/drm/amd/display/dc/dce60/dce60_resource.c  |   3 +
> .../gpu/drm/amd/display/dc/dce80/dce80_resource.c  |   2 +
> .../drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c  |  30 +-
> drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c |  35 +-
> drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dccg.c  |   6 +-
> .../gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c   |   7 +
> drivers/gpu/drm/amd/include/kgd_pp_interface.h     |   3 +-
> drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c   |   3 +-
> drivers/gpu/drm/amd/pm/powerplay/hwmgr/pp_psm.c    |   2 +
> .../gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c  |   3 +-
> drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c     |   4 +
> .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c   |  21 +-
> drivers/gpu/drm/bridge/adv7511/adv7511.h           |   3 +-
> drivers/gpu/drm/bridge/adv7511/adv7511_drv.c       |  18 +-
> drivers/gpu/drm/bridge/adv7511/adv7533.c           |  25 +-
> drivers/gpu/drm/bridge/ite-it6505.c                |   8 +-
> drivers/gpu/drm/drm_atomic_helper.c                |  10 +-
> drivers/gpu/drm/drm_edid.c                         |  12 +
> drivers/gpu/drm/drm_fourcc.c                       |   8 +-
> drivers/gpu/drm/etnaviv/etnaviv_gpu.c              |  11 +-
> drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_rgb.c          |   5 +-
> drivers/gpu/drm/i915/display/intel_bios.c          |   2 +-
> drivers/gpu/drm/i915/display/intel_dp.c            |  59 ---
> drivers/gpu/drm/i915/gt/intel_engine.h             |   6 +
> drivers/gpu/drm/i915/gt/intel_engine_cs.c          |  91 +++-
> drivers/gpu/drm/i915/gt/sysfs_engines.c            |  25 +-
> drivers/gpu/drm/i915/gt/uc/intel_guc.c             |  53 +--
> drivers/gpu/drm/i915/gt/uc/intel_guc_capture.c     | 147 ++++--
> drivers/gpu/drm/i915/gt/uc/intel_guc_capture.h     |   1 -
> drivers/gpu/drm/i915/gt/uc/intel_guc_fwif.h        |  21 +
> drivers/gpu/drm/i915/gt/uc/intel_guc_log.c         | 227 +++++++--
> drivers/gpu/drm/i915/gt/uc/intel_guc_log.h         |  42 +-
> drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c  |   8 +
> drivers/gpu/drm/i915/i915_params.c                 |  12 +
> drivers/gpu/drm/i915/i915_params.h                 |   3 +
> drivers/gpu/drm/mediatek/mtk_dpi.c                 |  12 +-
> drivers/gpu/drm/mediatek/mtk_hdmi.c                |   7 +-
> drivers/gpu/drm/meson/meson_encoder_cvbs.c         |   7 +-
> drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |  12 +-
> drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c        |  25 +-
> drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.h        |   2 +-
> drivers/gpu/drm/msm/disp/dpu1/dpu_hw_dsc.c         |  79 ++--
> drivers/gpu/drm/msm/disp/dpu1/dpu_hw_dsc.h         |   4 +-
> drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c           |  27 +-
> drivers/gpu/drm/msm/dp/dp_display.c                |   2 +-
> drivers/gpu/drm/msm/dsi/dsi.c                      |   2 +-
> drivers/gpu/drm/msm/dsi/dsi.h                      |   2 +-
> drivers/gpu/drm/msm/dsi/dsi_host.c                 | 204 +++-----
> drivers/gpu/drm/msm/hdmi/hdmi.c                    |   2 +-
> drivers/gpu/drm/msm/msm_drv.h                      |   9 +-
> drivers/gpu/drm/mxsfb/lcdif_kms.c                  |  48 +-
> drivers/gpu/drm/mxsfb/lcdif_regs.h                 |   5 +
> drivers/gpu/drm/panel/panel-sitronix-st7701.c      |  10 +-
> drivers/gpu/drm/radeon/radeon_bios.c               |  19 +-
> drivers/gpu/drm/rcar-du/Kconfig                    |   2 -
> drivers/gpu/drm/rockchip/cdn-dp-core.c             |   2 +-
> drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c    |   2 +-
> drivers/gpu/drm/rockchip/inno_hdmi.c               |   2 +-
> drivers/gpu/drm/rockchip/rk3066_hdmi.c             |   2 +-
> drivers/gpu/drm/rockchip/rockchip_drm_vop.c        |   4 +-
> drivers/gpu/drm/rockchip/rockchip_drm_vop2.c       |   2 +-
> drivers/gpu/drm/rockchip/rockchip_lvds.c           |  10 +-
> drivers/gpu/drm/sti/sti_dvo.c                      |   7 +-
> drivers/gpu/drm/sti/sti_hda.c                      |   7 +-
> drivers/gpu/drm/sti/sti_hdmi.c                     |   7 +-
> drivers/gpu/drm/tegra/dc.c                         |   4 +-
> drivers/hid/amd-sfh-hid/amd_sfh_client.c           |   4 +
> drivers/hid/hid-apple.c                            | 118 +++--
> drivers/hid/hid-input.c                            |   6 +
> drivers/hid/hid-logitech-hidpp.c                   |  11 +-
> drivers/hid/hid-mcp2221.c                          |  12 +-
> drivers/hid/hid-rmi.c                              |   2 +
> drivers/hid/hid-sensor-custom.c                    |   2 +-
> drivers/hid/i2c-hid/i2c-hid-core.c                 |   3 +-
> drivers/hid/wacom_sys.c                            |   8 +
> drivers/hid/wacom_wac.c                            |   4 +
> drivers/hid/wacom_wac.h                            |   1 +
> drivers/hsi/controllers/omap_ssi_core.c            |  14 +-
> drivers/hv/ring_buffer.c                           |  13 +
> drivers/hwmon/Kconfig                              |   1 +
> drivers/hwmon/jc42.c                               | 243 ++++++----
> drivers/hwmon/nct6775-platform.c                   |   7 +
> drivers/hwtracing/coresight/coresight-trbe.c       |   1 +
> drivers/i2c/busses/i2c-ismt.c                      |   3 +
> drivers/i2c/busses/i2c-pxa-pci.c                   |  10 +-
> drivers/i2c/muxes/i2c-mux-reg.c                    |   5 +-
> drivers/iio/adc/ad_sigma_delta.c                   |   8 +-
> drivers/iio/adc/ti-adc128s052.c                    |  14 +-
> drivers/iio/addac/ad74413r.c                       |   2 +-
> drivers/iio/imu/adis.c                             |  28 +-
> drivers/iio/industrialio-event.c                   |   4 +-
> drivers/iio/temperature/ltc2983.c                  |  10 +-
> drivers/infiniband/Kconfig                         |   2 +
> drivers/infiniband/core/device.c                   |   2 +-
> drivers/infiniband/core/mad.c                      |   5 -
> drivers/infiniband/core/nldev.c                    |   6 +-
> drivers/infiniband/core/restrack.c                 |   2 -
> drivers/infiniband/core/sysfs.c                    |  17 +-
> drivers/infiniband/hw/hfi1/affinity.c              |   2 +
> drivers/infiniband/hw/hfi1/firmware.c              |   6 +
> drivers/infiniband/hw/hns/Makefile                 |   2 +-
> drivers/infiniband/hw/hns/hns_roce_device.h        |  13 +-
> drivers/infiniband/hw/hns/hns_roce_hw_v2.c         | 257 +++++++---
> drivers/infiniband/hw/hns/hns_roce_hw_v2.h         |  14 +-
> drivers/infiniband/hw/hns/hns_roce_hw_v2_dfx.c     |  34 --
> drivers/infiniband/hw/hns/hns_roce_main.c          |  24 +-
> drivers/infiniband/hw/hns/hns_roce_mr.c            |   4 +-
> drivers/infiniband/hw/hns/hns_roce_qp.c            | 107 ++++-
> drivers/infiniband/hw/hns/hns_roce_restrack.c      |  35 +-
> drivers/infiniband/hw/irdma/uk.c                   | 170 ++++---
> drivers/infiniband/hw/irdma/user.h                 |  20 +-
> drivers/infiniband/hw/irdma/utils.c                |   2 +
> drivers/infiniband/hw/irdma/verbs.c                | 145 ++----
> drivers/infiniband/hw/irdma/verbs.h                |  53 +++
> drivers/infiniband/sw/rxe/rxe_mr.c                 |   9 +-
> drivers/infiniband/sw/rxe/rxe_qp.c                 |   6 +-
> drivers/infiniband/sw/siw/siw_cq.c                 |  24 +-
> drivers/infiniband/sw/siw/siw_qp_tx.c              |   2 +-
> drivers/infiniband/sw/siw/siw_verbs.c              |  40 +-
> drivers/infiniband/ulp/ipoib/ipoib_netlink.c       |   7 +
> drivers/infiniband/ulp/srp/ib_srp.c                |  96 +++-
> drivers/input/joystick/Kconfig                     |   1 +
> drivers/input/misc/Kconfig                         |   2 +-
> drivers/input/misc/iqs7222.c                       | 520 ++++++++++++-----=
----
> drivers/input/touchscreen/elants_i2c.c             |   9 +-
> drivers/interconnect/qcom/sc7180.c                 |   2 +-
> drivers/iommu/amd/iommu_v2.c                       |   1 +
> drivers/iommu/fsl_pamu.c                           |   2 +-
> drivers/iommu/mtk_iommu.c                          |  53 ++-
> drivers/iommu/rockchip-iommu.c                     |  10 +-
> drivers/iommu/s390-iommu.c                         | 106 ++---
> drivers/iommu/sun50i-iommu.c                       |  89 +++-
> drivers/irqchip/irq-gic-pm.c                       |   2 +-
> drivers/irqchip/irq-loongson-liointc.c             |   5 +-
> drivers/irqchip/irq-loongson-pch-pic.c             |   3 +
> drivers/irqchip/irq-wpcm450-aic.c                  |   1 +
> drivers/isdn/hardware/mISDN/hfcmulti.c             |  19 +-
> drivers/isdn/hardware/mISDN/hfcpci.c               |  13 +-
> drivers/isdn/hardware/mISDN/hfcsusb.c              |  12 +-
> drivers/leds/leds-is31fl319x.c                     |   3 +-
> drivers/leds/rgb/leds-qcom-lpg.c                   |  18 +-
> drivers/macintosh/macio-adb.c                      |   4 +
> drivers/macintosh/macio_asic.c                     |   2 +-
> drivers/mailbox/arm_mhuv2.c                        |   4 +-
> drivers/mailbox/mailbox-mpfs.c                     |  31 +-
> drivers/mailbox/pcc.c                              |   1 +
> drivers/mailbox/zynqmp-ipi-mailbox.c               |   4 +-
> drivers/mcb/mcb-core.c                             |   4 +-
> drivers/mcb/mcb-parse.c                            |   2 +-
> drivers/md/dm.c                                    | 123 +++--
> drivers/md/md-bitmap.c                             |  27 +-
> drivers/md/raid0.c                                 |   1 -
> drivers/md/raid1.c                                 |   1 +
> drivers/md/raid10.c                                |   2 -
> drivers/media/dvb-core/dvb_ca_en50221.c            |   2 +-
> drivers/media/dvb-core/dvb_frontend.c              |  10 +-
> drivers/media/dvb-core/dvbdev.c                    |  32 +-
> drivers/media/dvb-frontends/bcm3510.c              |   1 +
> drivers/media/i2c/ad5820.c                         |  10 +-
> drivers/media/i2c/adv748x/adv748x-afe.c            |   4 +
> drivers/media/i2c/dw9768.c                         |  33 +-
> drivers/media/i2c/hi846.c                          |  14 +-
> drivers/media/i2c/mt9p031.c                        |   1 -
> drivers/media/i2c/ov5640.c                         |   3 +-
> drivers/media/i2c/ov5648.c                         |   1 +
> drivers/media/pci/saa7164/saa7164-core.c           |   4 +-
> drivers/media/pci/solo6x10/solo6x10-core.c         |   1 +
> drivers/media/platform/amphion/vdec.c              |  15 +-
> drivers/media/platform/amphion/vpu.h               |   1 +
> drivers/media/platform/amphion/vpu_cmds.c          |  39 +-
> drivers/media/platform/amphion/vpu_drv.c           |   6 +-
> drivers/media/platform/amphion/vpu_malone.c        |   1 +
> drivers/media/platform/amphion/vpu_msgs.c          |   2 +
> drivers/media/platform/amphion/vpu_v4l2.c          |  30 +-
> drivers/media/platform/amphion/vpu_windsor.c       |   1 +
> drivers/media/platform/chips-media/coda-bit.c      |  14 +-
> drivers/media/platform/chips-media/coda-jpeg.c     |  10 +-
> .../mediatek/vcodec/mtk_vcodec_dec_stateless.c     |  13 +-
> .../mediatek/vcodec/vdec/vdec_h264_req_multi_if.c  |  60 ++-
> .../mediatek/vcodec/vdec/vdec_vp9_req_lat_if.c     |  15 +-
> .../platform/mediatek/vcodec/vdec_msg_queue.c      |   2 +-
> drivers/media/platform/nxp/imx-jpeg/mxc-jpeg-hw.c  |   4 +-
> drivers/media/platform/qcom/camss/camss-video.c    |   3 +-
> drivers/media/platform/qcom/camss/camss.c          |  11 +
> drivers/media/platform/qcom/venus/pm_helpers.c     |   4 +-
> .../media/platform/samsung/exynos4-is/fimc-core.c  |   2 +-
> .../media/platform/samsung/exynos4-is/media-dev.c  |  12 +-
> drivers/media/platform/samsung/s5p-mfc/s5p_mfc.c   |  17 +-
> .../platform/st/sti/c8sectpfe/c8sectpfe-core.c     |   1 +
> .../sunxi/sun6i-mipi-csi2/sun6i_mipi_csi2.c        |  23 +-
> .../sun8i-a83t-mipi-csi2/sun8i_a83t_mipi_csi2.c    |  23 +-
> drivers/media/radio/si470x/radio-si470x-usb.c      |   4 +-
> drivers/media/rc/imon.c                            |   6 +-
> drivers/media/test-drivers/vidtv/vidtv_bridge.c    |  22 +-
> drivers/media/test-drivers/vimc/vimc-core.c        |   2 +-
> drivers/media/test-drivers/vivid/vivid-vid-cap.c   |   1 +
> drivers/media/usb/dvb-usb/az6027.c                 |   4 +
> drivers/media/usb/dvb-usb/dvb-usb-init.c           |   4 +-
> drivers/media/v4l2-core/v4l2-ctrls-api.c           |   1 +
> drivers/media/v4l2-core/v4l2-ctrls-core.c          |   2 +-
> drivers/media/v4l2-core/v4l2-ioctl.c               |  34 +-
> drivers/media/v4l2-core/videobuf-dma-contig.c      |  22 +-
> drivers/memory/renesas-rpc-if.c                    |   3 +
> drivers/memstick/core/ms_block.c                   |   9 +-
> drivers/mfd/Kconfig                                |   1 +
> drivers/mfd/axp20x.c                               |   2 +-
> drivers/mfd/qcom-pm8008.c                          |   4 +-
> drivers/mfd/qcom_rpm.c                             |  16 +-
> drivers/misc/cxl/guest.c                           |  24 +-
> drivers/misc/cxl/pci.c                             |  21 +-
> drivers/misc/lkdtm/cfi.c                           |   6 +-
> drivers/misc/ocxl/config.c                         |  20 +-
> drivers/misc/ocxl/file.c                           |   7 +-
> drivers/misc/sgi-gru/grufault.c                    |  13 +-
> drivers/misc/sgi-gru/grumain.c                     |  22 +-
> drivers/misc/sgi-gru/grutables.h                   |   2 +-
> drivers/misc/tifm_7xx1.c                           |   2 +-
> drivers/mmc/core/sd.c                              |  11 +-
> drivers/mmc/host/alcor.c                           |   5 +-
> drivers/mmc/host/atmel-mci.c                       |   9 +-
> drivers/mmc/host/litex_mmc.c                       |   1 +
> drivers/mmc/host/meson-gx-mmc.c                    |   4 +-
> drivers/mmc/host/mmci.c                            |   4 +-
> drivers/mmc/host/moxart-mmc.c                      |   4 +-
> drivers/mmc/host/mxcmmc.c                          |   4 +-
> drivers/mmc/host/omap_hsmmc.c                      |   4 +-
> drivers/mmc/host/pxamci.c                          |   7 +-
> drivers/mmc/host/renesas_sdhi.h                    |   1 +
> drivers/mmc/host/renesas_sdhi_core.c               |  14 +-
> drivers/mmc/host/renesas_sdhi_internal_dmac.c      |   4 +-
> drivers/mmc/host/rtsx_pci_sdmmc.c                  |   9 +-
> drivers/mmc/host/rtsx_usb_sdmmc.c                  |  11 +-
> drivers/mmc/host/sdhci_f_sdh30.c                   |   3 +
> drivers/mmc/host/toshsd.c                          |   6 +-
> drivers/mmc/host/via-sdmmc.c                       |   4 +-
> drivers/mmc/host/vub300.c                          |  11 +-
> drivers/mmc/host/wbsd.c                            |  12 +-
> drivers/mmc/host/wmt-sdmmc.c                       |   6 +-
> drivers/mtd/lpddr/lpddr2_nvm.c                     |   2 +
> drivers/mtd/maps/pxa2xx-flash.c                    |   2 +
> drivers/mtd/mtdcore.c                              |   9 +-
> drivers/mtd/spi-nor/core.c                         |   3 +-
> drivers/mtd/spi-nor/sysfs.c                        |  14 +
> drivers/net/bonding/bond_main.c                    |  37 +-
> drivers/net/can/m_can/m_can.c                      |  32 +-
> drivers/net/can/m_can/m_can_platform.c             |   4 -
> drivers/net/can/m_can/tcan4x5x-core.c              |  18 +-
> drivers/net/can/usb/kvaser_usb/kvaser_usb.h        |  30 +-
> drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c   | 115 ++++-
> drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c  | 160 +++++--
> drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c   | 437 +++++++++++++++--=

> drivers/net/dsa/lan9303-core.c                     |   4 +-
> drivers/net/dsa/mv88e6xxx/chip.c                   |   9 +-
> drivers/net/ethernet/amd/atarilance.c              |   2 +-
> drivers/net/ethernet/amd/lance.c                   |   2 +-
> drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c        |  23 +-
> drivers/net/ethernet/apple/bmac.c                  |   2 +-
> drivers/net/ethernet/apple/mace.c                  |   2 +-
> drivers/net/ethernet/dnet.c                        |   4 +-
> drivers/net/ethernet/freescale/enetc/enetc.c       |  35 +-
> drivers/net/ethernet/intel/i40e/i40e_main.c        |  36 +-
> drivers/net/ethernet/intel/igb/igb_main.c          |   8 +-
> drivers/net/ethernet/intel/igc/igc.h               |   3 +
> drivers/net/ethernet/intel/igc/igc_defines.h       |   2 +
> drivers/net/ethernet/intel/igc/igc_main.c          | 210 +++++++--
> drivers/net/ethernet/intel/igc/igc_tsn.c           |  13 +-
> drivers/net/ethernet/mediatek/mtk_eth_soc.c        |  71 +--
> drivers/net/ethernet/mediatek/mtk_eth_soc.h        |  11 +-
> drivers/net/ethernet/myricom/myri10ge/myri10ge.c   |   1 +
> drivers/net/ethernet/neterion/s2io.c               |   2 +-
> drivers/net/ethernet/qlogic/qed/qed_debug.c        |   3 +-
> .../ethernet/qlogic/qlcnic/qlcnic_sriov_common.c   |   2 +
> drivers/net/ethernet/rdc/r6040.c                   |   5 +-
> .../net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c  |   3 +-
> drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   4 +-
> drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.h   |   2 +-
> .../net/ethernet/stmicro/stmmac/stmmac_selftests.c |   8 +-
> drivers/net/ethernet/ti/am65-cpsw-nuss.c           |  10 +-
> drivers/net/ethernet/ti/netcp_core.c               |   2 +-
> drivers/net/ethernet/xilinx/xilinx_emaclite.c      |   2 +-
> drivers/net/fddi/defxx.c                           |  22 +-
> drivers/net/hamradio/baycom_epp.c                  |   2 +-
> drivers/net/hamradio/scc.c                         |   6 +-
> drivers/net/macsec.c                               |  34 +-
> drivers/net/mctp/mctp-serial.c                     |   6 +-
> drivers/net/ntb_netdev.c                           |   4 +-
> drivers/net/ppp/ppp_generic.c                      |   2 +
> drivers/net/wan/farsync.c                          |   2 +
> drivers/net/wireless/ath/ar5523/ar5523.c           |   6 +
> drivers/net/wireless/ath/ath10k/core.c             |  16 +
> drivers/net/wireless/ath/ath10k/htc.c              |   9 +
> drivers/net/wireless/ath/ath10k/hw.h               |   2 +
> drivers/net/wireless/ath/ath10k/pci.c              |  20 +-
> drivers/net/wireless/ath/ath11k/core.c             |  46 ++
> drivers/net/wireless/ath/ath11k/core.h             |  14 +-
> drivers/net/wireless/ath/ath11k/debugfs.c          | 139 ++----
> drivers/net/wireless/ath/ath11k/debugfs.h          |   6 +-
> drivers/net/wireless/ath/ath11k/mac.c              | 122 +++--
> drivers/net/wireless/ath/ath11k/qmi.c              |   3 +
> drivers/net/wireless/ath/ath11k/wmi.c              |  48 +-
> drivers/net/wireless/ath/ath9k/hif_usb.c           |  46 +-
> .../broadcom/brcm80211/brcmfmac/firmware.c         |   5 +
> .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |   6 +-
> .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |   1 +
> drivers/net/wireless/intel/iwlwifi/mei/iwl-mei.h   |   7 +-
> drivers/net/wireless/intel/iwlwifi/mei/main.c      | 172 ++++---
> drivers/net/wireless/intel/iwlwifi/mei/net.c       |  10 +-
> drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |   2 +
> drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   4 +-
> drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   2 +-
> drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |  20 +-
> drivers/net/wireless/mediatek/mt76/mt76.h          |   3 +-
> drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c |  58 +--
> drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h |   5 -
> drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |  23 +-
> drivers/net/wireless/mediatek/mt76/mt7915/pci.c    |  13 +-
> drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |  34 +-
> drivers/net/wireless/mediatek/mt76/usb.c           |  11 +-
> drivers/net/wireless/purelifi/plfxlc/usb.c         |   1 +
> drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |   2 +-
> .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |  28 +-
> drivers/net/wireless/realtek/rtw89/core.c          |   2 +-
> drivers/net/wireless/realtek/rtw89/mac.c           |   6 +-
> drivers/net/wireless/realtek/rtw89/phy.c           |   2 +-
> drivers/net/wireless/rsi/rsi_91x_core.c            |   4 +-
> drivers/net/wireless/rsi/rsi_91x_hal.c             |   6 +-
> drivers/nfc/pn533/pn533.c                          |   4 +
> drivers/nvme/host/core.c                           |  14 +-
> drivers/nvme/target/core.c                         |  22 +-
> drivers/nvme/target/io-cmd-file.c                  |  16 +-
> drivers/nvme/target/nvmet.h                        |   3 +-
> drivers/of/overlay.c                               |   4 +-
> drivers/pci/controller/dwc/pci-imx6.c              |  13 +-
> drivers/pci/controller/dwc/pcie-designware.c       |   2 +-
> drivers/pci/controller/vmd.c                       |  27 +-
> drivers/pci/endpoint/functions/pci-epf-test.c      |   2 +-
> drivers/pci/endpoint/functions/pci-epf-vntb.c      |   2 +-
> drivers/pci/irq.c                                  |   2 +
> drivers/pci/probe.c                                |   3 -
> drivers/perf/arm_dmc620_pmu.c                      |   8 +-
> drivers/perf/arm_dsu_pmu.c                         |   6 +-
> drivers/perf/arm_smmuv3_pmu.c                      |   8 +-
> drivers/perf/hisilicon/hisi_pcie_pmu.c             |   8 +-
> drivers/perf/marvell_cn10k_tad_pmu.c               |   6 +-
> drivers/phy/broadcom/phy-brcm-usb-init-synopsys.c  |   9 +-
> drivers/phy/broadcom/phy-brcm-usb-init.h           |   1 -
> drivers/phy/broadcom/phy-brcm-usb.c                |  14 +-
> drivers/phy/marvell/phy-mvebu-a3700-comphy.c       |   3 +
> drivers/phy/qualcomm/phy-qcom-qmp-pcie.c           |  15 +-
> drivers/phy/qualcomm/phy-qcom-qmp-pcs-v5_20.h      |  14 +
> drivers/phy/qualcomm/phy-qcom-qmp.h                |   1 +
> drivers/pinctrl/mediatek/pinctrl-mt7986.c          |  24 +-
> drivers/pinctrl/pinconf-generic.c                  |   4 +-
> drivers/pinctrl/pinctrl-k210.c                     |   4 +-
> drivers/pinctrl/pinctrl-ocelot.c                   |  20 +-
> drivers/pinctrl/pinctrl-thunderbay.c               |   8 +-
> drivers/platform/chrome/cros_ec_typec.c            |  53 ++-
> drivers/platform/chrome/cros_usbpd_notify.c        |   6 +-
> drivers/platform/mellanox/mlxbf-pmc.c              |   2 +-
> drivers/platform/x86/huawei-wmi.c                  |  20 +-
> .../platform/x86/intel/int3472/clk_and_regulator.c |   3 +-
> drivers/platform/x86/intel_scu_ipc.c               |   2 +-
> drivers/platform/x86/mxm-wmi.c                     |   8 +-
> drivers/pnp/core.c                                 |   4 +-
> drivers/power/supply/ab8500_charger.c              |   9 +-
> drivers/power/supply/bq25890_charger.c             |  71 ++-
> drivers/power/supply/cw2015_battery.c              |  17 +-
> drivers/power/supply/power_supply_core.c           |   7 +-
> drivers/power/supply/z2_battery.c                  |   6 +-
> drivers/pwm/pwm-mediatek.c                         |   2 +-
> drivers/pwm/pwm-mtk-disp.c                         |   5 +-
> drivers/pwm/pwm-sifive.c                           |   5 +-
> drivers/pwm/pwm-tegra.c                            |  15 +-
> drivers/rapidio/devices/rio_mport_cdev.c           |  15 +-
> drivers/rapidio/rio-scan.c                         |   8 +-
> drivers/rapidio/rio.c                              |   9 +-
> drivers/regulator/core.c                           |  25 +-
> drivers/regulator/devres.c                         |   2 +-
> drivers/regulator/of_regulator.c                   |   2 +-
> drivers/regulator/qcom-labibb-regulator.c          |   1 +
> drivers/regulator/qcom-rpmh-regulator.c            |   2 +-
> drivers/regulator/stm32-vrefbuf.c                  |   2 +-
> drivers/remoteproc/qcom_q6v5_pas.c                 |   4 +
> drivers/remoteproc/qcom_q6v5_wcss.c                |   6 +-
> drivers/remoteproc/qcom_sysmon.c                   |   5 +-
> drivers/rtc/class.c                                |   4 +-
> drivers/rtc/rtc-cmos.c                             | 378 +++++++--------
> drivers/rtc/rtc-mxc_v2.c                           |   4 +-
> drivers/rtc/rtc-pcf85063.c                         |  10 +-
> drivers/rtc/rtc-pic32.c                            |   8 +-
> drivers/rtc/rtc-rzn1.c                             |   4 +-
> drivers/rtc/rtc-snvs.c                             |  16 +-
> drivers/rtc/rtc-st-lpc.c                           |   1 +
> drivers/s390/net/ctcm_main.c                       |  11 +-
> drivers/s390/net/lcs.c                             |   8 +-
> drivers/s390/net/netiucv.c                         |   9 +-
> drivers/scsi/elx/efct/efct_driver.c                |   1 +
> drivers/scsi/elx/libefc/efclib.h                   |   6 +-
> drivers/scsi/fcoe/fcoe.c                           |   1 +
> drivers/scsi/fcoe/fcoe_sysfs.c                     |  19 +-
> drivers/scsi/hisi_sas/hisi_sas_main.c              |   8 +-
> drivers/scsi/hpsa.c                                |   9 +-
> drivers/scsi/ipr.c                                 |  10 +-
> drivers/scsi/libsas/sas_ata.c                      |  25 +
> drivers/scsi/libsas/sas_expander.c                 |   4 +-
> drivers/scsi/libsas/sas_internal.h                 |   2 +
> drivers/scsi/lpfc/lpfc_sli.c                       |   6 +-
> drivers/scsi/mpt3sas/mpt3sas_transport.c           |   2 +
> drivers/scsi/qla2xxx/qla_def.h                     |  22 +-
> drivers/scsi/qla2xxx/qla_init.c                    |  20 +-
> drivers/scsi/qla2xxx/qla_inline.h                  |   4 +-
> drivers/scsi/qla2xxx/qla_os.c                      |   4 +-
> drivers/scsi/scsi_debug.c                          |  11 +-
> drivers/scsi/scsi_error.c                          |  14 +-
> drivers/scsi/smartpqi/smartpqi.h                   |   2 +-
> drivers/scsi/smartpqi/smartpqi_init.c              |  77 ++-
> drivers/scsi/snic/snic_disc.c                      |   3 +
> drivers/soc/apple/rtkit.c                          |   7 +-
> drivers/soc/apple/sart.c                           |   7 +-
> drivers/soc/mediatek/mtk-pm-domains.c              |   2 +-
> drivers/soc/qcom/apr.c                             |  15 +-
> drivers/soc/qcom/llcc-qcom.c                       |   2 +-
> drivers/soc/ti/knav_qmss_queue.c                   |   3 +-
> drivers/soc/ti/smartreflex.c                       |   1 +
> drivers/spi/spi-gpio.c                             |  16 +-
> drivers/spi/spi-mt65xx.c                           |   5 +
> drivers/spi/spidev.c                               |  21 +-
> drivers/staging/media/imx/imx7-media-csi.c         |   6 +-
> drivers/staging/media/rkvdec/rkvdec-vp9.c          |   3 +
> drivers/staging/media/stkwebcam/Kconfig            |   2 +-
> drivers/staging/media/sunxi/cedrus/cedrus_h265.c   |  25 +-
> drivers/staging/media/sunxi/cedrus/cedrus_regs.h   |   2 +
> drivers/staging/r8188eu/core/rtw_led.c             |  29 +-
> drivers/staging/r8188eu/core/rtw_pwrctrl.c         |   2 +-
> drivers/staging/rtl8192e/rtllib_rx.c               |   2 +-
> drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c  |   4 +-
> drivers/staging/vme_user/vme_fake.c                |   2 +
> drivers/staging/vme_user/vme_tsi148.c              |   1 +
> drivers/target/iscsi/iscsi_target_nego.c           |  12 +-
> drivers/thermal/imx8mm_thermal.c                   |   8 +-
> drivers/thermal/k3_j72xx_bandgap.c                 |   2 +-
> drivers/thermal/qcom/lmh.c                         |   2 +-
> drivers/thermal/qcom/qcom-spmi-temp-alarm.c        |   3 +-
> drivers/thermal/thermal_core.c                     |  18 +-
> drivers/tty/serial/8250/8250_bcm7271.c             |  10 +-
> drivers/tty/serial/altera_uart.c                   |  21 +-
> drivers/tty/serial/amba-pl011.c                    |  14 +-
> drivers/tty/serial/pch_uart.c                      |   4 +
> drivers/tty/serial/serial-tegra.c                  |   6 +-
> drivers/tty/serial/stm32-usart.c                   |  47 +-
> drivers/tty/serial/sunsab.c                        |   8 +-
> drivers/ufs/core/ufshcd.c                          |  37 +-
> drivers/uio/uio_dmem_genirq.c                      |  13 +-
> drivers/usb/cdns3/cdnsp-ring.c                     |  42 +-
> drivers/usb/core/hcd.c                             |   6 +-
> drivers/usb/dwc3/core.c                            |  23 +-
> drivers/usb/gadget/function/f_hid.c                |  53 ++-
> drivers/usb/gadget/udc/core.c                      |  12 +-
> drivers/usb/gadget/udc/fotg210-udc.c               |  12 +-
> drivers/usb/host/xhci-mtk.c                        |   1 -
> drivers/usb/host/xhci-ring.c                       |  14 +-
> drivers/usb/host/xhci.h                            |   2 +-
> drivers/usb/musb/musb_gadget.c                     |   2 -
> drivers/usb/musb/omap2430.c                        |  54 +++
> drivers/usb/roles/class.c                          |   5 +-
> drivers/usb/storage/alauda.c                       |   2 +
> drivers/usb/typec/bus.c                            |   2 +-
> drivers/usb/typec/tcpm/tcpci.c                     |   5 +-
> drivers/usb/typec/tipd/core.c                      |  11 +-
> drivers/usb/typec/wusb3801.c                       |   2 +-
> drivers/vfio/platform/vfio_platform_common.c       |   3 +-
> drivers/video/fbdev/Kconfig                        |   2 +-
> drivers/video/fbdev/core/fbcon.c                   |   3 +-
> drivers/video/fbdev/ep93xx-fb.c                    |   4 +-
> drivers/video/fbdev/geode/Kconfig                  |   1 +
> drivers/video/fbdev/hyperv_fb.c                    |   8 +-
> drivers/video/fbdev/pm2fb.c                        |   9 +-
> drivers/video/fbdev/uvesafb.c                      |   1 +
> drivers/video/fbdev/vermilion/vermilion.c          |   4 +-
> drivers/video/fbdev/via/via-core.c                 |   9 +-
> drivers/virt/coco/sev-guest/sev-guest.c            |   1 +
> drivers/watchdog/iTCO_wdt.c                        |  21 +-
> drivers/xen/privcmd.c                              |   2 +-
> fs/afs/fs_probe.c                                  |   5 +-
> fs/binfmt_misc.c                                   |   8 +-
> fs/btrfs/file.c                                    |  10 +-
> fs/char_dev.c                                      |   2 +-
> fs/cifs/cifsencrypt.c                              |  12 +-
> fs/cifs/cifsfs.c                                   |  31 +-
> fs/cifs/cifsglob.h                                 | 114 ++++-
> fs/cifs/cifsproto.h                                |  17 +-
> fs/cifs/connect.c                                  |   6 +-
> fs/cifs/dir.c                                      |  30 +-
> fs/cifs/file.c                                     |  41 +-
> fs/cifs/fs_context.c                               |  12 +-
> fs/cifs/inode.c                                    | 167 ++++---
> fs/cifs/link.c                                     | 107 +----
> fs/cifs/misc.c                                     |   6 +-
> fs/cifs/readdir.c                                  |   2 +
> fs/cifs/sess.c                                     |  30 +-
> fs/cifs/smb1ops.c                                  |  56 ++-
> fs/cifs/smb2file.c                                 | 127 ++++-
> fs/cifs/smb2inode.c                                | 169 +++----
> fs/cifs/smb2ops.c                                  | 252 ++++------
> fs/cifs/smb2pdu.c                                  |  20 +-
> fs/cifs/smb2pdu.h                                  |   3 +
> fs/cifs/smb2proto.h                                |  22 +-
> fs/configfs/dir.c                                  |   2 +
> fs/debugfs/file.c                                  |  28 +-
> fs/erofs/decompressor.c                            |  47 +-
> fs/erofs/erofs_fs.h                                |   2 +
> fs/erofs/internal.h                                |   1 +
> fs/erofs/zdata.c                                   |   3 +-
> fs/erofs/zmap.c                                    |  25 +-
> fs/f2fs/compress.c                                 |   2 +-
> fs/f2fs/f2fs.h                                     |   2 +-
> fs/f2fs/file.c                                     |   4 +
> fs/f2fs/gc.c                                       |  10 +-
> fs/f2fs/namei.c                                    | 329 +++++++------
> fs/f2fs/segment.c                                  |   8 +-
> fs/f2fs/super.c                                    |   2 +-
> fs/hfs/inode.c                                     |   2 +
> fs/hfs/trans.c                                     |   2 +-
> fs/hugetlbfs/inode.c                               |   6 +-
> fs/jfs/jfs_dmap.c                                  |  27 +-
> fs/jfs/namei.c                                     |   2 +-
> fs/ksmbd/mgmt/user_session.c                       |   8 +-
> fs/libfs.c                                         |  22 +-
> fs/lockd/svcsubs.c                                 |  17 +-
> fs/nfs/fs_context.c                                |   6 +
> fs/nfs/internal.h                                  |   6 +-
> fs/nfs/namespace.c                                 |   2 +-
> fs/nfs/nfs42xdr.c                                  |   2 +-
> fs/nfs/nfs4proc.c                                  |  38 +-
> fs/nfs/nfs4state.c                                 |   2 +
> fs/nfs/nfs4xdr.c                                   |  22 +-
> fs/nfsd/nfs2acl.c                                  |  10 -
> fs/nfsd/nfs3acl.c                                  |  30 +-
> fs/nfsd/nfs4callback.c                             |   4 +-
> fs/nfsd/nfs4proc.c                                 |   7 +-
> fs/nfsd/nfs4state.c                                |  51 +-
> fs/nilfs2/the_nilfs.c                              |  73 ++-
> fs/ntfs3/bitmap.c                                  |   2 +-
> fs/ntfs3/super.c                                   |   2 +-
> fs/ntfs3/xattr.c                                   |   2 +-
> fs/ocfs2/journal.c                                 |   2 +-
> fs/ocfs2/journal.h                                 |   1 +
> fs/ocfs2/stackglue.c                               |   8 +-
> fs/ocfs2/super.c                                   |   5 +-
> fs/orangefs/orangefs-debugfs.c                     |  29 +-
> fs/orangefs/orangefs-mod.c                         |   8 +-
> fs/orangefs/orangefs-sysfs.c                       |  71 ++-
> fs/overlayfs/file.c                                |  28 +-
> fs/overlayfs/super.c                               |   7 +-
> fs/pstore/Kconfig                                  |   1 +
> fs/pstore/pmsg.c                                   |   7 +-
> fs/pstore/ram.c                                    |   2 +
> fs/pstore/ram_core.c                               |   6 +-
> fs/reiserfs/namei.c                                |   4 +
> fs/reiserfs/xattr_security.c                       |   2 +-
> fs/sysv/itree.c                                    |   2 +-
> fs/udf/namei.c                                     |   8 +-
> fs/xattr.c                                         |   2 +-
> include/drm/drm_connector.h                        |   6 +
> include/drm/ttm/ttm_tt.h                           |   2 +-
> include/dt-bindings/clock/imx8mn-clock.h           |  24 +-
> include/dt-bindings/clock/imx8mp-clock.h           |   3 +-
> .../dt-bindings/clock/qcom,lpassaudiocc-sc7280.h   |   5 +
> .../dt-bindings/clock/qcom,lpasscorecc-sc7280.h    |   2 +
> include/linux/btf_ids.h                            |   2 +-
> include/linux/debugfs.h                            |  19 +-
> include/linux/eventfd.h                            |   2 +-
> include/linux/fortify-string.h                     |  31 +-
> include/linux/fs.h                                 |  12 +-
> include/linux/hisi_acc_qm.h                        |  37 +-
> include/linux/hyperv.h                             |   2 +
> include/linux/ieee80211.h                          |   2 +-
> include/linux/iio/imu/adis.h                       |  13 +-
> include/linux/netdevice.h                          |  58 ++-
> include/linux/proc_fs.h                            |   2 +
> include/linux/regulator/driver.h                   |   3 +-
> include/linux/skmsg.h                              |   1 +
> include/linux/timerqueue.h                         |   2 +-
> include/media/dvbdev.h                             |  32 +-
> include/net/bluetooth/hci.h                        |  20 +
> include/net/bluetooth/hci_core.h                   |   7 +-
> include/net/dst.h                                  |   5 +-
> include/net/ip_vs.h                                |  10 +-
> include/net/mrp.h                                  |   1 +
> include/net/sock_reuseport.h                       |   2 +
> include/net/tcp.h                                  |   4 +-
> include/scsi/sas_ata.h                             |   6 +
> include/sound/hda_codec.h                          |   2 +-
> include/sound/hdaudio.h                            |   1 +
> include/sound/pcm.h                                |  36 +-
> include/trace/events/f2fs.h                        |  34 +-
> include/trace/events/ib_mad.h                      |  13 +-
> include/uapi/linux/idxd.h                          |   2 +-
> include/uapi/linux/swab.h                          |   2 +-
> include/uapi/rdma/hns-abi.h                        |  15 +
> include/uapi/sound/asequencer.h                    |   8 +-
> io_uring/msg_ring.c                                |   2 +
> io_uring/net.c                                     |   2 +-
> io_uring/timeout.c                                 |   4 +-
> ipc/mqueue.c                                       |   6 +-
> kernel/acct.c                                      |   2 +
> kernel/bpf/btf.c                                   |   5 +
> kernel/bpf/syscall.c                               |   6 +-
> kernel/bpf/verifier.c                              | 108 +++--
> kernel/cpu.c                                       |  60 ++-
> kernel/events/core.c                               |   8 +-
> kernel/fork.c                                      |  17 +-
> kernel/futex/core.c                                |  26 +-
> kernel/gcov/gcc_4_7.c                              |   5 +
> kernel/irq/internals.h                             |   2 +
> kernel/irq/irqdesc.c                               |  15 +-
> kernel/kprobes.c                                   |  16 +-
> kernel/module/decompress.c                         |   8 +-
> kernel/padata.c                                    |  15 +-
> kernel/power/snapshot.c                            |   4 +-
> kernel/rcu/tree.c                                  |   2 +-
> kernel/relay.c                                     |   4 +-
> kernel/sched/core.c                                |  10 +-
> kernel/sched/cpudeadline.c                         |   2 +-
> kernel/sched/deadline.c                            |   4 +-
> kernel/sched/fair.c                                | 231 +++++++--
> kernel/sched/psi.c                                 |   8 +-
> kernel/sched/rt.c                                  |   4 +-
> kernel/sched/sched.h                               |  56 ++-
> kernel/trace/blktrace.c                            |   3 +-
> kernel/trace/trace_events_hist.c                   |   2 +-
> kernel/trace/trace_events_user.c                   |   1 +
> lib/debugobjects.c                                 |  10 +
> lib/fonts/fonts.c                                  |   4 +-
> lib/notifier-error-inject.c                        |   2 +-
> lib/test_firmware.c                                |   1 +
> mm/gup.c                                           |   3 +
> net/802/mrp.c                                      |  18 +-
> net/8021q/vlan_dev.c                               |   4 +-
> net/9p/client.c                                    |   5 +
> net/bluetooth/hci_conn.c                           |   2 +-
> net/bluetooth/hci_core.c                           |   4 +-
> net/bluetooth/hci_sync.c                           |   2 +-
> net/bluetooth/lib.c                                |   4 +-
> net/bluetooth/mgmt.c                               |   2 +-
> net/bluetooth/rfcomm/core.c                        |   2 +-
> net/bpf/test_run.c                                 |   3 -
> net/bridge/br_multicast.c                          |   4 +-
> net/bridge/br_vlan.c                               |   4 +-
> net/core/dev.c                                     |  18 +-
> net/core/devlink.c                                 |   9 +-
> net/core/drop_monitor.c                            |   8 +-
> net/core/filter.c                                  |  11 +-
> net/core/gen_stats.c                               |  16 +-
> net/core/skbuff.c                                  |   3 +
> net/core/skmsg.c                                   |   9 +-
> net/core/sock.c                                    |   2 +-
> net/core/sock_map.c                                |   2 +
> net/core/sock_reuseport.c                          |  94 +++-
> net/core/stream.c                                  |   6 +
> net/dsa/slave.c                                    |   4 +-
> net/dsa/tag_8021q.c                                |  11 +-
> net/ethtool/ioctl.c                                |   3 +-
> net/hsr/hsr_debugfs.c                              |  40 +-
> net/hsr/hsr_device.c                               |  32 +-
> net/hsr/hsr_forward.c                              |  14 +-
> net/hsr/hsr_framereg.c                             | 222 ++++-----
> net/hsr/hsr_framereg.h                             |  17 +-
> net/hsr/hsr_main.h                                 |   9 +-
> net/hsr/hsr_netlink.c                              |   4 +-
> net/ipv4/af_inet.c                                 |   8 +-
> net/ipv4/inet_connection_sock.c                    |   5 +-
> net/ipv4/ping.c                                    |   2 +-
> net/ipv4/tcp_bpf.c                                 |  19 +-
> net/ipv4/udp.c                                     |  39 +-
> net/ipv4/udp_tunnel_core.c                         |   1 +
> net/ipv6/af_inet6.c                                |   4 +-
> net/ipv6/datagram.c                                |  15 +-
> net/ipv6/seg6_local.c                              |   4 +-
> net/ipv6/sit.c                                     |  22 +-
> net/ipv6/udp.c                                     |  12 +-
> net/mac80211/cfg.c                                 |   2 +-
> net/mac80211/ieee80211_i.h                         |   1 +
> net/mac80211/iface.c                               |   1 +
> net/mac80211/mlme.c                                |  15 +-
> net/mac80211/sta_info.c                            |   8 +-
> net/mac80211/tx.c                                  |   2 +-
> net/mctp/device.c                                  |  14 +-
> net/mpls/af_mpls.c                                 |   4 +-
> net/netfilter/ipvs/ip_vs_core.c                    |  30 +-
> net/netfilter/ipvs/ip_vs_ctl.c                     |  14 +-
> net/netfilter/ipvs/ip_vs_est.c                     |  20 +-
> net/netfilter/nf_conntrack_proto_icmpv6.c          |  53 +++
> net/netfilter/nf_flow_table_offload.c              |   6 +-
> net/netfilter/nf_tables_api.c                      |   4 +-
> net/openvswitch/datapath.c                         |  29 +-
> net/openvswitch/flow_table.c                       |   9 +-
> net/rxrpc/output.c                                 |   2 +-
> net/rxrpc/sendmsg.c                                |   2 +-
> net/sched/ematch.c                                 |   2 +
> net/sctp/sysctl.c                                  |  73 +--
> net/sunrpc/clnt.c                                  |   2 +-
> net/sunrpc/xprtrdma/verbs.c                        |   2 +-
> net/tls/tls_sw.c                                   |   6 +-
> net/unix/af_unix.c                                 |  12 +-
> net/vmw_vsock/vmci_transport.c                     |   6 +-
> net/wireless/nl80211.c                             |   3 +
> net/wireless/reg.c                                 |   4 +-
> samples/bpf/xdp1_user.c                            |   2 +-
> samples/bpf/xdp2_kern.c                            |   4 +
> samples/vfio-mdev/mdpy-fb.c                        |   8 +-
> security/Kconfig.hardening                         |   3 +
> security/apparmor/apparmorfs.c                     |   4 +-
> security/apparmor/label.c                          |  12 +-
> security/apparmor/lsm.c                            |   4 +-
> security/apparmor/policy.c                         |   2 +-
> security/apparmor/policy_ns.c                      |   2 +-
> security/apparmor/policy_unpack.c                  |   2 +-
> security/integrity/digsig.c                        |   6 +-
> security/integrity/ima/ima_policy.c                |  51 +-
> security/integrity/ima/ima_template.c              |   4 +-
> security/loadpin/loadpin.c                         |  30 +-
> sound/core/pcm_native.c                            |   4 +-
> sound/drivers/mts64.c                              |   3 +
> sound/hda/hdac_stream.c                            |  17 +-
> sound/pci/asihpi/hpioctl.c                         |   2 +-
> sound/pci/hda/hda_codec.c                          |   3 +-
> sound/pci/hda/hda_controller.c                     |   4 +-
> sound/pci/hda/patch_hdmi.c                         | 273 ++++++-----
> sound/pci/hda/patch_realtek.c                      |  27 ++
> sound/soc/amd/yc/acp6x-mach.c                      |   7 +
> sound/soc/codecs/hda.c                             |   3 -
> sound/soc/codecs/hdac_hda.c                        |   3 -
> sound/soc/codecs/pcm512x.c                         |   8 +-
> sound/soc/codecs/rt298.c                           |   7 +
> sound/soc/codecs/rt5670.c                          |   2 -
> sound/soc/codecs/wm8994.c                          |   5 +
> sound/soc/codecs/wsa883x.c                         |   6 +-
> sound/soc/generic/audio-graph-card.c               |   4 +-
> sound/soc/intel/avs/boards/rt298.c                 |  24 +-
> sound/soc/intel/avs/core.c                         |   2 +-
> sound/soc/intel/avs/ipc.c                          |   6 +-
> sound/soc/intel/boards/sof_es8336.c                |   2 +-
> sound/soc/intel/skylake/skl.c                      |   5 +-
> sound/soc/mediatek/common/mtk-btcvsd.c             |   6 +-
> sound/soc/mediatek/mt8173/mt8173-afe-pcm.c         |  20 +-
> sound/soc/mediatek/mt8173/mt8173-rt5650-rt5514.c   |   7 +-
> .../mt8183/mt8183-mt6358-ts3a227-max98357.c        |  14 +-
> sound/soc/pxa/mmp-pcm.c                            |   2 +-
> sound/soc/qcom/lpass-sc7180.c                      |   3 +
> sound/soc/rockchip/rockchip_pdm.c                  |   1 +
> sound/soc/rockchip/rockchip_spdif.c                |   1 +
> sound/usb/quirks-table.h                           |   2 +
> tools/bpf/bpftool/common.c                         |   1 +
> tools/lib/bpf/bpf.h                                |   7 +
> tools/lib/bpf/btf.c                                |   8 +-
> tools/lib/bpf/btf_dump.c                           |  29 +-
> tools/lib/bpf/libbpf.c                             |  30 +-
> tools/lib/bpf/usdt.c                               |  11 +-
> tools/objtool/check.c                              |  10 +
> tools/perf/builtin-stat.c                          |  33 +-
> tools/perf/builtin-trace.c                         |  32 +-
> tools/perf/tests/shell/stat_all_pmu.sh             |  13 +-
> tools/perf/util/bpf_off_cpu.c                      |   2 +-
> tools/perf/util/debug.c                            |   4 +
> tools/perf/util/symbol-elf.c                       |   2 +-
> .../selftests/bpf/bpf_testmod/bpf_testmod.c        |  48 ++
> tools/testing/selftests/bpf/config                 |   1 +
> tools/testing/selftests/bpf/network_helpers.c      |   4 +
> tools/testing/selftests/bpf/prog_tests/empty_skb.c | 146 ++++++
> .../selftests/bpf/prog_tests/kprobe_multi_test.c   |  26 +-
> .../testing/selftests/bpf/prog_tests/lsm_cgroup.c  |  17 +-
> tools/testing/selftests/bpf/prog_tests/map_kptr.c  |   3 +-
> .../selftests/bpf/prog_tests/tracing_struct.c      |  64 +++
> .../selftests/bpf/prog_tests/xdp_adjust_tail.c     |   7 +-
> .../selftests/bpf/prog_tests/xdp_do_redirect.c     |   2 +-
> .../selftests/bpf/prog_tests/xdp_synproxy.c        |   2 +-
> tools/testing/selftests/bpf/progs/bpf_iter_ksym.c  |   6 +-
> tools/testing/selftests/bpf/progs/empty_skb.c      |  37 ++
> tools/testing/selftests/bpf/progs/lsm_cgroup.c     |   8 +
> tools/testing/selftests/bpf/progs/tracing_struct.c | 120 +++++
> tools/testing/selftests/bpf/xdp_synproxy.c         |   5 +-
> tools/testing/selftests/cgroup/cgroup_util.c       |   5 +-
> .../selftests/drivers/net/netdevsim/devlink.sh     |   4 +-
> tools/testing/selftests/efivarfs/efivarfs.sh       |   5 +
> .../ftrace/test.d/ftrace/func_event_triggers.tc    |  15 +-
> .../selftests/netfilter/conntrack_icmp_related.sh  |  36 +-
> .../selftests/powerpc/dscr/dscr_sysfs_test.c       |   5 +-
> tools/testing/selftests/proc/proc-uptime-002.c     |   3 +-
> 1027 files changed, 12883 insertions(+), 6780 deletions(-)
>=20
>=20
