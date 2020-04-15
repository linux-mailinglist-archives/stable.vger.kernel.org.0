Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12FFF1AB059
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 20:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405879AbgDOSIM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 14:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404936AbgDOSIK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 14:08:10 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58187C061A0C
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 11:08:10 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id d24so300442pll.8
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 11:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YDHyq/Q1NFvf4g+5tWc+Y7Lxmu+Mz9adPPrk9AeWm6A=;
        b=Za4TGYuOVvVItnZcBX7h1YJRkcY1q4tpZEVVHewKJoAG29HtznS6uZaenqj9rERo0A
         u0cke2SBNksqpU6HTgba5yfC5tItp8n0HIvfjlv4UJoJxTkvAHuLR/vgTnfqzRVW4KFG
         hsWZq/VEHcXHbtMmZKTbEAJ3NVY2fhSb8k3xY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YDHyq/Q1NFvf4g+5tWc+Y7Lxmu+Mz9adPPrk9AeWm6A=;
        b=EpOdLY4OCZBk1m74gDMa+DzQJNTAwiTbKjOVRciqo1qxJQYf5bJoHVLKK34TFjFy0T
         hT3JzEVm4z8RxvbXdqeu4xSoU1F8zqq18c/vZe3o5OCBLVLp77kbU+ErTEiNQHEZVUYu
         laDm5lryImEn+f+0KyLi3wcdvfAZ771f27cAwx29AUZJ/cwku3RhG4SJrOyfLM8N8YZt
         dtkJ27UdnAi398w7LEesvi8+dN0gNf/K1KaYhhEleZA29o44/EjD0GRWqxIN9gfkhFZx
         Eyh1l4LBHkHhie5csWLGDuoS+Ql1eFLpnRzAtPLPT0CIaLBrpLLGJmilnioxSr+yH+qd
         kLMA==
X-Gm-Message-State: AGi0PuY5JARg3QPAyup6KfGWazHVyhmiSGYu8/SwVVJ9AO3YPoZyyY6b
        3shzIN5uKEwky1K/nEHnF4D/KA==
X-Google-Smtp-Source: APiQypLcLfvNOWCbXfRAc0v6ygfVjFdhoM13aKQwaUMf6w3W4Mxi9iSkljEimGVNT4u0cYLUSQDgWA==
X-Received: by 2002:a17:90a:2602:: with SMTP id l2mr547841pje.110.1586974089803;
        Wed, 15 Apr 2020 11:08:09 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id e12sm14302203pfn.194.2020.04.15.11.08.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2020 11:08:08 -0700 (PDT)
Date:   Wed, 15 Apr 2020 11:08:07 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Guenter Roeck <groeck@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        kbuild test robot <lkp@intel.com>,
        cros-kernel-buildreports@googlegroups.com, kbuild-all@lists.01.org,
        clang-built-linux <clang-built-linux@googlegroups.com>
Subject: Re: [chrome-os:chromeos-4.19 21350/21402]
 drivers/misc/echo/echo.c:384:27: error: equality comparison with extraneous
 parentheses
Message-ID: <202004151103.B419F67@keescook>
References: <202004150637.9F62YI28%lkp@intel.com>
 <20200415002618.GB19509@ubuntu-s3-xlarge-x86>
 <CABXOdTd-TSKR+x4ALQXAD9VGxd4sQCCVC9hzdGamyUr-ndBJ+w@mail.gmail.com>
 <CAKwvOdnOuMcjzsqTt2aVtoiKN3L9zOONGX-4BJgRWedeWspWTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdnOuMcjzsqTt2aVtoiKN3L9zOONGX-4BJgRWedeWspWTA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 15, 2020 at 10:51:37AM -0700, 'Nick Desaulniers' via Clang Built Linux wrote:
> `git describe --contains "$tag" | sed 's/~.*//'` is my trick for
> finding the first tag that contained a commit.

BTW, this might be a useful tweak: since I have so many tags in my tree
beyond just Linus's tags (e.g. from linux-next), I also include "--match
'v*'". My ~/bin/git-contains is:

git describe --match 'v*' --contains "$1" | cut -d~ -f1 | cut -d^ -f1

(without this, my "git contains 85dc2c65e6c9" would report "next-20180927")

-- 
Kees Cook
