Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA8F5B993D
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 13:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiIOLBt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Sep 2022 07:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbiIOLBk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Sep 2022 07:01:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7FF69927A
        for <stable@vger.kernel.org>; Thu, 15 Sep 2022 04:01:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78443B81FAC
        for <stable@vger.kernel.org>; Thu, 15 Sep 2022 11:01:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D79C43470;
        Thu, 15 Sep 2022 11:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663239696;
        bh=MRDqYkGmi+D45psyQGcFNDzZEmF11i7HGtDmKl4SoxU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GWZAWTb1b8CPJlFdrdGp3xd6QULN70OX5wuPEC2fZG8VGL6rhBTayFKcliwg8IEAe
         BnEiDCpa5FhmSXt7t1+CVVFHpQK0wqMt5drphpa05GOOdq+FhWnCLxsUIlkvcXzaS5
         2LnPPhIj2O1oYTs9MoS1TqAWsr9nTO2VUyrxkdZY=
Date:   Thu, 15 Sep 2022 13:02:01 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jann Horn <jannh@google.com>
Cc:     stable <stable@vger.kernel.org>, Hugh Dickins <hughd@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>
Subject: Re: I botched the b67fbebd4cf9 (VM_PFNMAP TLB flush) stable
 backport, how do I have to fix it?
Message-ID: <YyMGKaTbIbw/nrsE@kroah.com>
References: <CAG48ez2sDEaDpiHBQJcDqPtvpCYK1JjLD=Jp8rE9ODnFW-MbRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez2sDEaDpiHBQJcDqPtvpCYK1JjLD=Jp8rE9ODnFW-MbRg@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 15, 2022 at 12:48:44PM +0200, Jann Horn wrote:
> Hi!
> 
> Hugh reached out to me and let me know (in nicer words) that I botched
> my attempt to re-implement b67fbebd4cf9 for the stable backport; the
> backport is an incomplete fix (because I forgot that in
> unmap_region(), "vma" is just one of potentially several VMAs).
> 
> What should the commit message for fixing that look like? And should
> we first revert the botched backport and then do a correct backport on
> top of that, or should I write a single fix commit?

Which every you want is fine with me, I can easily add 1 or 2 patches :)

If you want do the revert now, and get a release out with that, and then
do a "better" patch later, that's fine too, just let me know what you
want to do.

thanks,

greg k-h
