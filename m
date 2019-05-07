Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF337167AE
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 18:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbfEGQT5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 12:19:57 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:53410 "EHLO
        asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbfEGQT5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 12:19:57 -0400
Received: from ravnborg.org (unknown [158.248.194.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by asavdk4.altibox.net (Postfix) with ESMTPS id 57E01803FE;
        Tue,  7 May 2019 18:19:52 +0200 (CEST)
Date:   Tue, 7 May 2019 18:19:50 +0200
From:   Sam Ravnborg <sam@ravnborg.org>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     =?iso-8859-1?Q?S=E9bastien?= Szymanski 
        <sebastien.szymanski@armadeus.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, David Airlie <airlied@linux.ie>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Rob Herring <robh+dt@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        stable <stable@vger.kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH RE-RESEND 1/2] drm/panel: Add support for Armadeus ST0700
 Adapt
Message-ID: <20190507161950.GA24879@ravnborg.org>
References: <20190507152713.27494-1-sebastien.szymanski@armadeus.com>
 <CAOMZO5B2nMsVNO6O_D+YTSjux=-DjNPGxhkEi3AQquOZVODumA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOMZO5B2nMsVNO6O_D+YTSjux=-DjNPGxhkEi3AQquOZVODumA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.3 cv=VcLZwmh9 c=1 sm=1 tr=0
        a=UWs3HLbX/2nnQ3s7vZ42gw==:117 a=UWs3HLbX/2nnQ3s7vZ42gw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=8nJEP1OIZ-IA:10 a=k4gcJ1N8AAAA:8
        a=VwQbUJbxAAAA:8 a=7gkXJVJtAAAA:8 a=t7PmZwswHXuigcJotc4A:9
        a=wPNLvfGTeEIA:10 a=0EuUHwVWM4Mljrm1lpjw:22 a=AjGcO6oz07-iQ99wixmX:22
        a=E9Po1WZjFZOl8hwRPBS3:22
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Fabio

On Tue, May 07, 2019 at 12:33:39PM -0300, Fabio Estevam wrote:
> [Adding Sam, who is helping to review/collect panel-simple patches]
> 
> On Tue, May 7, 2019 at 12:27 PM Sébastien Szymanski
> <sebastien.szymanski@armadeus.com> wrote:
> >
> > This patch adds support for the Armadeus ST0700 Adapt. It comes with a
> > Santek ST0700I5Y-RBSLW 7.0" WVGA (800x480) TFT and an adapter board so
> > that it can be connected on the TFT header of Armadeus Dev boards.
> >
> > Cc: stable@vger.kernel.org # v4.19
> > Reviewed-by: Rob Herring <robh@kernel.org>
> > Signed-off-by: Sébastien Szymanski <sebastien.szymanski@armadeus.com>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>

If you wil lresend the patch I can apply it.
I have lost the original mail.

	Sam
