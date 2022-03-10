Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9819F4D46D3
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 13:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240800AbiCJM1o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 07:27:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236984AbiCJM1n (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 07:27:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59BF81480F3;
        Thu, 10 Mar 2022 04:26:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13E15B825C4;
        Thu, 10 Mar 2022 12:26:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 773CEC340E8;
        Thu, 10 Mar 2022 12:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646915200;
        bh=j9kbFAFVYrcTjwCyYTeY1V6XjDrPlAA8uuO+/0oacRk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ozVMW2eOCOfrZ2zi8XyEK/zevIbFxjuOusPKicJkb6dBFiaw29irn6QyWsqWRZ++4
         DFepAH4zX/+6KAV5KVpIszGCkYN4csMQXfFUd/C0R082QO8tE0iEZexxWqYnXMCPZU
         k00H/458PY5uii1n212X5p25fh/XlyWkztgPpK2Q=
Date:   Thu, 10 Mar 2022 13:26:38 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Valentin Kleibel <valentin@vrvis.at>
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Justin Sanders <justin@coraid.com>, linux-block@vger.kernel.org
Subject: Re: [PATCH] block: aoe: fix page fault in freedev()
Message-ID: <YinufgnQtSeTA18w@kroah.com>
References: <c274db07-9c7d-d857-33ad-4a762819bcdd@vrvis.at>
 <YinpIKY0HVlJ+TLR@kroah.com>
 <50ddedf1-5ac3-91c3-0b50-645ceb541071@vrvis.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50ddedf1-5ac3-91c3-0b50-645ceb541071@vrvis.at>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 10, 2022 at 01:24:38PM +0100, Valentin Kleibel wrote:
> On 10/03/2022 13:03, Greg Kroah-Hartman wrote:
> > > This patch applies to kernels 5.4 and 5.10.
> > 
> > We need a fix for Linus's tree first before we can backport anything to
> > older kernels.  Does this also work there?
> 
> It is fixed in Linus' tree starting with 5.14.

What commit fixes it there?  Why not just backport that one only?

thanks,

greg k-h
