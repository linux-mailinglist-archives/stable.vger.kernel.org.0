Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE0B4B5D87
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 23:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbiBNWST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 17:18:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiBNWSS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 17:18:18 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 128EB12F172;
        Mon, 14 Feb 2022 14:18:10 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id m22so12411416pfk.6;
        Mon, 14 Feb 2022 14:18:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=71v259sMnulVDUdnFL9PvW3q7zimpbg7uPWJfoOOLmg=;
        b=G5IqvXRvPZWwm596MQND/b5iZCjaUyRnv9LD2dOSnn0pk3xxjQ61HdvBBF8X1K23J7
         C2oXa7julzRaipdXpaw1I+H5D5lKsLGPuRejIsCFtMm8glelFZ2B8AoIN+hUsCBSoEuT
         ezCjQm1lH6PeAVfA8Uhzg1eJWlWtKfayrBXbHJAA73KsAVfV3rx49rxbSQqohxDcOw6n
         QAIqgZM5USvMHDxBWWQYA9BBYWiE7ItWZcHJM1l9kyOyo94G5J+0QVj2fVuFmJSpkB8d
         h15qNag6vvVgWa8iuseLC1RjsvBprFiX+fMWFF/NR9aI4DAxnx5GiZuqjs1Kp+qqMWeP
         WXvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=71v259sMnulVDUdnFL9PvW3q7zimpbg7uPWJfoOOLmg=;
        b=KobvkJ+clWnb9UQY+mf7ycSzXPbcTSf+jXmFcqYNwoCS/wtQOEtKnY9GpnESyzKHg1
         MUGiDPBeSTFfAzbtAKNDbjEQSdqjTP80GozGI2Z/uHzgP9iEmq7HHIjfzy22CljjqVAd
         l3ftFl1vTyhcsdaizeRYNe19SnWgao8/cRMVzXfqB+ciyK3tUXQbbEt1B8Q6zWayYxJS
         NEY9RjB7SXDJLvchQwafI6FV8u2vCBMTv6DGdvwAdogPHgeCR+Bhzno2tTbThX3gSkA2
         XER/9PgSWisXDiLZBy/JBAzPCu16/125+AX5YM1A7Ks4k5CiyGQWzme8WaSly7JZcdKN
         BgCg==
X-Gm-Message-State: AOAM533jG2w3majGtecmCERL4ihCSWuiA2uqsrpD9loqxw/jmouOABWQ
        Dn8w+u8R1IpTFnRBvU5WZ5c=
X-Google-Smtp-Source: ABdhPJyYFFep4lDe0JILfHNFijFDMbdT+o8UOjSl2L8kbRgZPnSww9ACOQVnd0m43jq2yq88c6U57w==
X-Received: by 2002:a05:6a00:1588:: with SMTP id u8mr882060pfk.4.1644877089499;
        Mon, 14 Feb 2022 14:18:09 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 75sm321711pga.12.2022.02.14.14.18.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Feb 2022 14:18:08 -0800 (PST)
Subject: Re: [PATCH 5.16 000/203] 5.16.10-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220214092510.221474733@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <36508c1c-1bc8-19c2-4448-0e11614ea26c@gmail.com>
Date:   Mon, 14 Feb 2022 14:18:07 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/14/22 1:24 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.10 release.
> There are 203 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
