Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2813A445F
	for <lists+stable@lfdr.de>; Fri, 11 Jun 2021 16:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbhFKOxs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Jun 2021 10:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbhFKOxs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Jun 2021 10:53:48 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A84BAC061574
        for <stable@vger.kernel.org>; Fri, 11 Jun 2021 07:51:35 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id f30so8985220lfj.1
        for <stable@vger.kernel.org>; Fri, 11 Jun 2021 07:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kkDDh1yzT46Hj6VhjlRWjIm6z4MIgg8IBmcKp1CHS28=;
        b=OEuElD0NE0KfnyKoiC00NixBsjP4q2d1pquZtVpPB1+HKBoncIYXE0n6cft9mNklKP
         NxkgRinoE4CbBfzBuikyeXIPR4s+TeHuCLg5GtBN8O8p08IdccmCP1bpBY6kpzVM+MZG
         QCfLrV34d6tqdAKBfxVEhju4Ekap9tFNJzorLKpaxSM/t0IKl0y4HShX3zXjDc+jKvCC
         D2SUP/ElraH03HQuPgTTIUKjJ8tNoP+j90xTnl7Hy5Q1GKdrItH/POjfnZh5xvDsgPho
         N8MNHW4R1oiRyQxQIRPN6CPgsQE8f+sRk7+pVCnssWOTYJk0eUepjG6s9w67FPb64QlC
         pkZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kkDDh1yzT46Hj6VhjlRWjIm6z4MIgg8IBmcKp1CHS28=;
        b=HlvrklizrpvJUdBYc5sS02TVP0k8+c1cCvFJ5/GOp5zMjV72MEZhGTVXNfmRItCZtZ
         Th6qiSZNX4tJm0sp0AIcIRLL9fFLmAm7CiEo1cGQ5CRcRvx12LjX4BHjOAWdIik6dHW7
         QkqVFnVZCv3hfljr97K2/+yalCSuJmTawT8xFhYLaW9rPTxD/JZM7ddxdDhlCrDbZgKD
         tupRm6k35x2/F/j1f5kRKJUWXcOo88H3Uw1PnLHAtJAIO5DB20Qwv9e1TlhIS5wRg/rK
         XNvwScCmwfQZ4ZPUzZPF3oH7UJIZIvE1uNmp0pRgIOZ8k9Bj2JXtA+rbN21jCvP2bhP2
         r9KA==
X-Gm-Message-State: AOAM530Id3As+NYdRfFuyixjez5rMLdl3Cxos4eOs0llm8rWHJwOlB4d
        kd/CfiZQFKJPWiAA5PC0lHOGklKtaQY6R3J1PkE=
X-Google-Smtp-Source: ABdhPJynLhEMY55wYj+momMHsg2XTxicaBAZG8IWlN/tljHGL1buqIxU77umTwBXUprfBVtjXVvKNMgOLw1/mSeFaw4=
X-Received: by 2002:ac2:51a9:: with SMTP id f9mr2799386lfk.223.1623423093890;
 Fri, 11 Jun 2021 07:51:33 -0700 (PDT)
MIME-Version: 1.0
References: <1623396129105150@kroah.com> <CAK8P3a1Y2g+-tKy=zD3yKhxjhVuWdMQvuP_MRbxzdeQFvAB-pQ@mail.gmail.com>
In-Reply-To: <CAK8P3a1Y2g+-tKy=zD3yKhxjhVuWdMQvuP_MRbxzdeQFvAB-pQ@mail.gmail.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Fri, 11 Jun 2021 11:51:22 -0300
Message-ID: <CAOMZO5DMQJ6GG+jfKO1a_HmfN_hwuL3De=KEV=g9WN7ejmMK6A@mail.gmail.com>
Subject: Re: patch "Revert "usb: gadget: fsl: Re-enable driver for ARM SoCs""
 added to usb-linus
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     gregkh <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@kernel.org>, Joel Stanley <joel@jms.id.au>,
        Leo Li <leoyang.li@nxp.com>, kbuild test robot <lkp@intel.com>,
        Peter Chen <peter.chen@nxp.com>, Ran Wang <ran.wang_1@nxp.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Shawn Guo <shawnguo@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Arnd,

On Fri, Jun 11, 2021 at 5:30 AM Arnd Bergmann <arnd@arndb.de> wrote:

> Adding Fabio and Guennadi to Cc.
>
> I can see that the missing symbols were in a driver that got removed in commit
> a390bef7db1f ("usb: gadget: fsl_mxc_udc: Remove the driver").
>
> If CONFIG_ARCH_MXC is disabled, these are stubbed out in the header file.
> These were added a long time ago by Guennadi Liakhovetski 54e4026b64a9
> ("USB: gadget: Add i.MX3x support to the fsl_usb2_udc driver"). I also
> see that this patch added  a few #ifdef CONFIG_ARCH_MXC checks to the
> driver that still remain today. This is clearly broken as it must be possible
> to use the same driver module on both SOC_LS1021A and i.MX using
> a runtime check.
>
> I also don't see any i.MX variant actually using this driver, but instead see
> the dts files declaring fsl,imx27-usb devices, which bind to the
> drivers/usb/chipidea/ci_hdrc_imx.c driver. Is this one of those cases
> where we have two separate drivers for the same hardware, or is this
> for a different device?

Exactly. The USB IP on several i.MX devices comes from ChipIdea.

Prior to using devicetree, we had the fsl_mxc_udc driver to handle the
gadget side.

Since i.MX has been converted to a DT-only platform, we no longer need
fsl_mxc_udc, as
drivers/usb/chipidea is used nowadays.
