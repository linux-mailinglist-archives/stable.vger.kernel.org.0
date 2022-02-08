Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4E014AE05C
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 19:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376333AbiBHSJS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 13:09:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384560AbiBHSJQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 13:09:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 40814C061578
        for <stable@vger.kernel.org>; Tue,  8 Feb 2022 10:09:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644343755;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D/59mzxAxGpcuRuvJCsAZqxLYdHzeJaGwUP97h2Fvxg=;
        b=fGoCMUE3U3VtJm92FqvvmCrIRGVyLjUoiqK/aNna9XSirzNtzfBVlL7qcuiezlbAWpyW0v
        3BnmwVlbQ/EKrHXikWzYFg7GSruMqLy2CjwBbNpRs5QoI5T0pUsdcuI9+vj3OGosIIrM0E
        Q3/sWwR0742jgu8jzGwFFrhe6GfCzpc=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-86-vY6sBAbEMxe-Qxlsow_Zcw-1; Tue, 08 Feb 2022 13:09:14 -0500
X-MC-Unique: vY6sBAbEMxe-Qxlsow_Zcw-1
Received: by mail-qv1-f72.google.com with SMTP id cs16-20020ad44c50000000b0042bfd7b5158so3970932qvb.3
        for <stable@vger.kernel.org>; Tue, 08 Feb 2022 10:09:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=D/59mzxAxGpcuRuvJCsAZqxLYdHzeJaGwUP97h2Fvxg=;
        b=cXHxCaqWo0/1VEMdFMYIv/EqcZ31b4YCaZs3NxxHscH/Efa2CnFPsqQLgA3PSUngwL
         +SQWVSQlkPdpJXRPlgMz8b8062K/0uAljYa2fDOy5DOJSuIHbqZ2EC7HfGXyaL3x8N4f
         EJ3La3DbmQyxvj+f3Qa+PTqDgyMXNHCXTapnVKdcrsbZUKOg3yg+2CxO/MTLopir+UJh
         fVJBEohwkPl37r7X8PDYAVrM0rf7Onuk4MTQrH8dnkCVy8mvH17OTKKQfI31LwQ4Tazo
         tRRzB8pQIlwIWg5S61pVedc/mhBDXMWzgsFVHntwA5OTqaMhy9kao1zttv+54i+3YZk3
         uDLw==
X-Gm-Message-State: AOAM531nqbvSz/uPxKdlcxF0RB5rLgQDnlQ6egZIZKcHY500IkKlSdDJ
        VaEz4a0hkv7WIWVsUMDXICYT4e45ahvi0VmGgs3AIgssS2yqKmw7hRbHDCK/0LTjt0GtDh+Qor/
        vV6Q0M+KIl5HPJCQt
X-Received: by 2002:a05:6214:2aad:: with SMTP id js13mr4206759qvb.32.1644343753187;
        Tue, 08 Feb 2022 10:09:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx6hYcmhpCrfUjUFKNHPDOzALofgJurmeN1dJb255nAGw0T7FIS2Qoz5AwnzSFbBkPqC8/MWw==
X-Received: by 2002:a05:6214:2aad:: with SMTP id js13mr4206733qvb.32.1644343752985;
        Tue, 08 Feb 2022 10:09:12 -0800 (PST)
Received: from [192.168.8.138] (pool-96-230-100-15.bstnma.fios.verizon.net. [96.230.100.15])
        by smtp.gmail.com with ESMTPSA id s2sm7006656qks.60.2022.02.08.10.09.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 10:09:12 -0800 (PST)
Message-ID: <eaaeecd5c0c80c8bf2ac81c48f603920b0c12248.camel@redhat.com>
Subject: Re: [PATCH] drm/i915/psr: Disable PSR2 selective fetch for all TGL
 steps
From:   Lyude Paul <lyude@redhat.com>
To:     "Souza, Jose" <jose.souza@intel.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>
Cc:     "airlied@linux.ie" <airlied@linux.ie>,
        "ville.syrjala@linux.intel.com" <ville.syrjala@linux.intel.com>,
        "Vivi, Rodrigo" <rodrigo.vivi@intel.com>,
        "joonas.lahtinen@linux.intel.com" <joonas.lahtinen@linux.intel.com>,
        "Mun, Gwan-gyeong" <gwan-gyeong.mun@intel.com>,
        "Roper, Matthew D" <matthew.d.roper@intel.com>,
        "tvrtko.ursulin@linux.intel.com" <tvrtko.ursulin@linux.intel.com>,
        "Kahola, Mika" <mika.kahola@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "jani.nikula@linux.intel.com" <jani.nikula@linux.intel.com>,
        "daniel@ffwll.ch" <daniel@ffwll.ch>,
        "Hogander, Jouni" <jouni.hogander@intel.com>,
        "De Marchi, Lucas" <lucas.demarchi@intel.com>
Date:   Tue, 08 Feb 2022 13:09:10 -0500
In-Reply-To: <47eed687da699a6abbfd7726439fd307786c9d93.camel@intel.com>
References: <20220207213923.3605-1-lyude@redhat.com>
         <47eed687da699a6abbfd7726439fd307786c9d93.camel@intel.com>
Organization: Red Hat Inc.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2022-02-08 at 13:06 +0000, Souza, Jose wrote:
> On Mon, 2022-02-07 at 16:38 -0500, Lyude Paul wrote:
> > As we've unfortunately started to come to expect from PSR on Intel
> > platforms, PSR2 selective fetch is not at all ready to be enabled on
> > Tigerlake as it results in severe flickering issues - at least on this
> > ThinkPad X1 Carbon 9th generation. The easiest way I've found of
> > reproducing these issues is to just move the cursor around the left border
> > of the screen (suspicious…).
> 
> Where is the bug for that? Where is the logs?

I'm happy to open up a bug and include some logs, will do it in just a moment

> We can't go from enabled to disabled without any debug and because of a
> single device.
> In the mean time you have the option to set the i915 parameter to disable
> it.

I mean - I totally understand the hesistance with the lack of debug info, I'll
go open up an issue with said info in a bit. FWIW is a machine currently being
sold with Linux pre-installs which is expected to work out of the box, so it's
not exactly an uncommon laptop to be running Linux. Also I don't have any
problem with us trying to fix the issue before flat out disabling things - I
sent the revert hoping that would happen, and also because I needed to write
the revert anyway since I had to disable this in Fedora's kernel.

> 
> > 
> > So, fix people's displays again and turn PSR2 selective fetch off for all
> > steppings of Tigerlake. This can be re-enabled again if someone from Intel
> > finds the time to fix this functionality on OEM machines.
> > 
> > Signed-off-by: Lyude Paul <lyude@redhat.com>
> > Fixes: 7f6002e58025 ("drm/i915/display: Enable PSR2 selective fetch by
> > default")
> > Cc: Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>
> > Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > Cc: José Roberto de Souza <jose.souza@intel.com>
> > Cc: Jani Nikula <jani.nikula@linux.intel.com>
> > Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
> > Cc: intel-gfx@lists.freedesktop.org
> > Cc: <stable@vger.kernel.org> # v5.16+
> > ---
> >  drivers/gpu/drm/i915/display/intel_psr.c | 10 +++++++---
> >  1 file changed, 7 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/i915/display/intel_psr.c
> > b/drivers/gpu/drm/i915/display/intel_psr.c
> > index a1a663f362e7..25c16abcd9cd 100644
> > --- a/drivers/gpu/drm/i915/display/intel_psr.c
> > +++ b/drivers/gpu/drm/i915/display/intel_psr.c
> > @@ -737,10 +737,14 @@ static bool intel_psr2_sel_fetch_config_valid(struct
> > intel_dp *intel_dp,
> >                 return false;
> >         }
> >  
> > -       /* Wa_14010254185 Wa_14010103792 */
> > -       if (IS_TGL_DISPLAY_STEP(dev_priv, STEP_A0, STEP_C0)) {
> > +       /*
> > +        * There's two things stopping this from being enabled on TGL:
> > +        * For steps A0-C0: workarounds Wa_14010254185 Wa_14010103792 are
> > missing
> > +        * For all steps: PSR2 selective fetch causes screen flickering
> > +        */
> > +       if (IS_TIGERLAKE(dev_priv)) {
> >                 drm_dbg_kms(&dev_priv->drm,
> > -                           "PSR2 sel fetch not enabled, missing the
> > implementation of WAs\n");
> > +                           "PSR2 sel fetch not enabled, currently broken
> > on TGL\n");
> >                 return false;
> >         }
> >  
> 

-- 
Cheers,
 Lyude Paul (she/her)
 Software Engineer at Red Hat

