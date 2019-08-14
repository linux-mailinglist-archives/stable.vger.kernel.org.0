Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B987E8C7FF
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 04:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729382AbfHNCZw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 22:25:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:53976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728775AbfHNCZw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 22:25:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A51120679;
        Wed, 14 Aug 2019 02:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565749550;
        bh=5rLlWUJ+nSWbLbJ/vJkace/NVU+oEELFK99umC/pAFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gbS6sF8tVhyYo52tmZ/A2hUN0o3fTnFQ8Qr8iSw6/7+pvi8Vq0gEnSGXwCYcoko3d
         uwBBwri9gaxZFTywsIkpeuXwn/j19miuM6h9P1JTnsadx4ONsP3Na4SUcV1kdIWgev
         eFeEw+M6u8k2yitYEC4K4OKPx+H7Ds7vDCZt3WWs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 33/33] selftests: kvm: Adding config fragments
Date:   Tue, 13 Aug 2019 22:23:23 -0400
Message-Id: <20190814022323.17111-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814022323.17111-1-sashal@kernel.org>
References: <20190814022323.17111-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naresh Kamboju <naresh.kamboju () linaro ! org>

[ Upstream commit c096397c78f766db972f923433031f2dec01cae0 ]

selftests kvm test cases need pre-required kernel configs for the test
to get pass.

Signed-off-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/config | 3 +++
 1 file changed, 3 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/config

diff --git a/tools/testing/selftests/kvm/config b/tools/testing/selftests/kvm/config
new file mode 100644
index 0000000000000..63ed533f73d6e
--- /dev/null
+++ b/tools/testing/selftests/kvm/config
@@ -0,0 +1,3 @@
+CONFIG_KVM=y
+CONFIG_KVM_INTEL=y
+CONFIG_KVM_AMD=y
-- 
2.20.1

