Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21F96516514
	for <lists+stable@lfdr.de>; Sun,  1 May 2022 18:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238026AbiEAQFM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 May 2022 12:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348798AbiEAQFG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 May 2022 12:05:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95CE7506F6
        for <stable@vger.kernel.org>; Sun,  1 May 2022 09:01:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57672B807EE
        for <stable@vger.kernel.org>; Sun,  1 May 2022 16:01:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55DBCC385A9;
        Sun,  1 May 2022 16:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651420898;
        bh=XMzV2LmnwavMO5rjCRPasKgh681uQ5FIPVKM4odh6I8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DF4B4lMp4uBks7NiiLP+yOPvkkVMSDLox6cEqO54AOMht+EV80pqFjo6S6f5BC3Fj
         zVoUZg13L4z5J5en5EQNjzTBd6gls7rFogtZnb2+7+reVWZdHG/o1U5HMgx8/ocI+l
         6qAR0O1eENexmTEM1AgujWPrbz19L3ei3s9qAOrw=
Date:   Sun, 1 May 2022 18:00:02 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     mathias.nyman@linux.intel.com
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] xhci: increase usb U3 -> U0 link resume
 timeout from 100ms to" failed to apply to 5.4-stable tree
Message-ID: <Ym6ugoUj17gWZXOC@kroah.com>
References: <165142032415585@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165142032415585@kroah.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 01, 2022 at 05:52:04PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Nevermind, I fixed this up, sorry for the noise.

greg k-h
