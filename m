Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E69A06B57A1
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 02:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbjCKB6I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 20:58:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjCKB6H (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 20:58:07 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D081013D6C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 17:58:03 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id h7so4047753ila.5
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 17:58:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1678499883;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z+H3HCPd5E7nw2uSbGAh1Pef1+Hjjcqki3cPhopzRmk=;
        b=GEpKUd4vAMIPV3Z0JM2tp18C5r02HPi8MM+cCth7D16z6W76CIWTdiLz2vo+jACT9x
         9ZbJWzVrupD6lnsDPYgBBBnGmoKb1eFMQZmy/kl5C4yuC3+c2TWuN4qYeND0ebQ6aGoM
         sf/dBWX8MXoCFxcN/hY19EAQkSU1aI2D9bRKM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678499883;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z+H3HCPd5E7nw2uSbGAh1Pef1+Hjjcqki3cPhopzRmk=;
        b=nZrs+1Ut/sF1Sv4oFE4QOyknNtg8vhHgUiB0duFLw/eGH1hHku5MiJfb9kvVEHebMt
         50DP4Em8xOIzu+HsCx/h7Dru6I2c+YQmGvqf0zuu/EwmbO53mTGDW+uE5ehGvTnEigEz
         c6z6F1A8rSAFqQbpdYdlB+YcKbVnaByPWslV8+EgPESjRpi8vrhNMv5sf3Jr0zWaREMU
         9mMdP+xWp6+H4Y+LEctwbyqm4waOArbP++0bTvWrw/L6kDgwJQY5XMr2PrMWrzD1mVdQ
         Wrv5LEXLH7hKMLZ9pthdFxBW1nWD2JQ3W8q4VHP+9gDRYGz4RRfItce3zqKWfkhrh5Uy
         YOew==
X-Gm-Message-State: AO0yUKVPG8jziWE2ZlpiL5cw1fccERUNh3J1HaWllXdQuxrW2FzPWyAI
        XP+RBc7gE0dl0vuguJQ8pY+Hsw==
X-Google-Smtp-Source: AK7set9ACxP6ymCmjEt4UqUFQ8WeykznCyv9URI3xbgqRkOk94wMVPqR7lLxWMl5jRyY9hhM4VNsng==
X-Received: by 2002:a05:6e02:1d16:b0:317:2f8d:528f with SMTP id i22-20020a056e021d1600b003172f8d528fmr3214658ila.2.1678499883085;
        Fri, 10 Mar 2023 17:58:03 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id c15-20020a92d3cf000000b0031df789038dsm472473ilh.7.2023.03.10.17.58.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Mar 2023 17:58:02 -0800 (PST)
Message-ID: <3e59f7b6-9763-3caa-557a-b1dd3afbf244@linuxfoundation.org>
Date:   Fri, 10 Mar 2023 18:58:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 6.2 000/211] 6.2.4-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
Content-Language: en-US
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
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
> This is the start of the stable review cycle for the 6.2.4 release.
> There are 211 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
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
