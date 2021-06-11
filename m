Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B50833A45B2
	for <lists+stable@lfdr.de>; Fri, 11 Jun 2021 17:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbhFKPq4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Jun 2021 11:46:56 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:37719 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbhFKPq4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Jun 2021 11:46:56 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]) by
 mrelayeu.kundenserver.de (mreue009 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1MryKr-1lWT0940O5-00nxqY for <stable@vger.kernel.org>; Fri, 11 Jun 2021
 17:44:57 +0200
Received: by mail-wr1-f42.google.com with SMTP id c5so6561923wrq.9
        for <stable@vger.kernel.org>; Fri, 11 Jun 2021 08:44:56 -0700 (PDT)
X-Gm-Message-State: AOAM532flo++jDTHtmdDnDUduEK5OYwnKPoDrpzNY3/guN4pEiNv0Agd
        oqtEhtkl+uvXSkhFgWpKcBuJn/UIskDhl14GfG4=
X-Google-Smtp-Source: ABdhPJzoXfN5Ip8YUn00vw4tSbeNK6LMhLU1XQ0MDadz7Aovl5H4JaULfhERs3asS+xEqgVBxBE5F0maTur9Xu5wIgc=
X-Received: by 2002:a5d:4e12:: with SMTP id p18mr3266374wrt.105.1623426296664;
 Fri, 11 Jun 2021 08:44:56 -0700 (PDT)
MIME-Version: 1.0
References: <1623396129105150@kroah.com> <CAK8P3a1Y2g+-tKy=zD3yKhxjhVuWdMQvuP_MRbxzdeQFvAB-pQ@mail.gmail.com>
 <CAOMZO5DMQJ6GG+jfKO1a_HmfN_hwuL3De=KEV=g9WN7ejmMK6A@mail.gmail.com>
In-Reply-To: <CAOMZO5DMQJ6GG+jfKO1a_HmfN_hwuL3De=KEV=g9WN7ejmMK6A@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 11 Jun 2021 17:42:58 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1R0xNRLYrC9oKgjUDQj2GwBKrcE1FfDqfryLBeg-X7dg@mail.gmail.com>
Message-ID: <CAK8P3a1R0xNRLYrC9oKgjUDQj2GwBKrcE1FfDqfryLBeg-X7dg@mail.gmail.com>
Subject: Re: patch "Revert "usb: gadget: fsl: Re-enable driver for ARM SoCs""
 added to usb-linus
To:     Fabio Estevam <festevam@gmail.com>
Cc:     gregkh <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@kernel.org>, Joel Stanley <joel@jms.id.au>,
        Leo Li <leoyang.li@nxp.com>, kbuild test robot <lkp@intel.com>,
        Peter Chen <peter.chen@nxp.com>, Ran Wang <ran.wang_1@nxp.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Shawn Guo <shawnguo@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:UGsBfE+uq+VGViusS+8d/KIckClHpCK0V3rE9KdTva/LPy2BSUo
 Qyu62ZJf83r17Tjz7/vBrvEY+3F0FN6Y325ibv6T8ckMS4ZJcrgfnHJujR5vKGebPU1tqJf
 39aB4Q+6ABb6uEJc+x0EZ+EhhH1Cdbh60TTuPgDgt71t5JLAeeWJBDFVdogrx3Y+h+eGvgh
 FOEalxz+mGpb8VSftOv+A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:PpH95R+oW+M=:bfg3AE5AlgeiEgrHjOMT/N
 7LTQbkQzOdxlGfxQzA94zdHWchL0PUDZn3JXvW0CTXinfu9/8TVeMB3L+LC6S0KfoLg81N6uY
 qSTP/4qo5o9W9PnX6gZHJrmkmAD8oSDbiHRiQQgGRJ3D42fCku7aZ3k7U6pfILf+L8I866J2M
 LHOWlcKfjINhsmcydAcXu+RTnSXNrY+HF1W+zZNU+/sCw0QpsRXqdFZTUdwc3+5cmdbyygK9l
 95uCMTt7vguCSJXLevQFOExuik9M8hKl4zGQDTOkbPe7/grLVFrxkCQ3fGZetUR/nue4mC35B
 U5SVQ7I2rZCyTsME673fzD97cMti9mGp6Wf9HrTsvTdkmZItWlkIm7h6i4h6ArcVw3k9U2WJ9
 uioxmbBSk/n3iY3y7TOoxP04GMXt5aUkmO4NJ7926ns+aQnyNkCzmdnkVZoupByuUPLA0M82M
 27d9mG9inuKkhirHvmAvB98E28cXxCbB6dfc3d0LDNOmat2zqL1tm8Ttg/4JrgusPPKJ6mntg
 yrfww5JuzYNYg6WdSaYdgk=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 11, 2021 at 4:51 PM Fabio Estevam <festevam@gmail.com> wrote:
> On Fri, Jun 11, 2021 at 5:30 AM Arnd Bergmann <arnd@arndb.de> wrote:
>
> > Adding Fabio and Guennadi to Cc.
> >
> > I can see that the missing symbols were in a driver that got removed in commit
> > a390bef7db1f ("usb: gadget: fsl_mxc_udc: Remove the driver").
> >
> > If CONFIG_ARCH_MXC is disabled, these are stubbed out in the header file.
> > These were added a long time ago by Guennadi Liakhovetski 54e4026b64a9
> > ("USB: gadget: Add i.MX3x support to the fsl_usb2_udc driver"). I also
> > see that this patch added  a few #ifdef CONFIG_ARCH_MXC checks to the
> > driver that still remain today. This is clearly broken as it must be possible
> > to use the same driver module on both SOC_LS1021A and i.MX using
> > a runtime check.
> >
> > I also don't see any i.MX variant actually using this driver, but instead see
> > the dts files declaring fsl,imx27-usb devices, which bind to the
> > drivers/usb/chipidea/ci_hdrc_imx.c driver. Is this one of those cases
> > where we have two separate drivers for the same hardware, or is this
> > for a different device?
>
> Exactly. The USB IP on several i.MX devices comes from ChipIdea.
>
> Prior to using devicetree, we had the fsl_mxc_udc driver to handle the
> gadget side.
>
> Since i.MX has been converted to a DT-only platform, we no longer need
> fsl_mxc_udc, as
> drivers/usb/chipidea is used nowadays.

Ok, good, so the simples solution I suppose is to remove the remaining
bits that Guennadi added when he wrote the removed driver in
54e4026b64a9, and then re-apply Joel's patch.

Alternatively, it might be possible change the chipidea driver to work
on ls1021a and ls1012a, assuming that they use the same hardware
block as i.MX.

Either way, it would be good to test the changes on at least one of these
two platforms.

        Arnd
