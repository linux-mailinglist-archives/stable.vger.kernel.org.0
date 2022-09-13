Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 560615B77D0
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 19:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232896AbiIMRYh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 13:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232901AbiIMRYD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 13:24:03 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CABE79D645
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 09:11:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9970ECE12A4
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 16:11:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 892D2C433D6;
        Tue, 13 Sep 2022 16:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663085475;
        bh=2oMKdlYrCOXP6ZAyIsniAiWi5rU2cvi/pUCas0ALL8k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M3SNcu5hcoyRPJfZvH/r4y7FU5GExsWe3q8g+O5gfIZWOtPa3uxOe8O2y9tWPV4lP
         CFU5WE592wn4hWjD6ueprv4jstGFIFlelj7Sy9sNeAUICLCg3MSZMqVehNFgwzTyU6
         GJDyXtM57qpUKD4ehma/pzzAVO/TKeHO7F6EkwdY=
Date:   Tue, 13 Sep 2022 18:11:39 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
        <holger@applied-asynchrony.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.19 000/192] 5.19.9-rc1 review
Message-ID: <YyCru3VUJn9rHT58@kroah.com>
References: <20220913140410.043243217@linuxfoundation.org>
 <3f43e609-ac83-f1e0-e991-5e7870bd1e6f@applied-asynchrony.com>
 <YyCqyoa6C4dVIuDD@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YyCqyoa6C4dVIuDD@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 13, 2022 at 06:07:38PM +0200, Greg Kroah-Hartman wrote:
> On Tue, Sep 13, 2022 at 05:20:04PM +0200, Holger Hoffstätte wrote:
> > On 2022-09-13 16:01, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.19.9 release.
> > > There are 192 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Thu, 15 Sep 2022 14:03:27 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.9-rc1.gz
> > 
> > 404: no popcorn
> > 
> > Some of the others are available, some are not. Mirrors acting up again?
> 
> Nope, my fault, sorry, new laptop, had to add another perl dependency
> that I had missed.  I'll go upload them all again...

Ok, all uploaded again, should hit the mirrors in a bit, let me know if
that didn't work in an hour or so.

thanks,

greg k-h
