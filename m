Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF9C1E598D
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 09:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726114AbgE1HqS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 03:46:18 -0400
Received: from elvis.franken.de ([193.175.24.41]:42134 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725747AbgE1HqR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 May 2020 03:46:17 -0400
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1jeDF0-0000aG-01; Thu, 28 May 2020 09:46:14 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id D3155C05A4; Thu, 28 May 2020 09:44:48 +0200 (CEST)
Date:   Thu, 28 May 2020 09:44:48 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Lichao Liu <liulichao@loongson.cn>
Cc:     Paul Burton <paulburton@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Max Filippov <jcmvbkbc@gmail.com>, jiaxun.yang@flygoat.com,
        yuanjunqing@loongson.cn, linux-mips@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] MIPS: CPU_LOONGSON2EF need software to maintain cache
 consistency
Message-ID: <20200528074448.GB10708@alpha.franken.de>
References: <20200528011031.30472-1-liulichao@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200528011031.30472-1-liulichao@loongson.cn>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 28, 2020 at 09:10:31AM +0800, Lichao Liu wrote:
> CPU_LOONGSON2EF need software to maintain cache consistency,
> so modify the 'cpu_needs_post_dma_flush' function to return true
> when the cpu type is CPU_LOONGSON2EF.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Lichao Liu <liulichao@loongson.cn>
> ---
>  arch/mips/mm/dma-noncoherent.c | 1 +
>  1 file changed, 1 insertion(+)

applied to mips-next.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
