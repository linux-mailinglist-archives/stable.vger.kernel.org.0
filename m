Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E240157525
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729288AbgBJMjA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:39:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:35750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729283AbgBJMjA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:39:00 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 596B221739;
        Mon, 10 Feb 2020 12:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338339;
        bh=b5E0seDSw/2qSo6zYqvtGmYLu55ZAeyA2xmwOUaLTtg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=spMcXgq+jFmFH4sNMcBUrq+b6/IXX5ZndSvRv0anG6rWykzUNMQnUCMj7rEdXAjKp
         B0yU7lBRRdsMIDdXn6aAKmmBByBY7GRNwnfPW2w/Oeow66gOPOX1S47x0K3wzUfBjM
         VIlUwgnXwJVaw2UgEzoxDqabedoLFoVapdyWwvDI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Kemnade <andreas@kemnade.info>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 5.4 289/309] mfd: rn5t618: Mark ADC control register volatile
Date:   Mon, 10 Feb 2020 04:34:05 -0800
Message-Id: <20200210122434.450710665@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
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
@@ -26,6 +26,7 @@ static bool rn5t618_volatile_reg(struct
 	case RN5T618_WATCHDOGCNT:
 	case RN5T618_DCIRQ:
 	case RN5T618_ILIMDATAH ... RN5T618_AIN0DATAL:
+	case RN5T618_ADCCNT3:
 	case RN5T618_IR_ADC1 ... RN5T618_IR_ADC3:
 	case RN5T618_IR_GPR:
 	case RN5T618_IR_GPF:


