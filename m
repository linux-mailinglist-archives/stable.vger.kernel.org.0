Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 107AB11EAF0
	for <lists+stable@lfdr.de>; Fri, 13 Dec 2019 20:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728567AbfLMTIB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Dec 2019 14:08:01 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:35490 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728455AbfLMTIB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Dec 2019 14:08:01 -0500
Received: by mail-yw1-f66.google.com with SMTP id i190so290276ywc.2
        for <stable@vger.kernel.org>; Fri, 13 Dec 2019 11:08:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=poorly.run; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=u53//nJmFj2HBNjimHgZzz/H3aQ8IHW4a1APpS8BYfM=;
        b=MY+TQkdaRjVlLRvBizfJDqVPaatex44xkXlQOYb7AAMLUiTs1GaolNIqRwaLS1uTd9
         6ZwZLE4qWu+24JGSEngt6vH27gY2A6kthi9KAyFwP577+lVUFrq81DNFN4A+DmJni6qP
         N155Cs+kaazV9NFMguyMMrkP4eK/QVSTuNlcPGgscSdMoOSnUCuM5sMOyiNYg5ysHin7
         rQgSP6+OYAJaKiJ1ELbTyNrePb5ayIyg8fm/dslZNEAm4b1O/Pzb/E7JkBnTeFwgMLWV
         maS6FYiyXG6+jzVvE8/RZmHifc+ryvb9BWYVT5OEhvC2E13LnpKYekM6+s6cZvTHBE8Q
         +jhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=u53//nJmFj2HBNjimHgZzz/H3aQ8IHW4a1APpS8BYfM=;
        b=lhVT6VDIbLW5yLVJWFmPiRqLksBIL0lpGGKz9HFMui2UXdjRdwy373c07DHprEB/ap
         IqwD6W5YgxAV646ZNiitqUY9IjSBNNEWo4Gl0J95FQZykZDtPviDV1zUEtkfbu4SyXj0
         ha+s+rc/OUvp9dZWcbeYddhqEo7yQGwh+OdIuhGOJFTuuHJI6//7FRcIJnvgA+bPabuy
         Jl9WAAlRYF85Eu2eKM/Jjo7pVH8ZxTK7CSrwTkaiQfFta2oqWbtZdR6IC9jmVAzbvSbI
         5vz5Bu1W1D5AYkgyTcySx5n+wkeqkX5AejHYz2wWqfjUzwDoWtpHX+5kLyUZsmKCpwjn
         8/6A==
X-Gm-Message-State: APjAAAU7tAN+yCIQlQKfA/M29kBL1+pgGRICXzCWgbM72N7/wYtlwYze
        ags5In25XjwjAl3om7liEC+7aA==
X-Google-Smtp-Source: APXvYqxFc2CHCXF5UsXT4xLnxzOdiit2wth1jH63/Sx6XhBDUwTcCUgBkFwlsQt0W6DshPcrFLNBxQ==
X-Received: by 2002:a81:3a06:: with SMTP id h6mr9494402ywa.170.1576264079756;
        Fri, 13 Dec 2019 11:07:59 -0800 (PST)
Received: from localhost ([2620:0:1013:11:1e1:4760:6ce4:fc64])
        by smtp.gmail.com with ESMTPSA id p133sm4527617ywb.71.2019.12.13.11.07.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 11:07:59 -0800 (PST)
Date:   Fri, 13 Dec 2019 14:07:58 -0500
From:   Sean Paul <sean@poorly.run>
To:     Ramalingam C <ramalingam.c@intel.com>
Cc:     Sean Paul <sean@poorly.run>, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, ville.syrjala@linux.intel.com,
        jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
        rodrigo.vivi@intel.com, daniel.vetter@ffwll.ch,
        Sean Paul <seanpaul@chromium.org>,
        Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org
Subject: Re: [PATCH v2 02/12] drm/i915: Clear the repeater bit on HDCP disable
Message-ID: <20191213190758.GG41609@art_vandelay>
References: <20191212190230.188505-1-sean@poorly.run>
 <20191212190230.188505-3-sean@poorly.run>
 <20191213102902.GB3829@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191213102902.GB3829@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 13, 2019 at 03:59:02PM +0530, Ramalingam C wrote:
> On 2019-12-12 at 14:02:20 -0500, Sean Paul wrote:
> > From: Sean Paul <seanpaul@chromium.org>
> > 
> > On HDCP disable, clear the repeater bit. This ensures if we connect a
> > non-repeater sink after a repeater, the bit is in the state we expect.
> > 
> > Fixes: ee5e5e7a5e0f ("drm/i915: Add HDCP framework + base implementation")
> > Cc: Chris Wilson <chris@chris-wilson.co.uk>
> > Cc: Ramalingam C <ramalingam.c@intel.com>
> > Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> > Cc: Sean Paul <seanpaul@chromium.org>
> > Cc: Jani Nikula <jani.nikula@linux.intel.com>
> > Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> > Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
> > Cc: intel-gfx@lists.freedesktop.org
> > Cc: <stable@vger.kernel.org> # v4.17+
> > Signed-off-by: Sean Paul <seanpaul@chromium.org>
> > 
> > Changes in v2:
> > -Added to the set
> > ---
> >  drivers/gpu/drm/i915/display/intel_hdcp.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/drivers/gpu/drm/i915/display/intel_hdcp.c b/drivers/gpu/drm/i915/display/intel_hdcp.c
> > index eaab9008feef..c4394c8e10eb 100644
> > --- a/drivers/gpu/drm/i915/display/intel_hdcp.c
> > +++ b/drivers/gpu/drm/i915/display/intel_hdcp.c
> > @@ -773,6 +773,7 @@ static int _intel_hdcp_disable(struct intel_connector *connector)
> >  	struct intel_digital_port *intel_dig_port = conn_to_dig_port(connector);
> >  	enum port port = intel_dig_port->base.port;
> >  	enum transcoder cpu_transcoder = hdcp->cpu_transcoder;
> > +	u32 repeater_ctl;
> >  	int ret;
> >  
> >  	DRM_DEBUG_KMS("[%s:%d] HDCP is being disabled...\n",
> > @@ -787,6 +788,10 @@ static int _intel_hdcp_disable(struct intel_connector *connector)
> >  		return -ETIMEDOUT;
> >  	}
> >  
> > +	repeater_ctl = intel_hdcp_get_repeater_ctl(dev_priv, cpu_transcoder,
> > +						   port);
> > +	I915_WRITE(HDCP_REP_CTL, I915_READ(HDCP_REP_CTL) & ~repeater_ctl);
> Do you think it will help to (double) clear HDCP_REP_CTL when detect a
> sink which is non repeater!? But yes disable will be executed on all
> HDCP exits.
> 

Yeah, that's probably a better idea. I was a little undecided on where to put it
and I think I settled on the disable path since that matches the way we handle
HDCP signalling. However if we always write REP_CTL, that cuts our callsites
back down to 1, which seems like a Good Thing.

Will revise.

Sean

> > +
> LGTM
> 
> Reviewed-by: Ramalingam C <ramalingam.c@intel.com>
> 
> >  	ret = hdcp->shim->toggle_signalling(intel_dig_port, false);
> >  	if (ret) {
> >  		DRM_ERROR("Failed to disable HDCP signalling\n");
> > -- 
> > Sean Paul, Software Engineer, Google / Chromium OS
> > 

-- 
Sean Paul, Software Engineer, Google / Chromium OS
