Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8FA723E239
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 21:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbgHFTbF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 15:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725998AbgHFTbE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Aug 2020 15:31:04 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A41FFC061575
        for <stable@vger.kernel.org>; Thu,  6 Aug 2020 12:31:04 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id z18so16611374otk.6
        for <stable@vger.kernel.org>; Thu, 06 Aug 2020 12:31:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GeRu59tlMk1gr3XfJOJEPZ16YIlB7a9bT3FSbDrlFNI=;
        b=PN/ZVzhUkybgP1iS/3pgofGQLIstZowSVGWyaA3VZLSQACZ1ltUjBTxAldLU/9Xmr3
         9360LjGBU4FLmna/CBUYITDmAW0HLyhVIy4kR08/3/5W7WQuJa+75XnfE00Re/vozRn+
         AiRG3+y6siXSY7Wz301LjpU0jWSHjvwwymRaU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GeRu59tlMk1gr3XfJOJEPZ16YIlB7a9bT3FSbDrlFNI=;
        b=GUt/+mpXXpPhfCUfA+ewx52HloQf9V2mqM8Zz4ZPEShJzjcahDOfYMed3atuHH+8Tw
         W/UGyIYsjxJUSuAlfGyMsigFm9iJuzp8Sh5YzRv3TTt1ChCsJixOxnq6H0iVgPLhOU72
         AR5TCE6ROVlq/NhqGKmEqB33hmMGtjH60+70/MM+5CiFirbXu31KS5OmssMNvLFRfEb/
         xEK2wvpy1d6tglmA+te+MvwMQQS6xFkl+CvzOVPKZfkaT5wcIU8mAGPvT9VPsoWpXXYo
         qlyXx3PH73l1d/CEVNpjegrFaypQtW/w5zWX8clSL3/JTFEXetlIr/DljeUpWTf410ei
         03fg==
X-Gm-Message-State: AOAM5317SmqzM7yWFHOas6r6HqwRguSAHtwQJOYCKtLWDE8HeOSzSbdw
        U3qmBB3RSTqKJy9vGSolaIjLRgU6Z7g=
X-Google-Smtp-Source: ABdhPJymGxB8cteoqcTajGgZEwlxw18mQJaEqCGCcgB8dv+BIN9kMCgkhniIyQ83D6CY+yWzqkMOcw==
X-Received: by 2002:a05:6830:56a:: with SMTP id f10mr8272484otc.247.1596742264014;
        Thu, 06 Aug 2020 12:31:04 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id p64sm1266995oih.39.2020.08.06.12.31.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2020 12:31:03 -0700 (PDT)
Subject: Re: [PATCH 5.7 0/7] 5.7.14-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20200805195916.183355405@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <fb676589-8646-0120-d743-a3744663326d@linuxfoundation.org>
Date:   Thu, 6 Aug 2020 13:31:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200805195916.183355405@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/5/20 1:59 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.7.14 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 Aug 2020 19:59:06 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.14-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
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

