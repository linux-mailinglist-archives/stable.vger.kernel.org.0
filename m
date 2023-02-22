Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F95B69F410
	for <lists+stable@lfdr.de>; Wed, 22 Feb 2023 13:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbjBVMM0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Feb 2023 07:12:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjBVMM0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Feb 2023 07:12:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E42057D98
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 04:12:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9AA03B811EA
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 12:12:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98596C433EF;
        Wed, 22 Feb 2023 12:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677067942;
        bh=4ZXoInGqbmWFaXaqOYGdgEGRNHW+gcLVf2g/UzODDEw=;
        h=From:To:Cc:Subject:Date:From;
        b=cpSiBxt87ubouDSftHWb8vUR6tddyNbFqlrGkya5AQrb353CpgJd8LIs6poxuvSXg
         Z0loycBtfiQDctWAABb+Qo7uqV1SWG6lCVuunBelONNrZtS6OeSwHh2lG8FyJ9JtDw
         AJl/N+jUC2ApRL8EWApPxYD53gHqGjJRe4QOWxx1ccNOnLQ73jCyJwjOLmW/PDOQrw
         mDXtTbDROrFNzj5JRujVvlbECAHkDrb/MPe/j6KhL2d4vWB6tg5401TcceqdoLjGfv
         MOCXGNo1k0vp0xvdH8isWt2vXEJw2SxizsUvUfwGILY0W2xBqxhMHYd2rTT+ZUss4v
         th1TdMGNUg/ug==
From:   Lee Jones <lee@kernel.org>
To:     lee@kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH 0/5] binder: Apply 4 missing stable fixes into v5.15.y
Date:   Wed, 22 Feb 2023 12:12:03 +0000
Message-Id: <20230222121208.898198-1-lee@kernel.org>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

These patches are present in all other Stable versions.

Alessandro Astone (2):
  binder: Address corner cases in deferred copy and fixup
  binder: Gracefully handle BINDER_TYPE_FDA objects with num_fds=0

Arnd Bergmann (1):
  binder: fix pointer cast warning

Todd Kjos (2):
  binder: read pre-translated fds from sender buffer
  binder: defer copies of pre-patched txn data

 drivers/android/binder.c | 343 +++++++++++++++++++++++++++++++++++----
 1 file changed, 313 insertions(+), 30 deletions(-)

-- 
2.39.2.637.g21b0678d19-goog

