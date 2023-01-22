Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB454676B0D
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 05:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbjAVEeu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Jan 2023 23:34:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbjAVEet (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Jan 2023 23:34:49 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D874F21958
        for <stable@vger.kernel.org>; Sat, 21 Jan 2023 20:34:45 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id 5so3307472plo.3
        for <stable@vger.kernel.org>; Sat, 21 Jan 2023 20:34:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fn4jIX1TlGXVUPlwwB43Qnd9wRdykXZuYVuNLyOTJe4=;
        b=YJ/7a7cCx60UKg/Xp1ZxZ1EgBe6IEzInIvkMq7el/O69DnGi03rWYQ4wI5eDYBmuf2
         lDeHYxoDc6HkeMx2ZCVoq8pLi1af0agyc4HbsfXn6Rs8sEcR+H0ER6jJG6Cv9ovgsq8l
         7ADvTsEGS+6u/inLvR3uiuXVh7woRxQx8/puDcKc2PGLO3TEOwypfy6ECYDpdyNyDHk9
         EteKPPqgdwx7vK7TykMqATlrD5KSAhZEmArucLveCFL42RwBFFGdyO5B1plHCB4rHHMh
         b+6EuUIdJuwKzDL7UJuPdxpiIjhULGnn7eORK6DbD3EOeIn0RntlHisAu90eRWqNDFVg
         RKNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fn4jIX1TlGXVUPlwwB43Qnd9wRdykXZuYVuNLyOTJe4=;
        b=VO3vFF86A51lxSFazQP4uNbK2QzpK03Zc1q2Zl7fXniCaIP/gAYuFAgtMhGZqmGwwi
         ptejYCjC4iiIW+MbfbAE4VpZRYXQJ+mTET/I7mGzKq+32mB7qF+jsojEJYsJg2q7m5bc
         AhICuMo6YeeeqYEU6unY5wekaIbpgpAXeSDKgqJKCIu/MifO3zJ4v1OWxCvcMZiRxpvr
         Tckf10nT7jpbSqoyDvRG/Tz2LFjAx0x9ve67vQwZchKDAAqpmUG797U1YkbTUoZCsZAZ
         /JjynplaK2cUbW8RFWizphAZjQpSHEDplJ7BBkfRcOrB8zJ/kpOgfEXV2fDznAmxad9D
         FPOQ==
X-Gm-Message-State: AFqh2kqyt/dKEGq/+6gC3CXjEWFPF3mcaSoi5Zqc3zeUEyhRi7oiTO/2
        CBp5sMzmOEOA2TOGtnQUjEg4PuTOjgF+ukO3
X-Google-Smtp-Source: AMrXdXt2IxOQ7rQfcIM+eHqPkwHPAoYeVXjfqJGKywz6VMjtcWFHNkZLj0ALjS2mB9tIQU5/5XTrHg==
X-Received: by 2002:a05:6a20:5492:b0:b7:9612:cd31 with SMTP id i18-20020a056a20549200b000b79612cd31mr5726107pzk.0.1674362085187;
        Sat, 21 Jan 2023 20:34:45 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id v3-20020a626103000000b0058ddd699b8asm8634256pfb.130.2023.01.21.20.34.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Jan 2023 20:34:44 -0800 (PST)
Message-ID: <de363501-e6c4-e01a-692f-c4207f886f0b@kernel.dk>
Date:   Sat, 21 Jan 2023 21:34:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: Patches for 5.15-stable
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
References: <be4f98fe-2e66-f7df-5f59-acc2ed7cccdb@kernel.dk>
 <Y8y7fMAmJtB1559f@sashalap>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Y8y7fMAmJtB1559f@sashalap>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/21/23 9:28 PM, Sasha Levin wrote:
> On Sat, Jan 21, 2023 at 10:52:10AM -0700, Jens Axboe wrote:
>> Hi,
>>
>> Two parts here:
>>
>> 1) The wakeup fix that went into 5.10-stable, but hadn't been done for
>>   5.15-stable yet. It was the last 3 patches in the 5.10-stable backport
>>   for io_uring
>>
>> 2) Other patches that were marked for stable or should go to stable, but
>>   initially failed.
>>
>> This gets us to basically parity on the regression test front for 5.15,
>> and have all been runtime tested.
>>
>> Please queue up for the next 5.15-stable, thanks!
> 
> I've queued up this and the other backports you've sent today, thanks!

Awesome, thanks Sasha!

-- 
Jens Axboe


