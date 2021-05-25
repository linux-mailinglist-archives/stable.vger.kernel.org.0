Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0D7F390B65
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 23:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbhEYV1v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 17:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbhEYV1u (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 May 2021 17:27:50 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B5CC061574;
        Tue, 25 May 2021 14:26:20 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id c196so23456389oib.9;
        Tue, 25 May 2021 14:26:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZwyB3oZbhncUoNjyEs4lI85OWB+hNWYX7AbTL0E94io=;
        b=kNSQQ2XjstrNvX4Z4NKce3HUYaK00M+legpgKCuRA8g8mTZvsn88ujkcVOrJroRGW7
         HmWa53+BQvuofJA+2Egy8i91efjbWbXfanJ6yWuzXW4Nu8mGZHhQZYTNzrBR7kgVvB2d
         ydrl6L62r8ZbnQx+fhwd8QYPQ/a+ClTtwB3BuMkMnA23FU1zpySGFFDLY0bSz3YvV0dd
         uUspuzis48IhKhgSbdGRKUGreQCp0xrK50GvrGelP7XLSKJQSbcN1wHvLprnXRBZYH3P
         rA1uRXD5j0XChqjQtwyLQi+Lbgnz2jFcdwwBL0NtB2grHmovmfawe2twVv9tig2ZbNro
         sXHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=ZwyB3oZbhncUoNjyEs4lI85OWB+hNWYX7AbTL0E94io=;
        b=H00eg5XKBk6kFiVoPa+m9sjjzsMMyf8p2ICJtITxZljegnznk7G22qVI4EN61Y1Tzl
         NaRMgX6HXz0x1IOBjWIkjhIco9p1LQf5SChGr2chLbOMZAmg7JRkZWnmC/oQmB7cFkPn
         E7sJxvC01Rbz/7UZIfrFpD3udosB7MjpljssnjLYbtXaMzmey9S2F+hQWSOOJBl4N2GY
         Xdew/m8aPimkDC9RW0x7zUx3uTdzg3lP3SY3p+480jZjFuY/CWwMYFwpHXNRryLPvTg+
         dDQO2cC+gEl/dP5Ya1jC9p7LoFezv+oR838YrB2cS+Bo5V3HXL6R2Xp2VoHQTi+v2wya
         tU1g==
X-Gm-Message-State: AOAM530kt4EkssTCFA7VdlNBSe5MnGhrgKa2SNaNNTZQaXQ5/+XFrvUC
        5oTBQXdwvPwW7bT8dNfJN2U=
X-Google-Smtp-Source: ABdhPJwIFqFU5B1/iHIQO2/jjyT6qCTA0tf+wBAsLwsQ/KKxWpJqtIMg06c5jp2K3YojeOr5H+DBdw==
X-Received: by 2002:a54:4809:: with SMTP id j9mr249771oij.14.1621977979553;
        Tue, 25 May 2021 14:26:19 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i2sm3992126oto.66.2021.05.25.14.26.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 14:26:19 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 25 May 2021 14:26:17 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/71] 5.4.122-rc1 review
Message-ID: <20210525212617.GE921026@roeck-us.net>
References: <20210524152326.447759938@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210524152326.447759938@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 24, 2021 at 05:25:06PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.122 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 May 2021 15:23:11 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 428 pass: 427 fail: 1
Failed tests:
	riscv:virt:defconfig:net,usb-ohci:nvme:rootfs

The failure is persistent; it manifests itself in failure to reboot.
The test passes after applying commit e181811bd04d ("nvmet: use new
ana_log_size instead the old one").

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
