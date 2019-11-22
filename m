Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37A1D10747C
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 16:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbfKVPCr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 10:02:47 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:32878 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbfKVPCr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Nov 2019 10:02:47 -0500
Received: by mail-io1-f67.google.com with SMTP id j13so8394982ioe.0
        for <stable@vger.kernel.org>; Fri, 22 Nov 2019 07:02:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PxNAVs84y6+SdjyjG3T0bh7Cdn5TKSY5guXJVYla5a0=;
        b=Qqav0lsbtPScG0UOqGuwD03uWyG+fZJf9/lRFrM6uiGX4IG+jbsu+j7SR9Djgs2YbY
         2HjIkw4QToMAUPgexium8gqB/KbfNMYvRZ0lW5ibRwX1uQOfkpIV49tlBCocQPU16CoG
         Xc2/dWOLWhYRTShLPJlavRo08QrP61d6PU0XU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PxNAVs84y6+SdjyjG3T0bh7Cdn5TKSY5guXJVYla5a0=;
        b=cHHRpAL3p9QV+tXxVA89Bs0hrhYZ/YHzVwanduzgR8Wy4TT2iGvp3qakuJmMHGPxDI
         kVZhXvgINCZVDyO8DWjO4t81etH4lb0DPlJJLyEU6Una/OTf+MbFDLUboycslWzkSQsk
         cRNbCrifchs1UnJDSj/GoVcxHwRyyWqsgOUaRTtBjJwSLD/92NIZ6i8tUCujRM5aJwnt
         YwhKGLs/SLdaTEW8vEmGk9mW59bW46OyDSxe3izCGn6Pnfu9/Dq6JnCr7sXk13JpZ12R
         BmwuGihju35OMMPyowVLwxWYQZlwo3Fu0/o1i/7sx8FAeCUcFm0WD4FWcSSa+WRBvGSa
         qqpA==
X-Gm-Message-State: APjAAAUqhBJJjmF8U2e2WzPeTCCkHo1gQgMKuSCcan2c6aVmOxHN3B5C
        Y/EcgtP7puyj0uNnD8AzqcaA23VCdBM=
X-Google-Smtp-Source: APXvYqzZRyzNpVJBMZeDUWupKu+gILtzBpEeZraZSJZ/RrbsiZNRLB7Zm9rrc7n+rU1kJ/uscdFzow==
X-Received: by 2002:a02:92c8:: with SMTP id c8mr13993197jah.2.1574434966112;
        Fri, 22 Nov 2019 07:02:46 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id v15sm3029217ilk.8.2019.11.22.07.02.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Nov 2019 07:02:45 -0800 (PST)
Subject: Re: Linux 5.3.12 BOOT TEST: Compiled, Booted, everything OK.
To:     Greg KH <gregkh@linuxfoundation.org>,
        "Daniel W. S. Almeida" <dwlsalmeida@gmail.com>
Cc:     stable@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        shuah Khan <skhan@linuxfoundation.org>
References: <a02e01c5-635f-60c3-9d27-6c13abda8ffa@gmail.com>
 <20191121202104.GA812038@kroah.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <078909db-a4e6-3656-67a4-f55cec7395c6@linuxfoundation.org>
Date:   Fri, 22 Nov 2019 08:02:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191121202104.GA812038@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/21/19 1:21 PM, Greg KH wrote:
> On Thu, Nov 21, 2019 at 03:55:34PM -0300, Daniel W. S. Almeida wrote:
>> ~ 2hr uptime: no crashes, no new errors on dmesg, everything looks good.
> 
> Thanks for testing.
> 
>> *This pops up after diffing the output of kselftest though:*
>>
>> < # ./reuseport_bpf: Unable to open tcp_fastopen sysctl for writing:
>> Permission denied
>> ---
>>> # ./reuseport_bpf: ebpf error. log:
>>> # 0: (bf) r6 = r1
>>> # 1: (20) r0 = *(u32 *)skb[0]
>>> # 2: (97) r0 %= 10
>>> # 3: (95) exit
>>> # processed 4 insns (limit 1000000) max_states_per_insn 0 total_states 0
>> peak_states 0 mark_read 0
>>> #
>>> # : Operation not permitted
>>
>> I did not run kselftest as root. I assume it is nothing noteworthy?
> 
> Is this a new issue, or has it always been there?
> 

This is not new issue. Running a root is required based on results
from my test runs.

thanks,
-- Shuah

