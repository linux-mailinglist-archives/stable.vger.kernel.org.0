Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CCE9693D1F
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 04:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbjBMDtG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Feb 2023 22:49:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjBMDtG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Feb 2023 22:49:06 -0500
X-Greylist: delayed 538 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 12 Feb 2023 19:49:03 PST
Received: from out-82.mta0.migadu.com (out-82.mta0.migadu.com [IPv6:2001:41d0:1004:224b::52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE614210A
        for <stable@vger.kernel.org>; Sun, 12 Feb 2023 19:49:03 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=winter.cafe; s=key1;
        t=1676259532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=x3m3BVlWph+iMrNcunQU9Xs3tEv4F3QPz6iEhnDahgY=;
        b=RLGBqvebXA0ktiCKczitFb8exn8opE+iUIHFqjDJR7miJYrLJUcgvmvhcWLuyVg70pOji+
        JaWoezT7f3Rg2PbCpTWEBbw/MhhfzjOGnaw0fs8OjEM4zu4ex47orZNvn+QYMtXimEZxum
        KNIlkARa0f5iVeOxBl0TBcO8EI9mfnhoGzPYDph8W9MzCxvsQp8wULp4DZBbYzb+uEHJ7x
        Wbqh0tQGRuzgFf7V3n1yu0nNoDMejqmqP9NmXV+s9dqjmM3IBERdY7fzpcbdGmHdEG1FSC
        IcB3k/DtmxbonbVTG54XP8JTveY1UHFs0Y4XEk8tbHN+Sdm5/eR3z4WesiZsdA==
From:   Winter <winter@winter.cafe>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: [REGRESSION] 5.15.88 and onwards no longer return EADDRINUSE from
 bind
Message-Id: <EF8A45D0-768A-4CD5-9A8A-0FA6E610ABF7@winter.cafe>
Date:   Sun, 12 Feb 2023 22:38:40 -0500
Cc:     regressions@lists.linux.dev
To:     stable@vger.kernel.org
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi all,

I'm facing the same issue as =
https://lore.kernel.org/stable/CAFsF8vL4CGFzWMb38_XviiEgxoKX0GYup=3DJiUFXU=
Omagdk9CRg@mail.gmail.com/, but on 5.15. I've bisected it across =
releases to 5.15.88, and can reproduce on 5.15.93.

However, I cannot seem to find the identified problematic commit in the =
5.15 branch, so I'm unsure if this is a different issue or not.

There's a few ways to reproduce this issue, but the one I've been using =
is running libuv's (https://github.com/libuv/libuv) tests, specifically =
tests 271 and 277.

#regzbot introduced v5.15.88..

Thanks,
Winter=
