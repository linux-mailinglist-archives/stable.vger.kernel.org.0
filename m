Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2479C678035
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 16:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232849AbjAWPnP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 10:43:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232858AbjAWPnN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 10:43:13 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 216E12B087;
        Mon, 23 Jan 2023 07:43:03 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30NEht8e000994;
        Mon, 23 Jan 2023 15:42:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=H0XGdP6NLVOH9wQdrt4DXRl+itoTUXmVf4IjgTT07ik=;
 b=vLOhY0ljlbbMIRJHHwVR4sIVcokpMRCHqL8rDkKZOK/b1gf74XokWXiSUsjFjTEUS/vQ
 bWYQq57d1C9KyvIvcVWh7m/4XsPDfdJ5HmRc478XDSxr6Q91ON7NdW2XGoadYETZC/hc
 7Kqz51Hsunh9lEj1c309aMfMezEZsxymHG09h8+CiSeQXFmgYpwdlVTV/pOGxp2q/hQY
 Cc3jUKUttlzjEctFCnH+neST4CH6ASGIwo91p5wU1ZRgifyvaW85Q0koW50sasYKQ5uh
 DZ7KrFCwm7lSl6FjiTN/3/Zdyl+OZ/Tb1LD1Mn4TVGDtdj0AnxNjzqJdNrTOzhQeJodl pg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n87xa320t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 15:42:58 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30NFaPHV013169;
        Mon, 23 Jan 2023 15:42:57 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g36j9e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 15:42:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZJ4/Cf9AsMXVF2iT1je1Q2UyKK5/G/1rWLqOVxrqUTz6Aida/lTqWg5OQkU1iead8fE7h6BwIrMOi+75kuSLF+oVwTZh4VCqwgItHL85ugEHXwAXgFAKx9Pbhy+6J0ImrCNWOyciKyR1ACQ/ity0ZzV0kGBsv+vCrvMfbbwf8SNI5I3i7ZkrS5XBnjbbu500x1M1Wk0L+wIGBANUf46AblkaP+dy3r+10kVVsV78OZbHTa3JVw4wr9Zs4Ht5UXj9h4pXaaRVfr6NMlD2Wk581uyr36EsIXRMWU6AMLZlk2JPl5wAAegPb5l5ko5VPA6ghExKWgmM0WX2zoEKm3/BCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H0XGdP6NLVOH9wQdrt4DXRl+itoTUXmVf4IjgTT07ik=;
 b=feMaa+WKRHAS65/AO4Y/2W4jFHjg81PWL1S9s/OUxDMiPEO0V/5xfHwki2q+T8SyME4kDoPGbgBvpxU88WZQr+hcpdTOeV4cnmi7T4iEAZZPodluR5Ls9aXB9v4Rq4JW8+iuOFXpBm9TJSXxdE5dvzWp0rnWHbU+6a4rvFzM/ezgsZKFXd10ao/8MqdaItFNJpatlPNZGYzGysZfMr/aGZGSDLeBA60A4DgEI6Kl46bHjsHvHb+uWCipm94c92E8gyIwnHiG11wYE+5GkxS6H8QOF4bHM7Qlpc3HJHqYoAiL2WgBUBL0B1m0iFsK3t5dByB6vSoQOlMFBBDg1gRChw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H0XGdP6NLVOH9wQdrt4DXRl+itoTUXmVf4IjgTT07ik=;
 b=CdkEHwHdG3zK2/B6ATG+tveqrq/YMcGaTK1F69rYTvwdTBMCrd5icICRE62nD7/X54kOpOtHcl8+Z4IJv01N62U4/YEzdhEwY4qaIJBsYhMNx8zn5gFMA/Xfp8EWK8Lm0dR0M2Y5k5Yvq5XMf8MfIyx+ryb0c2beHQ7nr43ysuE=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.9; Mon, 23 Jan
 2023 15:42:55 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::d8a4:336a:21e:40d9]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::d8a4:336a:21e:40d9%6]) with mapi id 15.20.6043.016; Mon, 23 Jan 2023
 15:42:55 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Nikos Tsironis <ntsironis@arrikto.com>
CC:     linux-stable <stable@vger.kernel.org>,
        Bruce Fields <bfields@fieldses.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: Re: [PATCH 5.4 0/1] nfsd: Ensure knfsd shuts down when the "nfsd"
 pseudofs is unmounted
Thread-Topic: [PATCH 5.4 0/1] nfsd: Ensure knfsd shuts down when the "nfsd"
 pseudofs is unmounted
Thread-Index: AQHZLz9cSyzG56mAkUSDB/Ggxzvxqa6sJDgA
Date:   Mon, 23 Jan 2023 15:42:55 +0000
Message-ID: <D98E42F0-3329-41DA-940B-4496AFC26340@oracle.com>
References: <20230123152822.868326-1-ntsironis@arrikto.com>
In-Reply-To: <20230123152822.868326-1-ntsironis@arrikto.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|PH0PR10MB5706:EE_
x-ms-office365-filtering-correlation-id: d4cf148b-9637-48fe-66d4-08dafd587ebb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: irUZDq9MyJPX394PBLJE1urAwv31ao8oayorjTV8c5T6vTdlIwfnLeHyFzKbCtzhqPy2atAPF1v07bFw7QUX2+fZhrlRdp/aP8Y6rqXxg3Vb0tNBBbX0kumJiSzZFewC8GnaP9W6LARJkxTAahgf9lBQpd9FCdHZOz6dqpH6AJpuGydsi9iEfqNH0Hxk6lwLa02kZ5EgiT5g5Q/7AOFQe6iQBLD+mef7bB9DVVCV4cApwUc+feUzbx1Ona/rAj0pyK86TcU6FN+YBu7XjZLxOmwbYl9FwPMHt+la2ixwmFh4k7bOhmjB4smoiopBWtN3laBaQQnqkai4bdvCLiQAjt3gdtTN4XhR665GZxPBwcQ20v8aL9MnXSQwIFFVq0VPAFgxaQLoMvw0k8WD+9hj+mXl+iMOEZnTEbDNxFZraoxR/QnReenVUYED/b5QpHPlA0pn1cIH16jzSGXfMRaGBdmeyIoIAJLZv1U3D2Fto0erBt1sDXKRWpNxuQD9GPFa+SLC2Qd4Y+c3PmQHUyyxsmBxqGV6WB3hISceE8sy58RcNI43gCUPqMukWasvICI49tvnCgKccsrowB4SJ1jep5bJDPqX+9mW6CxBzTbq1SwogMw8urxhrUHGxQZ2qYOQ8JzIe0LAnebMcggXt0r8hy3LUbBAucfskKwf1l8KapDsFgRYI4/mP8FWhuUWMVIdRBn89pJIAPXgs9LWKiZunYfu1Izyz+qwxCojCh81hPU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(366004)(136003)(39860400002)(396003)(451199015)(2616005)(2906002)(6512007)(4744005)(26005)(186003)(38100700002)(54906003)(86362001)(8936002)(36756003)(38070700005)(316002)(122000001)(41300700001)(5660300002)(83380400001)(53546011)(91956017)(478600001)(6506007)(6486002)(8676002)(4326008)(71200400001)(6916009)(76116006)(33656002)(66476007)(66446008)(64756008)(66556008)(66946007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PQfZrK+cBblLJjApzboqPSBc1s12uJB+Fcrr41ycOElW4kHkafBMcbvqLpH7?=
 =?us-ascii?Q?kgGDmpWWAohL8Ykqv62y+/on+7W5MnMcQwZlw7284eUgJsoA6YCJvRms0wdB?=
 =?us-ascii?Q?q6JC5iV7J37aXUeh4Wfr8R86gRh51hBe0n9lMXRWpmz9TldjNd+udDC1CI2s?=
 =?us-ascii?Q?6FME/uf3UAmnm1huSdHZz+/reQmnP1j5Eav3EJiWP4pqmcp8YG4vgPgwjtNe?=
 =?us-ascii?Q?DR4TCchxr7MQ9vdDAsgUN3SKHqRzfNKIVlI5GlYxKxukELbHIP+ZCFdjjk/9?=
 =?us-ascii?Q?787gktt3r38+DLlyRimbm6MhOcr6pPmdlLId4sD/rih19Ot9MUsKM9sgza02?=
 =?us-ascii?Q?kxhJqBNsQhf2yVSxSomZTO8BYD3Mf7eQWmLnwMTaxyo+O74VCpar4uHeQk5s?=
 =?us-ascii?Q?G5U7mm0fTCCYjZV5udmw4wEh1wfIT6dwPQDdpZgi1/UBmlH0HS3S2ymaRJLy?=
 =?us-ascii?Q?59fxmvzeHUFBeQYC7+0doI5wsahhh5B4CmCEJsUK2uOxJNCF+Edx+0rqgkV9?=
 =?us-ascii?Q?kESocoq//k0yNm2cPA5gT18tyO7qbayoiO6cvjHGWnxXJCzWknWquwGwhX73?=
 =?us-ascii?Q?H+AgJgX3ImRKme32dnGc+/SbU4kaMn/LuiPgI7XaLDIZtYJZQ50VsmX5hkhb?=
 =?us-ascii?Q?gmnzLAMP7cHhdyNYw710sovQVP/jqdJ3NcEXZ6V0YqS/rnCfFjbvrSC9+C2U?=
 =?us-ascii?Q?vplgzMXwUTpH7nBpIU2DGAnM6QGt2WnHxBKZe80wurLGWyiMfFBvyBIty/L3?=
 =?us-ascii?Q?JGhSzXV5+0HH5/vDIN+8YiUMcHCAMa2rbVM+afEZ6A7zKXN8PmFyE4tKR3Mg?=
 =?us-ascii?Q?Qu/fuu6e4mE+ov+PFEQ+ZMhKQT1miGVcw1BqMD4ktAt2QhJi5elspVNty7iW?=
 =?us-ascii?Q?ZC5cuoHQ47pzmxAkcHHJUlRgb0kgCEZFjxiZ32v+hoYCoV9U2sg0OBhC1vXj?=
 =?us-ascii?Q?i6DGBahlx9OMBV2Oy8sJWILhk6PYg5+/KLqLHsHZ8AkGrAQPgwuqohOvl98C?=
 =?us-ascii?Q?t91IcdtI093jdXNs//inWXjoWLZqqmLu3N+vhT1kJ1+kzrz2bWBF00GvBpbs?=
 =?us-ascii?Q?6FgR9wG6Afu3aijJp4FksTDwpXUmzmqccU03xUU+WoWDILPXPYUnE7m+bh3o?=
 =?us-ascii?Q?yNKfHbxKPihvd5VxFkd5CDRsvCaUAGnvDOaDFzZQWNB+HVhUentaIjvSZfOF?=
 =?us-ascii?Q?jr/jdzWYvx9zk1amv1pSozv8Slu1wKNGsHVkQoog73oDfzbOo6OZc3bsf5WO?=
 =?us-ascii?Q?DG3lDK2MHuRDKA0qcYEX+niTIOOPr3uPbynIEr0KGzyq48gklbBl425O4Orm?=
 =?us-ascii?Q?oc1kKvyvixktbcoRZQhzF1kz4qVKQdBQlHzqX419ZT+kqiwf6qKwXFVgiVXV?=
 =?us-ascii?Q?lJiPm4T/LtFBxKPN3lZ6/NL3rZngTQnvIlVUYzaNXhLx5AkKaG8+lNE2cQB0?=
 =?us-ascii?Q?ZNdttEcmxHJ6Pwz73FEf9jjmCXKmGCg2dFOWG3AZc6TdQ5M1dx3R5yi6ex37?=
 =?us-ascii?Q?Dg66M88u1/g1HOz8UgQMa6zMVtkjJ597q58x6Ow0/U7pGMny3bn95Zce9Ifl?=
 =?us-ascii?Q?ftie8Seq3NQzcBsdjkrIAsQZDXl9nKO1DC97HUHKUc4Pw7cufnhjQdopC9dC?=
 =?us-ascii?Q?JQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <28A136AD48B62D4CB03C5A9B0689CDF8@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: uIqwFBN6BeSRt2Ym+J5CY5w2zFhugoSfG7srCPGVd6XUsuVWklqbaHO+mt5miyGQESO3H4ESlXWDtc/JMbGbQqoILWfLqX+svNDEe83wPshqU9n+DKTq6uoAUf2IwX0JRsnA9XUNC+OV5SqCYobytiTsWlSLA6yuynGyo9Siv1ILEqDUitZ03rHn5WbBmhjhyZHFonK2sXcIy6cQ6cg6wuLexqaO+a4ad3QMEu8jSkqIZrCscYEyq0c/G9tWQ/F1jx7ig038GB0Me3FXlFs3A0vy6hBtsGYzXFhnnmAwfIhm9v8wn61BIVccx8JE61Pwd4OGXjuNr8qbtAzwAcEukZnvjhl/jUIzdNnYQzBDYvWVy0F/I8GhDOz8td9I8+1KDRD2GS2GTtk5jovWZ0nDPwr9Fku5NA23tODSmaTyXauJjwT0JR5AZmw/+TTtYdh/vQQs4oFUBKTQrNwBant7SRW9L+x3cL5lcCQA8EGnlFgsQYEeNvNlNg0eHtPPty1Q3aQn24sWzKh6BTlVLJgUafkDFOjxFd24sQqr7Aq4TOneyNzZ+0cWfvk6hd3mEmhCibhEGTLjrbkuDCM17w0oBBn5uXuhAa4QeMn1ceS5TDZQNeDI/ThNmj7/MhAnxV7qp+DWlj/cdkxN60Xw9heuOJeNK03wxGIaAcmSVXgwQs+pRy2uK/vixDLdASpl3i5qhfhYSDgYGNoOrIxZh7jkpuKAmzoqw2UB6J0W4NSKswqeyOnkopsZ8Wd/YhV3McMCc88Mp4/JQmEGTzNgqkeMlM+qxB8YPhMi8WuOESt7rw9HfkZXKhpvjnlemkbWxLkS8xgrurA99cRkFQayJeOrPDNpLLi8aVXlHtwtMSINxFY9fyH4/EtJM9YSePjb+6O4
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4cf148b-9637-48fe-66d4-08dafd587ebb
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2023 15:42:55.1506
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KfYuSaGcUNgGJjp9BOBnGbRtxYq/8iHbw1E+8L8A3uF2YAN3qM7b49qJaX1vgP1HJ3EwWTUhR3G+EqwIqE4KIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5706
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_11,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=749
 malwarescore=0 mlxscore=0 bulkscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301230150
X-Proofpoint-GUID: Jc8DWXFLzmJ7fFdL7WUKmVAPif4S1qat
X-Proofpoint-ORIG-GUID: Jc8DWXFLzmJ7fFdL7WUKmVAPif4S1qat
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Jan 23, 2023, at 10:28 AM, Nikos Tsironis <ntsironis@arrikto.com> wrot=
e:
>=20
> The bug that upstream commit c6c7f2a84da45 ("nfsd: Ensure knfsd shuts
> down when the "nfsd" pseudofs is unmounted") fixes in kernel v5.13
> exists in kernel v5.4 too.
>=20
> That is, knfsd threads are left behind once the nfsd pseudofs is
> unmounted, e.g. when the container is killed.
>=20
> I backported the patch to kernel v5.4, and tested it.

Nikos, thanks for taking care of this!


> Trond Myklebust (1):
>  nfsd: Ensure knfsd shuts down when the "nfsd" pseudofs is unmounted
>=20
> fs/nfsd/netns.h     |  6 +++---
> fs/nfsd/nfs4state.c |  8 +-------
> fs/nfsd/nfsctl.c    | 14 ++------------
> fs/nfsd/nfsd.h      |  3 +--
> fs/nfsd/nfssvc.c    | 35 ++++++++++++++++++++++++++++++++++-
> 5 files changed, 41 insertions(+), 25 deletions(-)
>=20
> --=20
> 2.30.2
>=20

--
Chuck Lever



