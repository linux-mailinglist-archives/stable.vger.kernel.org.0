Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEBEA38E99
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728724AbfFGPK0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:10:26 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:39730 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729875AbfFGPK0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jun 2019 11:10:26 -0400
Received: by mail-ed1-f65.google.com with SMTP id m10so3499281edv.6
        for <stable@vger.kernel.org>; Fri, 07 Jun 2019 08:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=x8tgX7GxOWk4zkmfV9eOh7llWMCmcqIg/K0VpKzqFHc=;
        b=bLCcGrQbnNLVOggqGnU2+2vr2zijK5I3m6mQVTvTJBQfakPw7HwC/03QFiS/PCMolZ
         MI5j2av4X4dHRbisnuy5VcyqZgf6B82xv+aRZ7F0n4LjRbrVx51Pdc9K8Sfs19z9rC2x
         /vQpzg37Plu1NadO2qPBNTBOQmmaml4MZOGHw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=x8tgX7GxOWk4zkmfV9eOh7llWMCmcqIg/K0VpKzqFHc=;
        b=fOo7sZf/uTMv0dznwt3cSO6blk7eYcoqeoStM0g9tKExTxBPI5e/3U/0vyc+L4+Kak
         1v/DLZ+d40PAZGGix4vCYTsgLFL+3u5//UizhmMvuVZFAOMAtNYNQug2MwR5ikP8lmTC
         Eg3MO3CW9gnZtFloGGz8EUa0KPlGRBEIkAma/d4zBD++VX+RBiMj+cA175+3yizkk6jA
         js4uIhGhhE6tCq8D3qtNdTWnvmAYH1tFfOcDoAeyS2MQlQIQgO55pTkOHWgY8W3cZzUS
         /VaSMuia7xCa7hNGI4hqe2jHHg0d4IJYW24IV2/dydcj2ettgu+et9V7coZV6tRzwJ/I
         s8Vg==
X-Gm-Message-State: APjAAAVx0zilk4EZHsqQIW3eb8GQrqbapemF9Uw3H+/CTm3bcwFHRf6S
        RzmBOKpHEt6rySZpc+xQi5YzUKi95nY=
X-Google-Smtp-Source: APXvYqzk6Nj13tec5Eq8pnk5r8g21UTe2h9jirlV97a+URiIIR9NI1OyympteOxPHlh3s2N/nz37Ow==
X-Received: by 2002:a17:906:5399:: with SMTP id g25mr31629549ejo.247.1559920224318;
        Fri, 07 Jun 2019 08:10:24 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:569e:0:3106:d637:d723:e855])
        by smtp.gmail.com with ESMTPSA id t3sm424749ejk.56.2019.06.07.08.10.23
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 07 Jun 2019 08:10:23 -0700 (PDT)
Date:   Fri, 7 Jun 2019 17:10:21 +0200
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Jani Nikula <jani.nikula@intel.com>
Cc:     intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Paul Wise <pabs3@bonedaddy.net>,
        Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@cs.helsinki.fi>,
        stable@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Ville =?iso-8859-1?Q?Syrj=E4l=E4?= 
        <ville.syrjala@linux.intel.com>,
        Harish Chegondi <harish.chegondi@intel.com>
Subject: Re: [PATCH 2/2] drm: add fallback override/firmware EDID modes
 workaround
Message-ID: <20190607151021.GJ21222@phenom.ffwll.local>
References: <20190607110513.12072-1-jani.nikula@intel.com>
 <20190607110513.12072-2-jani.nikula@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190607110513.12072-2-jani.nikula@intel.com>
X-Operating-System: Linux phenom 4.14.0-3-amd64 
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 07, 2019 at 02:05:13PM +0300, Jani Nikula wrote:
> We've moved the override and firmware EDID (simply "override EDID" from
> now on) handling to the low level drm_do_get_edid() function in order to
> transparently use the override throughout the stack. The idea is that
> you get the override EDID via the ->get_modes() hook.
> 
> Unfortunately, there are scenarios where the DDC probe in drm_get_edid()
> called via ->get_modes() fails, although the preceding ->detect()
> succeeds.
> 
> In the case reported by Paul Wise, the ->detect() hook,
> intel_crt_detect(), relies on hotplug detect, bypassing the DDC. In the
> case reported by Ilpo Järvinen, there is no ->detect() hook, which is
> interpreted as connected. The subsequent DDC probe reached via
> ->get_modes() fails, and we don't even look at the override EDID,
> resulting in no modes being added.
> 
> Because drm_get_edid() is used via ->detect() all over the place, we
> can't trivially remove the DDC probe, as it leads to override EDID
> effectively meaning connector forcing. The goal is that connector
> forcing and override EDID remain orthogonal.
> 
> Generally, the underlying problem here is the conflation of ->detect()
> and ->get_modes() via drm_get_edid(). The former should just detect, and
> the latter should just get the modes, typically via reading the EDID. As
> long as drm_get_edid() is used in ->detect(), it needs to retain the DDC
> probe. Or such users need to have a separate DDC probe step first.
> 
> Work around the regression by falling back to a separate attempt at
> getting the override EDID at drm_helper_probe_single_connector_modes()
> level. With a working DDC and override EDID, it'll never be called; the
> override EDID will come via ->get_modes(). There will still be a failing
> DDC probe attempt in the cases that require the fallback.

I think we should also highlight here that EDID caching between ->detect
and ->get_modes is a further complicating concern, which is why making
drm_do_get_edid magically dtrt between ->detect and ->get_modes doesn't
work either.

Aside from that nit I think this covers our lengthy discussion completely.

> Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=107583
> Reported-by: Paul Wise <pabs3@bonedaddy.net>
> Cc: Paul Wise <pabs3@bonedaddy.net>
> References: http://mid.mail-archive.com/alpine.DEB.2.20.1905262211270.24390@whs-18.cs.helsinki.fi
> Reported-by: Ilpo Järvinen <ilpo.jarvinen@cs.helsinki.fi>
> Cc: Ilpo Järvinen <ilpo.jarvinen@cs.helsinki.fi>
> References: 15f080f08d48 ("drm/edid: respect connector force for drm_get_edid ddc probe")
> Fixes: 53fd40a90f3c ("drm: handle override and firmware EDID at drm_do_get_edid() level")
> Cc: <stable@vger.kernel.org> # v4.15+
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
> Cc: Harish Chegondi <harish.chegondi@intel.com>
> Signed-off-by: Jani Nikula <jani.nikula@intel.com>

As discussed on irc, we need tested-by here from the reporters since
there's way too many losing and frustrangingly few winning moves here.

With all that, on the series:

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>

Thanks a lot for slogging through all this and pondering all the options
and implications!

Cheers, Daniel
> ---
>  drivers/gpu/drm/drm_edid.c         | 29 +++++++++++++++++++++++++++++
>  drivers/gpu/drm/drm_probe_helper.c |  7 +++++++
>  include/drm/drm_edid.h             |  1 +
>  3 files changed, 37 insertions(+)
> 
> diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
> index c59a1e8c5ada..780146bfc225 100644
> --- a/drivers/gpu/drm/drm_edid.c
> +++ b/drivers/gpu/drm/drm_edid.c
> @@ -1587,6 +1587,35 @@ static struct edid *drm_get_override_edid(struct drm_connector *connector)
>  	return IS_ERR(override) ? NULL : override;
>  }
>  
> +/**
> + * drm_add_override_edid_modes - add modes from override/firmware EDID
> + * @connector: connector we're probing
> + *
> + * Add modes from the override/firmware EDID, if available. Only to be used from
> + * drm_helper_probe_single_connector_modes() as a fallback for when DDC probe
> + * failed during drm_get_edid() and caused the override/firmware EDID to be
> + * skipped.
> + *
> + * Return: The number of modes added or 0 if we couldn't find any.
> + */
> +int drm_add_override_edid_modes(struct drm_connector *connector)
> +{
> +	struct edid *override;
> +	int num_modes = 0;
> +
> +	override = drm_get_override_edid(connector);
> +	if (override) {
> +		num_modes = drm_add_edid_modes(connector, override);
> +		kfree(override);
> +
> +		DRM_DEBUG_KMS("[CONNECTOR:%d:%s] adding %d modes via fallback override/firmware EDID\n",
> +			      connector->base.id, connector->name, num_modes);
> +	}
> +
> +	return num_modes;
> +}
> +EXPORT_SYMBOL(drm_add_override_edid_modes);
> +
>  /**
>   * drm_do_get_edid - get EDID data using a custom EDID block read function
>   * @connector: connector we're probing
> diff --git a/drivers/gpu/drm/drm_probe_helper.c b/drivers/gpu/drm/drm_probe_helper.c
> index 01e243f1ea94..ef2c468205a2 100644
> --- a/drivers/gpu/drm/drm_probe_helper.c
> +++ b/drivers/gpu/drm/drm_probe_helper.c
> @@ -480,6 +480,13 @@ int drm_helper_probe_single_connector_modes(struct drm_connector *connector,
>  
>  	count = (*connector_funcs->get_modes)(connector);
>  
> +	/*
> +	 * Fallback for when DDC probe failed in drm_get_edid() and thus skipped
> +	 * override/firmware EDID.
> +	 */
> +	if (count == 0 && connector->status == connector_status_connected)
> +		count = drm_add_override_edid_modes(connector);
> +
>  	if (count == 0 && connector->status == connector_status_connected)
>  		count = drm_add_modes_noedid(connector, 1024, 768);
>  	count += drm_helper_probe_add_cmdline_mode(connector);
> diff --git a/include/drm/drm_edid.h b/include/drm/drm_edid.h
> index 88b63801f9db..b9719418c3d2 100644
> --- a/include/drm/drm_edid.h
> +++ b/include/drm/drm_edid.h
> @@ -478,6 +478,7 @@ struct edid *drm_get_edid_switcheroo(struct drm_connector *connector,
>  				     struct i2c_adapter *adapter);
>  struct edid *drm_edid_duplicate(const struct edid *edid);
>  int drm_add_edid_modes(struct drm_connector *connector, struct edid *edid);
> +int drm_add_override_edid_modes(struct drm_connector *connector);
>  
>  u8 drm_match_cea_mode(const struct drm_display_mode *to_match);
>  enum hdmi_picture_aspect drm_get_cea_aspect_ratio(const u8 video_code);
> -- 
> 2.20.1
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
