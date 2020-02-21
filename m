Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F15C168262
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 16:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728130AbgBUPzJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 10:55:09 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45609 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728235AbgBUPzJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Feb 2020 10:55:09 -0500
Received: by mail-pf1-f195.google.com with SMTP id 2so1406604pfg.12;
        Fri, 21 Feb 2020 07:55:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ekbFi1JrdrBaSIhbrYWsoTR1L3NmdFrPXDaskjaSV08=;
        b=VvlOezARFA7ysub9DaAEuYzcPxhJBQLdj3BNgEEN1Yen96uESaJUh75EeYN2Z9DbWR
         cPJ9yGdG76nJJvR6am38eRDX2GzPxZiMBc4ylAyXFswvRtz/avOlwLFB995/ltdPIBlr
         LnVFvvHsvGR6N3dAxA8pYN0jUIxinKHEX/6yETYLF83v068SzNDwZ74dzxS8p2G6rgOa
         gC2zobt0cS6L3kpOmJlWTqW1dtueXMWCIh/0S6wTjHTPBp0PPLRXaYuplXRT7pAjLKpE
         NVCfnqUgjKJnu1vwglluoxgBHSXWySm4cVVcuBBh2BqSP78n1aSz5oJpr5aMeiJCjar5
         CXvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=ekbFi1JrdrBaSIhbrYWsoTR1L3NmdFrPXDaskjaSV08=;
        b=cCsU707z45DX57w3deW5PqsSxnfKqbcw0PHAKY4R4dMGgjycv7yawD8lF6omJFJ2WW
         Zte7oru0mm7v4YC6gQJC8vJekq52U22qAlNjHJ0uIC1c0E/tPcn0h0gWEPDYGmcGeQGj
         umgYgV+sSgLJtWMWUW/BlCqKjZyrFThAGosqQxZOSsM1r2X+yKybWBTxL4CXjRYc7/qY
         vPrg2Wk3Flht1D2a/195VYi1Qzlq747e6f5iJGvvaOj3dlrDFJpdgiMLwaE9iIHWdNhR
         I7hqWXgnAuHGrTXmQHASum2BpnZRL/IZLEBZPOIfDkGQETTiG+V+d44kcwkDb5oh8cr7
         yFAg==
X-Gm-Message-State: APjAAAXhLFMfuNDuMoK4PWVz5/TZbKB74xHLOCaKXUsz8gS0R2mcduCv
        NHSU39TOJ1FjXsnXsLspqZU=
X-Google-Smtp-Source: APXvYqynFCvB5OxdEfwsSIXpwGNYYVKgvQMIMhTYKtaNJtKpRVhqDuEoq80VRIyNGM+spNGzhyWptQ==
X-Received: by 2002:aa7:84c4:: with SMTP id x4mr37969255pfn.144.1582300508795;
        Fri, 21 Feb 2020 07:55:08 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m128sm3298688pfm.183.2020.02.21.07.55.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 21 Feb 2020 07:55:08 -0800 (PST)
Date:   Fri, 21 Feb 2020 07:55:07 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/344] 5.4.22-stable review
Message-ID: <20200221155507.GB11868@roeck-us.net>
References: <20200221072349.335551332@linuxfoundation.org>
 <4e8cb265-4745-4249-45e4-86bd84f068ed@roeck-us.net>
 <9f719752c33321fca7280a5cc59a886e1dd0dfda.camel@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f719752c33321fca7280a5cc59a886e1dd0dfda.camel@codethink.co.uk>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 21, 2020 at 03:21:30PM +0000, Ben Hutchings wrote:
> On Fri, 2020-02-21 at 06:28 -0800, Guenter Roeck wrote:
> [...]
> > Building powerpc:defconfig ... failed
> > Building powerpc:mpc83xx_defconfig ... failed
> > --------------
> > Error log:
> > drivers/rtc/rtc-ds1307.c:1570:21: error: variable 'regmap_config' has initializer but incomplete type
> > 
> > as well as various follow-up errors.
> >
> > The second problem affects both v5.4.y and v5.5.y.
> 
> This seems to be caused by commit 34719de919af (rtc-i2c-spi-avoid-
> inclusion-of-regmap-support-when-n.patch).  These branches will need
> commit 578c2b661e2b "rtc: Kconfig: select REGMAP_I2C when necessary" as
> well.
> 

Yes, I recall we had the same problem before, and the offending patch
was removed from the queue. Wonder how it made it back in without the
context patch (which either you or someone else also reported at the time).

Guenter
