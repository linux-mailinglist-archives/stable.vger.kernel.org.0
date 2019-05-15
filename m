Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 982231ED7E
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727706AbfEOLJ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:09:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:43386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726571AbfEOLJ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:09:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A23BD21473;
        Wed, 15 May 2019 11:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918597;
        bh=l4JtLHfLDj9majz6351VQqqQ6ALmlPCCirmKccmeIso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gnYCzIrttodkOwkdwktDBXYtz+cmhMH/bPJrqHGH9vWD526ZRvxqmBGXfTfeoRcGH
         YeRuFm5qSH/Kuorlyff1uQwxHX7B1snhyhFYXo6P7hR/VJtLjWwqzepP4b7QnQa3n/
         1rgyCve0E99CJ3gOIFnFAIeI6nMkBtK+yl9jATlk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiang Biao <jiang.biao2@zte.com.cn>,
        Thomas Gleixner <tglx@linutronix.de>, hpa@zytor.com,
        dwmw2@amazon.co.uk, konrad.wilk@oracle.com, bp@suse.de,
        zhong.weidong@zte.com.cn, Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 192/266] x86/speculation: Remove SPECTRE_V2_IBRS in enum spectre_v2_mitigation
Date:   Wed, 15 May 2019 12:54:59 +0200
Message-Id: <20190515090729.438146456@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiang Biao <jiang.biao2@zte.com.cn>

commit d9f4426c73002957be5dd39936f44a09498f7560 upstream.

SPECTRE_V2_IBRS in enum spectre_v2_mitigation is never used. Remove it.

Signed-off-by: Jiang Biao <jiang.biao2@zte.com.cn>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: hpa@zytor.com
Cc: dwmw2@amazon.co.uk
Cc: konrad.wilk@oracle.com
Cc: bp@suse.de
Cc: zhong.weidong@zte.com.cn
Link: https://lkml.kernel.org/r/1531872194-39207-1-git-send-email-jiang.biao2@zte.com.cn
[bwh: Backported to 4.4: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/nospec-branch.h |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -169,7 +169,6 @@ enum spectre_v2_mitigation {
 	SPECTRE_V2_RETPOLINE_MINIMAL_AMD,
 	SPECTRE_V2_RETPOLINE_GENERIC,
 	SPECTRE_V2_RETPOLINE_AMD,
-	SPECTRE_V2_IBRS,
 	SPECTRE_V2_IBRS_ENHANCED,
 };
 


