Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4E686156FE
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 02:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbiKBB1K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 21:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbiKBB1G (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 21:27:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 554381F9EC;
        Tue,  1 Nov 2022 18:27:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5A53B82054;
        Wed,  2 Nov 2022 01:27:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D102C433D6;
        Wed,  2 Nov 2022 01:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667352420;
        bh=k4P0hoQfhSxNC7Iu4COmXWBjx1cpoaAFcD65LMcpkR8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T2M2TndJir1D5natjoAn4VcJHKb3P9ZFYPWMeYUb5+Ccl4H74Pkb0dalFlAjak90/
         oDZeguPtOpVNFbszteq6vkIgWIOUAbkLMo2yCepk+PCDc+QnURYzfkVrZn7LWne/BS
         Bkxr+C50csTwGqESMLb9FD/IKD0uOt2998m0aFJc=
Date:   Wed, 2 Nov 2022 02:27:52 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     stable@vger.kernel.org, sashal@kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        james.morse@arm.com, anshuman.khandual@arm.com,
        catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
        suzuki.poulose@arm.com, ardb@kernel.org, mark.rutland@arm.com,
        wanghaibin.wang@huawei.com, anders.roxell@linaro.org
Subject: Re: [PATCH 5.10 0/2] arm64: backport two patches to 5.10-stable
Message-ID: <Y2HHmEUEHShi4PMX@kroah.com>
References: <20221031112246.1588-1-yuzenghui@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221031112246.1588-1-yuzenghui@huawei.com>
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 31, 2022 at 07:22:44PM +0800, Zenghui Yu wrote:
> Patch #1 (merged in 5.12-rc3) is required to address the issue
> Anders Roxell reported on the list [1].  Patch #2 (in 5.15-rc1) is
> a follow up.
> 
> [1] https://lore.kernel.org/lkml/20220826120020.GB520@mutt
> 
> Anshuman Khandual (1):
>   arm64/kexec: Test page size support with new TGRAN range values
> 
> James Morse (1):
>   arm64/mm: Fix __enable_mmu() for new TGRAN range values

Both now queued up, thanks.

greg k-h
