Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93F33311E8C
	for <lists+stable@lfdr.de>; Sat,  6 Feb 2021 17:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbhBFQBx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Feb 2021 11:01:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbhBFQBw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Feb 2021 11:01:52 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCD85C06174A;
        Sat,  6 Feb 2021 08:01:12 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id h6so10965032oie.5;
        Sat, 06 Feb 2021 08:01:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1RQ7Irm5HCaNmQKeyWJU1IQZ3vvQLe5Ki0d+idQWzE4=;
        b=Ugi4zE2GUGZP9TiRL4dz1cWS759q/EbMWwaDc3sUdJw0ztTGCZNGsTygmxHsMEShGv
         YxTinGUZJhu7P08Pl8CMTVei8vzJ8U7i+GdDeCxi9VWjibmrZtECkp3n5fFBBjL9v83/
         JpCul62m5X0zA3gd88zqeW4gQZ1VBDqO1Hckc1ZDywmM8qCcIoYYjY5aaCW14kws7jME
         ceHeMfShspuecBcP1YH1PDYqA0wGmhQriNvnwX57OY3kbs8gHn2L/2nR7avYXR31vJGf
         pndJaxo2xxFQltzT4poA6N2CNGJIbWgHu/6uZv/epoZ5OJwmPVX3vAu1qPesFViLmULg
         A3rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=1RQ7Irm5HCaNmQKeyWJU1IQZ3vvQLe5Ki0d+idQWzE4=;
        b=JM4PXhFnRvqdUusPyq+Mrd2Xc7MLChUhgRD9WWD/hTmk2Xhnf1ysjk3ZOWzlHEwwaF
         x6rXD3XFdaYC7WHpjlPHId+hyWZq0tueORo6fJuDIqMdSZWYclHYcvTKFYXK0oV+hTHc
         o35X7+O8PFnX4AXrUqZW2EUNSsiYn9dTjw/rgeKxaDVJ2r3mVE1IcrJTXN28h2yxeD3l
         KJ/iQISE2ODuTAXn6ajn7zQU6V7/VquQN8UO977b9Aw6lAPQK3QvEdekcN52M+GeMn/2
         847dqrJWDNrNSAzDtdEwIv7bTcTTfOQrnRqzyGKBrgt58RlbKBdXGi67zNukQog3Ky3U
         cKYw==
X-Gm-Message-State: AOAM531bl4BVQl+KXIcEfG0HgviUQTRdQ18Ru59RBhfwuRsJ1rXRuplj
        yIkMSlKlQzp+Pww5Txm1/B1cWpCokwk=
X-Google-Smtp-Source: ABdhPJxBjeBaVnyAPsoIpvA5jHF/1I2g9XvVe7XgaTFG91zjuPW+NqS0kUJCnaB3SnyqA39ZLyZVWg==
X-Received: by 2002:aca:ac12:: with SMTP id v18mr6280637oie.14.1612627272091;
        Sat, 06 Feb 2021 08:01:12 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s26sm2545025otp.54.2021.02.06.08.01.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 06 Feb 2021 08:01:11 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 6 Feb 2021 08:01:09 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/15] 4.14.220-rc1 review
Message-ID: <20210206160109.GA175716@roeck-us.net>
References: <20210205140649.733510103@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210205140649.733510103@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 05, 2021 at 03:08:45PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.220 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 07 Feb 2021 14:06:42 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 404 pass: 404 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
