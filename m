Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E36017CD2A
	for <lists+stable@lfdr.de>; Sat,  7 Mar 2020 10:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbgCGJOC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Mar 2020 04:14:02 -0500
Received: from elvis.franken.de ([193.175.24.41]:54707 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbgCGJOB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 7 Mar 2020 04:14:01 -0500
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1jAVWw-0000pd-01; Sat, 07 Mar 2020 10:13:58 +0100
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 7989AC0FA3; Sat,  7 Mar 2020 10:06:36 +0100 (CET)
Date:   Sat, 7 Mar 2020 10:06:36 +0100
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     Paul Cercueil <paul@crapouillou.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, letux-kernel@openphoenux.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v6] MIPS: DTS: CI20: fix interrupt for pcf8563 RTC
Message-ID: <20200307090636.GB4570@alpha.franken.de>
References: <7fbde64be07dc3c78343890e6597c1b2636d4815.1583515710.git.hns@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7fbde64be07dc3c78343890e6597c1b2636d4815.1583515710.git.hns@goldelico.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 06, 2020 at 06:28:30PM +0100, H. Nikolaus Schaller wrote:
> Interrupts should not be specified by interrupt line but by
> gpio parent and reference.
> 
> Fixes: 73f2b940474d ("MIPS: CI20: DTS: Add I2C nodes")
> Cc: stable@vger.kernel.org
> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
> Reviewed-by: Paul Cercueil <paul@crapouillou.net>
> ---
>  arch/mips/boot/dts/ingenic/ci20.dts | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

applied to mips-fixes.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
