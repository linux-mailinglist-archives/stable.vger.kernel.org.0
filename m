Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE3343988A4
	for <lists+stable@lfdr.de>; Wed,  2 Jun 2021 13:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbhFBLz3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Jun 2021 07:55:29 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:45467 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbhFBLz3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Jun 2021 07:55:29 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]) by
 mrelayeu.kundenserver.de (mreue108 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1Mr9Jw-1l0SJb1Q1O-00oE88 for <stable@vger.kernel.org>; Wed, 02 Jun 2021
 13:53:45 +0200
Received: by mail-wr1-f45.google.com with SMTP id a11so121772wrt.13
        for <stable@vger.kernel.org>; Wed, 02 Jun 2021 04:53:45 -0700 (PDT)
X-Gm-Message-State: AOAM533wPAtuzv/4buHXrzl99CWuUhyaogi4R/Xj9EbN7E54fqO/ZTU9
        yREUKZAU0v70Z7Yfb9knDV3nvjD5SCRpHV9hrY4=
X-Google-Smtp-Source: ABdhPJzEbw0P1LYhc8YudQDS84cn+BFWj38KbeMlrKY+BmLv8BPqe/gI7hkaMRNPtoqJged6fhsEp8/4XKKGP4G32wI=
X-Received: by 2002:a5d:5084:: with SMTP id a4mr1115982wrt.286.1622634824981;
 Wed, 02 Jun 2021 04:53:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210602114617.423521-1-arnd@kernel.org>
In-Reply-To: <20210602114617.423521-1-arnd@kernel.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 2 Jun 2021 13:52:06 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3ZFFRVfT=art9_r5Ca+K_t5usaHsvqD2VjhbPXqw-Mqw@mail.gmail.com>
Message-ID: <CAK8P3a3ZFFRVfT=art9_r5Ca+K_t5usaHsvqD2VjhbPXqw-Mqw@mail.gmail.com>
Subject: Re: [musl] [PATCH] [stable v4.1] arm64: Remove unimplemented syscall
 log message
To:     "# 3.4.x" <stable@vger.kernel.org>
Cc:     Michael Weiser <michael.weiser@gmx.de>,
        Martin Vajnar <martin.vajnar@gmail.com>,
        musl@lists.openwall.com, Will Deacon <will.deacon@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:25eQAuha7eMTnJbuZedWUE/CDXkjgjnzy7WM/xeMUJ3RRmwyEKi
 X/ZhOzFtyfwZ7oSHXhxUbjadSVAqkdaVTkINbhwGGeDx4Hh5AUx4miRt2dSSy1hocneLnsx
 MnJ9nJqPvHrwHDZfjPUNrSaLu+5vqE0ed34dHdkqspIvc3uaa5wBpQqxOZheDsyObQB59oM
 U4GvEi+g7XjKCVSfXeVjA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:D3BL0GRqN+8=:opwMAmvfow83yqSzee0lA4
 15lQPuKwh8vQhnaHf9eBr+ureZS/Ux0FpdunRw6OycmOQLKn6XkxrKyB9O3zfPk7mVMun/FcD
 +6Lx7+r45FQvfPUTI3BfP/mz9TYd3sNciwJt71N1QM6r9yDJiMi/oXnbVP50aK5OMX04V10L/
 //yj8Dntcl2LNyOGLL4kj0l3oDXgWilr9CZ9+nBlmFJaWx9xhM0CivH6vscbMIbhnpui5HjkE
 mcO5FYZ+p4KPvgBdFynfUHruRCzjcXGpOXseoULmXR5DkAvOg5HdyOqUcFMt6Efo6zbKyvKqS
 uKElK3ATJAftsZKjpa7SBlqblKgxBVVOlOj6RPWz0ru3sr781F0b/WbbJnyP2hrpZH15BUpYE
 4OuwWaIWf8rW+LTKmFs6UId+5qQxiuJS2yUk678tSzPo4F5IyDCYjAR5NhU4afeYHRL0dTXu4
 gvYg2Gws2sJncM24iMg73SUuBtHjwz4DojW6Xa1M4Fu/pFCW63OwHbDzuLbpkVbQQeXvoqV73
 b4+jdaK4r+CA57ptM/0D6CeFDiUHRktTYWNCGVkpXBV9eC54gUIfJUrySLR4PnMBdC1IpZUWa
 FweYdLlE/DgU5vJeVw+QJeYZBz/NBUaxn6ehWCcOvmSI1/N3sK5fI6szao5g6jG+Grp2NHfvi
 UETo=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 2, 2021 at 1:48 PM Arnd Bergmann <arnd@kernel.org> wrote:
>
> From: Michael Weiser <michael.weiser@gmx.de>
>
> commit 1962682d2b2fbe6cfa995a85c53c069fadda473e upstream.
>
> Stop printing a (ratelimited) kernel message for each instance of an
> unimplemented syscall being called. Userland making an unimplemented
> syscall is not necessarily misbehaviour and to be expected with a
> current userland running on an older kernel. Also, the current message
> looks scary to users but does not actually indicate a real problem nor
> help them narrow down the cause. Just rely on sys_ni_syscall() to return
> -ENOSYS.

Nevermind, I forgot the 4.1.y line had ended. The 4.4 version is still needed
though, and also applies to 4.9.

        Arnd
