Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 151E2621CA3
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 20:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiKHTC7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 14:02:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiKHTC6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 14:02:58 -0500
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAFC37832B;
        Tue,  8 Nov 2022 11:02:57 -0800 (PST)
Received: by mail-qk1-x72e.google.com with SMTP id 8so9686275qka.1;
        Tue, 08 Nov 2022 11:02:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3KG5HTwbUWnHIh1/xSLWqezCx1gVcj4ogrO0fVWY3+c=;
        b=YNGhzolnYHsjbIqKphzgb1s6nsxsgBM112eytFZL3/uZxCD8uc0kBgp0raeP0ueDJS
         HP4uZC+H99k6T1HILl0955Su4Lb9c8ZhhiLwNQons+o4JNcdER384aVrzWFhQX4W/kMA
         Ao1DJS4iD1YLhemCCJfi9M8w2gOuFymxiJeeNaZmjlIDD3cxUIWMHAxi3XBNAgfDc/ud
         aj4KSH0kC1wEfKrG6YC5EohJSdldUl84t+RbjE6DOQmiMMuWcerxk6bANlaFlitjZ83Y
         klTrwOKpyVzdE3zaTbHmwlIZ4O4eZghZ+MWc2Rb4BwZ2EbT9Wr+6w9gc9hNzshpmKz/d
         TOZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3KG5HTwbUWnHIh1/xSLWqezCx1gVcj4ogrO0fVWY3+c=;
        b=Q5iOVFu31TepCfmpQ+T0AGx5xuF99GVWBMwXsYtMl24NTUymoTvo0ttMrMLAbIJ3K0
         PFSsmfWl7G4Z4ffxzFzIMYA53qv9bNtvmO/TgX4vUOMZPDCp5HNMemHYRpmxOUWamP8B
         2+lnxDXRJCI5TUEEfCzNw9EEae+wLX4ReYpEjm2zRHpc26Xf10mOXWeWSIkWtB69yQo6
         Rw8LV6vciDoN9yav9BRQn/1ry6th5kgujlqVmx4kpFKk6mg35sn2Zwot1NJwn3XBrvZZ
         fFkpASshidAkSET6lANJoAnhTeVKRZVVDEwKw2p55bSPgP8G/2J0Qb+BMyGeisEIsFy9
         4Ohw==
X-Gm-Message-State: ACrzQf31DgYnjMcZ9kvGDXicAsbj9oJDosdlJqCSIrghaKYYctf3Uy5h
        iKgYIHNthi/GNbpAjihXmhg=
X-Google-Smtp-Source: AMsMyM7xP7cI78ex/eFm+5CJnRn70C4IZ1TJd562+dkXO/hXZs7nFClObcKZvjQfCHRISzXWQ54mAg==
X-Received: by 2002:a05:620a:132e:b0:6fa:5082:f870 with SMTP id p14-20020a05620a132e00b006fa5082f870mr28354616qkj.391.1667934177028;
        Tue, 08 Nov 2022 11:02:57 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id h4-20020ac846c4000000b00398a7c860c2sm8572295qto.4.2022.11.08.11.02.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Nov 2022 11:02:56 -0800 (PST)
Message-ID: <33c89360-8f7d-469e-c365-c9c739b7b033@gmail.com>
Date:   Tue, 8 Nov 2022 11:02:39 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.4 00/74] 5.4.224-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
References: <20221108133333.659601604@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20221108133333.659601604@linuxfoundation.org>
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



On 11/8/2022 5:38 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.224 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.224-rc1.gz
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

