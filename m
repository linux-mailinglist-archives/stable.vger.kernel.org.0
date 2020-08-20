Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33A2E24C6D5
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 22:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728453AbgHTUou (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 16:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728451AbgHTUou (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 16:44:50 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB70AC061385
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 13:44:48 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id 189so1687206pgg.13
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 13:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KXZ8XRMr1Gmt/6K8FfPiHZ68xI+BG1SYO5TQlLXsgOM=;
        b=ItQHzJgVJ+6LOguM2wyax6r96DFqEdZNp7OApIBvkHVH5+wCTlM4DzZyT9plsf7lHT
         /dZWso7elWIRDqNuqrxgPpUr7pOUuI8xbes86AwCM2I38wypTG1TSouWPwY4FiBJ7dPi
         /6AKI4W3T8jJJPaJQTFR6Nty8/Tj4dz96JjFA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KXZ8XRMr1Gmt/6K8FfPiHZ68xI+BG1SYO5TQlLXsgOM=;
        b=sV2FZxWP0PHCZ+7vz0asnKb3/NOVMPhfrYKJAOvkg+4sS1T46nRjxYW/9IZT/2c2DE
         OLLvKPhZUJxIaWrCnitPIAY8m/yVJ7BQ/IPr3JiZXmlg8w1iVsdqgrb7b8ZEFpa92yuz
         FaAJ4Tq56j5Q+bd2mwLtnjNIGh8ujmNke63jeh4itSIztTqkINSQgpBivEucYNOj7BRz
         Ogmv0CdOVtomAaWJzko2PFL07ICfDBI6s++2W647iqSdz7UzJJOQ0hg9UA7EkE5Vj/wj
         FpEqczDiGoJzaFaJcOX++tuqyEocSA/BIRAFQlZt/1PsWLIDs5ypawYI+7mkCW1Tvi4R
         ZyVg==
X-Gm-Message-State: AOAM533BIXDcpxumAYCu9F3Ah6CYOdq6D9uzcQ0g/DJZK9PdjRUhRoW9
        uMFM0a8uxyYySsYo34fJkFIRkj5RigsNDQ==
X-Google-Smtp-Source: ABdhPJxA/HzIe1deXkeM9AUoZWRlN6GDhbFRTj56OXW4gY/KgYFljYaS9q7fzTWFn3Y2/5I1fjio3w==
X-Received: by 2002:a63:143:: with SMTP id 64mr371803pgb.343.1597956288300;
        Thu, 20 Aug 2020 13:44:48 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id a15sm3638741pfo.185.2020.08.20.13.44.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2020 13:44:46 -0700 (PDT)
Date:   Thu, 20 Aug 2020 13:44:45 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Dmitry Golovin <dima@golovin.in>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Fangrui Song <maskray@google.com>,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: LLVM=1 patches for 5.4
Message-ID: <202008201339.879ABA0@keescook>
References: <CAKwvOd=Ko_UHWF-bYotqjPVw=chW_KMUFuBp_o8uOg0wOyHyWA@mail.gmail.com>
 <CAKwvOd=ojdFXs1ceoBwSnFBzyP7PW+-AknF0WjgJix60BKdgZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOd=ojdFXs1ceoBwSnFBzyP7PW+-AknF0WjgJix60BKdgZQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 20, 2020 at 01:27:32PM -0700, Nick Desaulniers wrote:
> On Thu, Aug 20, 2020 at 1:14 PM Nick Desaulniers
> <ndesaulniers@google.com> wrote:
> 
> Oh, I almost forgot, here's a picture of my cat who helped me by
> trying to lay on my keyboard mid-interactive rebase of this series.
> https://photos.app.goo.gl/J7CtBJtHmiuzhSfq7
> I asked him nicely to move; he proceeded to bite me, and not comply.

I think this needs to be an ongoing change to the stable kernel process.
Since such things require documentation, I propose:


diff --git a/Documentation/process/stable-kernel-rules.rst b/Documentation/process/stable-kernel-rules.rst
index 06f743b612c4..928f6f3ce6e2 100644
--- a/Documentation/process/stable-kernel-rules.rst
+++ b/Documentation/process/stable-kernel-rules.rst
@@ -35,6 +35,7 @@ Rules on what kind of patches are accepted, and which ones are not, into the
 Procedure for submitting patches to the -stable tree
 ----------------------------------------------------
 
+ - Preference may be given to submissions featuring pictures of cats. Also dogs.
  - If the patch covers files in net/ or drivers/net please follow netdev stable
    submission guidelines as described in
    :ref:`Documentation/networking/netdev-FAQ.rst <netdev-FAQ>`


> > Dear stable kernel maintainers,
> > Please consider the attached mbox file, which contains 9 patches which
> > cherry pick cleanly onto 5.4:
> >
> > 1. commit fcf1b6a35c16 ("Documentation/llvm: add documentation on
> > building w/ Clang/LLVM")
> > 2. commit 0f44fbc162b7 ("Documentation/llvm: fix the name of llvm-size")
> > 3. commit 63b903dfebde ("net: wan: wanxl: use allow to pass
> > CROSS_COMPILE_M68k for rebuilding firmware")
> > 4. commit 734f3719d343 ("net: wan: wanxl: use $(M68KCC) instead of
> > $(M68KAS) for rebuilding firmware")
> > 5. commit eefb8c124fd9 ("x86/boot: kbuild: allow readelf executable to
> > be specified")
> > 6. commit 94f7345b7124 ("kbuild: remove PYTHON2 variable")
> > 7. commit aa824e0c962b ("kbuild: remove AS variable")
> > 8. commit 7e20e47c70f8 ("kbuild: replace AS=clang with LLVM_IAS=1")
> > 9. commit a0d1c951ef08 ("kbuild: support LLVM=1 to switch the default
> > tools to Clang/LLVM")

And FWIW, "yes please" from me as well. This makes things muuuch easier
to test LTS with Clang.

-- 
Kees Cook
