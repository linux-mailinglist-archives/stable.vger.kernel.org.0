Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12A034C1ADA
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 19:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239572AbiBWSWY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 13:22:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241078AbiBWSWX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 13:22:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FB6D424AF;
        Wed, 23 Feb 2022 10:21:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48B83B8214E;
        Wed, 23 Feb 2022 18:21:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A68F0C340E7;
        Wed, 23 Feb 2022 18:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645640513;
        bh=A0e4/uVFZgUg/5cWPjPGRvf9MqHDJJYgKhKY4XthNIE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AtyDLKT5PKHX0UtvZSNy2LlZTv0URQrDdEjn8gFoM1/3oYaDsOMwTwdVXVYKomdRt
         a0iG6rU8uyyu886FQbkrlcN3S4OVGcroOxZU01m64oBjvuHUT0/vxjpkVWoDCQwT1s
         U9wFjmCMo95TOsA7cMTWVRV+pRX8hnoXQFMunL4w=
Date:   Wed, 23 Feb 2022 19:21:42 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Su Yue <l@damenly.su>
Cc:     stable@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH stable 5.10.y 0/2] backport two patches to avoid invalid
 memory access while mounting btrfs crafted image
Message-ID: <YhZ7NiRzBF4CSZ2i@kroah.com>
References: <20220222033117.1421286-1-l@damenly.su>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220222033117.1421286-1-l@damenly.su>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 22, 2022 at 11:31:15AM +0800, Su Yue wrote:
> Due to btrfs_item* helpers name changes in v5.17-rc1, here are two manual
> backport patches. Already verified by running fstests. 
> 
> Su Yue (2):
>   btrfs: tree-checker: check item_size for inode_item
>   btrfs: tree-checker: check item_size for dev_item
> 
>  fs/btrfs/tree-checker.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> -- 
> 2.34.1
> 

All now queued up, thanks.

greg k-h
