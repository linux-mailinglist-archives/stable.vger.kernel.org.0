Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 733BD3187F2
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 11:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbhBKKTm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 05:19:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbhBKKSG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Feb 2021 05:18:06 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F291C061756;
        Thu, 11 Feb 2021 02:17:24 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id b16so6656557lji.13;
        Thu, 11 Feb 2021 02:17:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jm2Vg2vtcC2uZCoulDXy0fsniUr4eVjzDAzUDSNNKSE=;
        b=kJ4MWHlGcO1k8YkKwbXpzbClY+KIxj4eKCFTLXw3JpIocfPdXG8hJm8ffbwAehAbZe
         W/TtyZEPWUaB5ltVUC01nF1kigZvDTIFtLqhv2va42R9wNPZMTeqrsr3ioKVepmCzCc4
         ms8Ypkn6Nl7AQaz+zMM76NnashtmXuu6Fvc0QXVLtP29kDf7Sy5Nhr2NKgRbpqyuvGRi
         LuA298TlR+PlN0J5ZITIz2+/edAg4LVemPt0bWq4uGOLAKvTU9Z3yxVZq9CckZ+2xJoQ
         r4S8J/GuQlsHAlBXDs3J91jNHztIZhFs/qmbcsxjGL/Gkn/LYWbiu1grJJdtYb8Z3OQt
         Jqzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jm2Vg2vtcC2uZCoulDXy0fsniUr4eVjzDAzUDSNNKSE=;
        b=Xv9KHl7DN9hz+6mqmcHcWVmPqpMD82Ku7tkeAb8uz7G6HVv447JgJRSEp9Kti+PRJ/
         sdUe4/29nuYOlCpSWylLuORduKTnl73qHKXjPJfTEqP2uHJyrcMCerG5fLZLqpXm/gh3
         74iNHlOde97+pMR7uL5LGbeH16C5/xENcQ6i86fVTED0jDvD0s1/eCz6cwNKCdkLnk8F
         /4QC8OukTO5Q2/ri0VnUN5kNGjSVMbiSmDm/UXlokb/+Q9N00FIK3YlqRITmPCNaBoge
         PCJKtC+oRZYoh8DqV1prPzrVryG69+o3mKXGysatYSMHVgjy5xu/rWQ+xbtEtBNWosg9
         QQ4Q==
X-Gm-Message-State: AOAM531cgHX5CndkKiRi+KR8BHxNMtbMxrEgn/pg/gW+tj3NWwxNkrhb
        4YviASbWaVL3xoZtlSrI9rNUoMy6zvcEau8tC+s=
X-Google-Smtp-Source: ABdhPJwzs+vtdW8dlE+eJfKnDrxgE1OVplgXPLeWWVicD6u1HQRmIyoAMDeeIstz519wL1P3b/icBmQP/U+Jn1v3188=
X-Received: by 2002:a2e:a312:: with SMTP id l18mr4697526lje.490.1613038643003;
 Thu, 11 Feb 2021 02:17:23 -0800 (PST)
MIME-Version: 1.0
References: <20210211095413.1043102-1-ch@denx.de> <8c08b85e-fa1e-3dd7-6d86-6ec9b57a3670@denx.de>
In-Reply-To: <8c08b85e-fa1e-3dd7-6d86-6ec9b57a3670@denx.de>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Thu, 11 Feb 2021 07:17:12 -0300
Message-ID: <CAOMZO5Amnrc6Os44B=0-Nqv+m1THhT-AtWA-oTbmUjYbb_xqUw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: imx: imx8mm: fix pad offset of SD1_DATA0 pin
To:     Claudius Heine <ch@denx.de>
Cc:     Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Marek Vasut <marex@denx.de>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Claudius,

On Thu, Feb 11, 2021 at 7:15 AM Claudius Heine <ch@denx.de> wrote:
>
> Hi,
>
> can you please add:
>
> Fixes: c1c9d41319c3 ("dt-bindings: imx: Add pinctrl binding doc for imx8mm")

Yes, I was about to suggest the same. Thanks for the fix:

Reviewed-by: Fabio Estevam <festevam@gmail.com>
