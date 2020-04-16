Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD651ACECD
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 19:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729208AbgDPRg7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 13:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726207AbgDPRg5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Apr 2020 13:36:57 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E7F7C061A0C
        for <stable@vger.kernel.org>; Thu, 16 Apr 2020 10:36:57 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id e25so2239428ljg.5
        for <stable@vger.kernel.org>; Thu, 16 Apr 2020 10:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arrikto-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JgCnAsKYInpmVcComEu1siRHmayq7ys3fnurxAfmQNg=;
        b=weSI6gXMa6eaaA9dVjqRNfD3pW6Bvg93APb/CbCuzq6u5f0j4fb/irlOyhFZEo1I9Q
         aEx1tmQLw+RmcAC6OebDDG+sO0g04lx+hNR5skGYUHHjeFe33VZpVqv4ojGLM5c3dDyR
         CgsqrmAAAucNImomEwVy8OgeFxEQrdlULgWNnKF0KtJzgJlONj2HSx+GRScxuxtGr7h0
         I8XZuhEFPAH6qDIv1KEIet0X3JOKaD26nnDUbdhf2+CAvQXmD3qtRPc0sfm0n6v+6Ixb
         VxhSKuuy4AFjP7CTIKo9G1AAAGFg7pUFYMw+soYfuH/fKyOwcxSjmLhvPkjo0+kXSoBw
         lbFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JgCnAsKYInpmVcComEu1siRHmayq7ys3fnurxAfmQNg=;
        b=UrQcLreRdnyRUuBDThoh3cWOMTSsahVkO8X4E8quXY1jkrxrFOA/Mdtjr7OdVoJTXu
         YH5ReN2nUtJL02OtpZqbdkkaPcBIIxwyEVXROdNfBlPqcaVoo7Y7ylLrs6rgQm6frlC4
         DnLKnr7Km3GGhAwHbNC7dWv9IE3hQqCZrGsMuj2j8AolJ/LV+L8GzspthtV7wzit/v8C
         itOucOKUUhduomXVFw13ncyeqMv8buQhSr5HrImZLjHEK+6YgNS22IhM0olxiYsD0x9K
         wW2ngilao9wPdAo83lA8A3U2iT46NKMq57UEdJnOLQ7XmrBoMALXHmdUIR6gjwYw58PA
         inrA==
X-Gm-Message-State: AGi0Puaihsh0Io/TpDfWCCjXlC4eXG4+qXslmu4SgwZ134WHbzLrQNO3
        W9ZKucvKbZ/IussqiTa4ypqE7Cb0JT4=
X-Google-Smtp-Source: APiQypJ6uL/Fp33oHmrn1tpTT+LRfqnvjDbRoKAYNMkfWjRRjznTlJiQuyPhz9axNTiIAQSBtYsGDw==
X-Received: by 2002:a2e:9a0d:: with SMTP id o13mr6732378lji.142.1587058615397;
        Thu, 16 Apr 2020 10:36:55 -0700 (PDT)
Received: from [192.168.1.112] (62.1.247.111.dsl.dyn.forthnet.gr. [62.1.247.111])
        by smtp.gmail.com with ESMTPSA id j14sm15258294lfm.73.2020.04.16.10.36.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2020 10:36:54 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] dm clone: Fix handling of partial region
 discards" failed to apply to 5.4-stable tree
To:     Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org
Cc:     snitzer@redhat.com, stable@vger.kernel.org
References: <1586948589138112@kroah.com> <20200416005702.GP1068@sasha-vm>
From:   Nikos Tsironis <ntsironis@arrikto.com>
Message-ID: <c762398d-2ce1-7046-907c-392bb26f9758@arrikto.com>
Date:   Thu, 16 Apr 2020 20:36:53 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200416005702.GP1068@sasha-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/16/20 3:57 AM, Sasha Levin wrote:
> On Wed, Apr 15, 2020 at 01:03:09PM +0200, gregkh@linuxfoundation.org wrote:
>>
>> The patch below does not apply to the 5.4-stable tree.
>> If someone wants it applied there, or to any other stable or longterm
>> tree, then please email the backport, including the original git commit
>> id to <stable@vger.kernel.org>.
>>
>> thanks,
>>
>> greg k-h
>>
>> ------------------ original commit in Linus's tree ------------------
>>
>> From 4b5142905d4ff58a4b93f7c8eaa7ba829c0a53c9 Mon Sep 17 00:00:00 2001
>> From: Nikos Tsironis <ntsironis@arrikto.com>
>> Date: Fri, 27 Mar 2020 16:01:08 +0200
>> Subject: [PATCH] dm clone: Fix handling of partial region discards
>>
>> There is a bug in the way dm-clone handles discards, which can lead to
>> discarding the wrong blocks or trying to discard blocks beyond the end
>> of the device.
>>
>> This could lead to data corruption, if the destination device indeed
>> discards the underlying blocks, i.e., if the discard operation results
>> in the original contents of a block to be lost.
>>
>> The root of the problem is the code that calculates the range of regions
>> covered by a discard request and decides which regions to discard.
>>
>> Since dm-clone handles the device in units of regions, we don't discard
>> parts of a region, only whole regions.
>>
>> The range is calculated as:
>>
>>    rs = dm_sector_div_up(bio->bi_iter.bi_sector, clone->region_size);
>>    re = bio_end_sector(bio) >> clone->region_shift;
>>
>> , where 'rs' is the first region to discard and (re - rs) is the number
>> of regions to discard.
>>
>> The bug manifests when we try to discard part of a single region, i.e.,
>> when we try to discard a block with size < region_size, and the discard
>> request both starts at an offset with respect to the beginning of that
>> region and ends before the end of the region.
>>
>> The root cause is the following comparison:
>>
>>  if (rs == re)
>>    // skip discard and complete original bio immediately
>>
>> , which doesn't take into account that 'rs' might be greater than 're'.
>>
>> Thus, we then issue a discard request for the wrong blocks, instead of
>> skipping the discard all together.
>>
>> Fix the check to also take into account the above case, so we don't end
>> up discarding the wrong blocks.
>>
>> Also, add some range checks to dm_clone_set_region_hydrated() and
>> dm_clone_cond_set_range(), which update dm-clone's region bitmap.
>>
>> Note that the aforementioned bug doesn't cause invalid memory accesses,
>> because dm_clone_is_range_hydrated() returns True for this case, so the
>> checks are just precautionary.
>>
>> Fixes: 7431b7835f55 ("dm: add clone target")
>> Cc: stable@vger.kernel.org # v5.4+
>> Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
>> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> 
> I've also grabbed 6ca43ed8376a ("dm clone: replace spin_lock_irqsave
> with spin_lock_irq") to deal with this conflict.
> 

I just saw the mail, thanks a lot for resolving this.

Nikos
