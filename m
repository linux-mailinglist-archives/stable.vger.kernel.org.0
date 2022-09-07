Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB3275AFD07
	for <lists+stable@lfdr.de>; Wed,  7 Sep 2022 09:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbiIGHCu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Sep 2022 03:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbiIGHCr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Sep 2022 03:02:47 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F11AA1D30;
        Wed,  7 Sep 2022 00:02:23 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id u9so28257713ejy.5;
        Wed, 07 Sep 2022 00:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date;
        bh=T8KpmZhgTa61csuwYkLX3CwUr/M04U7//pbWLlukU+4=;
        b=hGL+QvsGIw6dMyIzaH8CUOyJOXy4CL55iDwJgIMriwnwcrW0ouH5uYWSh/VwZkw+rS
         U0FOk/avlEHXr4lcwnku21t9hvI601CCqkMc4RkG0pHHzdVbLfWnYBXy6/gTii6fTaW7
         DKQ6DN57k2ocY3L7I1DCoSj0PJp6ROgUMiWXCrSueD5H3bw/9Z8EqoaprzyFroYjodrn
         FCM8sCBO1t9CACJV3PtP41tz6wTRz91z5vSsYlLt/DHjeNy/Su1dZBlGFheqSP2hXsAQ
         cQ3HxQ65b+3OF9DLZpa9WK0B5jIEQhOiCmayoiVAinIzjw1YM6jIa/uTbwCSiXHWTjSm
         aRLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date;
        bh=T8KpmZhgTa61csuwYkLX3CwUr/M04U7//pbWLlukU+4=;
        b=LzoRDKAfMD4lNQY4JoJxxUzNhOxbL4iluGmZiDKbPw1JJjrXaeblysbJH79rNbUE/k
         O8Vpl4xZQP8vTZLhhR9awMMkxEDfcRYRsjh6/P1CSHL1zgnDGkn868zTU5gmIvb21Nxj
         i2PJ7Fv6vpJBKCdxX4wD8y63NuzXGPKGJFGFQmG9zRGyst0shK5OPPAFCcjASDLfapUV
         efgzevq1jGzByc15N2J7R9Sdp5VFUOhR+XU8ES+cqf29Nzml4V65foFn8GOGOrIDq+jl
         l7RJq2deD9sNTPUOd89OMc4vdM+SSU3I3uwNq399jHlUZtbUFzCKiygHaRmhgd3iXNIk
         q1dw==
X-Gm-Message-State: ACgBeo2u21i3jQoH/0EEiR83hfensirSS1bhLcFS0CnEQlxOEQP73TVu
        +kGG8gL8X9k0kI0KZmcMHn8=
X-Google-Smtp-Source: AA6agR72IqW+IK5d0DEwIIiw/EZnnuumPFsECyR7SCyROaa3mbHVFDt7fODBPpf9kQ95GogpfH1Ing==
X-Received: by 2002:a17:906:9c82:b0:6df:c5f0:d456 with SMTP id fj2-20020a1709069c8200b006dfc5f0d456mr1377738ejc.287.1662534141434;
        Wed, 07 Sep 2022 00:02:21 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id f18-20020a17090631d200b007336c3f05bdsm7956191ejf.178.2022.09.07.00.02.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 00:02:21 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Wed, 7 Sep 2022 09:02:19 +0200
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Andrii Nakryiko <andrii@kernel.org>
Subject: Re: [PATCH 5.15 101/107] kbuild: Unify options for BTF generation
 for vmlinux and modules
Message-ID: <YxhB+3j6m6FHIanN@krava>
References: <20220906132821.713989422@linuxfoundation.org>
 <20220906132826.130642856@linuxfoundation.org>
 <291d739c-752f-ead3-1974-a136b986afb7@gmail.com>
 <YxguwCpBEKAJJDU6@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxguwCpBEKAJJDU6@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 07, 2022 at 07:40:16AM +0200, Greg Kroah-Hartman wrote:
> On Tue, Sep 06, 2022 at 11:45:00AM -0700, Florian Fainelli wrote:
> > 
> > 
> > On 9/6/2022 6:31 AM, Greg Kroah-Hartman wrote:
> > > From: Jiri Olsa <jolsa@redhat.com>
> > > 
> > > commit e27f05147bff21408c1b8410ad8e90cd286e7952 upstream.
> > > 
> > > Using new PAHOLE_FLAGS variable to pass extra arguments to
> > > pahole for both vmlinux and modules BTF data generation.
> > > 
> > > Adding new scripts/pahole-flags.sh script that detect and
> > > prints pahole options.
> > > 
> > > [ fixed issues found by kernel test robot ]
> > > 
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> > > Acked-by: Andrii Nakryiko <andrii@kernel.org>
> > > Link: https://lore.kernel.org/bpf/20211029125729.70002-1-jolsa@kernel.org
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > ---
> > >   Makefile                  |    3 +++
> > >   scripts/Makefile.modfinal |    2 +-
> > >   scripts/link-vmlinux.sh   |   11 +----------
> > >   scripts/pahole-flags.sh   |   20 ++++++++++++++++++++
> > >   4 files changed, 25 insertions(+), 11 deletions(-)
> > >   create mode 100755 scripts/pahole-flags.sh
> > 
> > My linux-stable-rc/linux-5.15.y checkout shows that scripts/pahole-flags.sh
> > does not have an executable permission and commit
> > 128e3cc0beffc92154d9af6bd8c107f46e830000 ("kbuild: Unify options for BTF
> > generation for vmlinux and modules") does have:
> > 
> > diff --git a/scripts/pahole-flags.sh b/scripts/pahole-flags.sh
> > new file mode 100644
> > index 000000000000..e6093adf4c06
> > 
> > whereas your email does have the proper 100755 permission set on the file,
> > any idea what happened here?
> 
> Yeah, quilt does not like dealing with file permissions at all :(
> 
> We have over time, not required executable permissions on kernel files
> because of this issue.  Is it required here?  If so, I'll try to
> remember to fix it up "by hand".

yes, pahole-flags.sh needs to have +x

thanks,
jirka

> 
> thanks,
> 
> greg k-h
