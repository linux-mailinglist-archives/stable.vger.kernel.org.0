Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD59D65A361
	for <lists+stable@lfdr.de>; Sat, 31 Dec 2022 10:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiLaJfn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Dec 2022 04:35:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiLaJfm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Dec 2022 04:35:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F3228B
        for <stable@vger.kernel.org>; Sat, 31 Dec 2022 01:35:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9FC10B802C4
        for <stable@vger.kernel.org>; Sat, 31 Dec 2022 09:35:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2A44C433D2;
        Sat, 31 Dec 2022 09:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672479337;
        bh=v0s0iSNAE5U+RwcEnNb6Ft9R8ENOAQILnnIPITR6SAE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=10GrGKCwgQQEtb4ssx7dN+yGylvHD4buOv9QyhJgNllA/yq/Q5wbMq5yYeQUBm8C1
         U8pdrlKYPw11kcnBdxdtN3+UG7lz+7lle2KuOZ09Kv8jYIwBrzOn/IVN5XYAB215EZ
         kV7I5ELC8cRzx2ikPAIpwrumDKLMnT+j9NEViP/4=
Date:   Sat, 31 Dec 2022 10:35:33 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Klaus Kudielka <klaus.kudielka@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 6.1 0000/1140] 6.1.2-rc2 review
Message-ID: <Y7ACZV10fIlRPXVY@kroah.com>
References: <20221230094107.317705320@linuxfoundation.org>
 <e9ee0609520238d28d94ee8b66e20ac0c6069caa.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e9ee0609520238d28d94ee8b66e20ac0c6069caa.camel@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 31, 2022 at 10:10:05AM +0100, Klaus Kudielka wrote:
> On Fri, 2022-12-30 at 10:49 +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.2 release.
> > There are 1140 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 01 Jan 2023 09:38:41 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.2-rc2.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > 
> 
> Hi Greg,
> 
> I'm concerned about backporting those two commits to *any* stable kernel right now:
> 
> > Pali Rohár <pali@kernel.org>
> >     ARM: dts: armada-39x: Fix compatible string for gpios
> [ Upstream commit d10886a4e6f85ee18d47a1066a52168461370ded ]
> 
> > 
> > Pali Rohár <pali@kernel.org>
> >     ARM: dts: armada-38x: Fix compatible string for gpios
> [ Upstream commit c4de4667f15d04ef5920bacf41e514ec7d1ef03d ]
> 
> The latter one breaks my Turris Omnia (Armada 385) pretty badly, and I guess we will end
> up with similar problems on Armada 39x boards.
> 
> Link: https://lore.kernel.org/r/f24474e70c1a4e9692bd596ef6d97ceda9511245.camel@gmail.com/

Thanks for the link, I'll drop these for now.  Please send a revert for
these for Linus's tree as well.

thanks,

greg k-h
