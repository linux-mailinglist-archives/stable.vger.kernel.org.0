Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58D32173E6
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 10:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfEHIdJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 04:33:09 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:34937 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbfEHIdJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 May 2019 04:33:09 -0400
Received: by mail-ed1-f65.google.com with SMTP id p26so3433043edr.2
        for <stable@vger.kernel.org>; Wed, 08 May 2019 01:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=sender:date:from:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=pK6wVbjmnvB/fkRhlO06WndQQley/CLsWlKi7Lo/4rk=;
        b=jyKQzz7bipEyXQ6mMXMUmxM55YNMYTV09/uuB5zNRCY0/9ZBIP+Lfyi94AaxP8Hj0y
         hnYPMzZdHpSUNgX7RXjh+tdhhT8nVwCAOFUoj8mudlIsy8+E2rpAyby34PhbMF66SUe3
         RGDCf2Tg5xAYPjSK0ABIlA3ukX0dLv5ZwK9Bs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=pK6wVbjmnvB/fkRhlO06WndQQley/CLsWlKi7Lo/4rk=;
        b=XLWVQwGccd7ZcF8T8DWvu9arYyVKKt/cGybV5rsAKyBSWpk48yduQjN5+Mu9WckG5L
         1wyeMIzHNlKd5E+v/CE+a3uIuYz8gfr2yIz1zfn436mxQJssplmakmY4f7r0+sdtj+oy
         RVXnDo2g8MjMazbvOUBrYbZQK1ZMbRE8tQTlUpt7/v9qXyL/ezZ9m1SdUxA8UdCZzsuE
         0ZaikxPOgCAZui16aXIrgJfUF5UKuNQLU6bqvm/8kg/+DKWGxDe4C8eyHXM6TATPfj2T
         WzRY8iJpAU1f+o9+09ZRzaxtTKvuM0O7CaR2aIH5hMbT5yldSyjbV3LN9iRArJPb8qRR
         5aug==
X-Gm-Message-State: APjAAAVp0kQdNvXO83QEl9k1VG6byfhOrVLEKeom0wVQrLCnFohafOQw
        +l42tQn5woXY29AAQf+yEP9A1A==
X-Google-Smtp-Source: APXvYqwUkZlPgHY9vRwVHZGsHkyTtIbJaS1tfENj3GHg4lDVQYijjVoHXXBWgmsCGnRbNduUH4WMew==
X-Received: by 2002:a50:8927:: with SMTP id e36mr38416424ede.54.1557304387856;
        Wed, 08 May 2019 01:33:07 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:569e:0:3106:d637:d723:e855])
        by smtp.gmail.com with ESMTPSA id m27sm2593869eje.67.2019.05.08.01.33.06
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 08 May 2019 01:33:06 -0700 (PDT)
Date:   Wed, 8 May 2019 10:33:03 +0200
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Sam Ravnborg <sam@ravnborg.org>
Cc:     Fabio Estevam <festevam@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, David Airlie <airlied@linux.ie>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Rob Herring <robh+dt@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        stable <stable@vger.kernel.org>,
        =?iso-8859-1?Q?S=E9bastien?= Szymanski 
        <sebastien.szymanski@armadeus.com>,
        Shawn Guo <shawnguo@kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH RE-RESEND 1/2] drm/panel: Add support for Armadeus ST0700
 Adapt
Message-ID: <20190508083303.GR17751@phenom.ffwll.local>
Mail-Followup-To: Sam Ravnborg <sam@ravnborg.org>,
        Fabio Estevam <festevam@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>,
        David Airlie <airlied@linux.ie>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Rob Herring <robh+dt@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        stable <stable@vger.kernel.org>,
        =?iso-8859-1?Q?S=E9bastien?= Szymanski <sebastien.szymanski@armadeus.com>,
        Shawn Guo <shawnguo@kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" <linux-arm-kernel@lists.infradead.org>
References: <20190507152713.27494-1-sebastien.szymanski@armadeus.com>
 <CAOMZO5B2nMsVNO6O_D+YTSjux=-DjNPGxhkEi3AQquOZVODumA@mail.gmail.com>
 <20190507161950.GA24879@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190507161950.GA24879@ravnborg.org>
X-Operating-System: Linux phenom 4.14.0-3-amd64 
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 07, 2019 at 06:19:50PM +0200, Sam Ravnborg wrote:
> Hi Fabio
> 
> On Tue, May 07, 2019 at 12:33:39PM -0300, Fabio Estevam wrote:
> > [Adding Sam, who is helping to review/collect panel-simple patches]
> > 
> > On Tue, May 7, 2019 at 12:27 PM Sébastien Szymanski
> > <sebastien.szymanski@armadeus.com> wrote:
> > >
> > > This patch adds support for the Armadeus ST0700 Adapt. It comes with a
> > > Santek ST0700I5Y-RBSLW 7.0" WVGA (800x480) TFT and an adapter board so
> > > that it can be connected on the TFT header of Armadeus Dev boards.
> > >
> > > Cc: stable@vger.kernel.org # v4.19
> > > Reviewed-by: Rob Herring <robh@kernel.org>
> > > Signed-off-by: Sébastien Szymanski <sebastien.szymanski@armadeus.com>
> Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
> 
> If you wil lresend the patch I can apply it.
> I have lost the original mail.

Usually patchwork should have it already (and you can pipe the raw
patchwork mbox into dim apply), but somehow it's not there either.
Not sure why, sometimes this is because mails are stuck in moderation,
sometimes because people do interesting things with their mails (e.g. smtp
servers mangling formatting).
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
