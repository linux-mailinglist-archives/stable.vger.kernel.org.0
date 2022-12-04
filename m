Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C14506420A3
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 00:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbiLDXw4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Dec 2022 18:52:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbiLDXwz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Dec 2022 18:52:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E837FB1D5
        for <stable@vger.kernel.org>; Sun,  4 Dec 2022 15:52:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3D3560F22
        for <stable@vger.kernel.org>; Sun,  4 Dec 2022 23:52:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB51C433C1;
        Sun,  4 Dec 2022 23:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670197972;
        bh=x6vvt0putHsNxhikKHlu5GLanF/je2DpalLRHj+paBE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dMqGlIy1O3vzopZ8rgs9qLPtENIl7lZlWBUDcrDEmvhhXHJX1jeXYvMrbwEGUz9l+
         1FMHVySQLgfcyOJf+XCyjTgDeHCS/6kcgY9avVMUvf+kkjzJWR4uAtrSKgnsXi/inJ
         bMp0HZ7crt8P3nD2Yb7dlmdTHUBNd9vVySMdHWijo4bQ8reZFhfsQDxdPX3JGAqfSI
         iLf35a7c2uQ864IqDysEsLJ3wCo1uRWtxRVvbkbVzsUqf4S9SXdoiN0zUy4KnIGQgK
         cCHoPYJ/c8I7gxfBSeYsf0k7VIRHTJPOSwAX3HrpnT9oiD8EigG35yDlrPNOG/PNmK
         yA/bfZaJq8srg==
Date:   Sun, 4 Dec 2022 18:52:50 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     stable@vger.kernel.org, bp@alien8.de, dave.hansen@linux.intel.com
Subject: Re: Backported version of upstream commit 4dbd633e90e0
Message-ID: <Y40y0iMw+fZB26nL@sashalap>
References: <1670191628-83759-1-git-send-email-mikelley@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1670191628-83759-1-git-send-email-mikelley@microsoft.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 04, 2022 at 02:07:08PM -0800, Michael Kelley wrote:
>Here's a backported version of upstream commit ID
>4dbd6a3e90e03130973688fd79e19425f720d999 that will work with
>5.4, 4.19, 4.14, and 4.9.

I've queued it up, thanks Michael!

-- 
Thanks,
Sasha
