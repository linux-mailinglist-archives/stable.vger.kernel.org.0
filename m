Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAE64557F54
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbiFWQHw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232131AbiFWQHv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:07:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D766144A1C
        for <stable@vger.kernel.org>; Thu, 23 Jun 2022 09:07:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F5F161037
        for <stable@vger.kernel.org>; Thu, 23 Jun 2022 16:07:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3996DC341C4;
        Thu, 23 Jun 2022 16:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656000469;
        bh=uSAis0kB0m41/VuGinlZCOpAkmQSa0B4bk4gsHLKseA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wv15+HqxasSDHGdZZ378cv5xKkCdIFu5QnIPM88LoT4Y4MaqI70MDW++0K6lh7jXZ
         lBqdAw8JtDj58PpZzVa60Dg0J71YPtPxZ6fJDTY7zjhP/gitIAj7yBVH+/jJMoScIe
         m4YcUYhwm4TdffmY4vNcO3pc3FOmbewrVsquOoMo=
Date:   Thu, 23 Jun 2022 18:07:46 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: patch request for 5.18-stable to fix gcc-12 build (hopefully
 last)
Message-ID: <YrSP0kfIN+UjExkZ@kroah.com>
References: <YrGZxGoKgKxcvVTG@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrGZxGoKgKxcvVTG@debian>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 21, 2022 at 11:13:24AM +0100, Sudip Mukherjee wrote:
> Hi Greg,
> 
> The following will be needed for the gcc-12 builds:
> 
> ee3db469dd31 ("wifi: rtlwifi: remove always-true condition pointed out by GCC 12")
> 32329216ca1d ("eth: sun: cassini: remove dead code")
> dbbc7d04c549 ("net: wwan: iosm: remove pointless null check")
> 
> 
> With this 3 applied on top of v5.18.6-rc1 allmodconfig for x86_64, riscv
> and mips passes. (not checked other arch yet)
> 
> Will request you to add these to 5.18-stable queue please.

All now queued up, thanks.

greg k-h
