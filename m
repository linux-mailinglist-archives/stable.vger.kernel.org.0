Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 097B7377D61
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 09:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbhEJHrI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 10 May 2021 03:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbhEJHrH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 03:47:07 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A623C061573
        for <stable@vger.kernel.org>; Mon, 10 May 2021 00:46:03 -0700 (PDT)
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1lg0bz-0001aw-V6; Mon, 10 May 2021 09:45:55 +0200
Received: from pza by lupine with local (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1lg0by-0005Ox-Bt; Mon, 10 May 2021 09:45:54 +0200
Message-ID: <b163b400b046d74967d5e773fc6959281a376d68.camel@pengutronix.de>
Subject: Re: [PATCH v6 1/3] reset: add missing empty function
 reset_control_rearm()
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Jim Quinlan <jim2101024@gmail.com>
Cc:     Amjad Ouled-Ameur <aouledameur@baylibre.com>,
        linux-pci@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        bcm-kernel-feedback-list@broadcom.com, james.quinlan@broadcom.com,
        stable@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
Date:   Mon, 10 May 2021 09:45:54 +0200
In-Reply-To: <20210503185639.GA993318@bjorn-Precision-5520>
References: <20210503185639.GA993318@bjorn-Precision-5520>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:1a17
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2021-05-03 at 13:56 -0500, Bjorn Helgaas wrote:
> On Fri, Apr 30, 2021 at 11:21:54AM -0400, Jim Quinlan wrote:
> > All other functions are defined for when CONFIG_RESET_CONTROLLER
> > is not set.
> > 
> > Fixes: 557acb3d2cd9 ("reset: make shared pulsed reset controls re-triggerable")
> > CC: stable@vger.kernel.org # v5.11+
> > Signed-off-by: Jim Quinlan <jim2101024@gmail.com>
> 
> Philipp, I'd like to merge this via the PCI tree since the brcmstb
> patch depends on it.  It looks correct to me, but I'd really like to
> have your ack before merging it.

Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp
