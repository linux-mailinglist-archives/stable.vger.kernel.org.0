Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD034C981E
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 23:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237523AbiCAWF1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 17:05:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234508AbiCAWF0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 17:05:26 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4543B723D3
        for <stable@vger.kernel.org>; Tue,  1 Mar 2022 14:04:45 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id d3so71650qvb.5
        for <stable@vger.kernel.org>; Tue, 01 Mar 2022 14:04:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=PfUAhRerYiosdA4OgcacxFowgenIXeAO+auc6HDEmWw=;
        b=HLVanu4WiMK/dzit6EF1Y9LC7lji9l7WW73+SFMSxBNYELNaov+qwiC3HHVy6UgTQH
         dW2L7K4ATHCTUOOyY5c+GKP48Uxkpb626vYnNS1QGjWv9hjg/9IMdjOzTcyCkrTa9B2I
         6CzFxFwYXxbD65DIKgBRISv349vIns0jzF+cMzXZIFr2ooC1TkrMDk1Q5zDmVQviVGSD
         j83qgNLM7eIzMLz6uiXORBJK4aXr1++Crm2a3dy9B7/Qox+zLNc+EbtwL3+xczl7b98X
         SxsYk8PEf1A7BIU98NoWpk0w0LRcFpYFvMQa5gUV+EQcCpgvDUyIB1+gDvee074oY/Nh
         2tlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=PfUAhRerYiosdA4OgcacxFowgenIXeAO+auc6HDEmWw=;
        b=Ir69+5nrLaElLhyUJdz05obB+laT4/CfRXvCHUEkxpHP3S265HhYDnXd2MDuQfgc1n
         KBoKmd7qMhP6twUi9M2HE3HSJDmRJDJlfAN/guiucfSeaJ5zTCcTQRFkKQLmE2IT7dVb
         ATHweluRB8tBDPqIMX5EDmiIvcWGXAz8IsZfbwtpwh43dbdX/vloomlH7mZ+M/mgMT6l
         W9fwHjB/P7qT4geQhI1m4qSpBFsuNzdkUB3waNCg1PRuD6xVcSlUxXOtpbEr6EnlgqMv
         yc7axQpzZwVuChn9Td+JWjAQCu+6QViDoWGJTmZHKa/zbZZ5M/ueIpYmFab5CjVykEuu
         8JEw==
X-Gm-Message-State: AOAM530et8tVJsHn9vhYUwXk40YzxZmI+sfepcl+92brzOKoQ4jLyF5l
        ZP54cMb+5ipXm6jXpjldSg==
X-Google-Smtp-Source: ABdhPJzjezmgWXBcGevx5cDoN9QxvlfiQTzBSbDj0lGMHD7Ys2w4wmje+g9320XF/B9YtMxXgYDceQ==
X-Received: by 2002:a05:6214:22c:b0:432:6b2b:95d0 with SMTP id j12-20020a056214022c00b004326b2b95d0mr18983087qvt.63.1646172284367;
        Tue, 01 Mar 2022 14:04:44 -0800 (PST)
Received: from smtpclient.apple ([94.140.11.67])
        by smtp.gmail.com with ESMTPSA id v26-20020a05620a0a9a00b00605c6dbe40asm6982554qkg.87.2022.03.01.14.04.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Mar 2022 14:04:43 -0800 (PST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.40.0.1.81\))
Subject: Re: FAILED: patch "[PATCH] bpf: Fix toctou on read-only map's
 constant scalar tracking" failed to apply to 5.4-stable tree
From:   Rafael David Tinoco <rafaeldtinoco@gmail.com>
In-Reply-To: <f01b6557-ed8f-1385-c5f6-95f73b940b7f@iogearbox.net>
Date:   Tue, 1 Mar 2022 19:04:40 -0300
Cc:     Lee Jones <lee.jones@linaro.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, stable@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>
X-Mao-Original-Outgoing-Id: 667865080.107439-1d65d8fc1c6a1100d0d21757bec2ade2
Content-Transfer-Encoding: quoted-printable
Message-Id: <577A5957-B1ED-41D8-A17C-227E15C23925@gmail.com>
References: <163757721744154@kroah.com> <Yg5wY5FKj0ikiq+A@google.com>
 <Yg51IuzfMnU8Uo6v@kroah.com> <Yg6AbfbFgDqbhq0e@google.com>
 <YhNg4uM1gIN89B7U@google.com> <YhNoZy415MYPH+GR@kroah.com>
 <YhNtE/sIdv5OkBQT@google.com>
 <f01b6557-ed8f-1385-c5f6-95f73b940b7f@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
X-Mailer: Apple Mail (2.3693.40.0.1.81)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


>> The bad-commit mentioned in "the Fixes tag":
>> Fixes: a23740ec43ba ("bpf: Track contents of read-only maps as =
scalars")
>> Which as you say, could well have been fixing another issue.
>> In fact, yes it was:
>> =
https://lore.kernel.org/stable/20210821203108.215937-2-rafaeldtinoco@gmail=
.com/
>> Daniel, what do you suggest please?
>=20
> Hm, okay, so a23740ec43ba ("bpf: Track contents of read-only maps as =
scalars") was
> backported to 5.4.144 given Rafael needed it to fix a failing =
regression test [0].
>=20
> Normally, I would have said that we should just revert a23740ec43ba =
given it was
> not a 'fix' in the first place, but then we are getting into a =
situation where it
> would break Rafael's now functioning test case again on 5.4.144+ =
released kernels.
>=20

IIRC, Without this patch, eBPF programs with extern variables, either =
from ksyms
or kconfig relocations, done by libbpf, used as branch conditions, won't =
work in
<=3D 5.4.144.

Something like:

extern u32 CONFIG_ARCH_HAS_SYSCALL_WRAPPER __kconfig;
...
if (CONFIG_ARCH_HAS_SYSCALL_WRAPPER) {
   valid BTF type declared/used
} else {
   <dead code>: invalid BTF type declared/used
}
...

The dead code is always evaluated and object load does not pass the =
verifier.

The workaround to mitigate this is to always rely in type/field =
existence checks
for the branch conditions, instead of relying in kconfig/ksyms =
relocations.

We've been doing this to support same CO-RE BPF obj in kernels < 5.4 so =
I guess
we could continue doing this for 5.4 as well (allowing you to drop this =
"fix").

Sorry for the burden (about having to introduce another fix, needed =
because of
that patch). I hope nobody else is relying on it and, if they are, there =
is a
mitigation described above.

So, feel free to drop it if it's easier for 5.4 maintenance, I'll =
mitigate
code on our side.

And, Thanks a lot for checking!

> Rafael, given you need this, do you have some cycles to help out Lee =
on this backport
> for 5.4 stable?
>=20
> Thanks guys,
> Daniel
>=20
> [0] =
https://lore.kernel.org/stable/20210821203108.215937-1-rafaeldtinoco@gmail=
.com/

