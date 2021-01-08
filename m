Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 441EB2EED51
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 06:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbhAHF4h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jan 2021 00:56:37 -0500
Received: from smtp.rcn.com ([69.168.97.78]:42159 "EHLO smtp.rcn.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726312AbhAHF4h (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Jan 2021 00:56:37 -0500
DKIM-Signature: v=1; a=rsa-sha1; d=rcn.com; s=20180516; c=relaxed/simple;
        q=dns/txt; i=@rcn.com; t=1610085355;
        h=From:Subject:Date:To:MIME-Version:Content-Type;
        bh=uoq1oCgLlTqpdDX/iUbLy7J1Wic=;
        b=c6kYxl5dAHxbOiVdqdtpwlZJ3HRsqT6d8o+H3U0A3aj2VvTvGG1giU8pYhoGTBZg
        B6mfXaBuZWBLs89nJPuLyRwawLxAJ/PVA9uebz86unUT5DrL5CYw50SEmxMm4s9W
        Lvt0wFFL8pF0qDLIIwOkmgpFoJH/UiFs+x0DrCH8ckYzz99aodzrE4ACPRVID3To
        R3qkTMAnOgqGt8sE8yi+mbh7nVxnC2duRP3rS9fV04v8lDDOBr6fRs+dhJjyY/Jz
        zl7p2H6JBoHWafz4l8KghJ6pLBHrZOcrEGbxt4XULskThw6CiODeuA0naRIV7EC9
        ekn7x/2nHFdj0bOFrKburQ==;
X_CMAE_Category: , ,
X-CNFS-Analysis: v=2.3 cv=A5ASwJeG c=1 sm=1 tr=0 cx=a_idp_x a=bY+bM9/mKJztUtGSkaJH+w==:117 a=KGjhK52YXX0A:10 a=FKkrIqjQGGEA:10 a=1ZTNynoO03QA:10 a=F99cmy5_UvwA:10 a=IkcTkHD0fZMA:10 a=EmqxpYm9HcoA:10 a=3i-aVO-tkbYA:10 a=xcJYnEyJvIoA:10 a=x7bEGLp0ZPQA:10 a=tclcd6dtLQvEqt9_mmAA:9 a=QEXdDO2ut3YA:10 a=AisHjgVolJARo0l0tmIy:22
X-CM-Score: 0
X-Scanned-by: Cloudmark Authority Engine
X-Authed-Username: bS5nYW1ib25lQHJjbi5jb20=
Authentication-Results: smtp02.rcn.cmh.synacor.com smtp.mail=m.gambone@rcn.com; spf=softfail; sender-id=softfail
Authentication-Results: smtp02.rcn.cmh.synacor.com header.from=m.gambone@rcn.com; sender-id=softfail
Received: from [10.33.66.6] ([10.33.66.6:51857] helo=md06.rcn.cmh.synacor.com)
        by smtp.rcn.com (envelope-from <m.gambone@rcn.com>)
        (ecelerity 3.6.25.56547 r(Core:3.6.25.0)) with ESMTP
        id 6F/67-54275-AE3F7FF5; Fri, 08 Jan 2021 00:55:54 -0500
Date:   Fri, 8 Jan 2021 00:55:54 -0500 (EST)
From:   Priyanka Gopal <m.gambone@rcn.com>
Reply-To: Priyanka Gopal <vijptiil@gmail.com>
To:     Priyanka Gopal <vijptiil@gmail.com>
Message-ID: <2086926404.7263445.1610085354280.JavaMail.root@rcn.com>
In-Reply-To: <761999615.7260037.1610085042926.JavaMail.root@rcn.com>
Subject: Re: ok
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [193.37.254.99]
X-Mailer: Zimbra 7.2.7_GA_2942 (zclient/7.2.7_GA_2942)
X-Vade-Verditct: clean
X-Vade-Analysis: gggruggvucftvghtrhhoucdtuddrgedujedrvdegfedguddukecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfujgfpteevqfftnfgvrghrnhhinhhgpdftvefppdfqfgfvnecuuegrihhlohhuthemuceftddunecugfhmphhthicusghougihucdlhedtmdenucfjughrpeffhfhrvffkjgfugggtgfhiofesthejtgdtredtjeenucfhrhhomheprfhrihihrghnkhgrucfiohhprghluceomhdrghgrmhgsohhnvgesrhgtnhdrtghomheqnecuggftrfgrthhtvghrnhepudfgtdeiudfgveduteeiiedvtedvgeefieehheevvdektdefudehgeetkeejtdfhnecukfhppedutddrfeefrdeiiedriedpudelfedrfeejrddvheegrdelleenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepihhnvghtpedutddrfeefrdeiiedrieenpdhmrghilhhfrhhomhepmhdrghgrmhgsohhnvgesrhgtnhdrtghomhenpdhrtghpthhtohepshhttghouhhrihgvrhhmvggurghvrghkkhgrmhesghhmrghilhdrtghomhen
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

