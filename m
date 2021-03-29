Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D35D134D4AB
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 18:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbhC2QP5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 29 Mar 2021 12:15:57 -0400
Received: from aposti.net ([89.234.176.197]:40632 "EHLO aposti.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229515AbhC2QPe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 12:15:34 -0400
Date:   Mon, 29 Mar 2021 17:15:06 +0100
From:   Paul Cercueil <paul@crapouillou.net>
Subject: Re: [PATCH] drm: DON'T require each CRTC to have a unique primary
 plane
To:     Simon Ser <contact@emersion.fr>
Cc:     Maxime Ripard <maxime@cerno.tech>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, od@zcrc.me,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Message-Id: <6TNQQQ.CQL1KN8NARCK@crapouillou.net>
In-Reply-To: <rExcDgzsvu0kmMtp6ujD3gpKLXeYz121Dzm8yJrZOvv1A6IJkB9sTBGFcJHQTCTvAGmcrZ79bdD78ZYUeK3el868UYXTK46dkKnmlpQkj4Y=@emersion.fr>
References: <20210327112214.10252-1-paul@crapouillou.net>
        <20210329140731.tvkfxic4fu47v3rz@gilmour>
        <S1LQQQ.K5HO8ISMBGA02@crapouillou.net>
        <20210329153541.a3yil2aqsrtf2nlj@gilmour>
        <25MQQQ.YYKN0GE2YPZN1@crapouillou.net>
        <rExcDgzsvu0kmMtp6ujD3gpKLXeYz121Dzm8yJrZOvv1A6IJkB9sTBGFcJHQTCTvAGmcrZ79bdD78ZYUeK3el868UYXTK46dkKnmlpQkj4Y=@emersion.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Le lun. 29 mars 2021 à 15:42, Simon Ser <contact@emersion.fr> a écrit 
:
> On Monday, March 29th, 2021 at 5:39 PM, Paul Cercueil 
> <paul@crapouillou.net> wrote:
> 
>>  Ok, I read that as "all drivers should provide AT LEAST one primary
>>  plane per CRTC", and not as "all drivers should provide ONE AND ONLY
>>  ONE primary plane per CRTC". My bad.
> 
> Yeah, it's a little complicated to document, because it's possible for
> a primary plane to be compatible with multiple CRTCs… We tried to
> improve this [1] recently.
> 
> [1]: 
> https://dri.freedesktop.org/docs/drm/gpu/drm-kms.html#plane-abstraction

Ok, that is definitely much clearer :)

-Paul


