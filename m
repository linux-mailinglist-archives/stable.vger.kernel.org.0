Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4AA2DA90A
	for <lists+stable@lfdr.de>; Tue, 15 Dec 2020 09:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgLOIOq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Dec 2020 03:14:46 -0500
Received: from mail2.directv.syn-alias.com ([69.168.106.50]:19556 "EHLO
        mail.directv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbgLOIOo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Dec 2020 03:14:44 -0500
DKIM-Signature: v=1; a=rsa-sha1; d=wildblue.net; s=20170921; c=relaxed/simple;
        q=dns/txt; i=@wildblue.net; t=1608020040;
        h=From:Subject:Date:To:MIME-Version:Content-Type;
        bh=7QFBJ3ol0iIxaa51AmjyWQzIBkY=;
        b=Inxnutk7D4umMSefCDdJeDBaYD8E127fizeYWe6ej4wfAJ8jH28WO1t5rAmKDtDx
        SJ6fCoskJk5/aiApaHcHHsAylXKcLKVjY7BqqJ0nhUikxxooyBkZqps9+0D7a/mD
        INr69nKqzJpuLubflopRrLE1om2osZigZyP37BrqXMRlgjbKts4T47Qdumw0oybr
        OB6xgUf2LxgbemGnkPu3gY/g4ELCSW5NjiCy7FE+ONPTr73W+vErj3Nft7X4iSuu
        3iIgW97oiPuAVuHbZZo1Hug8oMltvLb9uxHnQdO9ZazwvHZ3b5rEBwagXp3oTEC9
        XR5clzzF2SHi5KQlpitjhQ==;
X_CMAE_Category: , ,
X-CNFS-Analysis: v=2.3 cv=W95Gqiek c=1 sm=1 tr=0 cx=a_idp_x a=2lFl+QxTouiIEabbTS0tYw==:117 a=9cW_t1CCXrUA:10 a=KGjhK52YXX0A:10 a=FKkrIqjQGGEA:10 a=0HWvpWdjkFgA:10 a=8CtJfJBZR_UA:10 a=IkcTkHD0fZMA:10 a=zTNgK-yGK50A:10 a=A3tKBufkE8oA:10 a=q-lTWTPkEJ0A:10 a=x7bEGLp0ZPQA:10 a=rWLlr_ktIPNyxI42s1YA:9 a=QEXdDO2ut3YA:10 a=xo5jKAKm-U-Zyk2_beg_:22 a=jesCJw-TT3PGqT-kMy3s:22 a=pHzHmUro8NiASowvMSCR:22 a=Ew2E2A-JSTLzCXPT_086:22
X-CM-Score: 0
X-Scanned-by: Cloudmark Authority Engine
X-Authed-Username: amFtZXNrbmlnaHRAd2lsZGJsdWUubmV0
Received: from [10.80.118.14] ([10.80.118.14:56902] helo=md06.jasper.bos.sync.lan)
        by mail2.directv.syn-alias.com (envelope-from <jamesknight@wildblue.net>)
        (ecelerity 3.6.25.56547 r(Core:3.6.25.0)) with ESMTP
        id F9/6D-08087-74078DF5; Tue, 15 Dec 2020 03:13:59 -0500
Date:   Tue, 15 Dec 2020 03:13:59 -0500 (EST)
From:   Anders Karlsson <jamesknight@wildblue.net>
Reply-To: andresk1470@gmail.com
Message-ID: <1740542491.127856197.1608020039307.JavaMail.zimbra@wildblue.net>
Subject: 
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [95.137.178.183]
X-Mailer: Zimbra 8.7.6_GA_1776 (zclient/8.7.6_GA_1776)
Thread-Index: W9J2L6T0gRyaHmKkknD+A2ITCtIt9A==
Thread-Topic: 
X-Vade-Verditct: spam:high
X-Vade-Analysis: gggruggvucftvghtrhhoucdtuddrgedujedrudekledguddulecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfujgfpteevqfftpdggkfetufetvfdpqfgfvfenuceurghilhhouhhtmecufedtudenucgohfhorhgsihguuggvnhfjughrucdlhedttddmnecujfgurhepfffhrhfkufggtgfgihfothesthejtgdtredtjeenucfhrhhomheptehnuggvrhhsucfmrghrlhhsshhonhcuoehjrghmvghskhhnihhghhhtseifihhluggslhhuvgdrnhgvtheqnecuggftrfgrthhtvghrnhepgffhfeegteegffejhfelvdfhgeegleevtdduffehkeeugfdvueffjeekuefhfeejnecukfhppedutddrkedtrdduudekrddugedpleehrddufeejrddujeekrddukeefnecuhfhorhgsihguuggvnhfjughrpeffhfhrkffugggtgfhiofhtsehtjegttdertdejnecuvehluhhsthgvrhfuihiivgepudegnecurfgrrhgrmhepihhnvghtpedutddrkedtrdduudekrddugeenpdhmrghilhhfrhhomhepjhgrmhgvshhknhhighhhthesfihilhgusghluhgvrdhnvghtnedprhgtphhtthhopehsthgvtghhmhesudeifedrtghomhen
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Did you get my email
