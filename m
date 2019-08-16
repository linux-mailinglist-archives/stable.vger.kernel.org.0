Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E32890470
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 17:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbfHPPMg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Aug 2019 11:12:36 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:33692 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727217AbfHPPMg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Aug 2019 11:12:36 -0400
Received: by mail-io1-f68.google.com with SMTP id z3so6848098iog.0
        for <stable@vger.kernel.org>; Fri, 16 Aug 2019 08:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YuqhzAOotFlJJ+JGT4X00VewlHM+EBqkIgPZ06dmKIY=;
        b=spaP4VWpJEN8MiRhYjzCjbcDYMJyVThVCmHMMLjphY4k/4BjvwldiAxe1mZgAGqhFj
         ppT9DGncjOZQMxQw4YdXkq6AiQLMkb1r5EvsyMSf4u3hdeCYruuRRkidj4L3t1jeVuZd
         SR2EDa14WMDwdec55vFX9a8oI/Pc3nZckzLM7J545NEONCAEzzZcqQjDUNAUwmgfU97Y
         Ba/In/s1HWiB6uFvUM+Dw2x4H6UMeoM8IPeXtfL4711lrfUbFg92XgUXk2Xg7lJ/2MQ1
         NkL8uv5Wz8SdXSD0WRU+Gpj5WBc81hWnx3RJXWuYQq0tyyyptcyTbfMNaRb3DTuBMXdn
         SC+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YuqhzAOotFlJJ+JGT4X00VewlHM+EBqkIgPZ06dmKIY=;
        b=ndoKA5rKa770OWE8pbVNSZ8geeFw+UGa1EXoP4Mmqd3UBZlz06C7euhWf2+1TPWgZT
         zzTwKr+ExFnrQVzzREDRMPkOqptNoCkUhKdF4dBtrr8xnb4SozPUi8K2QdW0hP57lHnP
         90Cr00a3K8teH/gT9Jc1HBidtv9efbeLm3feaxXK+HOXKPcDW/ZmJgVV89AFtge0YVFU
         W4NrRzfr6pbNF+dTucwf9HxEMPUXItfHBR5RkN/Ub3hSxPM/OlgEcGRFrPD+yJLOoJPE
         EvFF/XCREM9bCXyos7Ai7nRgwGecW4VsD/CLlPpBZafcL8S0L5Mo7flWzaT7n96Pxfpu
         6qbg==
X-Gm-Message-State: APjAAAWwkCxrNVc5t+4eiUEJvhakImGWCfkKgXZOktWRRp66n4pKzCMA
        SPyKs87RYG03EavXx5rlvzc1ug==
X-Google-Smtp-Source: APXvYqwhR1qd2Q1b39cMr4h7RNgFKYgffpKLNQDVCt9p89pHPRD6svMydf7dE2AL+6qRBKvp8Tpq7w==
X-Received: by 2002:a02:7f54:: with SMTP id r81mr2065705jac.129.1565968355657;
        Fri, 16 Aug 2019 08:12:35 -0700 (PDT)
Received: from [192.168.1.50] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id c18sm3738538iod.19.2019.08.16.08.12.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 08:12:34 -0700 (PDT)
Subject: Re: [PATCH] blk-mq: remove blk_mq_hw_sysfs_cpus
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        stable@vger.kernel.org, Mark Ray <mark.ray@hpe.com>
References: <20190816074849.7197-1-ming.lei@redhat.com>
 <5baa0c28-6e12-5a61-0254-de0e49cf1596@kernel.dk>
 <20190816145435.GA3424@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0b0f1017-ea52-a155-fc05-e22006813105@kernel.dk>
Date:   Fri, 16 Aug 2019 09:12:33 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190816145435.GA3424@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/16/19 8:54 AM, Greg KH wrote:
> On Fri, Aug 16, 2019 at 08:20:42AM -0600, Jens Axboe wrote:
>> On 8/16/19 1:48 AM, Ming Lei wrote:
>>> It is reported that sysfs buffer overflow can be triggered in case
>>> of too many CPU cores(>841 on 4K PAGE_SIZE) when showing CPUs in
>>> blk_mq_hw_sysfs_cpus_show().
>>>
>>> This info isn't useful, given users may retrieve the CPU list
>>> from sw queue entries under same kobject dir, so far not see
>>> any active users.
>>>
>>> So remove the entry as suggested by Greg.
>>
>> I think that's a bit frivolous, there could very well be scripts or
>> apps that use it. Let's just fix the overflow.
> 
> As no one really knows what the format is (and the patch to fix the
> overflow changes the format of the file), I would say that it needs to
> just be dropped as it is not an example of what you should be doing in
> sysfs.

It's a list of CPUs, I think the format is quite self explanatory?

But in any case, I'm not 100% opposed to removing it, it's just not
one of those things that should be done on a whim.

-- 
Jens Axboe

