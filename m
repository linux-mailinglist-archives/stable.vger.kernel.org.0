Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6A53F7EAE
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 00:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232848AbhHYWgM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Aug 2021 18:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbhHYWgK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Aug 2021 18:36:10 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C4FEC061757
        for <stable@vger.kernel.org>; Wed, 25 Aug 2021 15:35:24 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id y128so1587678oie.4
        for <stable@vger.kernel.org>; Wed, 25 Aug 2021 15:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8umOJ4xRco1tiOVYvn1LcvlXX3cQpzvKrVzACiMJBIc=;
        b=ToCttOr5x9ajvEofZkYN+VLDKO/CsLjvdWpFG3TNveZJPFmGz0o/C37LTv7rr7B9OV
         vOvnZ2s8maSBUEhpqEUQIwROWN4RHmN2faNdL5SV8nWm3jCgIXpUBS7/9gIckZQ0UQ08
         Z0bk4frDJom7rgxxB8/IrAKE96huOp/FPV6ps=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8umOJ4xRco1tiOVYvn1LcvlXX3cQpzvKrVzACiMJBIc=;
        b=ejYt9WS1u1mt4EE3Nypixw5E/gYx682u9xpks6joxhgVbCvEeVmXy33vUC7ZpLOXUR
         ADPYgxU31cHMiR8jCo/gM0wcT1mzHDxQbNV/fDxJGzYy6dgLTgCNigoWI+JGhnYTR0yw
         mx0F39BHEoDH61j4jAJ6rmd7LTj8MCMlt7ePh6Du3oPlnf5J5JaYL8k5h4kZDi35ECOj
         pVLzoQ5ee6Ipq222yaKu7+gEhPP+tLclifreGsf89G9spx5v5jS/f3if9VXMOl9D85Tn
         ye19rVRCP3W2vLoWLJV07JCn0I87wQO4uABlpLydEIq6LgLLmRS+/Z/5ytkDSdFe0RPP
         eugA==
X-Gm-Message-State: AOAM532NU0xDWEE9Egu8Q8LodJ93C9s3w6ph3yfx1NC6i+cXdcWhq0wm
        rG70zSkEiIFwL7nf1hMwYDVqOQ==
X-Google-Smtp-Source: ABdhPJxh5KKIbcP2t6Q/dKRaZcluVdngovwL6jB7XYvLJyWJ4gmna4PbTKOoMzBP1scnPb09+GLCoQ==
X-Received: by 2002:aca:efc2:: with SMTP id n185mr238258oih.142.1629930923733;
        Wed, 25 Aug 2021 15:35:23 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id bj27sm242324oib.58.2021.08.25.15.35.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Aug 2021 15:35:23 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/98] 5.10.61-rc1 review
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210824165908.709932-1-sashal@kernel.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <a28b2170-e267-dda2-d0cd-aaae5d806925@linuxfoundation.org>
Date:   Wed, 25 Aug 2021 16:35:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/24/21 10:57 AM, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 5.10.61 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu 26 Aug 2021 04:58:25 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.10.y&id2=v5.10.60
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah


