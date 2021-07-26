Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 587503D535B
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 08:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbhGZGJ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 02:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbhGZGJZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Jul 2021 02:09:25 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC0ACC061757;
        Sun, 25 Jul 2021 23:49:54 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id w12so9663957wro.13;
        Sun, 25 Jul 2021 23:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=77kG9S3qiN7Pee8IO6EV9t1Ga5VtrrlRdIvRkJtgjNU=;
        b=mneKexEh5BOltVI5/pi4g7JTPR48LDIN3N+BNXpIMMQmcg+spMTr6A88kws8ebzU7Y
         b4OO5/jkInF7C9OHfaLQ9J1maBytdMmd1RlNPLQuCJkRrQKAr+AR3yLXyT2tIFCCaszM
         cPY/du9gwnRqZEvjKckNB3sX87CyfMCGIaqudshq/wAXH47046LhRJB2N/McmW8YJ5Er
         adM2e1GjKymlsGNTqMmi6ba3JQ7wSxh1TF7Kqlw5pFlAhRAD2B0F9jT+KxP0Tq4sjuj5
         gNum0qMSZlwrDNqLhi/OXv4Uarb4TW84AGQi7ru7K1JU7GrVt8eXYgEDHHCQdrW3X5q2
         3ZSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=77kG9S3qiN7Pee8IO6EV9t1Ga5VtrrlRdIvRkJtgjNU=;
        b=TguWTohmYed5nFtkaYO6tDt1txeX6iC81p9x3703K0lQMhD0J2b7wIGmkrC8T87t2m
         sjtM6cia40HELy6fVTmWCxXrP/X5Wt8Ah2S4XW91WapTj4GztswZkeCnS4O51LUfaYpn
         MKn0mjuLGqKM+dMGEjdS+2OYHHr0ZkNewl0o3L5vpPqQyYOZS3gpEZpPPxUTrpn3s8FQ
         xd6g3bVAF6NRZNg7ASkh5fFgUYJpIUivTuNJZE5VJnNTUOT5tBblc6m2KpC+bPc7YNZZ
         KtaEk0O0zw+WiJ3Zzp/lTmsxHZ48LJm3d//8g6zzYOD394TgH1aOqtMtfSuFkoJTrgKU
         xELQ==
X-Gm-Message-State: AOAM531E4qLm2QUSoIwt2Fli87+kGixriKgsivJrvzWvswZKeUpuqH8N
        b5hxW5r8AeC344zqwyjS01R9+Erud3F7ZW78owQ=
X-Google-Smtp-Source: ABdhPJxjtEtsWiu9MhpmZ6KCfuk0A7KSZibq3x5xuaXS2WHzKONuWHhJ719k3QpSBfqnxvIxCjxda/fmhGPm2s+Nbtk=
X-Received: by 2002:adf:dcca:: with SMTP id x10mr17274731wrm.59.1627282193384;
 Sun, 25 Jul 2021 23:49:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210726024441.16E8E60F11@mail.kernel.org>
In-Reply-To: <20210726024441.16E8E60F11@mail.kernel.org>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 26 Jul 2021 09:49:16 +0300
Message-ID: <CAHp75Vda-5ESLvnqVZEE_JRYr5k38gw0g-R650bNULf78d1t1w@mail.gmail.com>
Subject: Re: Patch "ACPI: utils: Fix reference counting in for_each_acpi_dev_match()"
 has been added to the 5.13-stable tree
To:     Sasha Levin <sashal@kernel.org>, Stable <stable@vger.kernel.org>
Cc:     stable-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 26, 2021 at 5:44 AM Sasha Levin <sashal@kernel.org> wrote:
>
> This is a note to let you know that I've just added the patch titled
>
>     ACPI: utils: Fix reference counting in for_each_acpi_dev_match()
>
> to the 5.13-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>
> The filename of the patch is:
>      acpi-utils-fix-reference-counting-in-for_each_acpi_d.patch
> and it can be found in the queue-5.13 subdirectory.
>
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.

This has to be accompanied with
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=fc68f42aa737dc15e7665a4101d4168aadb8e4c4

> commit 9b33ed3a4be3985e11c6bc81e5789262794164b6
> Author: Andy Shevchenko <andy.shevchenko@gmail.com>
> Date:   Mon Jul 12 21:21:21 2021 +0300


-- 
With Best Regards,
Andy Shevchenko
