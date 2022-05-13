Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3E1C526BA2
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 22:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378000AbiEMUfg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 16:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354983AbiEMUff (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 16:35:35 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D6C9627B
        for <stable@vger.kernel.org>; Fri, 13 May 2022 13:35:34 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id r27so9959475iot.1
        for <stable@vger.kernel.org>; Fri, 13 May 2022 13:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0FWkbZlVZ8+ZAk9MOWvn/sjCHmkOQjoLdvsS2FrREQQ=;
        b=Ay3nmlQmcTyckFsXET+z9Glc/oA3PwKjsbpGufKNaP6Oyahzz4QdwE1Pu9uPuKY+eZ
         VrgtHDs5X4wwGxdsWGV64Zq3xw/L4Qwq1oiPitnjsfWlKnATomrKRRMG/Ad/MO+KOR/S
         fVZ6UiDKq1wfHiSDPWf+tU64lhaOg9pFmfiLQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0FWkbZlVZ8+ZAk9MOWvn/sjCHmkOQjoLdvsS2FrREQQ=;
        b=khtFVpUqZkuaPtT6G6CFBKZjDUGqVDNAksaRshbLn9m9Sk0ZkRcgrBqv9n6Tx0/tT1
         PGVE8Cnfaz8GV5m7xNXxT+GZv/4ibLNIWz2Mt4CquDBu2VFAbt9Ct5tCEsoa74NoZobR
         MyXJqb8DeOuRpLgHrvlAhMkid5RkO9Iibe0RWS9a1rJxSNw47MdhZ25Zyf7tK7zB3zjZ
         icdbJ4kSe5qE5V5RR5JjKa/U7z35ldDjP0s3g28AkTBJH9eUytKWb3u4Aslg2nMUYA2s
         B3NiX9WKok4IjdGSy3EWfMAbRW1B6l9MCugRS8PG4X5bGN1cUOVjZQbPYfo/Rcb3cAOq
         pc9g==
X-Gm-Message-State: AOAM530tESKWMqiD8DM15LKTssmeKrAldjn0JKkqwoZCz1GxROCPMOwo
        sHRT0EpBt0brRQ1cu45zXA38bw==
X-Google-Smtp-Source: ABdhPJyOzuutlyP4RjHe4KUSOwomzY6geZDQX2GVk58T0PTagNM6Q5VWE+Ecc5U7ne/cNCPeGiAGRA==
X-Received: by 2002:a02:cead:0:b0:32a:ff4f:99b6 with SMTP id z13-20020a02cead000000b0032aff4f99b6mr3608230jaq.173.1652474133485;
        Fri, 13 May 2022 13:35:33 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id cx8-20020a056638490800b0032b3a781782sm923180jab.70.2022.05.13.13.35.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 May 2022 13:35:33 -0700 (PDT)
Subject: Re: [PATCH 5.17 00/12] 5.17.8-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220513142228.651822943@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <c024e984-656a-a49d-e1ea-dd46eb00682f@linuxfoundation.org>
Date:   Fri, 13 May 2022 14:35:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220513142228.651822943@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/13/22 8:24 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.8 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 May 2022 14:22:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
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



