Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB0C926CC95
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 22:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728456AbgIPUqX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 16 Sep 2020 16:46:23 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50718 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbgIPRBY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Sep 2020 13:01:24 -0400
Received: by mail-wm1-f67.google.com with SMTP id e17so3488563wme.0;
        Wed, 16 Sep 2020 10:00:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=Bn+sbCWoMoEWXFDYYD/cn5Vwv90GZomveDJ0LJsbSEs=;
        b=Zj0cf9BQVhIjYadlApua5Wunw/CjOZLtUnKlm1FAhyQcNN1AYZSiPk5OqhBReG3obg
         S/5vTJ2aUCvlPjGcrt790i1WLeRn8/3XexM9lhLiKIrYmibiQ2jh+L8Mu1b1NzZBxj2v
         k61JVAaeZ0N2+ZFb8JRAXNLpI6YZZa/9MARAyapCphFYGgpAqp7hd0xlJSXEaOLSiyYh
         l2DyJz2pmoozRhzl5dvDOB9OMuf1eE9rAhm95aka7OU5wVXlrvggZYDG+KZ54YRnwzEO
         cRCwVGniHnGm5EJH3eG/FDtSWneDHeY24kLAdkoRh1t37qBN8ryuS4c/zpOpYWlGFlf5
         50hg==
X-Gm-Message-State: AOAM5317ALdwfJ23ut3Kp6MvzzzgvOwW9NIdCnq/EuhU1IfK0W6pPn41
        TOPkQNrvyPY32phQbZ1XfRQ=
X-Google-Smtp-Source: ABdhPJzST1TbrG+M5Me6cW+XADMMr7T7ClzGrnimh+Kd5fIyONzHa8GzoHhctJNlccK4+AMkN4FJ+A==
X-Received: by 2002:a7b:c5cf:: with SMTP id n15mr5670927wmk.93.1600275607933;
        Wed, 16 Sep 2020 10:00:07 -0700 (PDT)
Received: from kozik-lap ([194.230.155.191])
        by smtp.googlemail.com with ESMTPSA id s80sm5914786wme.41.2020.09.16.10.00.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 16 Sep 2020 10:00:07 -0700 (PDT)
Date:   Wed, 16 Sep 2020 19:00:04 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Kukjin Kim <kgene@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Tomasz Figa <t.figa@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: samsung: fix PM debug build with DEBUG_LL but
 !MMU
Message-ID: <20200916170004.GA19427@kozik-lap>
References: <20200910154150.3318-1-krzk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200910154150.3318-1-krzk@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 10, 2020 at 05:41:49PM +0200, Krzysztof Kozlowski wrote:
> Selecting CONFIG_SAMSUNG_PM_DEBUG (depending on CONFIG_DEBUG_LL) but
> without CONFIG_MMU leads to build errors:
> 
>   arch/arm/plat-samsung/pm-debug.c: In function ‘s3c_pm_uart_base’:
>   arch/arm/plat-samsung/pm-debug.c:57:2: error:
>     implicit declaration of function ‘debug_ll_addr’ [-Werror=implicit-function-declaration]
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: 99b2fc2b8b40 ("ARM: SAMSUNG: Use debug_ll_addr() to get UART base address")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> 
> ---
> 
> Patchset is rebased on v5.9-rc1.
> ---
>  arch/arm/plat-samsung/Kconfig | 1 +

Applied.

Best regards,
Krzysztof

