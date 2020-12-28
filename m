Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D83E42E662E
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388551AbgL1NXm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:23:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:52282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388546AbgL1NXm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:23:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE73120719;
        Mon, 28 Dec 2020 13:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161781;
        bh=sV9cifRcauNGZ0LjAcCcdK89ZPt8u2a8dtWMPcGAeOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xzYA4wUvSGkDwHn6TG6TfcyknLFQpUe3IhAI8OzguoMTgMYkJNVwIpPsZD0jXYa7+
         M2FSON+9AACGzD5sfWo4m8cBGbN1hgJph2zRxdE2ig/JTvuV7fWc0EZHdPd5fr24r+
         AvCdl50cVI/oPgqWDh7sH1MgtGgHdAMdOzfy+8pU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        "taehyun.cho" <taehyun.cho@samsung.com>,
        Will McVicker <willmcvicker@google.com>,
        Peter Chen <peter.chen@nxp.com>
Subject: [PATCH 4.19 079/346] USB: gadget: f_acm: add support for SuperSpeed Plus
Date:   Mon, 28 Dec 2020 13:46:38 +0100
Message-Id: <20201228124923.618767109@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: taehyun.cho <taehyun.cho@samsung.com>

commit 3ee05c20656782387aa9eb010fdb9bb16982ac3f upstream.

Setup the SuperSpeed Plus descriptors for f_acm.  This allows the gadget
to work properly without crashing at SuperSpeed rates.

Cc: Felipe Balbi <balbi@kernel.org>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: taehyun.cho <taehyun.cho@samsung.com>
Signed-off-by: Will McVicker <willmcvicker@google.com>
Reviewed-by: Peter Chen <peter.chen@nxp.com>
Link: https://lore.kernel.org/r/20201127140559.381351-3-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/function/f_acm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/f_acm.c
+++ b/drivers/usb/gadget/function/f_acm.c
@@ -684,7 +684,7 @@ acm_bind(struct usb_configuration *c, st
 	acm_ss_out_desc.bEndpointAddress = acm_fs_out_desc.bEndpointAddress;
 
 	status = usb_assign_descriptors(f, acm_fs_function, acm_hs_function,
-			acm_ss_function, NULL);
+			acm_ss_function, acm_ss_function);
 	if (status)
 		goto fail;
 


