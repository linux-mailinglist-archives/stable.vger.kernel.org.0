Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE633354487
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 18:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241998AbhDEQFb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 12:05:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:57354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241977AbhDEQFO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 12:05:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EE54613C5;
        Mon,  5 Apr 2021 16:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617638708;
        bh=Sm8aQaGLHRowj8diWMhZrFvkldhFlLEA9Jvp+s9WktI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n9s0CqnWs4mK4oDsB371tH8wOe84FL0WtIp/POQU2qmFN1zwhZtKs0S1+wZR0OW9Z
         NOB5jKFtnqjeelzC9N/0BYFlnsDNHw6bltRDlzyVxDeQe6JpEM6ENwWwFCaT83q8KT
         xZXgOKUth2XPlG964x5tjiNymL0GLDuO2AD7Qg+s+nSuoxSF6J6qz6cDbFoa7C6Fn+
         6hLj/iO64L0Ib0Cby/wYHjwtL+1u1uuOcE1acI9sisqE6Ho2H4Xr2fWGonCysByxF4
         eHGzWQ/8nNZwPZsvr11pTt3zl0/ggc+UXccZqF2piX2235CFRaMWB5fbWKay+iN98R
         WNYyhSJ1hBMLw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 07/13] radix tree test suite: Fix compilation
Date:   Mon,  5 Apr 2021 12:04:52 -0400
Message-Id: <20210405160459.268794-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210405160459.268794-1-sashal@kernel.org>
References: <20210405160459.268794-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

[ Upstream commit dd841a749d1ded8e2e5facc4242ee0b6779fc0cb ]

Introducing local_lock broke compilation; fix it all up.

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

