Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEA366507EB
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 07:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbiLSG5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 01:57:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiLSG5c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 01:57:32 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB43627C
        for <stable@vger.kernel.org>; Sun, 18 Dec 2022 22:57:29 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id r11so7102022oie.13
        for <stable@vger.kernel.org>; Sun, 18 Dec 2022 22:57:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=l1gVVdJMp8wQ/rkq+Fk2Mvpk2jT5XTNTfrQA4T0DEr4=;
        b=DACXHMtVMrKpSzANHNmLbygT9bl4N711AP+TplObT58XKJ7FGFq9yDuBavxRM5NehE
         gSKOoA7DI8g4PV7CmmCruc8B7puaFQTlGHXUkTYStzRM8Nf+7v4E/FgseEz3m/C6qZWI
         UCJCLOfrehFIWmTt9rTfpsQ+bl+bC97K0OdNU76ovAVZ5Lt7UvpSuiYO1DikpEo9utcS
         ehXIcelsqfPnNFlF1ke2kGWBEt6yXQKzy9ML7KP2gmqBxZWcQvTdeDBSDRulgroxbni5
         lse5XxCa8uZ3dPz0ko5b+q5O9PAuh9APTKJbYYlEK4uGjFfKWNu75l2I7cAp4D9jAVFI
         SmEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l1gVVdJMp8wQ/rkq+Fk2Mvpk2jT5XTNTfrQA4T0DEr4=;
        b=4ct7CQen512bq8XG6vs4IwSt7eVMEbG6opF3UEwUAyft8tfch153VqOoFiucNtUCUS
         Hfs3MVn8MKQPfJ3Y5yI+Arn/n27EvKouNkZlJl6lvASMOPK+oyESak9Mav+QoDQPSLbq
         5sSI3gZxoTybsCbUv+UOm3x/KS4O5ROIg5/J+BD0GwdNDdp97CaoycSXiOnofU/RxdG2
         8LPrqFei708mQdGYAcaAVz3Aul0XFXP7s7t6QCrmIe4FsZEsJsIwqfqUdtmOtCKIOxvg
         1yzDrvAhK3emPqspQrvbgXuOkyaBOCw7qRs5wrvSFGiSjgwNPzHxzP8vAdf6PsfD2Qyn
         dohg==
X-Gm-Message-State: ANoB5pkWNW0ZOnnaG6juPULU6mypVKv9yKC4GPAfGOfJ6MJ7a1v8v7N4
        ut+N7mBFtKelZte2kuxnsAZVUjpC8iYXuci8/YvejDc0
X-Google-Smtp-Source: AA0mqf4xMCGWxZc4XplKGct7zMTJ3CkC5dZCMjKZmugIcug21WhX5kj7d2tR4tsfhOomGSA6c5FGKRgd05jeYF6oOk4=
X-Received: by 2002:aca:2801:0:b0:35e:2720:ddb3 with SMTP id
 1-20020aca2801000000b0035e2720ddb3mr1160994oix.83.1671433048884; Sun, 18 Dec
 2022 22:57:28 -0800 (PST)
MIME-Version: 1.0
References: <1a53deef-63f7-43c7-aa73-7ce46fb92a0d@app.fastmail.com>
In-Reply-To: <1a53deef-63f7-43c7-aa73-7ce46fb92a0d@app.fastmail.com>
From:   Sergio Paracuellos <sergio.paracuellos@gmail.com>
Date:   Mon, 19 Dec 2022 07:57:16 +0100
Message-ID: <CAMhs-H9jMVoaRxqK=Bh1+xPWD+-MnoXiKu+5MwDNNM-tEWSghg@mail.gmail.com>
Subject: Re: request for mt7621 SLUB boot fix for 6.1.y
To:     John Thomson <lists@johnthomson.fastmail.com.au>
Cc:     stable@vger.kernel.org
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

Hi John,

On Mon, Dec 19, 2022 at 7:53 AM John Thomson
<lists@johnthomson.fastmail.com.au> wrote:
>
> Hi stable team,
>
> I would like to request for cherry picking to the linux-6.1.y branch:
> 19098934f910 ("PCI: mt7621: Add sentinel to quirks table")
> a2cab953b4c0 ("mips: ralink: mt7621: define MT7621_SYSC_BASE with __iomem")
> b4767d4c0725 ("mips: ralink: mt7621: soc queries and tests as functions")
> 7c18b64bba3b ("mips: ralink: mt7621: do not use kzalloc too early")
>

I have tested all of these patches in the current tree for v6.2 and my
boards boot properly without issues now. I guess all of these will be
added to 6.1 when the merge window finishes.

Thanks,
    Sergio Paracuellos
