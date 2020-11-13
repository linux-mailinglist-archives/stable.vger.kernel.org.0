Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1921A2B1593
	for <lists+stable@lfdr.de>; Fri, 13 Nov 2020 06:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbgKMFem (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Nov 2020 00:34:42 -0500
Received: from mail-sg2apc01hn2234.outbound.protection.outlook.com ([52.100.184.234]:25856
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726071AbgKMFem (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Nov 2020 00:34:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bZvFN3rUDr5uo9t590dBiY3VLagNF6+WCIkaUhRIHPXgvR9HArPeu++6dkF4TcmTtE7GJPefW02m4HEmGKdrCt5n3rp/BWcjyGKtWZHEjipyes7dLQ6E2Z2u6sDM81xflhhdFaxhwBzBG8SChLVxtTEgvc4RnefO4RPduS2rCUdYTuzyil3A4SApHw8qjQw9yxQtDnWZgbjNK5YG2PvuIGc8xFxThd3rpxa8DVB+HicWRuo/RDbe8+PcyMQgtPDYbJk2GvRfWKCJE+zKZ7ewFB3xVqIJmwbAjBRx5uxeV650M6q5mvREum1Ql3Cbuv/a3/TxDuzHvgWTSRsAjIfhXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+GMkpkJvtadMkNDcF+7QPW0thUxBluYggjP8BKQ03zM=;
 b=XS6bVDM3qTJAxBtvxHQ23UMc1a7X3DW+agstZ8K4r7JXn3g/7HmlnoswsVHEww6b7F7312khIqhGYtVxDYN83Qrv0grY8rEIu7vrhU89xtL1t8NCYhMiyg2DfNXxXi4dtZigXT8eYhwHUzUI+9rb1ta3F+guD8NHfgIT9WKPmE9scDvn8TnJGJa7JUHNIez3smW3Iog74Ia3xEN6TNv13cZdrCik5tiBn7lN+gor0F/J24pdGVhRC8NiTsSm1YfQzsx2dMlo05E40A9OGe7MbZTimsshBjd+Zeqcw6JlpcavNb0gfYNcyUaTxg2vuE0yqKCEOkOr8JZLHAgy1eKPJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nec.com; dmarc=pass action=none header.from=nec.com; dkim=pass
 header.d=nec.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=necglobal.onmicrosoft.com; s=selector1-necglobal-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+GMkpkJvtadMkNDcF+7QPW0thUxBluYggjP8BKQ03zM=;
 b=ssaO+xBoS7v45ksTSAveiZV3Rq0DsXyE6qYEVMREtfOUs5cMffhlT6hRONdyIVghA+vbiKZKhRQQAMoV4lLZ0hi4Sk5J5JQXyM/cFsRwKFZChxYxwN9mvw0+4qOkuoLHRuiwWDBF5DPhwUVO66wIBctKNI48yrYxGkSqZnZ8LR8=
Received: from TY2PR01MB3210.jpnprd01.prod.outlook.com (2603:1096:404:74::14)
 by TY2PR01MB4235.jpnprd01.prod.outlook.com (2603:1096:404:df::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Fri, 13 Nov
 2020 05:34:27 +0000
Received: from TY2PR01MB3210.jpnprd01.prod.outlook.com
 ([fe80::c171:f9a6:903b:87d5]) by TY2PR01MB3210.jpnprd01.prod.outlook.com
 ([fe80::c171:f9a6:903b:87d5%4]) with mapi id 15.20.3541.025; Fri, 13 Nov 2020
 05:34:27 +0000
From:   =?iso-2022-jp?B?SE9SSUdVQ0hJIE5BT1lBKBskQktZOH0hIUQ+TGkbKEIp?= 
        <naoya.horiguchi@nec.com>
To:     Mike Kravetz <mike.kravetz@oracle.com>
CC:     "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Qian Cai <cai@lca.pm>, Hugh Dickins <hughd@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Michal Hocko <mhocko@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Roman Gushchin <guro@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] hugetlbfs: fix anon huge page migration race
Thread-Topic: [PATCH] hugetlbfs: fix anon huge page migration race
Thread-Index: AQHWs60KfZT9XF9ysUaUOQc0PlgC/qnFlfIA
Date:   Fri, 13 Nov 2020 05:34:27 +0000
Message-ID: <20201113053426.GA20236@hori.linux.bs1.fc.nec.co.jp>
References: <20201105195058.78401-1-mike.kravetz@oracle.com>
In-Reply-To: <20201105195058.78401-1-mike.kravetz@oracle.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=nec.com;
x-originating-ip: [165.225.110.205]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4ee56034-1dd1-4bca-3494-08d88795c9b7
x-ms-traffictypediagnostic: TY2PR01MB4235:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <TY2PR01MB4235181FDE1DE3DAA68633DCE7E60@TY2PR01MB4235.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:9;SRV:;IPV:NLI;SFV:SPM;H:TY2PR01MB3210.jpnprd01.prod.outlook.com;PTR:;CAT:OSPM;SFS:(4636009)(366004)(55236004)(66476007)(64756008)(66446008)(66946007)(6486002)(76116006)(66556008)(6916009)(9686003)(4326008)(498600001)(6506007)(83380400001)(7416002)(8676002)(71200400001)(5660300002)(6512007)(8936002)(86362001)(966005)(85182001)(1076003)(186003)(26005)(54906003)(33656002)(2906002)(14583001);DIR:OUT;SFP:1501;
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: =?iso-2022-jp?B?LzNmdkFrRStOeGxCVGxqY0dldStBS3BNbFhHQ3FEdDJRMm90eDBqRUJ4?=
 =?iso-2022-jp?B?YlR2QkZjdXdJdWxMZVNacFNsd241dGlSbjNhVFNuNGhjK1JpTkc3WUY4?=
 =?iso-2022-jp?B?TVNTdDZxV1Vpb1h1bjVTWWU2Mml1V1JORHBPRlIwNUVKc1dKaFUzTzkr?=
 =?iso-2022-jp?B?NkRhUVBvNk9tRTFTcVJjeXo3d0hTdGVydWlQWVJIYmZVNnJBdzdmM29p?=
 =?iso-2022-jp?B?cEVmR3M3RW1YUEkxNzU5YWRtdVgvZSswRUkwejdUY1VxRjZWQ2dQR0Yv?=
 =?iso-2022-jp?B?cFAzSERRR0ZpTit0NzhQMloyb05pclVqRGdYRnh0Q0lyK0xaNFNsQURI?=
 =?iso-2022-jp?B?WVB0dUM2ejRUWEM5eExkTW04MUdBMFdYcFNwdFYvR2U2Zm8vVVZwZHZ0?=
 =?iso-2022-jp?B?cVhobGlaU2VjMkE1WWtJcWNiQy9kZTYvL083bHJFOHhnUHNPcHJSVmlD?=
 =?iso-2022-jp?B?TEJTWHJ5SCtieWJ4djVYWGliZUJkOE9vUjlNYUYweUpDUVhVQWdXYVE5?=
 =?iso-2022-jp?B?ZkwzSm9aRkU2OE4zdWdNMkl4THdZeCs2MVdEK3o4WEZWbjJHVGZjOXFR?=
 =?iso-2022-jp?B?c2xlYjhvRXFXbnNEZTBDSXh1NVN2UjFlNTgvemVHVXhiMU14bjhxVUJY?=
 =?iso-2022-jp?B?bXFyQWNmZitQQnlWbmlIZVhaekd6YjVheENNQUhGYko0cEZ1ai9GYjJk?=
 =?iso-2022-jp?B?dWI3ek5UTDBidGprK0JuVFBMdWRYb2FKUlh1Si9ta3VCWitCUm5QT2Nv?=
 =?iso-2022-jp?B?ZGEyMmFLZGNGeXVSWlFiZmhRdlpxdTdmcnNDRzBudmNMZGVRbkN0VU1w?=
 =?iso-2022-jp?B?TWtkM3pQWnhTVEJmZklQcmkyME5tek13ZTFiNWJlOTBrRHIyVXUzSzND?=
 =?iso-2022-jp?B?NmVRSnRKY1h2YjFjZHJFTk43USsvR3liMGdLOE9nZ3RtUW8zMEIzZEI1?=
 =?iso-2022-jp?B?MDZLRlJ2K0o4QlBKTDZObEFyWTltQkVnRk9NUUh3N0xJUFlaYUl1K20x?=
 =?iso-2022-jp?B?bit6RVNVUk9ITE1hRlQ0Tm13Y3V3Myt4SWNhcHZyem1DUnZ1Mm1WblRt?=
 =?iso-2022-jp?B?a1hUQXltOVQwa3dLT1BiV0NLZVBaaGFMdzg4NFBMdGhwbGpHMS9BOFV3?=
 =?iso-2022-jp?B?V2FFVm91TXd6Y05LSFFqUWJacXZhUlZUSEJxQ2dFaWdDZTVpSlFMaHpU?=
 =?iso-2022-jp?B?SVhFMVpiOHhMR3VSbXBSYUpnTXB2UjgwVGRTS1RIQ3k0SGNlWTZTWGNy?=
 =?iso-2022-jp?B?VENvTzlpam9temM2V0s5Z3E5cS8velhraEp5N2FCQVJxNDJhWmFFWG1Q?=
 =?iso-2022-jp?B?d2thd3NsS3NiMWxEZkNxclJrWm5WMHcrR1ZXN3JsUTZZNDFPUzBXWkhp?=
 =?iso-2022-jp?B?ZnVlem4vNXB5KzAwVklpMDJDNmNPWm5QNlJMdUlmR2lzeXJOY2JlM3p3?=
 =?iso-2022-jp?B?Y00xQzRKUFo3NjdpNGljTQ==?=
x-ms-exchange-antispam-messagedata: 3Bv7p5qR+AbLmiyu2T4oZXcfAezp5JOg+cpY97inmYezVZTt6J+9Nt4J9+9FU/FKP8mEi5tLcduijqdi/3iyCo0ez91+P/7W1QPfDJlSwpc1mNV0QVV2Aeq3/gK0+aAKy8K+IhkaLcA/mEonb8NLvID3WMae3DkTL8WxAKofXicZGMSdtGkH1Mc3Oad9I9YoacrkqukabT6N0oGjE+AW+h5iIbtFLq2v5LgeXIkxMfYz/P9rczgCEZAbaIrUiPNHvYPdOPxyppcE6/hg5O1c8AWnWo9WFhowtSVuU/l8OFqz0shiWwCzW/1Jc0kpVqBMx7sfWZbCD3xCVtXwKt0IppRzzskUl7Os/K5IIE5Co6kL07GJGBf5UCmgCaTX0iSOZWm11wKVS9PirLY1C5yQompaErkveroqLh480M0c0Ag3Dy7zzs65PCJ7pYim7VGdgvqDzfhaEsgO4wNoy6C79oZg/vxzdrHTXbNWZzLzw8yFZ2gYg3+IZrFImr3NvPvRQJokWqWgHbCdy3NL6OWCbGTPx5Nhp5hxtplc2Z6T/9zS828+pGULfC2VyM6rMDCqIzicwooYfoKkigO3t213Sqty9M9ZEC+XvDNtW71cdiHzQln6C5gpAAxbeVPLfnJBLWIoEatbexGy1NetcydBt1ZyoKV+5eQkUY+7cdKBWERqp6YgOOuFc22pkqk3mn5o5dWmzKmKZbz/Y/nQ+CrvvqAJE7nwtxE483yIRoXhIyWXPmJV0Zo/5yLH/67rgb/5f7EAtihqX4ytMiGOC7E9mpkp45M2qIxKgdEBkoV94Vtj7WimLg//I/sVGK7hSnJHk0nMgjW3peem4kBZge7Nl51/gflLfKpyLVZ+WMuNgj4FW6nx9vLGSfnOmHCrOL+Fhgyka4Xlnq9OgblRrZWZIw==
Content-Type: text/plain; charset="iso-2022-jp"
Content-ID: <A372BCEFD8F71047A7D6EC701857CE7C@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nec.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB3210.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ee56034-1dd1-4bca-3494-08d88795c9b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2020 05:34:27.3401
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e67df547-9d0d-4f4d-9161-51c6ed1f7d11
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iCAXmONqlzkjDzwlz8pHux+LradFiRTm5SXcPVRr/LXS9hhs1AG1Kga5hcPCIfDq/jm5tcRQDHv39kaWnM3Yqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR01MB4235
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 05, 2020 at 11:50:58AM -0800, Mike Kravetz wrote:
> Qian Cai reported the following BUG in [1]
>=20
> [ 6147.019063][T45242] LTP: starting move_pages12
> [ 6147.475680][T64921] BUG: unable to handle page fault for address: ffff=
ffffffffffe0
> ...
> [ 6147.525866][T64921] RIP: 0010:anon_vma_interval_tree_iter_first+0xa2/0=
x170
> avc_start_pgoff at mm/interval_tree.c:63
> [ 6147.620914][T64921] Call Trace:
> [ 6147.624078][T64921]  rmap_walk_anon+0x141/0xa30
> rmap_walk_anon at mm/rmap.c:1864
> [ 6147.628639][T64921]  try_to_unmap+0x209/0x2d0
> try_to_unmap at mm/rmap.c:1763
> [ 6147.633026][T64921]  ? rmap_walk_locked+0x140/0x140
> [ 6147.637936][T64921]  ? page_remove_rmap+0x1190/0x1190
> [ 6147.643020][T64921]  ? page_not_mapped+0x10/0x10
> [ 6147.647668][T64921]  ? page_get_anon_vma+0x290/0x290
> [ 6147.652664][T64921]  ? page_mapcount_is_zero+0x10/0x10
> [ 6147.657838][T64921]  ? hugetlb_page_mapping_lock_write+0x97/0x180
> [ 6147.663972][T64921]  migrate_pages+0x1005/0x1fb0
> [ 6147.668617][T64921]  ? remove_migration_pte+0xac0/0xac0
> [ 6147.673875][T64921]  move_pages_and_store_status.isra.47+0xd7/0x1a0
> [ 6147.680181][T64921]  ? migrate_pages+0x1fb0/0x1fb0
> [ 6147.685002][T64921]  __x64_sys_move_pages+0xa5c/0x1100
> [ 6147.690176][T64921]  ? trace_hardirqs_on+0x20/0x1b5
> [ 6147.695084][T64921]  ? move_pages_and_store_status.isra.47+0x1a0/0x1a0
> [ 6147.701653][T64921]  ? rcu_read_lock_sched_held+0xaa/0xd0
> [ 6147.707088][T64921]  ? switch_fpu_return+0x196/0x400
> [ 6147.712083][T64921]  ? lockdep_hardirqs_on_prepare+0x38c/0x550
> [ 6147.717954][T64921]  ? do_syscall_64+0x24/0x310
> [ 6147.722513][T64921]  do_syscall_64+0x5f/0x310
> [ 6147.726897][T64921]  ? trace_hardirqs_off+0x12/0x1a0
> [ 6147.731894][T64921]  ? asm_exc_page_fault+0x8/0x30
> [ 6147.736714][T64921]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>=20
> Hugh Dickens diagnosed this as a migration bug caused by code introduced
> to use i_mmap_rwsem for pmd sharing synchronization.  Specifically, the
> routine unmap_and_move_huge_page() is always passing the TTU_RMAP_LOCKED
> flag to try_to_unmap() while holding i_mmap_rwsem.   This is wrong for
> anon pages as the anon_vma_lock should be held in this case.  Further
> analysis suggested that i_mmap_rwsem was not required to he held at all
> when calling try_to_unmap for anon pages as an anon page could never be
> part of a shared pmd mapping.
>=20
> Discussion also revealed that the hack in hugetlb_page_mapping_lock_write
> to drop page lock and acquire i_mmap_rwsem is wrong.  There is no way to
> keep mapping valid while dropping page lock.
>=20
> This patch does the following:
> - Do not take i_mmap_rwsem and set TTU_RMAP_LOCKED for anon pages when
>   calling try_to_unmap.
> - Remove the hacky code in hugetlb_page_mapping_lock_write.  The routine
>   will now simply do a 'trylock' while still holding the page lock.  If
>   the trylock fails, it will return NULL.  This could impact the callers:
>   - migration calling code will receive -EAGAIN and retry up to the hard
>     coded limit (10).
>   - memory error code will treat the page as BUSY.  This will force
>     killing (SIGKILL) instead of SIGBUS any mapping tasks.
>   Do note that this change in behavior only happens when there is a race.
>   None of the standard kernel testing suites actually hit this race, but
>   it is possible.
>=20
> [1] https://lore.kernel.org/lkml/20200708012044.GC992@lca.pw/
> [2] https://lore.kernel.org/linux-mm/alpine.LSU.2.11.2010071833100.2214@e=
ggly.anvils/
>=20
> Reported-by: Qian Cai <cai@lca.pw>
> Suggested-by: Hugh Dickins <hughd@google.com>
> Fixes: c0d0381ade79 ("hugetlbfs: use i_mmap_rwsem for more pmd sharing sy=
nchronization")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>

This approch looks simpler and better than former ones.
Thank you for the update.

Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>=
