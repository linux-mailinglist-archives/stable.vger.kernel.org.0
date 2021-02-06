Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB2D7311E92
	for <lists+stable@lfdr.de>; Sat,  6 Feb 2021 17:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbhBFQDJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Feb 2021 11:03:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbhBFQDI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Feb 2021 11:03:08 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1508EC061756;
        Sat,  6 Feb 2021 08:02:28 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id n7so10912465oic.11;
        Sat, 06 Feb 2021 08:02:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jANMVpFV6X+7bLZv9mIw0bFW8TVD0W2g2QnIcrut0SA=;
        b=UJxaSXeFuPQD+5+4L2M8xzzMJjx9DnlNW8QpkkLEhx+8jFz4sNTTHlduwCR7bUrLFW
         9hLEcyzOW4jSiWhWT3DmaoKhs8uqqaX7XPW0dmWp1S00IG0eO1QnMQygAvgltE2BDzVY
         cyWTsrpM2YfuE7sggD+Ii5VYS/TnKTehfAp/KmjFHFNGuw661IhWpxiobueSIz0UU4Al
         OOO0C9Bs+YEGUlc8lTF5c/CLnu22HGgvBZue2sAg9Plf7DVHetzDIngJI6z7mZnTUVu+
         e/ZAJ0id/du41H6f5RPOtLVC3/cmpVC9vJ8OW0hiELmkEKCmFQRBkiWTFAUjPPkNzDYf
         Amdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=jANMVpFV6X+7bLZv9mIw0bFW8TVD0W2g2QnIcrut0SA=;
        b=Bt5F2ZjFcKyT8C4Ip/oGnsjrKy8Det0w4/rji0IIEsngpg4OY9V1xqb/RPIo05BJkP
         IYbKQ76ebntX+SED76+PFreT+SzC1ao5RWogeZoEKIGPf7jrAneracEkniPo88cfTxpl
         RlAwAx5dVrLTgjaRhxbfKCD01kseLqLAqvV3+O29CWM54CTpGmCRQ23a85e7bnkpL2zW
         8G5BxSJPBCGgyO/UN1BSesWZivWfvcUiVzS6ZqRrZODoOmKP/5EkVeQt6/yEHoFLOjbj
         /6timDIt2eORpXpTDtX3QED2BjoPqKTXL2fICH+1+0A6k4duGuzZsCcUlqNsypx1LPcj
         rJhg==
X-Gm-Message-State: AOAM531UfTFBOALg1vKxtWYp3szUa57mVQBMAAkoyBcLzI0rqEvj7oNq
        N6AJ3Dgo3bpehIFz7zjyweXAe7tws3s=
X-Google-Smtp-Source: ABdhPJxaGNhyWK54AG/aHtmD0X5bggRUnSSoWyyseMAuuE4Pyn+IztdmL30/c6HpSNLj8fdwkvSwZQ==
X-Received: by 2002:aca:df84:: with SMTP id w126mr1481242oig.58.1612627347593;
        Sat, 06 Feb 2021 08:02:27 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u2sm2522762oor.40.2021.02.06.08.02.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 06 Feb 2021 08:02:27 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 6 Feb 2021 08:02:25 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/57] 5.10.14-rc1 review
Message-ID: <20210206160225.GD175716@roeck-us.net>
References: <20210205140655.982616732@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210205140655.982616732@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 05, 2021 at 03:06:26PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.14 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 07 Feb 2021 14:06:42 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 427 pass: 427 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
