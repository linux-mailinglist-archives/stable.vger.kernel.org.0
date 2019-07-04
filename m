Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25ACD5FD74
	for <lists+stable@lfdr.de>; Thu,  4 Jul 2019 21:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbfGDTdx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jul 2019 15:33:53 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:38000 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726844AbfGDTdx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Jul 2019 15:33:53 -0400
Received: by mail-qt1-f195.google.com with SMTP id n11so9001484qtl.5
        for <stable@vger.kernel.org>; Thu, 04 Jul 2019 12:33:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=trZAp9LOKuqwVKXtG5sPne0ur3xocoaSp6Vhf48qK18=;
        b=VSkZD6nCctKOxLYikoZQccQSIC7HG3BjF7auKnkVjzV3S6/JOTYm3/QyeelGqmvEv5
         vV2ZnUl+MgwSMvRFyAEDJCShSPKU1JI07ny5JA0iiuyH0+lkFzbULBWEISYsUa0VoX1q
         TUYnjf0g8+QOJ8wVdSbbSzcanguz6ZA4CL1UWW0Jtw7xpDig9xoZSpQ/LZp5da+xPgo4
         hKxKv7IzrUiUzbVOxwtz8oR/DO9QrgigV93U8WwaA123ORmsHMOt1c95GOxFRp5zEPdI
         SXhHKMMdBPepptNRLfbe38TAOi/gi7ilJJP942Cl1p6w8QSn9h2SXoJLWdFUGVeU3VvS
         VZNQ==
X-Gm-Message-State: APjAAAWXMn0FNJS4Tt8EEzLW++JzxyNEFXhv5BXtO+bamS78CQ6mwBrb
        Nuicogr9Nj7OYWvDwz2tnotcGFTq/l3dHnZtjaM=
X-Google-Smtp-Source: APXvYqweVx77P+bRxDU02t5Q7MxM9R08MVxR1EvLbV0Ux/SA5OUqheKaap0U+IW767J7q2Nj9YHBZ79qkWd8CCBSlKs=
X-Received: by 2002:ac8:5311:: with SMTP id t17mr35843053qtn.304.1562268832124;
 Thu, 04 Jul 2019 12:33:52 -0700 (PDT)
MIME-Version: 1.0
References: <5d1dd15d.1c69fb81.90003.b2ac@mx.google.com> <CAK8P3a1aTHOGOgRjHgFHS+vuDV2Kv2aY7-bEUBa2nx5aF_vVCA@mail.gmail.com>
 <20190704154218.GE10104@sasha-vm>
In-Reply-To: <20190704154218.GE10104@sasha-vm>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 4 Jul 2019 21:33:34 +0200
Message-ID: <CAK8P3a3ysa=HeUEtQ1fZPDYA41oPTbdtnCUN+oSFLHJk=MawBg@mail.gmail.com>
Subject: Re: stable-rc build: 78 warnings 1 failures (stable-rc/v5.1.16-8-g57f5b343cdf95)
To:     Sasha Levin <sashal@kernel.org>
Cc:     "# 5.1.x" <stable@vger.kernel.org>,
        Kernel Build Reports Mailman List 
        <kernel-build-reports@lists.linaro.org>,
        "Olof's autobuilder" <build@lixom.net>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 4, 2019 at 5:42 PM Sasha Levin <sashal@kernel.org> wrote:
>
> On Thu, Jul 04, 2019 at 01:46:36PM +0200, Arnd Bergmann wrote:
> >> arch/arm/mm/init.c:471:13: warning: unused variable 'itcm_end' [-Wunused-variable]
> >> arch/arm/mm/init.c:470:13: warning: unused variable 'dtcm_end' [-Wunused-variable]
> >
> >Please backport this to 5.1-stable:
> >
> >e6c4375f7c92 ("ARM: 8865/1: mm: remove unused variables")
>
> It's not in mainline yet.

oops, sorry about this. I only looked at the checked out tree which happened
to be linux-next ;-)

      Arnd
