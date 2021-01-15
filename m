Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7C52F79C3
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733148AbhAOMjz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:39:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:47140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732208AbhAOMjz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:39:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C8892388B;
        Fri, 15 Jan 2021 12:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714379;
        bh=nApjn8g6UJqMaMmdKu79fHAUuDAx22QfZZRU4mFPUGM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tI13P/EpXExh6gQT9rK685QsP/Y1YdQMWwj8odeDm+WcHVAO/efVKSXKPrsLkFYuj
         mN64YBlUeJWdX/4+WOiyAb3EnKvYnNZ/B0bCSAFxIsufoBApukoJ6nfdtSbkMOpzzI
         nEQd1S87BV55EbFa3bbBuVtSDQNKwY9bxm/FE40U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Steven Price <steven.price@arm.com>
Subject: [PATCH 5.10 102/103] drm/panfrost: Remove unused variables in panfrost_job_close()
Date:   Fri, 15 Jan 2021 13:28:35 +0100
Message-Id: <20210115122010.933647257@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boris Brezillon <boris.brezillon@collabora.com>

commit 7d6763ab77b3c047cf7d31ca7c4b799808a684a6 upstream.

Commit a17d609e3e21 ("drm/panfrost: Don't corrupt the queue mutex on
open/close") left unused variables behind, thus generating a warning
at compilation time. Remove those variables.

Fixes: a17d609e3e21 ("drm/panfrost: Don't corrupt the queue mutex on open/close")
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201101173817.831769-1-boris.brezillon@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/panfrost/panfrost_job.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/gpu/drm/panfrost/panfrost_job.c
+++ b/drivers/gpu/drm/panfrost/panfrost_job.c
@@ -676,8 +676,6 @@ int panfrost_job_open(struct panfrost_fi
 
 void panfrost_job_close(struct panfrost_file_priv *panfrost_priv)
 {
-	struct panfrost_device *pfdev = panfrost_priv->pfdev;
-	struct panfrost_job_slot *js = pfdev->js;
 	int i;
 
 	for (i = 0; i < NUM_JOB_SLOTS; i++)


