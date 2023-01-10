Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9505C664D32
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 21:23:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232694AbjAJUXc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 15:23:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232833AbjAJUX2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 15:23:28 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37593165B9;
        Tue, 10 Jan 2023 12:23:27 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id g14so13765631ljh.10;
        Tue, 10 Jan 2023 12:23:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GKagYVAsRWr9MmzVjf9Vyi9I8wsXIwa9or1lXLN2uMY=;
        b=LY2GL0spITSL8JEHd2mxVMauqaASRkqSBstV3Yyi5D+4BTsidmLB6JC7mevOx+Opqg
         5S5YffjJRYg494zonpFEurkO6cuQB5S5jfMMy1XVZaG9hEV770cbKeofNq/7JyL3bCEM
         rkGT2g10D6fGd9Rd7by57Bhk7gh1w1r8FEWsNRMHFPGa+eN3tfgp0Dd6QGcSuqbOUSKJ
         ooKYxQZdhPL4z2X4PD3scuAb3tCyrIfT8xvjT5U4iSCwx3/OnrwLLOqnKmNan3L1auUp
         oBuF3qSxzuIB7kb2SayMN8ISw7ltg1CUTHkseigiY85/P6TdvI/nCEsuPgN7XZ/xbZ9z
         q0rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GKagYVAsRWr9MmzVjf9Vyi9I8wsXIwa9or1lXLN2uMY=;
        b=BTINF/hgc8QZFo7dpCPfKhyja65KEbPvvwSR4/okPvPiNjvILcQrh/F+0h4FTYQK/7
         Ec3y5IzWBj0iPpb72yl4TOHmnH9nq44nXi6kIKccxUZox/0phSWX69hDPwAW6bDAha8G
         dv4hdawlzO70Ng44gBL5wEf+fKQXEouSXFPwigMLU/xTPCLBRZLToyptC84hEPNrC0wH
         +gyg05qaFcH/PyiMZLm3h28n7tp2wke16hUBsuEVji1yBzAciV4bEtQOVc6fNLkD7f69
         lgy4+rm2shQ66MXGKlUsC2v3DUYbwmJnLQlGwcyvyBTB9T3xNTiCbwYA/R/UaKRhQoZ0
         QOtQ==
X-Gm-Message-State: AFqh2kqWZAYdisTxZUbkpOkkKErHaYuMmaamwEwt5keTdMBlI4Aq29V4
        XztgXBGGbgK66hOtNERd3N7v2KRBgHKiaAsgxdSRugMdfMk=
X-Google-Smtp-Source: AMrXdXuIH2BxlUeRlFQoCuxRJQniJhByx8KPQ+B7Wzwp7DUQUNSOoiLHqlP+6Xt/PBTdgpF8X7D+2mrUv0248TyHHDU=
X-Received: by 2002:a05:651c:124f:b0:27f:c535:5ec2 with SMTP id
 h15-20020a05651c124f00b0027fc5355ec2mr2352375ljh.204.1673382205314; Tue, 10
 Jan 2023 12:23:25 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Tue, 10 Jan 2023 21:22:48 +0100
Message-ID: <CA+icZUUYrasObBwMQWae=+eAfUzvxc1Pk39QFz9=NXedWO41Vg@mail.gmail.com>
Subject: Please, clear statement to what is next LTS linux-kernel
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     helpdesk@kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Michael Larabel <Michael@michaellarabel.com>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Happy new 2023,

I normally watch [1] for the next LTS linux-kernel which is for me an
official site and for an official announcement.

On the debian-kernel mailing list you read Linux 6.1 will be the
official one for Debian-12 aka bookworm.

I saw a phoronix article about EOL of Linux-4.9 [3] which points to [2].

[2] says:

After being prompted on the kernel mailing list, Linux stable
maintainer Greg Kroah-Hartman commented:
> I usually pick the "last kernel of the year", and based on the normal release cycle, yes, 6.1 will be that kernel.
> But I can't promise anything until it is released, for obvious reasons.

This is not a clear statement for me and was maybe at a point where
6.1 was not released.

If you published a clear statement please point me to it.
And if so, please update [1] accordingly.
( It dropped 4.9 from LTS list recently from [1] - guess Konstantin or
someone from helpdesk did - so [1] is actively maintained. )

Please, a clear statement.

Thanks.

Regards,
-Sedat-

P.S.: Just for the records: I am not subscribed to LKML or
linux-stable mailing-lists and may miss such a clear statement.

[1] https://kernel.org/category/releases.html
[2] https://www.phoronix.com/news/Linux-6.1-Likely-LTS
[3] https://www.phoronix.com/news/Linux-4.9.337-LTS-Over
[4] https://release.debian.org/ > Key release dates
