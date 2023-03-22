Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA3FB6C551F
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 20:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbjCVTon (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 15:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjCVToZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 15:44:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EFD12366A
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 12:44:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A3CE622B4
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 19:44:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47045C433D2;
        Wed, 22 Mar 2023 19:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679514263;
        bh=9uSHxB6NaWOu4OJNfIFkRfiTCkJvHHvYrsCMHgBXwUg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rR9kU3tLNWdkz0Gdv7mrFmyb1eNq72e4ca9xLNzTprbSMJPqbrQ+SgUN88S018qW/
         SHVOnl/2JATeBTsY9aa5DNFg8eLcISpIgi3m4OGtbPTrOh5+FgNQGoYA/cKe/hVxAg
         l8JSMBUbCx2qzB8mgUN37v/yXdRvRPh1li6/UA9g=
Date:   Wed, 22 Mar 2023 20:44:20 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>
Cc:     Greg Kroah-Hartman <gregkh@google.com>,
        Sasha Levin <sashalevin@google.com>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Stanislav Fomichev <sdf@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: 5.10 LTS - Request for inclusion of getsockopt(SO_NETNS_COOKIE)
Message-ID: <ZBtalAJ1z4sUiJWO@kroah.com>
References: <CANP3RGeiFUsO4X_qQszO5JRY7UDSQVxuC+57aCscL0p+dmjyKA@mail.gmail.com>
 <ZBtVXJVi/zKb8eAk@kroah.com>
 <CANP3RGcHDjT1r5kwJRscy3r2deciKDqh7R92we1+eGUvcPbiUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANP3RGcHDjT1r5kwJRscy3r2deciKDqh7R92we1+eGUvcPbiUw@mail.gmail.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 22, 2023 at 12:37:15PM -0700, Maciej Żenczykowski wrote:
> On Wed, Mar 22, 2023 at 12:22 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > This really is a new feature, why not just move to a new kernel version
> > instead if you really need this?
> 
> Oh, come on, I *know* you know the answer to this question.
> 
> How's your effort to get device vendors/oems to use newer (major)
> kernels on their devices going?

Actually really well, with the new EU regulations and the reduced amount
of support time for LTS kernels, new devices will soon be forced to
update to move to newer kernel versions during the lifetime of the
device.

> Cause I was just recently *forced* into supporting 4.9 for another
> couple years...
> It's hard enough to get people to take stable version updates in a
> reasonable timeframe.
> 
> We either need to get this in via 5.10 LTS, or it goes in via Android
> Common Kernel...
> going in via LTS always seems preferable to me, since it benefits the
> wider community.

You are adding a new feature, we can't add that to stable kernels,
sorry.  Just stick this in your device-specific kernel please.

thanks,

greg k-h
