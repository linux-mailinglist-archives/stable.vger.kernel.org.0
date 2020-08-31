Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BABB25824A
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 22:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728660AbgHaUJ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 16:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728579AbgHaUJY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Aug 2020 16:09:24 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E17ABC061573
        for <stable@vger.kernel.org>; Mon, 31 Aug 2020 13:09:23 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id t4so2306280iln.1
        for <stable@vger.kernel.org>; Mon, 31 Aug 2020 13:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vb/BBUFWHsZv9uqstxYOfKfYSWSk23LX2YLTD2X+bU0=;
        b=jfxZLEmcNpAcfpTUXsL7YDvI10CNX3Kjz4SCxFAiDEZSa6hztYMvP1kDyct7+GmV6c
         9EbHLBAZaatwsZXhpgToVg3Vv1SfHEldT25/3CSzjVYx272xJQ7r2AZ5IIoWjNAW/JnR
         BCiDScaiILUkD+1WzSzusvvoC1LFoy5FjwUpB8592HC08bJry6VBtRihhLjYWvRg8PFO
         mnMbd8DfvjQM1rG/2wyomGlwq7QfWV+QRl7Hv4M9RDLvWVzm0l4Gw5+OJ9guzKRHEsh6
         ipjZxooVym9/9PmPO4HlM8JThdHgsNJDH1Wut5VnjkPOJf8v9IgjnZsL1/JucpQpaVdy
         cgNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vb/BBUFWHsZv9uqstxYOfKfYSWSk23LX2YLTD2X+bU0=;
        b=Q8ycxgZyIuZ9qi54AEkdl8HiGqJl4XIedjpx8gGSix6gfYCBt6OvZyv1NtS7EYw2w+
         GyDhuPgO4Kk/MocaQEcNB8OfWQYjn97Tsbqaf159fTJLR8Zk7ERSsdM18dJMdpDjhz40
         coUxSo+lzH8K0xT0byHaLyuSrLirsjvb3Gj8wCzUkqiSqaQcfo8wbMX/0htUEAerZs9n
         CFHA4hypeEAkPXe+amA+kOKNa7LYd0W1kMaDTjMEiVnvYnea2srVlINg3Z7H2ryGY/5l
         LSjP4/cgNDZS3i6aN7XFn6YgqFCbqhQ1jI7yutTS120Y7wEn3NiLiiG+7ckMPT5iGOlz
         jGNQ==
X-Gm-Message-State: AOAM530NDmaMuweMF90iOsyE7z9OcgullhDknG20Coon0jh43gesZDTY
        phYo5RGtZOZidJAr1Hi0aMZAM6BowAY0r7tu
X-Google-Smtp-Source: ABdhPJz7UXrlhAApHj4zGQlj+qPceLTDZf2lK3kp9LdzjzRPlU8aJ0b7EuDFfNsQViHi+moyH1P/Uw==
X-Received: by 2002:a92:9f53:: with SMTP id u80mr2828129ili.42.1598904562953;
        Mon, 31 Aug 2020 13:09:22 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id k11sm4473603iof.40.2020.08.31.13.09.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2020 13:09:22 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] io_uring: don't recurse on
 tsk->sighand->siglock with" failed to apply to 5.8-stable tree
To:     Sasha Levin <sashal@kernel.org>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org
References: <1598867905173168@kroah.com>
 <c1700041-1d6d-030e-b249-7c67cc96ac0e@kernel.dk>
 <20200831200849.GD8670@sasha-vm>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0984424f-8627-36c8-b150-939140896dd8@kernel.dk>
Date:   Mon, 31 Aug 2020 14:09:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200831200849.GD8670@sasha-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/31/20 2:08 PM, Sasha Levin wrote:
> On Mon, Aug 31, 2020 at 07:45:49AM -0600, Jens Axboe wrote:
>> On 8/31/20 3:58 AM, gregkh@linuxfoundation.org wrote:
>>>
>>> The patch below does not apply to the 5.8-stable tree.
>>> If someone wants it applied there, or to any other stable or longterm
>>> tree, then please email the backport, including the original git commit
>>> id to <stable@vger.kernel.org>.
>>
>> Here's a backport:
> 
> I've queued up this and the other two backports. Thanks!

Great, thanks Sasha!

-- 
Jens Axboe

