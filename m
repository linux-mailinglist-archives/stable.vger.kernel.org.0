Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43835502D10
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 17:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350086AbiDOPjq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Apr 2022 11:39:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355927AbiDOPiR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Apr 2022 11:38:17 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5205D3B287;
        Fri, 15 Apr 2022 08:35:41 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id o5-20020a17090ad20500b001ca8a1dc47aso12065866pju.1;
        Fri, 15 Apr 2022 08:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=9bXHH0l+tz0VBMaePEudc9a7Sz7QmbB3aIYivqju7Dw=;
        b=L9phSgW4sQxIe2PQ24Ubkjg8xsBECRdeYaJibMQ6FXnZNlB5Od0qbuGoGCvXqHpqpz
         vDFWUL+tJwDODl+g7lox8Vyg+0TyPZxKKyGhk0Tyg7qQFu0raX1/+H5fTQ6t2kGKsUZC
         v8zI4kj3YZMlps2LThodMhXmJ+JOW+07BnGwOhrO7XESGUj/qK3u2jhFPCbIAKWey4DN
         gjwBgZwy3zd1qnasenZvs/QLjlVBVu2m8CmSXQSi8F0CjmVbnYW3HPGZ3NYQGz60vTUI
         Mb4zIQgJsXsmDUpG3A5+gdo8P+E223LVxwf/CtRE88n5z8uULkCMnUnkmBKpHcfQO1lM
         2ojA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9bXHH0l+tz0VBMaePEudc9a7Sz7QmbB3aIYivqju7Dw=;
        b=wF1jqHGZeZtVwa9ZdFj+O+EsQ9FsBzByRyW1URvHweLDnY182u70kk1x/UYI8MX3jk
         3MOBTUFOQhbE9zCwKozWc+4rnlNOb8H1m7epzacoIluDoaxbo2F3kzakn7DfRqUT+Z8C
         MZ5Td88WEBaDZJIy5+1eIPTSjE8B5oCwtCTohCZkgUkKsLwN0VGacAA8PH0nGX5+F3fg
         VcFDz1wvb3uqalqWGLjB2BEf1Xf2BKIFY6WXFLxxVf+0KG7DcgrIKovhvldjufgygHS7
         nGTMDEMjbyqM5ZSS+cVUwnxcbwF7OwJ6A4N989i3V+pVIwjSL2NwnlGTnEmwPPSkWz3X
         GARw==
X-Gm-Message-State: AOAM530reV9dluRD/7ZVNo6QHt9XAL4v+YLJZjlqgpRe2nOVK7HdQ0A8
        9iSOOmqyAnpKnTaBCRBafPM=
X-Google-Smtp-Source: ABdhPJyXbKEnVBoHg+gPIRp8ZyglmrYLkX+7u+E/WwxXb5Ep7LCaFTbFx98GwgE9//2MtlmcWFJdUg==
X-Received: by 2002:a17:902:e9d3:b0:158:8521:1e8f with SMTP id 19-20020a170902e9d300b0015885211e8fmr18865907plk.82.1650036940787;
        Fri, 15 Apr 2022 08:35:40 -0700 (PDT)
Received: from [192.168.1.249] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id j6-20020aa79286000000b004fdf02851eesm3193421pfa.4.2022.04.15.08.35.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Apr 2022 08:35:39 -0700 (PDT)
Message-ID: <51328779-1a28-ef82-6847-47e45018647b@gmail.com>
Date:   Fri, 15 Apr 2022 08:35:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 5.4 000/475] 5.4.189-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220414110855.141582785@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/14/2022 6:06 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.189 release.
> There are 475 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 16 Apr 2022 11:07:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.189-rc1.gz
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
