Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 726115427AD
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 09:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbiFHHFf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 03:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354639AbiFHGTm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 02:19:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A2F19297;
        Tue,  7 Jun 2022 23:15:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A58BBB81FC9;
        Wed,  8 Jun 2022 06:15:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4F60C34116;
        Wed,  8 Jun 2022 06:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654668955;
        bh=ryIOVG2/H44ZWlE3JtU1m7wD6c6zOxENtCDNvDozD+I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S3tDaUKg6m5er2DxG2+5A+y5EZr/hY/Hn2B/KshYvMNIe4/tAI5wPxNU1vgiGKDPb
         keG0PnPkF54J3SjwpBN+axJzS9GVZkL7qccSj7Tc68U6xAuAKdGQD2WUCaWGblEJ8W
         ZSfUzLn4ymUhI4Tj9pX0VmdPooaXGYculIsbUV40=
Date:   Wed, 8 Jun 2022 08:15:52 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Joe Perches <joe@perches.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Soumya Negi <soumya.negi97@gmail.com>,
        fabioaiuto83@gmail.com, hdegoede@redhat.com,
        straube.linux@gmail.com, linux@roeck-us.net,
        linux-staging@lists.linux.dev
Subject: Re: [PATCH AUTOSEL 5.15 24/51] staging: rtl8723bs: Fix alignment to
 match open parenthesis
Message-ID: <YqA+mOYUNcYj59Cy@kroah.com>
References: <20220607175552.479948-1-sashal@kernel.org>
 <20220607175552.479948-24-sashal@kernel.org>
 <ff5d5283af74576f65545399851a40cb4f16a85c.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff5d5283af74576f65545399851a40cb4f16a85c.camel@perches.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 07, 2022 at 05:04:08PM -0700, Joe Perches wrote:
> On Tue, 2022-06-07 at 13:55 -0400, Sasha Levin wrote:
> > From: Soumya Negi <soumya.negi97@gmail.com>
> > 
> > [ Upstream commit f722d67fad290b0c960f27062adc8cf59488d0a7 ]
> > 
> > Adhere to Linux coding style. Fixes checkpatch warnings:
> > CHECK: Alignment should match open parenthesis
> > CHECK: line length of 101 exceeds 100 columns
> 
> why should this be backported?  It's only whitespace changes.

Good catch, it should not.

thanks,

greg k-h
