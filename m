Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B364E62CE
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 15:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfJ0ODO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 10:03:14 -0400
Received: from mail-pg1-f181.google.com ([209.85.215.181]:39107 "EHLO
        mail-pg1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbfJ0ODN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Oct 2019 10:03:13 -0400
Received: by mail-pg1-f181.google.com with SMTP id p12so4726666pgn.6
        for <stable@vger.kernel.org>; Sun, 27 Oct 2019 07:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EjdUKMCcAoWtqufn7db4E+HKnseQ98PM4gvFboX5CFE=;
        b=RfncqpBxTIyvrDHgjVJ0TIsgwtYIlyd41VMTT5FufNBms1UoeAD79sbeSdHAB7K5Un
         jdUzSpEtdETu3PaUfWEkMNkQ+chMOb8V6J+9rcGJ3XDdEsbSMnq6m1ahOU5PGVj11UKE
         fm+UJBnuUB9eUErEaL1MRfC4FSatOQgshYaNTcBUSU3AnrgYrTblCAJ9utFwQuQYwVJQ
         u03YtfpucIMHaguCrN7ZFqrUQ6UzZUwtRuoL8EWby0yJy/jKczTH5vb9dfQa7ACAsWMc
         UlvKu8G8xIgCM92oCyaseVcpwnDqzGCew9UM6EmPvoxRbCYfwj0Axtvh6RQw7ODgSNB9
         Vw7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EjdUKMCcAoWtqufn7db4E+HKnseQ98PM4gvFboX5CFE=;
        b=dZUhnf0FcwGTgz0+/TXzTOQAdcpnNeoXWma/wPssjgEQD8c/tGDjXhYRKpLZ39mF0B
         7GwuqMOURpN51NhIEdjoCNXZaOut0icb2Rei5eb29/edufFFZawAYt1Es1rIlyzCEPm5
         l4ywoMan+RCChz7PItwXqDT+6ZgbOyACaCAA4klOO7JztiidHj2ltpUyf1ZtFynphsuZ
         vMz3JdW4nmWWwhGgwSMeQDY2S4Be0M36AvcgZZBI4hoVUgrOfMTOqd59oj4njmvaknad
         W9CyssYCJjzo5EYp3XBmhLOqf5bVapM3P9QXFluqojpzYL2sYkODtmhnE5rOQZSRRoD0
         PdyA==
X-Gm-Message-State: APjAAAXOyvjtFoecgLds6adT11VpAmdLydUDujFA837PJkGPYbMA2wgI
        TVCMI5/WKMpIfAVA6GMBwp5NidbGUDecSw==
X-Google-Smtp-Source: APXvYqxy4wkdyuOXiOL2d8HuWt0v6jtesVgOwkKALCkJTe6g3yvs7AUdK39Kg0gNalukTIBTo7sYMQ==
X-Received: by 2002:a63:28f:: with SMTP id 137mr11662436pgc.301.1572184992439;
        Sun, 27 Oct 2019 07:03:12 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.79])
        by smtp.gmail.com with ESMTPSA id j11sm4789389pfa.127.2019.10.27.07.03.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Oct 2019 07:03:11 -0700 (PDT)
Subject: Re: io_uring stable 5.3 backports
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org
References: <efc9278b-de72-40b2-9a0a-48df0c64edc1@kernel.dk>
 <20191027085204.GA1560@sasha-vm>
 <f90a0bd3-3074-ee14-dea9-63d520bd72a2@kernel.dk>
 <20191027134832.GD1560@sasha-vm>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4dab77cb-0e29-15af-bb32-26ee23de3f69@kernel.dk>
Date:   Sun, 27 Oct 2019 08:03:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191027134832.GD1560@sasha-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/27/19 7:48 AM, Sasha Levin wrote:
> On Sun, Oct 27, 2019 at 06:01:03AM -0600, Jens Axboe wrote:
>> On 10/27/19 2:52 AM, Sasha Levin wrote:
>>> On Sat, Oct 26, 2019 at 05:33:41PM -0600, Jens Axboe wrote:
>>>> Hi,
>>>>
>>>> For some reason I forgot to mark these stable, but they should go
>>>> into stable. In order of applying them, they are:
>>>>
>>>> bc808bced39f4e4b626c5ea8c63d5e41fce7205a
>>>
>>> This commit says it fixes c576666863b78 ("io_uring: optimize
>>> submit_and_wait API") which is not in the stable tree.
>>>
>>>> ef03681ae8df770745978148a7fb84796ae99cba
>>>
>>> This commit doesn't say so, but really it fixes 5262f567987d3
>>> ("io_uring: IORING_OP_TIMEOUT support") which is not in the stable tree.
>>>
>>>> a1f58ba46f794b1168d1107befcf3d4b9f9fd453
>>>
>>> Same as the commit above.
>>
>> Oh man, sorry about that, I always forget to check if all of them are in
>> 5.3. I blame the fact that I backport everything to our internal tree,
>> which is 5.2 based. But yes, you are of course right, those three can be
>> dropped.
> 
> How much "secret sauce" does your internal tree have? Is it something
> we can peek into to make sure we don't miss fixes?

There's no secret sauce in the internal tree, it's just that I backport
everything into the 5.2 version that is our newest. It's fully uptodate
with 5.4-rc and in some cases what's queued up for 5.5 as well. Hence I
sometimes forget to check what is applicable to 5.3-stable, since I have
it in our 5.2 tree...

The internal tree is just backports. That's how we do things.

-- 
Jens Axboe

