Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 440D774637
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 07:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390008AbfGYFnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 01:43:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:58114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404889AbfGYFnK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 01:43:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B468521850;
        Thu, 25 Jul 2019 05:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564033389;
        bh=+BKNhstZkIim4IgI8aZWRD5EJTEYYGqYqAS97BenvGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ppCi9XG+OrhyXcZT/5tw79Zm/6f5MEebhRR7CR1B0mBF8ELrX8iQ5n7AfLRgqHEfb
         rY797LcB8SzegDv/cqeMHW9hdwoE9s3j6om2rFb5WrO6sgJQdBpmR+BX6X5Q7u3qfq
         kVhQNsr0nytQbRZ9VvU5C9niMKMPXT8+D9iliN/A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Black <dankamongmen@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.19 191/271] Input: synaptics - whitelist Lenovo T580 SMBus intertouch
Date:   Wed, 24 Jul 2019 21:21:00 +0200
Message-Id: <20190724191711.475428348@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
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


