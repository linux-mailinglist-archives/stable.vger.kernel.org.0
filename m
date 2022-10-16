Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0656D5FFF1B
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 14:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiJPMYq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 08:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiJPMYp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 08:24:45 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 104C217048;
        Sun, 16 Oct 2022 05:24:42 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id h185so8232205pgc.10;
        Sun, 16 Oct 2022 05:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ulapgXtBSEdOZtfDJACpfmzponGGZTpz8s2cMHVH+ns=;
        b=MlXl03eDpmfO6yKNAgLuVkJFGDxwkckUxIlypbWgPhEJzkLq4lH12tzOCkk3pngDXd
         4UibxIcS1Ty4PzVwXQpJSdzznxEfLyL/Yd/2Q6JSeF4KaeCwdzZYZgN16GqvrxBcv/0v
         RyDU+gWpz04OvX5CxYOFPF7fP2p1d+MCqWDybAQAQh02rR5vKBJsley2Pe0LPCCwRfy6
         sD+a5E5g8lToAd2dA1XoIkLMM4kfbN2QoOTKgxOblGBalHD2iK/gXbVat1FLjHRS07nP
         aw8sEcrix+cA+puf3CJCb6nCmvZJXUP3WlTtBo0WEuJgYXwa8ruJePCglk6n7u/54g1B
         pGhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ulapgXtBSEdOZtfDJACpfmzponGGZTpz8s2cMHVH+ns=;
        b=1WX9sXtkCTn8RFGjr0K60F4Ur0fBU/0NeIZWBXYmVvMam1jmB72BXgkPbs3jX2YDrp
         YFMb8BxsM4w9sY8lCPSel5lREviwMVqnO0CFEkqMg8NKtYk2SrzXVXceoFKiNA2aO1HD
         GLS4mmzy25KM26IvSXx4EUv/ffr7uOfxWHq8w92Knvr5P0oG53HAFwhfCG18hpYd+Fab
         sjr2fggKo5Ht3PefaD8U+3vGYhhI5M5w0Kj7d2TBCcVRq9LfbYSowmJQEhtIq7IensdM
         WBHEFGYlkJgBP0WleAwID7I/lpbi0MFoSldjsLVD2wYpxjYm1NP4/kmCsjsmruLnsY2H
         wkKw==
X-Gm-Message-State: ACrzQf18LWLiFjDqKeudIYQgOIE3oFCoNqXEpkuUnpc9HjTV/g7Xvhwk
        vHpT46RshVYeIkKXja9PAzM=
X-Google-Smtp-Source: AMsMyM7Hm57WtejGAp0EktQ7r4I0zKCXzLKbeiaKw3YwWhFvaWeRFXtbUVovgp4RVNjTNK4IIebnJQ==
X-Received: by 2002:a65:5a0b:0:b0:46b:158e:ad7c with SMTP id y11-20020a655a0b000000b0046b158ead7cmr6437219pgs.272.1665923081907;
        Sun, 16 Oct 2022 05:24:41 -0700 (PDT)
Received: from [192.168.43.80] (subs32-116-206-28-46.three.co.id. [116.206.28.46])
        by smtp.gmail.com with ESMTPSA id h9-20020a170902f54900b001788ccecbf5sm4779804plf.31.2022.10.16.05.24.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Oct 2022 05:24:41 -0700 (PDT)
Message-ID: <b811fb3a-b5bb-bb0d-0cdf-e5bc0e88836f@gmail.com>
Date:   Sun, 16 Oct 2022 19:24:37 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: BISECT result: 6.0.0-RC kernels trigger Firefox snap bug with
 6.0.0-rc3 through 6.0.0-rc7
Content-Language: en-US
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Phillip Lougher <phillip@squashfs.org.uk>,
        regressions@leemhuis.info, mirsad.todorovac@alu.unizg.hr
Cc:     linux-kernel@vger.kernel.org, marcmiltenberger@gmail.com,
        regressions@lists.linux.dev, srw@sladewatkins.net,
        stable@vger.kernel.org
References: <8702a833-e66c-e63a-bfc8-1007174c5b3d@leemhuis.info>
 <20221015205936.5735-1-phillip@squashfs.org.uk>
 <2d1ca80c-1023-9821-f401-43cff34cca86@gmail.com>
In-Reply-To: <2d1ca80c-1023-9821-f401-43cff34cca86@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/16/22 19:21, Bagas Sanjaya wrote:
> On 10/16/22 03:59, Phillip Lougher wrote:
>>
>> Which identified the "squashfs: support reading fragments in readahead call"
>> patch.
>>
>> There is a race-condition introduced in that patch, which involves cache
>> releasing and reuse.
>>
>> The following diff will fix that race-condition.  It would be great if
>> someone could test and verify before sending it out as a patch.
>>
>> Thanks
>>
>> Phillip
>>
>> diff --git a/fs/squashfs/file.c b/fs/squashfs/file.c
>> index e56510964b22..6cc23178e9ad 100644
>> --- a/fs/squashfs/file.c
>> +++ b/fs/squashfs/file.c
>> @@ -506,8 +506,9 @@ static int squashfs_readahead_fragment(struct page **page,
>>  		squashfs_i(inode)->fragment_size);
>>  	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
>>  	unsigned int n, mask = (1 << (msblk->block_log - PAGE_SHIFT)) - 1;
>> +	int error = buffer->error;
>>  
>> -	if (buffer->error)
>> +	if (error)
>>  		goto out;
>>  
>>  	expected += squashfs_i(inode)->fragment_offset;
>> @@ -529,7 +530,7 @@ static int squashfs_readahead_fragment(struct page **page,
>>  
>>  out:
>>  	squashfs_cache_put(buffer);
>> -	return buffer->error;
>> +	return error;
>>  }
>>  
>>  static void squashfs_readahead(struct readahead_control *ractl)
>>
> 
> No Verneed warnings so far. However, I need to test for a longer time
> (a day) to check if any warnings are reported.
> 
> Thanks.
> 

Also, since this regression is also found on linux-6.0.y stable branch,
don't forget to Cc stable list.

Thanks.

-- 
An old man doll... just what I always wanted! - Clara

