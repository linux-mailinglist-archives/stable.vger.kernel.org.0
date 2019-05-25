Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6068B2A338
	for <lists+stable@lfdr.de>; Sat, 25 May 2019 08:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfEYG41 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 May 2019 02:56:27 -0400
Received: from asavdk3.altibox.net ([109.247.116.14]:49398 "EHLO
        asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbfEYG41 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 May 2019 02:56:27 -0400
Received: from ravnborg.org (unknown [158.248.194.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by asavdk3.altibox.net (Postfix) with ESMTPS id 3D13420096;
        Sat, 25 May 2019 08:56:23 +0200 (CEST)
Date:   Sat, 25 May 2019 08:56:21 +0200
From:   Sam Ravnborg <sam@ravnborg.org>
To:     =?iso-8859-1?Q?S=E9bastien?= Szymanski 
        <sebastien.szymanski@armadeus.com>
Cc:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        NXP Linux Team <linux-imx@nxp.com>,
        Mark Rutland <mark.rutland@arm.com>,
        David Airlie <airlied@linux.ie>, stable@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>
Subject: Re: [PATCH RE-RESEND 1/2] drm/panel: Add support for Armadeus ST0700
 Adapt
Message-ID: <20190525065621.GC9586@ravnborg.org>
References: <20190507152713.27494-1-sebastien.szymanski@armadeus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190507152713.27494-1-sebastien.szymanski@armadeus.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.3 cv=dqr19Wo4 c=1 sm=1 tr=0
        a=UWs3HLbX/2nnQ3s7vZ42gw==:117 a=UWs3HLbX/2nnQ3s7vZ42gw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=8nJEP1OIZ-IA:10 a=VwQbUJbxAAAA:8
        a=k4gcJ1N8AAAA:8 a=rQ_wcCec06wBi9E7-2gA:9 a=wPNLvfGTeEIA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=0EuUHwVWM4Mljrm1lpjw:22
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 07, 2019 at 05:27:12PM +0200, Sébastien Szymanski wrote:
> This patch adds support for the Armadeus ST0700 Adapt. It comes with a
> Santek ST0700I5Y-RBSLW 7.0" WVGA (800x480) TFT and an adapter board so
> that it can be connected on the TFT header of Armadeus Dev boards.
> 
> Cc: stable@vger.kernel.org # v4.19
> Reviewed-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Sébastien Szymanski <sebastien.szymanski@armadeus.com>

Thanks, applied.
Only patch 1/2 applied, as patch 2/2 is missing review.

	Sam
