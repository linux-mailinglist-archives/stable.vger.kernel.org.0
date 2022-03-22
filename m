Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67FCC4E3C70
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 11:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232239AbiCVK3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Mar 2022 06:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbiCVK3O (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Mar 2022 06:29:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45FFB240B1
        for <stable@vger.kernel.org>; Tue, 22 Mar 2022 03:27:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED386B81B67
        for <stable@vger.kernel.org>; Tue, 22 Mar 2022 10:27:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 233D3C340EC;
        Tue, 22 Mar 2022 10:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647944864;
        bh=EGlUvlobd74hFRq9t7ZGZqtdUrdBatZKufNegXpcMU0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TO3g9c1XMU3MAsDQPbagfgi96niJxZudt6mSxDaTifLXi3bYmDGdTamEk5rFqvzyV
         YKyuUIIWyrxskCVKWpghVCjJPbwhwWSxOU6h23xrigMa2x67b1GbBYN4Azns9DrUyT
         0RPo/uzOwKbRT/FuByG43YLNUqCkpSltQCicIubc=
Date:   Tue, 22 Mar 2022 11:27:40 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH stable-5.15] MAINTAINERS: update Krzysztof Kozlowski's
 email
Message-ID: <YjmknD4C/WyJgiae@kroah.com>
References: <20220321144743.17896-1-krzk@kernel.org>
 <Yjif3B1NQBr6z4c+@kroah.com>
 <6ffd085b-dea9-1e52-0268-8de851193225@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ffd085b-dea9-1e52-0268-8de851193225@kernel.org>
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 22, 2022 at 11:19:50AM +0100, Krzysztof Kozlowski wrote:
> On 21/03/2022 16:55, Greg KH wrote:
> > On Mon, Mar 21, 2022 at 03:47:43PM +0100, Krzysztof Kozlowski wrote:
> >> From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> >>
> >> commit 5125091d757a251a128ec38d2397c9d160394eac upstream.
> >>
> >> Use Krzysztof Kozlowski's @kernel.org account in maintainer entries.
> >>
> >> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> >> Link: https://lore.kernel.org/r/20220307172805.156760-1-krzysztof.kozlowski@canonical.com'
> >> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> >> ---
> >>  .mailmap    |  1 +
> >>  MAINTAINERS | 28 ++++++++++++++--------------
> >>  2 files changed, 15 insertions(+), 14 deletions(-)
> > 
> > We do not normally do MAINTAINERS updates for older kernel trees as no
> > one should be doing development against them.
> > 
> > Any reason why this is different?
> > 
> 
> Hi Greg,
> 
> No, it's not different, but people work on backports for stables on a
> stable branch. Then they send such patch from within the stable tree,
> because it's easier, I guess. Without the .mailmap all these backports
> will go to wrong email address - my @canonical.com will start bouncing
> in two days.
> 
> In the same time I am not sure which mailmap is being followed by your
> and other stable-folks tools, when notifying with backport queue
> ("5.16.17-rc1 review" etc.).

I don't use any tools that uses the mailmap file at all.  So updating it
isn't going to affect the stable patch review process, sorry.

> Plus people actually might have some questions about some my backported
> commit. They might respond to the email shown in git log, which will be
> wrong without mailmap file.

People change email addresses all the time, this isn't anything new.  I
really don't want to get into the habit of having to keep this file up
to date with Linus's tree for 6 years, sorry.

thanks,

greg k-h
