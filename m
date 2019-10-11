Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2082CD40C8
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 15:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbfJKNPD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 09:15:03 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37877 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727909AbfJKNPD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Oct 2019 09:15:03 -0400
Received: by mail-pf1-f193.google.com with SMTP id y5so6094074pfo.4;
        Fri, 11 Oct 2019 06:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5dpAxIq0oRut154BI+yiCI47QjZYC6lAR9UcaGRAy/U=;
        b=a5Z9tUP4KnKzxAOLLHR6SNOUma9xq6R+9JSMmSRllnBoNaqF5wHZ0z9m951oOO+Fe2
         tb32j8wbnzMtuAoEFFXQv4QS2uSr9db3fZVVKDDDUkD/hf6xHGANxMbTFnuAw2nJLIli
         Cdki1GK31sNoP2eK1QZuJN6G+J6i2aqJWECRz4JOaZ/ZgKVITp/8H5OC6/XYRu6PpkBO
         e/Y2p2jHBpBR5dEbZSwQPzyb5RqI3/CB3QEKMlIaEcQqkkRFC4rCBh7DopC98nQP+03y
         sKLmT2mv+ew4hj8YtTUSgEtioY/m3rJkHz2JYzP/8udZYkS/FEANXiJnM+NuPppeYH7c
         bJwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5dpAxIq0oRut154BI+yiCI47QjZYC6lAR9UcaGRAy/U=;
        b=jXE6uHnArpk/L2fwFi0umMphcJKSInoJRmQvveGMTR/XlIz2fwU9zXwX+qtUZWwvFf
         ieBzlPxNfHVIvvZ6rFEbiFYPB/5kbsXY+dEDnb3mzRNyH36/ko/spB7/TNhiSLKLUb+T
         F3hqFDVNgqcdZLIhnELSDePZoQMLRVtU0N4MlSAiWfHbz00awDedKoLwiQxd5ghd6bMl
         I8PylcKXS4/AY9s2CH13Itw3bUK31Ry3S/ffbZ5UyJKdZvrX3Z4/EBiKQK4TFO0EK1B6
         1CZmjPBsrRMxuhJzHEhQN4FMkPmwcJKArlJ91Au6s6SJY63Y+kk7Bjd1BE6UGTJIyxP6
         tfFw==
X-Gm-Message-State: APjAAAVELGe1femVCZhZehuuGv8wJdlqW+PHiWqgrAwBpPXK15sscpAs
        xafBct43IINTFPHCZXCic8APIwMv
X-Google-Smtp-Source: APXvYqxpypOW/RODa2t2mycHthlzNX/Oo11hZqDdYWZm9g7iAvTUd/ddR/QjMfrCq2T6SwD91NCHbQ==
X-Received: by 2002:aa7:924f:: with SMTP id 15mr16586251pfp.194.1570799701215;
        Fri, 11 Oct 2019 06:15:01 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o9sm8493658pfp.67.2019.10.11.06.14.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Oct 2019 06:15:00 -0700 (PDT)
Subject: Re: [PATCH 4.14 00/61] 4.14.149-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20191010083449.500442342@linuxfoundation.org>
 <ce4b3f10-eafd-1169-9240-fb3891279c2a@roeck-us.net>
 <20191011042945.GB939089@kroah.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <fde4b241-2932-c543-d540-cc89f2b1eac0@roeck-us.net>
Date:   Fri, 11 Oct 2019 06:14:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191011042945.GB939089@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/10/19 9:29 PM, Greg Kroah-Hartman wrote:
> On Thu, Oct 10, 2019 at 10:12:26AM -0700, Guenter Roeck wrote:
>> On 10/10/19 1:36 AM, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 4.14.149 release.
>>> There are 61 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Sat 12 Oct 2019 08:29:51 AM UTC.
>>> Anything received after that time might be too late.
>>>
>>
>> Preliminary.
>>
>> I see several mips build failures.
>>
>> arch/mips/kernel/proc.c: In function 'show_cpuinfo':
>> arch/mips/include/asm/cpu-features.h:352:31: error: implicit declaration of function '__ase'
> 
> Thanks, will go drop the lone mips patch that I think is causing this
> problem.
> 

Looks like it did. For v4.14.148-61-g6f45e0e87a75:

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 372 pass: 372 fail: 0

Guenter
