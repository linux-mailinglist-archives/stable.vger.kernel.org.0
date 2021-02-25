Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD65324CCB
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 10:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236272AbhBYJZc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 04:25:32 -0500
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:60255 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236302AbhBYJZN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 04:25:13 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 67702D5A;
        Thu, 25 Feb 2021 04:23:28 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 25 Feb 2021 04:23:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=m6ZmU5
        zFZv69SZcmgvTVT/iTNC7utPTfNGCtpLjT53c=; b=S7JAXVWZAm94UvN1xVjL4C
        FxL2uyFJgLGUAMXdS2LcKKZkOOIJ7eUKkRrO4volKXVJWPN3LgdSja1rfNvoG/In
        4Q0E2z8nJbQuY6KRK1B2DEeFjO4t9/QR/Z776XoUnFQgRRchBSTSXzZ3/Iy/kPzm
        NexM+r2BlLd/BkNicfjie8p6DYzhMtCcopvhujaKXUiTu//LuUL7OyxbOiKQmVkc
        XGEMBoeG0m27bXIuzWKzF501iVifNCOczbeQ41fLozEjRLxXdItQhCU6sDhsMRw6
        mQ+qE58wv5rd8WRypv4CgLb4V3DkAx/wCH3mYtGpPv0MpDydZOIozz+9sa1kPQMA
        ==
X-ME-Sender: <xms:j2w3YOW4MK6U1nwBI5_AT3i1__ERIWiQsP2tdkR9LxesuzSksUJXJQ>
    <xme:j2w3YCPT0m2EAPO4q5YKdw9nJSFsKp3f1B6U0S32lwEhgVplg-vQVgGVOoXUTNnR4
    BNMqBidqKR9BQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrkeelgddtfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    ejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeehgefguedvheejffeiheehuedvjeefhfegvefggedvue
    dufeevgeffuedvteelueenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:j2w3YABTIrlbibBRBHD7NuQzmFbuQvA8cRcesdcZhbLvmhod0nm_Zw>
    <xmx:j2w3YPcUvMFNQ3_IfjQ2gqqlxX7uJIVzTlavw67qUflCAKnVevWP6w>
    <xmx:j2w3YPP0h3KIoaDj_0vAP5YpL6OdUpAHlEYpWDztioBe3b4_UqJtGg>
    <xmx:kGw3YCTH41UzyXCldVSAiAZzwvRyRrB96MI6ukLztj0xADoa3cyEY0jMCxU>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id B8C1C1080059;
        Thu, 25 Feb 2021 04:23:27 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: Use kvm_pfn_t for local PFN variable in" failed to apply to 4.14-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 25 Feb 2021 10:23:25 +0100
Message-ID: <1614245005237128@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

