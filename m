Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C88701DC180
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 23:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbgETVmq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 17:42:46 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:41187 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726892AbgETVmq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 17:42:46 -0400
Received: from mail-qv1-f44.google.com ([209.85.219.44]) by
 mrelayeu.kundenserver.de (mreue012 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MoNMu-1jHZwi0kSu-00onZ8; Wed, 20 May 2020 23:42:44 +0200
Received: by mail-qv1-f44.google.com with SMTP id r3so2154084qve.1;
        Wed, 20 May 2020 14:42:43 -0700 (PDT)
X-Gm-Message-State: AOAM533GjhBautts7IUwphMqHBZKFQTAnywZVO64O9U6zfbD0hB8z3sx
        HwiwNFdga0FCjyZXD/p1KLjTx/LsOrO7jF7isxw=
X-Google-Smtp-Source: ABdhPJzqluJpjChrOvgJkkIdUGT2EiHJKbRLacwd76DqeSZ2FPgAGae11Qsi1dscs2p1lOEvfqqL2zplAF5/7ZUcObU=
X-Received: by 2002:a05:6214:370:: with SMTP id t16mr7010872qvu.197.1590010962936;
 Wed, 20 May 2020 14:42:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200520195440.38759-1-hdegoede@redhat.com>
In-Reply-To: <20200520195440.38759-1-hdegoede@redhat.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 20 May 2020 23:42:27 +0200
X-Gmail-Original-Message-ID: <CAK8P3a03dcvaQxHOOvTtuqPoDzt0j0EOs2YSRcwT93H-fU09_Q@mail.gmail.com>
Message-ID: <CAK8P3a03dcvaQxHOOvTtuqPoDzt0j0EOs2YSRcwT93H-fU09_Q@mail.gmail.com>
Subject: Re: [PATCH 1/8] virt: vbox: Fix VBGL_IOCTL_VMMDEV_REQUEST_BIG and
 _LOG req numbers to match upstream
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:oscDWc1YLGf4SwYCvc5P2AvuWfD4qvj30kvLjRo1NO7fGDJ+B8E
 gYcomW8F0QlBp2+9WKIo5r+2Df/a01eXlyBDu7l0vWKkVDmqQZhZyaT2pGXSg0ORd//9lTG
 UR/vbA1DUjeQc2mcKiXnN1Qi4Kichd1nV1y8W4itr9/2wRkKa3vhfLqNipwvIE73BQUbosU
 yLoRZVQ2eXBsSXVYxqNVw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:U7xX/eMtTco=:6MOIcaWzMF+HM+38sD0/nT
 8HX0+zLZOWVSexnNrm75vlHC+h1P+LLR/gW2TqZET37+oQm24sdm4zbTyGunva8LionCE3oUP
 LVxYkTg6fCDAvGBJ2+fbXJr6cJsh3/djB9B9JMdn+uC2kcUd/gnl0EqFQ0dTDC9vmBWJbNLvi
 WBRKEAQCXk5CLd9eaC88zxDFD8UL+7Y9Y3NI1LrMabZFJU6G1enhMYHmhZ1nSzWJ/Ei2E13r6
 uYjH77vWDiu8QzrcPBw0fOjDNgo3gNiCwwkZP7sslwPFim5nHiwHYC/XcNJnJKu4fPdigiUrp
 lUijipftfXDWT6+hZTG9xSgXIn6tHBcv283O69AGhhlB0rleh6vKIJi5eAYbq2Sl+srXnvJ5T
 yfSXP5WMvm40hBiZEqSp50C8fybMPZqVZAmRV9Grjv95En2gF55Mv8sEqKYhNp3XJf31Abr1a
 tKUxccg1gUMF8OQLmzxQHsLLjKHVxLujKmc86yfen2sAGrGHQV2IzmKJBUmmrVKqLEC4zEkor
 nKVX9Gb9s7BhAcdBIrObmLt7S0JcnD9TdrwShoRidmhdLtMG1XiQb/qBKJvi2KsySZKxk4cEM
 qy68URavMLREJnnvrEWRbWT0TEiEleTiGTt8vrr7N6H1psNPROujkrpIwbFRQhTAWACLw+dVr
 8cqzSBlWEk3hvimxuCptg950PFzVJYD8HVFwPKCeeKRN6CTOZDuaZNhy3KaM96v9+DvaBM8KL
 LKzRK0DCgP21WkSYEEy0Omt8umF6UDrog8UzvarD6rgwYP6XYTyAxHuQtOKPu25RWOJfOoKif
 DOyyApqlJ2JfTMXTE9Hwvm12MBvIz0ehNazp0jWCIFl6Uuqz/M=
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 20, 2020 at 9:54 PM Hans de Goede <hdegoede@redhat.com> wrote:
>
> Until this commit the mainline kernel version (this version) of the
> vboxguest module contained a bug where it defined
> VBGL_IOCTL_VMMDEV_REQUEST_BIG and VBGL_IOCTL_LOG using
> _IOC(_IOC_READ | _IOC_WRITE, 'V', ...) instead of
> _IO(V, ...) as the out of tree VirtualBox upstream version does.
>
> Since the VirtualBox userspace bits are always built against VirtualBox
> upstream's headers, this means that so far the mainline kernel version
> of the vboxguest module has been failing these 2 ioctls with -ENOTTY.
> I guess that VBGL_IOCTL_VMMDEV_REQUEST_BIG is never used causing us to
> not hit that one and sofar the vboxguest driver has failed to actually
> log any log messages passed it through VBGL_IOCTL_LOG.
>
> This commit changes the VBGL_IOCTL_VMMDEV_REQUEST_BIG and VBGL_IOCTL_LOG
> defines to match the out of tree VirtualBox upstream vboxguest version,
> while keeping compatibility with the old wrong request defines so as
> to not break the kernel ABI in case someone has been using the old
> request defines.
>
> Fixes: f6ddd094f579 ("virt: Add vboxguest driver for Virtual Box Guest integration UAPI")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Indeed, this sounds like the best fix

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
