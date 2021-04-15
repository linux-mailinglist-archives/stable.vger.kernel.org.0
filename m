Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84BEF360D98
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233792AbhDOPEA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 11:04:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:45848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235373AbhDOPBF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 11:01:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B2C561416;
        Thu, 15 Apr 2021 14:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498630;
        bh=HWbejj58m5BIOvjehaem8bi+Di6jcH0gmlRIsQrw0UU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WRniV13wtPnE12Wd/xDTqoZFfASkRGWeOzdAo6v3SZeYB9ZvTlTE66ZYqtsXes9vM
         nQYZ6+/LpbwrzOGWHvRgZFQWOn1UIUH+7VD1d4/Fyg1N1LVS/Rt3e+DBTJ9a8UQZyy
         HnHXQQMtKFXrSNSoXkYcK+QOb2NoZ6tNqV8Xkvd8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 12/25] radix tree test suite: Fix compilation
Date:   Thu, 15 Apr 2021 16:48:06 +0200
Message-Id: <20210415144413.551014173@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144413.165663182@linuxfoundation.org>
References: <20210415144413.165663182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 7487de534dcbe143e6f41da751dd3ffcf93b00ee ]

Commit 4bba4c4bb09a added tools/include/linux/compiler_types.h which
includes linux/compiler-gcc.h.  Unfortunately, we had our own (empty)
compiler_types.h which overrode the one added by that commit, and
so we lost the definition of __must_be_array().  Removing our empty
compiler_types.h fixes the problem and reduces our divergence from the
rest of the tools.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/radix-tree/linux/compiler_types.h | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 delete mode 100644 tools/testing/radix-tree/linux/compiler_types.h

diff --git a/tools/testing/radix-tree/linux/compiler_types.h b/tools/testing/radix-tree/linux/compiler_types.h
deleted file mode 100644
index e69de29bb2d1..000000000000
-- 
2.30.2



