Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E959C13FCFB
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389868AbgAPXUh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:20:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:47252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390682AbgAPXUg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:20:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDF7620684;
        Thu, 16 Jan 2020 23:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216836;
        bh=DPkjtJFTZwjg+rtZHYEvsn5NAPRUMVLLNJt/gZps5GM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TP0V3q9addQ0azCpM2QnD+Xq4i5DUTK0iRDs56zSq9UkylzKziDNVFGoUVtyn97aI
         rA5tzkqdeWMUfkm+kNLn0fWNxybxgdSTNbfmJojn/OrKoaKjKlpQ9QLenVYuvEvI4J
         Es52jTfEMUrtj6f89jkL6fsvabdokF0rbHCA/jbk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Menzel <pmenzel@molgen.mpg.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 039/203] scsi: smartpqi: Update attribute name to `driver_version`
Date:   Fri, 17 Jan 2020 00:15:56 +0100
Message-Id: <20200116231747.489735972@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Menzel <pmenzel@molgen.mpg.de>

commit a2bdd0c904da12b223c8d7218e98138d4e6d9f4f upstream.

The file name in the documentation is currently incorrect, so fix it.

Link: https://lore.kernel.org/r/fe264d62-0371-ea59-b66a-6d855290ce65@molgen.mpg.de
Fixes: 6d90615f1346 ("scsi: smartpqi: add sysfs entries")
Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/scsi/smartpqi.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/scsi/smartpqi.txt
+++ b/Documentation/scsi/smartpqi.txt
@@ -29,7 +29,7 @@ smartpqi specific entries in /sys
   smartpqi host attributes:
   -------------------------
   /sys/class/scsi_host/host*/rescan
-  /sys/class/scsi_host/host*/version
+  /sys/class/scsi_host/host*/driver_version
 
   The host rescan attribute is a write only attribute. Writing to this
   attribute will trigger the driver to scan for new, changed, or removed


