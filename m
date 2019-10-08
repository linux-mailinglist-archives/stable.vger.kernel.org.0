Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD1A2CF11A
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 05:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729730AbfJHDNI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 23:13:08 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41917 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729536AbfJHDNI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 23:13:08 -0400
Received: by mail-pf1-f194.google.com with SMTP id q7so9921300pfh.8;
        Mon, 07 Oct 2019 20:13:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MwOr1Yqsq0vV0L2I0NuVxBn/YJkcXrSl5bx2uwm6GME=;
        b=l5DQgPL2Y+0qJXzGNoIaNDOAAIUJAk63EXpupbo+H3/fiTJ5modtP5d7iA6U+VfMhk
         OBjVGHCy6FaDj3AuFsasOQQ8RUord7oybiI12W0qKEl+M2XXUgqu8VSGVzSOCmtzA2CH
         sEF363igvp2bC4v0mTB6FF5EU/rszyjfER5wfETyzGteql8Teb70RDknSIosrHaQJ9+K
         LcBvIcdTTMTBtoa1SOxNtaKzR7PamQaMwo58AIbfWdd6uS8ppsJcf5egYQLwYl/fFV/o
         bKGFMP7VN5YYhOp2pzHsBggjiBYGDcejwSMIdLrAHNwHruk9+8gGSlFK0gotavTOaqiS
         lzpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MwOr1Yqsq0vV0L2I0NuVxBn/YJkcXrSl5bx2uwm6GME=;
        b=RFelGU2khEtrAa8WN4mNYOaFLGZLUoHmDCd74sWchbWPWMm1eVy+pKXrZg8KT4wmYt
         AN9VvI5NOfFr36NLSHuHkm4o/nSD1ROrIY4TKGzFcG4CrYbC1HRTuoQHg2zTXvFmbLvu
         6kBEvBis4UHExZHfq/lQph2vfcHZHCM+Z1/wum8J9uOaPmqNE7VO2wGy42x8EFLuAiye
         DwN5cCb5TSvWS3Jwzi1SwpSg+qgrd2zbIuH6Xc3KYI2/4O3oUU45UZ/ZAITvb4oo0+yy
         S02oaXN/t4MwPoAfDO0sOHAAS++3ByFUU7j5ZLm3tMHPJOXLDJVH8zxrqixDI8oIta6n
         Vl4Q==
X-Gm-Message-State: APjAAAXzjea5UAZiG5ooG6By5a6gPv9dG/158lygUwuOlNraux5rWxEN
        qeP2Hs8rVILm90PH2nrU32DgW3wP
X-Google-Smtp-Source: APXvYqz/aTjJrRNMzNO1/XB1zmUl5/r7tcj7a/bk8SorwCF5Qq9Ugle+lKHLjSticXDM+CViaWRbDg==
X-Received: by 2002:a63:2348:: with SMTP id u8mr2860808pgm.344.1570504387491;
        Mon, 07 Oct 2019 20:13:07 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s1sm9574747pgi.52.2019.10.07.20.13.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Oct 2019 20:13:06 -0700 (PDT)
Subject: Re: [PATCH 4.4 00/36] 4.4.196-stable review
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20191006171038.266461022@linuxfoundation.org>
 <d3e1e6ae-8ca4-a43b-d30d-9a9a9a7e5752@roeck-us.net>
 <20191007144951.GB966828@kroah.com> <20191007230708.GA1396@sasha-vm>
 <35f5fb99-6c35-9afd-1a4e-3fa7d4ba213a@roeck-us.net>
 <20191008014954.GB1396@sasha-vm>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <4e0e8cf2-a085-9bdf-b084-a3cb205bb100@roeck-us.net>
Date:   Mon, 7 Oct 2019 20:13:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191008014954.GB1396@sasha-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/7/19 6:49 PM, Sasha Levin wrote:
> On Mon, Oct 07, 2019 at 04:16:51PM -0700, Guenter Roeck wrote:
>> On 10/7/19 4:07 PM, Sasha Levin wrote:
>>> On Mon, Oct 07, 2019 at 04:49:51PM +0200, Greg Kroah-Hartman wrote:
>>>> On Mon, Oct 07, 2019 at 05:53:55AM -0700, Guenter Roeck wrote:
>>>>> On 10/6/19 10:18 AM, Greg Kroah-Hartman wrote:
>>>>>> This is the start of the stable review cycle for the 4.4.196 release.
>>>>>> There are 36 patches in this series, all will be posted as a response
>>>>>> to this one.  If anyone has any issues with these being applied, please
>>>>>> let me know.
>>>>>>
>>>>>> Responses should be made by Tue 08 Oct 2019 05:07:10 PM UTC.
>>>>>> Anything received after that time might be too late.
>>>>>>
>>>>>
>>>>> powerpc:defconfig fails to build.
>>>>>
>>>>> arch/powerpc/kernel/eeh_driver.c: In function ‘eeh_handle_normal_event’:
>>>>> arch/powerpc/kernel/eeh_driver.c:678:2: error: implicit declaration of function ‘eeh_for_each_pe’; did you mean ‘bus_for_each_dev’?
>>>>>
>>>>> It has a point:
>>>>>
>>>>> ... HEAD is now at 13cac61d31df Linux 4.4.196-rc1
>>>>> $ git grep eeh_for_each_pe
>>>>> arch/powerpc/kernel/eeh_driver.c:       eeh_for_each_pe(pe, tmp_pe)
>>>>> arch/powerpc/kernel/eeh_driver.c:                               eeh_for_each_pe(pe, tmp_pe)
>>>>>
>>>>> Caused by commit 3fb431be8de3a ("powerpc/eeh: Clear stale EEH_DEV_NO_HANDLER flag").
>>>>> Full report will follow later.
>>>>
>>>> Thanks for letting me know, I've dropped this from the queue now and
>>>> pushed out a -rc2 with that removed.
>>>>
>>>> Sasha, I thought your builder would have caught stuff like this?
>>>
>>> Interesting, the 4.4 build fails for me with vanilla 4.4 LTS kernel
>>> (which is why this was missed):
>>>
>>>  AS      arch/powerpc/kernel/systbl.o
>>> arch/powerpc/kernel/exceptions-64s.S: Assembler messages:
>>> arch/powerpc/kernel/exceptions-64s.S:1599: Warning: invalid register expression
>>> arch/powerpc/kernel/exceptions-64s.S:1640: Warning: invalid register expression
>>> arch/powerpc/kernel/exceptions-64s.S:839: Error: attempt to move .org backwards
>>> arch/powerpc/kernel/exceptions-64s.S:840: Error: attempt to move .org backwards
>>> arch/powerpc/kernel/exceptions-64s.S:864: Error: attempt to move .org backwards
>>> arch/powerpc/kernel/exceptions-64s.S:865: Error: attempt to move .org backwards
>>> scripts/Makefile.build:375: recipe for target 'arch/powerpc/kernel/head_64.o' failed
>>>
>>
>> Is this allmodconfig ? That is correct - it won't build in 4.4.y, and it would not be
>> easy to fix.
> 
> Oh, interesting, so no allmodconfig? I've disabled everything but
> allmodconfig on a few architectures in an attempt to save to build time.
> 

If I recall correctly, it stopped working quite some time ago for v4.4.y, and the powerpc
maintainers didn't want to spend the time fixing it. It works with v4.9.y and later.

Guenter
