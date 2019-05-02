Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2074511968
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 14:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbfEBMyY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 08:54:24 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:34839 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbfEBMyX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 May 2019 08:54:23 -0400
Received: by mail-lj1-f193.google.com with SMTP id z26so2089744ljj.2
        for <stable@vger.kernel.org>; Thu, 02 May 2019 05:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f2iV3bnerzLXP9x+uTFOU0GfRhZhG/Forl0VLEurI0E=;
        b=D7aTUJ8Tpfpg99B1fGNAekTouN23OQZ1zCh7Tay3/mEGSBfiayty2oGWZ7Ii0cykaS
         FH0puEgBWs5UfmBFPp1OsLPtq/HyWejO/s4qF35qXGIAFGg60MUCDlXKRpR3QhkQ8cKi
         n4d9qmPPPsa9TjHa4Wuhqn1S2ieDwy0DaYkgfVWKy0sLg7XAezPcOyoDWzkTJl1msNIm
         iq9VHxkkQU0CiHDyYMjgumVgHpgh01H5Ta9GCOfxwX3s2glUzH8sMo9NaajG00FZ8ltO
         luaIw93Y8sP59DJdmdQEKCofG18R9TFX9a75OpuB+ibOpgYMb6LtBn3bi3MnTHLAzRoT
         fHQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f2iV3bnerzLXP9x+uTFOU0GfRhZhG/Forl0VLEurI0E=;
        b=eBESVk7P4bxN6+V5E+bddganDQkhR2/KjfAhwXl4yugk5B2i5JfV+bmYQTXQl025Zh
         j2HLlBAQX1TiK54M18MWxoij8WGSMGkI+jLAe5B3wUynqvMa0rcl4xEPUcsWkseF77By
         Uj6MTZNkafW3QiejumJiajtj+L4bv/489JjNCh7SYef1biqaEu4P80IWPSwu3qaBpP8Y
         jRDP3j9lXIkBDpRdz3U3AiergAxuUEOvvD9j96lOZsTZTqdELTEQCuHQa6Ta1XQqiwox
         xWJN74K3xJuR9MrqRwXWWQwjtkO03fRMRagPuBuqD5MhVCouMoV8/byLq04aqxLdBEBD
         TKSw==
X-Gm-Message-State: APjAAAWvbu/aZTplOHKMntzUDeMZ+YQagbLv1L0f6/l4w4pA8t2gkSKS
        1nfO5nI+qhUrf3TXe2D/9Ywu3xYcN5K3HxOjVlg=
X-Google-Smtp-Source: APXvYqyNN6h47CvkEUshGiUc9OTFTZAq9oGFln3ciMmxqoD5IPsrs1TGv6yN7dqDKu3VYZtMysnDlE9Kv26mO9XpL4s=
X-Received: by 2002:a2e:8794:: with SMTP id n20mr2004032lji.76.1556801661788;
 Thu, 02 May 2019 05:54:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190502113020.8642-1-festevam@gmail.com> <20190502122645.C5FD52081C@mail.kernel.org>
 <CAOMZO5B6GJ_OCX_22M+RQ6HQG=_kxEcM7x1X8+VL9fRc+jHx2w@mail.gmail.com>
In-Reply-To: <CAOMZO5B6GJ_OCX_22M+RQ6HQG=_kxEcM7x1X8+VL9fRc+jHx2w@mail.gmail.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Thu, 2 May 2019 09:54:16 -0300
Message-ID: <CAOMZO5BMpwqQUYQ==MRowu62SboL7ikFztUVA2ODkRtONU6gsg@mail.gmail.com>
Subject: Re: [PATCH] ARM: imx: cpuidle-imx6sx: Restrict the SW2ISO increase to i.MX6SX
To:     Sasha Levin <sashal@kernel.org>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 2, 2019 at 9:33 AM Fabio Estevam <festevam@gmail.com> wrote:
>
> On Thu, May 2, 2019 at 9:26 AM Sasha Levin <sashal@kernel.org> wrote:
> >
> > Hi,
> >
> > [This is an automated email]
> >
> > This commit has been processed because it contains a "Fixes:" tag,
> > fixing commit: 1e434b703248 ARM: imx: update the cpu power up timing setting on i.mx6sx.
> >
> > The bot has tested the following trees: v5.0.10, v4.19.37, v4.14.114, v4.9.171, v4.4.179.
> >
> > v5.0.10: Build OK!
> > v4.19.37: Build OK!
> > v4.14.114: Build OK!
> > v4.9.171: Build OK!
> > v4.4.179: Failed to apply! Possible dependencies:
> >     6ae44aa651d0 ("ARM: imx: enable WAIT mode hardware workaround for imx6sx")
> >
> >
> > How should we proceed with this patch?
>
> I can submit a version for 4.4 stable tree once this hits mainline.
> The conflict resolution is very simple.

Or maybe I can send a simpler version that applies all the way to 4.4:

--- a/arch/arm/mach-imx/cpuidle-imx6sx.c
+++ b/arch/arm/mach-imx/cpuidle-imx6sx.c
@@ -15,6 +15,7 @@

 #include "common.h"
 #include "cpuidle.h"
+#include "hardware.h"

 static int imx6sx_idle_finish(unsigned long val)
 {
@@ -110,7 +111,7 @@ int __init imx6sx_cpuidle_init(void)
  * except for power up sw2iso which need to be
  * larger than LDO ramp up time.
  */
- imx_gpc_set_arm_power_up_timing(0xf, 1);
+ imx_gpc_set_arm_power_up_timing(cpu_is_imx6sx() ? 0xf: 0x2, 1);
  imx_gpc_set_arm_power_down_timing(1, 1);

  return cpuidle_register(&imx6sx_cpuidle_driver, NULL);

Would this be preferred?
