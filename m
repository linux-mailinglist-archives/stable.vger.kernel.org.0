Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19CAB324CCA
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 10:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236283AbhBYJZa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 04:25:30 -0500
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:41463 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236272AbhBYJZN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 04:25:13 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 20C96475;
        Thu, 25 Feb 2021 04:23:30 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 25 Feb 2021 04:23:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=oVrC2V
        eENGD28w1HnlNQRyj2HjbwCp8R7VmywrFx99w=; b=F9/Xed3soskVFOxz4dlTqt
        Fo7D4Y7PjxeshgTjiCRMnbGGqWXpTFPll75PMNtIJ1rT4gwqgDGC+Y3P0X0bhKWu
        G/H5BLcMTTEs7dnsoU31DPmChukpOQZsrHetKPOrNx2k8+snc80jb2bdmNmcG5lS
        Q3xvLheAxlaZmtxTRzVo7gvWQ5sd9Ejy5pmXZ0snbKK5PhyVrTlgw06+9vPQGspt
        o9k+PXCYcZIOfLKta8eVCszUZS3hRrIcCsVgQr1Z0xGCcz/1/BfuAzLeAYdnghES
        Zhy9eKU2cCpD5JeuZjaStuDjaICJWFsCsClQr59EfnI6Hw3l7pPTeSecG+bvchZA
        ==
X-ME-Sender: <xms:kWw3YKaR0OOKPbZfrfz73X5N2tZGZfYlfrHPP48zlOnrEC8Ys-gUjQ>
    <xme:kWw3YLM10XTUym5UrXuXOGTmng3rhkI5dnxSTW-lbdHDvRTu78gRuYQ9U7Mv_zcIe
    I6Sf1rv_7Di_Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrkeelgddtfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    ejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeehgefguedvheejffeiheehuedvjeefhfegvefggedvue
    dufeevgeffuedvteelueenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:kWw3YPbklxu-gNDdZfaZnmgIo9Dkrdk4leLy14q9auW0NIlPL7tDIQ>
    <xmx:kWw3YJ3Ov-yZoiSCf21724tadPPqRJfFBbhbkX-oiY2LhYOXJgqalA>
    <xmx:kWw3YFca80cfODwEffNipPeZnawYAshphu5uXYDjlq_gszKmOyECxQ>
    <xmx:kWw3YPm8CiYpM3KgkeydS5Cj05KaLtukh4884yemcmrb4RGpm3sTYPPQNzg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6FADD24005C;
        Thu, 25 Feb 2021 04:23:29 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: Use kvm_pfn_t for local PFN variable in" failed to apply to 4.19-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 25 Feb 2021 10:23:26 +0100
Message-ID: <161424500622955@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a9545779ee9e9e103648f6f2552e73cfe808d0f4 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Mon, 8 Feb 2021 12:19:40 -0800
Subject: [PATCH] KVM: Use kvm_pfn_t for local PFN variable in
 hva_to_pfn_remapped()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Use kvm_pfn_t, a.k.a. u64, for the local 'pfn' variable when retrieving
a so called "remapped" hva/pfn pair.  In theory, the hva could resolve to
a pfn in high memory on a 32-bit kernel.

This bug was inadvertantly exposed by commit bd2fae8da794 ("KVM: do not
assume PTE is writable after follow_pfn"), which added an error PFN value
to the mix, causing gcc to comlain about overflowing the unsigned long.

  arch/x86/kvm/../../../virt/kvm/kvm_main.c: In function ‘hva_to_pfn_remapped’:
  include/linux/kvm_host.h:89:30: error: conversion from ‘long long unsigned int’
                                  to ‘long unsigned int’ changes value from
                                  ‘9218868437227405314’ to ‘2’ [-Werror=overflow]
   89 | #define KVM_PFN_ERR_RO_FAULT (KVM_PFN_ERR_MASK + 2)
      |                              ^
virt/kvm/kvm_main.c:1935:9: note: in expansion of macro ‘KVM_PFN_ERR_RO_FAULT’

Cc: stable@vger.kernel.org
Fixes: add6a0cd1c5b ("KVM: MMU: try to fix up page faults before giving up")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210208201940.1258328-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ee4ac2618ec5..001b9de4e727 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1906,7 +1906,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 			       bool write_fault, bool *writable,
 			       kvm_pfn_t *p_pfn)
 {
-	unsigned long pfn;
+	kvm_pfn_t pfn;
 	pte_t *ptep;
 	spinlock_t *ptl;
 	int r;

