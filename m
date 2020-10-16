Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDBC1290C00
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 21:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409040AbgJPTBA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 15:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409039AbgJPTBA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 15:01:00 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E31BC061755;
        Fri, 16 Oct 2020 12:01:00 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id q136so3568865oic.8;
        Fri, 16 Oct 2020 12:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2bfP3e95h5s+dLdGifmzTwJN3OHG21TUmxZcz4Gvs4E=;
        b=U+pEs7+ugCfe7V/iRTg3bQ+O53hiL95NTDKrO4KmA0RRjxpGkuWkbTWwiu5kMsMkcH
         TTNgRIDc4AV4OUlJoRGQ4bFxECeYoXUjyRMrYJG6KUgs4EmsduVSyy8LyQk0M0OxI25O
         bQO1AFNgRi13u9MIxJUdcUMMu4QyizHkTGr/F4hx4GHqLRVIZyWcvNv7Tgji+jSFfi4H
         s1JFdzsUMTOCCv9+7tFT6ZBuJ1FvzvPwrkRdQtGgKd94ELM+DeW5zCYuXTXfRgvYG2ic
         iFuNqRYWU8RVQcVCBd+sYBp6U87P2/gFltrR866GAy3YjjJBCRr7mq960o++ODMZLdfK
         SO8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=2bfP3e95h5s+dLdGifmzTwJN3OHG21TUmxZcz4Gvs4E=;
        b=tocTu+e9TYeYVT0bfzjTPGxHrcLj4BEFxwLWmcE53pCsoe7KY1XcGTasT64cuBU1J9
         2anGEjq9BkRr6hxzd6335OOqgESQLimm+a0VNsXRJJDr4ajQFTDV8wnHmR6u8VY5WCJR
         FK3HHv2tc377gVofG//wB1nQUD/G3ALMnnsu0wzrSjcwE2c61J0AW9BU/OEyOF2PRnIX
         h3RcYUuhQw/9AGrrqKd8y0+/Igu95T+Q7xdpWHb6T2uTwKCtRprsYKEQlWskirNhB56g
         z3r+u8nAg1muPAumLlATuoZonKfKiY+S0NkAy6NKFwTp2BouHxNYVEPTbfoJOXj7vKIn
         pHuA==
X-Gm-Message-State: AOAM530DY0KM0ZeNx+kYW7uPdB9DmEK6uPY+MQzxODc2R8wAY1yYgnck
        o+nnauZcpF3czSsUhJ+sccM=
X-Google-Smtp-Source: ABdhPJy7L8YF//adGFFC0q0gC47NFK8REdY6Mlqnl7BXDUc31tagQE5Od5/zYaWeQEbd13Qx0Gq0FA==
X-Received: by 2002:aca:5883:: with SMTP id m125mr3474308oib.21.1602874860108;
        Fri, 16 Oct 2020 12:01:00 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u140sm1241735oie.41.2020.10.16.12.00.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 16 Oct 2020 12:00:59 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 16 Oct 2020 12:00:58 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/16] 4.9.240-rc1 review
Message-ID: <20201016190058.GB32893@roeck-us.net>
References: <20201016090437.205626543@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201016090437.205626543@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 16, 2020 at 11:07:04AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.240 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Oct 2020 09:04:25 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 386 pass: 386 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
