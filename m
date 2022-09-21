Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14AB95BF5CE
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 07:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbiIUFKs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 01:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiIUFKr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 01:10:47 -0400
Received: from vmicros1.altlinux.org (vmicros1.altlinux.org [194.107.17.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B833A78BC6;
        Tue, 20 Sep 2022 22:10:46 -0700 (PDT)
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 544DC72C90B;
        Wed, 21 Sep 2022 08:10:45 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id 3EC6D4A4826;
        Wed, 21 Sep 2022 08:10:45 +0300 (MSK)
Date:   Wed, 21 Sep 2022 08:10:45 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.15 22/41] video: fbdev: pxa3xx-gcu: Fix integer
 overflow in pxa3xx_gcu_write
Message-ID: <20220921051045.dqnivsbrigwqlkan@altlinux.org>
References: <20220628022100.595243-1-sashal@kernel.org>
 <20220628022100.595243-22-sashal@kernel.org>
 <20220919082143.g4gn5ssbzolnc57b@altlinux.org>
 <YyjsKkg+qG5ieCAC@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <YyjsKkg+qG5ieCAC@sashalap>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sasha,

On Mon, Sep 19, 2022 at 06:24:42PM -0400, Sasha Levin wrote:
> On Mon, Sep 19, 2022 at 11:21:43AM +0300, Vitaly Chikunov wrote:
> > On Mon, Jun 27, 2022 at 10:20:41PM -0400, Sasha Levin wrote:
> > > From: Hyunwoo Kim <imv4bel@gmail.com>
> > > 
> > > [ Upstream commit a09d2d00af53b43c6f11e6ab3cb58443c2cac8a7 ]
> > > 
> > > In pxa3xx_gcu_write, a count parameter of type size_t is passed to words of
> > > type int.  Then, copy_from_user() may cause a heap overflow because it is used
> > > as the third argument of copy_from_user().
> > 
> > Why this commit is still not in the stable branches?
> 
> Mostly because it's not tagged for stable.
> 
> But really, looks like I've missed a batch a few months ago, I can push
> it for the next release cycle.
> 
> > Isn't this is the fix for CVE-2022-39842[1]?
> 
> How the heck did this thing get a CVE?

More than that, they also assign high severity score to it:
  CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H

  Confidentiality Impact (C)  High
  Integrity Impact (I)        High
  Availability Impact (A)     High

Thanks,

> 
> -- 
> Thanks,
> Sasha
