Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8824650B41
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 13:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbiLSMPb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 07:15:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbiLSMPa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 07:15:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61802122
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 04:15:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F006560F30
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 12:15:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC6C1C433EF;
        Mon, 19 Dec 2022 12:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671452127;
        bh=aE1Mv9eKkSZ8FH/1P/w9nfDA6h4iAqdI6LcvNQXp9L8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TM1ur55124pzIouxv9fo3m7vJODhKUz3RKOqWvkhNdD1uz4skgO36heFQUxZVAm/I
         13Wa8RMsWeu6cvCSE673l8/PrHk20748v9l4XzJFlMgbRuQhks+B/L3AUJC1mPuVCe
         E73Tr3mLP7EwTTdQ2AyihkGxGsQRyvUSJRHGzbiI=
Date:   Mon, 19 Dec 2022 13:15:24 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sergio Paracuellos <sergio.paracuellos@gmail.com>
Cc:     John Thomson <lists@johnthomson.fastmail.com.au>,
        stable@vger.kernel.org
Subject: Re: request for mt7621 SLUB boot fix for 6.1.y
Message-ID: <Y6BV3A0V7NQWzzes@kroah.com>
References: <1a53deef-63f7-43c7-aa73-7ce46fb92a0d@app.fastmail.com>
 <CAMhs-H9jMVoaRxqK=Bh1+xPWD+-MnoXiKu+5MwDNNM-tEWSghg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMhs-H9jMVoaRxqK=Bh1+xPWD+-MnoXiKu+5MwDNNM-tEWSghg@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 19, 2022 at 07:57:16AM +0100, Sergio Paracuellos wrote:
> Hi John,
> 
> On Mon, Dec 19, 2022 at 7:53 AM John Thomson
> <lists@johnthomson.fastmail.com.au> wrote:
> >
> > Hi stable team,
> >
> > I would like to request for cherry picking to the linux-6.1.y branch:
> > 19098934f910 ("PCI: mt7621: Add sentinel to quirks table")
> > a2cab953b4c0 ("mips: ralink: mt7621: define MT7621_SYSC_BASE with __iomem")
> > b4767d4c0725 ("mips: ralink: mt7621: soc queries and tests as functions")
> > 7c18b64bba3b ("mips: ralink: mt7621: do not use kzalloc too early")
> >
> 
> I have tested all of these patches in the current tree for v6.2 and my
> boards boot properly without issues now. I guess all of these will be
> added to 6.1 when the merge window finishes.

Now queued up, thanks.

greg k-h
