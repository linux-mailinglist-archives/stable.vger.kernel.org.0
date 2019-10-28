Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5238FE74F1
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 16:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728892AbfJ1PVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 11:21:14 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:45658 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727615AbfJ1PVO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Oct 2019 11:21:14 -0400
Received: by mail-io1-f66.google.com with SMTP id s17so3994701iol.12
        for <stable@vger.kernel.org>; Mon, 28 Oct 2019 08:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HxpZ1ZDATeLWTNfuZUczckkjppf6TWr8DGKt6RqwR4k=;
        b=0m1fTmgMAAGTmbVeRdv79G4lbkHPOU+8PvrAF3/odh7fE/+VS9sujVaxkk7o3Zoqa9
         Znz4E138IG2ypLOhKQetxtbrQ57T4wrOuMiaotAMNpB+5hZK8JOfMXxLg1dnM8C1wCzd
         6oBCKx2mKx7wRQeuBluE2Ua+nnz3d8SoBn/A9AWSmi7Npt2jgoHHFQaW+ZXGMqM9Jghm
         vR5oiVj0COs/EApANK5jMfEJNKhRNE0eYP3VQXOa0k2TQOBXz6Y6ZV727tfz05a7PB/E
         V05PqEhH2wmpkLFeu2hQ/ukTwYert1p62ZK8XpVAlZWnir4LUlsBe6msq9J3Ji0kk3bQ
         2PMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HxpZ1ZDATeLWTNfuZUczckkjppf6TWr8DGKt6RqwR4k=;
        b=gPSvS+JGW/PG1peS2nW943yp1dOe1cohBkhKT0g7GzIbezdvwVv46uJpmdc6WYejgJ
         NxeOmJW1roOu5kFLI6usnZ+AcLT3phqKYdWO6MZ2trSFn1OzdAW314tW9XIzM9/LlYhw
         SvnDkCUz0jE5vqCxLIlHopyFfwi8c5i4BcFzIW6YThE+IxVY2hWUTQ/CejCwD34xrpyt
         ptsml2zlkuo4cpKvgw7V9vPEfV9614YjzP76qFGdxgpI3chKOHQ9W7+QZ3mw67POLi7B
         /Sj0Q04lDoPh27ilFk9seFXgVpRcXfme4beoCs7P4S01AYl9qTSWf9bYOMW054DnQ4f+
         QP8Q==
X-Gm-Message-State: APjAAAUJPcyxpkmg9MhYpizaeuSCrddhT0Gn7QsREAT8J3uBw+AISbLi
        ei9rojG9Nb2lZnHEjhjUxjESnmtWZ8xhzw==
X-Google-Smtp-Source: APXvYqxvX8RHdmcm9Ww5GUDZdKovkwlkUxJvtqz81//toCkzlzYrE3nhZAst+lnMFHDP3wZtk1DilQ==
X-Received: by 2002:a5e:d917:: with SMTP id n23mr10408961iop.28.1572276073459;
        Mon, 28 Oct 2019 08:21:13 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id w75sm1596618ill.78.2019.10.28.08.21.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Oct 2019 08:21:12 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] io_uring: fix up O_NONBLOCK handling for
 sockets" failed to apply to 5.3-stable tree
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>, zeba.hrvoje@gmail.com,
        stable@vger.kernel.org
References: <1572191635100175@kroah.com>
 <da7d616b-a7e1-5cf5-5b38-75ecf8843ccb@kernel.dk>
 <20191027200020.GB2587661@kroah.com>
 <b9a4a9f8-2588-b13e-b010-916895d7a8dc@kernel.dk>
 <20191027202633.GA2608793@kroah.com>
 <25f998ae-e6d4-9e62-3b3d-996cd92e80cb@kernel.dk>
 <20191028082632.GI1560@sasha-vm>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <be4498de-8fc9-95e6-bb91-60446d305366@kernel.dk>
Date:   Mon, 28 Oct 2019 09:21:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191028082632.GI1560@sasha-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/28/19 2:26 AM, Sasha Levin wrote:
> On Sun, Oct 27, 2019 at 02:39:06PM -0600, Jens Axboe wrote:
>> On 10/27/19 2:26 PM, Greg KH wrote:
>>> On Sun, Oct 27, 2019 at 02:22:06PM -0600, Jens Axboe wrote:
>>>> On 10/27/19 2:00 PM, Greg KH wrote:
>>>>> On Sun, Oct 27, 2019 at 12:58:14PM -0600, Jens Axboe wrote:
>>>>>> On 10/27/19 9:53 AM, gregkh@linuxfoundation.org wrote:
>>>>>>>
>>>>>>> The patch below does not apply to the 5.3-stable tree.
>>>>>>> If someone wants it applied there, or to any other stable or longterm
>>>>>>> tree, then please email the backport, including the original git commit
>>>>>>> id to <stable@vger.kernel.org>.
>>>>>>
>>>>>> I can fix this up, but I probably need to see Sasha's queue first for
>>>>>> the io_uring patches. I need to base it against that.
>>>>>
>>>>> Ok, wait for the next 5.3.y release in a few days and send stuff off of
>>>>> that if you can.
>>>>
>>>> Is there no "current" or similar tree to work of off? Would be a shame
>>>> to miss the next one, especially since the newer fixes are already in.
>>>
>>> I'm about to push out the -rcs right now.  You can base off of that and
>>> send me the patch and I'll add it, or just wait a few days, either is
>>> fine.
>>
>> Sounds good, thanks Greg.
> 
> I'll queue up a backport for this. The conflict is due to not having the
> io_queue_sqe()/__io_queue_sqe() split introduced by 4fe2c963154c3
> ("io_uring: add support for link with drain").

Thanks!

-- 
Jens Axboe

