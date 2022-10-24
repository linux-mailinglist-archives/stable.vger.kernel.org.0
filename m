Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8F2960B5DF
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 20:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232322AbiJXSnH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 14:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231994AbiJXSmx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 14:42:53 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD25EA3B5E;
        Mon, 24 Oct 2022 10:25:04 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id ml12so5901385qvb.0;
        Mon, 24 Oct 2022 10:25:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=otMY0mGsX2c0wl1s8CXWBFeCiy2EMKbzlxxKVm8RrFg=;
        b=BEwMEcYgRMnmmQ+J+vP7Wri7QQxJpUzxthH4uopaFCbSq7YWEMBwYkl9HU4d6k5vin
         oy8c3n4fjvoNN/W2ZBLT3SwQK9zjTMP0feAoWa3vi9BXhax9HKzkdLS7V3A2cPsj0Spa
         RNpzGfLTChNVlc8DX8M522eIK3Xx3EbaaR1B35A8cEoM9ujsOL9TemAzMu2iw6ylR1Hg
         8Ts0IXn2FZ0ICT+yyUuBD6F52VxqyN2Fk6utz1HgGbjXZdm9+03bdT3FcmVzVdvdxoL5
         ESFYAjdiPXWdU3TZpzkl23lK+vsmCsWWTL8HrSuWOlNZt9drMdxJD8jkUaO1FB3qfQYX
         ETdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=otMY0mGsX2c0wl1s8CXWBFeCiy2EMKbzlxxKVm8RrFg=;
        b=iQR2MU/HHcm3jX8qdVOtg7Rmu6vLpmJmfpf6WIYCyOCpUm1TTU5GThaZIR36/J/tp4
         oqYnwcOiPhWy5qVTmM5S2k+FR8ZQkFsKa8pgwrNF1VgNiyuGt6+VFzdzSy6eVZuK1Pqw
         DrDLoBBJ/tgwB8jXUPHyelQHU+MW+fzSILncVMcaeqqeHuQtdcqv2GUAHyBFRkHSvurK
         WbjMRzQaoQICNYVeogpOWhxrpnK6OMsrTn6yYIYoq8qUeKugAqo3ygN6dgbTyrKbU477
         HtOTDGhU8Ak8DIenm8I96PWQlWyed0XqT6Edg4UxX9DL/38cDjQ4axznRdgkYigw3uHJ
         W0vQ==
X-Gm-Message-State: ACrzQf1H+nPyZ4S9wKovmOGFgZje4oC08NY7YIdVJOc83+fIGgvDZoLY
        MEKtHZlO00GYXkMAMi8JNUo=
X-Google-Smtp-Source: AMsMyM60bMCK40orVdWOMfL7d5Akhxv/5YZ2KJbdm5jmAQ+5C4uPYQgxrUTBve2asU7Y1ZxpEm+JXw==
X-Received: by 2002:a05:6214:1c85:b0:4af:86a1:9983 with SMTP id ib5-20020a0562141c8500b004af86a19983mr27844506qvb.35.1666632216796;
        Mon, 24 Oct 2022 10:23:36 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id m16-20020a05620a291000b006cf9084f7d0sm371406qkp.4.2022.10.24.10.23.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Oct 2022 10:23:36 -0700 (PDT)
Message-ID: <2f20fa1d-d7e6-16d7-a131-809378bcf161@gmail.com>
Date:   Mon, 24 Oct 2022 10:23:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 4.9 000/159] 4.9.331-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
References: <20221024112949.358278806@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221024112949.358278806@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/24/22 04:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.331 release.
> There are 159 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Oct 2022 11:29:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.331-rc1.gz
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

