Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1A0659AED
	for <lists+stable@lfdr.de>; Fri, 30 Dec 2022 18:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235180AbiL3RXl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Dec 2022 12:23:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiL3RXk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Dec 2022 12:23:40 -0500
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F515FCCB;
        Fri, 30 Dec 2022 09:23:39 -0800 (PST)
Received: by mail-qt1-x833.google.com with SMTP id v14so14807613qtq.3;
        Fri, 30 Dec 2022 09:23:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9+/ml9NCLv5dDeSsbxvtQfApDnRRwzcuKMMn9TJ/VkA=;
        b=EzlVxJMwa8DGFD84dwRkZi0wFjJOLxUtCyb1ZmHRCVmxaoRDMXHvUR4GPON95dV1Rk
         svZWhK8ROFoTH8/JG06d6ej2uAKbh50zfMNOZHkIwixgPxBnTP9Il11UyNaUFl4+oZ+D
         pptoTsvHpiLlsvm28MIdoVRJWyETioDkepShdLrQOhDI/VvyhWl1Sh3cLbGbT65qvGD4
         j8Thbq9wY5Iq+C9OalLuBAYTcXffmsasz1IgCByZMGaCZdMRuw17YfF7I9gznk+DcpyI
         9fo8W+G34UkcLvoD2S71WNrttobVB9jjNxf3OH2cbJS4MBQhBlWYBOhniHXk9TwLIeUU
         qdeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9+/ml9NCLv5dDeSsbxvtQfApDnRRwzcuKMMn9TJ/VkA=;
        b=HNYpDxjOJ2SIpoK4Dq+vn5vk4aDseOJ5HwqBIaD00/1drwc8G6wu1KFe64RQuoiNib
         c2xT1HUa/FijZxrt1vxsXy0pUf+MOT+/uY3GAAv7mJI2MKA/pYgFlQatzIi3z5/iTAUe
         hZjtKM237i0K5Ayds6vVC0tP4WawwGxsriUMObmJ9t8dbjdICwbIIFu2ajgjqXeRbsYK
         00RAuXXs9el3DBkrzHFCM5Mv+hJy7hJ6TFnRVldFvKOz4GcHaPhDMl5HrV5gxWjjx10I
         kgq8pAVPvOVGu/z69GLhpruGPH4qfiQe4vZKejWPCbCt4oZnnQVk5ZQxmUMu5OfnjFbN
         eEkg==
X-Gm-Message-State: AFqh2kr7cefZIvMJT3W9vYCPSwxw7o3U0Or9u4qVoQJGVW+28ycpTQHh
        RihDOsDJEuCOrWWGk0iXB0sDNSk0MR8=
X-Google-Smtp-Source: AMrXdXtyW7V+Bam3ECPKRKkNIhL5uzFNhXHjvI7hvi5I1zr6GBJfTKw8wfVeqzy3ofhsBWFy291k7A==
X-Received: by 2002:ac8:7395:0:b0:3a7:ed31:a618 with SMTP id t21-20020ac87395000000b003a7ed31a618mr44552430qtp.7.1672421018595;
        Fri, 30 Dec 2022 09:23:38 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id fb25-20020a05622a481900b003a5430ee366sm11995695qtb.60.2022.12.30.09.23.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Dec 2022 09:23:37 -0800 (PST)
Message-ID: <1655572b-dee1-9e85-050c-6fb9a743a869@gmail.com>
Date:   Fri, 30 Dec 2022 09:23:35 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 5.15 000/731] 5.15.86-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221230094021.575121238@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221230094021.575121238@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/30/2022 1:49 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.86 release.
> There are 731 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 01 Jan 2023 09:38:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.86-rc2.gz
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
