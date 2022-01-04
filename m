Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81E564847DA
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 19:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236163AbiADSa0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 13:30:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233271AbiADSa0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 13:30:26 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 221A5C061761;
        Tue,  4 Jan 2022 10:30:26 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id i6so21625678pla.0;
        Tue, 04 Jan 2022 10:30:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rnQPBHVgsKv6rSNMK5NhPILl9X9oiqIs0qquLCqqHQ0=;
        b=HCGrT0sawWhxhFJ4mcbj/MzfDxvySeJ1ZpjfgqfgpIDimyiIkGHqEaSF9PDHyzPGCM
         lrKKFZyRDuqwauIKVlEDV46kiOlNpSSZd2P3BlLkxo+9/MdpM8MJa/2ubBNZ9HbSFHcJ
         ThRdVA2AHcbe9UHZpqYOAt0HAODyFKB0WdVzwBzSfGIjwNb1kHoRBXmnbyLMwXUYfLVR
         Z1jLgVqR7Oaoyd2LNsja1sK+zsyzhW2KRbJIZ/JTFJQeW28T9MUuMIL7ViBCenI5kWwY
         172WLZw+CBbKTlthdezuLFESVy9oHBOWxPvIDOflXNWCG1PJVLvQnHjXmGPpBZ0+aZb+
         hcrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rnQPBHVgsKv6rSNMK5NhPILl9X9oiqIs0qquLCqqHQ0=;
        b=0E9NvwfYNneizHYVJ7WwzcBXaUJZ6QGIsSuVtnKNAFfyyvtZNZno7wL141AZrgKA2g
         626pi4S7scl6re/4EsEpMJepDs79rhTaTMB0ILyGNTRP5uT85xjqeu6viP2Zp3sT53Js
         T6kAv7JNt8mA1AqBdQsB78fTFu1vl9hC6MmXybbO6cS1G7o1BwlJRnn2ulA0+KlaRQR6
         yWLNcr8kK72+kXuu8UmkwZhVegF/AxFdVIRIbrFb++rLGVSLSh0GibQUVWRCFQvBTR+8
         4d5yzshDRQ2sDBsuOZtf3QxR5tLRXt5lrULleZMvXvioybM8U3FWCd0ZfEAyE0EMp9pq
         oFrA==
X-Gm-Message-State: AOAM532nH7VgDadCLgjboASx6XKZxdr3Y7RLr+fQa8fXgcL/f3+Pyqxw
        Y0v/cGVarfdNVKJkpreFoC6rq+022P8=
X-Google-Smtp-Source: ABdhPJyoSQceafFcNkfHl0BMw+h3C1wpdBcgvb++kqJRl3z4z6A/PjLgj+JKBOEHRETHleThJvtOZA==
X-Received: by 2002:a17:902:ea0f:b0:149:3fdd:1090 with SMTP id s15-20020a170902ea0f00b001493fdd1090mr49447542plg.43.1641321025164;
        Tue, 04 Jan 2022 10:30:25 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id f7sm41745299pfc.141.2022.01.04.10.30.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jan 2022 10:30:24 -0800 (PST)
Subject: Re: [PATCH 5.10 00/47] 5.10.90-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20220104073841.681360658@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <606e6212-1005-9f38-2286-a6f515d9c27e@gmail.com>
Date:   Tue, 4 Jan 2022 10:30:22 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220104073841.681360658@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/3/22 11:41 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.90 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 06 Jan 2022 07:38:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.90-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
