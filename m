Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3986B57B9
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 03:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjCKCJe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 21:09:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjCKCJd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 21:09:33 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 520431194DE
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 18:09:32 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id 4so4051266ilz.6
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 18:09:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1678500571;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=41aygJ5SYte9HSlYMkbUpX0opg3YPHib82+u9lz3ejA=;
        b=fl6S8j+9bPkRwcv3748VyAdqOgRi2yYrJq0o+Y5q7CQXGJKhGXID6vn6eqMGxmZhaP
         dtgyIc2IDGE4aYGnZyUn296FM6/zWv05oIkjyZx9fEJ0enxtYl01wp+dYenNzHLp/PBW
         8QcC5e/7EMv+TrMO6Iuu9moGCTBTbMHU7ItfA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678500571;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=41aygJ5SYte9HSlYMkbUpX0opg3YPHib82+u9lz3ejA=;
        b=uunfIWhWt2OQeBxYFYv0eYq9O9RmbMZPwKbGOAfGNAgTUZfcaGVFdQC3HzkBEh3dzW
         8w00LXHyFR5vC3etu6UIfvoi1aaI/NXcBUfYz1FyclWCww4/W5oeAl2uPeJD8ZV1GGxI
         8sfTn9xIUPvtBVgjXjzqbPSSNryDL+lldLaGbAQTGwdt+lAJkauaceUztlJCb1ACrFzB
         0lmO00U2DhO9xa2MK8w+9GOx53dmJNhrvO/jZ84yKjEfUzPw+v8tsQUhY3tMxAm5PR0N
         IKkDkN4uA0yHYMdNoPoxhPe+T85YjvbahFtEj2MlaRsi6MNMMN/nQM7po3PxWcvOogmz
         uqDg==
X-Gm-Message-State: AO0yUKVomjUGUU9Y7yy0fw0mNVHMeZ5MnbSAoF/aj/WuKVi0zFeU3vUS
        gq/7jZppRV+aldzX4JAF6jY6wA==
X-Google-Smtp-Source: AK7set/ocK1dzDSFKqceBiea/2d8FPc3KoKV6Fxj/GwJVl6n80Z9kz+55zJV4TZNa0y2TqKCkYjrkQ==
X-Received: by 2002:a05:6e02:1d16:b0:316:ef1e:5e1f with SMTP id i22-20020a056e021d1600b00316ef1e5e1fmr3214944ila.1.1678500571693;
        Fri, 10 Mar 2023 18:09:31 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id p9-20020a92c109000000b003109f26455csm461229ile.55.2023.03.10.18.09.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Mar 2023 18:09:31 -0800 (PST)
Message-ID: <9621762e-0594-9076-42bc-86521dab6312@linuxfoundation.org>
Date:   Fri, 10 Mar 2023 19:09:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 4.19 000/252] 4.19.276-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/10/23 06:36, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.276 release.
> There are 252 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.276-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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
