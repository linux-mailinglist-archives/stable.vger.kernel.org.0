Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5475210F67
	for <lists+stable@lfdr.de>; Wed,  1 Jul 2020 17:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731823AbgGAPel (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 11:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731803AbgGAPel (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jul 2020 11:34:41 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73751C08C5DB
        for <stable@vger.kernel.org>; Wed,  1 Jul 2020 08:34:41 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id k15so21690422otp.8
        for <stable@vger.kernel.org>; Wed, 01 Jul 2020 08:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BO3A9UFCSekFMTeFwoQzee/zUYU1XRTbKaOkhPKAKz0=;
        b=auaWToNTNPAI7ppvFZCdj7N27JvGATqL//VThzIioprulKBRax839H40k4lzaT97m0
         7p9o6uS/CoEjrFVQjaVfHrDIsS7eTlvle0sMHYHgWZNL3RWbumy8/gJcOv6qobzlBGmS
         gIvR96Kz1+B31Kg3YlsDBbxbYtZaSbK6tffDM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BO3A9UFCSekFMTeFwoQzee/zUYU1XRTbKaOkhPKAKz0=;
        b=uUl9Zsv2eoGBpI0QkB1qCNaK+vxjSyUJn/za0bmQLZQVjP3B8iquTl8NZJOHufsW3l
         ZOhyVE3l+7N5Y/9d1FdPExT3pa3cEGVJb/sX3juT2Sxm4LvNHKJFQxfaXuJyuTaoBP5H
         Zj/KkYzme2zo29Nf+6p8E+vdY+IEDdduIinx0ssH7VMSg9+fN+RkkmUu9YebVH/c5jPP
         x4dX52E1UIEKB0jPFevcM0y0rvjtypCmxoEAqTIO0pveTowF3851ixgey95kSd3MJkNJ
         SePoIDmlB5e2t66X1G8b7q278Hp5hMXI1hdyyS9le1PTNJpF4Y+QUTaMo9JZt20qlnQo
         LupQ==
X-Gm-Message-State: AOAM531QT473avm82niCBk6dRDFUwptCw0hDAktzWu3C2T0Ry6Xscnfv
        AZdCiyXo8FdFINZeK3OduLYLow==
X-Google-Smtp-Source: ABdhPJwCAss0hEdRm8bsv6r18PQcnLkyq29udZm9VQ81HYaIJde7cAzf55HrjDKUfb+UruvuD7hWkw==
X-Received: by 2002:a9d:73c9:: with SMTP id m9mr14088153otk.94.1593617680732;
        Wed, 01 Jul 2020 08:34:40 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id z17sm98607oic.32.2020.07.01.08.34.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jul 2020 08:34:39 -0700 (PDT)
Subject: Re: [PATCH 5.7 000/265] 5.7.7-rc1 review
To:     Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        skhan@linuxfoundation.org
References: <20200629151818.2493727-1-sashal@kernel.org>
 <42dadde8-04c0-863b-651a-1959a3d85494@linuxfoundation.org>
 <20200629231826.GT1931@sasha-vm> <20200630083845.GA637154@kroah.com>
 <20200630151248.GY1931@sasha-vm> <20200630153325.GA1785141@kroah.com>
 <20200701144000.GC2687961@sasha-vm>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <7c55aa3f-1027-a640-9501-55502fd2745d@linuxfoundation.org>
Date:   Wed, 1 Jul 2020 09:34:38 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200701144000.GC2687961@sasha-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/1/20 8:40 AM, Sasha Levin wrote:
> On Tue, Jun 30, 2020 at 05:33:25PM +0200, Greg Kroah-Hartman wrote:
>> On Tue, Jun 30, 2020 at 11:12:48AM -0400, Sasha Levin wrote:
>>> On Tue, Jun 30, 2020 at 10:38:45AM +0200, Greg Kroah-Hartman wrote:
>>> > On Mon, Jun 29, 2020 at 07:18:26PM -0400, Sasha Levin wrote:
>>> > > On Mon, Jun 29, 2020 at 02:37:53PM -0600, Shuah Khan wrote:
>>> > > > Hi Sasha,
>>> > > >
>>> > > > On 6/29/20 9:13 AM, Sasha Levin wrote:
>>> > > > >
>>> > > > > This is the start of the stable review cycle for the 5.7.7 
>>> release.
>>> > > > > There are 265 patches in this series, all will be posted as a 
>>> response
>>> > > > > to this one.  If anyone has any issues with these being 
>>> applied, please
>>> > > > > let me know.
>>> > > > >
>>> > > > > Responses should be made by Wed 01 Jul 2020 03:14:48 PM UTC.
>>> > > > > Anything received after that time might be too late.
>>> > > > >
>>> > > > > The whole patch series can be found in one patch at:
>>> > > > >     
>>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.7.y&id2=v5.7.6 
>>>
>>> > > > >
>>> > > >
>>> > > > Looks like patch naming convention has changed. My scripts look
>>> > > > for the following convention Greg uses. Are you planning to use
>>> > > > the above going forward? My scripts failed looking for the usual
>>> > > > naming convention.
>>> > > >
>>> > > > The whole patch series can be found in one patch at:
>>> > > >     
>>> https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.6-rc1.gz 
>>>
>>> > > > or in the git tree and branch at:
>>> > > >     
>>> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git 
>>> linux-5.7.y
>>> > > > and the diffstat can be found below.
>>> > >
>>> > > Sorry for that. I was hoping to avoid using the signed upload 
>>> mechanism
>>> > > Greg was using by simply pointing the links to automatically 
>>> generated
>>> > > patches on cgit (the git.kernel.org interface).
>>> > >
>>> > > Would it be ok to change the pattern matching here? Something 
>>> like this
>>> > > should work for both Greg's format and my own (and whatever may come
>>> > > next):
>>> > >
>>> > >     grep -A1 "The whole patch series can be found in one patch 
>>> at:" | tail -n1 | sed 's/\t//'
>>> >
>>> > If those don't work, I can still push out -rc1 patches.
>>> >
>>> > It might be best given that the above -rc.git tree is unstable and 
>>> can,
>>> > and will, change, and patches stored on kernel.org will not.
>>>
>>> That's a good point. Maybe we should push tags for -rc releases too?
>>> that would allow us to keep stable links using the git.kernel.org
>>> interface.
>>
>> If we really want to do this, then yes, we could.  But that kind of goes
>> against what we (well I) have been doing in the past with that tree...
> 
> We've been force pushing it, yes, but if we add tags it would just keep
> older version around so I don't think it would change much for our
> workflow, but it would make it easy to get to older versions.
> 

I can make changes to my scripts as long as the process is consistent
for stable releases. Let mw know what you come up with, I will make
adjustments to my scripts.

thanks,
-- Shuah
