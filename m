Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C51C63EB00
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 09:26:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbiLAI0l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 03:26:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbiLAI0k (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 03:26:40 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9380B63D57
        for <stable@vger.kernel.org>; Thu,  1 Dec 2022 00:26:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EF71DCE1C46
        for <stable@vger.kernel.org>; Thu,  1 Dec 2022 08:26:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2686C433D6;
        Thu,  1 Dec 2022 08:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669883196;
        bh=jKM9RTXBuD5ejlzqPuTeN8DR67MahcSA9weyOpgt3YQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ltLiezXpEE8FS9AsvZnlTY4JYy6nLvXhJor0g3+R8QdINzk9x2/V1O5wUopmTOq73
         QUV5MzJVHoOUn08nhtKg82Q8RuI14PCZpSo7RJPQaBAYBO2g9zoRbOX81jxHDV61US
         G+UGyw7SBn9wpGbMv+yKqG1PRsA7aW4KO1rSbdAo=
Date:   Thu, 1 Dec 2022 06:58:52 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc:     bp@suse.de, dave.hansen@linux.intel.com, hdegoede@redhat.com,
        rafael.j.wysocki@intel.com, stable@kernel.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/pm: Add enumeration check before spec
 MSRs save/restore" failed to apply to 5.10-stable tree
Message-ID: <Y4hCnMlrnLe98IQ4@kroah.com>
References: <1669811516103161@kroah.com>
 <20221130231109.ohdusribjld4t4f5@desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221130231109.ohdusribjld4t4f5@desk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 30, 2022 at 03:11:09PM -0800, Pawan Gupta wrote:
> On Wed, Nov 30, 2022 at 01:31:56PM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.10-stable tree.
> 
> Patch is applying cleanly on v5.10.156. Is it not where it should be
> applied?

Did you try building with the patch applied?  :(

> Same observation for failed patch on 5.4.

Same on 5.4, breaks the build, right?

I don't have special emails for "this applied but did not build" as
that's more rare.

thanks,

greg k-h
