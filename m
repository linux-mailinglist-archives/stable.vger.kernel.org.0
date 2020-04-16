Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1C11AC289
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896048AbgDPN3k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:29:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:39548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896041AbgDPN3i (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:29:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09E2F20767;
        Thu, 16 Apr 2020 13:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587043778;
        bh=V59zFjV6ZZmWmqaah7XOzcTvl8C+F7D/XEZk8w+uE1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rWvWjvg0AmVE2mNZE94RZSREArPC7+Iplmhc/zA3XYBT6jXjAfxrEtbMnMtaSDhxQ
         G/nfXrF4OfVWDrVIQ0W+OomUjIFNXqysD1L0ZVPWJOVYcFgjFD5P0LeA6/JJ8K8SWe
         NZR6Gs8S8xn5x5vpzOUd9Z3VPE4KC/KEG52OhBD0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Daniel Axtens <dja@axtens.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.19 096/146] powerpc/pseries: Drop pointless static qualifier in vpa_debugfs_init()
Date:   Thu, 16 Apr 2020 15:23:57 +0200
Message-Id: <20200416131255.906873948@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131242.353444678@linuxfoundation.org>
References: <20200416131242.353444678@linuxfoundation.org>
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
@@ -1056,7 +1056,7 @@ static int __init vpa_debugfs_init(void)
 {
 	char name[16];
 	long i;
-	static struct dentry *vpa_dir;
+	struct dentry *vpa_dir;
 
 	if (!firmware_has_feature(FW_FEATURE_SPLPAR))
 		return 0;


