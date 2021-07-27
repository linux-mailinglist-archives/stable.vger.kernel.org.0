Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8AF03D7CF6
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 20:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbhG0SAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 14:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbhG0SAB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 14:00:01 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDA7FC061757;
        Tue, 27 Jul 2021 11:00:00 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id t66so13268416qkb.0;
        Tue, 27 Jul 2021 11:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qB3CqubBSoGIswHTi0IxXUO5ychUNZdJQNAeuTxBeRg=;
        b=Uv7Cd17uiZmH2QHl0FaanQu6SiXF7Z8cvU9Ot5Yf3yaLy3x0oCjV87Yj7dGq99BrpJ
         FHNPaSq4KLbC0cqJN9rI2RNfYARb/4N4jMFJYfo6ChozvqX3/TOB20s/iV0LbgraSOLU
         QIQRJ1dT5mKx8xLWPv1QjcyX9rLJquh+FolWOu26uZHOLbaAyq7j48fl77Qe8SO3nO9F
         bUnssbYzuW7muH8pG7CgZC5H1UpyJI5L1d23IuMzeZOvAJbjmHnnFgCvw6xFy245aO+p
         iUWi0fRf+66Z/PVigl5liKaqYofla+6suTXmx6mzWv3cYiv3B2r4sWIqN8k1MEzKdC7v
         ifWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=qB3CqubBSoGIswHTi0IxXUO5ychUNZdJQNAeuTxBeRg=;
        b=aRzdr+7O5qd+vIkgdFXKZLX8LAnKJRDDWlzBRBf1C92y8HUl6IKN+sAqE9kl4qqCnq
         8pRAb+rAd55wInOV1AhxTD2jHqa7AkABoxakB9Cr0Fy80QNcvvCqWXN4LR2850MHBgvR
         lyifAWqeUOOYb0AOJfTGGWfr2VTpv2VnQrKHff1GLT22j86QEtI9It4NswHkfqswlKJ0
         XVqF4clXvY1sWwkCavsHAkNbbJ3h1JJvEKamBxdROZqLR6pGKlexcCfjPvA9qK+cl1v0
         hebORRvGjJUxtZktwrIb/FcXHpI+YZtOwvlaYdwEBgSi68MXHKUv+GHiKs72KFrsseE/
         QR8g==
X-Gm-Message-State: AOAM532LSeprHPgMBIEOxKKH32sm7vUhJw5i006gGYeBxwkIyS4IIkgO
        bqbBJaEtmh6IjCvl52cGCbo=
X-Google-Smtp-Source: ABdhPJwtRAVWH55/UYXp+4uSbAZVnnynSes4jvWy2BmEByTomrFM7/zwL55F8otB5Gg0q7C6e/hbeA==
X-Received: by 2002:a37:684f:: with SMTP id d76mr23223888qkc.357.1627408799951;
        Tue, 27 Jul 2021 10:59:59 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z21sm1708802qti.73.2021.07.27.10.59.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 10:59:59 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 27 Jul 2021 10:59:57 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/46] 4.4.277-rc2 review
Message-ID: <20210727175957.GA1721083@roeck-us.net>
References: <20210727061334.372078412@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727061334.372078412@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 27, 2021 at 08:13:51AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.277 release.
> There are 46 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 29 Jul 2021 06:13:25 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 334 pass: 334 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
