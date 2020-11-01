Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 575662A1B5F
	for <lists+stable@lfdr.de>; Sun,  1 Nov 2020 01:23:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726123AbgKAAX6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 20:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbgKAAX6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Oct 2020 20:23:58 -0400
Received: from mail-oo1-xc42.google.com (mail-oo1-xc42.google.com [IPv6:2607:f8b0:4864:20::c42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E17C0C0617A6
        for <stable@vger.kernel.org>; Sat, 31 Oct 2020 17:23:57 -0700 (PDT)
Received: by mail-oo1-xc42.google.com with SMTP id j12so2492111oou.6
        for <stable@vger.kernel.org>; Sat, 31 Oct 2020 17:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kvYr3I1y8+ehhIyg5Sv32VzMWe/yxI9bnjmJEWtO5UM=;
        b=qY8eWwh8jpi7rNFjftXpcMSotFc53mCQweSVjR2R4B2pKPVBRXNnlkVL6YeMDxe7Cc
         Baca0UAFlY9JHEzNFStSI0pYpEXRdaERmtrWbDRnbWRJvjGQH+65aRzsleNlp0kFPHSt
         xN1vh+BvcNSeYFDo2lNzjIndDdTwFELcePgUPpHibdjuZRELjp7eN00H6QqVsofMp9AS
         TypjpKw93Po4gjpkjfMqkbmHrIlVGPyVRlRqCXUe2LPY9I2tzRO9pW5d5QHdyJixqLH9
         QaNDHmAnt7xFPXBSfPUagZTzMAmgM8yKCt7Wl5A9KhvTb6Mke1LLWe31IAiAaJY4PBU1
         PbUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kvYr3I1y8+ehhIyg5Sv32VzMWe/yxI9bnjmJEWtO5UM=;
        b=BDxH1rISEXL7hxvOH0PSVhviHNlHIJ14WV0knNBMF/T9VbD6P5HwTMl0lGrO/vAO4P
         f9JhQe2yZq5k1PpkL8Bw3seKka6bP5ATxQ41FvOJQtPsqHrl+ajAutxGcN9NRaj/Ip0D
         e49Heucghl8J12+TeI/tHIWIISedjicluzGmguGHpEiGZxZixr3Uis5W4wHcg5lSFBW9
         55mdobj1ggZ53EL9dIPVIvZmd1vS6M6yUQW9jL2ALd5UTOXxRuTE6Bb5ro0Vjf9o+sDl
         nz/M+gnRQ1kH1bbrIwOlnGUJ2KOEce6vDU664LdDRgXdrT2KnyclIaaPGGchBuuEo6fq
         3kSA==
X-Gm-Message-State: AOAM530oEQrxYsV8QyjyuvD1Ub9hneruM2+lBvTwODVvu4XXoNYBnUrF
        7x3+Ttc4UB2Mf14+yCQYFGFc1Blj4Cc=
X-Google-Smtp-Source: ABdhPJw86vhXl1RC+mYDHEbjziK75gCERyVvS2mVIpaAXRIndSHugk4ONYfxGfVRcYNsZVCJGdFXoA==
X-Received: by 2002:a4a:ea81:: with SMTP id r1mr7216755ooh.16.1604190236078;
        Sat, 31 Oct 2020 17:23:56 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f34sm645624otb.34.2020.10.31.17.23.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Oct 2020 17:23:55 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: v4.9.241 build failures
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <d7a693e2-9f4d-afc4-c1e1-a1c04122f472@roeck-us.net>
 <20201101001414.GA2092@sasha-vm>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <7cad0337-8ed4-386a-2bb3-88092b758a0c@roeck-us.net>
Date:   Sat, 31 Oct 2020 17:23:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201101001414.GA2092@sasha-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/31/20 5:14 PM, Sasha Levin wrote:
> On Sat, Oct 31, 2020 at 07:35:58AM -0700, Guenter Roeck wrote:
>> Building powerpc:defconfig ... failed
>> Building powerpc:allmodconfig ... failed
>> --------------
>> Error log:
>> arch/powerpc/platforms/powernv/opal-dump.c: In function ‘process_dump’:
>> arch/powerpc/platforms/powernv/opal-dump.c:409:7: error: void value not ignored as it ought to be
>>  dump = create_dump_obj(dump_id, dump_size, dump_type);
>>
> 
> I see that Greg already took b29336c0e178 ("powerpc/powernv/opal-dump :
> Use IRQ_HANDLED instead of numbers in interrupt handler") for 4.9 and
> 4.4, which should fix this issue.
> 

Correct, it is fixed now. Sorry for the noise.

Guenter
