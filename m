Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51BEC17CD28
	for <lists+stable@lfdr.de>; Sat,  7 Mar 2020 10:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgCGJOC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Mar 2020 04:14:02 -0500
Received: from elvis.franken.de ([193.175.24.41]:54703 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726339AbgCGJOC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 7 Mar 2020 04:14:02 -0500
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1jAVWw-0000pd-00; Sat, 07 Mar 2020 10:13:58 +0100
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 5A923C0FA0; Sat,  7 Mar 2020 10:06:17 +0100 (CET)
Date:   Sat, 7 Mar 2020 10:06:17 +0100
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     Paul Cercueil <paul@crapouillou.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, letux-kernel@openphoenux.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v6] MIPS: DTS: CI20: fix PMU definitions for ACT8600
Message-ID: <20200307090617.GA4570@alpha.franken.de>
References: <cccce8a3866e54859d04b3f67c7414c3efb1eedd.1583515678.git.hns@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cccce8a3866e54859d04b3f67c7414c3efb1eedd.1583515678.git.hns@goldelico.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 06, 2020 at 06:27:58PM +0100, H. Nikolaus Schaller wrote:
> There is a ACT8600 on the CI20 board and the bindings of the
> ACT8865 driver have changed without updating the CI20 device
> tree. Therefore the PMU can not be probed successfully and
> is running in power-on reset state.
> 
> Fix DT to match the latest act8865-regulator bindings.
> 
> Fixes: 73f2b940474d ("MIPS: CI20: DTS: Add I2C nodes")
> Cc: stable@vger.kernel.org
> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
> Reviewed-by: Paul Cercueil <paul@crapouillou.net>
> ---
>  arch/mips/boot/dts/ingenic/ci20.dts | 39 ++++++++++++++++++-----------
>  1 file changed, 24 insertions(+), 15 deletions(-)

applied to mips-fixes.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
