Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 030B4B292D
	for <lists+stable@lfdr.de>; Sat, 14 Sep 2019 02:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387751AbfINArp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 20:47:45 -0400
Received: from mout.gmx.net ([212.227.15.19]:48697 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388296AbfINArp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 20:47:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1568422058;
        bh=1dZAU78IbYBJcN9+5AKzIxpSms+M9yL1tlbHpZD/bcQ=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:In-Reply-To:References;
        b=S+aC3CT1AwNpHRsF07+4ErjMQ/KQ45JkKW2Wo8i4CSipYt7XUbuTuBCtJ2JkcPfAe
         Fmu/N/CNYqkZg9jYTiURVGo7jUdYsh61BF9vtR5DKzv1xO7WXSxsCkY3HdpZSGKBOo
         L+yqJQYIW8veYprIf3R7xfc4gro2VfN3UlmHDeFU=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from mir ([87.182.155.9]) by mail.gmx.com (mrgmx003
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0LiTF6-1iey7a2L1A-00cl0o; Sat, 14
 Sep 2019 02:47:38 +0200
Date:   Sat, 14 Sep 2019 02:54:11 +0200
From:   Stefan Lippers-Hollmann <s.l-h@gmx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH 5.2 36/37] vhost: block speculation of translated
 descriptors
Message-ID: <20190914025411.3016e3d9@mir>
In-Reply-To: <20190913130522.155505270@linuxfoundation.org>
References: <20190913130510.727515099@linuxfoundation.org>
        <20190913130522.155505270@linuxfoundation.org>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:dWohtcikPsP+foKcejhDs0dYClSz0t2lT2LaYlvH9kzBA26OjF4
 q1aroeVLhDuZxeMytW1+o7icptt5x4/nYzvDWnSi8+UypS2g9YNLcDVzbrJ18kkQdK5q1bM
 oDEo5l2OYUnx/IVYV0cYzQhIitEY5MiXdDYp7OZ1XCPj4nZ6yv1Pj0aZCwY7pXD8HTfbX6p
 0aJOXoQ+JdwTuC83EZMzg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:GkONtRLr3SM=:o5S/3c9sh3IdOfEEU8u97P
 Etf0Y7lWX+6ZeznjPsseQ1OcCZxYGmSskByg97+zZE1Du21lCxRYNtNY3EzNEahwVrX5Hu0xS
 Vxqt8kzM8u9+syTpFd4ABhJs8EZ8co93Ql5tCjt6Atxq4f7ddD+T27s+HH6lKNhT3tUhspk3x
 RB673ZCdlzFpad5mJGhGn3dr7RaVUbVrCf32l5ijENRKvs++fwGT99fXSju9sX1XAISeWtIuF
 9fft4E325apDIXsmRoCSJOcRgWttWNAWh7yzu1uOqzbHYjVrdGNxYDgmAM3TgB42AFgog5fhV
 v6ttokvOcX8nyqh5wYi0s9wRH0tvcpJMKZaMddtHFTeM0lIb4hUWbTynD6GchyeqeQgkoncKY
 3AMgHwp3wodAy4ScdQCSEwS6OQ/hcqzO+uulQpawQf136Jh8huMCMs+zowQLpNVBVkPrPV3Us
 AedOreu1AghNZbpQ8XcCf4DPvwll2Wm9edw9NpTQjelEk2ZEMWgvKKB25wHvhA8C5dUhhMDJe
 2btWsM7t+2yDSWxD9sAh7doDVJ/0bwElNGpRqjxPaGgedvYj6CDW8wGHP3zGEJ1rDxKJ2LA0g
 W+lyvXHrFXJJopKOXaKMpfpj3jUcvmF4pQL4RL0MpKCrbULEfpqiS8HBCLbSbl5nXq/WCzZ2f
 Ii23cK1u8+PxOqwt1vU4YLZ7Qy9b/r8stGwsOE7ykBpsGdxaHfvwePG5E/VJydn6O6Hn7Hp1s
 +EX0s1a9pUlPBUiSt+OaNoxzosKEMI+Ls3mn2tOfJsi+/vZAAhce8wScGM1mHY8lhNNjaT4Pv
 MH7cSUwQM05ull3gWIc1v31X81R6weio4OmhSoaHkehK1EZo+1GA/knBtZ0UywfRHA9ix85lG
 sSe0ViQJHuV9wvCVVALvONMeBzxu295Ewr34KTE9+NHwaxP3m36PhBdwQzQhBcUV3G5gttjUY
 7WA/tDSWlHH1OsDdzRxYavQFka7sK90/J7kTgIp5XYlube4ta5mIbHrwLeWm7a81+3O8bKKWu
 FVHrMHmwiIjBBCHF57dr+BMmv8yU3pOw7Qo51ECK6Pz2+PxM7xDPFxuYyYG8/PdDA7RT1blv3
 NeHB7rDsvaIwR4zfHilVDZWtgCTuSTPgZ0CHTdctKlVWY8hFo6j3MrIzmJ1w4EyJMKlDlGkMx
 jqtn4OE5LyY8uPCbJtACe+DiB2SCbqxZnaBgl+SYPpTuIKMViutwxsW0fcmUJdYg6qHfmoPkz
 3wexbQRfripmCBxiQvJSb0YOTpJ6c6ekVCrRtSg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

On 2019-09-13, Greg Kroah-Hartman wrote:
> From: Michael S. Tsirkin <mst@redhat.com>
>
> commit a89db445fbd7f1f8457b03759aa7343fa530ef6b upstream.
>
> iovec addresses coming from vhost are assumed to be
> pre-validated, but in fact can be speculated to a value
> out of range.
>
> Userspace address are later validated with array_index_nospec so we can
> be sure kernel info does not leak through these addresses, but vhost
> must also not leak userspace info outside the allowed memory table to
> guests.
>
> Following the defence in depth principle, make sure
> the address is not validated out of node range.
[...]

This fails to compile as part of 5.2.15-rc1 on i386 (amd64 is fine), using
gcc 9.2.1. Reverting just this patch results in a successful build again.

> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -1965,8 +1965,10 @@ static int translate_desc(struct vhost_v
>  		_iov =3D iov + ret;
>  		size =3D node->size - addr + node->start;
>  		_iov->iov_len =3D min((u64)len - s, size);
> -		_iov->iov_base =3D (void __user *)(unsigned long)
> -			(node->userspace_addr + addr - node->start);
> +		_iov->iov_base =3D (void __user *)
> +			((unsigned long)node->userspace_addr +
> +			 array_index_nospec((unsigned long)(addr - node->start),
> +					    node->size));
>  		s +=3D size;
>  		addr +=3D size;
>  		++ret;
>
>

  CC [M]  drivers/vhost/vhost.o
In file included from /build/linux-5.2/include/linux/export.h:45,
                 from /build/linux-5.2/include/linux/linkage.h:7,
                 from /build/linux-5.2/include/linux/kernel.h:8,
                 from /build/linux-5.2/include/linux/list.h:9,
                 from /build/linux-5.2/include/linux/wait.h:7,
                 from /build/linux-5.2/include/linux/eventfd.h:13,
                 from /build/linux-5.2/drivers/vhost/vhost.c:13:
/build/linux-5.2/drivers/vhost/vhost.c: In function 'translate_desc':
/build/linux-5.2/include/linux/compiler.h:345:38: error: call to '__compil=
etime_assert_1970' declared with attribute error: BUILD_BUG_ON failed: siz=
eof(_s) > sizeof(long)
  345 |  _compiletime_assert(condition, msg, __compiletime_assert_, __LINE=
__)
      |                                      ^
/build/linux-5.2/include/linux/compiler.h:326:4: note: in definition of ma=
cro '__compiletime_assert'
  326 |    prefix ## suffix();    \
      |    ^~~~~~
/build/linux-5.2/include/linux/compiler.h:345:2: note: in expansion of mac=
ro '_compiletime_assert'
  345 |  _compiletime_assert(condition, msg, __compiletime_assert_, __LINE=
__)
      |  ^~~~~~~~~~~~~~~~~~~
/build/linux-5.2/include/linux/build_bug.h:39:37: note: in expansion of ma=
cro 'compiletime_assert'
   39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), ms=
g)
      |                                     ^~~~~~~~~~~~~~~~~~
/build/linux-5.2/include/linux/build_bug.h:50:2: note: in expansion of mac=
ro 'BUILD_BUG_ON_MSG'
   50 |  BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
      |  ^~~~~~~~~~~~~~~~
/build/linux-5.2/include/linux/nospec.h:56:2: note: in expansion of macro =
'BUILD_BUG_ON'
   56 |  BUILD_BUG_ON(sizeof(_s) > sizeof(long));   \
      |  ^~~~~~~~~~~~
/build/linux-5.2/drivers/vhost/vhost.c:1970:5: note: in expansion of macro=
 'array_index_nospec'
 1970 |     array_index_nospec((unsigned long)(addr - node->start),
      |     ^~~~~~~~~~~~~~~~~~
make[3]: *** [/build/linux-5.2/scripts/Makefile.build:285: drivers/vhost/v=
host.o] Error 1
make[2]: *** [/build/linux-5.2/scripts/Makefile.build:489: drivers/vhost] =
Error 2
make[1]: *** [/build/linux-5.2/Makefile:1072: drivers] Error 2
make: *** [/build/linux-5.2/Makefile:179: sub-make] Error 2

Regards
	Stefan Lippers-Hollmann
