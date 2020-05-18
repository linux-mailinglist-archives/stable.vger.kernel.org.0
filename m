Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEF871D7FED
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728304AbgERRTV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728286AbgERRTV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 13:19:21 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19AA3C061A0C
        for <stable@vger.kernel.org>; Mon, 18 May 2020 10:19:21 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id g1so10706216ljk.7
        for <stable@vger.kernel.org>; Mon, 18 May 2020 10:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=5Kcz53r+XVuZat5+Xus/LNIfE/bNcSivY4LsjBcJ1Nc=;
        b=T6sXjrUZKRE+XdbbeA7HFakPk2I4bcSPX9Y1VDItA5wly3EOwvNOspAnwmLWZBVLS5
         rlUIKblk77N+2Ja/gnzDMs4M1AK8HfXscTLmiFsOx5F4TluGBEwvqKndKZ0nq2Hqw6jE
         VrJRPY39OBfvVDPhEWeCOa6M4OOcvvlDL6v3+n6HaeswCqfFctw4XX2tQ5uXedAX3KAg
         eO4ExuO7U65AD7GD/Fovv0FZaRbZ1OyVahCc0JRfkHmq9+trf4CAJexwFrIKOLXgPKQk
         cRE0HAqxAuAHICiHs1u8AHr4mWVMZ/tVwToZjyuvDw1YI6mQyfMGgKyQ0yPl45nolQct
         GB2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=5Kcz53r+XVuZat5+Xus/LNIfE/bNcSivY4LsjBcJ1Nc=;
        b=QWSvP+cHbl3duRw8UDu9TM9yf6gzAnCCjyWG/zG3PPQbXxWcQqkOVektNRk35sTQ4z
         jToTk3KhOWazaYdEThajD2OAvaBRratbYs5tFuNe6OHTED8RbxlUDlHzRYs0Ro+A4IBE
         nesIIAYZG+ovTUqHhL56ThEQkVvSCbXt59juTjdJO4FDzEHRhY8o4eoaEZTz07E/O13q
         v49UV1SxTLAI+zwvmIpFe4l48lfw5vJZhTUewSQUFlZD0giiUHws1tkv5srK6lkcbXUm
         Vbdt5atImRKePH76biUlp9g53LYwcJ/ZXIBfmlwZxOzK2g2Oy2G+DG5E2GcFAGZv+YtO
         nE3A==
X-Gm-Message-State: AOAM530EWhuirG88lg0EcH328Xb2Idnnhfhc8iAvwwpJTSCP0AiOnAAd
        970KbdsVLqJrPxU6jZ5vd3zQBc0hZrHbeg4NgHBPMw==
X-Google-Smtp-Source: ABdhPJxm2GY9PgWDZr5Ic7BKAIUOzeCqBKl/6Sa1rA8pYtrRXT4j82ShiuksMzcJGV2CP+07ZPdZ6UppbCknmght2JY=
X-Received: by 2002:a05:651c:1103:: with SMTP id d3mr11007924ljo.38.1589822359321;
 Mon, 18 May 2020 10:19:19 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 18 May 2020 22:49:08 +0530
Message-ID: <CA+G9fYtUOp8d1ktnp_-34AczAqR+eCj7UfD9u30hdYAey66syw@mail.gmail.com>
Subject: =?UTF-8?B?c3RhYmxlLXJjIDQuMTk6IGxpYi92c3ByaW50Zi5jOjE5ODM6MTE6IGVycm9yOiBpbXBsaQ==?=
        =?UTF-8?B?Y2l0IGRlY2xhcmF0aW9uIG9mIGZ1bmN0aW9uIOKAmGVycm9yX3N0cmluZ+KAmSBbLVdlcnJvcj1pbXBs?=
        =?UTF-8?B?aWNpdC1mdW5jdGlvbi1kZWNsYXJhdGlvbl0gIDE5ODMgfCByZXR1cm4gZXJyb3Jfc3RyaW5nKGJ1Ziwg?=
        =?UTF-8?B?ZW5kLCAiKGVpbnZhbCkiLCBzcGVjKTs=?=
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux- stable <stable@vger.kernel.org>
Cc:     lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc 4.19 build broken on arm64, arm, x86_64 and i386.

 # make -sk KBUILD_BUILD_USER=3DTuxBuild -C/linux -j16 ARCH=3Dx86
HOSTCC=3Dgcc CC=3D"sccache gcc" O=3Dbuild
75 #
76 kernel/locking/rwsem.o: warning: objtool: up_read()+0x11: call
without frame pointer save/setup
77 kernel/locking/rwsem.o: warning: objtool: up_write()+0x17: call
without frame pointer save/setup
78 kernel/locking/rwsem.o: warning: objtool: downgrade_write()+0x25:
call without frame pointer save/setup
79 ../drivers/crypto/ccp/sp-platform.c:37:34: warning: array
=E2=80=98sp_of_match=E2=80=99 assumed to have one element
80  37 | static const struct of_device_id sp_of_match[];
81  | ^~~~~~~~~~~
82 ../lib/vsprintf.c: In function =E2=80=98pointer=E2=80=99:
83 ../lib/vsprintf.c:1983:11: error: implicit declaration of function
=E2=80=98error_string=E2=80=99 [-Werror=3Dimplicit-function-declaration]
84  1983 | return error_string(buf, end, "(einval)", spec);
85  | ^~~~~~~~~~~~
86 ../lib/vsprintf.c:1983:11: warning: returning =E2=80=98int=E2=80=99 from=
 a function
with return type =E2=80=98char *=E2=80=99 makes pointer from integer withou=
t a cast
[-Wint-conversion]
87  1983 | return error_string(buf, end, "(einval)", spec);
88  | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
89 cc1: some warnings being treated as errors

ref:
https://gitlab.com/Linaro/lkft/kernel-runs/-/jobs/557410092
https://gitlab.com/Linaro/lkft/kernel-runs/-/jobs/557410099

--=20
Linaro LKFT
https://lkft.linaro.org
