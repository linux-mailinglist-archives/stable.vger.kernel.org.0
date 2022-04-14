Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 083005011B4
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242965AbiDNOOf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 10:14:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347974AbiDNOBt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 10:01:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD2D3BBEF;
        Thu, 14 Apr 2022 06:57:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53535B829A8;
        Thu, 14 Apr 2022 13:57:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9AB6C385A1;
        Thu, 14 Apr 2022 13:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649944647;
        bh=UmtEHEoEPr9euwfX1IGVzkYvnt8WHrS3FWOHMrHbhI4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yCttsKBk9ArkjIVOcdO4IGpskmkuRY6jylh2sm1wMHunRPJ9I9BMDnTXZ2P1SJ2as
         lpInWx0Ml5OCCV0Pd3tZlnprl0j0NjI6QGGp9bCt+1huQKOut7ovrOuJ9vFjMfNVzA
         oDcKsRvsZtedp0E8Foz7wYiQpCnFooP4i25pWooI=
Date:   Thu, 14 Apr 2022 15:34:20 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 208/338] ARM: ftrace: avoid redundant loads or
 clobbering IP
Message-ID: <Ylgi3Nh8mbAOvXi6@kroah.com>
References: <20220414110838.883074566@linuxfoundation.org>
 <20220414110844.817011928@linuxfoundation.org>
 <CAMj1kXG9ibOZfo60_pjwqACWhfPt8=38MDJD8C_CBoLrTYmCOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXG9ibOZfo60_pjwqACWhfPt8=38MDJD8C_CBoLrTYmCOw@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 14, 2022 at 03:25:29PM +0200, Ard Biesheuvel wrote:
> On Thu, 14 Apr 2022 at 15:23, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > From: Ard Biesheuvel <ardb@kernel.org>
> >
> > [ Upstream commit d11967870815b5ab89843980e35aab616c97c463 ]
> >
> 
> NAK. Please don't backport these patches to -stable, I thought I had
> been clear on this.

I dropped the patches you asked to be dropped, but this is a different
one and is already in the following releases:
	5.10.110 5.15.33 5.16.19 5.17.2

I can also drop it from here and the 5.4 queue if you do not want it
there.

thanks,

greg k-h
