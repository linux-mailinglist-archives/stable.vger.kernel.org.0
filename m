Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAEFE34D22B
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 16:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbhC2OLo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 10:11:44 -0400
Received: from mail-40134.protonmail.ch ([185.70.40.134]:38471 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbhC2OLa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 10:11:30 -0400
Date:   Mon, 29 Mar 2021 14:11:15 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=emersion.fr;
        s=protonmail3; t=1617027088;
        bh=/m6fPZO9iofk/6bDloEmBjjdNKVfk6ewjpqtTbHzMJ0=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=H6KxMsoOq95uVmocdEu4Su3McT7aYvwI7Vh3ED1ijihrdEYsLs4NEskce26iYUKo5
         8/eNe/e0ij0xFTGQUeJpIf3XONxqc9vGG2O527LwZCO9DRo9wnnRbhUOtbqZCiGJ6C
         UiS4iNLNjQ0UuneJyWS5ZaLY0Ues0UQTp/6cQrZ8WdwPd3LjNuEzcOT0I1VF+5gt9A
         cpd0aQIOvxo7hTcYa1pcFyqw6saYwFo4oEL78f/i+P+TqDmMqLVB6x4VFdCNH+Yct4
         dHeEPxX2Pd4gUrNxyH7thvN8DwUoqtyts42JPSWZ8bMiRX1OFzzJGi+iaqtb8Gj+9s
         LA0fr5z0zJW3Q==
To:     Maxime Ripard <maxime@cerno.tech>
From:   Simon Ser <contact@emersion.fr>
Cc:     Paul Cercueil <paul@crapouillou.net>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, od@zcrc.me,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Reply-To: Simon Ser <contact@emersion.fr>
Subject: Re: [PATCH] drm: DON'T require each CRTC to have a unique primary plane
Message-ID: <BoDZUOZSsZmHjkYkjHPb18dMl_t_U8ldrh8jZezjkA6a2O-IBkPGaER4wxZ2KlqRYuXlWM8xZwPnvweWEAATzoX-yuBJnBzjGKD3oXNfh5Y=@emersion.fr>
In-Reply-To: <20210329140731.tvkfxic4fu47v3rz@gilmour>
References: <20210327112214.10252-1-paul@crapouillou.net> <20210329140731.tvkfxic4fu47v3rz@gilmour>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Monday, March 29th, 2021 at 4:07 PM, Maxime Ripard <maxime@cerno.tech> w=
rote:

> Since it looks like you have two mutually exclusive planes, just expose
> one and be done with it?

You can expose the other as an overlay. Clever user-space will be able
to figure out that the more advanced plane can be used if the primary
plane is disabled.

But yeah, I don't think exposing two primary planes makes sense. The
"primary" bit is just there for legacy user-space, it's a hint that
it's the best plane to light up for fullscreen content. It has no other
significance than that, and in particular it doesn't mean that it's
incompatible with other primary planes.
