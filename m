Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24AE5677133
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 18:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbjAVRsE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 12:48:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbjAVRsD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 12:48:03 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE11B13D4F
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 09:48:00 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id z20so7433897plc.2
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 09:48:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mklioiOy2SPx/+Wl0XHLwjVP/zb0IvNHLalin7YERKQ=;
        b=M7K0zj+abUg4/PHuIjVVaLh/6Dh6z4S40ydjuMtgh8TTGjrAJay2yDEpujiOG0iimK
         0rkHFyi1c45orbeUtUtr0w8xWwpm7vJ2bc3oRZYmmPqCvCO7w0ZZb6a3O4ubjKkU1Q4k
         SCNg+a7Tkgo42yykChZJ2Gk8LDIRAno/b4eTcwPcM190m4sdAYwY0eJhVLuupx0ut5lY
         gDeWIr8QBmVgO6ttAkCQDUNFLpyZKy2SDHH9r7OVkYt4zO17r+lkt7p2+DGxli1svwo0
         2BBf9LVSkZAoUEdmz5WJ7lddrS81CdvQkmmEeFTq8W6OCsRNLQAQwhfSc2IqssZmNDrW
         gxKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mklioiOy2SPx/+Wl0XHLwjVP/zb0IvNHLalin7YERKQ=;
        b=nnYd8C8gtGtCCDTaCDP8+D6dsisGsweZ0Sl6BCFC3vgyeOHqgwG5BJTV08mLV5lYf4
         +T8Uh40PyysXp4s2O6/xkaWrwL0pCZmBvTS2RrS4MpWXxynYZIBbtMRWlWNyM1Qo8UuV
         JgJt2qAMsyeEfH+Kjyi1QXF0VYsgCKsB7MHhF3d/drgyUu7PXp0YMO3KakCFzdGvrLUF
         Zajbe1ogXrmLBe9S00aMUoukn/E5IKsp3LDITddLUBleg9AcrRR6GA3V9UOSiKeiE7G8
         9o1eoc1gBdhlQ7y3uuzqdz6O684iG2Y1McdG0pD4afmjTdGhHSjnwj70fN6ZuqZ/OvHJ
         Rq+w==
X-Gm-Message-State: AFqh2kq1tooSHkFY5x54D4EFN1JIG6Ta8HmECcSeQGhesLradOE7jtKD
        oCCuSc+J/geBvyIrBiPT7dmL5g==
X-Google-Smtp-Source: AMrXdXtIsNAlL0SxiNFyN2BzVxFTaLZUMTQq4Dc994DQ4GgrymgUQhe8oFoWQrNuXqIFlcJSF1/PHQ==
X-Received: by 2002:a17:90b:3c84:b0:22a:348:c7b5 with SMTP id pv4-20020a17090b3c8400b0022a0348c7b5mr2458138pjb.2.1674409680338;
        Sun, 22 Jan 2023 09:48:00 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p11-20020a17090ad30b00b00229b17bb1e8sm5125788pju.34.2023.01.22.09.47.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Jan 2023 09:47:59 -0800 (PST)
Message-ID: <8fa86861-2713-ae11-99ef-14d90b2943d7@kernel.dk>
Date:   Sun, 22 Jan 2023 10:47:58 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: FAILED: patch "[PATCH] io_uring: Clean up a false-positive
 warning from GCC 9.3.0" failed to apply to 5.10-stable tree
Content-Language: en-US
To:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        kernel test robot <lkp@intel.com>,
        "Chen Rong A." <rong.a.chen@intel.com>, stable@vger.kernel.org,
        io-uring Mailing list <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
References: <167439864617430@kroah.com>
 <CAOG64qO=iZZO-PJjmeYO5wKHAxn3ATDyj6g=FA_tx3WNAMBvug@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAOG64qO=iZZO-PJjmeYO5wKHAxn3ATDyj6g=FA_tx3WNAMBvug@mail.gmail.com>
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

On 1/22/23 8:43 AM, Alviro Iskandar Setiawan wrote:
> On Sun, Jan 22, 2023 at 9:44 PM <gregkh@linuxfoundation.org> wrote:
>> The patch below does not apply to the 5.10-stable tree.
>> If someone wants it applied there, or to any other stable or longterm
>> tree, then please email the backport, including the original git commit
>> id to <stable@vger.kernel.org>.
> 
> That uninitialized reading is living in 5.10.y branch now
> https://github.com/gregkh/linux/blob/v5.10.162/io_uring/io_uring.c#L4989-L5017
> 
> If this:
> 
>    ret = import_single_range(RE AD, buf, sr->len, &iov, &msg.msg_iter);
> 
> fails, this one (flags & MSG_WAITALL) may read an uninitialized
> variable because @flags is uninitialized.
> 
> Fortunately, if import_single_range() fails, (ret < min_ret) is always
> true, so this:
> 
>     ret < min_ret || ((flags & MSG_WAITALL)
> 
> will always short circuit. But no one tells the compiler if @ret is
> always less than @min_ret in that case. So it can't prove that @flags
> is never actually read. That still falls to undefined behavior anyway,
> the compiler may emit "ud2" or similar trap for that or behave
> randomly. IDK...

Now handled for both trees.

-- 
Jens Axboe


