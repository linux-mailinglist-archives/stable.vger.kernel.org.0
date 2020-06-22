Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29EDC20329F
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 10:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbgFVI7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 04:59:13 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:35842
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725802AbgFVI7M (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jun 2020 04:59:12 -0400
X-IronPort-AV: E=Sophos;i="5.75,266,1589234400"; 
   d="scan'208";a="352318332"
Received: from abo-173-121-68.mrs.modulonet.fr (HELO hadrien) ([85.68.121.173])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 10:59:08 +0200
Date:   Mon, 22 Jun 2020 10:59:08 +0200 (CEST)
From:   Julia Lawall <julia.lawall@inria.fr>
X-X-Sender: jll@hadrien
To:     Matthias Maennich <maennich@google.com>
cc:     Shuah Khan <skhan@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        YueHaibing <yuehaibing@huawei.com>, jeyu@kernel.org,
        cocci@systeme.lip6.fr, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] scripts: add dummy report mode to add_namespace.cocci
In-Reply-To: <20200622080345.GD260206@google.com>
Message-ID: <alpine.DEB.2.22.394.2006221057220.2531@hadrien>
References: <20200604164145.173925-1-maennich@google.com> <alpine.DEB.2.21.2006042130080.2577@hadrien> <bf757b9d-6a67-598b-ed6e-7ee24464abfa@linuxfoundation.org> <20200622080345.GD260206@google.com>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On Mon, 22 Jun 2020, Matthias Maennich wrote:

> On Thu, Jun 04, 2020 at 02:39:18PM -0600, Shuah Khan wrote:
> > On 6/4/20 1:31 PM, Julia Lawall wrote:
> > >
> > >
> > > On Thu, 4 Jun 2020, Matthias Maennich wrote:
> > >
> > > > When running `make coccicheck` in report mode using the
> > > > add_namespace.cocci file, it will fail for files that contain
> > > > MODULE_LICENSE. Those match the replacement precondition, but spatch
> > > > errors out as virtual.ns is not set.
> > > >
> > > > In order to fix that, add the virtual rule nsdeps and only do search and
> > > > replace if that rule has been explicitly requested.
> > > >
> > > > In order to make spatch happy in report mode, we also need a dummy rule,
> > > > as otherwise it errors out with "No rules apply". Using a script:python
> > > > rule appears unrelated and odd, but this is the shortest I could come up
> > > > with.
> > > >
> > > > Adjust scripts/nsdeps accordingly to set the nsdeps rule when run trough
> > > > `make nsdeps`.
> > > >
> > > > Suggested-by: Julia Lawall <julia.lawall@inria.fr>
> > > > Fixes: c7c4e29fb5a4 ("scripts: add_namespace: Fix coccicheck failed")
> > > > Cc: YueHaibing <yuehaibing@huawei.com>
> > > > Cc: jeyu@kernel.org
> > > > Cc: cocci@systeme.lip6.fr
> > > > Cc: stable@vger.kernel.org
> > > > Signed-off-by: Matthias Maennich <maennich@google.com>
> > >
> > > Acked-by: Julia Lawall <julia.lawall@inria.fr>
> > >
> > > Shuah reported the problem to me, so you could add
> > >
> > > Reported-by: Shuah Khan <skhan@linuxfoundation.org>
> > >
> >
> > Very cool. No errors with this patch. Thanks for fixing it
> > quickly.
>
> I am happy I could fix that and thanks for confirming. I assume your
> Tested-by could be added?

Yes, that would be fine.

julia


>
> Is somebody willing to take this patch through their tree?
>
> Cheers,
> Matthias
>
> >
> > thanks,
> > -- Shuah
> >
> >
> >
>

