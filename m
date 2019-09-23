Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30C2ABAE6A
	for <lists+stable@lfdr.de>; Mon, 23 Sep 2019 09:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436593AbfIWHUo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Sep 2019 03:20:44 -0400
Received: from retiisi.org.uk ([95.216.213.190]:49834 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2436537AbfIWHUo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Sep 2019 03:20:44 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2a01:4f9:c010:4572::80:2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 02DA5634C87;
        Mon, 23 Sep 2019 10:19:42 +0300 (EEST)
Received: from sailus by valkosipuli.localdomain with local (Exim 4.92)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1iCIdK-00029L-S1; Mon, 23 Sep 2019 10:19:42 +0300
Date:   Mon, 23 Sep 2019 10:19:42 +0300
From:   Sakari Ailus <sakari.ailus@iki.fi>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.3 084/203] media: omap3isp: Don't set streaming
 state on random subdevs
Message-ID: <20190923071942.GJ5525@valkosipuli.retiisi.org.uk>
References: <20190922184350.30563-1-sashal@kernel.org>
 <20190922184350.30563-84-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190922184350.30563-84-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On Sun, Sep 22, 2019 at 02:41:50PM -0400, Sasha Levin wrote:
> From: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> [ Upstream commit 7ef57be07ac146e70535747797ef4aee0f06e9f9 ]
> 
> The streaming state should be set to the first upstream sub-device only,
> not everywhere, for a sub-device driver itself knows how to best control
> the streaming state of its own upstream sub-devices.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

I don't disagree with this going to the stable trees as well, but in that
case it *must* be accompanied by commit e9eb103f0277 ("media: omap3isp: Set
device on omap3isp subdevs") or the driver will mostly cease to work.

Could you pick that up as well?

Thanks.

-- 
Kind regards,

Sakari Ailus
