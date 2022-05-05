Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43D5451B68F
	for <lists+stable@lfdr.de>; Thu,  5 May 2022 05:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbiEEDbD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 23:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233705AbiEEDbC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 23:31:02 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CF6946142;
        Wed,  4 May 2022 20:27:24 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id x23so2630937pff.9;
        Wed, 04 May 2022 20:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=9zQNbMxYczMNSMBjlKwAqK0Zf0LTVQ4fP6xMR3g4H9E=;
        b=TYwqyjukzHiw9hs2taos2n+SiiIuMwX872mpUAaEIn7Vw1VT82TRzCr6MdeFW5YIDX
         UkiRSOaIhWhl8F2ItpwQmBJGcKW4Ao4G4p4fiUHeOolxlfXZu1GLi6Ez9eoRs0qWYJJ/
         TM3Xz26MvCrQXgPXPObf0KnhcpKCJCnIX5HQVEWfxUrPB6Jr5jc5w5BhxdQaeSYnbsLX
         0jDKOPb6CvSnNvb+Xn7vBQDhhnz0RqvziIVZpzRzcSA2BGy0qQtCrD3ybTK8aTAW9IDf
         WE7ubXf9wBWKKyflmvoPtp+21+TQSMN9cadaNN2axKy95lb1J8sIJnCoakqjA64y5XW8
         unlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9zQNbMxYczMNSMBjlKwAqK0Zf0LTVQ4fP6xMR3g4H9E=;
        b=gwgoJSeI+BV5fARQOskxXDXR9bP0ZL5t3/AsP/8U05MROj+oeLemmeIg2ap2tDvoEP
         1h0CvCKppFormSssBDyZIqTpSRQpjv7vR1DnW1EgVX2jlQ4cui2Gf+RSmXMqywVym1SW
         U9F+zz2rP8eV4MWCOMO+7oImPcjUjQPGjo4ai+UYLechRHazPVm+N3z8bENMTCMJ+Kpy
         LwCF5nvzDt/2rYrwpK7NwoouSqYq9vjdOTjKlxz/oloe4vsuSY43cA+JhbabaABNp9Iq
         QkLXvSmEV7vRxweu7VkmbrM03ktTVEw3clBnrX47kGppXtlgCNFRGdyBxI3M7QP/PvJ3
         9HGg==
X-Gm-Message-State: AOAM530T6O5Q+uP0kUY0GVBgtU9sfTkC0qTY6lfwpJ53Ii/asA5getep
        H6Mgg9ODY/xAiT+A1De9g9g=
X-Google-Smtp-Source: ABdhPJyRfhOBZeDi0X0vYMrehR1+0q8VkfT3VKlaAkeRLfAavj7LEQ341VHc6eXqJcXTnKA1DyeKvA==
X-Received: by 2002:a65:524b:0:b0:383:1b87:2d21 with SMTP id q11-20020a65524b000000b003831b872d21mr20443698pgp.482.1651721244004;
        Wed, 04 May 2022 20:27:24 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id i13-20020a63584d000000b003c14af50606sm153188pgm.30.2022.05.04.20.27.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 May 2022 20:27:23 -0700 (PDT)
Message-ID: <fd00484e-5254-7764-cc80-c7f875b2d7a7@gmail.com>
Date:   Wed, 4 May 2022 20:27:22 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 5.10 000/129] 5.10.114-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220504153021.299025455@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220504153021.299025455@linuxfoundation.org>
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



On 5/4/2022 9:43 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.114 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 May 2022 15:25:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.114-rc1.gz
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
