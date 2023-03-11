Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA0A56B5FEE
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 20:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbjCKTBm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 14:01:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbjCKTBl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 14:01:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0BA060ABA;
        Sat, 11 Mar 2023 11:01:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5589160DE4;
        Sat, 11 Mar 2023 19:01:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75B02C433D2;
        Sat, 11 Mar 2023 19:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678561299;
        bh=vnodHj2MRXBuuStJdQdxqXTUE+xQrrqjiVLU987b9I8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GmheqXqAXHITTGLjCXkoIk2DdlvmDAoLxU0WEw27fyH05g/NO3BKUU5VVMTUDVlAJ
         XoC34Q3KXFGPXW2L+Fvy7fyslnkLlq27CraRsHKNYBdgLJY251GdTMP/uC/j/XmotN
         Jr5206Oe4wm/+QwEjH/CZUAUFQC2J8inaQVrbPK+jnI4qbrmEIV7fmWoXS0uhv8m6M
         Code7V1SnDyaXqjKzYpxJ+bHRaTVF+A5ZKPuta5ySnM5iiIhtqxBGrY0EEJUmL2EUQ
         2Y+aSWmEO5uCdYh8100M7iGbjYr04SLKoXD0dUoU6GiKONutzFYRc7Tt7fbJQYzltA
         n5y5c0mMO0c6w==
Date:   Sat, 11 Mar 2023 11:01:37 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Theodore Ts'o <tytso@mit.edu>,
        Matthew Wilcox <willy@infradead.org>,
        Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <ZAzQESu2AP+3x6IK@sol.localdomain>
References: <Y/zswi91axMN8OsA@sol.localdomain>
 <Y/zxKOBTLXFjSVyI@sol.localdomain>
 <ZATC3djtr9/uPX+P@duo.ucw.cz>
 <ZAewdAql4PBUYOG5@gmail.com>
 <ZAwe95meyCiv6qc4@casper.infradead.org>
 <ZAyK0KM6JmVOvQWy@sashalap>
 <20230311161644.GH860405@mit.edu>
 <ZAy+3f1/xfl6dWpI@sol.localdomain>
 <ZAzH8Ve05SRLYPnR@sashalap>
 <ZAzOgw8Ui4kh1Z3D@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAzOgw8Ui4kh1Z3D@sol.localdomain>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 11, 2023 at 10:55:01AM -0800, Eric Biggers wrote:
> > 
> > If you disagree, and really think it's trivial, take 5 minutes to write
> > something up? please?
> 
> I never said that it's "trivial" or that it would take only 5 minutes; that's
> just silly.  Just that this is possible and it's what needs to be done.

(I did say that it would be trivial to query lore.kernel.org from a Python
script, which is absolutely correct.  I did *not* say that the whole thing,
including the local index if querying lore.kernel.org directly is not scalable
enough, would be trivial.  Just that it's *possible*, and there do not seem to
be any technical blockers...)

- Eric
