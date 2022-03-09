Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 674A24D375E
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 18:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbiCIRju (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 12:39:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233187AbiCIRjt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 12:39:49 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F5F6D4D1;
        Wed,  9 Mar 2022 09:38:49 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id e3so2830691pjm.5;
        Wed, 09 Mar 2022 09:38:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FTzYDUj/DGbZ6gSv4ALHs6dgNbEyczfJFDCnWsWgF6k=;
        b=B6Pst6kzaQ5MODgn9E8gSlKIRZMeUjYEY5NKJ+wqX4cYG8YIxUTRXj6lUDLSUI5iKP
         QGt/LjXuB1vsgbqb8cmJxtkVoDH0Ye5BA9li+ytsZIwHCyioEA3jw3h/8n6EUB9cb11A
         RvR5wYuHNwL1riuuIcZaTMajsGzotzRdocRLdYrMf9FaiL7DBW+nMoKSsTaLJhBCTWGI
         SG9Ra6qlErwT4O4wNDso+Acg4t8nMoNHSvxDYB45uc8fhWosPhaxpWXrnl1RLUxuO+q7
         VdnJRNPdy2AZa8wzmaf/Avno3JO/bT+ypdnkZ4z4VdHGGbUbHz+GrthqDmjrf2CNnVVD
         wa1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FTzYDUj/DGbZ6gSv4ALHs6dgNbEyczfJFDCnWsWgF6k=;
        b=1fuMfB0X9Mj2iO3ASGuDX57XwVbx/5yPg9xMvCU6S+4VjoABKlCLAwx9aQSBYnwx65
         6jMzlnTlMFVG8UHzoIqml4LJ5ataIcx9RY9OghnGcoscwlmmJv2Ei4aokOVIRxlregco
         Nk0eFadmau0IBuMs6QcT6YkU91kW76utBwQ7bg74vmM1EgsEMf8AinjtrnK4IPTCQP0t
         9+POLi5mJJaDpNVgm3FKtrFttQpH+t3MxzrjItVOG9orzOPcH3A48gHbRGz0MDbIDTaA
         xj6lgpruDKyqDNaX12ykylD24X7kC9Opj2+gzMM+pftRAzE4diTE7U/TbkzIwNckU23t
         xPag==
X-Gm-Message-State: AOAM533TEhcdaCm5QhSCS1+s64alGht6AA/VSCNkxbtRR/Lu9yWmjSHS
        QV4n4j8oxoDQwM+xdUhRMknlNp3Ol+s=
X-Google-Smtp-Source: ABdhPJwE0VeK14ThWnH8OXqHAvNCDa18f215m4dC9m40R6qMSTfh6WR1TPU3DDO73d/LFMwGj6CzjA==
X-Received: by 2002:a17:90a:2c0b:b0:1be:da5a:b294 with SMTP id m11-20020a17090a2c0b00b001beda5ab294mr564436pjd.9.1646847529107;
        Wed, 09 Mar 2022 09:38:49 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 2-20020a17090a034200b001bfc572d018sm164594pjf.48.2022.03.09.09.38.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 09:38:48 -0800 (PST)
Subject: Re: [PATCH 5.4 00/18] 5.4.184-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220309155856.552503355@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <1ef6fd89-6648-215d-d44e-d577e242276f@gmail.com>
Date:   Wed, 9 Mar 2022 09:38:40 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220309155856.552503355@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
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

On 3/9/22 7:59 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.184 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Mar 2022 15:58:48 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.184-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Russell made me aware of this message of yours:

https://lore.kernel.org/all/YiiuCMd%2FhLmQ7tfS@kroah.com/

do you expect to get ARM64 patches for 5.4 (included) and versions
before and publish those as a different stable tag with those
specifically? If so, would not it be easier from a logistics point of
view if ARM, ARM64 and x86 all get BHB mitigations within the same
stable tag?

Thanks
-- 
Florian
