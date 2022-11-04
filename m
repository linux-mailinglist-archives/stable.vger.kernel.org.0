Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6616193D4
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 10:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231546AbiKDJsD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Nov 2022 05:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231540AbiKDJsC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Nov 2022 05:48:02 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2176B72;
        Fri,  4 Nov 2022 02:48:01 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id y203so4067049pfb.4;
        Fri, 04 Nov 2022 02:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JCM7DmPCrAhHj8o16i9KvJND8gQ8xeXyO3XsNoc1pPw=;
        b=CgmPNUd+NId6xXJHCwc5dSIA8ALu4kUG/zxn0BAvqYPLQDM7sbgqN8OGvEmuEECLIa
         pLgoVHrEI65nS2DTG++k31VbbJiaCRB1Alwe9PvYjPAUtxxIvb3fLvOVJoVr6fSf4rOk
         UtOw0X3ZLkwgVaoBY6BREhDtkOx8AmfGt3ZnG7zmgPcfeJCqvzSgioOn/wq8cLgPit2S
         MHd6eIFy9ebLWXTYUHEeWYVqMHpwlhwRr+kWa55WOQVYaQR6xqztpHuD05VCDV1H99rR
         YbL63FshfBwmSZGDFwBVVumi+kKDUmWiYcgfYXBas80O8tM5q3ZlR1ABw3FwYQ14MnP9
         eMAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JCM7DmPCrAhHj8o16i9KvJND8gQ8xeXyO3XsNoc1pPw=;
        b=bXpj5kfZLTQHVmtAFAF7ChbxOTLbfRuEIWfsucLLaHp+nnXxr6qVU5hAl+NipUWfs0
         NFFu7jhHCwcFcjfINqOWR1S1cOjjWxChGOF23GromlzTzJ+TX1pJFw+CTwLPtdOgqrdY
         OyT97rWiADSJA9RjFdGKyCxsNvb5Zg/x2ZBEO1K4z8plqirsVZzzEWSB1lx5QO019mqz
         n5+CBuYw5mlqFWNqoL9QBUNGZVTw1qpqQYtmgOXh1JmO6ZiT3zOogh3TnWLnRKzoWUoU
         uYqNA3Q/IB8ueTr0dpqjwkz/wuVBrAecQemZfrrm3c/IDS8vj7rWO2NPowjH72ZRXEcR
         DMRw==
X-Gm-Message-State: ACrzQf3H2WYAn+NPR6jskEKFkLDIdr84YB8YU5EjXIwasatGvemhOONC
        blnvMKSsjrRfyUyebyGqLzc=
X-Google-Smtp-Source: AMsMyM4J/bnvfLmAAYzNAp8KxZU31oa8PozHCTA7MrbLiwCOIyUOki9aQ6uaYWqTB9LkgJeVQJRXHw==
X-Received: by 2002:a63:6507:0:b0:46f:ea82:5792 with SMTP id z7-20020a636507000000b0046fea825792mr15279336pgb.50.1667555281253;
        Fri, 04 Nov 2022 02:48:01 -0700 (PDT)
Received: from [172.20.12.203] ([116.128.244.169])
        by smtp.gmail.com with ESMTPSA id y15-20020a17090322cf00b00176d347e9a7sm2172704plg.233.2022.11.04.02.47.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Nov 2022 02:48:00 -0700 (PDT)
Message-ID: <6436e363-198f-3d0b-cef3-4456de225432@gmail.com>
Date:   Fri, 4 Nov 2022 17:47:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Cc:     xiongxin@kylinos.cn, rafael@kernel.org, len.brown@intel.com,
        pavel@ucw.cz, huanglei@kylinos.cn, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] PM: hibernate: fix spelling mistake for annotation
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
References: <20221104054119.1946073-1-tgsp002@gmail.com>
 <20221104054119.1946073-2-tgsp002@gmail.com> <Y2TY120EAhfKgSvR@kroah.com>
From:   TGSP <tgsp002@gmail.com>
In-Reply-To: <Y2TY120EAhfKgSvR@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

在 2022/11/4 17:18, Greg KH 写道:
> On Fri, Nov 04, 2022 at 01:41:18PM +0800, TGSP wrote:
>> From: xiongxin <xiongxin@kylinos.cn>
>>
>> The actual calculation formula in the code below is:
>>
>> max_size = (count - (size + PAGES_FOR_IO)) / 2
>> 	    - 2 * DIV_ROUND_UP(reserved_size, PAGE_SIZE);
>>
>> But function comments are written differently, the comment is wrong?
>>
>> By the way, what exactly do the "/ 2" and "2 *" mean?
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: xiongxin <xiongxin@kylinos.cn>
> 
> Please do not use an anonymous gmail account for your corporate work
> like this.  Work with your company email admins to allow you to send
> patches from that address so that they can be verified to actually come
> from there.
> 
> thanks,
> 
> greg k-h

I also wanted to send it directly through the company mailbox, but those 
leaders didn't take it seriously.

Next time I don't use the company email and submit patches as I can as a 
freelancer.
