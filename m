Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3B71AB55B
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 03:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729107AbgDPBTA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 21:19:00 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:62482 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731040AbgDPBST (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 21:18:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1586999899; x=1618535899;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=3kuEkUTfis0lUFXd9fJA8SC8r3jCeWBUpS/+N1vgX34=;
  b=GUwfrqKO82C1LrTZOuSEXrqwxhxWMv36MX4P2mdc+JTza9wjWR6R4yNj
   gZIyKYm9speH0+NH81Tb0ukhUsaLj2BlGfxhVtH9foAi8b2spTdmUJsEB
   9xoBM0BYqDpPAhjcB49QkNRyrztSccmFgGqiPw4uWZDIOR+az4yxHrPGD
   v6PWAn+uNKUJfHIaakwi9+MREBmN2UqP4Nm3daVK8qSbwkwdxpjeZC0h+
   GUPdawRmpYUs8Cf18m+hRQg7yY5gjbTrXx8vrpELBGzPFPhbDRQGL2Stl
   kK9IpvQXcflxjBJDSZKVJU55zGv480w/kiSiUj0KweDuweG5xhEUOgPVN
   Q==;
IronPort-SDR: Bl25o2o4yEx9eoP9FyIhPGIhYbVRasQgvzgYfoJ9Pg2kMWRP/tnPJtKD6iOl6u4h5cLt2A8bZw
 RgAQ2Ic6DjdVk/Heu7/jFhHuKnSx8xt1XjdqxtFjeMhYi9BGoP1yxQQcMSzxQvjsi4hic2DELI
 5LMDCB8lxuUR3WX6/bptLWEjA1CZZhbG5bDtqF0WTwyV4UVBQnTC/GCUR6swMcptp6muRm1VeH
 nAhJP0F217rSbHUXa+h/9GsvOyqksuSiMxBCiqBpBRb5FXVNxapWzEzoLGYDUrg1b5JZCUjJwM
 c7k=
X-IronPort-AV: E=Sophos;i="5.72,388,1580745600"; 
   d="scan'208";a="136865843"
Received: from mail-dm6nam12lp2172.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.172])
  by ob1.hgst.iphmx.com with ESMTP; 16 Apr 2020 09:18:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NJZKpyHWaWGqZTKoZyiJx7+MBb28zW6PeyxvQ6p2YSFLK+Xn2pNqVJTGgWXY3u+IWKtSPTpPYAZbC/D6z4VII8Mn0gRvp6BbG13AnrBOlSPKiFzyv/D+Gq1ZDGwb6j6xBd3tC8qKX3bpBDuicQu5dRe8ciwqm79yPVec2kEr1a4ZKo2/KgaZ9wsmRCiqnG04AVcJVruRCS9F+YVqTlIWvTh3ESsrJD3AdPlpah4JFqbyoPQrejJEEKeyaWzLS07dmjlR4DTwOSf4o7y5guc4B5NPGJJc1JiPtnmmejKIf+pKDnbVeZj2L3mEUiw+j9S2tXvv7FUy7JAnX1PyuNJ4pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kRwqT2hMNmn41SVofVT7gQE+v4+XG0c5oCiiHCGAn5k=;
 b=mKFk+eLWqZcEN3oCMgdWMEVdaOjlHl6zl6dEjnKWPnDeAwUDsCAVYCQudbcG/B83aawIyK08vARRdgP6tvJvHZjQABr45IkbAT0y20wo8vyrfEfInYWhpJVezW5ugBlX8Pcxiq4KV5KxbFV+cNyCnq6Gxm8vm/EkPVlQXccVdfVgIgjZLsYMuBWBW8Glrr6sQ09sLhJjFgGXH9c2EzhDDsBD07rhNSTheiOMcdAPRtWSig0r1dlb8NQYq4t80mo+V5l15amH92HMmTSHgOrg1gLkSFvNfdRFqdbkXPnWJg2qgDPVPI4iizhFvm+41uDlt2dwT6vVPR/CVQ7lYZascg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kRwqT2hMNmn41SVofVT7gQE+v4+XG0c5oCiiHCGAn5k=;
 b=xUpmMw6+l8PMgn+pyLwA/gHNkSHikkpQ22fR/GK8TaTMqGUbhsclUIFF+3nJ3AhNjQMx8j4Ws6JHMWLULiA+oOubURdtZmuDrCXINNBT1IR16h11FNFUIaDzcAwT+NeAFJCAqeyan2pxS13jIi/NHelYooOK3tRkG6pQ4n+5wzk=
Received: from BY5PR04MB6900.namprd04.prod.outlook.com (2603:10b6:a03:229::20)
 by BY5PR04MB6915.namprd04.prod.outlook.com (2603:10b6:a03:22b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.26; Thu, 16 Apr
 2020 01:18:09 +0000
Received: from BY5PR04MB6900.namprd04.prod.outlook.com
 ([fe80::b574:3071:da2f:7606]) by BY5PR04MB6900.namprd04.prod.outlook.com
 ([fe80::b574:3071:da2f:7606%6]) with mapi id 15.20.2921.027; Thu, 16 Apr 2020
 01:18:09 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Sasha Levin <sashal@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "bob.liu@oracle.com" <bob.liu@oracle.com>,
        "snitzer@redhat.com" <snitzer@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] dm zoned: remove duplicate nr_rnd_zones
 increase in" failed to apply to 5.4-stable tree
Thread-Topic: FAILED: patch "[PATCH] dm zoned: remove duplicate nr_rnd_zones
 increase in" failed to apply to 5.4-stable tree
Thread-Index: AQHWExVluLCNXSaDGUmLTTIdAkVS3A==
Date:   Thu, 16 Apr 2020 01:18:08 +0000
Message-ID: <BY5PR04MB69005540AFF59A843B672091E7D80@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <15869485594525@kroah.com> <20200416005148.GO1068@sasha-vm>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5b293d0a-627b-448b-f702-08d7e1a40636
x-ms-traffictypediagnostic: BY5PR04MB6915:
x-microsoft-antispam-prvs: <BY5PR04MB6915B1F3B7BA4AC575EF3209E7D80@BY5PR04MB6915.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0375972289
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6900.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(396003)(346002)(136003)(376002)(366004)(39860400002)(52536014)(66556008)(478600001)(66476007)(76116006)(66946007)(64756008)(2906002)(33656002)(71200400001)(55016002)(7696005)(66446008)(186003)(9686003)(26005)(8936002)(53546011)(8676002)(54906003)(81156014)(316002)(86362001)(5660300002)(6506007)(110136005)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rWuuA5rPljrSzdLJZUQrgQ8db2IlmZ1n3/USyyZMf2TlxLI79T5/OesLpSMDG/iiITeeiyosqLMuHpEM9IgNaUnsTPaWltNsnZy77j6jCwpzL7dJ/203mQ5IGdE/aOYl7tm2eL0q/hmyHZTPW7jGxkhT4nEeTG9SaK6j6RNEOLNqroXTEQk51fHXpkfiNmjrVws86vYMgLH8ZiASMmaqJdtRBQjSSXCw102XmgyDQgaenFmdbou/5/fFWP7rp+FldKoXewjntTIl6N81PIz20gQJIu6kyAtyKzkqdi2rdZjMz1/cQJgRFDQ0eCvgW1M8L2oWm0mlATTxTCAuOta4Kb+UTdvImJ8/JTNrCF/5gr4mVOYL/7G0hqA81rFw1PlbqHZ/dVf6rbbsnXGz8W2qmlIA/u86O7HQFuJhcsJ6MM0XrOxhbhD+TpmgYWEitsT6
x-ms-exchange-antispam-messagedata: ZJeu3J6n1BqCYh1UgT7RGvqzrEKgR88XWjfrl7UpEN1kgekBlu110OW8C1oZkr6HGDKijBSXM1MQvsJDmaXSPrMBP2w+c7XnhHfLEfgIIv6JqV41yb+9WofT3UuH6W+LJuqAyI19c+4d0Oswfsxdnw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b293d0a-627b-448b-f702-08d7e1a40636
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2020 01:18:08.9932
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eYFXvX9KsYh/jj5YinEoHLAZZuP76odV29QY6wsWmPBpWcVyH81DYfUrSNDQDXVDq2PhiGUa3WNiPAs1uVSZXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6915
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020/04/16 9:51, Sasha Levin wrote:=0A=
> On Wed, Apr 15, 2020 at 01:02:39PM +0200, gregkh@linuxfoundation.org wrot=
e:=0A=
>>=0A=
>> The patch below does not apply to the 5.4-stable tree.=0A=
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
>>From b8fdd090376a7a46d17db316638fe54b965c2fb0 Mon Sep 17 00:00:00 2001=0A=
>> From: Bob Liu <bob.liu@oracle.com>=0A=
>> Date: Tue, 24 Mar 2020 21:22:45 +0800=0A=
>> Subject: [PATCH] dm zoned: remove duplicate nr_rnd_zones increase in=0A=
>> dmz_init_zone()=0A=
>>=0A=
>> zmd->nr_rnd_zones was increased twice by mistake. The other place it=0A=
>> is increased in dmz_init_zone() is the only one needed:=0A=
>>=0A=
>> 1131                 zmd->nr_useable_zones++;=0A=
>> 1132                 if (dmz_is_rnd(zone)) {=0A=
>> 1133                         zmd->nr_rnd_zones++;=0A=
>> 					^^^=0A=
>> Fixes: 3b1a94c88b79 ("dm zoned: drive-managed zoned block device target"=
)=0A=
>> Cc: stable@vger.kernel.org=0A=
>> Signed-off-by: Bob Liu <bob.liu@oracle.com>=0A=
>> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
>> Signed-off-by: Mike Snitzer <snitzer@redhat.com>=0A=
>>=0A=
>> diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metada=
ta.c=0A=
>> index 516c7b671d25..369de15c4e80 100644=0A=
>> --- a/drivers/md/dm-zoned-metadata.c=0A=
>> +++ b/drivers/md/dm-zoned-metadata.c=0A=
>> @@ -1109,7 +1109,6 @@ static int dmz_init_zone(struct blk_zone *blkz, un=
signed int idx, void *data)=0A=
>> 	switch (blkz->type) {=0A=
>> 	case BLK_ZONE_TYPE_CONVENTIONAL:=0A=
>> 		set_bit(DMZ_RND, &zone->flags);=0A=
>> -		zmd->nr_rnd_zones++;=0A=
>> 		break;=0A=
>> 	case BLK_ZONE_TYPE_SEQWRITE_REQ:=0A=
>> 	case BLK_ZONE_TYPE_SEQWRITE_PREF:=0A=
> =0A=
> The code on older kernels was using is/else construct instead of a=0A=
> switch. I've adjusted the patch and queued it up.=0A=
> =0A=
=0A=
I was about to do that. You saved me time :)=0A=
Thanks !=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
