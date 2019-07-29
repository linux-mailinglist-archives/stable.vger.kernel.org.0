Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EEB9792EB
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 20:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728740AbfG2SRV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 14:17:21 -0400
Received: from mail-io1-f49.google.com ([209.85.166.49]:33093 "EHLO
        mail-io1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726242AbfG2SRV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jul 2019 14:17:21 -0400
Received: by mail-io1-f49.google.com with SMTP id z3so3284410iog.0
        for <stable@vger.kernel.org>; Mon, 29 Jul 2019 11:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jN1VrhemEwfUdvcwgI6hsvtoLObQ3NsJ5/wJEXlhkzA=;
        b=kWwqz43DjtNsBiFPAP1nYt6/VUBZkEwJ/Qkrn0EVXfwrriQgw9E6RnQm83gnAXFT1r
         K6Ntnus7OBBwqa+wec+inRmVVF+npYRa8aIHp+BwvlkvhD2KqIryFYCefsDYejDK9c1z
         oIU6MX9h4L0PrEV9DwGN3UOQAaD6bFGU5qypNOoq2HfdBz5wOuaeyxzZUWrCQJixdm5C
         GE2km+FPCfnlwDl7EHan9VpIeqZ1egZy6npV062Jt0EHuVfyVVjon71VopthKtPphFoG
         Zk6ANLTIv6t3fwG2Cpz2wFAQ/Vl6EHFQheUFOkqm5tNwcWoeqhFlzA8aTC+2u+ZMjYNm
         pZNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jN1VrhemEwfUdvcwgI6hsvtoLObQ3NsJ5/wJEXlhkzA=;
        b=bAsjtrgbN3PSqlSjR2BzEWkV+NCvG2h+onCCgXwXQSYP1TL/29187bXCwISqCRV+Ln
         tAzS4UQFj94BCmNH5AOthks3l1IfMho+MZalCiAYmibaaYJEb2vOR0tz34T01c53CQxx
         n3cHgSwAgmy9StP5JwJyQGqirqHmDthNha0xKFHhJf13IpxZEZEF4AYqzxPLfQU2ibKR
         4EuAa4Ny7Wxfl3itlKIEKdR+bzvtN/yMXnAiyM+UIdLRFkygINxd/6m127SV81clFIwP
         cz45KkuoZBfvTwTGQXDn9uJ+iWIBjLm4H/0WN5ozRQD7yQnAZkKP2gd6hs6rBZv0+vA4
         qPhQ==
X-Gm-Message-State: APjAAAXSHfsvmgZ3w4317pUBy9IDtwjTwlQXJcRMJROAyV4YX/evhN3d
        dOhEsVMwZPAOXDTt67er3WrnGdRoEYU=
X-Google-Smtp-Source: APXvYqw15iY8h6OdgDTSZamSq5CLBwQQlz3SK6iIvTXFMHD3SU3zAbM2JlskQE7MtByyk8mDnNoyeA==
X-Received: by 2002:a02:b609:: with SMTP id h9mr109898502jam.36.1564424240186;
        Mon, 29 Jul 2019 11:17:20 -0700 (PDT)
Received: from [192.168.1.57] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id s3sm52236467iob.49.2019.07.29.11.17.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 11:17:19 -0700 (PDT)
Subject: Re: fs/io_uring.c stable additions
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <59d14d1f-441a-568c-246e-4ee1ea443278@kernel.dk>
 <20190729181528.GA25613@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <abd31004-9c2f-ffa9-10b3-77ed4427d411@kernel.dk>
Date:   Mon, 29 Jul 2019 12:17:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190729181528.GA25613@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/29/19 12:15 PM, Greg Kroah-Hartman wrote:
> On Mon, Jul 29, 2019 at 12:08:28PM -0600, Jens Axboe wrote:
>> Hi,
>>
>> I forgot to mark a few patches for io_uring as stable. In order
>> of how to apply, can you add the following commits for 5.2?
>>
>> f7b76ac9d17e16e44feebb6d2749fec92bfd6dd4
> 
> Does not apply :(
> 
>> c0e48f9dea9129aa11bec3ed13803bcc26e96e49
> 
> Now queued up.
> 
>> bd11b3a391e3df6fa958facbe4b3f9f4cca9bd49
> 
> Does not apply :(
> 
>> 36703247d5f52a679df9da51192b6950fe81689f
> 
> Now queued up.
> 
> You are 2 out of 4 :)
> 
> Care to send backported versions of the 2 that did not apply?  I'll be
> glad to queue them up then.

Huh strange, I applied them to our internal 5.2 tree without conflict.
Maybe I had backported more...

I'll send versions for 5.2 in a bit for you.

-- 
Jens Axboe

