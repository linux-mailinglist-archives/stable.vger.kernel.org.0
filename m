Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56B2D5EAD7D
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 19:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbiIZRD5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 13:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbiIZRDj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 13:03:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D699C95E57;
        Mon, 26 Sep 2022 09:05:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F367560F3E;
        Mon, 26 Sep 2022 16:05:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 126D5C433C1;
        Mon, 26 Sep 2022 16:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664208332;
        bh=H71XsYkWn8mKQfBZGC8BMhs00ORlABV3dPaXePxUXqU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GYfXLyFUm+0yFYts9hFYYvsVfcKOQn/s2lgj4hZz00tG+ATTQ8P8RjJiu59fAn2rW
         oO0rK2fOPcvBr9XyZrazSz2oy1G7/zIOP7SZGnrItLM3SZ7JPIz69Xy6RAnSpboesI
         XdZNK73tv2EImGAHbMx71dYSq3Ab62ZuVjDysbus=
Date:   Mon, 26 Sep 2022 18:05:29 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Kent Gustavsson <kent@minoris.se>,
        Marcus Folkesson <marcus.folkesson@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 042/120] iio:adc:mcp3911: Switch to generic firmware
 properties.
Message-ID: <YzHNyS/1AVzHVz0e@kroah.com>
References: <20220926100750.519221159@linuxfoundation.org>
 <20220926100752.250813953@linuxfoundation.org>
 <20220926125012.00001f86@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926125012.00001f86@huawei.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 26, 2022 at 12:50:12PM +0100, Jonathan Cameron wrote:
> On Mon, 26 Sep 2022 12:11:15 +0200
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
> > From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> > 
> > [ Upstream commit 4efc1c614d334883cce09c38aa3fe74d3fb0bbf0 ]
> > 
> > This allows use of the driver with other types of firmware such as ACPI
> > PRP0001 based probing.
> > 
> > Also part of a general attempt to remove direct use of of_ specific
> > accessors from IIO.
> > 
> > Added an include for mod_devicetable.h whilst here to cover the
> > struct of_device_id definition.
> 
> I'd treat this a feature enabling rather than a fix.
> It's small however, so if someone has a sent a backport request I'm fine
> with it going in stable. If not, probably just unnecessary noise for stable.

Now dropped, and the follow-on patch for this driver, from 5.4, 5.10,
and 5.15.

thanks,

greg k-h
