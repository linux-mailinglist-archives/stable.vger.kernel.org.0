Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5A6201C3E
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 22:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391899AbgFSUQX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 16:16:23 -0400
Received: from mga12.intel.com ([192.55.52.136]:8244 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391792AbgFSUQT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 16:16:19 -0400
IronPort-SDR: du3JJ5XfUBi6bBe/FTCbmS+VUGIzpXnzpFLN8KDXTdu87pQjyodYIjnV4xH6AgNZBFXSeuqPCz
 T9FXITVCLlIw==
X-IronPort-AV: E=McAfee;i="6000,8403,9657"; a="122814752"
X-IronPort-AV: E=Sophos;i="5.75,256,1589266800"; 
   d="scan'208";a="122814752"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2020 13:16:19 -0700
IronPort-SDR: voIfzF3EYTg3eLuLZL2i1qWEmF/oEZnAVg8LnL5GYhmsrG4475XYQrGVhdFVvui5e78WHjQhLu
 Uh3e52GfQJLg==
X-IronPort-AV: E=Sophos;i="5.75,256,1589266800"; 
   d="scan'208";a="263955101"
Received: from rdvivi-losangeles.jf.intel.com (HELO intel.com) ([10.165.21.202])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2020 13:16:19 -0700
Date:   Fri, 19 Jun 2020 13:14:04 -0700
From:   Rodrigo Vivi <rodrigo.vivi@intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        Swathi Dhanavanthri <swathi.dhanavanthri@intel.com>,
        Rafael Antognolli <rafael.antognolli@intel.com>,
        Matt Roper <matthew.d.roper@intel.com>
Subject: Re: [PATCH] drm/i915/tgl: Make Wa_14010229206 permanent
Message-ID: <20200619201404.GI334084@intel.com>
References: <20200618202701.729-1-rodrigo.vivi@intel.com>
 <20200619080900.GD8425@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200619080900.GD8425@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 19, 2020 at 10:09:00AM +0200, Greg KH wrote:
> On Thu, Jun 18, 2020 at 01:27:00PM -0700, Rodrigo Vivi wrote:
> > From: Swathi Dhanavanthri <swathi.dhanavanthri@intel.com>
> > 
> > commit 63d0f3ea8ebb67160eca281320d255c72b0cb51a upstream.
> > 
> > This workaround now applies to all steppings, not just A0.
> > Wa_1409085225 is a temporary A0-only W/A however it is
> > identical to Wa_14010229206 and hence the combined workaround
> > is made permanent.
> > Bspec: 52890
> > 
> > Signed-off-by: Swathi Dhanavanthri <swathi.dhanavanthri@intel.com>
> > Tested-by: Rafael Antognolli <rafael.antognolli@intel.com>
> > Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
> > [mattrope: added missing blank line]
> > Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
> > Link: https://patchwork.freedesktop.org/patch/msgid/20200326234955.16155-1-swathi.dhanavanthri@intel.com
> > Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
> > ---
> >  drivers/gpu/drm/i915/gt/intel_workarounds.c | 12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> What stable kernel(s) is this backport for?  You need to give us a hint
> :)

It's for 5.7.y only. Sorry for not being clear

> 
> thanks,
> 
> greg k-h
> 
> > 
> > diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
> > index 5176ad1a3976..092a42367851 100644
> > --- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
> > +++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
> > @@ -1379,12 +1379,6 @@ rcs_engine_wa_init(struct intel_engine_cs *engine, struct i915_wa_list *wal)
> >  			    GEN7_FF_THREAD_MODE,
> >  			    GEN12_FF_TESSELATION_DOP_GATE_DISABLE);
> >  
> > -		/*
> > -		 * Wa_1409085225:tgl
> > -		 * Wa_14010229206:tgl
> > -		 */
> > -		wa_masked_en(wal, GEN9_ROW_CHICKEN4, GEN12_DISABLE_TDL_PUSH);
> > -
> >  		/* Wa_1408615072:tgl */
> >  		wa_write_or(wal, UNSLICE_UNIT_LEVEL_CLKGATE2,
> >  			    VSUNIT_CLKGATE_DIS_TGL);
> > @@ -1402,6 +1396,12 @@ rcs_engine_wa_init(struct intel_engine_cs *engine, struct i915_wa_list *wal)
> >  		wa_masked_en(wal,
> >  			     GEN9_CS_DEBUG_MODE1,
> >  			     FF_DOP_CLOCK_GATE_DISABLE);
> > +
> > +		/*
> > +		 * Wa_1409085225:tgl
> > +		 * Wa_14010229206:tgl
> > +		 */
> > +		wa_masked_en(wal, GEN9_ROW_CHICKEN4, GEN12_DISABLE_TDL_PUSH);
> >  	}
> >  
> >  	if (IS_GEN(i915, 11)) {
> > -- 
> > 2.24.1
> > 
