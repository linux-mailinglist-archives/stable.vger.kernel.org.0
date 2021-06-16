Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 542DD3A964F
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 11:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbhFPJit (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 05:38:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:58928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231468AbhFPJit (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 05:38:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF660611CA;
        Wed, 16 Jun 2021 09:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623836203;
        bh=wcGDK91fFPepIq/awj42YrO7KjdXSTwdbqT1it3WO7g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ygZBfnSK533BPLAcGjAcewpnzqWMFx2cpxGJtUSi+rRvzjhyj9ODNuVa/97PFyeZe
         fXBq8nCu7AwuuzcXHgjrGgQNstqAOnxHIluFm6P8gJtAwaS54nEwAt0Q3zvGkVOqeP
         EIloSppAwnRg73RyiisDWxnPZaNxCS11/cSK3/v8=
Date:   Wed, 16 Jun 2021 11:36:41 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Liu Shixin <liushixin2@huawei.com>
Cc:     Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>, stable@vger.kernel.org,
        "Jann Horn," <jannh@google.com>,
        Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Questions about backports of fixes for "CoW after fork() issue"
Message-ID: <YMnGKd79OGeOvRap@kroah.com>
References: <f546c93e-0e36-03a1-fb08-67f46c83d2e7@huawei.com>
 <YMmfke61mTcPV4vB@kroah.com>
 <CAJuCfpG8p7AasufvqehNOLdoXw5ZQFuQhi6mhqPvA3GbPn1puQ@mail.gmail.com>
 <add3f456-052e-6f40-2949-0685b563fdee@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <add3f456-052e-6f40-2949-0685b563fdee@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 16, 2021 at 05:28:54PM +0800, Liu Shixin wrote:
> On 2021/6/16 15:11, Suren Baghdasaryan wrote:
> > On Tue, Jun 15, 2021 at 11:52 PM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> >> On Wed, Jun 16, 2021 at 02:47:15PM +0800, Liu Shixin wrote:
> >>> Hi, Suren,
> >>>
> >>> I read the previous discussion about fixing CVE-2020-29374 in stable 4.14 and 4.19 in
> >>> <https://lore.kernel.org/linux-mm/20210401181741.168763-1-surenb@google.com/>
> >>>
> >>> https://lore.kernel.org/linux-mm/20210401181741.168763-1-surenb@google.com/
> >>>
> >>> And the results of the discussion is that you backports of 17839856fd58 for 4.14 and
> >>>
> >>> 4.19 kernels.
> >>>
> >>> But the bug about dax and strace in the discussion has not been solved, right? I don't
> >>>
> >>> find a conclusion on this issue, am I missing something? Does this problem still exist in
> >>>
> >>> the stable 4.14 and 4.19 kernel?
> > That is my understanding after discussions with Andrea but I did not
> > verify that myself. As Greg pointed out, the best way would be to try
> > it out.
> > Thanks,
> > Suren.
> >
> >> As the code is all there for you, can you just test them and see for
> >> yourself?
> >>
> >> thanks,
> >>
> >> greg k-h
> > .
> >
> Thank you both for replies. I have tested it in stable 4.19 kernel and the bug is existed as expected.

Great, can you provide a working backport of the patches needed to solve
this for 4.19 so that we can apply them?

thanks,

greg k-h
