Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E720CEF1F
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 00:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728893AbfJGWgv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 18:36:51 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43369 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728654AbfJGWgv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 18:36:51 -0400
Received: by mail-pl1-f196.google.com with SMTP id f21so7530229plj.10;
        Mon, 07 Oct 2019 15:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qQFvQXMDOOQXelPSQG/VrtGgsFEzvkqo1WSTQd7tu0k=;
        b=kMbeUB6nfSXlrKHTAkW6JpIwZIRINd9NuS1bNOdTNs+8Aoeqm4IlcnUHMWWqcN5W4u
         3iV09ixXVBwoNvJOBGTCKHsC5HAah1IJCUyE7A/6eYBxSc17hbsVVPLzxxP8ofAPJNeT
         MTSH9ESlEsCR51pZjYjcKjj+5hy6yyENbArIf4X5wRJtzvd4IkVh7J3Z2H1guUiDXFtV
         q2FJAO3hcGhMqmxyG6XB5JOuS8QofPT03Bp8igl7HMH+K5zZ506HQjPqESYgOjbIPPvf
         OXqYApWayL8ZKiD22bvOJ9Ut9eJzOiG6pkbdznWgWoHZJYTMT1JwVdeC7kEIH60v8NAP
         K5Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qQFvQXMDOOQXelPSQG/VrtGgsFEzvkqo1WSTQd7tu0k=;
        b=SSM/GqUA81r3gRSYx49uX5KdX6tRQ3L7zmBRx1ex7iSik5CcvQWGbjoPczFw43e4Tz
         hUqxdiv/P7igfIR2CQ/KEwF/GVUbx8OV6KEuQ+ThjAh+bhFi/9aq1HUmXKvEcPfuDbrv
         MC9q8gqYW1QDRw0QJZyr0uj1P2pE/WdZYSJJTujb9FnFNZtkFtmTkp/Cpr6WLQv6ZP4G
         Qn/2I+jYR87swQ2jUC+3vM5DuokKjkYMWpUPmoQFVgifgTN8JZ474WekicF8qRWuGHyd
         Hh7BM7/xtKGRmFRrlFWVHUA/aegP+gNBGMfDoa0uPk++r2khR7u7uArJBFMM/AXI2oe1
         FWWQ==
X-Gm-Message-State: APjAAAV988K6zjAaxg5f3qS7ltoA/xe07LPPt/1iW4d71Ejbn3mELY8C
        El7hqroI+Gef703S81XFKwLAWryl
X-Google-Smtp-Source: APXvYqwsjlduvrCYB/Xn2VwJfyrMEGd8t6ujlCVPR53aEBbbfr2Ct7e/hsSBZvbPBaa3bvyhCp6hWw==
X-Received: by 2002:a17:902:144:: with SMTP id 62mr663028plb.283.1570487809873;
        Mon, 07 Oct 2019 15:36:49 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d6sm17952967pgj.22.2019.10.07.15.36.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Oct 2019 15:36:48 -0700 (PDT)
Subject: Re: [PATCH 4.4 00/36] 4.4.196-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20191006171038.266461022@linuxfoundation.org>
 <d3e1e6ae-8ca4-a43b-d30d-9a9a9a7e5752@roeck-us.net>
 <20191007144951.GB966828@kroah.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <fbce4eb8-ebc8-5246-ea03-3af2ebb97a16@roeck-us.net>
Date:   Mon, 7 Oct 2019 15:36:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191007144951.GB966828@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/7/19 7:49 AM, Greg Kroah-Hartman wrote:
> On Mon, Oct 07, 2019 at 05:53:55AM -0700, Guenter Roeck wrote:
>> On 10/6/19 10:18 AM, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 4.4.196 release.
>>> There are 36 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Tue 08 Oct 2019 05:07:10 PM UTC.
>>> Anything received after that time might be too late.
>>>
>>
>> powerpc:defconfig fails to build.
>>
>> arch/powerpc/kernel/eeh_driver.c: In function ‘eeh_handle_normal_event’:
>> arch/powerpc/kernel/eeh_driver.c:678:2: error: implicit declaration of function ‘eeh_for_each_pe’; did you mean ‘bus_for_each_dev’?
>>
>> It has a point:
>>
>> ... HEAD is now at 13cac61d31df Linux 4.4.196-rc1
>> $ git grep eeh_for_each_pe
>> arch/powerpc/kernel/eeh_driver.c:       eeh_for_each_pe(pe, tmp_pe)
>> arch/powerpc/kernel/eeh_driver.c:                               eeh_for_each_pe(pe, tmp_pe)
>>
>> Caused by commit 3fb431be8de3a ("powerpc/eeh: Clear stale EEH_DEV_NO_HANDLER flag").
>> Full report will follow later.
> 
> Thanks for letting me know, I've dropped this from the queue now and
> pushed out a -rc2 with that removed.
> 

For v4.4.195-36-g898f6e5cf82f:

Build results:
	total: 170 pass: 170 fail: 0
Qemu test results:
	total: 324 pass: 324 fail: 0

Guenter
