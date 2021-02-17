Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5C7031E1B7
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 23:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232779AbhBQWBB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 17:01:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbhBQWBA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Feb 2021 17:01:00 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78322C061574
        for <stable@vger.kernel.org>; Wed, 17 Feb 2021 14:00:20 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id n10so5541682wmq.0
        for <stable@vger.kernel.org>; Wed, 17 Feb 2021 14:00:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fLI9oZNu+12Xvkm2nxViLd7lQtrpZHX3oNGnaOTKy/8=;
        b=Cu3DmpKHZIHIynVxtH9JAZC2OqzHZ1/nlbejVmzNMezEUQMSgO850pndpn+OI5OsVc
         oaAOho+ClRH2gO53TMYr7JFYNDAOBrXF2179kDqdRFcptYAliZA454UgR8oQPRQGi/1l
         hzRK8kgYID4csx9eBgEuW10mTHMVsPjBavbOX+8msTNenFY/8kMLKOcCjenyrAE1Spnc
         Wgfgw2CY6FXWkfvKHgMOQ2BVT6Wzd+o8/kxuq+laHqC5GDK2AHnY4WTUPOP1U/bt4+Zp
         MUxrsvxzdzoQGojO1dMTFL2ds1BvC1Sd17U3Y5yjBAM8KGv/e0yHOXhwejxhd/Ds42Al
         oPrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fLI9oZNu+12Xvkm2nxViLd7lQtrpZHX3oNGnaOTKy/8=;
        b=NkeZu8pqtp/Xv2yIwoUnfVqXfHB86V722Z3Fj32WmhIWPFSbxWaK3apge5vSBS4CCt
         PAFA4TxSXrYEWx4lxNiCUIDT04UUwWJCeGmg+FQVRoLTT5YXIxPQNwp5dcmMufR+sC22
         SdMTJzi1wa/jAVRWxKca+YFTVEo1kD/aN2dhxUlS+7cZyK0tqGbRRZpXrv1y8Du+KQZ0
         s/LeZyswwEqQGywvFO9aNfS+nAwChzNtgyH2JoDOIETC6Ps6J64YcfsvT88wRPVa2FFj
         Hx8OQ3AEKRATZKuKXYpWAobogYRQO+z6eGibgwKM4jUDsmbefTE9gZcAU8kyI6Bz34d0
         o98A==
X-Gm-Message-State: AOAM530kYLWVXEbkX01CNTXCClJfhCSIfjtLJTjcDvweO2hRyrwu/dTV
        7Fe/ZKrlf/Ig6WVOsydbqI1haaMsDnGOcQ==
X-Google-Smtp-Source: ABdhPJzUOlZhCdk+KXsd1lOMOxtTe+qt0atKKclgjvvcwFVObWhVdF4Qy8t8PKHhDG2enBm6wfnPUA==
X-Received: by 2002:a05:600c:430b:: with SMTP id p11mr771454wme.29.1613599218841;
        Wed, 17 Feb 2021 14:00:18 -0800 (PST)
Received: from debian (host-2-98-59-96.as13285.net. [2.98.59.96])
        by smtp.gmail.com with ESMTPSA id u4sm5575434wrr.37.2021.02.17.14.00.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 14:00:18 -0800 (PST)
Date:   Wed, 17 Feb 2021 22:00:16 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     laijs@linux.alibaba.com, pbonzini@redhat.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] kvm: check tlbs_dirty directly" failed to
 apply to 4.19-stable tree
Message-ID: <YC2R8C+B44jy70LP@debian>
References: <1610354985142194@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="VWHgY4RwVqrINEdd"
Content-Disposition: inline
In-Reply-To: <1610354985142194@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--VWHgY4RwVqrINEdd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Jan 11, 2021 at 09:49:45AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport.

--
Regards
Sudip

--VWHgY4RwVqrINEdd
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-kvm-check-tlbs_dirty-directly.patch"

From 17a6138c90d0816bb02f35a2600ffb67a00f64f7 Mon Sep 17 00:00:00 2001
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
index 9312c7e750ed..1ecb27b3421a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -412,9 +412,8 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 	 */
 	kvm->mmu_notifier_count++;
 	need_tlb_flush = kvm_unmap_hva_range(kvm, start, end, blockable);
-	need_tlb_flush |= kvm->tlbs_dirty;
 	/* we've to flush the tlb before the pages can be freed */
-	if (need_tlb_flush)
+	if (need_tlb_flush || kvm->tlbs_dirty)
 		kvm_flush_remote_tlbs(kvm);
 
 	spin_unlock(&kvm->mmu_lock);
-- 
2.30.0


--VWHgY4RwVqrINEdd--
