Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD2E26B6390
	for <lists+stable@lfdr.de>; Sun, 12 Mar 2023 07:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbjCLGvk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Mar 2023 01:51:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCLGvj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Mar 2023 01:51:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 458B04ECC9
        for <stable@vger.kernel.org>; Sat, 11 Mar 2023 22:51:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C11E860A3B
        for <stable@vger.kernel.org>; Sun, 12 Mar 2023 06:51:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D71C4339B;
        Sun, 12 Mar 2023 06:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678603897;
        bh=UN7ghrgVJiar6dXzVk2jIKJPvVvSMkZSe2gZ1zxdpyQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X/rt/wsdl/5vFcz6R4tuTIjQ4Wz1fG9beBc/nCa+l31j7c8q6PKBVZZt4n2kJe/Va
         UKPZC1+Tic/rSPjxX0Y/c8v5LgclNYHFCQroq/3cNE4/StJW0QyX3tKc96LFDoMN9j
         Y63OIHDp+14aFyV3djjGQ4q3UNqExfACIGJdgpmo=
Date:   Sun, 12 Mar 2023 07:51:34 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Bitterblue Smith <rtl8821cerfe2@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] wifi: rtl8xxxu: fixing transmisison failure for rtl8192eu
Message-ID: <ZA12dnmhzqnAR1Uf@kroah.com>
References: <33adb1b9-37c3-76ac-687f-97383f2101ec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33adb1b9-37c3-76ac-687f-97383f2101ec@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 12, 2023 at 12:12:12AM +0200, Bitterblue Smith wrote:
> From: Jun ASAKA <JunASAKA@zzy040330.moe>
> 
> [ Upstream commit c6015bf3ff1ffb3caa27eb913797438a0fc634a0 ]
> 
> Fixing transmission failure which results in
> "authentication with ... timed out". This can be
> fixed by disable the REG_TXPAUSE.
> 
> Signed-off-by: Jun ASAKA <JunASAKA@zzy040330.moe>
> Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
> ---
> Hi, this is my first time here. I'm not sure if I did everything
> correctly.
> 
> This patch should go to all the stable kernels. Without it the
> USB wifi adapters with RTL8192EU chip are unusable more often
> than not. They can't connect to any network.
> 
> There's a small problem: the last line of context in this patch
> is only found in 6.2. The older kernels have something else
> there. Will it still work or should I send one more version
> of the patch?

This commit is already in the following released kernels, have you tried
them?

4.14.308 4.19.276 5.4.235 5.10.173 5.15.99 6.1.16 6.2.3 6.3-rc1
