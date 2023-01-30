Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 161C6681C5A
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 22:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbjA3VJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 16:09:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbjA3VJK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 16:09:10 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65B1345896
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 13:09:09 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id l128so1001053iof.2
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 13:09:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I5FFyP1pwgAcJTSYXMdmc2wmxlAHasQAPTGxr28W5CA=;
        b=O8oFQDSRasxJf9c5fc06EAjHPlFi1g/U5C954FGeGPSLDA86s8gS0RLxtkYxkLptrS
         T1/mM7geMzxj0yXPFir6O+AsFxzDcjMXL2ZpnIhpQz4HQC7fLaTt48ah90WVOEJ30Aui
         1DxXS2Xd6VU5xfM8MFokgDNcsYMrdauVEy+wE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I5FFyP1pwgAcJTSYXMdmc2wmxlAHasQAPTGxr28W5CA=;
        b=r7fZKpKXnxOXPEtSbtS5k093uQ6fxg+6+MrhbhgLbMcd/jVQVprOpj12jaZwV1iL5E
         6r0jjRSnHq7OuZigInlVzsuHfjVpNhW6h3hlx5z7AEFuRrnqKcHVXTbCKlZmdHREQUpW
         LO4HSp47MJw7grt8h4KAATPx8cacAV1echPP9OaWx/ImhZazUmvHpEzyYnXG9BYfU9+/
         msD64L+dtazVHXSQD76RP33GGBXgHJphK/xsScDfituBmfkXP9XDu1KiXyd5aDAmw29i
         HX2kQFRxji9+2O4nGif2Rj1WGu128icHjjbLGFRr7/xTRGnSPuxJbYw+vy39LYgMhFdu
         6+mA==
X-Gm-Message-State: AO0yUKWux7RAhYtMP1snp5sqz//6XTu8/pTVsElNUOdpVaxLUlCg8L2S
        QlpvASdAuSXvFz87ssGybVs2fw==
X-Google-Smtp-Source: AK7set+FmzYByEq+Ec1/MOcNI87kKOBFwxgvGlNVWFYtOs1Z2FaVqx/pN7V1kz8PsZUMkqHKeQkBuQ==
X-Received: by 2002:a6b:bb05:0:b0:716:8f6a:f480 with SMTP id l5-20020a6bbb05000000b007168f6af480mr1490463iof.0.1675112948672;
        Mon, 30 Jan 2023 13:09:08 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id t11-20020a02ccab000000b0038a760ab9a4sm4982930jap.161.2023.01.30.13.09.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jan 2023 13:09:07 -0800 (PST)
Message-ID: <84908e0d-54d0-30aa-54e7-acde8c661f24@linuxfoundation.org>
Date:   Mon, 30 Jan 2023 14:09:06 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 000/143] 5.10.166-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20230130134306.862721518@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/30/23 06:50, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.166 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Feb 2023 13:42:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.166-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
