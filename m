Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FAEF6D453C
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 15:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbjDCNFz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 09:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231553AbjDCNFy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 09:05:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDDECDA
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 06:05:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78A0B61AA9
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 13:05:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90DE9C433D2;
        Mon,  3 Apr 2023 13:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680527152;
        bh=m7tPY6WtRqa646uDMPG+nXo+UxKMeCHqRbr0Dxcx+0k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oPZKt0bTwwHb4VfVTWCpTdSzwEgYwh0s5U/HjyxG6/rZphMc6K+LpaCa2F7F6cBx6
         h0NQSOk8S3QuVBT7uTu1P9dKXh6inN0nHyveNXsz0mav0rdQxfXCFP4OFGfy0XD4Gi
         5p0RBJXNePuiKT7Nut7naoE8eJ31lPsqnE8PIybY=
Date:   Mon, 3 Apr 2023 15:05:50 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux-stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org, Sasha Levin <sashal@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Reiji Watanabe <reijiw@google.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: Re: stable-rc / queue : 5.15: arm64 build failed
Message-ID: <2023040343-sift-phonebook-dead@gregkh>
References: <CA+G9fYsF4D7o1iNW6fMNMdX9fKqqrvJw5GHcbW5yGr9PLSWcrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYsF4D7o1iNW6fMNMdX9fKqqrvJw5GHcbW5yGr9PLSWcrw@mail.gmail.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 03, 2023 at 03:47:11PM +0530, Naresh Kamboju wrote:
> Following build warning noticed on arm64,
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> suspecting commit:
> KVM: arm64: PMU: Fix GET_ONE_REG for vPMC regs to return the current value
> commit 9228b26194d1cc00449f12f306f53ef2e234a55b upstream.

Now dropped, thanks!

greg k-h
