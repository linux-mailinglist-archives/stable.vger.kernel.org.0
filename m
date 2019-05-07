Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C517F15CCD
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 08:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbfEGGHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 02:07:13 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41418 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726576AbfEGGHM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 02:07:12 -0400
Received: by mail-wr1-f65.google.com with SMTP id c12so20432739wrt.8
        for <stable@vger.kernel.org>; Mon, 06 May 2019 23:07:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=9TmCafgXOhlH8RMOfH8q5x+Ucc2E78Z2c8fQjMQCVpw=;
        b=Ik1Jh5uiCMljVBTvHbej8wxjsXUUh9q1rmHAjHg++m/85sI3TYNmJGEvWMLkQeo9I/
         D3FPAZk/I/6myEpWI9bWw0J/tLzCaoH1RMDDGdeirpjRdiGuVVFc1uACOiMbPFrmG8yi
         AUF7HFweejEyKJ5NDjiL4dniT9188LH6rJCcRqBhYnLrJBDk3CIh4ieYefZ8MrQEAdM1
         pPM0TmPavMNfnLw3OKt1FHTJfu70FAfeoelEoc1ysz2qc+A5pVDUmCExbLJIvBOiFn5h
         XEC775VWJEb+d3MaBquuCq74xESHUvnpR4dhLy3EmiDOdPGP+nScPHWIBT2FaLLDGaGO
         wp6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:subject:message-id
         :mime-version:content-disposition:user-agent;
        bh=9TmCafgXOhlH8RMOfH8q5x+Ucc2E78Z2c8fQjMQCVpw=;
        b=fpaj7RmAqgPe+5Cc3DEEnp/avwH/FvLTOBVfo7e739QJM+AXW6VxN6HMWPMf33yOVL
         paUn2NeT0GD0TbMaHLA6OZi1U/7t7wJb02XHHZcuYgQ2+jjTvigsPG5ss2KC9RwLsMqD
         Cv29qxmy81FOhb+B8LsAz8NmFmNXwN8XQr9YT6u8g6eYAJtuMZ2cWWxTaYJhXixk5sG5
         QUBaLQY2/LsUt6eTynsCVxjjGrVbrBdL/8RaigtjS1ennZKGZTU2p48XPHD/B+7QySR5
         G/gTITAgu/9H3oDWl9+UPA3P2fs88SSXsJWkgd0N2L+IadWnTru3Y+kK7o77/BcjB5GI
         IROQ==
X-Gm-Message-State: APjAAAVzUAvl8MmFeYHdoGq9GnqJUnNa2b/qZCmQj2jkwGsMQXuKdypw
        4vdPwfBHQLQiF8bu928pHU4Hb2NW
X-Google-Smtp-Source: APXvYqxvB1NSmU+lbB1Ef74uvhPQ0z+czACbBzPRjnIK1U07SElu6FKhl1ECPyz+43LndTA/FWG/Bw==
X-Received: by 2002:adf:ce8e:: with SMTP id r14mr3993312wrn.289.1557209230817;
        Mon, 06 May 2019 23:07:10 -0700 (PDT)
Received: from gmail.com (2E8B0CD5.catv.pool.telekom.hu. [46.139.12.213])
        by smtp.gmail.com with ESMTPSA id 17sm14290117wrk.91.2019.05.06.23.07.09
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 06 May 2019 23:07:10 -0700 (PDT)
Date:   Tue, 7 May 2019 08:07:08 +0200
From:   Ingo Molnar <mingo@kernel.org>
To:     stable kernel team <stable@vger.kernel.org>
Subject: [PATCH] genirq: Prevent use-after-free and work list corruption]
Message-ID: <20190507060708.GA75860@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hi Greg,

We forgot to mark 59c39840f5abf4a71e1 for -stable, please apply. It 
should apply cleanly all the way back to v3.0.

Thanks,

	Ingo

----- Forwarded message from tip-bot for Prasad Sodagudi <tipbot@zytor.com> -----

Date: Sun, 24 Mar 2019 14:16:45 -0700
From: tip-bot for Prasad Sodagudi <tipbot@zytor.com>
To: linux-tip-commits@vger.kernel.org
Cc: mingo@kernel.org, hpa@zytor.com, psodagud@codeaurora.org, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [tip:irq/core] genirq: Prevent use-after-free and work list corruption

Commit-ID:  59c39840f5abf4a71e1810a8da71aaccd6c17d26
Gitweb:     https://git.kernel.org/tip/59c39840f5abf4a71e1810a8da71aaccd6c17d26
Author:     Prasad Sodagudi <psodagud@codeaurora.org>
AuthorDate: Sun, 24 Mar 2019 07:57:04 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sun, 24 Mar 2019 22:13:17 +0100

genirq: Prevent use-after-free and work list corruption

When irq_set_affinity_notifier() replaces the notifier, then the
reference count on the old notifier is dropped which causes it to be
freed. But nothing ensures that the old notifier is not longer queued
in the work list. If it is queued this results in a use after free and
possibly in work list corruption.

Ensure that the work is canceled before the reference is dropped.

Signed-off-by: Prasad Sodagudi <psodagud@codeaurora.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: marc.zyngier@arm.com
Link: https://lkml.kernel.org/r/1553439424-6529-1-git-send-email-psodagud@codeaurora.org

---
 kernel/irq/manage.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 1401afa0d58a..53a081392115 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -357,8 +357,10 @@ irq_set_affinity_notifier(unsigned int irq, struct irq_affinity_notify *notify)
 	desc->affinity_notify = notify;
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 
-	if (old_notify)
+	if (old_notify) {
+		cancel_work_sync(&old_notify->work);
 		kref_put(&old_notify->kref, old_notify->release);
+	}
 
 	return 0;
 }

----- End forwarded message -----
