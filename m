Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A692A4AFB3B
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240411AbiBISnq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:43:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240406AbiBISnj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:43:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B10C03324A;
        Wed,  9 Feb 2022 10:42:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3193CB82380;
        Wed,  9 Feb 2022 18:42:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E29AFC340E7;
        Wed,  9 Feb 2022 18:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644432128;
        bh=LbpS3Y/VfwBZOHuEtHeMd4iAvaPoeairLJWLJwAYa1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DVlB2ZYuvLX3Wh/m//ngegNc3S2Tlp9z26JkvmcF6nE3tQf9oiNQxxnQAyxAWi64s
         aYEFtk6iak7D5Nc6VgQ5LMYuU5idz/S6wR2nFunUAy7QGHnUtWbbIOldq4uDh9gN48
         HK8kfGU2X8OUtdMgSmLXz8GKlpr0ZqufG1BygZk0UUxiawQzX+HuvfAgG8LfYX+Sa1
         zGLmQi2irdR6r4yPscQx/s8hfnm0vEQJAdPhtne2pD5M/leM0J+V4W0WD9Bv3OICQg
         /SwBW6BIr3YR7h3jbV2Hnn7mk5QItZIvR+dH5a0JTvLRRSO6CLyTffplNIIsHFYJjV
         6edN4zGtN3TFA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cristian Marussi <cristian.marussi@arm.com>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 10/27] selftests: openat2: Add missing dependency in Makefile
Date:   Wed,  9 Feb 2022 13:40:46 -0500
Message-Id: <20220209184103.47635-10-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209184103.47635-1-sashal@kernel.org>
References: <20220209184103.47635-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit ea3396725aa143dd42fe388cb67e44c90d2fb719 ]

Add a dependency on header helpers.h to the main target; while at that add
to helpers.h also a missing include for bool types.

Cc: Aleksa Sarai <cyphar@cyphar.com>
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/openat2/Makefile  | 2 +-
 tools/testing/selftests/openat2/helpers.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/openat2/Makefile b/tools/testing/selftests/openat2/Makefile
index 4b93b1417b862..843ba56d8e49e 100644
--- a/tools/testing/selftests/openat2/Makefile
+++ b/tools/testing/selftests/openat2/Makefile
@@ -5,4 +5,4 @@ TEST_GEN_PROGS := openat2_test resolve_test rename_attack_test
 
 include ../lib.mk
 
-$(TEST_GEN_PROGS): helpers.c
+$(TEST_GEN_PROGS): helpers.c helpers.h
diff --git a/tools/testing/selftests/openat2/helpers.h b/tools/testing/selftests/openat2/helpers.h
index ad5d0ba5b6ce9..7056340b9339e 100644
--- a/tools/testing/selftests/openat2/helpers.h
+++ b/tools/testing/selftests/openat2/helpers.h
@@ -9,6 +9,7 @@
 
 #define _GNU_SOURCE
 #include <stdint.h>
+#include <stdbool.h>
 #include <errno.h>
 #include <linux/types.h>
 #include "../kselftest.h"
-- 
2.34.1

