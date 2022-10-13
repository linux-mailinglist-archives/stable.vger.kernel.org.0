Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD0735FE2BD
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 21:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiJMTfs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 15:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiJMTfr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 15:35:47 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 421AE11A94B;
        Thu, 13 Oct 2022 12:35:45 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id s30so4051117eds.1;
        Thu, 13 Oct 2022 12:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aO2wfG6mESBWLGmiEHQ/ZdlLgCSrGemWpKlaxBdIPR0=;
        b=o5lciPHuBpfNXx8hNY1aLi0CZ+Abid9rsHTB9XFMYj89oqMFRO8p6XzrvS4TfNF12o
         6UKFmCDbZltjXmxRtE49G+2TF8xVk0q9sKQfuzoITV9JnvL+V9MJ53PSJxDnRpR9uweR
         BU+ibr/x67bZ9uUSH+B01Uf1J43sRE3VaViE4/2NPeqKTxz9HwHqvxu7Gpw5GadsLi5i
         s+ccQXCF1CC5oifE+sVvEKgydkiKTHkcwsGfn6zLJSgvZsHPg1Ahz/BhPs07qQKIKBgp
         M7qE/32g5jVvTOe7U9AQtEf4hmL0p6LIdNz8X+LesRVm6dpYBYOCx7Hypv8xWRcqGD/a
         B2UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aO2wfG6mESBWLGmiEHQ/ZdlLgCSrGemWpKlaxBdIPR0=;
        b=RsmEjNhTWMWUcHAuvL0rZ2KClkR/VT+7/fpcOyAR/oYDIjpSZczCJ07tQt9G/bpEO8
         xf6OifhfNvH5fnCluAUkR6f2hWsks18ctFvkkbq8+2UImZ417WUl0zz2BspZnNuTso02
         jwOPWyEN7oay3OQuOUZBiYJtg1lJKh2wJJYm2Syn0Oowy0wblzsVrbesDz/TNHZhgWUK
         nXpUwPLNMu1JwHPg7U7multVrMYQu+4n/rzPad2YArU+SYZTL0n9f22p7fembA/QFvzR
         kS2gAY0yM11tFzoCpnEd5i3tlfVxL4x8QoGTTeFMd5jMPjn2idWhFEG9ZNhj/Ry4uaBD
         PjwA==
X-Gm-Message-State: ACrzQf31dZ2Luvbe6SSMa/TzMglG9ArRbv5AU4GqCmOtWGNvZ9KmYV7F
        7rfuvCIcbZNJRfC1Zjm4WVs=
X-Google-Smtp-Source: AMsMyM65qyeNcU4PvNmavUCDHZm9SKmVc8HvmmyP2Gv5Ldhs3DrGZeVkMG/dIS1GKx7DX99zL079Pw==
X-Received: by 2002:a05:6402:50cf:b0:45c:dfce:66ae with SMTP id h15-20020a05640250cf00b0045cdfce66aemr1118400edb.370.1665689743723;
        Thu, 13 Oct 2022 12:35:43 -0700 (PDT)
Received: from ?IPV6:2a02:a466:68ed:1:2509:9d4b:f4db:684d? (2a02-a466-68ed-1-2509-9d4b-f4db-684d.fixed6.kpn.net. [2a02:a466:68ed:1:2509:9d4b:f4db:684d])
        by smtp.gmail.com with ESMTPSA id md9-20020a170906ae8900b0078defb88b0dsm316281ejb.73.2022.10.13.12.35.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Oct 2022 12:35:43 -0700 (PDT)
Message-ID: <bec17559-286c-b006-476f-3c26ae38e70d@gmail.com>
Date:   Thu, 13 Oct 2022 21:35:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH v2 2/2] Revert "usb: dwc3: Don't switch OTG -> peripheral
 if extcon is present"
Content-Language: en-US
To:     Andrey Smirnov <andrew.smirnov@gmail.com>
Cc:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20220927155332.10762-1-andriy.shevchenko@linux.intel.com>
 <20221003215734.7l3cnb2zy57nrxkk@synopsys.com>
 <YzvusOI89ju9e5+0@smile.fi.intel.com>
 <a7724993-6c04-92c5-3a26-3aef6d29c9e3@gmail.com>
 <20221005021212.qwnbmq6p7t26c3a4@synopsys.com>
 <2886b82d-a1f6-d288-e8d1-edae54046b4f@gmail.com>
 <20221006021204.hz7iteao65dgsev6@synopsys.com>
 <d52cc102-6a4f-78e9-6176-b33e2813fd1d@gmail.com>
 <20221007021122.nnwmqc6sq43e5xbn@synopsys.com>
 <ade865f1-8ed5-a8e3-e441-cb7688c6d001@gmail.com>
 <CAHQ1cqGSmNSg73DzURrcP=a-cCd6KdVUtUmnonhP54vWVDmEhw@mail.gmail.com>
 <4e73bbb9-eae1-6a90-d716-c721a1eeced3@gmail.com>
 <7e9519c6-f65f-5f83-1d17-a3510103469f@gmail.com>
 <CAHQ1cqE5=j9i8uYvBwdNUK8TrX3Wxy7iUML6K+gBQx-KRtkS7w@mail.gmail.com>
 <644adb7b-0438-e37c-222c-71bf261369b0@gmail.com>
 <CAHQ1cqGSXoUTopwvrQtLww5M0Tf=6F505ziLn+wGHhW_8-JhFQ@mail.gmail.com>
 <113fe314-0f5c-f53f-db78-c93bd4515260@gmail.com>
 <CAHQ1cqF_FvG0G2CAQooOVR3E442ApNFf8EKK8PpxcOrUoL5jDA@mail.gmail.com>
From:   Ferry Toth <fntoth@gmail.com>
In-Reply-To: <CAHQ1cqF_FvG0G2CAQooOVR3E442ApNFf8EKK8PpxcOrUoL5jDA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

<SNIP>
> My end goal here is to find a way to test vanilla v6.0 with the two
> patches reverted on your end. I thought that during my testing I saw
> tusb1210 print those timeout messages during its probe and that
> disabling the driver worked to break the loop, but I went back to
> double check and it doesn't work so scratch that idea. Configuring
> extcon as a built-in breaks host functionality with or without patches
> on my end, so I'm not sure it could be a path.
>
> I won't have time to try things with
> 0043b-TODO-driver-core-Break-infinite-loop-when-deferred-p.patch until
> the weekend, meanwhile can you give this diff a try with vanilla (no
> reverts) v6.0:
>
> modified   drivers/phy/ti/phy-tusb1210.c
> @@ -127,6 +127,7 @@ static int tusb1210_set_mode(struct phy *phy, enum
> phy_mode mode, int submode)
>    u8 reg;
>
>    ret = tusb1210_ulpi_read(tusb, ULPI_OTG_CTRL, &reg);
> + WARN_ON(ret < 0);
>    if (ret < 0)
>    return ret;
>
> @@ -152,7 +153,10 @@ static int tusb1210_set_mode(struct phy *phy,
> enum phy_mode mode, int submode)
>    }
>
>    tusb->otg_ctrl = reg;
> - return tusb1210_ulpi_write(tusb, ULPI_OTG_CTRL, reg);
> + ret = tusb1210_ulpi_write(tusb, ULPI_OTG_CTRL, reg);
> + WARN_ON(ret < 0);
> + return ret;
> +
>   }
>
>   #ifdef CONFIG_POWER_SUPPLY
>
> ? I'm curious to see if there's masked errors on your end since dwc3
> driver doesn't check for those.
root@yuna:~# dmesg | grep -i -E 'warn|assert|error|tusb|dwc3'
8250_mid: probe of 0000:00:04.0 failed with error -16
platform regulatory.0: Direct firmware load for regulatory.db failed 
with error -2
brcmfmac mmc2:0001:1: Direct firmware load for 
brcm/brcmfmac43340-sdio.Intel Corporation-Merrifield.bin failed with 
error -2
sof-audio-pci-intel-tng 0000:00:0d.0: error: I/O region is too small.
sof-audio-pci-intel-tng 0000:00:0d.0: error: failed to probe DSP -19


>> This is done through configfs only when the switch is set to device mode.
> Sure, but can it be disabled? We are looking for unknown variables, so
> excluding this would be a reasonable thing to do.
It's not enabled until I flip the switch to device mode.
