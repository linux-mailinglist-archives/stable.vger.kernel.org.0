Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81BD9A8EB7
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388260AbfIDR7j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 13:59:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:38568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387617AbfIDR7j (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 13:59:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D1B422CEA;
        Wed,  4 Sep 2019 17:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567619978;
        bh=fp7pC5A6v8DesicfVH1brRId9ycSV71FJmTtEnSVlJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zirDyoIJu9bW7MizUdlA3ZG6lglSzRnzCPTSCqxEP1oEtq0dqiTRK4rMHsp9NtTt1
         9VQAkx0fVdWxkLvAIubVsSzChfb6B9QSgKNh0X1WsNlhpRDsv9BXcF/7upbpGPWczO
         fgohj4Jo9ZcRynk384Uh6mC93tXeIwUfPo0uIskk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naresh Kamboju <naresh.kamboju@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 27/83] selftests: kvm: Adding config fragments
Date:   Wed,  4 Sep 2019 19:53:19 +0200
Message-Id: <20190904175306.343765540@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175303.488266791@linuxfoundation.org>
References: <20190904175303.488266791@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



