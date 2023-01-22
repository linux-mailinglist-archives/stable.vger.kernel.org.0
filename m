Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC518676B08
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 05:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbjAVE2u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Jan 2023 23:28:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjAVE2u (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Jan 2023 23:28:50 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 583C221941
        for <stable@vger.kernel.org>; Sat, 21 Jan 2023 20:28:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A4DE2CE0C59
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 04:28:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A60B3C4339B;
        Sun, 22 Jan 2023 04:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674361725;
        bh=mJgPU0qxG9rIeNtVWxz/LWm6C2BLtXXN3Xy6UWzLlwQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p2D42OydHfpbqA617gRwu1RuBBDrUHeY+jLBZyfpvvJG/qmrpc/Cuygxm4CL5cOzP
         e8n+f+dDDDkiKz2DhY9Ccaxc0hK3Iu0+cP9y+g1hZWOt305Kdo1wdNGA5B9llyvBjL
         SbdUMY+RgEB7CjV0Uv4yqXzevMdXOIBC3l0X7T4U7sGMT30ZaZIGp6EbBd85451MVZ
         uGRVAoZCbR+03rHylv0zfIyCXLRZiDZoasWU4Yli2W/hHY0ncxtOIfYyTzQHcky7fc
         +Je8dKzniwQOB4tjjAl6KQHewO3zdeznxYys2LjgHIdCYhxb7lY5jf4yO387Z8zTZj
         O9l3jk8nq3jug==
Date:   Sat, 21 Jan 2023 23:28:44 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: Patches for 5.15-stable
Message-ID: <Y8y7fMAmJtB1559f@sashalap>
References: <be4f98fe-2e66-f7df-5f59-acc2ed7cccdb@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <be4f98fe-2e66-f7df-5f59-acc2ed7cccdb@kernel.dk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 21, 2023 at 10:52:10AM -0700, Jens Axboe wrote:
>Hi,
>
>Two parts here:
>
>1) The wakeup fix that went into 5.10-stable, but hadn't been done for
>   5.15-stable yet. It was the last 3 patches in the 5.10-stable backport
>   for io_uring
>
>2) Other patches that were marked for stable or should go to stable, but
>   initially failed.
>
>This gets us to basically parity on the regression test front for 5.15,
>and have all been runtime tested.
>
>Please queue up for the next 5.15-stable, thanks!

I've queued up this and the other backports you've sent today, thanks!


-- 
Thanks,
Sasha
