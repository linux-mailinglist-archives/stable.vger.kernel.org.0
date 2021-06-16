Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA8113A8E47
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 03:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231854AbhFPBZq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 21:25:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:40102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230265AbhFPBZp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 21:25:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D280961159;
        Wed, 16 Jun 2021 01:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623806620;
        bh=dGuK6Z9fTiEiwzM7arbMbx90t9BffJ9SG5/pKGr4ZdU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=KOmsg/nIAyZPO9+O95Hcmkcm20AauEDZdl1yT6O84ULHpcmfE//jn6ijxBhSaTkAa
         oTIeVm7Ww6wL6UfL456fyp9ET5LSTIVBYNKSuLLZ4Q18LkSNLZNpOeBOir8ejcKQrj
         H+OvJag2zZnl2IFMyjvbvLubKgEoaaljM9HO9G1Q=
Date:   Tue, 15 Jun 2021 18:23:39 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, keescook@chromium.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        vannguye@cisco.com
Subject:  [patch 09/18] mm/slub.c: include swab.h
Message-ID: <20210616012339.Z7kefWWvC%akpm@linux-foundation.org>
In-Reply-To: <20210615182248.9a0ba90e8e66b9f4a53c0d23@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/slub.c: include swab.h

Fixes build with CONFIG_SLAB_FREELIST_HARDENED=y.

Hopefully.  But it's the right thing to do anwyay.

Fixes: 1ad53d9fa3f61 ("slub: improve bit diffusion for freelist ptr obfuscation")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=213417
Reported-by: <vannguye@cisco.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/slub.c~mm-slubc-include-swabh
+++ a/mm/slub.c
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/bit_spinlock.h>
 #include <linux/interrupt.h>
+#include <linux/swab.h>
 #include <linux/bitops.h>
 #include <linux/slab.h>
 #include "slab.h"
_
