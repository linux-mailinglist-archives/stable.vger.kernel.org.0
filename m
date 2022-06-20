Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E57155264F
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 23:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243839AbiFTVPe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 17:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241433AbiFTVPc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 17:15:32 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97FC013D49
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 14:15:31 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-3176b6ed923so112236807b3.11
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 14:15:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q1vTSLrS9i2Va4xyFmF/cESGFn2Xi7Hzio/Zu8fnd0A=;
        b=ka40xfTdLuylrkQ+VqxXlQ/luu49b5geDDF9VmRVWjIaYhOD6jXBshqq+2trStT9A4
         +UucK0YI2DXteaW7nFCQwzDfdFToxb8Vkj/fYrWKR7IJfn76nQ6mwROwvwhG3gbYYk16
         ULxK9X6eDC+laOk8gFmCnycmaAlBBljJwBdzGqyzGtxBm+uic5OJbXGTqI/MPgj6qYVi
         xV7z83Z+6pYHxQHElciumwvU33thJUoxgbDFNaOWaWwYRtE5GzCL0oCumhupx09nHqQ9
         aLXKyohaMBeoJlt8Fhmyfl4EzRe9ghf+MtVMgRRAfjEsBgtDGWQgL8IBVtHv7FcuSmgN
         dAIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q1vTSLrS9i2Va4xyFmF/cESGFn2Xi7Hzio/Zu8fnd0A=;
        b=KTNPYdh5WAeoHgBZ+k9cPndQhIvdrB/cgTEb1d2RbtWsjVOnox9OkpnRZ8x/5ul5Pk
         uui/iUZXJan4pDJN8G19+jVdkWeIeY/As0R6CupFmr+CfpBLt9Be3T7TP/wX97WUEQF2
         wArlidg+6EKiVlRaW6e9bo9KEDmcPfcX+K4+A07iKFlB9DWMtDNajZWTLfp1qv4OaL/N
         //4DA9/24hxliUnKdGl3X//rz2i6BMUINXADiDIpSNKxEQ8CEg29Hr+s8Ud5RP03VzgV
         No8BNuMwyuc4juC/Gy8EIa2rCGYTC44ndPafjepDqPwN0QzOcA1feUurW1GRwp8t2Q5b
         0rYQ==
X-Gm-Message-State: AJIora8V6d8ff//zO3pUxdotAzpDL/i4vteik1r1m+U8vSMonxV56CKM
        sc3BcbrCiGNmPKQ7aWd81sj7l3rah+/fqXCPc7AOygyn
X-Google-Smtp-Source: AGRyM1te+YdBgr6Zwl2ljpY7dzvrfxHdJd57NkBcO9lihTHzqQ8Ul7AHayHeol9ei1qMsTSyYPbgoTr7Bgz5MgOQh1g=
X-Received: by 2002:a81:a04d:0:b0:317:80c2:3937 with SMTP id
 x74-20020a81a04d000000b0031780c23937mr21593951ywg.478.1655759730818; Mon, 20
 Jun 2022 14:15:30 -0700 (PDT)
MIME-Version: 1.0
References: <YqxguwkPJhyvKbRk@debian> <YrBILWzY4ziMl7xE@kroah.com>
In-Reply-To: <YrBILWzY4ziMl7xE@kroah.com>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Mon, 20 Jun 2022 22:14:55 +0100
Message-ID: <CADVatmM_JAo=Ca_JPSmT2+z2LVcwZieDHj4O046h7odvomXr2w@mail.gmail.com>
Subject: Re: patch request for 5.18-stable to fix gcc-12 build
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 20, 2022 at 11:13 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Fri, Jun 17, 2022 at 12:08:43PM +0100, Sudip Mukherjee wrote:
> > Hi Greg,
> >
> > v5.18.y riscv builds fails with gcc-12. Can I please request to add the
> > following to the queue:
> >
> > f0be87c42cbd ("gcc-12: disable '-Warray-bounds' universally for now")
> > 49beadbd47c2 ("gcc-12: disable '-Wdangling-pointer' warning for now")
> > 7e415282b41b ("virtio-pci: Remove wrong address verification in vp_del_vqs()")
> >
> > This is only for the config that fdsdk is using, I will start a full
> > allmodconfig to check if anything else is needed.
>
> Now queued up, thanks.
>
> I don't think 5.18 will build with gcc-12 for x86-64 yet either, I'm
> sticking with gcc-11 for my builds at the moment...

Yeah, it still fails. But just few more errors. I am hoping I will
send you another list tomorrow for it.


-- 
Regards
Sudip
