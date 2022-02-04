Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2F9C4A9808
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 11:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231818AbiBDKxU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 05:53:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbiBDKxU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 05:53:20 -0500
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9AC5C061714;
        Fri,  4 Feb 2022 02:53:19 -0800 (PST)
Received: by nautica.notk.org (Postfix, from userid 108)
        id B8A4FC01A; Fri,  4 Feb 2022 11:53:16 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1643971996; bh=GHWhopYqLTCZQXXV/5Ol3vo+4X8al9AySDc6QwaVjF4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H0OsMjZSeYrNBoWbN88t0j60kAHyT33lGlqyeq6uUocBHpKTPRXdfS+BMjfP7oMis
         iDoTJdjxMYQZv8St1/kgfHcgLsrVpJP7K3kQuRIlfl5V4QkMVCSOEXP6Qjn8QesuSI
         VAlToeGXOVyu9ocVBgsoIPow1Q9OFlfJFVw0HFPzWfkoh7BNWMtQrMz0F8No1zMCyF
         4B/3VgNP+4Fs9thLYS8gqnzLubLhF0/7KEzM9EzmLpR352oyzi51lXCwWA5RIz9iR6
         0fQKTE/lesaNYRyH2oPx1A4YrMhWK2cTW9NCsuhk+GGMTN2SMCnRFM1TnOPciScpXZ
         JfxOaS5u7Qpqg==
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on nautica.notk.org
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=unavailable version=3.3.2
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id DD53FC009;
        Fri,  4 Feb 2022 11:53:14 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1643971996; bh=GHWhopYqLTCZQXXV/5Ol3vo+4X8al9AySDc6QwaVjF4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H0OsMjZSeYrNBoWbN88t0j60kAHyT33lGlqyeq6uUocBHpKTPRXdfS+BMjfP7oMis
         iDoTJdjxMYQZv8St1/kgfHcgLsrVpJP7K3kQuRIlfl5V4QkMVCSOEXP6Qjn8QesuSI
         VAlToeGXOVyu9ocVBgsoIPow1Q9OFlfJFVw0HFPzWfkoh7BNWMtQrMz0F8No1zMCyF
         4B/3VgNP+4Fs9thLYS8gqnzLubLhF0/7KEzM9EzmLpR352oyzi51lXCwWA5RIz9iR6
         0fQKTE/lesaNYRyH2oPx1A4YrMhWK2cTW9NCsuhk+GGMTN2SMCnRFM1TnOPciScpXZ
         JfxOaS5u7Qpqg==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 0db4f520;
        Fri, 4 Feb 2022 10:53:10 +0000 (UTC)
Date:   Fri, 4 Feb 2022 19:52:55 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: [GIT PULL] 9p for 5.17-rc3
Message-ID: <Yf0Fh7xIgJuoxuSB@codewreck.org>
References: <20220130130651.712293-1-asmadeus@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220130130651.712293-1-asmadeus@codewreck.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Linus,

I rarely send fixes out small things before rc1, for single patches do
you have a preference between a pull request or just resending the patch
again with you added to recipients after reviews?



The following changes since commit e783362eb54cd99b2cac8b3a9aeac942e6f6ac07:

  Linux 5.17-rc1 (2022-01-23 10:12:53 +0200)

are available in the Git repository at:

  git://github.com/martinetd/linux tags/9p-for-5.17-rc3

for you to fetch changes up to 22e424feb6658c5d6789e45121830357809c59cb:

  Revert "fs/9p: search open fids first" (2022-01-30 22:13:37 +0900)

----------------------------------------------------------------
9p-for-5.17-rc3: fix cannot walk open fid rule

the 9p 'walk' operation requires fid arguments to not originate from
an open or create call and we've missed that for a while as the
servers regularly running tests with don't enforce the check and
no active reviewer knew about the rule.

Both reporters confirmed reverting this patch fixes things for them
and looking at it further wasn't actually required...
Will take more time for follow up and enforcing the rule more
thoroughly later.

----------------------------------------------------------------
Dominique Martinet (1):
      Revert "fs/9p: search open fids first"

 fs/9p/fid.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

-- 
Dominique
