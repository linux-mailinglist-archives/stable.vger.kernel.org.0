Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6B71E573E
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 08:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725859AbgE1GFv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 02:05:51 -0400
Received: from vultr.net.flygoat.com ([149.28.68.211]:34534 "EHLO
        vultr.net.flygoat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726865AbgE1GFv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 May 2020 02:05:51 -0400
Received: from halation.net.flygoat.com (unknown [IPv6:240e:390:496:b320::d68])
        by vultr.net.flygoat.com (Postfix) with ESMTPSA id 9D96D20CD9;
        Thu, 28 May 2020 06:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=flygoat.com; s=vultr;
        t=1590645949; bh=Ho4pFiBTK0b1RFHQK73QvDFA2lb+uBeQcoEsdeDMBAs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gif+VHiIQWuyc38H12mkESetQ0SP42fyoAidJyO4hCLBZVRQs4mMERuCbu3P5AJvE
         PPx/lGRSoMFhl6owVNizz7M4QTx2THrxZ4x98adMNKdl/4v95frKxg7QuhPqhkkSXr
         8t6w7Y7h5/Z2sa+NIf05WoO/M0aQfOVUYo1K4NKmzpmLxl/YNIElyhbPSJVPwJUMCi
         o7dw74FcoEI9f4hZaBnyVg0o9XBm4XvchLTkCdRpbe8rawrzSjZJklm8BRhh+TAD64
         cBvz+KHaQPcFLp5ngA2bqVlK+yI9AD8B/ou3Qu8N7f/ObzS/tVpf+9PgDB4b3dFLNM
         JpKO/zWac4/1w==
Date:   Thu, 28 May 2020 14:05:35 +0800
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     Lichao Liu <liulichao@loongson.cn>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paul Burton <paulburton@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Max Filippov <jcmvbkbc@gmail.com>, yuanjunqing@loongson.cn,
        linux-mips@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] MIPS: CPU_LOONGSON2EF need software to maintain cache
 consistency
Message-ID: <20200528140535.1e2d9154@halation.net.flygoat.com>
In-Reply-To: <20200528011031.30472-1-liulichao@loongson.cn>
References: <20200528011031.30472-1-liulichao@loongson.cn>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 28 May 2020 09:10:31 +0800
Lichao Liu <liulichao@loongson.cn> wrote:

> CPU_LOONGSON2EF need software to maintain cache consistency,
> so modify the 'cpu_needs_post_dma_flush' function to return true
> when the cpu type is CPU_LOONGSON2EF.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Lichao Liu <liulichao@loongson.cn>

Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>

Thanks!

[...]

