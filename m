Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31AAD8EDAB
	for <lists+stable@lfdr.de>; Thu, 15 Aug 2019 16:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732687AbfHOOFb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Aug 2019 10:05:31 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45615 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732211AbfHOOFb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Aug 2019 10:05:31 -0400
Received: by mail-pg1-f194.google.com with SMTP id o13so1326954pgp.12;
        Thu, 15 Aug 2019 07:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZhLkAGGWQtYP+m+OIMzbG62Ficc34T6jA9hjqxpJ2UU=;
        b=BSoYeomTHwSqlhSttZwCDZeajURizApfDrTp/Txo9BsbE8xBjZOunyKw0w6luu29Zu
         zIBCEr433f9q1AMO5s1DJVF3mBTd6PyuMNBNcvpNf1Itx1kE3kFNnbn83vrYJ+1Qofdy
         zGqu33wJhe0O3rClrHXMEjt2CfF8b6dtH9jdgldqcIN5ABxHaNR9rpNrSegh75v/jnrF
         3eJEmaCJwxVeTpknMwed0yTKN/hiiFoHGO9g7dCBE6mTC73abaK4CIB1g+ZNIQ3penzX
         w05xhg6pCQYkl3zEcI9pmHt98N89EiTubtPL2EnUTOIj/coeqYeYcq19b143DqFlBeue
         GVUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZhLkAGGWQtYP+m+OIMzbG62Ficc34T6jA9hjqxpJ2UU=;
        b=HfgnHHWlrGZjRVLPytOgXlh+WmNz1+PoEt9mJgDwSLR9aHKsLHs0FggluK+IkMy9iF
         HiCRUtLf1csffnjGA4aBhmkTl/nb/Kz5McKyih6WJPJryCx9R1B8hmVbch71gC9yRbd+
         deq9PVQCciuJ8XTBmBzeatK7F7PCD7MnhnVigIAMXXVdI1ehmAHUqY+XLhGqrILEuLLg
         o2PqIzAUSuBXIdH2qHEVTQJsvMxJfveWtZxNLoEyRyAhXOVwguKohtlc8sxjC1OJfokF
         zGekaKWynCZmxVD1VKS5r84Nz7iCADkMc9IMBi1itBSKh3g+vM7de5DZqUdMqC6kKWjb
         43Qw==
X-Gm-Message-State: APjAAAUiLFWsjf1xrN2L4y6yezZsH/qzmh6lhiPQTDXveeRGWVEH2V2n
        Wwn1a5Rjx3L4dXMviPJmFq61QfmB
X-Google-Smtp-Source: APXvYqz220Gek3XcXQRTHkmsb/aXxI0km0yiL+0JobfxGe0D1w1Y67ej/iJ4fBlkKJHAhZR9S8TvYQ==
X-Received: by 2002:a63:394:: with SMTP id 142mr3630153pgd.43.1565877930197;
        Thu, 15 Aug 2019 07:05:30 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y14sm4414413pfq.85.2019.08.15.07.05.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 07:05:29 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/91] 4.19.67-stable review
To:     =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        torvalds@linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
References: <20190814165748.991235624@linuxfoundation.org>
 <aa683926-3df0-6f60-841a-7ea5a5e3566d@roeck-us.net>
 <CAEUSe78A6Cvt2irKzysfRSHubVxDaEGUVaLf2UF5EHzTeiOVOw@mail.gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <654b05a5-ebd6-cf4d-74d3-723e0bd3e40e@roeck-us.net>
Date:   Thu, 15 Aug 2019 07:05:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAEUSe78A6Cvt2irKzysfRSHubVxDaEGUVaLf2UF5EHzTeiOVOw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/15/19 6:58 AM, Daniel Díaz wrote:
> Hello!
> 
> On Thu, 15 Aug 2019 at 08:29, Guenter Roeck <linux@roeck-us.net> wrote:
>>
>> On 8/14/19 10:00 AM, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 4.19.67 release.
>>> There are 91 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Fri 16 Aug 2019 04:55:34 PM UTC.
>>> Anything received after that time might be too late.
>>>
>>
>> Building x86_64:tools/perf ... failed
>> --------------
>> Error log:
>> Warning: arch/x86/include/asm/cpufeatures.h differs from kernel
>> Warning: arch/x86/include/uapi/asm/kvm.h differs from kernel
>>     PERF_VERSION = 4.9.189.ge000f87
>> util/machine.c: In function ‘machine__create_module’:
>> util/machine.c:1088:43: error: ‘size’ undeclared (first use in this function); did you mean ‘die’?
>>     if (arch__fix_module_text_start(&start, &size, name) < 0)
>>                                              ^~~~
>>                                              die
>> util/machine.c:1088:43: note: each undeclared identifier is reported only once for each function it appears in
> 
> We noticed this exact failure but not on 4.19. For us, 4.19's perf builds fine.
> 
> On 4.9, perf failed with the error you described, as it looks like
> it's missing 9ad4652b66f1 ("perf record: Fix wrong size in
> perf_record_mmap for last kernel module"), though I have not verified
> yet.
> 

Uuh, yes, you are correct. I wasn't paying attention (blaming lack of coffee
in the morning). The above error is from v4.9.y.queue, not v4.19.y.queue.

Sorry for the confusion.

Guenter
