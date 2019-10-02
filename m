Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4662DC91B8
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 21:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728866AbfJBTIN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 15:08:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35646 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729236AbfJBTIN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 15:08:13 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyr-000365-Kl; Wed, 02 Oct 2019 20:08:09 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyo-0003eB-Oe; Wed, 02 Oct 2019 20:08:06 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Russell King" <rmk+kernel@armlinux.org.uk>,
        "Wolfram Sang" <wsa@the-dreams.de>
Date:   Wed, 02 Oct 2019 20:06:51 +0100
Message-ID: <lsq.1570043211.787427591@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 54/87] i2c: acorn: fix i2c warning
In-Reply-To: <lsq.1570043210.379046399@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.75-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@armlinux.org.uk>

commit ca21f851cc9643af049226d57fabc3c883ea648e upstream.

The Acorn i2c driver (for RiscPC) triggers the "i2c adapter has no name"
warning in the I2C core driver, resulting in the RTC being inaccessible.
Fix this.

Fixes: 2236baa75f70 ("i2c: Sanity checks on adapter registration")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/i2c/busses/i2c-acorn.c | 1 +
 1 file changed, 1 insertion(+)

--- a/drivers/i2c/busses/i2c-acorn.c
+++ b/drivers/i2c/busses/i2c-acorn.c
@@ -83,6 +83,7 @@ static struct i2c_algo_bit_data ioc_data
 
 static struct i2c_adapter ioc_ops = {
 	.nr			= 0,
+	.name			= "ioc",
 	.algo_data		= &ioc_data,
 };
 

