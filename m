Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A44E676E0D
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:06:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbjAVPGg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:06:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbjAVPGf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:06:35 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E7C113E8
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:06:33 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id g205so7100776pfb.6
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:06:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=50Zw557ZkGl2T68ldddQfT375g5Knv+0pv4OdQtdnWE=;
        b=jBp0bdz2JfKBDzbwN4iYpKiv7LbdhMo6VSkIK89Ii7lNHv2YJ7pLuHOG8Hofxmf+QW
         ti5lynjTqaYXU97dI3fYvOGU36GDi9Rzv+YHydwEG3OpYwD3tOZzDh+xsykTjGNbggRt
         3bPk/dMIfi6Q9YuPYlBhz89WVvamZZ1mSOr6RaHXYx6BL6/vaIlV2js0ULa3UxV0SQAN
         vEGEg3AGsCiUGkieVjANF8yHcFIs7/IhLYocmSlU+d5WiF69qHbEheizKxzr2XUDuQjE
         LM13D1AKIVrFyn8IvheU+O9b3qOeH9Nwg20KYiGQQdueTz2Skzywa4978Z1ZNZVSs9pV
         FR/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=50Zw557ZkGl2T68ldddQfT375g5Knv+0pv4OdQtdnWE=;
        b=2KyTCOXATmm+B1rBMs201NoWoeB4UdSSKwU1KnaCYtRYpolH+abmCbcOcmXSwfoFQZ
         11ENLT7XXjRhBL981ZTlrF3OS4jpOSVDbTOrYmnbriO2qt75VuakuT+wUj0wO7dJBR8n
         qbwIJOJMh8y/+KzxGb5yc02zxuNbZJZE2dGwamQeN2Hh/BPWJgmPyQFKeMlvwouK9BuN
         K1f70anRLp8udBdoGhX/qVuurjonY0LYgn4+8TemQZhyf63oEPesYdR8kn7kMSYCeYxr
         6iuz2SUDTiAxDTg8vDSf3s1Wt3HtcX1snlWGwcPIo4GWVvUtqhoLqlCvilnsAVlVkSXF
         VRXA==
X-Gm-Message-State: AFqh2kr0i7TCvdYxQ7DZ1OwsDYE7DkRLVBSuNadLAQ8o5hAr/gnmnSeC
        G9vl8A8YtkOm624YJRSoc5OHMVs9zzGlQvDv
X-Google-Smtp-Source: AMrXdXsPRAKkgdDtC2RuGj80JBnsirraGnh8yxdSSDt441nfbUwJEPJrUaSDeIzoUohxoTEvLcaEgQ==
X-Received: by 2002:a05:6a00:189a:b0:58d:e33b:d588 with SMTP id x26-20020a056a00189a00b0058de33bd588mr4248375pfh.2.1674399993271;
        Sun, 22 Jan 2023 07:06:33 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id z13-20020aa7990d000000b0058a313f4e4esm24004267pff.149.2023.01.22.07.06.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Jan 2023 07:06:32 -0800 (PST)
Message-ID: <eaf582d3-82da-b6cf-76e0-55b4f2597f8b@kernel.dk>
Date:   Sun, 22 Jan 2023 08:06:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: Patches for 5.15-stable
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>
References: <be4f98fe-2e66-f7df-5f59-acc2ed7cccdb@kernel.dk>
 <Y81MNeUGrntM0FKW@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Y81MNeUGrntM0FKW@kroah.com>
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

On 1/22/23 7:46 AM, Greg Kroah-Hartman wrote:
> On Sat, Jan 21, 2023 at 10:52:10AM -0700, Jens Axboe wrote:
>> Hi,
>>
>> Two parts here:
>>
>> 1) The wakeup fix that went into 5.10-stable, but hadn't been done for
>>    5.15-stable yet. It was the last 3 patches in the 5.10-stable backport
>>    for io_uring
>>
>> 2) Other patches that were marked for stable or should go to stable, but
>>    initially failed.
>>
>> This gets us to basically parity on the regression test front for 5.15,
>> and have all been runtime tested.
>>
>> Please queue up for the next 5.15-stable, thanks!
> 
> Note, some of the io_uring patches you sent for 5.10 and 5.15 have
> commits in the tree that are marked as "fixing" these commits.  I tried
> to backport them as well, but got a lot of failures, which is why you
> got those emails.  If they are not relevant, please feel free to ignore,
> but if they are needed, maybe we also need them as well?

I'll go over those failures and send any in that are needed.

-- 
Jens Axboe


