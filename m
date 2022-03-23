Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 288214E5ADF
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 22:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345025AbiCWVub (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 17:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242437AbiCWVub (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 17:50:31 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694286BDDC
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 14:49:00 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id b19so3991716wrh.11
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 14:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qrSbZoAiUkXyBXtV96tQqE3U9+3a1WixHxW/5QnsD7s=;
        b=WJaozsUrK1BXm41I0vi8XsK/ENuS6q7R88oBTOROdD3JeybgneYiHg7mMu0l/GwBF5
         TKE8WMtDynXwzd+/7+ZbtWmxuA3YXmFPcZLYg9cy1bwTg9toVES1fUuIiVRCGfWCCAOv
         twSYFA7Qisn6nPQ/r4ikYDnaJeLgzP6l/FYTT74xB33Fg7DvWUituFrIIdoAbTq2Mnyv
         h1E3KF20VQOLVsxTDmWBkreTMFREiHu7VammZGFFEs0vFqwMFgN42lU6LPiyfdSG4+l5
         Mj7/AuoMz66uqtDEoVj4hulbfM3a04R4/JHlUfAFIiH/UL8wyKheI330O9aQ7/3CfHUn
         BxcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qrSbZoAiUkXyBXtV96tQqE3U9+3a1WixHxW/5QnsD7s=;
        b=7BmP+A+T4K6xEayN85jUQ0x7ldWh28AYzZyBwb+hI5vT9uHA//eRQsA2TBF76gZ/qs
         pFhIiZVcOzM/bTJBD/oyVmweama5URjReTB1nNB651u4DmlHYdBINxzHBsV05SHEkuGX
         eTjKJUlhppJ6/jNM+ASBZByPrumKLy8xJ7shchaE09vFMP8EYz3KZWrVXn5GMQp1wEGL
         WZIWzvhoR+WfMFPBb9EiL73voDmkZ3N4Oups5J+K1jOtVxHF3LO6NiiZqmlhKkAs0/Xn
         3YUvVefF/MzVGygM9YPQWWksYTiYESDPL35DZ4U0jdPm3FjkAxPT83BTG5ZJzuJPpFHa
         Wa6g==
X-Gm-Message-State: AOAM530X5KAO/1gp0aPL30gX4uC/kOrCb8UerX/BsmRJRKn3x2FdxABe
        IvzdYmTfQ/TASRj5UQbCbPU=
X-Google-Smtp-Source: ABdhPJynmPEiU5eAVNKxSS+OXnoGHG1vgX+9vHWMwhM6jSHeGDpAFNwM7Su7yqit6hNjqyrSYWlQEw==
X-Received: by 2002:a5d:5249:0:b0:203:d647:a5cd with SMTP id k9-20020a5d5249000000b00203d647a5cdmr1753498wrc.103.1648072139040;
        Wed, 23 Mar 2022 14:48:59 -0700 (PDT)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id p16-20020a5d6390000000b00203ffebddf3sm1049951wru.99.2022.03.23.14.48.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 14:48:58 -0700 (PDT)
Date:   Wed, 23 Mar 2022 21:48:56 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     chuansheng.liu@intel.com, rafael.j.wysocki@intel.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] thermal: int340x: fix memory leak in
 int3400_notify()" failed to apply to 4.19-stable tree
Message-ID: <YjuVyDFAP7KYaxhL@debian>
References: <1646031707247250@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="5w9Q80Jy08/LfGN+"
Content-Disposition: inline
In-Reply-To: <1646031707247250@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--5w9Q80Jy08/LfGN+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Feb 28, 2022 at 08:01:47AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport.

--
Regards
Sudip

--5w9Q80Jy08/LfGN+
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-thermal-int340x-fix-memory-leak-in-int3400_notify.patch"

From 5a9a0d5e36d56389835781d6ef0afee65f7b06ba Mon Sep 17 00:00:00 2001
From: Chuansheng Liu <chuansheng.liu@intel.com>
Date: Wed, 23 Feb 2022 08:20:24 +0800
Subject: [PATCH] thermal: int340x: fix memory leak in int3400_notify()

commit 3abea10e6a8f0e7804ed4c124bea2d15aca977c8 upstream.

It is easy to hit the below memory leaks in my TigerLake platform:

unreferenced object 0xffff927c8b91dbc0 (size 32):
  comm "kworker/0:2", pid 112, jiffies 4294893323 (age 83.604s)
  hex dump (first 32 bytes):
    4e 41 4d 45 3d 49 4e 54 33 34 30 30 20 54 68 65  NAME=INT3400 The
    72 6d 61 6c 00 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5  rmal.kkkkkkkkkk.
  backtrace:
    [<ffffffff9c502c3e>] __kmalloc_track_caller+0x2fe/0x4a0
    [<ffffffff9c7b7c15>] kvasprintf+0x65/0xd0
    [<ffffffff9c7b7d6e>] kasprintf+0x4e/0x70
    [<ffffffffc04cb662>] int3400_notify+0x82/0x120 [int3400_thermal]
    [<ffffffff9c8b7358>] acpi_ev_notify_dispatch+0x54/0x71
    [<ffffffff9c88f1a7>] acpi_os_execute_deferred+0x17/0x30
    [<ffffffff9c2c2c0a>] process_one_work+0x21a/0x3f0
    [<ffffffff9c2c2e2a>] worker_thread+0x4a/0x3b0
    [<ffffffff9c2cb4dd>] kthread+0xfd/0x130
    [<ffffffff9c201c1f>] ret_from_fork+0x1f/0x30

Fix it by calling kfree() accordingly.

Fixes: 38e44da59130 ("thermal: int3400_thermal: process "thermal table changed" event")
Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
Cc: 4.14+ <stable@vger.kernel.org> # 4.14+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
[sudip: change in old path]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/thermal/int340x_thermal/int3400_thermal.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/thermal/int340x_thermal/int3400_thermal.c b/drivers/thermal/int340x_thermal/int3400_thermal.c
index e9d58de8b5da..77967da5d406 100644
--- a/drivers/thermal/int340x_thermal/int3400_thermal.c
+++ b/drivers/thermal/int340x_thermal/int3400_thermal.c
@@ -223,6 +223,10 @@ static void int3400_notify(acpi_handle handle,
 		thermal_prop[4] = NULL;
 		kobject_uevent_env(&priv->thermal->device.kobj, KOBJ_CHANGE,
 				thermal_prop);
+		kfree(thermal_prop[0]);
+		kfree(thermal_prop[1]);
+		kfree(thermal_prop[2]);
+		kfree(thermal_prop[3]);
 		break;
 	default:
 		/* Ignore unknown notification codes sent to INT3400 device */
-- 
2.30.2


--5w9Q80Jy08/LfGN+--
