Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7D3E271A89
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 07:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbgIUFxU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 01:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbgIUFxU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Sep 2020 01:53:20 -0400
Received: from mail-vk1-xa42.google.com (mail-vk1-xa42.google.com [IPv6:2607:f8b0:4864:20::a42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF7C2C0613CE
        for <stable@vger.kernel.org>; Sun, 20 Sep 2020 22:53:19 -0700 (PDT)
Received: by mail-vk1-xa42.google.com with SMTP id t189so3048964vka.10
        for <stable@vger.kernel.org>; Sun, 20 Sep 2020 22:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qQETu0O7sG8ZefKb7lE9RduahRzUSqc+hLCB6hG+Fns=;
        b=voRjucNk99z17LmRLmWubk3bIhLiHaPpViPQtBSwu2avCoVCt/IFsMrsqhRNYlnGqe
         42+Jp2C3KN2d3GFti2tlN1fcR8LQ5fB8v0l5rVltRVTHVy422pz8jqgp1CA+kVwUb3/S
         5bvZbV2B06SkwutizJdorH7X7+ji9MkcAOkHY9GfyP7vnY3l7nTjs/0NqhPds38s7tOz
         nOjr4oA90XNdlcjzUcfXS5cAWXrw60qZfUQXnLcgPa2Uz8St7vSDyazoi5t8RODh8mnf
         4D78nmdMNssDgAX2EcXov3YzLvy3qunaLiQv3TMv2cbG40iFJbdj0x2DR1rAJ+rWXM83
         47Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qQETu0O7sG8ZefKb7lE9RduahRzUSqc+hLCB6hG+Fns=;
        b=X+Js4E+EAFwNay9FovUa2EAN9mepUMeOe8We/+OtAtHH/VeSLunG6dPDb4L9UL56ia
         WulX9nz4DnS20BpSMujtaHneVhfFJpKQcK9oe3xdocmblXpm3IFarC8TQ502v1kURSXW
         yKODk5ZHSWdci7ofwSunbiEAkX711/aROOhqPfZKCVSjQ4deoM5dqhcvueH3oUrL3Qx6
         vUCfJ7IWXyp93HB14d41ECjcULJpCaiQfYSpYtZKYKbelUqni/kwCZ2YM2rtbV+Nm7bt
         w/M+YAstj/3/LkBu2G3DpPSewEfzIWJnU6swKpqg74auwbzfj9RDMGqP1qaSYOku4sFS
         enAQ==
X-Gm-Message-State: AOAM5337nvNyihDW8r3louNU1Mx2aVWOIOUWHT+aMZ2RzatVEc8FoUp0
        cKkOgJZd9Bb7ph5O8Y4ReUgMbRqj4nFw2bhGOLCyBg==
X-Google-Smtp-Source: ABdhPJxfjUjmTXeHKimVJajbEcb0o8D28ZqtxiFxWNHvdiioP34k/JSkTjw0hXFK+7mnxl/ASTwGwXilqixsBm5+sz8=
X-Received: by 2002:a1f:fec9:: with SMTP id l192mr17383064vki.21.1600667598769;
 Sun, 20 Sep 2020 22:53:18 -0700 (PDT)
MIME-Version: 1.0
References: <160040692945.25320.13233625491405115889.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <160040692945.25320.13233625491405115889.stgit@dwillia2-desk3.amr.corp.intel.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 21 Sep 2020 11:23:07 +0530
Message-ID: <CA+G9fYud7x0TfTDNWHa_0hzYHNQyet-a2==gQzDaZKXywY1meg@mail.gmail.com>
Subject: Re: [PATCH v2] dm: Call proper helper to determine dax support
To:     Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>
Cc:     linux-nvdimm@lists.01.org, linux- stable <stable@vger.kernel.org>,
        Adrian Huang <ahuang12@lenovo.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        open list <linux-kernel@vger.kernel.org>,
        Ira Weiny <ira.weiny@intel.com>, mpatocka@redhat.com,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 18 Sep 2020 at 11:18, Dan Williams <dan.j.williams@intel.com> wrote=
:
>
> From: Jan Kara <jack@suse.cz>
>
> DM was calling generic_fsdax_supported() to determine whether a device
> referenced in the DM table supports DAX. However this is a helper for "le=
af" device drivers so that
> they don't have to duplicate common generic checks. High level code
> should call dax_supported() helper which that calls into appropriate
> helper for the particular device. This problem manifested itself as
> kernel messages:
>
> dm-3: error: dax access failed (-95)
>
> when lvm2-testsuite run in cases where a DM device was stacked on top of
> another DM device.
>
> Fixes: 7bf7eac8d648 ("dax: Arrange for dax_supported check to span multip=
le devices")
> Cc: <stable@vger.kernel.org>
> Tested-by: Adrian Huang <ahuang12@lenovo.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
> Acked-by: Mike Snitzer <snitzer@redhat.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> Changes since v1 [1]:
> - Add missing dax_read_lock() around dax_supported()
>
> [1]: http://lore.kernel.org/r/20200916151445.450-1-jack@suse.cz
>
>  drivers/dax/super.c   |    4 ++++
>  drivers/md/dm-table.c |   10 +++++++---
>  include/linux/dax.h   |   11 +++++++++--
>  3 files changed, 20 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index e5767c83ea23..b6284c5cae0a 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -325,11 +325,15 @@ EXPORT_SYMBOL_GPL(dax_direct_access);
>  bool dax_supported(struct dax_device *dax_dev, struct block_device *bdev=
,
>                 int blocksize, sector_t start, sector_t len)
>  {
> +       if (!dax_dev)
> +               return false;
> +
>         if (!dax_alive(dax_dev))
>                 return false;
>
>         return dax_dev->ops->dax_supported(dax_dev, bdev, blocksize, star=
t, len);
>  }
> +EXPORT_SYMBOL_GPL(dax_supported);

arm build error while building with allmodconfig.

../drivers/dax/super.c:325:6: error: redefinition of =E2=80=98dax_supported=
=E2=80=99
  325 | bool dax_supported(struct dax_device *dax_dev, struct
block_device *bdev,
      |      ^~~~~~~~~~~~~
In file included from ../drivers/dax/super.c:16:
../include/linux/dax.h:162:20: note: previous definition of
=E2=80=98dax_supported=E2=80=99 was here
  162 | static inline bool dax_supported(struct dax_device *dax_dev,
      |                    ^~~~~~~~~~~~~
make[3]: *** [../scripts/Makefile.build:283: drivers/dax/super.o] Error 1

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

Ref:
https://builds.tuxbuild.com/IO690jFQDp0qP9zFuWBqpA/build.log
