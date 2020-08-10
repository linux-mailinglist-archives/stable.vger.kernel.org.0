Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02E9624139E
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 01:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbgHJXMz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 19:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726970AbgHJXMx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 19:12:53 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD215C06174A
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 16:12:51 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id v6so8651155ota.13
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 16:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SU7C5n0mjZgBQ0rPDuKYOoV0ucFHKRmKd1+rkblTeo8=;
        b=G4qB9y699W6Tzpa3363a9KER4rMzBEBY+csm7xk7oWiMyr3KKdnEmCyH01yCtjRcpK
         eJJepQSDtDcdUPCfyZ+Fx9Yw3xgTZnfsX+1m6GR9i/rxemYVGo2EtxgMkkAP4j0Q/DtP
         52R0G4RfPd7nuEYCIESOhV1rF2kpoOOLtlksY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SU7C5n0mjZgBQ0rPDuKYOoV0ucFHKRmKd1+rkblTeo8=;
        b=c/AKOuzr87y7jSo8I7h4n1LirGxxaxmZrDxjqXhgIvkU8izrddmYmaJuASQgX+fdFv
         fPSBXrB5He/gppD4JSAeKrt9L7kgy1eqsbN5Poo/jPDeM4dmefxTwAlk6w4ModotyLFK
         G+tmvxJy+ZDUKr72NhGudWZ92KpYPALitkD+qRNZzIRX7BpiLJjzwf4NrIwbdA7HsxE1
         EQsh9/n+U1G3FNJPNzY5GS9vLqPpfude32X8o4CLfsAdVxJ3g9CmE097EY46VntgmrIl
         KjlrPAFauH2y3M7lCjAJuxN/YhqaUAgq4Mw8a9DbAub/GXeWi9Y2LvesZxZelsVOU9h4
         vsgw==
X-Gm-Message-State: AOAM530vIKTGsCeYxpybzYXP+fDb3VICl0Y9jQfbXw9aTT/ApiZSTUtG
        zDDAw9dsB2dfY42JElc5/kq8+A==
X-Google-Smtp-Source: ABdhPJyIzznkB3XtO0QPID7PAzRM5l8q1dR2dWWHNIjl2NGwXaermQjcy/s51YfWoC2HyFbVKRmIjg==
X-Received: by 2002:a9d:7405:: with SMTP id n5mr2782246otk.286.1597101171176;
        Mon, 10 Aug 2020 16:12:51 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id i10sm3945874oie.42.2020.08.10.16.12.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2020 16:12:50 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/48] 4.19.139-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, skhan@linuxfoundation.org
References: <20200810151804.199494191@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <abdf0790-e2b7-c36c-ab0b-b01e4df817d3@linuxfoundation.org>
Date:   Mon, 10 Aug 2020 17:12:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200810151804.199494191@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/10/20 9:21 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.139 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Aug 2020 15:17:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.139-rc1.gz
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
