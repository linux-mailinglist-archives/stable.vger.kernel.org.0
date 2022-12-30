Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94FD6659CAF
	for <lists+stable@lfdr.de>; Fri, 30 Dec 2022 23:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiL3WVm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Dec 2022 17:21:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiL3WVk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Dec 2022 17:21:40 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C23871D0CF
        for <stable@vger.kernel.org>; Fri, 30 Dec 2022 14:21:39 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id b88so24735439edf.6
        for <stable@vger.kernel.org>; Fri, 30 Dec 2022 14:21:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hle+TDATQIU1Askkn4DbGJTqJ4zXSQMnec43tQ4/jZM=;
        b=pQjylaZeRgk7uiDrvcyHFI7v06Vkc4qYEz1sL4qhHWKyOG7j3/B4mlriifLexhP5i+
         7yOyTJsn5HAVPenSBmL0iCVKR1nz7/T441J2DXRAqECS0k2qh2ORq5kxz6nBBLTZVjPp
         xHTztE1E/QrZpd/dz/LBALd98yiUpQK6OkuaNfYyYXfD58eRk+WJLBo8yIj2LCXqgbz0
         8Jxw9NXkH0F3GoHYgtzIHgzBMnImtrFzXlD7dmylHROXvkxDXpUFqoQdg6Ma7bn0DLEH
         CjKDAm+YPD8Nu0q6iXWp+n+8AYghzBtEZNUBhsATebbyQQo1PXT8gaNxcAeZccu+Qgpa
         eNMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hle+TDATQIU1Askkn4DbGJTqJ4zXSQMnec43tQ4/jZM=;
        b=GO4CAY4LrCWkwIu7qQnAQ6tB9pbTsu9IePBw94C/BrvKKJ/Kgj4OeBmKHhfkkQZKLH
         WgUeXmu6PVj4MmsmFkDjn/oIMOTlBCJle7CQgOpQMC71pR0P2VdeXLCzFXqkBIj6TtbH
         qaLQHWCPAlBAjNqgtU5P0EKeOS7JlyNjpREtUYFzbPYk4iMXvVwUiWsmoZNiH0PgzQmk
         btI9EBN+nBBXWGYy3nrrpIbyCQ/9CpYmosBbn9SHsXrGnzMeA2GNwith9sodgdKyN40Z
         o8zMvq+3uEbXb4FeWVc/mO45wn8IT5rnFAMRCIo12RvyPf1QdiR662AfLEnBmFazim/+
         hBRQ==
X-Gm-Message-State: AFqh2kqTD2tdARPRMMphzZH5LgD4dMJBy6Ht0mPzUr+BJ1VTS3T5vtni
        DD5KgM1T3nrqKu7JTT+eCSm603tbRhn/AhMFUXkzHIl+lTM=
X-Google-Smtp-Source: AMrXdXtnCvYktMIZ6BdXm6xSI9y64WwtIfegEr0xSAYsPnxcqa8ZUnuA9r0eLzQ7O6CH3C06/d39LkAOSlUxyS36xbE=
X-Received: by 2002:a50:ea81:0:b0:45c:a651:8849 with SMTP id
 d1-20020a50ea81000000b0045ca6518849mr3712707edo.209.1672438898126; Fri, 30
 Dec 2022 14:21:38 -0800 (PST)
MIME-Version: 1.0
References: <20221230215942.3241955-1-zenczykowski@gmail.com> <Y69fx1KpwWivqLp0@181616e551cc>
In-Reply-To: <Y69fx1KpwWivqLp0@181616e551cc>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Fri, 30 Dec 2022 14:21:26 -0800
Message-ID: <CAHo-Ooxx2qF0i-34H3mCMB99_Uf1ifnw2ivs9z4AHkbSPXsY9Q@mail.gmail.com>
Subject: Re: [PATCH] usb: storage: de-quirk Seagate Expansion Portable Drive
 SRD00F1 [0bc2:2320]
To:     kernel test robot <lkp@intel.com>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
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

Mr. Robot,

your rule matching logic appears to be incorrectly implemented.

Regards,

A human.

On Fri, Dec 30, 2022 at 2:02 PM kernel test robot <lkp@intel.com> wrote:
>
> Hi,
>
> Thanks for your patch.
>
> FYI: kernel test robot notices the stable kernel rule is not satisfied.
>
> Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
> Subject: [PATCH] usb: storage: de-quirk Seagate Expansion Portable Drive SRD00F1 [0bc2:2320]
> Link: https://lore.kernel.org/stable/20221230215942.3241955-1-zenczykowski%40gmail.com
>
> The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests
>
>
>
