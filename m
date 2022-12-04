Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88121641DBF
	for <lists+stable@lfdr.de>; Sun,  4 Dec 2022 16:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbiLDP5X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Dec 2022 10:57:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbiLDP5X (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Dec 2022 10:57:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E897713D70;
        Sun,  4 Dec 2022 07:57:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83CA760E00;
        Sun,  4 Dec 2022 15:57:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 976EDC433D6;
        Sun,  4 Dec 2022 15:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670169441;
        bh=bAtDZvjG4sAFMdTVV9zqI+d8oTlQBOwzUvrwbRCgPUU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N/LPRvVv2Uy3F6orOgZR/9eBTtqLPfm79nWdiUJwNBzwSbH1tiD5ZvGvtrbwFNxKY
         v6ERBeGtDkxRnEvHGpeI26edvQnKbl/aXReR9eGuIYOQBGotZmmpceo7Uo8SPYuHfa
         QxpM6cXKaB2HK3oFgrrSQSOyEvOLoVP/yPEEUmSI=
Date:   Sun, 4 Dec 2022 16:57:18 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Fedor Pchelkin <pchelkin@ispras.ru>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Starke <daniel.starke@siemens.com>,
        jirislaby@kernel.org, Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH 5.10] Revert "tty: n_gsm: avoid call of sleeping
 functions from atomic context"
Message-ID: <Y4zDXrMEeCTElmRs@kroah.com>
References: <20221123181916.6911-1-pchelkin@ispras.ru>
 <Y4tQjdqL2vbDnTX8@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4tQjdqL2vbDnTX8@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 03, 2022 at 02:35:09PM +0100, Greg Kroah-Hartman wrote:
> On Wed, Nov 23, 2022 at 09:19:16PM +0300, Fedor Pchelkin wrote:
> > From: Fedor Pchelkin <pchelkin@ispras.ru>
> > 
> > [ Upstream commit acdab4cb4ba7e5f94d2b422ebd7bf4bf68178fb2 ]
> > 
> > This reverts commit eb75efdec8dd0f01ac85c88feafa6e63b34a2521.
> 
> What about for 5.15?  This should also be needed there, right?

Odd, it never got applied to 5.15, so nevermind about that, sorry for
the noise.

greg k-h
