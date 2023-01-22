Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44671677136
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 18:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbjAVRsr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 12:48:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbjAVRsq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 12:48:46 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFBD013509
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 09:48:45 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id 200so7258145pfx.7
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 09:48:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YluK9ElqNwHnfdQk+YasSM+S3pHK5ob32hBKkq1h1lY=;
        b=jlhnTHGHvs9uGD8WZkYDpTrKAHRsnK25UHf3gXzBS7JggExgvsiMEfX/WnLgtOMEo/
         yGlIsoxt4zk4VpfcSiSRS9Ay5qA1t6G2dvAz3P8mGA7JVoZqQ9MpOZhzNoXUEjESx1f5
         LvZXxw5FfVODuykoSiqzkZdiOdNl3ZF5q3h+jnRL8OllWxTc/uQJYN0WqoqYCm/uBoHQ
         JZy9OqLuAiexq+BkFu709ilp7kRJzwnH8oS1jh0uPMPXGRJyiXshTz/NLsqAT1SX0kDe
         iY1rceVIoSHhKS2Y3RmWORf1xY01lQWlo37F/KHJqYNZ1WNwX+2dV5tmKrknY9rmhpPd
         WHlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YluK9ElqNwHnfdQk+YasSM+S3pHK5ob32hBKkq1h1lY=;
        b=fUIM1Cnk57NilQ4JsKDRquTtI+JP6/QjaHpMN8EK8Oa678yHAtMmRHxW8ONZdOMxiA
         oiuPIaExljWqPyOKb8hkMnD7HxqIUM3Dm50o4AZ2CHHIGv11oUNppKn7GcSIlYUz46In
         fe04tZATm5pGsuuMFw9qmoFEnIh8SusNs8t+z5YXuxGyxq7Kol+o4ojWGclKt0JP3BmE
         e3fuqdCtlQtnh+XgIvwTREvqeZrjBZtfxDsjIa8E+hreELc8Wsl8vdt9rwdaqwl5cGGu
         wl9eLW+Vj6Cw/X7+8idz9CUqLwQPXP9lcxs4oK2Yw+gbsqPK8W6tBn4jwEpX0Kt9vQOB
         sq5A==
X-Gm-Message-State: AFqh2kqxKLVwHPCTPG8h7KGFBqfzF9pX8LW4cnn0ztb4ln5N79Yk4900
        o39NUU/roH/WIqqlRIYHr/JonD+IQ6uwQX+P
X-Google-Smtp-Source: AMrXdXszBmC05DeL8w7iy0mLSf8opb2J0hk6RftqwlbZIArHrXtHa6EGcNN0kusiAdgIAY6EqjNojQ==
X-Received: by 2002:a62:e919:0:b0:58d:be61:7d9e with SMTP id j25-20020a62e919000000b0058dbe617d9emr5162870pfh.0.1674409725269;
        Sun, 22 Jan 2023 09:48:45 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id x15-20020aa78f0f000000b00587fda4a260sm13344042pfr.9.2023.01.22.09.48.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Jan 2023 09:48:44 -0800 (PST)
Message-ID: <44961388-26d3-3163-3928-a8fe6e28cc04@kernel.dk>
Date:   Sun, 22 Jan 2023 10:48:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: Patches for 5.15-stable
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>
References: <be4f98fe-2e66-f7df-5f59-acc2ed7cccdb@kernel.dk>
 <Y81MNeUGrntM0FKW@kroah.com> <eaf582d3-82da-b6cf-76e0-55b4f2597f8b@kernel.dk>
In-Reply-To: <eaf582d3-82da-b6cf-76e0-55b4f2597f8b@kernel.dk>
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

On 1/22/23 8:06 AM, Jens Axboe wrote:
> On 1/22/23 7:46 AM, Greg Kroah-Hartman wrote:
>> On Sat, Jan 21, 2023 at 10:52:10AM -0700, Jens Axboe wrote:
>>> Hi,
>>>
>>> Two parts here:
>>>
>>> 1) The wakeup fix that went into 5.10-stable, but hadn't been done for
>>>    5.15-stable yet. It was the last 3 patches in the 5.10-stable backport
>>>    for io_uring
>>>
>>> 2) Other patches that were marked for stable or should go to stable, but
>>>    initially failed.
>>>
>>> This gets us to basically parity on the regression test front for 5.15,
>>> and have all been runtime tested.
>>>
>>> Please queue up for the next 5.15-stable, thanks!
>>
>> Note, some of the io_uring patches you sent for 5.10 and 5.15 have
>> commits in the tree that are marked as "fixing" these commits.  I tried
>> to backport them as well, but got a lot of failures, which is why you
>> got those emails.  If they are not relevant, please feel free to ignore,
>> but if they are needed, maybe we also need them as well?
> 
> I'll go over those failures and send any in that are needed.

Sent the patches to you/Sasha/stable, thanks!

-- 
Jens Axboe


