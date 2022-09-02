Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40F7F5AB6C7
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 18:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235498AbiIBQp1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 12:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235835AbiIBQp0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 12:45:26 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A782FD51;
        Fri,  2 Sep 2022 09:45:25 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id f14so2212674qkm.0;
        Fri, 02 Sep 2022 09:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=29oZcoY2q46tLwUZQFlwRfSOAvKJ/1ARLsojbCZzUIE=;
        b=ZUskE6+2avARgePDn3wyMZKTjzJgc6lCmVbVSJcUXMQuXyMmA50n/YqlwvYYFYglBP
         9Qt8M7lmFQQiBaBjSPXPfzTcHt5V0HveD1rU7erMMedLCDD6SzuslxqAkI8scOaqF8ZS
         3m3XdzWVN9hqxy/XSAuqml5TMpqNrJQJTKaWDNHqyYFvMRhBR0zyxiwtNWh0oekMP4CE
         h1tN3K0QTMK7lTGryeEKFW2ktOyXYpRbb4bJFZ1BbV05e/adQyoO7zQvESrK+4l83hT+
         N7iZqPXKBjSnLUqRpuL3nch3N1HAfVn6SRjFv4qcdtcVFwiSzFgEac2FKjsjukyouV1E
         Ve1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=29oZcoY2q46tLwUZQFlwRfSOAvKJ/1ARLsojbCZzUIE=;
        b=p1ktmVIn2BYERAKl6chrw9HJx/oc2EXZgFzKugboMtpjWXgRSHHc1Nl3GVQLOYjUAm
         lDVXWD/9fii+k2y0PnQJwCGAUrfk0ovnIqQfWkfeqA5QfR0f8wDSwwfVR8hfIiwMInNh
         D/Rx51wud4apn+HxynNewt/BBTltEKGYM5Mm377rcjVuDWjp87wnoiPz+7HWs7hORPyw
         g4rkKefv2L81eXGlrZPozGFP7rO2H/eH54PlbVD9ik278JmzveN7Jac+rHK92/rj3cim
         zsXmoXaqzzX7wHpGGmXHGtV0RMISZ/REBVpZFYWrKPqY3DiLPnsR9fr7HIWpAzPXKGT6
         rKCw==
X-Gm-Message-State: ACgBeo0mdiQ9MO1HFzoCjmgUR5HbEUOoD3J0gYcsosmXUeZIQRNfR8rf
        5oM8/N+F7jcVAd0JqVTxoU2IHckPJRA=
X-Google-Smtp-Source: AA6agR5xxB2RpH6Y3YWpALTdAUEGu1Hhp+5pBoEY9ywcGNWg77Sc3DFw1HNPISVB8w/E3BbCptS8+Q==
X-Received: by 2002:a05:620a:198a:b0:6be:73ae:bbc2 with SMTP id bm10-20020a05620a198a00b006be73aebbc2mr22412053qkb.394.1662137124729;
        Fri, 02 Sep 2022 09:45:24 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id k18-20020ac81412000000b003445b83de67sm1277705qtj.3.2022.09.02.09.45.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Sep 2022 09:45:23 -0700 (PDT)
Message-ID: <df379546-8439-cd18-b882-181542c28882@gmail.com>
Date:   Fri, 2 Sep 2022 09:45:21 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH 4.9 00/31] 4.9.327-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220902121356.732130937@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220902121356.732130937@linuxfoundation.org>
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



On 9/2/2022 5:18 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.327 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 04 Sep 2022 12:13:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.327-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
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
