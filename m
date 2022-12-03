Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48A7D64170A
	for <lists+stable@lfdr.de>; Sat,  3 Dec 2022 14:36:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbiLCNgX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Dec 2022 08:36:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbiLCNgG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Dec 2022 08:36:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 964081DF1D;
        Sat,  3 Dec 2022 05:35:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9B6EB80171;
        Sat,  3 Dec 2022 13:35:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10476C433C1;
        Sat,  3 Dec 2022 13:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670074512;
        bh=drQGBF1uDwZCqu0sU1HsJDJRHN1rFVFJ3QAmGpv5kjc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xC2OrKRVZv697XWbRr73J2Ls4Uu+EUGDJ4YGt7TdXYKxfbsG3LXIkE60gDgYD8dRu
         oJosNL85ESc3CsCcBT2r4SBh312Y3Zwi4S1JjVoj/xcfI9YY/f2pnHbM/h2VmaklmM
         glR9JXvAZ0IiYh1G/nFa77/n2aRYvoGiSJWRbWJc=
Date:   Sat, 3 Dec 2022 14:35:09 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Fedor Pchelkin <pchelkin@ispras.ru>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Starke <daniel.starke@siemens.com>,
        jirislaby@kernel.org, Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH 5.10] Revert "tty: n_gsm: avoid call of sleeping
 functions from atomic context"
Message-ID: <Y4tQjdqL2vbDnTX8@kroah.com>
References: <20221123181916.6911-1-pchelkin@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123181916.6911-1-pchelkin@ispras.ru>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 23, 2022 at 09:19:16PM +0300, Fedor Pchelkin wrote:
> From: Fedor Pchelkin <pchelkin@ispras.ru>
> 
> [ Upstream commit acdab4cb4ba7e5f94d2b422ebd7bf4bf68178fb2 ]
> 
> This reverts commit eb75efdec8dd0f01ac85c88feafa6e63b34a2521.

What about for 5.15?  This should also be needed there, right?

thanks,

greg k-h
