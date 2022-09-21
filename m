Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C06A95BF989
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 10:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiIUImQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 04:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiIUImP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 04:42:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E7D45F64;
        Wed, 21 Sep 2022 01:42:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FC73623F6;
        Wed, 21 Sep 2022 08:42:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C885C433D6;
        Wed, 21 Sep 2022 08:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663749733;
        bh=0GtndUAX9QGEdlFlTyfog2IdLqe1o69t51NBUAd7SDA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K71vEzCNwiodN3DboG0aaQ9oEql1VhmGWZg5kQbM0v51hdhJWh1iH+F87q/1QhWGg
         YjSsqqjVhYAzOkMK5B8ciBzjQvrlPM6EXa2QomNyl0DDsi1R+yvi9c9gSFRtfX7nx+
         LHr+573awWCWsDUYBzAkymQoCtLcwhmR5ShpmXSQ=
Date:   Wed, 21 Sep 2022 10:42:10 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Thorsten Leemhuis <regressions@leemhuis.info>,
        Lu Baolu <baolu.lu@linux.intel.com>, iommu@lists.linux.dev,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: How to quickly resolve the IOMMU regression that currently
 plagues a lot of people in 5.19.y
Message-ID: <YyrOYnneEH/lS+n0@kroah.com>
References: <1d1844f0-c773-6222-36c6-862e14f6020d@leemhuis.info>
 <fd672632-7935-14ff-e2be-0db8443b0907@leemhuis.info>
 <YyrI/qzx/EWapzck@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YyrI/qzx/EWapzck@8bytes.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 21, 2022 at 10:19:10AM +0200, Joerg Roedel wrote:
> Hi Thorsten,
> 
> On Wed, Sep 21, 2022 at 09:15:17AM +0200, Thorsten Leemhuis wrote:
> > [resend with proper subject, sorry for the noise]
> 
> Thanks for the noise :) I will queue the fix today and send it upstream.

Great, thanks for doing this.

greg k-h
