Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A66D30A0D2
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 05:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbhBAEZM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Jan 2021 23:25:12 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:37751 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbhBAEZG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 Jan 2021 23:25:06 -0500
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210201042425epoutp01fdb22e124effce7b8ad25543cd8bd41c~fhQjuZ9rP0903809038epoutp01j
        for <stable@vger.kernel.org>; Mon,  1 Feb 2021 04:24:25 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210201042425epoutp01fdb22e124effce7b8ad25543cd8bd41c~fhQjuZ9rP0903809038epoutp01j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1612153465;
        bh=mzsOWaLVGB19SDLHA+p5zA0nXz4UWOzySUeCX32NA5Q=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=KsnMTuiL/FqCqqhRqlFZVLmdjKeFjQVjdxuQK62EAVHFSgv6Gmd+HNFafQnjrOZ8+
         eqC/O0iz23nt87vbDNsl5aanQlkAufnQtb08IhQttq8a28rXg2TjqsTcje0upa+TvP
         N6wxCyxiEfrZXPyzKvqWJIHk4RlnS8csby0TFuOw=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210201042424epcas1p236f4e9f2d64901b136a1dead4d229e75~fhQi9PXEm2745027450epcas1p2m;
        Mon,  1 Feb 2021 04:24:24 +0000 (GMT)
Received: from epsmges1p4.samsung.com (unknown [182.195.40.162]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4DTZbC1N50z4x9Py; Mon,  1 Feb
        2021 04:24:23 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
        epsmges1p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        BF.13.10463.57287106; Mon,  1 Feb 2021 13:24:21 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20210201042420epcas1p246004f977a64fba2d843957c50cd4a4d~fhQfsjg8H2745027450epcas1p2X;
        Mon,  1 Feb 2021 04:24:20 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210201042420epsmtrp2d8c9f7bfb4b7f08f2fe8cc34d21cb380~fhQfrhQSQ0857308573epsmtrp2J;
        Mon,  1 Feb 2021 04:24:20 +0000 (GMT)
X-AuditID: b6c32a38-f11ff700000028df-a3-601782752303
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        47.50.13470.47287106; Mon,  1 Feb 2021 13:24:20 +0900 (KST)
Received: from namjaejeon01 (unknown [10.88.104.63]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210201042420epsmtip12ea66c24553c76fbcc9d958b1a57ed44~fhQfh3iwq0720307203epsmtip1K;
        Mon,  1 Feb 2021 04:24:20 +0000 (GMT)
From:   "Namjae Jeon" <namjae.jeon@samsung.com>
To:     "'Randy Dunlap'" <rdunlap@infradead.org>,
        <linux-fsdevel@vger.kernel.org>
Cc:     <sj1557.seo@samsung.com>, <stable@vger.kernel.org>
In-Reply-To: <554abcaf-e92c-4f39-5c31-c07db9332f4d@infradead.org>
Subject: RE: [PATCH v2] exfat: fix shift-out-of-bounds in exfat_fill_super()
Date:   Mon, 1 Feb 2021 13:24:20 +0900
Message-ID: <004101d6f852$1cbca4a0$5635ede0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHNCddPt7VLYABXHZak/VUr9I1ozAIxmPhpAmwvT7mqMZ+okA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNKsWRmVeSWpSXmKPExsWy7bCmrm5pk3iCwe0p0hZ79p5ksXh7ZzqL
        xZZ/R1gtFmx8xOjA4rF5hZZH35ZVjB6fN8kFMEfl2GSkJqakFimk5iXnp2TmpdsqeQfHO8eb
        mhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYALVNSKEvMKQUKBSQWFyvp29kU5ZeWpCpk5BeX2Cql
        FqTkFBgaFOgVJ+YWl+al6yXn51oZGhgYmQJVJuRkHO5RLnjIX7F07gXmBsYZvF2MnBwSAiYS
        T/dNZ+5i5OIQEtjBKLFz5jN2COcTo8TkB4+hMt8YJU683sQO09K/ehkbRGIvo8Thrl0sEM5L
        RonnC36wglSxCehK/PuzH6iKg0NEwF/i0XYdEJNZwExi2kkrkApOAUeJp7v2g1ULC/hI7Gx4
        wQhiswioSCx+cpcFxOYVsJSY+PglG4QtKHFy5hOwOLOAvMT2t3OYIe5RkPj5dBnYHBEBJ4lt
        XyeyQtSISMzubAN7QELgK7vEu4vNUA+4SLy9s4AVwhaWeHV8C1RcSuLzu71gJ0sIVEt83A81
        v4NR4sV3WwjbWOLm+g2sEK9oSqzfpQ8RVpTY+XsuI8RaPol3X3tYIabwSnS0CUGUqEr0XTrM
        BGFLS3S1f2CfwKg0C8ljs5A8NgvJA7MQli1gZFnFKJZaUJybnlpsWGCCHNObGMGpUMtiB+Pc
        tx/0DjEycTAeYpTgYFYS4T01SSxBiDclsbIqtSg/vqg0J7X4EKMpMKgnMkuJJucDk3FeSbyh
        qZGxsbGFiZm5mamxkjhvksGDeCGB9MSS1OzU1ILUIpg+Jg5OqQamBlsFcY770xgW/n2jNPfM
        3ftb6rdPWt49iXGC4p23zttTD0+dtPninkOiq1klGjqTNl1vUxL5v1d2k7ngvm2lvI+P7rPj
        i54kl3dia+33hRazOtmYrfrUOaVbdjFHyGtPX/ji/EJj2b4VZ3IetH137Lrru7NONdZS+qGH
        FXujQ8quEym+b97v6+a8+z/rW3vmjAfJXXeN1B6ctubUDI31sIvRvhc6rcPkgGtmZx7TkveT
        Few2GFk/7U0xX1p7dInYn0iZ1DMOyewujPxHG0/PKL93VN5MvFTnzrEaz9LIMJWNk6VffQlW
        1rkpHHfssjTj4ZxvP9ed/i/l0SYaUec8NfXWg7V7Zse5lp+1WSWmxFKckWioxVxUnAgAh/ih
        ng4EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsWy7bCSnG5Jk3iCwcqzqhZ79p5ksXh7ZzqL
        xZZ/R1gtFmx8xOjA4rF5hZZH35ZVjB6fN8kFMEdx2aSk5mSWpRbp2yVwZRzuUS54yF+xdO4F
        5gbGGbxdjJwcEgImEv2rl7GB2EICuxkl7v/wgohLSxw7cYa5i5EDyBaWOHy4uIuRC6jkOaPE
        1EU/mEBq2AR0Jf792c8GUiMi4C/xaLsOSJhZwELiwos3LBD1hxglbvx7CTafU8BR4umu/awg
        trCAj8TOhheMIDaLgIrE4id3WUBsXgFLiYmPIep5BQQlTs58wgIxVFvi6c2nULa8xPa3c5gh
        7lSQ+Pl0GdhMEQEniW1fJ7JC1IhIzO5sY57AKDwLyahZSEbNQjJqFpKWBYwsqxglUwuKc9Nz
        iw0LDPNSy/WKE3OLS/PS9ZLzczcxgqNCS3MH4/ZVH/QOMTJxMAI9ycGsJMJ7apJYghBvSmJl
        VWpRfnxRaU5q8SFGaQ4WJXHeC10n44UE0hNLUrNTUwtSi2CyTBycUg1MtXdvNsTq2JVmfJA/
        eYzbdMrBdtcLs+YFOJvWRa+Y822vzPVpy/ZabgxlcNmmphAyS0YjdUn+9AWFi4IZqyPu3GFc
        eHTn+dTL/RuVDy3u3WY3Me1g/qYnK1uEW2pK5kn7N+0+ce+H4KtdXX1XoruvMzplF0xcldh1
        vWb7f6ZjEr+F+OJyV9gv1VTSz5qwJyhYe8HWBW/OWm9gCmMsLbOL0956SDqbr/oJ+2/PoFN1
        H8VelQmtUN7z+f3lkrf9bEd5H234uljq5MHlrdsLosOfn79U8bzyb3LhhWNpnWWXPvdx8U4w
        9j13quz/a8uPL52f7N24deIxTe9/D6f/mbz7yJSDq2b/8ph4s3hCS1LI5TtKLMUZiYZazEXF
        iQBuAHWV+QIAAA==
X-CMS-MailID: 20210201042420epcas1p246004f977a64fba2d843957c50cd4a4d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210201025358epcas1p46c6943424d296e8ba46b361d637d0068
References: <CGME20210201025358epcas1p46c6943424d296e8ba46b361d637d0068@epcas1p4.samsung.com>
        <20210201024620.2178-1-namjae.jeon@samsung.com>
        <554abcaf-e92c-4f39-5c31-c07db9332f4d@infradead.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On 1/31/21 6:46 PM, Namjae Jeon wrote:
> > syzbot reported a warning which could cause shift-out-of-bounds issue.
> >
> > Call Trace:
> >  __dump_stack lib/dump_stack.c:79 [inline]  dump_stack+0x183/0x22e
> > lib/dump_stack.c:120  ubsan_epilogue lib/ubsan.c:148 [inline]
> >  __ubsan_handle_shift_out_of_bounds+0x432/0x4d0 lib/ubsan.c:395
> > exfat_read_boot_sector fs/exfat/super.c:471 [inline]
> > __exfat_fill_super fs/exfat/super.c:556 [inline]
> >  exfat_fill_super+0x2acb/0x2d00 fs/exfat/super.c:624
> >  get_tree_bdev+0x406/0x630 fs/super.c:1291
> >  vfs_get_tree+0x86/0x270 fs/super.c:1496  do_new_mount
> > fs/namespace.c:2881 [inline]
> >  path_mount+0x1937/0x2c50 fs/namespace.c:3211  do_mount
> > fs/namespace.c:3224 [inline]  __do_sys_mount fs/namespace.c:3432
> > [inline]
> >  __se_sys_mount+0x2f9/0x3b0 fs/namespace.c:3409
> >  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
> >  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> >
> > exfat specification describe sect_per_clus_bits field of boot sector
> > could be at most 25 - sect_size_bits and at least 0. And
> > sect_size_bits can also affect this calculation, It also needs validation.
> > This patch add validation for sect_per_clus_bits and sect_size_bits
> > field of boot sector.
> >
> > Fixes: 719c1e182916 ("exfat: add super block operations")
> > Cc: stable@vger.kernel.org # v5.9+
> > Reported-by: syzbot+da4fe66aaadd3c2e2d1c@syzkaller.appspotmail.com
> > Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
> > Tested-by: Randy Dunlap <rdunlap@infradead.org>
> > Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> 
> Tested-by: Randy Dunlap <rdunlap@infradead.org> # for v2
Thanks for your testing!
> 
> 
> > ---
> > v2:
> >  - change at most sect_per_clus_bits from 16 to 25 - sect_size_bits.
> >
> >  fs/exfat/exfat_raw.h |  4 ++++
> >  fs/exfat/super.c     | 31 ++++++++++++++++++++++++++-----
> >  2 files changed, 30 insertions(+), 5 deletions(-)
> 
> thanks.
> --
> ~Randy


