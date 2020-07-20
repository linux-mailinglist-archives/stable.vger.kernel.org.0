Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFCA42260B3
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 15:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgGTNWo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 20 Jul 2020 09:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbgGTNWo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 09:22:44 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89458C061794
        for <stable@vger.kernel.org>; Mon, 20 Jul 2020 06:22:44 -0700 (PDT)
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1jxVkf-0005Ny-IM; Mon, 20 Jul 2020 15:22:41 +0200
Received: from pza by lupine with local (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1jxVkf-0006sJ-4Y; Mon, 20 Jul 2020 15:22:41 +0200
Message-ID: <85fd0e51194c031a5037acecbe64a02b5eebd3fe.camel@pengutronix.de>
Subject: Re: [PATCH RESEND] drm/imx: imx-ldb: Disable both channels for
 split mode in enc->disable()
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Liu Ying <victor.liu@nxp.com>, dri-devel@lists.freedesktop.org
Cc:     Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>, stable@vger.kernel.org
Date:   Mon, 20 Jul 2020 15:22:41 +0200
In-Reply-To: <1594261732-16388-1-git-send-email-victor.liu@nxp.com>
References: <1594261732-16388-1-git-send-email-victor.liu@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:1a17
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2020-07-09 at 10:28 +0800, Liu Ying wrote:
> Both of the two LVDS channels should be disabled for split mode
> in the encoder's ->disable() callback, because they are enabled
> in the encoder's ->enable() callback.
> 
> Fixes: 6556f7f82b9c ("drm: imx: Move imx-drm driver out of staging")
> Cc: Philipp Zabel <p.zabel@pengutronix.de>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Pengutronix Kernel Team <kernel@pengutronix.de>
> Cc: NXP Linux Team <linux-imx@nxp.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Liu Ying <victor.liu@nxp.com>

Thank you, applied to imx-drm/next.

regards
Philipp
