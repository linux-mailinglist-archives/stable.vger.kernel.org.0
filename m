Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA7D50B2B
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 14:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728197AbfFXMyV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 08:54:21 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:41589 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726740AbfFXMyU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jun 2019 08:54:20 -0400
Received: by mail-lj1-f195.google.com with SMTP id 205so3709497ljj.8;
        Mon, 24 Jun 2019 05:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M1JNblMWL1UJydhDaOs1aVCdSHO2vHTNXrcJ9XfhOto=;
        b=AF5vIQ5Hupi4FNbYV2kGV4xOfPM3ulb1rRfQmWbQr5Ro3xoofZZge6mAwUVep7f04h
         /9FnvWP2O/GiGuxuwAZJhBpJA5eCAYuWnE6JM1h9Mydqpx3uq2jO4H2Q/EhATGLw99rr
         /evcrL2KspOCo2UH1DdmLLcq+cxtf/djSMri+5kZ8VQBwzLSkNSq+xeKjTyqOZdiXfxc
         r7o3AvgfaaVBwj1Ewen5q35C2XNx35g5Z0w02AsEl4AKF3ApiuaxkR3CZP6OicvK6W0d
         2mJj38Ma8R9/lqAYOF7uVILk7S17rUzrizWUxPtSHJeoO9fFXPVN2JW2YOEjFiRE9GIJ
         q9gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M1JNblMWL1UJydhDaOs1aVCdSHO2vHTNXrcJ9XfhOto=;
        b=k0Ckf6fhWCxjwQ+yHPQU2IWPoRn23kYbXVpDM0PNI8oxff0DH8OTk0HTTXAxdS2MMG
         wZ+u3KtOOocM7l/HVJxOu1CA+HtGd0VY12+1wui9dJOe4i14jsIDifwhtp6zpW3REegv
         XKSwEf1L1sedJTmO6wGpRB+iPhfE9jDgFp5RK5NivK7Utu8gQLJi1xqjuy46YJ0vLhxW
         oKhWFn/IBqtuCuQojsCzg4O8qN+QVfr8LfIswf90nwQQ2ctYuzX8GEbFBVgv6GpNC2ux
         c47Wds28JMkuIwcxgdQXnC1tL9cJfVAMdFlvzjFJ4MCYili3GfBP0Nmf5sqQMxW9ufBN
         +rXw==
X-Gm-Message-State: APjAAAUkZbs0mtGWAoHUwPLbiKn+Uex1WofVWeNI856X1z4/buXpfDZs
        R0mDUDbRljIx1CESGTj3yKO0yRNR7rJkM8/clVg=
X-Google-Smtp-Source: APXvYqx12fSqGEeTpRklsnlLBWi1B3OZsYNSLqkKkR4XEAv5A7APelVbsgnk/wQ5UP1qlBs2AcU4EovI5OPGe+uwOqM=
X-Received: by 2002:a2e:7d03:: with SMTP id y3mr34782350ljc.240.1561380858632;
 Mon, 24 Jun 2019 05:54:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190621082306.34415-1-yibin.gong@nxp.com>
In-Reply-To: <20190621082306.34415-1-yibin.gong@nxp.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Mon, 24 Jun 2019 09:54:40 -0300
Message-ID: <CAOMZO5B+uXF=1WTPsA-9LrmtTF0Q0s7Fipwtd1nkWSgr3ec25w@mail.gmail.com>
Subject: Re: [PATCH v2] dmaengine: imx-sdma: remove BD_INTR for channel0
To:     Robin Gong <yibin.gong@nxp.com>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Vinod <vkoul@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Sven Van Asbroeck <thesven73@gmail.com>,
        Michael Olbrich <m.olbrich@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        stable <stable@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>, dmaengine@vger.kernel.org,
        Sascha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Robin,

On Fri, Jun 21, 2019 at 5:21 AM <yibin.gong@nxp.com> wrote:
>
> From: Robin Gong <yibin.gong@nxp.com>
>
> It is possible for an irq triggered by channel0 to be received later
> after clks are disabled once firmware loaded during sdma probe. If
> that happens then clearing them by writing to SDMA_H_INTR won't work
> and the kernel will hang processing infinite interrupts. Actually,
> don't need interrupt triggered on channel0 since it's pollling
> SDMA_H_STATSTOP to know channel0 done rather than interrupt in
> current code, just clear BD_INTR to disable channel0 interrupt to
> avoid the above case.
> This issue was brought by commit 1d069bfa3c78 ("dmaengine: imx-sdma:
> ack channel 0 IRQ in the interrupt handler") which didn't take care
> the above case.
>
> Fixes: 1d069bfa3c78 ("dmaengine: imx-sdma: ack channel 0 IRQ in the interrupt handler")
> Cc: stable@vger.kernel.org #5.0+

This 5.0 notation does not look correct, as 1d069bfa3c78 was introduced in 4.10.
