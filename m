Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8182B66D994
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 10:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236498AbjAQJPS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 04:15:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236666AbjAQJOF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 04:14:05 -0500
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E401B3BD91;
        Tue, 17 Jan 2023 01:06:53 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id EE8895C0064;
        Tue, 17 Jan 2023 04:06:16 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 17 Jan 2023 04:06:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
         h=cc:cc:content-transfer-encoding:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1673946376; x=
        1674032776; bh=Df24bCGT4QZ+Xvpi3Tsf1b/KvctyrLLDs9supDMoYb4=; b=q
        ldaI/6cbb+baLZkEdkC1XqC6QOIjuL0ubizkmMPLME8ZyGmv7q74IcY99czsnFTi
        4BILWFI/uMbx6qchUCGu7MySS3xrgJFGN3v3xtSgVwP+i02KcigDrj2tVijd1Isz
        jopMEmlnEQmDKsqb4v5huMmtPkJ5EIoD9HMQvwIsyQyBfu7s3SEH0xXvCPPVVB3g
        xnwEc8co7h/DfWJ/3T44oHVT719kaoTRcCAoPqy/Ex+FYRTjoGhyiEkPFCPNfQVi
        ByRcWbwuvAztJV+nr2U3m4BTmkmPSj6x5WM/THlBCwMIRYMBomXwuobGUlj53T31
        ZZ6erUhTaatC1QkYqgr3A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1673946376; x=1674032776; bh=Df24bCGT4QZ+X
        vpi3Tsf1b/KvctyrLLDs9supDMoYb4=; b=YssJBzORyH6tOfwDPpV5JsC+tXJbj
        wvYj7U/+2mWIS26rlbRA+fA/SyUqeLFdRLOnbyPjJtl5iKp9fKw4l+fIuLnqVnS+
        1z1nkLkNrotnX8uW94SwaxUHbQhKFMefpjFavgEklcJ9/mepK+2NCG5ichNux8ry
        kp6r5bLFHtjYk1u9czEoihFhic+PZsV+Yy0JFVcKO4NIHZyDVX7v/yaKy5MJWLaX
        ooR5aKn0lCNyRtjS8XDp71QO4zpGyweIKCtwDHTVa2BPVc7sIviDN6TKYjCdOBzu
        bdZP3GHf8GsBXRqZslGI+T3U/XKfO3tYrOo2bOO9ZqJjt9ejXHE40UrPw==
X-ME-Sender: <xms:CGXGYxNkJmywlUCvR2d8GV-9BqrrCACcfT6QRJbQ4rilStP_kOseqQ>
    <xme:CGXGYz_Ku41BPKqwMzIutVvTaLJaJL2oHaX02wQU9B99t4Q6WCEpi5ErMifa2A0W6
    fhhZYvrn_2NkOAFW5M>
X-ME-Received: <xmr:CGXGYwQPHhyiu7OImQ9QnFZ1ixp2mD4fKajlhkTIq-m4lM6_jHPakO5eTM25IGrun1caWKRaBCKMElQ56GL0aJMqjsBtcst8MKeC-7mnmRuFcHMBt3ZFm_Y>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedruddthedgudefudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvvefufffkofgjfhgggfestd
    ekredtredttdenucfhrhhomhepvfgrkhgrshhhihcuufgrkhgrmhhothhouceoohdqthgr
    khgrshhhihesshgrkhgrmhhotggthhhirdhjpheqnecuggftrfgrthhtvghrnhepvdejgf
    ejuedvgfduudekleevtefgtdevhfdtffefiefgveeuteffiedvffekvddtnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepohdqthgrkhgrshhhih
    esshgrkhgrmhhotggthhhirdhjph
X-ME-Proxy: <xmx:CGXGY9to3Y48oTmuRfGeZcNC3Qi-EFR0UBH7-X11-P8Yeq_76QoxJw>
    <xmx:CGXGY5cropCq127Ut5Af_sQjlQcP8Kp6fxV1uzb2yVUPOG3nwAMgew>
    <xmx:CGXGY53VUOpuAlAuoypPc5HDhyxoUNHloQI2HmEnzAm1ZWPwP5GBIA>
    <xmx:CGXGY95xcbGvPITu_u_qmCGOtgSPI8PEZ3fG3f9ViNq6ON3V4Pp-IQ>
Feedback-ID: ie8e14432:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 17 Jan 2023 04:06:15 -0500 (EST)
From:   Takashi Sakamoto <o-takashi@sakamocchi.jp>
To:     tiwai@suse.de
Cc:     linux1394-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        stable@vger.kernel.org
Subject: [PATCH 1/1] firewire: fix memory leak for payload of request subaction to IEC 61883-1 FCP region
Date:   Tue, 17 Jan 2023 18:06:10 +0900
Message-Id: <20230117090610.93792-2-o-takashi@sakamocchi.jp>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230117090610.93792-1-o-takashi@sakamocchi.jp>
References: <20230117090610.93792-1-o-takashi@sakamocchi.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch is fix for Linux kernel v2.6.33 or later.

For request subaction to IEC 61883-1 FCP region, Linux FireWire subsystem
have had an issue of use-after-free. The subsystem allows multiple
user space listeners to the region, while data of the payload was likely
released before the listeners execute read(2) to access to it for copying
to user space.

The issue was fixed by a commit 281e20323ab7 ("firewire: core: fix
use-after-free regression in FCP handler"). The object of payload is
duplicated in kernel space for each listener. When the listener executes
ioctl(2) with FW_CDEV_IOC_SEND_RESPONSE request, the object is going to
be released.

However, it causes memory leak since the commit relies on call of
release_request() in drivers/firewire/core-cdev.c. Against the
expectation, the function is never called due to the design of
release_client_resource(). The function delegates release task
to caller when called with non-NULL fourth argument. The implementation
of ioctl_send_response() is the case. It should release the object
explicitly.

This commit fixes the bug.

Cc: <stable@vger.kernel.org>
Fixes: 281e20323ab7 ("firewire: core: fix use-after-free regression in FCP handler")
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
---
 drivers/firewire/core-cdev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/firewire/core-cdev.c b/drivers/firewire/core-cdev.c
index 9c89f7d53e99..958aa4662ccb 100644
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -819,8 +819,10 @@ static int ioctl_send_response(struct client *client, union ioctl_arg *arg)
 
 	r = container_of(resource, struct inbound_transaction_resource,
 			 resource);
-	if (is_fcp_request(r->request))
+	if (is_fcp_request(r->request)) {
+		kfree(r->data);
 		goto out;
+	}
 
 	if (a->length != fw_get_response_length(r->request)) {
 		ret = -EINVAL;
-- 
2.37.2

