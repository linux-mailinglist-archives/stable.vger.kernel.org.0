Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BDDC57141D
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 10:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232556AbiGLIN1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 04:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232314AbiGLINZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 04:13:25 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C93979FE24;
        Tue, 12 Jul 2022 01:13:22 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id j12so6611501plj.8;
        Tue, 12 Jul 2022 01:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=iQrMWrxkqmtjlkjmX6wludEy8wYKq324tUKddMOnZy0=;
        b=DmqtuJKxWRmEk13EvFQgmdLd8RDFoxV9hsclEeC0UwsXpLcRmNNoDOyFEUMWhiiG2B
         I5wS/ecZ/E2ZglBz2ci3KkLC6XELscyWg6fJip5TcXgusc+79fTK1NhxeZ741Qj0YpdL
         1kwbLZZF5DL7xTY9nA67QOMgbGbVZDPMmfjxW352tSKJoIDA9KTaT3ZTEprmm7TQRKje
         pxZ1a9JoL/gK44AZUJC4Aiy+gSt5qpjqNTXl22sz7RnYfOQGKsEvFMVnIuVgLizHdMGm
         BN95ODgCoYxlgRXEX01LmQvABCArA5gKX/VKxwhrjQjkAKygGoAsPKjUv2SOO2TPwjS9
         YdZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=iQrMWrxkqmtjlkjmX6wludEy8wYKq324tUKddMOnZy0=;
        b=Jc2ZlqVNvX+KLOwovM4YtNDitMU6qscxPaJ4vkQQfOZ+K9SN32+8y5jLT7mlckO+2r
         0qaT50Wqc/lU187dNoPJebbgiXcX7xNS1t5lml7ceSSjvkjYlormcxYmvaovt2fB/CBB
         baUWzvPyoPp41Pyses85y/ZGhTdNRn93yzN8M2C2SX0ZdYdl9FEdWOzMdJG6WIslhLLl
         tYubMD8TirqQiuj/qHscdulVD7oZTYT3ABiAW1H5ReWbPL3k8jtlIUiShH38+F59pGzI
         GmnbXfthJZM93SABLEXguviNGkQ9UZer1E5YurgqknAiawmSyVaf8s+ibfqRECyR9ENq
         A/AQ==
X-Gm-Message-State: AJIora8osRQ1aAGFka0pSgZOV0nOHBKPoz/0aPBDq2zcSmvv6kWbbUaT
        3iryXXoVnXXotyq876cvXz0=
X-Google-Smtp-Source: AGRyM1unF2mFVp4cW5EpaatVE/Dc4NAlB6ik77BxggQVZJZt9W8PO/bzUPvLDFnERTPKLSqiMU1yhg==
X-Received: by 2002:a17:90b:4d8a:b0:1ef:da53:e126 with SMTP id oj10-20020a17090b4d8a00b001efda53e126mr2904044pjb.116.1657613601844;
        Tue, 12 Jul 2022 01:13:21 -0700 (PDT)
Received: from [192.168.43.80] (subs02-180-214-232-76.three.co.id. [180.214.232.76])
        by smtp.gmail.com with ESMTPSA id e13-20020a170902784d00b0016bfea13321sm6073896pln.243.2022.07.12.01.13.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jul 2022 01:13:21 -0700 (PDT)
Message-ID: <38384a36-5474-0b56-3870-db486156694f@gmail.com>
Date:   Tue, 12 Jul 2022 15:13:14 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.15 000/229] 5.15.54-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220711145306.494277196@linuxfoundation.org>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220711145306.494277196@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/11/22 21:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.54 release.
> There are 229 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Jul 2022 14:51:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.54-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:
> 
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 5.15.54-rc2
> 
> Hangbin Liu <liuhangbin@gmail.com>
>     selftests/net: fix section name when using xdp_dummy.o
> 
> Dave Jiang <dave.jiang@intel.com>
>     dmaengine: idxd: force wq context cleanup on device disable path
> 
> Miaoqian Lin <linmq006@gmail.com>
>     dmaengine: ti: Add missing put_device in ti_dra7_xbar_route_allocate
> 
> Caleb Connolly <caleb.connolly@linaro.org>
>     dmaengine: qcom: bam_dma: fix runtime PM underflow
> 
> Miaoqian Lin <linmq006@gmail.com>
>     dmaengine: ti: Fix refcount leak in ti_dra7_xbar_route_allocate
> 
> Michael Walle <michael@walle.cc>
>     dmaengine: at_xdma: handle errors of at_xdmac_alloc_desc() correctly
> 
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>     dmaengine: lgm: Fix an error handling path in intel_ldma_probe()
> 
> Dmitry Osipenko <dmitry.osipenko@collabora.com>
>     dmaengine: pl330: Fix lockdep warning about non-static key
> 
> Linus Torvalds <torvalds@linux-foundation.org>
>     ida: don't use BUG_ON() for debugging
> 
> Samuel Holland <samuel@sholland.org>
>     dt-bindings: dma: allwinner,sun50i-a64-dma: Fix min/max typo
> 
> AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
>     Revert "serial: 8250_mtk: Make sure to select the right FEATURE_SEL"
> 
> Naoya Horiguchi <naoya.horiguchi@nec.com>
>     Revert "mm/memory-failure.c: fix race with changing page compound again"
> 
> Shuah Khan <skhan@linuxfoundation.org>
>     misc: rtsx_usb: set return value in rsp_buf alloc err path
> 
> Shuah Khan <skhan@linuxfoundation.org>
>     misc: rtsx_usb: use separate command and response buffers
> 
> Shuah Khan <skhan@linuxfoundation.org>
>     misc: rtsx_usb: fix use of dma mapped buffer for usb bulk transfer
> 
> Peter Robinson <pbrobinson@gmail.com>
>     dmaengine: imx-sdma: Allow imx8m for imx7 FW revs
> 
> Satish Nagireddy <satish.nagireddy@getcruise.com>
>     i2c: cadence: Unregister the clk notifier in error path
> 
> Heiner Kallweit <hkallweit1@gmail.com>
>     r8169: fix accessing unset transport header
> 
> Vladimir Oltean <vladimir.oltean@nxp.com>
>     selftests: forwarding: fix error message in learning_test
> 
> Vladimir Oltean <vladimir.oltean@nxp.com>
>     selftests: forwarding: fix learning_test when h1 supports IFF_UNICAST_FLT
> 
> Vladimir Oltean <vladimir.oltean@nxp.com>
>     selftests: forwarding: fix flood_unicast_test when h2 supports IFF_UNICAST_FLT
> 
> Rick Lindsley <ricklind@us.ibm.com>
>     ibmvnic: Properly dispose of all skbs during a failover.
> 
> Fabrice Gasnier <fabrice.gasnier@foss.st.com>
>     ARM: dts: stm32: add missing usbh clock and fix clk order on stm32mp15
> 
> Amelie Delaunay <amelie.delaunay@foss.st.com>
>     ARM: dts: stm32: use usbphyc ck_usbo_48m as USBH OHCI clock on stm32mp151
> 
> Norbert Zulinski <norbertx.zulinski@intel.com>
>     i40e: Fix VF's MAC Address change on VM
> 
> Lukasz Cieplicki <lukaszx.cieplicki@intel.com>
>     i40e: Fix dropped jumbo frames statistics
> 
> Jean Delvare <jdelvare@suse.de>
>     i2c: piix4: Fix a memory leak in the EFCH MMIO support
> 
> Ivan Malov <ivan.malov@oktetlabs.ru>
>     xsk: Clear page contiguity bit when unmapping pool
> 
> Mihai Sain <mihai.sain@microchip.com>
>     ARM: at91: fix soc detection for SAM9X60 SiPs
> 
> Eugen Hristev <eugen.hristev@microchip.com>
>     ARM: dts: at91: sama5d2_icp: fix eeprom compatibles
> 
> Eugen Hristev <eugen.hristev@microchip.com>
>     ARM: dts: at91: sam9x60ek: fix eeprom compatible and size
> 
> Claudiu Beznea <claudiu.beznea@microchip.com>
>     ARM: at91: pm: use proper compatibles for sama7g5's rtc and rtt
> 
> Claudiu Beznea <claudiu.beznea@microchip.com>
>     ARM: at91: pm: use proper compatibles for sam9x60's rtc and rtt
> 
> Claudiu Beznea <claudiu.beznea@microchip.com>
>     ARM: at91: pm: use proper compatible for sama5d2's rtc
> 
> Stephan Gerhold <stephan.gerhold@kernkonzept.com>
>     arm64: dts: qcom: msm8992-*: Fix vdd_lvs1_2-supply typo
> 
> Andrei Lalaev <andrey.lalaev@gmail.com>
>     pinctrl: sunxi: sunxi_pconf_set: use correct offset
> 
> Peng Fan <peng.fan@nxp.com>
>     arm64: dts: imx8mp-phyboard-pollux-rdk: correct i2c2 & mmc settings
> 
> Peng Fan <peng.fan@nxp.com>
>     arm64: dts: imx8mp-phyboard-pollux-rdk: correct eqos pad settings
> 
> Peng Fan <peng.fan@nxp.com>
>     arm64: dts: imx8mp-phyboard-pollux-rdk: correct uart pad settings
> 
> Peng Fan <peng.fan@nxp.com>
>     arm64: dts: imx8mp-evk: correct I2C3 pad settings
> 
> Peng Fan <peng.fan@nxp.com>
>     arm64: dts: imx8mp-evk: correct I2C1 pad settings
> 
> Peng Fan <peng.fan@nxp.com>
>     arm64: dts: imx8mp-evk: correct eqos pad settings
> 
> Peng Fan <peng.fan@nxp.com>
>     arm64: dts: imx8mp-evk: correct vbus pad settings
> 
> Peng Fan <peng.fan@nxp.com>
>     arm64: dts: imx8mp-evk: correct gpio-led pad settings
> 
> Sherry Sun <sherry.sun@nxp.com>
>     arm64: dts: imx8mp-evk: correct the uart2 pinctl value
> 
> Peng Fan <peng.fan@nxp.com>
>     arm64: dts: imx8mp-evk: correct mmc pad settings
> 
> Fabio Estevam <festevam@denx.de>
>     ARM: mxs_defconfig: Enable the framebuffer
> 
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>     arm64: dts: qcom: sdm845: use dispcc AHB clock for mdss node
> 
> Konrad Dybcio <konrad.dybcio@somainline.org>
>     arm64: dts: qcom: msm8994: Fix CPU6/7 reg values
> 
> Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
>     ASoC: codecs: rt700/rt711/rt711-sdca: resume bus/codec in .set_jack_detect
> 
> Charles Keepax <ckeepax@opensource.cirrus.com>
>     ASoC: rt711-sdca: Add endianness flag in snd_soc_component_driver
> 
> Charles Keepax <ckeepax@opensource.cirrus.com>
>     ASoC: rt711: Add endianness flag in snd_soc_component_driver
> 
> Samuel Holland <samuel@sholland.org>
>     pinctrl: sunxi: a83t: Fix NAND function name for some pins
> 
> Miaoqian Lin <linmq006@gmail.com>
>     ARM: meson: Fix refcount leak in meson_smp_prepare_cpus
> 
> daniel.starke@siemens.com <daniel.starke@siemens.com>
>     tty: n_gsm: fix encoding of command/response bit
> 
> Tom Rix <trix@redhat.com>
>     btrfs: fix use of uninitialized variable at rm device ioctl
> 
> Ye Guojin <ye.guojin@zte.com.cn>
>     virtio-blk: modify the value type of num in virtio_queue_rq()
> 
> Dan Carpenter <dan.carpenter@oracle.com>
>     btrfs: fix error pointer dereference in btrfs_ioctl_rm_dev_v2()
> 
> Hui Wang <hui.wang@canonical.com>
>     Revert "serial: sc16is7xx: Clear RS485 bits in the shutdown"
> 
> Eric Sandeen <sandeen@redhat.com>
>     xfs: remove incorrect ASSERT in xfs_rename
> 
> Jimmy Assarsson <extja@kvaser.com>
>     can: kvaser_usb: kvaser_usb_leaf: fix bittiming limits
> 
> Jimmy Assarsson <extja@kvaser.com>
>     can: kvaser_usb: kvaser_usb_leaf: fix CAN clock frequency regression
> 
> Jimmy Assarsson <extja@kvaser.com>
>     can: kvaser_usb: replace run-time checks with struct kvaser_usb_driver_info
> 
> Christian Marangi <ansuelsmth@gmail.com>
>     net: dsa: qca8k: reset cpu port on MTU change
> 
> Jason A. Donenfeld <Jason@zx2c4.com>
>     powerpc/powernv: delay rng platform device creation until later in boot
> 
> Hsin-Yi Wang <hsinyi@chromium.org>
>     video: of_display_timing.h: include errno.h
> 
> Dan Williams <dan.j.williams@intel.com>
>     memregion: Fix memregion_free() fallback definition
> 
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>     PM: runtime: Redefine pm_runtime_release_supplier()
> 
> Helge Deller <deller@gmx.de>
>     fbcon: Prevent that screen size is smaller than font size
> 
> Helge Deller <deller@gmx.de>
>     fbcon: Disallow setting font bigger than screen size
> 
> Helge Deller <deller@gmx.de>
>     fbmem: Check virtual screen sizes in fb_set_var()
> 
> Guiling Deng <greens9@163.com>
>     fbdev: fbmem: Fix logo center image dx issue
> 
> Yian Chen <yian.chen@intel.com>
>     iommu/vt-d: Fix PCI bus rescan device hot add
> 
> Alexey Dobriyan <adobriyan@gmail.com>
>     module: fix [e_shstrndx].sh_size=0 OOB access
> 
> Shuah Khan <skhan@linuxfoundation.org>
>     module: change to print useful messages from elf_validity_check()
> 
> Bryan O'Donoghue <bryan.odonoghue@linaro.org>
>     dt-bindings: soc: qcom: smd-rpm: Fix missing MSM8936 compatible
> 
> Vladimir Lypak <vladimir.lypak@gmail.com>
>     dt-bindings: soc: qcom: smd-rpm: Add compatible for MSM8953 SoC
> 
> David Howells <dhowells@redhat.com>
>     rxrpc: Fix locking issue
> 
> Mark Rutland <mark.rutland@arm.com>
>     irqchip/gic-v3: Refactor ISB + EOIR at ack time
> 
> Mark Rutland <mark.rutland@arm.com>
>     irqchip/gic-v3: Ensure pseudo-NMIs have an ISB between ack and handling
> 
> Pavel Begunkov <asml.silence@gmail.com>
>     io_uring: avoid io-wq -EAGAIN looping for !IOPOLL
> 
> Sean Wang <sean.wang@mediatek.com>
>     Bluetooth: btmtksdio: fix use-after-free at btmtksdio_recv_event
> 
> Niels Dossche <dossche.niels@gmail.com>
>     Bluetooth: protect le accept and resolv lists with hdev->lock
> 
> Rex-BC Chen <rex-bc.chen@mediatek.com>
>     drm/mediatek: Add vblank register/unregister callback functions
> 
> Chun-Kuang Hu <chunkuang.hu@kernel.org>
>     drm/mediatek: Add cmdq_handle in mtk_crtc
> 
> Chun-Kuang Hu <chunkuang.hu@kernel.org>
>     drm/mediatek: Detect CMDQ execution timeout
> 
> Chun-Kuang Hu <chunkuang.hu@kernel.org>
>     drm/mediatek: Remove the pointer of struct cmdq_client
> 
> Chun-Kuang Hu <chunkuang.hu@kernel.org>
>     drm/mediatek: Use mailbox rx_callback instead of cmdq_task_cb
> 
> Thomas Hellström <thomas.hellstrom@linux.intel.com>
>     drm/i915: Fix a race between vma / object destruction and unbinding
> 
> Richard Gong <richard.gong@amd.com>
>     drm/amdgpu: vi: disable ASPM on Intel Alder Lake based systems
> 
> Mario Limonciello <mario.limonciello@amd.com>
>     drm/amd: Refactor `amdgpu_aspm` to be evaluated per device
> 
> Daniel Starke <daniel.starke@siemens.com>
>     tty: n_gsm: fix invalid gsmtty_write_room() result
> 
> AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
>     serial: 8250_mtk: Make sure to select the right FEATURE_SEL
> 
> Michael Ellerman <mpe@ellerman.id.au>
>     powerpc/vdso: Fix incorrect CFI in gettimeofday.S
> 
> Christophe Leroy <christophe.leroy@csgroup.eu>
>     powerpc/vdso: Move cvdso_call macro into gettimeofday.S
> 
> Christophe Leroy <christophe.leroy@csgroup.eu>
>     powerpc/vdso: Remove cvdso_call_time macro
> 
> Daniel Starke <daniel.starke@siemens.com>
>     tty: n_gsm: fix sometimes uninitialized warning in gsm_dlci_modem_output()
> 
> Daniel Starke <daniel.starke@siemens.com>
>     tty: n_gsm: fix invalid use of MSC in advanced option
> 
> Naoya Horiguchi <naoya.horiguchi@nec.com>
>     mm/hwpoison: fix race between hugetlb free/demotion and memory_failure_hugetlb()
> 
> Miaohe Lin <linmiaohe@huawei.com>
>     mm/memory-failure.c: fix race with changing page compound again
> 
> luofei <luofei@unicloud.com>
>     mm/hwpoison: avoid the impact of hwpoison_filter() return value on mce handler
> 
> Naoya Horiguchi <naoya.horiguchi@nec.com>
>     mm/hwpoison: mf_mutex for soft offline and unpoison
> 
> Sean Christopherson <seanjc@google.com>
>     KVM: Initialize debugfs_dentry when a VM is created to avoid NULL deref
> 
> Naohiro Aota <naohiro.aota@wdc.com>
>     btrfs: zoned: use dedicated lock for data relocation
> 
> Johannes Thumshirn <johannes.thumshirn@wdc.com>
>     btrfs: zoned: encapsulate inode locking for zoned relocation
> 
> Daniel Starke <daniel.starke@siemens.com>
>     tty: n_gsm: fix missing update of modem controls after DLCI open
> 
> Maurizio Avogadro <mavoga@gmail.com>
>     ALSA: usb-audio: add mapping for MSI MAG X570S Torpedo MAX.
> 
> Johannes Schickel <lordhoto@gmail.com>
>     ALSA: usb-audio: add mapping for MSI MPG X570S Carbon Max Wifi.
> 
> Daniel Starke <daniel.starke@siemens.com>
>     tty: n_gsm: fix frame reception handling
> 
> Zhenguo Zhao <Zhenguo.Zhao1@unisoc.com>
>     tty: n_gsm: Save dlci address open status when config requester
> 
> Zhenguo Zhao <Zhenguo.Zhao1@unisoc.com>
>     tty: n_gsm: Modify CR,PF bit when config requester
> 
> Oliver Upton <oupton@google.com>
>     KVM: Don't create VM debugfs files outside of the VM directory
> 
> tiancyin <tianci.yin@amd.com>
>     drm/amd/vcn: fix an error msg on vcn 3.0
> 
> Xiaomeng Tong <xiam0nd.tong@gmail.com>
>     ASoC: rt5682: fix an incorrect NULL check on list iterator
> 
> Jack Yu <jack.yu@realtek.com>
>     ASoC: rt5682: move clk related code to rt5682_i2c_probe
> 
> Tadeusz Struk <tadeusz.struk@linaro.org>
>     uapi/linux/stddef.h: Add include guards
> 
> Kees Cook <keescook@chromium.org>
>     stddef: Introduce DECLARE_FLEX_ARRAY() helper
> 
> Paul Davey <paul.davey@alliedtelesis.co.nz>
>     bus: mhi: Fix pm_state conversion to string
> 
> Kees Cook <keescook@chromium.org>
>     bus: mhi: core: Use correctly sized arguments for bit field
> 
> Hui Wang <hui.wang@canonical.com>
>     serial: sc16is7xx: Clear RS485 bits in the shutdown
> 
> Nicholas Piggin <npiggin@gmail.com>
>     powerpc/tm: Fix more userspace r13 corruption
> 
> Nicholas Piggin <npiggin@gmail.com>
>     powerpc: flexible GPR range save/restore macros
> 
> Christophe Leroy <christophe.leroy@csgroup.eu>
>     powerpc/32: Don't use lmw/stmw for saving/restoring non volatile regs
> 
> Arun Easi <aeasi@marvell.com>
>     scsi: qla2xxx: Fix loss of NVMe namespaces after driver reload test
> 
> Claudio Imbrenda <imbrenda@linux.ibm.com>
>     KVM: s390x: fix SCK locking
> 
> Dongliang Mu <mudongliangabcd@gmail.com>
>     btrfs: don't access possibly stale fs_info data in device_list_add
> 
> Paolo Bonzini <pbonzini@redhat.com>
>     KVM: use __vcalloc for very large allocations
> 
> Paolo Bonzini <pbonzini@redhat.com>
>     mm: vmalloc: introduce array allocation functions
> 
> Kees Cook <keescook@chromium.org>
>     Compiler Attributes: add __alloc_size() for better bounds checking
> 
> Tudor Ambarus <tudor.ambarus@microchip.com>
>     mtd: spi-nor: Skip erase logic when SPI_NOR_NO_ERASE is set
> 
> Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>     batman-adv: Use netif_rx().
> 
> Haibo Chen <haibo.chen@nxp.com>
>     iio: accel: mma8452: use the correct logic to get mma8452_data
> 
> Palmer Dabbelt <palmer@rivosinc.com>
>     riscv/mm: Add XIP_FIXUP for riscv_pfn_base
> 
> Chuck Lever <chuck.lever@oracle.com>
>     NFSD: COMMIT operations must not return NFS?ERR_INVAL
> 
> Chuck Lever <chuck.lever@oracle.com>
>     NFSD: De-duplicate net_generic(nf->nf_net, nfsd_net_id)
> 
> CHANDAN VURDIGERE NATARAJ <chandan.vurdigerenataraj@amd.com>
>     drm/amd/display: Fix by adding FPU protection for dcn30_internal_validate_bw
> 
> Michael Strauss <michael.strauss@amd.com>
>     drm/amd/display: Set min dcfclk if pipe count is 0
> 
> Xiaomeng Tong <xiam0nd.tong@gmail.com>
>     drbd: fix an invalid memory access caused by incorrect use of list iterator
> 
> Wu Bo <wubo40@huawei.com>
>     drbd: Fix double free problem in drbd_create_device
> 
> Luis Chamberlain <mcgrof@kernel.org>
>     drbd: add error handling support for add_disk()
> 
> Qu Wenruo <wqu@suse.com>
>     btrfs: remove device item and update super block in the same transaction
> 
> Josef Bacik <josef@toxicpanda.com>
>     btrfs: use btrfs_get_dev_args_from_path in dev removal ioctls
> 
> Josef Bacik <josef@toxicpanda.com>
>     btrfs: add a btrfs_get_dev_args_from_path helper
> 
> Josef Bacik <josef@toxicpanda.com>
>     btrfs: handle device lookup with btrfs_dev_lookup_args
> 
> Eli Cohen <elic@nvidia.com>
>     vdpa/mlx5: Avoid processing works if workqueue was destroyed
> 
> Andreas Gruenbacher <agruenba@redhat.com>
>     gfs2: Fix gfs2_file_buffered_write endless loop workaround
> 
> Arun Easi <aeasi@marvell.com>
>     scsi: qla2xxx: Fix crash during module load unload test
> 
> Quinn Tran <qutran@marvell.com>
>     scsi: qla2xxx: edif: Replace list_for_each_safe with list_for_each_entry_safe
> 
> Quinn Tran <qutran@marvell.com>
>     scsi: qla2xxx: Fix laggy FC remote port session recovery
> 
> Manish Rangankar <mrangankar@marvell.com>
>     scsi: qla2xxx: Move heartbeat handling from DPC thread to workqueue
> 
> Sean Christopherson <seanjc@google.com>
>     KVM: x86/mmu: Use common TDP MMU zap helper for MMU notifier unmap hook
> 
> Sean Christopherson <seanjc@google.com>
>     KVM: x86/mmu: Use yield-safe TDP MMU root iter in MMU notifier unmapping
> 
> Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
>     clk: renesas: r9a07g044: Update multiplier and divider values for PLL2/3
> 
> Dan Williams <dan.j.williams@intel.com>
>     cxl/port: Hold port reference until decoder release
> 
> Lorenzo Bianconi <lorenzo@kernel.org>
>     mt76: mt7921: do not always disable fw runtime-pm
> 
> Sean Wang <sean.wang@mediatek.com>
>     mt76: mt76_connac: fix MCU_CE_CMD_SET_ROC definition error
> 
> Johan Hovold <johan@kernel.org>
>     media: davinci: vpif: fix use-after-free on driver unbind
> 
> Kees Cook <keescook@chromium.org>
>     media: omap3isp: Use struct_group() for memcpy() region
> 
> Kees Cook <keescook@chromium.org>
>     stddef: Introduce struct_group() helper macro
> 
> Tejun Heo <tj@kernel.org>
>     block: fix rq-qos breakage from skipping rq_qos_done_bio()
> 
> Jens Axboe <axboe@kernel.dk>
>     block: only mark bio as tracked if it really is tracked
> 
> Pavel Begunkov <asml.silence@gmail.com>
>     block: use bdev_get_queue() in bio.c
> 
> Jens Axboe <axboe@kernel.dk>
>     io_uring: ensure that fsnotify is always called
> 
> Max Gurtovoy <mgurtovoy@nvidia.com>
>     virtio-blk: avoid preallocating big SGL for data
> 
> Sukadev Bhattiprolu <sukadev@linux.ibm.com>
>     ibmvnic: Allow queueing resets during probe
> 
> Sukadev Bhattiprolu <sukadev@linux.ibm.com>
>     ibmvnic: clear fop when retrying probe
> 
> Sukadev Bhattiprolu <sukadev@linux.ibm.com>
>     ibmvnic: init init_done_rc earlier
> 
> Alexander Egorenkov <egorenar@linux.ibm.com>
>     s390/setup: preserve memory at OLDMEM_BASE and OLDMEM_SIZE
> 
> Alexander Gordeev <agordeev@linux.ibm.com>
>     s390/setup: use physical pointers for memblock_reserve()
> 
> Alexander Gordeev <agordeev@linux.ibm.com>
>     s390/boot: allocate amode31 section in decompressor
> 
> Florian Westphal <fw@strlen.de>
>     netfilter: nft_payload: don't allow th access for fragments
> 
> Pablo Neira Ayuso <pablo@netfilter.org>
>     netfilter: nft_payload: support for inner header matching / mangling
> 
> Pablo Neira Ayuso <pablo@netfilter.org>
>     netfilter: nf_tables: convert pktinfo->tprot_set to flags field
> 
> Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>     ASoC: rt5682: Fix deadlock on resume
> 
> Derek Fang <derek.fang@realtek.com>
>     ASoC: rt5682: Re-detect the combo jack after resuming
> 
> Derek Fang <derek.fang@realtek.com>
>     ASoC: rt5682: Avoid the unexpected IRQ event during going to suspend
> 
> Roi Dayan <roid@nvidia.com>
>     net/mlx5e: TC, Reject rules with forward and drop actions
> 
> Roi Dayan <roid@nvidia.com>
>     net/mlx5e: TC, Reject rules with drop and modify hdr action
> 
> Roi Dayan <roid@nvidia.com>
>     net/mlx5e: Split actions_match_supported() into a sub function
> 
> Roi Dayan <roid@nvidia.com>
>     net/mlx5e: Check action fwd/drop flag exists also for nic flows
> 
> Palmer Dabbelt <palmer@rivosinc.com>
>     RISC-V: defconfigs: Set CONFIG_FB=y, for FB console
> 
> Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
>     riscv: defconfig: enable DRM_NOUVEAU
> 
> Hou Tao <houtao1@huawei.com>
>     bpf, arm64: Use emit_addr_mov_i64() for BPF_PSEUDO_FUNC
> 
> Martin KaFai Lau <kafai@fb.com>
>     bpf: Stop caching subprog index in the bpf_pseudo_func insn
> 
> Lorenzo Bianconi <lorenzo@kernel.org>
>     mt76: mt7921: fix a possible race enabling/disabling runtime-pm
> 
> Lorenzo Bianconi <lorenzo@kernel.org>
>     mt76: mt7921: introduce mt7921_mcu_set_beacon_filter utility routine
> 
> Lorenzo Bianconi <lorenzo@kernel.org>
>     mt76: mt7921: get rid of mt7921_mac_set_beacon_filter
> 
> Hans de Goede <hdegoede@redhat.com>
>     platform/x86: wmi: Fix driver->notify() vs ->probe() race
> 
> Hans de Goede <hdegoede@redhat.com>
>     platform/x86: wmi: Replace read_takes_no_args with a flags field
> 
> Barnabás Pőcze <pobrn@protonmail.com>
>     platform/x86: wmi: introduce helper to convert driver to WMI driver
> 
> Shai Malin <smalin@marvell.com>
>     qed: Improve the stack space of filter_config()
> 
> Seevalamuthu Mariappan <quic_seevalam@quicinc.com>
>     ath11k: add hw_param for wakeup_mhi
> 
> Andrew Gabbasov <andrew_gabbasov@mentor.com>
>     memory: renesas-rpc-if: Avoid unaligned bus access for HyperFlash
> 
> Sean Young <sean@mess.org>
>     media: ir_toy: prevent device from hanging during transmit
> 
> Lukas Wunner <lukas@wunner.de>
>     PCI: pciehp: Ignore Link Down/Up caused by error-induced Hot Reset
> 
> Lukas Wunner <lukas@wunner.de>
>     PCI/portdrv: Rename pm_iter() to pcie_port_device_iter()
> 
> Ville Syrjälä <ville.syrjala@linux.intel.com>
>     drm/i915: Replace the unconditional clflush with drm_clflush_virt_range()
> 
> Thomas Hellström <thomas.hellstrom@linux.intel.com>
>     drm/i915/gt: Register the migrate contexts with their engines
> 
> Matthew Brost <matthew.brost@intel.com>
>     drm/i915: Disable bonding on gen12+ platforms
> 
> Filipe Manana <fdmanana@suse.com>
>     btrfs: fix deadlock between chunk allocation and chunk btree modifications
> 
> Michel Dänzer <mdaenzer@redhat.com>
>     dma-buf/poll: Get a file reference for outstanding fence callbacks
> 
> Hans de Goede <hdegoede@redhat.com>
>     Input: goodix - try not to touch the reset-pin on x86/ACPI devices
> 
> Hans de Goede <hdegoede@redhat.com>
>     Input: goodix - refactor reset handling
> 
> Hans de Goede <hdegoede@redhat.com>
>     Input: goodix - add a goodix.h header file
> 
> Hans de Goede <hdegoede@redhat.com>
>     Input: goodix - change goodix_i2c_write() len parameter type to int
> 
> Tang Bin <tangbin@cmss.chinamobile.com>
>     Input: cpcap-pwrbutton - handle errors from platform_get_irq()
> 
> Filipe Manana <fdmanana@suse.com>
>     btrfs: fix warning when freeing leaf after subvolume creation failure
> 
> Filipe Manana <fdmanana@suse.com>
>     btrfs: fix invalid delayed ref after subvolume creation failure
> 
> Nikolay Borisov <nborisov@suse.com>
>     btrfs: add additional parameters to btrfs_init_tree_ref/btrfs_init_data_ref
> 
> Nikolay Borisov <nborisov@suse.com>
>     btrfs: rename btrfs_alloc_chunk to btrfs_create_chunk
> 
> Pablo Neira Ayuso <pablo@netfilter.org>
>     netfilter: nf_tables: stricter validation of element data
> 
> Pablo Neira Ayuso <pablo@netfilter.org>
>     netfilter: nft_set_pipapo: release elements in clone from abort path
> 
> Duoming Zhou <duoming@zju.edu.cn>
>     net: rose: fix UAF bug caused by rose_t0timer_expiry
> 
> Oliver Neukum <oneukum@suse.com>
>     usbnet: fix memory leak in error case
> 
> Daniel Borkmann <daniel@iogearbox.net>
>     bpf: Fix insufficient bounds propagation from adjust_scalar_min_max_vals
> 
> Daniel Borkmann <daniel@iogearbox.net>
>     bpf: Fix incorrect verifier simulation around jmp32's jeq/jne
> 
> Thomas Kopp <thomas.kopp@microchip.com>
>     can: mcp251xfd: mcp251xfd_regmap_crc_read(): update workaround broken CRC on TBC register
> 
> Thomas Kopp <thomas.kopp@microchip.com>
>     can: mcp251xfd: mcp251xfd_regmap_crc_read(): improve workaround handling for mcp2517fd
> 
> Marc Kleine-Budde <mkl@pengutronix.de>
>     can: m_can: m_can_{read_fifo,echo_tx_event}(): shift timestamp to full 32 bits
> 
> Marc Kleine-Budde <mkl@pengutronix.de>
>     can: m_can: m_can_chip_config(): actually enable internal timestamping
> 
> Rhett Aultman <rhett.aultman@samsara.com>
>     can: gs_usb: gs_usb_open/close(): fix memory leak
> 
> Liang He <windhl@126.com>
>     can: grcan: grcan_probe(): remove extra of_node_get()
> 
> Oliver Hartkopp <socketcan@hartkopp.net>
>     can: bcm: use call_rcu() instead of costly synchronize_rcu()
> 
> Takashi Iwai <tiwai@suse.de>
>     ALSA: cs46xx: Fix missing snd_card_free() call at probe error
> 
> Tim Crawford <tcrawford@system76.com>
>     ALSA: hda/realtek: Add quirk for Clevo L140PU
> 
> Takashi Iwai <tiwai@suse.de>
>     ALSA: usb-audio: Workarounds for Behringer UMC 204/404 HD
> 
> Po-Hsu Lin <po-hsu.lin@canonical.com>
>     Revert "selftests/bpf: Add test for bpf_timer overwriting crash"
> 
> Liu Shixin <liushixin2@huawei.com>
>     mm/filemap: fix UAF in find_lock_entries
> 
> Jann Horn <jannh@google.com>
>     mm/slub: add missing TID updates on slab deactivation
> 
> 
> -------------
> 
> Diffstat:
> 
>  .../bindings/dma/allwinner,sun50i-a64-dma.yaml     |   2 +-
>  .../devicetree/bindings/soc/qcom/qcom,smd-rpm.yaml |   3 +
>  MAINTAINERS                                        |   3 +-
>  Makefile                                           |  19 +-
>  arch/arm/boot/dts/at91-sam9x60ek.dts               |   3 +-
>  arch/arm/boot/dts/at91-sama5d2_icp.dts             |   6 +-
>  arch/arm/boot/dts/stm32mp151.dtsi                  |   4 +-
>  arch/arm/configs/mxs_defconfig                     |   1 +
>  arch/arm/include/asm/arch_gicv3.h                  |   7 +-
>  arch/arm/mach-at91/pm.c                            |  10 +-
>  arch/arm/mach-meson/platsmp.c                      |   2 +
>  arch/arm64/boot/dts/freescale/imx8mp-evk.dts       |  54 ++--
>  .../dts/freescale/imx8mp-phyboard-pollux-rdk.dts   |  48 ++--
>  .../boot/dts/qcom/msm8992-bullhead-rev-101.dts     |   2 +-
>  arch/arm64/boot/dts/qcom/msm8992-xiaomi-libra.dts  |   2 +-
>  arch/arm64/boot/dts/qcom/msm8994.dtsi              |   4 +-
>  arch/arm64/boot/dts/qcom/sdm845.dtsi               |   2 +-
>  arch/arm64/include/asm/arch_gicv3.h                |   6 -
>  arch/arm64/net/bpf_jit_comp.c                      |   5 +-
>  arch/powerpc/boot/crt0.S                           |  31 +--
>  arch/powerpc/crypto/md5-asm.S                      |  10 +-
>  arch/powerpc/crypto/sha1-powerpc-asm.S             |   6 +-
>  arch/powerpc/include/asm/ppc_asm.h                 |  43 +--
>  arch/powerpc/include/asm/vdso/gettimeofday.h       |  69 +----
>  arch/powerpc/kernel/entry_32.S                     |  23 +-
>  arch/powerpc/kernel/exceptions-64e.S               |  14 +-
>  arch/powerpc/kernel/exceptions-64s.S               |   6 +-
>  arch/powerpc/kernel/head_32.h                      |   3 +-
>  arch/powerpc/kernel/head_booke.h                   |   3 +-
>  arch/powerpc/kernel/interrupt_64.S                 |  34 +--
>  arch/powerpc/kernel/optprobes_head.S               |   4 +-
>  arch/powerpc/kernel/tm.S                           |  38 +--
>  arch/powerpc/kernel/trace/ftrace_64_mprofile.S     |  15 +-
>  arch/powerpc/kernel/vdso32/gettimeofday.S          |  51 +++-
>  arch/powerpc/kvm/book3s_hv_rmhandlers.S            |   5 +-
>  arch/powerpc/kvm/book3s_hv_uvmem.c                 |   2 +-
>  arch/powerpc/lib/test_emulate_step_exec_instr.S    |   8 +-
>  arch/powerpc/platforms/powernv/rng.c               |  16 +-
>  arch/riscv/configs/defconfig                       |   8 +-
>  arch/riscv/configs/rv32_defconfig                  |   1 +
>  arch/riscv/mm/init.c                               |   1 +
>  arch/s390/boot/compressed/decompressor.h           |   1 +
>  arch/s390/boot/startup.c                           |   8 +
>  arch/s390/kernel/entry.h                           |   1 +
>  arch/s390/kernel/setup.c                           |  31 +--
>  arch/s390/kernel/vmlinux.lds.S                     |   1 +
>  arch/s390/kvm/kvm-s390.c                           |  19 +-
>  arch/s390/kvm/kvm-s390.h                           |   4 +-
>  arch/s390/kvm/priv.c                               |  15 +-
>  arch/x86/kernel/cpu/mce/core.c                     |   8 +-
>  arch/x86/kvm/mmu/page_track.c                      |   4 +-
>  arch/x86/kvm/mmu/tdp_mmu.c                         |   9 +-
>  arch/x86/kvm/x86.c                                 |   4 +-
>  block/bio.c                                        |  11 +-
>  block/blk-iolatency.c                              |   2 +-
>  block/blk-rq-qos.h                                 |  23 +-
>  drivers/base/core.c                                |   3 +-
>  drivers/base/memory.c                              |   2 +
>  drivers/base/power/runtime.c                       |  20 +-
>  drivers/block/Kconfig                              |   1 +
>  drivers/block/drbd/drbd_main.c                     |   8 +-
>  drivers/block/virtio_blk.c                         | 158 +++++++----
>  drivers/bluetooth/btmtksdio.c                      |   3 +-
>  drivers/bus/mhi/core/init.c                        |   9 +-
>  drivers/bus/mhi/core/internal.h                    |   2 +-
>  drivers/clk/renesas/r9a07g044-cpg.c                |   4 +-
>  drivers/cxl/core/bus.c                             |   4 +
>  drivers/dma-buf/dma-buf.c                          |  19 +-
>  drivers/dma/at_xdmac.c                             |   5 +
>  drivers/dma/idxd/device.c                          |   5 +-
>  drivers/dma/imx-sdma.c                             |   2 +-
>  drivers/dma/lgm/lgm-dma.c                          |   3 +-
>  drivers/dma/pl330.c                                |   2 +-
>  drivers/dma/qcom/bam_dma.c                         |  39 +--
>  drivers/dma/ti/dma-crossbar.c                      |   5 +
>  drivers/gpu/drm/amd/amdgpu/amdgpu.h                |   1 +
>  drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  25 ++
>  drivers/gpu/drm/amd/amdgpu/cik.c                   |   2 +-
>  drivers/gpu/drm/amd/amdgpu/nv.c                    |   2 +-
>  drivers/gpu/drm/amd/amdgpu/si.c                    |   2 +-
>  drivers/gpu/drm/amd/amdgpu/soc15.c                 |   2 +-
>  drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c              |   2 +-
>  drivers/gpu/drm/amd/amdgpu/vi.c                    |  17 +-
>  .../gpu/drm/amd/display/dc/dcn30/dcn30_resource.c  |   2 +-
>  .../gpu/drm/amd/display/dc/dcn30/dcn30_resource.h  |   7 +
>  .../gpu/drm/amd/display/dc/dcn31/dcn31_resource.c  |  65 ++++-
>  .../drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c    |   2 +-
>  drivers/gpu/drm/i915/gem/i915_gem_context.c        |   7 +
>  drivers/gpu/drm/i915/gem/i915_gem_object.c         |   6 +
>  drivers/gpu/drm/i915/gt/intel_context_types.h      |   8 +
>  drivers/gpu/drm/i915/gt/intel_engine_cs.c          |   4 +
>  drivers/gpu/drm/i915/gt/intel_engine_pm.c          |  23 ++
>  drivers/gpu/drm/i915/gt/intel_engine_pm.h          |   2 +
>  drivers/gpu/drm/i915/gt/intel_engine_types.h       |   7 +
>  .../gpu/drm/i915/gt/intel_execlists_submission.c   |   2 +
>  drivers/gpu/drm/i915/gt/intel_ring_submission.c    |   5 +-
>  drivers/gpu/drm/i915/gt/mock_engine.c              |   2 +
>  drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c  |  12 +-
>  drivers/gpu/drm/mediatek/mtk_disp_drv.h            |  16 +-
>  drivers/gpu/drm/mediatek/mtk_disp_ovl.c            |  22 +-
>  drivers/gpu/drm/mediatek/mtk_disp_rdma.c           |  20 +-
>  drivers/gpu/drm/mediatek/mtk_drm_crtc.c            | 133 +++++++--
>  drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c        |   4 +
>  drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.h        |  29 +-
>  drivers/i2c/busses/i2c-cadence.c                   |   1 +
>  drivers/i2c/busses/i2c-piix4.c                     |  16 +-
>  drivers/iio/accel/mma8452.c                        |   4 +-
>  drivers/input/misc/cpcap-pwrbutton.c               |   6 +-
>  drivers/input/touchscreen/goodix.c                 | 150 +++++-----
>  drivers/input/touchscreen/goodix.h                 |  75 +++++
>  drivers/iommu/intel/dmar.c                         |   2 +-
>  drivers/irqchip/irq-gic-v3.c                       |  42 ++-
>  drivers/media/platform/davinci/vpif.c              |  97 +++++--
>  drivers/media/platform/omap3isp/ispstat.c          |   5 +-
>  drivers/media/rc/ir_toy.c                          |   2 +-
>  drivers/memory/renesas-rpc-if.c                    |  48 +++-
>  drivers/misc/cardreader/rtsx_usb.c                 |  27 +-
>  drivers/mtd/spi-nor/core.c                         |   3 +-
>  drivers/net/can/grcan.c                            |   1 -
>  drivers/net/can/m_can/m_can.c                      |   8 +-
>  drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c   |  22 +-
>  drivers/net/can/usb/gs_usb.c                       |  23 +-
>  drivers/net/can/usb/kvaser_usb/kvaser_usb.h        |  25 +-
>  drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c   | 286 ++++++++++---------
>  drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c  |   4 +-
>  drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c   | 119 ++++----
>  drivers/net/dsa/qca8k.c                            |  23 +-
>  drivers/net/ethernet/ibm/ibmvnic.c                 | 147 +++++++++-
>  drivers/net/ethernet/ibm/ibmvnic.h                 |   1 +
>  drivers/net/ethernet/intel/i40e/i40e.h             |  16 ++
>  drivers/net/ethernet/intel/i40e/i40e_main.c        |  73 +++++
>  drivers/net/ethernet/intel/i40e/i40e_register.h    |  13 +
>  drivers/net/ethernet/intel/i40e/i40e_type.h        |   1 +
>  drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |   4 +
>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  88 +++---
>  drivers/net/ethernet/qlogic/qed/qed_l2.c           |  23 +-
>  drivers/net/ethernet/qlogic/qede/qede_filter.c     |  47 ++--
>  drivers/net/ethernet/realtek/r8169_main.c          |  10 +-
>  drivers/net/usb/usbnet.c                           |  17 +-
>  drivers/net/wireless/ath/ath11k/core.c             |   5 +
>  drivers/net/wireless/ath/ath11k/hw.h               |   1 +
>  drivers/net/wireless/ath/ath11k/pci.c              |  12 +-
>  .../net/wireless/mediatek/mt76/mt76_connac_mac.c   |   3 -
>  .../net/wireless/mediatek/mt76/mt76_connac_mcu.h   |   2 +-
>  .../net/wireless/mediatek/mt76/mt7921/debugfs.c    |  31 ++-
>  drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |  28 --
>  drivers/net/wireless/mediatek/mt76/mt7921/main.c   |  33 +--
>  drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |  47 ++--
>  drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h |  11 +-
>  drivers/pci/hotplug/pciehp.h                       |   2 +
>  drivers/pci/hotplug/pciehp_core.c                  |   2 +
>  drivers/pci/hotplug/pciehp_hpc.c                   |  26 ++
>  drivers/pci/pcie/portdrv.h                         |   3 +
>  drivers/pci/pcie/portdrv_core.c                    |  20 +-
>  drivers/pci/pcie/portdrv_pci.c                     |   3 +
>  drivers/pinctrl/sunxi/pinctrl-sun8i-a83t.c         |  10 +-
>  drivers/pinctrl/sunxi/pinctrl-sunxi.c              |   2 +
>  drivers/platform/x86/wmi.c                         |  39 +--
>  drivers/scsi/qla2xxx/qla_def.h                     |   5 +-
>  drivers/scsi/qla2xxx/qla_edif.c                    |  39 +--
>  drivers/scsi/qla2xxx/qla_edif.h                    |   1 -
>  drivers/scsi/qla2xxx/qla_init.c                    |   2 +
>  drivers/scsi/qla2xxx/qla_nvme.c                    |  27 +-
>  drivers/scsi/qla2xxx/qla_os.c                      | 102 ++++---
>  drivers/soc/atmel/soc.c                            |  12 +-
>  drivers/tty/n_gsm.c                                | 263 ++++++++++++++---
>  drivers/vdpa/mlx5/net/mlx5_vnet.c                  |   7 +-
>  drivers/video/fbdev/core/fbcon.c                   |  33 +++
>  drivers/video/fbdev/core/fbmem.c                   |  16 +-
>  fs/btrfs/block-group.c                             | 152 ++++++----
>  fs/btrfs/block-group.h                             |   2 +
>  fs/btrfs/ctree.c                                   |  17 +-
>  fs/btrfs/ctree.h                                   |   8 +-
>  fs/btrfs/delayed-ref.h                             |   5 +-
>  fs/btrfs/dev-replace.c                             |  16 +-
>  fs/btrfs/disk-io.c                                 |   1 +
>  fs/btrfs/extent-tree.c                             |  28 +-
>  fs/btrfs/extent_io.c                               |   8 +-
>  fs/btrfs/file.c                                    |  13 +-
>  fs/btrfs/free-space-tree.c                         |   4 +-
>  fs/btrfs/inode.c                                   |   3 +-
>  fs/btrfs/ioctl.c                                   |  96 ++++---
>  fs/btrfs/qgroup.c                                  |   3 +-
>  fs/btrfs/relocation.c                              |  25 +-
>  fs/btrfs/scrub.c                                   |   6 +-
>  fs/btrfs/tree-log.c                                |   2 +-
>  fs/btrfs/volumes.c                                 | 310 +++++++++++++--------
>  fs/btrfs/volumes.h                                 |  28 +-
>  fs/btrfs/zoned.c                                   |   2 +-
>  fs/btrfs/zoned.h                                   |  17 ++
>  fs/gfs2/file.c                                     |   1 +
>  fs/io_uring.c                                      |  10 +-
>  fs/nfsd/nfs3proc.c                                 |   6 -
>  fs/nfsd/vfs.c                                      |  64 +++--
>  fs/nfsd/vfs.h                                      |   4 +-
>  fs/seq_file.c                                      |  32 +++
>  fs/xfs/xfs_inode.c                                 |   1 -
>  include/linux/blk_types.h                          |   3 +-
>  include/linux/bpf.h                                |   6 +
>  include/linux/compiler-gcc.h                       |   8 +
>  include/linux/compiler_attributes.h                |  10 +
>  include/linux/compiler_types.h                     |  12 +
>  include/linux/fbcon.h                              |   4 +
>  include/linux/hugetlb.h                            |   6 +
>  include/linux/list.h                               |  10 +
>  include/linux/memregion.h                          |   2 +-
>  include/linux/mm.h                                 |   8 +
>  include/linux/pm_runtime.h                         |   5 +-
>  include/linux/qed/qed_eth_if.h                     |  21 +-
>  include/linux/rtsx_usb.h                           |   2 -
>  include/linux/seq_file.h                           |   4 +
>  include/linux/stddef.h                             |  61 ++++
>  include/linux/vmalloc.h                            |   5 +
>  include/net/netfilter/nf_tables.h                  |  10 +-
>  include/net/netfilter/nf_tables_ipv4.h             |   7 +-
>  include/net/netfilter/nf_tables_ipv6.h             |   6 +-
>  include/uapi/linux/netfilter/nf_tables.h           |   2 +
>  include/uapi/linux/omap3isp.h                      |  21 +-
>  include/uapi/linux/stddef.h                        |  41 +++
>  include/video/of_display_timing.h                  |   2 +
>  kernel/bpf/core.c                                  |   7 +
>  kernel/bpf/verifier.c                              | 150 ++++------
>  kernel/module.c                                    |  79 ++++--
>  lib/idr.c                                          |   3 +-
>  mm/filemap.c                                       |  12 +-
>  mm/hugetlb.c                                       |  10 +
>  mm/hwpoison-inject.c                               |   3 +-
>  mm/madvise.c                                       |   2 +
>  mm/memory-failure.c                                | 205 ++++++++------
>  mm/slub.c                                          |   2 +
>  mm/util.c                                          |  50 ++++
>  net/batman-adv/bridge_loop_avoidance.c             |   2 +-
>  net/bluetooth/hci_event.c                          |  12 +
>  net/can/bcm.c                                      |  18 +-
>  net/netfilter/nf_tables_api.c                      |   9 +-
>  net/netfilter/nf_tables_core.c                     |   2 +-
>  net/netfilter/nf_tables_trace.c                    |   4 +-
>  net/netfilter/nft_exthdr.c                         |   2 +-
>  net/netfilter/nft_meta.c                           |   2 +-
>  net/netfilter/nft_payload.c                        |  63 ++++-
>  net/netfilter/nft_set_pipapo.c                     |  48 +++-
>  net/rose/rose_route.c                              |   4 +-
>  net/rxrpc/ar-internal.h                            |   2 +-
>  net/rxrpc/call_accept.c                            |   6 +-
>  net/rxrpc/call_object.c                            |  18 +-
>  net/rxrpc/net_ns.c                                 |   2 +-
>  net/rxrpc/proc.c                                   |  10 +-
>  net/xdp/xsk_buff_pool.c                            |   1 +
>  scripts/checkpatch.pl                              |   3 +-
>  scripts/kernel-doc                                 |   9 +
>  sound/pci/cs46xx/cs46xx.c                          |  22 +-
>  sound/pci/hda/patch_realtek.c                      |   1 +
>  sound/soc/codecs/rt5682-i2c.c                      |  36 ++-
>  sound/soc/codecs/rt5682.c                          | 125 ++++-----
>  sound/soc/codecs/rt5682.h                          |   4 +-
>  sound/soc/codecs/rt700.c                           |  16 +-
>  sound/soc/codecs/rt711-sdca.c                      |  27 +-
>  sound/soc/codecs/rt711.c                           |  25 +-
>  sound/usb/mixer_maps.c                             |  16 ++
>  sound/usb/quirks.c                                 |   4 +
>  .../testing/selftests/bpf/prog_tests/timer_crash.c |  32 ---
>  tools/testing/selftests/bpf/progs/timer_crash.c    |  54 ----
>  tools/testing/selftests/net/forwarding/lib.sh      |   6 +-
>  tools/testing/selftests/net/udpgro.sh              |   2 +-
>  tools/testing/selftests/net/udpgro_bench.sh        |   2 +-
>  tools/testing/selftests/net/udpgro_fwd.sh          |   2 +-
>  tools/testing/selftests/net/veth.sh                |   6 +-
>  virt/kvm/kvm_main.c                                |  14 +-
>  268 files changed, 3823 insertions(+), 2087 deletions(-)
> 
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0)

On powerpc build (ps3_defconfig, GCC 12.1.0), I found errors on gettimeofday
vdso:

  VDSOSYM include/generated/vdso32-offsets.h
  LDS     arch/powerpc/kernel/vdso64/vdso64.lds
  AS      arch/powerpc/kernel/vdso64/sigtramp.o
  AS      arch/powerpc/kernel/vdso64/gettimeofday.o
  AS      arch/powerpc/kernel/vdso64/datapage.o
arch/powerpc/kernel/vdso64/gettimeofday.S: Assembler messages:
arch/powerpc/kernel/vdso64/gettimeofday.S:25: Error: unrecognized opcode: `cvdso_call'
arch/powerpc/kernel/vdso64/gettimeofday.S:36: Error: unrecognized opcode: `cvdso_call'
arch/powerpc/kernel/vdso64/gettimeofday.S:47: Error: unrecognized opcode: `cvdso_call'
arch/powerpc/kernel/vdso64/gettimeofday.S:57: Error: unrecognized opcode: `cvdso_call_time'
make[1]: *** [scripts/Makefile.build:390: arch/powerpc/kernel/vdso64/gettimeofday.o] Error 1

Thanks.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>
Reported-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
