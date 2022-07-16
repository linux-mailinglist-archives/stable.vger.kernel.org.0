Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0A01576BF2
	for <lists+stable@lfdr.de>; Sat, 16 Jul 2022 07:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbiGPFGN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Jul 2022 01:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiGPFGL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 16 Jul 2022 01:06:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 571D18AB2C
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 22:06:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8430B82E7F
        for <stable@vger.kernel.org>; Sat, 16 Jul 2022 05:06:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE21C34114;
        Sat, 16 Jul 2022 05:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657947967;
        bh=soAvcJqPbrBY3clc13rvqmw54Z8hhuEd1pm7XqWl2oE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eiadlUYs9ZhsrELKO0VkChXEhm1zlYRAFctPLZTEcHFDmHPEXPShi1OmaNRfPuoE/
         LALYhOkOvCQLwZrSGgGKPGy4D3jzCgqMCEnIaNWeRS8j33MvtHdkGb9xnbuChdrGL4
         B86iOh/EWSfq3TJSyh7glUmAg6MuK/L+ECitVrZA=
Date:   Sat, 16 Jul 2022 07:06:02 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Oleksandr Tymoshenko <ovt@google.com>
Cc:     sidhartha.kumar@oracle.com, stable@vger.kernel.org
Subject: Re: [PATCH 0/2] Fix vm kselftest build
Message-ID: <YtJHOtDQ4swTmxjf@kroah.com>
References: <20220715231542.2169650-1-ovt@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220715231542.2169650-1-ovt@google.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 15, 2022 at 11:15:40PM +0000, Oleksandr Tymoshenko wrote:
> This patchset reverts duplicates of two backported commits that created
> exact copies of functions added by the original backports.
> 
> Oleksandr Tymoshenko (2):
>   Revert "selftest/vm: verify remap destination address in mremap_test"
>   Revert "selftest/vm: verify mmap addr in mremap_test"
> 
>  tools/testing/selftests/vm/mremap_test.c | 53 ------------------------
>  1 file changed, 53 deletions(-)

For what stable tree(s) are you wanting these to be applied to?

thanks,

greg k-h
