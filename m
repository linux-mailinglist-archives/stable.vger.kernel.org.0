Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F26557F42E
	for <lists+stable@lfdr.de>; Sun, 24 Jul 2022 10:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiGXIt6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Jul 2022 04:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiGXIt6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Jul 2022 04:49:58 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B11F65A9
        for <stable@vger.kernel.org>; Sun, 24 Jul 2022 01:49:55 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id c185so950587iof.7
        for <stable@vger.kernel.org>; Sun, 24 Jul 2022 01:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=1kG3H46rBrmMi+WJnfY2J6CVJUoBoB8NyfXs+zko80M=;
        b=Ei+99csHz349xobRa6m1r0mge8Tufl/RMEjQa6DU+xfWslXnsaLU4Oo0gdZDyp2vkd
         EMM/DlbhhoMp+I4AljjvW0PQlZ4m63YCtnJROg52wo2pMZMV+Rsh1/jtiSPFS8mwkWN3
         KtvmrJ2GeZxtz3HrcbHCcL5XHHtjp7d+wzZM858GSrZVBNynivbgEC9AD5lGWuUEpASZ
         PvhDtLEG5hObUwy9pjFl4aRxcXc0dSxz+HQccI6i1ZIn9gw3keJVLsz0boEIBuGiyHyu
         1ZXX6IEGaBavA6/Bt9xbWlq6TNMiXQRW/O00pZWo4Kzy11Pot0qVOBUWbzW99MmwhRXe
         38+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=1kG3H46rBrmMi+WJnfY2J6CVJUoBoB8NyfXs+zko80M=;
        b=7RQoK8UUS+mUSV33oIquc5GQU1cwgOYXz+ELVIg4mRbqOF2IiRJ/SUQ7+InFBcBL1b
         OMtkoEhOc6a+CtCaYqlqacDgx10uIDaw005lNrycy5Z5AwA7zG2qDQ14tt5wD6QDPvdN
         iUi3q/LDc3lGLFJRtA8EFmjg9GmIa5tkA/S+q1ZtRA6m93YOyMG5OPhc77XniV3ckeK9
         GM7DFOBkprBCoO0phdkeXmJwOjMWeb971O8rsTQxfrrPbSoIpLlLlSwg1f8gXPbfTPSk
         C+XhdJYqg+m2ZPHRucAUmfkHazE1Rgqopiqf/toalskXsmqgzvTfkkWfU6G76kVqjugb
         Ywpg==
X-Gm-Message-State: AJIora8OdipG0qU1dgIPx7L37GQ7s/I8+sBViSGPBvEZy7jO4UZZf0Am
        GdqQB6hxHosfXetv8zQyGP02O7UOVeLnZmT2Ur8iZ/Nq70Cr33IY
X-Google-Smtp-Source: AGRyM1uFqxHYf2yGWm5V+JGOEHaLORhDcP3XzLDQHB5LwcF8Iiweud0maPGLmB+HBDdeVHOvjghyVOSmuuO9fxlWfsk=
X-Received: by 2002:a05:6602:2d16:b0:67c:1472:815e with SMTP id
 c22-20020a0566022d1600b0067c1472815emr2404589iow.86.1658652593738; Sun, 24
 Jul 2022 01:49:53 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Sun, 24 Jul 2022 01:49:42 -0700
Message-ID: <CANP3RGcZqbYnK=DV00yDi0JVj58oSZ100KjJ8tCeLtgTrGn3pQ@mail.gmail.com>
Subject: request for stable inclusion of per-file labelling for bpffs.
To:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Could the following 1-liner be pulled into LTS please?
It should easily - if not quite trivially - apply to 4.9/4.14/4.19/5.4
LTS trees.

of note: it's already long present in all Android Common Kernel 4.9+ trees,
but the lack of it in LTS appears to cause a minor security/compatibility i=
ssue,
since things can end up mislabelled.

commit 4ca54d3d3022ce27170b50e4bdecc3a42f05dbdc [v5.6-rc1-10-g4ca54d3d3022]
Author: Connor O'Brien <connoro@google.com>
Date:   Fri Feb 7 10:01:49 2020 -0800

    security: selinux: allow per-file labeling for bpffs

    Add support for genfscon per-file labeling of bpffs files. This allows
    for separate permissions for different pinned bpf objects, which may
    be completely unrelated to each other.

    Signed-off-by: Connor O'Brien <connoro@google.com>
    Signed-off-by: Steven Moreland <smoreland@google.com>
    Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
    Signed-off-by: Paul Moore <paul@paul-moore.com>

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 7c37cdb3aba0..44f6f4e20cba 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -702,6 +702,7 @@ static int selinux_set_mnt_opts(struct super_block *sb,
        if (!strcmp(sb->s_type->name, "debugfs") ||
            !strcmp(sb->s_type->name, "tracefs") ||
            !strcmp(sb->s_type->name, "binderfs") ||
+           !strcmp(sb->s_type->name, "bpf") ||
            !strcmp(sb->s_type->name, "pstore"))
                sbsec->flags |=3D SE_SBGENFS;

Thank you.

Maciej =C5=BBenczykowski, Kernel Networking Developer @ Google
