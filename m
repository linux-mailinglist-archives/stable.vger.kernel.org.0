Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 121B934D387
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 17:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbhC2PQA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 29 Mar 2021 11:16:00 -0400
Received: from aposti.net ([89.234.176.197]:54710 "EHLO aposti.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230237AbhC2PPo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 11:15:44 -0400
Date:   Mon, 29 Mar 2021 16:15:28 +0100
From:   Paul Cercueil <paul@crapouillou.net>
Subject: Re: [PATCH] drm: DON'T require each CRTC to have a unique primary
 plane
To:     Maxime Ripard <maxime@cerno.tech>
Cc:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Simon Ser <contact@emersion.fr>, od@zcrc.me,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Message-Id: <S1LQQQ.K5HO8ISMBGA02@crapouillou.net>
In-Reply-To: <20210329140731.tvkfxic4fu47v3rz@gilmour>
References: <20210327112214.10252-1-paul@crapouillou.net>
        <20210329140731.tvkfxic4fu47v3rz@gilmour>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Maxime,

Le lun. 29 mars 2021 à 16:07, Maxime Ripard <maxime@cerno.tech> a 
écrit :
> On Sat, Mar 27, 2021 at 11:22:14AM +0000, Paul Cercueil wrote:
>>  The ingenic-drm driver has two mutually exclusive primary planes
>>  already; so the fact that a CRTC must have one and only one primary
>>  plane is an invalid assumption.
> 
> I mean, no? It's been documented for a while that a CRTC should only
> have a single primary, so I'd say that the invalid assumption was that
> it was possible to have multiple primary planes for a CRTC.

Documented where?

I did read the doc of "enum drm_plane_type" in <drm/drm_plane.h>, and 
the DRM_PLANE_TYPE_PRIMARY describes my two planes, so I went with that.

-Paul

> Since it looks like you have two mutually exclusive planes, just 
> expose
> one and be done with it?
> 
> Maxime


