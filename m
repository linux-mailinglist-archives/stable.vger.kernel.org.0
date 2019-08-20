Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7718196C02
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 00:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730501AbfHTWMS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 18:12:18 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37647 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729887AbfHTWMS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Aug 2019 18:12:18 -0400
Received: by mail-pg1-f194.google.com with SMTP id d1so95784pgp.4;
        Tue, 20 Aug 2019 15:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=uXuEikk2bl/gHYHd04+mLMglq90CJII5QImF4dXxhoQ=;
        b=Q37foNAR9r2wZKaZmfrLGnfh1iBrplQD1xGiCtf2w2ZEa1cIPJmV4C+npy6fnJbsW0
         0xuQDurgPC4FDfqXLXkd97NY0m9GBZCT87hNFrmMZAM6zHMsXDy0senwxOhdKoGvDjcJ
         iWl2mPo/ncDeC+5SrOSFSH68EEoEDoHW0sddTTwrWFmj1ZZN5Bz8qYahkIb20NRfrCgT
         +os/5R7OlIn0HEJpOXKgl8BLOsvbAqQUYq112ZSMrqayNmniOzRanxui61v1hO/Tf76y
         b7+tiIUbySRP5Kx7RgDNvvqQkDQruGBqrSnk3e7Blbyn6zO+01bI8/2drywptxkwOR3b
         Lqzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=uXuEikk2bl/gHYHd04+mLMglq90CJII5QImF4dXxhoQ=;
        b=r1XNjorypDfZWl8TMJYYDufpfjgrMGbnVTZXcF9VdATNmUaQRAJtSf1YnFYiDQosOo
         HVjgO0SVkSfQYjt2OQRiC7VR8u+zHYEXAJqXBTuZqSuM/kkzKwYDDdejq09l0yN5RH7j
         8+G43oHcoSqMJcRNUdSpdBa3DD6ocoAy30aWe2UICVYtEOUIJqXlktHXp7n+H/mQFT4P
         nVBt1y12y27AUcYRCeXQxgt6Vr0yaYqWksJVEbjkoZZ6adAay6TUjEN2erY0trldkLYn
         GsnG3+czhM983IaLqEK5CRKHBNjXeG5CRuQO6beWRLkFoB4k4WoWHXpPnb6BNLRlfp9W
         2SEA==
X-Gm-Message-State: APjAAAXjEoi3FDpW646NljmyvZOja4g1UgTfSw/5d9B/YKlaYogY2GfT
        6LVadxpbA/+qQPW+l+TKZRT5iBbUWE0=
X-Google-Smtp-Source: APXvYqxuWd3gpjEvjRb8ovo6j8k48SMfjmaVe6BzSCNAeN6CQCNuWlv3zh2R2IDDcgCfOthrlmoTmA==
X-Received: by 2002:aa7:8e10:: with SMTP id c16mr31634806pfr.124.1566339136789;
        Tue, 20 Aug 2019 15:12:16 -0700 (PDT)
Received: from UbuntuLinux ([103.231.91.70])
        by smtp.gmail.com with ESMTPSA id v8sm983123pjb.6.2019.08.20.15.12.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 15:12:15 -0700 (PDT)
Date:   Wed, 21 Aug 2019 03:42:01 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org, lwn@lwn.net
Subject: Re: Linux 3.16.73
Message-ID: <20190820221158.GA3703@UbuntuLinux>
References: <1b7bc6b9a90895643d70abab85310effe941766c.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
In-Reply-To: <1b7bc6b9a90895643d70abab85310effe941766c.camel@decadent.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Thanks, a bunch Ben. :)

On 22:52 Tue 20 Aug 2019, Ben Hutchings wrote:
>I'm announcing the release of the 3.16.73 kernel.
>
>All users of the 3.16 kernel series should upgrade.
>
>The updated 3.16.y git tree can be found at:
>        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git linux-3.16.y
>and can be browsed at the normal kernel.org git web browser:
>        https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.g=
it
>
>The diff from 3.16.72 is attached to this message.
>
>Ben.
>
>------------
>
> Documentation/siphash.txt |  75 +++++++++++
> Makefile                  |   2 +-
> fs/ext4/indirect.c        |  43 ++++---
> include/linux/siphash.h   |  57 +++++++-
> include/net/tcp.h         |   3 +
> lib/siphash.c             | 321 +++++++++++++++++++++++++++++++++++++++++=
++++-
> lib/test_siphash.c        |  98 +++++++++++++-
> 7 files changed, 572 insertions(+), 27 deletions(-)
>
>Ben Hutchings (2):
>      tcp: Clear sk_send_head after purging the write queue
>      Linux 3.16.73
>
>Jason A. Donenfeld (1):
>      siphash: implement HalfSipHash1-3 for hash tables
>
>zhangyi (F) (2):
>      ext4: brelse all indirect buffer in ext4_ind_remove_space()
>      ext4: cleanup bh release code in ext4_ind_remove_space()
>
>--=20
>Ben Hutchings
>Experience is what causes a person to make new mistakes
>instead of old ones.
>
>

>diff --git a/Documentation/siphash.txt b/Documentation/siphash.txt
>index e8e6ddbbaab4..908d348ff777 100644
>--- a/Documentation/siphash.txt
>+++ b/Documentation/siphash.txt
>@@ -98,3 +98,78 @@ u64 h =3D siphash(&combined, offsetofend(typeof(combine=
d), dport), &secret);
>=20
> Read the SipHash paper if you're interested in learning more:
> https://131002.net/siphash/siphash.pdf
>+
>+
>+~=3D~=3D~=3D~=3D~=3D~=3D~=3D~=3D~=3D~=3D~=3D~=3D~=3D~=3D~=3D~=3D~=3D~=3D~=
=3D~=3D~=3D~=3D~=3D~=3D~=3D~=3D~=3D~=3D~=3D~=3D~=3D~=3D~=3D~=3D~
>+
>+HalfSipHash - SipHash's insecure younger cousin
>+-----------------------------------------------
>+Written by Jason A. Donenfeld <jason@zx2c4.com>
>+
>+On the off-chance that SipHash is not fast enough for your needs, you mig=
ht be
>+able to justify using HalfSipHash, a terrifying but potentially useful
>+possibility. HalfSipHash cuts SipHash's rounds down from "2-4" to "1-3" a=
nd,
>+even scarier, uses an easily brute-forcable 64-bit key (with a 32-bit out=
put)
>+instead of SipHash's 128-bit key. However, this may appeal to some
>+high-performance `jhash` users.
>+
>+Danger!
>+
>+Do not ever use HalfSipHash except for as a hashtable key function, and o=
nly
>+then when you can be absolutely certain that the outputs will never be
>+transmitted out of the kernel. This is only remotely useful over `jhash` =
as a
>+means of mitigating hashtable flooding denial of service attacks.
>+
>+1. Generating a key
>+
>+Keys should always be generated from a cryptographically secure source of
>+random numbers, either using get_random_bytes or get_random_once:
>+
>+hsiphash_key_t key;
>+get_random_bytes(&key, sizeof(key));
>+
>+If you're not deriving your key from here, you're doing it wrong.
>+
>+2. Using the functions
>+
>+There are two variants of the function, one that takes a list of integers=
, and
>+one that takes a buffer:
>+
>+u32 hsiphash(const void *data, size_t len, const hsiphash_key_t *key);
>+
>+And:
>+
>+u32 hsiphash_1u32(u32, const hsiphash_key_t *key);
>+u32 hsiphash_2u32(u32, u32, const hsiphash_key_t *key);
>+u32 hsiphash_3u32(u32, u32, u32, const hsiphash_key_t *key);
>+u32 hsiphash_4u32(u32, u32, u32, u32, const hsiphash_key_t *key);
>+
>+If you pass the generic hsiphash function something of a constant length,=
 it
>+will constant fold at compile-time and automatically choose one of the
>+optimized functions.
>+
>+3. Hashtable key function usage:
>+
>+struct some_hashtable {
>+	DECLARE_HASHTABLE(hashtable, 8);
>+	hsiphash_key_t key;
>+};
>+
>+void init_hashtable(struct some_hashtable *table)
>+{
>+	get_random_bytes(&table->key, sizeof(table->key));
>+}
>+
>+static inline hlist_head *some_hashtable_bucket(struct some_hashtable *ta=
ble, struct interesting_input *input)
>+{
>+	return &table->hashtable[hsiphash(input, sizeof(*input), &table->key) & =
(HASH_SIZE(table->hashtable) - 1)];
>+}
>+
>+You may then iterate like usual over the returned hash bucket.
>+
>+4. Performance
>+
>+HalfSipHash is roughly 3 times slower than JenkinsHash. For many replacem=
ents,
>+this will not be a problem, as the hashtable lookup isn't the bottleneck.=
 And
>+in general, this is probably a good sacrifice to make for the security an=
d DoS
>+resistance of HalfSipHash.
>diff --git a/Makefile b/Makefile
>index e2d6e0b9f22d..935fc9df7b17 100644
>--- a/Makefile
>+++ b/Makefile
>@@ -1,6 +1,6 @@
> VERSION =3D 3
> PATCHLEVEL =3D 16
>-SUBLEVEL =3D 72
>+SUBLEVEL =3D 73
> EXTRAVERSION =3D
> NAME =3D Museum of Fishiegoodies
>=20
>diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
>index 8df46f49a3d5..475a1d40f23e 100644
>--- a/fs/ext4/indirect.c
>+++ b/fs/ext4/indirect.c
>@@ -1313,6 +1313,7 @@ int ext4_ind_remove_space(handle_t *handle, struct i=
node *inode,
> 	ext4_lblk_t offsets[4], offsets2[4];
> 	Indirect chain[4], chain2[4];
> 	Indirect *partial, *partial2;
>+	Indirect *p =3D NULL, *p2 =3D NULL;
> 	ext4_lblk_t max_block;
> 	__le32 nr =3D 0, nr2 =3D 0;
> 	int n =3D 0, n2 =3D 0;
>@@ -1354,7 +1355,7 @@ int ext4_ind_remove_space(handle_t *handle, struct i=
node *inode,
> 		}
>=20
>=20
>-		partial =3D ext4_find_shared(inode, n, offsets, chain, &nr);
>+		partial =3D p =3D ext4_find_shared(inode, n, offsets, chain, &nr);
> 		if (nr) {
> 			if (partial =3D=3D chain) {
> 				/* Shared branch grows from the inode */
>@@ -1379,13 +1380,11 @@ int ext4_ind_remove_space(handle_t *handle, struct=
 inode *inode,
> 				partial->p + 1,
> 				(__le32 *)partial->bh->b_data+addr_per_block,
> 				(chain+n-1) - partial);
>-			BUFFER_TRACE(partial->bh, "call brelse");
>-			brelse(partial->bh);
> 			partial--;
> 		}
>=20
> end_range:
>-		partial2 =3D ext4_find_shared(inode, n2, offsets2, chain2, &nr2);
>+		partial2 =3D p2 =3D ext4_find_shared(inode, n2, offsets2, chain2, &nr2);
> 		if (nr2) {
> 			if (partial2 =3D=3D chain2) {
> 				/*
>@@ -1415,16 +1414,14 @@ int ext4_ind_remove_space(handle_t *handle, struct=
 inode *inode,
> 					   (__le32 *)partial2->bh->b_data,
> 					   partial2->p,
> 					   (chain2+n2-1) - partial2);
>-			BUFFER_TRACE(partial2->bh, "call brelse");
>-			brelse(partial2->bh);
> 			partial2--;
> 		}
> 		goto do_indirects;
> 	}
>=20
> 	/* Punch happened within the same level (n =3D=3D n2) */
>-	partial =3D ext4_find_shared(inode, n, offsets, chain, &nr);
>-	partial2 =3D ext4_find_shared(inode, n2, offsets2, chain2, &nr2);
>+	partial =3D p =3D ext4_find_shared(inode, n, offsets, chain, &nr);
>+	partial2 =3D p2 =3D ext4_find_shared(inode, n2, offsets2, chain2, &nr2);
>=20
> 	/* Free top, but only if partial2 isn't its subtree. */
> 	if (nr) {
>@@ -1481,11 +1478,7 @@ int ext4_ind_remove_space(handle_t *handle, struct =
inode *inode,
> 					   partial->p + 1,
> 					   partial2->p,
> 					   (chain+n-1) - partial);
>-			BUFFER_TRACE(partial->bh, "call brelse");
>-			brelse(partial->bh);
>-			BUFFER_TRACE(partial2->bh, "call brelse");
>-			brelse(partial2->bh);
>-			return 0;
>+			goto cleanup;
> 		}
>=20
> 		/*
>@@ -1500,8 +1493,6 @@ int ext4_ind_remove_space(handle_t *handle, struct i=
node *inode,
> 					   partial->p + 1,
> 					   (__le32 *)partial->bh->b_data+addr_per_block,
> 					   (chain+n-1) - partial);
>-			BUFFER_TRACE(partial->bh, "call brelse");
>-			brelse(partial->bh);
> 			partial--;
> 		}
> 		if (partial2 > chain2 && depth2 <=3D depth) {
>@@ -1509,11 +1500,21 @@ int ext4_ind_remove_space(handle_t *handle, struct=
 inode *inode,
> 					   (__le32 *)partial2->bh->b_data,
> 					   partial2->p,
> 					   (chain2+n2-1) - partial2);
>-			BUFFER_TRACE(partial2->bh, "call brelse");
>-			brelse(partial2->bh);
> 			partial2--;
> 		}
> 	}
>+
>+cleanup:
>+	while (p && p > chain) {
>+		BUFFER_TRACE(p->bh, "call brelse");
>+		brelse(p->bh);
>+		p--;
>+	}
>+	while (p2 && p2 > chain2) {
>+		BUFFER_TRACE(p2->bh, "call brelse");
>+		brelse(p2->bh);
>+		p2--;
>+	}
> 	return 0;
>=20
> do_indirects:
>@@ -1521,7 +1522,7 @@ int ext4_ind_remove_space(handle_t *handle, struct i=
node *inode,
> 	switch (offsets[0]) {
> 	default:
> 		if (++n >=3D n2)
>-			return 0;
>+			break;
> 		nr =3D i_data[EXT4_IND_BLOCK];
> 		if (nr) {
> 			ext4_free_branches(handle, inode, NULL, &nr, &nr+1, 1);
>@@ -1529,7 +1530,7 @@ int ext4_ind_remove_space(handle_t *handle, struct i=
node *inode,
> 		}
> 	case EXT4_IND_BLOCK:
> 		if (++n >=3D n2)
>-			return 0;
>+			break;
> 		nr =3D i_data[EXT4_DIND_BLOCK];
> 		if (nr) {
> 			ext4_free_branches(handle, inode, NULL, &nr, &nr+1, 2);
>@@ -1537,7 +1538,7 @@ int ext4_ind_remove_space(handle_t *handle, struct i=
node *inode,
> 		}
> 	case EXT4_DIND_BLOCK:
> 		if (++n >=3D n2)
>-			return 0;
>+			break;
> 		nr =3D i_data[EXT4_TIND_BLOCK];
> 		if (nr) {
> 			ext4_free_branches(handle, inode, NULL, &nr, &nr+1, 3);
>@@ -1546,5 +1547,5 @@ int ext4_ind_remove_space(handle_t *handle, struct i=
node *inode,
> 	case EXT4_TIND_BLOCK:
> 		;
> 	}
>-	return 0;
>+	goto cleanup;
> }
>diff --git a/include/linux/siphash.h b/include/linux/siphash.h
>index c8c7ae2e687b..bf21591a9e5e 100644
>--- a/include/linux/siphash.h
>+++ b/include/linux/siphash.h
>@@ -5,7 +5,9 @@
>  * SipHash: a fast short-input PRF
>  * https://131002.net/siphash/
>  *
>- * This implementation is specifically for SipHash2-4.
>+ * This implementation is specifically for SipHash2-4 for a secure PRF
>+ * and HalfSipHash1-3/SipHash1-3 for an insecure PRF only suitable for
>+ * hashtables.
>  */
>=20
> #ifndef _LINUX_SIPHASH_H
>@@ -87,4 +89,57 @@ static inline u64 siphash(const void *data, size_t len,
> 	return ___siphash_aligned(data, len, key);
> }
>=20
>+#define HSIPHASH_ALIGNMENT __alignof__(unsigned long)
>+typedef struct {
>+	unsigned long key[2];
>+} hsiphash_key_t;
>+
>+u32 __hsiphash_aligned(const void *data, size_t len,
>+		       const hsiphash_key_t *key);
>+#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
>+u32 __hsiphash_unaligned(const void *data, size_t len,
>+			 const hsiphash_key_t *key);
>+#endif
>+
>+u32 hsiphash_1u32(const u32 a, const hsiphash_key_t *key);
>+u32 hsiphash_2u32(const u32 a, const u32 b, const hsiphash_key_t *key);
>+u32 hsiphash_3u32(const u32 a, const u32 b, const u32 c,
>+		  const hsiphash_key_t *key);
>+u32 hsiphash_4u32(const u32 a, const u32 b, const u32 c, const u32 d,
>+		  const hsiphash_key_t *key);
>+
>+static inline u32 ___hsiphash_aligned(const __le32 *data, size_t len,
>+				      const hsiphash_key_t *key)
>+{
>+	if (__builtin_constant_p(len) && len =3D=3D 4)
>+		return hsiphash_1u32(le32_to_cpu(data[0]), key);
>+	if (__builtin_constant_p(len) && len =3D=3D 8)
>+		return hsiphash_2u32(le32_to_cpu(data[0]), le32_to_cpu(data[1]),
>+				     key);
>+	if (__builtin_constant_p(len) && len =3D=3D 12)
>+		return hsiphash_3u32(le32_to_cpu(data[0]), le32_to_cpu(data[1]),
>+				     le32_to_cpu(data[2]), key);
>+	if (__builtin_constant_p(len) && len =3D=3D 16)
>+		return hsiphash_4u32(le32_to_cpu(data[0]), le32_to_cpu(data[1]),
>+				     le32_to_cpu(data[2]), le32_to_cpu(data[3]),
>+				     key);
>+	return __hsiphash_aligned(data, len, key);
>+}
>+
>+/**
>+ * hsiphash - compute 32-bit hsiphash PRF value
>+ * @data: buffer to hash
>+ * @size: size of @data
>+ * @key: the hsiphash key
>+ */
>+static inline u32 hsiphash(const void *data, size_t len,
>+			   const hsiphash_key_t *key)
>+{
>+#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
>+	if (!IS_ALIGNED((unsigned long)data, HSIPHASH_ALIGNMENT))
>+		return __hsiphash_unaligned(data, len, key);
>+#endif
>+	return ___hsiphash_aligned(data, len, key);
>+}
>+
> #endif /* _LINUX_SIPHASH_H */
>diff --git a/include/net/tcp.h b/include/net/tcp.h
>index 79762b662de3..7667c9adc92a 100644
>--- a/include/net/tcp.h
>+++ b/include/net/tcp.h
>@@ -1352,6 +1352,8 @@ struct tcp_fastopen_context {
> 	struct rcu_head		rcu;
> };
>=20
>+static inline void tcp_init_send_head(struct sock *sk);
>+
> /* write queue abstraction */
> static inline void tcp_write_queue_purge(struct sock *sk)
> {
>@@ -1359,6 +1361,7 @@ static inline void tcp_write_queue_purge(struct sock=
 *sk)
>=20
> 	while ((skb =3D __skb_dequeue(&sk->sk_write_queue)) !=3D NULL)
> 		sk_wmem_free_skb(sk, skb);
>+	tcp_init_send_head(sk);
> 	sk_mem_reclaim(sk);
> 	tcp_clear_all_retrans_hints(tcp_sk(sk));
> }
>diff --git a/lib/siphash.c b/lib/siphash.c
>index c43cf406e71b..3ae58b4edad6 100644
>--- a/lib/siphash.c
>+++ b/lib/siphash.c
>@@ -5,7 +5,9 @@
>  * SipHash: a fast short-input PRF
>  * https://131002.net/siphash/
>  *
>- * This implementation is specifically for SipHash2-4.
>+ * This implementation is specifically for SipHash2-4 for a secure PRF
>+ * and HalfSipHash1-3/SipHash1-3 for an insecure PRF only suitable for
>+ * hashtables.
>  */
>=20
> #include <linux/siphash.h>
>@@ -230,3 +232,320 @@ u64 siphash_3u32(const u32 first, const u32 second, =
const u32 third,
> 	POSTAMBLE
> }
> EXPORT_SYMBOL(siphash_3u32);
>+
>+#if BITS_PER_LONG =3D=3D 64
>+/* Note that on 64-bit, we make HalfSipHash1-3 actually be SipHash1-3, for
>+ * performance reasons. On 32-bit, below, we actually implement HalfSipHa=
sh1-3.
>+ */
>+
>+#define HSIPROUND SIPROUND
>+#define HPREAMBLE(len) PREAMBLE(len)
>+#define HPOSTAMBLE \
>+	v3 ^=3D b; \
>+	HSIPROUND; \
>+	v0 ^=3D b; \
>+	v2 ^=3D 0xff; \
>+	HSIPROUND; \
>+	HSIPROUND; \
>+	HSIPROUND; \
>+	return (v0 ^ v1) ^ (v2 ^ v3);
>+
>+u32 __hsiphash_aligned(const void *data, size_t len, const hsiphash_key_t=
 *key)
>+{
>+	const u8 *end =3D data + len - (len % sizeof(u64));
>+	const u8 left =3D len & (sizeof(u64) - 1);
>+	u64 m;
>+	HPREAMBLE(len)
>+	for (; data !=3D end; data +=3D sizeof(u64)) {
>+		m =3D le64_to_cpup(data);
>+		v3 ^=3D m;
>+		HSIPROUND;
>+		v0 ^=3D m;
>+	}
>+#if defined(CONFIG_DCACHE_WORD_ACCESS) && BITS_PER_LONG =3D=3D 64
>+	if (left)
>+		b |=3D le64_to_cpu((__force __le64)(load_unaligned_zeropad(data) &
>+						  bytemask_from_count(left)));
>+#else
>+	switch (left) {
>+	case 7: b |=3D ((u64)end[6]) << 48;
>+	case 6: b |=3D ((u64)end[5]) << 40;
>+	case 5: b |=3D ((u64)end[4]) << 32;
>+	case 4: b |=3D le32_to_cpup(data); break;
>+	case 3: b |=3D ((u64)end[2]) << 16;
>+	case 2: b |=3D le16_to_cpup(data); break;
>+	case 1: b |=3D end[0];
>+	}
>+#endif
>+	HPOSTAMBLE
>+}
>+EXPORT_SYMBOL(__hsiphash_aligned);
>+
>+#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
>+u32 __hsiphash_unaligned(const void *data, size_t len,
>+			 const hsiphash_key_t *key)
>+{
>+	const u8 *end =3D data + len - (len % sizeof(u64));
>+	const u8 left =3D len & (sizeof(u64) - 1);
>+	u64 m;
>+	HPREAMBLE(len)
>+	for (; data !=3D end; data +=3D sizeof(u64)) {
>+		m =3D get_unaligned_le64(data);
>+		v3 ^=3D m;
>+		HSIPROUND;
>+		v0 ^=3D m;
>+	}
>+#if defined(CONFIG_DCACHE_WORD_ACCESS) && BITS_PER_LONG =3D=3D 64
>+	if (left)
>+		b |=3D le64_to_cpu((__force __le64)(load_unaligned_zeropad(data) &
>+						  bytemask_from_count(left)));
>+#else
>+	switch (left) {
>+	case 7: b |=3D ((u64)end[6]) << 48;
>+	case 6: b |=3D ((u64)end[5]) << 40;
>+	case 5: b |=3D ((u64)end[4]) << 32;
>+	case 4: b |=3D get_unaligned_le32(end); break;
>+	case 3: b |=3D ((u64)end[2]) << 16;
>+	case 2: b |=3D get_unaligned_le16(end); break;
>+	case 1: b |=3D end[0];
>+	}
>+#endif
>+	HPOSTAMBLE
>+}
>+EXPORT_SYMBOL(__hsiphash_unaligned);
>+#endif
>+
>+/**
>+ * hsiphash_1u32 - compute 64-bit hsiphash PRF value of a u32
>+ * @first: first u32
>+ * @key: the hsiphash key
>+ */
>+u32 hsiphash_1u32(const u32 first, const hsiphash_key_t *key)
>+{
>+	HPREAMBLE(4)
>+	b |=3D first;
>+	HPOSTAMBLE
>+}
>+EXPORT_SYMBOL(hsiphash_1u32);
>+
>+/**
>+ * hsiphash_2u32 - compute 32-bit hsiphash PRF value of 2 u32
>+ * @first: first u32
>+ * @second: second u32
>+ * @key: the hsiphash key
>+ */
>+u32 hsiphash_2u32(const u32 first, const u32 second, const hsiphash_key_t=
 *key)
>+{
>+	u64 combined =3D (u64)second << 32 | first;
>+	HPREAMBLE(8)
>+	v3 ^=3D combined;
>+	HSIPROUND;
>+	v0 ^=3D combined;
>+	HPOSTAMBLE
>+}
>+EXPORT_SYMBOL(hsiphash_2u32);
>+
>+/**
>+ * hsiphash_3u32 - compute 32-bit hsiphash PRF value of 3 u32
>+ * @first: first u32
>+ * @second: second u32
>+ * @third: third u32
>+ * @key: the hsiphash key
>+ */
>+u32 hsiphash_3u32(const u32 first, const u32 second, const u32 third,
>+		  const hsiphash_key_t *key)
>+{
>+	u64 combined =3D (u64)second << 32 | first;
>+	HPREAMBLE(12)
>+	v3 ^=3D combined;
>+	HSIPROUND;
>+	v0 ^=3D combined;
>+	b |=3D third;
>+	HPOSTAMBLE
>+}
>+EXPORT_SYMBOL(hsiphash_3u32);
>+
>+/**
>+ * hsiphash_4u32 - compute 32-bit hsiphash PRF value of 4 u32
>+ * @first: first u32
>+ * @second: second u32
>+ * @third: third u32
>+ * @forth: forth u32
>+ * @key: the hsiphash key
>+ */
>+u32 hsiphash_4u32(const u32 first, const u32 second, const u32 third,
>+		  const u32 forth, const hsiphash_key_t *key)
>+{
>+	u64 combined =3D (u64)second << 32 | first;
>+	HPREAMBLE(16)
>+	v3 ^=3D combined;
>+	HSIPROUND;
>+	v0 ^=3D combined;
>+	combined =3D (u64)forth << 32 | third;
>+	v3 ^=3D combined;
>+	HSIPROUND;
>+	v0 ^=3D combined;
>+	HPOSTAMBLE
>+}
>+EXPORT_SYMBOL(hsiphash_4u32);
>+#else
>+#define HSIPROUND \
>+	do { \
>+	v0 +=3D v1; v1 =3D rol32(v1, 5); v1 ^=3D v0; v0 =3D rol32(v0, 16); \
>+	v2 +=3D v3; v3 =3D rol32(v3, 8); v3 ^=3D v2; \
>+	v0 +=3D v3; v3 =3D rol32(v3, 7); v3 ^=3D v0; \
>+	v2 +=3D v1; v1 =3D rol32(v1, 13); v1 ^=3D v2; v2 =3D rol32(v2, 16); \
>+	} while (0)
>+
>+#define HPREAMBLE(len) \
>+	u32 v0 =3D 0; \
>+	u32 v1 =3D 0; \
>+	u32 v2 =3D 0x6c796765U; \
>+	u32 v3 =3D 0x74656462U; \
>+	u32 b =3D ((u32)(len)) << 24; \
>+	v3 ^=3D key->key[1]; \
>+	v2 ^=3D key->key[0]; \
>+	v1 ^=3D key->key[1]; \
>+	v0 ^=3D key->key[0];
>+
>+#define HPOSTAMBLE \
>+	v3 ^=3D b; \
>+	HSIPROUND; \
>+	v0 ^=3D b; \
>+	v2 ^=3D 0xff; \
>+	HSIPROUND; \
>+	HSIPROUND; \
>+	HSIPROUND; \
>+	return v1 ^ v3;
>+
>+u32 __hsiphash_aligned(const void *data, size_t len, const hsiphash_key_t=
 *key)
>+{
>+	const u8 *end =3D data + len - (len % sizeof(u32));
>+	const u8 left =3D len & (sizeof(u32) - 1);
>+	u32 m;
>+	HPREAMBLE(len)
>+	for (; data !=3D end; data +=3D sizeof(u32)) {
>+		m =3D le32_to_cpup(data);
>+		v3 ^=3D m;
>+		HSIPROUND;
>+		v0 ^=3D m;
>+	}
>+	switch (left) {
>+	case 3: b |=3D ((u32)end[2]) << 16;
>+	case 2: b |=3D le16_to_cpup(data); break;
>+	case 1: b |=3D end[0];
>+	}
>+	HPOSTAMBLE
>+}
>+EXPORT_SYMBOL(__hsiphash_aligned);
>+
>+#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
>+u32 __hsiphash_unaligned(const void *data, size_t len,
>+			 const hsiphash_key_t *key)
>+{
>+	const u8 *end =3D data + len - (len % sizeof(u32));
>+	const u8 left =3D len & (sizeof(u32) - 1);
>+	u32 m;
>+	HPREAMBLE(len)
>+	for (; data !=3D end; data +=3D sizeof(u32)) {
>+		m =3D get_unaligned_le32(data);
>+		v3 ^=3D m;
>+		HSIPROUND;
>+		v0 ^=3D m;
>+	}
>+	switch (left) {
>+	case 3: b |=3D ((u32)end[2]) << 16;
>+	case 2: b |=3D get_unaligned_le16(end); break;
>+	case 1: b |=3D end[0];
>+	}
>+	HPOSTAMBLE
>+}
>+EXPORT_SYMBOL(__hsiphash_unaligned);
>+#endif
>+
>+/**
>+ * hsiphash_1u32 - compute 32-bit hsiphash PRF value of a u32
>+ * @first: first u32
>+ * @key: the hsiphash key
>+ */
>+u32 hsiphash_1u32(const u32 first, const hsiphash_key_t *key)
>+{
>+	HPREAMBLE(4)
>+	v3 ^=3D first;
>+	HSIPROUND;
>+	v0 ^=3D first;
>+	HPOSTAMBLE
>+}
>+EXPORT_SYMBOL(hsiphash_1u32);
>+
>+/**
>+ * hsiphash_2u32 - compute 32-bit hsiphash PRF value of 2 u32
>+ * @first: first u32
>+ * @second: second u32
>+ * @key: the hsiphash key
>+ */
>+u32 hsiphash_2u32(const u32 first, const u32 second, const hsiphash_key_t=
 *key)
>+{
>+	HPREAMBLE(8)
>+	v3 ^=3D first;
>+	HSIPROUND;
>+	v0 ^=3D first;
>+	v3 ^=3D second;
>+	HSIPROUND;
>+	v0 ^=3D second;
>+	HPOSTAMBLE
>+}
>+EXPORT_SYMBOL(hsiphash_2u32);
>+
>+/**
>+ * hsiphash_3u32 - compute 32-bit hsiphash PRF value of 3 u32
>+ * @first: first u32
>+ * @second: second u32
>+ * @third: third u32
>+ * @key: the hsiphash key
>+ */
>+u32 hsiphash_3u32(const u32 first, const u32 second, const u32 third,
>+		  const hsiphash_key_t *key)
>+{
>+	HPREAMBLE(12)
>+	v3 ^=3D first;
>+	HSIPROUND;
>+	v0 ^=3D first;
>+	v3 ^=3D second;
>+	HSIPROUND;
>+	v0 ^=3D second;
>+	v3 ^=3D third;
>+	HSIPROUND;
>+	v0 ^=3D third;
>+	HPOSTAMBLE
>+}
>+EXPORT_SYMBOL(hsiphash_3u32);
>+
>+/**
>+ * hsiphash_4u32 - compute 32-bit hsiphash PRF value of 4 u32
>+ * @first: first u32
>+ * @second: second u32
>+ * @third: third u32
>+ * @forth: forth u32
>+ * @key: the hsiphash key
>+ */
>+u32 hsiphash_4u32(const u32 first, const u32 second, const u32 third,
>+		  const u32 forth, const hsiphash_key_t *key)
>+{
>+	HPREAMBLE(16)
>+	v3 ^=3D first;
>+	HSIPROUND;
>+	v0 ^=3D first;
>+	v3 ^=3D second;
>+	HSIPROUND;
>+	v0 ^=3D second;
>+	v3 ^=3D third;
>+	HSIPROUND;
>+	v0 ^=3D third;
>+	v3 ^=3D forth;
>+	HSIPROUND;
>+	v0 ^=3D forth;
>+	HPOSTAMBLE
>+}
>+EXPORT_SYMBOL(hsiphash_4u32);
>+#endif
>diff --git a/lib/test_siphash.c b/lib/test_siphash.c
>index d972acfc15e4..a6d854d933bf 100644
>--- a/lib/test_siphash.c
>+++ b/lib/test_siphash.c
>@@ -7,7 +7,9 @@
>  * SipHash: a fast short-input PRF
>  * https://131002.net/siphash/
>  *
>- * This implementation is specifically for SipHash2-4.
>+ * This implementation is specifically for SipHash2-4 for a secure PRF
>+ * and HalfSipHash1-3/SipHash1-3 for an insecure PRF only suitable for
>+ * hashtables.
>  */
>=20
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>@@ -18,8 +20,8 @@
> #include <linux/errno.h>
> #include <linux/module.h>
>=20
>-/* Test vectors taken from official reference source available at:
>- *     https://131002.net/siphash/siphash24.c
>+/* Test vectors taken from reference source available at:
>+ *     https://github.com/veorq/SipHash
>  */
>=20
> static const siphash_key_t test_key_siphash =3D
>@@ -50,6 +52,64 @@ static const u64 test_vectors_siphash[64] =3D {
> 	0x958a324ceb064572ULL
> };
>=20
>+#if BITS_PER_LONG =3D=3D 64
>+static const hsiphash_key_t test_key_hsiphash =3D
>+	{{ 0x0706050403020100ULL, 0x0f0e0d0c0b0a0908ULL }};
>+
>+static const u32 test_vectors_hsiphash[64] =3D {
>+	0x050fc4dcU, 0x7d57ca93U, 0x4dc7d44dU,
>+	0xe7ddf7fbU, 0x88d38328U, 0x49533b67U,
>+	0xc59f22a7U, 0x9bb11140U, 0x8d299a8eU,
>+	0x6c063de4U, 0x92ff097fU, 0xf94dc352U,
>+	0x57b4d9a2U, 0x1229ffa7U, 0xc0f95d34U,
>+	0x2a519956U, 0x7d908b66U, 0x63dbd80cU,
>+	0xb473e63eU, 0x8d297d1cU, 0xa6cce040U,
>+	0x2b45f844U, 0xa320872eU, 0xdae6c123U,
>+	0x67349c8cU, 0x705b0979U, 0xca9913a5U,
>+	0x4ade3b35U, 0xef6cd00dU, 0x4ab1e1f4U,
>+	0x43c5e663U, 0x8c21d1bcU, 0x16a7b60dU,
>+	0x7a8ff9bfU, 0x1f2a753eU, 0xbf186b91U,
>+	0xada26206U, 0xa3c33057U, 0xae3a36a1U,
>+	0x7b108392U, 0x99e41531U, 0x3f1ad944U,
>+	0xc8138825U, 0xc28949a6U, 0xfaf8876bU,
>+	0x9f042196U, 0x68b1d623U, 0x8b5114fdU,
>+	0xdf074c46U, 0x12cc86b3U, 0x0a52098fU,
>+	0x9d292f9aU, 0xa2f41f12U, 0x43a71ed0U,
>+	0x73f0bce6U, 0x70a7e980U, 0x243c6d75U,
>+	0xfdb71513U, 0xa67d8a08U, 0xb7e8f148U,
>+	0xf7a644eeU, 0x0f1837f2U, 0x4b6694e0U,
>+	0xb7bbb3a8U
>+};
>+#else
>+static const hsiphash_key_t test_key_hsiphash =3D
>+	{{ 0x03020100U, 0x07060504U }};
>+
>+static const u32 test_vectors_hsiphash[64] =3D {
>+	0x5814c896U, 0xe7e864caU, 0xbc4b0e30U,
>+	0x01539939U, 0x7e059ea6U, 0x88e3d89bU,
>+	0xa0080b65U, 0x9d38d9d6U, 0x577999b1U,
>+	0xc839caedU, 0xe4fa32cfU, 0x959246eeU,
>+	0x6b28096cU, 0x66dd9cd6U, 0x16658a7cU,
>+	0xd0257b04U, 0x8b31d501U, 0x2b1cd04bU,
>+	0x06712339U, 0x522aca67U, 0x911bb605U,
>+	0x90a65f0eU, 0xf826ef7bU, 0x62512debU,
>+	0x57150ad7U, 0x5d473507U, 0x1ec47442U,
>+	0xab64afd3U, 0x0a4100d0U, 0x6d2ce652U,
>+	0x2331b6a3U, 0x08d8791aU, 0xbc6dda8dU,
>+	0xe0f6c934U, 0xb0652033U, 0x9b9851ccU,
>+	0x7c46fb7fU, 0x732ba8cbU, 0xf142997aU,
>+	0xfcc9aa1bU, 0x05327eb2U, 0xe110131cU,
>+	0xf9e5e7c0U, 0xa7d708a6U, 0x11795ab1U,
>+	0x65671619U, 0x9f5fff91U, 0xd89c5267U,
>+	0x007783ebU, 0x95766243U, 0xab639262U,
>+	0x9c7e1390U, 0xc368dda6U, 0x38ddc455U,
>+	0xfa13d379U, 0x979ea4e8U, 0x53ecd77eU,
>+	0x2ee80657U, 0x33dbb66aU, 0xae3f0577U,
>+	0x88b4c4ccU, 0x3e7f480bU, 0x74c1ebf8U,
>+	0x87178304U
>+};
>+#endif
>+
> static int __init siphash_test_init(void)
> {
> 	u8 in[64] __aligned(SIPHASH_ALIGNMENT);
>@@ -70,6 +130,16 @@ static int __init siphash_test_init(void)
> 			pr_info("siphash self-test unaligned %u: FAIL\n", i + 1);
> 			ret =3D -EINVAL;
> 		}
>+		if (hsiphash(in, i, &test_key_hsiphash) !=3D
>+						test_vectors_hsiphash[i]) {
>+			pr_info("hsiphash self-test aligned %u: FAIL\n", i + 1);
>+			ret =3D -EINVAL;
>+		}
>+		if (hsiphash(in_unaligned + 1, i, &test_key_hsiphash) !=3D
>+						test_vectors_hsiphash[i]) {
>+			pr_info("hsiphash self-test unaligned %u: FAIL\n", i + 1);
>+			ret =3D -EINVAL;
>+		}
> 	}
> 	if (siphash_1u64(0x0706050403020100ULL, &test_key_siphash) !=3D
> 						test_vectors_siphash[8]) {
>@@ -115,6 +185,28 @@ static int __init siphash_test_init(void)
> 		pr_info("siphash self-test 4u32: FAIL\n");
> 		ret =3D -EINVAL;
> 	}
>+	if (hsiphash_1u32(0x03020100U, &test_key_hsiphash) !=3D
>+						test_vectors_hsiphash[4]) {
>+		pr_info("hsiphash self-test 1u32: FAIL\n");
>+		ret =3D -EINVAL;
>+	}
>+	if (hsiphash_2u32(0x03020100U, 0x07060504U, &test_key_hsiphash) !=3D
>+						test_vectors_hsiphash[8]) {
>+		pr_info("hsiphash self-test 2u32: FAIL\n");
>+		ret =3D -EINVAL;
>+	}
>+	if (hsiphash_3u32(0x03020100U, 0x07060504U,
>+			  0x0b0a0908U, &test_key_hsiphash) !=3D
>+						test_vectors_hsiphash[12]) {
>+		pr_info("hsiphash self-test 3u32: FAIL\n");
>+		ret =3D -EINVAL;
>+	}
>+	if (hsiphash_4u32(0x03020100U, 0x07060504U,
>+			  0x0b0a0908U, 0x0f0e0d0cU, &test_key_hsiphash) !=3D
>+						test_vectors_hsiphash[16]) {
>+		pr_info("hsiphash self-test 4u32: FAIL\n");
>+		ret =3D -EINVAL;
>+	}
> 	if (!ret)
> 		pr_info("self-tests: pass\n");
> 	return ret;
>=0D



--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAl1ccCYACgkQsjqdtxFL
KRX2gAgAsoPv9lm/+XmsHCJMGszD635ToTGVxAyxxDaTdSKoRXDxiwWIBVF/ujdn
X15Xkf/NkS5IAk3iZ7ySAKiunq55tc7Xgsq8cn0NZV+VG/1LqByxn0eWkoOkiev3
MUPSZ64PBE8/hi1reAPHiP0soDPdeGe2ishlTDj2iDYW4++rzp59n6cyICb5992r
ImXIOHQcHuHwJRovOXTfh37ZgbseSZYh0TQ7/9d/qCP5oR+TqD7CIgMSUi/IhDJq
e7+mDEJQK6Bsr7YziET4umt5lYWPA0+2Laqful8tqdM0NzQGsQay+ZaCHto0d+0a
qM8LywcqEcAZC21SSm71wGqPl9yIyw==
=glS9
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
