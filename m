Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9DE699995
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 17:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbjBPQMn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 11:12:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbjBPQMk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 11:12:40 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3976A85F60
        for <stable@vger.kernel.org>; Thu, 16 Feb 2023 08:12:34 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id z5so834324iow.1
        for <stable@vger.kernel.org>; Thu, 16 Feb 2023 08:12:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1676563954;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hslXI6CWRbStbzB+4K+o5c/LMLxsmfP9KwuJ1mTzpbs=;
        b=D+Zja0G75GubSEiKHCoSIHl1dXGKL3GAhKbiRlqge2Cg6cLvrQd0Z6KqsSml+5J0yK
         VzmVqML9BFqYrxoiqizCzzjug+Rf3r8vadWOiMFZ7jBzj5gN2QErpThCZbL9V4aXdo1h
         vTX0zsgsa5WmDHaNbq/dmy5rshZXx8pfUQADUbcj/rz41PkJYJOWm97cC5aU1aajApYg
         Wycf6hI/vyaB2cObLs/ncHOwsSTfSm3uZpTVccFHf88WuR1ZZsfirekQUxpXgCiQpOEw
         OOx0MksiovQP1mehQYJPlZNiz9ie9AqusqQmc8foO3nbokmEE4e/d5pYd24KFjBOgFNT
         anmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676563954;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hslXI6CWRbStbzB+4K+o5c/LMLxsmfP9KwuJ1mTzpbs=;
        b=KLXN/eNUVfcF6m5JI+Frd3LKYkuY4yuiU0lwDilyStu3HGgNFwlTTohsmOWyesDuaE
         5+axbV5ynt51N47xZxZ661zINZWw6q5t2bGIzIlcD+l9o0YxiPBZTzyJ6iYiT0CoCp30
         dN0S2KhthU3VIso/78a+Y3sNGZOr2/A74j+/mW2SWxvHGCT1sAqAQj5kF1o1MAGiyXvo
         IJwmLlob+PPfcwWRFQKMPBXJjZyqLES2sdO0aptOP+z2EHSSfmpkES4mlxZhYTPRhpLl
         bz/wlX+140b6Y0CXsMG3QOewlVFr9MxjhQ9PSW/hh3H3P6EGqaK6yUuz2QkeuwvLiRSP
         hK0g==
X-Gm-Message-State: AO0yUKU1qS3x0jVc8oWVHjM24goDJx3KIWevWhsyg4R7OrupZJuSKMPF
        CACsmFNWMgW+ZprFJHvG4xVXwg==
X-Google-Smtp-Source: AK7set8o37Ur7xoVXUw35QfynrNT/KPsreqh7ufKv7gE2HIHjsorbZ9G5XgXfx/cPb816yyN8aNLlA==
X-Received: by 2002:a5d:96d7:0:b0:719:6a2:99d8 with SMTP id r23-20020a5d96d7000000b0071906a299d8mr3957618iol.0.1676563954287;
        Thu, 16 Feb 2023 08:12:34 -0800 (PST)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id v1-20020a6bac01000000b0073f9a945236sm638636ioe.6.2023.02.16.08.12.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Feb 2023 08:12:33 -0800 (PST)
Message-ID: <e4fb52d3-25da-4796-2f79-d9630b7168d6@kernel.dk>
Date:   Thu, 16 Feb 2023 09:12:33 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH 1/4] brd: return 0/-error from brd_insert_page()
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-block@vger.kernel.org, stable@vger.kernel.org
References: <20230216151918.319585-1-axboe@kernel.dk>
 <20230216151918.319585-2-axboe@kernel.dk> <Y+5UYrUgp9lg8zRD@infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Y+5UYrUgp9lg8zRD@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/16/23 9:05 AM, Christoph Hellwig wrote:
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
>> Cc: stable@vger.kernel.org # 5.10+
> 
> But why is this a stable candidate?

Only because the other patches depend on it.

-- 
Jens Axboe


