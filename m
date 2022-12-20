Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC5BA6522A3
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 15:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233776AbiLTOc1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Dec 2022 09:32:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234140AbiLTOcV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Dec 2022 09:32:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E756DDEA9;
        Tue, 20 Dec 2022 06:32:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DC6A61478;
        Tue, 20 Dec 2022 14:32:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67B91C433EF;
        Tue, 20 Dec 2022 14:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671546739;
        bh=I9Cu+kAKzr7nMCJCiEna+C9QzBUQlwXRBtFRhj+AnWY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i6ikgmsgRMPQj5I+OkiUddOnkhLld+aADGqP/TPYKPzpZ6Exmj7qfvunajVl8SbaS
         BwClnc3miLkgwLxgoLdjqCg7/7pVvccQuRisfE4G4cBqLkhv8j7gI6cUC6PxerLH7H
         O/wxsdusiIWFJl/5DkVzQqiUMAepsFo1sb96DzAk=
Date:   Tue, 20 Dec 2022 15:32:15 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Allen Webb <allenwebb@google.com>
Cc:     "linux-modules@vger.kernel.org" <linux-modules@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>, stable@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v9 01/10] imx: Fix typo
Message-ID: <Y6HHb8alGpMHLpM/@kroah.com>
References: <20221219191855.2010466-1-allenwebb@google.com>
 <20221219204619.2205248-1-allenwebb@google.com>
 <20221219204619.2205248-2-allenwebb@google.com>
 <Y6FZWOC1DSHHZNWy@kroah.com>
 <CAJzde06et8qZPmu=zF13rJt8=v_etMjgTRhv9y75wdrX7doC0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJzde06et8qZPmu=zF13rJt8=v_etMjgTRhv9y75wdrX7doC0g@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 20, 2022 at 08:26:06AM -0600, Allen Webb wrote:
> On Mon, Dec 19, 2022 at 3:23 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> >
> > On Mon, Dec 19, 2022 at 02:46:09PM -0600, Allen Webb wrote:
> > > A one character difference in the name supplied to MODULE_DEVICE_TABLE
> > > breaks a future patch set, so fix the typo.
> >
> > What behaviour is broken here for older kernels? What would not work
> > that makes this patch worthy of consideration for stable? The commit
> > log should be clear on that.
> >
> > In the future, it may be useful for you to wait at least 1 week or so
> > before sending a new series becuase just a couple of days is not enough
> > if you are getting feedback.
> >
> > So before sending a v10, please give it at least a few days or a week.
> >
> >   Luis
> 
> On Tue, Dec 20, 2022 at 12:42 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Mon, Dec 19, 2022 at 02:46:09PM -0600, Allen Webb wrote:
> > > A one character difference in the name supplied to MODULE_DEVICE_TABLE
> > > breaks a future patch set, so fix the typo.
> >
> > Breaking a future change is not worth a stable backport, right?  Doesn't
> > this fix a real issue now?  If so, please explain that.
> >
> > thanks,
> >
> > greg k-h
> 
> I will update the commit message to say that it breaks compilation
> when building imx8mp-blk-ctrl as a module (and so forth for the other
> similar patches).

Can that code be built as a module?  Same for the other changes...
