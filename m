Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B23B91748C
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 11:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbfEHJGS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 05:06:18 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:38211 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbfEHJGS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 May 2019 05:06:18 -0400
Received: by mail-ed1-f66.google.com with SMTP id w11so21376126edl.5
        for <stable@vger.kernel.org>; Wed, 08 May 2019 02:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=sender:date:from:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=ZCByRjUdoltM6JQS2wK/k1Vsg/2ECYjryZKrL53UB1A=;
        b=cAzcttZx8IOcmQDqtJutN0W3TZIg84Kt+H8yqc/dtHNn73Y2pzR4uGqqCerk+xxpRK
         kCgJj/0Cr/9osHXLk0jMGb0DbsYQmdwOxkCRSgnYBTOS4elaRx1CcurT+vvHJOsLuOZf
         kJPxniGaN7IRwAIl1yJA3kUC4nDvoPbGXpO0o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=ZCByRjUdoltM6JQS2wK/k1Vsg/2ECYjryZKrL53UB1A=;
        b=a/BHEzFo1qBrf5XGQKVE6YZI6aYYvWsvMKdrN7KXKYgNn2FsFitI8Aio1Ex3QR4HTo
         NuGtgLH7UQmk81RlHwJxHt5VH2YNWZuoEREhvmj616lpKg+02XEWjmNzT3am9QfglxaW
         i45dy8PSAPkcw1M02lKa3F9VO084bnFCbyK5KEsDyjy+zsv1DVzxlEQNp30+/rqVukdX
         q8NYw+4at/xT82Eq32JKYDEnWAdfPWrFoJAPeT0VSwlh1vHzHKVmEvNKZY1vs+iFVWx8
         /oMlcFHg/zLZI9knNpvFBHN/IBaJWs95xFrNluBXgIca7gkJL4M4Spu6fO+NjgbgtHad
         EQHw==
X-Gm-Message-State: APjAAAXahN3zJDoRIJJiUg+ESzbaco4Tfl7x/szfseUCr5qTwzbtZTBV
        VvPPUeS3szA3je27fCbG8mQclQ==
X-Google-Smtp-Source: APXvYqyhIyJzQJ2/WQmKoGSeee8pS6Iu8b2u59hMI6uOyjAOYUPnEY7pFFD0PgsSnAjiyZEjRhbMSQ==
X-Received: by 2002:a17:906:a48:: with SMTP id x8mr3642206ejf.247.1557306376650;
        Wed, 08 May 2019 02:06:16 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:569e:0:3106:d637:d723:e855])
        by smtp.gmail.com with ESMTPSA id f44sm4982723eda.73.2019.05.08.02.06.15
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 08 May 2019 02:06:15 -0700 (PDT)
Date:   Wed, 8 May 2019 11:06:12 +0200
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
Message-ID: <20190508090612.GT17751@phenom.ffwll.local>
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
 <20190508083303.GR17751@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190508083303.GR17751@phenom.ffwll.local>
X-Operating-System: Linux phenom 4.14.0-3-amd64 
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 08, 2019 at 10:33:03AM +0200, Daniel Vetter wrote:
> On Tue, May 07, 2019 at 06:19:50PM +0200, Sam Ravnborg wrote:
> > Hi Fabio
> > 
> > On Tue, May 07, 2019 at 12:33:39PM -0300, Fabio Estevam wrote:
> > > [Adding Sam, who is helping to review/collect panel-simple patches]
> > > 
> > > On Tue, May 7, 2019 at 12:27 PM Sébastien Szymanski
> > > <sebastien.szymanski@armadeus.com> wrote:
> > > >
> > > > This patch adds support for the Armadeus ST0700 Adapt. It comes with a
> > > > Santek ST0700I5Y-RBSLW 7.0" WVGA (800x480) TFT and an adapter board so
> > > > that it can be connected on the TFT header of Armadeus Dev boards.
> > > >
> > > > Cc: stable@vger.kernel.org # v4.19
> > > > Reviewed-by: Rob Herring <robh@kernel.org>
> > > > Signed-off-by: Sébastien Szymanski <sebastien.szymanski@armadeus.com>
> > Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
> > 
> > If you wil lresend the patch I can apply it.
> > I have lost the original mail.
> 
> Usually patchwork should have it already (and you can pipe the raw
> patchwork mbox into dim apply), but somehow it's not there either.
> Not sure why, sometimes this is because mails are stuck in moderation,
> sometimes because people do interesting things with their mails (e.g. smtp
> servers mangling formatting).

patchwork was just a bit slow, it's there now:

https://patchwork.freedesktop.org/series/60408/

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
