Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C73EE1B416B
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728659AbgDVKv7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:51:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:41022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728141AbgDVKKo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:10:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A4A920780;
        Wed, 22 Apr 2020 10:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550243;
        bh=y4RlWMVlN8oehwrTES2hNOCCguSeHdw5uT5nth+Xwdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rJVcS15d6uJSraH9e7NgGfg7i9678zPiFcAtl+xvWQF8z1SE4OpYHjlgtb2+7qRY6
         2E3e5VlwUJCSwftHndV3wrGCk7QgYjfKShMsV+Ks6cxxzQWHUelhnwNv5i7Qi0yiCY
         DbMy/llwlsUjrfTJrzCGdVkft/Rg6Yx4CV0kOqv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Daniel Axtens <dja@axtens.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.14 068/199] powerpc/pseries: Drop pointless static qualifier in vpa_debugfs_init()
Date:   Wed, 22 Apr 2020 11:56:34 +0200
Message-Id: <20200422095105.002965848@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095057.806111593@linuxfoundation.org>
References: <20200422095057.806111593@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

commit 11dd34f3eae5a468013bb161a1dcf1fecd2ca321 upstream.

There is no need to have the 'struct dentry *vpa_dir' variable static
since new value always be assigned before use it.

Fixes: c6c26fb55e8e ("powerpc/pseries: Export raw per-CPU VPA data via debugfs")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190218125644.87448-1-yuehaibing@huawei.com
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/pseries/lpar.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/platforms/pseries/lpar.c
+++ b/arch/powerpc/platforms/pseries/lpar.c
@@ -1060,7 +1060,7 @@ static int __init vpa_debugfs_init(void)
 {
 	char name[16];
 	long i;
-	static struct dentry *vpa_dir;
+	struct dentry *vpa_dir;
 
 	if (!firmware_has_feature(FW_FEATURE_SPLPAR))
 		return 0;


