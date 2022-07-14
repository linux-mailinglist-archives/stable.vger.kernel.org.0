Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11C155744DA
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 08:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233972AbiGNGJB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 02:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233280AbiGNGIw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 02:08:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 635E811C1E;
        Wed, 13 Jul 2022 23:08:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A06B2B8220B;
        Thu, 14 Jul 2022 06:08:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C45C8C34114;
        Thu, 14 Jul 2022 06:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657778920;
        bh=o9lMKv613CrGGGygcthUdb4r6QPjw/LhZtoV5PD7a2g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eTQvcGYaPiqQUid3SIlQwBgz0x2usn1xBAD6Q9/9C6XDcMdw2H3olNWk9+VNhxbAq
         a8YVCJvVJtzITAjcX2eE3anmQoJ1MWXJk0jZFPPxX0aSuYIepproHBOMGtE4okEohA
         3hY91SEK4R9ATArIft3De4vnhpDGbtETslV4LrKY=
Date:   Thu, 14 Jul 2022 08:08:37 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     sean.wang@kernel.org
Cc:     stable@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sean Wang <sean.wang@mediatek.com>
Subject: Re: [PATCH 5.15 2/5] Revert "mt76: mt7921e: fix possible probe
 failure after reboot"
Message-ID: <Ys+y5QuKqtTPBGd0@kroah.com>
References: <4bdcd29552ba78c87d8799181b9acddec465ad3c.1657764335.git.sean.wang@kernel.org>
 <c297b97b4af66777202652b29183397e671bc15d.1657764335.git.sean.wang@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c297b97b4af66777202652b29183397e671bc15d.1657764335.git.sean.wang@kernel.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 13, 2022 at 07:07:38PM -0700, sean.wang@kernel.org wrote:
> From: Sean Wang <sean.wang@mediatek.com>
> 
> This reverts commit 649178c0493e4080b2b226b0ef9fa2d834b1b412.
> 
> Signed-off-by: Sean Wang <sean.wang@mediatek.com>
> ---
> There was mistake in
> 649178c0493e ("mt76: mt7921e: fix possible probe failure after reboot")
> that caused WiFi reset cannot work well as the reported issue
> "PROBLEM: [Stable v5.15.42+] [mt7921] Wake after suspend locks up system
> when mt7921-driver is used on a Lenovo ThinkPad E15 G3"
> in http://lists.infradead.org/pipermail/linux-mediatek/2022-June/042668.html
> So, we need to revert, fix and land it again on the stable tree from upstream.

Same questions here as on patch 1/5.
