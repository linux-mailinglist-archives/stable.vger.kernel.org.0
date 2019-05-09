Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 040AA18B39
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 16:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbfEIOGh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 10:06:37 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43216 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726192AbfEIOGh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 10:06:37 -0400
Received: by mail-pf1-f193.google.com with SMTP id c6so1377089pfa.10
        for <stable@vger.kernel.org>; Thu, 09 May 2019 07:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7XlyYld84sMizui4UM0AVQb85rbnPa3zUibJIGN+rGo=;
        b=Cfmr15nRMQ648hMh0Uljwu1px87lDv2u/ReIJaG3bGwGyftxrbhA2o7dQbIYYKGzoF
         /tzYyZJ/cc5IIN8rPKEDHhY+Ws1/gxrsodI+9OlMn7iareo6VUAOC03K0oGRmghONfN5
         iWYB3RiJXvX01TmUbQG6/Se3OyU0Vot9LhRXy/Mimpqo3uHZPl0RJbzz5rT/n098Yf0c
         AaMw9SS20T6lgobZZDwzzkt/UcXotWTmctVSo3CxDiJiyLFfric1CeRyl7ARJrjpkfV5
         jK1WUh3fZbH9elRdMPMzEPh7CfXbsQ33AICd7xyhDzaxjb/OvTJ31znJhPpTyRbQSSvI
         OXrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7XlyYld84sMizui4UM0AVQb85rbnPa3zUibJIGN+rGo=;
        b=jV4JlhkNRj6ovJzjXrq2Diar7LIfEazYP8L09izAAzDUAXlXASnamonB6Nf3LYBMTv
         n3A9t/5+tjSKeFQWuaR6qp7XiizT1cj5/ER0A7gdDnhOL62dho3vbsUvn42lXAgmg1YU
         r0rAbJub7JbAFfJe1YswoTsMa/g6tz945NFRYw/ZOnsRD/hgMpvPHRBpGSq7ym/i1uYg
         KgSFGWHDg6o3APStCvJjC9o/wTC4q1uZDf0KAEAxLtDnvXZ6szELABvxGnmmlVatY40C
         fI+PGJ5x19DJJzCfftTBBBzn/Mb/6t54TB0zsO82IP4ovxmWA+gmXXhXZjOgNWrkwbZb
         n5hw==
X-Gm-Message-State: APjAAAV1eO7aUzw4udCdK6SfIu172t+bKmVY4/ahW9fdFCHSVFnv29eK
        IsppgyTLZ1z1hsLnf1OrgeomyOXg
X-Google-Smtp-Source: APXvYqx3v6jG3HaAjthaj5kpJFK0XAvJKIu3KnAbDhMrbH8iQJi4WH+jTC61jBpJOMDV2IyRlg782g==
X-Received: by 2002:aa7:98c6:: with SMTP id e6mr5363491pfm.191.1557410795784;
        Thu, 09 May 2019 07:06:35 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d66sm994593pfg.183.2019.05.09.07.06.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 07:06:34 -0700 (PDT)
Subject: Re: Build failure in v4.4.y.queue (ppc:allmodconfig)
To:     =?UTF-8?Q?Michal_Such=c3=a1nek?= <msuchanek@suse.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
References: <20190508202642.GA28212@roeck-us.net>
 <20190509065324.GA3864@kroah.com> <20190509114923.696222cb@naga>
 <e8aa590e-a02f-19de-96df-6728ded7aab3@roeck-us.net>
 <20190509152649.2e3ef94d@kitsune.suse.cz>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <ace9aeac-f632-c004-1528-8c242def0904@roeck-us.net>
Date:   Thu, 9 May 2019 07:06:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190509152649.2e3ef94d@kitsune.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/9/19 6:26 AM, Michal Suchánek wrote:
> On Thu, 9 May 2019 06:07:31 -0700
> Guenter Roeck <linux@roeck-us.net> wrote:
> 
>> On 5/9/19 2:49 AM, Michal Suchánek wrote:
>>> On Thu, 9 May 2019 08:53:24 +0200
>>> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>>>    
>>>> On Wed, May 08, 2019 at 01:26:42PM -0700, Guenter Roeck wrote:
>>>>> I see multiple instances of:
>>>>>
>>>>> arch/powerpc/kernel/exceptions-64s.S:839: Error:
>>>>> 	attempt to move .org backwards
>>>>>
>>>>> in v4.4.y.queue (v4.4.179-143-gc4db218e9451).
>>>>>
>>>>> This is due to commit 9b2d4e06d7f1 ("powerpc/64s: Add support for a store
>>>>> forwarding barrier at kernel entry/exit"), which is part of a large patch
>>>>> series and can not easily be reverted.
>>>>>
>>>>> Guess I'll stop doing ppc:allmodconfig builds in v4.4.y ?
>>>>
>>>> Michael, I thought this patch series was supposed to fix ppc issues, not
>>>> add to them :)
>>>>
>>>> Any ideas on what to do here?
>>>
>>> What exact code do you build?
>>>   
>> $ make ARCH=powerpc CROSS_COMPILE=powerpc64-linux- allmodconfig
>> $ powerpc64-linux-gcc --version
>> powerpc64-linux-gcc (GCC) 8.3.0
>>
> 
> Gcc should not see this file. I am asking because I do not see an .org
> directive at line 839 of 4.4.179. I probably need some different repo
> or extra patches to see the same code as you do.
> 
v4.4.179-143-gc4db218e9451 from
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
branch linux-4.4.y

That also includes 'powerpc/64s: Improve RFI L1-D cache flush fallback',
but reverting it does not make a difference. Also, the .org is
hidden in STD_RELON_EXCEPTION_PSERIES().

Guenter
