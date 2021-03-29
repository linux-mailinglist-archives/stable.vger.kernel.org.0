Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEDEC34D42D
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 17:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbhC2Pmo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 11:42:44 -0400
Received: from mail-40134.protonmail.ch ([185.70.40.134]:13512 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbhC2Pm1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 11:42:27 -0400
Date:   Mon, 29 Mar 2021 15:42:08 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=emersion.fr;
        s=protonmail3; t=1617032545;
        bh=2/L+rxb2brglmePjN5EhVd44vXZ9B62TDl2wMhMnNvM=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=pzfGQ01zvflujGIEayX0OMJGoqbj7T9F30YdUsKOtGTni+fq2VFO81AFwyLk2vmIw
         E3wPDQ8qv3nSqR+aF0dh1jyiJ5LHMGoAJ/Lhss4H/G2ggIqEXCWQGc/CxN0/cZlxmV
         gB9gFcffeTgLCHaadQC0G+SuirYDb/fi8vLmCf30Wuc3aSlAG1bRtEq9gNeipa+QBw
         bb9XaugILBIQSk+41KfSEkGS+kD1R8ZQvCLDuvlMBRUqk9MHOoQwvlDEPrCpDlRJi7
         O7ysdoQ53KcthccIw+ELEIW/Ft/WPc4Is1BM9JIG/w/V10cqeuX/EcIXqIpf1hEh8p
         9MVixi+OMnckQ==
To:     Paul Cercueil <paul@crapouillou.net>
From:   Simon Ser <contact@emersion.fr>
Cc:     Maxime Ripard <maxime@cerno.tech>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, od@zcrc.me,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Reply-To: Simon Ser <contact@emersion.fr>
Subject: Re: [PATCH] drm: DON'T require each CRTC to have a unique primary plane
Message-ID: <rExcDgzsvu0kmMtp6ujD3gpKLXeYz121Dzm8yJrZOvv1A6IJkB9sTBGFcJHQTCTvAGmcrZ79bdD78ZYUeK3el868UYXTK46dkKnmlpQkj4Y=@emersion.fr>
In-Reply-To: <25MQQQ.YYKN0GE2YPZN1@crapouillou.net>
References: <20210327112214.10252-1-paul@crapouillou.net> <20210329140731.tvkfxic4fu47v3rz@gilmour> <S1LQQQ.K5HO8ISMBGA02@crapouillou.net> <20210329153541.a3yil2aqsrtf2nlj@gilmour> <25MQQQ.YYKN0GE2YPZN1@crapouillou.net>
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

On Monday, March 29th, 2021 at 5:39 PM, Paul Cercueil <paul@crapouillou.net=
> wrote:

> Ok, I read that as "all drivers should provide AT LEAST one primary
> plane per CRTC", and not as "all drivers should provide ONE AND ONLY
> ONE primary plane per CRTC". My bad.

Yeah, it's a little complicated to document, because it's possible for
a primary plane to be compatible with multiple CRTCs=E2=80=A6 We tried to
improve this [1] recently.

[1]: https://dri.freedesktop.org/docs/drm/gpu/drm-kms.html#plane-abstractio=
n
