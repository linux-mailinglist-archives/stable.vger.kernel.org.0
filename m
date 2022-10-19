Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD9CA603A2D
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 08:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbiJSGzA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 02:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiJSGy7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 02:54:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE9B5167E9;
        Tue, 18 Oct 2022 23:54:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F08861781;
        Wed, 19 Oct 2022 06:54:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36AD1C433D6;
        Wed, 19 Oct 2022 06:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666162489;
        bh=BTjN8/vHiLlG0kTIDnGngNJWeQFrbpyDTe47K92Vnrc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pJ1tjDMDb8rsqydH1d6s5sVKTMESDopiFgVlg8Da+yuwTX/yBqapvSbKs/ZyYIxaT
         s8Tm8ZBJwhyFLra8576orlK4TXGgwzsEg038WyJYDlqDGHFZskJDkuoiiCiZV8Md47
         xnhnvSpkBsgkEJRdlRd6nFJaK42P/TeN9KNTajSU=
Date:   Wed, 19 Oct 2022 08:54:46 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-efi@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH for-stable] efi: libstub: drop pointless get_memory_map()
 call
Message-ID: <Y0+fNpprkj4kr5tk@kroah.com>
References: <20221018182545.143757-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221018182545.143757-1-ardb@kernel.org>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 18, 2022 at 08:25:45PM +0200, Ard Biesheuvel wrote:
> commit d80ca810f096ff66f451e7a3ed2f0cd9ef1ff519 upstream
> 
> Currently, the non-x86 stub code calls get_memory_map() redundantly,
> given that the data it returns is never used anywhere. So drop the call.
> 
> Cc: <stable@vger.kernel.org> # v4.14+
> Fixes: 24d7c494ce46 ("efi/arm-stub: Round up FDT allocation to mapping size")
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  drivers/firmware/efi/libstub/fdt.c | 8 --------
>  1 file changed, 8 deletions(-)
> 
> This is a backport for v5.4 and older, where the patch in question did
> not apply cleanly on the first attempt. Please apply.

Thanks, now queued up.

greg k-h
