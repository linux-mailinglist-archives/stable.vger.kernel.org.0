Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6371E4D78EA
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 01:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234453AbiCNAXS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 13 Mar 2022 20:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235688AbiCNAXR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Mar 2022 20:23:17 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A48E7264;
        Sun, 13 Mar 2022 17:22:07 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 22E0Lk1sA017506, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 22E0Lk1sA017506
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 14 Mar 2022 08:21:46 +0800
Received: from RTEXMBS02.realtek.com.tw (172.21.6.95) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 14 Mar 2022 08:21:46 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS02.realtek.com.tw (172.21.6.95) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 14 Mar 2022 08:21:45 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::41d7:1d2e:78a6:ff34]) by
 RTEXMBS04.realtek.com.tw ([fe80::41d7:1d2e:78a6:ff34%5]) with mapi id
 15.01.2308.021; Mon, 14 Mar 2022 08:21:45 +0800
From:   Pkshih <pkshih@realtek.com>
To:     Larry Finger <Larry.Finger@lwfinger.net>,
        "kvalo@kernel.org" <kvalo@kernel.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] rtw88: Fix missing support for Realtek 8821CE RFE Type 6
Thread-Topic: [PATCH] rtw88: Fix missing support for Realtek 8821CE RFE Type 6
Thread-Index: AQHYNvmYIwpCHRrRLUm44JDZxWJKBay+A8og
Date:   Mon, 14 Mar 2022 00:21:45 +0000
Message-ID: <9ae5780119e24142bffd855d915a5e92@realtek.com>
References: <20220313164358.30426-1-Larry.Finger@lwfinger.net>
In-Reply-To: <20220313164358.30426-1-Larry.Finger@lwfinger.net>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS02.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/3/13_=3F=3F_10:59:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> -----Original Message-----
> From: Larry Finger <Larry.Finger@lwfinger.net>
> Sent: Monday, March 14, 2022 12:44 AM
> To: kvalo@kernel.org
> Cc: linux-wireless@vger.kernel.org; Larry Finger <Larry.Finger@lwfinger.net>; Pkshih <pkshih@realtek.com>;
> stable@vger.kernel.org
> Subject: [PATCH] rtw88: Fix missing support for Realtek 8821CE RFE Type 6
> 
> The rtl8821ce with RFE Type 6 behaves the same as ones with RFE Type 0.
> 
> This change has been tested in the repo at git://GitHub.com/lwfinger/rtw88.git.
> It fixes commit 769a29ce2af4 ("rtw88: 8821c: add basic functions").
> 
> Fixes: 769a29ce2af4 ("rtw88: 8821c: add basic functions").
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: stable@vger.kernel.org # 5.9+
> ---
> Kalle,
> 
> This patch file was prepared a couple of months ago, but apparently not submitted
> then. It should be applied as soon as possible.
> 
> Larry

Hi Larry,

This patch has been merged [1]. The git link of wireless driver next has been
changed [2]. That may be the reason you can't find the patch.

[1] https://lore.kernel.org/all/164364407205.21641.13263478436415544062.kvalo@kernel.org/
[2] git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git

Ping-Ke

