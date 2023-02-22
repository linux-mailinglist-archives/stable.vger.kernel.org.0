Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4792A69F37E
	for <lists+stable@lfdr.de>; Wed, 22 Feb 2023 12:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbjBVLhV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Feb 2023 06:37:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjBVLhV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Feb 2023 06:37:21 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0574D34C0B
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 03:37:20 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id g8so7865316ybu.13
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 03:37:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=su5NXQ9sdq9gbw4xV37FfRNlttpWAWicuKT4hV5e2CA=;
        b=tgpFiFBEGRlKSoNlnMw/zWozJuUSTGv4v1mGIFqfgj/GVHfMyeqOsjH2rG3Dwcv+Ls
         o0reNh+lMt8yWH/Wt73V803b4eNQUes7iE9pQ6YRMmu5x0ROqM2+jzW3C8C8xrz4VlA0
         qbwLb2aR43JpvTL1Aubqy/uep6nOtuz9kiV/WsZh4Bc9eExuOk7yMB+f18G8qSIB7fM+
         TIsT7IL/fHTfW9YtaQBsPejKFrVJo8dqdpdScplkh/MmRICtdwcie8DLGKwCgW62n7pO
         NgppSWllQnZqtgEPOvyQbNfnsGOCy6jgNAsTeGHYx/DBTHpMSraXSp8LGzeLSZtsml3Y
         TEhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=su5NXQ9sdq9gbw4xV37FfRNlttpWAWicuKT4hV5e2CA=;
        b=S9d1vjdJLZl5H3tcRIFaenPvqv1KJzKaUbhYXizxZReCQnEExKKXx1cYSBj0+dabLj
         m+aE9OQo5RqOOZcpoRqlP/yRZiY9zCPQmwRKFbiXT/RKtMSe1Vwol5Hq4EYDf0a7ZZ5b
         HqI9vNCJUKljfyjSkt4eNZSDe/SMLaWCrW7pXF3vT0dUyeICZRmPF84IeToEiuVdJ8j5
         bSs380rsKiblF7yfeSf1CZXGlUiC+VIfRiM/JIVCdbKxO2YxDS9Ylw8SQ2OIEMkFRzoS
         9G+palYpK4+ch3AhBg+3+tnP64znDTjpNY8Gnk9NoDifVvzl7o3XUpsHk+ZO/T+KdKdW
         1RFQ==
X-Gm-Message-State: AO0yUKXNqvJaalNxbtyJoNC/4/SOKIoXUzIJA7u8MVg7J1LsIZQhLLH6
        6dNi/rcbuzx01wohlODV2CWgEozr9iwcvWgNqZS67Q==
X-Google-Smtp-Source: AK7set9N2SiZpJMzEs0wUfqVtmEgg4EgEmOaHJubSLgDUXhCDdjNmcLRj4lHDFRZ5Wviggni1VA3cwVwleIVMDk7Rec=
X-Received: by 2002:a5b:146:0:b0:8e2:4b9:fe28 with SMTP id c6-20020a5b0146000000b008e204b9fe28mr529718ybp.631.1677065838491;
 Wed, 22 Feb 2023 03:37:18 -0800 (PST)
MIME-Version: 1.0
References: <20220201205624.652313-1-nathan@kernel.org> <20230222112141.278066-1-maennich@google.com>
 <Y/X7xd8NKQe7KhPG@kroah.com>
In-Reply-To: <Y/X7xd8NKQe7KhPG@kroah.com>
From:   =?UTF-8?Q?Matthias_M=C3=A4nnich?= <maennich@google.com>
Date:   Wed, 22 Feb 2023 11:37:02 +0000
Message-ID: <CAJFNNnrqj18n1SF9Od-Vg4OBAW3YKNqW62jy566gES5XWXD_ZA@mail.gmail.com>
Subject: Re: [PATCH 0/5] Allow CONFIG_DEBUG_INFO_DWARF5=y + CONFIG_DEBUG_INFO_BTF=y
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, kernel-team@android.com,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 22, 2023 at 11:26 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Wed, Feb 22, 2023 at 11:21:37AM +0000, maennich@google.com wrote:
> > From: Matthias Maennich <maennich@google.com>
> >
> > Can we please pick this series up for 5.15? I am particularly interested
> > in the last patch to enable BTF + DWARF5, but the cleanup patches before
> > are a very reasonable choice for stable@ as well as they simplify the
> > pahole version calculation and allow future BTF/pahole related patches
> > to apply cleanly as well. I intentionally kept the config
> > PAHOLE_HAS_BTF_TAG and hence its patch complete, even though there is no
> > user for it.
>
> What are the upstream git commit ids for these changes?

Sorry, they should have been part of the commit message ... here they are

f67644b4f282d42acf5ad9b0175ef5671314ab12 ("MAINTAINERS: Add
scripts/pahole-flags.sh to BPF section")
613fe169237785a4bb1d06397b52606b2967da53 ("kbuild: Add CONFIG_PAHOLE_VERSION")
2d6c9810eb8915c4ddede707b8e167a1d919e1ca ("scripts/pahole-flags.sh:
Use pahole-version.sh")
6323c81350b73a4569cf52df85f80273faa64071 ("lib/Kconfig.debug: Use
CONFIG_PAHOLE_VERSION")
42d9b379e3e1790eafb87c799c9edfd0b37a37c7 ("lib/Kconfig.debug: Allow
BTF + DWARF5 with pahole 1.21+")

Cheers,
Matthias

>
> thanks,
>
> greg k-h
