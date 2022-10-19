Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA2C1604BB2
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 17:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbiJSPhn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 11:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232262AbiJSPhU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 11:37:20 -0400
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C0371AAE4C;
        Wed, 19 Oct 2022 08:33:28 -0700 (PDT)
Received: by mail-wr1-f50.google.com with SMTP id bv10so29661161wrb.4;
        Wed, 19 Oct 2022 08:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ihHBWawYSVwKyvv6HV64hEopZkwL0qL/qygppc8yMYg=;
        b=A5r9N+GRvAJ/HXU6Fgg2ViJs9qWUmb1pWN3Tc5UbOKp2a4KpIwN2xb4gXlT1YGFmIi
         DlnpJQ8/Vh49QCotpW81JboQKj2ZZhW2Rs4krCR+UUKUfysRdm/bhhpPNpX0fcND1QIy
         6Qffls/xoGZ2lNnREdW6wBlhdYKQC1Yc81Omp70PU7B9jXzMP5ujxFwfegkH9ArT7hRZ
         3Mdwn2l37EogYFv635DQ/+C9n+WtpH4Ftq1jB5hnEhJUlgYcBvpxXS0doc7Xuv/et2px
         mBXy/YQNuROyGwi5HBu5RfGBq+3thMbd53YmS6mDEh0RtqBS4Qx1sY/Bl39pLkdrW+Zm
         c9Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ihHBWawYSVwKyvv6HV64hEopZkwL0qL/qygppc8yMYg=;
        b=mpeibBU49FYTBrDw92KQpj+4tzcyXOUPQqRSREI/9BX5snMdugk7Xm5rFotwyFwlCk
         Ot+ShDMostYg159QJCQoSZV/6Z3eZVi2ebgc7E2cbtV2O2xeAC3IZwBe8m76hU07MVQj
         V3JOszkkTzU6lcd4uxw8kn8MoThhPvPrazJYjniT1W4T8h6IlWdYw1CrO1srU0kzcEZn
         C84IwFOlPGpfKo5rRkjJ6ZnDqErPCKSr+79+jIlPyCOvpLGHxai7OcoRGN2LEzQyRg6X
         q4bxErH0ksm9Ky17qqDSDi9yscFe9WgDPesQba+hDAAOh5S9YsLtaHnqppo7JvHtqeBX
         vAZQ==
X-Gm-Message-State: ACrzQf1KW4POIRR4m/0JJUiSrBOo4mmwxXCdGVK/Ogn1LtzUiHsR1KPm
        IkBBbd59Kj1L/jKmJzxdN70=
X-Google-Smtp-Source: AMsMyM5WP6K7DytpJoV74bCrxXaV3ao02SD74GEl4lhFAcTZpX3RZL7m/wzGjkAgRl/W8ZuVxpfZDw==
X-Received: by 2002:adf:a459:0:b0:22e:3725:ba17 with SMTP id e25-20020adfa459000000b0022e3725ba17mr5595034wra.110.1666193454303;
        Wed, 19 Oct 2022 08:30:54 -0700 (PDT)
Received: from krava ([83.240.63.167])
        by smtp.gmail.com with ESMTPSA id l1-20020a5d4bc1000000b0022afe4fb459sm9181171wrt.51.2022.10.19.08.30.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 08:30:53 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Wed, 19 Oct 2022 17:30:52 +0200
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org, bpf@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Rodriguez Reboredo <yakoyoku@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Philip =?iso-8859-1?Q?M=FCller?= <philm@manjaro.org>
Subject: Re: [PATCH stable 5.10 0/5] kbuild: Fix compilation for latest
 pahole release
Message-ID: <Y1AYK0n+HcLZ1oCZ@krava>
References: <20221019085604.1017583-1-jolsa@kernel.org>
 <Y1AP8h6YGiDZAgyp@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1AP8h6YGiDZAgyp@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 19, 2022 at 04:55:46PM +0200, Greg KH wrote:
> On Wed, Oct 19, 2022 at 10:55:59AM +0200, Jiri Olsa wrote:
> > hi,
> > new version of pahole (1.24) is causing compilation fail for 5.10
> > stable kernel, discussed in here [1][2]. Sending fix for that plus
> > dependency patches.
> > 
> > thanks,
> > jirka
> > 
> > 
> > [1] https://lore.kernel.org/bpf/20220825163538.vajnsv3xcpbhl47v@altlinux.org/
> > [2] https://lore.kernel.org/bpf/YwQRKkmWqsf%2FDu6A@kernel.org/
> > ---
> > Andrii Nakryiko (1):
> >       kbuild: skip per-CPU BTF generation for pahole v1.18-v1.21
> > 
> > Ilya Leoshkevich (1):
> >       bpf: Generate BTF_KIND_FLOAT when linking vmlinux
> > 
> > Javier Martinez Canillas (1):
> >       kbuild: Quote OBJCOPY var to avoid a pahole call break the build
> > 
> > Jiri Olsa (1):
> >       kbuild: Unify options for BTF generation for vmlinux and modules
> > 
> > Martin Rodriguez Reboredo (1):
> >       kbuild: Add skip_encoding_btf_enum64 option to pahole
> > 
> >  Makefile                |  3 +++
> >  scripts/link-vmlinux.sh |  2 +-
> >  scripts/pahole-flags.sh | 21 +++++++++++++++++++++
> >  3 files changed, 25 insertions(+), 1 deletion(-)
> >  create mode 100755 scripts/pahole-flags.sh
> 
> Ah, all showed up now.  I'll look at these tomorrow, thanks!

great, thanks

jirka
