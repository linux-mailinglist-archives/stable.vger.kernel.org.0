Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 882DD644C2B
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 20:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiLFTFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 14:05:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbiLFTF3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 14:05:29 -0500
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A2682BB3B;
        Tue,  6 Dec 2022 11:05:29 -0800 (PST)
Received: by mail-qt1-x833.google.com with SMTP id x28so13390935qtv.13;
        Tue, 06 Dec 2022 11:05:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/TaSyIQyIVk1tPPl8SpOfU95ahTR/5mZip85LMpUqE0=;
        b=aP4vpnBPWS5WVPgzBPPC+E/8DBpGiIxOr0kvPB20hzlFZ49MWOFQLgdRZoJCvVEz6F
         WtbIsK6v2u0JAOZgRdq4hlGoX9kw0DNWP7EzB00bY8178oKP6i4bm/pTsuTaXTkNsGcT
         36NFt5dVvUIeEpM73AEIQKGxYqqitAv3ShJD7nsxLxISl9a3nQN9JbIR1vaGRcjL/V5l
         M+q+9UyGHo6fU/nvyHGfsgJHgCJ3tG+QcM9U/MohfK+7C/MtcQw3Y/If4nFyzCeit/Js
         xJP9j2xwp5C8LK01tfEScKTz0wyRrotYTdsdUnJ2Htez0ieA5nCppSyMMosg4NW7gRKJ
         ljIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/TaSyIQyIVk1tPPl8SpOfU95ahTR/5mZip85LMpUqE0=;
        b=zt/Kqs5LaQBWkFSAFK57qWxT1eCFJgoSxfk3ame59O9IJx1EnztUDUJYqG2dzbniCt
         ibxHVJcnfbXUgLUxH2xb4Ui8oFmyhVUtCtSD1DMFzTH+IqutX9+V1uuOb+OVlDXO17HT
         2Le0EsdfJhxbB3Uq8fo5Piem5iHjAD96unh3acynD20idt1btwxYTDVI15VyZbbBNUEp
         Hr6HS27Qy9tKYjohCYbFTvJfZoq7H6o9ppfEAuRMc1YL7gyNpaROkPa4bJlUhpdVGDxl
         tbpfZkjQ33D/sxuGfFLxoPVR2zKTdDlG2kcqlLFw3Wf0EzZgJ02mi3atlvmLTYdaCg7m
         nbEQ==
X-Gm-Message-State: ANoB5pnVJykkhN1fNBuOtJykVrnNs90ZRn/E/RcxWKil/Dv6dvJIk1CI
        uzc2opogIezrJKVbXqxvRGs=
X-Google-Smtp-Source: AA0mqf6rJ021beKfANsDw1zAUU/n6XEvZd1HJ0S7TwgV3vdiH6r4GFMLDMurjIO9Jh+7EIYvZNjG5A==
X-Received: by 2002:ac8:4541:0:b0:3a6:9904:d3ea with SMTP id z1-20020ac84541000000b003a69904d3eamr17886721qtn.597.1670353528117;
        Tue, 06 Dec 2022 11:05:28 -0800 (PST)
Received: from [192.168.1.102] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id s11-20020a05620a0bcb00b006fcab4da037sm12513107qki.39.2022.12.06.11.05.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Dec 2022 11:05:27 -0800 (PST)
Message-ID: <6cc9c6e0-1107-e743-de98-6ea6b04bb131@gmail.com>
Date:   Tue, 6 Dec 2022 11:05:24 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.4 000/157] 5.4.226-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221206124054.310184563@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20221206124054.310184563@linuxfoundation.org>
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



On 12/6/2022 4:42 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.226 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Dec 2022 12:40:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.226-rc2.gz
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

