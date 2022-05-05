Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5D7251CBE6
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 00:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233742AbiEEWMZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 May 2022 18:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbiEEWMY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 May 2022 18:12:24 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F4B5DE4A;
        Thu,  5 May 2022 15:08:44 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id x18so5651987plg.6;
        Thu, 05 May 2022 15:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ZctFPbIkyyBRN7A+G750EEkN6msxHuL8eqp5mqoQ1Rw=;
        b=fVW8tJJiyLpUsuCsQDLJeKt9GdBmL7vu8PiqCKg5vNilsGOJzXi/lYlE2Y3j7naxrX
         9kBOKY7ceQIs+w89ou3N3riXEgTmfY6njVsuKmkNXOA4YjqvxyeYJI1B4/7d44EJyVZQ
         hgiU8yHwDxG5pQsFZJMa6i4Yn1TpRY9Fnz9OpfCd3jhJqKMMrnpzRtaMQDXNpLMfbciR
         XbFpjgur9tuDQTuxQ3VNgl/+opK4kJNEehrRRWz4+w4eTbqV0+HyAo8oTtL4uejcx83g
         /bx1eppx2lOdo0lgOQppr/6QAA131P2XbyLQwaEuxkw6AAURnlQQvvYxwyA3sf1znOzJ
         I8Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZctFPbIkyyBRN7A+G750EEkN6msxHuL8eqp5mqoQ1Rw=;
        b=Mlh4w+em7sMZ3U5m15oLLzA1v0Q/adrQRUIjq/4l11YjGKV+md9b2vQGrmRQll6wCm
         4hEhveneB1VZp7KGSuquhQop1rsioKWwtHCEcy6VYepuaK4JTqdmllBfrq+o4GUJFWUY
         FU3jUp5fOdT69oyGvRSMt1yf15UjBHxMsN+iz0z2kMo1TSA2gHX2c7lbVOCeP5phQwvX
         PK4Yy7qCPvrPcNNfPphACeKpsyKF8a0E4ZYD7p3ljLi7h9wevNLPRIu9B9e2QqJcrvbw
         3otqlv1eHi0thoqlzTde5q11Db9rjUWvJ+N+pKS+9LvKbMwsCOPKfcVg5Ud3N9jwRCyV
         ty2Q==
X-Gm-Message-State: AOAM532ggdtJuNEeK2oNNoZV6xWbCwyuRDfc14Y84iacmDC2UlapAzWi
        QYcVq1qvWI9WWmtXMsd9xqs=
X-Google-Smtp-Source: ABdhPJxrJQ1znobxJsDaMY2MuAzsVvl21cvzxtdYXjDgEHVzA7T3IH6ne1HEtLcuy0U/LwHvpLvvNQ==
X-Received: by 2002:a17:90b:3889:b0:1dc:cac6:f03e with SMTP id mu9-20020a17090b388900b001dccac6f03emr463795pjb.23.1651788523662;
        Thu, 05 May 2022 15:08:43 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id y9-20020a17090a134900b001da3780bfd3sm303383pjf.0.2022.05.05.15.08.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 May 2022 15:08:42 -0700 (PDT)
Message-ID: <f71c8b62-d875-5f84-e6fa-5548eaf442fa@gmail.com>
Date:   Thu, 5 May 2022 15:08:22 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 5.15 000/177] 5.15.38-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220504153053.873100034@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220504153053.873100034@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/4/22 09:43, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.38 release.
> There are 177 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 May 2022 15:25:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.38-rc1.gz
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
