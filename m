Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7C2BCEF7F
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 01:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729252AbfJGXQ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 19:16:56 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33646 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729145AbfJGXQ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 19:16:56 -0400
Received: by mail-pl1-f194.google.com with SMTP id d22so7610377pls.0;
        Mon, 07 Oct 2019 16:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=op2uXxkWXggW/ZiyKdiwR/8/LJor0lmgkGPfA3WISUs=;
        b=scpxNy1BIS0qAUSncfTkj607cnZ6LuLh8Nks7V/5sq1PEC5kSh81aajFRMYZ+O2i0L
         QzibK+XuvdvRm6iOFZtsT2WA9n4ERkZ5LZimUA8NaVmqSduy1aHvDY5+aPf7MpmGv/0Q
         IHTsvqs7x9MZUg9WL8GHf9QPmn3LCv/brRY0s6lnYZrvL4dVruebQCp5czBNigAKMwsi
         Uk9hIiklJmctm4YAw3NEA3l0fFhuZ3EUDZXep4YHjqLorZ157E7gClDTZCDcou0YzpN0
         MiKU/aANJsfqgoJiIBERCoMr5eL7krRWJTiu5mUXl8mcpx/5aGM5RaPSjmvV1PeZdHxp
         +dug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=op2uXxkWXggW/ZiyKdiwR/8/LJor0lmgkGPfA3WISUs=;
        b=a1as3TcO8c9zovD/tvnzesVEg2dMn9g4Z7tLeg7MHMmDrGzBarm4t864Xx4w4Y2ZgF
         h3H/6f2iJy900vGiSxVCv3czMoh1gyMPYwnbRiu7cTydGmXS520xXlqAuc6lXvANqfoN
         EV9Gd8VaxgYMeDLW9YuiDX4hiC1XPG80t01jmhm9F2G//3k6RlSTryN1/2g0JKl6Dbzm
         WwxsayuFAg8WjtyGDTmKghg1vCALULCc5bL8YNHmOOexujwMqyzqSyE3XX2rIATsv9m6
         l6GGhbQxQsnVC5wU62lNGgQUGAQwPR0eE4nhNf92PZXC7FxXQiEMMqtzLtaA8TmNKafj
         BDIA==
X-Gm-Message-State: APjAAAW/Jt5f2vkg/IPjnCuU/+C2wNuKNdH1ygJAwfI/O8KnDK8dqc0T
        lK0/hj3CtaWS0QwE08209f4EmhoD
X-Google-Smtp-Source: APXvYqzMSG5gHjV15d7idvNXEtNMQAOhGF/5QWwhkXjOSHb3HfcLstjfcotM+anbE56ApWd4N0UrvA==
X-Received: by 2002:a17:902:8344:: with SMTP id z4mr32085723pln.330.1570490214984;
        Mon, 07 Oct 2019 16:16:54 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bb15sm438676pjb.2.2019.10.07.16.16.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Oct 2019 16:16:53 -0700 (PDT)
Subject: Re: [PATCH 4.4 00/36] 4.4.196-stable review
To:     Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20191006171038.266461022@linuxfoundation.org>
 <d3e1e6ae-8ca4-a43b-d30d-9a9a9a7e5752@roeck-us.net>
 <20191007144951.GB966828@kroah.com> <20191007230708.GA1396@sasha-vm>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <35f5fb99-6c35-9afd-1a4e-3fa7d4ba213a@roeck-us.net>
Date:   Mon, 7 Oct 2019 16:16:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191007230708.GA1396@sasha-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/7/19 4:07 PM, Sasha Levin wrote:
> On Mon, Oct 07, 2019 at 04:49:51PM +0200, Greg Kroah-Hartman wrote:
>> On Mon, Oct 07, 2019 at 05:53:55AM -0700, Guenter Roeck wrote:
>>> On 10/6/19 10:18 AM, Greg Kroah-Hartman wrote:
>>> > This is the start of the stable review cycle for the 4.4.196 release.
>>> > There are 36 patches in this series, all will be posted as a response
>>> > to this one.  If anyone has any issues with these being applied, please
>>> > let me know.
>>> >
>>> > Responses should be made by Tue 08 Oct 2019 05:07:10 PM UTC.
>>> > Anything received after that time might be too late.
>>> >
>>>
>>> powerpc:defconfig fails to build.
>>>
>>> arch/powerpc/kernel/eeh_driver.c: In function ‘eeh_handle_normal_event’:
>>> arch/powerpc/kernel/eeh_driver.c:678:2: error: implicit declaration of function ‘eeh_for_each_pe’; did you mean ‘bus_for_each_dev’?
>>>
>>> It has a point:
>>>
>>> ... HEAD is now at 13cac61d31df Linux 4.4.196-rc1
>>> $ git grep eeh_for_each_pe
>>> arch/powerpc/kernel/eeh_driver.c:       eeh_for_each_pe(pe, tmp_pe)
>>> arch/powerpc/kernel/eeh_driver.c:                               eeh_for_each_pe(pe, tmp_pe)
>>>
>>> Caused by commit 3fb431be8de3a ("powerpc/eeh: Clear stale EEH_DEV_NO_HANDLER flag").
>>> Full report will follow later.
>>
>> Thanks for letting me know, I've dropped this from the queue now and
>> pushed out a -rc2 with that removed.
>>
>> Sasha, I thought your builder would have caught stuff like this?
> 
> Interesting, the 4.4 build fails for me with vanilla 4.4 LTS kernel
> (which is why this was missed):
> 
>   AS      arch/powerpc/kernel/systbl.o
> arch/powerpc/kernel/exceptions-64s.S: Assembler messages:
> arch/powerpc/kernel/exceptions-64s.S:1599: Warning: invalid register expression
> arch/powerpc/kernel/exceptions-64s.S:1640: Warning: invalid register expression
> arch/powerpc/kernel/exceptions-64s.S:839: Error: attempt to move .org backwards
> arch/powerpc/kernel/exceptions-64s.S:840: Error: attempt to move .org backwards
> arch/powerpc/kernel/exceptions-64s.S:864: Error: attempt to move .org backwards
> arch/powerpc/kernel/exceptions-64s.S:865: Error: attempt to move .org backwards
> scripts/Makefile.build:375: recipe for target 'arch/powerpc/kernel/head_64.o' failed
> 

Is this allmodconfig ? That is correct - it won't build in 4.4.y, and it would not be
easy to fix.

Guenter

