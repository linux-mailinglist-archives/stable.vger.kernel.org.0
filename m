Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB013427A2
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 22:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbhCSVXh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 17:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbhCSVXV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Mar 2021 17:23:21 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E8DC06175F;
        Fri, 19 Mar 2021 14:23:21 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id i3so6229815oik.7;
        Fri, 19 Mar 2021 14:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=uqQyy4xqN7GSlAyXE8p5ZknTDtxNu9dMqTROMzdaR14=;
        b=aqe31hk1S1V8KbShG9VlRF6G85S575tSDPWiW1q10rVOFwiwXY2HgYsWt5NqHBVKBp
         oKj+JP5Enm6q4+rmUX2YnGmA+zNZhrjB4YKNBXXR6wsy1XLSoQn7lrf4dpdS6erNF/kL
         rry0tcm8ie9vgUMEcrzNCFFmdfStCVwhDHAo/Olsik0WCx7yWZkmcnizXkkbc3qGkhfO
         NMH1JNjl5KELRRVg7ualkGlcGCbUZ3jaoRvcUZ3sijglBtVa6Mkx7vaKETTw6c4Ucs1b
         OHkJ0aO6OyYu33mNC+Z4rVUk1ZTgDLyUlW6uf0erXEyKXiuGc8pJ+HSdSgB6AbQq537n
         O9Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=uqQyy4xqN7GSlAyXE8p5ZknTDtxNu9dMqTROMzdaR14=;
        b=AMzrM2/V+dd/a9t3OKQgv1A9Q+OvwrJx3e6tRFRvbnwUKqNPXv1X0EMfueiDNwzINX
         0qOu9qDO8ztSjepqSNznfl2bDC55st1A9xwNYJgDfbE1SHGFPhut2TAm3U5NALGzEcte
         h5sQL0oXS8tzrgSEpbTEVP1GKjvLNLZ5A+WmUAylLcEyOkLqlrZubJY6FrYinGPLNI3a
         9+BZGL0V7tBWIz2XytQqJahoggHn9YVr5xreRycTVbpHGOf3f28jXE7rHpZxR7/8sgH6
         plUFUpGO6Zuu/6x9pkoHyuhMMrStYVLKemTeV2aczSkUibRfSw5g/5cLaMV+I2lD50I5
         W0AQ==
X-Gm-Message-State: AOAM533M6GGP8uimv+H9UvbHKfqeH/hrCoAZEVX00kKBDYM724HUb4Fj
        sYdtFfB86ARcjvP6Jibym3Y=
X-Google-Smtp-Source: ABdhPJxozM4OshWeAw8xL1x2e65/nYF5jVWHr30vh7hcVvb2on2Lzz9O/1TWP7bUNt2+VtcTeQHu0Q==
X-Received: by 2002:aca:b645:: with SMTP id g66mr2349370oif.64.1616189000629;
        Fri, 19 Mar 2021 14:23:20 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t22sm1485370otl.49.2021.03.19.14.23.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 19 Mar 2021 14:23:20 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 19 Mar 2021 14:23:18 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.11 00/31] 5.11.8-rc1 review
Message-ID: <20210319212318.GD23228@roeck-us.net>
References: <20210319121747.203523570@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319121747.203523570@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 19, 2021 at 01:18:54PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.11.8 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 21 Mar 2021 12:17:37 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 437 pass: 437 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
