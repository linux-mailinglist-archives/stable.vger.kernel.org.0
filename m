Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1F94C0D6
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 20:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730165AbfFSSgr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 14:36:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:60548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726109AbfFSSgq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Jun 2019 14:36:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8B3F214AF;
        Wed, 19 Jun 2019 18:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560969406;
        bh=ASPng6hEbz1DA8ra61scrwvKdhNdcvVtXH/fg2JLJ/s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W1FLG9an4047zm9mVfDTVvrGzubs52CY5JRu9D+egtHOZdMOjWp4XXY1Uht+F4nbs
         JiRzj5rZkAt0avcEaxw5PCfqtifX0K9Tss4ZgIMpiHnPse3iYGO8cAg6RGjh2o2qlY
         3qiHh+MxSkbD7CpCZ44UvadIW8i2ZjUx6hTIfldA=
Date:   Wed, 19 Jun 2019 20:36:43 +0200
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
Message-ID: <20190619183643.GB7018@kroah.com>
References: <20190513175521.84955-1-rrangel@chromium.org>
 <20190514091933.GA27269@kroah.com>
 <20190619164625.GA85539@google.com>
 <20190619170917.GC10107@kroah.com>
 <20190619182304.GA98587@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190619182304.GA98587@google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 19, 2019 at 12:23:04PM -0600, Raul Rangel wrote:
> On Wed, Jun 19, 2019 at 07:09:17PM +0200, Greg Kroah-Hartman wrote:
> > On Wed, Jun 19, 2019 at 10:46:25AM -0600, Raul Rangel wrote:
> > > On Tue, May 14, 2019 at 11:19:34AM +0200, Greg Kroah-Hartman wrote:
> > > > On Mon, May 13, 2019 at 11:55:18AM -0600, Raul E Rangel wrote:
> > > > > I think we should cherry-pick 41e3efd07d5a02c80f503e29d755aa1bbb4245de
> > > > > https://lore.kernel.org/patchwork/patch/856512/ into 4.14. It fixes a
> > > > > potential resource leak when shutting down the request queue.
> > > > 
> > > > Potential meaning "it does happen", or "it can happen if we do this", or
> > > > just "maybe it might happen, we really do not know?"
> > > It does happen if the AMD SDHCI patches are cherry-picked into 4.14.
> > > https://lkml.org/lkml/2019/5/1/398
> > 
> > Why are those patches somehow being required to be added to 4.14.y?  If
> > they are not added, is all fine?
> I was just thinking we would backport the patches to fix this AMD SDHCI
> hardware bug, but I guess we don't need to.

Has anyone asked for those to be backported?  Does anyone require them
to be?  What's keeping users from using a newer kernel that have this
specific hardware issue?

Trying to apply patches to a stable kernel due to an issue that is not
even in that stable kernel is crazy.  No wonder I am totally confused...

thanks,

greg k-h
