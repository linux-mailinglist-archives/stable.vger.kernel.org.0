Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C94722F069
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732251AbgG0OYZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:24:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:53898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732202AbgG0OYY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:24:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F05921744;
        Mon, 27 Jul 2020 14:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859863;
        bh=kOVhulJk+pdwU88duSZrqzaEiuBdYU+NRWyGSP6HyBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RdYBmobozHhgvZ94mBOR+2fGXTnsO7D7AqDC4qQ7EPzaI8PGTxJvF7it/bjDXlzdX
         Bqokrk5ZWyOa2KR3+dX1yQTR0E6drso+t3y0HCKMfQ3skQyq6ZE3ZnqIIEcX9LqmZu
         ekVktbKBYv7A6lVlSxYjxWK6zxH8ooae4KbDn1rU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Katsnelson <me@0upti.me>,
        Lyude Paul <lyude@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 117/179] Input: synaptics - enable InterTouch for ThinkPad X1E 1st gen
Date:   Mon, 27 Jul 2020 16:04:52 +0200
Message-Id: <20200727134938.354419325@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Katsnelson <me@0upti.me>

[ Upstream commit dcb00fc799dc03fd320e123e4c81b3278c763ea5 ]

Tested on my own laptop, touchpad feels slightly more responsive with
this on, though it might just be placebo.

Signed-off-by: Ilya Katsnelson <me@0upti.me>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Link: https://lore.kernel.org/r/20200703143457.132373-1-me@0upti.me
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/mouse/synaptics.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 758dae8d65006..4b81b2d0fe067 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -179,6 +179,7 @@ static const char * const smbus_pnp_ids[] = {
 	"LEN0093", /* T480 */
 	"LEN0096", /* X280 */
 	"LEN0097", /* X280 -> ALPS trackpoint */
+	"LEN0099", /* X1 Extreme 1st */
 	"LEN009b", /* T580 */
 	"LEN200f", /* T450s */
 	"LEN2044", /* L470  */
-- 
2.25.1



