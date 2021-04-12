Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0001335C989
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 17:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242729AbhDLPRI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 11:17:08 -0400
Received: from elvis.franken.de ([193.175.24.41]:45480 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242681AbhDLPRI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 11:17:08 -0400
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1lVyIy-0006wH-01; Mon, 12 Apr 2021 17:16:48 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id D651DC02C4; Mon, 12 Apr 2021 17:05:29 +0200 (CEST)
Date:   Mon, 12 Apr 2021 17:05:29 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Paul Burton <paulburton@kernel.org>, Tom Rini <trini@konsulko.com>,
        Simon Glass <sjg@chromium.org>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] MIPS: generic: Update node names to avoid unit addresses
Message-ID: <20210412150529.GB23632@alpha.franken.de>
References: <20210409174734.GJ1310@bill-the-cat>
 <20210409192128.3998606-1-nathan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210409192128.3998606-1-nathan@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 09, 2021 at 12:21:28PM -0700, Nathan Chancellor wrote:
> With the latest mkimage from U-Boot 2021.04, the generic defconfigs no
> longer build, failing with:
> 
> /usr/bin/mkimage: verify_header failed for FIT Image support with exit code 1
> 
> This is expected after the linked U-Boot commits because '@' is
> forbidden in the node names due to the way that libfdt treats nodes with
> the same prefix but different unit addresses.
> 
> Switch the '@' in the node name to '-'. Drop the unit addresses from the
> hash and kernel child nodes because there is only one node so they do
> not need to have a number to differentiate them.
> 
> Cc: stable@vger.kernel.org
> Link: https://source.denx.de/u-boot/u-boot/-/commit/79af75f7776fc20b0d7eb6afe1e27c00fdb4b9b4
> Link: https://source.denx.de/u-boot/u-boot/-/commit/3f04db891a353f4b127ed57279279f851c6b4917
> Suggested-by: Simon Glass <sjg@chromium.org>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  arch/mips/generic/board-boston.its.S   | 10 +++++-----
>  arch/mips/generic/board-jaguar2.its.S  | 16 ++++++++--------
>  arch/mips/generic/board-luton.its.S    |  8 ++++----
>  arch/mips/generic/board-ni169445.its.S | 10 +++++-----
>  arch/mips/generic/board-ocelot.its.S   | 20 ++++++++++----------
>  arch/mips/generic/board-serval.its.S   |  8 ++++----
>  arch/mips/generic/board-xilfpga.its.S  | 10 +++++-----
>  arch/mips/generic/vmlinux.its.S        | 10 +++++-----
>  8 files changed, 46 insertions(+), 46 deletions(-)

applied to mips-next.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
