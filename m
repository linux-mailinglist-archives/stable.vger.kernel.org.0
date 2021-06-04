Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00C0939BCC6
	for <lists+stable@lfdr.de>; Fri,  4 Jun 2021 18:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbhFDQOs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Jun 2021 12:14:48 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:48245 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231448AbhFDQOr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Jun 2021 12:14:47 -0400
Received: (Authenticated sender: josh@joshtriplett.org)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 19630E0008;
        Fri,  4 Jun 2021 16:12:57 +0000 (UTC)
Date:   Fri, 4 Jun 2021 09:12:56 -0700
From:   Josh Triplett <josh@joshtriplett.org>
To:     stable@vger.kernel.org
Cc:     989451@bugs.debian.org, Salvatore Bonaccorso <carnil@debian.org>
Subject: [5.10.x] Please backport "net: usb: cdc_ncm: don't spew
 notifications" (de658a195ee23ca6aaffe197d1d2ea040beea0a2)
Message-ID: <YLpRCHB1R1qhBZsk@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Some USB Ethernet devices using the cdc_ncm driver produce several of
these messages per second:

Jun 03 19:25:17 s kernel: cdc_ncm 3-2.2:2.0 enx(mac address): 1000 mbit/s downlink 1000 mbit/s uplink

This results in substantial log noise and disk usage.

Please consider backporting
net: usb: cdc_ncm: don't spew notifications
(git commit de658a195ee23ca6aaffe197d1d2ea040beea0a2)
to the 5.10.x stable kernel, to fix this problem.

Thanks,
Josh Triplett
