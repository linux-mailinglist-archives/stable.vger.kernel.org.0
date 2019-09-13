Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B64B2B2120
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389848AbfIMNdt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:33:49 -0400
Received: from mail-vs1-f66.google.com ([209.85.217.66]:42511 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388524AbfIMNdt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Sep 2019 09:33:49 -0400
Received: by mail-vs1-f66.google.com with SMTP id m22so18586781vsl.9;
        Fri, 13 Sep 2019 06:33:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Hnl7OpEfza4YbA2qYO4VUD1uuEgWDd+IAdiDL6hY/pM=;
        b=IofTxCS7lwNQAocatR0C7ZiQ6XGfKbtmTucn1ZRXz9tNVv1mdEnNImBFrovzT4sv0g
         JIk9w4c6owtM08W0VQUgumkJPpb25IKrmez2gU77KTE1E0UKwLJTbThIMq12FqyEeL67
         CPFtFtDQ7Rs55U8hE5dHgidXx1cfABRcAcExlMpmo6csXZ/gsCENd77uYMeoeGJJYWiC
         UVh48cDhoNTxWrMncsXjNcPjlP0rB/dfFjHsc4xqQI9RcMe6c7VSpLvtQSJUtPw+UDvh
         qgu7+CHxT/nHUWKlY095X7lIXyDvJ9xK1wp2icCIXIkcSzyBAm1GlX5B4G8sb0I7jWM2
         CGfQ==
X-Gm-Message-State: APjAAAXvvBtcso/Sz2hoQ9QxRACtG9Z3mKkZsM0daBHX+sqM+6zWffw8
        pNH1nN+HGbBxHR+1XhTNcgZeiMYdJ9MJuFCe+DQ=
X-Google-Smtp-Source: APXvYqzXCO+EpVFbPYPlwDYijbuWIyqt5+tfpfwugxLjt/Ev9WUQG2jABsTvE5FdPYOUoUJaDM+fpDyxEF5WEXd7iPA=
X-Received: by 2002:a67:fd97:: with SMTP id k23mr20291160vsq.220.1568381627687;
 Fri, 13 Sep 2019 06:33:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190913130559.669563815@linuxfoundation.org> <20190913130606.981926197@linuxfoundation.org>
In-Reply-To: <20190913130606.981926197@linuxfoundation.org>
From:   Ilia Mirkin <imirkin@alum.mit.edu>
Date:   Fri, 13 Sep 2019 09:33:36 -0400
Message-ID: <CAKb7UviY0sjFUc6QqjU4eKxm2b-osKoJNO2CSP9HmQ5AdORgkw@mail.gmail.com>
Subject: Re: [PATCH 4.19 092/190] drm/nouveau: Dont WARN_ON VCPI allocation failures
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        nouveau <nouveau@lists.freedesktop.org>,
        "# 3.9+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

This feels like it's missing a From: line.

commit b513a18cf1d705bd04efd91c417e79e4938be093
Author: Lyude Paul <lyude@redhat.com>
Date:   Mon Jan 28 16:03:50 2019 -0500

    drm/nouveau: Don't WARN_ON VCPI allocation failures

Is this an artifact of your notification-of-patches process and I
never noticed before, or was the patch ingested incorrectly?

Cheers,

  -ilia

On Fri, Sep 13, 2019 at 9:16 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> [ Upstream commit b513a18cf1d705bd04efd91c417e79e4938be093 ]
>
> This is much louder then we want. VCPI allocation failures are quite
> normal, since they will happen if any part of the modesetting process is
> interrupted by removing the DP MST topology in question. So just print a
> debugging message on VCPI failures instead.
>
> Signed-off-by: Lyude Paul <lyude@redhat.com>
> Fixes: f479c0ba4a17 ("drm/nouveau/kms/nv50: initial support for DP 1.2 multi-stream")
> Cc: Ben Skeggs <bskeggs@redhat.com>
> Cc: dri-devel@lists.freedesktop.org
> Cc: nouveau@lists.freedesktop.org
> Cc: <stable@vger.kernel.org> # v4.10+
> Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/gpu/drm/nouveau/dispnv50/disp.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/drm/nouveau/dispnv50/disp.c
> index f889d41a281fa..5e01bfb69d7a3 100644
> --- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
> +++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
> @@ -759,7 +759,8 @@ nv50_msto_enable(struct drm_encoder *encoder)
>
>         slots = drm_dp_find_vcpi_slots(&mstm->mgr, mstc->pbn);
>         r = drm_dp_mst_allocate_vcpi(&mstm->mgr, mstc->port, mstc->pbn, slots);
> -       WARN_ON(!r);
> +       if (!r)
> +               DRM_DEBUG_KMS("Failed to allocate VCPI\n");
>
>         if (!mstm->links++)
>                 nv50_outp_acquire(mstm->outp);
> --
> 2.20.1
>
>
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel
