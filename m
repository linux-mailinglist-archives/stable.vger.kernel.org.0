Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6798D4D545E
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 23:13:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244822AbiCJWOD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 17:14:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244576AbiCJWOC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 17:14:02 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0506D10BB;
        Thu, 10 Mar 2022 14:13:01 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id v4so6514704pjh.2;
        Thu, 10 Mar 2022 14:13:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OEbSQ04nyfNRXvDeQMNqKDmEQERB66Kn5CxU4dhzX5o=;
        b=M5vpwh2HbSfMc9Coy8Z4zHTJ5PszU64EO1EOUobZsMFdWPcr8T+rgjGhVcG32OZaOw
         HFmwwIy4/FxtKj6FefdPft7esEMC2GlW60sXH0u0miHbYzqALoerKtoP0EDq22Y7VMcd
         c0xPta1RwbPVe9yyjdR9RnJ+I8lnmbIcCKAqX0Ugol53kYlIhF1nPgVa/am0G7mrdQSP
         4a7Zo0sMrCNA/KElb1DorGWRtyLcbPZLrCod1pksSlzdJXg5Ou45GC9Zd7umNyp1NPKm
         XO0ouufT9EU6xIrNWm1QLE7cpyyN/WoZGHx35qPlPrGOtU7WhwEPWX435R/Tvkv8G7Wb
         G+mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OEbSQ04nyfNRXvDeQMNqKDmEQERB66Kn5CxU4dhzX5o=;
        b=lSPN9zy/BG+q1frLXuSFngFsz8s890FjZe6+L7yHWRzOwOIuZbNeM91MBtQKI+2LfL
         TRGJkUx8esQifyBChzJDWFsOrmjsj+yRSqWJ9Mo8sHnAd6VTs78FxMbEgscuy+bjZ5iI
         oOXGHqtOM1lhZkQLT2a6i21faznzkBTqpcuGqmRP/TCmDWb59wR1ri8KOCylCuSNz0li
         nXvXX7isykjoSwwWitPRGZvCOVpiEBEwc1WiTz6RyVsZzpecgjLJFrv98x7u+ZQUUzTa
         QVg4pkmYPx50zyu/MU95PZKnNyf6DxCaQeFFXPhXosM34r5JSsG7yJBxbR/1QZqe5sBR
         5yMA==
X-Gm-Message-State: AOAM532Wegm+mneTy+jE+irPFZKM0dGnTCAjkocVAuzWOjVJRC3wUQ3A
        kr0IwC9CAHXIRGymT3xFVk4=
X-Google-Smtp-Source: ABdhPJzigQ1KKLniJLT7PnvfAcdr+8HGXe1QJU9BUH50mnKGpKOCbYDWxe4rfVzcUute6ptxqEQJpw==
X-Received: by 2002:a17:90b:4ac1:b0:1bf:6d51:1ad9 with SMTP id mh1-20020a17090b4ac100b001bf6d511ad9mr18247300pjb.199.1646950380379;
        Thu, 10 Mar 2022 14:13:00 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id cv15-20020a17090afd0f00b001bedcbca1a9sm10950308pjb.57.2022.03.10.14.12.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 14:12:59 -0800 (PST)
Subject: Re: [PATCH 5.15 00/58] 5.15.28-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220310140812.983088611@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <9d7f894c-ddc6-3da1-97b2-f228993126a6@gmail.com>
Date:   Thu, 10 Mar 2022 14:12:53 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220310140812.983088611@linuxfoundation.org>
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

On 3/10/22 6:18 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.28 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 12 Mar 2022 14:07:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.28-rc2.gz
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
