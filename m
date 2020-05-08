Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C10301CB032
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbgEHMgu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:36:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:50596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727904AbgEHMgt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:36:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2679C21473;
        Fri,  8 May 2020 12:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941409;
        bh=RkbciHOuTgWynaEsvfqqfM9VLg8UcvbdXInl/9mWLvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qFqHHaDaaScIQg+6bXWaiwUaSbUPW3lZE1UwYqoPUO7jpGBbzNqVT59yVeoNR8vEj
         /6fZh0ZfwUPsv5AHoIqsFzOBHz3/vFK6zsMPAzMuhwuVPfbGf7oDDFuSomNSoWy2IY
         oQR7u6fWtBloWk+0GQkqh5TU4ORkJ0msw0tu9yeY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 4.4 005/312] usb: gadget: f_acm: Fix configfs attr name
Date:   Fri,  8 May 2020 14:29:56 +0200
Message-Id: <20200508123124.912426309@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Opasiak <k.opasiak@samsung.com>

commit 0561f77e2db9e72dc32e4f82b56fca8ba6b31171 upstream.

Correct attribute name is port_num not num.

Fixes: ea6bd6b ("usb-gadget/f_acm: use per-attribute show and store methods")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Krzysztof Opasiak <k.opasiak@samsung.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/function/f_acm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/function/f_acm.c
+++ b/drivers/usb/gadget/function/f_acm.c
@@ -779,10 +779,10 @@ static ssize_t f_acm_port_num_show(struc
 	return sprintf(page, "%u\n", to_f_serial_opts(item)->port_num);
 }
 
-CONFIGFS_ATTR_RO(f_acm_port_, num);
+CONFIGFS_ATTR_RO(f_acm_, port_num);
 
 static struct configfs_attribute *acm_attrs[] = {
-	&f_acm_port_attr_num,
+	&f_acm_attr_port_num,
 	NULL,
 };
 


