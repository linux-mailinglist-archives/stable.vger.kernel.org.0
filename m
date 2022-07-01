Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEE056316A
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 12:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235874AbiGAKbm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jul 2022 06:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236027AbiGAKbj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jul 2022 06:31:39 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05AF776EA6;
        Fri,  1 Jul 2022 03:31:31 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id i1so2532329wrb.11;
        Fri, 01 Jul 2022 03:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sv8ru5AJgoX0HDjn/lbin4Grg0LxZIxlKrPOk1Csv5I=;
        b=PgViZDb+ngMwgBeAZmC3Dg79CjeuIKAqyf+tBRLDGUlp9b+3YVf7L00ru3+M1s1xiN
         okE38/BmAk6b4OGQTgjzCnLbWt/1rRfSHKkcLTOJiXVVnD+V3DxKyZ7yl7hXWT+Cx+yX
         YfjaSW2tvCQ9ttDTUyGBANphA0yxFDZMqoKNcQWUrpmm2XP9ft1UaZLVbVaGxcESH89+
         /CmhYbx5qOnqsABRVJQNO8Im++ZILci3WEshcH7+Eq/3503zRTrGXtqQu8rHZpyRhXBC
         dBzuWqMI7nbT1250GzOU/ClzO/jtQEZarPeYxElWOnw4aAI/MKNt6IB9sRYOkCwU5MiZ
         H/Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sv8ru5AJgoX0HDjn/lbin4Grg0LxZIxlKrPOk1Csv5I=;
        b=kaqd3xbuYRpKKyIEjIy4Q0o52f3ieYKw0pwRTc9HeSWjS5ZGtI4/0wXbadhgS3fXGb
         phyouwAeT1StS1gSk+tD0BLOE/sueRbYMWA2sETSNuohIF+1MmWfwnxgxjr+ZbyLX3kw
         22ZbEArVxd0JbohcC44+7IqyeBf7aWsxwk0p2GBNubyreGRGQHZYlHhwP9Q7b7/s6DrC
         uzKzaCyNu8PbGqG1erCA036ivZQw+FQAWp6RWOREXPDvZI1l1p9Q5Gke/WCv32dPA1Bf
         Lze/sfJiPi7lGYKVQHY8B8ETOPDjiTi9qAPZ6VWVOZIaTCiw36040HLBPnTJN/VLkz2m
         Isfg==
X-Gm-Message-State: AJIora9qiaaQsNhf9HKWOEwZvuPByhBiXfP/BcduQ6ITedHzn2qyac2w
        lwuob7oS5GVDphOnhfOvZP8=
X-Google-Smtp-Source: AGRyM1srilE6HugJRSarEQjn9CYMxgu6Q9D36WX4+u2UgfZyWuGsspHUz67iS1ZLgRB68SNsEecRHQ==
X-Received: by 2002:a5d:518f:0:b0:21b:8a8c:ce4 with SMTP id k15-20020a5d518f000000b0021b8a8c0ce4mr13326621wrv.614.1656671489454;
        Fri, 01 Jul 2022 03:31:29 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id j22-20020a05600c485600b003a04b248896sm5982113wmo.35.2022.07.01.03.31.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 03:31:29 -0700 (PDT)
Date:   Fri, 1 Jul 2022 11:31:27 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, slade@sladewatkins.com,
        Paulo Alcantara <pc@cjr.nz>,
        Enzo Matsumiya <ematsumiya@suse.de>,
        Steve French <stfrench@microsoft.com>
Subject: Re: [PATCH 5.18 0/6] 5.18.9-rc1 review
Message-ID: <Yr7M//9X8RdNz+Hu@debian>
References: <20220630133230.239507521@linuxfoundation.org>
 <Yr6pTvc0Zka7qVfc@debian.me>
 <Yr6vKgOmqF562oc+@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yr6vKgOmqF562oc+@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 01, 2022 at 10:24:10AM +0200, Greg Kroah-Hartman wrote:
> On Fri, Jul 01, 2022 at 02:59:10PM +0700, Bagas Sanjaya wrote:
> > On Thu, Jun 30, 2022 at 03:47:26PM +0200, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.18.9 release.
> > > There are 6 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > 
> > Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 12.1.0)
> > and powerpc (ps3_defconfig, GCC 12.1.0).
> > 
> > I get a warning on cifs:
> > 
> >   CC [M]  fs/cifs/connect.o
> >   CC      drivers/tty/tty_baudrate.o
> >   CC      drivers/tty/tty_jobctrl.o
> > fs/cifs/connect.c: In function 'is_path_remote':
> > fs/cifs/connect.c:3426:14: warning: unused variable 'nodfs' [-Wunused-variable]
> >  3426 |         bool nodfs = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS;
> >       |              ^~~~~
> > 
> > The culprit is commit 2340f1adf9fbb3 ("cifs: don't call
> > cifs_dfs_query_info_nonascii_quirk() if nodfs was set") (upstream commit
> > 421ef3d56513b2).
> 
> Again, gcc-12 is going to have problems with stable releases until
> Linus's tree is fixed up entirely.  Once that happens, then I will take
> backports to stable kernels to get them to build properly.

I have not tested, but this should be fixed by this one:

93ed91c020aa ("cifs: fix minor compile warning")

--
Regards
Sudip
