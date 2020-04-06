Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94D3619FE0F
	for <lists+stable@lfdr.de>; Mon,  6 Apr 2020 21:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbgDFT1m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Apr 2020 15:27:42 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:41199 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725933AbgDFT1l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Apr 2020 15:27:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586201260;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QwF4wq4AYvXRbfz5PvV0g0CmU7fPPunQdEwXYUcKME4=;
        b=ibtNEGxZeTG++hvl9c4NRAHu1DDWpAh+S3+miJDnzVsVNjzLRCyeF6MwpEZsUeTnJexq/B
        yqpGoZ9+8AERMVQb5DUy7kN5RJsLaupzDQrryGBuu2QtZww6WV62X0/bY+nUYirneytQXG
        lcSJEZrco3lFij4s1/Bh3JhpS+ygSgc=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-96-oj2AGhBLMiioTujL_WVpaQ-1; Mon, 06 Apr 2020 15:27:38 -0400
X-MC-Unique: oj2AGhBLMiioTujL_WVpaQ-1
Received: by mail-qk1-f199.google.com with SMTP id a21so897101qkg.6
        for <stable@vger.kernel.org>; Mon, 06 Apr 2020 12:27:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=QwF4wq4AYvXRbfz5PvV0g0CmU7fPPunQdEwXYUcKME4=;
        b=bOTIwj5Ld1IZaxao528EyucA0iuFYoU0DWvbxlCWfgXuKXiKuBDU4JjHUwyvS3wxyz
         FCi+VFFNTlXVJ0T7C2CdKLLXRhNiIKKHckfgB8O+YWduPnchDbbs2TxEOnGbg48q91xf
         OSCZBxBjRJzMzImN6xqLgoAIJGhAYfVXzKV4TjEld6LST8ToCOqWlGe7JxeIer3jXK9z
         LFl8tne68F8b1/eFsQSyRrpA6K0Mk/ebJWlkwgdq17Wxifs99WGLW1CRNIP9eChY5Rbd
         4J5W5uGZLXPlaTSfwAvWnya1fErGyGsApJYl6B1ri7zjQZQYYzff7LBagXlwWB1Pf3xs
         EiWw==
X-Gm-Message-State: AGi0PuZ5tVJz5l+rsXHxxgcRsYLJJYTudryR4HOZXWXqPO11VizP8/Ws
        QjEZMSPBVC8ZSN/FvpZ9p5p5IXHLe9mPez7Lgxdx3h0WPV8JKPEqvikjSuCQog+iKZXACIu2Z5s
        Ky9yZ1S2rGgFn7mxX
X-Received: by 2002:ac8:10f:: with SMTP id e15mr1115211qtg.355.1586201257855;
        Mon, 06 Apr 2020 12:27:37 -0700 (PDT)
X-Google-Smtp-Source: APiQypIcSVxln0+TxAGiz9pu5WgjVaSm1wM1cLgviUCkvqSS8unS4LyeOc9Fq545caCsXLfk1u4yAQ==
X-Received: by 2002:ac8:10f:: with SMTP id e15mr1115187qtg.355.1586201257610;
        Mon, 06 Apr 2020 12:27:37 -0700 (PDT)
Received: from Ruby.lyude.net (static-173-76-190-23.bstnma.ftas.verizon.net. [173.76.190.23])
        by smtp.gmail.com with ESMTPSA id g2sm2896284qtj.96.2020.04.06.12.27.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 12:27:36 -0700 (PDT)
Message-ID: <e6802716d4ddb18a43cedd2c8af4c96726f62719.camel@redhat.com>
Subject: Re: [PATCH 2/4] drm/dp_mst: Reformat drm_dp_check_act_status() a bit
From:   Lyude Paul <lyude@redhat.com>
To:     Sean Paul <sean@poorly.run>
Cc:     dri-devel <dri-devel@lists.freedesktop.org>,
        stable <stable@vger.kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>,
        Todd Previte <tprevite@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date:   Mon, 06 Apr 2020 15:27:35 -0400
In-Reply-To: <CAMavQKL6G9QsUE7ZzGXNpjjEVdZGQZkbN3oke-M=Lz=pHOn70A@mail.gmail.com>
References: <20200403200757.886443-1-lyude@redhat.com>
         <20200403200757.886443-3-lyude@redhat.com>
         <CAMavQKL6G9QsUE7ZzGXNpjjEVdZGQZkbN3oke-M=Lz=pHOn70A@mail.gmail.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2020-04-06 at 15:23 -0400, Sean Paul wrote:
> On Fri, Apr 3, 2020 at 4:08 PM Lyude Paul <lyude@redhat.com> wrote:
> > Just add a bit more line wrapping, get rid of some extraneous
> > whitespace, remove an unneeded goto label, and move around some variable
> > declarations. No functional changes here.
> > 
> > Signed-off-by: Lyude Paul <lyude@redhat.com>
> > [this isn't a fix, but it's needed for the fix that comes after this]
> > Fixes: ad7f8a1f9ced ("drm/helper: add Displayport multi-stream helper
> > (v0.6)")
> > Cc: Sean Paul <sean@poorly.run>
> > Cc: <stable@vger.kernel.org> # v3.17+
> > ---
> >  drivers/gpu/drm/drm_dp_mst_topology.c | 22 ++++++++++------------
> >  1 file changed, 10 insertions(+), 12 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c
> > b/drivers/gpu/drm/drm_dp_mst_topology.c
> > index 2b9ce965f044..7aaf184a2e5f 100644
> > --- a/drivers/gpu/drm/drm_dp_mst_topology.c
> > +++ b/drivers/gpu/drm/drm_dp_mst_topology.c
> > @@ -4473,33 +4473,31 @@ static int drm_dp_dpcd_write_payload(struct
> > drm_dp_mst_topology_mgr *mgr,
> >   */
> >  int drm_dp_check_act_status(struct drm_dp_mst_topology_mgr *mgr)
> >  {
> > +       int count = 0, ret;
> >         u8 status;
> > -       int ret;
> > -       int count = 0;
> > 
> >         do {
> > -               ret = drm_dp_dpcd_readb(mgr->aux,
> > DP_PAYLOAD_TABLE_UPDATE_STATUS, &status);
> > -
> > +               ret = drm_dp_dpcd_readb(mgr->aux,
> > +                                       DP_PAYLOAD_TABLE_UPDATE_STATUS,
> > +                                       &status);
> >                 if (ret < 0) {
> > -                       DRM_DEBUG_KMS("failed to read payload table status
> > %d\n", ret);
> > -                       goto fail;
> > +                       DRM_DEBUG_KMS("failed to read payload table status
> > %d\n",
> > +                                     ret);
> > +                       return ret;
> >                 }
> > 
> >                 if (status & DP_PAYLOAD_ACT_HANDLED)
> >                         break;
> >                 count++;
> >                 udelay(100);
> > -
> >         } while (count < 30);
> > 
> >         if (!(status & DP_PAYLOAD_ACT_HANDLED)) {
> > -               DRM_DEBUG_KMS("failed to get ACT bit %d after %d
> > retries\n", status, count);
> > -               ret = -EINVAL;
> > -               goto fail;
> > +               DRM_DEBUG_KMS("failed to get ACT bit %d after %d
> > retries\n",
> 
> Should we print status in base16 here?
> 
> Otherwise:
> 
> Reviewed-by: Sean Paul <sean@poorly.run>

Good point - I'll make sure to fix that before I push the series
> 
> > +                             status, count);
> > +               return -EINVAL;
> >         }
> >         return 0;
> > -fail:
> > -       return ret;
> >  }
> >  EXPORT_SYMBOL(drm_dp_check_act_status);
> > 
> > --
> > 2.25.1
> > 
-- 
Cheers,
	Lyude Paul (she/her)
	Associate Software Engineer at Red Hat

