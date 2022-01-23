Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D782249759B
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 21:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240140AbiAWU73 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 15:59:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237715AbiAWU71 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 15:59:27 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3AF7C06173B
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 12:59:26 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id z14so8381072ljc.13
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 12:59:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rmjsRZYfn7ec/I7dlJNrIDYMFwR7NWaS/CieYmv7fvQ=;
        b=qNg9loFDbnAS2B1dJFNInQ3XlfzswIfCqViJyemkFlUld1xdi+kilYKycDc+zEOSA7
         sQhCImKom6UtC2JWGnoooOVj0UE61KYyp+BRt++T1zAhN4JwKe5dQdHRCMjRsxff4BP9
         lpmfvuqeDr83fTEEXnjDYJrMUgjbsdw05xbqTDSmfdy1wAs3c44xxnKHbY6Nmxn9DuUt
         NrDBsmqvq5SE1XPEUEzSzBVVFnLWsbr9cwy+irw9HBfFuhJOG70MO71OGJ6atrdDx4w4
         8mzefM46KQ5ugll6J1EpBRIvt4W/O8nztVbeoZcj0uXewx6q1sSFYSd63OCUVd09nPCO
         WDvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rmjsRZYfn7ec/I7dlJNrIDYMFwR7NWaS/CieYmv7fvQ=;
        b=Vn420wmEV8nAmwEiA1KNKu3Of6MKwjibYEeKrQ1RCoLAFKb6FxP5VxKWp8jNZytC9T
         jFlIqBMTDdGygjus5bFMhLGeEVM+TY4gnUatL2aoHgZz49JBqJioiew3T+7vGVFOx5um
         Flkp8AuU/+uFXOfl8sk3n9WJgf28qyjo8Na8xaXi3fK0+Cg0LmbgnS35RUYAXMK+ZVdV
         F7MA3FZtU3SFnUxmdEWZ8l+pcCEm6gzj6YltgqWBjYFiTREBBZyGHl8MaasycgjaYEYE
         Gp86oDM1Vb1selq6R3qu2GXLJK/6ksH6Mdhb/H9ROKkrxMzJI7kKwNqM7io7eU+P8Atm
         4DWA==
X-Gm-Message-State: AOAM532E/5e9gxDzKqES/3cHDSuv5kRb4s6pvUNqjbMVdBzeFUnkCjSU
        gI3CVC4P1UtJ+sj1uSyj6mPD3IDKBjldyA6MehuMct1+g48=
X-Google-Smtp-Source: ABdhPJxujOI51FJAh9XjQwuZ0rNl/lpue7rD0vZuW2n0wS+Hc7WbCp6XzrWEdn/Rv3ByhHBlY8O7rQiYH0yPX5LtvQ0=
X-Received: by 2002:a2e:9b9a:: with SMTP id z26mr9237127lji.381.1642971564761;
 Sun, 23 Jan 2022 12:59:24 -0800 (PST)
MIME-Version: 1.0
References: <1642947273187150@kroah.com>
In-Reply-To: <1642947273187150@kroah.com>
From:   Fabrizio Bertocci <fabriziobertocci@gmail.com>
Date:   Sun, 23 Jan 2022 15:59:13 -0500
Message-ID: <CADtzkx73RzAyCKwsTWLQgWq_oFeUFoXU+NvnapEvM4KHU6CF4w@mail.gmail.com>
Subject: Fwd: FAILED: patch "[PATCH] platform/x86: amd-pmc: Fix s2idle
 failures on certain AMD" failed to apply to 5.16-stable tree
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch was already backported to: 5.15.y (commit
0159c7b266830a082f73f0a48da3d21b5936bbec) and 5.16.y
(commit 49201b90af818654c5506a0decc18e111eadcb66)

Regards,
Fabrizio

---------- Forwarded message ---------
From: <gregkh@linuxfoundation.org>
Date: Sun, Jan 23, 2022 at 9:14 AM
Subject: FAILED: patch "[PATCH] platform/x86: amd-pmc: Fix s2idle
failures on certain AMD" failed to apply to 5.16-stable tree
To: <fabriziobertocci@gmail.com>, <Shyam-sundar.S-k@amd.com>,
<hdegoede@redhat.com>
Cc: <stable@vger.kernel.org>



The patch below does not apply to the 5.16-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a602f5111fdd3d8a8ea2ac9e61f1c047d9794062 Mon Sep 17 00:00:00 2001
From: Fabrizio Bertocci <fabriziobertocci@gmail.com>
Date: Mon, 29 Nov 2021 23:15:40 -0500
Subject: [PATCH] platform/x86: amd-pmc: Fix s2idle failures on certain AMD
 laptops

On some AMD hardware laptops, the system fails communicating with the
PMC when entering s2idle and the machine is battery powered.

Hardware description: HP Pavilion Aero Laptop 13-be0097nr
CPU: AMD Ryzen 7 5800U with Radeon Graphics
GPU: 03:00.0 VGA compatible controller [0300]: Advanced Micro Devices,
Inc. [AMD/ATI] Device [1002:1638] (rev c1)

Detailed description of the problem (and investigation) here:
https://gitlab.freedesktop.org/drm/amd/-/issues/1799

Patch is a single line: reduce the polling delay in half, from 100uSec
to 50uSec when waiting for a change in state from the PMC after a
write command operation.

After changing the delay, I did not see a single failure on this
machine (I have this fix for now more than one week and s2idle worked
every single time on battery power).

Cc: stable@vger.kernel.org
Acked-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Signed-off-by: Fabrizio Bertocci <fabriziobertocci@gmail.com>
Link: https://lore.kernel.org/r/CADtzkx7TdfbwtaVEXUdD6YXPey52E-nZVQNs+Z41DTx7gqMqtw@mail.gmail.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>

diff --git a/drivers/platform/x86/amd-pmc.c b/drivers/platform/x86/amd-pmc.c
index b7e50ed050a8..841c44cd64c2 100644
--- a/drivers/platform/x86/amd-pmc.c
+++ b/drivers/platform/x86/amd-pmc.c
@@ -76,7 +76,7 @@
 #define AMD_CPU_ID_CZN                 AMD_CPU_ID_RN
 #define AMD_CPU_ID_YC                  0x14B5

-#define PMC_MSG_DELAY_MIN_US           100
+#define PMC_MSG_DELAY_MIN_US           50
 #define RESPONSE_REGISTER_LOOP_MAX     20000

 #define SOC_SUBSYSTEM_IP_MAX   12
