Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0FF559B585
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 18:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbiHUQuK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 12:50:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiHUQuJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 12:50:09 -0400
Received: from rfvt.org.uk (rfvt.org.uk [37.187.119.221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5C3B1C91E;
        Sun, 21 Aug 2022 09:50:07 -0700 (PDT)
Received: from wylie.me.uk (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by rfvt.org.uk (Postfix) with ESMTPS id CB5FB82CC4;
        Sun, 21 Aug 2022 17:50:01 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wylie.me.uk;
        s=mydkim005; t=1661100601;
        bh=q+x+Ol4FFP5xOeKSbHjfFQjd4jkWVjDlO4DK5fZcXCM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=n9ilN6+egqrx5676IDM6rRoFeo5RFASYYAMqC3nwoyEPWXvxuVFxbc62BpVkc7jXe
         nCfMzPFVXsfBAm7IeBkX9Zlh1Pd9Vm3BuTcBsNPMhs05/V71v5wbvLCYgehqK/7mrT
         fAERmPVg8K9gjVxVH3ahVxHHmKpT7pQbRGljQqiaXy1FA0Cdu6BmpFZQEP60WH2SCv
         awcO+0Qy4whfipO8XLCyqfyfJtRMJbrAQVGFAzt3rw5W9MlWHqYnpLDg5rIlTPK97D
         jpxenad8f+GqtFRSzMIs0kUfAkgRqFfr8ZRLsTpBwRR9r60NEwsglOj3v8fACXzf54
         gd8ChZxE8QCVA==
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <25346.25145.488362.162952@wylie.me.uk>
Date:   Sun, 21 Aug 2022 17:50:01 +0100
From:   "Alan J. Wylie" <alan@wylie.me.uk>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Regression in 5.19.0: USB errors during boot
In-Reply-To: <20220821142610.GA2979@lst.de>
References: <25342.20092.262450.330346@wylie.me.uk>
        <Yv5Q8gDvVTGOHd8k@kroah.com>
        <20220821062345.GA26598@lst.de>
        <25345.60162.942383.502797@wylie.me.uk>
        <20220821142610.GA2979@lst.de>
X-Mailer: VM 8.2.0b under 27.2 (x86_64-pc-linux-gnu)
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

at 16:26 on Sun 21-Aug-2022 Christoph Hellwig (hch@lst.de) wrote:

> Thanks for confirming my suspicion.  I'd still like to fix the issue
> with CONFIG_GART_IOMMU enabled once I've tracked it down.  Would you
> be willing to test patches?

I'll be glad to help.

I've also had a look in the loft and my box of bits for an old
Athlon64/Opteron/Turion/Sempron processor, but I'm afraid all I've got
are:

Phenom II X6 1055T
Phenom II X2 545
Athlon 2  x2 270

-- 
Alan J. Wylie                                          https://www.wylie.me.uk/

Dance like no-one's watching. / Encrypt like everyone is.
Security is inversely proportional to convenience
