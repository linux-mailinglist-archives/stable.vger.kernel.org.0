Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7B858038D
	for <lists+stable@lfdr.de>; Mon, 25 Jul 2022 19:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235942AbiGYRgo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jul 2022 13:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235189AbiGYRgo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jul 2022 13:36:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C021C90E
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 10:36:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7A366136F
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 17:36:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE897C341C6;
        Mon, 25 Jul 2022 17:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658770602;
        bh=LRKYD6tvdpGG1Wyiu/gIvDyJZS/HRXuWET6gf6x+zfk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0pEF6oVC2xyhrMHmIDfxaRaD1NBOxJVf/PTrwHukA6qQa7yUaNLCeduMqCMjt3eTj
         UxCU6ZVthi97Q/CYDQqs/0zqB5YS1EyUj7n1P8MmwcW8bvQBiOmpXwkUK+fRi6RSM6
         oC5EgycuVzkL9CV45g35RopGEpQKKH32lXdrLqp0=
Date:   Mon, 25 Jul 2022 19:36:36 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc:     stable@vger.kernel.org, broonie@kernel.org,
        peter.ujfalusi@linux.intel.com, ranjani.sridharan@linux.intel.com
Subject: Re: [PATCH 3/3] ASoC: SOF: Intel: disable IMR boot when resuming
 from ACPI S4 and S5 states
Message-ID: <Yt7UpI9T/v9sXill@kroah.com>
References: <20220711155719.104952-1-pierre-louis.bossart@linux.intel.com>
 <20220711155719.104952-4-pierre-louis.bossart@linux.intel.com>
 <Ytv9JKlEOXctrFee@kroah.com>
 <56549c69-39a1-56cf-fb48-e2af6eeadef5@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56549c69-39a1-56cf-fb48-e2af6eeadef5@linux.intel.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 25, 2022 at 10:25:07AM -0500, Pierre-Louis Bossart wrote:
> 
> 
> On 7/23/22 08:52, Greg KH wrote:
> > On Mon, Jul 11, 2022 at 10:57:19AM -0500, Pierre-Louis Bossart wrote:
> >> commit 58ecb11eab44dd5d64e35664ac4d62fecb6328f4 upstream.
> > 
> > Again, not a valid commit :(
> > 
> > Where did these come from?
> > 
> > confused,
> 
> There are on Mark Brown's for-next branch, I must have looked at the IDs
> after a rebase or something. We always report the SHA IDs from that
> for-next branch, and linux-next check those values. I didn't realize
> they could be different in Linus' tree.
> 
> I am still a bit confused since our Fixes tag could be right at the
> moment we submit the patches to Mark but wrong long-term after merge by
> Linus. Either I need more coffee, or I am missing a key concept, or both.
> 
> The commit IDs on Linus' tree should be:
> 
> a933084558c6 ASoC: SOF: pm: add explicit behavior for ACPI S1 and S2
> 
> 9d2d46271338 ASoC: SOF: pm: add definitions for S4 and S5 states
> 
> 391153522d18 ASoC: SOF: Intel: disable IMR boot when resuming from ACPI
> S4 and S5 states
> 
> 
> Do you want me to resend?

Yes please.
