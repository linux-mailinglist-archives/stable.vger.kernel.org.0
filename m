Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8E0644BF5
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 19:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbiLFSl0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 13:41:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbiLFSlO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 13:41:14 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F553F06F;
        Tue,  6 Dec 2022 10:41:03 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id e7-20020a17090a77c700b00216928a3917so18843484pjs.4;
        Tue, 06 Dec 2022 10:41:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5gSr4H7WrM5p30udt7aFBkhEJpe85dvdV3IE4tFnVRo=;
        b=TGQT0+CX1iAFQkGnVQomi2v8D9g1ksynUotNR29hyIGO3kPFxOwpRrLIYnS9IuaWQP
         R/lQ60Ap2c9LcdxYX0GG7xVxS6FAnWBgG84pj9kavgjFdK14xF30kOzZjAY9ua1zySz+
         RnljnEKRisAfcjsyoyyo7jvGNVLpbN1W65dAuatU1Yc3uVrTRpwW3e9C97yzZwttlAd3
         4rAcFp6o1C6L2q1jyN1r1Es+Z4c745e4CXbD5nrQfRBqr++X+Z4X7T2tLQ4ueEwoGWhm
         WkHOrL2WtWPC1rSv+slE56VSB7Dt2sYG15dy4JUY7XcAk6sVcgVAVhR68JeNZxetpOeX
         JBgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5gSr4H7WrM5p30udt7aFBkhEJpe85dvdV3IE4tFnVRo=;
        b=79EKO0D8qC0HXZ591VxJZxLJs6yef6Caay/efBbqxD9/NcRZ9lpc/xJWK5xL/5PeUD
         0NJumwO6STY7hc2oD/j38GCZ1NRLi3R80FOyUaZDbxTVk9bvVMDtbh9bj036a1aYtji+
         PsgovkHeSmUh5XoPiaxUFKpRRKO5qce6sapArEYUmDwaXIBNiB+VZBmPR97nYyCSpFKM
         CqkPphlE5ia8nUa/bDhP8ysjZENkp1pxnnNn4AS564OtUwsJBzbYBWAxtWwjxzUj+OFH
         pMICyAV1dnrqCwPOpeckMvxTZMnymzVGZlU92CNa0k3mBgO5rKapu28ylsTpicMsYIVw
         cFNw==
X-Gm-Message-State: ANoB5pkElLYjCVqEWHwaDH2UzYIWjao5+zIiifVfPZTtWPFkcK4NpdIu
        2fw5hsJv0U3BGQDbkePjKwg=
X-Google-Smtp-Source: AA0mqf4aQXK2YFP9zN8AYyVVp8yy6XB26E6pP22ecJQ2jAGlbETA14oO58LUU1q4zivayR7lvz497w==
X-Received: by 2002:a17:902:7c06:b0:189:b0a3:cf50 with SMTP id x6-20020a1709027c0600b00189b0a3cf50mr27149772pll.39.1670352062320;
        Tue, 06 Dec 2022 10:41:02 -0800 (PST)
Received: from [192.168.1.102] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id ju10-20020a170903428a00b001782a6fbcacsm12937521plb.101.2022.12.06.10.41.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Dec 2022 10:41:01 -0800 (PST)
Message-ID: <31fae915-3803-49e2-cded-0ab77ffcb611@gmail.com>
Date:   Tue, 6 Dec 2022 10:40:59 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 4.9 00/63] 4.9.335-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221206124043.386388226@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20221206124043.386388226@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/6/2022 4:41 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.335 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Dec 2022 12:40:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.335-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
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

