Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A81B463D07
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 18:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245004AbhK3Rph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 12:45:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245021AbhK3Rph (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 12:45:37 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD58FC061574;
        Tue, 30 Nov 2021 09:42:17 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id n17-20020a9d64d1000000b00579cf677301so31259137otl.8;
        Tue, 30 Nov 2021 09:42:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bh9MvVYSoRwniUuTCfSskdbcH0AOy3Z4iQ19KH1/zms=;
        b=oEuygPshytxMekhA/++Fw3dgXa0c9sJw7D/+8oDqMpUJE02ayfKzUCADWHJzoreI+J
         ghz7nqzuN4LSs6WdQimSk6DAHV6XKnh9d1DPnLTHvgikht0jkj89Kz5fZ8j9yqawgYTg
         VOojyuAc/E6CzwEh3AFFyZA5AJr/V61OnmStve+DOoSfP1QTUWLRhtB7vhcV1MwGmQe/
         QxjjykDBMG9N5joNoHYlMjjSUd6dcGYrTH6KKvXuhkMwMk45xn5zhMoGw5v+MUgPoByz
         GxPQarlZ4EG1ypDPPVOvFaAQA3dFPayxQlizgleo9F9NARhDv88hYQ+qzDDD/KdVevkb
         lwhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=bh9MvVYSoRwniUuTCfSskdbcH0AOy3Z4iQ19KH1/zms=;
        b=g+300dMnpGXwkMF01THuojnH2X1DSRofBBuKF+16Js0AhTMHa2aNqMSzmHMMqrlgmw
         LtFpKcnMvRSwmxGKiDArqnENkcHz+oYbUuPt32XXxHFtetZ22Vm8iVYr+Mez5yn6p/qD
         Dp2b4p+NnabfyBznDNVZwt7hx0Vb2pZK+YT7YfrmjfhRosPqtD5vofUxR2hdaB4w78V5
         BgcIUEy8bYu+Epw2YidoJv6q4XKW4gIUctsx46ec7njAubOBTVjXT/5ScRgAh1+cLqFm
         d38M7jiSpXqKVyR+6cDo1UjFDTA008b3MEq2dd3yaMjPfqLe/p1Rep2cvs8cmxz6j5CV
         as9Q==
X-Gm-Message-State: AOAM531zoDhUo06n+cVdDD6ypzc4c+z4RmnaGfF+MJo14jbyz6l4DMDS
        syt2MR50ibhwiMIVUL4Akzc=
X-Google-Smtp-Source: ABdhPJwFlMXZFP2umcGaZzZPim8HjwNJjvk4U75EQt2jUkRXTKJwIxlLfOa/43ebXjT1TX4J9xC4zw==
X-Received: by 2002:a05:6830:2082:: with SMTP id y2mr628319otq.15.1638294137154;
        Tue, 30 Nov 2021 09:42:17 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bb8sm3930118oib.9.2021.11.30.09.42.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 09:42:16 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 30 Nov 2021 09:42:15 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/69] 4.19.219-rc1 review
Message-ID: <20211130174215.GD3226251@roeck-us.net>
References: <20211129181703.670197996@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129181703.670197996@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 29, 2021 at 07:17:42PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.219 release.
> There are 69 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Dec 2021 18:16:51 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 441 pass: 441 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
