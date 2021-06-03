Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABD43399C7E
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 10:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbhFCI1D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 04:27:03 -0400
Received: from mail-wm1-f54.google.com ([209.85.128.54]:46936 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbhFCI1C (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Jun 2021 04:27:02 -0400
Received: by mail-wm1-f54.google.com with SMTP id h12-20020a05600c350cb029019fae7a26cdso3131801wmq.5;
        Thu, 03 Jun 2021 01:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yQJDvB1JFxS3yFsv4pf320LfhcVG0zOssVYg3NzlqgA=;
        b=I/x7z7LAYRzWcblM2yCrnLmR3zEnGlDFv1W+OyYKnbCyzq1wwJ+JsINK9dwzpDIdG9
         rY0P/d8DPOoEHLehu14IFuISeVQO2VQNNM95+QCrmNkf1JkkSxqMWPiPj4bl7s5XEcvA
         bvqNjEOdeTUDD2FMaioDngX4YJg0O11UojgRNj0RAxxNTg2yW/L/B8tsiO6dhhrSKI82
         k+mYbVJb/MSNS0eOvvwdXxLrNhivMb2KsnzO5dH5Meaa/zqEriy/y8qekB5IY5exP+21
         Vy7q4K0zZcG7kKTahI971Y3y6Y44CIbeyklmssqYr+bbGxFcHbBGcE//x1RjOs9D/kMx
         e0vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yQJDvB1JFxS3yFsv4pf320LfhcVG0zOssVYg3NzlqgA=;
        b=KgSsKbj3WIR6j8VX9/nQtO1vnR7g98oiehEGZKL4P2sJ1hcHyBrYCFRsXwbBqMyp5/
         yiWH80xBOJGDMQkq8Du6hu5Nbw79j8LZSyyBj9YSO+b0yRF8qCFdOxQUX3148j/rW3VX
         2V9DZT81lpT7xamdHL+4HJ0D1m49rLAOM5ug+hshI4mv2W2zAyGPMtsLORTSOtucYCcE
         ZA3n+O2ZpmUca2sr3lyOTS5FtjF5LT+fltbvY+0frf41G1Ne4CzMXwWyijxBF1FAvo3J
         mHCe3pkWkTsigdZkQRJsE74EvQy+R7ImCRSzoL9FePrM62yzztLojo3Pn48mRV6+MQ07
         VX6g==
X-Gm-Message-State: AOAM531i6Gt8WfNk2v5RFCri/1Q2ZzTufduy7whAr8HyFd/i+ek/KR+V
        Sy+IaNCdVyYcgaifD2OrplktKnSpRj/Fz4uV
X-Google-Smtp-Source: ABdhPJx+No2weO8B6eK3SX2zlMD4Lpms4aV5V7wmjUQ0F8hlpbg2PnkZwy5HQ68GvUnHmHX0G/0e5g==
X-Received: by 2002:a05:600c:4a29:: with SMTP id c41mr22632772wmp.17.1622708646498;
        Thu, 03 Jun 2021 01:24:06 -0700 (PDT)
Received: from [192.168.178.196] ([171.33.179.232])
        by smtp.gmail.com with ESMTPSA id 6sm2028921wmg.17.2021.06.03.01.24.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jun 2021 01:24:06 -0700 (PDT)
Subject: Re: Backporting fix for #199981 to 4.19.y?
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <c75fcd12-e661-bc03-e077-077799ef1c44@gmail.com>
 <YLiNrCFFGEmltssD@kroah.com>
From:   =?UTF-8?Q?Lauren=c8=9biu_P=c4=83ncescu?= <lpancescu@gmail.com>
Message-ID: <5399984e-0860-170e-377e-1f4bf3ccb3a0@gmail.com>
Date:   Thu, 3 Jun 2021 10:24:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <YLiNrCFFGEmltssD@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/3/21 10:07 AM, Greg KH wrote:
> On Thu, Jun 03, 2021 at 09:53:46AM +0200, Laurențiu Păncescu wrote:
>> Hi there,
>>
>> I'm running Debian Buster on an old Asus EeePC and I see the battery always
>> at 100% when unplugged, with an estimated battery life of 4200 hours, no
>> matter how long I've been using it without AC power.
>>
>> I suspect this might be bug #201351, marked as duplicate of #199981 and
>> fixed in 5.0-rc1. Would you please consider backporting it to the 4.19 LTS
>> kernel?
> 
> What specific commit in Linus's tree is this so we know what to
> backport?

Hi Greg,

I think it's commit b1c0330823fe842dbb34641f1410f0afa51c29d3.

Many thanks,
Laurențiu


https://github.com/torvalds/linux/commit/b1c0330823fe842dbb34641f1410f0afa51c29d3
