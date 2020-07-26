Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB57122DD4B
	for <lists+stable@lfdr.de>; Sun, 26 Jul 2020 10:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbgGZIcd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Jul 2020 04:32:33 -0400
Received: from elvis.franken.de ([193.175.24.41]:49113 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726072AbgGZIcX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 26 Jul 2020 04:32:23 -0400
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1jzc4y-0004Hg-03; Sun, 26 Jul 2020 10:32:20 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id B9282C0A2D; Sun, 26 Jul 2020 10:25:17 +0200 (CEST)
Date:   Sun, 26 Jul 2020 10:25:17 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Huacai Chen <chenhc@lemote.com>
Cc:     linux-mips@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>,
        Zhangjin Wu <wuzhangjin@gmail.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>, stable@vger.kernel.org
Subject: Re: [PATCH V2] MIPS: CPU#0 is not hotpluggable
Message-ID: <20200726082517.GD5032@alpha.franken.de>
References: <1594896024-16624-1-git-send-email-chenhc@lemote.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1594896024-16624-1-git-send-email-chenhc@lemote.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 16, 2020 at 06:40:23PM +0800, Huacai Chen wrote:
> Now CPU#0 is not hotpluggable on MIPS, so prevent to create /sys/devices
> /system/cpu/cpu0/online which confuses some user-space tools.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Huacai Chen <chenhc@lemote.com>
> ---
>  arch/mips/kernel/topology.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

applied to mips-next.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
