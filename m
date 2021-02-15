Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0542231B611
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 09:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbhBOI5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 03:57:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:47850 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229595AbhBOI47 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 03:56:59 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7EACAADE0;
        Mon, 15 Feb 2021 08:56:17 +0000 (UTC)
Subject: Re: [PATCH v3] kcmp: Support selection of SYS_kcmp without
 CHECKPOINT_RESTORE
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        linux-kernel@vger.kernel.org
Cc:     Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx@lists.freedesktop.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        dri-devel@lists.freedesktop.org,
        Andy Lutomirski <luto@amacapital.net>,
        Cyrill Gorcunov <gorcunov@gmail.com>, stable@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
References: <20210205163752.11932-1-chris@chris-wilson.co.uk>
 <20210205220012.1983-1-chris@chris-wilson.co.uk>
From:   Thomas Zimmermann <tzimmermann@suse.de>
Message-ID: <f3b09921-df08-b4fc-bd3b-1aaf583bc9a8@suse.de>
Date:   Mon, 15 Feb 2021 09:56:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210205220012.1983-1-chris@chris-wilson.co.uk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="StY4QkOf8VnBZ9PWJHOu8j2lZZxSHqhoO"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--StY4QkOf8VnBZ9PWJHOu8j2lZZxSHqhoO
Content-Type: multipart/mixed; boundary="DQ9J4BgxYOiXYYmKggX3lsPoJY3gULU7G";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Chris Wilson <chris@chris-wilson.co.uk>, linux-kernel@vger.kernel.org
Cc: Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>,
 Daniel Vetter <daniel.vetter@ffwll.ch>, intel-gfx@lists.freedesktop.org,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>,
 dri-devel@lists.freedesktop.org, Andy Lutomirski <luto@amacapital.net>,
 Cyrill Gorcunov <gorcunov@gmail.com>, stable@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>
Message-ID: <f3b09921-df08-b4fc-bd3b-1aaf583bc9a8@suse.de>
Subject: Re: [PATCH v3] kcmp: Support selection of SYS_kcmp without
 CHECKPOINT_RESTORE
References: <20210205163752.11932-1-chris@chris-wilson.co.uk>
 <20210205220012.1983-1-chris@chris-wilson.co.uk>
In-Reply-To: <20210205220012.1983-1-chris@chris-wilson.co.uk>

--DQ9J4BgxYOiXYYmKggX3lsPoJY3gULU7G
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi

Am 05.02.21 um 23:00 schrieb Chris Wilson:
> Userspace has discovered the functionality offered by SYS_kcmp and has
> started to depend upon it. In particular, Mesa uses SYS_kcmp for
> os_same_file_description() in order to identify when two fd (e.g. devic=
e
> or dmabuf) point to the same struct file. Since they depend on it for
> core functionality, lift SYS_kcmp out of the non-default
> CONFIG_CHECKPOINT_RESTORE into the selectable syscall category.
>=20
> Rasmus Villemoes also pointed out that systemd uses SYS_kcmp to
> deduplicate the per-service file descriptor store.

This helps a lot with transactional programming in userspace system=20
code. So FWIW

Acked-by: Thomas Zimmermann <tzimmermann@suse.de>

>=20
> Note that some distributions such as Ubuntu are already enabling
> CHECKPOINT_RESTORE in their configs and so, by extension, SYS_kcmp.
>=20
> References: https://gitlab.freedesktop.org/drm/intel/-/issues/3046
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Will Drewry <wad@chromium.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Dave Airlie <airlied@gmail.com>
> Cc: Daniel Vetter <daniel@ffwll.ch>
> Cc: Lucas Stach <l.stach@pengutronix.de>
> Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Cc: Cyrill Gorcunov <gorcunov@gmail.com>
> Cc: stable@vger.kernel.org
> Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch> # DRM depends on kcmp
> Acked-by: Rasmus Villemoes <linux@rasmusvillemoes.dk> # systemd uses kc=
mp
>=20
> ---
> v2:
>    - Default n.
>    - Borrrow help message from man kcmp.
>    - Export get_epoll_tfile_raw_ptr() for CONFIG_KCMP
> v3:
>    - Select KCMP for CONFIG_DRM
> ---
>   drivers/gpu/drm/Kconfig                       |  3 +++
>   fs/eventpoll.c                                |  4 ++--
>   include/linux/eventpoll.h                     |  2 +-
>   init/Kconfig                                  | 11 +++++++++++
>   kernel/Makefile                               |  2 +-
>   tools/testing/selftests/seccomp/seccomp_bpf.c |  2 +-
>   6 files changed, 19 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
> index 0973f408d75f..af6c6d214d91 100644
> --- a/drivers/gpu/drm/Kconfig
> +++ b/drivers/gpu/drm/Kconfig
> @@ -15,6 +15,9 @@ menuconfig DRM
>   	select I2C_ALGOBIT
>   	select DMA_SHARED_BUFFER
>   	select SYNC_FILE
> +# gallium uses SYS_kcmp for os_same_file_description() to de-duplicate=

> +# device and dmabuf fd. Let's make sure that is available for our user=
space.
> +	select KCMP
>   	help
>   	  Kernel-level support for the Direct Rendering Infrastructure (DRI)=

>   	  introduced in XFree86 4.0. If you say Y here, you need to select
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index a829af074eb5..3196474cbe24 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -979,7 +979,7 @@ static struct epitem *ep_find(struct eventpoll *ep,=
 struct file *file, int fd)
>   	return epir;
>   }
>  =20
> -#ifdef CONFIG_CHECKPOINT_RESTORE
> +#ifdef CONFIG_KCMP
>   static struct epitem *ep_find_tfd(struct eventpoll *ep, int tfd, unsi=
gned long toff)
>   {
>   	struct rb_node *rbp;
> @@ -1021,7 +1021,7 @@ struct file *get_epoll_tfile_raw_ptr(struct file =
*file, int tfd,
>  =20
>   	return file_raw;
>   }
> -#endif /* CONFIG_CHECKPOINT_RESTORE */
> +#endif /* CONFIG_KCMP */
>  =20
>   /**
>    * Adds a new entry to the tail of the list in a lockless way, i.e.
> diff --git a/include/linux/eventpoll.h b/include/linux/eventpoll.h
> index 0350393465d4..593322c946e6 100644
> --- a/include/linux/eventpoll.h
> +++ b/include/linux/eventpoll.h
> @@ -18,7 +18,7 @@ struct file;
>  =20
>   #ifdef CONFIG_EPOLL
>  =20
> -#ifdef CONFIG_CHECKPOINT_RESTORE
> +#ifdef CONFIG_KCMP
>   struct file *get_epoll_tfile_raw_ptr(struct file *file, int tfd, unsi=
gned long toff);
>   #endif
>  =20
> diff --git a/init/Kconfig b/init/Kconfig
> index b77c60f8b963..9cc7436b2f73 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1194,6 +1194,7 @@ endif # NAMESPACES
>   config CHECKPOINT_RESTORE
>   	bool "Checkpoint/restore support"
>   	select PROC_CHILDREN
> +	select KCMP
>   	default n
>   	help
>   	  Enables additional kernel features in a sake of checkpoint/restore=
=2E
> @@ -1737,6 +1738,16 @@ config ARCH_HAS_MEMBARRIER_CALLBACKS
>   config ARCH_HAS_MEMBARRIER_SYNC_CORE
>   	bool
>  =20
> +config KCMP
> +	bool "Enable kcmp() system call" if EXPERT
> +	help
> +	  Enable the kernel resource comparison system call. It provides
> +	  user-space with the ability to compare two processes to see if they=

> +	  share a common resource, such as a file descriptor or even virtual
> +	  memory space.
> +
> +	  If unsure, say N.
> +
>   config RSEQ
>   	bool "Enable rseq() system call" if EXPERT
>   	default y
> diff --git a/kernel/Makefile b/kernel/Makefile
> index aa7368c7eabf..320f1f3941b7 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -51,7 +51,7 @@ obj-y +=3D livepatch/
>   obj-y +=3D dma/
>   obj-y +=3D entry/
>  =20
> -obj-$(CONFIG_CHECKPOINT_RESTORE) +=3D kcmp.o
> +obj-$(CONFIG_KCMP) +=3D kcmp.o
>   obj-$(CONFIG_FREEZER) +=3D freezer.o
>   obj-$(CONFIG_PROFILING) +=3D profile.o
>   obj-$(CONFIG_STACKTRACE) +=3D stacktrace.o
> diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/test=
ing/selftests/seccomp/seccomp_bpf.c
> index 26c72f2b61b1..1b6c7d33c4ff 100644
> --- a/tools/testing/selftests/seccomp/seccomp_bpf.c
> +++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
> @@ -315,7 +315,7 @@ TEST(kcmp)
>   	ret =3D __filecmp(getpid(), getpid(), 1, 1);
>   	EXPECT_EQ(ret, 0);
>   	if (ret !=3D 0 && errno =3D=3D ENOSYS)
> -		SKIP(return, "Kernel does not support kcmp() (missing CONFIG_CHECKPO=
INT_RESTORE?)");
> +		SKIP(return, "Kernel does not support kcmp() (missing CONFIG_KCMP?)"=
);
>   }
>  =20
>   TEST(mode_strict_support)
>=20

--=20
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Maxfeldstr. 5, 90409 N=C3=BCrnberg, Germany
(HRB 36809, AG N=C3=BCrnberg)
Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=B6rffer


--DQ9J4BgxYOiXYYmKggX3lsPoJY3gULU7G--

--StY4QkOf8VnBZ9PWJHOu8j2lZZxSHqhoO
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmAqNy4FAwAAAAAACgkQlh/E3EQov+D5
zRAArRuP1f2kfckNRiTbiUHOWtnyMziX9iF0ptq+QvAII1SBqhTurNJAsJ7vkWFXtFKSzs6A7he4
nzylEw83a7LJwNSn2rmxXM8sxZuUC+44arhPhEjangMbVgdiaiQZvcTSGmE3tks4FJIJdUQbEEkX
1o+0ZOQwMSy0vy2iJ/Sv1SDxZgpLAhC/m6gTX+1KQFbSxPKGkQ8xOdI++zk341j00Rgf6E+GjQoD
z5li+N6dfqmxPqSssx+q2ztzwYKfL9DMkzfwouIoYbI1Z9rtXjALaDVfu1LOYBCyvqsBF95xj00V
lkAJ65L/3bPO4b/KS5g0QSB5VrM/z+efpDZfRZWo5jRCBYDXORZPVKe/ohlu8pNQ9cOnkyYHBw4v
P4+xanjQJ7YgF2imNTR/DPMoCRZLc6tQd2+Xt0uYqLSN3Vc8BdoAipYDnsu2aHMBWYOP2GpUY95Z
B5l5MBB/6acok9167jl0O3z4ON6rOcT4WnBPjJwkS+1pWI7FL72C3Y2UrmkssZN0P+bptw/wJJPY
QrhU0+8Zi7TE1bwDR41Pg3Rg4md6pyNCdwC9TfwZS5ApsqfGpT0kWJmeXJ8NXWMVcrEhOILmbWuq
KCCSZybSYuKwiSLPqSM/I/ozP1lUDNoltxTFNc2WjNgG/zL4qS4pZYgg7H3f4LdwETdBwtiEcfu2
tsE=
=kzOS
-----END PGP SIGNATURE-----

--StY4QkOf8VnBZ9PWJHOu8j2lZZxSHqhoO--
