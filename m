Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3EDB41DCF8
	for <lists+stable@lfdr.de>; Thu, 30 Sep 2021 17:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233672AbhI3PJT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Sep 2021 11:09:19 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:11188 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232957AbhI3PJS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Sep 2021 11:09:18 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18UEMRDY018050;
        Thu, 30 Sep 2021 15:07:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=tNeu2buj+sEr8TJQOAHxOZFU+LPPfd7OnOhd4dl7efg=;
 b=N1svIA+NsrLTeh4WwNO+hDIYIQz9WEnG91cLci/whCgyIdOLj+v5JcT8mo+/VdYXoUMR
 yVagN9bzFHIF2F/2MMubixOTWLuB4LgUeiLNkqj0H3Ru2pGLX7V55nvRNWMjjAFJ1/r0
 TczqdCt4oZJhayCdk+HxwBIb926iQG42RzaRRT8mddcLbEecJEKU8lJ76+gu6XznhcCb
 Q3DFr6MLHlwSpTYzZj9L5d7dkm00dQ/sZBGTo3Z0zGvwerBWaRUSkKuLb8Wr180DK5e9
 jWpo7UB+JQ+DLXwV3zKKswDkAApcc5NetChH+6P8tOHnitrJ5cn5kgpZ6TjywpewBI7h NQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bdcqu9cb3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 15:07:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18UExntw030535;
        Thu, 30 Sep 2021 15:07:30 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2045.outbound.protection.outlook.com [104.47.73.45])
        by aserp3020.oracle.com with ESMTP id 3bceu76utv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 15:07:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bu6YXyz118zJ3phy2warnAyvDGYYoRsyQVU6jXOaG7WR3cNT7KIzx8W2JFR3cELdN+hpUJkHfArqfxpgjfzHnEzpvvnxcg1VYSbXrTKYwVJdbRdoHyLOVMnxOZw9dJeJEx08m7hukt2adc3rWHNex2Dk+7UO3uVptLojAM0uuZXYXL01qeZMFwiid+EjFHniLWV96wtZH+CjRtwiQiRvsKhLVfPhQGUkeqoclC5Q/9t1NtbB/U7c57kblt8Lo1vvIKp8GHPRx63bG1u0uZUM0R+8PhioHXlMJ9lVVq7Knej/irW32Wnd6oYS+PQ4hcqX3y50/9jdqngYeH60GJ51pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=tNeu2buj+sEr8TJQOAHxOZFU+LPPfd7OnOhd4dl7efg=;
 b=JG5Ys6c/0eO+WIafg+AFSYFiWHiM37oNBTCocqsb3lk3ZX5HwhHtaUV2H7xi/L6e0QQBHcjr0Gl49zeSwMvwveC0stdmbwFN8tnSSr7ufk/1Tk2/ytIZlUg3XAOozohG5rjAz3DcfjkOcwwr5QsViPha1mUEt+iAAqOc1kuQ8vQbx/onEAMR5u2Vm5gxgaFt5ujcCA6xjDxIVs0SU5xun67hyIkrXkUZwVAQ8E5BVintcoGswIzRyAJOOXQdpsGSo+GNTPWmc0S9IsD+2nJHhRWHIfUmO44xlfC2OA0HMgYnh395yaUSnarkEfswDnyVpiVg/3lK5bwiJ9TudsCC4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tNeu2buj+sEr8TJQOAHxOZFU+LPPfd7OnOhd4dl7efg=;
 b=uGZapGSvZInwRgQ98yCxyzeXRIS191XOEZK83NePAu+GXG6VUX8oLOyWbCyuGLEu/jtjZ3ewhx4Kjw2MwTzXW4bHgJgBq+TE5hQvXgXsIWDYo/c9e7WIXFh2+k532iDs4+8hKZA62tFLNKxjnUg2UFeBuEuNesGEr52Dn5aghvc=
Received: from SJ0PR10MB4688.namprd10.prod.outlook.com (2603:10b6:a03:2db::24)
 by BYAPR10MB3605.namprd10.prod.outlook.com (2603:10b6:a03:129::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Thu, 30 Sep
 2021 15:07:28 +0000
Received: from SJ0PR10MB4688.namprd10.prod.outlook.com
 ([fe80::f4fe:5b4:6bd9:4c5b]) by SJ0PR10MB4688.namprd10.prod.outlook.com
 ([fe80::f4fe:5b4:6bd9:4c5b%6]) with mapi id 15.20.4566.015; Thu, 30 Sep 2021
 15:07:28 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Bruce Fields <bfields@fieldses.org>,
        "Ho, Patrick" <Patrick.Ho@netapp.com>
CC:     Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] nfsd: fix error handling of register_pernet_subsys() in
 init_nfsd()
Thread-Topic: [PATCH] nfsd: fix error handling of register_pernet_subsys() in
 init_nfsd()
Thread-Index: Ade1jt37NNfgpkRySiiZJ5n/Oif8NgAdt90AAAHJKgA=
Date:   Thu, 30 Sep 2021 15:07:28 +0000
Message-ID: <F04E6E6F-E01F-4F0B-9F62-A3579BA0EF89@oracle.com>
References: <SJ0PR06MB8327D188504E0F367C8B4E53F4AA9@SJ0PR06MB8327.namprd06.prod.outlook.com>
 <20210930141620.GA9422@fieldses.org>
In-Reply-To: <20210930141620.GA9422@fieldses.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: fieldses.org; dkim=none (message not signed)
 header.d=none;fieldses.org; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 13de9415-5b92-4820-cfaf-08d9842404f2
x-ms-traffictypediagnostic: BYAPR10MB3605:
x-microsoft-antispam-prvs: <BYAPR10MB3605797CA5FE3D926B75870F93AA9@BYAPR10MB3605.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1388;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zkvIBzICYXx/T9s7yonPcNPLtJt3kQV8wpBUatdNXkSnbUIuVYRgB3I15wvqjw1xg/LDeBxPxNEdW7tBnw642ZdnznsKPWY32dgxnw1DzFY0fztm9nxjbKsZ1KYGeH4dI6XDKRZpg/3PyLZ8ag6kZbTzNzugaGy06H9N0/w62dviCOdMAozlb219AtNbN8evfGWUBKyHAgVYSl4mBAoD1ylumj0EYIjH17o282KPEYpcpcOk5nS9s4N14875WnECRKOgjwCvEKtqLe+PNLvOF+BBS3CxTow31450smgMngjmuzqKIez9a0X3fhdW2WcCuAuoQLk5K43iw9t8ptMQSt3aPXnTm3MEL12iUh2BZ6V7hk3FBh5zWEY7IT7cdt0kguHl7Ux8W6v7LdC7H+SP/QHyDw1KUjPbiVL9IPs8gQZ0C56Uud4IPWxlGOI0DgijwMXeoKouYwc6baZnHkCJZAYs2qaq899MfzyKMHHz+FpwMu+ajO8XMCa8BJGZpLlAGvJL7KoKHwvZtGb8goYAW9r8e1h+UBt/r9ae52HPEHpgO3yLuX9Sn1AbBYO9qlLWocj2NEIwWKipGdkd6Vpq4wKm//y1xqS90PE50IExSiMFAjZNCPG2Pmk2W/XCSA/iLPoaBbnTtLI5Km6BFsmythe3tL0wBcRTK1oO9OuoM2naoaglwFHog3iSXwTadjPuJLfoPrrml9RKQ1F9TAC8Nmu5Hu/PDSStESKf3qLgiXjG90aNzPlMGYcALBj3IQHx
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4688.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38100700002)(38070700005)(2616005)(86362001)(26005)(122000001)(186003)(91956017)(66946007)(71200400001)(4326008)(8936002)(53546011)(6506007)(83380400001)(316002)(5660300002)(36756003)(6512007)(110136005)(66476007)(66556008)(64756008)(6486002)(2906002)(76116006)(33656002)(66446008)(54906003)(508600001)(8676002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZhZvW2yUkc3YWs61ljAYJJpgiAvr6/SPYAazJT+Bpg0K1kx4nte7JaHXUASG?=
 =?us-ascii?Q?++Vu9t4f2QyFsg2IvafzNFPE6MCtbYj/tBhYfeA8BwK+FsAN3ARkCGIJ1bkZ?=
 =?us-ascii?Q?logqq5aBstprGLdIFw4OmSzBRViKsUJC1+bFTLFQfgbQJIDwz1Mp9plqUp6w?=
 =?us-ascii?Q?YyHwh6YkSKGHfbIjXKG1t/Mi+Dst7I3UIpqgc3HwYHxBuNxBKQaikVsXa/0s?=
 =?us-ascii?Q?D2lj5DeKC4d8tDRbzi/OArwf2WHhCqMZBfSaP0v5kva/7UZbFkWPLsT2UX9P?=
 =?us-ascii?Q?fAB5Ael+QBubQLMAns+7aTd0vjPJvdNDsUmaJ4RfpE2pU61qxGa04wGx0OMI?=
 =?us-ascii?Q?hb/6k5o2OEmVRXVE2nXhHY+osrcK6gg3JNHSqX7Z5uWTNIECEVM/iOFKdPlf?=
 =?us-ascii?Q?31IwYaI+HrCsPNPSJ/2bdg8uKWY4t3NmMOik8YuVEiIYIHRlsuzLciYAfd5s?=
 =?us-ascii?Q?Br0UCHeah1rrTjJyPV4emdJpUChQGnaCBKbxaa6kxsEuk2khVQzXpVY2Rri5?=
 =?us-ascii?Q?xZ4oLyG1CfNyPL9cylGuQHbGWFEZ6jD8s2K6W7QaCYBW4Y92iPJ3MO7NuUUV?=
 =?us-ascii?Q?xDXe69tMiA900u0/fKQRYcr8UIh6Lpjl35vNKhBrjl6lLhC/QXtXbwtPdQF7?=
 =?us-ascii?Q?WUFBXRIokrP1Qa9WKci4K1xU4NV5J0/8x/TOVz6wUXg37zXy1D0th4vd6pP5?=
 =?us-ascii?Q?C/59/e6BkIa8Ep/nbvhpd22IkFy3oDJj62QDox7DupGea7JZaDsxbTZa54oj?=
 =?us-ascii?Q?5dy82QpqNkUz6+19zgdcfGYvlFnYPkyYQdAB59o7knD8heyd9GLqlpdFtzJT?=
 =?us-ascii?Q?JcihmVR1kuihpYuuE09tC6HxOxfJZbaO7oNgO3XmSLZiLg4LBwdOMuEd4UJa?=
 =?us-ascii?Q?FSW4ab3dpPju9B+hcGWIuHzL4PUEBNMuKQa02QgPkjWRti7p+wsvcY/1Bl9V?=
 =?us-ascii?Q?pMtdHKRbrY4Pz6VINsIIlHjYuHOpKQl19zYq8J0z/OQ2BSat5DGybneUuwbP?=
 =?us-ascii?Q?HYcpO0j081Aea6lisZ1fEnJKW0RekG53YFUu0gjXaYgpb9KVVRSKKkI7DYb5?=
 =?us-ascii?Q?0890WXxU7A9B89gCEI1YdASqaJKedwsMkmvsHabogh+5pw3Om31tqlG7W3w3?=
 =?us-ascii?Q?c4YhnLiZq6zFGlA7MkXZGzM5DzLu8ost7bN2buRrq0n1iJ2LObhPQr9dgF0T?=
 =?us-ascii?Q?6ehP81RoxLQXQVCzGiGOa38QNSUKmeisdqhzs07iohlXHh9OS5TwqCQnJ5BJ?=
 =?us-ascii?Q?GRK5eFq5geMxeLGWt9jgzsat4y2PKtWJYI2QiufdX3Kvm9aY1ZIitAKjQrzL?=
 =?us-ascii?Q?1ERppOP4eU2h20sMUBKJFrpC?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7A1947EB6AA2DF4894A2B026633DAC95@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4688.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13de9415-5b92-4820-cfaf-08d9842404f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2021 15:07:28.5978
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 00rsSWatXHGbbT7FODedayc4zu1qBe3/ZVHD7c/+BU+DQ3gwq7tB1Y3jiL9dUpzohOLjmovMGR0LnP4TRlJnwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3605
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10123 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109300093
X-Proofpoint-GUID: uGfIxQOG0zV_BaRkALie_CBlTAjGr478
X-Proofpoint-ORIG-GUID: uGfIxQOG0zV_BaRkALie_CBlTAjGr478
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Sep 30, 2021, at 10:16 AM, J. Bruce Fields <bfields@fieldses.org> wrot=
e:
>=20
> On Thu, Sep 30, 2021 at 03:48:42AM +0000, Ho, Patrick wrote:
>>> From 7417896fcc7aea645fa0b89f39fa55979251dca3 Mon Sep 17 00:00:00 2001
>> From: Patrick Ho <Patrick.Ho@netapp.com>
>> Date: Sat, 21 Aug 2021 02:56:26 -0400
>> Subject: [PATCH] nfsd: fix error handling of register_pernet_subsys() in
>> init_nfsd()
>>=20
>> init_nfsd() should not unregister pernet subsys if the register fails
>> but should instead unwind from the last successful operation which is
>> register_filesystem().
>>=20
>> Unregistering a failed register_pernet_subsys() call can result in
>> a kernel GPF as revealed by programmatically injecting an error in
>> register_pernet_subsys().
>>=20
>> Verified the fix handled failure gracefully with no lingering nfsd
>> entry in /proc/filesystems.  This change was introduced by the commit
>> bd5ae9288d64 ("nfsd: register pernet ops last, unregister first"),
>> the original error handling logic was correct.
>=20
> Whoops, thanks for catching this.  I assume Chuck will pick it up.

Applied to the for-next branch at

git://git.kernel.org/pub/scm/linux/kernel/git/cel/linux.git



> Acked-by: J. Bruce Fields <bfields@redhat.com>
>=20
> --b.
>=20
>>=20
>> Fixes: bd5ae9288d64 ("nfsd: register pernet ops last, unregister first")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Patrick Ho <Patrick.Ho@netapp.com>
>> ---
>> fs/nfsd/nfsctl.c | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>=20
>> diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
>> index c2c3d9077dc5..09ae1a0873d0 100644
>> --- a/fs/nfsd/nfsctl.c
>> +++ b/fs/nfsd/nfsctl.c
>> @@ -1545,7 +1545,7 @@ static int __init init_nfsd(void)
>> 		goto out_free_all;
>> 	return 0;
>> out_free_all:
>> -	unregister_pernet_subsys(&nfsd_net_ops);
>> +	unregister_filesystem(&nfsd_fs_type);
>> out_free_exports:
>> 	remove_proc_entry("fs/nfs/exports", NULL);
>> 	remove_proc_entry("fs/nfs", NULL);
>> --=20
>> 2.17.1

--
Chuck Lever



