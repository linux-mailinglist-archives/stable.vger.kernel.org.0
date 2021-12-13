Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3269147352B
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 20:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242467AbhLMTov (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 14:44:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242464AbhLMTou (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 14:44:50 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 306A4C061574
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 11:44:50 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id r11so54996342edd.9
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 11:44:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h/bn2QA4sRokY+lW2mdsTbBERIo47tUeAt+yGqnl3lo=;
        b=Sh0+xasBUXbS3UacsNmltTp0MkTV/oG+CZVOKrPRjJVjfnIicuuAMfk55RUBcNdHOJ
         a0LPNIeZDwnZdOGVq4OgGQC4LYdsKQaraEp0aNMWame4VS7gnVm0YgzmNmP7p2NWPgb6
         A2RmLpAuWMJW1dAopi867SmawQF/hfeeQk1/c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h/bn2QA4sRokY+lW2mdsTbBERIo47tUeAt+yGqnl3lo=;
        b=IS/bRHvZ7eARQVVvDrZBMNRnADt31GnkQfPox9p0xd4VIA3ZgDv4xLPFrAQYWaWukA
         rSHP4yMe0PdghI/RQ64iz1bEZXJ+omzH6Jyh+ctlfJ7gI909FW1zsIMGnnKhcP3Z4hpo
         y/qQJW78WjIV/FZko1Xks08TjVyK4JnwSRR+yBq29AzRxqVDDjhZwN2LPPNhxkprcd/i
         2EVmhCjE78/ihNq82AICpr5IMfNpkpwwl/9uvICvwWhiKw+Qb8UsasSBraOHt7XXdrNo
         SRiNAqv5pIdZdVKqzL8vVQuOJZ3BMMVNAWj2c2uYqaaiSiUoryyNXJ8C2zJzRQ1ZXOtD
         ET6Q==
X-Gm-Message-State: AOAM531cTPTHjh0FRvVF+fnwmE7jwhQXYpVz2QBzB1ZuczM4mY6dZdoW
        ldl8nkcFVWVHBCgqUlu/Ce0HdPbbH56sT8JX
X-Google-Smtp-Source: ABdhPJxAqiYzbVWeV6MAGL1myJNfT8u97VM79m6PEVCtOiOQRHfIpORpTHIaJFDQRQOR7Yw6hl9lOQ==
X-Received: by 2002:a17:906:8145:: with SMTP id z5mr407128ejw.519.1639424688645;
        Mon, 13 Dec 2021 11:44:48 -0800 (PST)
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com. [209.85.221.41])
        by smtp.gmail.com with ESMTPSA id gz26sm6034350ejc.100.2021.12.13.11.44.47
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 11:44:47 -0800 (PST)
Received: by mail-wr1-f41.google.com with SMTP id a18so28897332wrn.6
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 11:44:47 -0800 (PST)
X-Received: by 2002:adf:cc8d:: with SMTP id p13mr611346wrj.274.1639424687470;
 Mon, 13 Dec 2021 11:44:47 -0800 (PST)
MIME-Version: 1.0
References: <20211210053743.GA36420@xsang-OptiPlex-9020> <CAHk-=wgxd2DqzM3PAsFmzJDHFggxg7ODTQxfJoGCRDbjgMm8nA@mail.gmail.com>
 <CAG48ez1pnatAB095dnbrn9LbuQe4+ENwh-WEW36pM40ozhpruw@mail.gmail.com>
 <CAHk-=wg1uxUTmdEYgTcxWGQ-s6vb_V_Jux+Z+qwoAcVGkCTDYA@mail.gmail.com>
 <CAHk-=wh5iFv1MOx6r8zyGYkYGfgfxqcPSrUDwfuOCdis+VR+BQ@mail.gmail.com>
 <20211213083154.GA20853@linux.intel.com> <CAHk-=wjsTk2jym66RYkK9kuq8zOXTd2bWPiOq43-iCF6Qy-xQQ@mail.gmail.com>
In-Reply-To: <CAHk-=wjsTk2jym66RYkK9kuq8zOXTd2bWPiOq43-iCF6Qy-xQQ@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 13 Dec 2021 11:44:31 -0800
X-Gmail-Original-Message-ID: <CAHk-=whoMGTAAyah0jH+rHyAXCLnxAHu8KffrR8PrAXGhTxRdA@mail.gmail.com>
Message-ID: <CAHk-=whoMGTAAyah0jH+rHyAXCLnxAHu8KffrR8PrAXGhTxRdA@mail.gmail.com>
Subject: Re: [LKP] Re: [fget] 054aa8d439: will-it-scale.per_thread_ops -5.7% regression
To:     Carel Si <beibei.si@intel.com>
Cc:     Jann Horn <jannh@google.com>, Miklos Szeredi <mszeredi@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@lists.01.org,
        kernel test robot <lkp@intel.com>, fengwei.yin@intel.com,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 13, 2021 at 10:37 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So I'll just apply the patch. Thanks for the report and the testing

Done, it's commit e386dfc56f83 ("fget: clarify and improve
__fget_files() implementation") in my tree now.

I didn't mark it as "Fixes:" or for stable, because I can't imagine
that it matters in real life.

But then it  struck me that Greg has mentioned that he ends up getting
a lot of performance regression reports for people testing stable and
they can be distracting.

So I'm adding a stable cc here just so people are aware of this as a
"yeah, will-it-scale.poll2 performance regression has been reported,
has a fix available if somebody cares".

              Linus
