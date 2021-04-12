Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 417BD35CEF8
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 18:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244574AbhDLQyG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 12:54:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50209 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343867AbhDLQuW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 12:50:22 -0400
Received: from mail-wm1-f69.google.com ([209.85.128.69])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lVzlB-0000ul-P7
        for stable@vger.kernel.org; Mon, 12 Apr 2021 16:50:01 +0000
Received: by mail-wm1-f69.google.com with SMTP id v65-20020a1cde440000b029012853a35ee7so1497704wmg.2
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 09:50:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2zPLG+73TKJr4dlw0cIaFEEl9n/wh4UyqgMutT/N1S0=;
        b=QCoRAheA/IlqmnyZab7cqnsXSrJUYAKT9waIWuNgeDKTakkbzIf+gW/3AAgHfxYV98
         4n2ZXF+j7TCIIYDRbi1sCBh+iPA1bO+Ryf6h68kBYGpYsfj0JQ1pS01jUIBHBo5WMS3/
         LrWYWXqhukQ5UHD/kG6lCYsAAlNRruM7MPUaTtWqxwpWRxJHQGcRoptGPzNo1nM2QeoT
         WUnBvyLsw0mwQqmrTkm+AqbcxdTgo6PQkggoMnQVh1V+I/lejRIfH6/TvLrYR/Wwy97a
         Dk+4XEAZ+p6DgUaxPTF6MGNcE6uJcNdC1K17I1fVv/qcv1yVwEIKkgL/pc8yVDDOyEmL
         pKVA==
X-Gm-Message-State: AOAM533yn5wVFiy6jadg1DoZA3mvHKttheojPesmoOGAbic0dWRtXaoz
        ld/QZKfZREzaEv/NK+HKlvBM1paoghgfvZWArQkt/RSjAGHg22QC0xHMrDEV3LsCAEhb7YM4xb8
        uV+ZDnDFw6OcS9FVgUQodEa1i6BUrDJ4HRg==
X-Received: by 2002:adf:fdcd:: with SMTP id i13mr17772180wrs.185.1618246201156;
        Mon, 12 Apr 2021 09:50:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJygAkOubK8yScd9gznsmyE6svsoPN5jCJREMKdSVaKsNv67krChoq1OI9eneBff88eXscM0lw==
X-Received: by 2002:adf:fdcd:: with SMTP id i13mr17772177wrs.185.1618246201065;
        Mon, 12 Apr 2021 09:50:01 -0700 (PDT)
Received: from [192.168.1.115] (xdsl-188-155-192-147.adslplus.ch. [188.155.192.147])
        by smtp.gmail.com with ESMTPSA id g12sm8375299wru.47.2021.04.12.09.50.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Apr 2021 09:50:00 -0700 (PDT)
Subject: Re: Newer stable-tools
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <f6ad8f77-6dd7-647e-5d4a-983754ba8442@canonical.com>
 <YHRzlIXXLUzfV0WT@sashalap>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <5e5195b3-a2e9-471e-cbdd-0951f13ecbb0@canonical.com>
Date:   Mon, 12 Apr 2021 18:50:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YHRzlIXXLUzfV0WT@sashalap>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/04/2021 18:21, Sasha Levin wrote:
> Hey Krzysztof!
> 
> On Mon, Apr 12, 2021 at 12:58:16PM +0200, Krzysztof Kozlowski wrote:
>> Hi Greg, Sasha and everyone,
>>
>> I am looking at stable-tools from Sasha [1] in hope in re-using it. The
>> problem I want to solve is to find easier commits in the distro tree,
>> which were fixed or reverted upstream. Something like steal-commits from
>> the stable-tools [1].
> 
> You're probably looking for stable-has-fixes :)
> 
>> However the tools themself were not updated since some time and have
>> several issues, so the questions are:
>> 1. Do you have somewhere updated version which you would like to share?
> 
> So I've cleaned up and pushed the few patches I had locally to that
> repo. It's not that it's abandoned, but rather it was working just fine
> for me for the past few years so there wasn't anything too big done on
> that front.
> 
>> 2. Do you have other stable-toolset which you could share?
> 
> FWIW, Greg has his own set of scripts: https://github.com/gregkh/gregkh-linux/tree/master/scripts

Thanks, I'll try your changes and take a look at Greg's scripts.

Best regards,
Krzysztof
