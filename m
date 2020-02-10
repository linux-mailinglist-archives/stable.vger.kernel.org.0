Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7A7157C89
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgBJNmJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:42:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:37536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727608AbgBJNmJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 08:42:09 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EF792070A;
        Mon, 10 Feb 2020 13:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581342128;
        bh=5Eej5lVXPxtXUJAcBIwWMhEm8+QwGGg2d+RHI7UPVT8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D3J0tcsHC4yoljBzE5DMlHAjqgZ+5AmGIjpQEENaHibhiZcKIzmpOVVd6Jp+9kvvw
         BsgpTYZaX6Rxjav68jeuqerOlWng+A9LBxH0ghwv4SwaxJ2rQ8NcdUG9TJGf7iUddn
         /FnjfbK+A4NZ4yjC+zA7nbQxnarNfaQ+8a8y3szU=
Date:   Mon, 10 Feb 2020 05:42:07 -0800
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Marek Vasut <marex@denx.de>,
        Igor Opaniuk <igor.opaniuk@toradex.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Mark Brown <broonie@kernel.org>,
        Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
Subject: Re: [PATCH 5.4 261/309] regulator: core: Add regulator_is_equal()
 helper
Message-ID: <20200210134207.GA532104@kroah.com>
References: <20200210122406.106356946@linuxfoundation.org>
 <20200210122431.731980081@linuxfoundation.org>
 <CAOMZO5D5U+OmQk5D-ObtR6O9hBm4S8EnycMLnAghw2vsyOG1cQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5D5U+OmQk5D-ObtR6O9hBm4S8EnycMLnAghw2vsyOG1cQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 10, 2020 at 10:03:00AM -0300, Fabio Estevam wrote:
> On Mon, Feb 10, 2020 at 9:38 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> 
> > +static inline bool
> > +regulator_is_equal(struct regulator *reg1, struct regulator *reg2);
> 
> This causes build error. There is a fix for this in:
> 
> commit 0468e667a5bead9c1b7ded92861b5a98d8d78745
> Author: Stephen Rothwell <sfr@canb.auug.org.au>
> Date:   Wed Jan 15 12:02:58 2020 +1100
> 
>     regulator fix for "regulator: core: Add regulator_is_equal() helper"
> 
>     Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
>     Link: https://lore.kernel.org/r/20200115120258.0e535fcb@canb.auug.org.au
>     Acked-by: Marek Vasut <marex@denx.de>
>     Signed-off-by: Mark Brown <broonie@kernel.org>

That commit is also queued up already, thanks!

greg k-h
