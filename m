Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C056A502A8
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 09:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727243AbfFXHBl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 03:01:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:46058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726077AbfFXHBl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 03:01:41 -0400
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE978208CA
        for <stable@vger.kernel.org>; Mon, 24 Jun 2019 07:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561359701;
        bh=T0oeAa8Tz0vRXuG3Mwx6Y8MnnyjLiX7daWK1otNrcRk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=qY1rhOu/6LweEuYlGB0B/Vn8hbX1iJjk9m+fWLUj3HOEYybhG2AOoBDbv+8S5Yb9j
         +YQYOzN0zz2afuFfKYznn+zF3men8MMXMpb+Ml7ldH8GyHsR/np7SIs4+LWcbOhUHH
         mvNgtkSgg21G/m4AG7xICBFRZIY4pUaSPdtQCkqA=
Received: by mail-lj1-f174.google.com with SMTP id a21so11471436ljh.7
        for <stable@vger.kernel.org>; Mon, 24 Jun 2019 00:01:40 -0700 (PDT)
X-Gm-Message-State: APjAAAUBZADv7ibnOEWiOFifQDXw20j69yR39jZt3ZbUdcaAsurPSS80
        ED6kdsfbhuopLgUMR+heW8TS6Rtln6o3rZiSWsA=
X-Google-Smtp-Source: APXvYqxLwtuI6gSOpjoeSyPBx9ZbIkyw026xOOgIkK2l1axtR8IdasnDZmllKwLbFIS23EY6JvDEcrPLkR2v5FsZLH4=
X-Received: by 2002:a2e:3008:: with SMTP id w8mr44002093ljw.13.1561359699005;
 Mon, 24 Jun 2019 00:01:39 -0700 (PDT)
MIME-Version: 1.0
References: <1560948159-21926-1-git-send-email-krzk@kernel.org> <20190622181347.3BFC52070B@mail.kernel.org>
In-Reply-To: <20190622181347.3BFC52070B@mail.kernel.org>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Mon, 24 Jun 2019 09:01:27 +0200
X-Gmail-Original-Message-ID: <CAJKOXPeZH+jiXxsm_cpWsfuju=vhAd2GDoj_aH811pv17C6YOQ@mail.gmail.com>
Message-ID: <CAJKOXPeZH+jiXxsm_cpWsfuju=vhAd2GDoj_aH811pv17C6YOQ@mail.gmail.com>
Subject: Re: [PATCH] regulator: s2mps11: Fix ERR_PTR dereference on GPIO
 lookup failure
To:     Sasha Levin <sashal@kernel.org>
Cc:     Sangbeom Kim <sbkim73@samsung.com>,
        Georg Waibel <georg.waibel@sensor-technik.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 22 Jun 2019 at 20:13, Sasha Levin <sashal@kernel.org> wrote:
>
> Hi,
>
> [This is an automated email]
>
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: 1c984942f0a4 regulator: s2mps11: Pass descriptor instead of GPIO number.
>
> The bot has tested the following trees: v5.1.12, v4.19.53.
>
> v5.1.12: Build OK!
> v4.19.53: Failed to apply! Possible dependencies:
>     Unable to calculate
>
>
> How should we proceed with this patch?

The commit mentioned in fixes tag (1c984942f0a4) came in
v5.0-rc1/v5.0. Why do you try to port it to v4.19?

Best regards,
Krzysztof
