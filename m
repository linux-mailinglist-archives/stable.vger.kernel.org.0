Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBD10516D4A
	for <lists+stable@lfdr.de>; Mon,  2 May 2022 11:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235428AbiEBJ1S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 May 2022 05:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbiEBJ1R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 May 2022 05:27:17 -0400
Received: from theia.8bytes.org (8bytes.org [81.169.241.247])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D97143BBED
        for <stable@vger.kernel.org>; Mon,  2 May 2022 02:23:49 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id C4F6F5E5; Mon,  2 May 2022 11:23:47 +0200 (CEST)
Date:   Mon, 2 May 2022 11:23:43 +0200
From:   JoergRoedel <joro@8bytes.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     =?iso-8859-1?Q?J=F6rg-Volker?= Peetz <jvpeetz@web.de>,
        SuraveeSuthikulpanit <suravee.suthikulpanit@amd.com>,
        WillDeacon <will@kernel.org>, stable@vger.kernel.org
Subject: Re: Linux 5.17.5
Message-ID: <Ym+jH9ekmZgwwU/H@8bytes.org>
References: <165106510338255@kroah.com>
 <a5c7406e-64b0-7522-fef0-27fec1ac6698@web.de>
 <Ym6X3enhptEUyyJG@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Ym6X3enhptEUyyJG@kroah.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 01, 2022 at 04:23:25PM +0200, Greg KH wrote:
> On Sun, May 01, 2022 at 02:37:36PM +0200, Jörg-Volker Peetz wrote:
> > Is this serious?
> > CPU is AMD Ryzen 7 5700G (RENOIR).
> > The config file is attached.
> > With kernel 5.17.3 this warning did not appear.
> 
> Can you use 'git bisect' to track down the offending change?

This warning is not serious, it means that the GA log needs a very long
time to initialize. We have seen this upstream already and I am
currently working with AMD to find the root-cause for the large delay.
There is already a fix which increases the delay, but it doesn't seem to
help on every machine. The fix should already be in v5.17.5.

I also suspect this is hard to bisect, as it seems to be timing related.
I will send you a patch for testing in the next days, would be great if
you could report back then.

Regards,

	Joerg
