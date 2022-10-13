Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93C865FD452
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 07:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbiJMFxY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 01:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiJMFxX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 01:53:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0800A11BDB7;
        Wed, 12 Oct 2022 22:53:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B204CB81C23;
        Thu, 13 Oct 2022 05:53:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01B77C433C1;
        Thu, 13 Oct 2022 05:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665640400;
        bh=JKvK5qnnvdNaD/71/4ZTyGVJa4Z/FNAIMsw5Vst0oEc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=x73m9d/b3X1I3tvjbdZ3FC+RetY04Xr8xtJZLvgRR2eYTtz34esB0hNZT0z8gV44f
         Nbx9Dm0mqiq2FwjjxuAAn8fJcQNO6oLZfjVwbLJq0itP2SVe6j3FHxaklbpWqFGrvd
         fzy4IleE6z+ZCs8+OKkHyBc6SfZXonFKh+ODOOyQ=
Date:   Thu, 13 Oct 2022 07:54:04 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Nathan Huckleberry <nhuck@google.com>, llvm@lists.linux.dev,
        Dan Carpenter <error27@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>, ndesaulniers@google.com,
        ztong0001@gmail.com, dave@stgolabs.net,
        linux-staging@lists.linux.dev
Subject: Re: [PATCH AUTOSEL 4.14 11/13] staging: rtl8192u: Fix return type of
 ieee80211_xmit
Message-ID: <Y0en/E9XgB8Wyirr@kroah.com>
References: <20221013002716.1895839-1-sashal@kernel.org>
 <20221013002716.1895839-11-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221013002716.1895839-11-sashal@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 12, 2022 at 08:27:10PM -0400, Sasha Levin wrote:
> From: Nathan Huckleberry <nhuck@google.com>
> 
> [ Upstream commit 2851349ac351010a2649e0ff86a1e3d68fe5d683 ]
> 
> The ndo_start_xmit field in net_device_ops is expected to be of type
> netdev_tx_t (*ndo_start_xmit)(struct sk_buff *skb, struct net_device *dev).
> 
> The mismatched return type breaks forward edge kCFI since the underlying
> function definition does not match the function hook definition.

Again, not needed in any stable branches, thanks.

greg k-h
