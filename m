Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD0DA1BC1
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 15:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727415AbfH2NpD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 09:45:03 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:46347 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727176AbfH2NpC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 09:45:02 -0400
Received: by mail-pg1-f179.google.com with SMTP id m3so1600996pgv.13
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 06:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3Pmr3jSeTiOsIoCI55GpaiNHd38T2sY1kmnokrRyxIg=;
        b=cCWFv7glVGcmBvwse8HkDsir9mdN7oQIHWmvCtZ/9pMjX20YgpQmyTGRMu67BG/9ve
         ofDTc58ji+VGpQfdtQEWb3N97cGRKMyrxKHQP96TtZ6d7cyHST2vH9vWKX/M/Tg1nAyO
         kaZpRUsdxo036L04/ZaHvYOPp8GADb9MpKwm3p72gVKkcMh+iOwxRucFXUAwiuJHCiaj
         BAMx0nsX3M8LyA+4QYsAygNNqS3JEkW+iSr5MAWLyHOSPR2PwVIKzjut2yVP+OOqZzJI
         Q1Aqmu+Y7EIiRcr0eNXAQF3ujQq5ue+B0ywHnuLqNSdC2Xkk4dYBrCuTnJpc5GNnNCNr
         gEnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3Pmr3jSeTiOsIoCI55GpaiNHd38T2sY1kmnokrRyxIg=;
        b=Lda6samaOUNvy85SoshsYYUI79+xGhuv+xmGSGwNdsGJ6K4Wf8m9n++yciIKo7i73E
         ga21PVrRoi0+oTplUmUdhioPqm7yxQDb9axfRyG39HF8091z8hOKwZ5x3IBDyKYYwBf2
         uG6GaPLJcUAX3Agd1NUiNvnqswdg5txSHVAsd3MRLINIPiOwtkIacTG1vtcmFLztmRel
         zmxSoQxKNQ5oHSE4ol6j18hZaTUaE9tFn1WRHNojKkP+nqbXf+ug07fwg/1CHJmRd6Vw
         6i3BKdvk3NMusDufm0bXSmDfcEb3HVhhlC4X/jCUVie7f7/bCNjxjRPP257qNHNuWMPw
         exZg==
X-Gm-Message-State: APjAAAUM/Efe3pS2POzSTR457HX6DIbthtvs7uuh9xBas4rDNLs0nLIx
        NGXgJ3ZGtUQvzXA6SpJSa6M=
X-Google-Smtp-Source: APXvYqxW1vqbZEtsiwpeFu9TyAoUwmdh+hZ1Pi6p5OYtrx999YfvHkAuZLlQ3wD1V6knTkiQq6sClw==
X-Received: by 2002:a63:e44b:: with SMTP id i11mr8136203pgk.297.1567086301975;
        Thu, 29 Aug 2019 06:45:01 -0700 (PDT)
Received: from server.roeck-us.net (108-223-40-66.lightspeed.sntcca.sbcglobal.net. [108.223.40.66])
        by smtp.gmail.com with ESMTPSA id l123sm3485180pfl.9.2019.08.29.06.45.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 06:45:00 -0700 (PDT)
Subject: Re: Patches potentially missing from stable releases
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20190827171621.GA30360@roeck-us.net>
 <20190827181003.GR5281@sasha-vm> <20190827200151.GA19618@roeck-us.net>
 <20190828122240.GC5281@sasha-vm> <20190829110009.GH5281@sasha-vm>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <b05b87c2-082d-6960-8513-ba3b623de842@roeck-us.net>
Date:   Thu, 29 Aug 2019 06:44:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190829110009.GH5281@sasha-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/29/19 4:00 AM, Sasha Levin wrote:
> On Wed, Aug 28, 2019 at 08:22:40AM -0400, Sasha Levin wrote:
>> On Tue, Aug 27, 2019 at 01:01:51PM -0700, Guenter Roeck wrote:
>>> make sense to start with looking at Fixes: ? After all, additional
>>> references (wich higher chance for false positives) can always be
>>> searched for later.
>>
>> Yes, let me send a branch out for review later today and we could
>> compare our results.
> 
> The AUTOSEL set I've just sent
> (https://lore.kernel.org/stable/20190829105009.2265-1-sashal@kernel.org/)
> is really a batch of these fixes for v4.19 and older.
> 

Excellent!

I am working on improving my script further, letting me tag fixes as nuisance.
This already turns out to be quite useful for my own use ...

Thanks,
Guenter
