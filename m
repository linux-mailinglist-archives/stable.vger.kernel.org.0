Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBD71452928
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 05:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239497AbhKPEgs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 23:36:48 -0500
Received: from smtprelay0155.hostedemail.com ([216.40.44.155]:52994 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S238459AbhKPEgn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 23:36:43 -0500
Received: from omf17.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id AE6D98479E;
        Tue, 16 Nov 2021 04:33:45 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf17.hostedemail.com (Postfix) with ESMTPA id B1937E00035D;
        Tue, 16 Nov 2021 04:33:38 +0000 (UTC)
Message-ID: <70cd970d6c39a5ea5e88cbf4b86031c22c5d10d4.camel@perches.com>
Subject: Re: [PATCH v3 1/3] MAINTAINERS: Update maintainers for paravirt ops
 and VMware hypervisor interface
From:   Joe Perches <joe@perches.com>
To:     "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>,
        Sasha Levin <sashal@kernel.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>, jgross@suse.com,
        x86@kernel.org, pv-drivers@vmware.com,
        Alexey Makhalov <amakhalov@vmware.com>,
        Deep Shah <sdeep@vmware.com>, stable@vger.kernel.org,
        virtualization@lists.linux-foundation.org, keerthanak@vmware.com,
        srivatsab@vmware.com, anishs@vmware.com, vithampi@vmware.com,
        linux-kernel@vger.kernel.org, namit@vmware.com, kuba@kernel.org,
        rostedt@goodmis.org
Date:   Mon, 15 Nov 2021 20:33:40 -0800
In-Reply-To: <20211115223900.GA22267@csail.mit.edu>
References: <163657479269.84207.13658789048079672839.stgit@srivatsa-dev>
         <163657487268.84207.5604596767569015608.stgit@srivatsa-dev>
         <YYy9P7Rjg9hntmm3@kroah.com> <20211111153916.GA7966@csail.mit.edu>
         <YY1krlfM5R7uEzJF@kroah.com> <20211111194002.GA8739@csail.mit.edu>
         <YY6hhWtvh+OvOqAl@sashalap> <20211115223900.GA22267@csail.mit.edu>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B1937E00035D
X-Spam-Status: No, score=-4.87
X-Stat-Signature: f98m33wsx4mfc3t3jhbfctk3bb9t83gn
X-Rspamd-Server: rspamout01
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX187U+B1QyrWtVLRt6ScGYedLRY84IBk+8w=
X-HE-Tag: 1637037218-641034
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2021-11-15 at 14:39 -0800, Srivatsa S. Bhat wrote:
> On Fri, Nov 12, 2021 at 12:16:53PM -0500, Sasha Levin wrote:
> > Maybe we should just remove MAINTAINERS from stable trees to make it
> > obvious.
> 
> I don't think we should go quite that far. Instead, perhaps we can
> modify get_maintainer.pl (if needed) such that it prints out a warning
> or reminder to consult the upstream MAINTAINERS file if the script is
> invoked on an older stable kernel.

I don't see how that's feasible.

