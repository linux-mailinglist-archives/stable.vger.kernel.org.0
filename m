Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0124165A34F
	for <lists+stable@lfdr.de>; Sat, 31 Dec 2022 10:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbiLaJKP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Dec 2022 04:10:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiLaJKN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Dec 2022 04:10:13 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 519852DC3
        for <stable@vger.kernel.org>; Sat, 31 Dec 2022 01:10:08 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id m8-20020a05600c3b0800b003d96f801c48so14740461wms.0
        for <stable@vger.kernel.org>; Sat, 31 Dec 2022 01:10:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nHtqSom/NPOqpnu1/5uZxJR7SBzKstlNHb36iHfhgqc=;
        b=X0Wh78GqGD1abjYCFlc7xPkYBcRs4mocIevt8rZ/77iKiGh7Z0Tb5jN8jDmef0ANCV
         hCvDYCMGbFdPT+sY5v8jf2CHFoMSdsjQiSOFdsfOHFLO/ag8C6NSkUiOEIlConE5s0mb
         bBnkYFYhGEEayhhJcUc9vBJX1/xQZFIyv/Yx9F0UUrUfxXlU9A/v/adePwATtO+1TFZR
         4BicbiJAa1YNRfRlBmVqARpH0TogryVQ1tKUQN+f+gObSdnkKRYVGG8Nhml7uIUSfd5L
         4QOsou9zomURD6Ff0N+hnFRT/7hg0jU+QCzUy6dAm1Gg9+djdckEymAR26O2yZ9wRh0q
         hcJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nHtqSom/NPOqpnu1/5uZxJR7SBzKstlNHb36iHfhgqc=;
        b=nlV21j9rcjMtuH/9D6lB0MZjkByB+NwfoRSo1/V+O1WMj0W+fvda5LXALJTx6HRyxB
         CoOKQ6hhr748x0ExeCQgIodaFlpswfnMIyGg716e876v0VPm7y9T1URWyTxLo3s4VmXv
         FJuJ7I0WBBWGNhTX1p1OPX5FBJ14aJa67SrvQc3AOLkGoUeUXNZMDdSGeUImnlcQBrXR
         xlnrrnTu0i4/9VGFEDXUyXxEPvCFcz+UhMUqsLVme6MGQdEgBxikfMKJdI2/VoOBFxIt
         OAC7fVsJLTEmxqjVZizV1hBJ60TUI0D42xKicVrUHLiUkFPGO+3tIlkHpb83khFCgYrK
         noWg==
X-Gm-Message-State: AFqh2ko78Gp0ckhdBKkFPnEhd+5wF6rYlmonwNyKtTy/BQRdCePa+xFr
        dPaDxVlC6dxosTFHRW6IGL0=
X-Google-Smtp-Source: AMrXdXuXg5VEUORyhBhbpA+ZUWW9aW0vf//YsYqly/wtdOBZD/gfzzCb19f/xCtg2Ivrum4yri8jKQ==
X-Received: by 2002:a05:600c:4f48:b0:3d6:8570:1239 with SMTP id m8-20020a05600c4f4800b003d685701239mr30589229wmq.16.1672477806779;
        Sat, 31 Dec 2022 01:10:06 -0800 (PST)
Received: from ?IPv6:2a02:168:6806:0:70ad:9f34:9d41:ef2c? ([2a02:168:6806:0:70ad:9f34:9d41:ef2c])
        by smtp.gmail.com with ESMTPSA id h9-20020a05600c314900b003d99469ece1sm13397264wmo.24.2022.12.31.01.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Dec 2022 01:10:06 -0800 (PST)
Message-ID: <e9ee0609520238d28d94ee8b66e20ac0c6069caa.camel@gmail.com>
Subject: Re: [PATCH 6.1 0000/1140] 6.1.2-rc2 review
From:   Klaus Kudielka <klaus.kudielka@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Date:   Sat, 31 Dec 2022 10:10:05 +0100
In-Reply-To: <20221230094107.317705320@linuxfoundation.org>
References: <20221230094107.317705320@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.2-1 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2022-12-30 at 10:49 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.2 release.
> There are 1140 patches in this series, all will be posted as a response
> to this one.=C2=A0 If anyone has any issues with these being applied, ple=
ase
> let me know.
>=20
> Responses should be made by Sun, 01 Jan 2023 09:38:41 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0https://www.kernel.org/pu=
b/linux/kernel/v6.x/stable-review/patch-6.1.2-rc2.gz
> or in the git tree and branch at:
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0git://git.kernel.org/pub/=
scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>=20
> thanks,
>=20
> greg k-h
>=20
>=20

Hi Greg,

I'm concerned about backporting those two commits to *any* stable kernel ri=
ght now:

> Pali Roh=C3=A1r <pali@kernel.org>
> =C2=A0=C2=A0=C2=A0 ARM: dts: armada-39x: Fix compatible string for gpios
[ Upstream commit d10886a4e6f85ee18d47a1066a52168461370ded ]

>=20
> Pali Roh=C3=A1r <pali@kernel.org>
> =C2=A0=C2=A0=C2=A0 ARM: dts: armada-38x: Fix compatible string for gpios
[ Upstream commit c4de4667f15d04ef5920bacf41e514ec7d1ef03d ]

The latter one breaks my Turris Omnia (Armada 385) pretty badly, and I gues=
s we will end
up with similar problems on Armada 39x boards.

Link: https://lore.kernel.org/r/f24474e70c1a4e9692bd596ef6d97ceda9511245.ca=
mel@gmail.com/

Thanks, Klaus

