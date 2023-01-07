Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80B55661199
	for <lists+stable@lfdr.de>; Sat,  7 Jan 2023 21:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232564AbjAGUa5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Jan 2023 15:30:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232521AbjAGUa4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Jan 2023 15:30:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D2534D77;
        Sat,  7 Jan 2023 12:30:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6261F60B8C;
        Sat,  7 Jan 2023 20:30:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A18CDC433D2;
        Sat,  7 Jan 2023 20:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673123453;
        bh=+TMstKL07xUTqVoajbbWQM6ZllvJrtB36POH82uCwM8=;
        h=Date:From:To:Cc:Subject:From;
        b=ZMpu0EjUyIunqxcZlJXQcS2tFD80bxcL7mMagAxdfVNlbTV6gk5OAlBujpAYgb1Bj
         S2Qn7lZTEpLXSa+pHb33Glh9Jn5aJeehip9HILwLFgwIUQeJwJ+qUrzZJkxuPUZeIl
         yFMENo7LPrbcVNmb/Vby+lm1kDpQ61mukYFIccedcnkgL/mnt6GKwg9bLS5+0A/H2N
         hdw92bKG26QbSGOnZb0Dlr2dpgD/2W+esP/NdTEJGxgDeeSVDfWWYuzRa2Jr9ZobuO
         UM524fmJzaAhTZwuH2U8kGSaxTDleaGWrWke6tkVo4HsmqIQAVPmq7dQyBE8jq3sYZ
         WT0TuWSidzlDQ==
Date:   Sat, 7 Jan 2023 12:30:51 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org
Subject: Please apply "ext4: don't allow journal inode to have encrypt flag"
 to 5.15 and earlier
Message-ID: <Y7nWexWBpMWKwdeB@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please apply commit 105c78e12468 ("ext4: don't allow journal inode to have
encrypt flag") to the 5.15, 5.10, 5.4, and 4.19 LTS kernels, where it applies
cleanly.

It didn't get applied automatically because for the Fixes tag, I used a commit
in 5.18.  However, that was the commit that exposed the problem, not the root
cause.  IMO it makes sense to apply this to earlier kernels too, especially
because some people have backported the 5.18 commit.

- Eric
