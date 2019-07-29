Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B316C79450
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388072AbfG2TaK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:30:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:42914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388173AbfG2TaJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:30:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6D9821655;
        Mon, 29 Jul 2019 19:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428609;
        bh=+BKNhstZkIim4IgI8aZWRD5EJTEYYGqYqAS97BenvGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a2zEXmxKB6LrrEPZhVdHaVDxSQB9L4j8lonsCYRNXywieTLLoUZLJf9DOM1Ba9S6m
         uB2rXX/xR+vXhmdP31PR2/eDJl/kIHDN9q2ROHspmIsOL9gB5UiYQHDCT2F8CRcumj
         FtcJsW8q8++sGJDMLfOqMiehjZUe1jaVtJjJ3d5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Black <dankamongmen@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.14 129/293] Input: synaptics - whitelist Lenovo T580 SMBus intertouch
Date:   Mon, 29 Jul 2019 21:20:20 +0200
Message-Id: <20190729190834.462912320@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Black <dankamongmen@gmail.com>

commit 1976d7d200c5a32e72293a2ada36b7b7c9d6dd6e upstream.

Adds the Lenovo T580 to the SMBus intertouch list for Synaptics
touchpads. I've tested with this for a week now, and it seems a great
improvement. It's also nice to have the complaint gone from dmesg.

Signed-off-by: Nick Black <dankamongmen@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/mouse/synaptics.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -179,6 +179,7 @@ static const char * const smbus_pnp_ids[
 	"LEN0093", /* T480 */
 	"LEN0096", /* X280 */
 	"LEN0097", /* X280 -> ALPS trackpoint */
+	"LEN009b", /* T580 */
 	"LEN200f", /* T450s */
 	"LEN2054", /* E480 */
 	"LEN2055", /* E580 */


