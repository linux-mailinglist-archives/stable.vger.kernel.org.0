Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50959557F42
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiFWQEG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232138AbiFWQDt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:03:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ABDD44752
        for <stable@vger.kernel.org>; Thu, 23 Jun 2022 09:03:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7FD961EA8
        for <stable@vger.kernel.org>; Thu, 23 Jun 2022 16:03:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CFCCC3411B;
        Thu, 23 Jun 2022 16:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656000227;
        bh=SvIHauJLNnlY7iKb1z6fJ2umhZ1xKLbf0Xg32uzb8jQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m4Ym+bG8sgk+8U3DJon2wptTJXjqwr0yXhPtgTsj0SvDDq13A7UrdrqAcanvKoyyJ
         VEiXOBt2859Iq8m/VF9qCSs5ocL8uidUof0G2Wvj+OSRAXTEWkECHd2WCkUQsU2ckS
         X/TSqqE8vAPfoahboW+u3PY27G3p2jn1OOEIOaTQ=
Date:   Thu, 23 Jun 2022 18:03:44 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     Sasha Levin <sashal@kernel.org>, stable <stable@vger.kernel.org>,
        Willy Tarreau <w@1wt.eu>, Eric Dumazet <edumazet@google.com>,
        Amit Klein <aksecurity@gmail.com>
Subject: Re: [stable] Improved TCP source port randomisation
Message-ID: <YrSO4AO8usZQda1z@kroah.com>
References: <c07281c6d7faa8042cff0a3da7a273eb617cfa13.camel@decadent.org.uk>
 <YrSNqZazgv05N07+@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrSNqZazgv05N07+@kroah.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 23, 2022 at 05:58:33PM +0200, Greg Kroah-Hartman wrote:
> On Wed, Jun 22, 2022 at 12:24:19AM +0200, Ben Hutchings wrote:
> > Please pick the following commits for 5.4 and 5.10 stable branches:
> > 
> > 90564f36f1c3071d1e0c617cde342f9706e250be tcp: add some entropy in __inet_hash_connect()
> > 506884b616e95714af173c47b89e7d1f5157c190 tcp: use different parts of the port_offset for index and offset
> > dabeb1baad260b2308477991f3006f4a1ac80d6d tcp: add small random increments to the source port
> > 735ad25586cd381a3fdc8283e2d1cd4d65f0e9e7 tcp: dynamically allocate the perturb table used by source ports
> > ada9e93075c7d54a7fd28bae5429ed30ddd89bfa tcp: increase source port perturb table to 2^16
> > 82f233b30b728249d1c374b77d722b2e4f55a631 tcp: drop the hash_32() part from the index calculation
> 
> All of these commit ids are not in Linus's tree, are you sure you got
> them correct?

Ah, I can pick them from the mboxes you sent me in the other email...
