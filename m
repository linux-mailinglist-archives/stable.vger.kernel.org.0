Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A63032C837
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 02:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377077AbhCDAe4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 19:34:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387973AbhCCUHZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 15:07:25 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62EFCC061756;
        Wed,  3 Mar 2021 12:06:45 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id j1so27404427oiw.3;
        Wed, 03 Mar 2021 12:06:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=maWR3MwDnpTCyKD0A5JuR2qaNqfVR1pB3LvsxhZUP8s=;
        b=fu94lpr87gnX31AVFnE80wq3W+kr4ff4xdKHueLMARJNnTbugI/1OAm2rhKEUoBts4
         IrLYZl3tUmrUJanHfKsnvmRDrMqtau+KJhtfUlsz4Ib+/YfYR5AYYbPz7/doNrJRG7s8
         tQNXFQ1FvsQU9LnxdJe3ugxZTEnrtjpIqWhNx8JvqKCHoGVGlTO1jJQLIDFyhrvBhzJG
         foaKBuVLtl1IVHox5qti5MtVfrr7m6nwME3DpNVVhHp+a6AKJZjMxDB70f2sJ9D6Io0X
         7OkiX3ON9+cGH7HmlUx2Pjroo5ry/sI5Tn13jli1EuiHU+s+m8X02ck/cGCnXl/S4GZi
         /DwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=maWR3MwDnpTCyKD0A5JuR2qaNqfVR1pB3LvsxhZUP8s=;
        b=SH4YtPmFsTQvk+d79l35bQw8Qq6Z+UBj1v5+DhDhrLIuEFGQpr2JrxKXU/tGK9g74K
         xqkeGWf6yQw/vVeAzLs9hhjd8TlPwWA6QhvmkIfgv91vuOEFks6NmvigvjdyMQsm0KF2
         p2SbZ/FxIpSMHb2YgMNc917PdXzuGeM0xG2gykFsilnOiCLMBe5HDDHUdQLHRgn9DtVb
         J4BsEke5I0npFJwyPMiyvtJj88ID9zZhouMQ5XOmdG7zZs0OggoNlwkW4BhcBgsu+RFA
         LJKTBe2sJVrfSqXrLkthCwoWZQ8+Ig6rxNbFwAobHVR93x2sqWWQkctJ7g2R7Ssn5nE4
         RUkw==
X-Gm-Message-State: AOAM533FcZB/qkObvqjcA0AVTFmzSwhjdUR1/7DZpK4ZoG2mOvYrpwRn
        dj3mB9dWNJ1m2A8xv+2ZZM4=
X-Google-Smtp-Source: ABdhPJybbv/A5rtSLpfid+7HgbIe2wXvM3PiuINYCk2CtjCWJLZ0xT+AYqvSkiEbkGMx1cYNNCP3MA==
X-Received: by 2002:aca:4508:: with SMTP id s8mr450644oia.118.1614802004860;
        Wed, 03 Mar 2021 12:06:44 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w15sm4296092otp.29.2021.03.03.12.06.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 03 Mar 2021 12:06:44 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 3 Mar 2021 12:06:42 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/175] 4.14.223-rc4 review
Message-ID: <20210303200642.GC33580@roeck-us.net>
References: <20210302192539.408045707@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210302192539.408045707@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 02, 2021 at 08:28:05PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.223 release.
> There are 175 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Mar 2021 19:25:07 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 406 pass: 406 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
