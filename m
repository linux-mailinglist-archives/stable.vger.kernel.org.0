Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD0943CD59C
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 15:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237160AbhGSMf5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 08:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237111AbhGSMf5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 08:35:57 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25F4AC061574
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 05:36:54 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id u8-20020a7bcb080000b02901e44e9caa2aso10483772wmj.4
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 06:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZiroQn6QiWdPLyhoJtyIyqZTTN56blVdeogfk3QJX8M=;
        b=eXX4KdugNywIot7Dls558pifE7JhAQpZGib41eDIC0LDu0+DbdlLXaI/4h+KtK5Hbe
         1OjMQbeRz4emLNAqgPRQg/Hl/QiMoWm4WKH2HZEjjb0EpIkoUP+GrlNc76lFDDn1PfaB
         Vx4i8GhmIrzJmtsy7GEhHv79T4F/Ye7tfVFT6VdqmPG1uxlyFVTBROMV5ql5EfL6hITw
         Dp/x5DhZLYeNwob2kxLEZY2+mlM3YijZBd80o12FsqPlaxF729F4Gtq1HgT3thAbvopA
         LgWcKb6olrZcQxUoyM2YSy0xir9KZq2rFYvEV2s+cBeftsw7+QOgVhyiK4QQGqcNpwSW
         bDOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZiroQn6QiWdPLyhoJtyIyqZTTN56blVdeogfk3QJX8M=;
        b=pyMWkfu6MQDPDr70lpdmwtKf/U5SHJ4Ug24ASdCEN7gB7lMxPAVI84BUbXk+Jadvhh
         xM6VO5ibatuvAiu1ufOKmA2TmUUVXBGak0oAkRgp/m4AeA+DPRWCoKpYZxivUu8lg8xh
         3OQx2Oz2y1w+k224gv2ttrfVPWtV4BT8cTTkfE4/Y2DCFy5QkLlB1F9mlghP1zIdDULN
         G+TvOxsFbj9hd3yZO1hUZWhacmN5BHtDW5dqad4mGq8Wf5XzarynJAVVuwzRH/+VgQcx
         eew8asula6Avrg2nCyNs097aQPQmy1CVZXkKFfE42M/aRa5kPMOjB9V/GeD42zTRyXu3
         CfvQ==
X-Gm-Message-State: AOAM532e2M/HG/5suK8AvcmwSEHg7hmiBcHuZZPed4Av/uyxUGLR9DHF
        lF9DBqzXenxIqpmEicEmXRQ=
X-Google-Smtp-Source: ABdhPJzlluXg5pWQLJ1WzRHkFQsK6tYHlYJYMxTInXwC/hfkqn10aH7cmTnZM0TpWQA6VN15Q2alBQ==
X-Received: by 2002:a05:600c:4285:: with SMTP id v5mr12613511wmc.189.1626700594102;
        Mon, 19 Jul 2021 06:16:34 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.204])
        by smtp.gmail.com with ESMTPSA id p9sm19503209wrx.59.2021.07.19.06.16.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jul 2021 06:16:33 -0700 (PDT)
Subject: Re: [PATCH 0/2] stable-5.12 backport fixes
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
References: <cover.1626651114.git.asml.silence@gmail.com>
 <YPV2pX0pmsOrW337@kroah.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <d8762b17-d13b-8abe-d35d-ff0164383c34@gmail.com>
Date:   Mon, 19 Jul 2021 14:16:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YPV2pX0pmsOrW337@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/19/21 1:57 PM, Greg KH wrote:
> On Mon, Jul 19, 2021 at 12:54:21AM +0100, Pavel Begunkov wrote:
>> a298232ee6b9a1 ("io_uring: fix link timeout refs") was backported,
>> however the second chunk of it got discarded, which breaks io_uring.
>> It depends on another patch, so backport it first (patch 1/2) and
>> then apply a298232ee6b9a1 again (patch 2/2).
>>
>> It's a bit messy, the patch will be in the tree twice. Let me
>> know if there is a better way.
>>
>> Pavel Begunkov (2):
>>   io_uring: put link timeout req consistently
>>   io_uring: fix link timeout refs
>>
>>  fs/io_uring.c | 9 ++-------
>>  1 file changed, 2 insertions(+), 7 deletions(-)
> 
> Not a problem, thanks for these.  This is going to be the last 5.12.y
> release, so it shouldn't be that confusing.

Perfect, thanks Greg

-- 
Pavel Begunkov
