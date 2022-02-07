Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB6E4ACD0A
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 02:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235176AbiBHBFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 20:05:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236779AbiBGX2E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 18:28:04 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5724C061355;
        Mon,  7 Feb 2022 15:28:03 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id om7so1288966pjb.5;
        Mon, 07 Feb 2022 15:28:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wMCF6rrG4H4mtR75i+Ow3RIxozoNm0ZBZY8u8XRb4YI=;
        b=FUfAOdIhJc/NIZaF7i6SnkgHZUqRweh3C67UTQ0+Y9pki22+ZtNB7min1qoUAIdleb
         QQ3WMe9ppSf9nVF8/rWzFkYC/DemMLlUGzlwLM2qsS+VTl3J3SlP2DKlMPUtVUhyCe1v
         OxStvo3MwAmq/IE2pyosgPvKco1i51JvFFwxADCmenMzPJg1NRS8zGaeTnH0HK3RhMN9
         AeA/IvO9EZJpyovTWWQAfDb7hUGe7U/fZKEdXM7qBEFqcItHRbJgnLraex/tRnxtjagH
         Yg1NXXT15ZT/71E71nB8dUCp9+9FQXFG1oegbw91QuRc2ZtiJBEAhmnFW4cd9eVlt4Fs
         qbrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wMCF6rrG4H4mtR75i+Ow3RIxozoNm0ZBZY8u8XRb4YI=;
        b=d7QVgs3DAVhFLRAuDFNkmRRJNsa3WOLx7dNXduXeQg3eOb9q3/QWwPhAT+DkF7gvc0
         k8VMV8R6YpOE33r2djhVCsqAhg8PvmxL2Wj6eIGuMD0GBewiZgX3O0x5Hg4VqELSRLLN
         ntZDkfAy09XqJ4oazzcYzLqVTQKN1TdQIosZokcO7RqywKgwJl1V3qQaSaJZ8jtDdAwB
         XvF4HoUITJPNf3GBsJKkECJaO3dDxAEDAA04I9Q5qBruI3ohwSD+tuC0iQ+PCBlJPxWZ
         AqSKG60rySTn/DCkx8ICjogJXf5pXrMzdEXrNEISA7fB4N/omIoornSXtboyw/2IMBls
         bB/A==
X-Gm-Message-State: AOAM530V1E+dMeHtH5EB5wwqByEjNLJBg0frT3PTpSfZbEC8jQoUacTo
        30POuQja+WAZT9fjFVXjAVM=
X-Google-Smtp-Source: ABdhPJwQ05+7spxyqqMOdTZMnDmFos3xpomIyWBNabfORn7hpQFI0tMroajmfSyqOs8P7RR7NhQ+4A==
X-Received: by 2002:a17:903:1105:: with SMTP id n5mr1706476plh.99.1644276483121;
        Mon, 07 Feb 2022 15:28:03 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id mz4sm395744pjb.53.2022.02.07.15.27.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 15:28:02 -0800 (PST)
Subject: Re: [PATCH 5.4 00/44] 5.4.178-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220207103753.155627314@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <2d0979d7-ecc1-3ff0-6bb7-c4295f3aeb7c@gmail.com>
Date:   Mon, 7 Feb 2022 15:27:32 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220207103753.155627314@linuxfoundation.org>
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

On 2/7/22 3:06 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.178 release.
> There are 44 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Feb 2022 10:37:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.178-rc1.gz
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
