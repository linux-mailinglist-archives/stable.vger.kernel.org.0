Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93EB8615250
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 20:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbiKATcP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 15:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiKATcN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 15:32:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE9810FF6
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 12:32:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB85861723
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:32:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38477C433B5;
        Tue,  1 Nov 2022 19:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667331132;
        bh=5uKjKR6u14fjR/ihGAtv1q3uT1K85Gt/sLsqjd/YlGk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZxWQg17byFpd/s0yjiHw/KXJWuPg9BldNaIDFEM+YTm4XIqHfCMP3BPX1NHhRwz2N
         6X6E3vhsvvhq/siDajRS+vLIrdefKgVz3PLClv1BP9Nk7dBtTVvBp19xabRDk1g+j5
         tx0g21JhlnDYZ3VSUn5j4uAaGbCvAp7X0DGlM1pc=
Date:   Tue, 1 Nov 2022 20:33:06 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Meena Shanmugam <meenashanmugam@google.com>
Cc:     stable@vger.kernel.org, kuniyu@amazon.com
Subject: Re: [PATCH 5.15 0/1] Request to backport 3c52c6bb831f to 5.15.y
Message-ID: <Y2F0ct7Dk9Npxrta@kroah.com>
References: <20221101005202.50231-1-meenashanmugam@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221101005202.50231-1-meenashanmugam@google.com>
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 01, 2022 at 12:52:01AM +0000, Meena Shanmugam wrote:
> The commit 3c52c6bb831f (tcp/udp: Fix memory leak in
> ipv6_renew_options()) fixes a memory leak reported by syzbot. This seems
> to be a good candidate for the stable trees. This patch didn't apply cleanly
> in 5.15 kernel, since release_sock() calls are changed to
> sockopt_release_sock() in the latest kernel versions.
> 
> Kuniyuki Iwashima (1):
>   tcp/udp: Fix memory leak in ipv6_renew_options().
> 
>  net/ipv6/ipv6_sockglue.c | 7 +++++++
>  1 file changed, 7 insertions(+)

Can you provide a working version for 6.0.y first?  We can not have
people upgrading to newer kernels and having a regression.

thanks,

greg k-h
