Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9807429A583
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 08:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2507648AbgJ0H1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 03:27:20 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:39478 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725779AbgJ0H1U (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Oct 2020 03:27:20 -0400
X-Greylist: delayed 2690 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Oct 2020 03:27:18 EDT
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kXIgc-0008F6-2M; Tue, 27 Oct 2020 07:42:26 +0100
Date:   Tue, 27 Oct 2020 07:42:26 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH linux-5.9 1/1] net: netfilter: fix KASAN:
 slab-out-of-bounds Read in nft_flow_rule_create
Message-ID: <20201027064226.GA15770@breakpoint.cc>
References: <20201019172532.3906-1-saeed.mirzamohammadi@oracle.com>
 <20201020115047.GA15628@salvia>
 <28C74722-8F35-4397-B567-FA5BCF525891@oracle.com>
 <3BE1A64B-7104-4220-BAD1-870338A33B15@oracle.com>
 <566D38F7-7C99-40F4-A948-03F2F0439BBB@oracle.com>
 <20201027062111.GD206502@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201027062111.GD206502@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> wrote:

[ Trimming CC ]

> On Sun, Oct 25, 2020 at 04:31:57PM -0700, Saeed Mirzamohammadi wrote:
> > Adding stable.
> 
> What did that do?

Its a request to pick up

commit 31cc578ae2de19c748af06d859019dced68e325d
Author: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Date:   Tue Oct 20 13:41:36 2020 +0200

    netfilter: nftables_offload: KASAN slab-out-of-bounds Read in nft_flow_rule_create

Which lacks a Fixes tag.  Should have been:

Fixes: c9626a2cbdb20e2 ("netfilter: nf_tables: add hardware offload support")
(v5.3+)

Hope that makes things clearer.
