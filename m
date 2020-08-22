Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECADA24E8AB
	for <lists+stable@lfdr.de>; Sat, 22 Aug 2020 18:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728282AbgHVQUn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Aug 2020 12:20:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:59068 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728255AbgHVQUm (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Aug 2020 12:20:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CCAF7AFF2;
        Sat, 22 Aug 2020 16:21:09 +0000 (UTC)
Date:   Sat, 22 Aug 2020 18:20:38 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Joerg Roedel <joro@8bytes.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        Pavel Machek <pavel@ucw.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@redhat.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Vrabel <david.vrabel@citrix.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm: Track page table modifications in
 __apply_to_page_range()
Message-ID: <20200822162038.GQ3354@suse.de>
References: <20200821123746.16904-1-joro@8bytes.org>
 <20200821153412.5902e4ed0699615d8de4a595@linux-foundation.org>
 <159805314945.32652.6355592202796435703@build.alporthouse.com>
 <159809591535.32652.4016790228519688343@build.alporthouse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159809591535.32652.4016790228519688343@build.alporthouse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 22, 2020 at 12:31:55PM +0100, Chris Wilson wrote:
> The active ingredient was
> 
> 7f0a002b5a21 ("x86/mm: remove vmalloc faulting")

Right, that is what bisection will point to. Thanks for collecting all
the info and updating the commit message!

Regards,

	Joerg
