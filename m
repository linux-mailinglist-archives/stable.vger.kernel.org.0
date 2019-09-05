Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BEC3A9D93
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 10:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731338AbfIEI4M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 04:56:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:53070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726231AbfIEI4M (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Sep 2019 04:56:12 -0400
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC3D021743;
        Thu,  5 Sep 2019 08:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567673771;
        bh=nxynrq1ZfNXPmxOvki9jsnLzdsi03WB1FQJR4M9tk9E=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ecyFj7MxRKASyJLrsL7kjE7VL6EGorP4cT5Z64pFYPksHfFHpZq++Vistm/eDhA/I
         GlZ7DfdU8fVfLFoqLKajsUIIuXI1A3dnnvl9MPvfN4Iq0XowyLbXSdttXZoUpwNFgd
         MyejiMAf0qs1wvlS8CdTggdiz2OzFkcNkbGHpyNk=
Received: by mail-qt1-f172.google.com with SMTP id k10so1913803qth.2;
        Thu, 05 Sep 2019 01:56:10 -0700 (PDT)
X-Gm-Message-State: APjAAAWE2xkPS0TYBRsBzBSUhweYfl5sCATqBMOlcOiwgeE6Qskgiadf
        6c+tkdx94zWz4SlqqY4aGB8pd6ZZQ9C9ksNikg==
X-Google-Smtp-Source: APXvYqwe7WYxk3XElGIIkDrb0I2DrV8ccOBgRzEx1xzn6PSLs7xZ9sDEOQkVezo7W2c1bqph8/273A3ZNIydErCuYfc=
X-Received: by 2002:ac8:6b05:: with SMTP id w5mr2408517qts.136.1567673770094;
 Thu, 05 Sep 2019 01:56:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190903162519.7136-1-sashal@kernel.org> <20190903162519.7136-147-sashal@kernel.org>
In-Reply-To: <20190903162519.7136-147-sashal@kernel.org>
From:   Rob Herring <robh@kernel.org>
Date:   Thu, 5 Sep 2019 09:55:58 +0100
X-Gmail-Original-Message-ID: <CAL_JsqJrwwsp1wjCBnNmx45ZiLTXVY_nCfN6OrJ5o9dLbc+_2w@mail.gmail.com>
Message-ID: <CAL_JsqJrwwsp1wjCBnNmx45ZiLTXVY_nCfN6OrJ5o9dLbc+_2w@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.19 147/167] drm/panel: Add support for Armadeus
 ST0700 Adapt
To:     Sasha Levin <sashal@kernel.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        =?UTF-8?Q?S=C3=A9bastien_Szymanski?= 
        <sebastien.szymanski@armadeus.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 3, 2019 at 5:31 PM Sasha Levin <sashal@kernel.org> wrote:
>
> From: S=C3=A9bastien Szymanski <sebastien.szymanski@armadeus.com>
>
> [ Upstream commit c479450f61c7f1f248c9a54aedacd2a6ca521ff8 ]
>
> This patch adds support for the Armadeus ST0700 Adapt. It comes with a
> Santek ST0700I5Y-RBSLW 7.0" WVGA (800x480) TFT and an adapter board so
> that it can be connected on the TFT header of Armadeus Dev boards.
>
> Cc: stable@vger.kernel.org # v4.19
> Reviewed-by: Rob Herring <robh@kernel.org>
> Signed-off-by: S=C3=A9bastien Szymanski <sebastien.szymanski@armadeus.com=
>
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> Link: https://patchwork.freedesktop.org/patch/msgid/20190507152713.27494-=
1-sebastien.szymanski@armadeus.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  .../display/panel/armadeus,st0700-adapt.txt   |  9 ++++++
>  drivers/gpu/drm/panel/panel-simple.c          | 29 +++++++++++++++++++
>  2 files changed, 38 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/display/panel/armad=
eus,st0700-adapt.txt

Looks like a new feature, not stable material. Not sure why it got
tagged for stable.

Rob
