Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 283905B9676
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 10:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiIOIfn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Sep 2022 04:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbiIOIfL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Sep 2022 04:35:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94DA01F2C2;
        Thu, 15 Sep 2022 01:35:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B80BBB81E5D;
        Thu, 15 Sep 2022 08:35:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14822C433C1;
        Thu, 15 Sep 2022 08:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663230905;
        bh=WlRn9lkQQXw0fVyN1GqzEjWHMGSOjm8w0pFtHaZu4LA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SIHhR3VfQSSD7QiuqqN38uiZpeCXNlk5uWzS1X6jDzu9orcxI6ypchr5Phm3BlMUG
         6+jQeiiJxd5aXMJRX2e5XURtC2vBXUmET8yrYPpy9JQHRoWEqLOIvps6Cx67z39jl/
         vXtPj+3nruqScHiHxy5XNs60Ak/TLZ4IxdsqUZ90=
Date:   Thu, 15 Sep 2022 10:35:31 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Subject: Re: [PATCH 4.19 77/79] x86/nospec: Fix i386 RSB stuffing
Message-ID: <YyLj08DIFIs44oQH@kroah.com>
References: <20220913140348.835121645@linuxfoundation.org>
 <20220913140352.600717282@linuxfoundation.org>
 <c4dbfd1eea23b4495bb310dc78d174ef65adfc28.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4dbfd1eea23b4495bb310dc78d174ef65adfc28.camel@decadent.org.uk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 14, 2022 at 08:46:00PM +0200, Ben Hutchings wrote:
> On Tue, 2022-09-13 at 16:07 +0200, Greg Kroah-Hartman wrote:
> > From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> > 
> > From: Peter Zijlstra <peterz@infradead.org>
> > 
> > commit 332924973725e8cdcc783c175f68cf7e162cb9e5 upstream.
> 
> This should have only "From: Peter Zijlstra".

Ick, thanks, my scripts aren't the best at times, I'll go fix that.

greg k-h
