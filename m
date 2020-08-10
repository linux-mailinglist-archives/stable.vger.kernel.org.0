Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0F2240480
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 12:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbgHJKLx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 06:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725846AbgHJKLx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 06:11:53 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5AEFC061756
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 03:11:52 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id c4so6804823otf.12
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 03:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=OW2QJCAB01OdhXmMEnrb61ovICwXUJ2/SuGvF568dYU=;
        b=ggsmFC8YfdA14oRN6IMa5+a5Lu7byaU0nMgDQ/ZKdvUMlyt9sp5tKuSZ59KNJ3bAcW
         aXJCy4bYNkcHccE0KksP30UFbpwUoVWD1Ra81s9LMD6obnjcAY1hSNXXgk9v5CKS72xe
         F5wrv8hHuaMqhCIiXf5mxpoGWK+bMZ5q9Lbv1DQiYhoqarG72Ss6uWemNhBdk+3ZCT0o
         P6tt8b94A1NpNnflw1Ro5QV7sK8Gn/mcYmY7h5wMt2ENUQKOLfONPWMjKEB4qQzLJO6c
         hZ9x31iFEuowosN9vt0nWdBaoLe2y7g8xujm4wLqKQCsbxfya+8uIoe/9tV92E16Ecw5
         vhXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=OW2QJCAB01OdhXmMEnrb61ovICwXUJ2/SuGvF568dYU=;
        b=X46UPrPf3BxbkJj3qtymqDUyLBXnX2RrKPZxL8h24b6EIjHMWA0EX+HZ7vdSPfLNyG
         4R3NgQvYW51NMU7WoIIcJ4MR+RGWF27DKeVwDu0wYnLxAqbOMnFjEmIWafmLLKJ0Nbed
         USFKeFT1AfeQA1GP1ljhPqK4E1CKDdpcJjcKk9VRv+F9ZRPcLg8IJAzf+i/4MHK2qpwA
         JFMD4ac9LAc5OETsAWSPJrfx1gIuET61z79KWHzjgab/sh2YwDskORjXgKBiH/bvxx4k
         xz9T+2G9nKkZp/3yyEnlJq0QbieM20dKeGz39wFUCH27TtF45PBZfYHT2+bOKZoZBidm
         KXbw==
X-Gm-Message-State: AOAM532cqY28o42ZBX3p/WMjkAw3QogRNDlcFTwexkbNJwwZqX6Wj1ek
        kAvtUhiOneKA4J9JoDvPZxKpQMSy6wGchPoSa4o=
X-Google-Smtp-Source: ABdhPJw54k0lm+LxhRoSN0GE6CVf3mD6yMQhSe8PzP+zrKimUV7D+6logVGCaPY/COKGeFbvdLZQUqN/e/w7v/qvF8w=
X-Received: by 2002:a9d:7997:: with SMTP id h23mr180663otm.28.1597054311630;
 Mon, 10 Aug 2020 03:11:51 -0700 (PDT)
MIME-Version: 1.0
References: <CA+icZUW_f4d5_yDg0_Ox8nVd_6R=JNc8Bo9TgEzjLUy_1MdXOw@mail.gmail.com>
 <20200810100125.GA2405194@kroah.com> <20200810100149.GB2405194@kroah.com>
In-Reply-To: <20200810100149.GB2405194@kroah.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Mon, 10 Aug 2020 12:11:40 +0200
Message-ID: <CA+icZUWzsHect3v_31-PE_qRfXk7hbORY8JpSkjQmoEFqMykiQ@mail.gmail.com>
Subject: Re: Base for <linux-stable-rc.git#queue/5.8>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <alexander.levin@microsoft.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 10, 2020 at 12:01 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Mon, Aug 10, 2020 at 12:01:25PM +0200, Greg Kroah-Hartman wrote:
> > On Mon, Aug 10, 2020 at 11:52:30AM +0200, Sedat Dilek wrote:
> > > [ Hope I have the correct CC for linux-stable ML ]
> > >
> > > Hi Greg and Sasha,
> > >
> > > The base for <linux-stable-rc.git#queue/5.8> is Linux v5.7.14 where it
> > > should be Linux v5.8.
> >
> > What exactly do you mean by "#queue/5.8"?
> >
> > Is that a branch name?  Ah, never seen those before, maybe they are
> > something that Sasha creates?
>
> But yes, you are right, it seems to mirror queue/5.7 at the moment,
> which isn't correct.
>
> thanks,

[ CC correct stable ML ]

Exactly.

With <linux-stable-rc.git#queue/5.8> I mean [1].

- Sedat -

[1] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/log/?h=queue/5.8
