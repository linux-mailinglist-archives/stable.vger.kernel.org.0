Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CEAB4D54F5
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 00:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344056AbiCJXDy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 18:03:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244176AbiCJXDx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 18:03:53 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F05D8861
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 15:02:50 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id e13so6215256plh.3
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 15:02:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=qCMfsAHqhyUTf8fGA4OHhtye0xi2CMmHfA8bKqnUOwU=;
        b=lTIm6tcynZZZZo+qzBuJkyCnE4SOADxBnvgaYZoo0BfrlKjaT2/ycA5aM4ucCs9DRm
         A40bsgqfpYfNkXrpTTq+RtdQJ5apjKjPihr+2QKy0dHc+WPb64rottYAyH9KT4fSTJ6f
         uMLKFM0rtA9ulOVMEihml7zQlcjinPqsnTBTXV2HnNALTSX7gnl0P/LACOnXG13mkmY5
         9ujpHbi6VUsYBwbdmEBIX9RPuZqNqUnvLM8N36WyjG0EZMeyIBbXs6VshlvPgKns8KI0
         rgOe+QH+RZyzXYT1LXkaLDu3lxYjZ7nGb26Qh3eQ0AZo6hlqsduUOAI8yyeuOrVIeVdL
         uwyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qCMfsAHqhyUTf8fGA4OHhtye0xi2CMmHfA8bKqnUOwU=;
        b=dQWbZYsTE8HnPjnlcz+ZIAR7ZgSgWWLOyDqRs4p7EXmjoKxung88JXdurnpYf3VaEI
         zb9Ja/OufCC+HoCpp+/TeSAIZqwg8U+u59JRJ4kutskx2bBa0mjDhXwV5tPFy0yTs4vC
         cJouR3ZzFCjvFmvEcrInhDI4kxI2ZHUzH2cxyzvDXGefY7MfwAlsBFN0XBeYCLE4Lgpx
         8UYKBQC5ln9PC6s3dU+/nLK4wGRzp9OUqmzoQkE5ougO9CDauyD9Y8ymbNQu/xBDSVJF
         t63vvBG+JjmkZ6aFaJfu511S8rfvIPPxt5DpE0x0Lc/kHpv5u2pugHAzli/chVSMKIyZ
         VnoA==
X-Gm-Message-State: AOAM530mMHgPPw5A+/FU7JiUTT9E1EvxrfqNfJnbioUELaPIqfgeCj9M
        5NYzB7l8Q/W3Qp6Hq/J+FSsZAA==
X-Google-Smtp-Source: ABdhPJxkBgTssqHrG0TSK20fB1rNsXucs78oWP3GJVb0mgEcRUQTMz6BAmM8EHaGJfpPH6DEMePBaQ==
X-Received: by 2002:a17:90b:1941:b0:1bf:5440:d716 with SMTP id nk1-20020a17090b194100b001bf5440d716mr7475224pjb.147.1646953369999;
        Thu, 10 Mar 2022 15:02:49 -0800 (PST)
Received: from ?IPV6:2600:380:7676:ce7b:11ac:aee8:fe09:2807? ([2600:380:7676:ce7b:11ac:aee8:fe09:2807])
        by smtp.gmail.com with ESMTPSA id p10-20020a056a000b4a00b004e12fd48035sm8358038pfo.96.2022.03.10.15.02.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 15:02:49 -0800 (PST)
Message-ID: <38f7aaf5-2043-b4f4-1fa5-52a7c883772b@kernel.dk>
Date:   Thu, 10 Mar 2022 16:02:47 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH] block: check more requests for multiple_queues in
 blk_attempt_plug_merge
Content-Language: en-US
To:     Song Liu <song@kernel.org>
Cc:     linux-block@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>, stable@vger.kernel.org,
        Larkin Lowrey <llowrey@nuclearwinter.com>,
        Wilson Jonathan <i400sjon@gmail.com>,
        Roger Heflin <rogerheflin@gmail.com>
References: <20220309064209.4169303-1-song@kernel.org>
 <9516f407-bb91-093b-739d-c32bda1b5d8d@kernel.dk>
 <CAPhsuW5zX96VaBMu-o=JUqDz2KLRBcNFM_gEsT=tHjeYqrngSQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAPhsuW5zX96VaBMu-o=JUqDz2KLRBcNFM_gEsT=tHjeYqrngSQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/10/22 3:37 PM, Song Liu wrote:
> On Thu, Mar 10, 2022 at 2:15 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 3/8/22 11:42 PM, Song Liu wrote:
>>> RAID arrays check/repair operations benefit a lot from merging requests.
>>> If we only check the previous entry for merge attempt, many merge will be
>>> missed. As a result, significant regression is observed for RAID check
>>> and repair.
>>>
>>> Fix this by checking more than just the previous entry when
>>> plug->multiple_queues == true.
>>>
>>> This improves the check/repair speed of a 20-HDD raid6 from 19 MB/s to
>>> 103 MB/s.
>>
>> Do the underlying disks not have an IO scheduler attached? Curious why
>> the merges aren't being done there, would be trivial when the list is
>> flushed out. Because if the perf difference is that big, then other
>> workloads would be suffering they are that sensitive to being within a
>> plug worth of IO.
> 
> The disks have mq-deadline by default. I also tried kyber, the result
> is the same. Raid repair work sends IOs to all the HDDs in a
> round-robin manner. If we only check the previous request, there isn't
> much opportunity for merge. I guess other workloads may have different
> behavior?

Round robin one at the time? I feel like there's something odd or
suboptimal with the raid rebuild, if it's that sensitive to plug
merging. Plug merging is mainly meant to reduce the overhead of merging,
complement what the scheduler would do. If there's a big drop in
performance just by not getting as efficient merging on the plug side,
that points to an issue with something else.

-- 
Jens Axboe

