Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64FF56EBFBB
	for <lists+stable@lfdr.de>; Sun, 23 Apr 2023 15:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbjDWNWl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Apr 2023 09:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjDWNWk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Apr 2023 09:22:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 722D7E66;
        Sun, 23 Apr 2023 06:22:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B2E56113A;
        Sun, 23 Apr 2023 13:22:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D7C8C433D2;
        Sun, 23 Apr 2023 13:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682256158;
        bh=z++1MKbpH1EgfGdwIKX1tWmv/v3j0n0DjPyOfgtK1cM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lg+WBeyPzIF5Vp8q7EqejAtGgQlpHOb58T6a8rhUx0fZI+PnH99n8vhu6F1z5hkKr
         U/FKkp8xPWJfluyntOA5245dXHq1v7kfNumclkzMgKuhjMOig+bg3wuVez7lpai37t
         rHXxsIaBHaGcTbn9bkZcM3H1bPS5VVflBJwbkAMI=
Date:   Sun, 23 Apr 2023 15:22:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tudor Ambarus <tudor.ambarus@linaro.org>
Cc:     stable@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        joneslee@google.com
Subject: Re: [PATCH][for stable [4.14, 5.10] 0/3] ext4: fix use-after-free in
 ext4_xattr_set_entry
Message-ID: <2023042328-directed-quicken-e878@gregkh>
References: <20230419064610.1918038-1-tudor.ambarus@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419064610.1918038-1-tudor.ambarus@linaro.org>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 19, 2023 at 06:46:07AM +0000, Tudor Ambarus wrote:
> This is a good example that emphasizes that the order in which patches
> are queued to stable matters. More details in the revert commit.
> Tested and intended for 4.14, 4.19, 5.4, 5.10.
> 
> Baokun Li (1):
>   ext4: fix use-after-free in ext4_xattr_set_entry
> 
> Ritesh Harjani (1):
>   ext4: remove duplicate definition of ext4_xattr_ibody_inline_set()
> 
> Tudor Ambarus (1):
>   Revert "ext4: fix use-after-free in ext4_xattr_set_entry"
> 
>  fs/ext4/inline.c | 11 +++++------
>  fs/ext4/xattr.c  | 26 +-------------------------
>  fs/ext4/xattr.h  |  6 +++---
>  3 files changed, 9 insertions(+), 34 deletions(-)

All now queued up, thanks.

greg k-h
