Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5A4E231197
	for <lists+stable@lfdr.de>; Tue, 28 Jul 2020 20:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732330AbgG1SYK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jul 2020 14:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732328AbgG1SYJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jul 2020 14:24:09 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08DB8C061794;
        Tue, 28 Jul 2020 11:24:09 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id d1so10346793plr.8;
        Tue, 28 Jul 2020 11:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ACcl0I0FKCHzoJlruhy1bok/ASRUZLSp8wFM6Lmuq68=;
        b=E1A3ts3+nMgEKHtIp8mDRHd7xZB76rnpuBiq6FLMbI8cRd7KunW7PhP+mmQM21//Ur
         UlIt2cu/YvXe0YN/ymnYfPL6k3urFQ8Bx+wHrleM0yX663ixAeSZZED8CVyAHTgl+ov5
         FNCB2+3yzMPfTynrVH9E8dz7JQYwQkLph6TDqKwS/mBoGkAHFMYwUcuNHyxcWSAs3dpe
         mwLb6oZ0ig+28grXipGzieY/21Fc3GDad/oEEciaMfAkQc23mYmYSFnHq3NbrKRVcb9L
         r41GbkOrywjkdZLAtfrJmp0bwlNrQfkG3QTCqBuONhw9nW3EuHr0WKew2MFbDMaeEe9S
         aYZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=ACcl0I0FKCHzoJlruhy1bok/ASRUZLSp8wFM6Lmuq68=;
        b=UrfjD60/HQ7euHU97h0KlvcLwtwpK6dP1yDdQKAT4d4h9/lTUj1lZ254N4mbUiPh9A
         +lF6T9LpkxSimvOf8zFDKBB9MrhOajXJkYb/9WagsNDY4KnBFn4YCM4ONO9lDGF4V3WD
         mMV6FSfaEo+GZQJMuLTFIYNeTuOdGZPUoWSA9f7H5rusWeZTE7dj9fqg05pTeWoOwVH3
         VCkZ4LqJPEExNz/8fjY0RUkPM158Qz0/a/SUZlsR60co3DKVTLMT85vIvknBHfi8Ol3g
         3TwPjJmN8Ib2g2Shq9oJdn0F8tsKrX2v9xKmO2WdIud7EcCTjs7ilaOyVoIwx82qXXQn
         Wpkg==
X-Gm-Message-State: AOAM531Da3AovZ9unjowEq00HryG3Wi1gOKheaf2YXqNjBKUDijLzr/Y
        2Us6izzVDHnqvRJHkb8jYZ0=
X-Google-Smtp-Source: ABdhPJwGZPWDNJbeTIO2g+HL081gj60enjvDpuHMFDg2FBAci9zt8L08ovxSnOrOpj605PzxKt3iDA==
X-Received: by 2002:a17:902:9307:: with SMTP id bc7mr25507635plb.213.1595960648647;
        Tue, 28 Jul 2020 11:24:08 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k23sm18577881pgb.92.2020.07.28.11.24.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 Jul 2020 11:24:08 -0700 (PDT)
Date:   Tue, 28 Jul 2020 11:24:07 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.7 000/179] 5.7.11-rc1 review
Message-ID: <20200728182407.GD183563@roeck-us.net>
References: <20200727134932.659499757@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 27, 2020 at 04:02:55PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.7.11 release.
> There are 179 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Jul 2020 13:48:51 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 431 pass: 431 fail: 0

Guenter
