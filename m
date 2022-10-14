Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 879E95FF273
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 18:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbiJNQpf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 12:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbiJNQpe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 12:45:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93CEC9A2A0;
        Fri, 14 Oct 2022 09:45:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 435AFB82366;
        Fri, 14 Oct 2022 16:45:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02519C433D6;
        Fri, 14 Oct 2022 16:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665765929;
        bh=fORHAKhkkr6i5biet1dKhDXZ1OJsNvuqWbZ57XnX2fo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1w77jxdPcu/oF/4ih0UxtzAC0F0eqHSIxM25q6jxLxPdIXJoYUyEDO2QIJ0BEP00a
         CHzpU7VvchwzQL7OGjn1/wtLKjyk0WmY+qM1o92oHcxriu1vnnrvsCjz2PIPcql6Sn
         Qf2Y6CJEaYoDRa61sOSpALDSGpuPHHiDaxyIbfNo=
Date:   Fri, 14 Oct 2022 18:46:13 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tyler Hicks <code@tyhicks.com>
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH] Documentation: process: update the list of current LTS
Message-ID: <Y0mSVQCQer7fEKgu@kroah.com>
References: <20221013183414.667316-1-ndesaulniers@google.com>
 <130adb69-ff37-51fd-26a2-674ab78ff044@gmail.com>
 <Y0kK2g+CUxbqPJ8d@kroah.com>
 <20221014163426.tjxmek6xq6ojejea@sequoia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221014163426.tjxmek6xq6ojejea@sequoia>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 14, 2022 at 11:34:26AM -0500, Tyler Hicks wrote:
> On 2022-10-14 09:08:10, Greg Kroah-Hartman wrote:
> > On Fri, Oct 14, 2022 at 09:24:11AM +0700, Bagas Sanjaya wrote:
> > > On 10/14/22 01:34, Nick Desaulniers wrote:
> > > > 3.16 was EOL in 2020.
> > > > 4.4 was EOL in 2022.
> > > > 
> > > > 5.10 is new in 2020.
> > > > 5.15 is new in 2021.
> > > > 
> > > > We'll see if 6.1 becomes LTS in 2022.
> > > > 
> > > 
> > > I think the table should be keep updated whenever new LTS is announced
> > > and oldest LTS become EOL, to be on par with kernel.org homepage.
> > 
> > Yeah, I didn't even realize this was in the kernel tree, I've just been
> > keeping kernel.org up to date.
> 
> How about simply replacing this table with a pointer to
> https://www.kernel.org/category/releases.html so that you don't have to
> remember to update tables in two different places? It also has the
> benefit that the documentation is never stale (missing new LTS
> releases), even when someone is reading the documentation from an older
> kernel release.

Sure, that makes more sense!

greg k-h
