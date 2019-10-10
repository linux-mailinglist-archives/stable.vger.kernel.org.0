Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71F18D2F54
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 19:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbfJJRMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 13:12:31 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34458 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbfJJRMa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Oct 2019 13:12:30 -0400
Received: by mail-pf1-f196.google.com with SMTP id b128so4323864pfa.1;
        Thu, 10 Oct 2019 10:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gFkplFWsX/KWikFo2q63Yk6w/wjGYsWVVSNzNO5eWCA=;
        b=h+JBtgs598QcD4Vh9cXa7CKKJUa7TPPDpqRyTFp0ZLKK1N/E94snAeEJu32YuCdaPn
         TmioF3jiMEHYeBLKM2Dr17jD5RfiqeAsSGCFkoDb5oZugD557uVX++rOHwbLE5wsEmfs
         QAe4bt4Jdulu4s1gG4oYUDmMtohJfJrTjKfv3BfIauTmMpexkHBCSWlsVk+JzqA+DoyF
         drol4g4T4jQWCZy7pRY8dxdx2Ok0QYvJeTt5w6+YDb8qZ/RtKcL/HSv8kNJDV8fA7WtG
         cjwQLHveBuFXkZrA1AM1gNT6nmGhoWVvcxLDJh9r9y6/ipyx5zpH1LBOc2T6DVJrWXx/
         HzOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gFkplFWsX/KWikFo2q63Yk6w/wjGYsWVVSNzNO5eWCA=;
        b=NsNHRoHGsTPi2VdexUuVTzksfo9y9CsXAzIQUzadgV7QGKv1aeBqH9G7+/QomOC7GC
         46NkOUbGQaW2lupvuvXxNpry/jcrnKKZSHPmmxoaN/L/DJtbYPhpMqIXGtcUu5txYPAr
         u0klp7eoTyKd7EBngCKSCZFhY/SsXAZRxzh8rqjPjIl0wv+VUpG6nCVuJdfEhwQP4dKX
         FlG1ryWNoZOB41TAe8v0xjlLM5am7XdDhFcRpWZaejMxnvSleQ0j9aHPLlQcaCx5YSoD
         qxRswSyFFo5bgXtKmlLCUEhYadWEJMOelI8GINdZQUsVEbsvYMM20bL7Q/5+1vchAqdN
         M0ng==
X-Gm-Message-State: APjAAAUlLjocq1mURIG3iFu2KNE463EXZcWK/5tRPHR0dZonYsVc+jsM
        dledH239bl5WZKjQzalfTHJ2c0Lm
X-Google-Smtp-Source: APXvYqyWmb9MlI935Au9xB562Z4BjyaNxtRl8Jm4vtNjamdzcCfEwyyvHuImE5QDXkYzhYDszz637w==
X-Received: by 2002:a63:5a03:: with SMTP id o3mr12024714pgb.381.1570727549782;
        Thu, 10 Oct 2019 10:12:29 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b3sm4849474pjp.13.2019.10.10.10.12.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Oct 2019 10:12:28 -0700 (PDT)
Subject: Re: [PATCH 4.14 00/61] 4.14.149-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20191010083449.500442342@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <ce4b3f10-eafd-1169-9240-fb3891279c2a@roeck-us.net>
Date:   Thu, 10 Oct 2019 10:12:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191010083449.500442342@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/10/19 1:36 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.149 release.
> There are 61 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 12 Oct 2019 08:29:51 AM UTC.
> Anything received after that time might be too late.
> 

Preliminary.

I see several mips build failures.

arch/mips/kernel/proc.c: In function 'show_cpuinfo':
arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaration of function '__ase'

Guenter
