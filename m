Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B69462BAB58
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 14:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728399AbgKTNeH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 08:34:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728104AbgKTNeG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Nov 2020 08:34:06 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C4AC0613CF
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 05:34:05 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id l1so10020525wrb.9
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 05:34:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0DnufIVx5k+ikoA08x3/TY3NmZ4fqJGmV9/jnWsQi+Q=;
        b=tuBii7JJ9llmFjqxkhQh9JT06URno1cMKMbuUGj6d6hY1jJ1vXBCjORiW7l49jWqQS
         q7Gbf70245JD02MYPFcCMEVxazJ+IQbH8TZXr3oD/53dTpNwHNz+NjrkyemBYNRIMwBn
         4FOlfaYamciW6SDmc/HaXZZq5uhZyKJ92LfaOoX+CViW1xiUPo4j9fMtGQxIohsuVMeq
         CYspkdRvnEy1NM1M4J2feOGVfLOzhvsRYH6Ec9nXYvSHQr+CQ6DPgVKUlDKmibQljFUo
         KMNf40oSZs3e7icn9EZzCyovdpV7RlUk58tNEpcMge4CsXhazPdMNbBzBnaGN2lRKaHq
         wZLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=0DnufIVx5k+ikoA08x3/TY3NmZ4fqJGmV9/jnWsQi+Q=;
        b=bMo5IHW4Vr6tB85Nsuz1zSch8dhOfO2QCmvmz/KFh6kf9EAA4nsZz6jRNo2ATEw3xy
         gaj+h0Co+rzWNoDEVWtpCKKECCyoQ+IUex/KENe3mO6QLolWE7O0ljafhvOC23Vxeuz9
         m6lfaKlP1kes7NiANGcKzplXJsmxB1HiJvWEroWdujX50nPN6z0+hohDQ31ZqVWHp664
         jD5pcv0DZ3GFzug0GiT3GlgvUWgG+GtOA7m/zzumGlnd9Zj7fniodrFP3NOsS6EV8brS
         cCDlviqci8/gFOO3y3142VJr1BRWLYut/AZ5Ni1c/qU2C1kJT3F75XeXKkDBnWeUCfP0
         thDw==
X-Gm-Message-State: AOAM532Agx+BMRHZ65WzzNNz17bQzC/yq8/040xN5bxie9uTQSkxQLBz
        StC6mWCQ6hD4iZ8MFhgcygM=
X-Google-Smtp-Source: ABdhPJz/NZ0LG3uk3iDJftKMcB3386fuGyk45ubTHbxhwqN+k4nxrlf4bzU5TXNQbpo35io6sxappQ==
X-Received: by 2002:adf:f2ce:: with SMTP id d14mr15691029wrp.94.1605879244592;
        Fri, 20 Nov 2020 05:34:04 -0800 (PST)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id g138sm4216048wme.39.2020.11.20.05.34.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 05:34:02 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Fri, 20 Nov 2020 14:34:00 +0100
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Andrey Zhizhikin <andrey.z@gmail.com>
Cc:     stable@vger.kernel.org, Leo Yan <leo.yan@linaro.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Suzuki Poulouse <suzuki.poulose@arm.com>,
        Tor Jeremiassen <tor@ti.com>,
        linux-arm-kernel@lists.infradead.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] Revert "perf cs-etm: Move definition of 'traceid_list'
 global variable from header file"
Message-ID: <20201120133400.GA405401@eldamar.lan>
References: <20201120073909.357536-1-carnil@debian.org>
 <CAHtQpK6xA4Ej_LCKBv6TWgiypzwzFzPy3ANvH8BRw-y_FkuJqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHtQpK6xA4Ej_LCKBv6TWgiypzwzFzPy3ANvH8BRw-y_FkuJqg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Andrey,

On Fri, Nov 20, 2020 at 10:54:22AM +0100, Andrey Zhizhikin wrote:
> On Fri, Nov 20, 2020 at 8:39 AM Salvatore Bonaccorso <carnil@debian.org> wrote:
> >
> > This reverts commit 168200b6d6ea0cb5765943ec5da5b8149701f36a upstream.
> > (but only from 4.19.y)
> 
> This revert would fail the build of 4.19.y with gcc10, I believe the
> original commit was introduced to address exactly this case. If this
> is intended behavior that 4.19.y is not compiled with newer gcc
> versions - then this revert is OK.

TTBOMK, this would not regress the build for newer gcc (specifically
gcc10) as 4.19.158 is failing perf tool builds there as well (without
the above commit reverted). Just as an example v4.19.y does not have
cff20b3151cc ("perf tests bp_account: Make global variable static")
which is there in v5.6-rc6 to fix build failures with 10.0.1.

But it did regress builds with older gcc's as for instance used in
Debian buster (gcc 8.3.0) since 4.19.152.

Do I possibly miss something? If there is a solution to make it build
with newer GCCs and *not* regress previously working GCC versions then
this is surely the best outcome though.

Regards,
Salvatore
