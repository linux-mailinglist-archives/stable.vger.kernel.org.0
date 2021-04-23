Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96AC1368E16
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 09:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240868AbhDWHpz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Apr 2021 03:45:55 -0400
Received: from mail2.directv.syn-alias.com ([69.168.106.50]:39109 "EHLO
        mail.directv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbhDWHpy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Apr 2021 03:45:54 -0400
DKIM-Signature: v=1; a=rsa-sha1; d=wildblue.net; s=20170921; c=relaxed/simple;
        q=dns/txt; i=@wildblue.net; t=1619163917;
        h=From:Subject:Date:To:MIME-Version:Content-Type;
        bh=uJQJNut0A7xrwgC3hvByq4Xy8us=;
        b=MKnr9bnEw0NuKyOZehhnpYxX0u5mVd7KMII9GnVfHX6mF6YmioZJEy4adqpGqakx
        MxBBYfNK/Jt+Z487+MWwvJslkY9b7aMeqhAFTOP2R3XOD6vhVmD5YzXoEbKh5SkC
        XfiuWdad+8d+ofam/wT27HEM3uNpUvizDem+x67K5+haJVYaqSLQqSxnGWSnGJnC
        yIeZwQoQ9PMI3pbkGlcuawZRvLzTiulEulETtkKs+L0L6wNm2QHPYCoSAo2hn88e
        r+tYaXkT8/X/U+Zs/rzfgWt0TASL/XuF0SBb4vcDz1w/oPvidDFiicVACGGvbfun
        90GIeAavzQOLkynFp82HfA==;
X-Authed-Username: amVkb3JhY2hAd2lsZGJsdWUubmV0
Received: from [10.80.118.23] ([10.80.118.23:53538] helo=md04.jasper.bos.sync.lan)
        by mail2.directv.syn-alias.com (envelope-from <jedorach@wildblue.net>)
        (ecelerity 3.6.25.56547 r(Core:3.6.25.0)) with ESMTP
        id 45/AE-04574-C0B72806; Fri, 23 Apr 2021 03:45:16 -0400
Date:   Fri, 23 Apr 2021 03:45:16 -0400 (EDT)
From:   Rowell Hambrick <jedorach@wildblue.net>
Reply-To: rowha211@gmail.com
To:     rafael.maum@e-swojswiat.pl
Message-ID: <120695664.76812163.1619163916443.JavaMail.zimbra@wildblue.net>
Subject: 
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [185.203.122.20]
X-Mailer: Zimbra 8.7.6_GA_1776 (zclient/8.7.6_GA_1776)
Thread-Index: dSYnpNL6JFa4iTDOLwANc3s52Deizw==
Thread-Topic: 
X-Vade-Verditct: clean
X-Vade-Analysis: gggruggvucftvghtrhhoucdtuddrgeduledrvdduuddguddvtdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfujgfpteevqfftpdggkfetufetvfdpqfgfvfenuceurghilhhouhhtmecufedtudenucfgmhhpthihuchsuhgsjhgvtghtucdluddtmdenucfjughrpeffhfhrvffkufggtgfgihfothesthejtgdtredtjeenucfhrhhomheptfhofigvlhhlucfjrghmsghrihgtkhcuoehjvgguohhrrggthhesfihilhgusghluhgvrdhnvghtqeenucggtffrrghtthgvrhhnpeefhfeiieevueeukeeggfefteefheevieeujeeugfegfefhjeehgfettdduhefhieenucfkphepuddtrdektddruddukedrvdefpddukeehrddvtdefrdduvddvrddvtdenucevlhhushhtvghrufhiiigvpeelnecurfgrrhgrmhepihhnvghtpedutddrkedtrdduudekrddvfedphhgvlhhopehmugdtgedrjhgrshhpvghrrdgsohhsrdhshihntgdrlhgrnhdpmhgrihhlfhhrohhmpehjvgguohhrrggthhesfihilhgusghluhgvrdhnvghtpdhrtghpthhtohepshhtvghfrghnsehgrhgvphhlihhnrdgtohhmpdhhohhsthepshhmthhprdhjrghsphgvrhdrsghoshdrshihnhgtrdhlrghnpdhsphhfpehsohhfthhfrghilhdpughkihhmpe
X-Vade-Client: VIASAT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Do you get my previous mail
