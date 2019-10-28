Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC413E72AE
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 14:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389017AbfJ1Nfi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 09:35:38 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34163 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726833AbfJ1Nfh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Oct 2019 09:35:37 -0400
Received: by mail-pf1-f193.google.com with SMTP id b128so6912163pfa.1;
        Mon, 28 Oct 2019 06:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zJqrh2GcmG2ALmzsMvpfmr7+h1630cs7NsYD9l3RRSM=;
        b=e5nnC2IgmuYYgz8i2OJJw2Dk1Ooc+V1uiSAdGNI/ZQf12YpAHk239FUqwDzqO17raR
         VPxuyJ83rzq4cIG03ptDBnT2+B+BwKTxZO9m7tpsfLjNCs0MkaLGDc36HmxovwFBL3ok
         Wwx8HicNHZ3Kv4SWn2VSxdkjQF5isjsD2IxxWa81NgTNpPnZfBL0apnW3EjVGfrz610a
         z+6XddsNu835EqHMIx+p7LnCi4nA6/MS/s2ID4AiwKy2P1NZHYG26yp7Ny6WbenM+2G8
         yjXNWvztwENiWGOAhlsk38zrnDpWXDjsJZg7aLSiJO0K+B7RzzwTwqlX7/8M01tCyg6L
         0l3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zJqrh2GcmG2ALmzsMvpfmr7+h1630cs7NsYD9l3RRSM=;
        b=PCZhYAamVVo6lxxcZOlvEdTvZ5vPoFTvP/gLceoEZKBZ3dXhyQuwi2jDzlDpEZOZzT
         FKpjWUSU7UUoyfSceSffwDx2dgs8j443HxBQ3Bb03/0fmBc2P4kjbd6XCWzyXFnevCQf
         wGmTgmK9PUSp977P8BSTsCh9mD2ouXt4oB/Tdk8ZeZKySOeilbtkeGk7BRrApUZ11xuh
         od1GCsbcdoSEhA5LIueXJa5chGDo6XXEkDMEeallzXUUlygMq3yCm+sXgZsVqVDhzr4m
         DZx9JzIBh8Xj9fVSmjCtcQ2Gh340rswaT61aRhdjN217D4iyh/iCb5NDX+iniNzGvIq8
         L0Zw==
X-Gm-Message-State: APjAAAW2WnuVlRFp9Ak3kVzKfdlHzdg+PNzl8+07UMaa831qSANC507V
        IYnfLgBgdG0bX66uZ4+GTWe9EkE3
X-Google-Smtp-Source: APXvYqyQJOT9hDMN0RRKHCOwheokmfuWeW0uTLKlaRRMST4vsW43Gx3LLRmw9YnZT20ZcvX6r07/GQ==
X-Received: by 2002:a63:1c5f:: with SMTP id c31mr17037518pgm.230.1572269736764;
        Mon, 28 Oct 2019 06:35:36 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s14sm10521268pfe.52.2019.10.28.06.35.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Oct 2019 06:35:36 -0700 (PDT)
Subject: Re: [PATCH 4.14 000/119] 4.14.151-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20191027203259.948006506@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <a0e5788c-c21b-b1df-bfa3-7a4cc8bea211@roeck-us.net>
Date:   Mon, 28 Oct 2019 06:35:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191027203259.948006506@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/27/19 1:59 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.151 release.
> There are 119 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 29 Oct 2019 08:27:02 PM UTC.
> Anything received after that time might be too late.
> 


Build results:
	total: 172 pass: 159 fail: 13
Failed builds:
	All mips
Qemu test results:
	total: 372 pass: 312 fail: 60
Failed tests:
	All mips

Guenter
