Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8495E1B3FFA
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731746AbgDVKmZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:42:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:56846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730113AbgDVKUf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:20:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 527C820882;
        Wed, 22 Apr 2020 10:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550834;
        bh=MxfZqwYuTbJQqXM8IFaFiD9upgymHdyWQGEkNliFGuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UHoP9hzxTIE/Uyw64b+CkHjQn9zwQTa1hzO8bPKIItmGZszNPipDsUPrXhU6yS4VP
         xQXqEj9z42Y1xKk3rStu/nTZBjFwrLwVDnwdWR1QbHqkATKVJAAUjlkPeVM5Gtl7JG
         rkDfuPFD+kac0vGz5H78EkL9k6rnMIMlOUH/74jI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 5.4 111/118] docs: Fix path to MTD command line partition parser
Date:   Wed, 22 Apr 2020 11:57:52 +0200
Message-Id: <20200422095049.135454091@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095031.522502705@linuxfoundation.org>
References: <20200422095031.522502705@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Neuschäfer <j.neuschaefer@gmx.net>

commit fb2511247dc4061fd122d0195838278a4a0b7b59 upstream.

cmdlinepart.c has been moved to drivers/mtd/parsers/.

Fixes: a3f12a35c91d ("mtd: parsers: Move CMDLINE parser")
Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/admin-guide/kernel-parameters.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2741,7 +2741,7 @@
 			<name>,<region-number>[,<base>,<size>,<buswidth>,<altbuswidth>]
 
 	mtdparts=	[MTD]
-			See drivers/mtd/cmdlinepart.c.
+			See drivers/mtd/parsers/cmdlinepart.c
 
 	multitce=off	[PPC]  This parameter disables the use of the pSeries
 			firmware feature for updating multiple TCE entries


