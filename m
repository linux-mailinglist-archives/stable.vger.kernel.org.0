Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8ADA2576B3
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 11:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726117AbgHaJkD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 05:40:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:54478 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726106AbgHaJkC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Aug 2020 05:40:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 49735ACDB;
        Mon, 31 Aug 2020 09:40:34 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 5CCC3DA840; Mon, 31 Aug 2020 11:38:48 +0200 (CEST)
Date:   Mon, 31 Aug 2020 11:38:48 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Max Staudt <max@enpas.org>
Cc:     David Sterba <dsterba@suse.com>, linux-fsdevel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-m68k@vger.kernel.org, glaubitz@physik.fu-berlin.de,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] fs/affs: Fix basic permission bits to actually work
Message-ID: <20200831093848.GS28318@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Max Staudt <max@enpas.org>,
        David Sterba <dsterba@suse.com>, linux-fsdevel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-m68k@vger.kernel.org, glaubitz@physik.fu-berlin.de,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20200827154900.28233-1-max@enpas.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200827154900.28233-1-max@enpas.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 27, 2020 at 05:49:00PM +0200, Max Staudt wrote:
> The basic permission bits (protection bits in AmigaOS) have been broken
> in Linux' affs - it would only set bits, but never delete them.
> Also, contrary to the documentation, the Archived bit was not handled.
> 
> Let's fix this for good, and set the bits such that Linux and classic
> AmigaOS can coexist in the most peaceful manner.
> 
> Also, update the documentation to represent the current state of things.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Max Staudt <max@enpas.org>

Thanks, patch looks good to me, I'll send a pull request to Linus this
week.
