Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBDEA4DE7F4
	for <lists+stable@lfdr.de>; Sat, 19 Mar 2022 13:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242951AbiCSMzV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Mar 2022 08:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242324AbiCSMzS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Mar 2022 08:55:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1311B173F52;
        Sat, 19 Mar 2022 05:53:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3AF160C39;
        Sat, 19 Mar 2022 12:53:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAC2FC340EC;
        Sat, 19 Mar 2022 12:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647694437;
        bh=WHSVyei0s202CUQ9+4FxBCZNiRYzegEfDi9q+wuk0fE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BCcJFQ/K6aXAIK5v8lXtCDDyl5ZuZuXxmFcUIqZ8cr7HbdHCTO0cZOUGP0kTHigpf
         ZgCipL4QXSq4wYpcKV/SwvBXECFHn8Hte9QJUR1cKFNaV0qknAd6qXMzYjnR0xLr21
         X6tqlD+GTIVRcKU9xSlHOVzMxhEdlkvLTZgqyefw=
Date:   Sat, 19 Mar 2022 13:52:58 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     James Morse <james.morse@arm.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        catalin.marinas@arm.com
Subject: Re: [stable:PATCH v4.19.235 00/22] arm64: Mitigate spectre style
 branch history side channels
Message-ID: <YjXSKlUk1a2jR1il@kroah.com>
References: <20220318174842.2321061-1-james.morse@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220318174842.2321061-1-james.morse@arm.com>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 18, 2022 at 05:48:20PM +0000, James Morse wrote:
> Hello!
> 
> There is the v4.19 backport with the k=8 typo and SDEI name thing both
> fixed.
> 
> Again, its the KVM templates patch that doesn't exist upstream, this is
> necessary because the infrastructure for older kernels is very
> different, and the dependencies for what was a rewrite are huge.

Many thanks for these, all now queued up!

greg k-h
