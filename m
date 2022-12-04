Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C87DF641DC3
	for <lists+stable@lfdr.de>; Sun,  4 Dec 2022 16:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbiLDP7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Dec 2022 10:59:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbiLDP7K (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Dec 2022 10:59:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB7C11A17;
        Sun,  4 Dec 2022 07:59:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C244DB807E5;
        Sun,  4 Dec 2022 15:59:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B43C433D6;
        Sun,  4 Dec 2022 15:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670169547;
        bh=JW/Oo312ivCVzkF1MzwvQXMZLERGpp065FGLKX24WAw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cJLjOuTo9Ggbgc2qn+Mz659Fl2rA/+0cvLoFjSapYQbj9I6/OIdbTzi8TZPBoRsM9
         Dt2quiYgJSs8w/+SnE4PMN6W7Z4jmHxuDn4ez9FfpiupUTtleHlvWFpLTYPA2irZWV
         p19/eGHGk92V8O1MsflGbXQNNKOUa8LB4NH2FyUc=
Date:   Sun, 4 Dec 2022 16:59:04 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Fedor Pchelkin <pchelkin@ispras.ru>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Starke <daniel.starke@siemens.com>,
        jirislaby@kernel.org, Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org, Pavel Machek <pavel@denx.de>
Subject: Re: [PATCH v2 5.10] Revert "tty: n_gsm: avoid call of sleeping
 functions from atomic context"
Message-ID: <Y4zDyCrniSF4J8xz@kroah.com>
References: <Y4tRUPNnbgGm0/Ts@kroah.com>
 <20221203215518.8150-1-pchelkin@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221203215518.8150-1-pchelkin@ispras.ru>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 04, 2022 at 12:55:18AM +0300, Fedor Pchelkin wrote:
> From: Fedor Pchelkin <pchelkin@ispras.ru>
> 
> [ Upstream commit acdab4cb4ba7e5f94d2b422ebd7bf4bf68178fb2 ]
> 
> This reverts commit eb75efdec8dd0f01ac85c88feafa6e63b34a2521.
> 
> The above commit is reverted as the usage of tx_mutex seems not to solve
> the problem described in eb75efdec8dd ("tty: n_gsm: avoid call of sleeping
> functions from atomic context") and just moves the bug to another place.
> 
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> Reviewed-by: Daniel Starke <daniel.starke@siemens.com>
> Link: https://lore.kernel.org/r/20221008110221.13645-2-pchelkin@ispras.ru
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Reviewed-by: Pavel Machek <pavel@denx.de>

Now queued up, thanks.

greg k-h
