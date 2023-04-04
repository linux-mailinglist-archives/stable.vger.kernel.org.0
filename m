Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9AD6D5662
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 04:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbjDDCHC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 22:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232997AbjDDCHA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 22:07:00 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4322F2111;
        Mon,  3 Apr 2023 19:06:59 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id fy10-20020a17090b020a00b0023b4bcf0727so32496811pjb.0;
        Mon, 03 Apr 2023 19:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680574019; x=1683166019;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=t0ge3CIUOEAdSzey1zXLiQEJE19ZYS3sqtGQOCknv/4=;
        b=TdNchomHmFG6XQeTfzd8bCgqQZzmqhfdiH2VqbSs0CYCR2cw92h0zcP8kp9ppvkEqY
         m5mttRjQQNoXLz7ctQTuCvmWNEwucn6Ir21DxI4reEFoau+zOyiTIkCmHH011B/pGiPu
         wseRjZupLmIkZvB6BEZsFVIQVGJSF4HLGsQWDp/WvWYrIGsCh7bdWRogfEFgilqVWnTi
         7y7c1mqY77J9ROyRnH+IF1xtarQNrXd93diNrYrw/KuPi00E2Rg9nAobPPrcgvDYLGjv
         tmr0aRieAhJzP/PayxAWXWXVNM2R+6HVdAdcVacJeKmD941ggvOY6bjjZ3z4CO04mSVn
         aaQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680574019; x=1683166019;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t0ge3CIUOEAdSzey1zXLiQEJE19ZYS3sqtGQOCknv/4=;
        b=paDMVLWP0TrH8PLwVkIRoxq7deJvXF2tsmAbBW6oLzdEekQVUHFMVQgjoZO//XjZaX
         4BT/r8m4gADzbXF0IawF4/VEUHQB4ABFtmeH6i9jXfYoUxT6rOfjSkJwZuCV4Emif78E
         oM/2pIdmb5+twJJxctDqF/AY8H2TZIWhmoIirJqEfX2GQrMzqUJJwhwzOosoUKN4OwZW
         eHmYZ+76TjMV1VbR/6hcCak2hW/rQzggpcQI9Q7BhUTAPgukVWdaZecIUbkuWdfZKxMp
         cv3KTjb/KlKMInwGXJzTeEqHJ1xgfPbj33q8/QzjGWGpE25cSyCXGo9F56WD+ksEB5ww
         D01Q==
X-Gm-Message-State: AAQBX9c2pmiUO9VdExwvh4s70DKV9uxmT/FcLSfTchN806/MSlhLCMFI
        o2eHAFnKOg2YCi56E3wqCuw=
X-Google-Smtp-Source: AKy350YAvo/0m+M3bZC6eGs4064RCzJc6O96Blh7uRJ5TQJb71K3Kw4dF37bCkgkje9GPeRy0PNLtg==
X-Received: by 2002:a17:90a:be07:b0:23f:3b89:7f16 with SMTP id a7-20020a17090abe0700b0023f3b897f16mr1089060pjs.0.1680574018726;
        Mon, 03 Apr 2023 19:06:58 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id u4-20020a170902bf4400b001a27f810a2esm7205541pls.256.2023.04.03.19.06.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Apr 2023 19:06:58 -0700 (PDT)
Message-ID: <8df91261-eb16-7190-dc20-93387ffe003a@gmail.com>
Date:   Mon, 3 Apr 2023 19:06:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH 5.15 00/99] 5.15.106-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230403140356.079638751@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230403140356.079638751@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/3/2023 7:08 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.106 release.
> There are 99 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.106-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
