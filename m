Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04E38169FE6
	for <lists+stable@lfdr.de>; Mon, 24 Feb 2020 09:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbgBXIXO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Feb 2020 03:23:14 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:37845 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbgBXIXO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Feb 2020 03:23:14 -0500
Received: by mail-lf1-f66.google.com with SMTP id b15so6176179lfc.4
        for <stable@vger.kernel.org>; Mon, 24 Feb 2020 00:23:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xAqGj83InS0ZYn9vUU4xBzv4JhEGkgeAXZzYgZeZCJw=;
        b=AhqgEvO5ctpKu55VCGeZjNC4uMaPDuRgUbzouCuTAzoFZr8R/LCl42VxzaWQJHp3fF
         icJmi8ymnQKsuPdX40I+RgD75GXb/hYQUKYu0F1otUfCZinaD05TrpkRnjm+Sd24koSx
         /Z2ONjHuh5nN4dxzkwU/U13DsornT3MqLp6O0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xAqGj83InS0ZYn9vUU4xBzv4JhEGkgeAXZzYgZeZCJw=;
        b=RwRkOyKWBlELN0GKacmo4b9evEM1DvpL4O12dDxSugCbsknPu/DC9T4o8XWmPrKrv6
         Ea+PA/LwQqpKEMQznoLYTGAx7zufVu+BDGUADFquStN4O+PhrBOPAzl2EYh+3k0j62X2
         TrPmrlcm8b3UVLKbqpdrRGck0gW13SRVinre4svX7EKP5PmQmq4XweQADdRsVGY8Ofkv
         /H63OxWBvfhfcb6PylAXb2Ykv5t5YkKfdmxEeo4OPDnxl+wxfZ73Ar2njQ8eNhPm4q7I
         4YdxvMtrhL5x01yK1TldwCWqUj9jJSOcEbP/7nYfIOsfBAPmi3JUNRD+8zFYOPe7kdFc
         pzyQ==
X-Gm-Message-State: APjAAAXKgGoMReXBaQiCqw1Ukpty6SZI5IRx60exGWN0MNabZW/Ll0kV
        cLUoEsSjOZKzzZ9OionStxYrAw==
X-Google-Smtp-Source: APXvYqwrB59mAnhR5gG9dNnSACHGvcqfdkoajx+ETsuhNpIDH0m1/6dTIMNuRjhczpGspRJWcXEyPg==
X-Received: by 2002:a19:4c86:: with SMTP id z128mr3757019lfa.100.1582532592324;
        Mon, 24 Feb 2020 00:23:12 -0800 (PST)
Received: from [172.16.11.50] ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id r12sm5740883ljh.105.2020.02.24.00.23.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 00:23:11 -0800 (PST)
Subject: Re: Patch "soc: fsl: qe: change return type of cpm_muram_alloc() to
 s32" has been added to the 5.5-stable tree
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable-commits@vger.kernel.org,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20200221012743.D5A0E208E4@mail.kernel.org>
 <89ccc850-54af-aaec-4a9e-330dcb814ca7@rasmusvillemoes.dk>
 <20200221134604.GL1734@sasha-vm>
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <a30cdd12-cf8f-3695-9509-cee33f7beb0d@rasmusvillemoes.dk>
Date:   Mon, 24 Feb 2020 09:23:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200221134604.GL1734@sasha-vm>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21/02/2020 14.46, Sasha Levin wrote:
> On Fri, Feb 21, 2020 at 09:53:04AM +0100, Rasmus Villemoes wrote:
>> On 21/02/2020 02.27, Sasha Levin wrote:
>>> This is a note to let you know that I've just added the patch titled
>>>
>>>     soc: fsl: qe: change return type of cpm_muram_alloc() to s32
>>>
>>> to the 5.5-stable tree which can be found at:
>>>    
>>> http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>>>
>>>
>>> The filename of the patch is:
>>>      soc-fsl-qe-change-return-type-of-cpm_muram_alloc-to-.patch
>>> and it can be found in the queue-5.5 subdirectory.
>>>
>>> If you, or anyone else, feels it should not be added to the stable tree,
>>> please let <stable@vger.kernel.org> know about it.
>>
>> Isn't that what I did when I replied to the AUTOSEL mail a week ago?
>>
>> https://lore.kernel.org/stable/a920b57f-ad9e-5c25-3981-0462febd952a@rasmusvillemoes.dk/
>>
>>
>> The TL;DR is the last part of the middle paragraph "... I think they
>> should not be added to any -stable kernel."
> 
> You did and I've missed your mail, sorry. I'll drop it now.

Uargh, I should have been more explicit and not provided a TL;DR.

Note the word 'they' (and I should also have caught the word "it"). My
original detailed mail concerned both "soc: fsl: qe: change return type
of cpm_muram_alloc() to s32" (which indeed got dropped) _and_
"net/wan/fsl_ucc_hdlc: reject muram offsets above 64K" which is now in
-stable :-(

I've re-read the code in fsl_ucc_hdlc.c, and I think we're lucky that it
will work even despite being taken without all its predecessors
(800cd6fb76f0 and on), so no need to revert it from -stable. But sigh.

Rasmus
