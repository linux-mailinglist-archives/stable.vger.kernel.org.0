Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8BDE5FDE43
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 18:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbiJMQ3u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 12:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiJMQ3s (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 12:29:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F47F19C0B
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 09:29:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37020B81E35
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 16:29:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76469C433C1;
        Thu, 13 Oct 2022 16:29:44 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="UgKr+yuB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1665678583;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8XlCkCAYLzuY0Lh5WCAMtwViJKWolj+1Yl+JGD1ihNM=;
        b=UgKr+yuB/cgbUWD6VztZNnCEwnsW7Tk9ebsXvPnEnlLwemw7QzFT5CLxsCCfQ3WM2XMaF7
        FXPKBipcGGBv/LWDRrqvDt0eKIV2cLz2EOOUiAd3RZvzBfcU1lPzMsa0dJX7MfrM8Lv0as
        Ii6G82qjYBlgxUN/M6xBFfTnoeIW4rc=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id d08f62e7 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Thu, 13 Oct 2022 16:29:42 +0000 (UTC)
Date:   Thu, 13 Oct 2022 10:29:40 -0600
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH stable 0/3] recent failed backports for the rng
Message-ID: <Y0g89B5GYqYco9w2@zx2c4.com>
References: <20221013153654.1397691-1-Jason@zx2c4.com>
 <Y0g6bYnxyNNX5WC6@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y0g6bYnxyNNX5WC6@kroah.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 13, 2022 at 06:18:53PM +0200, Greg KH wrote:
> On Thu, Oct 13, 2022 at 09:36:51AM -0600, Jason A. Donenfeld wrote:
> > Hi Greg,
> > 
> > You just sent me an automated email about these failing, so here they
> > are backported. 
> 
> Backported where?  Patch 1 is already in 5.10 and newer, does this one
> work in older?
> 
> And 2 and 3 for all branches?

For all of them they're not yet in.

I'll have a look at the 4.9 breakage.

Jason
