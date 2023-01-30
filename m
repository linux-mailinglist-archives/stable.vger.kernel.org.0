Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2534B6810FF
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237147AbjA3OJW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:09:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbjA3OJT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:09:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C3FF3B0E6
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:09:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75FB361025
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:09:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8956CC433EF;
        Mon, 30 Jan 2023 14:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087757;
        bh=DT/aYjU51HX+3mWs6zbdZSQ3hu7Wex2ZUvbW5F7iVlU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=elJ0+hokFPXwfV1CWPzYnjg0swrPY0SUT22SpKoaAjZEs/237ngKp+xddfM3a1D7r
         er5Ckl+8942W8H76gTSzMoCiMe5FoaW8I7bv5sPT9QVQOTKd+4lKvBkIVfE9ONZnZZ
         AI9sjky4wB7fD8jOtx6z6P48yu0/ytrBf4XEmEFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Joe Perches <joe@perches.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 300/313] treewide: fix up files incorrectly marked executable
Date:   Mon, 30 Jan 2023 14:52:15 +0100
Message-Id: <20230130134350.708772456@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 262b42e02d1e0b5ad1b33e9b9842e178c16231de ]

I'm not exactly clear on what strange workflow causes people to do it,
but clearly occasionally some files end up being committed as executable
even though they clearly aren't.

This is a reprise of commit 90fda63fa115 ("treewide: fix up files
incorrectly marked executable"), just with a different set of files (but
with the same trivial shell scripting).

So apparently we need to re-do this every five years or so, and Joe
needs to just keep reminding me to do so ;)

Reported-by: Joe Perches <joe@perches.com>
Fixes: 523375c943e5 ("drm/vmwgfx: Port vmwgfx to arm64")
Fixes: 5c439937775d ("ASoC: codecs: add support for ES8326")
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_msg_arm64.h | 0
 sound/soc/codecs/es8326.c                 | 0
 sound/soc/codecs/es8326.h                 | 0
 3 files changed, 0 insertions(+), 0 deletions(-)
 mode change 100755 => 100644 drivers/gpu/drm/vmwgfx/vmwgfx_msg_arm64.h
 mode change 100755 => 100644 sound/soc/codecs/es8326.c
 mode change 100755 => 100644 sound/soc/codecs/es8326.h

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_msg_arm64.h b/drivers/gpu/drm/vmwgfx/vmwgfx_msg_arm64.h
old mode 100755
new mode 100644
diff --git a/sound/soc/codecs/es8326.c b/sound/soc/codecs/es8326.c
old mode 100755
new mode 100644
diff --git a/sound/soc/codecs/es8326.h b/sound/soc/codecs/es8326.h
old mode 100755
new mode 100644
-- 
2.39.0



