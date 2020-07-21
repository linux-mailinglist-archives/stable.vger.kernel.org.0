Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0524C2285D2
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 18:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbgGUQgq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 12:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726919AbgGUQgq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jul 2020 12:36:46 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C14C061794;
        Tue, 21 Jul 2020 09:36:46 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id j20so10991958pfe.5;
        Tue, 21 Jul 2020 09:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ugNmf5f1ssdnztFM4mLSm3kKPPJPVFe5okdNvNNvO7Q=;
        b=eA/Mg8gIV/CBeMAhmMaA7wFJJ9tizVlbs9gKuoxMl3haE4wacLZInR89wFu1478N2T
         mUiISeLG8rhjXB/+A8Zk9ziNpripSaCMmjp9cM/HWig8FIgXifHhJGgcExJfuLYqY9A3
         yfuqXL5wXQe+S/hDqnPkXagw7k/hZgdLO0QeBJdeB+QBwdazQXO1s+uzhXeBASCoB5Jt
         LWMuuv2Pa/zgcw2OxfCsrSh/0SvqcE8g+jOep4qGeR6b6VqZCh4lI7iiylLDNoMBNJHW
         DAwF2ScUV15YXeit8XGzBbPGnFn952L9YVSIV7p2013u7/g1oFcpownSYRyBCDIRq7/y
         rz9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=ugNmf5f1ssdnztFM4mLSm3kKPPJPVFe5okdNvNNvO7Q=;
        b=NBQ9RgkLWqQRrZdNiBByuP4UNkrEzo3+z29Xmsouh+xb7ZGB+BIUe/FJILy8uakX/6
         mFAFsvvEcbOdiEFmvYAGbXNCtaVtjvWRvPnvbdR1E2dGgtEgZhFKA8Je2CX2jqngMXAI
         3xDpMPnYZj3ChidrHo2hs9TqaqkouTNBwbwMvVaRjTWmane9fMwplUGeOVWtZsY0GYof
         pwf5UzeFrCcXYnuC/Bp2DerLYSlBg1PRjnHNzyJEkhKHARl2KPWjRLgSlfeg4QbmpdhA
         HgJqjKkEP4acPODx0D/PhkVzz71CokzHXJJCjAGM4kt6kEG62t9TssxnP9C1KDm5GpjW
         1pFg==
X-Gm-Message-State: AOAM532lXnDqXlNCGHvu2g9BC/MGzQhKsGVSQL4gYo6n64sHlwwBFlix
        TA//NQgZJEKhXLH8xM12mFs=
X-Google-Smtp-Source: ABdhPJwqbKqY8+D8DMQ0OniIVS108O4i4r8WfNBV2HhYpIGGyUqaeI5w51DiUz52n3jM9NF5VHxjjg==
X-Received: by 2002:a05:6a00:1586:: with SMTP id u6mr24407003pfk.147.1595349406039;
        Tue, 21 Jul 2020 09:36:46 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f18sm17944110pgv.84.2020.07.21.09.36.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 21 Jul 2020 09:36:45 -0700 (PDT)
Date:   Tue, 21 Jul 2020 09:36:44 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/86] 4.9.231-rc1 review
Message-ID: <20200721163644.GB239562@roeck-us.net>
References: <20200720152753.138974850@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200720152753.138974850@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 20, 2020 at 05:35:56PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.231 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Jul 2020 15:27:31 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 171 pass: 171 fail: 0
Qemu test results:
	total: 386 pass: 386 fail: 0

Guenter
