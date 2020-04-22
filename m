Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF4D1B3E73
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730926AbgDVK1n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:27:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:36880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730921AbgDVK1m (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:27:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B71C20784;
        Wed, 22 Apr 2020 10:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587551261;
        bh=oGNoFMiTl3XoTCe407hIxRE+bzjUiNIRIr0wS07o/Qs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0l9PPAP3zeXHfdKTYAFEwxnpAzWlKuozNnhFwyxeEY0Q+iNfqzc0evg336nnxcjxq
         yO0/e7L0TJLBT/o1OcD++VR/0Vt93vfjo5hObaXAeEnONed6O1VWb7AjCxmppEivP2
         J54RHdX5DP4nK9dXanhvDL1/5wAOmrE1eW8eigo0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 5.6 159/166] docs: Fix path to MTD command line partition parser
Date:   Wed, 22 Apr 2020 11:58:06 +0200
Message-Id: <20200422095105.491986803@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
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
@@ -2795,7 +2795,7 @@
 			<name>,<region-number>[,<base>,<size>,<buswidth>,<altbuswidth>]
 
 	mtdparts=	[MTD]
-			See drivers/mtd/cmdlinepart.c.
+			See drivers/mtd/parsers/cmdlinepart.c
 
 	multitce=off	[PPC]  This parameter disables the use of the pSeries
 			firmware feature for updating multiple TCE entries


