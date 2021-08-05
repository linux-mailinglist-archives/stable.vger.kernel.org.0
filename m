Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0CEE3E1CF0
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 21:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbhHETpM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 15:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbhHETpM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Aug 2021 15:45:12 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 261A0C061765
        for <stable@vger.kernel.org>; Thu,  5 Aug 2021 12:44:57 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id o185so8827959oih.13
        for <stable@vger.kernel.org>; Thu, 05 Aug 2021 12:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GukdHRA4NAegl09rQBluSmPZ8/amjPrbnBf3Xab/2Fg=;
        b=T59AIqx9G12F8V70wMBCKU1LFwQJ3vXZFS8ZC9vgy0tx1QF74hVtLVZv++w6K4lika
         Cc6Zc4lCYEWdJvUsr2cZNfo811oxyyP+Pr5gkw2LqBjzpX3LcZj3kziDSxEkdSbmjumE
         me46cRhhPRgWsMrPi0BWsLHBbNT2bE1G18lSe3GR2EvA3exeCpgMMLh+ydT1D48RMwQo
         91os9yTW1a+NN5reW98gOMFt5F+9RUJdv7wAEx0aIIqoIY4Vq6R1dVIF5PkKqlPfx4hx
         huS5npYzgO4BJEuaZ0ENAECasR6wZBYrIHnrC4NYrnHGLYhXBfcDzDRiA7O4+SDPHOwv
         NuLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=GukdHRA4NAegl09rQBluSmPZ8/amjPrbnBf3Xab/2Fg=;
        b=Vvj9xH6b5VspOasPr23eWuGgq52qGB5tNlKa9zX+tpHzLFiKYG0hPGOLj2FwB9PY0c
         rd+hYa/F00ZVGclMSuHEpAYl/L+widtUlQ9vOQwLUExrisfSJoBoNaKMN6hgQlJC33ND
         XhKoAbZHqU6ClvD7PiRJ/GXFYc7PD6fRlE5plbrUdOg5fcnZjb+VNfsgj8RR3hARQ1RL
         1zvYYS1vvqqetZiQ/uPrNwsHnRcSs+te9jKp+p7SY2RTcVR7nw1ho0ZVziehJ6JPBOsF
         kbKq1NiipFG727WDnI30C56Er44efNPoH3bKyfmFy9mg5krKP0OwCMbAPOUo8ibwobTJ
         VoEg==
X-Gm-Message-State: AOAM533LCYhhQSjC1yejP9LbYN0lBA7Tx2OQ58kbViscbfynoUkOrDm1
        EYsRgiYpJ67RT4DUbhr287E=
X-Google-Smtp-Source: ABdhPJxAipzh/41GtrKIYgSXQd6hcidqfRDiIPMuuAbZ6tIJ3NiC3FNytWgtVZoHxzajA0ToxhnnDw==
X-Received: by 2002:a05:6808:4d5:: with SMTP id a21mr3310865oie.1.1628192696571;
        Thu, 05 Aug 2021 12:44:56 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i12sm1121378otr.56.2021.08.05.12.44.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:44:56 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 5 Aug 2021 12:44:54 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: Regressions in stable releases
Message-ID: <20210805194454.GA3808616@roeck-us.net>
References: <efee3a58-a4d2-af22-0931-e81b877ab539@roeck-us.net>
 <YQwPg1VQZTyPSkXe@kroah.com>
 <20210805173922.GB3691426@roeck-us.net>
 <YQwjOK9lfbzEyK2d@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQwjOK9lfbzEyK2d@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 05, 2021 at 07:43:20PM +0200, Greg Kroah-Hartman wrote:
> On Thu, Aug 05, 2021 at 10:39:22AM -0700, Guenter Roeck wrote:
> > On Thu, Aug 05, 2021 at 06:19:15PM +0200, Greg Kroah-Hartman wrote:
> > > On Thu, Aug 05, 2021 at 09:11:02AM -0700, Guenter Roeck wrote:
> > > > Hi folks,
> > > > 
> > > > we have (at least) two severe regressions in stable releases right now.
> > > > 
> > > > [SHAs are from linux-5.10.y]
> > > > 
> > > > 2435dcfd16ac spi: mediatek: fix fifo rx mode
> > > > 	Breaks SPI access on all Mediatek devices for small transactions
> > > > 	(including all Mediatek based Chromebooks since they use small SPI
> > > > 	 transactions for EC communication)
> > > > 
> > > > 60789afc02f5 Bluetooth: Shutdown controller after workqueues are flushed or cancelled
> > > > 	Breaks Bluetooth on various devices (Mediatek and possibly others)
> > > > 	Discussion: https://lkml.org/lkml/2021/7/28/569
> > > 
> > > Are either of these being tracked on the regressions list?  I have not
> > > noticed them being reported there, or on the stable list :(
> > > 
> > 
> > I wasn't aware of regressions@lists.linux.dev. Clueless me. And this is the
> > report on the stable list, or at least that was the idea. Should I send separate
> > emails to regressions@ with details ?
> 
> For regressions in Linus's tree, yes please do.  I have seen many stable
> regressions also sent there as they mirror regressions in Linus's tree
> (right now there is at least one ACPI regression that hopefully will
> show up in Linus's tree soon that has hit stable as well..)
> 
> > > > Unfortunately, it appears that all our testing doesn't cover SPI and Bluetooth.
> > > > 
> > > > I understand that upstream is just as broken until fixes are applied there.
> > > > Still, it shows that our test coverage is far from where it needs to be,
> > > > and/or that we may be too aggressive with backporting patches to stable
> > > > releases.
> > > > 
> > > > If you have an idea how to improve the situation, please let me know.
> > > 
> > > We need to get tests running in kernelci on real hardware, that's going
> > > to be much more helpful here.
> > > 
> > 
> > Yes, I know. Of course it didn't help that our internal testing didn't catch
> > the problem until after the fact either.
> 
> There will always be issues that can only be caught on real hardware, we
> are all just human.  The goal is to handle them quickly when they are
> caught.
> 
> I'll go revert the above commits now, thanks.

If you do that, it needs to be done all the way to v4.19.y.

Guenter
