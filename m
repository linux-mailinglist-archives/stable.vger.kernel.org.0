Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2437A34B6D0
	for <lists+stable@lfdr.de>; Sat, 27 Mar 2021 12:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbhC0LY1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Mar 2021 07:24:27 -0400
Received: from mail-40136.protonmail.ch ([185.70.40.136]:11273 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231455AbhC0LYY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 27 Mar 2021 07:24:24 -0400
Date:   Sat, 27 Mar 2021 11:24:06 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=emersion.fr;
        s=protonmail3; t=1616844262;
        bh=ZeosTjM7JTFTNLFhh8j3WlcOms5nuTO7bTrKwENNYQA=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=RIPT0bde8x/F0BSTs64Mp+ghXeXOEByxoW0cBkbAunG9v42djMFM5bu2gUA8dbWnX
         thFaGbxERyf8xQIe0xf7aqhBwZuGyHXufOT05hYenfsWomuV08L5aVwnaI6yt8k4oE
         3E3XKkdQ6Kf36vrOwINH7vkVrCTSfr/Y57rx01cmfUFeZYvQlSJzN+XeuBGl8VTwBK
         GBUtx3ZAcKRZBJvXpXSLULiz2E3wDbTm6uNNGcui+bzjPDmTjREn7firXO1o95bnB1
         9sGxzI+nwO/lgKuIjgmA5lsGI5DxgGSRDI1Uvx/ZdbAAqcmR16gnlfb+ZDnp+MVxKm
         6X2SAdQ17zWoQ==
To:     Paul Cercueil <paul@crapouillou.net>
From:   Simon Ser <contact@emersion.fr>
Cc:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, od@zcrc.me,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Reply-To: Simon Ser <contact@emersion.fr>
Subject: Re: [PATCH] drm: DON'T require each CRTC to have a unique primary plane
Message-ID: <1J_tcDPSAZW23jPO8ApyzgINcVRRWcNyFP0LvrSFVIMbZB9lH6lCWvh2ByU9rNt6bj6xpgRgv8n0hBKhXAvXNfLBGfTIsvbhYuHW3IIDd7Y=@emersion.fr>
In-Reply-To: <20210327112214.10252-1-paul@crapouillou.net>
References: <20210327112214.10252-1-paul@crapouillou.net>
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

On Saturday, March 27th, 2021 at 12:22 PM, Paul Cercueil <paul@crapouillou.=
net> wrote:

> The ingenic-drm driver has two mutually exclusive primary planes
> already; so the fact that a CRTC must have one and only one primary
> plane is an invalid assumption.

Why does this driver expose two primary planes, if it only has a single
CRTC?
