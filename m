Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F21F6623D5F
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 09:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232638AbiKJIWR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 03:22:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232701AbiKJIWP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 03:22:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D61FB1FCC4
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 00:22:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94AFCB820FC
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 08:22:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC76C433D6;
        Thu, 10 Nov 2022 08:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668068531;
        bh=8m7zk4H++U5f+wKPyIGrnKbcJ/At1hVuWnbMbh5ZxYE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nCMDTGfMeM69E4Mx3DpHqUuM4jCGy0q6RzGYGMTTH1bAQEJyYnH1x8jef3s5oqWPf
         I04wZc6YXRSEkChDVbub2BcmKB2qenISSLjHnrtxmvIDvWG22H9BWDqRjriRTVGhmv
         5X/u0XpP3AniML4UeGLK7PwAiSTmPC6DCMZd7qOQ=
Date:   Thu, 10 Nov 2022 09:22:08 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     "Tyler Hicks (Microsoft)" <code@tyhicks.com>
Cc:     Suleiman Souhlal <suleiman@google.com>, sashal@kernel.org,
        Sangwhan Moon <sxm@google.com>, stable@vger.kernel.org,
        Kelsey Steele <kelseysteele@linux.microsoft.com>,
        Allen Pais <stable.kernel.dev@gmail.com>
Subject: Re: LTS 5.15 EOL Date
Message-ID: <Y2y0sOGT4UrKj6JV@kroah.com>
References: <CABCjUKBwLuTWE7A4PkNvRZx=6jeu3QjsFZq5iWZAKnmPYWKLog@mail.gmail.com>
 <Y1EGHnKcWzKv6t99@kroah.com>
 <20221028194019.vda2ei2nsqsysvby@sequoia>
 <Y1zIJw0RNGtQ3XgQ@kroah.com>
 <20221109234526.r5raofrnzddggarw@sequoia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109234526.r5raofrnzddggarw@sequoia>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 09, 2022 at 05:45:26PM -0600, Tyler Hicks (Microsoft) wrote:
> On 2022-10-29 08:28:55, gregkh@linuxfoundation.org wrote:
> > On Fri, Oct 28, 2022 at 02:40:19PM -0500, Tyler Hicks (Microsoft) wrote:
> > > On 2022-10-20 10:26:06, gregkh@linuxfoundation.org wrote:
> > > > On Thu, Oct 20, 2022 at 08:25:35AM +0900, Suleiman Souhlal wrote:
> > > > > Hello,
> > > > > 
> > > > > I saw that the projected EOL of LTS 5.15 is Oct 2023.
> > > > > How likely is it that the date will be extended? I'm guessing it's
> > > > > pretty likely, given that Android uses it.
> > > > 
> > > > Android is the only user that has talked to me about this kernel
> > > > version so far.  Please see:
> > > > 	http://kroah.com/log/blog/2021/02/03/helping-out-with-lts-kernel-releases/
> > > > for what I require in order to keep an LTS kernel going longer than 2
> > > > years.
> > > 
> > > Microsoft is also interested in a longer lifetime for v5.15 LTS. An
> > > additional year should meet our needs.
> > 
> > Wonderful, thanks for letting us know.
> > 
> > > We are aware of your "Helping Out ..." blog post and have been making
> > > improvements to be of more assistance. Kelsey and Allen (Cc'ed) have
> > > been doing -rc testing of v5.15 -rc releases and reporting the results
> > > to the list, on behalf of Microsoft. Testing of the -rc releases is
> > > mostly manual at this point, so we don't get every release tested before
> > > the release happens, but we're working on improving our processes and
> > > having builds/tests kick off automatically so that you can rely on us
> > > even more. We should have a much better system in place to help with
> > > testing and reporting by the time Oct 2023 rolls around. :)
> > 
> > Don't you all use kernelci already?  Doesn't that fit into your testing
> > environment already to make this easier?
> 
> You're right that we provide kernelci resources for the broader
> community but we use something different internally.
> 
> > 
> > And yes, I have seen the testing results, thank you for that.  If you
> > all want to be added to the initial -rc1 email announcement to help
> > trigger any build systems that way, just let me know.
> 
> Thanks. I had planned to watch for new pushes to the linux-stable-rc.git
> branches. If that doesn't work for some reason, we'll take you up on the
> email offer.

Watch out when using that tree, it is rebased all the time and contains
intermediate steps before the "real" -rc releases happen.  It is there
for systems that can not handle quilt series.

good luck!

greg k-h
