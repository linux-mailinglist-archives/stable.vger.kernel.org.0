Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 153396EEEE
	for <lists+stable@lfdr.de>; Sat, 20 Jul 2019 12:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727710AbfGTKJu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Jul 2019 06:09:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:50898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727700AbfGTKJu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 20 Jul 2019 06:09:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23E8120873;
        Sat, 20 Jul 2019 10:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563617389;
        bh=v/6mTdXPWdAXUDN5KMQVjYHO1YFlsu5hDM5G0ka8NKw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YdumlYAKru89eoGAnBIPQascIIQnHFfJCbYZyrXDXwZfrVhWKKdKnMxM1NIBuowCy
         OyUaQMVt7et+buTclSlyUQOdb4/jzZDePTNNMsEaaegK38EhpGKb3KlhDA6ZWpGWmt
         7UsoGw+orM/iNWBUJyyVSZWOMVxfsKnr1LrpSKFI=
Date:   Sat, 20 Jul 2019 12:09:46 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Robert Hodaszi <Robert.Hodaszi@digi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 4.19 30/47] genirq: Delay deactivation in free_irq()
Message-ID: <20190720100946.GA7731@kroah.com>
References: <20190718030045.780672747@linuxfoundation.org>
 <20190718030051.289662042@linuxfoundation.org>
 <20190719195852.GA21625@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190719195852.GA21625@amd>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 19, 2019 at 09:58:53PM +0200, Pavel Machek wrote:
> Hi!
> 
> Something went wrong in this mail:
> 
> On Thu 2019-07-18 12:01:44, Greg Kroah-Hartman wrote:
> > From: Thomas Gleixner tglx@linutronix.de
> > 
> 
> normally there should be <> around the email address. And they are in
> the git, and in 5.1 patch series, so I guess that is not a big deal.

Good catch, this is wrong, I've fixed it up in the patch file.

thanks,

greg k-h
