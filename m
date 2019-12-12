Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD3F111CEB6
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 14:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729470AbfLLNsW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 08:48:22 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:49670 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729425AbfLLNsW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Dec 2019 08:48:22 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 1EEFF1C25CE; Thu, 12 Dec 2019 14:48:20 +0100 (CET)
Date:   Thu, 12 Dec 2019 14:48:20 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg KH <greg@kroah.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Ricardo Ribalda Delgado <ribalda@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.4 148/350] media: ad5820: Define entity function
Message-ID: <20191212134820.yfwkamocjxumz6ci@ucw.cz>
References: <20191210210735.9077-1-sashal@kernel.org>
 <20191210210735.9077-109-sashal@kernel.org>
 <20191212121938.GB17876@duo.ucw.cz>
 <20191212122437.GA1541615@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212122437.GA1541615@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Thu, Dec 12, 2019 at 01:19:38PM +0100, Pavel Machek wrote:
> > On Tue 2019-12-10 16:04:13, Sasha Levin wrote:
> > > From: Ricardo Ribalda Delgado <ribalda@kernel.org>
> > > 
> > > [ Upstream commit 801ef7c4919efba6b96b5aed1e72844ca69e26d3 ]
> > > 
> > > Without this patch, media_device_register_entity throws a warning:
> > > 
> > > dev_warn(mdev->dev,
> > > 	 "Entity type for entity %s was not initialized!\n",
> > > 	 entity->name);
> > 
> > This fixes warning, not a serious bug. Thus it is against stable
> > rules.
> 
> That's a good enough fix for a real issue.  We take patches in stable
> for this all the time.

I know you do this all the time...

But that's not what the documentation says you should be doing!

 - It must fix a problem that causes a build error (but not for things
    marked CONFIG_BROKEN), an oops, a hang, data corruption, a real
       security issue, or some "oh, that's not good" issue.  In short,
       something
          critical.

I'd prefer you to act as the documentation says you would, but even
just fixing the documentation would be improvement over current
situation.

Thanks,
								Pavel
