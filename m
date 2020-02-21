Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F574168014
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 15:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbgBUOWh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 09:22:37 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33039 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727096AbgBUOWh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Feb 2020 09:22:37 -0500
Received: by mail-pf1-f196.google.com with SMTP id n7so1294897pfn.0;
        Fri, 21 Feb 2020 06:22:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2/IamDH/mtHsNqby1ZwnFXi7BQZdjG+nXNoAha0VInA=;
        b=CJHFTM42Ml7uYcrJxBGS64hGqhjQJRWH2je59qF4p4SGxO2oZf4/MccPWSPsJ3Zp2s
         RHCXSfAhZSrR3ksyh19nhWDhVek2c1JfsYaLFiCcQivJ/YakaUDtrmOGPtyonTsMJKm1
         qmcK5PqOE/3G95ciYJ+gd0ETtJVJThR1C4GsnYTzdoSXAGvz/iZVC3sfB/vFYjGuOFYC
         T2Ql0P5dr5JqPjDIZ9dWWJ4pvS6x1Lvlad1GuAugsZJASin9abk36UjErpjnS1sStfe3
         V5iW810KLF+n2H3ayPWz0zpJRFwikNJ0yBvbKJmW/zCuVJzilq+amzMuvMqryE0HoqTY
         SueQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2/IamDH/mtHsNqby1ZwnFXi7BQZdjG+nXNoAha0VInA=;
        b=Vy6QDKo13I0RdNCH4eCBB6NG15mvCiL8oCf5EvyzE/C1uMfrzRM5Odux5WzWDPEtKH
         wEb0TnasrR8vketfeaNUoORw4NHWJEFr+sXX68apNZtwPupOIgDnJ76w/rmJ+kdME38d
         3jVlWv3wit8RxENDv+ynGR03Uiut/PDVqaJAGmxW5wo790ck7jqjmTdfwGgETay42uHI
         YQvVk4al6Q/9NQ4D00bl1zxNnMacDEDAg8iccv8TriAjDlW+Bhxjz9qqjqCpcuZshjoS
         KevovLBfkKk6omlB6J488WSirkNJ0KsFjokO8cpx4gCBPv/mXAmPytMb6kivAZlxho56
         CLKw==
X-Gm-Message-State: APjAAAUD/vtsDjCuhtr0wn4qjBdSouevk/tUxHjX02oMQ6RfVibjv1Ry
        TpNC2ioPp+NWY/uUd4cxQdJ4BPKl
X-Google-Smtp-Source: APXvYqyTtkxL9g+5f29bei1JeFyLDYsIxwx5He88ws/0SiC2j1CITerwXPTHx8RU9J5XsgaVg+8kig==
X-Received: by 2002:a62:fb07:: with SMTP id x7mr38015384pfm.125.1582294955677;
        Fri, 21 Feb 2020 06:22:35 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l13sm2854965pjq.23.2020.02.21.06.22.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 06:22:34 -0800 (PST)
Subject: Re: [PATCH 5.4 000/344] 5.4.22-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20200221072349.335551332@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <45ea9919-8924-fd56-6c78-3cf7f23bb7ff@roeck-us.net>
Date:   Fri, 21 Feb 2020 06:22:33 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/20/20 11:36 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.22 release.
> There are 344 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 23 Feb 2020 07:19:49 +0000.
> Anything received after that time might be too late.
> 

Build reference: v5.4.21-345-gbae6e9bf73af
gcc version: x86_64-linux-gcc (GCC) 9.2.0

Building x86_64:allnoconfig ... failed
--------------
Error log:
arch/x86/kernel/unwind_orc.c: In function 'unwind_init':
arch/x86/kernel/unwind_orc.c:278:56: error: 'orc_sort_cmp' undeclared (first use in this function)

Affects v{4.14,4.19,5,4,5,5}.y.queue.


