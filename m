Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60DF34C6C41
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 13:24:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236350AbiB1MYV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 07:24:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236315AbiB1MXq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 07:23:46 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E10470336;
        Mon, 28 Feb 2022 04:23:06 -0800 (PST)
Date:   Mon, 28 Feb 2022 13:23:02 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1646050984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a/Gjv/OGZldokMkNnypLm+ugx/pyxGjoMpJLTQ9iw6A=;
        b=MQcsEhVZsLP/sJSz3T/JzOXlqqQyKENsAVUsisZbwcnTaOQFwh6lybBhbnAWdtiWor19mv
        DrtcF62iWDP5chPiqZoV3KQ6thA+dPOfGUcwEcnNZsI70IQLM/9rneH0HT5zDTWZoWS+v7
        0r+tHJAKMTBtm4w44Cp4S3vBPiZ60kE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Richard Leitner <richard.leitner@linux.dev>
To:     Pavel Machek <pavel@denx.de>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Tommaso Merciai <tomm.merciai@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        richard.leitner@skidata.com, linux-usb@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.10 04/23] usb: usb251xb: add boost-up property
 support
Message-ID: <Yhy+pvprwSx4zdCG@ltleri2>
References: <20220215152957.581303-1-sashal@kernel.org>
 <20220215152957.581303-4-sashal@kernel.org>
 <20220220101256.GC7321@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220220101256.GC7321@amd>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Sun, Feb 20, 2022 at 11:12:57AM +0100, Pavel Machek wrote:
> Hi!
> 
> > From: Tommaso Merciai <tomm.merciai@gmail.com>
> > 
> > [ Upstream commit 5c2b9c61ae5d8ad0a196d33b66ce44543be22281 ]
> > 
> > Add support for boost-up register of usb251xb hub.
> > boost-up property control USB electrical drive strength
> > This register can be set:
> > 
> >  - Normal mode -> 0x00
> >  - Low         -> 0x01
> >  - Medium      -> 0x10
> >  - High        -> 0x11
> > 
> > (Normal Default)
> > 
> > References:
> >  - http://www.mouser.com/catalog/specsheets/2514.pdf p29
> 
> Should the boost-up property be documented somewhere in the kernel
> tree? We normally do that for device tree properties. And we normally
> have properties used somewhere in the device tree. What is going on here?

AFAIK this patch was dropped for all stable releases, so this specific
AUTOSEL message/thread is obsolete.

Nonetheless the DT documentation is also missing on master. Therefore
I guess it should be provided asap 😉

Tommaso, can you provide a patch?

regards;rl

> 
> Best regards,
> 							Pavel
