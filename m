Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32D5015C73B
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387688AbgBMQI3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 11:08:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:33382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728242AbgBMPXF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:23:05 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 198DF24689;
        Thu, 13 Feb 2020 15:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607385;
        bh=RVMrRn/672904ZJ9LKWHjuRWZYknUEX76x2QFpM7TLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y5ablhpWrHtidkRx4+d2eMVDlw9DZo8DJs0ce3SlBl1dAYR+93vEVZnWY/b7XsT4/
         4QZ5Bd/B7PBd7tGSR2pQpfCFpQCSAi3wd8RCF+RjHqGomGK9pvtNQL0BJnjYkdUW84
         s7pfkhg5IJ/57uf6McnlZOiyR0CUsLjDJxHk5TCw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Kemnade <andreas@kemnade.info>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.4 57/91] mfd: rn5t618: Mark ADC control register volatile
Date:   Thu, 13 Feb 2020 07:20:14 -0800
Message-Id: <20200213151843.961727486@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151821.384445454@linuxfoundation.org>
References: <20200213151821.384445454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Kemnade <andreas@kemnade.info>

commit 2f3dc25c0118de03a00ddc88b61f7216854f534d upstream.

There is a bit which gets cleared after conversion.

Fixes: 9bb9e29c78f8 ("mfd: Add Ricoh RN5T618 PMIC core driver")
Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mfd/rn5t618.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mfd/rn5t618.c
+++ b/drivers/mfd/rn5t618.c
@@ -28,6 +28,7 @@ static bool rn5t618_volatile_reg(struct
 	case RN5T618_WATCHDOGCNT:
 	case RN5T618_DCIRQ:
 	case RN5T618_ILIMDATAH ... RN5T618_AIN0DATAL:
+	case RN5T618_ADCCNT3:
 	case RN5T618_IR_ADC1 ... RN5T618_IR_ADC3:
 	case RN5T618_IR_GPR:
 	case RN5T618_IR_GPF:


