Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6875E4D887F
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 16:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235968AbiCNPuR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 11:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231625AbiCNPuO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 11:50:14 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB0311A18
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 08:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1647272941; x=1678808941;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=LZCX/PNeWKFS0V8AGlixxdWbMF5xas83JColZQfGTHg=;
  b=AqDVTX9I5KJHrwRB5XqW+4plPOxqMUyB703F7xkYiqEEsbzfvJKBOIN1
   uElUz4qlPprxkFq1p68XKvWK0012Ip4eoa1HIoKydo7R6wPuCB0aLoQEm
   MlmX9mpFK6pfEWoXD+JKG2FdPHNYM3yiF2AVGZ+EFHayCx2D3sjSDd5L5
   1gH0WLKhNvyZ67fvPHiXPf3ROxyqoQhUXE/JVCh9yUsnL6kLMh1FW4/HF
   zF0g64zQgIYYXMmb7SS5pD82ZVwzgQNk7jsNGXSuRPKiSlBgYodnpyqKG
   rJYRC5E6QRq9WIZKS8PFqbQ5pr8+qAIgz4UqqpA3WJvSf289Up6Jx1xpI
   g==;
X-IronPort-AV: E=Sophos;i="5.90,181,1643644800"; 
   d="scan'208";a="195320521"
Received: from mail-bn7nam10lp2105.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.105])
  by ob1.hgst.iphmx.com with ESMTP; 14 Mar 2022 23:49:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V7ruzDCad/YEn+71752MVbdPRGUeJsm9Ia91jbx1ZjE3CipgRN89ZbLdhpKzODKdBrb7c9aF+k+o8vRkSUD2rbRarxH/ImNut3Zy+RHqZyGF0utA4X/5MCH8vRhL/qIlMDLZyAzZ6VuF0r0qmc4sFHK/EOwKbk08rLArqi2PHIgjFiYSM0zlhNPBzEmnweK2X0yoMp6NhErIjX04Uaqv32ltb+qhZxFrE10Pr4MlSxrTa2aIrrv6cd47iU+pD1Q3AMHgg2qDejq57/B3R1Nj5TQHt6gdupNb2hjBcFvgd9Qds+Ml1AFagSHcrsElDQViHR9mpXF6HwJjASnoPCZcHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LZCX/PNeWKFS0V8AGlixxdWbMF5xas83JColZQfGTHg=;
 b=aaZLBzGGgo4eEmO0HE5gsD4Co6WnNlIzKL/FNjS441zKwFfXc7yZwXmhjh4vYCeRKYY5p+0POfbqtmumsdcPgPXITGK6PgFJZpbcMs5sS1qxsEVkKKfCaAm3oAiMMZFR1xRkEBm3yf8OSU0ZGTTnt043b6hBtWUeTeIYendWvqeEdQJSitZA3fwT1y1En1FDclIV0UjIhaHKEFYwjB+TYJVK6H3xmhsV3D8aHL427friCj8qc4/uLQfi8jcdTqx2WRM1Pp7va68lTUzufpiHaeP5qKVfUq5RPdVDYx3nJjCqyx4RVsplWIpuv7O5PeYakDsLDM9mi7cKMNh3dzdRHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LZCX/PNeWKFS0V8AGlixxdWbMF5xas83JColZQfGTHg=;
 b=VzPQWcV7jbTEIMVNmgPkhwRZF6y6OhHSnvZKre/43EUArPJREcR1kvhm+Y8NQKEm+vH16/LE19Oen+oSPIDv2ot4tkPDjF8gaVQM13o0Az4LgmIImHZDRxXyEYmvv/DIJg9w4+6IogWuok/0u18n4zCkGnchI+20kQ8YNIk57ic=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by BN7PR04MB4100.namprd04.prod.outlook.com (2603:10b6:406:ce::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.25; Mon, 14 Mar
 2022 15:49:00 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::f025:4f23:8e46:b2ed]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::f025:4f23:8e46:b2ed%2]) with mapi id 15.20.5061.028; Mon, 14 Mar 2022
 15:48:59 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     Christoph Hellwig <hch@lst.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Subject: Re: kintegrityd workqueue fix backported, but only to some LTS
Thread-Topic: kintegrityd workqueue fix backported, but only to some LTS
Thread-Index: AQHYN5mtjBWghYPVmkqkfGiiQU6Z4ay+ztwAgAALQwCAAAzTAIAAH+SA
Date:   Mon, 14 Mar 2022 15:48:59 +0000
Message-ID: <Yi9j62xyno2Kq24h@x1-carbon>
References: <Yi8r+UyK092FE12X@x1-carbon> <Yi809h0I28SN0qG8@kroah.com>
 <Yi8+aIyDFWCfBMT/@x1-carbon> <Yi9JKo4TPnc036Oa@kroah.com>
In-Reply-To: <Yi9JKo4TPnc036Oa@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9a75b90d-6101-4d94-08f1-08da05d2280a
x-ms-traffictypediagnostic: BN7PR04MB4100:EE_
x-microsoft-antispam-prvs: <BN7PR04MB4100A748CED1A6A56AD87467F20F9@BN7PR04MB4100.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mkaRBUfTxU4zEbWmeHiUjwkxI7VVE9RqxEbYocXxW8jbgAY2SLFryaynrk094a0yYZzNkxmhK2U9yMetTCFfv/nseXCV7X/fQTRKMo/fZGcW/PClv/RZbc6wzNNGlOql905eXwdU0uFF5sT2yYTKd3Sf0QP0tF3gxuPiyzAicPVM0buwhh0L6COZfud9wq1JoNoZJdOUrZPtObWBSdSgMYZzdFClFmKbMeHLeBIij7w+2/LSpdmgImb3r+f1rmMIWT9UALKypIBQu4Njx1gkrHicEOJBPYmhfFRaWn4Xq1rRi5sn5GpFL/kX9dh/LufCHBf1GOurSPBnq9qYzs1/TlCMRhOuwk2JJcqbHUB+1rxWpoKmRJ2UPC1rac+gkaceGWSCztqwoZdEYZ3gjN1oiN1GMor+9gCvVJLEXHhrf9MqFB0pOLAf+JWP4r1Pq1wgDKVYzMXRZZb2cv8+4qvstcQEddppc3avnr2Jq647oZXL+MQviNy1zMVOIjlmQdTKCTIDLVKTXsKWEwreM1IXcnj2X6dnlJiq/kybLWBSKzDXOnzUm+3IxPdzmgOcUtgSPouw51NK5+hmk4mg4TI8W/tPjg8Dx78OLvXD0P2VZJ0dGeGEE74QJGItx0y1/EsgePGMnYHME77ctVTx6Ce3PwU+gTS1TOMJfZwQbaBonMdm4ahlh3+S6p2wvJ/OCoONIDNPQV6YvenibCK5MOnVgiUG4ppHes5IpdgiUFS+BZNSdekjTkof/yqcPitRXuVIMGBh5w1SnpIs5A8aqN28cqPNZ0Np7+r9aMVPn687wU7W+iNBjI05dSGccnWdtgcPXYhex9SAvjtWWk+HgjKx1w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(6506007)(8676002)(33716001)(8936002)(86362001)(76116006)(91956017)(6486002)(6512007)(9686003)(64756008)(66446008)(66476007)(66556008)(4326008)(66946007)(71200400001)(122000001)(38100700002)(6916009)(54906003)(5660300002)(508600001)(83380400001)(2906002)(38070700005)(82960400001)(966005)(26005)(186003)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MCYaRCy1+0yd4mtPWx0ObpFMe2kbdobNxqlTHKfR/nCMu9dMd908eB+/SaLT?=
 =?us-ascii?Q?QZeMMVIyfL8pA8oF9iE4jsaFCHpH1syK5Z+Rdhj/4x5dw5Kj9TMhKA01aAtb?=
 =?us-ascii?Q?Q0QmnXAjUXezFNx4+0xIbc+srzwRFjqH7KImbFuIVNUlmTq8U/hMBwqTReEW?=
 =?us-ascii?Q?6qNE+SW6sNtFIIIU7VewaKyBVk+8gjJxOHRur4QjsBEfLq/SO4IymLUmPLvw?=
 =?us-ascii?Q?lfv3s/0wDQ7dOOKfuDEoen0Y54pFsMpUB2x5hgus4ODvHnXY/tbTRtXb65bP?=
 =?us-ascii?Q?DRl5EecxpqD2oTxmu1CJW8wOj7BbMRj+Vjtv88s3rCS/ArYkdNvxZ/tPZicE?=
 =?us-ascii?Q?83/2zYnGWBk1M9Sj3n5xTXVDAvVMVpQV6b/DfkffsanO3MtNndK90ebVpgEV?=
 =?us-ascii?Q?Sg7JQda7RNgkw0SmPXo8imuWIAB6bulfVY2FoTF4jKLsZdNM95qjNnchJEiO?=
 =?us-ascii?Q?HIQyxhsTqz+q73Lr6c+0rtcg61yHUF/UuB8d5WMqwIGwRdvx2m0KIUMxJzUN?=
 =?us-ascii?Q?MYxSkOvf1rZyJFdR+RIomcOecHWKhlG4RCEcu7bMIhEUnYlSwhFRAiwUG7eQ?=
 =?us-ascii?Q?a5xqWLdPJDEw+4oMcfLH8+PSy2rpAFpsYOv1pDMGBUAMMWXNMMU+1v11jN0l?=
 =?us-ascii?Q?zS7zMh1TunanHC9O7iWDOPvXZjyev2cypvCifydkVDY6c5UvNhJbXljnHeuw?=
 =?us-ascii?Q?ATQY3WxAD8lgeEwdvT4uFg+WLjLquYTtu7Xu5yA2MsdNNQcoN9+DY0jeM1HU?=
 =?us-ascii?Q?M+Jdfk3nxpVEO/J/0Bi5QGxO4shUIoVFhjMTvvjFAnBQODJnI3LRlW7ZJC3h?=
 =?us-ascii?Q?ilrc/R68m5P9Q0oVE65f7pDh5dWkuLIuxwD/rWQ38XhnH+a+R3DMCNjbqrdM?=
 =?us-ascii?Q?0ueY4nzdTpA1+36VDPKHYTsAmUydrEWREkZ5ulYm9jDiWs0CMvYB6k4abCRK?=
 =?us-ascii?Q?aTYPSoVWWp0aRBLkWAFySN9X8YreGRj4nj2mHE2jkZIww7CVYLIlqZo+5Zjj?=
 =?us-ascii?Q?ISP2/F1zkeKndRv/+4HkmxZQJt06U8FMxdXyvkRceARzriVuo4MwbC9jWZ5x?=
 =?us-ascii?Q?ExfxWMemGbP/A2thnROd0V129INIk07pqHJplG7x9yFb99PXJ3TrDv4wd18n?=
 =?us-ascii?Q?WKFTgHfLR+qSnd+JtWAYgLfxaZOu9bWNPwWBTh0jXNjlbzew2kN5Jau6EeDg?=
 =?us-ascii?Q?DXY4uxwobbEtkdAElGyyNk9eOibIR+es0RglxrZ620HsBN11I837JYVcOoAo?=
 =?us-ascii?Q?kiFg0avYpwtiaFBwopfPlUdZqaDEXBEwiC7X9taCy03czJwFkZgKwuRKXP0i?=
 =?us-ascii?Q?IYEHrPeYcxtlt8IBbozk7OvlOEEc5n9sQAQBfqaMmHByHGalscxvYdVJJlHR?=
 =?us-ascii?Q?ZSw8ssIFYgUdP6v3j9yZZ5FH0nfGOKK/WvBgIWBy1zMEmEZ8GhJb0yiO39fM?=
 =?us-ascii?Q?eRVqBtPbNps8WfIP9FL9Ehk3lOB2t4/exbCN9y4ZPCGKmjFk9D3Wtw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AD9F1C2ABC4876478CB992024D630F96@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a75b90d-6101-4d94-08f1-08da05d2280a
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2022 15:48:59.8113
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rHAN4AIFnFIM/VxlBCxT46t0xX8nZBsFawRCeuUnABdsKNlqKsTdYDH4XoRgGV2ESj1msV4tVdedFseo5yXG9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR04MB4100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 14, 2022 at 02:54:50PM +0100, Greg KH wrote:
> On Mon, Mar 14, 2022 at 01:08:57PM +0000, Niklas Cassel wrote:
> > On Mon, Mar 14, 2022 at 01:28:38PM +0100, Greg KH wrote:
> > > On Mon, Mar 14, 2022 at 11:50:18AM +0000, Niklas Cassel wrote:
> > > > Hello Christoph, stable,
> > > >=20
> > > > I recently saw a crash caused by the kintegrityd workqueue that cou=
ld only
> > > > be reproduced on older kernels.
> > > > A null pointer dereference in function bio_integrity_verify_fn.
> > > >=20
> > > > The fix in Linus's tree for this:
> > > > 3df49967f6f1 ("block: flush the integrity workqueue in blk_integrit=
y_unregister")
> > > > was first merged in v5.15.
> > > >=20
> > > > The fix has been backported to v5.10 LTS branch in:
> > > > 1ef68b84bc11 ("block: flush the integrity workqueue in blk_integrit=
y_unregister")
> > > >=20
> > > > The fix doesn't have a fixes tag, but from inspecting the code,
> > > > I don't understand why this was only backported to v5.10, AFAICT it=
 should
> > > > at least have been backported to v5.4, v4.19 and v4.14 LTS as well.
> > > >=20
> > > > Original series:
> > > > https://lore.kernel.org/all/20210914070657.87677-3-hch@lst.de/
> > > >=20
> > > > The blk_flush_integrity() call that actually fixes the crash should=
 be
> > > > trivial to backport/add before clearing the flag and doing the mems=
et.
> > >=20
> > > A backported patch series would be great to have, to show that you ha=
ve
> > > tested that it works properly.
> >=20
> > Hello Greg,
> >=20
> > Unfortunately, I don't have access to the machine. I was only provided
> > a kernel crash dump to diagnose the crash.
> >=20
> > I guess I was hoping for someone more familiar with the integrity stuff
> > to backport it. Both patch 1 and 3 are unrelated to the NULL pointer cr=
ash,
> > and because of various refactoring, I'm not sure if patch 1 and 3 are e=
ven
> > applicable for older kernel versions.
>=20
> I do not know what patch 1 and 3 refer to here, sorry :(

Sorry, I was referring to patch 1/3 and 3/3 in the series:
https://lore.kernel.org/all/20210914070657.87677-1-hch@lst.de/

Looking at it again, patch 1/2 and 2/2 are both required.

Patch 3/3, I don't know, since the flag used to be in bdi, but is now in
request_queue.

But even then, since this doesn't have a Fixes tag, I'm not sure how far
this has to be backported. Christoph, thoughts?

I'm assuming that it was the machine learning scripts that backported it to
5.10, but considering that I've seen a crash dump with this in 4.18, it
definitely should have been backported to 4.19+ (but probably even further
back).


Kind regards,
Niklas=
