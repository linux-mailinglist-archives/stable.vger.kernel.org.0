Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6EBE6C19A0
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233137AbjCTPf4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233139AbjCTPf1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:35:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154483A4E9
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:27:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38D00B80EC5
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:27:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD7AC433D2;
        Mon, 20 Mar 2023 15:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679326069;
        bh=h7vpUiiPtLPLG9a5vWxmrGagwlxo57LGdDJQAc5qikg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2pvEfFDMfKjO1LxXtfKCeUiSegJUQlF29JVekobIMvVpc0rp/pandEZC6VbgGyz/S
         0wwcLjQFKLO1d7OInuRtuPF+Rrcro5xu4+E/vtZk01GlneP+DOzx9M8VBLIc7e2aQW
         aTNxWq550cQdS+93obFk/UVMKfZaN+xs8AuvLp54=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Borislav Petkov (AMD)" <bp@alien8.de>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 6.1 195/198] virt/coco/sev-guest: Do some code style cleanups
Date:   Mon, 20 Mar 2023 15:55:33 +0100
Message-Id: <20230320145515.644058218@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov (AMD) <bp@alien8.de>

commit d25bae7dc7b0668cb2a1325c64eb32d5fea4e5a9 upstream.

Remove unnecessary linebreaks, make the code more compact.

No functional changes.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Link: https://lore.kernel.org/r/20230307192449.24732-7-bp@alien8.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/virt/coco/sev-guest/sev-guest.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -414,18 +414,14 @@ static int handle_guest_request(struct s
 		if (rc == -EIO && *fw_err == SNP_GUEST_REQ_INVALID_LEN)
 			return rc;
 
-		dev_alert(snp_dev->dev,
-			  "Detected error from ASP request. rc: %d, fw_err: %llu\n",
-			  rc, *fw_err);
+		dev_alert(snp_dev->dev, "Detected error from ASP request. rc: %d, fw_err: %llu\n", rc, *fw_err);
 		snp_disable_vmpck(snp_dev);
 		return rc;
 	}
 
 	rc = verify_and_dec_payload(snp_dev, resp_buf, resp_sz);
 	if (rc) {
-		dev_alert(snp_dev->dev,
-			  "Detected unexpected decode failure from ASP. rc: %d\n",
-			  rc);
+		dev_alert(snp_dev->dev, "Detected unexpected decode failure from ASP. rc: %d\n", rc);
 		snp_disable_vmpck(snp_dev);
 		return rc;
 	}


