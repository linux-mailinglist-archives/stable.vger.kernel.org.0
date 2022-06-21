Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A44B553084
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 13:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbiFULOo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 07:14:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348897AbiFULOl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 07:14:41 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B07429CA7
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 04:14:40 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id i15so19017245ybp.1
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 04:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xYw9OmTRzTi+Xt9lvnhkFXi31e5yL6ORBs6Qt2ln5bE=;
        b=O51hTyPzAKdmWO+0BH7EHTopaz5cyCfM8Sb9Ydp5jtFH7JBUOBlK1iX8m2X9eE5LsC
         S6PnmyVDPMwHbjjnm0U1i+7uAxe2awpBnB/3iv5czH9JihQgEyn6ZEKfe15Iql/j3E24
         1cVdj5cA1YLWm7HP41MKhRY9tUnIjhoxqYU5EELxmbsIH7+rX8EJXBf0jzmCXta9/Ptf
         xamFjrQC/vuAn6ryJ+WoAVdw8bOLLXGuSRFxLGQyEjGjPfe3WkcX5iM2cSd+N/sjVS2V
         P1Q/ChlHEhiXuMWogS8lyLWbHaa5MdaSrMI02OD5oRxHvNk3RNryn5k5kWdrcjupPaZZ
         /mpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xYw9OmTRzTi+Xt9lvnhkFXi31e5yL6ORBs6Qt2ln5bE=;
        b=VglwTBqr7mUrVq8npvUBnsu6VOdCmEhcgJUDPsPn/EDxPeTKlIWhY6HAalDHxDI9Mf
         avzBMmNK6UpLAis4GhZcBlFSk4CGBGOlNAoqiXRwxJ8ghfSFkmpxByRCzCKkaYutCN6E
         j7vGWF9TL3g4nOgnwEDLPHXjNABFW2HuzWfTpbiyt0rMjdIBU9YSdluGxYkp46yAvf58
         TTbMJpIUvoztBi9GFiuR/b6mwMs94/IKuj+VS3h+8+8DfkOkPS8j7L6PMsWcqf916QxT
         iCxeWoPKfKl5bN/xXTTzOBbSaPu/OLxJ15qLXRmBGdjvk3wiSOy2Hr4Aj7cW7JBTroTj
         lnKg==
X-Gm-Message-State: AJIora+sWtFEv9t8QixyP+3e036d/bDf3vCMW2GPuUJyirFeo+Ib8BPC
        Ksnd9IhH1HXfLvj8yIbaKFA8U18o5aXiwXkadc1A5RS+m6E=
X-Google-Smtp-Source: AGRyM1veXkcRVtph7Ey0DF2ez4+6d0LK89sugoAm1FZrfAbYYFDkRSSYYos/g+junPyfpaMoIhiOPBVYJflo8xOCzRI=
X-Received: by 2002:a5b:50:0:b0:668:de4f:9b41 with SMTP id e16-20020a5b0050000000b00668de4f9b41mr16400729ybp.517.1655810079568;
 Tue, 21 Jun 2022 04:14:39 -0700 (PDT)
MIME-Version: 1.0
References: <YrGZxGoKgKxcvVTG@debian> <ce23efa0-70d3-41f4-eb4a-ea047e0dfb91@kernel.org>
In-Reply-To: <ce23efa0-70d3-41f4-eb4a-ea047e0dfb91@kernel.org>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Tue, 21 Jun 2022 12:14:03 +0100
Message-ID: <CADVatmN869Y6r7=ds2s_K0yXGN4RYKnZZy5413V+V8Eq+3WHuw@mail.gmail.com>
Subject: Re: patch request for 5.18-stable to fix gcc-12 build (hopefully last)
To:     Jiri Slaby <jirislaby@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stable <stable@vger.kernel.org>
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

On Tue, Jun 21, 2022 at 11:39 AM Jiri Slaby <jirislaby@kernel.org> wrote:
>
> On 21. 06. 22, 12:13, Sudip Mukherjee wrote:
> > Hi Greg,
> >
> > The following will be needed for the gcc-12 builds:
> >
> > ee3db469dd31 ("wifi: rtlwifi: remove always-true condition pointed out by GCC 12")
> > 32329216ca1d ("eth: sun: cassini: remove dead code")
> > dbbc7d04c549 ("net: wwan: iosm: remove pointless null check")
> >
> >
> > With this 3 applied on top of v5.18.6-rc1 allmodconfig for x86_64, riscv
> > and mips passes. (not checked other arch yet)
> >
> > Will request you to add these to 5.18-stable queue please.
>
> On the top of that, I had to apply this too:
> aeb84412037b x86/boot: Wrap literal addresses in absolute_pointer()

uhhh... I thought -Warray-bounds has been disabled by:
f0be87c42cbd ("gcc-12: disable '-Warray-bounds' universally for now")
which is in v5.18.6-rc1 now.

Are you sure you still need that ?


--
Regards
Sudip
