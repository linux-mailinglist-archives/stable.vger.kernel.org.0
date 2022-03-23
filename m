Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97B534E5AD3
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 22:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237403AbiCWVst (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 17:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232814AbiCWVst (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 17:48:49 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D008E18A
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 14:47:19 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 123-20020a1c1981000000b0038b3616a71aso1624440wmz.4
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 14:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AFenXKEbs5u77efEEEJ+nb8wOn+JzlF1rE6XKdoznBQ=;
        b=YfewNjLJ+SEVWLVgn9fFLf1+SBY7SCtfSHqhTzFVTWABg1lONUVOS+QSrb/hVi/vya
         yylT9UCiKTTWw7yjeRkuRk6RIkRtX175WyLATkbQiipgmyQousNEOkyQqUanmYfbWYXf
         kF0SYLiHACYWs6p6Ajxe0gO/B6Vw8x+3m3r0GqsPSKPRD6d4uQSySaZ6kC+75U+34kgK
         7+tUIB4z36GhYiCjl/haxOSIvCbkk/cAawoc3PwcySPbkkajjLTb9MO6/6YW52u+LJZW
         dG5H7mtuhEb+QitKggJl5TA9iNczMRiz2n0+hnZH7BDejbV+A7O5DAWcAGZrjnkSwFsb
         fakw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AFenXKEbs5u77efEEEJ+nb8wOn+JzlF1rE6XKdoznBQ=;
        b=x2gXj5HeVqosECyapVaeDiux8PkElwmO+2fRJVveXgWPkx0Mi9C/HMzB5BjrLsuBH0
         YiP9PslA120MqGBshCdhQ9N9Kl1B8hqBFTfAgx8sb4cxc0/jj0jfr4/upKKpdlJJa6OI
         oixfbYWWjTutIPJIU0QKXSdliPrDZOnxlbQT8Rmr10ZJ4bI2ErggHT+3TVailxP62wWR
         RHAfm6cYagFoddnRQkSw3t95roBSq9XaV4lQgU/v8/7EbUMLTCU8ERQb4CUqwc6VRuvQ
         2k1zLOmCVwh7X6e1VtQMH27z32KWwShHs0Dh2f4tPPh9uIGkWtPlGFU0HMzKR6ImRBX2
         ysng==
X-Gm-Message-State: AOAM530D5QXEYPu1xGJ405UiTd1J/qVanbF6umQkBG5kyTtb0LHMT9DD
        emSBGBRAPhZij7bw3vUjJd0e+YJQd0s=
X-Google-Smtp-Source: ABdhPJygJ96FHy/ZUJktN9oZZ8cc/MNVj928y9wyR/DMSzUCNdjnb+xkPxrOsf7dWVI5Ft1nqNRnrg==
X-Received: by 2002:a05:600c:600a:b0:38c:6c9e:f9c7 with SMTP id az10-20020a05600c600a00b0038c6c9ef9c7mr11164233wmb.26.1648072037533;
        Wed, 23 Mar 2022 14:47:17 -0700 (PDT)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id c7-20020a5d4f07000000b00203db8f13c6sm847658wru.75.2022.03.23.14.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 14:47:16 -0700 (PDT)
Date:   Wed, 23 Mar 2022 21:47:14 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     chuansheng.liu@intel.com, rafael.j.wysocki@intel.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] thermal: int340x: fix memory leak in
 int3400_notify()" failed to apply to 5.4-stable tree
Message-ID: <YjuVYoXlGnVo4zod@debian>
References: <1646031700191178@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="9CSFDPXFjvyBBkfI"
Content-Disposition: inline
In-Reply-To: <1646031700191178@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--9CSFDPXFjvyBBkfI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Feb 28, 2022 at 08:01:40AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport.

--
Regards
Sudip

--9CSFDPXFjvyBBkfI
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-thermal-int340x-fix-memory-leak-in-int3400_notify.patch"

From c33ffcb112666518f78854623173b363892618dd Mon Sep 17 00:00:00 2001
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
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/thermal/intel/int340x_thermal/int3400_thermal.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
index 3517883b5cdb..a31163547fba 100644
--- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
+++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
@@ -216,6 +216,10 @@ static void int3400_notify(acpi_handle handle,
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


--9CSFDPXFjvyBBkfI--
