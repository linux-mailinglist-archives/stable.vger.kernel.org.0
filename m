Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 536E76D6C05
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 20:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234462AbjDDS3L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 14:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234268AbjDDS2y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 14:28:54 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842056184
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 11:26:09 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id p203so39778018ybb.13
        for <stable@vger.kernel.org>; Tue, 04 Apr 2023 11:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1680632765;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xyjoFpVijlAvxTCbOhJJ22iDzQUactcN5oOMXtPKyqU=;
        b=fcxPf/i8xq/kSQfoVdznWlATaPoee6x4Dem/NHTsVKRgZLeTmjolTZLa/+wlaVzoo2
         9wvH9iZDHP0vTlVzDnxPCaPpHN3tDUjPt67SQO61fkm34DihtHBMRLAFcs2rMItJTIhy
         I6ffUk8HIw91u9pqKUvjV5A2g74DjoemZoBP07KThvSgH49wdGzmNq3+3McXhZUTP6Pp
         haNgzYnEbjtZi+tD+GbjOtszKTPwrkXxqpENHShf5NPe98Q7/dEGAs3IkKkA7iFl8wl0
         Nim2er0csMAF8UUSFkm0qwDshTzU0tzM7EOY6pkH15hkYpDAVagWgrcgvIf+Y7NEmhNw
         8ElQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680632765;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xyjoFpVijlAvxTCbOhJJ22iDzQUactcN5oOMXtPKyqU=;
        b=vD4d0Hz9+qvaFELVkPZWS5GCMf7O6o2LGB3+0uHUN0ShkZQj7J/7xJsEdrg1KRl4S9
         sJl+NE4ZniBnbjoS8M7z1gq8q/yn0OstCcBkOrQSoVu+r/pS4fvel9fbegovzawh13Yh
         X2vpjBoewsc89S+AjIDVcKfTHAstU8ab+Dshz0tDWY64GP/jombCyN3N2TsHv6WWBcA6
         qqUr/mskXsaGPpeTWtB18aB/vqkkCuDYmvA7YI+Rp6uj1BPjzUsqzZRjCuI69SCsaz+9
         8dYPLJSZGRNbsheBjBSHRHSTrrE590xecIDkM4ntIHNnERI834EqX8XjAFP8ahnoJKQg
         U6xg==
X-Gm-Message-State: AAQBX9fZRbhqzrZmmUxPvPQFgezLmvvPRZ7OCEjv/NnYOcgJPClzJqwV
        sRLMJ0tj/LTFAuVDkkvkspqLEUGvMgAzkyHex0X2
X-Google-Smtp-Source: AKy350Z1zr2YlO7SKFTwlplbfhoyc2wR4q7sivsyQWkkLJjxdDoxjxyefjzb/C0u+bqpRWOrC8ylutsAT9jk1XyHS7o=
X-Received: by 2002:a25:7449:0:b0:b75:8ac3:d5d9 with SMTP id
 p70-20020a257449000000b00b758ac3d5d9mr2436296ybc.3.1680632765167; Tue, 04 Apr
 2023 11:26:05 -0700 (PDT)
MIME-Version: 1.0
References: <20230331123221.3273328-1-roberto.sassu@huaweicloud.com> <20230331123221.3273328-2-roberto.sassu@huaweicloud.com>
In-Reply-To: <20230331123221.3273328-2-roberto.sassu@huaweicloud.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 4 Apr 2023 14:25:54 -0400
Message-ID: <CAHC9VhT17mtnncuKVNzqr0zTU+E5R+8wMaxF4AYXS_bG9L0HZQ@mail.gmail.com>
Subject: Re: [PATCH v10 1/4] reiserfs: Add security prefix to xattr name in reiserfs_security_write()
To:     Roberto Sassu <roberto.sassu@huaweicloud.com>
Cc:     zohar@linux.ibm.com, dmitry.kasatkin@gmail.com, jmorris@namei.org,
        serge@hallyn.com, stephen.smalley.work@gmail.com,
        eparis@parisplace.org, casey@schaufler-ca.com,
        reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        bpf@vger.kernel.org, kpsingh@kernel.org, keescook@chromium.org,
        nicolas.bouchinet@clip-os.org,
        Roberto Sassu <roberto.sassu@huawei.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 31, 2023 at 8:33=E2=80=AFAM Roberto Sassu
<roberto.sassu@huaweicloud.com> wrote:
>
> From: Roberto Sassu <roberto.sassu@huawei.com>
>
> Reiserfs sets a security xattr at inode creation time in two stages: firs=
t,
> it calls reiserfs_security_init() to obtain the xattr from active LSMs;
> then, it calls reiserfs_security_write() to actually write that xattr.
>
> Unfortunately, it seems there is a wrong expectation that LSMs provide th=
e
> full xattr name in the form 'security.<suffix>'. However, LSMs always
> provided just the suffix, causing reiserfs to not write the xattr at all
> (if the suffix is shorter than the prefix), or to write an xattr with the
> wrong name.
>
> Add a temporary buffer in reiserfs_security_write(), and write to it the
> full xattr name, before passing it to reiserfs_xattr_set_handle().
>
> Also replace the name length check with a check that the full xattr name =
is
> not larger than XATTR_NAME_MAX.
>
> Cc: stable@vger.kernel.org # v2.6.x
> Fixes: 57fe60df6241 ("reiserfs: add atomic addition of selinux attributes=
 during inode creation")
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> ---
>  fs/reiserfs/xattr_security.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)

This looks good to me, thanks.  While normally I would merge something
like this into the lsm/stable-X.Y branch, I'm going to merge it into
lsm/next to give it a week or two of extra testing.  I think anyone
who is using reiserfs+LSM (doubtful as it looks horribly broken) would
be okay with waiting a few more days at this point :)

--=20
paul-moore.com
