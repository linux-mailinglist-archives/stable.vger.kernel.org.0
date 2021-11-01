Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28466441D0B
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 16:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbhKAPER (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 11:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbhKAPER (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Nov 2021 11:04:17 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D57C061714;
        Mon,  1 Nov 2021 08:01:44 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id k29so11362529qve.6;
        Mon, 01 Nov 2021 08:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aV4ZtZ43VwnKsLkvPobGjH+Nu8TCZDHl/55S1ia5M+k=;
        b=TZcU7SXQ8ZWXRZdvOEo4mPKuugCOTEgtIHx2GhsmzTE/f4FXu3nAr2gM4RtudQsEni
         G5K/U1+GHH8zQNoYMxSluGXrJM0O6hiORlhUnkOjHY3XRSVCSDtW3U3c7Y7FqM9FhUB1
         ngBzAZS58Xn+OvMQLht6fQhvdJd1YJca8Z80I8+gqrXTCkTKX2gn0IPTr3FqMyARV8bd
         xKbJMh9IaNk9UqFPdfll9oxcZ7CMKN5PmO2IgVJJqSuErbMVmvT8+aDvmYRC/ndz5Tra
         tKLbGXb3lh4Kw+j0BYC6nef3jnQmm8hUXUiZ25CHdXWOHtfdRihwioMl2pz+iECECt55
         0ugw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aV4ZtZ43VwnKsLkvPobGjH+Nu8TCZDHl/55S1ia5M+k=;
        b=0QSj3at7wxaCv8Tn1Phl+rGo+/2jth4+7sXHKEK5hodcQuOoMmBi8gcSZ9fg5/UMY3
         kaNxcxKK4/O82qo+a1cydyk0ZeyRiZv8hctLTasW+qBFiDc+YOoKWqPRgHoZtRw/An0A
         x6mlAD1EJO5k3qQek0BRfCGDBIoQc1uJz+MdrPwBl8HJg0LeGuf4xF6OY7+7aJfRiVf5
         8kPpBZsIw9J/l4PFV0ZoJtu6pPE49+fuc4gP0QzRdH9GTwab6ZNxAxw1uNjtPwhHBmMl
         LRxlzxxSA8YMju/tJbUG4uekBpz2n7SMKT65Xyi//sKxHnuL+UjFiz0YeUiJpShMuCuQ
         96sg==
X-Gm-Message-State: AOAM532Hp7Sx3dPdSulmsdq+vBckAoNbPc9GTw+ryaaiVq4cj7Knqks0
        ckGaqI4dWnNK9L+6zOl5A0l0ibLYIJ8VEA==
X-Google-Smtp-Source: ABdhPJydnnII8W6NLEylduFVpzQ4Ebzi0oqbW3RHIuVmh0lW6/rXr3t3WGK1A25a2vS6N+6haL+9JQ==
X-Received: by 2002:a05:6214:e4a:: with SMTP id o10mr29317718qvc.58.1635778892866;
        Mon, 01 Nov 2021 08:01:32 -0700 (PDT)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id d19sm9183141qty.26.2021.11.01.08.01.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 08:01:31 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailauth.nyi.internal (Postfix) with ESMTP id A8BCB27C005A;
        Mon,  1 Nov 2021 11:01:29 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Nov 2021 11:01:30 -0400
X-ME-Sender: <xms:SAGAYeeRXe1PEkNxo4MvSPREFc2oFMHZUIPBOrJA8RK-9hWpHXBMSw>
    <xme:SAGAYYPF1jzKUAt1MSHWnpXUwxYOq5nGODxyp26wGS36dDX405eTKfiJZoqQJYTAQ
    XkDlLfnP9OC0cbDwA>
X-ME-Received: <xmr:SAGAYfgiCoMBDLVNFvrmdojmcQEe7Y8IHjwuakk6ZZJW02h5VBBjBHZsgvhptg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdehvddgieelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffoggfgsedtkeertdertddtnecuhfhrohhmpeeuohhquhhnucfh
    vghnghcuoegsohhquhhnrdhfvghnghesghhmrghilhdrtghomheqnecuggftrfgrthhtvg
    hrnhepieejhfelvddtgeduhfffueegteevleeugfekvefhueduuedugfevvefhtedvuedv
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsghoqh
    hunhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqieelvdeghedtieegqddu
    jeejkeehheehvddqsghoqhhunhdrfhgvnhhgpeepghhmrghilhdrtghomhesfhhigihmvg
    drnhgrmhgv
X-ME-Proxy: <xmx:SAGAYb8fP3j5C4Rm1UUFi1oEO-0bvUsmLPeWTwQWr4rFqHTX041TxQ>
    <xmx:SAGAYavivQvsmcIvZmrJJPq_QCE0TilkDb9cXjucUHlQxeYq_nC_vA>
    <xmx:SAGAYSHBCVpJSPYE2qMhY0fjM1kLmmSdKeKW4W6nsDfGJW5SxXpPqQ>
    <xmx:SQGAYYC552nAJbZISEIzihgi2PRBYRTlSMZFRoRKt9Iu4expOkZR9w>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 1 Nov 2021 11:01:28 -0400 (EDT)
From:   Boqun Feng <boqun.feng@gmail.com>
To:     linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Boqun Feng <boqun.feng@gmail.com>, stable@vger.kernel.org,
        Baihua Lu <baihua.lu@microsoft.com>
Subject: [PATCH] Drivers: hv: balloon: Use VMBUS_RING_SIZE() wrapper for dm_ring_size
Date:   Mon,  1 Nov 2021 23:00:26 +0800
Message-Id: <20211101150026.736124-1-boqun.feng@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Baihua reported an error when boot an ARM64 guest with PAGE_SIZE=64k and
BALLOON is enabled:

	hv_vmbus: registering driver hv_balloon
	hv_vmbus: probe failed for device 1eccfd72-4b41-45ef-b73a-4a6e44c12924 (-22)

The cause of this is that the ringbuffer size for hv_balloon is not
adjusted with VMBUS_RING_SIZE(), which makes the size not large enough
for ringbuffers on guest with PAGE_SIZE=64k. Therefore use
VMBUS_RING_SIZE() to calculate the ringbuffer size. Note that the old
size (20 * 1024) counts a 4k header in the total size, while
VMBUS_RING_SIZE() expects the parameter as the payload size, so use
16 * 1024.

Cc: <stable@vger.kernel.org> # 5.15.x
Reported-by: Baihua Lu <baihua.lu@microsoft.com>
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
---
 drivers/hv/hv_balloon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index 7f11ea07d698..ca873a3b98db 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -480,7 +480,7 @@ module_param(pressure_report_delay, uint, (S_IRUGO | S_IWUSR));
 MODULE_PARM_DESC(pressure_report_delay, "Delay in secs in reporting pressure");
 static atomic_t trans_id = ATOMIC_INIT(0);
 
-static int dm_ring_size = 20 * 1024;
+static int dm_ring_size = VMBUS_RING_SIZE(16 * 1024);
 
 /*
  * Driver specific state.
-- 
2.33.0

