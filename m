Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0A72C4CB4
	for <lists+stable@lfdr.de>; Thu, 26 Nov 2020 02:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731709AbgKZBf3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 20:35:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731378AbgKZBf2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Nov 2020 20:35:28 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B17C9C0613D4
        for <stable@vger.kernel.org>; Wed, 25 Nov 2020 17:35:28 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id s21so134136pfu.13
        for <stable@vger.kernel.org>; Wed, 25 Nov 2020 17:35:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jvZUrj/D59tQDKY9E7neBPUnuFVhH8tjPM+xd8IFwYI=;
        b=rJo7aYao/s1RI1bCG5NTKz5B98x/k1LCyBkx0jeKNQ1pp57TLCCPz5tFNmGPBov6Yd
         NZ5B8EUvDMmpRUhIOwgSlqNmEvVzj1khRqoCt76vZouGp9UaXcGLACiLJdv3iMLps7vT
         p9a2vUu8DuCTHOzyofIk+PkGGaNHnzC2kNmYP0qxSfc30K13YtCtaDbKtuQrOykmA+er
         ynGzujCFJoFgZwkK9U/GHMfRTRvelrpWA6WZOKksdKVQA+zbxWhSoXyj+VMQ6dhmjgNm
         uG1VoDvS+auw51QqeJz8x6ntDmH9/pMJrog/HT42ZiLelBnGwQ9A3MbMIppMetdXNKat
         B2fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jvZUrj/D59tQDKY9E7neBPUnuFVhH8tjPM+xd8IFwYI=;
        b=ikUgkGAE/FI6b0o8iHbkpEYM3ltOtanThRysS0+FSKEn5QPJtPNpoEJ/OkSWTLYnQs
         PEwNS2FC/e2sUrdZru/o47Tf50DlLVBYB1xcSIkwLaz/xhwrvGF3zhjOx3hpCs58kNuM
         8VzgQjgVPb+daiFoFeltKUs8q6MhD+EEmRadAKAAe1LEMt6NFocW2SES4d3gHUr2wT2h
         4+O+dF57WPa/MbMz53fXXCbv5YVyFBFC3Nx++uTHlN6Wrz4H8TVm2ehg/rlPh35WGiYx
         jIvWDDY0KKu8PC+1fMdYDC/a6rw5BnNTQM6MtBULyjMRWknpwUBatB5gCnm/asEw2/Oy
         bGgw==
X-Gm-Message-State: AOAM530t/EeaL45A5nrdckffWBIU1nihg+aDNLuf5Siu7gLImoZiosfw
        oYDGXjCcLuNhFXBciBTIW8AXWA==
X-Google-Smtp-Source: ABdhPJyfl78Z/V9ZdrvoPiAddcJuPPTvdFEzdUbsziPwmpvKTpZhVAF5zW88miVYmCNLs/3OfM6oow==
X-Received: by 2002:a63:3083:: with SMTP id w125mr597842pgw.276.1606354528163;
        Wed, 25 Nov 2020 17:35:28 -0800 (PST)
Received: from leoy-ThinkPad-X240s ([103.127.239.100])
        by smtp.gmail.com with ESMTPSA id 21sm2928224pfj.134.2020.11.25.17.35.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 25 Nov 2020 17:35:27 -0800 (PST)
Date:   Thu, 26 Nov 2020 09:35:22 +0800
From:   Leo Yan <leo.yan@linaro.org>
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     stable@vger.kernel.org, Andrey Zhizhikin <andrey.z@gmail.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Mike Leach <mike.leach@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Robert Walker <robert.walker@arm.com>,
        Suzuki K Poulouse <suzuki.poulose@arm.com>,
        coresight ml <coresight@lists.linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 1/2] perf cs-etm: Change tuple from traceID-CPU# to
 traceID-metadata
Message-ID: <20201126013522.GB31690@leoy-ThinkPad-X240s>
References: <20201122134339.GA6071@leoy-ThinkPad-X240s>
 <20201125201215.26455-1-carnil@debian.org>
 <X769O4RFFPyfQaDT@eldamar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X769O4RFFPyfQaDT@eldamar.lan>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 25, 2020 at 09:23:23PM +0100, Salvatore Bonaccorso wrote:
> On Wed, Nov 25, 2020 at 09:12:14PM +0100, Salvatore Bonaccorso wrote:
> > From: Leo Yan <leo.yan@linaro.org>
> > 
> > commit 95c6fe970a0160cb770c5dce9f80311b42d030c0 upstream.

[...]

> That's a fallout on my end. Should have said: This is for 4.19
> specifically to be queued.
> 
> Background: in
> https://lore.kernel.org/stable/20201014135627.GA3698844@kroah.com/
> 168200b6d6ea0cb5765943ec5da5b8149701f36a was queued up for v4.19.y but
> the prerequeisite commit was not included and so resulted in build
> failures with gcc 8.3.0.
> 
> The commit was later on reverted but in this thread it was asked to
> actually make it possible to compile the file as well with more recent
> gcc versions.
> 
> Those two patches to be applied in 4.19.y only pick up a backport of
> the rerequisite commit 95c6fe970a0160cb770c5dce9f80311b42d030c0 (PATCH
> 1) followed up by the cherry-pick of
> 168200b6d6ea0cb5765943ec5da5b8149701f36a again.

Since the patch 01 is minor tweaked due to context difference, I
manually compared it with original patch and looks good to me.

Thank you for the back porting,
Leo
