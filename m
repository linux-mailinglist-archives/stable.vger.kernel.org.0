Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 540336101F7
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 21:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236656AbiJ0Ttr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 15:49:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236671AbiJ0Ttq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 15:49:46 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB2C11C43B
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 12:49:41 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id r19so2037556qtx.6
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 12:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IZvmWLTFu1pJfxfIKPo4Qzw+QHUwqjXY5ckHaNck6Jc=;
        b=fTbxvhkB9Q+Fe33eN2TIiuiGsYcoayGZo/GVlgIPaPIi4E4PWHQg+tILioAu1pxy47
         SPB/HWIwL/rp1BPAalsZtvSEPPUlAgagvZZeBgnks/VLrKBeuDwVfjzxhCp8NrsMDPgH
         YqgIu238xCH5sedRqUOy5B71c+BZ22fWTQrb4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IZvmWLTFu1pJfxfIKPo4Qzw+QHUwqjXY5ckHaNck6Jc=;
        b=s/ztmo4bSy7R974UttvIVhonxMdBPPo9IY3GrzIA+f2UL60C/CoIH0m63v36cGZHqY
         YzOZIZdDiqvkiUY11u1yRdiP/RSmEKTtosB7GZtqPUiMhiNhzf0IeId/LnECfhB7ucyS
         E0OxZTDBVNne3CYOchBMKqUD8/O9RqvanfR6nvOfAx2bN7v51FYdIutVNy/wOPftaQwe
         awHhA/ouGrNPMBKEfhd8YYcO6J158KZEvuD4AdFGyvjWOeoOB+2qgVRu5ZEYHl/cqwvg
         lU6osZUs9blx+dWd4TvF8qci++ZDjUWET7F/yxJTzLX28hbrIoU1fZBLNZCqWh0sQPEU
         Yw8A==
X-Gm-Message-State: ACrzQf0O85HtVdOeDOkTZZtLI6BuC6k5FRq5DGpuQEe9VUIbItledmQj
        1BqdWSIrAdWS0RygpSwZIM+GaBnODmrg6g==
X-Google-Smtp-Source: AMsMyM6UkYI7usB0JD+LICdWLSTKJMxgwQZXP6fPv3FKqjvJtYV0ymEFIe6MWDwfjP2vG8paULeC1w==
X-Received: by 2002:a05:622a:1a9f:b0:39c:ae32:9f7f with SMTP id s31-20020a05622a1a9f00b0039cae329f7fmr44236180qtc.80.1666900180807;
        Thu, 27 Oct 2022 12:49:40 -0700 (PDT)
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com. [209.85.128.181])
        by smtp.gmail.com with ESMTPSA id e4-20020ac80104000000b003972790deb9sm1308101qtg.84.2022.10.27.12.49.38
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Oct 2022 12:49:39 -0700 (PDT)
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-36d2188004bso26950927b3.4
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 12:49:38 -0700 (PDT)
X-Received: by 2002:a81:d34c:0:b0:349:1e37:ce4e with SMTP id
 d12-20020a81d34c000000b003491e37ce4emr45951805ywl.112.1666900178558; Thu, 27
 Oct 2022 12:49:38 -0700 (PDT)
MIME-Version: 1.0
References: <20221027165054.270676357@linuxfoundation.org> <8617f970-2a72-799b-530d-3a5bb07822a6@roeck-us.net>
 <Y1rbQqkdeliRrQPF@kroah.com> <20221027192744.GC11819@duo.ucw.cz>
In-Reply-To: <20221027192744.GC11819@duo.ucw.cz>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 27 Oct 2022 12:49:22 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgweH9GibJBzuEZNBGKbYPrs4NchT0YLuyxk1=N7gsWog@mail.gmail.com>
Message-ID: <CAHk-=wgweH9GibJBzuEZNBGKbYPrs4NchT0YLuyxk1=N7gsWog@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/79] 5.10.151-rc1 review
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 27, 2022 at 12:27 PM Pavel Machek <pavel@denx.de> wrote:
>
> Alternatively you can modify the caller to do /bin/sh /scripts/... so
> it does not need a +x bit...

Generally we should be doing both.

Make it have the proper +x bit to show clearly that it's an executable
script and have 'ls' and friends show it that way when people enable
colorization or whatever.

*And* make any Makefiles and tooling use an explicit "sh" or whatever
thing, because we've traditionally let people use tar-files and patch
to generate their trees, and various stupid tools exist and get it
wrong even when we get it right in our git tree.

So belt and suspenders.

But in this case, I think our tools already do the "run shell" part:

  Makefile:PAHOLE_FLAGS   = $(shell PAHOLE=$(PAHOLE)
$(srctree)/scripts/pahole-flags.sh)

no? And at least in my -git tree, it's already executable.

Maybe one of those "various stipid tools exists" is in the stable
tree. I didn't check.

           Linus
