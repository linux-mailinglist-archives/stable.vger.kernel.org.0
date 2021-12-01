Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5F80464B43
	for <lists+stable@lfdr.de>; Wed,  1 Dec 2021 11:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348517AbhLAKMx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Dec 2021 05:12:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348511AbhLAKMw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Dec 2021 05:12:52 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3420BC06174A
        for <stable@vger.kernel.org>; Wed,  1 Dec 2021 02:09:31 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id k2so47114088lji.4
        for <stable@vger.kernel.org>; Wed, 01 Dec 2021 02:09:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OUz5GIJwWhsCyqmvdwiSMp+8PenKcEyq20yCWjGw6oo=;
        b=h0Fitg9dKp6Gl/4ZI0YCCzy6luvo1s9aJSiGf6y033HzRqpc5bZcL22MlRCxP3mbCw
         qaFmDSHUWkmclJFd6Gfp/IFpPuiU7sHzEXpo7ODUC+M3ObKQBAze5n0u8m5zdnSf40pd
         rWicWAkANUpI3/KhOCbjO6u0XEmS6Zjz6t6xbahAOXpcxxGSwPHx2ZvT9rC83GjQ/Jyi
         Zs4Tb/H/YaHN/WStBxRlcFz1073veJYxBn+ifRYQ4WrGuao/yfclD+EQY65wwJ1LSDgT
         t35ruCeNnZ7SL3r0UrUHhEBHvQHgn/B3WNXWOVMGwWma20ykKSLR2Leaqfo+hPq4XYAq
         HpsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OUz5GIJwWhsCyqmvdwiSMp+8PenKcEyq20yCWjGw6oo=;
        b=eLnDpV3S+Ui5yTbqopo+gTBV6Lcgo53qL0hJ9BGPiMRr3bheC4yH7qClFLs2N/FZFR
         RnzhM8YCc406CKohK+yscarI4FGfLg7pNSrbLJcdGNtzdkN+pmM4AkOeSZJkWuozy7ex
         dE/m59JQPZgbCYw/ZotQtF+ol7IQrDWDHHGzGSKaLPIke6s0nEWRqfdnr5U3+ugIHhxu
         gYPVXctSshS9ontvv0+xWR67u8alaos/CYexZiFYtoQUKrRIkVMmgpUjDgvLkyh1Wy3Q
         BbaLymifVk/FEuH+BvFf+4U6ZF7//4X9c0foqCaKcdtoJwNa9eNDxAEXLIASCP8c9g6K
         uqJw==
X-Gm-Message-State: AOAM532MKftEyeNUzf1s1yEUs9jOVap+IFZKaVLYZMblJlE1wbsdTTIW
        4II5tzVV+iHyTv78H1jK35Sv2mgTrq9QhQRFj+PeJQ==
X-Google-Smtp-Source: ABdhPJzDsJHqm+aHiy+lkIXP5Ar3k9o7SMl/nP/3Xx3p2ShJFSukJaXUE1CMRVgy9JAkWUv59xYkYWSvKKpQZ+pGyjE=
X-Received: by 2002:a2e:5850:: with SMTP id x16mr4763005ljd.122.1638353369362;
 Wed, 01 Dec 2021 02:09:29 -0800 (PST)
MIME-Version: 1.0
References: <YaB/JHP/pMbgRJ1O@kroah.com> <20211126074904.88388-1-guangming.cao@mediatek.com>
 <CALAqxLVF1BPznzwjem2BcsDDoo5gMoBqjKEceZDLJan4zCtk3w@mail.gmail.com>
In-Reply-To: <CALAqxLVF1BPznzwjem2BcsDDoo5gMoBqjKEceZDLJan4zCtk3w@mail.gmail.com>
From:   Sumit Semwal <sumit.semwal@linaro.org>
Date:   Wed, 1 Dec 2021 15:39:17 +0530
Message-ID: <CAO_48GHxanR=-mN232ANwxQEiBo9zb3WjvO-6WmP6eFYWA1M5A@mail.gmail.com>
Subject: Re: [PATCH v4] dma-buf: system_heap: Use 'for_each_sgtable_sg' in
 pages free flow
To:     John Stultz <john.stultz@linaro.org>
Cc:     guangming.cao@mediatek.com, greg@kroah.com, brian.starkey@arm.com,
        benjamin.gaignard@linaro.org, christian.koenig@amd.com,
        dri-devel@lists.freedesktop.org, labbott@redhat.com,
        linaro-mm-sig@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mediatek@lists.infradead.org,
        lmark@codeaurora.org, matthias.bgg@gmail.com, robin.murphy@arm.com,
        stable@vger.kernel.org, wsd_upstream@mediatek.com,
        kuan-ying.lee@mediatek.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Guangming,

On Mon, 29 Nov 2021 at 23:35, John Stultz <john.stultz@linaro.org> wrote:
>
> On Thu, Nov 25, 2021 at 11:48 PM <guangming.cao@mediatek.com> wrote:
> >
> > From: Guangming <Guangming.Cao@mediatek.com>
> >
> > For previous version, it uses 'sg_table.nent's to traverse sg_table in =
pages
> > free flow.
> > However, 'sg_table.nents' is reassigned in 'dma_map_sg', it means the n=
umber of
> > created entries in the DMA adderess space.
> > So, use 'sg_table.nents' in pages free flow will case some pages can't =
be freed.
> >
> > Here we should use sg_table.orig_nents to free pages memory, but use th=
e
> > sgtable helper 'for each_sgtable_sg'(, instead of the previous rather c=
ommon
> > helper 'for_each_sg' which maybe cause memory leak) is much better.

Thanks for catching this and the patch; applied to drm-misc-fixes.
> >
> > Fixes: d963ab0f15fb0 ("dma-buf: system_heap: Allocate higher order page=
s if available")
> > Signed-off-by: Guangming <Guangming.Cao@mediatek.com>
> > Reviewed-by: Robin Murphy <robin.murphy@arm.com>
> > Cc: <stable@vger.kernel.org> # 5.11.*
>
> Thanks so much for catching this and sending in all the revisions!
>
> Reviewed-by: John Stultz <john.stultz@linaro.org>


Best,
Sumit.

--=20
Thanks and regards,

Sumit Semwal (he / him)
Tech Lead - LCG, Vertical Technologies
Linaro.org =E2=94=82 Open source software for ARM SoCs
