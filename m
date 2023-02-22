Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CED369F36E
	for <lists+stable@lfdr.de>; Wed, 22 Feb 2023 12:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbjBVL0d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Feb 2023 06:26:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231788AbjBVL0E (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Feb 2023 06:26:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9145738EB9;
        Wed, 22 Feb 2023 03:26:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4EED9B8125F;
        Wed, 22 Feb 2023 11:26:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 875CDC433D2;
        Wed, 22 Feb 2023 11:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677065160;
        bh=elTvLTyk3huhwGpMWXEk9oQkw9RrLqU3XN5UZW38SUk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ue2OH13uF2VSvuYm8UB8/Xr3E8VCtlZZmK6aErcZdePtfpJGDhhKWnW39M3XVHvWW
         k01LJbiXUDwBugPB+B+CCetZzKyakNA53PO8cvywVXQsxm00UM1u1MX0PleCvQkSfP
         Rm1zl+DIPnMhkazwpG8K9BSElPcqCZTxpUdTymJ4=
Date:   Wed, 22 Feb 2023 12:25:57 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     maennich@google.com
Cc:     linux-kernel@vger.kernel.org, kernel-team@android.com,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: Re: [PATCH 0/5] Allow CONFIG_DEBUG_INFO_DWARF5=y +
 CONFIG_DEBUG_INFO_BTF=y
Message-ID: <Y/X7xd8NKQe7KhPG@kroah.com>
References: <20220201205624.652313-1-nathan@kernel.org>
 <20230222112141.278066-1-maennich@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230222112141.278066-1-maennich@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 22, 2023 at 11:21:37AM +0000, maennich@google.com wrote:
> From: Matthias Maennich <maennich@google.com>
> 
> Can we please pick this series up for 5.15? I am particularly interested
> in the last patch to enable BTF + DWARF5, but the cleanup patches before
> are a very reasonable choice for stable@ as well as they simplify the
> pahole version calculation and allow future BTF/pahole related patches
> to apply cleanly as well. I intentionally kept the config
> PAHOLE_HAS_BTF_TAG and hence its patch complete, even though there is no
> user for it.

What are the upstream git commit ids for these changes?

thanks,

greg k-h
