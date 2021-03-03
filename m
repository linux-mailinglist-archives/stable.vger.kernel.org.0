Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44BA332C848
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 02:14:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381690AbhCDAfT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 19:35:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234140AbhCDAAv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 19:00:51 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C065FC0613DC;
        Wed,  3 Mar 2021 15:23:00 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id o3so27986910oic.8;
        Wed, 03 Mar 2021 15:23:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=y+QBcgFaWVyvex1UNhCsil33JAfbjhHN/sg1WnQrBc4=;
        b=GEo8z2hRIrxUVRE+6KmFTn5VrpICHch/00VGG9lDWfZk8MPy347g7L2xrbkQgklf0I
         Vz/jAzqBtqK3djCN14m+Sc+3C/LNSvGlWoJlZS6OBuOSkOpSoX1sT3Y9Uq+Yk/IjIgRL
         OzYHfkCuljH19e2fMSUiW4OMAW+SmJyP2r7nFpNwPwR2G39JMlZk+Y2z7KtvP6GNltRt
         h/rflgS6akWOkZzzPscSVbhloZ0qpnzMKiyRYfovkR6Iqilh9sZx4wHVX9bCk1iti6QP
         Iu3gCySwQRkDJUrBR+GQIFzRHJWFrzA6SJuykU3H7fL8hX49LrAZYb8BhC2OpKdumA7m
         CDRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=y+QBcgFaWVyvex1UNhCsil33JAfbjhHN/sg1WnQrBc4=;
        b=RnHKDtYD0LA6QmHLshFJJ4y7ZnAAWDH7ir10950BqTc54/q7+wj3KFEBx0vr0z7DMm
         OJnz2QuyZA/UPOFcHfVyZl9kGd6+b7usASwwY6UHc2aKsemtIvtRMOke5WfqttjfXy3u
         fa/u1S2WtWwOva+7KtgmpV6/sKcu4A/k6IaKHCI/AmYiye2mX3lvbsSVx/8upm2N1NtS
         g1OKs/Pjl1UQZfwSPiVp2WXW2eJRtzsUsqJo146f6IBUwWmGPpEaGZ0+O9UyW/ddNB+D
         O7cG8JpsgacI5IqGNBwJY2HT9f4I4vkBD1E0+N67omU+iHJ361lOan7Yug0Bj476dtFi
         1Ggw==
X-Gm-Message-State: AOAM531FHxMRUqPsTOdE/Im6/8cWNokuor+/X+L+o26uS2GXQSncPse7
        82s9eurhpM6BlVKojitUPU4XBJRJzqU+rw==
X-Google-Smtp-Source: ABdhPJzNl91BjLs+zIIfGzHt+vvQewGxbG8uQ8xvmjuoRP94/DN3yT/5P1wTtpSYsb+9nsvqIreFMQ==
X-Received: by 2002:aca:7594:: with SMTP id q142mr999313oic.168.1614813780018;
        Wed, 03 Mar 2021 15:23:00 -0800 (PST)
Received: from [192.168.88.245] (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id 43sm5456095otv.69.2021.03.03.15.22.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Mar 2021 15:22:59 -0800 (PST)
From:   Nadav Amit <nadav.amit@gmail.com>
Message-Id: <631CDC2D-F12D-4577-8975-FB1FA1F27E54@gmail.com>
Content-Type: multipart/signed;
        boundary="Apple-Mail=_18B5CA1B-8058-4F9A-9129-1C096C002DC9";
        protocol="application/pgp-signature";
        micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH RESEND v3] mm/userfaultfd: fix memory corruption due to
 writeprotect
Date:   Wed, 3 Mar 2021 15:22:56 -0800
In-Reply-To: <20210303190327.GV397383@xz-x1>
Cc:     Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Minchan Kim <minchan@kernel.org>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        stable <stable@vger.kernel.org>, Yu Zhao <yuzhao@google.com>
To:     Peter Xu <peterx@redhat.com>
References: <20210303095702.3814618-1-namit@vmware.com>
 <20210303190327.GV397383@xz-x1>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Apple-Mail=_18B5CA1B-8058-4F9A-9129-1C096C002DC9
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii



> On Mar 3, 2021, at 11:03 AM, Peter Xu <peterx@redhat.com> wrote:
>=20
> On Wed, Mar 03, 2021 at 01:57:02AM -0800, Nadav Amit wrote:
>> From: Nadav Amit <namit@vmware.com>
>>=20
>> Userfaultfd self-test fails occasionally, indicating a memory
>> corruption.
>=20
> It's failing very constantly now for me after I got it run on a 40 =
cores
> system...  While indeed not easy to fail on my laptop.
>=20

It fails rather constantly for me, but since nobody else reproduced it,
I was afraid to say otherwise ;-)

>=20
>> Fixes: 292924b26024 ("userfaultfd: wp: apply _PAGE_UFFD_WP bit")
>> Signed-off-by: Nadav Amit <namit@vmware.com>
>>=20
>> ---
>> v2->v3:
>> * Do not acquire mmap_lock for write, flush conditionally instead =
[Yu]
>> * Change the fixes tag to the patch that made the race apparent [Yu]
>=20
> Did you forget about this one?  It would still be good to point to =
09854ba94c6a
> just to show that 5.7/5.8 stable branches shouldn't need this patch as =
they're
> not prone to the tlb data curruption.  Maybe also cc stable with 5.9+?

The fixes tag is wrong, as you say. I will fix it and cc stable with =
5.9+.

>=20
>> * Removing patch to avoid write-protect on uffd unprotect. More
>>  comprehensive solution to follow (and avoid the TLB flush as well).
>> ---
>> mm/memory.c | 7 +++++++
>> 1 file changed, 7 insertions(+)
>>=20
>> diff --git a/mm/memory.c b/mm/memory.c
>> index 9e8576a83147..06da04f98936 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -3092,6 +3092,13 @@ static vm_fault_t do_wp_page(struct vm_fault =
*vmf)
>> 		return handle_userfault(vmf, VM_UFFD_WP);
>> 	}
>>=20
>> +	/*
>> +	 * Userfaultfd write-protect can defer flushes. Ensure the TLB
>> +	 * is flushed in this case before copying.
>> +	 */
>> +	if (userfaultfd_wp(vmf->vma) && =
mm_tlb_flush_pending(vmf->vma->vm_mm))
>> +		flush_tlb_page(vmf->vma, vmf->address);
>> +
>> 	vmf->page =3D vm_normal_page(vma, vmf->address, vmf->orig_pte);
>> 	if (!vmf->page) {
>> 		/*
>> --
>> 2.25.1
>>=20
>=20
> Thanks for being consistent on fixing this problem.
>=20
> Maybe it's even better to put that into a "unlikely" to reduce the =
affect of
> normal do_wp_page as much as possible?  But I'll leave it to others.
>=20
> If with the fixes tag modified:
>=20
> Reviewed-by: Peter Xu <peterx@redhat.com>
> Tested-by: Peter Xu <peterx@redhat.com>

Thanks, I will send v4 later today.

Regards,
Nadav


--Apple-Mail=_18B5CA1B-8058-4F9A-9129-1C096C002DC9
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEESJL3osl5Ymx/w9I1HaAqSabaD1oFAmBAGlAACgkQHaAqSaba
D1rGnw//Us0fCu0XaieTlSAfbzQ8ehca5zjpYbHo5Q8EfN60eO3pr6fN3bl9vdHL
KGysmooMbkyR9rVXJQTdBPI/PhFERcMFSonc/cxQYwr1bo9zXkWcqrgm6/btMVjB
7luT9k3y9BCAaM8hJSN2+AiK2bWBm993F8wsED7Ji+yW/uHtA5eawqII+fTqkPIj
Ltvsg5rt95BpJpmOt+gzTIFtMU1qZU3DCtgxlTjplMApu89ZamAMYPeldN388p4C
wGsaL0bafgrOCdFf6wYPVQo4Jazn0cBw9e44JohuBLlgleeFf3mBa7pM+N7t+g4Y
Cu7L++QbNZqoT1IJcMAzpxkRt7fREaaYYp45Tow5ri28BOMbtupz4qBUI/3ZD0Wr
El6CYijbDOx9rtB+W29/ZdMBELOrVSuX9qBtYaCJqhIrOu27+4YdTve40iatbrpT
63ESTOPNky/MRbBzLTRNiFx94cM6wnQQuaE6JYoO4oV/A1ID1gqlbj1iVvA5WKMm
UFMcWFniFMurOG/mzG19brrnlC2kBdA6fm6TrYVz9L9DL2o5UbSyxkHHqCOtEn2r
feyFn1hcz5GyYuOSAF07EmV4B6ph5tMCRmc3Jp9aa5RAckBZ1wb0PPE6+5sRyEcl
GOtjfBhpJu8im+BzsJNQi3T5nCL0zxeSGP5MTBvshFXWKhSbjwE=
=p/0+
-----END PGP SIGNATURE-----

--Apple-Mail=_18B5CA1B-8058-4F9A-9129-1C096C002DC9--
