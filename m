Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E99B513FFFC
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388351AbgAPXq6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:46:58 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:57582 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390819AbgAPXV0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jan 2020 18:21:26 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 3828C29997;
        Thu, 16 Jan 2020 18:21:23 -0500 (EST)
Date:   Fri, 17 Jan 2020 10:21:26 +1100 (AEDT)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Sasha Levin <sashal@kernel.org>
cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-m68k@lists.linux-m68k.org
Subject: Re: [PATCH AUTOSEL 4.4 064/174] m68k: mac: Fix VIA timer counter
 accesses
In-Reply-To: <20200116174251.24326-64-sashal@kernel.org>
Message-ID: <alpine.LNX.2.21.1.2001170929550.255@nippy.intranet>
References: <20200116174251.24326-1-sashal@kernel.org> <20200116174251.24326-64-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On Thu, 16 Jan 2020, Sasha Levin wrote:

> From: Finn Thain <fthain@telegraphics.com.au>
> 
> [ Upstream commit 0ca7ce7db771580433bf24454f7a1542bd326078 ]
> 

This commit has been selected for 4.4, 4.9, 4.14 and 4.19. But this commit 
has questionable value without it's parent, commit 1efdd4bd2543 ("m68k: 
Call timer_interrupt() with interrupts disabled").

For all stable branches, I'd prefer you selected both commits or neither, 
because I periodically backport to a branch based on stable/linux-4.14.y.

Thanks.
