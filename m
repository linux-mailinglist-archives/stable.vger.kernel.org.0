Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 088034C34A6
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 19:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232746AbiBXSYa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Feb 2022 13:24:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbiBXSY3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Feb 2022 13:24:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FD5225317F;
        Thu, 24 Feb 2022 10:23:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13783B826E6;
        Thu, 24 Feb 2022 18:23:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43850C340E9;
        Thu, 24 Feb 2022 18:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645727036;
        bh=8TGSW6w/JOL2VaPQZ77oAX4jTKb1mTWfqAmxorApL7U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MVYBUkrpL6VrhgG6uRO7XyzXpZwPREqZiyTCNCgHB3xw1Ns4VvAu68ctN4i6GlPp4
         Yh1mQMjYtHLEeU8j3mzhPfG/f9QmoaHmsfM/cC+LuIrH7M5j6wg8r3o5/Ch10cMaxu
         InKnh5dZFJparcw9g5jSEh6MHO8Nr1T6D83qqZ+o=
Date:   Thu, 24 Feb 2022 19:23:53 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felix Becker <linux.felixbecker2@gmx.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH] USB: serial: simple: add Nokia phone driver
Message-ID: <YhfNOZnZdRigFAr7@kroah.com>
References: <20220224133109.10523-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220224133109.10523-1-johan@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 24, 2022 at 02:31:09PM +0100, Johan Hovold wrote:
> Add a new "simple" driver for certain Nokia phones, including Nokia 130
> (RM-1035) which exposes two serial ports in "charging only" mode.
> 
> Reported-by: Felix Becker <linux.felixbecker2@gmx.de>
> Link: https://lore.kernel.org/r/20220208201506.6c65834d@gmx.de
> Cc: stable@vger.kernel.org
> Signed-off-by: Johan Hovold <johan@kernel.org>


Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
