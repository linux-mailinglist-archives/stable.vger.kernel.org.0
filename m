Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D963E528465
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 14:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232141AbiEPMpy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 08:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231545AbiEPMpy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 08:45:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF75D38BD7
        for <stable@vger.kernel.org>; Mon, 16 May 2022 05:45:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8CE46B811CB
        for <stable@vger.kernel.org>; Mon, 16 May 2022 12:45:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8BB3C385AA;
        Mon, 16 May 2022 12:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652705150;
        bh=oxIlOdlvmcxSa0MhEfL3Wf9ouMYcYnwSuF9bRw/ho78=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fz/GP0lfsYnFcOd4Jz30wbMSE24+vTy20REG63jH8ACXInKMfUxD8t3J85ZA8GGIS
         42VGw6j4IDuVN+CwKhTeN0lieVMKbscwXqGzPIpFFzwTSc8gaxE2HzhJPq+QrXkngl
         CqvJPOcAxKUQFQnxoM/kUN1TiMfddxcRS6vrvLlE=
Date:   Mon, 16 May 2022 14:45:47 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Francesco Dolcini <francesco.dolcini@toradex.com>
Cc:     andrew@lunn.ch, stable@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH 5.4] net: phy: Fix race condition on link status change
Message-ID: <YoJHezRYQR6EvTB2@kroah.com>
References: <20220516082919.18137-1-francesco.dolcini@toradex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516082919.18137-1-francesco.dolcini@toradex.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 16, 2022 at 10:29:19AM +0200, Francesco Dolcini wrote:
> backport of commit 91a7cda1f4b8bdf770000a3b60640576dafe0cec upstream.
> 

Both backports now queued up, thanks!

greg k-h
