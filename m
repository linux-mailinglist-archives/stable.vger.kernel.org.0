Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD02424D235
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 12:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728004AbgHUKXq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 06:23:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:55854 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727791AbgHUKXq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 06:23:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C0D28AE38;
        Fri, 21 Aug 2020 10:24:12 +0000 (UTC)
Date:   Fri, 21 Aug 2020 12:23:43 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        linux-mm@kvack.org, Pavel Machek <pavel@ucw.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@redhat.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Vrabel <david.vrabel@citrix.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mm: Track page table modifications in
 __apply_to_page_range() construction
Message-ID: <20200821102343.GI3354@suse.de>
References: <20200821085011.28878-1-chris@chris-wilson.co.uk>
 <20200821100902.GG3354@suse.de>
 <159800481672.29194.17217138842959831589@build.alporthouse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159800481672.29194.17217138842959831589@build.alporthouse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 21, 2020 at 11:13:36AM +0100, Chris Wilson wrote:
> We need to store the initial addr, as here addr == end [or earlier on
> earlier], so range is (start, addr).

Right, I missed that, thanks for pointing it out.
