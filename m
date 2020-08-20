Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1980A24C8DC
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 01:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbgHTX5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 19:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726962AbgHTX4M (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 19:56:12 -0400
Received: from mail-oo1-xc42.google.com (mail-oo1-xc42.google.com [IPv6:2607:f8b0:4864:20::c42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43D69C061346
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 16:49:34 -0700 (PDT)
Received: by mail-oo1-xc42.google.com with SMTP id g1so810030oop.11
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 16:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oZUvMXwXY9bt259tMB/dgK87KeJSN3Vs01nZPdrO78A=;
        b=C9+RYfwhiHcu/DG8B5Y4xBoyEXcisNFMzNg4zMWaPkGdq/mJLj5HuMz76ui+ED1IoZ
         ZvmQrO+I//F2J2LvXcQq7b/EsfnG4VhxHk5wLA7HRZ/3TbUGDVLN6iFnv2WbNSQNPTJU
         b7utLb5kooAMaJC6TVQ2n/lJ8EO5UTkN7ksEU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oZUvMXwXY9bt259tMB/dgK87KeJSN3Vs01nZPdrO78A=;
        b=XjszVKki3US/ICrMyy16B6dyrjVxsXzk+S3899poqCx6NEM6+xSkZWJhA0deo0fVrJ
         I4ZhNeeluw5Xl5jGxjI/gM4D/KCK90usY8aXBFyGQ46snPAqDD6q5SBgHqFWAzfUfkmG
         6oL7aTJEAOHWIv3IZxdCjTKrlti844Ie8sTn6+oZlnCN+CoUMk4AtvDS4cWyTYtHnkMa
         55nxkV3wqvH6zLVxXtgBGU1RQSSg64CjdLo4wZaixPpECrD1ay1QorwHRFU5uL2WijaH
         xfWe8iuO5sVjSnW1JRWmTinKLVGCxTpb4ZpiZv+PI4pRm4Wo0W2BAYJUbDCzQovJOYEX
         M7SQ==
X-Gm-Message-State: AOAM5331fpMCbC7DLlL9fxiptg6n1pp/r7cz9xtFsKNhnKT8oxJ7avKT
        zcJhTTD5J4J9d6ZHWLVm3X9aAw==
X-Google-Smtp-Source: ABdhPJz6OO9q7ynYl5AJf7S8zZsBQqOYtZKomeZK0jBP8zpo+ipyqidMANn5GTuDtuA7RM3M1+v3rA==
X-Received: by 2002:a4a:9441:: with SMTP id j1mr188845ooi.46.1597967373707;
        Thu, 20 Aug 2020 16:49:33 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id n74sm15785oig.54.2020.08.20.16.49.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2020 16:49:33 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/92] 4.19.141-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20200820091537.490965042@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <9f2a64dd-3ddd-4559-aa37-c11265538dc8@linuxfoundation.org>
Date:   Thu, 20 Aug 2020 17:49:32 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200820091537.490965042@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/20/20 3:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.141 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 Aug 2020 09:15:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.141-rc1.gz
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
