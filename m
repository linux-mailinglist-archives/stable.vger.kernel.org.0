Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA80215E360
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:30:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391495AbgBNQ3i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:29:38 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37104 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393402AbgBNQ0t (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Feb 2020 11:26:49 -0500
Received: by mail-pl1-f196.google.com with SMTP id c23so3911307plz.4;
        Fri, 14 Feb 2020 08:26:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=B5LavZnvDc2H0BilbcHTMEaeHVyUFn+jvZShai3pdz4=;
        b=FojDOUKhHE/32/VEavk94WoIhrYrOObwR06J9FRHFHAIp+jFrNhRAZC71hw1sOqzbb
         rajf8h286q1k6zL+D8lbdRmcRWf7mDziyJ+8oef2DTpsAfwJqZKjy1IqeecXVkJhLJkK
         jBNnItT6nT2+Gw0p0WJlA78rtbv+UHs6uU0XUZ72oClHNLyRDz85Pxiy8/QEyzxHxs4i
         SLeoqXtnxXcOdlkowqqBjvJhN7mVXhEx/GVgeUoyBv1pQiNXu+WXUzixajtfxYGCAxCM
         XiusUlVEb4JNaOMI3Hu6GTpTSbKQVn10wyOqRkCcuWwdzC8CXx3QqclvXhszrelilUVh
         MbSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=B5LavZnvDc2H0BilbcHTMEaeHVyUFn+jvZShai3pdz4=;
        b=l2Rmyzgg+otKw8MlyDW5x1vHsEECpWGr5iFWEpZ1Kg+X0g2IT5qqGyFzvqhbdlSjjT
         7fTdL/xQlyEpGyUOvymGdMWC9ZeTp9syB0DRvcWKc9cFY7GR7e3wyTqPsS/3BKIMNZn0
         sg8D0HRfUo3a4RZINCYcLMo4/csoqhK5e/miBB+wm7htySSia8Z88SNzeqqebd3x5Y77
         zi/R2Emy1w1lLsz48ffWjIVDMacvlfR5EApHBUKkg4pREIQX1drpMVVSj26QmGhxchve
         q6f/BFq1zSZMwQcLcY7vZAL/dxttPNgOzcHac07tQM5uev6SlsraMwGfRPeuc8f+tKuN
         YZUg==
X-Gm-Message-State: APjAAAUjmMdf74l5mwDcgmbJugwASiCESHPaIfLbs77GxFb8icJ6xbW8
        /qpOkVFSEUJvsIB8zixe7xc=
X-Google-Smtp-Source: APXvYqx7lg9W8azBTIVgcSYBl/71cYY2Qqr/zdB8ci7UekByj8eHdv/HkemitzSzxfeAMEYl4cFcEw==
X-Received: by 2002:a17:90a:17c2:: with SMTP id q60mr4327761pja.111.1581697609226;
        Fri, 14 Feb 2020 08:26:49 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o14sm7549898pgm.67.2020.02.14.08.26.47
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 14 Feb 2020 08:26:48 -0800 (PST)
Date:   Fri, 14 Feb 2020 08:26:47 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/173] 4.14.171-stable review
Message-ID: <20200214162647.GA18488@roeck-us.net>
References: <20200213151931.677980430@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200213151931.677980430@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 13, 2020 at 07:18:23AM -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.171 release.
> There are 173 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Feb 2020 15:16:41 +0000.
> Anything received after that time might be too late.
> 

For v4.14.170-175-gfc30e3f7ed49:

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 378 pass: 378 fail: 0

Guenter
