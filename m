Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 208BE4EE017
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 20:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233367AbiCaSFv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 14:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232671AbiCaSFv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 14:05:51 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E834DF41
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 11:04:01 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id b130so377597pga.13
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 11:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=YsjSmrG2rvYs50asz/taC5lCuB0Ss1bBZU3bReqw5is=;
        b=PouxUIYkBVuDtFYYhzJKLOVGEietOc0cr9qJm2EvDslOhzSw9jON2ICmYF6t9N5/6d
         UeUa90pA/MozGMKak7kSYV0mXp43DAEGF2q7tXAYxPBwHknQABhfGpVQXvnSm8QSTt/n
         Eok9vzYTaPRKddP8OxP4oaKDkzdCIH7LL/RmyFAUWgF7jsxDViqNjjb7WbU/DZKVxRtG
         fN7/0u+gUYr79gPq5Rro0aSzY01+eXTZQ0BBw8iACDlZqN9rtqzBBl4iJe/qiOdvTHpe
         ywKFz8znw4luKvpXbOv6m6ae8EobDnAtXSAX89rWDWgXE8ZobRk7ujXauAwBCNcXwkU9
         yg7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=YsjSmrG2rvYs50asz/taC5lCuB0Ss1bBZU3bReqw5is=;
        b=6zYT4bm6+D9mVBigMFK5d/O6+KmmkRIcthiarJcYfQIzhWaMp1SpDnhzx6q+vYGOUa
         Iv73Ue3B/C1VM6pSSoSNESxH3aHppn/KhxcXLYhAWv2Eg0ye1DwyHo1Yuy6BqT91RvRb
         z7MbaRlDtz5WJQpLIFXEUkMzJdBW5xYSZ8mFrQDgGc8Oh8lbxkXX3QBVB74fPm4Ef7fu
         xgLymDUeLryVR0/9sY3K2+VAaiTGkKg18583Mg2O7iQeYHbDD8R90SX2EuFhz3OEle6v
         GXaVIJCsN4BbkK5wz4GbaMpNEdpQs62ydyeh+9BPrqOReeH/oQ0NC8kJGvg3wwcc+CwA
         NooQ==
X-Gm-Message-State: AOAM530Jk8c732pWWEQ7jzEDUDcHtbHPfftmcMRBGV6n6jkTHgUbN0yh
        sdHl1TcCM7j2XQ1DTyflI+oQV5lj46Juddre
X-Google-Smtp-Source: ABdhPJzs/UIaReCHNW6gfF+eZ6FRhildRbC1WSzb8rJwa2DI3Yesk+oxp4qzOcQkzybMD/Ht6oeMLA==
X-Received: by 2002:a65:6d15:0:b0:382:4e6d:dd0d with SMTP id bf21-20020a656d15000000b003824e6ddd0dmr11580133pgb.333.1648749841056;
        Thu, 31 Mar 2022 11:04:01 -0700 (PDT)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id oc10-20020a17090b1c0a00b001c7510ed0c8sm11299522pjb.49.2022.03.31.11.03.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Mar 2022 11:04:00 -0700 (PDT)
Message-ID: <39b76458-17e6-4e04-15d8-1445d2067d0c@linaro.org>
Date:   Thu, 31 Mar 2022 11:03:59 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Andreas Dilger <adilger.kernel@dilger.ca>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        linux-ext4@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+7a806094edd5d07ba029@syzkaller.appspotmail.com
References: <20220315215439.269122-1-tadeusz.struk@linaro.org>
 <YkW9+AK2d3i8X9rq@mit.edu>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: Re: [PATCH v2] ext4: check if offset+length is valid in fallocate
In-Reply-To: <YkW9+AK2d3i8X9rq@mit.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/31/22 07:43, Theodore Ts'o wrote:
> On Tue, Mar 15, 2022 at 02:54:39PM -0700, Tadeusz Struk wrote:
>> @@ -3967,6 +3968,16 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
>>   		   offset;
>>   	}
>>   
>> +	/*
>> +	 * For punch hole the length + offset needs to be at least within
>> +	 * one block before last
>> +	 */
>> +	max_length = sbi->s_bitmap_maxbytes - inode->i_sb->s_blocksize;
>> +	if (offset + length >= max_length) {
>> +		ret = -ENOSPC;
>> +		goto out_mutex;
>> +	}
> 
> I wonder if we would be better off just simply capping length to
> max_length?  If length is set to some large value, such as LONG_MAX,
> it's pretty clear what the intention should be, which is to simply do
> the equivalent of truncating the file at offset.  Perhaps we should
> just do that?

Don't think that would be the correct behavior. ftrucnate (or truncate)
modify the file size, but fallocate with FALLOC_FL_PUNCH_HOLE should not.

man 2 fallocate says:
"...
The FALLOC_FL_PUNCH_HOLE flag must be ORed with FALLOC_FL_KEEP_SIZE in mode;
in other words, even when punching off the end of the file, the file size
(as reported by stat(2)) does not change.
"
that is enforced by vfs:
https://elixir.bootlin.com/linux/v5.17.1/source/fs/open.c#L245

> 
> That being said, we should be consistent with what other file systems
> do when they are asked to punch a hole starting at offset and
> extending out to LONG_MAX.

For all the supported file systems, apart from ext4, only btrfs, gfs2, and xfs
support fallocate and FALLOC_FL_PUNCH_HOLE mode.
Looking at what they do is they round the length of the space to be freed
i.e. offset + length to valid value and then perform the operation
using the valid values.

https://elixir.bootlin.com/linux/v5.17.1/source/fs/gfs2/bmap.c#L2424
https://elixir.bootlin.com/linux/v5.17.1/source/fs/btrfs/file.c#L2506

For ext4 this would mean that one could only deallocate space up to
the one before last block. I will change this to do the same in the
next version if that's ok with you.

> 
> Also, if we are going to return an error, I don't think ENOSPC is the
> correct error to be returning.

I took it from man 2 fallocate, my first suspicion was that it crashed
because the disk on my VM wasn't big enough. It was a bad choice.

-- 
Thanks,
Tadeusz
