Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72C7D120F1F
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 17:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbfLPQP4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 11:15:56 -0500
Received: from mail-dm6nam12on2046.outbound.protection.outlook.com ([40.107.243.46]:6656
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725805AbfLPQPz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 11:15:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JcfG60er/4SiWVGHN6Kjv7TfKT+svuAYKBOVf5syYCh+jy+Psewh+lGreiqaBYuICaBeDtsBY5FF/Bpfr0MfkNJ4ilqjz6XNRxpiO8B6qg557TNrMthZTtzCIiHdt4y9wcfTq12ZysvsZXWN1gT+VwwCwHNBZ8z9RcFBdlT+U033NxX8xIixrw9BDB9PA6umuzO/krA9nubp5C39WOncTRGuyTmVKVSAjIc7lij86LiYhwSVRoDA4XSOLNdTj/jpIYrcp7L3ss2h/p7/DybMIzJAHmfBr5m/ER/ZZRrGIK3bgqasD7MBKLrWrTtDGX1hZnGjCK1dQmDF8wbPiQQnzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V2pTOri5D2SYgsZnCaRJHEvs0sBbq/grVKXrscKTDNQ=;
 b=kloMiDsE5CFYS0safY52ksUOpmlSpGZ4fBGEbKUARQ69vxl/5EJ3wjomytEAG+R0i4e0jzW9Em8SiOXOyJMxx68dtViJj5A8wTLQwR+m+BMqxb0kpDlPCov6O2mJT6CcMl4TKnFxR0o7MV4sFuJ9d8YKCq3f4gFYYrvtX9ekj342XeXn7kIQNcBvW+6yi5XG9jBF4Ev6aJT0ka0m6Ikxe/7JRCW4Fr6W/ZXSOD4bCPoQzJ2BnuHH6r5zDd5ayqA4q/z74ge3bZuTcxyInnVJqtXC0ZY+5f4uWjv0KJI1GLz/M8LB22P7AtJ+Eyjtp2gr3p0kHhl4LYqTPYIny1reSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V2pTOri5D2SYgsZnCaRJHEvs0sBbq/grVKXrscKTDNQ=;
 b=xPW1ZkiDrmqyoqQ6efVPzBV4kF27a2UQSTNpdQMCzDldq2qEYMTumNrroCHTu1Ov4Iwe1N2U7tztJDOTcb//MPPUam3We/dnWQ2Q1rJiKYdqp50t1GsY78UcVusLB7kqfY4t0n1BbZxE7yX2BU0zS6evhJgntCcdq3lwyOkooqQ=
Received: from MN2PR05MB6141.namprd05.prod.outlook.com (20.178.241.217) by
 MN2PR05MB6477.namprd05.prod.outlook.com (20.178.246.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.12; Mon, 16 Dec 2019 16:15:52 +0000
Received: from MN2PR05MB6141.namprd05.prod.outlook.com
 ([fe80::611e:6a6b:9109:5aa8]) by MN2PR05MB6141.namprd05.prod.outlook.com
 ([fe80::611e:6a6b:9109:5aa8%7]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 16:15:52 +0000
From:   Thomas Hellstrom <thellstrom@vmware.com>
To:     Sasha Levin <sashal@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "mhocko@suse.com" <mhocko@suse.com>
CC:     "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "willy@infradead.org" <willy@infradead.org>
Subject: Re: FAILED: patch "[PATCH] mm/memory.c: fix a huge pud insertion race
 during faulting" failed to apply to 4.19-stable tree
Thread-Topic: FAILED: patch "[PATCH] mm/memory.c: fix a huge pud insertion
 race during faulting" failed to apply to 4.19-stable tree
Thread-Index: AQHVtAh1XUudiPx/N0iksCFJFjPcUA==
Date:   Mon, 16 Dec 2019 16:15:52 +0000
Message-ID: <MN2PR05MB6141372C8C638027EDE5AA12A1510@MN2PR05MB6141.namprd05.prod.outlook.com>
References: <1576497644874@kroah.com> <20191216155718.GF17708@sasha-vm>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=thellstrom@vmware.com; 
x-originating-ip: [155.4.205.35]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a6379383-353a-4eb1-416f-08d7824338cb
x-ms-traffictypediagnostic: MN2PR05MB6477:
x-microsoft-antispam-prvs: <MN2PR05MB6477D5261B0EC8CA592EA402A1510@MN2PR05MB6477.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(376002)(136003)(39860400002)(396003)(199004)(189003)(8676002)(81166006)(71200400001)(9686003)(81156014)(110136005)(8936002)(86362001)(33656002)(2906002)(316002)(6506007)(54906003)(7696005)(64756008)(66556008)(186003)(66446008)(66476007)(66946007)(52536014)(5660300002)(91956017)(76116006)(53546011)(55016002)(478600001)(966005)(26005)(45080400002)(4326008)(14583001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR05MB6477;H:MN2PR05MB6141.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9lqvcQiMOT3jpM4kkEy0AiYSiLHwXRmVlRkYV0tJdLy7FBDCX0c+qw8zM1oHVupzLQRz3kJzuwrAmn4M8gROjOgaYEPK8mZpaCBj/O3nNHDjfjoTSL0AptTV3Ns6gT+AOuSMt49DmgQyD+uPF/uEpTXQFmlFHefQl2gs6bKIa8kPGuGv+EKTWYP8g/Fs+Gd2tw85Hqs2byXRsRfPjBxcHAGa5q1fXl7eeNF1ayASAmePh9OrlIkrbTLNd3R5IPDubSu1TyQWHTguYLFVJPsMrM3XkFe6aIrcLlhMvP9uIekHYF+pEe60zECKxlzQof97A98J3XOfTn7/eYTNhHWHVeQnGrKiqXdatkzlPcdcLU6mMHB0afcECvDV/Jj5W9VGotXijj///GC+OgHz2CU9t8cJmKGMmNW7j689apUHXa0WXqssCqgNaeovgu/r5lcdBzKUZ1CqRDqI6HmD1zusu23JhygQNt7zf94oziG1n2p2BcPfb0QVcLa6VTIdNVOpSIxs7Ka4JNBuhEiqnYDK0w==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6379383-353a-4eb1-416f-08d7824338cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 16:15:52.2249
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 166l0YuKlCygggp/pnuxThfR8V0jjWepCAA17Bf+lXHvw1NiKM6YusIbtAlj0qyHB4KBcrme9efGh9dIKKR0cA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR05MB6477
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi!=0A=
=0A=
On 12/16/19 4:57 PM, Sasha Levin wrote:=0A=
> On Mon, Dec 16, 2019 at 01:00:44PM +0100, gregkh@linuxfoundation.org wrot=
e:=0A=
>> The patch below does not apply to the 4.19-stable tree.=0A=
>> If someone wants it applied there, or to any other stable or longterm=0A=
>> tree, then please email the backport, including the original git commit=
=0A=
>> id to <stable@vger.kernel.org>.=0A=
>>=0A=
>> thanks,=0A=
>>=0A=
>> greg k-h=0A=
>>=0A=
>> ------------------ original commit in Linus's tree ------------------=0A=
>>=0A=
> >From 625110b5e9dae9074d8a7e67dd07f821a053eed7 Mon Sep 17 00:00:00 2001=
=0A=
>> From: Thomas Hellstrom <thellstrom@vmware.com>=0A=
>> Date: Sat, 30 Nov 2019 17:51:32 -0800=0A=
>> Subject: [PATCH] mm/memory.c: fix a huge pud insertion race during fault=
ing=0A=
>>=0A=
>> A huge pud page can theoretically be faulted in racing with pmd_alloc()=
=0A=
>> in __handle_mm_fault().  That will lead to pmd_alloc() returning an=0A=
>> invalid pmd pointer.=0A=
>>=0A=
>> Fix this by adding a pud_trans_unstable() function similar to=0A=
>> pmd_trans_unstable() and check whether the pud is really stable before=
=0A=
>> using the pmd pointer.=0A=
>>=0A=
>> Race:=0A=
>>  Thread 1:             Thread 2:                 Comment=0A=
>>  create_huge_pud()                               Fallback - not taken.=
=0A=
>>                        create_huge_pud()         Taken.=0A=
>>  pmd_alloc()                                     Returns an invalid poin=
ter.=0A=
>>=0A=
>> This will result in user-visible huge page data corruption.=0A=
>>=0A=
>> Note that this was caught during a code audit rather than a real=0A=
>> experienced problem.  It looks to me like the only implementation that=
=0A=
>> currently creates huge pud pagetable entries is dev_dax_huge_fault()=0A=
>> which doesn't appear to care much about private (COW) mappings or=0A=
>> write-tracking which is, I believe, a prerequisite for create_huge_pud()=
=0A=
>> falling back on thread 1, but not in thread 2.=0A=
>>=0A=
>> Link: https://nam04.safelinks.protection.outlook.com/?url=3Dhttp%3A%2F%2=
Flkml.kernel.org%2Fr%2F20191115115808.21181-2-thomas_os%40shipmail.org&amp;=
data=3D02%7C01%7Cthellstrom%40vmware.com%7C24addc40cb56441b594408d78240a278=
%7Cb39138ca3cee4b4aa4d6cd83d9dd62f0%7C0%7C0%7C637121086431698566&amp;sdata=
=3DwAhgL%2BfbBiu2eDOb3ygPahH0OiYBLV1unSCZ0VxpAQY%3D&amp;reserved=3D0=0A=
>> Fixes: a00cc7d9dd93 ("mm, x86: add support for PUD-sized transparent hug=
epages")=0A=
>> Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>=0A=
>> Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>=0A=
>> Cc: Arnd Bergmann <arnd@arndb.de>=0A=
>> Cc: Matthew Wilcox <willy@infradead.org>=0A=
>> Cc: <stable@vger.kernel.org>=0A=
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>=0A=
>> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>=0A=
> This one doesn't apply cleanly because 7635d9cbe832 ("mm, thp, proc:=0A=
> report THP eligibility for each vma") has changed what=0A=
> transparent_hugepage_enabled() does.=0A=
>=0A=
> The "right" backport here would be to simply change from calling=0A=
> __transparent_hugepage_enabled() to calling=0A=
> transparent_hugepage_enabled() as we don't have 7635d9cbe832 in older=0A=
> kernels, but I worry that if we do end up backporting some part of that=
=0A=
> logic change later it will diverge us from upstream and will cause for=0A=
> subtle issues that are difficult to debug.=0A=
>=0A=
> So unless Michal / Andrew yell at me for this, I'm going to take in=0A=
> 7635d9cbe832 even though it's clearly a new feature just to make=0A=
> 625110b5e9da and future patches apply cleanly, and avoid future issues.=
=0A=
>=0A=
Isn't this a change just in the patch context?=0A=
=0A=
In any case, please see previous mails regarding additional testing of=0A=
this patch.=0A=
=0A=
Thanks,=0A=
=0A=
Thomas=0A=
=0A=
=0A=
