Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 079B14ACB50
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 22:29:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232695AbiBGV2h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 16:28:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233631AbiBGV2g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 16:28:36 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF468C061355
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 13:28:35 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id 15so12258063ilg.8
        for <stable@vger.kernel.org>; Mon, 07 Feb 2022 13:28:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZoPNcURKuiyBsfuMCsxFRvD+FdDOMPSZh378YCQdWew=;
        b=OGfUdsmUKUncc+L/NCjGB4tMLmfOP9i+lOscyLtUhOqDdfLLcMemwr53vTTK+aPxYs
         AntX75ynFwE3yp/HRU8o8arCFYuGRyQHC7E7nkmwWXNrVTMzwE+5pyJI1dJioNCRyVFV
         x5EUP0G8YNsOOmpwQsqQjybQo8Bj95Gy4y0aA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZoPNcURKuiyBsfuMCsxFRvD+FdDOMPSZh378YCQdWew=;
        b=lLacmCV3jrEtwYT24hTgtbImunKzpP8VuaIRHhY1vG95yMhSxafr+YgSjtTH7cJwAM
         DnqckeJE/KYMMVdZ587p21JKlqTGM1ssTp+WIZB4AsiT8qIELC816jZytS7+rgwxkPNP
         eNQxGmlrG7sw+RqR+rN7AaCi0iTDOL+Ocv/c/827xHd5ZT5YkA2Z1BnpR5i32ohb1aqo
         jKOlK4ZhVwD5Skk9zQLZKEFQpLev4o63sNwvLK0Ccclzbv98J+2nX5Jxp1+br89cf4c2
         nLAb55OMKvIEPjDLcD9g33Oo4iZzCnrQQhrEqe+0hFBhB11+VUZAinYMD5ShwDUyL8ZB
         riIA==
X-Gm-Message-State: AOAM532F8uVcVFiL+DlmHV8Lxx1B0wVn11thYmdtos0hPLF54y+BBjpH
        2Cx/PtIVIWFZxxMyuLBzgo1jhA==
X-Google-Smtp-Source: ABdhPJxK3aX2uHbIcGdwR8aV4AP7VMok1KtzstLPRL0Es6DC2dkHg2OW5pgEDMrhE8UOPQc9CA9SQw==
X-Received: by 2002:a05:6e02:2145:: with SMTP id d5mr687033ilv.57.1644269315305;
        Mon, 07 Feb 2022 13:28:35 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id l1sm6430838iln.29.2022.02.07.13.28.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 13:28:35 -0800 (PST)
Subject: Re: [PATCH 4.9 00/48] 4.9.300-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220207103752.341184175@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <70b389dd-a26d-d09b-9028-f20d44630e18@linuxfoundation.org>
Date:   Mon, 7 Feb 2022 14:28:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220207103752.341184175@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/7/22 4:05 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.300 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Feb 2022 10:37:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.300-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
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
