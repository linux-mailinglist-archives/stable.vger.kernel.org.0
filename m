Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59B054DD09D
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 23:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbiCQWS7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 18:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiCQWS6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 18:18:58 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5444F3A42;
        Thu, 17 Mar 2022 15:17:41 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id w4so5580521ply.13;
        Thu, 17 Mar 2022 15:17:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=u67mlsAXienNJbjA1K4Up/3jKdev0UtOsvojY5N2v+c=;
        b=MvTFWt0GdexJeJwp3RzA1CULnksX9odWe0/2yFbSNF1pNDZwe1XtVGjCsN6VWy4pAn
         94AAIVO//mV5IgO3kpuUxpHuGnAOO/2fCmTuKnkGrHSFlqPSkj9iLio6yD6XrJyrCr+V
         UZkn2iY2JMc7BPIqYL/564GNsxHeYGgpll38Y0Dr9oVWHQPv4x+StOuoAsZ873fDgM/7
         AtJBz+VNKPSksnK5NIEt5XD15xrI4WPKPmPZmoX0X83Wc/nZGD5KuMtwtcszPwtrM5Jt
         lSDi3MIkNgugSD2KFzOmapJj4uaI7RCCFjSh2/btIq7NhJhKjBvKW0GEVpJDxCFfHrE7
         1ftw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=u67mlsAXienNJbjA1K4Up/3jKdev0UtOsvojY5N2v+c=;
        b=clTN0XWi4HXCSFK42iXVMZELa0I6kxC8QpF0WtATJ2CC2H5z6HFSmOhFrYQTBPhG3r
         Kgg6TfGJ5SZuXBjOzB6ZocT3QePfmC5h9ebrzI4PDW4nAxvfDfJczDgVIzggdzANXs5a
         cfRI6QyTy62N5SEb+ytFSxXwkVrufs93eXlbqjprM+HJ+UtSrKunSCa95k7V5LG8L92s
         M00k3q68MSKTXCngpaXXuBmVBYEqxQMWSk5H5/0DDnLauCpfscity/bxS2iZ4GGfkBWg
         t9ZGS3IpumgvCh6FE9hQZ1Rgypo1r1ZIu0Rnu8nBz3wdag9wZwZScifCCqJ3UP5DFJA5
         LMbA==
X-Gm-Message-State: AOAM5312k10/OiJ4615tuqr6vSDvQqWN4PtOq5Rp8vcb3gRqUwsdKpvZ
        +id/vWUE+YuZZ/q+2PWNyQB0z743Soo=
X-Google-Smtp-Source: ABdhPJxJ9ZWoUcHW/JAixS9O0eqNQTrtD/qALlEirnDDlzQnu5Zc8sxAyjjTWNgRCaKEz8e4kphmWA==
X-Received: by 2002:a17:902:8d8f:b0:153:6546:2530 with SMTP id v15-20020a1709028d8f00b0015365462530mr7223109plo.81.1647555461172;
        Thu, 17 Mar 2022 15:17:41 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id l2-20020a637c42000000b003644cfa0dd1sm5918388pgn.79.2022.03.17.15.17.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Mar 2022 15:17:40 -0700 (PDT)
Subject: Re: [PATCH 5.16 00/28] 5.16.16-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220317124526.768423926@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <37c2fb44-eb26-2b97-e7e2-7dd58d6cdb44@gmail.com>
Date:   Thu, 17 Mar 2022 15:17:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220317124526.768423926@linuxfoundation.org>
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

On 3/17/22 5:45 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.16 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 19 Mar 2022 12:45:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.16-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
