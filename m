Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 289082E3688
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 12:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727294AbgL1LeZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 06:34:25 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:37517 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727287AbgL1LeZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 06:34:25 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 5586978C;
        Mon, 28 Dec 2020 06:33:19 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 06:33:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Y0yWow
        v647zadS7ppd9JipqLsXtW8k6e0ImCn821+lI=; b=YaOgDP3zGHuMXzXQT9NqoO
        6ounJmUc7W4uXo9kxN53422kWM3wguMLOQfSUAiRDo3x/FF1fcou6wDMwdD7Ow5u
        SQex/vf67C2G5nMobzjoeJdEuvT4PdM/6ACoM27UxWvanLDtlKWPNokfULYGy0OD
        kkAOGIicTNv6LRFJ7pQcOm4NBRUtGrMswuu9XglBWGpRgGGFwcJrb+xJkpbOCvDN
        K7DEdUb4igRhaJ/e3WXnqee7KZfHMAhWMEt/PFHeZHZbzA0yu8fipwBYBdyzRyzO
        UlWSlrqcvna0u3GP3ea46ezXcLgZP6Nb8Hqi1j4iK7bTVIk/GDPnjJ+85wmdNWcA
        ==
X-ME-Sender: <xms:fsLpXyX0XXdMTDQuPSFhJaBq5koW1oSAzujq6iOcDglY9GnyEEiwNw>
    <xme:fsLpX-lNbKxiLG6w2X6KVxzUeLzwyewIEf62TgV5HF4hAnFXw_7YF5gRwjc70q0I3
    A22mEvcp3lA9g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgfeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepvdffgeejjeeitdeiffejieejfffghedviedujeehfe
    egvefhhfevvdefueehkeelnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:fsLpX2baSJD5iMWBegK4nykKMMiodP2781Wf8qbXGqWB67Nama00Tw>
    <xmx:fsLpX5UNKPIlQio4DSmaoB054U14bSPPj4MUf-lJ6ZyxWyYNy5NE_w>
    <xmx:fsLpX8lq4Q7o2O10290I5OMLGKu5ibJhIivArG7Q1YdpPQfMjppt2g>
    <xmx:fsLpX4tWebQP5C0Y52shXAkOV0S6nD7i63sRDlwYPL2G0oymApSYMEOzEaI>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id A145D240057;
        Mon, 28 Dec 2020 06:33:18 -0500 (EST)
Subject: FAILED: patch "[PATCH] dma-buf/dma-resv: Respect num_fences when initializing the" failed to apply to 4.19-stable tree
To:     maarten.lankhorst@linux.intel.com,
        niranjana.vishwanathapura@intel.com, stable@vger.kernel.org,
        thomas.hellstrom@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 12:18:40 +0100
Message-ID: <16091543202457@kroah.com>
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

From bf8975837dac156c33a4d15d46602700998cb6dd Mon Sep 17 00:00:00 2001
From: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Date: Tue, 24 Nov 2020 12:57:07 +0100
Subject: [PATCH] dma-buf/dma-resv: Respect num_fences when initializing the
 shared fence list.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

We hardcode the maximum number of shared fences to 4, instead of
respecting num_fences. Use a minimum of 4, but more if num_fences
is higher.

This seems to have been an oversight when first implementing the
api.

Fixes: 04a5faa8cbe5 ("reservation: update api and add some helpers")
Cc: <stable@vger.kernel.org> # v3.17+
Reported-by: Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201124115707.406917-1-maarten.lankhorst@linux.intel.com

diff --git a/drivers/dma-buf/dma-resv.c b/drivers/dma-buf/dma-resv.c
index bb5a42b10c29..6ddbeb5dfbf6 100644
--- a/drivers/dma-buf/dma-resv.c
+++ b/drivers/dma-buf/dma-resv.c
@@ -200,7 +200,7 @@ int dma_resv_reserve_shared(struct dma_resv *obj, unsigned int num_fences)
 			max = max(old->shared_count + num_fences,
 				  old->shared_max * 2);
 	} else {
-		max = 4;
+		max = max(4ul, roundup_pow_of_two(num_fences));
 	}
 
 	new = dma_resv_list_alloc(max);

