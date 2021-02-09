Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A237E314571
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 02:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbhBIBP1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 20:15:27 -0500
Received: from mail2.directv.syn-alias.com ([69.168.106.50]:32426 "EHLO
        mail.directv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbhBIBP0 (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 8 Feb 2021 20:15:26 -0500
DKIM-Signature: v=1; a=rsa-sha1; d=wildblue.net; s=20170921; c=relaxed/simple;
        q=dns/txt; i=@wildblue.net; t=1612833285;
        h=From:Subject:Date:To:MIME-Version:Content-Type;
        bh=e50BNIa8q6E9T9tu5BM00rccoE8=;
        b=KcmUOof9FBOidbUwB9WpXc8/pYCQuz8WC76y9KX14eX5U6G2Ae6Y8q+a+fwcWDE4
        V5p5X1Lxsvs7lfwQz3gNk9dPVRQelhdXuTy8j/MkOiX9yUl6uW+TaNlAlPVUqiSP
        vW4fx6ELgjT/tzXPsCzy79shmD+lrVrqE850wGExZM5yirQzQsRyXeM9v9MTjbkn
        5JD/S4EVYPgkzfhCgwhKQng3wbeSWH90bRl7NjfifX98Ctu+jpYw8Jct0PAjMIvg
        8WB1DrPbBFPnQebkRDAdq5/hnQ6cpCBhn38E52XlMrODWOzchN7R8wqgSnzN/PeY
        8x3QVNzOpH/3Xwv1e2e9tg==;
X_CMAE_Category: , ,
X-CNFS-Analysis: v=2.4 cv=LKuj/La9 c=1 sm=1 tr=0 ts=6021e204 cx=a_idp_x a=J/Zec3zG8Cfcl7Qy1ylmOw==:117 a=9cW_t1CCXrUA:10 a=KGjhK52YXX0A:10 a=FKkrIqjQGGEA:10 a=OGxnvhSY1EUA:10 a=r5oH8Fgm9fIA:10 a=IkcTkHD0fZMA:10 a=qa6Q16uM49sA:10 a=IbQgVbBq4bcA:10 a=4cdET6WwprQA:10 a=x7bEGLp0ZPQA:10 a=-xSE0sSnTIhhw0HgHx8A:9 a=QEXdDO2ut3YA:10 a=xo5jKAKm-U-Zyk2_beg_:22 a=kHmCYliWHlBROp4ktEDo:22 a=pHzHmUro8NiASowvMSCR:22 a=Ew2E2A-JSTLzCXPT_086:22
X-CM-Score: 0
X-Scanned-by: Cloudmark Authority Engine
X-Authed-Username: cG9tZXJveTI2QHdpbGRibHVlLm5ldA==
Received: from [10.80.118.23] ([10.80.118.23:50454] helo=md05.jasper.bos.sync.lan)
        by mail2.directv.syn-alias.com (envelope-from <pomeroy26@wildblue.net>)
        (ecelerity 3.6.25.56547 r(Core:3.6.25.0)) with ESMTP
        id 02/E0-19783-302E1206; Mon, 08 Feb 2021 20:14:44 -0500
Date:   Mon, 8 Feb 2021 20:14:43 -0500 (EST)
From:   Rowell Hambrick <pomeroy26@wildblue.net>
Reply-To: rowellhambrick1@gmail.com
Message-ID: <1940217071.15848311.1612833283804.JavaMail.zimbra@wildblue.net>
Subject: 
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [95.142.122.22]
X-Mailer: Zimbra 8.7.6_GA_1776 (zclient/8.7.6_GA_1776)
Thread-Index: DBC8DgIJsaKAjZl9tiFWmb9MBZocSg==
Thread-Topic: 
X-Vade-Verditct: spam:high
X-Vade-Analysis: gggruggvucftvghtrhhoucdtuddrgeduledrheeggdefvdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfujgfpteevqfftnfgvrghrnhhinhhgpdggkfetufetvfdpqfgfvfenuceurghilhhouhhtmecufedtudenucgohfhorhgsihguuggvnhfjughrucdlhedttddmnecujfgurhepfffhrhfkufggtgfgihfothesthejtgdtredtjeenucfhrhhomheptfhofigvlhhlucfjrghmsghrihgtkhcuoehpohhmvghrohihvdeiseifihhluggslhhuvgdrnhgvtheqnecuggftrfgrthhtvghrnhepueeuuefhieeuuefhjeejteejfeefueelueeuheeuvefhvdegfefhheelteegvdeknecukfhppedutddrkedtrdduudekrddvfedpleehrddugedvrdduvddvrddvvdenucfhohhrsghiugguvghnjfgurhepfffhrhfkufggtgfgihfothesthejtgdtredtjeenucevlhhushhtvghrufhiiigvpeeinecurfgrrhgrmhepihhnvghtpedutddrkedtrdduudekrddvfeenpdhmrghilhhfrhhomhepphhomhgvrhhohidvieesfihilhgusghluhgvrdhnvghtnedprhgtphhtthhopehsthgvphhhvghnshhhuhhokhgvlhhiseduvdeirdgtohhmne
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Do you get my email
