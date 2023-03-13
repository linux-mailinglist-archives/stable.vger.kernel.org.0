Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CEC86B8139
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 19:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbjCMSzm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 14:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbjCMSzN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 14:55:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23217F74B;
        Mon, 13 Mar 2023 11:54:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE752B811A1;
        Mon, 13 Mar 2023 18:54:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DEC9C433D2;
        Mon, 13 Mar 2023 18:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678733659;
        bh=Dnpm+hz/zJ1IFUOpg/H4/aNj/Z0ntprerDyImjlhSa0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ojBH30oKWurbeDFjZ2rcxmSOnsBzofdJqBx6pYHhXUVYXblNKbiKjfk6UkdM6Ay9w
         SLl7g/4MSoDI3PG5cOwSb4lZ0MmkP2fGGe4fslkd0ryIODGUYkj0k4tjEWvw8p3QDe
         S2IAm2d1VRSGJI84PdWhM4nZv75w/YNGHRnF1gP069xIk4AgfAuQI8tL+jiK0R0OHt
         BTBZH+t04yG4MRRNboGlJWgB/Ac3uDItXvUYW6rupHnVOE/TeCYzBxnhm+DDQfduru
         qKuZwtWSWVb8cu0hPzZXj8gPQyQtGTeoSc8jdm1M1oYXfsUhGyCuJ4XnTugHeS2viw
         9cv4+7bwaXFGw==
Date:   Mon, 13 Mar 2023 11:54:17 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, Theodore Ts'o <tytso@mit.edu>,
        Matthew Wilcox <willy@infradead.org>,
        Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <ZA9xWaHuh3hiYr8X@sol.localdomain>
References: <Y/zxKOBTLXFjSVyI@sol.localdomain>
 <ZATC3djtr9/uPX+P@duo.ucw.cz>
 <ZAewdAql4PBUYOG5@gmail.com>
 <ZAwe95meyCiv6qc4@casper.infradead.org>
 <ZAyK0KM6JmVOvQWy@sashalap>
 <20230311161644.GH860405@mit.edu>
 <ZAy+3f1/xfl6dWpI@sol.localdomain>
 <ZAzH8Ve05SRLYPnR@sashalap>
 <ZAzOgw8Ui4kh1Z3D@sol.localdomain>
 <ZA9gXRMvQj2TO0W3@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZA9gXRMvQj2TO0W3@kroah.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 13, 2023 at 06:41:49PM +0100, Greg KH wrote:
> > (Even just stable-kernel-rules.rst is totally incorrect these days.)
> 
> I do not understand this, what is not correct?
> 
> It's how to get patches merged into stable kernels, we go
> above-and-beyond that for those developers and maintainers that do NOT
> follow those rules.  If everyone followed them, we wouldn't be having
> this discussion at all :)

The entire list of rules for what patches are accepted into stable.  This is a
longstanding issue that has been reiterated many times in the past, see
https://lore.kernel.org/stable/20220924182124.GA19210@duo.ucw.cz for example.

The fact is, many people *do* follow the rules exactly by *not* tagging commits
for stable when they don't meet the documented eligibility criteria.  But then
the stable maintainers backport the commits anyway, as the real eligibility
criteria are *much* more relaxed than what is documented.

- Eric
