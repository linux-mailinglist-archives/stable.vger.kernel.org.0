Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3A312474E4
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392210AbgHQTQw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:16:52 -0400
Received: from mout.gmx.net ([212.227.17.20]:51287 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392120AbgHQTQh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 15:16:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1597691793;
        bh=MCPNhXCMT/9qfTsvH9DI04DUiW1GX0YJfRvbQGJyJ9c=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=I6FhE/kAmOrO6yNpk2noNyFM7o7Tby/ShAgF8pTa/UDGPtDY/ff3W6ZID1dgMhB9n
         d149Wap5KsAhpmRgFKEvZrD1x4aJ/e+iN5gIZ75BdA1311aoknzLzyWvriTmVQB13J
         AUCVKs6cCuOtTj1hnNAl2XmzUsGBe75yMutmFJoA=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.43.192] ([80.187.101.156]) by mail.gmx.com (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N49lJ-1kpqlM1JyL-01038R; Mon, 17
 Aug 2020 21:16:33 +0200
Subject: Re: WTF: patch "[PATCH] parisc: Whitespace cleanups in atomic.h" was
 seriously submitted to be applied to the 5.8-stable tree?
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org
References: <159766809925341@kroah.com>
From:   Helge Deller <deller@gmx.de>
Autocrypt: addr=deller@gmx.de; keydata=
 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
 c2TFWAS8k6RLkk41ZUU8ENX8+qZx/Q==
Message-ID: <63893f78-a2d9-4268-8e4f-004b64921281@gmx.de>
Date:   Mon, 17 Aug 2020 21:16:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <159766809925341@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:lCsXQWUGUq29SbBHWJ/CXHiAi6tXd4xt/m2vz9f04tZKcSNmCKO
 O1HaZAp8+xLt8QBVVcQqum+tVN9Up/YrF16CTs3Y/0IpFyvC451G4diuDp1JysArWlxOffF
 hSlXyE5W2k/bO3eEAsP6M9mwNh3yJ5cBHZk9EICMi/lczUizMObfPNu+xddfmaJJim5JC0m
 t8m61HnVlYDFMLSjsbEHA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:uYV8OIiACRU=:4oyKjYHpPfLS+akmk8xU7W
 GWdwzhTwRfqESgVTNXXYcXeyE/xvf0fksbsFHLpY0xj1LnhgSyXFOWF/Ld+7Tw93cPacHJk3s
 iBR77xR7h3gESPZP7IojYu0P56lp7nfXuyxvDVC3OL5lxVz+SidwvL9STJkW0Txu6AkwqnTRE
 SVkMhriagYGfz46wxus+Iy/sG7Z67PzY/f1aP1iv3t3RyR+hUd1WlNGeieLpK8VqNHCMYBdLm
 gY5q6lhqTjMY6dIfjvOSaUFXo0bR2VZkxM6tzVTrwAPaBcwQ4ULo5EveKD1xqXIIQzAjgvSxR
 snzGshQzZTCAiMETQZy523Zj/P+3eOe1aRV6cmMuZTOIyFg0h2LU7RHiHe+6Z9iztERvTJG4M
 H67SjJgCshMgi4lw7wJOYMtmoryZJi90645yaAcEqO4CipRJIl2xRRoyQzh5PZGlidNWe5hOW
 etfG+FSUNxjRFTPIZBORN8abjRm0sdapZ72K8bdkYtrtO9Ac5b/EkMmsfI1tEz1xrnK/myaC1
 pT6HhbMXSBTMWk+FLtqWtP4ktNnvckDQzlde6KaDnL7bQ4KQkxohJHOxZ6HIwNc8MQ7wYf/wd
 GZ8s/4tEw7vYClJAT7Xzpc3nmRcCgp3gA9nntly4B14BLjJDE72jq3BjAWY+yTS939KFMRHBm
 +vvgQ3jEP4mhKaWKKwDCuf7T61MgrxnkxPGB8rTjjTvKZnriad2RbXKyZ7O8Et0JhSNDi7bl0
 7IRaolFcyg8Zzm5mx6CRUmVMdmDNSU+E2ZvWxSGDr2OhAWANiQyyUVKJd9cCS740fqjWIRHZJ
 aa0hWlWd/1lBZDe2ZBRrYDwDiFYnKsYMM8j2bZDi1UuJJd4k27qoP/NUubUPuRXcewf/SIZsg
 XTRbGWcvtDASsnKPghrZDlO2cb/Np0gMpNXEJHcUdTVPXGz/3sPYyoYdsBhRlvc2bivRZpzO2
 fEvfHFBgEyi8QWzFHM68lmybWJxXT8qQKdlyC1swJNfhFwC53e3n9X8/6Uto5swC0BQi8QqE2
 f566j5To2ejqJM77UDGmag+sNdHa+KT/0ch5RH/5P+KLVTF4z0iyw9rkT6/inOSxc7IlvlOpZ
 cQnENjRKGDZujPWkE52AF8eqoU3Hbcz7L4GV+4l9VWx2dVtA1OsDWb7naIC2SYZ7QBeCTGl1X
 J+E1LhXLQhY/1RD0y8uMgngSxUFSM2ZtXLBW4o0rRW9w71Sv43H8/o2fIpH03961gfhN14E5g
 mHpGY1XMi1UY6qbdU
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 17.08.20 14:41, gregkh@linuxfoundation.org wrote:
> The patch below was submitted to be applied to the 5.8-stable tree.
>
> I fail to see how this patch meets the stable kernel rules as found at
> Documentation/process/stable-kernel-rules.rst.
>
> I could be totally wrong, and if so, please respond to
> <stable@vger.kernel.org> and let me know why this patch should be
> applied.  Otherwise, it is now dropped from my patch queues, never to be
> seen again.

I tagged it for stable series, because often when successing patches
come in, I sometimes need to trigger a backport of such small prior cleanu=
p patches.
But your are right, for now it's ok to drop it.

Thank you!
Helge

> thanks,
>
> greg k-h
>
> ------------------ original commit in Linus's tree ------------------
>
> From 3bc6e3dc5a54d5842938c6f1ed78dd1add379af7 Mon Sep 17 00:00:00 2001
> From: Helge Deller <deller@gmx.de>
> Date: Sun, 14 Jun 2020 10:50:42 +0200
> Subject: [PATCH] parisc: Whitespace cleanups in atomic.h
>
> Fix whitespace indenting and drop trailing backslashes.
>
> Cc: <stable@vger.kernel.org> # 4.19+
> Signed-off-by: Helge Deller <deller@gmx.de>
>
> diff --git a/arch/parisc/include/asm/atomic.h b/arch/parisc/include/asm/=
atomic.h
> index 6dd4171c9530..90e8267fc509 100644
> --- a/arch/parisc/include/asm/atomic.h
> +++ b/arch/parisc/include/asm/atomic.h
> @@ -34,13 +34,13 @@ extern arch_spinlock_t __atomic_hash[ATOMIC_HASH_SIZ=
E] __lock_aligned;
>  /* Can't use raw_spin_lock_irq because of #include problems, so
>   * this is the substitute */
>  #define _atomic_spin_lock_irqsave(l,f) do {	\
> -	arch_spinlock_t *s =3D ATOMIC_HASH(l);		\
> +	arch_spinlock_t *s =3D ATOMIC_HASH(l);	\
>  	local_irq_save(f);			\
>  	arch_spin_lock(s);			\
>  } while(0)
>
>  #define _atomic_spin_unlock_irqrestore(l,f) do {	\
> -	arch_spinlock_t *s =3D ATOMIC_HASH(l);			\
> +	arch_spinlock_t *s =3D ATOMIC_HASH(l);		\
>  	arch_spin_unlock(s);				\
>  	local_irq_restore(f);				\
>  } while(0)
> @@ -85,7 +85,7 @@ static __inline__ void atomic_##op(int i, atomic_t *v)=
			\
>  	_atomic_spin_lock_irqsave(v, flags);				\
>  	v->counter c_op i;						\
>  	_atomic_spin_unlock_irqrestore(v, flags);			\
> -}									\
> +}
>
>  #define ATOMIC_OP_RETURN(op, c_op)					\
>  static __inline__ int atomic_##op##_return(int i, atomic_t *v)		\
> @@ -150,7 +150,7 @@ static __inline__ void atomic64_##op(s64 i, atomic64=
_t *v)		\
>  	_atomic_spin_lock_irqsave(v, flags);				\
>  	v->counter c_op i;						\
>  	_atomic_spin_unlock_irqrestore(v, flags);			\
> -}									\
> +}
>
>  #define ATOMIC64_OP_RETURN(op, c_op)					\
>  static __inline__ s64 atomic64_##op##_return(s64 i, atomic64_t *v)	\
>

