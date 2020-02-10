Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0674B1576F7
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729549AbgBJM4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:56:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:44168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729761AbgBJMlh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:37 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14CA9208C3;
        Mon, 10 Feb 2020 12:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338497;
        bh=GfY0bmBiqh0NqfU7FYMqZtKu8Wg4/HCjFIo9gPncUJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QAY6/7j666jWtz50YQDqmXz0iUVLuWMPycuy8TXE29de57lcgwOjVkqVkrxZmcbkP
         X32N94VLAcGKRol+swYRoWQbTOoh2L6WCyzZv6x6rywZbCfYSM5EhnfEMMx/Xd6b5n
         wW9aU2Sb2JESSdWJ5s3xw5ZVyMHNcSLvW3ifarjw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH 5.5 286/367] phy: qualcomm: Adjust indentation in read_poll_timeout
Date:   Mon, 10 Feb 2020 04:33:19 -0800
Message-Id: <20200210122450.313373008@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

commit a89806c998ee123bb9c0f18526e55afd12c0c0ab upstream.

Clang warns:

../drivers/phy/qualcomm/phy-qcom-apq8064-sata.c:83:4: warning:
misleading indentation; statement is not part of the previous 'if'
[-Wmisleading-indentation]
                 usleep_range(DELAY_INTERVAL_US, DELAY_INTERVAL_US + 50);
                 ^
../drivers/phy/qualcomm/phy-qcom-apq8064-sata.c:80:3: note: previous
statement is here
                if (readl_relaxed(addr) & mask)
                ^
1 warning generated.

This warning occurs because there is a space after the tab on this line.
Remove it so that the indentation is consistent with the Linux kernel
coding style and clang no longer warns.

Fixes: 1de990d8a169 ("phy: qcom: Add driver for QCOM APQ8064 SATA PHY")
Link: https://github.com/ClangBuiltLinux/linux/issues/816
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/phy/qualcomm/phy-qcom-apq8064-sata.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/phy/qualcomm/phy-qcom-apq8064-sata.c
+++ b/drivers/phy/qualcomm/phy-qcom-apq8064-sata.c
@@ -80,7 +80,7 @@ static int read_poll_timeout(void __iome
 		if (readl_relaxed(addr) & mask)
 			return 0;
 
-		 usleep_range(DELAY_INTERVAL_US, DELAY_INTERVAL_US + 50);
+		usleep_range(DELAY_INTERVAL_US, DELAY_INTERVAL_US + 50);
 	} while (!time_after(jiffies, timeout));
 
 	return (readl_relaxed(addr) & mask) ? 0 : -ETIMEDOUT;


