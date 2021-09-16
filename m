Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6A2C40D38C
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 08:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234653AbhIPG67 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 02:58:59 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:53725 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234759AbhIPG65 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Sep 2021 02:58:57 -0400
Received: from mail-wr1-f49.google.com ([209.85.221.49]) by
 mrelayeu.kundenserver.de (mreue012 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1MGxYh-1mdfV50uLz-00E8ls for <stable@vger.kernel.org>; Thu, 16 Sep 2021
 08:57:36 +0200
Received: by mail-wr1-f49.google.com with SMTP id u18so5991445wrg.5
        for <stable@vger.kernel.org>; Wed, 15 Sep 2021 23:57:36 -0700 (PDT)
X-Gm-Message-State: AOAM5300BhppksZaeJB5oGNqclIm9EscVnrbbu/fYmX7udXR+cCYLDx/
        YQdp7FWy2qrZEN0GhOd5Sk7gR9Kb3KMqJicG4Uo=
X-Google-Smtp-Source: ABdhPJyGKya71NiCi0cGKIVI43Q1oZ/o0MNVo1GnwEqGalCBCvjnxdMrxJ5gSyMDHd7jluoisDJQCB8/rJUEKWJs+70=
X-Received: by 2002:a5d:528b:: with SMTP id c11mr4045013wrv.369.1631775455897;
 Wed, 15 Sep 2021 23:57:35 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYtcsy_jaGkssSSUb5qeQehLvPF9=TgEG9kn42NKez1mOQ@mail.gmail.com>
In-Reply-To: <CA+G9fYtcsy_jaGkssSSUb5qeQehLvPF9=TgEG9kn42NKez1mOQ@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 16 Sep 2021 08:57:20 +0200
X-Gmail-Original-Message-ID: <CAK8P3a19jGTStRnO+em7-7VRwEE-LBL0xY9uqY4+tqx+n04qeQ@mail.gmail.com>
Message-ID: <CAK8P3a19jGTStRnO+em7-7VRwEE-LBL0xY9uqY4+tqx+n04qeQ@mail.gmail.com>
Subject: Re: ARM: 9109/1: oabi-compat: add epoll_pwait handler
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:CR8G/E0Jocaq3YoF15S1G+xM1bNo+M2vyrtXvO+hShzqrzNlRpe
 ubyHZp8gMYNgo/u9x2NRBK89Wqc6bZw/5Rz6wNvkmRul02ZW5cVaX/rgqBfTq9gY5MN7gVO
 0jng5MK5cD+1SUqa8Vk9Zng1ho5oV3BBBg0Bosfpv9b5AXyzhMif/a/KekhRlcqDAublk5/
 Fqh+eJNygKyqwRXXmNlKg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:GCtZSFnVacw=:emanGUUpFkpgGHeKWtc90q
 Zmwb461F2rT7pgsBweBXuV7uJJxgoi5ecYiGAKvMFCncabHMZqa07BxQ17FjevgZ4elmbGd1u
 QF4Xgmz0k+ALoitdZ6laU35PBVwE8BsFXXd7F1s01l5Zx33fc0Jtp0ryrZbTQT7z7tVJrFH0y
 T2bv35URhQqeSNNRQeKsTIv6wb+Yh7mXwNg2+9zaonzvt4zkDJhKd/ZngkKZp43eCvk66uZwS
 IlyihXtkeA/0xgl4yzZjYGf7gD/p0bQEhQrqOj64B5NgTZH9riyJP8uDPRDXkJlVi3cLVoRRy
 v2QqkAO956SG/TRedwuJchNnaqlcITcnUDLOKhBtuFnslwa4Vyhwr/wC3FJXp9jYan3hZnttp
 hLiRFWeBQ0FpAjdQHUYf6t9J3wQ9b3sKwF5oREq+5d6D06No0H0wTfaYeLkN1g/jU1a1gG7Y+
 LTfnBST+8cWuSNYCiHym5v3suXQI+on2twTJTN8CQocbYxaD7tRJTKLfTAv20XFkqvvO5DDxt
 A0/w44WGDY74qoc6Y6y7Xznm+NI8dL0P400wtuEkgYHclzDIjm65HvCNea0cmqgzkYXIh80Zc
 WAl30jaSWGmTj+UM6/uNIVVpxpG/LqmthfIIMZOmJv1hbkZFtvL4j0SXYI/h0QQmj2Mix0cHB
 scUE9so4+4QNhrztZB/ZiSXmR0blr2/W7I0SbRvX8hyrT76GMuL/JG3vITFtS/N6n8iJtHgTD
 3iH85NHeHMcixgKqVS63psB/hZvKqGk67nh0aA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 16, 2021 at 8:40 AM Naresh Kamboju
<naresh.kamboju@linaro.org> wrote:
>
> Following build warnings/ errors noticed while building stable-rc 4.14...5.14
> branches with gcc-8/9/10/11 for arm architecture with axm55xx_defconfig.
>
> # to reproduce this build locally:
> tuxmake --runtime podman --target-arch arm --toolchain gcc-11
> --kconfig axm55xx_defconfig

Thank you for the report!

This was introduced in my upstream commit b6e47f3c11c1 ("ARM: 9109/1:
oabi-compat:
add epoll_pwait handler") and fixed in the immediately following 249dbe74d3c4
("ARM: 9108/1: oabi-compat: rework epoll_wait/epoll_pwait emulation").

Only the first patch got backported to stable-rc, so it's broken
there. If anyone
thinks we want to keep the epoll_pwait emulation in stable, I can do a backport,
but I would just drop that commit from all stable kernels.

      Arnd
