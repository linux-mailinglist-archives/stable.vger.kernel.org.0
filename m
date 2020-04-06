Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDDD419FE3B
	for <lists+stable@lfdr.de>; Mon,  6 Apr 2020 21:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbgDFTnR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Apr 2020 15:43:17 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:30311 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725957AbgDFTnR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Apr 2020 15:43:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586202195;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4FgxeFtNjl0qouniLNN2YFmv27Dp9D+qfMG9VLSyC7M=;
        b=Jd1EgSz6sfAbbdVuVvW3SIuKZrY511XpjtCwS89yBfOhaRv2IyZNB486QltROyeqn0xyjK
        6x/j4xdR2I5mDaVlOLXtnT839at7mqEr99AshOZWzj0ohEvn9a6avwv6CBbqeCTnExoBUi
        S1LefFRJs7Gd76vZVxTJh5Losi7u2Qo=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-X7gRXChyMYGC4DM0pO0bXg-1; Mon, 06 Apr 2020 15:43:14 -0400
X-MC-Unique: X7gRXChyMYGC4DM0pO0bXg-1
Received: by mail-qt1-f198.google.com with SMTP id q94so880631qtd.10
        for <stable@vger.kernel.org>; Mon, 06 Apr 2020 12:43:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=4FgxeFtNjl0qouniLNN2YFmv27Dp9D+qfMG9VLSyC7M=;
        b=kIG1iIoetvSG0xCICJ/dorXre627nZ9fOsFMtk2/9jLQxzB2Wh2b2fMGexww2faFz9
         AbDCkzakGSqO9wKq1jlw1utCuCOws9YpPCAU/PNRRqk3t0225eFK+sUpT2X1gQgOjYYl
         PRiO37X4LUaMY1NGBOmqQbQp5u4ivvwgKBLsHUo6Gz3ivH/ijsDX6L1a1n0JZdwlwkNv
         e/DY2491GbkvVIlht1Ew+z3CMUqFfWAF/RWWW+47oxEPB4eAwe2bbhel9b2AgyQDujTr
         nAkJvHY36AX5q+8D8oml309GwRkaGlh4MwV5nFuCPlKsGJuG7bwlHKXizGE/ybNFJo8s
         e2zA==
X-Gm-Message-State: AGi0PuaBUSs7Z6u2sw15RTaR1WFHuDT8gXGMFDHgGoS6OqgHPUOWLe6O
        oYB3qzvJi37Gmq7RVIwPd33Cv6SLBQROyY/XIyPan5XwSdaWf8irq9VZNUNUpAYzVLa4bC9qTdO
        dUxdgMNrzcWzfvhc9
X-Received: by 2002:a0c:a181:: with SMTP id e1mr1465934qva.19.1586202191869;
        Mon, 06 Apr 2020 12:43:11 -0700 (PDT)
X-Google-Smtp-Source: APiQypII+D3hQ4rA9orAMNS9EzduyFbgdxN85HHsI1cVwQUC0pNc/rMKoEF1qBT7Oy32pVztz1+9pA==
X-Received: by 2002:a0c:a181:: with SMTP id e1mr1465915qva.19.1586202191527;
        Mon, 06 Apr 2020 12:43:11 -0700 (PDT)
Received: from Ruby.lyude.net (static-173-76-190-23.bstnma.ftas.verizon.net. [173.76.190.23])
        by smtp.gmail.com with ESMTPSA id p14sm1159088qkp.63.2020.04.06.12.43.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 12:43:10 -0700 (PDT)
Message-ID: <3eccd492237ee8797a8af2ea757594bc13ae055f.camel@redhat.com>
Subject: Re: [PATCH 3/4] drm/dp_mst: Increase ACT retry timeout to 3s
From:   Lyude Paul <lyude@redhat.com>
To:     Sean Paul <sean@poorly.run>
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
Date:   Mon, 06 Apr 2020 15:43:09 -0400
In-Reply-To: <CAMavQK+yVxFYNUR1wdfwB_UhRS2ziy0N5k+WTwAqUwRovX3GMA@mail.gmail.com>
References: <20200403200757.886443-1-lyude@redhat.com>
         <20200403200757.886443-4-lyude@redhat.com>
         <CAMavQK+yVxFYNUR1wdfwB_UhRS2ziy0N5k+WTwAqUwRovX3GMA@mail.gmail.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2020-04-06 at 15:41 -0400, Sean Paul wrote:
> On Fri, Apr 3, 2020 at 4:08 PM Lyude Paul <lyude@redhat.com> wrote:
> > Currently we only poll for an ACT up to 30 times, with a busy-wait delay
> > of 100µs between each attempt - giving us a timeout of 2900µs. While
> > this might seem sensible, it would appear that in certain scenarios it
> > can take dramatically longer then that for us to receive an ACT. On one
> > of the EVGA MST hubs that I have available, I observed said hub
> > sometimes taking longer then a second before signalling the ACT. These
> > delays mostly seem to occur when previous sideband messages we've sent
> > are NAKd by the hub, however it wouldn't be particularly surprising if
> > it's possible to reproduce times like this simply by introducing branch
> > devices with large LCTs since payload allocations have to take effect on
> > every downstream device up to the payload's target.
> > 
> > So, instead of just retrying 30 times we poll for the ACT for up to 3ms,
> > and additionally use usleep_range() to avoid a very long and rude
> > busy-wait. Note that the previous retry count of 30 appears to have been
> > arbitrarily chosen, as I can't find any mention of a recommended timeout
> > or retry count for ACTs in the DisplayPort 2.0 specification. This also
> > goes for the range we were previously using for udelay(), although I
> > suspect that was just copied from the recommended delay for link
> > training on SST devices.
> > 
> > Signed-off-by: Lyude Paul <lyude@redhat.com>
> > Fixes: ad7f8a1f9ced ("drm/helper: add Displayport multi-stream helper
> > (v0.6)")
> > Cc: Sean Paul <sean@poorly.run>
> > Cc: <stable@vger.kernel.org> # v3.17+
> > ---
> >  drivers/gpu/drm/drm_dp_mst_topology.c | 26 +++++++++++++++++++-------
> >  1 file changed, 19 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c
> > b/drivers/gpu/drm/drm_dp_mst_topology.c
> > index 7aaf184a2e5f..f313407374ed 100644
> > --- a/drivers/gpu/drm/drm_dp_mst_topology.c
> > +++ b/drivers/gpu/drm/drm_dp_mst_topology.c
> > @@ -4466,17 +4466,30 @@ static int drm_dp_dpcd_write_payload(struct
> > drm_dp_mst_topology_mgr *mgr,
> >   * @mgr: manager to use
> >   *
> >   * Tries waiting for the MST hub to finish updating it's payload table by
> > - * polling for the ACT handled bit.
> > + * polling for the ACT handled bit for up to 3 seconds (yes-some hubs
> > really
> > + * take that long).
> >   *
> >   * Returns:
> >   * 0 if the ACT was handled in time, negative error code on failure.
> >   */
> >  int drm_dp_check_act_status(struct drm_dp_mst_topology_mgr *mgr)
> >  {
> > -       int count = 0, ret;
> > +       /*
> > +        * There doesn't seem to be any recommended retry count or timeout
> > in
> > +        * the MST specification. Since some hubs have been observed to
> > take
> > +        * over 1 second to update their payload allocations under certain
> > +        * conditions, we use a rather large timeout value.
> > +        */
> > +       const int timeout_ms = 3000;
> > +      unsigned long timeout = jiffies + msecs_to_jiffies(timeout_ms);
> > +       int ret;
> > +       bool retrying = false;
> >         u8 status;
> > 
> >         do {
> > +               if (retrying)
> > +                       usleep_range(100, 1000);
> > +
> >                 ret = drm_dp_dpcd_readb(mgr->aux,
> >                                         DP_PAYLOAD_TABLE_UPDATE_STATUS,
> >                                         &status);
> > @@ -4488,13 +4501,12 @@ int drm_dp_check_act_status(struct
> > drm_dp_mst_topology_mgr *mgr)
> > 
> >                 if (status & DP_PAYLOAD_ACT_HANDLED)
> >                         break;
> > -               count++;
> > -               udelay(100);
> > -       } while (count < 30);
> > +               retrying = true;
> > +       } while (jiffies < timeout);
> 
> Somewhat academic, but I think there's an overflow possibility here if
> timeout is near ulong_max and jiffies overflows during the usleep. In
> that case we'll be retrying for a very loong time.
> 
> I wish we had i915's wait_for() macro available to all drm...

Maybe we could add it to the kernel library somewhere? I don't see why we'd
need to stop at DRM

> 
> Sean
> 
> >         if (!(status & DP_PAYLOAD_ACT_HANDLED)) {
> > -               DRM_DEBUG_KMS("failed to get ACT bit %d after %d
> > retries\n",
> > -                             status, count);
> > +               DRM_DEBUG_KMS("failed to get ACT bit %d after %dms\n",
> > +                             status, timeout_ms);
> >                 return -EINVAL;
> >         }
> >         return 0;
> > --
> > 2.25.1
> > 
-- 
Cheers,
	Lyude Paul (she/her)
	Associate Software Engineer at Red Hat

