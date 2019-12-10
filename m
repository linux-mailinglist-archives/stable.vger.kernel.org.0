Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F14DC1196F1
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728474AbfLJVaG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:30:06 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:36579 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728454AbfLJVaF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 16:30:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576013404;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DHu5hRwqB3tC0gd9elzTe92YoxL1ejzVp+mWTVGomm8=;
        b=WLerbINJlc2q6fRSJ6P05AUEghs7dsJTv7lLgYoyO0RCJm6d1WacGOujMkBCef7GIL+e9s
        VOpzo8cCFcWQjFiqKVMgMsgncfbVtf2f8kBz5t7Old+2GqKbybfIpeOfo9FFSi85NnRuzi
        AV/ZpFc4TjozBhNcXxlWKyywuWxVtUs=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-HA1PkCaUMp-RtAdh_wuX2Q-1; Tue, 10 Dec 2019 16:30:02 -0500
Received: by mail-qv1-f71.google.com with SMTP id r8so7772035qvp.3
        for <stable@vger.kernel.org>; Tue, 10 Dec 2019 13:30:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=xpN2FnDzTxFXN1g1oq3lTClVwXGfJj+1zSJtFTlzut4=;
        b=kbjSsCELDJRG6QmKWjTuDx3i5fQhuA4D69YVrosxIy4azKWrQnNAuMirdewuenIALY
         VuReVmq97EkqAhKLcPVbrHs7tPpaM34H5TKz6XC/0N1sdMd0BbWFN5p6tupmv8WZqU2q
         6WrU0m8i/CfNNDzmESm7i98shcjHF9+BFLPL4MJA8wRs9oEdj2cB+pe07A61vd9H+p5E
         EIFIXiiqj3UR+saaPZ9iiAILuQshLQ1JSDNMnwE+RDTiPhtXsmmaJSyGJ+Y4FZ7+gN2S
         sKp5dSnUZ9PUnz1ylNQ6wBdLBG6SJMMIPJDCbce24B/w523Hxhyels/fWpwhmrlh/NNo
         egMA==
X-Gm-Message-State: APjAAAUo7WHOm1Z1t7FZMNiq7RHQ78eK4TaMPabLYfSfzBA5KYpcnjKW
        PHN9KNneDOTAg1FZvfGiCPTuFlp00IHqFHndgjyXSie+CBXu9cXxcmj3X+RI1/Fdk6eqv6pquRA
        waGrJIFBWBmnze/6i
X-Received: by 2002:ae9:ea06:: with SMTP id f6mr36300551qkg.246.1576013401552;
        Tue, 10 Dec 2019 13:30:01 -0800 (PST)
X-Google-Smtp-Source: APXvYqw6HfPU/eGOIfyo5HqRG5ep6RNVNFkQBiwi75jTuEdvFpEA7UiCcSPs3KNOxfndMomJWPkDOg==
X-Received: by 2002:ae9:ea06:: with SMTP id f6mr36300538qkg.246.1576013401306;
        Tue, 10 Dec 2019 13:30:01 -0800 (PST)
Received: from dhcp-10-20-1-90.bss.redhat.com ([144.121.20.162])
        by smtp.gmail.com with ESMTPSA id r41sm5405qtr.60.2019.12.10.13.30.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 13:30:00 -0800 (PST)
Message-ID: <90e9126b9692ce6a1b0fcd85a4d0327bf818e58a.camel@redhat.com>
Subject: Re: [PATCH AUTOSEL 5.4 143/350] drm/nouveau: Resume hotplug
 interrupts earlier
From:   Lyude Paul <lyude@redhat.com>
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Juston Li <juston.li@intel.com>, Imre Deak <imre.deak@intel.com>,
        Ville =?ISO-8859-1?Q?Syrj=E4l=E4?= 
        <ville.syrjala@linux.intel.com>, Harry Wentland <hwentlan@amd.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sean Paul <sean@poorly.run>, dri-devel@lists.freedesktop.org,
        nouveau@lists.freedesktop.org
Date:   Tue, 10 Dec 2019 16:29:54 -0500
In-Reply-To: <20191210210735.9077-104-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
         <20191210210735.9077-104-sashal@kernel.org>
Organization: Red Hat
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31)
MIME-Version: 1.0
X-MC-Unique: HA1PkCaUMp-RtAdh_wuX2Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

huh? Not sure how this got put in the stable queue, but this probably shoul=
d
be dropped. this was prepatory work for some MST functionality that got add=
ed
recently, not a fix.

On Tue, 2019-12-10 at 16:04 -0500, Sasha Levin wrote:
> From: Lyude Paul <lyude@redhat.com>
>=20
> [ Upstream commit ac0de16a38a9ec7026ca96132e3883c564497068 ]
>=20
> Currently, we enable hotplug detection only after we re-enable the
> display. However, this is too late if we're planning on sending sideband
> messages during the resume process - which we'll need to do in order to
> reprobe the topology on resume.
>=20
> So, enable hotplug events before reinitializing the display.
>=20
> Cc: Juston Li <juston.li@intel.com>
> Cc: Imre Deak <imre.deak@intel.com>
> Cc: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
> Cc: Harry Wentland <hwentlan@amd.com>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Reviewed-by: Sean Paul <sean@poorly.run>
> Signed-off-by: Lyude Paul <lyude@redhat.com>
> Link:=20
> https://patchwork.freedesktop.org/patch/msgid/20191022023641.8026-11-lyud=
e@redhat.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/gpu/drm/nouveau/nouveau_display.c | 19 +++++++++++--------
>  1 file changed, 11 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/nouveau/nouveau_display.c
> b/drivers/gpu/drm/nouveau/nouveau_display.c
> index 6f038511a03a9..53f9bceaf17a5 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_display.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_display.c
> @@ -407,6 +407,17 @@ nouveau_display_init(struct drm_device *dev, bool
> resume, bool runtime)
>  =09struct drm_connector_list_iter conn_iter;
>  =09int ret;
> =20
> +=09/*
> +=09 * Enable hotplug interrupts (done as early as possible, since we nee=
d
> +=09 * them for MST)
> +=09 */
> +=09drm_connector_list_iter_begin(dev, &conn_iter);
> +=09nouveau_for_each_non_mst_connector_iter(connector, &conn_iter) {
> +=09=09struct nouveau_connector *conn =3D nouveau_connector(connector);
> +=09=09nvif_notify_get(&conn->hpd);
> +=09}
> +=09drm_connector_list_iter_end(&conn_iter);
> +
>  =09ret =3D disp->init(dev, resume, runtime);
>  =09if (ret)
>  =09=09return ret;
> @@ -416,14 +427,6 @@ nouveau_display_init(struct drm_device *dev, bool
> resume, bool runtime)
>  =09 */
>  =09drm_kms_helper_poll_enable(dev);
> =20
> -=09/* enable hotplug interrupts */
> -=09drm_connector_list_iter_begin(dev, &conn_iter);
> -=09nouveau_for_each_non_mst_connector_iter(connector, &conn_iter) {
> -=09=09struct nouveau_connector *conn =3D nouveau_connector(connector);
> -=09=09nvif_notify_get(&conn->hpd);
> -=09}
> -=09drm_connector_list_iter_end(&conn_iter);
> -
>  =09return ret;
>  }
> =20
--=20
Cheers,
=09Lyude Paul

