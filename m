Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34830636E9E
	for <lists+stable@lfdr.de>; Thu, 24 Nov 2022 00:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbiKWXz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 18:55:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiKWXz1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 18:55:27 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C040E0CB2
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 15:55:27 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id b62so217165pgc.0
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 15:55:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vZiOinbRPK6s4HUAgO7uA4kxZqo3MLeus6tZS6PdBy0=;
        b=dw+pUvRMhuo4MPn0AhEl19nbqie88uxLf/WFF7A4NP2zGGdmBl5tKFxuZEsiufD2Kr
         b8wKqOev+bPjppr9a6zM2VqzBrKP3YlHqDWsrbTEyWHwMFGSPpRduIAACrDX3bd3YWkK
         67XlCHkb/7QD3YKhZ50StlS2Pyb1lL0rU5DZTr3tn1DPd3bp22Gf7RClbDcAc1agP9Dy
         cnsjp+d4fqFivPgbiX9iqwsb9vSVRvmnWomiE56TVPrS16Yic+sODz2YWp8LIEyjFvIa
         CVWZ0efsPmFk8UWtG9qiuLXJefiWtKTSomoTN/lTurYC9Pe0CiqUxgmyi2qXLLj9dIOf
         aUkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vZiOinbRPK6s4HUAgO7uA4kxZqo3MLeus6tZS6PdBy0=;
        b=jUEnvKUPS44zP3xdaKpYbf5IFuqAHkUwyC4SgQHD6XUZjA+V9OW+UFriosqxH3ppse
         f8YKN6P6CxawheC7oiuwidImtC2AjzlOqkOcTzeaReGtRrJeRDzJDLZrIRBdykR+Jzha
         trg61Pi8KJl2mvg9lyTB/NkK1gpbZV3L0xfmV2/haPAePw48ZS+czATknc6afbKRQ72+
         vfw2nIZjTANP4pUUaClsF0AlAyJOB/5nAZDUouSibdnya1TZV5UBhF5F9qfc6DoiJtxN
         ornEIb4h8o+La27TPNN3txzo52P+R2POeuXop0iZZlQGhvxtVhkn6hfFysqA9mK7kpZK
         HP3g==
X-Gm-Message-State: ANoB5plAZrVAFyEM72d7A/ux+0qArnMCqKybt3ggVuV/dtL44pesLWG5
        K2IOkH7Lm+pV35yGsozItKallxmkeviHXrGgYyA0CA==
X-Google-Smtp-Source: AA0mqf53Q98XvtxzLRg7tBIr6xrqrDmFUF4UUCdyYGMQ29J6BsZMrFF2OIOnpXrqQiP+G5c5KCNcbxbVHNU3Lv9V1Us=
X-Received: by 2002:a65:53ca:0:b0:46f:ed3a:f38b with SMTP id
 z10-20020a6553ca000000b0046fed3af38bmr15226546pgr.387.1669247726407; Wed, 23
 Nov 2022 15:55:26 -0800 (PST)
MIME-Version: 1.0
From:   =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date:   Wed, 23 Nov 2022 17:55:14 -0600
Message-ID: <CAEUSe7-V73jB83Vbv-5AYiOUn8+kXw_fRt74DNiz4gFwYs8mrQ@mail.gmail.com>
Subject: Stable backport request: kconfig/symbol.c
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     linux- stable <stable@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

Would the stable maintainers please consider backporting the following
commit to the 4.9 and 4.14 stable branches?

commit e3b03bf29d6b99fab7001fb20c33fe54928c157a
Author: Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Sat Dec 16 00:28:42 2017 +0900

    kconfig: display recursive dependency resolution hint just once

The following failures are found with Clang's `-Wmisleading-indentation`:
-----8<----------8<----------8<-----
In file included from scripts/kconfig/zconf.tab.c:2470:
/builds/linux/scripts/kconfig/symbol.c:1153:4: warning: misleading
indentation; statement is not part of the previous 'if'
[-Wmisleading-indentation]
                        fprintf(stderr, "For a resolution refer to
Documentation/kbuild/kconfig-language.txt\n");
                        ^
/builds/linux/scripts/kconfig/symbol.c:1150:3: note: previous statement is =
here
                if (stack->sym =3D=3D last_sym)
                ^
1 warning generated.
----->8---------->8---------->8-----

Thanks and greetings!

Daniel D=C3=ADaz
daniel.diaz@linaro.org
