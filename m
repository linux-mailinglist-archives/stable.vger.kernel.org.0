Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1C053CABC
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 15:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbiFCNhG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 09:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230221AbiFCNhF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 09:37:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D29A35FB7
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 06:36:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BC90616F8
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 13:36:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF18C385B8;
        Fri,  3 Jun 2022 13:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654263418;
        bh=SugCdCTW1Ig1FhhsV0ICo887swpl2+vElcBTbRm8l4k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ew40EtsHqsf/4++/mUG+pRDZUb1PH6EMv9I+s2OZTD4eH94JNjK+As/kUwLjN+PNp
         GY8IUeHgUPQEcNsw41GnlwXPLeRX1/6biNvEoPy/B22EuhBWtnzykuNKboE9fLI/te
         SCjALw2LnnE1NX67AYbbNOKmvlz96Xm0o2zVpPW8=
Date:   Fri, 3 Jun 2022 15:36:55 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     sashal@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 0/3] Backports for Kirkstone
Message-ID: <YpoOdwA3XH2un+93@kroah.com>
References: <20220530215325.921847-1-daniel.diaz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220530215325.921847-1-daniel.diaz@linaro.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 30, 2022 at 04:53:22PM -0500, Daniel Díaz wrote:
> We recently started building with Poky Kirkstone (quite a leap
> from our ancient and venerable branch of Sumo) which includes
> a newer set of tools in the toolchain:
> 
>   binutils   2.30 -> 2.38
>   gcc       7.3.3 -> 11.2.0
>   glibc      2.27 -> 2.35
> 
> This uncovered some issues while cross-compiling on the 4.x
> kernels. The following patches help in building the 4.19
> branch again.
> 
> These backports are already applied all the way down to 5.4.
> 
> Arnaldo Carvalho de Melo (2):
>   perf bench: Share some global variables to fix build with gcc 10
>   perf tests bp_account: Make global variable static
> 
> Ben Hutchings (1):
>   libtraceevent: Fix build with binutils 2.35
> 
>  tools/lib/traceevent/Makefile    |  2 +-
>  tools/perf/bench/bench.h         |  4 ++++
>  tools/perf/bench/futex-hash.c    | 12 ++++++------
>  tools/perf/bench/futex-lock-pi.c | 11 +++++------
>  tools/perf/tests/bp_account.c    |  2 +-
>  5 files changed, 17 insertions(+), 14 deletions(-)
> 
> -- 
> 2.32.0
> 

All now queued up, thanks.

greg k-h
