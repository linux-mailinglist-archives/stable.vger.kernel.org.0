Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE2B271AA4
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 08:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgIUGEa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 02:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbgIUGE3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Sep 2020 02:04:29 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C300C0613CE
        for <stable@vger.kernel.org>; Sun, 20 Sep 2020 23:04:29 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id y194so7414875vsc.4
        for <stable@vger.kernel.org>; Sun, 20 Sep 2020 23:04:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=gmSKhpFY4kTNF3DPRn/4uO6u6dZbhjoQaX0s9W7i2IM=;
        b=nYtofNvodxIDAyZLMUI2rcNLFfTMRH1LBcTAJ8HrhbB2NLSx2bVuOCT+QYikoCeA7t
         Ld15cYB+D7ZgjD2ONWcj2OqcxoABt15HqUl9Wr6vYSziluXmEZd5T/qn3ovoW18lvL+0
         9GxNFwR95z3amyJLydMsfD6AjbMQNRY46l8GuzszwS1sBkoZnviPU3y9du8fLDYa0aoe
         oLZVCrvdkuNDAaf5M2iONVk4vbMyHaHmt1SarI1wMSRtfFJ6f5kZ5UTCOfLNm27wjssj
         Bd8XOiHpUOzpBbsRROFbKkjBZwE0J/LEA8trISJL/3t6GFQldmeWIOWZrSg9BSddoUSc
         RBpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=gmSKhpFY4kTNF3DPRn/4uO6u6dZbhjoQaX0s9W7i2IM=;
        b=hlImDNjewFqvGi/LEicEosebzEZi85E7YmWJ8b97KAUg5eqcCXjh1D4gTUFEzZhrVH
         aC8nPRFDtD8Ov858KwesR8CurK0zd22YdikgH/IfajqDFhX5RQjGfluZzH2iIb/NWvoI
         CadLP6kixp0ygnA+ibFje32rR+ibEukfn2bpZO6mNQB4+uarrBqencZw0TpbtrUTaZPZ
         VQeQwuDWAbW3Y3MENQ+nhbH8MN3L2TJ8gH1IOTmI0bajGeXrJDSlzQ3nFvL62E3J/LDD
         KUzxBTFwazBfBIbs4zjD8ez/gSF7zWjhNzdlALQMT9Zg7MsiIsqDxlmuHhVjU+lJMl9F
         gjpg==
X-Gm-Message-State: AOAM530gIHxhi+qG2KCS9hklDKaCUmd3q2NxSZOT1ZfM7T3dX70+NHtH
        yneltnAe6XghBtZo+IZRkccPw+rbS1ZQdbYwrIlVOw==
X-Google-Smtp-Source: ABdhPJzuk1/PiphSwuUvjP6+E5H+PEm5LcR5lGn9Fq1X93k9XatzTGELxhm95y0PWoUFN4sZmwm7EgBxD7/W71hG544=
X-Received: by 2002:a67:80d2:: with SMTP id b201mr26678854vsd.12.1600668268677;
 Sun, 20 Sep 2020 23:04:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200921010359.GO3027113@arch-chirva.localdomain>
In-Reply-To: <20200921010359.GO3027113@arch-chirva.localdomain>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 21 Sep 2020 11:34:17 +0530
Message-ID: <CA+G9fYtCg2KjdB2oBUDJ2DKAzUxq3u8ZnMY9Et-RG9Pnrmuf9w@mail.gmail.com>
Subject: =?UTF-8?B?UmU6IFBST0JMRU06IDUuOS4wLXJjNiBmYWlscyB0byBjb21waWxlIGR1ZSB0byAncmVkZQ==?=
        =?UTF-8?B?ZmluaXRpb24gb2Yg4oCYZGF4X3N1cHBvcnRlZOKAmSc=?=
To:     Stuart Little <achirvasub@gmail.com>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>, linux-nvdimm@lists.01.org,
        kernel list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Adrian Huang <ahuang12@lenovo.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Ira Weiny <ira.weiny@intel.com>, mpatocka@redhat.com,
        lkft-triage@lists.linaro.org, Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 21 Sep 2020 at 06:34, Stuart Little <achirvasub@gmail.com> wrote:
>
> I am trying to compile for an x86_64 machine (Intel(R) Core(TM) i7-7500U =
CPU @ 2.70GHz). The config file I am currently using is at
>
> https://termbin.com/xin7
>
> The build for 5.9.0-rc6 fails with the following errors:
>

arm and mips allmodconfig build breaks due to this error.

>
> drivers/dax/super.c:325:6: error: redefinition of =E2=80=98dax_supported=
=E2=80=99
>   325 | bool dax_supported(struct dax_device *dax_dev, struct block_devic=
e *bdev,
>       |      ^~~~~~~~~~~~~
> In file included from drivers/dax/super.c:16:
> ./include/linux/dax.h:162:20: note: previous definition of =E2=80=98dax_s=
upported=E2=80=99 was here
>   162 | static inline bool dax_supported(struct dax_device *dax_dev,
>       |                    ^~~~~~~~~~~~~
>   CC      lib/memregion.o
>   CC [M]  drivers/gpu/drm/drm_gem_vram_helper.o
> make[2]: *** [scripts/Makefile.build:283: drivers/dax/super.o] Error 1
> make[1]: *** [scripts/Makefile.build:500: drivers/dax] Error 2
> make[1]: *** Waiting for unfinished jobs....
>
> --- end ---
>
> That's earlier on, and then later, at the end of the (failed) build:
>
> make: *** [Makefile:1784: drivers] Error 2
>
> The full build log is at
>
> https://termbin.com/ihxj
>
> but I do not see anything else amiss. 5.9.0-rc5 built fine last week.

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
