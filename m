Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB6DC29D3FF
	for <lists+stable@lfdr.de>; Wed, 28 Oct 2020 22:48:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725956AbgJ1VmM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 17:42:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbgJ1VmJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Oct 2020 17:42:09 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C37C2C0613CF;
        Wed, 28 Oct 2020 14:42:09 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id s21so1157035oij.0;
        Wed, 28 Oct 2020 14:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=y19XOp+V2H74chD5CDt3cr1N3Z14O1UThzJ9Q1EX/50=;
        b=AFsKWBTyuRiq4o2Z1aheyaP83UkcUTE8hlCi4d/APSfctXl2jmsQeYS7sV58l1g0f3
         IWW/7qQ+DxTOHIu9cOScfG5R+t0UFE6qXsRJZNd5bQVPDWt/Y3lILVbDLT/vQxHEOTIV
         cRuqpfe7x/XKTDnEEUyzGbjUlTpNYWBlxUgRXb+slyQ/O81WVcxuXduFDS20MPEcmS7+
         xKNl9M3MbjoayaFaLQ2+ohK9Hn9LrG9tr0giTvBW94mkSFo3v91bxoXiI+fucLPTqEBe
         h4Tf707sQfcSmsz0JKiz1PYZzx2sjiY0s5yBEL5xQxNFFILnnhgZP6Ela757u4Py0GOU
         vCkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=y19XOp+V2H74chD5CDt3cr1N3Z14O1UThzJ9Q1EX/50=;
        b=VbbHNAf+Sb+s0OCRra1wTc3Qgf36NBXI/HK3JmTz1Z4QFCSyo79bvNESTZKmd/HP3f
         nRsur2vgJ7OFMCKhGVJQgzar+VdwD68qaazBpXSBz/2c43+TgitddZZGcVQbPGEXv1Ui
         fB+GjUv705Ijv6BLCcPf56q+ng/8KU7hoOz4gk3qSf9vGF7MI/QQi8l0pIRM6ux/wqtK
         G0PtZnZiQpJiVZWazExJf8gFaZ9Y5M4BCUKYJxd6A7FTrnYlHSHhnX/nqqbl9VheoO8Q
         XSFMIvVqFmkKBRGNVUfblJZ5Bq3CmaMOcPGdvVbnTjr+bpzp58FzJ05nCb+R53hGeJpO
         mMJw==
X-Gm-Message-State: AOAM533sq1la6mBV+pskwivAtRdwkUFcGp9F4ZDoNS0dA/nuNauKBtRn
        /sd18W+H8Fmm6tx8loGucXWqYoB8Fbs=
X-Google-Smtp-Source: ABdhPJwfrjyMcW1svTXocxnCUJjB1ORoKCEE56831Px0WisDVU2d3GYySGGRM7IawajExBjwugiV7w==
X-Received: by 2002:aca:5d07:: with SMTP id r7mr441653oib.87.1603914971738;
        Wed, 28 Oct 2020 12:56:11 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id e78sm119484ote.50.2020.10.28.12.56.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 28 Oct 2020 12:56:11 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 28 Oct 2020 12:56:10 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/191] 4.14.203-rc1 review
Message-ID: <20201028195610.GB124982@roeck-us.net>
References: <20201027134909.701581493@linuxfoundation.org>
 <20201028170853.GC118534@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201028170853.GC118534@roeck-us.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Retry.

On Wed, Oct 28, 2020 at 10:08:53AM -0700, Guenter Roeck wrote:
> On Tue, Oct 27, 2020 at 02:47:35PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.14.203 release.
> > There are 191 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 29 Oct 2020 13:48:36 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 168 pass: 166 fail: 2
> Failed builds:
> 	powerpc:defconfig
> 	powerpc:allmodconfig
> Qemu test results:
> 	total: 404 pass: 385 fail: 19
> Failed tests:
> 	<various powerpc64>
> 
> Error log:
> arch/powerpc/platforms/powernv/opal-dump.c: In function 'process_dump':
> arch/powerpc/platforms/powernv/opal-dump.c:409:7: error: void value not ignored as it ought to be
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>
> 
> Guenter
