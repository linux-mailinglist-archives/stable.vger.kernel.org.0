Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8FD6A5CC3
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 17:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbjB1QIU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Feb 2023 11:08:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbjB1QIU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Feb 2023 11:08:20 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74BC4C674
        for <stable@vger.kernel.org>; Tue, 28 Feb 2023 08:08:18 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id bp19so5670445oib.4
        for <stable@vger.kernel.org>; Tue, 28 Feb 2023 08:08:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+DuQMwQqoZZxYz0mh4YkmIMucepoPHSppd7CceVZznA=;
        b=H9Ny8TyVQrqdLsMdaIiVhcuQno4tM9reWPhwH48MmEcKjxkDxp7FXFI56b4LAnHynz
         mlU51e2u4we75jT4IUny1zQIbEi4tWMHFSjpH15EqL40JXNh8occoM8WYH2DL0Rsct5F
         3zBrtPj5myCcVEqc09FfO9Q5NhFaBiDjZi2EtccRaSybFec6Xq+yZXz+ft73eY3nMC/L
         6W47gyTb48r2bUsfhPqrBbTCw6t7u5dmhKM+W1rIVUP/113IBPNs8naPjpfpxL2CPYzT
         fk0qKvo0MuCY0FhKPDlLqnPqzc4wNCQQd34yBComc2q+o+GeUT3FZ4/dYwOjO5FBWR8L
         wbPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+DuQMwQqoZZxYz0mh4YkmIMucepoPHSppd7CceVZznA=;
        b=BDA3FV2uiQmnL52s8ZTNShkYWavWhGRWCANFc2YaW9tMVXZgirxbAtXtpvrvxLBAai
         DQqNolWJ4Z9pRhsvBzd8oPvEEYEEX/vZLOKC2/1zrj71QSCTK/bmwO7JhNT5aDdiGnUD
         F3HGpmqTSh7QJ+w7xRV9sRlrSGzZto+IVyINYkv/3pCPtN0SKtnU2TR439JMTDCxcJay
         U7/hMz5o7LoQrC399N9d6kiV4vfh6jyZNfrKoPJz+AqPBaQGTmNd9Lea51TsbfBqPYDp
         eLH6yjUGEB5Na9fsLmxZ7SRzApHzlRInrEcA8kUVV+ubFQxnY/K18OBAY3zKVNV1ci/A
         y+Yg==
X-Gm-Message-State: AO0yUKXB0fKKRjj6POECOCH3i+rGHGJMi6Qqo4s8cytAbXmhjLIwdDBj
        4/EdEOj+fowIDGq+B40NSsRbLaEW1sap+IVXwow=
X-Google-Smtp-Source: AK7set/sRX2Wb+LRJSkZFOSq0KaHutWlI+rrQZLtwZXLUPHa7/lDbtMau7wGW4PdST8upcLKBP/mMrOvil9Wrb454sc=
X-Received: by 2002:a54:4783:0:b0:37f:9a63:cdf8 with SMTP id
 o3-20020a544783000000b0037f9a63cdf8mr1042055oic.2.1677600497824; Tue, 28 Feb
 2023 08:08:17 -0800 (PST)
MIME-Version: 1.0
References: <f260225d-2a03-8d41-58d8-da278a790a95@arinc9.com>
 <CAMhs-H-zGy3Nde_pUPE4aFJgg81+QH2NERo7yBkjQEwB2g3vDQ@mail.gmail.com> <Y/4lzbkLITqAzUMR@kroah.com>
In-Reply-To: <Y/4lzbkLITqAzUMR@kroah.com>
From:   Sergio Paracuellos <sergio.paracuellos@gmail.com>
Date:   Tue, 28 Feb 2023 17:08:05 +0100
Message-ID: <CAMhs-H8RtGQS_UqQsbknUpFCmsXfC-rVNgU=b8VPbS41+SjA6Q@mail.gmail.com>
Subject: Re: Please apply efbc7bd90f60 to 5.15
To:     Greg KH <greg@kroah.com>
Cc:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        stable@vger.kernel.org, erkin.bozoglu@xeront.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 28, 2023 at 5:03 PM Greg KH <greg@kroah.com> wrote:
>
> On Tue, Feb 28, 2023 at 04:58:25PM +0100, Sergio Paracuellos wrote:
> > Hi,
> >
> > On Sat, Feb 11, 2023 at 4:55 PM Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@a=
rinc9.com> wrote:
> > >
> > > commit efbc7bd90f60c71b8e786ee767952bc22fc3666d upstream.
> > >
> > > Please apply ("staging: mt7621-dts: change palmbus address to lower
> > > case") to 5.15. It solves the duplicate label error caused by the nod=
e
> > > name being uppercase on gbpc1.dts, but lowercase on mt7621.dtsi.
> > >
> > > drivers/staging/mt7621-dts/gbpc1.dts:22.28-26.4: ERROR
> > > (duplicate_label): /palmbus@1E000000: Duplicate label 'palmbus' on
> > > /palmbus@1E000000 and /palmbus@1e000000
> > > ERROR: Input tree has errors, aborting (use -f to force output)
> > >
> > > Ar=C4=B1n=C3=A7
> >
> > It looks like this commit is not backported to 5.15 yet? I guess the
> > mail got lost somewhere...
>
> Sorry, didn't get to it yet, now queued up, thanks.

Thanks, Greg!

Best regards,
    Sergio Paracuellos
>
> greg k-h
