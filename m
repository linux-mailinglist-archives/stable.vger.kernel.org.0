Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9BC65930EA
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 16:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbiHOOnM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 10:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230418AbiHOOnL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 10:43:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B192D15FFE
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 07:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660574589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=z5mQ0hPi4AeyBfzZet0Uijp05MF1VufdFtq2pAuw55o=;
        b=ao9lnzxSmb4GJR4dF7dO/FFklh9xOECHwex713otqx4ueLYEDOGMOeRKWrW+i/ozoFumZ6
        Al+y6OeTS1q4oDVaZugzKp4CDNW6hWNWk72Qeu8qm2SwsBqhGigX2c16brJxl0GJCzPYt3
        WmdNrz9qZB1h7IueJE17Ei9qcT50DYw=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-360-p95PeCmPP8uTRIipTFWL9g-1; Mon, 15 Aug 2022 10:43:08 -0400
X-MC-Unique: p95PeCmPP8uTRIipTFWL9g-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-32a144ac47fso62037257b3.8
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 07:43:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc;
        bh=z5mQ0hPi4AeyBfzZet0Uijp05MF1VufdFtq2pAuw55o=;
        b=nqw9OpJsZaRo+jL3m2dZnAIvxb7pCWeiyDHtQ8aKe8Kw/LEk0Ouha2bVHDl9zDgCPH
         g9a4jYap/CgImtBYyemHTh45DVpZ/4j44ZbhTHNWxnkW43+CeEcAz5d/s++IYIBv1vlR
         bfm0XWjoVjdgFjfqnN12cMkj/aKebiaw/m/Mjp+x38wMNNY7pXjgpqi1EFErF03CwtFP
         BrmYfkcjWuVR3DQKNnb7lV3/km2oCrWa5TFt3FnHh/0D/MdLf1g8cyH+MJqs9tP5ckHY
         BJAJl4BeLHHEgH2dmHOCIpRxUuLJDewpBuusNn+Rx4cFXuK/dt3zj0Dl3i0j9hSwFhwg
         sLeA==
X-Gm-Message-State: ACgBeo1Nq55AFcACsWZWsNrJGvJgutMHqlE7I1A6wGZ3g6NtMfI7wUKt
        DfxVY0mwrsqMMK1SUcojq7cC6+yvCTzuGGsjkwvXasvy6GTzPL/3b4TZW1eamnRXPZcJ/CraWd0
        1X78kRWAIrQgxm4ZVQb+ZMQ5qu8CW2Jk1
X-Received: by 2002:a0d:d744:0:b0:321:fdb4:12a5 with SMTP id z65-20020a0dd744000000b00321fdb412a5mr13398559ywd.479.1660574588090;
        Mon, 15 Aug 2022 07:43:08 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4MS+dbitMoerpbYebp6DjUn8i3vjwRH3q21hXP/pKhcScEOu2pWwVlKBM19QZz0R3QM5VfRSYu3E0LAwaCZVE=
X-Received: by 2002:a0d:d744:0:b0:321:fdb4:12a5 with SMTP id
 z65-20020a0dd744000000b00321fdb412a5mr13398543ywd.479.1660574587905; Mon, 15
 Aug 2022 07:43:07 -0700 (PDT)
MIME-Version: 1.0
From:   Veronika Kabatova <vkabatov@redhat.com>
Date:   Mon, 15 Aug 2022 16:42:32 +0200
Message-ID: <CA+tGwnk-zD0O_xV_LqUPa4XC-S9oCFbPvQf+8FkREqfZjqwHwg@mail.gmail.com>
Subject: =?UTF-8?Q?5=2E18_queue_aarch64_build_issue=3A_kexec=5Fkernel=5Fverify=5F?=
        =?UTF-8?Q?pe=5Fsig=E2=80=99_undeclared?=
To:     Linux Stable maillist <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

CKI has been hitting the following build issue on aarch64 with the
latest queues:

00:00:12 arch/arm64/kernel/kexec_image.c:136:23: error:
=E2=80=98kexec_kernel_verify_pe_sig=E2=80=99 undeclared here (not in a func=
tion)
00:00:12   136 |         .verify_sig =3D kexec_kernel_verify_pe_sig,
00:00:12       |                       ^~~~~~~~~~~~~~~~~~~~~~~~~~
00:00:12 make[4]: *** [scripts/Makefile.build:289:
arch/arm64/kernel/kexec_image.o] Error 1
00:00:12 make[3]: *** [scripts/Makefile.build:551: arch/arm64/kernel] Error=
 2
00:00:12 make[2]: *** [Makefile:1844: arch/arm64] Error 2

Seems to be caused by
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/=
commit/?h=3Dqueue/5.18&id=3D3d36f26a98be23c6fc48f4589030c87dc6e1a268

Full build log and kernel config used is available at

https://datawarehouse.cki-project.org/kcidb/builds/251196

or with other recent stable queue checkouts in DataWarehouse.


Veronika

