Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88A5D64AA41
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 23:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233771AbiLLWae (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 17:30:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233437AbiLLWab (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 17:30:31 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 495AD13F9D;
        Mon, 12 Dec 2022 14:30:30 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id fu10so10369054qtb.0;
        Mon, 12 Dec 2022 14:30:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Wn7Ol+Nii+KRvjkJs021zJvmcVilYQbtbdjjj+CM3ls=;
        b=HW4KILHHyHX00+spPmp5NLS15WYIJza6zKV2kWfOIGTwOvPNWxchBNEMHUEgLI+Lvy
         lS0F4r8OfIx797KwBP3VGj5pnguA/eVfDcPNGNJPvYGOsow8P2s4EAkRhXA1Pj1BDJ6b
         JC9IveJMHA7RiES+uQ87sAG+9m/yW0seDRpu7x+TKhJtteFpJR6AWNStbKuMQa0Jw8QW
         NhTslBdOWm58I6XAso9ceCcJGuL5EujexdVMtD6aeMfSZRDt+OTSoeb4pdAK6BmSDEM6
         hk/s+/9Dem8bd1FssB3PwYcrQ/QBVjrzlaOAk55FGIdGlBfGZ3jnRQHwmvTBDrI6GVYN
         rGSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wn7Ol+Nii+KRvjkJs021zJvmcVilYQbtbdjjj+CM3ls=;
        b=dnMSV6aOjI+j0XlqmAKwrfZzORJVSOpH5/9blk8l4OXgZYuD5iqmDUUWTHIkfiANyS
         3NJr5CTakSLx/ygeqVT6mMlLX170RtTe8bfBzRqDX8kG9EkJro7TLsy5AULY4svWHUiM
         gV5dG1OeWrMIAji0ftxAtJm2nzOUdI/7E3zTvIXdXCdwumi7vjyYOO8crXFx+FXYIgdZ
         BiyhZr4OlkVTPm/RHBM6rwA49n88xd8r/CIGc8HokYSTzJSUeYWIMu5n3in8o6R6xbfY
         Zycu5svlN4rLT+foop/UWABC5DCaPtM4ES/d5iDs+LzYtQbpmKNW5uSRiE0y1oNOfJA9
         MWqw==
X-Gm-Message-State: ANoB5pkSvOGf57amoLCSkklKuCps9RfuaXL4sroEx3Rn4AV6QGNINTME
        xQyKsIYdrTrY+rZCe2rkHIg=
X-Google-Smtp-Source: AA0mqf4Q04DmUA95Ihc5nFTAKQA0gcUbMcOVE7u04B2KcMfMSL8jzhiJocguGJ/lwYUEuowW29N4yQ==
X-Received: by 2002:ac8:68d:0:b0:3a5:f445:acf with SMTP id f13-20020ac8068d000000b003a5f4450acfmr27958303qth.67.1670884229338;
        Mon, 12 Dec 2022 14:30:29 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id fu20-20020a05622a5d9400b003a69225c2cdsm6444538qtb.56.2022.12.12.14.30.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 14:30:28 -0800 (PST)
Message-ID: <c6f01794-ee64-eaf7-1beb-74378d981ebf@gmail.com>
Date:   Mon, 12 Dec 2022 14:30:20 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.4 00/67] 5.4.227-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221212130917.599345531@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221212130917.599345531@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/12/22 05:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.227 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.227-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

