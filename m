Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62AF166BFFC
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 14:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbjAPNmc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 08:42:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbjAPNmc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 08:42:32 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80CA91CF52
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 05:42:30 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id 7so19694608pga.1
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 05:42:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tErkCosgVrVsY9HwXyFuLDBw31Us8x14nZ20eKCJlIU=;
        b=D+BxIZZlaxiv2eMBSwyLnJS4slW9SQthFSjAIni2i9wN/XHny19/nTDAt8rdWEdP5p
         Ouv9cDtUYXFFo2CDAqucYqxRYaDnN8pUohuCZ01Q5iK5LV1DGgTDGJuYDPHv8UMxQ6y5
         IOOSRzyidXrSWjgldlSlAUZ7iDVZd0hhxb6b5M/1mVVFUSjpYPtWCB+e0jaAgQaLPnfw
         +ZQUMyovOD9eyjtC2WerWYKg3a2LBIiHw21RGb2W6oU1aVqam1zFRjSaS56GKaDK/pIy
         PJvRpeAtTzff1viVFPZagZBpxXQfAEQKZjnGMlWcqbbGrIWW3qRkwrJgVz6U5DE8xjtk
         An9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tErkCosgVrVsY9HwXyFuLDBw31Us8x14nZ20eKCJlIU=;
        b=oHJM021GbEdoNIKuHyQCGFi9gxk5ZxOEbGYc1azWThgpz55+65MtjhBxN1EHOQ6C2C
         65TGochMm4DPBHrmV8FYiYhyoPSUYyUTOllCBcBZ2CvgoGkpKigtwnvPHe82Lj1Droef
         4Eo+rjdP8hkzJvTfyEw2RdlZsDOiJqzuDMNET6rv0mXM12UGTGPaYR+NwtFdge/O+I+M
         SvKBgzAXtzZWnGu4S9tXZyXGOWOYnWBkrNb3qFb0zEbUEEx7vWqnBnl8hxXgNNUkOSSB
         mQfFYoahqlavx2qrJ0L3kVBzJeQjWLodDoezMlSHhk1XD/ivq0wXLo5IDFC1bJYQSVsB
         bVhg==
X-Gm-Message-State: AFqh2kpLAGl8r5LzgoQd/XUgrF94+zFJCWfPJltqzwIaP3LaMtWOFo0p
        JRIEz2+f3qsVvRCOJjPsSIP0zTDBZ1oFjrjK
X-Google-Smtp-Source: AMrXdXu7lYyfPTqoQcyUt78UxBQCjTNeeTOYmqdsUP/GACWq/O0SrXccfdV64V/2BD55P6CDuBZysA==
X-Received: by 2002:a62:1996:0:b0:582:d97d:debc with SMTP id 144-20020a621996000000b00582d97ddebcmr10117988pfz.3.1673876549769;
        Mon, 16 Jan 2023 05:42:29 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id a20-20020aa79714000000b0058d9a5bac88sm2532974pfg.203.2023.01.16.05.42.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jan 2023 05:42:29 -0800 (PST)
Message-ID: <c5632908-1b0f-af1f-4754-bf1d0027a6dc@kernel.dk>
Date:   Mon, 16 Jan 2023 06:42:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: =?UTF-8?Q?Re=3a_=5bregression=5d_Bug=c2=a0216932_-_io=5furing_with_?=
 =?UTF-8?Q?libvirt_cause_kernel_NULL_pointer_dereference_since_6=2e1=2e5?=
Content-Language: en-US
To:     Linux regressions mailing list <regressions@lists.linux.dev>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        io-uring@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "Sergey V." <truesmb@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <74347fe1-ac68-2661-500d-b87fab6994f7@leemhuis.info>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <74347fe1-ac68-2661-500d-b87fab6994f7@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/16/23 6:17?AM, Linux kernel regression tracking (Thorsten Leemhuis) wrote:
> Hi, this is your Linux kernel regression tracker.
> 
> I noticed a regression report in bugzilla.kernel.org. As many (most?)
> kernel developer don't keep an eye on it, I decided to forward it by
> mail. Quoting from https://bugzilla.kernel.org/show_bug.cgi?id=216932 :

Looks like:

commit 6d47e0f6a535701134d950db65eb8fe1edf0b575
Author: Jens Axboe <axboe@kernel.dk>
Date:   Wed Jan 4 08:52:06 2023 -0700

    block: don't allow splitting of a REQ_NOWAIT bio

got picked up by stable, but not the required prep patch:


commit 613b14884b8595e20b9fac4126bf627313827fbe
Author: Jens Axboe <axboe@kernel.dk>
Date:   Wed Jan 4 08:51:19 2023 -0700

    block: handle bio_split_to_limits() NULL return

Greg/team, can you pick the latter too? It'll pick cleanly for
6.1-stable, not sure how far back the other patch has gone yet.

-- 
Jens Axboe

