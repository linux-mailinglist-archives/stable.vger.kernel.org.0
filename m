Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27356E6555
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 21:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727977AbfJ0UWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 16:22:11 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33398 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727121AbfJ0UWL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Oct 2019 16:22:11 -0400
Received: by mail-pg1-f193.google.com with SMTP id u23so5096461pgo.0
        for <stable@vger.kernel.org>; Sun, 27 Oct 2019 13:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LIB5NQNKD9523j+L9amoI/eFJfVAotXndN3TnZUgyws=;
        b=noS1gtpMiLCvdgRUF0aQrwIl8qRciafWXGJHJorZ2rwgt2zYbt5ar4T5aE+Ne+Y4lT
         h28dsjoeWjdQ2YAitzSDWVcRP+7np7kdk1/FydAaD6dxD4XXSXoSf1q4nuMEhLXIWeP+
         DRDAlJ5xb3FhqeBWWRH5bG0lpTNQw9iC1IMbUZEmBEJYuvXKfK6ANqWOKwZtgtvElqSD
         CFv1mMr2n/1QA7mSAC6dJPQxgZw8pvJc0Ep5wCCdfcaHBaCwyX9meqH+jJ5TogRCIvRK
         DMAjKh9+skzl8t4MDvFyENwPj6oVJPQ2RzgRRLtXtH75aKjQJYYdgtlQkrqgqMq3GQ3U
         1agA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LIB5NQNKD9523j+L9amoI/eFJfVAotXndN3TnZUgyws=;
        b=MFCHVrQ489JATBrka1zAALItsiloYkqUuLtEF/5po3DSBHdGMRgGs6lJ4ZKuZuELHg
         Ji9dvM3cJnrgzg1VwjPFNzPaCGdAj4eqQ64RFunol6x225UWLznx4DmCl+p5/HZEGg3W
         6p+Gsr3iNbTYS538lgNSzDX2sWyx1VG+DUwxFeQsmlBK8MOtJg/F6Atad6ZleJvvihTc
         qLqMb2qz7i+ft+/i+5aPHfoOFakB1hPqSvd5eJNP9Wcp+yp9ddSCReA6o5R5reN3/dEG
         CxdoHcICzPdhPUdTKbhzMFj7FpF3maBqGfkQEV+yWlV1Y/aElTVhXLHHiWw4uHP28qiY
         FKsw==
X-Gm-Message-State: APjAAAVsfhK4SCAdsXzpg8PelUN0LBWxRlqL1RFT8KjnhbnZIl6rMEUY
        OlMCMoIjnR26P6RIRcGRKONHeg==
X-Google-Smtp-Source: APXvYqwRnOdkNFFptbnpJ7n/N+ihgFVFkhcxmQNP2gW14ERnuPkKHJtN0GNkl4rCy0y7k80nto2LiA==
X-Received: by 2002:a63:b60b:: with SMTP id j11mr5559622pgf.116.1572207728703;
        Sun, 27 Oct 2019 13:22:08 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.79])
        by smtp.gmail.com with ESMTPSA id k32sm8447050pje.10.2019.10.27.13.22.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Oct 2019 13:22:07 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] io_uring: fix up O_NONBLOCK handling for
 sockets" failed to apply to 5.3-stable tree
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     zeba.hrvoje@gmail.com, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
References: <1572191635100175@kroah.com>
 <da7d616b-a7e1-5cf5-5b38-75ecf8843ccb@kernel.dk>
 <20191027200020.GB2587661@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b9a4a9f8-2588-b13e-b010-916895d7a8dc@kernel.dk>
Date:   Sun, 27 Oct 2019 14:22:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191027200020.GB2587661@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/27/19 2:00 PM, Greg KH wrote:
> On Sun, Oct 27, 2019 at 12:58:14PM -0600, Jens Axboe wrote:
>> On 10/27/19 9:53 AM, gregkh@linuxfoundation.org wrote:
>>>
>>> The patch below does not apply to the 5.3-stable tree.
>>> If someone wants it applied there, or to any other stable or longterm
>>> tree, then please email the backport, including the original git commit
>>> id to <stable@vger.kernel.org>.
>>
>> I can fix this up, but I probably need to see Sasha's queue first for
>> the io_uring patches. I need to base it against that.
> 
> Ok, wait for the next 5.3.y release in a few days and send stuff off of
> that if you can.

Is there no "current" or similar tree to work of off? Would be a shame
to miss the next one, especially since the newer fixes are already in.

If not, I'll just wait for the next one.

-- 
Jens Axboe

