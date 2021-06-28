Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE823B5B49
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 11:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232564AbhF1Jcb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 05:32:31 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:50869 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232523AbhF1Jca (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Jun 2021 05:32:30 -0400
Received: from epcas3p4.samsung.com (unknown [182.195.41.22])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210628093002epoutp0234c48caa461fdcd5201c4201739caf0d~MtQX5m9Yj1556015560epoutp02O
        for <stable@vger.kernel.org>; Mon, 28 Jun 2021 09:30:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210628093002epoutp0234c48caa461fdcd5201c4201739caf0d~MtQX5m9Yj1556015560epoutp02O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1624872602;
        bh=oXKpYXRkQUVN+A3707sppBID07czBzBOOfUdPZEjhAk=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=mm5jYahOLp5sHxzztESy86h0rE21WK0xmh4/oXk+DXZnXbUuk0HKt7OIknCVsT9Tt
         j55R6c57SSuzAz2yBORphvTlgiMd4p7IEZ/gXrvUDBU8MNTze/TgNPCcuM0l7uGC5l
         Lg3sIu7rrvLVZ66ARIAsbS89Z7mK+v1eZZEo1CSU=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas3p2.samsung.com (KnoxPortal) with ESMTP id
        20210628093002epcas3p2daecf64a8ca809b7088366bff8a48bc5~MtQXXxE9v2489024890epcas3p2U;
        Mon, 28 Jun 2021 09:30:02 +0000 (GMT)
Received: from epcpadp3 (unknown [182.195.40.17]) by epsnrtp4.localdomain
        (Postfix) with ESMTP id 4GD2Q21TsGz4x9Pq; Mon, 28 Jun 2021 09:30:02 +0000
        (GMT)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20210628092528epcas2p3adff63fc46a3b86bf26cdb188ebcfe99~MtMYgQ8A71051110511epcas2p3s;
        Mon, 28 Jun 2021 09:25:28 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210628092528epsmtrp2fe5e5d3aa5c65d0099c47ad83ef9a4b1~MtMYfgeP43032930329epsmtrp2-;
        Mon, 28 Jun 2021 09:25:28 +0000 (GMT)
X-AuditID: b6c32a29-607ff700000020ca-13-60d9958808d2
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        28.46.08394.88599D06; Mon, 28 Jun 2021 18:25:28 +0900 (KST)
Received: from KORCO039056 (unknown [10.229.8.156]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210628092528epsmtip2cec2e2e3e10ec54729e371a6166c5757~MtMYSnDT60205402054epsmtip2B;
        Mon, 28 Jun 2021 09:25:28 +0000 (GMT)
From:   "Chanho Park" <chanho61.park@samsung.com>
To:     "'Greg KH'" <gregkh@linuxfoundation.org>
Cc:     "'Bumyong Lee'" <bumyong.lee@samsung.com>,
        "'Christoph Hellwig'" <hch@lst.de>,
        "'Dominique MARTINET'" <dominique.martinet@atmark-techno.com>,
        =?iso-8859-2?Q?'Horia_Geant=E3'?= <horia.geanta@nxp.com>,
        <stable@vger.kernel.org>,
        "'Konrad Rzeszutek Wilk'" <konrad.wilk@oracle.com>
In-Reply-To: <YNmQ9ZmZS658Rxfi@kroah.com>
Subject: RE: [PATCH] swiotlb: manipulate orig_addr when tlb_addr has offset
Date:   Mon, 28 Jun 2021 18:25:28 +0900
Message-ID: <1891546521.01624872602204.JavaMail.epsvc@epcpadp3>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKltQgv62cTY7iu3VSex7QwgHRErAJIYWAyAcMSlFEBi98T+alf13kQ
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42LZdlhJXrdj6s0Eg0m9chZ7T1tYvDykabH6
        gJNF8+L1bBYrVx9lsvhw/jCTxbLFTxktFmx8xOjA4dHZvJjJY//cNeweu282sHlsfLeDyePj
        01ssHn1bVjF6fN4kF8AexWWTkpqTWZZapG+XwJXxbvs05oLnLBV3X8xlbWD8ydzFyMkhIWAi
        cfduJ0sXIxeHkMBuRom5596zQyRkJZ692wFlC0vcbznCClH0jFHi/JpjYN1sAvoSLzu2sYLY
        IgI6Eh1nToBNYhZYxCRxelofWLeQwAlGiWtTgroYOTg4BTQlVq7VAAkLC3hL/Lp5gRHEZhFQ
        lVjRcwRsDq+ApcTFf5cZIWxBiZMzn7CA2MwCBhJLFv5igrDlJba/nQP1gYLEz6fLoG5wk+g4
        9YgZokZEYnZnG/MERuFZSEbNQjJqFpJRs5C0LGBkWcUomVpQnJueW2xYYJiXWq5XnJhbXJqX
        rpecn7uJERxnWpo7GLev+qB3iJGJg/EQowQHs5IIr1jVtQQh3pTEyqrUovz4otKc1OJDjNIc
        LErivBe6TsYLCaQnlqRmp6YWpBbBZJk4OKUamLY3HbhlGSwsnr/WWrv/l5ydb3/epZk1awte
        nBRc5rXpk//BmD+Xflqu2jKxfctpD93gmY/ifYuEPx737IxZb8netTnx4SK2jtXTFDwC5cRK
        WQ0+9L46mycRcqE9tST4NX/Qr2XpN5b+UcmROfnZvXXuNX131QZz/cOOgZ8m51x4+r2p9+nL
        9hdVdlFeh4OqOR9pdDPwpGUWVBx36Ur8dciJ55Z1X1+B4stVO/+8t5bQnvLg3ll5p9zKzg0X
        8t0nXH8vGp694euu8pib6xzTPex2yNi+DGU+JMafV/WK94lRncrbXtf0SyU334f7FFyqYssv
        OJzUbtd2oZR7c3Pr/GtRl+OLJ2+/rXfif7W6EktxRqKhFnNRcSIACtypbCIDAAA=
X-CMS-MailID: 20210628092528epcas2p3adff63fc46a3b86bf26cdb188ebcfe99
X-Msg-Generator: CA
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210628065823epcas2p19305f8b888a7fc0e883ec51db61e3bae
References: <16246131632380@kroah.com>
        <CGME20210628065823epcas2p19305f8b888a7fc0e883ec51db61e3bae@epcas2p1.samsung.com>
        <513700442.21624870682149.JavaMail.epsvc@epcpadp4>
        <YNmQ9ZmZS658Rxfi@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> > commit 5f89468e2f060031cd89fd4287298e0eaf246bf6 upstream.
> > (Backported as different form due to absence of below patch series
> > https://lore.kernel.org/linux-iommu/20210301074436.919889-1-hch@lst.de/)
> 
> What stable kernel(s) is this for?

Hmm. I sent this with "--in-reply-to" option of git send-email with your
e-mail's message-id but it didn't work well.
This is for linux-5.12.y tree.

> 
> And did you send the same patch twice?

No. Unfortunately, they're different due to swiotlb patches. I backported
the patch to each kernel versions respectively.

Best Regards,
Chanho Park


