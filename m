Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3EC62A0A85
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 16:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbgJ3P5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 11:57:33 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54265 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726178AbgJ3P5c (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Oct 2020 11:57:32 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 2AEAA5C02E3;
        Fri, 30 Oct 2020 11:57:31 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 30 Oct 2020 11:57:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sent.com; h=from
        :to:cc:subject:date:message-id:in-reply-to:references:reply-to
        :mime-version:content-type:content-transfer-encoding; s=fm1; bh=
        a+yV5AyyQgbkAmuRGp5Grqx+CnaA6i6TKDg6E8EnuoM=; b=CM6maBmxba6MD3gN
        Qh3zw0M8Aodzykt7peGyp7k/hIrMRoSl4FyRsvoZgLc5iOjVDs05mgSwWSVB3RnU
        FHLvhGZ8QPztxZ3oWCaeIpOZPWPEHEsTHeoYk7tHY4TDF3x0XLxMUFQ2cULSYdxz
        on7zYvowgLYsDo6wTr3SOIKJr+0V55ya+/HxrINLLieVhkKQGEyoe3n8LemVQ3ck
        k76+b5mmNeYjebN9Ef6Y3sbpPgmfzDS+HiARnQnY91NWj+SduiWXEHrPsUhkVowJ
        so/Sxk7BtDDyHw4qi7yUjut9k5Ymb7QEhiAgjkTB5FJfFuprNPqOCAG2KQigidNZ
        0qgWvw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :reply-to:subject:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm1; bh=a+yV5AyyQgbkAmuRGp5Grqx+CnaA6
        i6TKDg6E8EnuoM=; b=XjsIw02X52kdwL2SI7AqkUZsB2TNMfkrvT1ZSucW8u4vP
        9PKkglNpAMYJOAWnOHqUCdcHxxIYY/67DCcN3Xjpy3T35LjkN2B4z+RxS+q/C0uo
        +6gds5HWz1ZooDha+wUdpT/VHGI+I2LeXv+blBPL10LsEnh4Dg/+PH52HPiallui
        xg0D+IkHHQVbLjlS1NoldygtcJvt0pqRKpAUX8pcmCetyDlWmraPrdHsvizrrbLH
        DvmXnX/Z9QZtPIqoxJ7goL93hTaTSsjYilQBwYBer0J95f1B/HSDJy0Np470chnU
        1SLnleKf+vrEmVlYAZwJcHLRc+1CgOZ9rYaYmgsUw==
X-ME-Sender: <xms:6jecXwNsUFY30fvsZI4ygQMm7FShfp9oQMWP-9zKuyMH6lSqWtiz8Q>
    <xme:6jecX2_LAnZb62_TK9vIE5nXsVX941nMbatW5pivg7TwyWCZqZYZO10rLid4v3Qah
    12ayEh1aMaWjfEDXg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrleehgdejkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhhrgggtgfesthhqredtredtjeenucfhrhhomhepkghiucgj
    rghnuceoiihirdihrghnsehsvghnthdrtghomheqnecuggftrfgrthhtvghrnhepkefggf
    eljeefgeejtdethfehvdfgffdvfeefkeejtefghfetvdduffekgeeltedtnecukfhppedu
    vddrgeeirddutdeirdduieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepiihirdihrghnsehsvghnthdrtghomh
X-ME-Proxy: <xmx:6jecX3SwqoUEgFceRqgWX9icwxS_HzhKVdCdLr97Ih-34JsAyCCdiw>
    <xmx:6jecX4vFCMytth0AbAjmr7vBPpoGXKPgQIQtQAh2TflIM6fsm_RwTw>
    <xmx:6jecX4fCnqP5Yx4bSWpZCNZabjZrjo9Jd6ysknmsRIQ4NxhgXmXRhg>
    <xmx:6zecXwTYDEixWvZ6dY2LgLz6lLCSsbm5TrsvUSrpIOUEhVGHk94KRw>
Received: from nvrsysarch6.NVidia.COM (unknown [12.46.106.164])
        by mail.messagingengine.com (Postfix) with ESMTPA id 45A85328005D;
        Fri, 30 Oct 2020 11:57:30 -0400 (EDT)
From:   Zi Yan <zi.yan@sent.com>
To:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc:     Yang Shi <shy828301@gmail.com>, Michal Hocko <mhocko@suse.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Rik van Riel <riel@surriel.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Zi Yan <ziy@nvidia.com>
Subject: [PATCH v2 2/2] mm/compaction: stop isolation if too many pages are isolated and we have pages to migrate.
Date:   Fri, 30 Oct 2020 11:57:16 -0400
Message-Id: <20201030155716.3614401-2-zi.yan@sent.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201030155716.3614401-1-zi.yan@sent.com>
References: <20201030155716.3614401-1-zi.yan@sent.com>
Reply-To: Zi Yan <ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zi Yan <ziy@nvidia.com>

In isolate_migratepages_block, if we have too many isolated pages and
nr_migratepages is not zero, we should try to migrate what we have
without wasting time on isolating.

Fixes: 1da2f328fa64 (=E2=80=9Cmm,thp,compaction,cma: allow THP migration fo=
r CMA allocations=E2=80=9D)
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
---
 mm/compaction.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/compaction.c b/mm/compaction.c
index 3e834ac402f1..4d237a7c3830 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -817,6 +817,10 @@ isolate_migratepages_block(struct compact_control *cc,=
 unsigned long low_pfn,
 	 * delay for some time until fewer pages are isolated
 	 */
 	while (unlikely(too_many_isolated(pgdat))) {
+		/* stop isolation if there are still pages not migrated */
+		if (cc->nr_migratepages)
+			return 0;
+
 		/* async migration should just abort */
 		if (cc->mode =3D=3D MIGRATE_ASYNC)
 			return 0;
--=20
2.28.0

