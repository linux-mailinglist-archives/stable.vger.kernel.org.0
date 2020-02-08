Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D001156490
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 14:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbgBHNeG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 08:34:06 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46024 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727131AbgBHNeG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 08:34:06 -0500
Received: by mail-pf1-f193.google.com with SMTP id 2so1232745pfg.12
        for <stable@vger.kernel.org>; Sat, 08 Feb 2020 05:34:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SdgkevJj45koTHnxdq9o3Aw2kMisdrvqzvNoeWuyqk8=;
        b=oc6Ltvcpf/dyyK9+29H+WQDC27CrMxbWVJwVFfc6mgis/ZKy7ex6N7zYnfszECGbQn
         eAN1LxbFdkdx/IIoV1V6X7Q0EK8Im3VqEMRRwqKDI1Uqy/em2bkxrXKRvcZZoa8AFyyj
         bsuwUiPSW2npNmDZPTCiHQyzGTem9vD48K+58FzFLDhbRX4/Mxu2FIsVhVyuRgSlAh9j
         FQ2WjCxKQJoIJhQNYq1F6C7dUmPPx//Ek7RCKWuzb9r7XFn17qykjI84B7CkMrtkkpVo
         8K05Wcd6Qdf5mjYXWzDB/xjTFF8mTNb/kYx/Kltp1nT3oQN3FKoWRKl4XMOQt2YapgTd
         XXow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SdgkevJj45koTHnxdq9o3Aw2kMisdrvqzvNoeWuyqk8=;
        b=Ja0jKTwCZ0QRCFYbbf5CoYnSJJvRK7kmdug0iXEIhMiAPcMz3v9ujB8KMsQ0iu/p/p
         jNIa8+s/hCNX+fujuH4ZfdtgTrEV75lx/NMwQ9dMV1Ti8P5nnqTObvHG2AsIH/9BBw2x
         DVUYyKoTpNeDQxx3Q5m38EtYx9dFbnaBGaYxQOWLMohLv/l5UE+FYeeiydipFIeGLtmW
         bgG/vtcWxDf76aRL5UCIeOQz5YgwGc76cvRmZYSRmz/TnfnQyUuZ82c5Us9eEn/zjEXD
         ZWj6bgEeDfXatKUvVIt+zmfgm6TRfoU89nrYqSK55d4L9+DKsjrCdHjuAlIF+IaObtBU
         dYOA==
X-Gm-Message-State: APjAAAX54HbgjgoFsh9LhOG7KNOSzeEXme1NLKomCa+WNkFg6J3zR2Wq
        X/OCybQPiL65YaZEyn3VIY5LADZJ
X-Google-Smtp-Source: APXvYqwmrsT/JQnjNSzr/UGs45ny1fgw8n6LtCvTou3BlF1KWAfadCwfVymavEMlLoS4BhWPydcohw==
X-Received: by 2002:a63:5508:: with SMTP id j8mr4622440pgb.170.1581168845639;
        Sat, 08 Feb 2020 05:34:05 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i9sm6548711pfk.24.2020.02.08.05.34.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Feb 2020 05:34:05 -0800 (PST)
Subject: Re: v4.9.y.queue build failures (s390)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>
References: <e63c50d7-68c0-1ada-dc05-86452d17a76a@roeck-us.net>
 <20200208132823.GA1234618@kroah.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <15bfd5ad-bb01-3142-3c4a-44cb3661a772@roeck-us.net>
Date:   Sat, 8 Feb 2020 05:34:04 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200208132823.GA1234618@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/8/20 5:28 AM, Greg Kroah-Hartman wrote:
> On Sat, Feb 08, 2020 at 05:15:43AM -0800, Guenter Roeck wrote:
>> For v4.9.213-37-g860ec95da9ad:
>>
>> arch/s390/mm/hugetlbpage.c:14:10: fatal error: linux/sched/mm.h: No such file or directory
>>     14 | #include <linux/sched/mm.h>
>>        |          ^~~~~~~~~~~~~~~~~~
>> compilation terminated.
>> scripts/Makefile.build:304: recipe for target 'arch/s390/mm/hugetlbpage.o' failed
>> make[1]: *** [arch/s390/mm/hugetlbpage.o] Error 1
>> Makefile:1688: recipe for target 'arch/s390/mm/hugetlbpage.o' failed
>> make: *** [arch/s390/mm/hugetlbpage.o] Error 2
>>
>> Guenter
> 
> Thanks for letting me know, I'll try to guess and pick "sched.h" instead
> here and push out an update.
> 
> greg k-h
> 

You have "s390/mm: fix dynamic pagetable upgrade for hugetlbfs"
in there which is tagged 4.12+.

Guenter
