Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91548DC628
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 15:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405337AbfJRNei (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 09:34:38 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:44945 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730379AbfJRNei (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Oct 2019 09:34:38 -0400
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1iLSOq-0000QE-KA; Fri, 18 Oct 2019 15:34:36 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <sha@pengutronix.de>)
        id 1iLSOp-0008G9-Vw; Fri, 18 Oct 2019 15:34:35 +0200
Date:   Fri, 18 Oct 2019 15:34:35 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     linux-mmc <linux-mmc@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Bruno Thomsen <bruno.thomsen@gmail.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] mmc: mxs: fix flags passed to dmaengine_prep_slave_sg
Message-ID: <20191018133435.oncn7nktihpqyj4z@pengutronix.de>
References: <20191018093934.29695-1-s.hauer@pengutronix.de>
 <CAOMZO5DUoj4xVZQSvk9Juw9z37UgrMn3g24h2_pAMxuTkBjw4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5DUoj4xVZQSvk9Juw9z37UgrMn3g24h2_pAMxuTkBjw4g@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 15:29:33 up 102 days, 19:39, 100 users,  load average: 0.02, 0.12,
 0.15
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 18, 2019 at 10:25:21AM -0300, Fabio Estevam wrote:
> Hi Sascha,
> 
> On Fri, Oct 18, 2019 at 6:39 AM Sascha Hauer <s.hauer@pengutronix.de> wrote:
> >
> > Since ceeeb99cd821 we no longer abuse the DMA_CTRL_ACK flag for custom
> > driver use and introduced the MXS_DMA_CTRL_WAIT4END instead. We have not
> > changed all users to this flag though. This patch fixes it for the
> > mxs-mmc driver.
> 
> If I read this correctly, this patch is not the complete fix for all users.
> 
> Wouldn't it be better to revert the offending commit instead?

We would probably also have to revert the exec_op conversion of the gpmi
NAND driver, something which I'd rather not do.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
