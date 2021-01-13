Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDDC2F508C
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 18:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727727AbhAMRCZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 12:02:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727301AbhAMRCZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jan 2021 12:02:25 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90919C061575
        for <stable@vger.kernel.org>; Wed, 13 Jan 2021 09:01:44 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id w5so2866564wrm.11
        for <stable@vger.kernel.org>; Wed, 13 Jan 2021 09:01:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jwdEZBPTaxHDDiWO9iNlc9fY48FF9OS+VCcCP6d5/ag=;
        b=It+wH2xxv9hMi5vOBt1pZwYVDsoWE6p+hX8uQHQZezvS+jvZtw86n9au5dzw1UzGqH
         jKdvHJYPN07305jjrlGt5q2E8JpgahxPe1PMc8lTZUSvOZqeo8AVPS7D8ypsorX5HO5z
         hm6aENR2nxH+gBNQvp1WtEifAUN7KRTf/pU0FKXPiuQ+6m6GpCkyzg163s/lCIHFzqHV
         rL8X+szCr+gCdgbljXPkT+g9M4tUb5xrO1LBAYmzH4ZMaPmx+e0MzNB8p6vAmNJl8X1o
         YleKnisPqGHQhjMR46GhZNXPUA+qyuJ+7B/rgMWcAsnhX2yD2g/xgfsxCbC+bFbDmpBV
         qVAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=jwdEZBPTaxHDDiWO9iNlc9fY48FF9OS+VCcCP6d5/ag=;
        b=GZa2YMc48AM9vevn6gqVRvDlVaAwhnhA/war1SnWfZaxA789yFUUb0cXvhtpqUMt1H
         VWUcPJlfz7MZl0oNeqQ5uxLy5pdY2dzBI0CKIvAUmvvYOoY8InEHmwX04e6fvHzMnFsM
         /YbssKYRvOyTOjL04og1fA384k1CoQ/JeIxuAm5k9pi5G0WgnsHqh3GA14O29ro7Y3bL
         fet3LDBiPKIlCnd6FQUHOSmlBCY6c9xFAFzaJHBBl98MfRPeOj6Q4sKWAqOzMWpPqymS
         8CAg8q5iizz/fMYqgvgkihGJF44W9cHILk2JWdBj5xFdpWPtCfOtevIhs5RY0qRra528
         CoVg==
X-Gm-Message-State: AOAM530iBJx1gHVR4lDtMFS8DortTqEXT4iK+VXehj35aj38zLncfbJ/
        DL4m9xy+Nb87rv3OsHwo9Dc=
X-Google-Smtp-Source: ABdhPJzICRr5OFUxq4TWnXZzessM3Ssjby1m+G9DqrzcxW2NwBddwrTyQNwDGayDQ5YN26GbJbzYJw==
X-Received: by 2002:adf:dcc5:: with SMTP id x5mr3521363wrm.167.1610557303314;
        Wed, 13 Jan 2021 09:01:43 -0800 (PST)
Received: from [192.168.8.122] ([85.255.235.134])
        by smtp.gmail.com with ESMTPSA id w4sm3766026wmc.13.2021.01.13.09.01.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jan 2021 09:01:42 -0800 (PST)
To:     Sasha Levin <sashal@kernel.org>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
References: <cover.1610485688.git.asml.silence@gmail.com>
 <b965dc7a6bfb1adbe5b4bcd9a363a38d662a3195.1610485688.git.asml.silence@gmail.com>
 <20210113165440.GS4035784@sasha-vm>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 5.10-stable 1/3] io_uring: synchronise IOPOLL on
 task_submit fail
Message-ID: <4ee0bd5a-d9aa-850b-2493-65f921c43d56@gmail.com>
Date:   Wed, 13 Jan 2021 16:58:09 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20210113165440.GS4035784@sasha-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 13/01/2021 16:54, Sasha Levin wrote:
> On Tue, Jan 12, 2021 at 09:17:24PM +0000, Pavel Begunkov wrote:
>> commit 81b6d05ccad4f3d8a9dfb091fb46ad6978ee40e4 upstream
>>
>> io_req_task_submit() might be called for IOPOLL, do the fail path under
>> uring_lock to comply with IOPOLL synchronisation based solely on it.
> 
> Just curious, why did the stable tag disappear from this backport?

Probably I just didn't pay attention and erased while adding "upstream
commit" and so. Didn't know that it's better to leave it though.

> Otherwise, I've queued up the series, thanks!

Thanks!

-- 
Pavel Begunkov
