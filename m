Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A781EE72A8
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 14:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729589AbfJ1Ndb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 09:33:31 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37173 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726833AbfJ1Ndb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Oct 2019 09:33:31 -0400
Received: by mail-pg1-f196.google.com with SMTP id p1so6892369pgi.4;
        Mon, 28 Oct 2019 06:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bjA4G+XednmapSh+vxN0xNuwGtGTrMwwIsjSpmlVe2w=;
        b=sSetDPm7uPz7MRLQo7Epd1nEL/eEmPC/XKoZKpRWErA2jnkhN+ClYUE27lcUeEzFr8
         V5mtFg47kvLqP6YcRx3HSNIQIVut9Vyd/RfNuJ7VvQs2Wpcexu9yIzq6qJyBC2pJAF4f
         RNQGQSjgvrwt3A/KSC1N1UdT7Cs4ezlkGgVLcVtYknkSMPavZW5dSLiRiurPUmMTt/mE
         4DZLjscTnc03mnVIQu0nzZ2H4UqJtutajpjarGbc5/GUddvtSNtiXEllS1J9xqmHwwsd
         7Llv/pejIuVAmKi7se5l3Lm+pzAg7t/6C67JJwSbQkP8DpKRyrNy25CYWEaTgUi5ussZ
         AQdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bjA4G+XednmapSh+vxN0xNuwGtGTrMwwIsjSpmlVe2w=;
        b=s6Z18HYC5eQXLRsJGO0noIFiCLA+AHUqFt1L2gHwzHk9aH3SBWg8vo9TZljj0e/M5L
         LuinowL0QNlS0Ixh5LQemEHACgpYXuFjywujL1oyL3zum737bzWcYmSlczqdKuywxvPC
         UwDXECSNvbGPtHjqBsVrn7Qo/WVPCEA+Wawgqh/b8R8NxEeA7vjTKH3FKCShL+JBTgxa
         /jPNV+NYhPS3z6f59ZErD/j0sTXyiWHhqvvR+9a2bkcjQeLW4iGgzbvFii5hiPueC55q
         qIqhU7pw8ShWyYhgWSt61nqrEh/A7y1ivmhTUeOsL9qsob/mHA18mxj1i2d0wUnjX4bj
         UyzQ==
X-Gm-Message-State: APjAAAWVS/o4yu4ll40N0NW415bQFqgsejjwFJLD9OlENCImkwQ8wtUv
        HCv9GzZfdCZNA4/DJn8kpu1Oj51v
X-Google-Smtp-Source: APXvYqyoendJoKNGlYRsBYzNptIEg7JqPk0CZDzpK93jsXVNPS+WIH7CP5rpWs/QKvkcPlEW3lsVGw==
X-Received: by 2002:a63:b047:: with SMTP id z7mr9143697pgo.224.1572269610587;
        Mon, 28 Oct 2019 06:33:30 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bb15sm10506910pjb.22.2019.10.28.06.33.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Oct 2019 06:33:30 -0700 (PDT)
Subject: Re: [PATCH 4.4 00/41] 4.4.198-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20191027203056.220821342@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <858b85af-8924-3922-e369-a17e7e7dabec@roeck-us.net>
Date:   Mon, 28 Oct 2019 06:33:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191027203056.220821342@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/27/19 2:00 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.198 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 29 Oct 2019 08:27:02 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 170 pass: 157 fail: 13
Failed builds:
	<all mips>
Qemu test results:
	total: 324 pass: 266 fail: 58
Failed tests:
	<all mips>

Guenter
