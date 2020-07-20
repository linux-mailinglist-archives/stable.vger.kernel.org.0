Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F48E226276
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 16:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728840AbgGTOq5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 10:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbgGTOq5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 10:46:57 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6C4C061794
        for <stable@vger.kernel.org>; Mon, 20 Jul 2020 07:46:56 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id h8so1645723lfp.9
        for <stable@vger.kernel.org>; Mon, 20 Jul 2020 07:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=8mBayLljK07tpOK2cUTx9sKmUzYXsIypNs7qoG7RKhU=;
        b=CP6z+OagiOM3edDj+9njgav3aT+Rn/yoTy9MPIcYtYIMv94mdpF/eozlqAAj5XeMuz
         J9k5rgrUeXIKALOhOklzF1DIZt6Q4lG3uzgPNMXYYJG1fCOki5c6aJqn6n0irEIGXTig
         clardMVA0iOlK7uYjcdmh2khyb0VtBzvgYAhXPkqQTOXuHxBzz33s5fqaaaB1d7P2LS/
         pv+ae/MVCFmj3obqoyBJH4HeKeDHuCo+nw59cLctaokNuKTq3He2M91XCrShckcFt9Sw
         1ptxAMTxCC7sZbxx7Qz7RabaKOTQk0VLzEXtgzhUMwA9QqbO7jcDRN5dr7MjzKjQ6clJ
         xivw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=8mBayLljK07tpOK2cUTx9sKmUzYXsIypNs7qoG7RKhU=;
        b=BJILkMkO/SyIJLz8H/ZoK1hfemTpD2ghqbd+mwOX+UHDBwSNRvoUL2vJUwKBxCh2Fp
         PJywKM4O1LP7JwnrJ8G+pOvSGEgt+gpIwjwSJO7ZCCy9+8PJNOUch9Dxx/TcqAFv3uwJ
         u1HjxZCUrwyqnM8DavJfUF05+5SIuKDq0hsN+TfE5owyDOWYsGkoRjxA3crSEIRR4p38
         Y7dC3s5CZ9knRD0eTqkcvQPMM9TQIjgpU1TsiKDZvvxNWsTEIi5Mz0h1IbTLAOYSQf7c
         ulU20dGocMAukkBOPe1C8zyykR/yiYOKpJDbP1/QX9G5IT7GCyCxZrSGx04SWzDOrunY
         uyrg==
X-Gm-Message-State: AOAM531crVHc9mLWvPOY4LxAIcUKT3cEg6wauOq/0wlF2PRURHejXuFy
        nfKd87cUdQDPcIbZ2g+S3UqerKkTJEm2eOgataY5YllmZBwEjA==
X-Google-Smtp-Source: ABdhPJwkuKFs7Hj/o/ey5gsewnVJS+LmxZXfFX3ecSA3cKuBaDV8nu/l14mHK4eUdXE2f7m4fOg4GvCI710SkyPjufY=
X-Received: by 2002:a19:c653:: with SMTP id w80mr10014499lff.167.1595256414075;
 Mon, 20 Jul 2020 07:46:54 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 20 Jul 2020 20:16:42 +0530
Message-ID: <CA+G9fYuPe=XkrTx+yDo556D5t4wrFRFXctPPb2+7w+v-hAHvyw@mail.gmail.com>
Subject: =?UTF-8?Q?stable=2Drc_5=2E4=3A_arm_build_failed=3A_arm=2Dinit=2Ec=3A327=3A12=3A_?=
        =?UTF-8?Q?error=3A_implicit_declaration_of_function_=E2=80=98get=5Fdev=5Ffrom=5Ffwno?=
        =?UTF-8?Q?de=E2=80=99?=
To:     linux- stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        saravanak@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

arm build failed on stable-rc 5.4 branch.

make -sk KBUILD_BUILD_USER=3DTuxBuild -C/linux -j32 ARCH=3Darm
CROSS_COMPILE=3Darm-linux-gnueabihf- HOSTCC=3Dgcc CC=3D"sccache
arm-linux-gnueabihf-gcc" O=3Dbuild zImage
#
../drivers/firmware/efi/arm-init.c: In function =E2=80=98efifb_add_links=E2=
=80=99:
../drivers/firmware/efi/arm-init.c:327:12: error: implicit declaration
of function =E2=80=98get_dev_from_fwnode=E2=80=99
[-Werror=3Dimplicit-function-declaration]
  327 |  sup_dev =3D get_dev_from_fwnode(&sup_np->fwnode);
      |            ^~~~~~~~~~~~~~~~~~~
../drivers/firmware/efi/arm-init.c:327:10: warning: assignment to
=E2=80=98struct device *=E2=80=99 from =E2=80=98int=E2=80=99 makes pointer =
from integer without a cast
[-Wint-conversion]
  327 |  sup_dev =3D get_dev_from_fwnode(&sup_np->fwnode);
      |          ^
../drivers/firmware/efi/arm-init.c: At top level:
../drivers/firmware/efi/arm-init.c:352:3: error: =E2=80=98const struct
fwnode_operations=E2=80=99 has no member named =E2=80=98add_links=E2=80=99
  352 |  .add_links =3D efifb_add_links,
      |   ^~~~~~~~~
../drivers/firmware/efi/arm-init.c:352:15: error: initialization of
=E2=80=98struct fwnode_handle * (*)(struct fwnode_handle *)=E2=80=99 from i=
ncompatible
pointer type =E2=80=98int (*)(const struct fwnode_handle *, struct device *=
)=E2=80=99
[-Werror=3Dincompatible-pointer-types]
  352 |  .add_links =3D efifb_add_links,
      |               ^~~~~~~~~~~~~~~
../drivers/firmware/efi/arm-init.c:352:15: note: (near initialization
for =E2=80=98efifb_fwnode_ops.get=E2=80=99)


seems like this is coming from the below patch
--
efi/arm: Defer probe of PCIe backed efifb on DT systems
[ Upstream commit 64c8a0cd0a535891d5905c3a1651150f0f141439 ]

The new of_devlink support breaks PCIe probing on ARM platforms booting
via UEFI if the firmware exposes a EFI framebuffer that is backed by a
PCI device. The reason is that the probing order gets reversed,
resulting in a resource conflict on the framebuffer memory window when
the PCIe probes last, causing it to give up entirely.

Given that we rely on PCI quirks to deal with EFI framebuffers that get
moved around in memory, we cannot simply drop the memory reservation, so
instead, let's use the device link infrastructure to register this
dependency, and force the probing to occur in the expected order.

Co-developed-by: Saravana Kannan <saravanak@google.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Saravana Kannan <saravanak@google.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20200113172245.27925-9-ardb@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>


--=20
Linaro LKFT
https://lkft.linaro.org
