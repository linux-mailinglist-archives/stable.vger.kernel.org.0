Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 715A6679F2B
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 17:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233100AbjAXQuy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 11:50:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233235AbjAXQux (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 11:50:53 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7681D46161
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 08:50:52 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id o5so13548431qtr.11
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 08:50:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mcOp8zyil3pWriy3DlCZcCWX0BKo/EQlllqJn2itDhU=;
        b=XMZnv57FFlW/8DP3GzKZcYJqtSAnU3ltiqRs6kOnzb17LLhdNsdByR1qsb8V3yCLoA
         kjvzL/UvnIRGMd/l9mcFro/sBo7GgSoD0e10N1GFRA/d9FuooB5NTGtdjWBfrRQDKnc5
         nJWZx6FDnJynmGWBFKYJ+K5RTU4ljksQee4ro=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mcOp8zyil3pWriy3DlCZcCWX0BKo/EQlllqJn2itDhU=;
        b=4ZkNzKh9qBkucyRjMZvLGexqpY+lZFLDpiRDYDoYqERO34ruy2XqPGUsUSgo4y82Ob
         KPDjQOoPHhhSvzIazsJhCZdW2CKazoIuAslav1G/PFty76Fu6XLLqlL12kPIbks7wanU
         /LHVzkNrPtdi5mS5ZCweJhhBipJOopvgLjj9Q4VqSEdHiw2hRYbX5rAWt3Xvp3mtNqBb
         3odxp4o3C8ck4afJNCyMppfTUiDglrG6iO6G7prD5pQ0duAMY2eqA3+c7ggSRfPgDrs3
         sRSJRWQUTewkCrJiS5mWBjIQ8oh4VEICsjybvbRkm0iewRogQaxbRX0f3KFTntWK5H6p
         TMrA==
X-Gm-Message-State: AFqh2krXqmZDjTzm+0CoVOzE1xD/I1/aisagwbgLNxOW/DJ8ECC9bhLf
        EF4R7fTriub9fl5Yr26e3iRH+hIINXM9TZv0
X-Google-Smtp-Source: AMrXdXu1G/fH/toPVGioLvKQZ7qIS68G9/Jg4Cretah6UOIvWoRgUc0YeEsmUcc0KrdWlsCftr0s5A==
X-Received: by 2002:ac8:4f58:0:b0:3b3:9d40:b407 with SMTP id i24-20020ac84f58000000b003b39d40b407mr63723819qtw.62.1674579051402;
        Tue, 24 Jan 2023 08:50:51 -0800 (PST)
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com. [209.85.222.177])
        by smtp.gmail.com with ESMTPSA id b23-20020ac85417000000b003b635009149sm1518717qtq.72.2023.01.24.08.50.50
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jan 2023 08:50:50 -0800 (PST)
Received: by mail-qk1-f177.google.com with SMTP id d13so8442917qkk.12
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 08:50:50 -0800 (PST)
X-Received: by 2002:a05:620a:144a:b0:6ff:cbda:a128 with SMTP id
 i10-20020a05620a144a00b006ffcbdaa128mr1503997qkl.697.1674579050396; Tue, 24
 Jan 2023 08:50:50 -0800 (PST)
MIME-Version: 1.0
References: <20230124134131.637036-1-sashal@kernel.org> <20230124134131.637036-35-sashal@kernel.org>
In-Reply-To: <20230124134131.637036-35-sashal@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 24 Jan 2023 08:50:34 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjZmzuHP10Trg_7EBnix4mFLfODPM+FsZz0Jjj+YAFDeg@mail.gmail.com>
Message-ID: <CAHk-=wjZmzuHP10Trg_7EBnix4mFLfODPM+FsZz0Jjj+YAFDeg@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 6.1 35/35] ext4: deal with legacy signed xattr
 name hash values
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel test robot <oliver.sang@intel.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Andreas Dilger <adilger@dilger.ca>,
        "Theodore Ts'o" <tytso@mit.edu>, Jason Donenfeld <Jason@zx2c4.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 24, 2023 at 5:42 AM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Linus Torvalds <torvalds@linux-foundation.org>
>
> [ Upstream commit f3bbac32475b27f49be201f896d98d4009de1562 ]
>
> We potentially have old hashes of the xattr names generated on systems
> with signed 'char' types.  Now that everybody uses '-funsigned-char',
> those hashes will no longer match.

This patch does not work correctly without '-funsigned-char', and I
don't think that has been back-ported to stable kernels.

That said, the patch *almost* works. You'd just have to add something
like this to it:

  --- a/fs/ext4/xattr.c
  +++ b/fs/ext4/xattr.c
  @@ -3096,7 +3096,7 @@ static __le32 ext4_xattr_hash_entry(char *name,
        while (name_len--) {
                hash = (hash << NAME_HASH_SHIFT) ^
                       (hash >> (8*sizeof(hash) - NAME_HASH_SHIFT)) ^
  -                    *name++;
  +                    (unsigned char)*name++;
        }
        while (value_count--) {
                hash = (hash << VALUE_HASH_SHIFT) ^

to make it work right (ie just make sure that the proper xattr name
hashing actually uses unsigned chars for its hash).

                    Linus
