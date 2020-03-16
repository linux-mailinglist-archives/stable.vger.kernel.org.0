Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5DB218758C
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 23:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732747AbgCPWaw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 18:30:52 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:48852 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732652AbgCPWav (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 18:30:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584397848;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=jD3597mPc2KA0v/5GFwUXUnxZ4EqoPgX3emGCY04tl0=;
        b=yUV0Ql+pivQGpB1XfLx9QXZHce6Yps0BwWF5DPf4UCskJrGnOOYfW8F5ezpNEuw/A2bOGj
        LBDfJfQ3w3DfFX5Blv+imkjnUryYG2S45Y/QzS3jdu+HLW0UxBhYITkRxCc3Osn7FKuTCr
        v/OMQwc4WIGyPPHQyi1dJvtjxSyUgng=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 4.14 00/15] batman-adv: Pending fixes
Date:   Mon, 16 Mar 2020 23:30:17 +0100
Message-Id: <20200316223032.6236-1-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I was asked by Greg KH to check for missing fixes in linux 4.14.y and provide
backports for it. I've ended up with a lot more missing patches than
I've expected. Not sure why these were missing but I couldn't find them at
the moment in any stable release for 4.14.y. Feel free to check for things
which I've missed too.

Kind regards,
	Sven

Linus Lüssing (1):
  batman-adv: Fix TT sync flags for intermediate TT responses

Marek Lindner (1):
  batman-adv: prevent TT request storms by not sending inconsistent TT
    TLVLs

Matthias Schiffer (1):
  batman-adv: update data pointers after skb_cow()

Sven Eckelmann (12):
  batman-adv: Avoid spurious warnings from bat_v neigh_cmp
    implementation
  batman-adv: Always initialize fragment header priority
  batman-adv: Fix check of retrieved orig_gw in batadv_v_gw_is_eligible
  batman-adv: Fix lock for ogm cnt access in batadv_iv_ogm_calc_tq
  batman-adv: Fix internal interface indices types
  batman-adv: Avoid race in TT TVLV allocator helper
  batman-adv: Fix debugfs path for renamed hardif
  batman-adv: Fix debugfs path for renamed softif
  batman-adv: Fix duplicated OGMs on NETDEV_UP
  batman-adv: Avoid free/alloc race when handling OGM2 buffer
  batman-adv: Avoid free/alloc race when handling OGM buffer
  batman-adv: Don't schedule OGM for disabled interface

 net/batman-adv/bat_iv_ogm.c        | 94 +++++++++++++++++++++++-------
 net/batman-adv/bat_v.c             | 11 ++--
 net/batman-adv/bat_v_ogm.c         | 42 ++++++++++---
 net/batman-adv/debugfs.c           | 46 ++++++++++++++-
 net/batman-adv/debugfs.h           | 11 ++++
 net/batman-adv/fragmentation.c     |  2 +
 net/batman-adv/hard-interface.c    | 51 +++++++++++++---
 net/batman-adv/originator.c        |  4 +-
 net/batman-adv/originator.h        |  4 +-
 net/batman-adv/routing.c           | 10 ++--
 net/batman-adv/translation-table.c | 84 ++++++++++++++++++++------
 net/batman-adv/types.h             | 18 ++++--
 12 files changed, 301 insertions(+), 76 deletions(-)

-- 
2.20.1

