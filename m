Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0B5D33911B
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 16:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbhCLPUJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 10:20:09 -0500
Received: from elvis.franken.de ([193.175.24.41]:53102 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232035AbhCLPTr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Mar 2021 10:19:47 -0500
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1lKjZo-0002cX-00; Fri, 12 Mar 2021 16:19:44 +0100
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 98FE4C2118; Fri, 12 Mar 2021 16:19:34 +0100 (CET)
Date:   Fri, 12 Mar 2021 16:19:34 +0100
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc:     Tiezhu Yang <yangtiezhu@loongson.cn>,
        Jinyang He <hejinyang@loongson.cn>,
        Mike Rapoport <rppt@kernel.org>,
        Youling Tang <tangyouling@loongson.cn>,
        Tobias Wolf <dev-NTEO@vplace.de>,
        Marcin Nowakowski <marcin.nowakowski@mips.com>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] MIPS: fix memory reservation for non-usermem setups
Message-ID: <20210312151934.GA4209@alpha.franken.de>
References: <20210307194030.8007-1-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210307194030.8007-1-ilya.lipnitskiy@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 07, 2021 at 11:40:30AM -0800, Ilya Lipnitskiy wrote:
> From: Tobias Wolf <dev-NTEO@vplace.de>
> 
> Commit 67a3ba25aa95 ("MIPS: Fix incorrect mem=X@Y handling") introduced a new
> issue for rt288x where "PHYS_OFFSET" is 0x0 but the calculated "ramstart" is
> not. As the prerequisite of custom memory map has been removed, this results
> in the full memory range of 0x0 - 0x8000000 to be marked as reserved for this
> platform.

and where is the problem here ?

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
