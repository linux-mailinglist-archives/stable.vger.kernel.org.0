Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A50F3D02BA
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 22:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234513AbhGTT3m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 15:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232555AbhGTT2b (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 15:28:31 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91990C0613DB;
        Tue, 20 Jul 2021 13:09:04 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id y66so472034oie.7;
        Tue, 20 Jul 2021 13:09:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=R7hH0iWBLMoS42DmHsJjDBi+zEbZ3nDJKV9Z7pFCLY0=;
        b=f/pQt7HJ0ccJbcgYu+J2KLrHZ8GLZcJAq9rum7ugQCd4mLla2U1qztcZ2fkk5ajoOY
         +xGpNU8SF0ZBANVayBQUgnuoqMzgIt1aARfNZFT/eSvMFNycFpLofIRu7EDLWJZ0gzqa
         sKIaHM/lzb5PFppitqA3wxFhYah3uC2ixQ4sUrnhRx3au5kppY/DZAhiEW7DqvXmX6gi
         3wy5zcMDI9UUfYwtZsTGkfaN1NpxiqmCUnx3+ow7prkBVLyGTPSWiyvzHhXcOkg7DA5b
         ZX1dFt0zlFSOOmkDv9gXeaFtBcmqn/dRWUh5e3mVnFwvFmnO8jRylyfYhFF6pr9Fo+1o
         SIGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=R7hH0iWBLMoS42DmHsJjDBi+zEbZ3nDJKV9Z7pFCLY0=;
        b=p5OfsZ/mjuppKGKFYy6JzdOiik0ZLKxGXc4OUnGfjYAiL7KYKsQH8VgxX2yVzvbwnh
         iNHH9QACiGTb9aL2Tnbfy2Ie2p5ed8b3OXQB6rdZPyvUcJgkBToqw0ENff47qbCoCobr
         kbvuaGOqgtbFUFA6ggJKrq8uHi1/tK9s6/gDmAQZn4VzB0nu7YvMN2oTuuMKPe9Gyy8X
         NfOvJ+DgfVP4XRABOPS3wqZiZgiEJbHJUtkpFg/ixATNrUWWbZ0GVZbZteRK0HAYjvz6
         xZRhd5zMRDJCCppsk7rpghmQPh81VlS+YpiIfOMfW5RvJd1nqmONixAhCK6c+3wP4Czd
         /0pw==
X-Gm-Message-State: AOAM530jrKR3CGZAQFdp/Kxcgh0YbsLYqjSohlsr4u3YWn/g41iJO3Ix
        LZ8FU6nPr9MYIjRvwCdnegg=
X-Google-Smtp-Source: ABdhPJzRsXPX5eCmKfOb/Iek8iEVOmndIJxmpmHDe8nwXXXvd3CZAuaY72qatCAcBjFnh0CZJvo/Lg==
X-Received: by 2002:a05:6808:1290:: with SMTP id a16mr96931oiw.147.1626811744051;
        Tue, 20 Jul 2021 13:09:04 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v4sm3901059otk.75.2021.07.20.13.09.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 13:09:03 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 20 Jul 2021 13:09:02 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/420] 4.19.198-rc2 review
Message-ID: <20210720200902.GD2360284@roeck-us.net>
References: <20210719184335.198051502@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719184335.198051502@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 19, 2021 at 08:45:06PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.198 release.
> There are 420 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jul 2021 18:42:43 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 426 pass: 426 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
