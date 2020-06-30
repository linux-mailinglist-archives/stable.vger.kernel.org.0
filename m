Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72D5D20FA70
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 19:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390251AbgF3RV7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 13:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387782AbgF3RV6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 13:21:58 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC18FC061755;
        Tue, 30 Jun 2020 10:21:58 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id q17so9700178pfu.8;
        Tue, 30 Jun 2020 10:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hhVnF8XtIBENJWyt2leQBzAMZ9arfKkacBbJga9UN4A=;
        b=JOpQqEuKNfi4TgrQ4XwftllFZQnx6caG7pAAwAd2B/3GVNeWezIGnrZWdY+lR9m6GF
         NMsaJn0dSONEChxq7egunhEA7DLFZ4kS1tAO6MyqakT6LI4gTuhoH7dOanVT/wpyKVkw
         2kdxEUgWuUzmSe5vi4ax7wc7Pjc+ECU+WByP5DWS8vfzE/CcCzu6zruwgHPe2ThmCzpr
         bi/2zCZMIf6ZXuEJ1QznGNDOv1CSgAebFX5I2QMJPMZm+cv00pOo0O3D8o8D0JMV95wi
         CcKoCrNBdP6k4WxQT8pIW8edIGe2f3WhBJEKxKwsjenFN/4nDGetdYg3dg3IFtnIY1+k
         ifOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=hhVnF8XtIBENJWyt2leQBzAMZ9arfKkacBbJga9UN4A=;
        b=FBYWEUOrqMJ0X1no+WY9IQVeHHtiGjEnQzWi4/REGmiEbw5yFT30x+AWtVkgdR8etn
         u4M5Q2dRyiwM7E2kOLNZNgpR34rrRLX0p8P3S8GjYqRhxFDZhXzvScnZXogkT7WsReDT
         r4+n/IlVmDP2udE96fLz9vZl2cOxNYLM1OvwA5uBQ5qXZ/SPdcgqWDgYUkUP3S0BCQB9
         AzE/5MLpuEyaFC2pSl5EiRbWdtuSS8uPN2fjWGScMhWmLTx8E08P61gfJVmLXEznPe2A
         iFdxiyQh7xTNthmK62w9eagxclODRfuWkQLTy/eBYOYAPZcl1EE04tteoxx+MGBAPzdA
         2XOw==
X-Gm-Message-State: AOAM533Uzlo1aLhr3PniYg2KsaeuYPC7MlYFMhXW7A2bTXH+eQW3TKFG
        LosRM0maLV3CnXsWtVF2Csw=
X-Google-Smtp-Source: ABdhPJz6DIhNc6fozJ1MuDiJkZ9HjgPVk65/4RRxAtYz7JIVbB7iHJ2ME/haM+5kOiGnHMcugRpaUQ==
X-Received: by 2002:a63:7c51:: with SMTP id l17mr15677144pgn.303.1593537718409;
        Tue, 30 Jun 2020 10:21:58 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 6sm3207293pfi.170.2020.06.30.10.21.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 30 Jun 2020 10:21:58 -0700 (PDT)
Date:   Tue, 30 Jun 2020 10:21:57 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org
Subject: Re: [PATCH 4.19 000/131] 4.19.131-rc1 review
Message-ID: <20200630172157.GD629@roeck-us.net>
References: <20200629153502.2494656-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200629153502.2494656-1-sashal@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 29, 2020 at 11:32:51AM -0400, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 4.19.131 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 01 Jul 2020 03:34:57 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 421 pass: 421 fail: 0

Guenter
