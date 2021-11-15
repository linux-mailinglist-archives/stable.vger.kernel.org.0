Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EEE74508B3
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 16:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232323AbhKOPlk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 10:41:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:55088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230101AbhKOPlj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 10:41:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1BB761504;
        Mon, 15 Nov 2021 15:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636990724;
        bh=wm/8LH6ma6lVEL1guWimjUz0yhQU69llXWlDtImY87c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N1XsupCrgz8p7hQmMTgbT9l5qDhRQWatiyqfQ2k1+sLWHjLqRJIn5CEryRpQ+1XQ9
         zP3y8Mou/r4w36eLy4sx81zIgZZh2Y6lbuNGiiObp4ThdK7R2/Q/Mu2xa/wKlnVRy7
         64lwX6cWQJwbAKNy6L28ayYuUtu32779dYeMOazC2TTEDd/6Wxt8/gHsXxjVybwNNj
         k9S8m1j9cqNg1FoisLs4IVriAJK3yJas3rJ/pjy4jWCMF5wU14mMegD7kEV+xBHfL6
         SPKDbVZYQCPnqdLS+FRbJCgwEOH3xdg9aUC0BCv2W2NnB5rZNYdw/K0qTnn6phg778
         jWEjvFF48+Hew==
Received: by pali.im (Postfix)
        id 62608949; Mon, 15 Nov 2021 16:38:41 +0100 (CET)
Date:   Mon, 15 Nov 2021 16:38:41 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        lorenzo.pieralisi@arm.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] PCI: aardvark: Fix PCIe Max Payload Size
 setting" failed to apply to 5.15-stable tree
Message-ID: <20211115153841.ftphwo7k5hefayfp@pali>
References: <1636899211215194@kroah.com>
 <20211114142033.isnb6hszl6b5rozt@pali>
 <YZJ9z4N64bzgl97E@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YZJ9z4N64bzgl97E@kroah.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Monday 15 November 2021 16:33:35 Greg KH wrote:
> On Sun, Nov 14, 2021 at 03:20:33PM +0100, Pali Rohár wrote:
> > On Sunday 14 November 2021 15:13:31 gregkh@linuxfoundation.org wrote:
> > > The patch below does not apply to the 5.15-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git commit
> > > id to <stable@vger.kernel.org>.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > Hello Greg! Following patch is needed for PCI_EXP_DEVCTL_PAYLOAD_512B macro:
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=460275f124fb072dca218a6b43b6370eebbab20d
> 
> Thanks, that solved the issue here for 5.10 and newer, but not for
> 4.9.y, 4.14.y, 4.19.y and 5.4.y.  Can you send fixes for them if it
> matters?

Marek told me that would take care of backporting aardvark related
patches to stable trees. He is already in CC list.
