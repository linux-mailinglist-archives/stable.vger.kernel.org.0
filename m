Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6D01593471
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 20:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbiHOSDi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbiHOSDh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:03:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 09FBF28E2B
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 11:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660586613;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wQjr+DSYGxM4TpUxnXhcHX0DX24mB5hjVi7pYJ9v++8=;
        b=MB6TX+U2Sx9ajnDkaCpI0nwK1N3OTHDlAHa3ZdctLAfWELZC3r7IeB1EKcI/0KeQLE8Sod
        uG2QTU0mQ4Orsafd3RaZ10a/SphFASqI8IpnIJmN7bpBspqWR03l1VYJmg5wL3kzcSqspE
        9jmPBWLa9rS3sWkVF60gkTiDhMJ+CpA=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-104-ckUWqoEBOgin7zqWwJ5zCA-1; Mon, 15 Aug 2022 14:03:32 -0400
X-MC-Unique: ckUWqoEBOgin7zqWwJ5zCA-1
Received: by mail-ej1-f72.google.com with SMTP id g18-20020a1709065d1200b0073082300e1fso1212120ejt.12
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 11:03:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=wQjr+DSYGxM4TpUxnXhcHX0DX24mB5hjVi7pYJ9v++8=;
        b=428/03Kf/Dk9OhQIlNUIXv3xZo3aXU5qPz35kv6aK9WBAccE53xzlm9VG5BPP3Ye4P
         R9iPMAplt0UzkC8NacNrih5AsyFhbfd64bl9eannmJVP9EwEhm5R8d+yn3FQ/sIRoOvl
         YnJmSjSYe330Que08UT/ZcDvOOUF2yeJi7b2oxq3KvrlMKkpoJ2xKn2nX9LgZH4lcK9i
         u2LpmcikwmEQEMOi0USlSPD1socYWE1Ijpv0P11oCNhZi3cJdiLMHF37w+xj2Bw4wca5
         a6yPqFhLRHd/wlhfgftOFF1YlMNVaNAkLFLa7JErmt18lfA9H2I6s1sCGiiZO4zsyUbZ
         RZmA==
X-Gm-Message-State: ACgBeo2b8waSV40XPE2G73xg2Ta7NwqaBITFVQaoeexorc1WTMF5UdSl
        WHVBbwGkh6p/Td/ChhON59qz0Etudzp/lC00rPOb5EO+inHrWj6hG8Spypt/E+GlOWHQ+Pm3xi4
        op5ZuGAiw51xaR2FCR2bdfAx90eI0XIq7
X-Received: by 2002:aa7:dd50:0:b0:440:3e9d:784 with SMTP id o16-20020aa7dd50000000b004403e9d0784mr15656374edw.195.1660586611552;
        Mon, 15 Aug 2022 11:03:31 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4ilBYpI5+hg3LT1yB5sTqM3lMYh4WgRyvUWsiZVy9Nzjcy/+DGyyGBhpo0ZF6gQUL7QOy3v+qFA8joRXmATdM=
X-Received: by 2002:aa7:dd50:0:b0:440:3e9d:784 with SMTP id
 o16-20020aa7dd50000000b004403e9d0784mr15656358edw.195.1660586611281; Mon, 15
 Aug 2022 11:03:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220811103435.188481-1-david@redhat.com> <20220811103435.188481-3-david@redhat.com>
 <YvVRfSYsPOraTo6o@monkey> <20220815153549.0288a9c6@thinkpad>
 <CADFyXm7-0zXDG+ZHjft95aAAiSZh_RyAqgJw1nGsALwEL1XKiw@mail.gmail.com> <20220815175929.303774fd@thinkpad>
In-Reply-To: <20220815175929.303774fd@thinkpad>
From:   David Hildenbrand <david@redhat.com>
Date:   Mon, 15 Aug 2022 20:03:20 +0200
Message-ID: <CADFyXm40iiz-xFpLK4qGgHGh5Qp+98G9qxnqC20c8qtRiKt9_A@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm/hugetlb: support write-faults in shared mappings
To:     Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc:     Mike Kravetz <mike.kravetz@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, stable <stable@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>
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

On Mon, Aug 15, 2022 at 5:59 PM Gerald Schaefer
<gerald.schaefer@linux.ibm.com> wrote:
>
> On Mon, 15 Aug 2022 17:07:32 +0200
> David Hildenbrand <david@redhat.com> wrote:
>
> > On Mon, Aug 15, 2022 at 3:36 PM Gerald Schaefer
> > <gerald.schaefer@linux.ibm.com> wrote:
> > >
> > > On Thu, 11 Aug 2022 11:59:09 -0700
> > > Mike Kravetz <mike.kravetz@oracle.com> wrote:
> > >
> > > > On 08/11/22 12:34, David Hildenbrand wrote:
> > > > > If we ever get a write-fault on a write-protected page in a share=
d mapping,
> > > > > we'd be in trouble (again). Instead, we can simply map the page w=
ritable.
> > > > >
> > > > <snip>
> > > > >
> > > > > Reason is that uffd-wp doesn't clear the uffd-wp PTE bit when
> > > > > unregistering and consequently keeps the PTE writeprotected. Reas=
on for
> > > > > this is to avoid the additional overhead when unregistering. Note
> > > > > that this is the case also for !hugetlb and that we will end up w=
ith
> > > > > writable PTEs that still have the uffd-wp PTE bit set once we ret=
urn
> > > > > from hugetlb_wp(). I'm not touching the uffd-wp PTE bit for now, =
because it
> > > > > seems to be a generic thing -- wp_page_reuse() also doesn't clear=
 it.
> > > > >
> > > > > VM_MAYSHARE handling in hugetlb_fault() for FAULT_FLAG_WRITE
> > > > > indicates that MAP_SHARED handling was at least envisioned, but c=
ould never
> > > > > have worked as expected.
> > > > >
> > > > > While at it, make sure that we never end up in hugetlb_wp() on wr=
ite
> > > > > faults without VM_WRITE, because we don't support maybe_mkwrite()
> > > > > semantics as commonly used in the !hugetlb case -- for example, i=
n
> > > > > wp_page_reuse().
> > > >
> > > > Nit,
> > > > to me 'make sure that we never end up in hugetlb_wp()' implies that
> > > > we would check for condition in callers as opposed to first thing i=
n
> > > > hugetlb_wp().  However, I am OK with description as it.
> > >
> >
> > Hi Gerald,
> >
> > > Is that new WARN_ON_ONCE() in hugetlb_wp() meant to indicate a real b=
ug?
> >
> > Most probably, unless I am missing something important.
> >
> > Something triggers FAULT_FLAG_WRITE on a VMA without VM_WRITE and
> > hugetlb_wp() would map the pte writable.
> > Consequently, we'd have a writable pte inside a VMA that does not have
> > write permissions, which is dubious. My check prevents that and bails
> > out.
> >
> > Ordinary (!hugetlb) faults have maybe_mkwrite() (e.g., for FOLL_FORCE
> > or breaking COW) semantics such that we won't be mapping PTEs writable
> > if the VMA does not have write permissions.
> >
> > I suspect that either
> >
> > a) Some write fault misses a protection check and ends up triggering a
> > FAULT_FLAG_WRITE where we should actually fail early.
> >
> > b) The write fault is valid and some VMA misses proper flags (VM_WRITE)=
.
> >
> > c) The write fault is valid (e.g., for breaking COW or FOLL_FORCE) and
> > we'd actually want maybe_mkwrite semantics.
> >
> > > It is triggered by libhugetlbfs testcase "HUGETLB_ELFMAP=3DR linkhuge=
_rw"
> > > (at least on s390), and crashes our CI, because it runs with panic_on=
_warn
> > > enabled.
> > >
> > > Not sure if this means that we have bug elsewhere, allowing us to
> > > get to the WARN in hugetlb_wp().
> >
> > That's what I suspect. Do you have a backtrace?
>
> Sure, forgot to send it with initial reply...
>
> [   82.574749] ------------[ cut here ]------------
> [   82.574751] WARNING: CPU: 9 PID: 1674 at mm/hugetlb.c:5264 hugetlb_wp+=
0x3be/0x818
> [   82.574759] Modules linked in: nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 =
nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft=
_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set nf_tabl=
es nfnetlink sunrpc uvdevice s390_trng vfio_ccw mdev vfio_iommu_type1 eadm_=
sch vfio zcrypt_cex4 sch_fq_codel configfs ghash_s390 prng chacha_s390 libc=
hacha aes_s390 des_s390 libdes sha3_512_s390 sha3_256_s390 sha512_s390 sha2=
56_s390 sha1_s390 sha_common pkey zcrypt rng_core autofs4
> [   82.574785] CPU: 9 PID: 1674 Comm: linkhuge_rw Kdump: loaded Not taint=
ed 5.19.0-next-20220815 #36
> [   82.574787] Hardware name: IBM 3931 A01 704 (LPAR)
> [   82.574788] Krnl PSW : 0704c00180000000 00000006c9d4bc6a (hugetlb_wp+0=
x3c2/0x818)
> [   82.574791]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 P=
M:0 RI:0 EA:3
> [   82.574794] Krnl GPRS: 000000000227c000 0000000008640071 0000000000000=
000 0000000001200000
> [   82.574796]            0000000001200000 00000000b5a98090 0000000000000=
255 00000000adb2c898
> [   82.574797]            0000000000000000 00000000adb2c898 0000000001200=
000 00000000b5a98090
> [   82.574799]            000000008c408000 0000000092fd7300 000003800339b=
c10 000003800339baf8
> [   82.574803] Krnl Code: 00000006c9d4bc5c: f160000407fe        mvo     4=
(7,%r0),2046(1,%r0)
>            00000006c9d4bc62: 47000700           bc      0,1792
>           #00000006c9d4bc66: af000000           mc      0,0
>           >00000006c9d4bc6a: a7a80040           lhi     %r10,64
>            00000006c9d4bc6e: b916002a           llgfr   %r2,%r10
>            00000006c9d4bc72: eb6ff1600004       lmg     %r6,%r15,352(%r15=
)
>            00000006c9d4bc78: 07fe               bcr     15,%r14
>            00000006c9d4bc7a: 47000700           bc      0,1792
> [   82.574814] Call Trace:
> [   82.574842]  [<00000006c9d4bc6a>] hugetlb_wp+0x3c2/0x818
> [   82.574846]  [<00000006c9d4c62e>] hugetlb_no_page+0x56e/0x5a8
> [   82.574848]  [<00000006c9d4cac2>] hugetlb_fault+0x45a/0x590
> [   82.574850]  [<00000006c9d06d4a>] handle_mm_fault+0x182/0x220
> [   82.574855]  [<00000006c9a9d70e>] do_exception+0x19e/0x470
> [   82.574858]  [<00000006c9a9dff2>] do_dat_exception+0x2a/0x50
> [   82.574861]  [<00000006ca668a18>] __do_pgm_check+0xf0/0x1b0
> [   82.574866]  [<00000006ca677b3c>] pgm_check_handler+0x11c/0x170
> [   82.574870] Last Breaking-Event-Address:
> [   82.574871]  [<00000006c9d4b926>] hugetlb_wp+0x7e/0x818
> [   82.574873] Kernel panic - not syncing: panic_on_warn set ...
> [   82.574875] CPU: 9 PID: 1674 Comm: linkhuge_rw Kdump: loaded Not taint=
ed 5.19.0-next-20220815 #36
> [   82.574877] Hardware name: IBM 3931 A01 704 (LPAR)
> [   82.574878] Call Trace:
> [   82.574879]  [<00000006ca664f22>] dump_stack_lvl+0x62/0x80
> [   82.574881]  [<00000006ca657af8>] panic+0x118/0x300
> [   82.574884]  [<00000006c9ac3da6>] __warn+0xb6/0x160
> [   82.574887]  [<00000006ca29b1ea>] report_bug+0xba/0x140
> [   82.574890]  [<00000006c9a75194>] monitor_event_exception+0x44/0x80
> [   82.574892]  [<00000006ca668a18>] __do_pgm_check+0xf0/0x1b0
> [   82.574894]  [<00000006ca677b3c>] pgm_check_handler+0x11c/0x170
> [   82.574897]  [<00000006c9d4bc6a>] hugetlb_wp+0x3c2/0x818
> [   82.574899]  [<00000006c9d4c62e>] hugetlb_no_page+0x56e/0x5a8
> [   82.574901]  [<00000006c9d4cac2>] hugetlb_fault+0x45a/0x590
> [   82.574903]  [<00000006c9d06d4a>] handle_mm_fault+0x182/0x220
> [   82.574906]  [<00000006c9a9d70e>] do_exception+0x19e/0x470
> [   82.574907]  [<00000006c9a9dff2>] do_dat_exception+0x2a/0x50
> [   82.574909]  [<00000006ca668a18>] __do_pgm_check+0xf0/0x1b0
> [   82.574912]  [<00000006ca677b3c>] pgm_check_handler+0x11c/0x170


do_dat_exception() sets
  access =3D VM_ACCESS_FLAGS;

do_exception() sets
  is_write =3D (trans_exc_code & store_indication) =3D=3D 0x400;

and FAULT_FLAG_WRITE
   if (access =3D=3D VM_WRITE || is_write)
          flags |=3D FAULT_FLAG_WRITE;

however, for VMA permission checks it only checks
  if (unlikely(!(vma->vm_flags & access)))
          goto out_up;

as VM_ACCESS_FLAGS includes VM_WRITE | VM_READ ...

We end up triggering a write fault (FAULT_FLAG_WRITE), even though the
VMA does not allow for writes.

I assume that's what happens and that it's a bug in s390x code.

