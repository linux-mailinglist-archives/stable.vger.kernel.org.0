Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1B064170D
	for <lists+stable@lfdr.de>; Sat,  3 Dec 2022 14:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbiLCNib (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Dec 2022 08:38:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiLCNib (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Dec 2022 08:38:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4382D1BE95;
        Sat,  3 Dec 2022 05:38:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E871BB80171;
        Sat,  3 Dec 2022 13:38:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56CD3C433C1;
        Sat,  3 Dec 2022 13:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670074707;
        bh=bMIyH4sES3OwK/UPdqogNOYLfgzZfXluu8F1DJdT2oM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VAf3CMVyOY0R/NPDtMP8vSI1X0QcjsUcs4W4/x6n4WhqoxefQ9i5hSMLewiNyr/O0
         fplnHo/+4GnsbjSUUFrZSFGhLhvw3pgQyTtBMd69IE0I62A6oxOqSIeqMnEse1a09z
         +/8TH+xqcWnTUOjU7AAVSO5SGc0AhO/c3JSxx/p4=
Date:   Sat, 3 Dec 2022 14:38:24 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Fedor Pchelkin <pchelkin@ispras.ru>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Starke <daniel.starke@siemens.com>,
        jirislaby@kernel.org, Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH 5.10] Revert "tty: n_gsm: avoid call of sleeping
 functions from atomic context"
Message-ID: <Y4tRUPNnbgGm0/Ts@kroah.com>
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
> 
> The above commit is reverted as the usage of tx_mutex seems not to solve
> the problem described in eb75efdec8dd ("tty: n_gsm: avoid call of sleeping
> functions from atomic context") and just moves the bug to another place.
> 
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> Reviewed-by: Daniel Starke <daniel.starke@siemens.com>
> Link: https://lore.kernel.org/r/20221008110221.13645-2-pchelkin@ispras.ru
> ---
>  drivers/tty/n_gsm.c | 39 +++++++++++++++++++++------------------
>  1 file changed, 21 insertions(+), 18 deletions(-)

Also, what happened to my original signed-off-by here?

thanks,

greg k-h
