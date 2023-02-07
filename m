Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08C4668D302
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 10:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjBGJkU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 04:40:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbjBGJkT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 04:40:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC6095FC1
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 01:40:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 838216128E
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 09:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78008C433EF;
        Tue,  7 Feb 2023 09:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675762817;
        bh=6/9Lj6y5xOYeQxMAtMK/R5NOKE91tchlanJE3TNhY0Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wbv0j0LJIRptJbPHFgf8AtEMVWNRFyQSD5BypsLDNQj9iRSnhZR0q+ZpSwXuPXI6p
         8qxhe4L8Kz0WNnFEO0H1sfCLzhhReRhtD4uWfKDWAgmgh2BsNQ0ncBEPnNZSWJjN5/
         /EsL6RBFQQUTXRYcxsvLpcJvsUcl38G7YGczLL0c=
Date:   Tue, 7 Feb 2023 10:40:10 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Shaoying Xu <shaoyi@amazon.com>
Cc:     dsahern@kernel.org, idosch@nvidia.com, kuba@kernel.org,
        patches@lists.linux.dev, sashal@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH stable 5.4 1/2] Revert "ipv4: Fix incorrect route
 flushing when source address is deleted"
Message-ID: <Y+IcelCxZufB92VE@kroah.com>
References: <20221212130920.482075438@linuxfoundation.org>
 <20230205053100.15903-1-shaoyi@amazon.com>
 <20230205053100.15903-2-shaoyi@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230205053100.15903-2-shaoyi@amazon.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 05, 2023 at 05:30:59AM +0000, Shaoying Xu wrote:
> This reverts commit 2537b637eac0bd546f63e1492a34edd30878e8d4.
> 
> Signed-off-by: Shaoying Xu <shaoyi@amazon.com>

We need a reason why this revert happens please.  Perhaps put the
information you have in the previous email in this thread in here?

thanks,

greg k-h
