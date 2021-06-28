Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBD893B6A94
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 23:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234483AbhF1Vuc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 17:50:32 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:37850 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232143AbhF1Vua (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Jun 2021 17:50:30 -0400
Received: from epcas3p4.samsung.com (unknown [182.195.41.22])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210628214802epoutp04b090e4e221ddc8e592cdc7c113579d77~M3UuhxSUn1974119741epoutp04X
        for <stable@vger.kernel.org>; Mon, 28 Jun 2021 21:48:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210628214802epoutp04b090e4e221ddc8e592cdc7c113579d77~M3UuhxSUn1974119741epoutp04X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1624916882;
        bh=hxKzFy+xnqg7eLkEihr8gyKGDwzA+i3cWEbfDicdVYQ=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=iAWBgtXtXIOSEceh4Lo+bthB//WQ+sMQWOqcLSPiG9+2bEKRRiEpyopvotbPHV+y2
         Ou4CE3x560MN+NM6hgTVaiGxHnqYQWUT1tzNd7Cn5JHDzmL2SN5jEfl9oVI/0x2g9V
         nEc86F/UPfpkenU4ACNUai7VNzyz7lttZHpRGj1s=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas3p2.samsung.com (KnoxPortal) with ESMTP id
        20210628214801epcas3p2c230891b31fda11911574c43998d74f2~M3UuFDWC71579715797epcas3p2K;
        Mon, 28 Jun 2021 21:48:01 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp4.localdomain
        (Postfix) with ESMTP id 4GDLnY6plZz4x9Pq; Mon, 28 Jun 2021 21:48:01 +0000
        (GMT)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20210628100500epcas2p48c13e88e123aa002aea27a945f9e02e0~Mtu5z62Qs2064920649epcas2p4f;
        Mon, 28 Jun 2021 10:05:00 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210628100500epsmtrp11d4b3303a09c88356352ef48b136e491~Mtu5zA34m3193931939epsmtrp1k;
        Mon, 28 Jun 2021 10:05:00 +0000 (GMT)
X-AuditID: b6c32a2a-bebff70000002061-7a-60d99ecc5f26
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        A8.9B.08289.CCE99D06; Mon, 28 Jun 2021 19:05:00 +0900 (KST)
Received: from KORCO039056 (unknown [10.229.8.156]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210628100500epsmtip17816949dd49642b6e9c507dbc9c7f9d8~Mtu5mDvCS1050310503epsmtip1x;
        Mon, 28 Jun 2021 10:05:00 +0000 (GMT)
From:   "Chanho Park" <chanho61.park@samsung.com>
To:     "'Greg KH'" <gregkh@linuxfoundation.org>
Cc:     "'Bumyong Lee'" <bumyong.lee@samsung.com>,
        "'Christoph Hellwig'" <hch@lst.de>,
        "'Dominique MARTINET'" <dominique.martinet@atmark-techno.com>,
        =?iso-8859-2?Q?'Horia_Geant=E3'?= <horia.geanta@nxp.com>,
        <stable@vger.kernel.org>,
        "'Konrad Rzeszutek Wilk'" <konrad.wilk@oracle.com>
In-Reply-To: <YNmYE5aHvQBYn6cr@kroah.com>
Subject: RE: [PATCH] swiotlb: manipulate orig_addr when tlb_addr has offset
Date:   Mon, 28 Jun 2021 19:05:00 +0900
Message-ID: <1891546521.01624916881934.JavaMail.epsvc@epcpadp4>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKltQgv62cTY7iu3VSex7QwgHRErAJIYWAyAcMSlFEBi98T+QKRGoCtAf6asY+pO2LQ8A==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsWy7bCSnO6ZeTcTDB5t0rbYe9rC4uUhTYvV
        B5wsmhevZ7NYufook8WH84eZLJYtfsposWDjI0YHDo/O5sVMHvvnrmH32H2zgc1j47sdTB4f
        n95i8ejbsorR4/MmuQD2KC6blNSczLLUIn27BK6MA987mAtOsFb83n6HtYFxDUsXIyeHhICJ
        xLY/jUxdjFwcQgI7GCWWnbvHDpGQlXj2bgeULSxxv+UIK0TRM0aJzsWvwRJsAvoSLzu2sYLY
        IgI6Eh1nTrCAFDELLGKSOD2tjx2iYyaTROfyDUA7ODg4BTQlrq6zBGkQFvCW+HXzAiOIzSKg
        KrHhzFc2EJtXwFLiyMVrrBC2oMTJmU/ATmUWMJBYsvAXE4QtL7H97RxmiOsUJH4+XQZ1RJjE
        i/eXmSFqRCRmd7YxT2AUnoVk1Cwko2YhGTULScsCRpZVjJKpBcW56bnFhgVGeanlesWJucWl
        eel6yfm5mxjBkaaltYNxz6oPeocYmTgYDzFKcDArifCKVV1LEOJNSaysSi3Kjy8qzUktPsQo
        zcGiJM57oetkvJBAemJJanZqakFqEUyWiYNTqoFJ3+SV/LOenyeFMhNm31pxyuu98xelP4rv
        rdnje5o2tc2WZt/l/OGF7hfR75/6RUInsEZ+1n01t+5YnrzJnV6OegPpnHA5Cca0wwXrTB7q
        v0mrrKj7MXHS69Ck0xcDGt4F3vV68eJul3uMwN9bGrpbxY+wqZQU5cgdfq45VaXGhYGxInvC
        sy0L5Q1bQxr/zDleVnLEPed0OfusLrHlHDybE9r94vkXB0pPaUudz+yiILN8Q3Lxp+2HDl+u
        EZs61zGaM2S/ZVXEiat/S3NPR3rZ3WvZmpr2+lxVgeA7c6fzN9WaY2K/HvvC7lH4tu2W4nFj
        zevGPqs7t52uYXXzdTC74z7HeGvVguhpWWL+G5VYijMSDbWYi4oTAeg4uq8jAwAA
X-CMS-MailID: 20210628100500epcas2p48c13e88e123aa002aea27a945f9e02e0
X-Msg-Generator: CA
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210628065823epcas2p19305f8b888a7fc0e883ec51db61e3bae
References: <16246131632380@kroah.com>
        <CGME20210628065823epcas2p19305f8b888a7fc0e883ec51db61e3bae@epcas2p1.samsung.com>
        <513700442.21624870682149.JavaMail.epsvc@epcpadp4>
        <YNmQ9ZmZS658Rxfi@kroah.com>
        <1891546521.01624872602204.JavaMail.epsvc@epcpadp3>
        <YNmYE5aHvQBYn6cr@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> That does not work when the message you are sending in-reply-to is no
> longer in the recipient's message box :)

Ah. Got it.

> 
> > This is for linux-5.12.y tree.
> 
> Great, thanks.
> 
> > > And did you send the same patch twice?
> >
> > No. Unfortunately, they're different due to swiotlb patches. I
> > backported the patch to each kernel versions respectively.
> 
> What is the "other" patch for?

Another patch what I sent is for linux-5.10.y tree.
Regarding linux-5.10.y's patch and linux-5.12.y's patch, below patch was
applied only for linux-5.12.y tree and it made differences.

daf9514fd5eb swiotlb: Validate bounce size in the sync/unmap path

Best Regards,
Chanho Park


