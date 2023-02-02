Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECB8F688533
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 18:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232040AbjBBRRF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 12:17:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231977AbjBBRQ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 12:16:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6B946FD31;
        Thu,  2 Feb 2023 09:16:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97D53B8275D;
        Thu,  2 Feb 2023 17:16:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15B8CC433EF;
        Thu,  2 Feb 2023 17:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675358214;
        bh=2QIKzSTkeTLb3Ws9Xh3yl46wURTVrxCvDvgQo81IKTA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MWeg0AqtrLH7TJAuW6VKPK1slPK5BiniE8SO0w+Kfg0tli4IFnai/fiLCwX1C42Wt
         UNs1No+u72j3HltNfP/xFvP3FZQJ68cmEVdRCFYXyRDQNFiYDHPPEKiogsk+aDdv0v
         2y4KNh51RfyZL7xPM8mRF5q8gmRfUikiGrvENI8YDVQ1Ab6fiTAy0dwAa/1Lp/R2fR
         721uw0USFpGO4bPFxRggfV5slOboQxCxB0u0ZbvWGhp0NHX3tePoyOEWEGpbtOBlhf
         rZTomc2zNeQwqTlBFdmtZXD7sduYGx/QdIgcjxra35nl2La6fbhtEaxr5x4SEzlv8I
         EhOJVLLPT+/pQ==
Date:   Thu, 2 Feb 2023 12:16:52 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     stable@vger.kernel.org,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        SeongJae Park <sj@kernel.org>,
        Seth Jenkins <sethjenkins@google.com>,
        Jann Horn <jannh@google.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5.4 00/17] Backport oops_limit to 5.4
Message-ID: <Y9vwBL2+NWtwMnA4@sashalap>
References: <20230202044255.128815-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230202044255.128815-1-ebiggers@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 01, 2023 at 08:42:38PM -0800, Eric Biggers wrote:
>This series backports the patchset
>"exit: Put an upper limit on how often we can oops"
>(https://lore.kernel.org/linux-mm/20221117233838.give.484-kees@kernel.org/T/#u)
>to 5.4, as recommended at
>https://googleprojectzero.blogspot.com/2023/01/exploiting-null-dereferences-in-linux.html
>This follows the backports to 5.10 and 5.15 which already released.
>
>This required backporting various prerequisite patches.
>
>I've tested that oops_limit and warn_limit work correctly on x86_64.

Queued up all 3 backports, thanks!

-- 
Thanks,
Sasha
