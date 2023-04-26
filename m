Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFD716EEC7F
	for <lists+stable@lfdr.de>; Wed, 26 Apr 2023 04:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239047AbjDZCss (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 22:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239031AbjDZCsr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 22:48:47 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FCFBE4E;
        Tue, 25 Apr 2023 19:48:45 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-9594916df23so98781066b.1;
        Tue, 25 Apr 2023 19:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682477324; x=1685069324;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=luIBezxVj8vjsN8taNGI10NmyK3fPLG8Q9qSFZe7gVg=;
        b=ry1w73aKJZhF+mw0bkTlPfi3NbHr2/r5LIV+7uuHtOZw2S0AU5hZV6agpBs5LVE9DE
         oUbO/kvBh69w2pol++Z8lg1MonDRS7VNSnk/gX0ceyn/HkDMTvUm3UYG1mtgj+aBEWXl
         Yu23ATANopFyLcA5MwyfFQ/QAdVRRLffuXKnL5majIbPm+81MjCV2nGreqsz5tYSm5k6
         fELHB8SOyEOSNAg8R+qnj4TQyhJ04k1q6bhS0V8FXDr4fhPoRzxwL6PY7WkgZcfy4VYf
         H8YbrOp1rC9t8FiKhzzQ1wWc9LBSupPu4zojUkO9IA5NtinbqIOXyEW+zibRrAlezp/n
         HEkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682477324; x=1685069324;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=luIBezxVj8vjsN8taNGI10NmyK3fPLG8Q9qSFZe7gVg=;
        b=Dg+x1lwvB93fcBZ630xYKwVX7jwq2xhKGvbl1y9p7Q5Esw5lfmaALDwk1n5MfZwUiG
         6TZcUKtRZtdsk6lV3eEYxE1CE0j2cOjAhIA+EDSF0byU/iO5bqmSs0/3eZZgjV3pKl99
         mv2/eGDlAvobfCuyLv1T/PsX5j1PMAmQSoN0YUEnY5xjE5qwY2sc0BRdOPQewzBxWUW8
         6YPgOnCM3RGvMi1Zf0jrU254xi4IVF50pl4zF3o6DXXMpPXm9wvTZCs2UWdzdlrMNmbK
         Yi95E89+aikOOKgmfjCop/TqDCGSZqiVv04IXPD4mvWtWLSP46w4jHZDHHcUBkoiAtrl
         RuEA==
X-Gm-Message-State: AAQBX9dc7SOeNRVkr9PamSTUkmeLQU1ro2i1ZJQYYl4oE6+hXx3bWLZy
        ebeF6gNqNVbo9B/+78K8iWKnzTkXBsqHJBGIr7iDWpdd0Gs=
X-Google-Smtp-Source: AKy350ah10QfjHhR3RthnizYYdfMX/dVDPe92W7VgE61H/ui8jl13kTYbQo4YMuGTSjZrMGEVf9Gvgn7D7dF7fy00yk=
X-Received: by 2002:a17:907:2087:b0:930:7f40:c1bb with SMTP id
 pv7-20020a170907208700b009307f40c1bbmr15743065ejb.4.1682477323728; Tue, 25
 Apr 2023 19:48:43 -0700 (PDT)
MIME-Version: 1.0
References: <20230426004831.650908-1-olvaffe@gmail.com> <BL0PR12MB2465ACA3AC6D8CCDFA043239F1659@BL0PR12MB2465.namprd12.prod.outlook.com>
In-Reply-To: <BL0PR12MB2465ACA3AC6D8CCDFA043239F1659@BL0PR12MB2465.namprd12.prod.outlook.com>
From:   Chia-I Wu <olvaffe@gmail.com>
Date:   Tue, 25 Apr 2023 19:48:32 -0700
Message-ID: <CAPaKu7SA5wWrwdP6MQvDu=3qH-QCH_iUFASmDY-VYxnrXn=2zg@mail.gmail.com>
Subject: Re: [PATCH] drm/amdgpu: add a missing lock for AMDGPU_SCHED
To:     "Chen, Guchun" <Guchun.Chen@amd.com>
Cc:     "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        David Airlie <airlied@gmail.com>,
        "Koenig, Christian" <Christian.Koenig@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 25, 2023 at 7:27=E2=80=AFPM Chen, Guchun <Guchun.Chen@amd.com> =
wrote:
>
> From coding style's perspective, this lock/unlock handling should be put =
into amdgpu_ctx_priority_override.
The locking is to protect mgr->ctx_handles.
>
> Regards,
> Guchun
>
> > -----Original Message-----
> > From: amd-gfx <amd-gfx-bounces@lists.freedesktop.org> On Behalf Of Chia=
-
> > I Wu
> > Sent: Wednesday, April 26, 2023 8:48 AM
> > To: dri-devel@lists.freedesktop.org
> > Cc: Pan, Xinhui <Xinhui.Pan@amd.com>; linux-kernel@vger.kernel.org;
> > stable@vger.kernel.org; amd-gfx@lists.freedesktop.org; Daniel Vetter
> > <daniel@ffwll.ch>; Deucher, Alexander <Alexander.Deucher@amd.com>;
> > David Airlie <airlied@gmail.com>; Koenig, Christian
> > <Christian.Koenig@amd.com>
> > Subject: [PATCH] drm/amdgpu: add a missing lock for AMDGPU_SCHED
> >
> > Signed-off-by: Chia-I Wu <olvaffe@gmail.com>
> > Cc: stable@vger.kernel.org
> > ---
> >  drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c
> > b/drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c
> > index e9b45089a28a6..863b2a34b2d64 100644
> > --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c
> > +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c
> > @@ -38,6 +38,7 @@ static int
> > amdgpu_sched_process_priority_override(struct amdgpu_device *adev,  {
> >       struct fd f =3D fdget(fd);
> >       struct amdgpu_fpriv *fpriv;
> > +     struct amdgpu_ctx_mgr *mgr;
> >       struct amdgpu_ctx *ctx;
> >       uint32_t id;
> >       int r;
> > @@ -51,8 +52,11 @@ static int
> > amdgpu_sched_process_priority_override(struct amdgpu_device *adev,
> >               return r;
> >       }
> >
> > -     idr_for_each_entry(&fpriv->ctx_mgr.ctx_handles, ctx, id)
> > +     mgr =3D &fpriv->ctx_mgr;
> > +     mutex_lock(&mgr->lock);
> > +     idr_for_each_entry(&mgr->ctx_handles, ctx, id)
> >               amdgpu_ctx_priority_override(ctx, priority);
> > +     mutex_unlock(&mgr->lock);
> >
> >       fdput(f);
> >       return 0;
> > --
> > 2.40.0.634.g4ca3ef3211-goog
>
