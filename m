Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB67E60E6C2
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 19:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233884AbiJZRu7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 13:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233683AbiJZRu6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 13:50:58 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 005B63FF1D
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 10:50:57 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id k22so4437781pfd.3
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 10:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=T2h24MH4MSet5fkWfX3uTwFzD+dW0H4QpEU+raKyOqA=;
        b=ivQLeLZ7BsAExAyxGKVCHq+ccRyYQoBFMoIYAhYmWOheKCynITfHW9wcE8cvx+bO+i
         RvtQSLcZWGZh11U0y8Qy00JtpimkdWsDkS0vht2EbaGibQZa2l4Sln0asdhIuo8SW9mV
         Jm1iuymvdc2KMSPY841iuEU6eyMeimXob4i77baN0WHc01RQl+YWuQh9CBZPYc5wYeld
         IsPzJQg1aOzj2kv9GnFc0Vg6VjeRv+EBwfE7eioqhDCl1Iw2Q/YtN38pHCVZAzk8kXne
         t6fS70VEdGXLJajYsWtPLlLN5VgOP8hu4Wuy809RVGWWCtoEb8kVK3IcYbDtMabO7dV+
         Fr8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T2h24MH4MSet5fkWfX3uTwFzD+dW0H4QpEU+raKyOqA=;
        b=L3TeJ4xOegWYOHSebRftwL49bNz0Vu1ESOCyYuVRffZ+WhJcYbbndjZCutAD8fzbP5
         qCjGnnJ+bgpscvoOTTFibk2/KI47PBafQsnSdDO4uPfDfVPqjwA8vjGzv2oj4jNMkNHt
         K+e/qTsYZh4iCiMMGe7Niz3lElBjFI0Og3nLPVC289+6/T4r59VaDGaOsUbxA8j9rdd0
         b0SjN40/Ikbpw9T1yHB7PbYrAO+P7JurkDOk2WQDvjUhifSKddnqKTl+YYwhtQfprnw2
         RclyLkagf1zzanntHaeds/D7hce/M9gdSYn4VtogDLMyI1OY1tRm/boedBsg855JfjoA
         gjDw==
X-Gm-Message-State: ACrzQf2KJ9AYTY0KpGTo7v+ZjsimSqYoLmYONBmAstk0WdOE0pLdG0h6
        7LwNdwzU4ieOZz2rcdD5GgRPCLzXJ2ZCC/ramHmUiA==
X-Google-Smtp-Source: AMsMyM46VDtfzl95K+DwkdIa1+TlZcE/UPAk9Yg5rP8k+RWwHCoiFIRmvTiAHL4HsfKsaUjxj/wh7ktvYCdsXWbq5U0=
X-Received: by 2002:a63:2cd2:0:b0:41c:5901:67d8 with SMTP id
 s201-20020a632cd2000000b0041c590167d8mr38428132pgs.365.1666806657224; Wed, 26
 Oct 2022 10:50:57 -0700 (PDT)
MIME-Version: 1.0
References: <CAKwvOdneUW4e9==CABAk68uePCGNt7Sq6P-84tR41HRB23zFTA@mail.gmail.com>
 <Y1gUoS73T4nycQwr@dev-arch.thelio-3990X>
In-Reply-To: <Y1gUoS73T4nycQwr@dev-arch.thelio-3990X>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 26 Oct 2022 10:50:45 -0700
Message-ID: <CAKwvOdkR6Xb4LeJM6K4g-Vdyg9=osfjwphvJzmGxkQa33zqcVQ@mail.gmail.com>
Subject: Re: backports of 32ef9e5054ec ("Makefile.debug: re-enable debug info
 for .S files")
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        clang-built-linux <llvm@lists.linux.dev>,
        Alexey Alexandrov <aalexand@google.com>,
        Bill Wendling <morbo@google.com>,
        Greg Thelen <gthelen@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 25, 2022 at 9:53 AM Nathan Chancellor <nathan@kernel.org> wrote:
>
> On Mon, Oct 24, 2022 at 02:06:52PM -0700, Nick Desaulniers wrote:
> > Dear stable kernel maintainers,
> > Our production kernel team and ChromeOS kernel teams are reporting
> > that they are unable to symbolize addresses of symbols defined in
> > assembly sources due to a regression I caused with
> >     commit a66049e2cf0e ("Kbuild: make DWARF version a choice")
>
> I think you mean commit b8a9092330da ("Kbuild: do not emit debug info
> for assembly with LLVM_IAS=1"), which is what you blamed in
> 32ef9e5054ec? a66049e2cf0e does not appear to have any affect on this
> problem?

Ah right, grabbed the wrong sha from the commit messages.

Not an issue in the patches, just the initial email I sent. Should
still be good for stable maintainers to pick up.

>
> > I fixed this upstream with
> >     commit 32ef9e5054ec ("Makefile.debug: re-enable debug info for .S files")
> > but I think this is infeasible to backport through to 4.19.y.
> >
> > Do the attached branch-specific variants look acceptable?
>
> I think the stable specific versions should be okay. We should be able
> to deal with any fallout that happens if there is any.
>
> Acked-by: Nathan Chancellor <nathan@kernel.org>

Thanks for triple checking!
-- 
Thanks,
~Nick Desaulniers
