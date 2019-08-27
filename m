Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CAB29DF4E
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 09:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728697AbfH0HxD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 03:53:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:44506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729665AbfH0HxA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:53:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4EB22173E;
        Tue, 27 Aug 2019 07:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892380;
        bh=fp7pC5A6v8DesicfVH1brRId9ycSV71FJmTtEnSVlJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2GFEm7U42ypy5dnBVXRBEuoHFr9PpSNmz7zXFIqI87Vr+bfGlC2aWgO0FgBmBF1+G
         J8cOVn+vSaU9H6OvzooUBAgC1QgF1/D+fZ+qIO+oYFGbctAR/bKApEyyeumBICuTQC
         xE6epzbIuIAk4FW2PYdEFR3bRhA9kXE4ngt5sUQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naresh Kamboju <naresh.kamboju@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 35/62] selftests: kvm: Adding config fragments
Date:   Tue, 27 Aug 2019 09:50:40 +0200
Message-Id: <20190827072702.740044582@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072659.803647352@linuxfoundation.org>
References: <20190827072659.803647352@linuxfoundation.org>
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



