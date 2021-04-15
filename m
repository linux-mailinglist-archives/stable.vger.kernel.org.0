Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60B17360DC9
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233913AbhDOPF7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 11:05:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:48942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234416AbhDOPDU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 11:03:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1EAD61428;
        Thu, 15 Apr 2021 14:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498695;
        bh=HWbejj58m5BIOvjehaem8bi+Di6jcH0gmlRIsQrw0UU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OD85bTl2aKkNiMXXt5ekI8a82tiN+BU0btgWH7rgg2sr1jdiMa8ipi3K+m28Y7LP1
         a+06ELZzD8WMhFtV/m+h+Mtsr9V/v/+PRSNHs5wNb2cSt/OQZ4Bww3Gwbtlbo/7sDq
         PIRW7u1loWCEGJI4gdZg7dErdZg6S3FZtOd69B28=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 12/23] radix tree test suite: Fix compilation
Date:   Thu, 15 Apr 2021 16:48:19 +0200
Message-Id: <20210415144413.537807651@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144413.146131392@linuxfoundation.org>
References: <20210415144413.146131392@linuxfoundation.org>
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



