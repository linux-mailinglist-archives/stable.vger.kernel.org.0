Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8135239C498
	for <lists+stable@lfdr.de>; Sat,  5 Jun 2021 02:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbhFEAoU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Jun 2021 20:44:20 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:57063 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbhFEAoT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Jun 2021 20:44:19 -0400
Received: (Authenticated sender: josh@joshtriplett.org)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 21C85200002;
        Sat,  5 Jun 2021 00:42:29 +0000 (UTC)
Date:   Fri, 4 Jun 2021 17:42:28 -0700
From:   Josh Triplett <josh@joshtriplett.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, 989451@bugs.debian.org,
        Salvatore Bonaccorso <carnil@debian.org>
Subject: Re: [5.10.x] Please backport "net: usb: cdc_ncm: don't spew
 notifications" (de658a195ee23ca6aaffe197d1d2ea040beea0a2)
Message-ID: <YLrIdCtcfHIWNAs0@localhost>
References: <YLpRCHB1R1qhBZsk@localhost>
 <YLpXIXV96XXv3PP5@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YLpXIXV96XXv3PP5@sashalap>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 04, 2021 at 12:38:57PM -0400, Sasha Levin wrote:
> On Fri, Jun 04, 2021 at 09:12:56AM -0700, Josh Triplett wrote:
> > Some USB Ethernet devices using the cdc_ncm driver produce several of
> > these messages per second:
> > 
> > Jun 03 19:25:17 s kernel: cdc_ncm 3-2.2:2.0 enx(mac address): 1000 mbit/s downlink 1000 mbit/s uplink
> > 
> > This results in substantial log noise and disk usage.
> > 
> > Please consider backporting
> > net: usb: cdc_ncm: don't spew notifications
> > (git commit de658a195ee23ca6aaffe197d1d2ea040beea0a2)
> > to the 5.10.x stable kernel, to fix this problem.
> 
> Queued up, thanks!

Thank you!
