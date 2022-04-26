Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 562345104A7
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 18:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353351AbiDZQ4Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 12:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238941AbiDZQz6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 12:55:58 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBCFD57173;
        Tue, 26 Apr 2022 09:52:33 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id cx11-20020a17090afd8b00b001d9fe5965b3so718725pjb.3;
        Tue, 26 Apr 2022 09:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=r0lhPwHvH5aW0qjpr+H1Q6FH+Wd+E2OoVXX9QmNnwis=;
        b=eoXcjPRWfIgipFkhjyIJ6gYXJ+YSE+jGmT+GS179RkPiGczBzzW7IuoFM7h9WP+3Ww
         31F1yHNWdzpkXOcUg5IjOk48VV6DZPKCF1X+7kM9XpVggisaoKVWPoErG4QGCaYYzqn6
         kSy+iOL4RT1jMnNZI5M3iJiUfXOSw5vJowfYFyGSPXh9i0RrIZJv1lIPELfxWx/usPip
         uknDUjBa6SFIMaWImydiC17VBGmMJEAlm3VsvB8r+l8m8do8oMA5KvjDTpyE6IxZOect
         6WZzX6o33OJa4QxkrY7CwrXnt4pqStCnMPvsgxVWjvsT+y5VcHA0IC7+sUxYFimnZh42
         r5fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=r0lhPwHvH5aW0qjpr+H1Q6FH+Wd+E2OoVXX9QmNnwis=;
        b=jkf2iwAE53YP7icEL18KgMLn/OZ4SZo/+kUcupU3TJpVjY9Uqh8jX3hFUNg7X/FppN
         KLCW/7mYqTNPRXs7EI1E9kN5XEPmz/qSiqZeoV83Br8otMXGMBoi/GqWMedIZiKMUTIh
         S+5DRgJZhpW4WTa4O8QwcHmJrVcr5SooOKkIxBDouD3KOXMLo4772a9562de5Lx2bw5R
         5j/t1A6uuqXjSd1u+iswcsPmv5pqNJeOdKlGadQjKtLtx+jwnCOVmVkaf+qA9Ae3fDX9
         dTwHrGzbA6pI9y7cHspOddwTNS0rS8DQRsy5H10lkxVeLSpEvxMOl/Z5djqkxRSVDI6n
         jOMQ==
X-Gm-Message-State: AOAM5310a56VmW9RSgUe7Q5mdMJeVBlHcBmMG41lVoIyzr+p38J0z/Ik
        /jhpayxdFyscq4m0vioO5WXU0Uk9x4U=
X-Google-Smtp-Source: ABdhPJwAX9WnP8hldRTNm74L7b1Dq1glV4/7KT1w6Vwvj+AfgFLAz7o8RjrIpyM6NeWDOlpVzV7zVA==
X-Received: by 2002:a17:902:8f94:b0:151:64c5:7759 with SMTP id z20-20020a1709028f9400b0015164c57759mr24420414plo.4.1650991953232;
        Tue, 26 Apr 2022 09:52:33 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id k13-20020aa7820d000000b004fa72a52040sm15871801pfi.172.2022.04.26.09.52.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Apr 2022 09:52:32 -0700 (PDT)
Message-ID: <3edf3b94-fd21-8d0e-1f32-33598863a156@gmail.com>
Date:   Tue, 26 Apr 2022 09:52:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.4 00/62] 5.4.191-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220426081737.209637816@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220426081737.209637816@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/26/22 01:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.191 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 Apr 2022 08:17:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.191-rc1.gz
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
