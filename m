Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A59C2473D4E
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 07:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbhLNGnZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 01:43:25 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:45684
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231201AbhLNGnW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 01:43:22 -0500
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com [209.85.167.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 563FB3F208
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 06:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1639464201;
        bh=xOTB2ScaHtWm2f/iOOdnjpT35u35gjMiJFm7sy9sIwE=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=J9DhtuJ8425pFXSUtG34Rtupm6BeYfq7Q3Zy81dXKRyZJD2gjLeWvt3NUrFbEky2t
         8RIBGEOllP0xgjk5xVVQGXjc9ZBg3g50OR5F4MCH6BWBiMk/VMX1otA+rqgipmPogk
         PLd6vAj2DgnKB1RoMfxKOJVu9w5cedgLAgV4gW2M6+a19SHiW/kxyUd1lceviXpD1k
         7McsO66/XdISr9dl0Wo8HAKSAFV6DmbdhXePf8ZVViPUPkM33VfmbzfefPWpvMhNSL
         asWyPTgSJsc89+frqui2Y3/FqozRTjSfTBZyUMuvFF+QoTqaMtb1UffswakM54NweQ
         /z4y6k8hyXSvg==
Received: by mail-lf1-f71.google.com with SMTP id w21-20020a197b15000000b00422b0797fa3so1336552lfc.4
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 22:43:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xOTB2ScaHtWm2f/iOOdnjpT35u35gjMiJFm7sy9sIwE=;
        b=JjR+L5dSIDxhelRKE+By54s75tcTkYEQJRy2mErc9MMZXcDtNtkcq1m05VDgewdhk2
         wUEVRlplOSA0m6L7AvOCMoSSqWha3W8KRlDmPB/nQAsEPcaCTtoStokLnwHg6da4mMdC
         k+AGHRXtrlG4rlC/eMTjhnleA3Gt8Z4tpFMXe4eowX8MqkCUk8qujVjyRf+sHaEhrkSd
         nk6ec18kQ/FnVD7N93rh+nTRBT+/8FZMoRuzdAUBglHWQ8xUKGnMsXsniXGxYXzz9ovm
         at6PLMUDswymSPWMjG6F47eX709xVCI1XP1gAQQZeuc+ee2oBswCgT91Z/pPqSa0kPnt
         DCng==
X-Gm-Message-State: AOAM532XNbWeVov2v7FDRWAQ8tScmli4jFYcLKkie8Rn0Z5aZe0Jht6e
        KmZypcmbomMI3QmvTae6hwvXiMA69Ujksbs+8Wjckm5tn5v0O6wg/zxwltar1uesQjeVTZpdZeB
        UTPGh+iulgmcojTsBAgjBsKzw4ZwfLbeT/g==
X-Received: by 2002:a19:4f49:: with SMTP id a9mr3139479lfk.37.1639464200291;
        Mon, 13 Dec 2021 22:43:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzeBwrExC4ewGvW0Yile/MhYCWIf8ovwjdrA0vvJewKVayS8VRGF+KmxD47iQBOtqm7nqGssA==
X-Received: by 2002:a19:4f49:: with SMTP id a9mr3139462lfk.37.1639464200094;
        Mon, 13 Dec 2021 22:43:20 -0800 (PST)
Received: from [192.168.3.67] (89-77-68-124.dynamic.chello.pl. [89.77.68.124])
        by smtp.gmail.com with ESMTPSA id v2sm1704897lfb.258.2021.12.13.22.43.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 22:43:19 -0800 (PST)
Message-ID: <68145d95-1b6a-153e-42ba-43d18b705a70@canonical.com>
Date:   Tue, 14 Dec 2021 07:43:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH 5.10 000/132] 5.10.85-rc1 review
Content-Language: en-US
To:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Cc:     shuah@kernel.org, f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
References: <20211213092939.074326017@linuxfoundation.org>
 <52a7fa5d-6fa0-a0df-2e88-bd4bf443a671@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <52a7fa5d-6fa0-a0df-2e88-bd4bf443a671@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 13/12/2021 19:17, Tadeusz Struk wrote:
> On 12/13/21 01:29, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.10.85 release.
>> There are 132 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed, 15 Dec 2021 09:29:16 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.85-rc1.gz
>> or in the git tree and branch at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
>> and the diffstat can be found below.
> 
> Hi,
> In this release cycle there were two similar nfc fixes:
> 
> fd79a0cbf0b2 nfc: fix segfault in nfc_genl_dump_devices_done
> 4cd8371a234d nfc: fix potential NULL pointer deref in nfc_genl_dump_ses_done
> 
> The list here only includes the second one. The first is still missing.
> The same applies to 5.15

With my review tag for this other fix I mentioned it needs Fixes and
Cc-stable, but these were not added by Jakub when applying. It won't be
picked up automatically by Greg.

Jakub,
What's weird, the cc-stable was also removed from my commit which is not
good. Few other people add Fixes tag without Cc-stable when they want to
annotate it should not go to stable. This one should go to stable, so it
should have cc-stable (which I put there).

Best regards,
Krzysztof
