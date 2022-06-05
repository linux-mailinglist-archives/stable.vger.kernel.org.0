Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B252B53DAA5
	for <lists+stable@lfdr.de>; Sun,  5 Jun 2022 09:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244245AbiFEHC3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Jun 2022 03:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244353AbiFEHC1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Jun 2022 03:02:27 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B82D9FD07;
        Sun,  5 Jun 2022 00:02:25 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id b5so9846302plx.10;
        Sun, 05 Jun 2022 00:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xTSZnsm+i5vZpjJh7Qae5uGLg8nommiIywZZlwG2gf0=;
        b=Bg9VhtXcO0LjuceuBlWpC9vAd8cqATf0FtbMF3eBgpjKkn/HcB3T/KbJCYtuo76jmR
         o4DhTPKnjQNMrMFr4fhjwx6IShwQ29aa+OBXAsq3BMEG8YGO6eR0+8YL2zMueN5sN+qK
         VTBb7eOxrLEitgLDEnwkZGf8W/YjpKBgoAjezWwbDYR62+e8GCUndHeHIS5zlK7fEHSj
         2JzhE2o97dldciA8vu6LccoNEqTHJbiKK+Umn12WqBTwbkkbKaacLS3gnpcvpSz1pqof
         0qPnmSD7jvezzioIQ4pGDUiJEi+ObwmwpJzlzK7wBLZavytH+7ZMKmYm7p/7B9JHv6V0
         0tvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xTSZnsm+i5vZpjJh7Qae5uGLg8nommiIywZZlwG2gf0=;
        b=picrGgdBwTFdhOcUxd1gemHLqe0YcMDxcsQdsqm8c3DBjfbSul3MouAlWamGnqbRxd
         n6xPuZqc8wY+8w7U1U3oR6pti3LCUPL1rAKQlm/wcKaX3xObR/7O8c8cYdLQQCuKi7O5
         DZlqnXUu5b+URKmQvw7YbECvpfHmSUK7DFv9SM1fnBzNvMTAFxkUfc1hrc3XzTkVNxWz
         7vjU7EzD7WxurR2Jwehxrt1Uz4PqKjPRrDSBbevD2mMj+esnbrFjlyH2w2qlb8TeOT6a
         Z/s67rd1Q/Hq+sK+T7TKLpfdFx9msGQc8IyzFvEnOLuBllhcHGAKCphZQMm7O3FdbZaK
         Kt2w==
X-Gm-Message-State: AOAM532dPJzqInODMAKMIQRQ6K8cKhb6EdTVtgr3o//Ea9ooeuCyyT2Q
        DXYo+d4q1OrbvHhlVZ18f+M=
X-Google-Smtp-Source: ABdhPJwjqC+H25hvogaEdMdvMycxLbW3RYeRyS+e0bQzlYkLpveaXWQSQoKdhncPJm2py02puE0Yxg==
X-Received: by 2002:a17:902:b58c:b0:163:920c:6164 with SMTP id a12-20020a170902b58c00b00163920c6164mr18686484pls.58.1654412544689;
        Sun, 05 Jun 2022 00:02:24 -0700 (PDT)
Received: from localhost (subs28-116-206-12-32.three.co.id. [116.206.12.32])
        by smtp.gmail.com with ESMTPSA id gq20-20020a17090b105400b001e26da0d28csm7703751pjb.32.2022.06.05.00.02.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jun 2022 00:02:24 -0700 (PDT)
Date:   Sun, 5 Jun 2022 14:02:21 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Ferenc Havasi <havasi@inf.u-szeged.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 5.18 00/67] 5.18.2-rc1 review
Message-ID: <YpxU/bVogip64iQF@debian.me>
References: <20220603173820.731531504@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220603173820.731531504@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 03, 2022 at 07:43:01PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.2 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.


Successfully cross-compiled for arm (multi_v7_defconfig, GCC 12.1.0, neon
FPU) and arm64 (bcm2711_defconfig, GCC 12.1.0).

On arm64 build, I found partly outside array bounds warning:

  CC [M]  fs/jffs2/summary.o
  LD [M]  drivers/gpu/drm/drm_cma_helper.o
  LD [M]  drivers/gpu/drm/drm_shmem_helper.o
  LD [M]  drivers/gpu/drm/drm_kms_helper.o
  LD [M]  drivers/gpu/drm/drm.o
  AR      drivers/gpu/drm/built-in.a
  AR      drivers/gpu/vga/built-in.a
  AR      drivers/gpu/built-in.a
  CC      drivers/base/power/sysfs.o
In file included from fs/jffs2/summary.c:23:
In function 'jffs2_sum_add_mem',
    inlined from 'jffs2_sum_add_inode_mem' at fs/jffs2/summary.c:130:9:
fs/jffs2/nodelist.h:43:28: warning: array subscript 'union jffs2_sum_mem[0]' is partly outside array bounds of 'unsigned char[26]' [-Warray-bounds]
   43 | #define je16_to_cpu(x) ((x).v16)
      |                        ~~~~^~~~~
fs/jffs2/summary.c:71:17: note: in expansion of macro 'je16_to_cpu'
   71 |         switch (je16_to_cpu(item->u.nodetype)) {
      |                 ^~~~~~~~~~~
In file included from fs/jffs2/summary.c:17:
In function 'kmalloc',
    inlined from 'jffs2_sum_add_inode_mem' at fs/jffs2/summary.c:118:37:
./include/linux/slab.h:581:24: note: object of size 26 allocated by 'kmem_cache_alloc_trace'
  581 |                 return kmem_cache_alloc_trace(
      |                        ^~~~~~~~~~~~~~~~~~~~~~~
  582 |                                 kmalloc_caches[kmalloc_type(flags)][index],
      |                                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  583 |                                 flags, size);
      |                                 ~~~~~~~~~~~~
In file included from fs/jffs2/nodelist.h:22:
In function 'jffs2_sum_add_mem',
    inlined from 'jffs2_sum_add_inode_mem' at fs/jffs2/summary.c:130:9:
fs/jffs2/summary.c:79:73: warning: array subscript 'union jffs2_sum_mem[0]' is partly outside array bounds of 'unsigned char[26]' [-Warray-bounds]
   79 |                s->sum_size += JFFS2_SUMMARY_DIRENT_SIZE(item->d.nsize);

fs/jffs2/summary.h:34:80: note: in definition of macro 'JFFS2_SUMMARY_DIRENT_SIZE'
   34 | S2_SUMMARY_DIRENT_SIZE(x) (sizeof(struct jffs2_sum_dirent_flash) + (x))
      |                                                                     ^

In function 'kmalloc',
    inlined from 'jffs2_sum_add_inode_mem' at fs/jffs2/summary.c:118:37:
./include/linux/slab.h:581:24: note: object of size 26 allocated by 'kmem_cache_alloc_trace'
  581 |                 return kmem_cache_alloc_trace(
      |                        ^~~~~~~~~~~~~~~~~~~~~~~
  582 |                                 kmalloc_caches[kmalloc_type(flags)][index],
      |                                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  583 |                                 flags, size);
      |                                 ~~~~~~~~~~~~

These warnings are introduced by commit e631ddba5887833 ("[JFFS2] Add erase
block summary support (mount time improvement)") and unfortunately, initial
mainline commit at 1da177e4c3f415 ("Linux-2.6.12-rc2").

These doesn't cause build failure, however.

Cc-ing commiters and authors of these commits (Linus is already on Cc list).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>
Reported-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
