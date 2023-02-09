Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3FC36900B6
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 08:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbjBIHKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 02:10:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjBIHKG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 02:10:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E7E1B33C
        for <stable@vger.kernel.org>; Wed,  8 Feb 2023 23:10:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00D5861917
        for <stable@vger.kernel.org>; Thu,  9 Feb 2023 07:10:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E55DFC433EF;
        Thu,  9 Feb 2023 07:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675926604;
        bh=7ONAgzEPzUdEixBEL4T/tk/2duqElCRbGnFphNUFvj8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GpFH3wWFWVvLI77bF8QRsbjeCY03qchmEtTy3iJMqRjbb9gGHbG9atv6/hSZfJUDp
         +uxYAvU6Yfvn80te7oy8AfGpPFTwC3yGanNoUOiBT/542P7sjmJHmOAT83iDBBpFPM
         2AvaJ8NCDUh5eLZ29676JhsazxXnRwPox5Wtz7as=
Date:   Thu, 9 Feb 2023 08:10:00 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Michael Nies <michael.nies@netclusive.com>
Cc:     "'stable@vger.kernel.org'" <stable@vger.kernel.org>
Subject: Re: Kernel Bug 217013
Message-ID: <Y+ScSE/M54LxkzZu@kroah.com>
References: <HE1PR0902MB188277E37DED663AE440510BE1D99@HE1PR0902MB1882.eurprd09.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <HE1PR0902MB188277E37DED663AE440510BE1D99@HE1PR0902MB1882.eurprd09.prod.outlook.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 09, 2023 at 06:54:51AM +0000, Michael Nies wrote:
> Hello,
> 
> could you please have a look at Kernel Bug 217013 that was reported by me yesterday?
> https://bugzilla.kernel.org/show_bug.cgi?id=217013
> 
> Greg wrote that I should write a Mail to this address.

Thanks for the email, and the bug report, I'll work on this later today.

Do you also see the same problem with the 4.19.y kernel tree?  Or are
you not using that one too, or with a newer compiler?

thanks,

greg k-h
