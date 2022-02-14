Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37A814B5B88
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 22:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbiBNUwm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 15:52:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiBNUwl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 15:52:41 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BC2A21818;
        Mon, 14 Feb 2022 12:52:22 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id e17so11785218pfv.5;
        Mon, 14 Feb 2022 12:52:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OLEzoYCMLTbGDVeqbxK+5lFttyCAPo9oIDhB/QhDJGw=;
        b=QXJQkK/mzVF+p35yGb5Rc6EArRncVS6UPVJ43adgUZqedywOqAnrO4S6GuocX12OA6
         7YFYSOww3s7W6KLb8L+3R0VO1dXu3Sh2dfP/48P8qunaMnyE++UlU4HKjGxG6I4P6hh2
         udpNZ4v7zu6zMPpttbGlQjWJFeQe3Ixcu6loRMEEDtWg9SzMBkgR5Fiz1xBV6G7Q4Gu9
         tgsO7RW4gtFaMghM09q0Fw4CZJAq9iN88KAocwPW/+v2OQJQiRuZ4/v6rTke9phBfhxi
         sKemXb+sPsf9dWsfLEMFuKn+xE+f3XgMulnZCxH1/+IWdoy2jN1JZrLsFIZEj8m6E50u
         m4lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OLEzoYCMLTbGDVeqbxK+5lFttyCAPo9oIDhB/QhDJGw=;
        b=nJuwrUy4aoFdCQ1r+6KoIm/ARpYG4101OvoQndeAjpj70mmOPNx4liPhWD/mQYLTCz
         yjUTVPiNS6Awl7UZEN0PLbSQHrlHG0spB+myAaY9qtiCfV90xtPsF3hqNf2ywuDsJx0U
         XY8bXrwqAKbs9Kqhe17sq3AjDJ/+D7GrF743RSYCYcfFd8uD9lFusvdM+FITozCqgEBa
         MlKe8sW4gOuI+zy/wg1dT4oQPGWQ1moeltFV3ls6v+BM/nBvpCvwK7zKUCTMGPnsbXf8
         3neUlK89YqbHTGGz3V2cJX1Ad5Rfcic9crPA0lJJoHujfge6kM2qvbhSI/JO+Mv7eDPu
         QDGw==
X-Gm-Message-State: AOAM5301ORUGNBu+XGiw37nhAsr4ANQGAEzUrglZ3VXumGCQeUmgdmAv
        fD/9c3VMoPzCRx7FSZ3sio66DBQgWGA=
X-Google-Smtp-Source: ABdhPJz56ibNoIV+Cjq8u28ihnBkAsxJp4R4lDcSfLYtIfNvCH9HSd3otZBm399O4xXtxZUWzyx3pQ==
X-Received: by 2002:a63:d2:: with SMTP id 201mr585252pga.51.1644869569345;
        Mon, 14 Feb 2022 12:12:49 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id q2sm3435990pfu.160.2022.02.14.12.12.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Feb 2022 12:12:48 -0800 (PST)
Subject: Re: [PATCH 5.4 00/71] 5.4.180-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220214092452.020713240@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <0bdf93e4-9fde-da49-d372-34b2fb687fa0@gmail.com>
Date:   Mon, 14 Feb 2022 12:12:43 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220214092452.020713240@linuxfoundation.org>
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

On 2/14/22 1:25 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.180 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.180-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
