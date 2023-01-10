Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12E91663AB3
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 09:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbjAJIQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 03:16:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231534AbjAJIQq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 03:16:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C6083D1EF
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 00:16:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B22E7B80FEF
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 08:16:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F7AC433D2;
        Tue, 10 Jan 2023 08:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673338602;
        bh=YivH9GLhXTlXB1CHup/XtKIX4TRUVuuvPOdaN8iwl28=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2G1uz6gpnBsGUBUwqAUEGK+IiEJ+mkpCDaztK8jxEjy6Ax/11EV81zsqUXQ4rwQ+J
         Gn89aL/6kfxJxTbmJ6eI27Stsjz6pBeWAapFAmxjBbQiWvsKV/VhLIEtzVGgsJFzKs
         Glhxccv7zJsvuB+84MgaEeHuhK417B4T7dBO0pOo=
Date:   Tue, 10 Jan 2023 09:16:38 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] io_uring: fix CQ waiting timeout
 handling" failed to apply to 5.15-stable tree
Message-ID: <Y70e5r6T7SzaT7cV@kroah.com>
References: <1673338181165182@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1673338181165182@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 10, 2023 at 09:09:41AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.15-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 

Nevermind, I fixed this up for all 3 trees.

greg k-h
