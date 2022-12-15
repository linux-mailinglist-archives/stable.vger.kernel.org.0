Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D39164D6B5
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 07:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbiLOGw5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 01:52:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiLOGwX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 01:52:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EDC85D683;
        Wed, 14 Dec 2022 22:52:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA6ED61C64;
        Thu, 15 Dec 2022 06:52:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1C8DC43398;
        Thu, 15 Dec 2022 06:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671087141;
        bh=/dozYddgWW0sjNJPUF3AKDsTE5SlGN4d7Yda3Q53F90=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t7RyWj3B53OLgRQ5ABYsWQROvdg7boAURX57CArH/9hdMvjFzvzt7YKRi+L+qEJR7
         WZGcecmA0Z/SnfJm8uZ+oFk28+lz97QBA1WjNVbKAzNTXvm77yVGoghwAbsJV9afhV
         WDrZld7X+egOjEw/e0QVo8aHfL39WuGrQnQD8nkI=
Date:   Thu, 15 Dec 2022 07:52:09 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Luis Henriques <lhenriques@suse.de>,
        "Darrick J . Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 0/2] cross-fs copy_file_range() fixes for stable
Message-ID: <Y5rEGedKn3TuueN4@kroah.com>
References: <20221213131341.951049-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221213131341.951049-1-amir73il@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 13, 2022 at 03:13:39PM +0200, Amir Goldstein wrote:
> Greg,
> 
> The recent history of copy_file_range() API is somewhat convoluted.
> The API changes are documented in copy_file_range(2) man page.
> I've just posted a man page update patch [1] to fix some wrong kernel
> version references in the man page.
> 
> The problem is that it took many kernel releases to get reports on the
> regression from v5.3 and yet more releases (v5.12..v5.19) to work on
> the solution and get it merged.
> 
> This situation leads to confusion among users as can be seen in [2].
> You've already picked the patch [1/2] to 5.15.y and I sent you a
> request to pick patch [2/2] (from v6.1) as well.
> 
> Following are backports of the two patches to 5.10.y, which I verified
> with the relevant test in fstests.

All now queued up, thanks.

greg k-h
