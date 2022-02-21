Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 035554BECAD
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 22:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbiBUVix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 16:38:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231383AbiBUViw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 16:38:52 -0500
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 642EF220C8
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 13:38:28 -0800 (PST)
Received: by mail-oo1-xc2c.google.com with SMTP id u47-20020a4a9732000000b00316d0257de0so14861889ooi.7
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 13:38:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JnCW9r6odpcmMATjsWda/BGHx/21KoOsBb/9YjZG+lo=;
        b=gntegFzfwI/sCm7pT7lI3SNDkzR/BhtdrEYXw3SAhB/vBzXrkg9DcCr7Str7Daa2ZB
         cnBKxsTcTlxCA5fAwLdTbJunmwmwHertZM+qAUrsSt3ZJsENpJtPW8CmfOcBas0g9lyT
         5G3gNjpYmCIjxGInSrE7cYl6Tquzxyel4T7Yo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JnCW9r6odpcmMATjsWda/BGHx/21KoOsBb/9YjZG+lo=;
        b=rnEEkE547mk1PzmYxeLlWJCC+KvPnQ+BAwH4Xtdu4/9fMpcKlDGAjfardYS6JaxOw3
         ibNip9NgttTyp4cQn2yWu0zFjlHgs0QBEcAxPFTjUmdFgVaUUw2xJxfdoqPzcWgLq1zx
         lmLdgp59O/MyYL/irj4R6VpHCddli2AoiBPNq1wS3zoEF3LpxoHDhfsD2praMZkn5KhW
         vaFxLBDUYFLGBQxfT0np9Rd5ToWos5Fs04sxyWtviZqMtki2n53hiqOL7KAjHlO6Qh6e
         p5tD0UTJB3JTXtQqJ+TtYS7J0yiBg9K9rTawJrjBzZS6oglfkKIGyvkO5EjEFvvKTMBG
         T8FA==
X-Gm-Message-State: AOAM533ujc67gt7lNBk5q33+azBV4YMECt3zH4pGFeC6eIPxnUqsLQQd
        ZqUKW5dOLep3hknp3IgudpemXw==
X-Google-Smtp-Source: ABdhPJwMRok/QIepOC8zF52Pk/+FH1zByJAUS7KoQQ28EB23Xf1LDTIlYOLa/tSHkjJq1MC9fMrsrQ==
X-Received: by 2002:a05:6870:d612:b0:ce:c0c9:6e8 with SMTP id a18-20020a056870d61200b000cec0c906e8mr382034oaq.314.1645479507781;
        Mon, 21 Feb 2022 13:38:27 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id i14sm2010108oig.24.2022.02.21.13.38.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 13:38:27 -0800 (PST)
Subject: Re: [PATCH 4.19 00/58] 4.19.231-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220221084911.895146879@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <c34b1f50-c694-2288-0f41-5705f376ee16@linuxfoundation.org>
Date:   Mon, 21 Feb 2022 14:38:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220221084911.895146879@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/21/22 1:48 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.231 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.231-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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
