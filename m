Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 578E865B85B
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 01:25:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbjACAZy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 19:25:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbjACAZx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 19:25:53 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 099E0D95
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 16:25:52 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id a9so5012830ilk.6
        for <stable@vger.kernel.org>; Mon, 02 Jan 2023 16:25:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X2bRqedDHz7W8LP/t/e8z/mJRrJLBwwXwuoJjeyrKPQ=;
        b=WRpqGYVNcjYj/JZxI+lIU5Mp/6pPnnamqt9IOpppL4UtcG4hEizNDdmi2yRzsOZFNU
         FLQy+u1qfwR6XxLwkVoe1vo01wLLgqwqDRtCQhxE/3sISiHkk4yK4IbYS8oDZInW9KOs
         I4T6fgbonmBLJSjL2p6ks+DX63wLfOEM9Avr8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X2bRqedDHz7W8LP/t/e8z/mJRrJLBwwXwuoJjeyrKPQ=;
        b=NV3YDo139ujQyX8gAsT+U9y0evqdXnNbyZstgE8ZnI8IPYpW/cPGMd+D9oGjt9pRW6
         LRyutlqfaxl0xtIsk8foRBSVWJgHAYWdy9NTtuqOhZ4YswQKSuGIaDdMKQxTviqnIP07
         JlZP4SSF3iuniI/+5mjjFYGsoOm7ZE3CLaJlT/XJCWGU37rz/jSpA9I30HyqkyHgHl5Y
         sMRjPZnXlHHHFXv3IxV5JAML8zSDi11pOkIlL0+1y6lF5gYlmjLYifSF8pkUM8koV78I
         X4vhthgmde9NU5DNpWJzdKrt1vJ3/vG61m2AuOLvUWHaaXe3pzxqahFTx5HU9XpIHbeA
         Ng3w==
X-Gm-Message-State: AFqh2konBLuHlcVrBwf30TCrkVngTmtyjLfiX+x18Vo0EBv9CKaLyay2
        s/xcM59aSgZuBKgIqDJIh6kuIA==
X-Google-Smtp-Source: AMrXdXvs5/vh8wOrYitaU6nwXH2xlsyKqI0lkqQSJoUKYXh1+FlKb3hOPwOzO8PIhXnNaOkhsJmSXA==
X-Received: by 2002:a05:6e02:12af:b0:30b:fe91:35ed with SMTP id f15-20020a056e0212af00b0030bfe9135edmr3789190ilr.1.1672705551299;
        Mon, 02 Jan 2023 16:25:51 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id l1-20020a056e02066100b0030bfd384821sm7609317ilt.81.2023.01.02.16.25.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Jan 2023 16:25:50 -0800 (PST)
Message-ID: <1978c896-f08e-a397-0949-d66aedb5ae38@linuxfoundation.org>
Date:   Mon, 2 Jan 2023 17:25:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.1 00/71] 6.1.3-rc1 review
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
References: <20230102110551.509937186@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230102110551.509937186@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/2/23 04:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.3 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Jan 2023 11:05:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.3-rc1.gz
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
