Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 695E2696C72
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 19:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233358AbjBNSKJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 13:10:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233309AbjBNSKH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 13:10:07 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F01B4;
        Tue, 14 Feb 2023 10:09:59 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id bh15so13673311oib.4;
        Tue, 14 Feb 2023 10:09:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=6Y717KJbIRjmj+t9kJAIvgBCc3UIFcYLwVTbZ9RsBPk=;
        b=XwcIdw9ldMHQ4ayiqMbANGBH3Ycpl/ADyKalw8WJRsox/7OgE4QrKcKc8mlpGGmZoA
         dbwJnZEDuVUxTw07bumv6cXJks3KX3Aa6f3EaPhlrMTN1rhyS1Q9QKYqP86Qt/gmE/Z4
         RTODsASPYD51aEVqcsdFl3hs9g5fNjKrWpFzZsPxLpN0sqq7sy+LzKWDsUzY24pxrIEO
         R69UNBna63ls2/KXD7bTM9zNdQKqMAvfxfrcPGTxeVwyHX11VVLpR/enCawt/Dogh2Nl
         l8/5PkHxPdQRRPsfeb0zAa1VOXn7j7ZtLosQabO/vHs6T2+eGD9GCF1Z/KvjSiWTJN5l
         EMNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6Y717KJbIRjmj+t9kJAIvgBCc3UIFcYLwVTbZ9RsBPk=;
        b=ywrVTq+Og8Cuwz/nVnA4TqTdSmVMWuBPEHBxVHwMBO0aHcNHPCKyU89LmnqYXcG2TB
         +02Wq7WXTt+YeXkxiyS2ylAWKvGJz7RPK+s9Kdg8UfV2IxTVQYqZVcHo8X8aOKA8Z+Qv
         PE1ctX/pPoJfwBUcqXfi4nlz1/14BR0rCsltbTM9ORlM7QpvJPCAtpXF6JK/9lmik2MF
         jNCpnCzifAa6jHVWkDxWYmyWwbBOYUeYBO86Ex80stW7k2GVYbglUm+KeD5Bj+YRqQim
         eXamxee/7OojrhwZfwQVm4b5mT493tzRGSqLKrKOOzCSZbMP2nlQpDFNkmmYsjXQqpHb
         QTwQ==
X-Gm-Message-State: AO0yUKW/B5eVGa/wAthT7thBhA2bgt4W6wNnv8D83RBMtlPTbw1xVc4q
        1biCkyZB0f65hqWl4wQB65o=
X-Google-Smtp-Source: AK7set/Ipu5a6wQXpVlF4OsXb8/OusLhF5tQD1rtSUbjH7bFzZF2ZxmmKiZVGnoNT26vDqW2b3u40w==
X-Received: by 2002:aca:2b09:0:b0:378:3c87:5092 with SMTP id i9-20020aca2b09000000b003783c875092mr1501490oik.5.1676398198584;
        Tue, 14 Feb 2023 10:09:58 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p125-20020acad883000000b003436fa2c23bsm6463808oig.7.2023.02.14.10.09.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Feb 2023 10:09:58 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <c210524a-368d-4249-93f5-6d7ed2a5a173@roeck-us.net>
Date:   Tue, 14 Feb 2023 10:09:55 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 000/139] 5.10.168-rc1 review
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20230213144745.696901179@linuxfoundation.org>
 <05984672-d897-6050-3e8b-3e7984c81bd9@roeck-us.net>
 <1cd10087-87fe-048e-c9ed-0a5d32c50764@roeck-us.net>
 <CAHk-=wgnKpVzL14X0+cLQcWuQmjPAvgrDGF69JRMjgc4rA0VfQ@mail.gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <CAHk-=wgnKpVzL14X0+cLQcWuQmjPAvgrDGF69JRMjgc4rA0VfQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/14/23 09:54, Linus Torvalds wrote:
> On Tue, Feb 14, 2023 at 9:51 AM Guenter Roeck <linux@roeck-us.net> wrote:
>>
>> Reverting the nvmem patches fixed this problem.
> 
> But upstream is fine?
> 

Yes, this was a bad backport. One of the nvmem patches was missing
from the backport. However, a fix for that missing patch was backported,
causing a double device registration and all kinds of interesting
problems.

Guenter

