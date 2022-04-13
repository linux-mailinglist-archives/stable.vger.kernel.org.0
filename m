Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7E874FFF0A
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 21:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233128AbiDMTUz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 15:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236771AbiDMTUy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 15:20:54 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A512049F12;
        Wed, 13 Apr 2022 12:18:32 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id q12so2634215pgj.13;
        Wed, 13 Apr 2022 12:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=13BiRCdMQdV6oE2WlYFyJr4Me/qxZiXsmHAaoX7Cako=;
        b=eiLIDLD7zv79rTjVsGObOxPijJqMLHOy+YsBHfBxiPnr4HSuDamQMd5pFy2fCY8d+l
         2bBVGhO8SlRBdZsBhoRbmI/hGwNfKBopel4av6kGgl2Yb1jSgR1yWBve0acTuHNgjgJi
         uhvEYMyHPnTdc3RirUMG3KLDHrLR0VIjltfsD8TduwYuWqjAfhUzWLomLBQhkGRQRNtE
         9oP4prkrv4M2QRBmCUxvyIpvZON8jleB87b+zJO8RFw3oG3mxv0cG9EaabtL2tTXSLUh
         f2qVG4xj80g6BOOMTjgKSF2RQNsd0bX7D5aO/GD+/CPYcQASiS8R7UJxePNv26KMtWZG
         Pyow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=13BiRCdMQdV6oE2WlYFyJr4Me/qxZiXsmHAaoX7Cako=;
        b=QvU0aMS2Wh1LKRAZXfnMnnEY5T7twCBur4QoNOEvIT7PjsGl5rzoX7AXiGKorNWhD1
         0nQ4nmUiw2Xrin9QdWreOElOiSHdfTG1whcwhGoFxY++Bfn0ZBlL9+mjA0R868JokXhd
         twAXQMdHpOWqivstnoo0VDO55Ebhx/TaDlOj/JN6cdSXpQpPnEN2mxyFLkUvdhuVX/aB
         dYX3izsHNBrSnvMORj6kLdxGvBWOey7foV9G8rFqAQh8X1u4Bo+cD6zPtY0sEW7B5aDT
         KCf+qnx22eX7hw4XQ7sWXO+2GNdItLzKu7XfE1kozpe8v94H8/lhkfIHEGPSIeD5g6SM
         QBlg==
X-Gm-Message-State: AOAM5327fhrB2LB9YcsWSVaapc76dyj+BBsv1fy9XFEwKdO+e68QmCpI
        pIXTNy5tFNLywfmlHukRq34=
X-Google-Smtp-Source: ABdhPJyrh40GO1Kw1ZXMHsblrn5HI7cjcOWiMtzzPSQiRMk1kmwDNpZZqc5CFLwrJYTFmIPzkAYFZw==
X-Received: by 2002:a63:e10b:0:b0:39d:bd5a:92b6 with SMTP id z11-20020a63e10b000000b0039dbd5a92b6mr2649222pgh.163.1649877512133;
        Wed, 13 Apr 2022 12:18:32 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id m2-20020a056a00164200b00505a31a064esm15063373pfc.103.2022.04.13.12.18.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Apr 2022 12:18:31 -0700 (PDT)
Message-ID: <08dc81e2-cae8-a263-513b-c66c0ce1e8e1@gmail.com>
Date:   Wed, 13 Apr 2022 12:18:29 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 5.15 000/277] 5.15.34-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220412173836.126811734@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220412173836.126811734@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/12/2022 10:47 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.34 release.
> There are 277 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Apr 2022 17:37:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.34-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
