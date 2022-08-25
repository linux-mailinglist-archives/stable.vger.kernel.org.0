Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 782915A0FFA
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 14:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237857AbiHYMKA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 08:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235306AbiHYMJ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 08:09:57 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B929F186D0;
        Thu, 25 Aug 2022 05:09:53 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 183745C0228;
        Thu, 25 Aug 2022 08:09:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Thu, 25 Aug 2022 08:09:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1661429391; x=1661515791; bh=XYfrVHTgcE
        hJXqJGPt42wHk+t1vdfSYUFsTqDFwgEtU=; b=k2r8Mi/yx3CG090lPIXZE8t6SJ
        J4osDk71BkSQ8wB569gtrEdpmkkQ2QqudJCbMczLLWVnS3hjRZ+WCZV80Liy6LF/
        CetRs4VvXS7I835Qb7GQEAsW3LqDey8ImcIQxZB+oRn7xQJsW1jvA72+531rNTRB
        fCRhZP1a3KyQ0Wp/tHhtU/IosC4oErKMYwSthRAw2hDKlN0euYMU8OPvZxT8QN+t
        uNUnw8nbPJxwlGzJ1brsdMBijXgH836ThD2F9q+AfHTqwGQY5e7S5NmHNZVJ/bVB
        dSjmDCXj6x1UaTv6OYmPDdksnPJEakXOSx6TDodVDmN5Lx3bA3Px5CdW/Kjg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1661429391; x=1661515791; bh=XYfrVHTgcEhJXqJGPt42wHk+t1vd
        fSYUFsTqDFwgEtU=; b=YJpryrxfGrCpXU0ukSFvYcT0QQn+0i6b36umJQCvqdRi
        YN80uonNZMsXE3GrMzHoiR4nHCadBp30EFHqgp1DSclszx1l6PiQTHuRwuPfpowD
        hPxXKZ8cV2UtT+X6QgOj1xd6enH7F/IrkhyCCnMDfjVliHutszFXeiFr2YZNd0Dx
        E63DMrYoDSSCEWwj3L3XaeTPTNCV93/terOERyDFwZtuj8CMVZW2Z8K3wqU/XWq9
        QBSy15Tjz1xbSaVzwicpfk9BFwYIHRxjdytaOcDVJbyChjYcfTvapQVpMvNqhTkH
        8F1RovzE2g/JtZsnlYKb12rtxoCKsPO2y+dPuIcIFw==
X-ME-Sender: <xms:jmYHYyrTWtWOqd3ZcBpFBvciQmftGmFVCy8E8Z8mo2yjXs00usVQwQ>
    <xme:jmYHYwrBEdCTcqIxSgHZ8A5stnuekKl9R5iFjqY9R_k-ZZhrr3vBmgg0HRFsufOE9
    DU85dKl5t2vPA>
X-ME-Received: <xmr:jmYHY3OFliPnMxzYX4ZVSkjECfSdYbsu8FBPZd7kP_Vv76o_cfIjHFbU9yGUlO2_AZ_bgO2BnuHv6q1sMhDS2wJ4BhkfxMqQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdejfedggeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepheegvd
    evvdeljeeugfdtudduhfekledtiefhveejkeejuefhtdeufefhgfehkeetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:jmYHYx6Q42cNqWSCCzvENSfzsxiWqid0dV8doYw0Z2QVRHJz0V5wVQ>
    <xmx:jmYHYx4VS8sDLJVq-B35IqokJkP0KSxSv5L97Cx_cRYiJYUt3zaeCw>
    <xmx:jmYHYxiOfwDQUEuunfiwqfKP8VDTtKcIWSCc1fi5afp_8MjM3dn__g>
    <xmx:j2YHY01qZ01IVhGvgfAt-Zf3LCkk3j2fcjk9rpOpnEZTvY4yXAC7ZA>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 25 Aug 2022 08:09:50 -0400 (EDT)
Date:   Thu, 25 Aug 2022 14:09:47 +0200
From:   Greg KH <greg@kroah.com>
To:     Naohiro Aota <naohiro.aota@wdc.com>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH STABLE 5.15 0/5] btrfs: zoned: backport max_extent_size
 fix
Message-ID: <Ywdmi+yvfn0PRt8P@kroah.com>
References: <20220822060704.1278361-1-naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220822060704.1278361-1-naohiro.aota@wdc.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 22, 2022 at 03:06:59PM +0900, Naohiro Aota wrote:
> These patches are backport for the 5.15 branch.
> 
> This series backports fixes for expecting the number of on-going write
> extents on zoned mode.
> 
> It picks up patches 1 to 3 for the dependencies of patches 4 and 5.
> 
> Christoph Hellwig (1):
>   block: add a bdev_max_zone_append_sectors helper
> 
> Naohiro Aota (4):
>   block: add bdev_max_segments() helper
>   btrfs: zoned: revive max_zone_append_bytes
>   btrfs: replace BTRFS_MAX_EXTENT_SIZE with fs_info->max_extent_size
>   btrfs: convert count_max_extents() to use fs_info->max_extent_size
> 
>  drivers/nvme/target/zns.c |  3 +--
>  fs/btrfs/ctree.h          | 29 +++++++++++++++++++++--------
>  fs/btrfs/delalloc-space.c |  6 +++---
>  fs/btrfs/disk-io.c        |  2 ++
>  fs/btrfs/extent_io.c      |  4 +++-
>  fs/btrfs/inode.c          | 22 ++++++++++++----------
>  fs/btrfs/zoned.c          | 20 ++++++++++++++++++++
>  fs/btrfs/zoned.h          |  1 +
>  fs/zonefs/super.c         |  3 +--
>  include/linux/blkdev.h    | 11 +++++++++++
>  10 files changed, 75 insertions(+), 26 deletions(-)
> 
> -- 
> 2.37.2
> 

All now queued up, thanks.

greg k-h
