Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 852D458C9A7
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 15:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242961AbiHHNmm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Aug 2022 09:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243450AbiHHNmk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Aug 2022 09:42:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB6ABF43;
        Mon,  8 Aug 2022 06:42:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 564E860A28;
        Mon,  8 Aug 2022 13:42:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68FF4C433D7;
        Mon,  8 Aug 2022 13:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659966158;
        bh=NSOd/IjeBeuf/cmn24O4QOHnUSiCroe2SILaXVd9FS0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U/4VVRGqeAjgO2RjQBpG8CpFNWhGVC8zXUZCApiWxfEQdDCoe4MCQfSUI8XOfc2rV
         MTrCy7dUBLZVR59cU6+heWdphyx/nk0YXi5Zt4peCim2WbcEV6GS+Wnfz1vtbLR+8y
         RnKhjdQT9iTirYCsiykjTkOqN2wmnY3RJQQ2wlrM=
Date:   Mon, 8 Aug 2022 15:42:36 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Naohiro Aota <naohiro.aota@wdc.com>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH STABLE 5.15 0/2] btrfs: backport zoned mode fixes
Message-ID: <YvESzLhwkLwLGH18@kroah.com>
References: <20220808043818.1183760-1-naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220808043818.1183760-1-naohiro.aota@wdc.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 08, 2022 at 01:38:16PM +0900, Naohiro Aota wrote:
> This series backport zoned mode related fixes to the 5.15 branch.
> 
> The patches are common among backport for 5.18.
> 
> https://lore.kernel.org/linux-btrfs/20220808020201.712924-1-naohiro.aota@wdc.com/T/
> 
> Naohiro Aota (2):
>   btrfs: zoned: prevent allocation from previous data relocation BG
>   btrfs: zoned: fix critical section of relocation inode writeback
> 
>  fs/btrfs/block-group.h |  1 +
>  fs/btrfs/extent-tree.c | 20 ++++++++++++++++++--
>  fs/btrfs/extent_io.c   |  3 ++-
>  fs/btrfs/inode.c       |  2 ++
>  fs/btrfs/zoned.c       | 27 +++++++++++++++++++++++++++
>  fs/btrfs/zoned.h       |  5 +++++
>  6 files changed, 55 insertions(+), 3 deletions(-)
> 
> -- 
> 2.35.1
> 

Now queued up, thanks.

greg k-h
