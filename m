Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE0053E04D
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 06:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbiFFD7x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Jun 2022 23:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiFFD7v (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Jun 2022 23:59:51 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 358691D303;
        Sun,  5 Jun 2022 20:59:44 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id o6so6088445plg.2;
        Sun, 05 Jun 2022 20:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=F3dlgaXmkDpDEty0Y4DNCWJHlmIObEDWkeyV88bJ1Pg=;
        b=BJBW1yOCWpOULW0xyTrerbG4y7zPYfn1I61YNgD7Y70F8Q1r8/DhnX8ELeAIikMmoJ
         1H06V89YylT/lmz+v7kGZMokx4yYvi7KuCd1pDt5Y40Noi2+c7TUw3BkWmdFzXUQG51A
         QN4+Vd8DTPCp8UYaqAUVXnQHlgojK8SufP8tdKga6bUuZKJGQg1ylbJIdt+LAvTSx3GR
         ByuG3q2sjMJLEkYCtghZO2ndpj8NR7n/fR64SQA+FUbygh4oHy4nFvHjeeYYEa68cYJj
         t5Dxl0vt7EJ01dSGs75qVqBGbcyiz6DOX+DKxCX5fiyQTQ6v9OphrCyKgwD/kiSFJCRU
         ytJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=F3dlgaXmkDpDEty0Y4DNCWJHlmIObEDWkeyV88bJ1Pg=;
        b=NRNnPS7i1A8TxdnNO9h9prBMqXhwVm4k+TRt79GhB2AIBrNwhM+m4JbqVBDp0Naknf
         hJIrL1eEhR9kvOzRoMhdAkPeX5EX6uBAGsd4vMgt5nGuF1u0WuBdlpE6fwa2k41o6//F
         dWVrxAyIoR5FN69evIXnPS4iPmJe2lwyuIn7vKsUACDGwlA9Xwq9NrKvUm/FRcKArRMD
         w1n/pttJCLf+82kc4NBhXvpWEoSeZgPNeDHWar+OHm46w6w1SWw/uvLJR/TN2+aGA6Ow
         HkmxEBq9djiucL840MJcfYK6HDDNQYBAWIetQhodVV6D/LrW4SywxYALhDqNrrhoXAv1
         +FjQ==
X-Gm-Message-State: AOAM530LIONgeuYXR0VWAR/VVrmPofaG7WmNM/V/Oqcblheq/8B3Lb1e
        7FUAd3GCeT7EBAopiY9LilE=
X-Google-Smtp-Source: ABdhPJz018j7KIAM1lyTIrFxMTwuSnzEkr87RwbyQbdQnw5vzBA49wIGQTCLtHW+Xps8wJVjcivrFQ==
X-Received: by 2002:a17:90a:9914:b0:1db:d10f:1fcf with SMTP id b20-20020a17090a991400b001dbd10f1fcfmr59116261pjp.241.1654487984072;
        Sun, 05 Jun 2022 20:59:44 -0700 (PDT)
Received: from localhost (subs03-180-214-233-92.three.co.id. [180.214.233.92])
        by smtp.gmail.com with ESMTPSA id bi16-20020a056a00311000b0050dc762815asm2798215pfb.52.2022.06.05.20.59.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jun 2022 20:59:43 -0700 (PDT)
Date:   Mon, 6 Jun 2022 10:59:40 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     linux-mtd@lists.infradead.org
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Richard Weinberger <richard@nod.at>,
        David Howells <dhowells@redhat.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Baokun Li <libaokun1@huawei.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kyeong Yoo <kyeong.yoo@alliedtelesis.co.nz>,
        hongnanli <hongnan.li@linux.alibaba.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: partly outside array bounds warning on fs/jffs2/summary.c, GCC 12.1.0
Message-ID: <Yp17rHxRb6d5JrHd@debian.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi everyone,

When I build arm64 kernel with GCC 12.1.0 (bcm2711_defconfig), I get
partly outside array bounds warning on fs/jffs2/summary.c:

  CC [M]  fs/jffs2/summary.o
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
./include/linux/slab.h:600:24: note: object of size 26 allocated by 'kmem_cache_alloc_trace'
  600 |                 return kmem_cache_alloc_trace(
      |                        ^~~~~~~~~~~~~~~~~~~~~~~
  601 |                                 kmalloc_caches[kmalloc_type(flags)][index],
      |                                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  602 |                                 flags, size);
      |                                 ~~~~~~~~~~~~
In file included from fs/jffs2/nodelist.h:22:
In function 'jffs2_sum_add_mem',
    inlined from 'jffs2_sum_add_inode_mem' at fs/jffs2/summary.c:130:9:
fs/jffs2/summary.c:79:73: warning: array subscript 'union jffs2_sum_mem[0]' is partly outside array bounds of 'unsigned char[26]' [-Warray-bounds]
   79 |                         s->sum_size += JFFS2_SUMMARY_DIRENT_SIZE(item->d.nsize);
fs/jffs2/summary.h:34:80: note: in definition of macro 'JFFS2_SUMMARY_DIRENT_SIZE'
   34 | #define JFFS2_SUMMARY_DIRENT_SIZE(x) (sizeof(struct jffs2_sum_dirent_flash) + (x))
      |                                                                                ^
In function 'kmalloc',
    inlined from 'jffs2_sum_add_inode_mem' at fs/jffs2/summary.c:118:37:
./include/linux/slab.h:600:24: note: object of size 26 allocated by 'kmem_cache_alloc_trace'
  600 |                 return kmem_cache_alloc_trace(
      |                        ^~~~~~~~~~~~~~~~~~~~~~~
  601 |                                 kmalloc_caches[kmalloc_type(flags)][index],
      |                                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  602 |                                 flags, size);
      |                                 ~~~~~~~~~~~~

I first found these warnings when reviewing linux-5.18.y stable rc [1],
for which Greg recommends me to contact JFFS subsystem developers.

Thanks.

[1]: https://lore.kernel.org/stable/YpxU%2FbVogip64iQF@debian.me/ 

-- 
An old man doll... just what I always wanted! - Clara
