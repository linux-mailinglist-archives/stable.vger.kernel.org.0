Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC56F9D92A
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 00:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbfHZWd0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 18:33:26 -0400
Received: from mail-pl1-f169.google.com ([209.85.214.169]:36296 "EHLO
        mail-pl1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbfHZWd0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Aug 2019 18:33:26 -0400
Received: by mail-pl1-f169.google.com with SMTP id f19so10729263plr.3
        for <stable@vger.kernel.org>; Mon, 26 Aug 2019 15:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8SBb9fx2JmKnKrQ5OBtNUHTjvWrdQMCpvHPF/G6Fmig=;
        b=DZS/4Zvm8/aN6UpLFfyWoUz3j6ykUB2xBMNVTyuacDyyQIT0QvhFeZ6ly+dBryL6FL
         kZbxYOdMW/gGayzpk4VilfDUijWIQn8xTT6O8oBdNJSP28LuFjpQx9sjcD1VwppPdpt7
         gwItu/UGMj6InqyCnAVWct879Eo0C+ZWpyCnvwYZAfLPBT7DhRqda4V2F5tiwPmZ7R6U
         m/xbXfexvyoC9rEc/mdNorcpWXw7YHoPPfk4FL2sR+2mpt02vArSqQCfKUyTgJSbM/go
         SlKmU5iEvM+GO7CV8BGLJtyXKUR6Dp9lJk0Hf432uT3cqMAn69iHVLi40a4+6uh+R+/d
         N2Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8SBb9fx2JmKnKrQ5OBtNUHTjvWrdQMCpvHPF/G6Fmig=;
        b=B+fgSnZOLn/6zbKb69nZ/Ik2uupXf4HDpqGtwvNpB4mdHWnphP97aOS8WVMBt09rh5
         QleIP+jc3TH249sE4u+6St/5Yqkjsytq4iGqX28lF3bgHU5+wviiz0VMEdKC4eTizdvV
         Bla03mp+b2Pu+kiMBUGChhiohrSALPu5E8oQkCxL6JvS+UKbBTdc8m4KB+dJHVi6NkmT
         JgQYXV0QhbjirKHxD6jQIFyV6/hHrA/PEcrFxSbt2MM+QF+/BvkYJlWvgwEGEuU/Ou+m
         5c1wkBIuxSpXkeMh0axCb6Q9Wur7lbcXuH1yxtvTn6ffRkUbXqhnSSifhpS1b9TWqwZw
         MAeg==
X-Gm-Message-State: APjAAAVDUZU59BWseJ+ESMLmNPjnXZg++c3V8jHa6t1tJus7oZi7Z9T7
        zbpYMP2yLFJqzndDEHXDpeRCf3jlIUicfg==
X-Google-Smtp-Source: APXvYqx896SP/z3bzIUSI/TT4PV7U1O0yaerDR4dlasqCRuXol+gNelivuZMFyoCGxwlH0N56zS90A==
X-Received: by 2002:a17:902:b718:: with SMTP id d24mr8103387pls.204.1566858805008;
        Mon, 26 Aug 2019 15:33:25 -0700 (PDT)
Received: from [192.168.1.188] (66.29.164.166.static.utbb.net. [66.29.164.166])
        by smtp.gmail.com with ESMTPSA id z4sm10709708pgp.80.2019.08.26.15.33.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Aug 2019 15:33:24 -0700 (PDT)
Subject: Re: fs/io_uring.c stable additions
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
References: <06ff6a5e-ecaa-ce53-5db0-6ff6e128c119@kernel.dk>
 <20190826214132.GM5281@sasha-vm>
 <b7419a63-cf1a-7618-0c77-c065aeb0c81e@kernel.dk>
 <20190826223246.GN5281@sasha-vm>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <47cfce53-480b-f688-e074-20bcb9d708dd@kernel.dk>
Date:   Mon, 26 Aug 2019 16:33:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190826223246.GN5281@sasha-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/26/19 4:32 PM, Sasha Levin wrote:
> On Mon, Aug 26, 2019 at 03:56:27PM -0600, Jens Axboe wrote:
>> On 8/26/19 3:41 PM, Sasha Levin wrote:
>>> On Mon, Aug 26, 2019 at 02:39:28PM -0600, Jens Axboe wrote:
>>>> 500f9fbadef86466a435726192f4ca4df7d94236
>>>> a3a0e43fd77013819e4b6f55e37e0efe8e35d805
>>>> 08f5439f1df25a6cf6cf4c72cf6c13025599ce67
>>>
>>> These 3 look okay, but I haven't queued them up as you were explicit
>>> with ordering instructions, and as I can't take the first one I'm
>>> playing it safe.
>>
>> Thanks for checking, just these three is what we need for 5.2.
> 
> Queued up for 5.2, thanks!

Thanks!

-- 
Jens Axboe

