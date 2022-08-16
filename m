Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2D9D595BF7
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 14:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235280AbiHPMm4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 08:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234938AbiHPMmx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 08:42:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8514BA4063;
        Tue, 16 Aug 2022 05:42:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9985B818C6;
        Tue, 16 Aug 2022 12:42:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E90FC433D6;
        Tue, 16 Aug 2022 12:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660653767;
        bh=i54K/lIRAo9FemQV7ppcUwSrobEo+2LrKkjjXg+9Bts=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2pA/vMqKMyypDXtkFCferb6QR0JsRou48uadAI7vPbDVpbAUBc7SxUwht3Q65HuM2
         ghVF3hkhxd6Q/iMKhT+oimMtTbDToluoETzZlPS/hANbNIOyoTs7L9oiGEPDYgJ/ZI
         UKc7SGVjv7ZAiUoF5IcAJLYk0LMRhoMkSqYuWm0s=
Date:   Tue, 16 Aug 2022 14:42:44 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH] x86/nospec: Unwreck the RSB stuffing
Message-ID: <YvuQxAzPHMXdoMLX@kroah.com>
References: <20220809175513.345597655@linuxfoundation.org>
 <20220809175513.979067723@linuxfoundation.org>
 <YvuNdDWoUZSBjYcm@worktop.programming.kicks-ass.net>
 <YvuOnkhj/Z8naRmN@kroah.com>
 <YvuPZYhoZLaSRKmr@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvuPZYhoZLaSRKmr@zn.tnic>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 02:36:53PM +0200, Borislav Petkov wrote:
> On Tue, Aug 16, 2022 at 02:33:34PM +0200, Greg Kroah-Hartman wrote:
> > I need an Intel person
> 
> Daniel?
> 
> > to test this as I have no idea how to do so as his is an issue in
> > tLinus's tree.
> 
> If this passes - and I have my both fingers crossed - this will be an
> amazing simplification.
> 
> Might wanna take it into stable too, when ready.

I'd be glad to :)
