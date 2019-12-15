Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E21EA11F9C4
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 18:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbfLORjt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 12:39:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:39452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbfLORjt (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Dec 2019 12:39:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BF6C206E0;
        Sun, 15 Dec 2019 17:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576431588;
        bh=xO9imPKgrcaG4Gppck79B18IaNtrDNJP84mfF1NmxiI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oLQt/dJuBtR553xBwV4VzOgI8UO2E570seCzCccDDwEdii+mF69Y+kw7waj1awYZG
         kXd5Z+OJGE6p8RTFgPxvLIjpDyqQsS7Meu8Gs6aqrM7xYSzCqLdKr5dvMt9TAWOw1X
         Pn+Lwt480hhiSJ0jBI1yjgdP3mNwNyfPcn24HDsc=
Date:   Sun, 15 Dec 2019 18:39:46 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     stable@vger.kernel.org, tony@atomide.com, ulf.hansson@linaro.org
Subject: Re: FAILED: patch "[PATCH] omap: pdata-quirks: remove openpandora
 quirks for mmc3 and" failed to apply to 4.3-stable tree
Message-ID: <20191215173946.GA855550@kroah.com>
References: <1576416778218226@kroah.com>
 <0280CE20-0D1C-42F5-9243-3A464ABD71FF@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0280CE20-0D1C-42F5-9243-3A464ABD71FF@goldelico.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 15, 2019 at 06:30:33PM +0100, H. Nikolaus Schaller wrote:
> This patch is not intended for 4.3-stable because it fixes a bug introduced in v4.7.
> 
> > Am 15.12.2019 um 14:32 schrieb gregkh@linuxfoundation.org:
> > 
> > 
> > The patch below does not apply to the 4.3-stable tree.

Ugh, that was a typo on my part, sorry about that.  There is no more 4.3
stable tree :)

thanks,

greg k-h
