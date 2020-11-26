Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B39252C5416
	for <lists+stable@lfdr.de>; Thu, 26 Nov 2020 13:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388291AbgKZMlM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Nov 2020 07:41:12 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:36259 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388891AbgKZMlK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Nov 2020 07:41:10 -0500
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20201126124107epoutp025a1866d340723f53f967457b60e65120~LD0G4APSY2815728157epoutp02A
        for <stable@vger.kernel.org>; Thu, 26 Nov 2020 12:41:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20201126124107epoutp025a1866d340723f53f967457b60e65120~LD0G4APSY2815728157epoutp02A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1606394467;
        bh=iSqjeiZN9ZHIRsbmUchA6FqeDwl9GLlk9YIZdX3McHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z4IRhwDfyJWTHY1PeI6Bh7HbQKwLNeJHgMWM/WSmUC6oP6SOzQ6SB6JjGzfPJJFMz
         t2ohr9YbDBP6rAQON1L4/zrTFQoKhZ5ldIzFDMMrRm6QJvjxwzuAJ+0wOPExi3aVwR
         zhCMRtxgubjs2bCa++xZVUrbFXe5qMeEzQ+LIoK4=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20201126124105epcas2p2704e8efad1121ed61ded1c17d39776b0~LD0FDnoVq1559715597epcas2p2G;
        Thu, 26 Nov 2020 12:41:05 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.182]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4ChcnC5Blmz4x9Pq; Thu, 26 Nov
        2020 12:41:03 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        78.B6.53956.F52AFBF5; Thu, 26 Nov 2020 21:41:03 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20201126124101epcas2p30b7039bc8e6a9c08e35487b39dd84767~LD0CEgkiy1209912099epcas2p3L;
        Thu, 26 Nov 2020 12:41:01 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201126124101epsmtrp2d572c1eadbcde839ee26f885469c1ab8~LD0CAWK4k0997409974epsmtrp2k;
        Thu, 26 Nov 2020 12:41:01 +0000 (GMT)
X-AuditID: b6c32a47-72bff7000000d2c4-63-5fbfa25fecaf
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E1.4E.13470.D52AFBF5; Thu, 26 Nov 2020 21:41:01 +0900 (KST)
Received: from localhost.localdomain (unknown [12.36.155.123]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20201126124101epsmtip1aa2f3840fb064b5b912f238509583ec5~LD0BmgMw62986829868epsmtip1B;
        Thu, 26 Nov 2020 12:41:01 +0000 (GMT)
From:   Youngmin Nam <youngmin.nam@samsung.com>
To:     minchan@kernel.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        namhyung@kernel.org, youngmin.nam@samsung.com
Subject: Re: [PATCH] tracing: Fix align of static buffer
Date:   Thu, 26 Nov 2020 22:04:28 +0900
Message-Id: <20201126130428.17826-1-youngmin.nam@samsung.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20201125225654.1618966-1-minchan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGKsWRmVeSWpSXmKPExsWy7bCmuW78ov3xBrNPcVhc3jWHzWLZ1/fs
        Fk3LtrJYLNj4iNFi8YFP7A6sHptWdbJ59G1ZxejxeZNcAHNUjk1GamJKapFCal5yfkpmXrqt
        kndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0EolhbLEnFKgUEBicbGSvp1NUX5pSapC
        Rn5xia1SakFKToGhYYFecWJucWleul5yfq6VoYGBkSlQZUJOxo4/LgXRFd8b9jA2MHp2MXJy
        SAiYSPx98JO9i5GLQ0hgB6PE5ON3mSGcT4wSR2cuZoNwvjFK9O3YzA7TcvPIZiaIxF5GiVuX
        J0NVfWaUOHL5PjNIFZuArsS2E/8YQWwRATGJx19+gHUzC2RKXPl5ECjOwSEsYCGx+UgESJhF
        QFXiypRjTCA2r4CtxLvXD5ghlslLzG48zQZicwpYSZy80cYCUSMocXLmExaIkfISzVtng50t
        IXCMXeLdjl1MEM0uEssX3WGDsIUlXh3fAvWBlMTnd3uh4vUSi7cthWqewCgxf9MHqCJjiVnP
        2sEOZRbQlFi/Sx/ElBBQljhyC2ovn0TH4b/sEGFeiY42IYhGNYlfUzYwQtgyErsXr4B6xUOi
        8V4PNKh6GSUub97NPoFRYRaSd2YheWcWwuIFjMyrGMVSC4pz01OLjQqMkaN3EyM4AWq572Cc
        8faD3iFGJg7GQ4wSHMxKIrzuwnvjhXhTEiurUovy44tKc1KLDzGaAgN7IrOUaHI+MAXnlcQb
        mhqZmRlYmlqYmhlZKInzhq7sixcSSE8sSc1OTS1ILYLpY+LglGpgWjiRvcZ9ydOXDyomPt0/
        e/u+4KTqsJWGGxTS5v/Y2uVwaU+SxCUZa72SbYcZ9nWoHXB/Wj/B/k1Y3EL1XRyLUlazrirt
        qHJpU/zH06bSeXO6kvsm6VNfrv/3aPN3M/y+5P85vqZkZSu54L2m7Arv7jz8xuG3UmrlZwm/
        ba5rWAt9DG3eeeXnRv55uK/pkv2Jw4Wqje3xO9M3eG7j33Lj8/XQ1QePZ8tURk7i07VPaLfY
        UrD37vGNYtYBuheUg6PZGRkPlP00DVO7efDwbfuINCGeBbNuubBO2LDm7hS+A6a+DnuKxbZ3
        vHq7h6vu5I5/DGE6ExnULfSl0uV8fDeekuY+dn+Hu5zLwrVflrbfVWIpzkg01GIuKk4EAHsn
        IT8JBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsWy7bCSnG7sov3xBv0PVCwu75rDZrHs63t2
        i6ZlW1ksFmx8xGix+MAndgdWj02rOtk8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK2PHH5eC
        6IrvDXsYGxg9uxg5OSQETCRuHtnM1MXIxSEksJtRYuuvX4wQCRmJ2ysvs0LYwhL3W46wQhR9
        ZJToeXoWLMEmoCux7cQ/sAYRATGJx19+sIPYzAK5EhtbFwLFOTiEBSwkNh+JAAmzCKhKXJly
        jAnE5hWwlXj3+gEzxHx5idmNp9lAbE4BK4mTN9pYQGwhAUuJWae/sUPUC0qcnPmEBWK8vETz
        1tnMExgFZiFJzUKSWsDItIpRMrWgODc9t9iwwDAvtVyvODG3uDQvXS85P3cTIzhMtTR3MG5f
        9UHvECMTB+MhRgkOZiURXnfhvfFCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeW8ULowTEkhPLEnN
        Tk0tSC2CyTJxcEo1MOU8PPg94bXwh2XnXuhNmr4o9+687BzXEJcjrw/vM4v9c9WtVZGfOSfs
        mOlGj8MbmrP6JWvPOMbpTJfcL7hOb9E01YVJbAVHu036ypaH3Nx5d/b93efXyPUL1+SYTc35
        U2rpfoDl36dLV9Tvcs49bckb3xX82P9oekWDQN/+Zeti36udKl5y9VzpZeHLVoscVk/Wilm6
        6H/dnw+pScdL5/rtuTH1q9QrznB/l1oejz3p54zS1Ja4rzt1MrTuds3uCc9/8tzUt7TLDp6Q
        uCkgb7pKVEndKSdDgQK25tS88yW30vadZFPWK3r/UjzskdNKRYG4nK2Clnw2d/WaWFYuKMz3
        MuQU3atRNtmSO3BSuhJLcUaioRZzUXEiAJOvNBPCAgAA
X-CMS-MailID: 20201126124101epcas2p30b7039bc8e6a9c08e35487b39dd84767
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201126124101epcas2p30b7039bc8e6a9c08e35487b39dd84767
References: <20201125225654.1618966-1-minchan@kernel.org>
        <CGME20201126124101epcas2p30b7039bc8e6a9c08e35487b39dd84767@epcas2p3.samsung.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Minchan,

Feel free to add my:

Tested-by: Youngmin Nam <youngmin.nam@samsung.com>
