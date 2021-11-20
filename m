Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADB58457E65
	for <lists+stable@lfdr.de>; Sat, 20 Nov 2021 13:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237239AbhKTMoE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Nov 2021 07:44:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237231AbhKTMoE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Nov 2021 07:44:04 -0500
Received: from dvalin.narfation.org (dvalin.narfation.org [IPv6:2a00:17d8:100::8b1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C93C061574
        for <stable@vger.kernel.org>; Sat, 20 Nov 2021 04:41:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1637412060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=t7wbxovLoX7LRwlLOel7o2Ymj+dtVX9lRg/4gewPTQk=;
        b=1r5RT5rWdN4r6tse23U/puZ/UqDahbQaUyy3Pew9hKKnmd3AYVAjxI7pdPKrEDUwHWjI46
        2Vo8RPA27yju39rbn1WYdjdDo0jqKBVO4o5G+l20zm1tVI0OPXMl5QGzq8tKCRxu+WM1Bi
        bTbspJfiwaCCHgQJmgzHa3rfzr1hpfY=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 5.4 0/3] batman-adv: Fixes for stable/linux-4.19.y
Date:   Sat, 20 Nov 2021 13:40:50 +0100
Message-Id: <20211120124053.261156-1-sven@narfation.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I went through  all changes in batman-adv since v4.19 with a Fixes: line
and checked whether they were backported to the LTS kernels. The ones which
weren't ported and applied to this branch are now part of this patch series.

For this kernel version, I only found following three patches:

* batman-adv: Consider fragmentation for needed_headroom
* batman-adv: Reserve needed_*room for fragments
* batman-adv: Don't always reallocate the fragmentation skb head

which could in some circumstances cause packet loss but which were created
to fix high CPU load/low throughput problems. But I've added them here
anyway because the corresponding VXLAN patches were also added to stable.
And some stable kernels also got these fixes a while back.

Kind regards,
	Sven

Sven Eckelmann (3):
  batman-adv: Consider fragmentation for needed_headroom
  batman-adv: Reserve needed_*room for fragments
  batman-adv: Don't always reallocate the fragmentation skb head

 net/batman-adv/fragmentation.c  | 26 ++++++++++++++++----------
 net/batman-adv/hard-interface.c |  3 +++
 2 files changed, 19 insertions(+), 10 deletions(-)

-- 
2.30.2

