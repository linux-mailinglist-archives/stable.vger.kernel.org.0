Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA43B5C04AE
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 18:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbiIUQv7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 12:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231273AbiIUQvQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 12:51:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F27C271C;
        Wed, 21 Sep 2022 09:46:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DCD163213;
        Wed, 21 Sep 2022 16:46:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D6FBC433C1;
        Wed, 21 Sep 2022 16:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663778813;
        bh=KO9/J/hUO8nnDy0M9Goj6pDfKn66gCx4G05aBn2ANZE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RN2hmiXX6cjXziPtgx/iY5Bg3NETvDCbt4S2Wzy7zoVkAJdavITiNaLB1cvE496Bx
         CYgB99QgC/PxyHvdNBH+yBkuwQ0K1iAEfnh+XB0e4UWAsqKMkwAz75u0Qzoyz47vLz
         J3CiO5nwbNX1P3MO9yW0lSVSIDxsnJfC861Hw9iU=
Date:   Wed, 21 Sep 2022 18:46:51 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Lu Baolu <baolu.lu@linux.intel.com>, iommu@lists.linux.dev,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        LKML <linux-kernel@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: How to quickly resolve the IOMMU regression that currently
 plagues a lot of people in 5.19.y
Message-ID: <Yys/+yXuINceZGbz@kroah.com>
References: <1d1844f0-c773-6222-36c6-862e14f6020d@leemhuis.info>
 <fd672632-7935-14ff-e2be-0db8443b0907@leemhuis.info>
 <YyrI/qzx/EWapzck@8bytes.org>
 <CAHk-=wgU0PyYHut+8zV+kNCxOZiCXd5J29Eisiy8badzsk8Msw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgU0PyYHut+8zV+kNCxOZiCXd5J29Eisiy8badzsk8Msw@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 21, 2022 at 09:15:12AM -0700, Linus Torvalds wrote:
> On Wed, Sep 21, 2022 at 1:19 AM Joerg Roedel <joro@8bytes.org> wrote:
> >
> > Thanks for the noise :) I will queue the fix today and send it upstream.
> 
> .. and it's in my tree now.

And now added to the next 5.19-rc release that is out for review now.

thanks for the quick response everyone,

greg k-h
