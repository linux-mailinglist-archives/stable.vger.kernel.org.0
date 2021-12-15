Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F55C4753A9
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 08:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240534AbhLOH1t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 02:27:49 -0500
Received: from verein.lst.de ([213.95.11.211]:55377 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240524AbhLOH1s (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Dec 2021 02:27:48 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 16DD568AFE; Wed, 15 Dec 2021 08:27:45 +0100 (CET)
Date:   Wed, 15 Dec 2021 08:27:44 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     john.p.donnelly@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, Baoquan He <bhe@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, cl@linux.com, kexec@lists.infradead.org,
        stable@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH v3 5/5] mm/slub: do not create dma-kmalloc if no
 managed pages in DMA zone
Message-ID: <20211215072744.GB3010@lst.de>
References: <20211213122712.23805-1-bhe@redhat.com> <20211213122712.23805-6-bhe@redhat.com> <20211214163124.GA21762@lst.de> <dc648afe-6dbe-55c9-ebf6-9334d71706b4@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc648afe-6dbe-55c9-ebf6-9334d71706b4@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 14, 2021 at 11:07:34AM -0600, john.p.donnelly@oracle.com wrote:
> Is CONFIG_ZONE_DMA even needed anymore in x86_64  ?

Yes.  There are still plenty of addressing challenged devices, mostly
ISA-like but also a few PCI/PCIe ones.
