Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA67835441E
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 18:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241878AbhDEQEc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 12:04:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:55742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242047AbhDEQE1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 12:04:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC16A613B9;
        Mon,  5 Apr 2021 16:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617638661;
        bh=eNRxCHjDEZm7ZMVSCK8sEwsiZEqUyXr6H0sI5kRJgcc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iEjUj2eINKYSDyxeJ/pAuRfJwmv0hpRTw486TYbkHv8oj/RmOLYAVCsMiraTkYKth
         4Xs35IDelJjQs4fYLA83fhxTgWDjat40jY0hCDwz3wINzpk4OtaojmBPCW6bg7BcBM
         qOxr6/NEV+1LXszdilFss2uGBuHDw6gchSGC3oID5E0UF3BvWWm8C/am4FyaLs+gox
         9XAyq8D5Y5P+2i6u48w5ZN32Lul7NE099Ra9lDjnIHoB+fLL65wD5FMe4JpMD7fhog
         D9nPTC/bzSLY3L1mDOBJURlVlcFaeNlBLY3tMxsh6mYKdtZS8i96m70vmkFwH29k/E
         4jYfnGxCD8T2g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 13/22] radix tree test suite: Fix compilation
Date:   Mon,  5 Apr 2021 12:03:56 -0400
Message-Id: <20210405160406.268132-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210405160406.268132-1-sashal@kernel.org>
References: <20210405160406.268132-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

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

