Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC0D728899
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390913AbfEWT10 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:27:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:39684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389939AbfEWT10 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:27:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 249DB20879;
        Thu, 23 May 2019 19:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639645;
        bh=10XOMHYCtBXmq82im8ODiqLdbIgJIm8C3wPIzJ3hL1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tBjax0zV/Ck8DK0DtBRM1uGmv5DsfmjFzA43niRYdY6vIu/2HnJtLId9G7E0pDzb3
         lAGTOusbcwh84yDevB47RgB7k9AIGarCV9iegTDp59zUmjxLObhcERya+nLcHUsW8k
         B2mxGAIJnmOvwclP7dJ3ldllV+eE60dh5YEQfH+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: [PATCH 5.1 026/122] parisc: Export running_on_qemu symbol for modules
Date:   Thu, 23 May 2019 21:05:48 +0200
Message-Id: <20190523181708.277648207@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181705.091418060@linuxfoundation.org>
References: <20190523181705.091418060@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit 3e1120f4b57bc12437048494ab56648edaa5b57d upstream.

Signed-off-by: Helge Deller <deller@gmx.de>
CC: stable@vger.kernel.org # v4.9+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/kernel/process.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/parisc/kernel/process.c
+++ b/arch/parisc/kernel/process.c
@@ -193,6 +193,7 @@ int dump_task_fpu (struct task_struct *t
  */
 
 int running_on_qemu __read_mostly;
+EXPORT_SYMBOL(running_on_qemu);
 
 void __cpuidle arch_cpu_idle_dead(void)
 {


