Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0034CFCB6
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 12:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236025AbiCGL0R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 06:26:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242012AbiCGL0E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 06:26:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10ED45E153;
        Mon,  7 Mar 2022 02:58:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7373861261;
        Mon,  7 Mar 2022 10:58:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA32C340E9;
        Mon,  7 Mar 2022 10:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646650734;
        bh=5xyjKk8i5iRsuorQQjOqeV2wIQYYLgms+b4Hxo6LfKk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DRw36NOwr1DQBURyjpKJSGRxRQDIS2t8uE1I/cYZeSeAj/SyrQkUDriN6/PGYDDoL
         SaPWbAAeKpHabGZHKBp/fxD7AuTu4nptMdgY0AZZJiVk0CriI0SSaOed3g51sQm34q
         T6iWmw7dcGnv4xMjjCz4lnxqe1S3yUlQ8I8emo4z+y7cchCOn/uGT2ZKeJXsEghfeO
         xA4KOKUWncMRja1PsKEMNKH281fpnrwhWpMMVjgg+Eh89F3dxdpUsD5esvEliZNuPw
         jRfiykpQpWxMPQxGMI+rXDHP+AWzP9MWkJGuAKhofZeOMV5b6Jnrfk0kgJFnngeWKE
         0AZ+yb+g9Upnw==
Date:   Mon, 7 Mar 2022 05:58:50 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     stable-commits@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        stable@vger.kernel.org
Subject: Re: Patch "iommu/amd: Simplify pagetable freeing" has been added to
 the 5.15-stable tree
Message-ID: <YiXlamFo/eqTYDeX@sashalap>
References: <20220305210025.146536-1-sashal@kernel.org>
 <34442eae-a30d-5144-0fc5-edee35bee7b9@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <34442eae-a30d-5144-0fc5-edee35bee7b9@arm.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 07, 2022 at 10:35:19AM +0000, Robin Murphy wrote:
>On 2022-03-05 21:00, Sasha Levin wrote:
>>This is a note to let you know that I've just added the patch titled
>>
>>     iommu/amd: Simplify pagetable freeing
>>
>>to the 5.15-stable tree which can be found at:
>>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>>
>>The filename of the patch is:
>>      iommu-amd-simplify-pagetable-freeing.patch
>>and it can be found in the queue-5.15 subdirectory.
>>
>>If you, or anyone else, feels it should not be added to the stable tree,
>>please let <stable@vger.kernel.org> know about it.
>
>I don't think this one qualifies for stable - it was just a 
>refactoring to aid future development. The "fixing" of types is merely 
>cosmetic, and the code size benefit was just a little bonus, hardly 
>significant.

I took it and "iommu/amd: Use put_pages_list" to avoid the conflict when
taking 6b0b2d9a6a30 ("iommu/amd: Fix I/O page table memory leak").

Let me see if I can rework it to not need the 2 prereq patches...

-- 
Thanks,
Sasha
