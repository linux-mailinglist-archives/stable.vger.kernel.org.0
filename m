Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B00E25842E5
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 17:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231752AbiG1PT2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 11:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231767AbiG1PT1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 11:19:27 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C825F558DE
        for <stable@vger.kernel.org>; Thu, 28 Jul 2022 08:19:26 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id s206so1789112pgs.3
        for <stable@vger.kernel.org>; Thu, 28 Jul 2022 08:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc;
        bh=pQ1fJw+UH4q0bslSdkcMAKD/A55dsZAH6NsrWi3ntuY=;
        b=lHihWsOpVjf6EcqoO9LBYCjWooUzhQfnbOPhyA5hCudUs13WOxgUXL4V4Lvf8mLrk6
         8/Uv06Jg14plBHZ2nuL7ubV197+fwPnciw2AR6/BnDaNs4/R2ZIEHgT2k0S4R4AHE4vc
         4OJXqyfMII+YC+tqJUjTEuSl0fBtGEolMNui7PDXyJ+n5HVyeZnHAL/wy4SqEfSrkR5c
         2+SV5zoYu0aPHB/aU2gQa0DeNfW3nEeBUu0QabL39BSHHyiSaCevkuDC+4HUu14/T+Lt
         naEFfdglwRfAi31CI6tWknkVI7qjdBl12fDnZPu9WrLPjF4wR+pTXJVsNx8uxLPzINkm
         Sh4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=pQ1fJw+UH4q0bslSdkcMAKD/A55dsZAH6NsrWi3ntuY=;
        b=gGXslgKB+56i9eZE5FrqGE1R+++GmyQNUUKUQU+q193BGz94X8ZO58U8HB0iCHe7LH
         w33Btb9C7d7dT/HacHAKX8IWrdiT56IuHYxRluzgaouGyC6fPOB9XeRfzUsyCZbWvfhr
         UbxmJFFPEca6aD5b/d4O/Jej1byCmRX6WzVxe7DOX0XbPbIaK5RFoLa/DxURQXiO5EEh
         PrT9WXbf0sgbmV6Xuwxq/Goroxjl50+HAjC+veZ0qw/G+MKDN5N4cWyPbhyfJC277xI5
         1rwdYpqybFNps+2htsqgLKZ31Sw024JFRbZldENNDUE3JCl41Cz8JjVNkkoUXTvomX4c
         YYOA==
X-Gm-Message-State: AJIora/K183WvsTyKAkhVkDDEer3ZVbth5CXeRdtjbwV5iFRyde8WtsZ
        Y/mBuQrstY1pqkk4lOqVbDKBAQ==
X-Google-Smtp-Source: AGRyM1uiE5loJGnLpiRRHlyA820KFf+7q1Uek3db/YZiwO8yNQb8Kd1rb7tFROXcy/mXpMQrBBH5cg==
X-Received: by 2002:a63:5b5e:0:b0:41a:5e8f:b127 with SMTP id l30-20020a635b5e000000b0041a5e8fb127mr22670240pgm.104.1659021566293;
        Thu, 28 Jul 2022 08:19:26 -0700 (PDT)
Received: from ?IPV6:2601:1c0:4c00:ad20:feaa:14ff:fe3a:b225? ([2601:1c0:4c00:ad20:feaa:14ff:fe3a:b225])
        by smtp.gmail.com with ESMTPSA id r17-20020aa79ed1000000b00528c26c84a3sm917844pfq.64.2022.07.28.08.19.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jul 2022 08:19:25 -0700 (PDT)
Message-ID: <94c6cdb7-7884-b95e-da32-9e46756f6cdb@linaro.org>
Date:   Thu, 28 Jul 2022 08:19:24 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>,
        Christoph Hellwig <hch@lst.de>
Cc:     stable@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com,
        syzbot+4f441e6ca0fcad141421@syzkaller.appspotmail.com,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Jens Axboe <axboe@kernel.dk>
References: <20220718211226.506362-1-tadeusz.struk@linaro.org>
 <YtwM3uHugOOdDQZT@kroah.com> <YuKgW9BCNl8ChT/v@kroah.com>
 <20220728144520.GA18285@lst.de> <YuKkgPx2XF6rQnLq@kroah.com>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: Re: [PATCH 5.10 1/2] block: split bio_kmalloc from bio_alloc_bioset
In-Reply-To: <YuKkgPx2XF6rQnLq@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/28/22 08:00, Greg KH wrote:
> On Thu, Jul 28, 2022 at 04:45:20PM +0200, Christoph Hellwig wrote:
>> On Thu, Jul 28, 2022 at 04:42:35PM +0200, Greg KH wrote:
>>>>> Link:https://syzkaller.appspot.com/bug?id=a3416231e37024a75f2b95bd95db0d8ce8132a84
>>>> Both now queued up, thanks.
>>> As was just reported, this breaks things all over the place:
>>> 	https://lore.kernel.org/r/219030d8-3408-cc9d-7aec-1fb14ab891ce@roeck-us.net
>>>
>>> Note, I also had to add lots of fix-up patches on top of these two that
>>> you missed, so odds are there are other fix-ups that I also missed.
>>>
>>> Please go and test this again, and submit ALL patches that are needed
>>> after they pass the proper testing and I will be glad to reconsider them
>>> again.
>> Why did this even get backported?  It was a cleanup that required a lot
>> of prep work, and should not by itself fix anything.
> Looks like syzkaller is reporting something odd...
> 
> Tadeusz, how was this tested?

Yes, I tested it with syzbot and locally and it fixed the syzbot reported
"kernel BUG at block/blk-mq.c:567" issue:

https://syzkaller.appspot.com/bug?id=a3416231e37024a75f2b95bd95db0d8ce8132a84

I only tested it with booting from ext4 fs, as I don't have any btrfs setup.

-- 
Thanks,
Tadeusz
