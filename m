Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7AD69E898
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 20:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbjBUTyu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 14:54:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbjBUTyq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 14:54:46 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C310F2C65A;
        Tue, 21 Feb 2023 11:54:45 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id h17-20020a17090aea9100b0023739b10792so756432pjz.1;
        Tue, 21 Feb 2023 11:54:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6lXLb2kAxu1qrxKFIvtwpsX4ghWa+4Y9mIGpesCLWZM=;
        b=Zm2YMz0ltXL+hvMMp6m9/q0f+/mcSg2Hy1AL8uLoRvfGiI7/hDF6FQwlQ3kCUKqQfW
         h55b/8BHi4r8D3Y4cV2cs1X1QhWKTl2jz9yqu/s/p07q3oXMDRlW1ZDYN0bAnDWKh8vE
         JE+wpYslf7OyS7IT+xQ6e/9qn/z1i+u0jAN2Vrt+ehhdBvDhUyeWion1lAvqt9bvDk6j
         c0R0XV8X2t8LaPinBdmyCtjVgF/wT0FHzPQl7a57aLnwZeyfJuU2ZgwC75hSxzT+oCwj
         nBdXcmCRE9lczlS93mdPHv32549y/Y6oFlaS+AOWtoyK1LcbmYFPFr15bIYpWqa8dydS
         iG7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6lXLb2kAxu1qrxKFIvtwpsX4ghWa+4Y9mIGpesCLWZM=;
        b=sLjn9MOADMGbmC+RokSQSBFGpzstm/tqLdstuz4o4hMlQlDXuBJEX1xra8X7psVI7z
         e20CvQH1YDgHgMSAzkViFKx273gy/XRMHxeYZIFMllNaqoR0nzSY8dbMTGAyvDkPuNnY
         xUPfnK0niR3rj7Amryw+F2h1zZUrNbe79ck0S9NpJOZN4u7ebkDVuZe7HOw+ZCX31Blf
         HAYRqiZL3TacJ0KC/rWMaixAP3MNPQziwdIg6KALUxJ7sULfT4zJNlPucZ5T87D04PmI
         apkj/0/ShS56++7okeDrd/FtJRrgH8TlwuFhALmBEPIt7HLf4TDbY97Po9nukcVw2e9L
         V7Kg==
X-Gm-Message-State: AO0yUKV4gfvoX8Kk2IFnkegFdrCs9yq3I0YUUW+p0iLoEDdKHEpqQw4z
        LxQq2edmr15jd+9YHLMzkrc=
X-Google-Smtp-Source: AK7set+inZ15B1OxI3byvR4e3v0ZSqG0MkSjGibLn1UTgkq4V5j99CglJLFRAzKioatHpF1QUQiyyQ==
X-Received: by 2002:a17:902:f545:b0:19a:8378:bddf with SMTP id h5-20020a170902f54500b0019a8378bddfmr5986612plf.4.1677009285147;
        Tue, 21 Feb 2023 11:54:45 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id t13-20020a1709028c8d00b0019a96a6543esm2553118plo.184.2023.02.21.11.54.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Feb 2023 11:54:44 -0800 (PST)
Message-ID: <c03b9be7-139a-a0c3-ff90-673904cf3431@gmail.com>
Date:   Tue, 21 Feb 2023 11:54:42 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.10 00/57] 5.10.169-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230220133549.360169435@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230220133549.360169435@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/20/23 05:36, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.169 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.169-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

