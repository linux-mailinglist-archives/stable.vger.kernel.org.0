Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 437CB31E1BA
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 23:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232967AbhBQWC2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 17:02:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232948AbhBQWCY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Feb 2021 17:02:24 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 885F2C061574
        for <stable@vger.kernel.org>; Wed, 17 Feb 2021 14:01:43 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id u14so148938wri.3
        for <stable@vger.kernel.org>; Wed, 17 Feb 2021 14:01:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9wDceaR9CPYrp3iYhTkbBxkKPqHvfmFEahLcfv+Atks=;
        b=HPKZbQ1qXgGtVTQFuwt2pDx4Ov8TmB1Y5QUGp9ImYjPvpxo7vCn8k8/EAD7PtTakq3
         FMnT2+4wXnSY76xDJiuFvtmb86mWx787ZvchJRxI9TvT75R5Z3RS+FOcYANTNcepIMi/
         FnPGUuIihwp5ZuXt4jkNFwJl9cRGt9xxN8DC46/6gBypQtNfdgiUEcpsi8LpRZi2BwJi
         oFsjGYVktUAajwsXKR683xw2Z4eM0TRLnV8i8SwY3YZQjf9kfpTIsSdWhaGWP5lgZvzm
         iIhBK9fyVY13bz7tJvIztpsmPk6fF1lNbBsK9NY8rnzZTqnq5uzPb+9FQi9+IUL4+rbd
         Z5WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9wDceaR9CPYrp3iYhTkbBxkKPqHvfmFEahLcfv+Atks=;
        b=ADJz5I163lHFzqzBZSavIrnT7G5aldFE23USaZBA42NmFmsvSddmM+NlFkdHqEh8rB
         Dc37WSJ1A1e401FDcmsJRdD6F3vlgmHYMxXCGxXmMm6S4L3x47ARL/oGAYPfXN8q2/JN
         GD5mKoS5tsJVz8x1u0zyYwXouyMkKLHgl8cZPcq+0Rc1+Mfu5DLMuMQKocElEPq2Ctr/
         PGANc77rLwTPeOJxLuHbHSwlyJHW1zaDbpa63Dvpcsl5uKqftzo9DmGugJ7cTOS5kNxd
         VwWXrxvAQdBe54L4pzrVAo+XGAXrQVdDCdt3wz4oGC0sjre6mIXPakjhUWSpolJqBoG3
         Mpfw==
X-Gm-Message-State: AOAM5302aC5hpVqb+dGxPx9G0wUZikSQrZ0kuishlZefX3w+pcw1HQHu
        s91RjPMmnjeQn4p2YEoklimY6rz6JR7Eug==
X-Google-Smtp-Source: ABdhPJyChUeEWs9n4Aliy703gDfkdOJtjolHhcK8XW4oQE46l4oeGaG9DPXaQeJw0FHp39yIaBl/NQ==
X-Received: by 2002:a5d:47a2:: with SMTP id 2mr1139179wrb.393.1613599302209;
        Wed, 17 Feb 2021 14:01:42 -0800 (PST)
Received: from debian (host-2-98-59-96.as13285.net. [2.98.59.96])
        by smtp.gmail.com with ESMTPSA id v1sm4810031wmj.31.2021.02.17.14.01.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 14:01:41 -0800 (PST)
Date:   Wed, 17 Feb 2021 22:01:40 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     laijs@linux.alibaba.com, pbonzini@redhat.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] kvm: check tlbs_dirty directly" failed to
 apply to 4.14-stable tree
Message-ID: <YC2SRG41YJD29sq5@debian>
References: <161035498424207@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="+F4toEKGQzHabFKT"
Content-Disposition: inline
In-Reply-To: <161035498424207@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--+F4toEKGQzHabFKT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Jan 11, 2021 at 09:49:44AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport, will apply to all branches till 4.4-stable.

--
Regards
Sudip

--+F4toEKGQzHabFKT
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-kvm-check-tlbs_dirty-directly.patch"

From 6a75cb89e3e75fa825fdf866ea9c0632423f3f6f Mon Sep 17 00:00:00 2001
From: Lai Jiangshan <laijs@linux.alibaba.com>
Date: Thu, 17 Dec 2020 23:41:18 +0800
Subject: [PATCH] kvm: check tlbs_dirty directly

commit 88bf56d04bc3564542049ec4ec168a8b60d0b48c upstream

In kvm_mmu_notifier_invalidate_range_start(), tlbs_dirty is used as:
        need_tlb_flush |= kvm->tlbs_dirty;
with need_tlb_flush's type being int and tlbs_dirty's type being long.

It means that tlbs_dirty is always used as int and the higher 32 bits
is useless.  We need to check tlbs_dirty in a correct way and this
change checks it directly without propagating it to need_tlb_flush.

Note: it's _extremely_ unlikely this neglecting of higher 32 bits can
cause problems in practice.  It would require encountering tlbs_dirty
on a 4 billion count boundary, and KVM would need to be using shadow
paging or be running a nested guest.

Cc: stable@vger.kernel.org
Fixes: a4ee1ca4a36e ("KVM: MMU: delay flush all tlbs on sync_page path")
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
Message-Id: <20201217154118.16497-1-jiangshanlai@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 virt/kvm/kvm_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c1ca4d40157b..547ae59199db 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -382,9 +382,8 @@ static void kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 	 */
 	kvm->mmu_notifier_count++;
 	need_tlb_flush = kvm_unmap_hva_range(kvm, start, end);
-	need_tlb_flush |= kvm->tlbs_dirty;
 	/* we've to flush the tlb before the pages can be freed */
-	if (need_tlb_flush)
+	if (need_tlb_flush || kvm->tlbs_dirty)
 		kvm_flush_remote_tlbs(kvm);
 
 	spin_unlock(&kvm->mmu_lock);
-- 
2.30.0


--+F4toEKGQzHabFKT--
