Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4666D575AEC
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 07:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbiGOFYL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 01:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiGOFYK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 01:24:10 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB07118E0F
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 22:24:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EA626CE2D7A
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 05:24:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91240C34115;
        Fri, 15 Jul 2022 05:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657862645;
        bh=Tep2qIXZTy8FmzGNFjllYFr6w2iblZ3cQrl4I6UklIU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IcvEYZ24X/xzeh7ZDyY8bnBa3L6trplQOLE8OodhA2eOD9Q9Blri8KYwXgSpiSTqp
         iI+tMsyenUgA2hh3oE18ehRBXrfaYgqJSqJA2XCEX97EPP2XBjEebQacKkxajYeyFn
         8dPiNKC5e28dXsfytD26tSLmsXlQHdvGdoOqdDcI=
Date:   Fri, 15 Jul 2022 07:24:02 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Oleksandr Tymoshenko <ovt@google.com>
Cc:     sidhartha.kumar@oracle.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 101/135] selftest/vm: verify remap destination
 address in mremap_test
Message-ID: <YtD58ibVVPtJTIyF@kroah.com>
References: <20220510130743.305503241@linuxfoundation.org>
 <20220714224351.1469186-1-ovt@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220714224351.1469186-1-ovt@google.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 14, 2022 at 10:43:51PM +0000, Oleksandr Tymoshenko wrote:
> Hello,
> 
> This commit is the second backport of the upstream commit 18d609da
> ("selftest/vm: verify remap destination address in mremap_test"). It
> re-introduces function is_remap_region_valid and breaks vm selftest
> target build with the following diagnostics:
> 
>   mremap_test.c:126:13: error: redefinition of ‘is_remap_region_valid’
> 
> The original backport to 5.15 was done as commit 2688d967. This one
> (0b4e1609) should be reverted.
> 
> The same happend with the upstream commit 9c85a9ba ("selftest/vm:
> verify mmap addr in mremap_test"). Original backport: a17404fc,
> repeated backport with just the new function added: e8b99895.
> Build error message:
> 
>   mremap_test.c:147:27: error: redefinition of ‘get_mmap_min_addr’

This is already released, so can you send a revert for this?

thanks,

greg k-h
