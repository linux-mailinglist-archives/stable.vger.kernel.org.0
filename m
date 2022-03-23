Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22F5F4E5ADD
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 22:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241102AbiCWVtp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 17:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345027AbiCWVto (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 17:49:44 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7449E24BCC
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 14:48:12 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id k124-20020a1ca182000000b0038c9cf6e2a6so1647992wme.0
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 14:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gmNQXpQXMgc+H10Htq5uVmO479HHM0NtT5GMeVWYsCY=;
        b=BGdb0XnQZUcbvY6JmR1qHRIktWQMZPW4uUCZ2/ya8j6OdXDdHAGCThP49vTgtnips6
         iAqIe/bmLxFXClq1007uWSCvGBTI2zxvE3Y09ZO3+muvhHL7BYRsJxZIR/X1Ijyfx5Hh
         CqDvyZT8k9kA2GKt4tfPvrFVpr/XGkGHWemzWS62MrwKhFA1H0Z5gc21caYlqfqZMUdV
         vKFe1Vhe2UrR9AqWcyZNXRSYtZgfffeJKrckPVWRi2qZqCP1vso0fi7tNtrdlCRP+M4v
         0VYEs/vFEw8GxuEdXX6FL1iJG3IshBrRJ8fvOtPBR2nm1D7Mk50S4mM9nymKzqgcOpQn
         dsBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gmNQXpQXMgc+H10Htq5uVmO479HHM0NtT5GMeVWYsCY=;
        b=lMPYQ+sS0oeIcFay/g8vQ03FxBf5o+y/WsE7vLn4prH5GMAcXKbY4BTMqjlndPQlNn
         JkHQxP8rLVsiH9xd/jfbcvJXab6cxfT3N85RA4U7kErrnbN6FXMcx6H9qfy4eeStHNaP
         tOruQgQ+ZAJ6sUzAs37eRPtVAC5CVUcGh4Nt8rZZxqQ8n3eVN45I9WuvfNkrsYdvAZwS
         5wEpioe5g+zRbikT0oGFjwKAqjwDk6LEb2QT5LQ/UgyUTH+OzwDV2U8oGtL5xJaAIJ+Y
         Zq/Ds5vzm/U07yWNod3abATfVVXj3LUf4KJ5143MMLHx+RK3YofsjGeCa7N92+PN9DQ1
         TkrQ==
X-Gm-Message-State: AOAM532mzhBMvyRjWYvmmxqiUjwcHxTbRsg+gNJa/HxVwe67Q0H3paIF
        o8MEge0zsyv9mFFTGCzMZkM=
X-Google-Smtp-Source: ABdhPJydrUQjCY3lz+2WP/rWM+e1tfydVDwnuoTNBeF6R68+5OFBrcN/BeqWLhjP7DbPyZhDoH76NQ==
X-Received: by 2002:a05:600c:4e8b:b0:38c:90cf:1158 with SMTP id f11-20020a05600c4e8b00b0038c90cf1158mr11638966wmq.107.1648072090913;
        Wed, 23 Mar 2022 14:48:10 -0700 (PDT)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id f8-20020a5d6648000000b00203e64e3637sm856412wrw.89.2022.03.23.14.48.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 14:48:10 -0700 (PDT)
Date:   Wed, 23 Mar 2022 21:48:08 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     chuansheng.liu@intel.com, rafael.j.wysocki@intel.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] thermal: int340x: fix memory leak in
 int3400_notify()" failed to apply to 4.14-stable tree
Message-ID: <YjuVmAij+cN6ZhzD@debian>
References: <16460317043746@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nAUHFP2mmxmiboVX"
Content-Disposition: inline
In-Reply-To: <16460317043746@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--nAUHFP2mmxmiboVX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Feb 28, 2022 at 08:01:44AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport.

--
Regards
Sudip

--nAUHFP2mmxmiboVX
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-thermal-int340x-fix-memory-leak-in-int3400_notify.patch"

From 1144f431f6e09ae57be3d4e7affc3a71056bb48b Mon Sep 17 00:00:00 2001
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
index 4a20f4d47b1d..d7cd86116084 100644
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
 		dev_err(&priv->adev->dev, "Unsupported event [0x%x]\n", event);
-- 
2.30.2


--nAUHFP2mmxmiboVX--
