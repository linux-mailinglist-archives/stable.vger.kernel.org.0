Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2A76526EF8
	for <lists+stable@lfdr.de>; Sat, 14 May 2022 09:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbiENC75 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 22:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231548AbiENC70 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 22:59:26 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00BA1389B30;
        Fri, 13 May 2022 18:22:25 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id 3so6892985ily.2;
        Fri, 13 May 2022 18:22:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=67GP168P+hN/ssTeYEMLrtAfHM65J+cVfzRzQLLyya8=;
        b=eszRmVdCzSebdghf0JbUqiCSHp1Yx/0f1hYR2Kw1QzBnVjRhZfpX/o5gxbOSyld0yq
         SWqiuszl2XyX2axPP6WPhhDS0pqwfwg3sogffqfHTKT7luNfmTeosynWJWV+wZ6Cu8ng
         fW5CfYtVvjVugAOMzNq5PfMvXWMQY9NEWvEYjBEiCPokFWhOA3wcYPcI+yE4pQr7NvgU
         WTd6Z0mYqdD34/6hGsaRam/CBW8FRvoSnuo60qsWkkSWNSGnqkgnoN9S532wDLhABTtr
         PwCIIaPewN5f7LNqZ/kmWoyCSEqzPxKNLH/VstNnbhUahkM61sddWwRuyA+LsgLQJdXn
         5VzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=67GP168P+hN/ssTeYEMLrtAfHM65J+cVfzRzQLLyya8=;
        b=cFgaSeP9QXjB+mfl8SzyhaWjAQU2qE8uWh63LHZWKb3VCNkgzL3MGEYAP0qSmifY48
         Wtf7nTt68Y0SdUrpmEEwXBUpR/G86A44CY5bqRh7vAFrkdLiSMq73NtQAo+OhfzmZqvJ
         k3PRQgMipFPxJq1yaQKELS+Mjh4gVE5rsdEQ0Am17AomokN17ZZuzeFTZTkoh3ofoymn
         xw8QhqGm5t/+nbYbTZk0oorL5/gA4UmAZE+7luya/2/it7JwCNZk4y9HUtCHR5YBH/aO
         Lm/crrO77YZLhyQ7FfPI0zeKPa1U7Q8zrjBbNygPGTFcgJJ8tA3g0kbMh+xZmtFyj/hz
         E+fg==
X-Gm-Message-State: AOAM531nVcmHm6qnUq+z3OPqsUcJL2SfwuLalTi5LxoL9n+Niv+Ll0va
        1UykV3abuhk6jZQFFqkDYevLM421mvs=
X-Google-Smtp-Source: ABdhPJzqqWSNPJV15eq1Iqxa8q0UYnaWDJC1IQR0sGesXJRBWEXfZYlg0xjkbQhvp2iMFtfdHa0jNQ==
X-Received: by 2002:a05:6a02:105:b0:381:fd01:330f with SMTP id bg5-20020a056a02010500b00381fd01330fmr5791393pgb.483.1652487049545;
        Fri, 13 May 2022 17:10:49 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id t5-20020a62d145000000b0050dc7628143sm2294159pfl.29.2022.05.13.17.10.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 May 2022 17:10:48 -0700 (PDT)
Message-ID: <5f27e87b-78e9-68c0-d776-e3bc3a54561c@gmail.com>
Date:   Fri, 13 May 2022 17:10:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 4.9 0/7] 4.9.314-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220513142225.909697091@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220513142225.909697091@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/13/22 07:23, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.314 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 May 2022 14:22:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.314-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
