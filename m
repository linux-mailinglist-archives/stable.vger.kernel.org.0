Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 207854BF54
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 19:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbfFSRJU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 13:09:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:54582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726091AbfFSRJU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Jun 2019 13:09:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12D092084E;
        Wed, 19 Jun 2019 17:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560964159;
        bh=80tp+Pfbm6Ns4CbM/jJ69e0di//UD8WVvRSO8hblqyM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GUiKRDkeQDyT9YRzrvLwbzlNtdl981GFiz6MxIYp7SLnFO93q5foZULw8qzDq9gj4
         VLRRnZfrc4sFSYfxNGEHaR97+JqJJXlhaANP6dLMrRVEXQ3ehDEmJEaclS6cSjd5ie
         10Fsf2QDfDHktMYRRDYmjHTcefukDpsNNbZ5gW2Q=
Date:   Wed, 19 Jun 2019 19:09:17 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Raul Rangel <rrangel@chromium.org>
Cc:     stable@vger.kernel.org, linux-mmc@vger.kernel.org,
        djkurtz@google.com, adrian.hunter@intel.com, zwisler@chromium.org,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org, Chris Boot <bootc@bootc.net>,
        =?iso-8859-1?Q?Cl=E9ment_P=E9ron?= <peron.clem@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [stable/4.14.y PATCH 0/3] mmc: Fix a potential resource leak
 when shutting down request queue.
Message-ID: <20190619170917.GC10107@kroah.com>
References: <20190513175521.84955-1-rrangel@chromium.org>
 <20190514091933.GA27269@kroah.com>
 <20190619164625.GA85539@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190619164625.GA85539@google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 19, 2019 at 10:46:25AM -0600, Raul Rangel wrote:
> On Tue, May 14, 2019 at 11:19:34AM +0200, Greg Kroah-Hartman wrote:
> > On Mon, May 13, 2019 at 11:55:18AM -0600, Raul E Rangel wrote:
> > > I think we should cherry-pick 41e3efd07d5a02c80f503e29d755aa1bbb4245de
> > > https://lore.kernel.org/patchwork/patch/856512/ into 4.14. It fixes a
> > > potential resource leak when shutting down the request queue.
> > 
> > Potential meaning "it does happen", or "it can happen if we do this", or
> > just "maybe it might happen, we really do not know?"
> It does happen if the AMD SDHCI patches are cherry-picked into 4.14.
> https://lkml.org/lkml/2019/5/1/398

Why are those patches somehow being required to be added to 4.14.y?  If
they are not added, is all fine?

thanks,

greg k-h
