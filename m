Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A330E823BD
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 19:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728798AbfHEROB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 13:14:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:48736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727460AbfHEROB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 13:14:01 -0400
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 866CF20880;
        Mon,  5 Aug 2019 17:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565025240;
        bh=Va+OTuCNAfDuQ8PngmkrwQZCpEgAWLmwthnJauPJOUA=;
        h=From:To:Cc:Subject:Date:From;
        b=Jit1u+6Odc0arxR2KHjg0m3ScD0yp187mCgJplayX+gwY2ryEg8sx2QZDCxX+ZDI9
         2qlfU350010tRzoSPx863JzuXwNUKBJPUzYxeRevgu2IqTD0Gs3oyzbwx9bvcGIClX
         gXg7nkXOEg5p86OD2JZ1bbGH2haabIAWfn2k14V4=
From:   Will Deacon <will@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, Will Deacon <will@kernel.org>
Subject: [PATCH 0/2] [Backport for 4.9.y stable] arm64 CTR_EL0 cpufeature fixes
Date:   Mon,  5 Aug 2019 18:13:53 +0100
Message-Id: <20190805171355.19308-1-will@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

These two patches are backports for 4.9.y stable kernels after one of
them failed to apply:

  https://lkml.kernel.org/r/156498316660175@kroah.com

Cheers,

Will

--->8

Will Deacon (2):
  arm64: cpufeature: Fix CTR_EL0 field definitions
  arm64: cpufeature: Fix feature comparison for CTR_EL0.{CWG,ERG}

 arch/arm64/include/asm/cpufeature.h |  7 ++++---
 arch/arm64/kernel/cpufeature.c      | 14 ++++++++++----
 2 files changed, 14 insertions(+), 7 deletions(-)

-- 
2.11.0

