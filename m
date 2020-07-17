Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88E2A22362E
	for <lists+stable@lfdr.de>; Fri, 17 Jul 2020 09:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726113AbgGQHtC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 17 Jul 2020 03:49:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726855AbgGQHtC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jul 2020 03:49:02 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A57EC08C5C0
        for <stable@vger.kernel.org>; Fri, 17 Jul 2020 00:49:02 -0700 (PDT)
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1jwL74-0007TD-Ht; Fri, 17 Jul 2020 09:48:58 +0200
Received: from pza by lupine with local (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1jwL73-0004Ud-J7; Fri, 17 Jul 2020 09:48:57 +0200
Message-ID: <05184a7c923c7e2aacca9da2bafe338ff5a7c16d.camel@pengutronix.de>
Subject: Re: [PATCH 2/2] media: coda: Add more H264 levels for CODA960
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org
Cc:     Hans Verkuil <hverkuil@xs4all.nl>,
        Robert Beckett <bob.beckett@collabora.com>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        kernel@collabora.com, stable@vger.kernel.org
Date:   Fri, 17 Jul 2020 09:48:57 +0200
In-Reply-To: <20200717034923.219524-2-ezequiel@collabora.com>
References: <20200717034923.219524-1-ezequiel@collabora.com>
         <20200717034923.219524-2-ezequiel@collabora.com>
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

Hi Ezequiel, Nicolas,

On Fri, 2020-07-17 at 00:49 -0300, Ezequiel Garcia wrote:
> From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
> 
> This add H264 level 4.1, 4.2 and 5.0 to the list of supported formats.
> While the hardware does not fully support these levels, it do support
> most of them.

Could you clarify this? As far as I understand the hardware supports
maximum frame size requirement for up to level 4.2 (8704 macroblocks),
but not 5.0, and at least the implementation on i.MX6 does not support
the max encoding speed requirements for levels 4.1 and higher.

I don't think the firmware ever produces any output with a level higher
than 4.0 either, so what is the purpose of pretending otherwise?

regards
Philipp
