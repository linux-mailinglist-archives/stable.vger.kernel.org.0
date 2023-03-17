Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 772ED6BE9FD
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 14:21:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbjCQNVn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 09:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbjCQNVn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 09:21:43 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3608474E6;
        Fri, 17 Mar 2023 06:21:41 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id er8so8555026edb.0;
        Fri, 17 Mar 2023 06:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679059300;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SLgOfewvMPWGU0rcCg6ppHB2MURpJza9CN5p/ySPUQ4=;
        b=artZlANRnJSoDpasdGAz9tAGLeKOrBFmIyjNWfKWlV8kLtflWuYpxx9cg7Zs0u06kr
         oFlTS7G5XcISxB0M9Kp7rfKFTWIu4l8V4BUKVcLKqhTGT1f+kdlx3Ozv4muUZmAH4kRy
         OT/WOzolsKOASMj/cbXWRMzWPCUxjDGwt+kEJmmgmzDpyeFbcvqMUMP0nVMtkVdSMMc0
         2fk18i45/v+xKN13oqo39hX0NVad16aVAYLI6FmplGZ2b3HDp9jMrlNh+EXafv9FtuI7
         X3U/KIr6CzFJKKWJoKWPRI4AFx0+lTKpM80wMcSYAb1w3cPlM1Q0MJmUMR+O8EI/J5qJ
         fB5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679059300;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SLgOfewvMPWGU0rcCg6ppHB2MURpJza9CN5p/ySPUQ4=;
        b=iD0LbMPpD5aGncjQMndWKaya+MDqIm3S3H3bIbMkXmqajX/cydoxarqtHmKra8tsQs
         TlyShOSC9gMWga+Hd/UEdJah+/rpUsbMIIM04/iL0HrkSO5Dcl8lMyFVe3MfIPO8tHGL
         U3xQ051euLHGyFB+XaQJXeh1t+G4QB92ntKyaxZaCnUQ2fcVMPNRyF0KcuWV0cQjRcOC
         sDeYUkaJTeU4n4nfKpxrya9k7G33D9wIcKGoWk9AGffqeg5FDZ3plx1TMRsCtl8zHCTE
         Vp1c9a1BfCmRvuYhtvtaQc5DtWQLsne1yjs9jfNWlyNakZxer8PjwZ3ICHUx1WmBR32t
         CMNw==
X-Gm-Message-State: AO0yUKXRcBbnoR/X7VzZkRkDDGOWaoTzMpWV8VvF+OAYTBuw/bHrF+t7
        FnNMLowPi5ENG1gEDEHAdh5TbZlErhOMUPzV8HE=
X-Google-Smtp-Source: AK7set9ANTzdsTwzL3UCfR4HDZWJNPK6TdkWA6M6SDIwGJ1GfPC6MuABd6wOfEMgD66ZPECeashqtmIuHcIJhfvw1PA=
X-Received: by 2002:a17:907:d13:b0:926:5020:1421 with SMTP id
 gn19-20020a1709070d1300b0092650201421mr7804499ejc.9.1679059299875; Fri, 17
 Mar 2023 06:21:39 -0700 (PDT)
MIME-Version: 1.0
References: <20230316094129.846802350@linuxfoundation.org> <ZBQ/rhv9nP+i8Pyc@debian>
 <ZBRjTid0Hc4V7bwB@kroah.com>
In-Reply-To: <ZBRjTid0Hc4V7bwB@kroah.com>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Fri, 17 Mar 2023 13:21:03 +0000
Message-ID: <CADVatmOU9nJQDo7OGDNGppU8eci98yqsJzxYLjT=NPXqv8BbDg@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/27] 4.19.278-rc3 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
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

Hi Greg,

On Fri, 17 Mar 2023 at 12:55, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Fri, Mar 17, 2023 at 10:23:42AM +0000, Sudip Mukherjee wrote:
> > Hi Greg,
> >
> > On Thu, Mar 16, 2023 at 10:42:14AM +0100, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 4.19.278 release.
> > > There are 27 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Sat, 18 Mar 2023 09:41:20 +0000.
> > > Anything received after that time might be too late.
> >
> > Build test (gcc version 11.3.1 20230311):
> > mips: 63 configs -> no  failure
> > arm: 115 configs -> no failure
> > arm64: 2 configs -> no failure
> > x86_64: 4 configs -> no failure
> > alpha allmodconfig -> no failure
> > powerpc allmodconfig -> no failure
> > riscv allmodconfig -> no failure
> > s390 allmodconfig -> no failure
> > xtensa allmodconfig -> no failure
> >
> > Boot test:
> > x86_64: Booted on qemu. No regression. [1]
> >
> > Boot Regression on test laptop:
> > Only black screen but ssh worked, so from the dmesg it seems i915 failed.
>
> Can you bisect this?

There was no need to bisect. Only one i915 related commit was there
and reverting that has fixed it for me.

9a0789a26289 ("drm/i915: Don't use BAR mappings for ring buffers with LLC")
commit 85636167e3206c3fbd52254fc432991cc4e90194 upstream.


-- 
Regards
Sudip
