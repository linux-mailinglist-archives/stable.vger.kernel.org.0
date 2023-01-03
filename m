Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD8365BB58
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 08:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232929AbjACHow (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 02:44:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbjACHou (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 02:44:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6FC3C77D
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 23:44:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54CF4B80DE9
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 07:44:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A5D8C433D2;
        Tue,  3 Jan 2023 07:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672731887;
        bh=Bs0kUMWJTn7B/ed73ibp5hivdwNbnTqbqoyBYZLxSLs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2rpHKv+fJbFkbQr7k7rwrquUUp20b2SLjrG8iAXXunXwIMDSdzpddXVx9dtm5dICh
         6jM16NxyPFYdserzVWqe5LnUG3hvkCLSkyHj2rfHJkuou1LgIkwqMr9CH5E1z+I1+7
         jet4hE76wgFFqD8wpzsxtSXi4yJvNoOMdV+MbsjM=
Date:   Tue, 3 Jan 2023 08:44:44 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: 5.15-stable io_uring backport
Message-ID: <Y7Pc7KQoYlHMy67d@kroah.com>
References: <5ad43b3a-c1a9-b830-c58a-163864fd07bc@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ad43b3a-c1a9-b830-c58a-163864fd07bc@kernel.dk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 02, 2023 at 09:44:39AM -0700, Jens Axboe wrote:
> Hi Greg,
> 
> Here's the series we discussed before the break, no changes since then.
> Last 3 patches are new stable backports, the rest is backporting the
> 5.15.85 io_uring codebase to 5.10-stable. This is done to make 5.10
> maintainable wrt io_uring, and importantly, to bring back the native
> io workers to 5.10-stable.

Thanks for this!  I've queued them all up now and will push out a -rc
with just them for testing in a bit.

greg k-h
