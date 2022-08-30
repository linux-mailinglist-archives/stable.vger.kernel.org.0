Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89EBC5A6E74
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 22:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbiH3UaX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 16:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbiH3UaW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 16:30:22 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0374A54C98;
        Tue, 30 Aug 2022 13:30:19 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27UHtp9d006486;
        Tue, 30 Aug 2022 20:30:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=HZQUgSez5PSi0aCRnyfKq+gLvz9ctCAP1VRxsViwuzM=;
 b=gj0HnkyLduj18wbuT8uz/7lkqCwRSgwOmAErKphPe7f6T9lV8W54kFpn6D4tQuxGkgKa
 /d5hf6g4KQcoNCxeunK2gVc1sO+vNlqenZu/UNenUUGAJTbZz30Tlb7tv3xKZfW5WSzC
 Eli4x0N3JDV8RKlUE3bPNd9VyIb9KXuH/aCLIAv6C+/2Ylmtm6pZae6szkarczSM+Pzu
 ATPSVTDSCodjTlW3AqSWmw5/CthHOjYWdgJqHF+2EQeK5HsiefhyHClTZSA0Ux3Y+mLc
 kg9CQiK0P/ZE52R91oOH2izxVlGlZ3XL8fBtRiBlXfr2zS27AEAX0e7MfzWKnVM4rCxy Fw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j7avsfgsw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Aug 2022 20:30:10 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27UIXVqV013111;
        Tue, 30 Aug 2022 20:30:10 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3j79q4cq81-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Aug 2022 20:30:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SX1CCrkimgBn3jJJWYfjreVw8SpVwEZANWh/F02GTJzUG9BvYv8sRbqt/C90WNyXgzcRo2KUYEB1+xbwIMczWWYRwE18nP3KNYeCHJb4GTBo/3tWvcuE4XWsjG5dS/G3dLC1UkZU2Lf/+rJYBbfHvvsW+DKTN3hf6u58UCTUIezp8/w3nwLKADXb2vP0mY1iSA1MikYJ7oPQ23Q7AijZ1nce7z7smbtR0INmRwnRlsIUrmQfaXiZgTk7Gov3fKuV+5cTe8zcxytOZZ6DKFMpOrtELaiwd4s3pdFxqRfpmpsJS/7dFuiOuDtoNickylrWfqOdIFxUc+xabVa7r1QGDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HZQUgSez5PSi0aCRnyfKq+gLvz9ctCAP1VRxsViwuzM=;
 b=VGLntEbjdBNkKmTKlwvjH//U7geLkKE3UkvoLshwLrQI4mrlUI/gzmmYMra9zyyhY2rOV146PUGiV7Sn+wR34txd0TYNKN/qEC6AElCMoDEOjCwq09fyjsmY/3ek8K6tEPn/vkNCMdeb3TLbK+RYzYx1kCYJRHrQz86tusK1B2zO3YBKtqYMT2YMGyvAY6xrKwUf/bzcWAjc+EBTvqmTqmEWxP/CRMN2IwZbGvdL2iFLC4pjf83ewsTFfXirGpObdLbGaC4n+ZT4nIrrvYzh/eqQKJZBjAgkxBMcr/Ssk5WzIekMWESXdPqNdVmLruC11sgJ4Y7rxIIKNOpuOClz4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HZQUgSez5PSi0aCRnyfKq+gLvz9ctCAP1VRxsViwuzM=;
 b=zSK1EaTDQzXYGSG4cOxj3k7ToXk61W9jL4u76rFcKSBoH2Jsf0yPGFdq2hS/RoWXI+UhoRve768AM/XIFigwVh509I36F99GwJQuLOgu3b4ouqniFpSeUPV8PkzQAOrEGQrksUU2ybTwTtd8NRBP/nQlkg4bqZaTKjQt2NBaaCM=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by BLAPR10MB5281.namprd10.prod.outlook.com (2603:10b6:208:30f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Tue, 30 Aug
 2022 20:30:07 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::a420:3107:436d:d223]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::a420:3107:436d:d223%5]) with mapi id 15.20.5566.021; Tue, 30 Aug 2022
 20:30:07 +0000
From:   Liam Howlett <liam.howlett@oracle.com>
To:     Carlos Llamas <cmllamas@google.com>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?iso-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Todd Kjos <tkjos@android.com>,
        Martijn Coenen <maco@android.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Christian Brauner <brauner@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "syzbot+f7dc54e5be28950ac459@syzkaller.appspotmail.com" 
        <syzbot+f7dc54e5be28950ac459@syzkaller.appspotmail.com>,
        "syzbot+a75ebe0452711c9e56d9@syzkaller.appspotmail.com" 
        <syzbot+a75ebe0452711c9e56d9@syzkaller.appspotmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] binder: fix alloc->vma_vm_mm null-ptr dereference
Thread-Topic: [PATCH 1/7] binder: fix alloc->vma_vm_mm null-ptr dereference
Thread-Index: AQHYu+O+8j78ewjyGUWdeBrLUwjJOK3Hz2wAgAAJnICAAA2+AA==
Date:   Tue, 30 Aug 2022 20:30:07 +0000
Message-ID: <20220830203000.qgv3dkbgep2d6saw@revolver>
References: <20220829201254.1814484-1-cmllamas@google.com>
 <20220829201254.1814484-2-cmllamas@google.com>
 <20220830190515.dlrp2a3ypfyhzid5@revolver> <Yw5nwaNI5ewExYtC@google.com>
In-Reply-To: <Yw5nwaNI5ewExYtC@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 76c7327a-086c-4dfc-bbe2-08da8ac66da6
x-ms-traffictypediagnostic: BLAPR10MB5281:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EMvdUvEbdctmHSAX9IiZdC1f/Ukhy0cOQHfpA2sbM6A3gkoiIXqMEHt0BO+eiSQNI6tMFIN+u6zRmbsKnbyN9Qh87kk+h5Na/CT9VPsXCXCOqaT/LLtiX0KnKHgcmF/gFnT1DIa/qwMKyd4vePZYF496Z9c7pI3ZnSi+e2wdtIN8JX4leqTCmLcVDc31lP09m+F+J/sxmNJC7Yl7jW5OsvHjsfkyazpQ5zsfcvKQebkD4nRMp83ehfg4Vt56cyDLonnAvmLGxF00w+BHFrVB7FpKzI+OsHyt7ptgk/saErNeHuzcwSM8A9Vv088A5xIDTM9jS8EVvX5rPpjz2zg/vCgg7ZeDnPu7rGfbT3Zn2jSst386plZ+chb6n2s8jeFHZmO9mBxKBlMarJ7k9h+pJXMN2USRH0kbW81JKorizGd49nPxB/aqxYNWNY47E8U0o68ev00U+fp7kgAF8my1ApvOP0n2gLyfa59oPobbB/jMMYVuO4jXuIhfvgH8Gn/bnrrEFgSmt2f4h1z8vK7/ACVZTGvKl2SjW+zoXvAopz8B7z314f+bC1Xa9iMZrituTy9RfgkxLyzSW6HRoNuu7z7re8813is4SNmwitYi+3kV+6ZFXtukKuSjuJPtkre0vC0KfGLdbIf9sfDc77PcFASu1GryRKAqNzhGhF9cG/LPC9Z8ecyKtY3tBdxDBmKbYO10X32hyjHyfLfjbdAQTZn3KOfpdKPIXgYOq4rXN+/eRbVW6aKdYKQx+bQXTagU1eYT+p2m5meYFixGg6ZbRw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(396003)(376002)(366004)(136003)(346002)(39860400002)(33716001)(44832011)(38100700002)(6512007)(6506007)(122000001)(9686003)(2906002)(26005)(1076003)(186003)(71200400001)(83380400001)(54906003)(66946007)(66446008)(4326008)(8676002)(66556008)(6916009)(66476007)(64756008)(76116006)(91956017)(6486002)(86362001)(7416002)(38070700005)(5660300002)(316002)(8936002)(41300700001)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?Pd2hKYx0ppbV7Jyc7U9IWjOVEigD72KlqdPgLvshV1hT7YxQWHmzntk0JM?=
 =?iso-8859-1?Q?IB25sbaAlfi4TKkMa5zgG8vUo8tPysBXyXz2E12bLhDCypzAeguqfvKmL0?=
 =?iso-8859-1?Q?Z9g4fsZyg9TFgvJN8WyZkxW5fSPeSPOy5DHEcFaXUO4sf0Afrp5ndocwo/?=
 =?iso-8859-1?Q?yk99g/DKAmemqTHvWrrIjoSRTm+i53r2lBsBnFbQzaMaaZe7KxiPikPrBs?=
 =?iso-8859-1?Q?kYr9v0jFmMdNu2R3Om9w3RzvJjSwdBMQn8VMNCWlxc+4bBjnxGMfUaWMZn?=
 =?iso-8859-1?Q?gQeThYoF+7Ije0295zsIeNjB7YF5HaFcoXW6o70vR5uwMPaEgRjz6i2vmT?=
 =?iso-8859-1?Q?e0b/ZCw4F9lU3wGkIKX5wB7lSiqxzwsXnG22+sIDti0wbQIUyFMTexzB2O?=
 =?iso-8859-1?Q?ekbyN4meZ2UMQfWpofurGElPh6JU4Ga+Xlj3AP3mTv+pjk9FeNZy5SRyGV?=
 =?iso-8859-1?Q?pD9ExrnfJUBjTfopRF2NaVNzaPsSAz6GjICD1Aa4jt/kpjSKjNpiTpgZNI?=
 =?iso-8859-1?Q?37NbTnSbcdMn1QG27lvMLULQOZfgq2S2zoYujVBSp2iLo0tVGWoLdqQTbM?=
 =?iso-8859-1?Q?QjPQos8b7H16JF7GoL5yAVeFdjf/SfuJBnzgf0PehyMz6IxAUFG7v7INWD?=
 =?iso-8859-1?Q?WxMKTH4fwrq/1f3V5PnJeiD3R8zk4hJpVTbZfVxoMSO+mysJ1P//lbQYo7?=
 =?iso-8859-1?Q?D+KLXT22uTcej+6raRbxmBqbwRaoEU9X/0WEwhbmwcrRMDZAoD3F+RIBa2?=
 =?iso-8859-1?Q?7ohsdVzfv1UUkUwOGiS9peaUag6t88fa+ArZR49Hy0axXK3qPjpYW3BRHE?=
 =?iso-8859-1?Q?/TTr4yrM0c8YyPThecOCTd3xZDyci6SPxZNEZjg/4jpWUhkmDE+ZYs6nZh?=
 =?iso-8859-1?Q?u0QdlYGCf3QrU12m9IHDOmvMW6l8s/E5HXxDMTVzlPBJ/I49z1trl7H0FD?=
 =?iso-8859-1?Q?nYr0BOI5B/j4VKzM8sLPEjgHAfQp1xDVNFfkvRUwDdt9UV/UJZZuX2k4PR?=
 =?iso-8859-1?Q?Y9C4cPC0gnj3DFWlG+eqYs98QwOAilC/0vp1eL9aPii3ANDhmtL6aOYhkO?=
 =?iso-8859-1?Q?sQIjFAaJz99tlbL4ZBeFMLXVmVEphPeKmGlD4uhAh2/Az3TqnolFG7y4Ck?=
 =?iso-8859-1?Q?8OPTQuQ9/jcDF4ZTfyefYzDBqSgz2wYqe3JL8rvhGCg1kRgGr0h5qfCMEH?=
 =?iso-8859-1?Q?vIFEY41TUbMazqCfJHDL3knPuliJWYyzWZptLD2Hnu2Qr3XfCkqiri2714?=
 =?iso-8859-1?Q?RKBJ2srKMrEo4rTx8BqVF2bNRcB5C55E0h25Ne0a1bxf2Ynu94wcbNLNFt?=
 =?iso-8859-1?Q?V62pnJgmzQVuQJs0+ZfPFmh3BwRVs9d6qIL/zG9Ne1ocP/DTl37Kxm6gY1?=
 =?iso-8859-1?Q?a+lM/8JuUxz7SvCvLTV/5isZ67mrUdPKqESmWvrdGZ1eJ4owAB0zRlX4uG?=
 =?iso-8859-1?Q?ocVwYqOgAsqhnmUX2TwD01VXsAVV+kztI9r6DP7Uf2LDXE7c6MtCc4H3pV?=
 =?iso-8859-1?Q?Eap/05sL0h9a2iAdAt6N5MyBSGl9sGWE81+IihQ/AhgFnTa7xWqHJZNPvQ?=
 =?iso-8859-1?Q?ImeL314NZrJwUIEGhWtAbb0L3SYBL7nvseN9fubd6Chpa4IEEB4QOPUsPK?=
 =?iso-8859-1?Q?YrB8rClwcy8AOCB92iUO3qJ4BhmZTX/NqM5jQmAza/a5uPdIbnIWLNFw?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <C16BBB581CA9C64BB400E4E701653FEA@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76c7327a-086c-4dfc-bbe2-08da8ac66da6
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2022 20:30:07.3835
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1CF2am3g/WBat5T3JSHl5IuhbWnyRBJc6WCX611xF7YMRExBeYtxhEreiBk2NhuQKErm4nZMFcRfC+KiU2jgCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5281
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-30_11,2022-08-30_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208300091
X-Proofpoint-GUID: 4WQR8FMWj6sgAbvo58Q0T49ibDG7hh73
X-Proofpoint-ORIG-GUID: 4WQR8FMWj6sgAbvo58Q0T49ibDG7hh73
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* Carlos Llamas <cmllamas@google.com> [220830 15:41]:
> On Tue, Aug 30, 2022 at 07:06:37PM +0000, Liam Howlett wrote:
> > > diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_=
alloc.c
> > > index 51f4e1c5cd01..9b1778c00610 100644
> > > --- a/drivers/android/binder_alloc.c
> > > +++ b/drivers/android/binder_alloc.c
> > > @@ -322,7 +322,6 @@ static inline void binder_alloc_set_vma(struct bi=
nder_alloc *alloc,
> > >  	 */
> > >  	if (vma) {
> > >  		vm_start =3D vma->vm_start;
> > > -		alloc->vma_vm_mm =3D vma->vm_mm;
> >=20
> > Is this really the null pointer dereference?  We check for vma above..?
> >=20
>=20
> Not here. The sequence leading to the null-ptr-deref happens when we try
> to take alloc->vma_vm_mm->mmap_lock in binder_alloc_new_buf_locked() and
> in binder_alloc_print_pages() without initializing alloc->vma_vm_mm
> first (e.g. mmap() was never called). These sequences are described in
> the commit message but basically they translate to mmap_read_lock(NULL)
> calls.

Ah, this is unnecessary with the rest of the change.

Feel free to add my reviewed-by if you want.


Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
