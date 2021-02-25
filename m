Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6667232571D
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 20:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233637AbhBYTyF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 14:54:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234561AbhBYTwf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 14:52:35 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E2CCC06174A;
        Thu, 25 Feb 2021 11:51:55 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id r19so6907101otk.2;
        Thu, 25 Feb 2021 11:51:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tqfUxA6R0Jrx7pcOgZodqULc/pmXOpkn7mAUe+P1S0s=;
        b=Zd6Ut6WR9cbY5JsRWLmEZt8joJAvfku/Ujvfv0IYspQviqTbPtSTv6r5pwLxJ+mFCK
         uFORVx/E4/Bq+OhdfenzYPOqbOAMaI9EDaOAhE+L9SX/Bz555WUL5dShkVNNh9VScvFd
         IMnInxpsVCMDJQS9t7x4q9BoQKQzM+DMf3mY9DNzxMMwnHuS9Vp7KUBj1jJcqPgmnsfC
         RbKB1lWzvFxD53NrdW1T6FcjF/SxgGJ6xrwk8PCIdm6zB1IvI3f8QswkW1dHjQKUj0XU
         5OKHlfJDbY/3qQ6UHnN/mRfKIyQR8ebwbi8NQ7UOYoXw7kUzRF7USILVdZjSVi8CbjvN
         hoDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=tqfUxA6R0Jrx7pcOgZodqULc/pmXOpkn7mAUe+P1S0s=;
        b=Z837fyhpHxq8g/ME9WhUUubNlGJ+kYY2Tu2R+eaYH7a1RcNylYdwxPomAN9zoQufm7
         fWQ4BN+/nD1WJk2be38Ze0j0MN5e+sUwBw/frGX86cCRmtnp+OaPZ9R02TPW4odqSLQa
         pqZT/pC5NB2ekU/yXB3Iv3dGIC4DxUvp2EW7UfdLBiVb0OscaEPF2M7iCRPRAWA++1UE
         MDmrlIPmjrfky/DONkzvJsUIHMJPAQF/Z5D/B2GUtI+n5Q/PMvGDf1zYRQTuWDVQdkhX
         3enH3DIjEAXjqwl+vCp3L6yLmGXip3MmxPUpNt5m4uqDp0AJk4wF0aoPWtaPce92tIto
         M+5g==
X-Gm-Message-State: AOAM533ipRsNMw28EBzTgsjrtLPoIa3riveA8U8oYeXDyBMnP7HZ+GOg
        ZmfD2uM116Dh9bFl6PY3NZPdet3qVUc=
X-Google-Smtp-Source: ABdhPJwOr1A17hv3cHh5EavsWUGohrhEm8hYGxXdXYJDug1w06qKmVdCOo880/Y1m65yzQE7fXUIEQ==
X-Received: by 2002:a9d:7a52:: with SMTP id z18mr3657144otm.106.1614282714586;
        Thu, 25 Feb 2021 11:51:54 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o20sm1258466oor.14.2021.02.25.11.51.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 25 Feb 2021 11:51:53 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 25 Feb 2021 11:51:51 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/17] 5.4.101-rc1 review
Message-ID: <20210225195151.GA107964@roeck-us.net>
References: <20210225092515.001992375@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210225092515.001992375@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 25, 2021 at 10:53:45AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.101 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Feb 2021 09:25:06 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 429 pass: 429 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
