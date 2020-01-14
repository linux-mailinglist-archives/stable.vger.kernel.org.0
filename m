Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 699DE13A5F0
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729393AbgANKGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:06:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:35720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729640AbgANKGc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:06:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FC3E24677;
        Tue, 14 Jan 2020 10:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996391;
        bh=Jh40u/tSBu3myoAaCydzkNwil2EpuaMTa9hi9TmuNPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dWhRRAPo3ygs8CHOJ2H6u6eMS2+3vvUuTfkUaY9MxAsr7rvAg3ZZ6WdQBgz3DdIYA
         FuN1r9iOqOOdMn9vEngqbWAN14awrh2WE7fIRojo8MtfLFlP3z18WOrEdZoYggBo0c
         MNqwm4H6GzON6mT+zyQMmQ2XXtL3jpU21WZvLDFs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 5.4 65/78] staging: vt6656: remove bool from vnt_radio_power_on ret
Date:   Tue, 14 Jan 2020 11:01:39 +0100
Message-Id: <20200114094402.155167930@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094352.428808181@linuxfoundation.org>
References: <20200114094352.428808181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Malcolm Priestley <tvboxspy@gmail.com>

commit 07f59f180ee083c48c32a1e69ae1d0091444d212 upstream.

The driver uses logical only error checking a bool true would flag error.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Link: https://lore.kernel.org/r/cc52b67c-9ef8-3e57-815a-44d10701919e@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/vt6656/card.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -719,7 +719,7 @@ end:
  */
 int vnt_radio_power_on(struct vnt_private *priv)
 {
-	int ret = true;
+	int ret = 0;
 
 	vnt_exit_deep_sleep(priv);
 


