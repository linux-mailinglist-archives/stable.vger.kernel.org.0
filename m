Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA058157B7A
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgBJMgN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:36:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:55084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728288AbgBJMgN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:36:13 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07FF0215A4;
        Mon, 10 Feb 2020 12:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338172;
        bh=OtF+22AVaCYL/DFT73Mu1Y/xZPAyyjmClm8bC9cY9Tw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tznu+qDtVZ5jiVWDM2HOl28gpEKuop4GDTjvEmjiLlvL5xGUxFUEeaw4jMdmo9a16
         HNdr9+KGs7qnEr92iRa5jI7OAKj6MpLSgPp3uNTFhl1yavaZGhC4mk65UU77YZrek5
         f0IZzNieyiFMerChEMyrYbUVW9cmi7rTKil2qaNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 156/195] net: tulip: Adjust indentation in {dmfe, uli526x}_init_module
Date:   Mon, 10 Feb 2020 04:33:34 -0800
Message-Id: <20200210122320.628276405@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

commit fe06bf3d83ef0d92f35a24e03297172e92ce9ce3 upstream.

Clang warns:

../drivers/net/ethernet/dec/tulip/uli526x.c:1812:3: warning: misleading
indentation; statement is not part of the previous 'if'
[-Wmisleading-indentation]
        switch (mode) {
        ^
../drivers/net/ethernet/dec/tulip/uli526x.c:1809:2: note: previous
statement is here
        if (cr6set)
        ^
1 warning generated.

../drivers/net/ethernet/dec/tulip/dmfe.c:2217:3: warning: misleading
indentation; statement is not part of the previous 'if'
[-Wmisleading-indentation]
        switch(mode) {
        ^
../drivers/net/ethernet/dec/tulip/dmfe.c:2214:2: note: previous
statement is here
        if (cr6set)
        ^
1 warning generated.

This warning occurs because there is a space before the tab on these
lines. Remove them so that the indentation is consistent with the Linux
kernel coding style and clang no longer warns.

While we are here, adjust the default block in dmfe_init_module to have
a proper break between the label and assignment and add a space between
the switch and opening parentheses to avoid a checkpatch warning.

Fixes: e1c3e5014040 ("[PATCH] initialisation cleanup for ULI526x-net-driver")
Link: https://github.com/ClangBuiltLinux/linux/issues/795
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/dec/tulip/dmfe.c    |    7 ++++---
 drivers/net/ethernet/dec/tulip/uli526x.c |    4 ++--
 2 files changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/dec/tulip/dmfe.c
+++ b/drivers/net/ethernet/dec/tulip/dmfe.c
@@ -2222,15 +2222,16 @@ static int __init dmfe_init_module(void)
 	if (cr6set)
 		dmfe_cr6_user_set = cr6set;
 
- 	switch(mode) {
-   	case DMFE_10MHF:
+	switch (mode) {
+	case DMFE_10MHF:
 	case DMFE_100MHF:
 	case DMFE_10MFD:
 	case DMFE_100MFD:
 	case DMFE_1M_HPNA:
 		dmfe_media_mode = mode;
 		break;
-	default:dmfe_media_mode = DMFE_AUTO;
+	default:
+		dmfe_media_mode = DMFE_AUTO;
 		break;
 	}
 
--- a/drivers/net/ethernet/dec/tulip/uli526x.c
+++ b/drivers/net/ethernet/dec/tulip/uli526x.c
@@ -1817,8 +1817,8 @@ static int __init uli526x_init_module(vo
 	if (cr6set)
 		uli526x_cr6_user_set = cr6set;
 
- 	switch (mode) {
-   	case ULI526X_10MHF:
+	switch (mode) {
+	case ULI526X_10MHF:
 	case ULI526X_100MHF:
 	case ULI526X_10MFD:
 	case ULI526X_100MFD:


