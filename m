Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01AF94B0432
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 05:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232261AbiBJEGe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 23:06:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbiBJEGd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 23:06:33 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C35624587;
        Wed,  9 Feb 2022 20:06:35 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id u16so2306707pfg.3;
        Wed, 09 Feb 2022 20:06:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=D824CBsDTkAnZmO31B6FAA6Hg8krn7asQlC1nYX3F/8=;
        b=ijy8JDgmxDWPPgCB7+Tkn6mwan67OYvixHCUWQ81F2WcTo4hNojXfWwMlJALdCE1v9
         TsNKyu4WkfXj3jat9pfzfZmxvz7V+Rcj8Q/954b6i0kWeMzU3XoAKXPDy2Vn3T+KNKbt
         K+fddMUQsAfHwZJph9zwQOENVzobDlEylAH0oxHNbWzk4wKXApyixh/8R3AQIP54O2gg
         aPMVYDI1I3KCRqZpJqhO7Zq+Ym9D5Y2LUBXDGNnFDH5Dn1dvap3HjDCKzo8zmT3DIl2L
         0P83a4TtwF+/WB5GOhhXbNSY2FKK2v+5A+/uGmvvKe5/n3FPkSaPkP+4cnKCTC/2h9/A
         Gi7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=D824CBsDTkAnZmO31B6FAA6Hg8krn7asQlC1nYX3F/8=;
        b=sJSek60QAIOLlIgy3SWK0BIQmgmmO/QBXVA5KNlgB1wb5ANFF4fD1AFpK0Tz0kYpd5
         RiuBqCEyQjAJ2LNomWjagga0QvVSK6yPTh66MWFHmP/BWBKfsu4ReQokxbjOdOabihEU
         ZsALHml4hlDm47E0OruY+MsCeXS4mB6//I7YafuQbWCXqEJrHthsufjgNyn81trRBwbM
         jjAs7l8LWdFR/gqyK2L8ool5377J5c2ppboLxHWfdDV2tYdeK6ynRL1GqfUxiskbK1Ho
         oqf+Is1I2V2GUZZecmwwrFDzxzDHnK4hVwal1/Us8T8RrRczZT1ixFbkga41cWv65Qio
         P0HA==
X-Gm-Message-State: AOAM533eChLD/z09MKf5vl7km2CZuCs8A66Ab6vf/TUZl/i6wgNvmOzb
        q+iQRBC6c+NVcVyBRP/KKn4=
X-Google-Smtp-Source: ABdhPJxtURjkMOZI2kXr5lWz1cvvjq3oBbtVWKiX22Dz3d9SHOCT2ppJM7OJh6SQ+J8284q1Nej2yA==
X-Received: by 2002:a65:6392:: with SMTP id h18mr4448490pgv.102.1644465995022;
        Wed, 09 Feb 2022 20:06:35 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id d12sm14908176pgk.29.2022.02.09.20.06.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Feb 2022 20:06:34 -0800 (PST)
Message-ID: <0c0b36fd-360c-cb56-7e06-ae84af7cd3de@gmail.com>
Date:   Wed, 9 Feb 2022 20:06:32 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH 4.9 0/2] 4.9.301-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220209191247.830371456@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220209191247.830371456@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
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



On 2/9/2022 11:13 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.301 release.
> There are 2 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Feb 2022 19:12:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.301-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
