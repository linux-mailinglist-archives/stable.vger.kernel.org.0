Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC0FC27CC28
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732776AbgI2Mdz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:33:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:37336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728786AbgI2LW5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:22:57 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53BB923A5C;
        Tue, 29 Sep 2020 11:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378390;
        bh=meO6ORAQIfHcxRMg2SQvD3XfCqWBal3sr5orOsOVaps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QOXLOmeWSm5AG/iVHAzURCCf9l+ZVIS88iu20l/gzfcV60mWCIdRY921E7bAB6Nfx
         N9IibquYSPAk9qf17lbk27o8ektdL3T9lVLrqHUWH2sOE5C1nBAwc7VUhtm13KJJBo
         sO8irhcM20hY/I14PIWyatJnWdzfibPAZx8GZ0M8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, linux-ide@vger.kernel.org
Subject: [PATCH 4.14 164/166] ata: define AC_ERR_OK
Date:   Tue, 29 Sep 2020 13:01:16 +0200
Message-Id: <20200929105943.386146288@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105935.184737111@linuxfoundation.org>
References: <20200929105935.184737111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

commit 25937580a5065d6fbd92d9c8ebd47145ad80052e upstream.

Since we will return enum ata_completion_errors from qc_prep in the next
patch, let's define AC_ERR_OK to mark the OK status.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: linux-ide@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/libata.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -504,6 +504,7 @@ enum hsm_task_states {
 };
 
 enum ata_completion_errors {
+	AC_ERR_OK		= 0,	    /* no error */
 	AC_ERR_DEV		= (1 << 0), /* device reported error */
 	AC_ERR_HSM		= (1 << 1), /* host state machine violation */
 	AC_ERR_TIMEOUT		= (1 << 2), /* timeout */


