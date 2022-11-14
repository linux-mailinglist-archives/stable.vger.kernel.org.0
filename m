Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B54E628A4E
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 21:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235917AbiKNUTB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 15:19:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237392AbiKNUS7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 15:18:59 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9743D6432
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:18:57 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id o13so6331712ilq.6
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:18:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=l5jWeSEFH8KPpRFe92anqqfuPK5CFe56HJ+q/GFObsI=;
        b=KnOsqmJf+Thi9PWSSU6z38w0WX305+CFnz5i6LGeKoT5Oc+yHn0P8JMwQl5NWS4LU/
         5M15Wyd6bbMP+H7VRGLGQDvj9gLwpSQCNdE3dQBI02dbGoLv13yR5mAmXYKAFgXw4GTO
         mqlkKlFZ11ZGED6OeXt9CiygK8Nrup4QD82AE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l5jWeSEFH8KPpRFe92anqqfuPK5CFe56HJ+q/GFObsI=;
        b=rc/AZQdToPLVtAd3OzBNTAUnkKERGnSGtAsoyZSe1wqKyiZ0oUM5JeFqyluO+eC0sH
         eQ11pOLYB4b8IGFotk9bQ0OIkFo/rvsRDFT/j4PfuhRA6iAUXp3NVbU3Wv5AXwZsWo2X
         dyQd+nZ3Jv7K+XtAxMKInvPbcTjIhcq3TucjFJcdJkKCBdaedDF8vBoh4jK40X+c8Fcd
         y7SWFdCJk/pNKSsqClwjX9IzqViY73cLPiyZPHrstJZHKjSJLK0y6pXOibrf8uE7wka2
         02vHN6VgZR0BH8o5vvuJYM3YJMbLC58GlvBgzUUQylvWqSLCpX5w6b7RLwrhzpVanBRQ
         zjGA==
X-Gm-Message-State: ANoB5pl8tWEsHz2uyj2LMYvGsxQnPNuicNZ5RvfFZ8+z1Ucpg1UzIQwz
        GmHexOChyolv4GE/xXRKCL0VKg==
X-Google-Smtp-Source: AA0mqf58swpwdoWUpjNBlSxGv88VOj7yRUmLl3xe1ZWcJ8j7cidiNCb6Kgp1vfhcAigzS/ABz9dSig==
X-Received: by 2002:a92:7503:0:b0:300:c699:770e with SMTP id q3-20020a927503000000b00300c699770emr6941343ilc.115.1668457136959;
        Mon, 14 Nov 2022 12:18:56 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id j184-20020a0263c1000000b0037508cc0bc2sm3876514jac.12.2022.11.14.12.18.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Nov 2022 12:18:56 -0800 (PST)
Message-ID: <8e929fe7-70e7-d425-d285-45e3040d6f09@linuxfoundation.org>
Date:   Mon, 14 Nov 2022 13:18:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.0 000/190] 6.0.9-rc1 review
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
References: <20221114124458.806324402@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/14/22 05:43, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.9 release.
> There are 190 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Nov 2022 12:44:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
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
