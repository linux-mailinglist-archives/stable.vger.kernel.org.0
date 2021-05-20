Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAD84389A5A
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 02:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbhETAQD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 20:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbhETAQC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 May 2021 20:16:02 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C971C061574;
        Wed, 19 May 2021 17:14:40 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id x8so15745182wrq.9;
        Wed, 19 May 2021 17:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2eR8QYJhsv+JHie8c9LG+Hd2DO/6eGdicO+iuYTXcdA=;
        b=RNLuOm/JCXC2BFTP42mTHqUngG18FZLj+u1jiQ2uk4qoRR+w2QMsr+TOWYkNIEMtwj
         kvryt6SNfJyv15XUaj/7up6uaYDv74b0ocUTWxax61qUdbLz6IrxP0DXDyWO/jDJJWz7
         VwiHbI2Y0Lf+4jGIzBbiPalqvSzosdwFZBDzIvhQoEJ0kXb4ehZUCnq3DEmEWNKIAJZA
         x9M2C9WwTPFqR/oAsmTIsx5nsWkfo/tZ5AtHMuCCWxUDOflvFTITsJFJzLWdquqIZbKL
         mS8zZ0+rVGbTUlch/4cbtzQwoF78csbqXNvJ4xpbId0tykIz34ok4dnXeKO16TandpXr
         gjwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2eR8QYJhsv+JHie8c9LG+Hd2DO/6eGdicO+iuYTXcdA=;
        b=f211x3soJQ7W0wMv8YgcKMAAycg2KPRYSS+vJyNRROcPdVeSpPCdlv7gvqryp9nysN
         oGfG/AdL+1f6i/x/+rftXfQJQz+B2BNsMJDUdpFJCyduDBQlYsMZ+w+R2SJgbqHCNHMT
         2ny4awgMi4hdLAx3FvE4T8XsQf66jhXM5JLxQKUCY3ynaJD4QIHvrGmf/XPp99kTAN44
         Nn7zsc5lKpXqvtREJsdtUQA2M9NtJPQv5LNr4cu6N/4tE4WhSdcY6v9ATbpop8YAjTSQ
         2z1ghFSG76XB0wsIw9sqSP2ioGz6fzsjAsCCp5BmqjrIuTc+sSvjC1/dA31ieQyd9Gfk
         sbOg==
X-Gm-Message-State: AOAM5315dy6/XM/HvuPCva3U/P2wtmF8prGnnW3WX/g6KbWl1kXTDZBs
        Z9NGrlfLcl1fJ4ftHbcDUEA=
X-Google-Smtp-Source: ABdhPJzQKV9STS+dr7n2vX0gwJ9KXMyQK52wVEnx2tm9zkjT4V0x9ZWz6owRm54YAM9BVzw7TE3q2A==
X-Received: by 2002:adf:e0c6:: with SMTP id m6mr1479940wri.66.1621469679173;
        Wed, 19 May 2021 17:14:39 -0700 (PDT)
Received: from [192.168.2.120] (pd9e5a1b9.dip0.t-ipconnect.de. [217.229.161.185])
        by smtp.gmail.com with ESMTPSA id c12sm1106078wrr.90.2021.05.19.17.14.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 May 2021 17:14:37 -0700 (PDT)
Subject: Re: [PATCH] pinctrl/amd: Add device HID for new AMD GPIO controller
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Sachi King <nakato@nakato.io>
References: <20210512210316.1982416-1-luzmaximilian@gmail.com>
 <CACRpkdZpm4w6Ym2p9xTsYpkU7CR531aLUUxXj54tssoqd6c9=Q@mail.gmail.com>
From:   Maximilian Luz <luzmaximilian@gmail.com>
Message-ID: <582afe8b-76c0-7c72-bb08-5e3cca70d1a6@gmail.com>
Date:   Thu, 20 May 2021 02:14:34 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CACRpkdZpm4w6Ym2p9xTsYpkU7CR531aLUUxXj54tssoqd6c9=Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 20/05/2021 01:50, Linus Walleij wrote:
> On Wed, May 12, 2021 at 11:03 PM Maximilian Luz <luzmaximilian@gmail.com> wrote:
> 
>> Add device HID AMDI0031 to the AMD GPIO controller driver match table.
>> This controller can be found on Microsoft Surface Laptop 4 devices and
>> seems similar enough that we can just copy the existing AMDI0030 entry.
>>
>> Cc: <stable@vger.kernel.org> # 5.10+
> 
> Why? It's hardly a regression?

Because that ID is already in use on the Surface Laptop 4 and
potentially other AMD-based laptops that are already available for
purchase. Not having it in stable means that people may have to deal
with some things not working (as this may prevent other drivers relying
on GPIOs from working) until 5.14 is available on their distribution of
choice.

Given the size of this change, I hardly think that's necessary. Which
is, I believe, also why the stable-kernel-rules doc points out that new
device IDs are (generally) allowed.

Regards,
Max
