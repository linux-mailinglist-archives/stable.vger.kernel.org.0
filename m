Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89DCA6B9E47
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 19:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbjCNS1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 14:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbjCNS1H (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 14:27:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D960974B2;
        Tue, 14 Mar 2023 11:27:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED528B81AE1;
        Tue, 14 Mar 2023 18:27:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 641C2C433EF;
        Tue, 14 Mar 2023 18:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678818422;
        bh=sZJC19YJ19ITSfQATsdT6wquwPEVzTC8Tb6zCiuxHhw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rgleUlJoXnikh8YK3DWXMKfJcOFvQ3cgCGxrVLOVtU4Et7fhmBB4k2W53IWTS1Bnw
         GUY9h2uZWYNjkGT4szhLspw98l7Fv0scOmX/9vksctARYT0cFoU84LSAJacHLwQ+tw
         dYZ3RZSPjOM0d+cUbucL9byTcWgAtyUrufkVtgDk=
Date:   Tue, 14 Mar 2023 19:26:59 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>, Theodore Ts'o <tytso@mit.edu>,
        Matthew Wilcox <willy@infradead.org>,
        Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <ZBC8c31rf1E2EsF5@kroah.com>
References: <ZATC3djtr9/uPX+P@duo.ucw.cz>
 <ZAewdAql4PBUYOG5@gmail.com>
 <ZAwe95meyCiv6qc4@casper.infradead.org>
 <ZAyK0KM6JmVOvQWy@sashalap>
 <20230311161644.GH860405@mit.edu>
 <ZAy+3f1/xfl6dWpI@sol.localdomain>
 <ZAzH8Ve05SRLYPnR@sashalap>
 <ZAzOgw8Ui4kh1Z3D@sol.localdomain>
 <ZA9gXRMvQj2TO0W3@kroah.com>
 <ZA9xWaHuh3hiYr8X@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZA9xWaHuh3hiYr8X@sol.localdomain>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 13, 2023 at 11:54:17AM -0700, Eric Biggers wrote:
> 
> The fact is, many people *do* follow the rules exactly by *not* tagging commits
> for stable when they don't meet the documented eligibility criteria.  But then
> the stable maintainers backport the commits anyway, as the real eligibility
> criteria are *much* more relaxed than what is documented.

Again, if you do NOT want your patches backported, because you always
mark them properly for stable releases, just let us know and we will add
you to the list of other subsystems and maintainers that have asked us
for this in the past.

We can't detect the absence of a tag as "I know exactly what I am doing"
because of the huge number of developers who do NOT tag patches, and so,
we have to dig through the tree to find fixes on our own.

thanks,

greg k-h
