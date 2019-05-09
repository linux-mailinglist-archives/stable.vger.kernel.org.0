Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78C4818A4E
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 15:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbfEINHh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 09:07:37 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33173 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726511AbfEINHh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 09:07:37 -0400
Received: by mail-pl1-f194.google.com with SMTP id y3so1148316plp.0
        for <stable@vger.kernel.org>; Thu, 09 May 2019 06:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AMDSOHuntpXjwkDROmPwR3CtgdKHjORZGQxYxRCtzlU=;
        b=lmC2wxBOUUxBpARjaZJqsfJzrZMRiR1P3nYQGJS8kJ6P5trMZHbo2STPMZbf4tl/bE
         dDHY2sVyuBYEF0ALB5HW8JzvmbjsV1krfl5dT/zCQ81Q9ixUMiCD1ZPoG418wrmZwDET
         aRhq1VjdW020hplpfYZAxl2YeuxKk5e5Kl1RH9eEEt8e7cL8JDo6qJ7+bjTF9/rB5cK0
         Feqx4lIgWPvr8arTX2zGvBLZFSf5ORhpt/UAsJkbkp4+yXfm6NNwZ5yn02FSS/dQIPR4
         MvdrffaELUToz2lIp6ProF6siAQo+z1QRuHmHzFXhdPofFSgjIhtCujfEiv/gf9G2iq+
         H1VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AMDSOHuntpXjwkDROmPwR3CtgdKHjORZGQxYxRCtzlU=;
        b=X+ZWXzMftdLDRLGnDb87s1zsc9aOfp8GJh37zixAQrjnZYmqWj8hP2uYOQo0IJGF9r
         pLwjKwEmI2ZMFFUPpq3tKldXuUclQiXVV3UKnbYEt6JNX4KvXb705TGVn+CvcGYvuWad
         zN+P7+FmmdMe6ea2VSlgK6JuQGDG5Qw3BApu9NtIZ7ea7GCismetWtWjTbUJxUCxMw1m
         MZ6CSJS8jzPD78VXG4xxurbEF/mO4dtcWuvM/fGvztRco2U4V5f9q7FmH9iGDio7f3wn
         3bMyY/QToaL6UqxuIksTGTkMXAkaH1iP9J7n1IoolevPLfKPEecHiiYlcGKP5kjFgcbU
         e6uA==
X-Gm-Message-State: APjAAAXC14+VSAS68tOenVR4TdAaA5dhRif0ghz0oPgl7wpSyjDbOZ7k
        8S3/3raqzUfCv3ETlamVn3k2g/Q9
X-Google-Smtp-Source: APXvYqxY64yiv1YSXv40+phLLmGiWlKDHIHmA3rCiS28kXRO7hdD/3Py8T04aZ70WemoqMOckVi6AQ==
X-Received: by 2002:a17:902:e091:: with SMTP id cb17mr4891085plb.222.1557407255840;
        Thu, 09 May 2019 06:07:35 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 5sm5158382pfs.17.2019.05.09.06.07.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 06:07:33 -0700 (PDT)
Subject: Re: Build failure in v4.4.y.queue (ppc:allmodconfig)
To:     =?UTF-8?Q?Michal_Such=c3=a1nek?= <msuchanek@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
References: <20190508202642.GA28212@roeck-us.net>
 <20190509065324.GA3864@kroah.com> <20190509114923.696222cb@naga>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <e8aa590e-a02f-19de-96df-6728ded7aab3@roeck-us.net>
Date:   Thu, 9 May 2019 06:07:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190509114923.696222cb@naga>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/9/19 2:49 AM, Michal Suchánek wrote:
> On Thu, 9 May 2019 08:53:24 +0200
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
>> On Wed, May 08, 2019 at 01:26:42PM -0700, Guenter Roeck wrote:
>>> I see multiple instances of:
>>>
>>> arch/powerpc/kernel/exceptions-64s.S:839: Error:
>>> 	attempt to move .org backwards
>>>
>>> in v4.4.y.queue (v4.4.179-143-gc4db218e9451).
>>>
>>> This is due to commit 9b2d4e06d7f1 ("powerpc/64s: Add support for a store
>>> forwarding barrier at kernel entry/exit"), which is part of a large patch
>>> series and can not easily be reverted.
>>>
>>> Guess I'll stop doing ppc:allmodconfig builds in v4.4.y ?
>>
>> Michael, I thought this patch series was supposed to fix ppc issues, not
>> add to them :)
>>
>> Any ideas on what to do here?
> 
> What exact code do you build?
>
$ make ARCH=powerpc CROSS_COMPILE=powerpc64-linux- allmodconfig
$ powerpc64-linux-gcc --version
powerpc64-linux-gcc (GCC) 8.3.0

Guenter
