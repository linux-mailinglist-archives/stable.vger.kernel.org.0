Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 047D35A6CC4
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 21:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbiH3TGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 15:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiH3TGt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 15:06:49 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B100167440;
        Tue, 30 Aug 2022 12:06:48 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27UHtkJG000517;
        Tue, 30 Aug 2022 19:06:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=APfnwWKhwxxT1Yqcq0Q187miBWNUxSU5HVPJ4WA8PeQ=;
 b=HjLj0G2OhilJkVQM58yF/n+O2LlEObr2YI3X6Nst5q8eOV/+obahqgoyc1IKvrVFoL3+
 hZFwzUpWQK1LeLTsQtyUPdAxeBqVBqlaelQ60OiXb7b1mEe6ac8mEfXDw9PnW9tkIEAL
 n2p+9z6LFW7BFxVUMmwgcNQSkHWarzZFIbsYAITwAaiOuAG8O4u0KNZpSjPOcM7p9Ro1
 79TU5sn2YED46yhoKSdzbqvB969j5Ib92YR2ccUhb5FfnjfZWWhqDJ6/c2xbG/gflare
 oRVaY51XIzl6VRqPFv7OCIr2bWyBd5Y/1E/RBL0Kb7pJeGgdoIaUA+5F4N6A1SSmxnKH vw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j7btt79w4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Aug 2022 19:06:40 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27UIXXK7036086;
        Tue, 30 Aug 2022 19:06:39 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3j79q4gy28-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Aug 2022 19:06:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VJSW4MEwZyZnv4+GFvsmHjZG9MyuADPVKC1YdZCWfVz7CfbQqySsPccwiPPu+DVu094956DyLda09XwHCmuEOLVbsI4LPfS0x1ACvatkFdlaKOWJhHshT6WIyJqHDIaMwXg64z7bwtGwhsY20AbtvOtIom5IKJjRZXzEXyensATKIpdDHqreroBJ6TvuCyr8nW5ceDRO3ToMuAx8HhkCdssgThiKSTNZOxpaoYzJbZhcBtvDt7Glt7d7Pu2EWkZqG6S/EXasppxR9l8+qj73lEwoDvsqmHOJGJt1mOwevlROqUDli975wQuJmQyvcXiWOCxksk+VGSJFwv4XjBmLrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=APfnwWKhwxxT1Yqcq0Q187miBWNUxSU5HVPJ4WA8PeQ=;
 b=Dbe+A5T+9+g6rCtDmefswXUeDW9JYkx9UUS9T45iYrC2dE4xIir8gj4FimH+t5F117sFHCXQaZW/aVa6Dm/OK0bERBbn2OLBt7uVRrOEGTFe9WzfUI8D5sIkc1IeIXaXIvs4oPTnFPkSQbrYR88GRj51M+jcJ5SrerOk05ncnyeH4vnCzsjlAat2vEBMD+Xuif9N9KpvhA2uZ5PJ71aS/6bqrtn4t1CyS2Hunerl176yxR60r5Vvc50P+1DbYpfaj6wlFKWfxj3ecNf3vGnZibssyz4yu2Q83kvl544ASPv1oIVUnNyUtnJhGSR0PLt/0qL3isQTtfVNwUChLiknjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=APfnwWKhwxxT1Yqcq0Q187miBWNUxSU5HVPJ4WA8PeQ=;
 b=iMlNlSypeUu7qmUD2OYb6/DJCkQfty5vps0ScXwg9haUKDZaijtmRW3Ey41hVsBQpWfZGRkI8zy8aV9u+5ukUudv5jcaGMYy27uJOedzdBAJpN4O6DKwyT+jctBkoGDvroou5aTH7/86Ln3zglwP4J8edSJ+ZcIVpNyjBoHdj8c=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by BY5PR10MB4322.namprd10.prod.outlook.com (2603:10b6:a03:208::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Tue, 30 Aug
 2022 19:06:37 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::a420:3107:436d:d223]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::a420:3107:436d:d223%5]) with mapi id 15.20.5566.021; Tue, 30 Aug 2022
 19:06:37 +0000
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
Thread-Index: AQHYu+O+8j78ewjyGUWdeBrLUwjJOK3Hz2wA
Date:   Tue, 30 Aug 2022 19:06:37 +0000
Message-ID: <20220830190515.dlrp2a3ypfyhzid5@revolver>
References: <20220829201254.1814484-1-cmllamas@google.com>
 <20220829201254.1814484-2-cmllamas@google.com>
In-Reply-To: <20220829201254.1814484-2-cmllamas@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2b56a364-cc48-4d26-6c70-08da8abac34e
x-ms-traffictypediagnostic: BY5PR10MB4322:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dI9ON/rSUFRWVx9DpRpOonnKKKXWRWEiJWK3uwOjUeZsBKm7nURurrGvgGTnpyjXEb2WUd9i0uIWUCa//KN/oKtPcfjRngxbxAHBvzUZloTX1JargVnzy/k+Ma5g0LhvKVocONHTsTwWmID3H8jUt/hwqXp4kPW7egu2xwl6ahgrl4Koj61LF5XLjbjOYxtR3a39ZiUHtq0dulpSCZ2SZiy+y9ujjdBoc24+gHXI0PdEyECahLYAsqtaeW37u8PAfExE/kA2ATtnbsUeWB1GEkm2QvA5yebRNi0S6ddR8nngsZxAqqCepPv+Exycu/5kCH4SGDynZQl7TXXHs7VQWAgS1ku9cs6DQwPtaG+G4ZCttrPa1rGrtacaJnXxfOVIQiQ9CAcIG5hst8fP7E8gbMU6SfV3Zjl+HU6ASBKK/xHPSFbqdgmYWfNSDM1v7kaVIb/VKhdA71lwLyXiKHSIFRIJxEepg9QrlOMrfyyOkhzSeT3WRrEO/7dUEiLeBhZI/4/JZYLjmcxQcpBavhZxtA7XUkn+Vu+Up1sfuX1eXU3qSuGvqQ3Yo4gs8E+t4O2hFpIcb6vwUWTlZb2FBrKia9EkKY7Es1SLBYbmOf4tArgeETl8u1EENIHevQxhfVB4G8acdSBQ6n2u/ia4ADzyxScolK2jRmgLsecoOeVTi15mjWRLKf8PnrpfH/QHLsxNUDEh5Inq9fFE5RQukMiemEdXFYwH1k8PWTK7PAhHdb3VAKzSN0uz58i8CKofumnIMQAdJ0Y8E4z6mb+VAjTHfJnOGI5amm5OWOxOxrx6q1b1mmcAp+OGJoUQOffKWFUmAUBL1W8OW8S1K+DGImeX88vRJa5iuSwVu/+xdDeGwbs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(39860400002)(376002)(346002)(136003)(396003)(366004)(186003)(38100700002)(1076003)(122000001)(2906002)(26005)(9686003)(6512007)(6506007)(86362001)(83380400001)(33716001)(38070700005)(66476007)(66946007)(66556008)(966005)(64756008)(66446008)(91956017)(316002)(6486002)(8676002)(478600001)(76116006)(4326008)(71200400001)(6916009)(54906003)(8936002)(44832011)(41300700001)(5660300002)(7416002)(99710200001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?m+U/4mShI+ZeqeJRyx0y3/2t/6rSwEtvLJs1yVw+RA1trU7uUQ1d4g4WDH?=
 =?iso-8859-1?Q?YvZkJ6OcrAe6sjrbgVvxafEhdQqVNcW6Ngg4WMaleJaEGnACPbf1raVF0m?=
 =?iso-8859-1?Q?tusHhNY1UBixVhGstJxLqySi22tBPUAEmHNrEVtwy0khfRoqDMvXv5mMgL?=
 =?iso-8859-1?Q?Hwiejf2uMYZvN2v0O4SZy54q3sL8XyNambzdm/mua3xRo2PwXTrG/MUGNh?=
 =?iso-8859-1?Q?oylQPmCk0VuPl7prDi+omFIBRc10UlYKQt2oiMIZrZz2SuvQ7eaeWM/+EV?=
 =?iso-8859-1?Q?EwBtAiWuReBd/OtZufryvljENk8oZ9Q6lLVL+HG0k9toXs1MaNyFbf7Vu2?=
 =?iso-8859-1?Q?7iCCx/U3udBH8WyFTim7GIGumqSVMu/5OvvT8xgK0KGZQh7VI67jxTW9HZ?=
 =?iso-8859-1?Q?/Coc1BlpDXfS9cni5lIYIAgWsu6hGhWUoMRcPUHuCGLKEWtkqKhPZ9FGTX?=
 =?iso-8859-1?Q?NHN0HpKiUdvp1cJmhuaWHiy/spo989phjMGwy1lhnPnp5hyYlFVuMP6dyB?=
 =?iso-8859-1?Q?msMnX07F8x/kNGWOsb0VVtgBui27Gk5mFAUNUIxPRXE33RNjDu9NI7slCm?=
 =?iso-8859-1?Q?mggljI7hzXvh6K3prMQiK5dYdW/xjPtNNphOKKBkQjDPOzgIp39vj0QHVe?=
 =?iso-8859-1?Q?uVqbuuogzm0GzMVFnFsJPl6pxFP30kJCFKVCgCAMytCah9F3UX9UMDMfGK?=
 =?iso-8859-1?Q?k92imW2qsCB3vnH2ihzhOPF0clY3CBe5oeKPxXd4MRG99FOESEU2ncF7LX?=
 =?iso-8859-1?Q?4EP+DVxBmkPFg8wmwROBZSgY9HQF/PuX3C0Su79m/kH83Ypn1XDaA5FC2s?=
 =?iso-8859-1?Q?0pZ399BK+cWRXP8I3J3odmOU4AbYjP0VckxuvURGvKOVY3rdefU+9CdiCQ?=
 =?iso-8859-1?Q?l6G17ouMoBRSwW1wQFryRWuohuruHdHnL7BUmNLM8ZGG2bxZyRtt9c3NUU?=
 =?iso-8859-1?Q?WR0JyyKzCFmlr64/6eac6/O/twVWRaAfZPC70vOu0S2BsGj9LLknRMFtJ7?=
 =?iso-8859-1?Q?Dn4kJffxeosfH59ZVcU8GUni4Ik0jY76MGoeagJ96oW1W7VE+RfNqHi83B?=
 =?iso-8859-1?Q?KAY+4NGVjMaiJv6q9YczCGyGGPfmeLuwK++I8z/Tqohfntra/mdN+JcIvB?=
 =?iso-8859-1?Q?ffc1YKiNtp5K8YBOyRrwfTtncQ5N2nlgVSkFQHGMasdsZ0fKJbhLoDVVRo?=
 =?iso-8859-1?Q?mbTsu2T7oL9yF0+reZ87GDHPbcfFvKCKhmKYxmog/uYe51uAHe3UbJ2//x?=
 =?iso-8859-1?Q?nbG20XscPfxdeknIZrYoELXvp/olXyQPE20uoRww8MJ+kyQznaKZb6F7g0?=
 =?iso-8859-1?Q?cEJP22ZQkbcPY89/SYxwR3iknpXTXFULblr+o5l/l/Ngc9+ZT54zZtB4ZW?=
 =?iso-8859-1?Q?HPbfIij/XOS0adWWQs2mg1/zEvKY4Sxzq0EigESywwkBvlZ0GI3VMvd0sd?=
 =?iso-8859-1?Q?BFv9p2tTp3p6Gv8Ganv8i7IAouPrMJYwfHcCcgE0PgeBMOieRpLM+c05VJ?=
 =?iso-8859-1?Q?VqXoK+tdLBfqQ4j4eXKWt2jqsJB4r0WxavwbuU3FOEJSYue++PvK0/45xq?=
 =?iso-8859-1?Q?gKZffHtdOMFRIXRIBVXgKEY3wSkX34K66HMvsN9oQuIbpwUTjoSmFz/7rg?=
 =?iso-8859-1?Q?aXr/GYPGZlT+QFE8MCqbLjGkOxLKCZVuoyIZqIbdoDRj7iKMuX1vONUA?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <A9DE44BB6F9743488B5CB0CEDA753981@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b56a364-cc48-4d26-6c70-08da8abac34e
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2022 19:06:37.1280
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cPuWUy6aTx/RP4m/04So4okRBbjIYR/0g1fBjhuXMiCGx699lpP2lgtLhUUlvLtTt4ZGubAwP4YQCXoExQrcCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4322
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-30_10,2022-08-30_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 spamscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208300085
X-Proofpoint-ORIG-GUID: uE7uS9GySIXadLWA9wo1Zep1cNXDnLhO
X-Proofpoint-GUID: uE7uS9GySIXadLWA9wo1Zep1cNXDnLhO
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* Carlos Llamas <cmllamas@google.com> [220829 16:13]:
> Syzbot reported a couple issues introduced by commit 44e602b4e52f
> ("binder_alloc: add missing mmap_lock calls when using the VMA"), in
> which we attempt to acquire the mmap_lock when alloc->vma_vm_mm has not
> been initialized yet.
>=20
> This can happen if a binder_proc receives a transaction without having
> previously called mmap() to setup the binder_proc->alloc space in [1].
> Also, a similar issue occurs via binder_alloc_print_pages() when we try
> to dump the debugfs binder stats file in [2].
>=20
> Sample of syzbot's crash report:
>   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>   KASAN: null-ptr-deref in range [0x0000000000000128-0x000000000000012f]
>   CPU: 0 PID: 3755 Comm: syz-executor229 Not tainted 6.0.0-rc1-next-20220=
819-syzkaller #0
>   syz-executor229[3755] cmdline: ./syz-executor2294415195
>   Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS=
 Google 07/22/2022
>   RIP: 0010:__lock_acquire+0xd83/0x56d0 kernel/locking/lockdep.c:4923
>   [...]
>   Call Trace:
>    <TASK>
>    lock_acquire kernel/locking/lockdep.c:5666 [inline]
>    lock_acquire+0x1ab/0x570 kernel/locking/lockdep.c:5631
>    down_read+0x98/0x450 kernel/locking/rwsem.c:1499
>    mmap_read_lock include/linux/mmap_lock.h:117 [inline]
>    binder_alloc_new_buf_locked drivers/android/binder_alloc.c:405 [inline=
]
>    binder_alloc_new_buf+0xa5/0x19e0 drivers/android/binder_alloc.c:593
>    binder_transaction+0x242e/0x9a80 drivers/android/binder.c:3199
>    binder_thread_write+0x664/0x3220 drivers/android/binder.c:3986
>    binder_ioctl_write_read drivers/android/binder.c:5036 [inline]
>    binder_ioctl+0x3470/0x6d00 drivers/android/binder.c:5323
>    vfs_ioctl fs/ioctl.c:51 [inline]
>    __do_sys_ioctl fs/ioctl.c:870 [inline]
>    __se_sys_ioctl fs/ioctl.c:856 [inline]
>    __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:856
>    do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>    do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>    entry_SYSCALL_64_after_hwframe+0x63/0xcd
>    [...]
>   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> Fix these issues by setting up alloc->vma_vm_mm pointer during open()
> and caching directly from current->mm. This guarantees we have a valid
> reference to take the mmap_lock during scenarios described above.
>=20
> [1] https://syzkaller.appspot.com/bug?extid=3Df7dc54e5be28950ac459
> [2] https://syzkaller.appspot.com/bug?extid=3Da75ebe0452711c9e56d9
>=20
> Fixes: 44e602b4e52f ("binder_alloc: add missing mmap_lock calls when usin=
g the VMA")
> Reported-by: syzbot+f7dc54e5be28950ac459@syzkaller.appspotmail.com
> Reported-by: syzbot+a75ebe0452711c9e56d9@syzkaller.appspotmail.com
> Cc: <stable@vger.kernel.org> # v5.15+
> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> Signed-off-by: Carlos Llamas <cmllamas@google.com>
> ---
>  drivers/android/binder_alloc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_allo=
c.c
> index 51f4e1c5cd01..9b1778c00610 100644
> --- a/drivers/android/binder_alloc.c
> +++ b/drivers/android/binder_alloc.c
> @@ -322,7 +322,6 @@ static inline void binder_alloc_set_vma(struct binder=
_alloc *alloc,
>  	 */
>  	if (vma) {
>  		vm_start =3D vma->vm_start;
> -		alloc->vma_vm_mm =3D vma->vm_mm;

Is this really the null pointer dereference?  We check for vma above..?

>  		mmap_assert_write_locked(alloc->vma_vm_mm);
>  	} else {
>  		mmap_assert_locked(alloc->vma_vm_mm);
> @@ -795,7 +794,6 @@ int binder_alloc_mmap_handler(struct binder_alloc *al=
loc,
>  	binder_insert_free_buffer(alloc, buffer);
>  	alloc->free_async_space =3D alloc->buffer_size / 2;
>  	binder_alloc_set_vma(alloc, vma);
> -	mmgrab(alloc->vma_vm_mm);
> =20
>  	return 0;
> =20
> @@ -1091,6 +1089,8 @@ static struct shrinker binder_shrinker =3D {
>  void binder_alloc_init(struct binder_alloc *alloc)
>  {
>  	alloc->pid =3D current->group_leader->pid;
> +	alloc->vma_vm_mm =3D current->mm;
> +	mmgrab(alloc->vma_vm_mm);
>  	mutex_init(&alloc->mutex);
>  	INIT_LIST_HEAD(&alloc->buffers);
>  }
> --=20
> 2.37.2.672.g94769d06f0-goog
> =
