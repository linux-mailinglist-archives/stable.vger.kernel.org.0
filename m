Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD74C3D00C9
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 19:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234446AbhGTRF0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 13:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233513AbhGTREK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 13:04:10 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA239C0613DF;
        Tue, 20 Jul 2021 10:44:44 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id h1so11781448plf.6;
        Tue, 20 Jul 2021 10:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=q3HDnuffZuJhaxgw+kTfsNGvuoZSYcdRnWVcMLBuc9A=;
        b=nG57TzCISECsz3+smnh3RhtNTXVjpYhFyX+Ez+txIPpJ81wpM0dsV4yplPL3HQr/Yk
         3zOggitl249bkBd5b2dDWYeefwfJlFoZK6s2hlDtABRJrw8v5tIlh2D0jyHrRDpk6fbV
         7SdQDuvjQcQwaxFHGV/i6ZBNuvGqgVDjJyt7k97crhu6CNk9IqqisvBaqY10z3LWZzyF
         Nku0CTZlpK12hq2jOPl5FBG2qXC3xsQuJWKm+YP3rVzB5vI7Bg9p8wrs9JgTAQIkKq1V
         nMG97yeL9MuEiKlKKA3F3G894TghKz2WsszX8pZNaJga+lIxV4tqbN/BfNkqpiDXNVFW
         1M+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q3HDnuffZuJhaxgw+kTfsNGvuoZSYcdRnWVcMLBuc9A=;
        b=c76xEckEWSwnzzIQBNHWSDkR4Jny0mamomXfp4s8zQZvZt5n5p2jKl3jYekz9BfaTr
         ZLesb9s8xVuGSaMsaQ9dJX3Ma2gu2EW1xB72wy/T62xRFP0t+ZXQn6zdBQcdppOdFsHJ
         VfQb+LmFPVRjS6zc+aPi0dv5CAdNaeMI0xXollj0lRj5TitybMFDw4WDtLm4vdUhC6wZ
         AlS80/auqFft3c+eVwnlkucWy7IXn/nMSe+Xl51QPpc8srXqyIyeRBHx37Bqj5myx0R3
         +ApIJU5xMdNsSciQ+0dgayLDxVJtpeEMcuV7qyRV4BMa1Eef58PfyBiGrwEqAezRr2+H
         3AGg==
X-Gm-Message-State: AOAM532OlQLSTtRmB4S8ZDuOJAQDcOp3Yfn1XWECjM6e5Y6eaLOf8mU1
        5XKzzEHWJsEQiAECcKJdvvgk1KRUMRAabw==
X-Google-Smtp-Source: ABdhPJxvypR/CVhx27PnzeTXOEBxyuhW/3BDWEUYY6D6fZKuLMwQNssHGu7Z/BnO2y2+yUpZa50TcA==
X-Received: by 2002:a17:90a:bd18:: with SMTP id y24mr36756135pjr.83.1626803083965;
        Tue, 20 Jul 2021 10:44:43 -0700 (PDT)
Received: from [10.69.75.79] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g9sm27429168pgh.40.2021.07.20.10.44.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jul 2021 10:44:43 -0700 (PDT)
Subject: Re: [PATCH 5.13 000/349] 5.13.4-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210719184345.989046417@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b2ae6f4d-3508-f275-ec3e-2a0cb2140750@gmail.com>
Date:   Tue, 20 Jul 2021 10:44:42 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210719184345.989046417@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 7/19/2021 11:44 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.4 release.
> There are 349 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jul 2021 18:42:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.4-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
