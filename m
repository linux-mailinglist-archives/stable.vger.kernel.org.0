Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0659C286578
	for <lists+stable@lfdr.de>; Wed,  7 Oct 2020 19:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727999AbgJGRKN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Oct 2020 13:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727997AbgJGRKM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Oct 2020 13:10:12 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E7B9C061755
        for <stable@vger.kernel.org>; Wed,  7 Oct 2020 10:10:11 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id c5so2932347ilk.11
        for <stable@vger.kernel.org>; Wed, 07 Oct 2020 10:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OHgiPi+HH4XIO1ZOH7fI2PdHskzVlXTwSm30bqF05uo=;
        b=R9Pc9OdNUiP7YnimdFz6hEWeTHRvDa6NKuLVbtwqWO0LHmF5kQdWYk1yWDP5hz+8EC
         e4KiKEMgVIPwQiYpciJBTBtyGKtStjtzbnKPWuC7AUAWq3TfqSycSoXFoM9n7y58yQt3
         9rZxRQNDE9K6iKo+OPOkoGiZfrfX1oRZh5vAa9l/i5rv9zFjJDEJxei3cWReJ8dbxy08
         /KnVmVw0qwTR1/pdrOb6BUXlhqXmfda4aAtPrzc2tegIAxfqvXSWetSZ3m2FdGBfDr0G
         gVvz8qow6nxNwE3pATfjSBx9lI7gYI+BKq1yQfPKBCQAW8gjvL//ItTW/EMB7IfFao64
         6adA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OHgiPi+HH4XIO1ZOH7fI2PdHskzVlXTwSm30bqF05uo=;
        b=GbXIUw8+Dz2yX9ju3e7dc50/9in6PoyOryNnpy1aW1ma0bWXJG3Ms6rkjyq5Jg6ikW
         Phu5erkg+CL6izqWY1vpDQ6pUBeinQ/m43vBQKEXwjdV9DKhUV4x2iH8A8jN6lFh+Re1
         eSaCV2oJFvjaqEQQCNQMottuEasEZDUpoXdqeWzdoPBtfU1LeEJzcnXut3r+nxIRjzHI
         prpN5tp7pQZkQJFeim9+J1EmjjoSxBNRDuh/Xd3tI6obPgjWh6wq46rdHTojWv7eT2ip
         O6kRmTTCWjROaNtG4tk8FelsoY/nN0eGKvfcqCbcejyku5KcrIiCegZ2FDiK94bFDRQg
         w74g==
X-Gm-Message-State: AOAM533ewv0u1NSQPZaXZYRHkMyEk1KTXASZNybUYfF0oVShW3u8NFTu
        s50jcn41fw0LeWPuJwd9K64BkxIQ7HXfwQ==
X-Google-Smtp-Source: ABdhPJwryV+JJC0+frkhWptuiEAlqbydnXrv/lIHPKxBRQCrBASqX8L+i/F4FGsJ/GSLRL/BLyhoiA==
X-Received: by 2002:a05:6e02:13ae:: with SMTP id h14mr3688976ilo.208.1602090610153;
        Wed, 07 Oct 2020 10:10:10 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id f21sm1113268ioh.1.2020.10.07.10.10.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Oct 2020 10:10:09 -0700 (PDT)
Subject: Re: Request for inclusion for 5.4-stable
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <690b1e06-742d-6b1f-2f09-83edcc562d95@kernel.dk>
 <20201007164417.GA50479@kroah.com>
 <3e741883-678e-a539-0e6d-6fd681fb5c50@kernel.dk>
 <20201007170456.GA86482@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <414d589f-6adb-28c0-2931-1c3bb5f47d71@kernel.dk>
Date:   Wed, 7 Oct 2020 11:10:08 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201007170456.GA86482@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/7/20 11:04 AM, Greg KH wrote:
> On Wed, Oct 07, 2020 at 10:45:26AM -0600, Jens Axboe wrote:
>> On 10/7/20 10:44 AM, Greg KH wrote:
>>> On Wed, Oct 07, 2020 at 09:36:23AM -0600, Jens Axboe wrote:
>>>> Hi,
>>>>
>>>> Can you queue up this series for 5.4-stable? It fixes some issues
>>>> with an earlier patch that was queued up for 5.4-stable.
>>>
>>> These aren't upstream, right?
>>>
>>> Are they a special 5.4-only stuff?
>>
>> Right, we had to make some 5.4 specific changes to fix various cases,
>> hence these are only applicable to 5.4 as they are fixes for that fix...
>>
>>> And I need a signed-off-by: from you at the very least :)
>>
>> Oops for sure, here's an updated one :-)
> 
> That works, now queued up, thanks!

Thanks Greg!

-- 
Jens Axboe

