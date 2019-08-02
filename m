Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F187F800D3
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 21:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391996AbfHBTT3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 15:19:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35672 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391971AbfHBTT3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Aug 2019 15:19:29 -0400
X-Greylist: delayed 416 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Aug 2019 15:19:28 EDT
Received: from X1 (unknown [76.191.170.112])
        by mail.linuxfoundation.org (Postfix) with ESMTPSA id 76EF1167C;
        Fri,  2 Aug 2019 19:12:27 +0000 (UTC)
Date:   Fri, 2 Aug 2019 12:11:47 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Ralph Campbell <rcampbell@nvidia.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        John Hubbard <jhubbard@nvidia.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Jan Kara <jack@suse.cz>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Michal Hocko <mhocko@suse.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        =?ISO-8859-1?Q?J=E9r=F4me?= Glisse <jglisse@redhat.com>
Subject: Re: [PATCH v3 2/3] mm/hmm: fix ZONE_DEVICE anon page mapping reuse
Message-Id: <20190802121147.d7e6a5eb57966b98118abb97@linux-foundation.org>
In-Reply-To: <20190802083141.GA11000@lst.de>
References: <20190724232700.23327-1-rcampbell@nvidia.com>
        <20190724232700.23327-3-rcampbell@nvidia.com>
        <20190802083141.GA11000@lst.de>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2 Aug 2019 10:31:41 +0200 Christoph Hellwig <hch@lst.de> wrote:

> Andrew,
> 
> Any reason the fixes haven't made it to mainline yet?

I generally let fixes bake in -next for a week or two, unless they
appear to be impeding ongoing test&devel.

[3/3] shows no sign of having been reviewed, btw.
