Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDB73E655D
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 21:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbfJ0UjK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 16:39:10 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37811 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726956AbfJ0UjK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Oct 2019 16:39:10 -0400
Received: by mail-pl1-f193.google.com with SMTP id p13so4333279pll.4
        for <stable@vger.kernel.org>; Sun, 27 Oct 2019 13:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2gDHjkdm+90iCJ7CFFketpqX4s69oYxbMmg0EEV/ss8=;
        b=hV/UC5cbZUK6eLolKNp1AdhYq/elCHXQE7h2CGJfFO7rPNNQk7KKaUaD01WjWn0GbL
         cBa25bVDOUd+0sfp8mNUBQcMPT7WT1zAa2y2bLa/ixbpCvpjZjiyWQj7ic80uPP/eBLy
         PTBvGITVbI2kfH4Ekdg1DgxPuBzugt9kiUTn+6JHWSOcvET66Yx3QSMDs8C7lN17qVbE
         80YHw1u6u4/BjVuYm9G0+5BlrjP2aHa4l7x/CqDUYTzY2s/67rgUl/T+/pXvoE6UJeoB
         tw5v58WOUd/WFojarBpgpDk39IsP1WevVTGrPPgbj1qIroEMWeejx2CQ6ZK1heOk5wYy
         NIkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2gDHjkdm+90iCJ7CFFketpqX4s69oYxbMmg0EEV/ss8=;
        b=rUUTYGLFnhktOiPL5sLI1T4Ln19Mc2bpL/0tjEi87MvcVkJRXcK+p/XYyPfP77Q52a
         6dGkdHBwIs6LpdbHRCf+QFY2UHLQ3oQnnzNeFqHkR08+S/OGlz/T18Gfkd/Gxc5Il6/n
         A8gtwAawIRrDD6/KpDnOl1tOUGVTxRFYpUB8Vt9y43zrcLCy0+kqSXTBlUHUtnTgz6X8
         9Uwq391UnPdECvmH1QeCTnLiyjWe75cEuf6jsp8PCHQqzsGGMfDm4AfQ18/o0K5xAvk2
         SWTsBTAtOIZuESy6hDI9Z0xMBbNinPU+LDqkWdF0wGAmZA4d/OhgUgSWQmyIjWc7qlDy
         IFnw==
X-Gm-Message-State: APjAAAUAP+pMUZ+mwa8PrZJ51dK/1PBeoVv1ilDta8DNT9LDTlauCfT9
        g0Hv4FLujsetrWZ8KIeiByUolQ==
X-Google-Smtp-Source: APXvYqz3CW14j1Jp5SPV5x5b6mK9NH1+EkW5EnONYYHtZvKiZ6X1kbozX9LMwS9r/PiuSENxTjnK9g==
X-Received: by 2002:a17:902:820f:: with SMTP id x15mr15815963pln.288.1572208749756;
        Sun, 27 Oct 2019 13:39:09 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.79])
        by smtp.gmail.com with ESMTPSA id v19sm7721305pff.46.2019.10.27.13.39.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Oct 2019 13:39:08 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] io_uring: fix up O_NONBLOCK handling for
 sockets" failed to apply to 5.3-stable tree
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     zeba.hrvoje@gmail.com, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
References: <1572191635100175@kroah.com>
 <da7d616b-a7e1-5cf5-5b38-75ecf8843ccb@kernel.dk>
 <20191027200020.GB2587661@kroah.com>
 <b9a4a9f8-2588-b13e-b010-916895d7a8dc@kernel.dk>
 <20191027202633.GA2608793@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <25f998ae-e6d4-9e62-3b3d-996cd92e80cb@kernel.dk>
Date:   Sun, 27 Oct 2019 14:39:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191027202633.GA2608793@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/27/19 2:26 PM, Greg KH wrote:
> On Sun, Oct 27, 2019 at 02:22:06PM -0600, Jens Axboe wrote:
>> On 10/27/19 2:00 PM, Greg KH wrote:
>>> On Sun, Oct 27, 2019 at 12:58:14PM -0600, Jens Axboe wrote:
>>>> On 10/27/19 9:53 AM, gregkh@linuxfoundation.org wrote:
>>>>>
>>>>> The patch below does not apply to the 5.3-stable tree.
>>>>> If someone wants it applied there, or to any other stable or longterm
>>>>> tree, then please email the backport, including the original git commit
>>>>> id to <stable@vger.kernel.org>.
>>>>
>>>> I can fix this up, but I probably need to see Sasha's queue first for
>>>> the io_uring patches. I need to base it against that.
>>>
>>> Ok, wait for the next 5.3.y release in a few days and send stuff off of
>>> that if you can.
>>
>> Is there no "current" or similar tree to work of off? Would be a shame
>> to miss the next one, especially since the newer fixes are already in.
> 
> I'm about to push out the -rcs right now.  You can base off of that and
> send me the patch and I'll add it, or just wait a few days, either is
> fine.

Sounds good, thanks Greg.

-- 
Jens Axboe

