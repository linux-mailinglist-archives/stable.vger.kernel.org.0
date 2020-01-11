Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D040913837B
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 21:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731055AbgAKUKN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 15:10:13 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:42729 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731045AbgAKUKN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jan 2020 15:10:13 -0500
Received: by mail-pl1-f194.google.com with SMTP id p9so2193366plk.9;
        Sat, 11 Jan 2020 12:10:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EjEIhTS0iFDpHoRJO5ZblD6G1YeXP+2uPWxoytZcfgA=;
        b=Ap3Qxu9yHUTBHmX9MFzouoGff8y7oJqDatdU2bsRFXRy75z2xvjtEDzyVUyOuMhl+Q
         cb3x+m5S3JQZg7gtTIiArhAFPSupIpru1FwpAFv8QA1k+/mlLh6bRSMh5DptVZrl1Tfh
         Fc4MgXXGmaImBOrhTEBij4OPqI3PJXCI0KeKymSTvrZpra9TPOVLiHlrv3sJtScSg9vQ
         bNZu8qc7rgbxV9Ccunqxt8vasizFz9+VCtHO09z7z0t7xVwT80M1d0Z+QIFh7V8t3iRo
         SckA+oMsBcN/w8QsjL/MFFdTbE9KmMd8oq+D5x+VonpLUF16mWfWQD0Ot7SNqf42Sy+r
         5qtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EjEIhTS0iFDpHoRJO5ZblD6G1YeXP+2uPWxoytZcfgA=;
        b=FlPRj57Seh6hAEDt7+zBjBV+BQFMmZgWXWM7a1ygR3B/3tVqf1EjB4dqKTGqcDKRXm
         MZnyWB7jnrPzJOHko6moC5OILEFoofSF1T4PYTp/svIVuglOy4cXDcCH7otBYxBXWA34
         Z5sGDt1IojQeF98vjYIbbGMvfgZJiGgUTQG6sLWQWssBAXHkm57HXpX4RL0DXxIAe6Dj
         piMvjfEoTTX4uCqG+DNwLOX2qMahirPzQhEENzhnNw00A/2fPHgf7n0F6gib8c9yjrLY
         Ft4HHxCscEP2J4KRl64lDC2qtXhXuP7iSTuul+COi1WjKzC6oYNt3r7ujne9AiBuy7F+
         t8Dg==
X-Gm-Message-State: APjAAAUooKx+DJtn52gvAc89IarphLUY4siJnicM6rDRxNbGWnpifLFE
        3Gd9hNQ2a7vioNYJNrWLMd/60HLX
X-Google-Smtp-Source: APXvYqwwlxVho/Edn9u5Kr57ZjbZhv+FJdmPDcA8eKmLyDqqU2VoIibaoFHWrR6At2lZ0YOvF8vokw==
X-Received: by 2002:a17:902:74cb:: with SMTP id f11mr6183241plt.139.1578773412581;
        Sat, 11 Jan 2020 12:10:12 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 13sm7857811pfi.78.2020.01.11.12.10.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Jan 2020 12:10:12 -0800 (PST)
Subject: Re: [PATCH 4.19 00/84] 4.19.95-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20200111094845.328046411@linuxfoundation.org>
 <23c3a0d1-1655-8cc2-7c96-743a47953795@roeck-us.net>
 <20200111174715.GB394778@kroah.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <565353ce-9383-9af6-3150-529e9ef73398@roeck-us.net>
Date:   Sat, 11 Jan 2020 12:10:11 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200111174715.GB394778@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/11/20 9:47 AM, Greg Kroah-Hartman wrote:
> On Sat, Jan 11, 2020 at 08:02:40AM -0800, Guenter Roeck wrote:
>> On 1/11/20 1:49 AM, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 4.19.95 release.
>>> There are 84 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Mon, 13 Jan 2020 09:46:17 +0000.
>>> Anything received after that time might be too late.
>>>
>> Build results:
>> 	total: 156 pass: 154 fail: 2
>> Failed builds:
>> 	arm64:defconfig
>> 	arm64:allmodconfig
>> Qemu test results:
>> 	total: 382 pass: 339 fail: 43
>> Failed tests:
>> 	<all arm64>
>>
>> arch/arm64/kvm/hyp/switch.c: In function 'handle_tx2_tvm':
>> arch/arm64/kvm/hyp/switch.c:438:2: error: implicit declaration of function '__kvm_skip_instr'; did you mean 'kvm_skip_instr'?
> 
> Thanks for this, I'll go push out a -rc2 with the offending patch
> removed.
> 

For v4.19.94-84-g4f77fc728c70:

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 382 pass: 382 fail: 0

Guenter
