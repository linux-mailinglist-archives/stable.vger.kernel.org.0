Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18C081A12DB
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 19:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbgDGRmr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 13:42:47 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:38761 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbgDGRmr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 13:42:47 -0400
Received: by mail-io1-f65.google.com with SMTP id e79so4279654iof.5
        for <stable@vger.kernel.org>; Tue, 07 Apr 2020 10:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=poorly.run; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=b5j6zw5ZfXB9lEpVt/NTILUXrz7FT8+HfVyae5W7p/Y=;
        b=Rq+ADldyWxQqp4k3Sqly0N0oHNs/prtr6ajGzgBwOkgV23KxvS5jOx0ofrYrZS94iA
         UnWT6PDCXcY/3DZlUHKFLFolv6hHlp4kVRAXh0KAiKVa31qxL+knYPv5tUFPHxyf4QSH
         WG3tu37fMYpt+Jw/ULqk1i6W1ft8PqRryetDJe7DecpX8unLLTyrrDt1fpcunnfPfjGv
         WimKQLo5dwI18+PPjhOMJwoTVGW9Tcua5n+KnhSsd1tlUWTW3Phi7vZND/Y3IU0xGMAT
         icudh/gYbZMzpk/wVutFDqF6szKgWqa7EUKQQB5BzrnQNFivb3lym0o8A0GsfeZWy4Mz
         EVCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=b5j6zw5ZfXB9lEpVt/NTILUXrz7FT8+HfVyae5W7p/Y=;
        b=MTht8FSBysCAhTm0hQutm5po1Hub3IQ725Ib9onoV1T39uSVngIN9tePkWGI2NSpN2
         IOgWS3bzoLSx0AHxxKriDqrV71Njefs090b6SzF2IL0QATkzPY6nCkJ6k501ZKvbt1rq
         751CGmKm+IRce+/hO5KIlHeWiBJAkRK0+Q4TKEC8ywX/FnCTnSwUPwZXgGrSnUezTSEH
         DRXZg7okqSeM3eg42VFlEa9odc79EW+VrSarz7AgKgvYCBWOScByhXfAoy8LTnpbf52p
         44NdhYOX0uEgRI6dRy5KH66L/JMYkcuwUrFMmRIU5CHzEtn3RXnXSp0v3P7JoTocpS6O
         LzRg==
X-Gm-Message-State: AGi0PuYN/wN3DwVm54M1bDXBYfvj96UkFmopqtKRbVKtEcOIL25Aikwt
        vegj8bjDlRBGN5XEfimSpUpKxJhefCG1x2MXOFxfO693
X-Google-Smtp-Source: APiQypI9n1JqctpxXb2an7vmddN6FVi++2+Vo0vK84d8yh0rW346tKYBEJYvSDpE1acLEgm4NSV4RypXtXhges79df8=
X-Received: by 2002:a5d:8c8a:: with SMTP id g10mr3141939ion.201.1586281365752;
 Tue, 07 Apr 2020 10:42:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200406221253.1307209-1-lyude@redhat.com> <20200406221253.1307209-4-lyude@redhat.com>
In-Reply-To: <20200406221253.1307209-4-lyude@redhat.com>
From:   Sean Paul <sean@poorly.run>
Date:   Tue, 7 Apr 2020 13:42:09 -0400
Message-ID: <CAMavQKL_30XpTJ5VmVUEemi6vyT2E-WqioG+SS+9DQPgeusxxA@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] drm/dp_mst: Increase ACT retry timeout to 3s
To:     Lyude Paul <lyude@redhat.com>
Cc:     dri-devel <dri-devel@lists.freedesktop.org>,
        stable <stable@vger.kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Todd Previte <tprevite@gmail.com>,
        Dave Airlie <airlied@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 6, 2020 at 6:13 PM Lyude Paul <lyude@redhat.com> wrote:
>
> Currently we only poll for an ACT up to 30 times, with a busy-wait delay
> of 100=C2=B5s between each attempt - giving us a timeout of 2900=C2=B5s. =
While
> this might seem sensible, it would appear that in certain scenarios it
> can take dramatically longer then that for us to receive an ACT. On one
> of the EVGA MST hubs that I have available, I observed said hub
> sometimes taking longer then a second before signalling the ACT. These
> delays mostly seem to occur when previous sideband messages we've sent
> are NAKd by the hub, however it wouldn't be particularly surprising if
> it's possible to reproduce times like this simply by introducing branch
> devices with large LCTs since payload allocations have to take effect on
> every downstream device up to the payload's target.
>
> So, instead of just retrying 30 times we poll for the ACT for up to 3ms,
> and additionally use usleep_range() to avoid a very long and rude
> busy-wait. Note that the previous retry count of 30 appears to have been
> arbitrarily chosen, as I can't find any mention of a recommended timeout
> or retry count for ACTs in the DisplayPort 2.0 specification. This also
> goes for the range we were previously using for udelay(), although I
> suspect that was just copied from the recommended delay for link
> training on SST devices.
>
> Changes since v1:
> * Use readx_poll_timeout() instead of open-coding timeout loop - Sean
>   Paul
>
> Signed-off-by: Lyude Paul <lyude@redhat.com>
> Fixes: ad7f8a1f9ced ("drm/helper: add Displayport multi-stream helper (v0=
.6)")
> Cc: Sean Paul <sean@poorly.run>
> Cc: <stable@vger.kernel.org> # v3.17+
> ---
>  drivers/gpu/drm/drm_dp_mst_topology.c | 57 ++++++++++++++++-----------
>  1 file changed, 34 insertions(+), 23 deletions(-)
>
> diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_=
dp_mst_topology.c
> index c83adbdfc1cd..ce61964baa7c 100644
> --- a/drivers/gpu/drm/drm_dp_mst_topology.c
> +++ b/drivers/gpu/drm/drm_dp_mst_topology.c
> @@ -27,6 +27,7 @@
>  #include <linux/kernel.h>
>  #include <linux/sched.h>
>  #include <linux/seq_file.h>
> +#include <linux/iopoll.h>
>
>  #if IS_ENABLED(CONFIG_DRM_DEBUG_DP_MST_TOPOLOGY_REFS)
>  #include <linux/stacktrace.h>
> @@ -4460,43 +4461,53 @@ static int drm_dp_dpcd_write_payload(struct drm_d=
p_mst_topology_mgr *mgr,
>         return ret;
>  }
>
> +static int do_get_act_status(struct drm_dp_aux *aux)
> +{
> +       int ret;
> +       u8 status;
> +
> +       ret =3D drm_dp_dpcd_readb(aux, DP_PAYLOAD_TABLE_UPDATE_STATUS, &s=
tatus);
> +       if (ret < 0)
> +               return ret;
> +
> +       return status;
> +}
>
>  /**
>   * drm_dp_check_act_status() - Polls for ACT handled status.
>   * @mgr: manager to use
>   *
>   * Tries waiting for the MST hub to finish updating it's payload table b=
y
> - * polling for the ACT handled bit.
> + * polling for the ACT handled bit for up to 3 seconds (yes-some hubs re=
ally
> + * take that long).
>   *
>   * Returns:
>   * 0 if the ACT was handled in time, negative error code on failure.
>   */
>  int drm_dp_check_act_status(struct drm_dp_mst_topology_mgr *mgr)
>  {
> -       int count =3D 0, ret;
> -       u8 status;
> -
> -       do {
> -               ret =3D drm_dp_dpcd_readb(mgr->aux,
> -                                       DP_PAYLOAD_TABLE_UPDATE_STATUS,
> -                                       &status);
> -               if (ret < 0) {
> -                       DRM_DEBUG_KMS("failed to read payload table statu=
s %d\n",
> -                                     ret);
> -                       return ret;
> -               }
> -
> -               if (status & DP_PAYLOAD_ACT_HANDLED)
> -                       break;
> -               count++;
> -               udelay(100);
> -       } while (count < 30);
> -
> -       if (!(status & DP_PAYLOAD_ACT_HANDLED)) {
> -               DRM_DEBUG_KMS("failed to get ACT bit %d after %d retries\=
n",
> -                             status, count);
> +       /*
> +        * There doesn't seem to be any recommended retry count or timeou=
t in
> +        * the MST specification. Since some hubs have been observed to t=
ake
> +        * over 1 second to update their payload allocations under certai=
n
> +        * conditions, we use a rather large timeout value.
> +        */
> +       const int timeout_ms =3D 3000;
> +       int ret, status;
> +
> +       ret =3D readx_poll_timeout(do_get_act_status, mgr->aux, status,
> +                                status & DP_PAYLOAD_ACT_HANDLED || statu=
s < 0,
> +                                100, timeout_ms * USEC_PER_MSEC);

In v1 the usleep range was 100 -> 1000, in v2 it's going to be 51 ->
100. Perhaps bump this up to 200?

> +       if (ret < 0 && status >=3D 0) {
> +               DRM_DEBUG_KMS("Failed to get ACT bit %d after %dms\n",
> +                             status, timeout_ms);

I still think status should be base 16 when printed

With those nits addressed,

Reviewed-by: Sean Paul <sean@poorly.run>

>                 return -EINVAL;
> +       } else if (status < 0) {
> +               DRM_DEBUG_KMS("Failed to read payload table status: %d\n"=
,
> +                             status);
> +               return status;
>         }
> +
>         return 0;
>  }
>  EXPORT_SYMBOL(drm_dp_check_act_status);
> --
> 2.25.1
>
