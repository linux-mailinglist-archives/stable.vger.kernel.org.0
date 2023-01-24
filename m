Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 873B167A517
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 22:38:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235035AbjAXViT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 16:38:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235037AbjAXViR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 16:38:17 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 250741632B
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 13:38:13 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id r205so14591539oib.9
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 13:38:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7JehzhdrkWMsTsXozX6TPCwiwh1w1l2PgeaZJIaxC7M=;
        b=VPPaDBtyw0aRgAevKbuHldlym7Sy1aRxXFn7NX236OSrJ6aAlbgKPyZdpPWIJYjKVE
         dCD9QQIPFNXERpXW9YBOmA8PtZ2epdRNzAoL1DijysvbF6cNr4+j01ckstYCda3WWmuy
         UPnG2KFgDMjyfUkY7OQe8xWkIbhzkx8lpxEs9Et4SbGZRw3eeM2xfICFBgbiVH7C4VY0
         7Kz4esBaOBkumRFqQVzE1A+DF1mGYbpLM0zUzb6duV7UpkAjNwnxJVjL+AoSH+Aq49fZ
         1XlIyTZ2NDKeVmeODM/cb1nWXxH5pQmNx+ebMlrRlyi6dvp4Dd+BJFoYh7GVGj/Bd6JE
         CMKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7JehzhdrkWMsTsXozX6TPCwiwh1w1l2PgeaZJIaxC7M=;
        b=QAIage8y7DNuT/DFkd1QM5xraykhiU8WnAwsN9jtSHnueGHIljNovDUDvHw8Pt3joh
         j5dCOvYZ9f1R20AkDVA5HlQ/aXsZ+rP6TiH+CjkafbVNQvvd1W46EfDO18O2C6t2a4Ey
         KDfpFZwGTs0pVNE1b3wGICmtFa8fbVKSGJqCbh5cJOh3NUzyqc4iYX+8SnrcTc29wYZ7
         YY2FWQTLv75nc/whT2qpU2P2zA10ALJWgwJy3MR99xWY0ioT7eiBB7K5PdkD84TI+hzx
         8s9CeGL7mvDnfDfEIQvR5QcYJ7yXLE7+Bx45ylqdBawgnWAMfWaMi0aIkSsGDvYGa0Ll
         +QQw==
X-Gm-Message-State: AO0yUKVpNkHPfQ+Kstxoofmxaxs7K8sRx/ON1x2zuNAFy6H6iQFoOZqZ
        fILR/TAivLw/Gi40EQTUY26j0YsIC1JBvfC83EQ=
X-Google-Smtp-Source: AK7set+V9etwiE6xzCXy1Xm6RbEUxuJXvo3mBrDr+wOeRzKcOFlFsw2ovnUkxQM1c/eiwV/kZofVmzrBUp/Kw5jEfL0=
X-Received: by 2002:a05:6808:2124:b0:36f:18f:cdfb with SMTP id
 r36-20020a056808212400b0036f018fcdfbmr224429oiw.270.1674596292448; Tue, 24
 Jan 2023 13:38:12 -0800 (PST)
MIME-Version: 1.0
References: <CALFERdzKUodLsm6=Ub3g2+PxpNpPtPq3bGBLbff=eZr9_S=YVA@mail.gmail.com>
 <Y89n98fRfTpLmPUg@kroah.com> <CAFJ_xbqMx8LsD_Ry70jnqVmmhyGjTFpA-Gv7SpRR21v3Djr1DA@mail.gmail.com>
 <CALFERdxxAt5+Y0nxbEieYSZX8YLTA9aogtGWLLZBEpGdbWxT-g@mail.gmail.com>
 <CAFJ_xbrAVZDtXwe0Ku0V7b1xp580N+ao0caCRP1xiHBr11oKyQ@mail.gmail.com> <CALFERdwpbQdpnyLuHxo67S4KC=if97AzLGDRVEo+u-HN2Tu0fg@mail.gmail.com>
In-Reply-To: <CALFERdwpbQdpnyLuHxo67S4KC=if97AzLGDRVEo+u-HN2Tu0fg@mail.gmail.com>
From:   Sasa Ostrouska <casaxa@gmail.com>
Date:   Tue, 24 Jan 2023 22:38:01 +0100
Message-ID: <CALFERdwXwJxZ=jG=p6J1LUERzL9=xaiixN1t4Ux11axMW3CJuw@mail.gmail.com>
Subject: Re: Google Pixelbook EVE, no sound in kernel 6.1.x
To:     Lukasz Majczak <lma@semihalf.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        regressions@lists.linux.dev,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 24, 2023 at 3:31 PM Sasa Ostrouska <casaxa@gmail.com> wrote:
>
> On Tue, Jan 24, 2023 at 1:11 PM Lukasz Majczak <lma@semihalf.com> wrote:
> >
> > > If you need anything else just let me know.
> > >
> > > Thanks
> > > Sasa
> >
> > Sasa,
> >
> > Thank you for sharing logs from the working version - could you also
> > provide dmesg for the no sound scenario? You can also share them using
> > e.g. https://gist.github.com/ .
>
> Lukasz thanks, sure, will provide that too but let me reboot into the
> non working kernel.
> Will post it on gist.github.com and post the link here.
>
Hi Lukasz, please see the dmesg with the non working sound kernel:
https://gist.github.com/saxa/08b233a95d5e52046354b07d2e9ca13d

> Rgds
> Sasa
> >
> > Best regards,
> > Lukasz
