Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B24ED1D9DE9
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 19:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729219AbgESRbI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 13:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729197AbgESRbI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 May 2020 13:31:08 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1243AC08C5C0;
        Tue, 19 May 2020 10:31:08 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id l17so308256wrr.4;
        Tue, 19 May 2020 10:31:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kwsJJSPwIW1RER2lwybPrjIu+9cw8TmM1I6Izb8Qnaw=;
        b=dBhIFO6rkpy6660MNRUbiQSMw3OsR01yPDEYPqsNwYkENCVx2ZHgVf6EkFIqAWwIQT
         tFa+jJTO9sQZMi18OLiTJvCGEe8yDDAmK2seGHLjD5p23enXlhEG10XzswqepdHl++i0
         JjpgPvvrEHBzp0gtpVa0KqLBE8gc7x2X71RfCmBU5GYUyqSFVyafYI841v4nfLUDic7Z
         ZeCKqDog8yPJwR7sVVAPKcEimvUIudPMVftzP4N9dCQBkkiEc1Jw1ZWH6Tj+UbTCbMda
         lXxodAJLPuQ/gk9sz4iiSrlodCEux9EdBnn1hlJJTd6yI2YUQQjmbcxrkrm6VpVpU/5a
         3krg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kwsJJSPwIW1RER2lwybPrjIu+9cw8TmM1I6Izb8Qnaw=;
        b=Moc7873c48vHoyNen7YNVtVhVUNqS3aOOK5cXpPsigOlc83Lw8M1d8DMd1KcPbqomX
         06C9Zuqz99LQLqeA4KbPxanYTcWlly2z4/rlAT95R6uvxIKNHmRBus6TMHJr9agjHZbo
         Cg3L6c9KHvsLbtDqDqCRRJMQQhR+r3d5N+blDoj4WdJOm/bC92FeEk86ZQEI+5MV5wUd
         aCLCPX0I0bdUUtyH9pZRnQgVJ9jbjkP/L/lkn9kY9twIwtaIqwKktkKhHtONbnCsHOEU
         o1OyIqhTovBnI4A3NKSx13YUKH9wDK2KbyJKPac9f0eMaQcK4/VjZCflq+N7PXTuHGev
         QaBw==
X-Gm-Message-State: AOAM532iHe5xQ4DVNGJ2BggklDQAyPJT2JsgOXX8vhO/cupl421EQn1B
        3fxm6wb1aL7ixC57rh5+S6w=
X-Google-Smtp-Source: ABdhPJz4+NY5+8ioCpdwW4ZaMW+f3pW9y+pcWexTKP5iWLuCtP/HjhFZjq+mjF03TWuVGfY6nqTppQ==
X-Received: by 2002:adf:9d91:: with SMTP id p17mr25952400wre.119.1589909466755;
        Tue, 19 May 2020 10:31:06 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s11sm90421wrp.79.2020.05.19.10.31.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2020 10:31:05 -0700 (PDT)
Subject: Re: [PATCH 4.19 01/80] net: dsa: Do not make user port errors fatal
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
References: <20200518173450.097837707@linuxfoundation.org>
 <20200518173450.419156571@linuxfoundation.org> <20200519071707.GA2609@amd>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f11d7eba-17a4-28f9-0bb1-2fae1e0518a3@gmail.com>
Date:   Tue, 19 May 2020 10:31:04 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200519071707.GA2609@amd>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/19/2020 12:17 AM, Pavel Machek wrote:
> Hi!
> 
>> From: Florian Fainelli <f.fainelli@gmail.com>
>>
>> commit 86f8b1c01a0a537a73d2996615133be63cdf75db upstream.
>>
>> Prior to 1d27732f411d ("net: dsa: setup and teardown ports"), we would
>> not treat failures to set-up an user port as fatal, but after this
>> commit we would, which is a regression for some systems where interfaces
>> may be declared in the Device Tree, but the underlying hardware may not
>> be present (pluggable daughter cards for instance).
>>
> 
>> +++ b/net/dsa/dsa2.c
>> @@ -412,7 +412,7 @@ static int dsa_tree_setup_switches(struc
>>  
>>  		err = dsa_switch_setup(ds);
>>  		if (err)
>> -			return err;
>> +			continue;
> 
> The error code is discarded here, so user can now wonder "why does not
> my port work" with no indications in the logs... Should we do
> dev_info() here?

There are informational messages provided at various points where a
failure can happen and especially in the net/dsa/slave.c file where most
of the errors are. I do not think an additional is needed at all.
-- 
Florian
