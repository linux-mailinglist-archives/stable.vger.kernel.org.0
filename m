Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23B1CB94E3
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 18:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389135AbfITQGR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 12:06:17 -0400
Received: from mga14.intel.com ([192.55.52.115]:37282 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387964AbfITQGR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Sep 2019 12:06:17 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Sep 2019 09:06:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,529,1559545200"; 
   d="scan'208";a="178410120"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by orsmga007.jf.intel.com with SMTP; 20 Sep 2019 09:06:12 -0700
Received: by stinkbox (sSMTP sendmail emulation); Fri, 20 Sep 2019 19:06:12 +0300
Date:   Fri, 20 Sep 2019 19:06:12 +0300
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Thierry Reding <thierry.reding@gmail.com>
Cc:     dri-devel@lists.freedesktop.org,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        intel-gfx@lists.freedesktop.org, stable@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Martin Bugge <marbugge@cisco.com>,
        Thierry Reding <treding@nvidia.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] video/hdmi: Fix AVI bar unpack
Message-ID: <20190920160612.GB1208@intel.com>
References: <20190919132853.30954-1-ville.syrjala@linux.intel.com>
 <20190920145853.GA10973@ulmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190920145853.GA10973@ulmo>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 20, 2019 at 04:58:53PM +0200, Thierry Reding wrote:
> On Thu, Sep 19, 2019 at 04:28:53PM +0300, Ville Syrjala wrote:
> > From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > 
> > The bar values are little endian, not big endian. The pack
> > function did it right but the unpack got it wrong. Fix it.
> > 
> > Cc: stable@vger.kernel.org
> > Cc: linux-media@vger.kernel.org
> > Cc: Martin Bugge <marbugge@cisco.com>
> > Cc: Hans Verkuil <hans.verkuil@cisco.com>
> > Cc: Thierry Reding <treding@nvidia.com>
> > Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > Fixes: 2c676f378edb ("[media] hdmi: added unpack and logging functions for InfoFrames")
> > Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > ---
> >  drivers/video/hdmi.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> Reviewed-by: Thierry Reding <treding@nvidia.com>

Thanks. Pushed to drm-misc-next.

-- 
Ville Syrjälä
Intel
