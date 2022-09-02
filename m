Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB505AACAC
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 12:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235922AbiIBKkc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 06:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235926AbiIBKk0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 06:40:26 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C09AF28726
        for <stable@vger.kernel.org>; Fri,  2 Sep 2022 03:40:22 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id h1so1008606wmd.3
        for <stable@vger.kernel.org>; Fri, 02 Sep 2022 03:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=qX/U45Jys+VRBRWchhIGrd6+LiCMFeu0vMTIMPqb6ac=;
        b=M6aVn058fkJAOdx4HcrMfjBTT+GBkDHxS6T5gY8rELNxP0G8AEThjWjCeg5pqXC61C
         i41VcINoNJ7ltpAh1tptrFvETWMajyFFbpGTd6mUlI7pbqdP5Rr3QN6AEejhzuOfhvjY
         L+vJkyk0C8gud7RQKiBvjzrjJsm0IhzHZMpy6WSC/0inZRxTY6u1iNdCBeVL8yPXRXvq
         rKWPY8WXtCAesALBjB/yK2/qZ3sayg7XUisISDrG/KL/N4RLqWPPl9DzUwhEElZN4oPu
         HSXO0+Tq6mrOG0SwrMsflict006UJL77URWbqvbxtYP+4738jbkONOtXBeLwZNFqhMZQ
         g1kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=qX/U45Jys+VRBRWchhIGrd6+LiCMFeu0vMTIMPqb6ac=;
        b=lPAOo78NyrsybrvV8jEUXpnHcqJLebgDA4WzVMRHLNGkwZFQbSz2vNRFQ8pfr3fAqA
         C46hBbbfqxP1apOy2wifgrvNyqETkwHo6JsTxNdOPgywCEWkliKS8hMO5FyJM4jjzO6B
         xSaI5vJgb0beWPj1llPcNIoWmTGQMbMxeVCzX0Cjre2YFSxPA0sGgAHh9qJYdrMNnHG+
         jR0EiheLzeg+0BVO6/1YuYS5Wv8BEKRN4jZYPN73vyuEkCASdGIzm/ph470L6zlCkavJ
         AJEXwG/fDcXg5DNAH6C1GcF391/APTbyUuoauL+K206WtiyG6/bExDeSIqLHoNBnMp4M
         bsWA==
X-Gm-Message-State: ACgBeo10SvNKEAsZzbPQ2nfT27/FMEaoGs4tj3S5UG+9JuVJ+T9p8Nha
        tcZ6MhLF4zQItp8i7YUP4nrsUKJBzbU=
X-Google-Smtp-Source: AA6agR7OoC75pzKdXryAIpwdXQ7LnmF8VKTzOiQvpQhEQY8uVC/+G7PGp/ZlsQNOIpDMeSD+1TRfsQ==
X-Received: by 2002:a05:600c:3b05:b0:3a8:4c81:54df with SMTP id m5-20020a05600c3b0500b003a84c8154dfmr2378185wms.129.1662115221129;
        Fri, 02 Sep 2022 03:40:21 -0700 (PDT)
Received: from [192.168.43.77] (82-132-230-225.dab.02.net. [82.132.230.225])
        by smtp.gmail.com with ESMTPSA id w3-20020a05600018c300b002206203ed3dsm1259042wrq.29.2022.09.02.03.40.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Sep 2022 03:40:20 -0700 (PDT)
Message-ID: <11296c4c-ba6d-fefe-ea1f-a19f4cabcb01@gmail.com>
Date:   Fri, 2 Sep 2022 11:38:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH stable-5.10 1/1] io_uring: disable polling pollfree files
Content-Language: en-US
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
References: <4f4668f469baa8f1387e746fd2533ec662500f3a.1662042761.git.asml.silence@gmail.com>
 <756d8d67-7a63-62a1-51e4-1e966f40610d@gmail.com> <YxGfF7hQOGa6lKMt@kroah.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <YxGfF7hQOGa6lKMt@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/2/22 07:13, Greg KH wrote:
> On Thu, Sep 01, 2022 at 04:25:46PM +0100, Pavel Begunkov wrote:
>> On 9/1/22 16:16, Pavel Begunkov wrote:
>>> Older kernels lack io_uring POLLFREE handling. As only affected files
>>> are signalfd and android binder the safest option would be to disable
>>> polling those files via io_uring and hope there are no users.
>>
>> It differs from how it's fixed upstream, but IMHO porting is too
>> difficult to be reliable enough, this one is quick and simple.
>> The upstream fix:
>>
>> commit 791f3465c4afde02d7f16cf7424ca87070b69396
>> Author: Pavel Begunkov <asml.silence@gmail.com>
>> Date:   Fri Jan 14 11:59:10 2022 +0000
>>
>>      io_uring: fix UAF due to missing POLLFREE handling
>>
>>
>> I also forgot Fixes tag if required:
>>
>> Fixes: 221c5eb233823 ("io_uring: add support for IORING_OP_POLL")
> 
> I'll go add it by hand, all now queued up, thanks!

Perfect, thanks greg

-- 
Pavel Begunkov
