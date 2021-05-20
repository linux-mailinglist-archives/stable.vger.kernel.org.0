Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC02D38AA1F
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235220AbhETLK1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:10:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:38332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238962AbhETLHd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:07:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CDB161D32;
        Thu, 20 May 2021 10:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505155;
        bh=HRUMB6cOx5+KzcuT3fAC1/OP5cgUpeEa455FMJJUnR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uyDjcrh3FZxgR67m5RmHTuMVdWzQTurJ2CGxwXpviMK6hQjj+uXBl2WSuYJLS7juT
         imgrbfG5qGFO9e4kdHTmA+sqUSioPva7pD9EoMiiLER0hSHSztgymlt6irU4C8n8g7
         1Di/A7PDHG7jX/eAb6s0HfybC39p5sqzWTIVZHaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Foley <pefoley2@pefoley.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 4.9 225/240] extcon: adc-jack: Fix incompatible pointer type warning
Date:   Thu, 20 May 2021 11:23:37 +0200
Message-Id: <20210520092116.266284298@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Foley <pefoley2@pefoley.com>

commit 8a522bf2d4f788306443d36b26b54f0aedcdfdbe upstream.

This patch fixes the incompatible warning of extcon-adc-jack.c driver
when calling devm_extcon_dev_allocate().

Signed-off-by: Peter Foley <pefoley2@pefoley.com>
[cw00.choi: Modify the patch title and descritpion]
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/extcon/extcon-adc-jack.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/extcon/extcon-adc-jack.h
+++ b/include/linux/extcon/extcon-adc-jack.h
@@ -59,7 +59,7 @@ struct adc_jack_pdata {
 	const char *name;
 	const char *consumer_channel;
 
-	const enum extcon *cable_names;
+	const unsigned int *cable_names;
 
 	/* The last entry's state should be 0 */
 	struct adc_jack_cond *adc_conditions;


