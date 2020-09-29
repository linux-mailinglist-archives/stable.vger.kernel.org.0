Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E27BD27BDE7
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 09:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725787AbgI2HXr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 03:23:47 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:56528 "EHLO
        asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbgI2HXr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Sep 2020 03:23:47 -0400
X-Greylist: delayed 347 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Sep 2020 03:23:46 EDT
Received: from ravnborg.org (unknown [188.228.123.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by asavdk4.altibox.net (Postfix) with ESMTPS id 08D27804E5;
        Tue, 29 Sep 2020 09:17:55 +0200 (CEST)
Date:   Tue, 29 Sep 2020 09:17:54 +0200
From:   Sam Ravnborg <sam@ravnborg.org>
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     dri-devel@lists.freedesktop.org, Heiko Stuebner <heiko@sntech.de>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        Sandy Huang <hjc@rock-chips.com>, stable@vger.kernel.org
Subject: Re: [PATCH v1 1/2] drm/rockchip: fix build due to undefined
 drm_gem_cma_vm_ops
Message-ID: <20200929071754.GA736868@ravnborg.org>
References: <20200925215524.2899527-1-sam@ravnborg.org>
 <20200925215524.2899527-2-sam@ravnborg.org>
 <83650213-3b09-aea0-4485-cd20de1d9548@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <83650213-3b09-aea0-4485-cd20de1d9548@suse.de>
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.3 cv=A5ZCwZeG c=1 sm=1 tr=0
        a=S6zTFyMACwkrwXSdXUNehg==:117 a=S6zTFyMACwkrwXSdXUNehg==:17
        a=IkcTkHD0fZMA:10 a=7gkXJVJtAAAA:8 a=nVws210Im4UeU8Tq7v4A:9
        a=QEXdDO2ut3YA:10 a=E9Po1WZjFZOl8hwRPBS3:22
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 29, 2020 at 08:53:06AM +0200, Thomas Zimmermann wrote:
> Hi Sam
> 
> Am 25.09.20 um 23:55 schrieb Sam Ravnborg:
> > Commit 0d590af3140d ("drm/rockchip: Convert to drm_gem_object_funcs")
> > introduced the following build error:
> > 
> > rockchip_drm_gem.c:304:13: error: ‘drm_gem_cma_vm_ops’ undeclared here
> >   304 |  .vm_ops = &drm_gem_cma_vm_ops,
> >       |             ^~~~~~~~~~~~~~~~~~
> >       |             drm_gem_mmap_obj
> > 
> > Fixed by adding missing include file.
> > 
> > Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> 
> Didn't you review exactly this change yesterday? Anyway, you should add
Yep.

> 
> Fixes: 0d590af3140d ("drm/rockchip: Convert to drm_gem_object_funcs")
> 
> and
> 
> Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
> 
> It might happen that I land my patch first, depending on the urgency of
> the issue.
I expect you to land the patch you made asap so we can have the build
fixed again.


	Sam
