Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44B05359B30
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 12:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234320AbhDIKHt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 06:07:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:51278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234316AbhDIKFv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 06:05:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6635D61356;
        Fri,  9 Apr 2021 10:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962518;
        bh=xF3OLvrkXxqieUA3Lge8W0wrSbztqaJOn4/7BbTbDSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lufoO43cR2HtBeKImwF8iq0jjt5meVsdqG3uIbuCH/hZYOotxan30JfEFHYDP2Vvx
         Q4pWB/5H2uq9dvqDagkyIA8GOm2i1nxzpiR/wXcP9z30y3wMsZoB7aBxtROT/ma1FQ
         QISY46+HmNIuBmmZXRx03GHZTe9ZFZBFG6YXY8D0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 36/45] math: Export mul_u64_u64_div_u64
Date:   Fri,  9 Apr 2021 11:54:02 +0200
Message-Id: <20210409095306.589673475@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095305.397149021@linuxfoundation.org>
References: <20210409095305.397149021@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David S. Miller <davem@davemloft.net>

[ Upstream commit bf45947864764548697e7515fe693e10f173f312 ]

Fixes: f51d7bf1dbe5 ("ptp_qoriq: fix overflow in ptp_qoriq_adjfine() u64 calcalation")
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/math/div64.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/math/div64.c b/lib/math/div64.c
index 064d68a5391a..46866394fc84 100644
--- a/lib/math/div64.c
+++ b/lib/math/div64.c
@@ -232,4 +232,5 @@ u64 mul_u64_u64_div_u64(u64 a, u64 b, u64 c)
 
 	return res + div64_u64(a * b, c);
 }
+EXPORT_SYMBOL(mul_u64_u64_div_u64);
 #endif
-- 
2.30.2



