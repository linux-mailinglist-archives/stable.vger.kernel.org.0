Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF23F56577C
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 15:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234862AbiGDNgK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 09:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234867AbiGDNfz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 09:35:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7A022637
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 06:33:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B844B80EE2
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 13:33:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04A7BC3411E;
        Mon,  4 Jul 2022 13:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656941601;
        bh=ZGyNdCQLqlWxTPtqPjyNJ3z+3hZVPTlY08IF8mLT/zI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tiNKymvTl2fYUnxLVD1BvF32K4g0tgaRM1unl0PeDmujWnwuxhvJuAwP4CYj8/D8V
         CsY+3WQ6NwAb1LPUze6cNHm4xb4oULZ5aCNgtM1vZdTkIpTVN+t1GfFQPpK29KkQXc
         NDByREpZ/7FpX2xlhm9QoTIsBmhff2D2FEOrTbZM=
Date:   Mon, 4 Jul 2022 15:33:18 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: 5.18/15/10 backport
Message-ID: <YsLsHslaa8MWMZM/@kroah.com>
References: <36e6d08d-89c0-99e3-a248-1ce79315de03@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36e6d08d-89c0-99e3-a248-1ce79315de03@kernel.dk>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 30, 2022 at 02:45:53PM -0600, Jens Axboe wrote:
> Hi,
> 
> Can you apply these three patches, one for each of the 5.10, 5.15, and
> 5.18 stable tree? Doesn't fix any issues of concern, just ensures that
> we -EINVAL when invalid fields are set in the sqe for these opcodes.
> This brings it up to par with 5.19 and newer.

All now queued up, thanks.

greg k-h
