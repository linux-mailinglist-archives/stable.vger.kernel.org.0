Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEFFA5A9833
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 15:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233761AbiIANMI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 09:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233825AbiIANLZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 09:11:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BFF980EBA;
        Thu,  1 Sep 2022 06:06:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF5B461EF3;
        Thu,  1 Sep 2022 13:06:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08AC3C433C1;
        Thu,  1 Sep 2022 13:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662037611;
        bh=k4/b3x6e6SI+9q/vBPkMaUT6KMzbrIuxz/LSLsU5QlA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W9uBqDWQ0uYLzjPTow6VHbQvhcZTA4EN4n6BEXZ2T5GsDrTF/jm2M3y4AwNVpvsdf
         Z5jdYWnqqaqm+5XiS7S4ce6gbfoheq8oxd1hCwbEWR+cPoPghq5Ywq9MfhKqqlw8bh
         R62Lk2L4G/BavBdBJpHW+RgQ/YBAYBPVKrH2RIUE+FuF7fdrge+JNq2CQ7//5XPeq5
         +pWVq+MdLV/gcTz/yK0Ytt7f7u/KvrnGOEJFeqV4GdgoXKzxNQl3a9F8M8Pfj+w2hR
         psVky6z711ojrKzf5E0r9WFoeYeGNO434QPjP6BYffKYGBXm+aazj10XTLJ8w/r1aj
         /obzQKo7eeTUw==
From:   Will Deacon <will@kernel.org>
To:     Levi Yun <ppbuk5246@gmail.com>, catalin.marinas@arm.com,
        bhe@redhat.com
Cc:     kernel-team@android.com, Will Deacon <will@kernel.org>,
        nramas@linux.microsoft.com, stable@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kexec@lists.infradead.org,
        thunder.leizhen@huawei.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] arm64/kexec: Fix missing extra range for crashkres_low.
Date:   Thu,  1 Sep 2022 14:06:32 +0100
Message-Id: <166202940119.739039.2574146355073942653.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220831103913.12661-1-ppbuk5246@gmail.com>
References: <CAM7-yPRp7wpP1a=SrH4o2SBijF4ZfxkLTe7vpRXq_D_y1Kz-1g@mail.gmail.com> <20220831103913.12661-1-ppbuk5246@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 31 Aug 2022 19:39:13 +0900, Levi Yun wrote:
> Like crashk_res, Calling crash_exclude_mem_range function with
> crashk_low_res area would need extra crash_mem range too.
> 
> Add one more extra cmem slot in case of crashk_low_res is used.
> 
> 

Applied to arm64 (for-next/fixes), thanks!

[1/1] arm64/kexec: Fix missing extra range for crashkres_low.
      https://git.kernel.org/arm64/c/4831be702b95

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
