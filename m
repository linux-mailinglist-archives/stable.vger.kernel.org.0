Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86F001E10AD
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 16:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390947AbgEYOjJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 10:39:09 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:47117 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390944AbgEYOjJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 May 2020 10:39:09 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 5FB951942863;
        Mon, 25 May 2020 10:39:08 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 25 May 2020 10:39:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=j2KvwR
        mzBGgCRkoZkG4uMPtc5d6+nBdA5kmN8hzkjPE=; b=WoXHTPBwTL5apmzzftQmDs
        31KplEqrGmIQcNZSULh4SgGfrN0e3txjzHT+3qm0s0wXpWmGcHN0W3S883wxazgF
        9B7FdC1WJ3xbPIrOmcscIMwN0ucIJ/O9KEjVVKjRqT2ZBmCy4x3Ji3dgyf2VXija
        +uyu2bVb2FO4KRKqLsG8soxmpQoV4Ikc60G7ebIsKsxe1n/v9GNTPtRc9+odkkk3
        ZyrG99wrYEoEz6TlY8pDqH6/1dwdjN5xy/2Rh5QJw+VA79CiIVfJHqvfLB9nQ1HF
        uXPhzsXtQ6WQh1Q5oYvHOq42zmj26RgHcqstdvn+R5Xq5P1fiqCJPw9cEiU/Oglw
        ==
X-ME-Sender: <xms:jNjLXpOL6xYVhk_GB7xZv6Gdma3GakIhkI3Whv-JinmnQ4gAJczMsw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvtddgjeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:jNjLXr-bKs_c1qSrw5cii15nF9ioeJ5_CTq9oA-Hmg-pms7dfLiSFA>
    <xmx:jNjLXoRChqrEzrSMmVQzbQDwckcoDcCup78LEpEkET90vhxnhTYAgA>
    <xmx:jNjLXltWgEkgVv26r91dawrGYxuOuTYNASAfmII41NHnR5FJjq11Ww>
    <xmx:jNjLXhGyq0pFRgicVtbJO7qthvzLM5JHyG_F3JJSLk764GoJaV13Sg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C62783280059;
        Mon, 25 May 2020 10:39:07 -0400 (EDT)
Subject: FAILED: patch "[PATCH] s390/kexec_file: fix initrd location for kdump kernel" failed to apply to 4.19-stable tree
To:     prudo@linux.ibm.com, borntraeger@de.ibm.com, gor@linux.ibm.com,
        lijiang@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 May 2020 16:39:06 +0200
Message-ID: <159041754611760@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 70b690547d5ea1a3d135a4cc39cd1e08246d0c3a Mon Sep 17 00:00:00 2001
From: Philipp Rudo <prudo@linux.ibm.com>
Date: Tue, 12 May 2020 19:39:56 +0200
Subject: [PATCH] s390/kexec_file: fix initrd location for kdump kernel

initrd_start must not point at the location the initrd is loaded into
the crashkernel memory but at the location it will be after the
crashkernel memory is swapped with the memory at 0.

Fixes: ee337f5469fd ("s390/kexec_file: Add crash support to image loader")
Reported-by: Lianbo Jiang <lijiang@redhat.com>
Signed-off-by: Philipp Rudo <prudo@linux.ibm.com>
Tested-by: Lianbo Jiang <lijiang@redhat.com>
Link: https://lore.kernel.org/r/20200512193956.15ae3f23@laptop2-ibm.local
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>

diff --git a/arch/s390/kernel/machine_kexec_file.c b/arch/s390/kernel/machine_kexec_file.c
index 8415ae7d2a23..f9e4baa64b67 100644
--- a/arch/s390/kernel/machine_kexec_file.c
+++ b/arch/s390/kernel/machine_kexec_file.c
@@ -151,7 +151,7 @@ static int kexec_file_add_initrd(struct kimage *image,
 		buf.mem += crashk_res.start;
 	buf.memsz = buf.bufsz;
 
-	data->parm->initrd_start = buf.mem;
+	data->parm->initrd_start = data->memsz;
 	data->parm->initrd_size = buf.memsz;
 	data->memsz += buf.memsz;
 

