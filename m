Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8738C53F98A
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 11:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238966AbiFGJWn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 05:22:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238987AbiFGJWl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 05:22:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D619AAE70
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 02:22:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5FA1611DB
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 09:22:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA689C385A5;
        Tue,  7 Jun 2022 09:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654593756;
        bh=qhP0jo6czoQWlcPxJTTnRgt7+pcmE+KYFwLZ/8HO0r4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fpXQToMs2Q0XMiy51WTn65pBeUdi+aUhpi6PR5fGHHn+sOF4TqKzgjy+7LujOMAB9
         OtZuUQ1XmDVLvTVJ7ccZ7U8N3fYyrBz6u+F6V/uJDfyUHl2ZLyBoH4B6VTW+lIBRIL
         rRfMTKkzlXLdEF2+MTOAgl2p77xoyZLzviqGS4lM=
Date:   Tue, 7 Jun 2022 11:14:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH stable 5.10 5.15 5.17 5.18] Revert "random: use static
 branch for crng_ready()"
Message-ID: <Yp8W+zkF2QUngWG0@kroah.com>
References: <20220607084005.666059-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220607084005.666059-1-Jason@zx2c4.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 07, 2022 at 10:40:05AM +0200, Jason A. Donenfeld wrote:
> This reverts upstream commit f5bda35fba615ace70a656d4700423fa6c9bebee
> from stable. It's not essential and will take some time during 5.19 to
> work out properly.
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  drivers/char/random.c | 12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)
> 

Now queued up, thanks.

greg k-h
