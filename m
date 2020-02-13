Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC3015C5E9
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbgBMPZa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:25:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:41288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729023AbgBMPZa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:25:30 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34FF820848;
        Thu, 13 Feb 2020 15:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607529;
        bh=GA+fYb+0DRK+VeQeKUaCgGZFbiP+DH5OSDA2JxVANdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tV8DAJ9AqqlbK/93sIi41VpAfuecw/3/o3XFI8ewCsxH7APTDlfXlEAparRVUfXHf
         3H3+rgZ8+6izfdGxUKzZNHiQRIO8tWbGNq0PZEz7/mw2WghevLyr4ScL9sF/PC9d6Q
         FmnkOWQgaY6VNXlWPauMYrbVGbQUfGFmGspSA7HU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 100/173] NFC: pn544: Adjust indentation in pn544_hci_check_presence
Date:   Thu, 13 Feb 2020 07:20:03 -0800
Message-Id: <20200213151958.029772178@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151931.677980430@linuxfoundation.org>
References: <20200213151931.677980430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

commit 5080832627b65e3772a35d1dced68c64e2b24442 upstream.

Clang warns

../drivers/nfc/pn544/pn544.c:696:4: warning: misleading indentation;
statement is not part of the previous 'if' [-Wmisleading-indentation]
                 return nfc_hci_send_cmd(hdev, NFC_HCI_RF_READER_A_GATE,
                 ^
../drivers/nfc/pn544/pn544.c:692:3: note: previous statement is here
                if (target->nfcid1_len != 4 && target->nfcid1_len != 7 &&
                ^
1 warning generated.

This warning occurs because there is a space after the tab on this line.
Remove it so that the indentation is consistent with the Linux kernel
coding style and clang no longer warns.

Fixes: da052850b911 ("NFC: Add pn544 presence check for different targets")
Link: https://github.com/ClangBuiltLinux/linux/issues/814
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/nfc/pn544/pn544.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nfc/pn544/pn544.c
+++ b/drivers/nfc/pn544/pn544.c
@@ -704,7 +704,7 @@ static int pn544_hci_check_presence(stru
 		    target->nfcid1_len != 10)
 			return -EOPNOTSUPP;
 
-		 return nfc_hci_send_cmd(hdev, NFC_HCI_RF_READER_A_GATE,
+		return nfc_hci_send_cmd(hdev, NFC_HCI_RF_READER_A_GATE,
 				     PN544_RF_READER_CMD_ACTIVATE_NEXT,
 				     target->nfcid1, target->nfcid1_len, NULL);
 	} else if (target->supported_protocols & (NFC_PROTO_JEWEL_MASK |


