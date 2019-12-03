Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0FC111D69
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730119AbfLCWxM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:53:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:46286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730116AbfLCWxL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:53:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C2BC21555;
        Tue,  3 Dec 2019 22:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413590;
        bh=89gxeJGzthezn63gW8QWdpmf0myFbNkTNKcj5J4kHOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=trsbNULwr9UN1LbWQWhpnVF/6jos2j/y+ELXL2NVW9ZimVdZFMfQTSJHqhoQWv0Z/
         PoLcoxyi4Bt2t9HI1jFHZM3pkPh8SbmzenTWYhWLTF0KGt+lv94JXDg74XdH/DoC+E
         +3N20vz0JwmKsz0bjemEacgxLuEIxVhN3M5hQK6w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 187/321] um: Include sys/uio.h to have writev()
Date:   Tue,  3 Dec 2019 23:34:13 +0100
Message-Id: <20191203223436.849266168@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Weinberger <richard@nod.at>

[ Upstream commit 0053102a869f1b909904b1b85ac282e2744deaab ]

sys/uio.h gives us writev(), otherwise the build might fail on
some systems.

Fixes: 49da7e64f33e ("High Performance UML Vector Network Driver")
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/vector_user.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/um/drivers/vector_user.c b/arch/um/drivers/vector_user.c
index 4d6a78e31089f..00c4c2735a5f7 100644
--- a/arch/um/drivers/vector_user.c
+++ b/arch/um/drivers/vector_user.c
@@ -30,6 +30,7 @@
 #include <stdlib.h>
 #include <os.h>
 #include <um_malloc.h>
+#include <sys/uio.h>
 #include "vector_user.h"
 
 #define ID_GRE 0
-- 
2.20.1



