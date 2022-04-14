Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4AB35005AE
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 07:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234212AbiDNF7o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 01:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239954AbiDNF7o (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 01:59:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB4D3369C8
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 22:57:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D56161E6D
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 05:57:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70109C385A1;
        Thu, 14 Apr 2022 05:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649915839;
        bh=YU8i33JkD4KGkiK3QaTTW8/5XfZup6lX2fAZDLml2rw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BwzAGOlBWrOqrGpvCRvVrdplLW1VVZcoLw8CpEygVNYqdaCGkOq/AZ1ugQ0wWc5+I
         3A0v22o1ybhGo/rB5JauNzX7UdJAblkbAO+oGH4dkkDRNMjubEpemOLlYUsU/nSOpS
         /5ZWqIjdcxMhjDXUaJHPWFiIVQ8Cd7GBEyOJ1OvI=
Date:   Thu, 14 Apr 2022 07:57:17 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     cam enih <nanericwang@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>, stable@vger.kernel.org,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: stable 5.10: please revert
 c4dc584a2d4c8d74b054f09d67e0a076767bdee5
Message-ID: <Yle3vc10uHh7AC2k@kroah.com>
References: <beaf8136-1c97-a65f-e64b-a98f23f024d2@infradead.org>
 <YlI7xE0JFYZSqJUL@sashalap>
 <CAPB3MF52aRsiq8wxFmQfK+KO=AVEhD+ww2O-0hj1KW5ntf3LXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPB3MF52aRsiq8wxFmQfK+KO=AVEhD+ww2O-0hj1KW5ntf3LXw@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A: http://en.wikipedia.org/wiki/Top_post
Q: Were do I find info about this thing called top-posting?
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

On Thu, Apr 14, 2022 at 01:50:05PM +0800, cam enih wrote:
> thanks everyone.
> 
> two suggestions:
> 
> 1. To avoid this issue from future dot builds of LTS, i would suggest to
> avoid MRs of any config/module dependency changes, unless the scope of
> impact limits to the scope of MR itself.

What is a "mr"?

> 2. this issue can fail-fast by checking the dependency in compile time.

And how could we have tested this?

confused,

greg k-h
