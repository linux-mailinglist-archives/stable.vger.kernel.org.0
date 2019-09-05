Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0CAAA9DC
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 19:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732994AbfIERVG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 13:21:06 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:43365 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732679AbfIERVG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 13:21:06 -0400
Received: by mail-ed1-f65.google.com with SMTP id c19so3398922edy.10
        for <stable@vger.kernel.org>; Thu, 05 Sep 2019 10:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Lukb3eP+CeEknZWAwQu/dY5fgrYVYVSG9EhQbpjgajU=;
        b=i29JUZLTG2ydbbvlXVgvnlgoY2XMDycS47cmCEs8pr0UyvlE/oXjNjVJWN+/Z3h9nl
         r2gSXM86H5aPHe/WXfXC8CAOH3FdaT4yXMORtpK9ET3U4ahlTQcWk/N8oguR5xLjlhjV
         qWbwPVXRk6mX7ubo8qnVUdHe/NpOui53CTYpOCl1jMjG03R6bYqTm/jEu/m0G0T3MiO4
         X7FAZR3L777FTpgR6/8s8pyNdauFdNf8Vr38MfUlP3vfYuXrlvRW2ucTAPSgbAFMfLOK
         JKrAlq+bAk7/4GGfSrGMp6LrDEmO4EM3NoNK5Aas3IFBmUgMAY2QAJlAeSWciu5xyMe7
         yGLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Lukb3eP+CeEknZWAwQu/dY5fgrYVYVSG9EhQbpjgajU=;
        b=bgU9pQKWrFg7PqOTTh3zHO0V56DxIJo9khu+2Moz09EzqY+DG5Fgl1eTYK5VyABmma
         44TjIdseo4CyV0IBSq5EhynHer2KQ6tggrL0DOUJyy7d6OVvPWyaOnan/3H+NjjeJx0z
         HyxsQTti/PXkiAFfWFHL0fgaMB14kzmaPkUg3uP8jtciNPNlz+daSZMt/8VSnrhj3r3n
         QGR17vc8s4XnxG2jInUrkzt4/Pydwr+tjrkKjITzy0beLYtcjuOwhbcfs9pHK9pkxT7F
         FvyqVWHJpj1MpQm8A2nIM4FLhDh10tkm+THiKv5MNVnDHZL378MIYefVSn6TNsq3Jg5o
         JnJw==
X-Gm-Message-State: APjAAAU1yJ7g80aPwWGdvNjXVkCGC4h+/JHcFe/Zq/WTYGf7jtj4otPZ
        JAlLnm1Ptus7A6eYn1OGt+krGSSZrC//2fmGX9I=
X-Google-Smtp-Source: APXvYqxhrTCAEPojNYYeJbGOdtXFzEiUAUUdPKfjwOIDCaBwBEoAAtyFgCpHdrIMfzF+uWWF29Wwgq3ZjOOB48o7F+Y=
X-Received: by 2002:a50:935d:: with SMTP id n29mr5106518eda.294.1567704064549;
 Thu, 05 Sep 2019 10:21:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190903190642.32588-1-daniel.vetter@ffwll.ch>
In-Reply-To: <20190903190642.32588-1-daniel.vetter@ffwll.ch>
From:   Rob Clark <robdclark@gmail.com>
Date:   Thu, 5 Sep 2019 10:20:53 -0700
Message-ID: <CAF6AEGvMa3JcoQeQzznjGbSdERnDPp39AT5rsF8QV1Ns9cBjaw@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH 1/3] drm/atomic: Take the atomic toys away
 from X
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        David Airlie <airlied@linux.ie>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        stable <stable@vger.kernel.org>, Adam Jackson <ajax@redhat.com>,
        Alex Deucher <alexdeucher@gmail.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel@daenzer.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 3, 2019 at 12:07 PM Daniel Vetter <daniel.vetter@ffwll.ch> wrot=
e:
>
> The -modesetting ddx has a totally broken idea of how atomic works:
> - doesn't disable old connectors, assuming they get auto-disable like
>   with the legacy setcrtc
> - assumes ASYNC_FLIP is wired through for the atomic ioctl
> - not a single call to TEST_ONLY
>
> Iow the implementation is a 1:1 translation of legacy ioctls to
> atomic, which is a) broken b) pointless.
>
> We already have bugs in both i915 and amdgpu-DC where this prevents us
> from enabling neat features.
>
> If anyone ever cares about atomic in X we can easily add a new atomic
> level (req->value =3D=3D 2) for X to get back the shiny toys.
>
> Since these broken versions of -modesetting have been shipping,
> there's really no other way to get out of this bind.
>
> References: https://gitlab.freedesktop.org/xorg/xserver/issues/629
> References: https://gitlab.freedesktop.org/xorg/xserver/merge_requests/18=
0
> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Cc: Michel D=C3=A4nzer <michel@daenzer.net>
> Cc: Alex Deucher <alexdeucher@gmail.com>
> Cc: Adam Jackson <ajax@redhat.com>
> Cc: Sean Paul <sean@poorly.run>
> Cc: David Airlie <airlied@linux.ie>
> Cc: stable@vger.kernel.org
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> ---
>  drivers/gpu/drm/drm_ioctl.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/gpu/drm/drm_ioctl.c b/drivers/gpu/drm/drm_ioctl.c
> index 2c120c58f72d..1cb7b4c3c87c 100644
> --- a/drivers/gpu/drm/drm_ioctl.c
> +++ b/drivers/gpu/drm/drm_ioctl.c
> @@ -334,6 +334,9 @@ drm_setclientcap(struct drm_device *dev, void *data, =
struct drm_file *file_priv)
>                 file_priv->universal_planes =3D req->value;
>                 break;
>         case DRM_CLIENT_CAP_ATOMIC:
> +               /* The modesetting DDX has a totally broken idea of atomi=
c. */
> +               if (strstr(current->comm, "X"))
> +                       return -EOPNOTSUPP;

Seems like we can be a bit more targeted than "anything that has 'X'
in the name".. at a minimum restrict things to "starts with 'X'" seems
saner.  But I guess we could probably somehow look at the processes
memory map and look for modesetting_drv.so.

BR,
-R

>                 if (!drm_core_check_feature(dev, DRIVER_ATOMIC))
>                         return -EOPNOTSUPP;
>                 if (req->value > 1)
> --
> 2.23.0
>
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/intel-gfx
