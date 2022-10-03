Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF735F3A04
	for <lists+stable@lfdr.de>; Tue,  4 Oct 2022 01:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbiJCXt0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 19:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiJCXt0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 19:49:26 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E1E1476D5
        for <stable@vger.kernel.org>; Mon,  3 Oct 2022 16:49:24 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id b23so9377364iof.2
        for <stable@vger.kernel.org>; Mon, 03 Oct 2022 16:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=J/BP6sWdX6BvvxTyPkm25+mUcKPRh2bmjUpOAtcUnpE=;
        b=Uusuhy7VqS0BCGuQw4FCh78dyf5tJ+MSyNfBb4Pg4zvrCkXDKiST9hReL/jbXXuT+K
         oOAusmO9rnUFHCbGVWYFd6yC5moTGwwlIGDy6vUIPyCHrOsTb5Mwhmnht0+Z324UOGzh
         MjLct9wp6dihze4WIxzKnZyMiMWLQ8galXJvk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=J/BP6sWdX6BvvxTyPkm25+mUcKPRh2bmjUpOAtcUnpE=;
        b=GhkT1bdri/U98P/1z5TVzLRvGH9vT3bv1NDYbnlvZlXSRiOj+PRsih4T3euuWgHdsZ
         kgF/k6Z5mNi+bGo9AWEuK1m+t4gqUGA6qYM8IcXbTBO6ZySXbZ+32Yysyk53oJkrq+Ol
         Oxv0XImaJcclsXR8MLK93uHIpBVqPUfkZuslaoJYoTIcCbzHnq8nC4XkmvAxV4jNxdUA
         XyCfHrfH8vZrMRWBYZt2T3W7VeOWlkWaE7Ok5qkpui4mK7PuHaaLb6LKn/GeiCtZVFnm
         ZnKyuk3OHLHGIkTABe6SEDX3RwfY6YxWk9SjwauS9fYQHTX0NB5uFvMSWKol3WFyxTg3
         beBA==
X-Gm-Message-State: ACrzQf3YTRxuLRiT1hGxLMekqmErqckAcrLZvpBmWi9mJ1E0+HriI30i
        g5DaFfhSJ0c1iGOwKDKngGRezw==
X-Google-Smtp-Source: AMsMyM7czVZVJb1uyC69tNllVw8kOtfYg2XS6KbuohQtfZF6gU60DyAo671+QPNHPXhi+XuXHTxr1w==
X-Received: by 2002:a05:6602:168b:b0:6a2:c6d1:d4e4 with SMTP id s11-20020a056602168b00b006a2c6d1d4e4mr10166675iow.190.1664840963930;
        Mon, 03 Oct 2022 16:49:23 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id t26-20020a02ab9a000000b00362bea5e4c6sm2425542jan.169.2022.10.03.16.49.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Oct 2022 16:49:23 -0700 (PDT)
Message-ID: <7af02bc3-c0f2-7326-e467-02549e88c9ce@linuxfoundation.org>
Date:   Mon, 3 Oct 2022 17:49:21 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.4 00/30] 5.4.216-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20221003070716.269502440@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221003070716.269502440@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/3/22 01:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.216 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Oct 2022 07:07:06 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.216-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
>      Linux 5.4.216-rc1
> 
> Florian Fainelli <f.fainelli@gmail.com>
>      clk: iproc: Do not rely on node name for correct PLL setup
> 
> Han Xu <han.xu@nxp.com>
>      clk: imx: imx6sx: remove the SET_RATE_PARENT flag for QSPI clocks
> 
> Wang Yufen <wangyufen@huawei.com>
>      selftests: Fix the if conditions of in test_extra_filter()
> 
> Michael Kelley <mikelley@microsoft.com>
>      nvme: Fix IOC_PR_CLEAR and IOC_PR_RELEASE ioctls for nvme devices
> 
> Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
>      nvme: add new line after variable declatation
> 
> Peilin Ye <peilin.ye@bytedance.com>
>      usbnet: Fix memory leak in usbnet_disconnect()
> 
> Yang Yingliang <yangyingliang@huawei.com>
>      Input: melfas_mip4 - fix return value check in mip4_probe()
> 
> Brian Norris <briannorris@chromium.org>
>      Revert "drm: bridge: analogix/dp: add panel prepare/unprepare in suspend/resume time"
> 
> Samuel Holland <samuel@sholland.org>
>      soc: sunxi: sram: Fix debugfs info for A64 SRAM C
> 
> Samuel Holland <samuel@sholland.org>
>      soc: sunxi: sram: Fix probe function ordering issues
> 
> Cai Huoqing <caihuoqing@baidu.com>
>      soc: sunxi_sram: Make use of the helper function devm_platform_ioremap_resource()
> 
> Samuel Holland <samuel@sholland.org>
>      soc: sunxi: sram: Prevent the driver from being unbound
> 
> Samuel Holland <samuel@sholland.org>
>      soc: sunxi: sram: Actually claim SRAM regions
> 
> YuTong Chang <mtwget@gmail.com>
>      ARM: dts: am33xx: Fix MMCHS0 dma properties
> 
> Faiz Abbas <faiz_abbas@ti.com>
>      ARM: dts: Move am33xx and am43xx mmc nodes to sdhci-omap driver
> 
> Hangyu Hua <hbh25y@gmail.com>
>      media: dvb_vb2: fix possible out of bound access
> 
> Minchan Kim <minchan@kernel.org>
>      mm: fix madivse_pageout mishandling on non-LRU page
> 
> Alistair Popple <apopple@nvidia.com>
>      mm/migrate_device.c: flush TLB while holding PTL
> 
> Maurizio Lombardi <mlombard@redhat.com>
>      mm: prevent page_frag_alloc() from corrupting the memory
> 
> Mel Gorman <mgorman@techsingularity.net>
>      mm/page_alloc: fix race condition between build_all_zonelists and page allocation
> 
> Sergei Antonov <saproj@gmail.com>
>      mmc: moxart: fix 4-bit bus width and remove 8-bit bus width
> 
> Niklas Cassel <niklas.cassel@wdc.com>
>      libata: add ATA_HORKAGE_NOLPM for Pioneer BDR-207M and BDR-205
> 
> Sasha Levin <sashal@kernel.org>
>      Revert "net: mvpp2: debugfs: fix memory leak when using debugfs_lookup()"
> 
> ChenXiaoSong <chenxiaosong2@huawei.com>
>      ntfs: fix BUG_ON in ntfs_lookup_inode_by_name()
> 
> Linus Walleij <linus.walleij@linaro.org>
>      ARM: dts: integrator: Tag PCI host with device_type
> 
> Aidan MacDonald <aidanmacdonald.0x0@gmail.com>
>      clk: ingenic-tcu: Properly enable registers before accessing timers
> 
> Frank Wunderlich <frank-w@public-files.de>
>      net: usb: qmi_wwan: Add new usb-id for Dell branded EM7455
> 
> Hongling Zeng <zenghongling@kylinos.cn>
>      uas: ignore UAS for Thinkplus chips
> 
> Hongling Zeng <zenghongling@kylinos.cn>
>      usb-storage: Add Hiksemi USB3-FW to IGNORE_UAS
> 
> Hongling Zeng <zenghongling@kylinos.cn>
>      uas: add no-uas quirk for Hiksemi usb_disk
> 
> 
> -------------
> 
> Diffstat:
> 
>   Makefile                                           |  4 +-
>   arch/arm/boot/dts/am335x-baltos.dtsi               |  2 +-
>   arch/arm/boot/dts/am335x-boneblack-common.dtsi     |  1 +
>   arch/arm/boot/dts/am335x-boneblack-wireless.dts    |  1 -
>   arch/arm/boot/dts/am335x-boneblue.dts              |  1 -
>   arch/arm/boot/dts/am335x-bonegreen-wireless.dts    |  1 -
>   arch/arm/boot/dts/am335x-evm.dts                   |  3 +-
>   arch/arm/boot/dts/am335x-evmsk.dts                 |  2 +-
>   arch/arm/boot/dts/am335x-lxm.dts                   |  2 +-
>   arch/arm/boot/dts/am335x-moxa-uc-2100-common.dtsi  |  2 +-
>   arch/arm/boot/dts/am335x-moxa-uc-8100-me-t.dts     |  2 +-
>   arch/arm/boot/dts/am335x-pepper.dts                |  4 +-
>   arch/arm/boot/dts/am335x-phycore-som.dtsi          |  2 +-
>   arch/arm/boot/dts/am33xx-l4.dtsi                   |  9 +--
>   arch/arm/boot/dts/am33xx.dtsi                      |  3 +-
>   arch/arm/boot/dts/am4372.dtsi                      |  3 +-
>   arch/arm/boot/dts/am437x-cm-t43.dts                |  2 +-
>   arch/arm/boot/dts/am437x-gp-evm.dts                |  4 +-
>   arch/arm/boot/dts/am437x-l4.dtsi                   |  5 +-
>   arch/arm/boot/dts/am437x-sk-evm.dts                |  2 +-
>   arch/arm/boot/dts/integratorap.dts                 |  1 +
>   drivers/ata/libata-core.c                          |  4 ++
>   drivers/clk/bcm/clk-iproc-pll.c                    | 12 ++--
>   drivers/clk/imx/clk-imx6sx.c                       |  4 +-
>   drivers/clk/ingenic/tcu.c                          | 15 ++---
>   drivers/gpu/drm/bridge/analogix/analogix_dp_core.c | 13 -----
>   drivers/input/touchscreen/melfas_mip4.c            |  2 +-
>   drivers/media/dvb-core/dvb_vb2.c                   | 11 ++++
>   drivers/mmc/host/moxart-mmc.c                      | 17 +-----
>   drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c |  4 +-
>   drivers/net/usb/qmi_wwan.c                         |  1 +
>   drivers/net/usb/usbnet.c                           |  7 ++-
>   drivers/nvme/host/core.c                           |  9 ++-
>   drivers/soc/sunxi/sunxi_sram.c                     | 27 ++++-----
>   drivers/usb/storage/unusual_uas.h                  | 21 +++++++
>   fs/ntfs/super.c                                    |  3 +-
>   mm/madvise.c                                       |  7 ++-
>   mm/migrate.c                                       |  5 +-
>   mm/page_alloc.c                                    | 65 ++++++++++++++++++----
>   tools/testing/selftests/net/reuseport_bpf.c        |  2 +-
>   40 files changed, 173 insertions(+), 112 deletions(-)
> 
> 
> 

Compiled and failed to boot. Reverting the following patch fixes
the problem.

commit 4b453403a945b13ea8aa9e8628bec1eaffeb7257 (HEAD -> linux-5.4.y)
Author: Shuah Khan <skhan@linuxfoundation.org>
Date:   Mon Oct 3 15:45:57 2022 -0600

     Revert "drm/amdgpu: use dirty framebuffer helper"

thanks,
-- Shuah
     
     This reverts commit c89849ecfd2e10838b31c519c2a6607266b58f02.

