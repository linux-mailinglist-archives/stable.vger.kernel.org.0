Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7938B3B73B4
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 16:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234304AbhF2OCc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 10:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234235AbhF2OCc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Jun 2021 10:02:32 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBDFCC061760
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 07:00:04 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id v5so20949423ilo.5
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 07:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LiPBJHutY2JT3x1rtt17GDMx4lGLUKiSnYapmAQzqkY=;
        b=FV3cFk4tB7yhnj/7aMI1tyutOIEixWTcp2MsxpxdxQA65Qvna33nzotfnN7/AzgNgL
         ek1RKFOoIUz32fEM3JgqXnp4gNQzXkCFS2Ek+hrywbJgukWjiJZpq2u09UT9fB0WZg8Q
         XRmVGfh3Fk1AhwepCgLENmQinGPupafWa4Pkc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LiPBJHutY2JT3x1rtt17GDMx4lGLUKiSnYapmAQzqkY=;
        b=XWCSOWKwVuQiGafl5Uw226SnzYg7LSpP+pcHAtNsYMq6iidtiEHFV6jGQXGmUGO+hP
         Tcq17kG9Q33Q1UBeHt+Li7aAMP/2YNjXaj97T2YrXWuOFxXKU6Km+8ymKGvopxehOt0w
         SVEzl6H9gpYHkxp4A531QLgrg+YVOugqLzM993s26mI2RDAb0sEvkRBL+5l16zfvVKLq
         F7rcNNks2Mc0Ak2hyi9MW3Jio0CGM5OPmzHjCGetcWQ/U7+gJj1aBL38O1II+MWWmOw2
         IJwzHHENbFPAxWcErKOyeGOCJkbPXcdb+DkYx0Lot/0Y6qFQsYq+iZOnBup2Qvp9SE2q
         sXlQ==
X-Gm-Message-State: AOAM5307XHwiJ4HavZAaRHBXCKX2ROsKIsSLlHLQx4SN2iwU/EjdCf9w
        b00Ki8ahMkFY7FRjetVRvCC7DA==
X-Google-Smtp-Source: ABdhPJyzufp6Kg7E9n0waFJLeQepIcJX8JWih+Xg6HWqJfZpBasOfT+RTB/VFy+cbUt+0coC/JOUow==
X-Received: by 2002:a05:6e02:1aa7:: with SMTP id l7mr21771403ilv.187.1624975204243;
        Tue, 29 Jun 2021 07:00:04 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id a12sm2785560ilt.3.2021.06.29.07.00.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Jun 2021 07:00:03 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/71] 5.4.129-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210628143004.32596-1-sashal@kernel.org>
 <d3122f35-4659-8bed-65eb-77087eec82fe@linuxfoundation.org>
 <YNq5mSk5MW3Uq60H@kroah.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <b3ebfc9b-ab6f-db28-f64a-a6cdd0bf2dfd@linuxfoundation.org>
Date:   Tue, 29 Jun 2021 08:00:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YNq5mSk5MW3Uq60H@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/29/21 12:11 AM, Greg Kroah-Hartman wrote:
> On Mon, Jun 28, 2021 at 02:57:20PM -0600, Shuah Khan wrote:
>> On 6/28/21 8:28 AM, Sasha Levin wrote:
>>>
>>> This is the start of the stable review cycle for the 5.4.129 release.
>>> There are 71 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Wed 30 Jun 2021 02:29:43 PM UTC.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>>           https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.4.y&id2=v5.4.128
>>
>> My tools are failing on this link. Is it possible to keep the rc patch
>> convention consistent with Greg KH's naming scheme?
> 
> What is failing on this, the use of "&" in the link?  The patch itself
> from this link works for me.
> 

The link itself is good. My scripts assumes patch-5.4.128-rc1.gz naming
convention. I can adjust my scripts to work with either.

Easier to adjust my script if it is a pain to adjust on your end. :)

thanks,
-- Shuah



