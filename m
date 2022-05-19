Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6B252D29F
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 14:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232721AbiESMge (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 08:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236758AbiESMgd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 08:36:33 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F5C220F0
        for <stable@vger.kernel.org>; Thu, 19 May 2022 05:36:30 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id i24so5040381pfa.7
        for <stable@vger.kernel.org>; Thu, 19 May 2022 05:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=dl2ACopGjJBM6RoKaafxy83X2jJ4IJ9dmwbplOvmKpc=;
        b=GjOABBxh77rXMUNZhbVvWR8eAKwZ4jKS88JJVuYHvTWch3/Vuq8o85JEaAVFZimng7
         dpWL+f4dlXJNBY15tsaxAEOLI+J4EL8gcKLWDEES3BUfE+seStpemzhxUnDB8+XxhMPi
         ICAIcwAiQY7NkPEOM+hR01VTyIblZj9F6ifMCYbhhYhjK2GN4b++bZZGOopKf8iGvV1e
         UwDVvH2KQdNUY81W45OHwAG5jvE9jvmt0f2FWTbU1JxnXbCLmBJkZ7qAqr8kFE2FV5id
         RoVqxDD6W160D39xnKAbgYAPvLjv4v7ZlzKle286Z1VX7CSiQJftGJPdI/iniCBT5OGB
         /bLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dl2ACopGjJBM6RoKaafxy83X2jJ4IJ9dmwbplOvmKpc=;
        b=U5qCmDbUNKOTirrtdYeDEH91I5eAzYXn+ermIn6zeWSKjgmcQm4+PmfWXYKxb5TtMq
         /Zi4juM2sZuY2BImqFbRF1cQ0OPXSkT3G9lzby8Dpy9jd2cJRmJ8/qVioJysDWM1Y/QN
         xbsjZNp6kSABUFCs7hJQjShXbpx90c00qOpjj2x9U2wXfce1iqjQ7mi3KMB4W80BBhiU
         FGmIAw7sjy/jfrac2E4RFKXkWrpIvfvH84bmp+T+W7vL0PgHY12IlG5LnW7e5aPxjKAW
         e/HaGHSMAFvL2Q1L8OBdsIJ4UHUrXvbDeEgSzycxynRKW5e6KYTIWGuxfr8T032eSBYS
         udCA==
X-Gm-Message-State: AOAM530aaCdjLp8LqQaIybeS++4sMc+DqQjr1VfCmOt3kSXtNsPKG/SE
        +3wTwp55GQQZ1ZCzk5xUX/lpkUspX3QRpw==
X-Google-Smtp-Source: ABdhPJyL9RJMTyivYjB+qiA7U3vOzib39oJ5c8VE20v2XIS57UeftAIZ8SDqhBgW0KDFOBYAVx2vQQ==
X-Received: by 2002:a63:5008:0:b0:3f6:2e0b:cf3a with SMTP id e8-20020a635008000000b003f62e0bcf3amr3571689pgb.213.1652963790280;
        Thu, 19 May 2022 05:36:30 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id j186-20020a62c5c3000000b0051844f3f637sm877900pfg.40.2022.05.19.05.36.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 May 2022 05:36:29 -0700 (PDT)
Message-ID: <3c4f9e1a-07c7-e86c-c43f-68e73b7eedee@kernel.dk>
Date:   Thu, 19 May 2022 06:36:28 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: Cherry-pick patch request for 5.15-stable
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <032e7301-10ef-c392-04ed-345763e893da@kernel.dk>
 <b0d16f69-f345-3a6a-3e42-122016fb601a@kernel.dk> <YoY5YKsUp4zIXqC7@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <YoY5YKsUp4zIXqC7@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/19/22 6:34 AM, Greg Kroah-Hartman wrote:
> On Thu, May 19, 2022 at 06:10:46AM -0600, Jens Axboe wrote:
>> On 5/17/22 8:37 PM, Jens Axboe wrote:
>>> Hi,
>>>
>>> Can you cherrypick:
>>>
>>> commit e74ead135bc4459f7d40b1f8edab1333a28b54e8
>>> Author: Pavel Begunkov <asml.silence@gmail.com>
>>> Date:   Sun Oct 17 00:07:08 2021 +0100
>>>
>>>     io_uring: arm poll for non-nowait files
>>>
>>> into 5.15-stable? It should apply cleanly.
>>
>> I didn't see this in the 5.15.41 release that just happened
>> yesterday, just a ping to remind you that this is needed for
>> 5.15-stable.
> 
> I already had the -rc releases out when you requested this, please give
> me a chance to catch up, it's been less than 2 days!  :)

Sorry, I think that may have come off a bit wrong, a few days is
obviously fine :-). Just wanted to make sure it wasn't overlooked or
missed, and came to think of it when sending out that 5.10-stable patch.

> I'll queue this up now...

Thanks!

-- 
Jens Axboe

