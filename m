Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1415B24CF4C
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 09:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727902AbgHUHbz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 21 Aug 2020 03:31:55 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:40035 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726864AbgHUHbz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Aug 2020 03:31:55 -0400
X-Greylist: delayed 1279 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Aug 2020 03:31:54 EDT
Received: from [2001:67c:670:100:3ad5:47ff:feaf:1a17] (helo=lupine)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1k91C3-0005l6-7s; Fri, 21 Aug 2020 09:10:31 +0200
Received: from pza by lupine with local (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1k91C2-00045j-Ip; Fri, 21 Aug 2020 09:10:30 +0200
Message-ID: <e586d38120241447df58818c1f9e3c04e5068972.camel@pengutronix.de>
Subject: Re: [PATCH 4.9 196/212] gpu: ipu-v3: image-convert: Combine
 rotate/no-rotate irq handlers
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Date:   Fri, 21 Aug 2020 09:10:30 +0200
In-Reply-To: <20200821070216.GB23823@amd>
References: <20200820091602.251285210@linuxfoundation.org>
         <20200820091612.258939813@linuxfoundation.org> <20200821070216.GB23823@amd>
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

Hi,

On Fri, 2020-08-21 at 09:02 +0200, Pavel Machek wrote:
> Hi!
> 
> > From: Steve Longerbeam <slongerbeam@gmail.com>
> > 
> > [ Upstream commit 0f6245f42ce9b7e4d20f2cda8d5f12b55a44d7d1 ]
> > 
> > Combine the rotate_irq() and norotate_irq() handlers into a single
> > eof_irq() handler.
> 
> AFAICT this is preparation for next patch, not a backfix. And actual
> fix patch is not there for 4.19, so this can be dropped, too.

You are right, this patch is preparation for commit 0f6245f42ce9 ("gpu:
ipu-v3: image-convert: Wait for all EOFs before completing a tile").

regards
Philipp
