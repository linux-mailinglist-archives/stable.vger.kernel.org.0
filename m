Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD76C4DC377
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 11:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232100AbiCQKB7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 06:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232072AbiCQKB6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 06:01:58 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6B2CD4479
        for <stable@vger.kernel.org>; Thu, 17 Mar 2022 03:00:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 52CE4CE2259
        for <stable@vger.kernel.org>; Thu, 17 Mar 2022 10:00:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4800DC340E9;
        Thu, 17 Mar 2022 10:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647511238;
        bh=nIQAfyLtMOlcWp2si2HWrzsIfDL6gt9n50szSVrLy2c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nEh9kbCYAy6hA8BF87HNd//3k4drXyku27Bv9YKtWGZ+XnnVrqXHRo9bdE/pKZg0J
         l1YRp32YyautPSgwozx6B12VuB4F0V9LylybPpWlQ22Pw+t39TpKau1sOlQtWcXSCl
         aAEuL8d8+16L+4Epj0jANR1f5ITp2X/xaDQRIpCo=
Date:   Thu, 17 Mar 2022 11:00:33 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     James Morse <james.morse@arm.com>, stable@vger.kernel.org,
        catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [stable:PATCH v5.4.184 00/22] arm64: Mitigate spectre style
 branch history side channels
Message-ID: <YjMGwYeBTx36/6uO@kroah.com>
References: <20220315182415.3900464-1-james.morse@arm.com>
 <YjIFE8Abn7XI+4yW@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjIFE8Abn7XI+4yW@sashalap>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 16, 2022 at 11:41:07AM -0400, Sasha Levin wrote:
> On Tue, Mar 15, 2022 at 06:23:53PM +0000, James Morse wrote:
> > Hi Greg,
> > 
> > Here is the state of the current v5.4 backport. Now that the 32bit
> > code has been merged, it doesn't conflict when KVM's shared 32bit/64bit
> > code needs to use these constants.
> > 
> > I've fixed the two issues that were reported against the v5.10 backport.
> > 
> > I had a go at bringing all the pre-requisites in to add proton-pack.c
> > to v5.4. Its currently 39 patches:
> > https://git.gitlab.arm.com/linux-arm/linux-jm.git /bhb/alternative_backport/UNTESTED/v5.4.183
> > (or for web browsers:
> > https://gitlab.arm.com/linux-arm/linux-jm/-/commits/bhb/alternative_backport/UNTESTED/v5.4.183/
> > )
> 
> I've queued it up.

Thanks for merging these, and James, thanks for the backports!  I agree,
this way is a bit "simpler", but thanks for trying the other way as
well.

Does this mean that the 4.19 and older backports will be easier?

greg k-h
