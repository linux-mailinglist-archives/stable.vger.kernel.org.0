Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84746188ECA
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 21:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgCQUPv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 16:15:51 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:49598 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726564AbgCQUPv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 16:15:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584476149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=pnH1OgGyKKIcIExYof5pKDmmKaw7f3bmIzTp8mo/bXA=;
        b=GRHRbCuwKytp2ybC5epTvsGRIWMlY1hKjRPECqGORG7iWPisQFH3mb/HCf0b87br5qdLdF
        yxIlFHjtB6gNIF36+/q445mPFLt1p1VlesFfvdxu72VkHmjVo0iQiiPHxFius8RK4Gziy8
        IPMIxdE0hyXLVJW+wkjM2Av1+w/33WA=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 4.9 0/3] batman-adv: Pending fixes; part 2
Date:   Tue, 17 Mar 2020 21:15:37 +0100
Message-Id: <20200317201540.23496-1-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I've already send a couple of missing patches for stable linux-4.9.y. But
I've noticed that there were some other ones which I skipped but which I now
saw while checking for missing patches in linux-4.4.y.

Kind regards,
        Sven

Matthias Schiffer (1):
  batman-adv: update data pointers after skb_cow()

Sven Eckelmann (2):
  batman-adv: Avoid probe ELP information leak
  batman-adv: Use explicit tvlv padding for ELP packets

 net/batman-adv/bat_v_elp.c | 12 ++++++++----
 net/batman-adv/routing.c   |  5 ++++-
 2 files changed, 12 insertions(+), 5 deletions(-)

-- 
2.20.1

