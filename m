Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E60CA57A4B2
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 19:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238256AbiGSRMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 13:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238335AbiGSRMO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 13:12:14 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 741B157E30
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 10:12:13 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id h132so14045285pgc.10
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 10:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=xlsTXlXgkqcwZmlKCHkSKeWcBmUe/4Yks4XD/IOGgJ8=;
        b=ZQIQV7tJormcdXT5Y2BwVjedCW7zwEhbrZ4sYHPgObfAxoVc9msrDpayMhUw1YxOTY
         exrX/3rKOc3Y+Y+EQoIWutn6Ux8jV3GscFW7NzxCst8uCmuR+mBF/8YEvnsazGauTHUg
         waETftJEUk8j37dqhW//H5FRO/6EPxAjugJ0Xt8dA6E3eptOkt58/c7lM6dUKoI9jDrq
         oOezV0oj2E4VKjOhr2VyajXXmjh7b+QTrRFYQYp9/at1Z+19ei4Gx7VsEe90rb3xK9f4
         H8BltzEcTBBfoViuLK/am//c4djPNcVznBEgRxiRnJRH4QM5GL4LyGifiPIcInmUis3B
         KyPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=xlsTXlXgkqcwZmlKCHkSKeWcBmUe/4Yks4XD/IOGgJ8=;
        b=M1VDGKVZvp9LaSCbVORkR2qCtsPYY+OYtTv3+PnBWJY5m+rNggLKXbi2FGaDcCuKva
         9/zYg0R2U6/ggNkLD0mvKGQku5LsMef/2SJ9IIeMQCGKCEb1xzXcXgsyxxTsX4cGgjZ8
         315VC3Fypxo6za40+RnB6b3rqFqGS5CNK4VkU+YaIf6c/qHjKv1/MyGY8EK19/BUOYlO
         /D5lyiCSxraaa3wglpKCobat4TAg388PJKsiZilpV3f+Q9DetKEpln6zrCFPVMAqCxBm
         P/4a3OmiPDmO/XK8GM7/aqe9BZ0IfrrNEt7WGtrX7sGa+ktwh29Nb5Yb1Q8OeLRkPxac
         MeVQ==
X-Gm-Message-State: AJIora8GU8fAvd1noYk9ZzO3Ou33luFU0q4mK6HWDZdzprSXDgYMe8pj
        oA0yNoKRfunI3Nn/DCQbQYDI9kY4+5WwoQ==
X-Google-Smtp-Source: AGRyM1u0OqFaN5bR5kLMvbIxDbCjNtYUTNT4RMDYwcRrouitJfNNXVr7HZIeA2S96pKZGVQg4EWvAA==
X-Received: by 2002:a63:1658:0:b0:41a:4118:f4b9 with SMTP id 24-20020a631658000000b0041a4118f4b9mr6025950pgw.153.1658250732654;
        Tue, 19 Jul 2022 10:12:12 -0700 (PDT)
Received: from [10.4.188.211] ([139.177.225.225])
        by smtp.gmail.com with ESMTPSA id g3-20020a170902e38300b0015e8d4eb1c8sm11811311ple.18.2022.07.19.10.12.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jul 2022 10:12:12 -0700 (PDT)
Message-ID: <17df93c3-5d12-aea9-95df-a46437ea798a@bytedance.com>
Date:   Wed, 20 Jul 2022 01:12:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [External] Re: [PATCH v3] block: don't allow the same type rq_qos
 add more than once
To:     Jens Axboe <axboe@kernel.dk>, tj@kernel.org
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
        stable@vger.kernel.org
References: <20220719165313.51887-1-hanjinke.666@bytedance.com>
 <036e5ae0-4908-d4ab-c2e5-56e9ca85e26d@kernel.dk>
From:   hanjinke <hanjinke.666@bytedance.com>
In-Reply-To: <036e5ae0-4908-d4ab-c2e5-56e9ca85e26d@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

okay, I will do it.

在 2022/7/20 上午12:56, Jens Axboe 写道:
> On 7/19/22 10:53 AM, Jinke Han wrote:
>> From: Jinke Han <hanjinke.666@bytedance.com>
>>
>> In our test of iocost, we encounttered some list add/del corrutions of
>> inner_walk list in ioc_timer_fn.
> 
> This still fails for 5.20 and you didn't correct any of the spelling
> mistakes I identified.
> 
> Please take your time to get this right rather than attempt to rush it
> and needing to send new versions all of the time.
> 
