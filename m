Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C89F213F27E
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407157AbgAPSfq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:35:46 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:37330 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407151AbgAPSfo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jan 2020 13:35:44 -0500
Received: by mail-lj1-f196.google.com with SMTP id o13so23778428ljg.4
        for <stable@vger.kernel.org>; Thu, 16 Jan 2020 10:35:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lixom-net.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=w3m47L5Z0xI8HYh0lKryrWYdR0UgzApvsO7nDstJ484=;
        b=zt4hUFckpv0JtJBTTBpPR0wmokiqIfW2lNyhGhC5whKAMLVPQ598lSopUqg40Dednt
         zZo0oen6Rj98R4s2jKVEEcBxfKT/0FB5KuR3J5vOvJn4EL6sX/EUaJVb0CARHJQRzqoW
         uKbC//iUkpteLGJZ6Dw876Fj0gC3FiXyI+hiL33ReAiBpqHjvoxIX3d8exyoXErn3ulF
         3M+pB9l/F2YBegxvYZqVrF14OhsMBCzdgU+DFXEVcGFHUJdwod8/UsTrdWlt1M1nYU1s
         VyiO8zEEtSJi0si67QGW4eRXclm6PYPI8n7GMfhxFHWwD8JYf5YlHLFCO3zVZZh7qZyF
         HZOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=w3m47L5Z0xI8HYh0lKryrWYdR0UgzApvsO7nDstJ484=;
        b=ATRxqWS6b48/R9uENuwCBD2ImqqKf+4zgAvNT+lESnlVtP/0j8yXMIUyYDa7FLqLjF
         nLfc/2Ott0vM7JgM1eJ3wIlh6Js/pi2OCUmDrc2QR5nwNfOQCbyqy36fE3Fj+33H9kf4
         BpfZluqtfMwGgrF2ya1F0OVpS+LVChkuxEhkCWgmUP2musLeTCS9sB1+UgvDJEnt0c+S
         tAKDgdzx5bPQxkPMKJHxrTjYJUXsp/soh230jOIM7zvXso10ax6MY8y/KlxUZmRhZOBI
         6hNRXo7RVIBlBfYFxUB4hQ4wDSpuBrQCQif87c41HfMpfUsIXPipD9vNLbU0pHB/cHXE
         f+GQ==
X-Gm-Message-State: APjAAAXrDKO2fJsU0sDwej/HG2A3DP9NJ/8F2HXXEswBe3URArLSkjjg
        akkQaDC6/XsABCqL/iqk0cUAdg==
X-Google-Smtp-Source: APXvYqz/9p+Equ9yB2/f1ypHaf4+rn1iYRPCZicwrFKzWbSFxXdSqtv9R5Vc2x+rsOBhxB3KKZsmqg==
X-Received: by 2002:a2e:89d0:: with SMTP id c16mr3151068ljk.228.1579199742453;
        Thu, 16 Jan 2020 10:35:42 -0800 (PST)
Received: from localhost (h85-30-9-151.cust.a3fiber.se. [85.30.9.151])
        by smtp.gmail.com with ESMTPSA id x84sm11124259lfa.97.2020.01.16.10.35.41
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 16 Jan 2020 10:35:41 -0800 (PST)
Date:   Thu, 16 Jan 2020 10:34:58 -0800
From:   Olof Johansson <olof@lixom.net>
To:     Sekhar Nori <nsekhar@ti.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        David Lechner <david@lechnology.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: davinci: select CONFIG_RESET_CONTROLLER
Message-ID: <20200116183458.qsa6bk7wlfhpd4m4@localhost>
References: <20191210195202.622734-1-arnd@arndb.de>
 <ba94531d-1f16-b985-5638-c226bab28d5b@ti.com>
 <1513bfee-6623-47fa-1eef-6074ba9ab3b8@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1513bfee-6623-47fa-1eef-6074ba9ab3b8@ti.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 13, 2020 at 05:32:54PM +0530, Sekhar Nori wrote:
> Hi Arnd,
> 
> On 11/12/19 3:42 PM, Sekhar Nori wrote:
> > Hi Arnd,
> > 
> > On 11/12/19 1:21 AM, Arnd Bergmann wrote:
> >> Selecting RESET_CONTROLLER is actually required, otherwise we
> >> can get a link failure in the clock driver:
> >>
> >> drivers/clk/davinci/psc.o: In function `__davinci_psc_register_clocks':
> >> psc.c:(.text+0x9a0): undefined reference to `devm_reset_controller_register'
> >> drivers/clk/davinci/psc-da850.o: In function `da850_psc0_init':
> >> psc-da850.c:(.text+0x24): undefined reference to `reset_controller_add_lookup'
> >>
> >> Fixes: f962396ce292 ("ARM: davinci: support multiplatform build for ARM v5")
> >> Cc: <stable@vger.kernel.org> # v5.4
> >> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > 
> > Assuming you are going to apply directly to ARM-SoC,
> > 
> > Acked-by: Sekhar Nori <nsekhar@ti.com>
> 
> This is not yet in Linus's master. Let me know if I should collect it
> and send a pull request.

It's sitting in our fixes branch and should show up in mainline in not too
long.


-Olof
