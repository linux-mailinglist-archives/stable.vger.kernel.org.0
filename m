Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4659634D3FA
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 17:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbhC2PdF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 29 Mar 2021 11:33:05 -0400
Received: from aposti.net ([89.234.176.197]:56360 "EHLO aposti.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230337AbhC2Pcc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 11:32:32 -0400
Date:   Mon, 29 Mar 2021 16:32:17 +0100
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
Message-Id: <TTLQQQ.OCR65URAWJVQ2@crapouillou.net>
In-Reply-To: <BoDZUOZSsZmHjkYkjHPb18dMl_t_U8ldrh8jZezjkA6a2O-IBkPGaER4wxZ2KlqRYuXlWM8xZwPnvweWEAATzoX-yuBJnBzjGKD3oXNfh5Y=@emersion.fr>
References: <20210327112214.10252-1-paul@crapouillou.net>
        <20210329140731.tvkfxic4fu47v3rz@gilmour>
        <BoDZUOZSsZmHjkYkjHPb18dMl_t_U8ldrh8jZezjkA6a2O-IBkPGaER4wxZ2KlqRYuXlWM8xZwPnvweWEAATzoX-yuBJnBzjGKD3oXNfh5Y=@emersion.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Simon,

Le lun. 29 mars 2021 à 14:11, Simon Ser <contact@emersion.fr> a écrit 
:
> On Monday, March 29th, 2021 at 4:07 PM, Maxime Ripard 
> <maxime@cerno.tech> wrote:
> 
>>  Since it looks like you have two mutually exclusive planes, just 
>> expose
>>  one and be done with it?
> 
> You can expose the other as an overlay. Clever user-space will be able
> to figure out that the more advanced plane can be used if the primary
> plane is disabled.
> 
> But yeah, I don't think exposing two primary planes makes sense. The
> "primary" bit is just there for legacy user-space, it's a hint that
> it's the best plane to light up for fullscreen content. It has no 
> other
> significance than that, and in particular it doesn't mean that it's
> incompatible with other primary planes.

Yes, from what I understood when writing the driver, there is not much 
of a difference with primary vs. overlay planes when dealing with the 
atomic DRM API, which I used exclusively.

Making the second plane an overlay would break the ABI, which is never 
something I'm happy to do; but I'd prefer to do it now than later.

I still have concerns about the user-space being "clever" enough to 
know it can disable the primary plane. Can e.g. wlroots handle that?

Cheers,
-Paul


