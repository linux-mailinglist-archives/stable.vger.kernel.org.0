Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C91A414BEED
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 18:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbgA1RvX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 12:51:23 -0500
Received: from mail-yb1-f196.google.com ([209.85.219.196]:44149 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbgA1RvW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jan 2020 12:51:22 -0500
Received: by mail-yb1-f196.google.com with SMTP id f136so7113583ybg.11;
        Tue, 28 Jan 2020 09:51:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=e0Vmq5myNp7ihPvBRUAeOgRf8OdwgEjv50BOJEfcsKQ=;
        b=VF6Ud0uW3qlDx672C6ALMuR1N1MC/e7Qdmx1j+JktY3spfncODviUk1vumE7+F8wMQ
         xO1u/RjbjFwP23DFpNIEoadkrKR09lTnjADiwqUYNGGcEbOJTroPb+P9XmDNoxR8DgqS
         sPd5W4ScMScbEOps9u3U5F+9hiPdTcrNdipT1GGozrsRoAouc9fLalIcVyltQGzdaftP
         BkXXRrIbw9BOg7CZXFcSTe0q4N5KfbkooLucniT/sigUY+frk0edPCPZPz4PpJo7WIDo
         58ClvjqZEG3vXmt6iNmP+w8JgkkJxnePn+ynnH32F/s2YG8JIE5Ajhba3mMQVrFXEyEW
         b7Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=e0Vmq5myNp7ihPvBRUAeOgRf8OdwgEjv50BOJEfcsKQ=;
        b=Huiw+MN+CkWZcQGEB1jcVYm9/4VBw8sy4LrK834SLrgpR6w6yPrDDMgvseu06e+jDF
         AuXpbSkjwK0dSDi+Cc9otEAEfxKoQmBC88bCOnP2Ir/o9uiNuDjw9nh943+7WkfH0rzG
         gb4Ark9efi3rKZU1Ks++CIO6qOxrNdat3N/EZpapLDnNfu7jwpC1zrIGWl5F14O18uc/
         mXz7fSiro1Lwc3kkjlYwSW9UdFitXszL4O7cJLw+fCuMozXfzmA5qIc4UZYrErvySVWU
         zEMjumH7yF7lHe7L3PtOTm+HjQ01hZMXn9CAWyMmSPDvEYRk7JI1Lcki+RiV8dH4wWAE
         LTHQ==
X-Gm-Message-State: APjAAAWHdWJt4/Kpxr06kNACUHRGIQR0lX0mAgnZAZwRFN6GiRdFlihq
        lHcZP3jv9d6GKb5oZnNRG+RzG+4o
X-Google-Smtp-Source: APXvYqzr6GlaMeayKFIxHSgbHgwi9qkzV7MMFfGK4UVzy3avojFvZx/ld3NCFd1vP8L+sD/AlXw+uQ==
X-Received: by 2002:a5b:80a:: with SMTP id x10mr16474089ybp.385.1580233881796;
        Tue, 28 Jan 2020 09:51:21 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d186sm8678005ywe.0.2020.01.28.09.51.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 Jan 2020 09:51:21 -0800 (PST)
Date:   Tue, 28 Jan 2020 09:51:19 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 000/183] 4.4.212-stable review
Message-ID: <20200128175119.GA8176@roeck-us.net>
References: <20200128135829.486060649@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200128135829.486060649@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 28, 2020 at 03:03:39PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.212 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Jan 2020 13:57:09 +0000.
> Anything received after that time might be too late.
> 

v4.4.211-184-gc4e686398655:

arch/powerpc/kernel/cacheinfo.c: In function ‘cacheinfo_teardown’:
arch/powerpc/kernel/cacheinfo.c:875:2: error: implicit declaration of function ‘lockdep_assert_cpus_held’;

Guenter
