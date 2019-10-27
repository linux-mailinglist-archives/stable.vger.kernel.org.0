Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89E4EE624B
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 13:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfJ0MBH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 08:01:07 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:47099 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726706AbfJ0MBH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Oct 2019 08:01:07 -0400
Received: by mail-pg1-f193.google.com with SMTP id f19so4602972pgn.13
        for <stable@vger.kernel.org>; Sun, 27 Oct 2019 05:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yDbqLx02ji94rlta9aL6spgBmjoZ7cI+VAk2R82pEsg=;
        b=a+MZS7Wc4kx2geNMDCSXyE7i9uwKcwaJ4xqRlqDbGKjtsiZPrIfFMrBvebfYzyVdFu
         Mqv1VadWrnTHT1yDEtd5ML6CKIP0E6Tpw0EuboPpmpnz7yytxS423b0ERne6fD1nfRwR
         qO/kLtGEPYz8HAh04ucNru+7N6ZA3kIYIEq53X1lNYRF2LaxZJ40U8BxHXKEMF+tsOPf
         aRISUbmSyrudVc2E0LhzKA3XZfiulBnmZvISp2C5Rz/mSFizBJAO9cJ3Jd3MTbx0FYAx
         ubIrl/f/NcoS8dNwBwCc53N09PSTgV26zJATEErtsxjp1Rsw4Kkii8jLT3N6P4ebyUSC
         Rjnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yDbqLx02ji94rlta9aL6spgBmjoZ7cI+VAk2R82pEsg=;
        b=cLk/kCmp8y9qy9TqFHirh99XBfRURxDrBx04FLWso8GIZHmQTrfXNWO7ja2CBG/TZH
         Bgfb3ld/AvgXr5O3M6ugKlI4B4Iw7XshTkjsr1PQ8+3TUzIFfN40HtLNBmd9+U9m0+FJ
         HzbbHI1bMUGIuqjYm69PaHE6KGgAPy7RwM+wfHGE95iZ1NlSZATQn1nox+G1MRPC90G+
         EJgLwoVEjiOgoFLgcuN91GpHnvgbFrfec00D9NwYkpFbjn1lfHUWBW4WAMnRS07sOI/t
         C44illKjKNSODLMlhhy0tAjvvGiFfICCm7c7ESXK1+pLIuG8IK8fqCiDe2hcyXzoiEeU
         l0wA==
X-Gm-Message-State: APjAAAX6Zf8fys4pLqKfyiqDg93Hm2DBI0hgemeHqlr6ZA0+EhfBw+18
        fWYj+s5xaJX4hFwqZ5iol2Q4mIQy996sWQ==
X-Google-Smtp-Source: APXvYqyaU1L2PlDW/yGqgFYj8qvD0rpAGn9vAUvoMSMuMKVUHgbmzPN3m2JLMI5dyvo3NaWGKTzXsw==
X-Received: by 2002:a63:ec4f:: with SMTP id r15mr14980353pgj.17.1572177665966;
        Sun, 27 Oct 2019 05:01:05 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.79])
        by smtp.gmail.com with ESMTPSA id g17sm7459671pgn.37.2019.10.27.05.01.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Oct 2019 05:01:05 -0700 (PDT)
Subject: Re: io_uring stable 5.3 backports
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org
References: <efc9278b-de72-40b2-9a0a-48df0c64edc1@kernel.dk>
 <20191027085204.GA1560@sasha-vm>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f90a0bd3-3074-ee14-dea9-63d520bd72a2@kernel.dk>
Date:   Sun, 27 Oct 2019 06:01:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191027085204.GA1560@sasha-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/27/19 2:52 AM, Sasha Levin wrote:
> On Sat, Oct 26, 2019 at 05:33:41PM -0600, Jens Axboe wrote:
>> Hi,
>>
>> For some reason I forgot to mark these stable, but they should go
>> into stable. In order of applying them, they are:
>>
>> bc808bced39f4e4b626c5ea8c63d5e41fce7205a
> 
> This commit says it fixes c576666863b78 ("io_uring: optimize
> submit_and_wait API") which is not in the stable tree.
> 
>> ef03681ae8df770745978148a7fb84796ae99cba
> 
> This commit doesn't say so, but really it fixes 5262f567987d3
> ("io_uring: IORING_OP_TIMEOUT support") which is not in the stable tree.
> 
>> a1f58ba46f794b1168d1107befcf3d4b9f9fd453
> 
> Same as the commit above.

Oh man, sorry about that, I always forget to check if all of them are in
5.3. I blame the fact that I backport everything to our internal tree,
which is 5.2 based. But yes, you are of course right, those three can be
dropped.

>> 84d55dc5b9e57b513a702fbc358e1b5489651590
>> fb5ccc98782f654778cb8d96ba8a998304f9a51f
> 
> This needed some massaging to work around not having 4fe2c963154c3
> ("io_uring: add support for link with drain"). I've fixed it up and
> queued it.
> 
>> 935d1e45908afb8853c497f2c2bbbb685dec51dc
> 
> I think that Greg's scripts didn't like how much this code moved around
> and refused to deal with it. I've verified patching did the right thing
> and queued it up.
> 
>> 498ccd9eda49117c34e0041563d0da6ac40e52b8
> 
> This one needed massaging to work around missing 75b28affdd6ae
> ("io_uring: allocate the two rings together") in the stable tree. I've
> fixed it up and queued it up.
> 
> 
> Jens, could you please take a look at my backport of fb5ccc98782f65:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-5.3/io_uring-fix-broken-links-with-offloading.patch
> 
> And 498ccd9eda491:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-5.3/io_uring-used-cached-copies-of-sq-dropped-and-cq-ove.patch
> 
> And confirm I did the right thing?

Of course, I'll take a look right now. Thanks for taking care of these!

-- 
Jens Axboe

