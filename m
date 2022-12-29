Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9B2659323
	for <lists+stable@lfdr.de>; Fri, 30 Dec 2022 00:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234009AbiL2XYV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Dec 2022 18:24:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbiL2XYU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Dec 2022 18:24:20 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C82598FFE
        for <stable@vger.kernel.org>; Thu, 29 Dec 2022 15:24:19 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id y4so10436617iof.0
        for <stable@vger.kernel.org>; Thu, 29 Dec 2022 15:24:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EKWr2Oqn4+KbfBpOg8OfYaJAhn+fXb/cSvl2sD2pWvw=;
        b=G1OO+7KSmmiwUcrRssIY4eqX3xS5Y4JnvkJMYoE7vkNc9EHanx+JhRTYAJtjvbg3Z7
         vdRGHr4aTZJvVzCwWauWUHn4HVRp877G09OkfQ+ChYHZqOMJreKkoytpjJpzdXXUerV/
         LXHdIAo5+svAlhbFA1AgVoTrl6V0ef4mbfLhA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EKWr2Oqn4+KbfBpOg8OfYaJAhn+fXb/cSvl2sD2pWvw=;
        b=1QcbWzsJwzxSOYR6j79Bld3ydKICXzs7WKndv+yVqMgensbstG7Oi1muv576PPF4DQ
         HNCexjBzF2fTvUdFl2O8ENu2fDw5ah9XCF5lkiUZnl5lfVLMXuBTNs4xlzH5rHriDIsi
         5IEpoHC7/YrJijpQnxAsy2CwBzSxMNBDeE34GCBaCc2/89DHulDHbKlTlkHxfYby1UAb
         jYVOOBylhRiUALe3eOC0VU5CT4brnAbBwfs3QXD8HodI3LMPeLDGaP75JwZhN1WMaATd
         FdeT0XnWgpnsF0PhEvrQ5JFezvmX0iuWcj3/pq9TtQePbeoR/r7SVGUhHnALArlfQ8PB
         77vA==
X-Gm-Message-State: AFqh2krj+WssB3kA7fM6Nh2Jb7bruIo+WjQa+48jwJEdpUdIsI6qBSEH
        n6IFaIxWdV43OwIC3EXcOMM8Mw==
X-Google-Smtp-Source: AMrXdXtlKlZSAuUaSVEw7pdrAhUjFDCakVbS0qZBml8qKztAB2FaGTxtccOMXkLmUJaUZ7HThFJ04A==
X-Received: by 2002:a6b:e812:0:b0:6f3:fed4:aa36 with SMTP id f18-20020a6be812000000b006f3fed4aa36mr2749575ioh.1.1672356259094;
        Thu, 29 Dec 2022 15:24:19 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id u5-20020a5d9f45000000b006884b050a0asm6983365iot.18.2022.12.29.15.24.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Dec 2022 15:24:18 -0800 (PST)
Message-ID: <9cfe1554-a060-8966-844f-52a7c9cf4bd2@linuxfoundation.org>
Date:   Thu, 29 Dec 2022 16:24:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.1 0000/1146] 6.1.2-rc1 review
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
References: <20221228144330.180012208@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/28/22 07:25, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.2 release.
> There are 1146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Dec 2022 14:41:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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


