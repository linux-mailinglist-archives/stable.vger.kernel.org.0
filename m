Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C22FB303226
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 03:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729359AbhAYOZD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 09:25:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:53882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729441AbhAYOYa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 09:24:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D935123102;
        Mon, 25 Jan 2021 14:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611584629;
        bh=ovE4LpzpvxphrWmCFe1gDhMEb1FKhNFTwP40GDj5+h0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ENLFpAIKQk0uVFWgTWA13MA+wIhsdTjp6o2/kO2I674QTwov6SJ5jqSlyXaxoAJgM
         h+XsGz8flLZ+jDJljyWRIiESh3Lgw7vkBSVjoxkLXOEMFu91nWYc6t3TtcvUR5M/u+
         1uMaHEBx8gQEleo3Vg2gHMaNUTvxZzIel1PHd3IA=
Date:   Mon, 25 Jan 2021 15:23:46 +0100
From:   gregkh <gregkh@linuxfoundation.org>
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        stable <stable@vger.kernel.org>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, od@zcrc.me
Subject: Re: [BACKPORT 5.4 PATCH] pinctrl: ingenic: Fix JZ4760 support
Message-ID: <YA7UcnXkuAh1nuys@kroah.com>
References: <1611494593252195@kroah.com>
 <20210124134704.202931-1-paul@crapouillou.net>
 <KEYFNQ.YUG2S0J7JWMP2@crapouillou.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <KEYFNQ.YUG2S0J7JWMP2@crapouillou.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 24, 2021 at 01:49:32PM +0000, Paul Cercueil wrote:
> 
> 
> Le dim. 24 janv. 2021 à 13:47, Paul Cercueil <paul@crapouillou.net> a écrit
> :
> > - JZ4760 and JZ4760B have a similar register layout as the JZ4740, and
> >   don't use the new register layout, which was introduced with the
> >   JZ4770 SoC and not the JZ4760 or JZ4760B SoCs.
> > 
> > - The JZ4740 code path only expected two function modes to be
> >   configurable for each pin, and wouldn't work with more than two. Fix
> >   it for the JZ4760, which has four configurable function modes.
> 
> Forgot to add the original commit ID:
> 9a85c09a3f507b925d75cb0c7c8f364467038052

Thanks, now queued up.

greg k-h
