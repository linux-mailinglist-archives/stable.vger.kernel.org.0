Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E32E1677CD1
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 14:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbjAWNpY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 08:45:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbjAWNpX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 08:45:23 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E757AEFB9
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 05:45:22 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id h5-20020a17090a9c0500b0022bb85eb35dso6639263pjp.3
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 05:45:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ypcll6rcz+2Sea/Dl0o/2HwvI/ZpKjR9I3LC7fo9JwU=;
        b=hag7wJuh1uswx1BeduxmDp8P1jpMQrySnb9rZ5T8zKWxHVFzJ1q+JF5sQp2eh/81x3
         qEhbVjPNC+Bs82b6YlgH5fui+UgykmCnRU6rqBVOd5SiEWRrmXSsdfaeJLJqhyyinJKt
         NhIdNO5E+YMJ1mWzKPLdjPYGnKyN8AGzQSQNt5hIRVobcpMQRYbqKzwwihaPz4VRGAg9
         mb4DG0WeC03MVB/7ggnk/q6mFvYCz2UFIqrlYlPdDgY45kWYZ6oY24uHYMQLeQhoNppL
         pZzSnNcr/eo7njR3yRZ/W2Bz5crmfXQQj8dErJGHk15szETCjKkiECj3tQvlrVh8tWdS
         TfHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ypcll6rcz+2Sea/Dl0o/2HwvI/ZpKjR9I3LC7fo9JwU=;
        b=F8G7rbgBBXxZZdsM0jN3pmJi3CX90tu+S6U1l0WOXbN8i5PRTWp+hqWz8HqXxhaSd7
         UBGMQMgvQc/bEv7G2zKVU2EKG1rVt1xtmSQRwQRKoT6v8iAMTuXokQwqJoxYxB+DnmXg
         U7gc702dfejE4KIUsIdThyT1FoXQpxVpLrTamdhAExix1xL1Z5PLbQnKxdtaqhnLF90I
         c1eXYtLU7Ieml1tBwzsfIzeuY6nNQhJuwcyBxpyKs4fnF8E+4iqmPgEbKAZPhhHpgMhJ
         YPcQrUzZuNY/tGr5+smNxGizRQF1H7y1Gan82oA8YBBlksLoiCQD6keHOo/hdzZ8s2/Z
         Nzlw==
X-Gm-Message-State: AFqh2kpczYIDd5aotkv0IG5uPvq3zPe4+iDXe1y9oEVaVry/TpYzmQZr
        Ihb2RQ5UyQgF3IkKPW5858p6TA==
X-Google-Smtp-Source: AMrXdXuRb6SL2qwaZpZ5fYGCqxU6S18Izu0n9OLs+Hbhn+gPKOmvRuCe7hsrfmA81445M+GoDISwLA==
X-Received: by 2002:a17:902:ab16:b0:195:ea0e:3221 with SMTP id ik22-20020a170902ab1600b00195ea0e3221mr2707007plb.3.1674481522242;
        Mon, 23 Jan 2023 05:45:22 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id y17-20020a1709029b9100b00192740bb02dsm2120811plp.45.2023.01.23.05.45.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 05:45:21 -0800 (PST)
Message-ID: <12da95ef-0727-4a58-7854-81ee7b2d02da@kernel.dk>
Date:   Mon, 23 Jan 2023 06:45:20 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: Missing 5.10/5.15 stable patches
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable <stable@vger.kernel.org>
References: <68f7505b-e6e4-bcaa-63ed-418e247a143f@kernel.dk>
 <Y85YFKN4mX4JFNNX@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Y85YFKN4mX4JFNNX@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/23/23 2:49 AM, Greg Kroah-Hartman wrote:
> On Sun, Jan 22, 2023 at 10:47:42AM -0700, Jens Axboe wrote:
>> Hi Greg,
>>
>> As mentioned, two of them could be discarded. Here are the 4 that should
>> indeed get applied, ported to 5.10/15 stable and tested. The series
>> applies cleanly to both trees, so just sending one set rather than applying
>> to the individual "failed to apply" emails.
> 
> Thanks for these, all now queued up!

Thanks Greg!

-- 
Jens Axboe


