Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10D62501CE7
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 22:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235877AbiDNUqv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 16:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243651AbiDNUqu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 16:46:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A91F1FD7
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 13:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649969061;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JmaAlHIjXef9NYKFArMf2KanmEfiFR7sku0+K1UQU60=;
        b=IsSert9F117pUqgv2BFu2XbbzAlCH7EMK+DjdhgnNiPbfHXOGgTFbYKLFiLjlQSKIcAqFv
        1DZAokG1Yopyjr3YiJpffm5BjIRvqwNQk7SZMKQ282pIMuk6SFvuc2kLJEIrDaZ10l8pp8
        vKfrGGbDUHppyFfVyvJxhm74iOPsk/Q=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-635-Bms_T7zUOLC6RfKX_mk5Zw-1; Thu, 14 Apr 2022 16:44:20 -0400
X-MC-Unique: Bms_T7zUOLC6RfKX_mk5Zw-1
Received: by mail-qv1-f69.google.com with SMTP id p3-20020a05621421e300b0044427d0ab90so5332420qvj.17
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 13:44:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=JmaAlHIjXef9NYKFArMf2KanmEfiFR7sku0+K1UQU60=;
        b=PUiIGfVEkhq5c4kxcgChtiL8AS4CPmm6Tm6sDbWyDnpVsRhUfTKG8keuGezRZmRKPf
         ibJWz2UywfDTglvjDP1jpELuGN0dKruqeulKVM1lUs9lfXlyJbW5G7NFsF8S3oaQaHy4
         tNsYsSjoKeJt3MWfne0pcL20w+702+tWWmyDgCbd8WXUnmvcNXlyqf27centOIUA6S2b
         N2mcOgEqF63Q7ksrBXgz6FjzUZooialXOGmDjg0aJ2WqUChRurr/BW0IfbBQOLcJKJ63
         xfvEySlMEYle/Il1c8Et/Ahv0qvsH9qislYdWEmptiAk5zhU84Ij3zqeC5MgSM+hJ1bN
         Q6ZA==
X-Gm-Message-State: AOAM532Ht8dO0XGCzXvuXDUseQmQTKmTmTNO6SYc5vBksRueamH5QuF3
        7u54U0t4g7MJpZOsxipUyqElqbk1Iq/rgh1BIt32jKGxsl93U8H876owCSFXfFh7u4756Jx8YK9
        9dDxbpYIgjf8lKklu
X-Received: by 2002:a05:620a:248f:b0:69c:2e80:2194 with SMTP id i15-20020a05620a248f00b0069c2e802194mr3268044qkn.548.1649969060118;
        Thu, 14 Apr 2022 13:44:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyQcJDfigohvjOM0rvDKHhHPaYBHGLfiTsCTHJVvIUQb2SQ4FwWN3GNCwMtOk9NUuahtr2caQ==
X-Received: by 2002:a05:620a:248f:b0:69c:2e80:2194 with SMTP id i15-20020a05620a248f00b0069c2e802194mr3268035qkn.548.1649969059919;
        Thu, 14 Apr 2022 13:44:19 -0700 (PDT)
Received: from [192.168.8.138] (pool-71-126-244-162.bstnma.fios.verizon.net. [71.126.244.162])
        by smtp.gmail.com with ESMTPSA id x20-20020a05622a001400b002f04bcd1e55sm1866390qtw.70.2022.04.14.13.44.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 13:44:19 -0700 (PDT)
Message-ID: <ac1c0383b20eeec0f86e439d4889a55fcbf8cd4e.camel@redhat.com>
Subject: Re: [PATCH v2] drm/i915: Check EDID for HDR static metadata when
 choosing blc
From:   Lyude Paul <lyude@redhat.com>
To:     Jouni =?ISO-8859-1?Q?H=F6gander?= <jouni.hogander@intel.com>,
        intel-gfx@lists.freedesktop.org
Cc:     Mika Kahola <mika.kahola@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Filippo Falezza <filippo.falezza@outlook.it>,
        stable@vger.kernel.org
Date:   Thu, 14 Apr 2022 16:44:13 -0400
In-Reply-To: <20220413082826.120634-1-jouni.hogander@intel.com>
References: <20220413082826.120634-1-jouni.hogander@intel.com>
Organization: Red Hat Inc.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Reviewed-by: Lyude Paul <lyude@redhat.com>

On Wed, 2022-04-13 at 11:28 +0300, Jouni Högander wrote:
> We have now seen panel (XMG Core 15 e21 laptop) advertizing support
> for Intel proprietary eDP backlight control via DPCD registers, but
> actually working only with legacy pwm control.
> 
> This patch adds panel EDID check for possible HDR static metadata and
> Intel proprietary eDP backlight control is used only if that exists.
> Missing HDR static metadata is ignored if user specifically asks for
> Intel proprietary eDP backlight control via enable_dpcd_backlight
> parameter.
> 
> v2 :
> - Ignore missing HDR static metadata if Intel proprietary eDP
>   backlight control is forced via i915.enable_dpcd_backlight
> - Printout info message if panel is missing HDR static metadata and
>   support for Intel proprietary eDP backlight control is detected
> 
> Fixes: 4a8d79901d5b ("drm/i915/dp: Enable Intel's HDR backlight interface
> (only SDR for now)")
> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/5284
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: Mika Kahola <mika.kahola@intel.com>
> Cc: Jani Nikula <jani.nikula@intel.com>
> Cc: Filippo Falezza <filippo.falezza@outlook.it>
> Cc: stable@vger.kernel.org
> Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
> ---
>  .../drm/i915/display/intel_dp_aux_backlight.c | 34 ++++++++++++++-----
>  1 file changed, 26 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c
> b/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c
> index 97cf3cac0105..fb6cf30ee628 100644
> --- a/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c
> +++ b/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c
> @@ -97,6 +97,14 @@
>  
>  #define INTEL_EDP_BRIGHTNESS_OPTIMIZATION_1                           
> 0x359
>  
> +enum intel_dp_aux_backlight_modparam {
> +       INTEL_DP_AUX_BACKLIGHT_AUTO = -1,
> +       INTEL_DP_AUX_BACKLIGHT_OFF = 0,
> +       INTEL_DP_AUX_BACKLIGHT_ON = 1,
> +       INTEL_DP_AUX_BACKLIGHT_FORCE_VESA = 2,
> +       INTEL_DP_AUX_BACKLIGHT_FORCE_INTEL = 3,
> +};
> +
>  /* Intel EDP backlight callbacks */
>  static bool
>  intel_dp_aux_supports_hdr_backlight(struct intel_connector *connector)
> @@ -126,6 +134,24 @@ intel_dp_aux_supports_hdr_backlight(struct
> intel_connector *connector)
>                 return false;
>         }
>  
> +       /*
> +        * If we don't have HDR static metadata there is no way to
> +        * runtime detect used range for nits based control. For now
> +        * do not use Intel proprietary eDP backlight control if we
> +        * don't have this data in panel EDID. In case we find panel
> +        * which supports only nits based control, but doesn't provide
> +        * HDR static metadata we need to start maintaining table of
> +        * ranges for such panels.
> +        */
> +       if (i915->params.enable_dpcd_backlight !=
> INTEL_DP_AUX_BACKLIGHT_FORCE_INTEL &&
> +           !(connector->base.hdr_sink_metadata.hdmi_type1.metadata_type &
> +             BIT(HDMI_STATIC_METADATA_TYPE1))) {
> +               drm_info(&i915->drm,
> +                        "Panel is missing HDR static metadata. Possible
> support for Intel HDR backlight interface is not used. If your backlight
> controls don't work try booting with i915.enable_dpcd_backlight=%d. needs
> this, please file a _new_ bug report on drm/i915, see " FDO_BUG_URL " for
> details.\n",
> +                        INTEL_DP_AUX_BACKLIGHT_FORCE_INTEL);
> +               return false;
> +       }
> +
>         panel->backlight.edp.intel.sdr_uses_aux =
>                 tcon_cap[2] & INTEL_EDP_SDR_TCON_BRIGHTNESS_AUX_CAP;
>  
> @@ -413,14 +439,6 @@ static const struct intel_panel_bl_funcs
> intel_dp_vesa_bl_funcs = {
>         .get = intel_dp_aux_vesa_get_backlight,
>  };
>  
> -enum intel_dp_aux_backlight_modparam {
> -       INTEL_DP_AUX_BACKLIGHT_AUTO = -1,
> -       INTEL_DP_AUX_BACKLIGHT_OFF = 0,
> -       INTEL_DP_AUX_BACKLIGHT_ON = 1,
> -       INTEL_DP_AUX_BACKLIGHT_FORCE_VESA = 2,
> -       INTEL_DP_AUX_BACKLIGHT_FORCE_INTEL = 3,
> -};
> -
>  int intel_dp_aux_init_backlight_funcs(struct intel_connector *connector)
>  {
>         struct drm_device *dev = connector->base.dev;

-- 
Cheers,
 Lyude Paul (she/her)
 Software Engineer at Red Hat

