Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCAB82A182A
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 15:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727356AbgJaObg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 10:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgJaObf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Oct 2020 10:31:35 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ED81C0617A6;
        Sat, 31 Oct 2020 07:31:35 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id g43so582696otg.13;
        Sat, 31 Oct 2020 07:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mkpAKNQWAXd1e0DuF5o8hmnhnjSq3v1PpopqWN1V8+E=;
        b=KRFpmuGaQ5raW601ZJMDEJD1AV2N/jp13lax1YGQia+QUl3JbYsW6yaoZ155vIWyn7
         MCYvoHaNDnasgM1p3I+UdqSkh976c5JmCvdMKQsHvmh1rovj+Aav9RiBIuFtqNKcUzfc
         VpmA1GcRIKO/I/lHdgIUY2y6VpvvhBpqCcxdPl37asX/80oyi8VET/pjjCygD6WXceFg
         6nYQYa8hp852AOQBHj8WjtzKLuagytoAHdDWxbASWZRgqQwxaLCQjhtFYlC616sfNK/l
         L+sbPPkTh2RBGqsI9+mPShkgJl+f8ZqdLeLrI6cTasFikJ04v85b5cVZGFaL+qkWnRGr
         K3Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=mkpAKNQWAXd1e0DuF5o8hmnhnjSq3v1PpopqWN1V8+E=;
        b=fWRgojQKRvA6AzLuk8h4CSQTeKTgT8+LunVsEdHRCrn/64gsWFPuIJe3DKzF1AqbHc
         EN5Ue/5WnrECZgsP9NXUaDnxEYmSGaFppOaTVkX0tp9JaVJMAZN+TcrEtLZNohh0mwKc
         41jg2dF/o2J+70S15G0zzpsxs3HBM8dkm0Xy6ohn3UPmNIYoBZ9mnV5IH7uiOta+Ii6Y
         X6Da4UfVAiU/qSswJyxPZK6lJHC6jbRFf3uYiPSlkNFKQ/dG3pRrLeKouN8S94d37BLm
         jttzfUAX80ieIzOhjygX3NAb535FZMPpooA+U8rZ7e7fpsxFxtXPOs3NvwE7bz4OUxqh
         EwrQ==
X-Gm-Message-State: AOAM533JhOfFhW0e+byordPKkQF5M3XXjdikDGzmjFc+p57qV7mJAuwW
        AETbrFkBWw73LE3e2g0oNYIVlBE2Co8=
X-Google-Smtp-Source: ABdhPJzPJ7cca9KGmEmkFiEHLrxjkCpkf2Em8Bp13xGDo2jpIaswfsCnvhvfyRfle/Gqm83iwyPtng==
X-Received: by 2002:a9d:2a88:: with SMTP id e8mr5363785otb.122.1604154694917;
        Sat, 31 Oct 2020 07:31:34 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h6sm2223620oia.51.2020.10.31.07.31.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Oct 2020 07:31:34 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH 4.19 000/264] 4.19.153-rc1 review
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
References: <20201027135430.632029009@linuxfoundation.org>
 <20201028171035.GD118534@roeck-us.net> <20201028195619.GC124982@roeck-us.net>
 <20201031094500.GA271135@eldamar.lan>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <7608060e-f48b-1a7c-1a92-9c41d81d9a40@roeck-us.net>
Date:   Sat, 31 Oct 2020 07:31:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201031094500.GA271135@eldamar.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/31/20 2:45 AM, Salvatore Bonaccorso wrote:
> Hi Greg,
> 
> On Wed, Oct 28, 2020 at 12:56:19PM -0700, Guenter Roeck wrote:
>> Retry.
>>
>> On Wed, Oct 28, 2020 at 10:10:35AM -0700, Guenter Roeck wrote:
>>> On Tue, Oct 27, 2020 at 02:50:58PM +0100, Greg Kroah-Hartman wrote:
>>>> This is the start of the stable review cycle for the 4.19.153 release.
>>>> There are 264 patches in this series, all will be posted as a response
>>>> to this one.  If anyone has any issues with these being applied, please
>>>> let me know.
>>>>
>>>> Responses should be made by Thu, 29 Oct 2020 13:53:47 +0000.
>>>> Anything received after that time might be too late.
>>>>
>>>
>>> Build results:
>>> 	total: 155 pass: 152 fail: 3
>>> Failed builds:
>>> 	i386:tools/perf
>>> 	powerpc:ppc6xx_defconfig
>>> 	x86_64:tools/perf
>>> Qemu test results:
>>> 	total: 417 pass: 417 fail: 0
>>>
>>> perf failures are as usual. powerpc:
> 
> Regarding the perf failures, do you plan to revert b801d568c7d8 ("perf
> cs-etm: Move definition of 'traceid_list' global variable from header
> file") included in 4.19.152 or is a bugfix underway?
> 

The problem is:

In file included from util/evlist.h:15:0,
                 from util/evsel.c:30:
util/evsel.c: In function ‘perf_evsel__exit’:
util/util.h:25:28: error: passing argument 1 of ‘free’ discards ‘const’ qualifier from pointer target type
/usr/include/stdlib.h:563:13: note: expected ‘void *’ but argument is of type ‘const char *’
 extern void free (void *__ptr) __THROW;

This is seen with older versions of gcc (6.5.0 in my case). I have no idea why
newer versions of gcc/glibc accept this (afaics free() still expects a char *,
not a const char *). The underlying problem is that pmu_name should not be
declared const char *, but char *, since it is allocated. The upstream version
of perf no longer uses the same definition of zfree(). It was changed from
	#define zfree(ptr) ({ free(*ptr); *ptr = NULL; })
to
	#define zfree(ptr) __zfree((void **)(ptr))
which does the necessary typecast. The fix would be to either change the definition
of zfree to add the typecast, or to change the definition of pmu_name to drop the const.
Both would only apply to v4.19.y. I don't know if either would be acceptable.

Either case, reverting b801d568c7d8 won't solve that problem.

Guenter
