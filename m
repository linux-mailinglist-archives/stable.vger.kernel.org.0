Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09D9068DFD5
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 19:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232313AbjBGSWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 13:22:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbjBGSVi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 13:21:38 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D899F3CE0B;
        Tue,  7 Feb 2023 10:21:03 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id g18so15461556qtb.6;
        Tue, 07 Feb 2023 10:21:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uNoCuvF8k/IGVgv9MTdzYZCHzKUcqEKM38i1vceSI2Y=;
        b=QdQ71qYYT0xgyoNJdybVu6bekywG/lSvp5wx6rU5hsJ2AFd2ia5f8Ph/6NHAe5LXvM
         yIbiTtMpv2qYiM61f69Lez0/bP2x0TqWbe8ew7/1nW38tkG33CP4zCJsry/SmepvR9lU
         bYflQM1HrvqymwOAt1OwBRM0Nd4JWlpYBk6fWITv/grNz34I4aOAykUJ5bmXq9ogA8Oc
         vQwnGB5Z6cSiCx5Wf7iT46AWJbbtbwUUoDouMowKJkPqiL2BaFl8XF84ITq9xVisOyEP
         FuKg7hBmze3nvJ7JfdkClDMN82eU3T0wEzQzYDoBJeGoghnB8Vtzd+BypUcera2UZeJn
         IsTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uNoCuvF8k/IGVgv9MTdzYZCHzKUcqEKM38i1vceSI2Y=;
        b=nEdFUlzyJwKp4J9qr1ZSzWaPR/nMIec6BhIyjJRHjQxtzSyhs8waJHDc7gySD2yHbD
         rW19xz8LG2XDzJZwyE64cOE9JVVUhaygWU6miMRcwCPsTA9pnWgJwAkIwj8dnqbbEhfq
         YkCZA25n6czn6+RTa2mjkKahmEk3nBQd01KD+0hgp5dgYtz1JwCkIy4t25KgM1S1BI49
         dF6bvHgZ/l37SbwX4OF6I+rr8blA3gj1irVANCtaXQ3H9bVhd5pINH3GdPMLTYweS7cu
         NVMmXDlg8InL9AThfBC/lF7eDD8Tvi+lDqx+VHOuLSZtnnj9TK8RY9SehKBGgDoNewQA
         zbHw==
X-Gm-Message-State: AO0yUKXmlQZYe9U14zeSpktHWk/0+JtG1I9BG66JF1S954Qg6u1p0DrJ
        FeMtqm180ZGmoZadldCCzTo=
X-Google-Smtp-Source: AK7set8P7XEs+Z1mylqUEpNqmN5S6L1etKNkQzg5lRXZj0sNtQz45dsph1NS3hqwt2mCcBsBFjitTA==
X-Received: by 2002:a05:622a:18d:b0:3b8:aa16:82c1 with SMTP id s13-20020a05622a018d00b003b8aa1682c1mr4725673qtw.60.1675794062929;
        Tue, 07 Feb 2023 10:21:02 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id g25-20020ac870d9000000b003a7e38055c9sm9733458qtp.63.2023.02.07.10.21.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Feb 2023 10:21:02 -0800 (PST)
Message-ID: <ad03daa9-8317-a289-865e-9cad591d91f7@gmail.com>
Date:   Tue, 7 Feb 2023 10:20:59 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.15 000/120] 5.15.93-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230207125618.699726054@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
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



On 2/7/2023 4:56 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.93 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Feb 2023 12:55:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.93-rc1.gz
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
