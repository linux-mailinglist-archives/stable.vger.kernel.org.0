Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2B12B8A71
	for <lists+stable@lfdr.de>; Thu, 19 Nov 2020 04:39:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbgKSDhG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 22:37:06 -0500
Received: from 99-33-87-210.lightspeed.sntcca.sbcglobal.net ([99.33.87.210]:60384
        "EHLO mail.aaazen.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbgKSDhG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Nov 2020 22:37:06 -0500
X-Greylist: delayed 395 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Nov 2020 22:37:06 EST
Received: from localhost (localhost [127.0.0.1])
        by thursday.test (OpenSMTPD) with ESMTP id 789ac693;
        Thu, 19 Nov 2020 03:30:25 +0000 (UTC)
Date:   Wed, 18 Nov 2020 19:30:25 -0800 (PST)
From:   Richard Narron <richard@aaazen.com>
X-X-Sender: richard@thursday.test
To:     Johannes Berg <johannes.berg@intel.com>
cc:     Greg KH <greg@kroah.com>, Sasha Levin <sashal@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 5.9 099/255] mac80211: always wind down STA state
Message-ID: <alpine.LNX.2.20.2011181915260.441@thursday.test>
User-Agent: Alpine 2.20 (LNX 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch is 5.9.9-rc1 but is missing from the new 5.9.9 on kernel.org.

Is this desirable?

https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.9-rc1.xz

https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/incr/patch-5.9.8-9.xz

I like to compare the stable review and incremental patches and if they
are substantially the same then I just keep using the stable review
version...
