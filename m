Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB4FBAE74
	for <lists+stable@lfdr.de>; Mon, 23 Sep 2019 09:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393160AbfIWHZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Sep 2019 03:25:14 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:35982 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389719AbfIWHZO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Sep 2019 03:25:14 -0400
Received: from pendragon.ideasonboard.com (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 2528E51A;
        Mon, 23 Sep 2019 09:25:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1569223512;
        bh=W73OWeyjps5zQDbf4o8klBK6FV6fBTBTuu61y3QjNRI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W8HM36RZnNhOKBVdbAEVUJxROIW10YLs781fqrJLyjDixRMp4nev8nos+W4xtvg/q
         baxHCiSaAeArs9Bi/5RiVQX9JUjJ8p2ETtwhf013Prit9mHkg4bR/c9tmX8Hy/w1Pl
         6clowBhFMoQOuJfLoN1/kooP7ELRPdXHIQt5XTZU=
Date:   Mon, 23 Sep 2019 10:25:03 +0300
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Sakari Ailus <sakari.ailus@iki.fi>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.3 084/203] media: omap3isp: Don't set streaming
 state on random subdevs
Message-ID: <20190923072503.GA5056@pendragon.ideasonboard.com>
References: <20190922184350.30563-1-sashal@kernel.org>
 <20190922184350.30563-84-sashal@kernel.org>
 <20190923071942.GJ5525@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190923071942.GJ5525@valkosipuli.retiisi.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 23, 2019 at 10:19:42AM +0300, Sakari Ailus wrote:
> Hi Sasha,
> 
> On Sun, Sep 22, 2019 at 02:41:50PM -0400, Sasha Levin wrote:
> > From: Sakari Ailus <sakari.ailus@linux.intel.com>
> > 
> > [ Upstream commit 7ef57be07ac146e70535747797ef4aee0f06e9f9 ]
> > 
> > The streaming state should be set to the first upstream sub-device only,
> > not everywhere, for a sub-device driver itself knows how to best control
> > the streaming state of its own upstream sub-devices.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> I don't disagree with this going to the stable trees as well, but in that
> case it *must* be accompanied by commit e9eb103f0277 ("media: omap3isp: Set
> device on omap3isp subdevs") or the driver will mostly cease to work.
> 
> Could you pick that up as well?

While I don't disagree either, I also think there's no requirement to
get this commit backported to stable branches. It seems to be the result
of a too aggressive auto-selection.

-- 
Regards,

Laurent Pinchart
