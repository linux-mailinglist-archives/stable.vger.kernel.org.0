Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC3EB54D08C
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 20:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355176AbiFOSAa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jun 2022 14:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236325AbiFOSA3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jun 2022 14:00:29 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3DF02A718;
        Wed, 15 Jun 2022 11:00:28 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id w21so12169579pfc.0;
        Wed, 15 Jun 2022 11:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qMYjlX/UBpwrjGqKKro02HBfwEFDYsK2XO45mdFo3rc=;
        b=iWL6biHGhBZeoAug+7fTwhF5Z8oRPErcQ4qaaKocRXNdOEVfGRaDcnV7jYQW9IEYTc
         J0TWgdDXdbgGuW4xxy1+AGRhWWuacHBD6yw73HBcyGBJk173czqkY4NdE9aj5/yu2ynt
         NFn9TLNSeUYpuO/AgFOKym3dn0ls/qzUnA3fUU8MeXtP9PFHWstAdePV0a/9pCcnpMKw
         nJpcLnP8AfxVDHLjl9KgCwBboOnYXbC25kiNPzskKdm2lzHtAXHZPJ3b1iFFnyMH0uHP
         35ah/WzMPy7Suq7zlC+uR46IW58giQharwLIRdr3r7AR3PHXrTNSubXUCJWeH4UnwS8N
         LsVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=qMYjlX/UBpwrjGqKKro02HBfwEFDYsK2XO45mdFo3rc=;
        b=cfJ0M2osXn8jcGBnuppK0G8PMfIJ0yU01KpTVQbjh9rfNz4iVp5miW39dKoQqzu3mt
         tElOM57xphkh5oy3GrfeGlN41my1S8rkvXOv081QCYOvvH2caRyIBM0wbUXwaUlwDEi5
         bJ/K0017ngbwaouXikYjQQNLMaNX+0TtynEJ+nYqw1Jgti1bwtbCdyGUTfQE+xQvSsOZ
         35Z0qSnRBnpqWEGCjYbIEgLPc7oHN/CiRw7Ohn96Yhj0dDr1zYjfhfCb75JMIxI/k4Mk
         UemnHJ333AsKRB6loEMQQuHVpvN4Uy4TqVKALfCMVJ9iHtY8nMKaDxUhQgY77p2MbHid
         w/SA==
X-Gm-Message-State: AJIora+u6c2BNrRDiPw3H4XuuPzA1OmXtWggzi9fXBVnu1kSliNPDYCk
        fTDvJjOE2/4QxaCZxSxFlKFni+tMrTg=
X-Google-Smtp-Source: AGRyM1s/f3aI6ssGuwvM1/e5X3UzRfBKmv9Krzu4r8jYIO/OY3lPSWmIxHHmAHSAkD7bBd/YaWUIkw==
X-Received: by 2002:a63:6f8c:0:b0:408:bdc6:7726 with SMTP id k134-20020a636f8c000000b00408bdc67726mr916000pgc.110.1655316028285;
        Wed, 15 Jun 2022 11:00:28 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m24-20020a170902bb9800b0016203a92865sm9605090pls.107.2022.06.15.11.00.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 11:00:27 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 15 Jun 2022 11:00:26 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Jan Kara <jack@suse.cz>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Backlund <tmb@tmb.nu>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Slade Watkins <slade@sladewatkins.com>
Subject: Re: [PATCH 5.15 000/251] 5.15.47-rc2 review
Message-ID: <20220615180026.GA2146974@roeck-us.net>
References: <bd80cd0d-a364-4ebd-2a89-933f79eaf4c7@tmb.nu>
 <CAHk-=wix7+mGzS-hANyk7DZsZ1NgGMHjPzSQKggEomYrRCrP_Q@mail.gmail.com>
 <CAHk-=wgfFhwMP0=QQY_iZvf0kveR5=VGK919Ayn+ZSUADs9mag@mail.gmail.com>
 <20220615110022.yifrsvzxjsz2wky5@quack3.lan>
 <20220615133845.o2lzfe5s4dzdfvtg@quack3.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220615133845.o2lzfe5s4dzdfvtg@quack3.lan>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 15, 2022 at 03:38:45PM +0200, Jan Kara wrote:
> On Wed 15-06-22 13:00:22, Jan Kara wrote:
> > On Tue 14-06-22 12:00:22, Linus Torvalds wrote:
> > > On Tue, Jun 14, 2022 at 11:51 AM Linus Torvalds
> > > <torvalds@linux-foundation.org> wrote:
> > > >
> > > > Or just make sure that noop_backing_dev_info is fully initialized
> > > > before it's used.
> > > 
> > > I don't see any real reason why that
> > > 
> > >     err = bdi_init(&noop_backing_dev_info);
> > > 
> > > couldn't just be done very early. Maybe as the first call in
> > > driver_init(), before the whole devtmpfs_init() etc.
> > 
> > I've checked the dependencies and cgroups (which are the only non-trivial
> > dependency besides per-CPU infrastructure) are initialized early enough so
> > it should work fine. So let's try that.
> 
> Attached patch boots for me. Guys, who was able to reproduce the failure: Can
> you please confirm this patch fixes your problem?
> 

It does for me.

> 								Honza
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR

> From 8f998b182be7563fc92aa8914cc7d21f75a3c20e Mon Sep 17 00:00:00 2001
> From: Jan Kara <jack@suse.cz>
> Date: Wed, 15 Jun 2022 15:22:29 +0200
> Subject: [PATCH] init: Initialized noop_backing_dev_info early
> 
> noop_backing_dev_info is used by superblocks of various
> pseudofilesystems such as kdevtmpfs. Initialize it before the
> filesystems get mounted.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
