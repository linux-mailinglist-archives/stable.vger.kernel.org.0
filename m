Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF731569693
	for <lists+stable@lfdr.de>; Thu,  7 Jul 2022 01:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234374AbiGFXvH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 19:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233947AbiGFXvG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 19:51:06 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C638B2D1E1
        for <stable@vger.kernel.org>; Wed,  6 Jul 2022 16:51:04 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id v1so6902812ilg.11
        for <stable@vger.kernel.org>; Wed, 06 Jul 2022 16:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=azufkNPmRwbrIbp+/oMcurf+3VkObt2rdfnsu3lrwHw=;
        b=ZqIfFB11n+7z1TFBbo0A8qnT25SClBBvtAYu6FWph/AH9RDV1ekgNb2VVioY5cqZwe
         Pn9m9LdVCAEgul551JaHJdvdosRqRh0IjnHV8lfd5a8pjD2wpixvwJmEVC9wNPx4jGp+
         ueuR6AbKh3aEsMDaZqIT+DkMAhCPg/kYr6yGQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=azufkNPmRwbrIbp+/oMcurf+3VkObt2rdfnsu3lrwHw=;
        b=GhvlOqD0rfNo7XiF8xpllcPX0brmDRRS2p+xEUm/3YAO9BhWZGZP9rym7Va59y174Q
         rIUSd1XhHo1YThMNJ7qnUJJRQBJrHhmXN5/lPKWBS5LtttFupPlStHjnTsgzP9SSx9nD
         oIypiwdT+zGpk7JRS5bMY+let+Rk+zJAWPdmu3oES2RTexTd9o+TEA8Xi5pJvzCrwlVs
         XiT+ZJSa8MU7k45k0cp+gu2tisoAwQpwmKuSBY1sbQ8uSNxo/oa0w7Y5gq8+lwOB3WQW
         xj1pL4z8pC15m3jgaSl/bulLUxzldRc9uEjdpGvRUt4cSh5T7Qfws+FZYNPL+OMCEBxr
         Ddsg==
X-Gm-Message-State: AJIora/l2hVRpNaFtyMiJyjM3LFSZ0rxDLZpJKHLnElSYfaNWw2RWD3I
        4eieivZpXcVjUJcwoqRFHTpptw==
X-Google-Smtp-Source: AGRyM1vID52ax7cH4ykYMh6J3cyTIdkwg+GDzCmeyr4ZUQirTvA/u5c9gULrupkdvIDbgcYEatMWJw==
X-Received: by 2002:a05:6e02:1947:b0:2da:9897:47f1 with SMTP id x7-20020a056e02194700b002da989747f1mr27346214ilu.136.1657151464184;
        Wed, 06 Jul 2022 16:51:04 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id i83-20020a6bb856000000b0065a47e16f53sm17288954iof.37.2022.07.06.16.51.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jul 2022 16:51:03 -0700 (PDT)
Subject: Re: [PATCH 5.18 000/181] 5.18.8-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <daa65eb0-85ce-d83a-8279-caf1645c945d@linuxfoundation.org>
Date:   Wed, 6 Jul 2022 17:51:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/27/22 5:19 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.8 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Jun 2022 11:19:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
