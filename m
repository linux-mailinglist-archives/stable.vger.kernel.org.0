Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 631312E37DB
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729440AbgL1NAf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:00:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:56742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729489AbgL1NAe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:00:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C36A4224D2;
        Mon, 28 Dec 2020 12:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160394;
        bh=Eu3WwfxvjsfbZcO5t0tR1Cdq6NyZA4LKnONh3i5U5sc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uOUXYDrSJ+Yc2TB4CorQAfwfCU9LpvlduNYENcxDkFRNU8i5K652CaOJpKT+z1S1M
         m0pgMmJUUHpBsXMFhOB5QtQiz0SyYUKHPnuewnFOReeNkSnoKnKytbrWyrW8AdHRB+
         g6+TXXwmBnFHA1Q5Ar+MJv98YTv4fuEIAau1JRNw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        "taehyun.cho" <taehyun.cho@samsung.com>,
        Will McVicker <willmcvicker@google.com>,
        Peter Chen <peter.chen@nxp.com>
Subject: [PATCH 4.9 037/175] USB: gadget: f_acm: add support for SuperSpeed Plus
Date:   Mon, 28 Dec 2020 13:48:10 +0100
Message-Id: <20201228124855.043326993@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
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
@@ -687,7 +687,7 @@ acm_bind(struct usb_configuration *c, st
 	acm_ss_out_desc.bEndpointAddress = acm_fs_out_desc.bEndpointAddress;
 
 	status = usb_assign_descriptors(f, acm_fs_function, acm_hs_function,
-			acm_ss_function, NULL);
+			acm_ss_function, acm_ss_function);
 	if (status)
 		goto fail;
 


