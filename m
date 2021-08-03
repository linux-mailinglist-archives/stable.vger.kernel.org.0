Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC593DF6A0
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 22:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbhHCUwj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 16:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbhHCUwj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Aug 2021 16:52:39 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEABEC061757;
        Tue,  3 Aug 2021 13:52:27 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id v8-20020a0568301bc8b02904d5b4e5ca3aso9767365ota.13;
        Tue, 03 Aug 2021 13:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VtphRU8oFphgqW5P1QLuJue1xk+Dt0j5gKSN+F1DYxk=;
        b=U7VCqY0WXTGadjSfnxfoaKYmee/gjmyDh45M1yOpdumZVN+km8uYA5i2zmyczuD8vC
         TDThmysG5EOvIIWfeWzzsKb0HA1zMXSLyqu/Ie8gGbB1WGycxkHNUaB0auSBDVfu64vW
         XA8m7nAaNKGwzPOAlDjA4VYQlp3T6coP9jH8//DadGZLe0N/DDvMx/Om8H4bmy9dH1Ra
         JDd4ev5S2KIh63RYmQprOXftGWmJx8bfcSU7hz+Pnqq0ZszFqWeN86ewOs8Se2b6qc7+
         lzeejxUJEt8iHwlXND5muYkeAVfFH1p+eqsnQ7RxN2cHMlY3qR6ST3eQgk1oz/fAiBhr
         fnHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VtphRU8oFphgqW5P1QLuJue1xk+Dt0j5gKSN+F1DYxk=;
        b=PO5k0sszxjsehiCcK8P5cFTVzWFrILJmixg0A17JiFqdIs4Rqn1EpI4jj92i+imFFz
         YpAfRmF7e7BA3pkXuroeAtIrQ37+YJ5PblSCUQNxjJZQ8ZAxNnPDV8irvql08z1ICGnN
         C/uWd1CAWU027XJ7/Kg1mDaqWJvbk+COZ/Fv60Hbb+rRbgolfgtYypUIdPVW5Ti0wFlH
         CM1u9zwREln05Cwzkn/LSbsCyWaA9bA4IAhkHb6W6R9JwGW14Nrcnski9LkCj5Fsh/JN
         T4LLi8p4yj9RBDF9nbPU1EQK8WnffwQcuvFV3SAM+f2CRsnt96tsfLp8hPtlAAEEb/4q
         qMog==
X-Gm-Message-State: AOAM533Mw79N0R+ge6m9USryJlbMYaSEBZgpmyQ7Xk1QJ7QYX8ouNB58
        73k7okcCLWy63GkG8KksiKmGGxaX7eM=
X-Google-Smtp-Source: ABdhPJyBoTrMlO3Oi4wC4m7X3eNMpBoVGZcEPHwiLqIfRVdRy9e2O5wOnTXYF1YcEWnsS6a7wL5/pw==
X-Received: by 2002:a9d:63da:: with SMTP id e26mr149665otl.153.1628023946961;
        Tue, 03 Aug 2021 13:52:26 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g1sm29698otk.21.2021.08.03.13.52.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 13:52:26 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH 5.10 00/67] 5.10.56-rc1 review
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
References: <20210802134339.023067817@linuxfoundation.org>
 <20210803192607.GA14540@duo.ucw.cz>
 <c1d12ff5-06d5-075c-e01f-5184ffb09e69@roeck-us.net>
 <20210803195026.GA16178@duo.ucw.cz>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <fb1e3a3a-9e6b-f397-c803-054fe96fc3c4@roeck-us.net>
Date:   Tue, 3 Aug 2021 13:52:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210803195026.GA16178@duo.ucw.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/3/21 12:50 PM, Pavel Machek wrote:
> On Tue 2021-08-03 12:37:29, Guenter Roeck wrote:
>> On 8/3/21 12:26 PM, Pavel Machek wrote:
>>> Hi!
>>>
>>>> This is the start of the stable review cycle for the 5.10.56 release.
>>>> There are 67 patches in this series, all will be posted as a response
>>>> to this one.  If anyone has any issues with these being applied, please
>>>> let me know.
>>>
>>> Not sure what went wrong, but 50 or so patches disappeared from the queue:
>>>
>>> 48156f3dce81b215b9d6dd524ea34f7e5e029e6b (origin/queue/5.10) btrfs: fix lost inode on log replay after mix of fsync, rename and inode eviction
>>> 474a423936753742c112e265b5481dddd8c02f33 btrfs: fix race causing unnecessary inode logging during link and rename
>>> 2fb9fc485825505e31b634b68d4c05e193a224da Revert "drm/i915: Propagate errors on awaiting already signaled fences"
>>> b1c92988bfcb7aa46bdf8198541f305c9ff2df25 drm/i915: Revert "drm/i915/gem: Asynchronous cmdparser"
>>> 11fe69a17195cf58eff523f26f90de50660d0100 (tag: v5.10.55) Linux 5.10.55
>>> 984e93b8e20731f83e453dd056f8a3931b4a66e5 ipv6: ip6_finish_output2: set
>>> sk into newly allocated nskb
>>
>> FWIW, the git repository matches the shortlog and summary.
> 
> git log --pretty=oneline origin/linux-5.10.y
> 
> seems to match shortlog/summary.
> 
> git log --pretty=oneline origin/queue/5.10
> 
> is unexpectedly short. Short changelog can also be seen on the web:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/log/?h=queue/5.10
> 
> (and 4.19/ 4.4 repositories have same problem, it is even more visible
> there.)
> 

Ah, that explains it. No idea what the queue/ branches are for.
My scripts use the linux- branches.

Guenter
