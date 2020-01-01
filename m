Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D41712DD4B
	for <lists+stable@lfdr.de>; Wed,  1 Jan 2020 03:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbgAACBP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Dec 2019 21:01:15 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:52347 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726806AbgAACBP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Dec 2019 21:01:15 -0500
Received: by mail-pj1-f65.google.com with SMTP id a6so1726855pjh.2;
        Tue, 31 Dec 2019 18:01:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LvKaJsyAx2/qmZ5gl/7odm6wcIITIaIwKOP7eRaPStU=;
        b=es/rzdx4kvZ9DMy+A0/4qQzs/zrzI1kcdEhDQprnblJFJuAGr3AyCgUF3RVpvDpx04
         ZTaESRB1jbBi1Q5Rbk3YJN2jlvhX/lsKVGT1mz8KzqiM5lbFeYEw+F0tWkH9TNcdhWdo
         lyNysyPIR6GpFatLrDmAjne8+Bc/Hk1P4l4r5zfdqq7v7ibJOeTYkQ7JmgfEAvgaO+Yk
         +1HqQYpMknwkthNtQ30Zlj1nnmdKFX9msl5Jj2qYJJD4/FKN7ATcc0bR7SiIeg/dMW4r
         Ia/LUGyGSdKHANeO5s6VV0qkl+VmUTs01qaDa3twLNJiaEgXUaqIhmfmx/QiS43eohin
         VbFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LvKaJsyAx2/qmZ5gl/7odm6wcIITIaIwKOP7eRaPStU=;
        b=SgB1gL09VkvAeuqqoJzGAYHbsqi7oOTNNU5Oy8eBqwcGszq03Dl6+5CfGQP0wqfu82
         p+3q5BIntFX89pdfN3ujCxqHa6Jz5jHVZc0/yFxCHUgdwB+7W9OiOs8uxQsTo5QCuDsv
         z0j/E9Z1a1tx66lUy3V8vjcLxUFVlJK9XxrKO5sIkercrHGcNTLctxMVNUjQUC/S9HXE
         MpbyShaBH+vS/DvhG90LVTdQfFk1wjaqV1rY9lVX+GEwRXC1Bmsz7NBLsalAPDyE0NNS
         XUnrBmLaEw8FSzzsjtMkSPrJIi7tTp2qAr2TXdVRr818CrSK1IfoqANjIxFfJHkH+G/j
         RA5A==
X-Gm-Message-State: APjAAAXmgOiyOkNCEh6oMS5qMGpxUx5pOpOtue+fcU+h8Nq7GLSS9A8E
        X/H5p+8+uZl438KM16UY3Y0eZRoC
X-Google-Smtp-Source: APXvYqyhBY/kaFBd+o4Pl7Shc4Br0ZBSuOO5lIDis2p3AKa3yLKjXDHZkL+C+Z5yb5niqidQMcKEmA==
X-Received: by 2002:a17:90a:1b66:: with SMTP id q93mr10473725pjq.102.1577844074681;
        Tue, 31 Dec 2019 18:01:14 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t187sm57136382pfd.21.2019.12.31.18.01.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Dec 2019 18:01:14 -0800 (PST)
Subject: Re: [PATCH 4.19 000/219] 4.19.92-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20191229162508.458551679@linuxfoundation.org>
 <20191230171959.GC12958@roeck-us.net> <20191230173506.GB1350143@kroah.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <7c5b2866-39d9-5c5f-0282-eef2f34c7fe8@roeck-us.net>
Date:   Tue, 31 Dec 2019 18:01:12 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191230173506.GB1350143@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/30/19 9:35 AM, Greg Kroah-Hartman wrote:
> On Mon, Dec 30, 2019 at 09:19:59AM -0800, Guenter Roeck wrote:
>> On Sun, Dec 29, 2019 at 06:16:42PM +0100, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 4.19.92 release.
>>> There are 219 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Tue, 31 Dec 2019 16:17:25 +0000.
>>> Anything received after that time might be too late.
>>>
>> Build results:
>> 	total: 156 pass: 141 fail: 15
>> Failed builds:
>> 	i386:tools/perf
>> 	<all mips>
>> 	x86_64:tools/perf
>> Qemu test results:
>> 	total: 381 pass: 316 fail: 65
>> Failed tests:
>> 	<all mips>
>> 	<all ppc64_book3s_defconfig>
>>
>> perf as with v4.14.y.
>>
>> arch/mips/kernel/syscall.c:40:10: fatal error: asm/sync.h: No such file or directory
> 
> Ah, will go drop the offending patch and push out a -rc2 with both of
> these issues fixed.
> 
>> arch/powerpc/include/asm/spinlock.h:56:1: error: type defaults to ‘int’ in declaration of ‘DECLARE_STATIC_KEY_FALSE’
>> and similar errors.
>>
>> The powerpc build problem is inherited from mainline and has not been fixed
>> there as far as I can see. I guess that makes 4.19.y bug-for-bug "compatible"
>> with mainline in that regard.
> 
> bug compatible is fun :(
> 

Not really. It is a terrible idea and results in the opposite of what I would
call a "stable" release.

Anyway, turns out the offending commit is 14c73bd344d ("powerpc/vcpu: Assume
dedicated processors as non-preempt"), which uses static_branch_unlikely().
This function does not exist for ppc in v4.19.y and v5.4.y. Thus, the _impact_
of the error in v4.19.y and v5.4.y is the same as in mainline, but the _cause_
is different. Upstream commit 14c73bd344d should not have been applied to
v4.19.y and v5.4.y and needs to be reverted from those branches.

Guenter
