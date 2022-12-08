Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3DDC647117
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 14:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbiLHNzA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 08:55:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiLHNy7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 08:54:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FCB036C4E
        for <stable@vger.kernel.org>; Thu,  8 Dec 2022 05:54:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15ADEB822EF
        for <stable@vger.kernel.org>; Thu,  8 Dec 2022 13:54:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C149C433C1;
        Thu,  8 Dec 2022 13:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670507695;
        bh=+fSn1dJvs3nLrMAhENIK82Jd/Au6mWGoi86E+L4/+Xo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mPl5v5Mh1ARkeZS9KRpv7MJ89B/EZXyjW20ZYk7++30L+I19k7rDI4Q4/MiVyg3sH
         xhcVCtiw5Ab5dCgi5wueAChnVDTAeYbqm7ys3pIbU4Km1vMG1tjw30Zqq8JDovD14G
         xpS2RBrFzlBM5cHuvToLjlOUbWkkEebbKfrG1sA7C4pLpsIaqByVaxl4RECctLYqG6
         3LhObvmWZIBLw5mrKLkoY/u4RpSctZPA5cKKyd1wsODxX//UEQDMtMD3/jRj5XFN0R
         s2BfnN70YZ6GWtgjzq5COpAVTfbXmpfDE9YgFE4yHuzFAOGwoiBFF+XZe/cQHReL/P
         WKp2AwwTJF+KQ==
Date:   Thu, 8 Dec 2022 08:54:53 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Jann Horn <jannh@google.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH stable 4.9,4.14 1/2] mm/khugepaged: fix GUP-fast
 interaction by sending IPI
Message-ID: <Y5HsrWiScgO2TF4S@sashalap>
References: <20221206171614.1183048-1-jannh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221206171614.1183048-1-jannh@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 06, 2022 at 06:16:02PM +0100, Jann Horn wrote:
>commit 2ba99c5e08812494bc57f319fb562f527d9bacd8 upstream.

I've queued all of these, thanks!

-- 
Thanks,
Sasha
