Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF1C04721C9
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 08:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbhLMHej (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 02:34:39 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:21499 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbhLMHej (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 02:34:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1639380880; x=1670916880;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=m3I8N6/5Ujq+Md6HvRSb2dukC65QNKgxKGRTuhr7lHw=;
  b=ZCIKHFGz5QsIvIAU2m+nDK+n+loljU+jVaSqvpxVakQ8sxqYEoUQOKzE
   BGCQzNAjo4vWHygIlWmdc8jw50rN+Pgv+puWSR+zqU+yqYEYkx/j+MZb3
   OX3FPMfW6D+F+X9u7iSn/FxIRouXl+mNmiQeKWiZo25UbqmD+Uj92sg73
   Y3ZB5myO3hpbyCSBsG+q22J7H04iN03nOvZ48/cAp2iP6fFOrfrzFlhj1
   qC79+wB4c2ndUDGF+2vPq39USlvXTy5eFqvjTnbNJdwI2Uw4uy0M0wBbP
   8jXeinYgB/PZryg/RqxyqFbPmvzYL0gq2f7UCf5cnGBc4a+ZxSzRuZs5y
   g==;
X-IronPort-AV: E=Sophos;i="5.88,201,1635177600"; 
   d="scan'208";a="189118082"
Received: from mail-mw2nam10lp2109.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.109])
  by ob1.hgst.iphmx.com with ESMTP; 13 Dec 2021 15:34:39 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EBMhOCeTnr8YsV1vUXYrwLlT+LJs09rs6wEd/L6W1sTOIKBSO5tn3wY1Sa0y+ykgrYEv16ffnkRzxSV9oSYfHcHJSSoeNz4QhmWyI5vtPd1TxzaIIRq063S5DTdEZYMug02RNIAp1cgcHFxmaY6zUsduOmHPyk+ERzwlhJU2ke2N5c2iF1oU9DcWaXEmvdYdfQF4H3kr43BUVF3SNQca/JIiJmWefJm4233Ho1wSOLW+TcOaCNxAE+VxYs6QRN2ZKUWYn69S1nr4U9VdxexAVNONXJ9myzAxIBmjDsehmlk5b79EiDRRtDbMmvRheEvitXqENTcnP1XN04BUL4iLBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KQdQfrBqPnCRdDM/ryL3jsWVX0eZTqovz56mpIX5RfY=;
 b=frUdVzr8Ai4CNLZzwMTwYmbyJXB9A5I7ww5137nZ/NSs0f6QIe0QzKjYNwV0mk0RM3n9b+u7uLfnO5MJ86NqfSsFxsWdGrT4kO14zWAfVwSxE9kRxbbnAGuN7qzImYzP8Jw7kmr1slbGO8E0cfxqupebRGli82gmNNFYsAScwJnFKMS60qr1r+QgEJclMOZ0+v/qYU/UdnGEp9e49mSwZU0HKjoNoV3nyooox+6JAD6+B14bOEiSqNzSmqWdHkmSmrTygDK+g79Z0hwI+LrIZWRyeXNSfTqi5SzxqcNfBTMoUYt0vqHDWX1eGkS+qJ37BQj7d4Ovha38HmHpb76f3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KQdQfrBqPnCRdDM/ryL3jsWVX0eZTqovz56mpIX5RfY=;
 b=aNcJmUC81xUuZ5XzmboD6xUDB9oE6bP+Ge84CJxdQZfMA8XoAykyLbarE1BBo/ZKXbG9vq+icI/NRZ1bcfF2L7LtQUbrsHJveR7u8LVnaBG1kxJi3KZDtUVInMb7OSL1SEd5m6UtGP71PqIx//2IGHjO82DjLXkgXUyTf4KwdXk=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7141.namprd04.prod.outlook.com (2603:10b6:510:17::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16; Mon, 13 Dec
 2021 07:34:37 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3418:fa40:16a4:6e0c]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3418:fa40:16a4:6e0c%3]) with mapi id 15.20.4778.017; Mon, 13 Dec 2021
 07:34:37 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "dsterba@suse.com" <dsterba@suse.com>,
        Naohiro Aota <Naohiro.Aota@wdc.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] btrfs: zoned: clear data relocation bg on
 zone finish" failed to apply to 5.15-stable tree
Thread-Topic: FAILED: patch "[PATCH] btrfs: zoned: clear data relocation bg on
 zone finish" failed to apply to 5.15-stable tree
Thread-Index: AQHX72OLJqAc/lKd+02SWa3+kw0KAg==
Date:   Mon, 13 Dec 2021 07:34:37 +0000
Message-ID: <PH0PR04MB74161D8CF905FE235521373E9B749@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <16393188751463@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 525e57b1-3052-41c0-bca1-08d9be0b044a
x-ms-traffictypediagnostic: PH0PR04MB7141:EE_
x-microsoft-antispam-prvs: <PH0PR04MB71410B15E55CEF3BE36226B29B749@PH0PR04MB7141.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: saRP/dwb1PrygCFhUMROOi5LSQ0OPjS9d4m2pW9a32/69xfUZn1U4Gu1QQG9BAhMSwMFMrbnQHFU0eLEyctuRP90ezszVmfc58BU/2DaQuHxXHy4cLvaZqiTSrExMUF1EUoxo7gMdwN14LUXa3EbnrBjOJX1rmFOYwrFk2RSIyNQfkhFVOfXWdG0o6//qmPtCiLAxS2oUeN4gfS8x+OKt4pBdpCPWqVw+3cK3tBTCjkwfFRsgmMhGCZXkaTLP9Gqyf0yKUp+6KSthXUTE9POGB1dyla3AMZt23505+g8mzwN8blL6n5xQEgjzIMazIAEWkMUcuUsuGQfYF0yC+HlODaXnXsgP6496IgtHKyX2uRYEMGj4habOTfAFE2BkQwhAnAcc9S2MDQThY/aod2eFt4LlikncgIKs6N7CR+VGqQK5HDThSv1t3lZilEuG+3h3ZWKeq68/8VZx/deeCM+V0YEhZwQjxoFLDykH+8SMv90bY3Pn2fgOe9h8Pm4PXW4XkGxpBIq0wh43hVSAQeJwa5tLGxmG9ACzrKgz4fcqFl7rzYxSgrNbDK5xylJt/Wl7djMi9h9ObigivAy29X0nJuKjzI620HkcCcCtFkcjq9a/z1pdEZYpatqj8JV6LiGUyrOXQAgEuJYmO4e5K2sqalvQvmGYhXZ8mOYN/Gf6iNZWyTw1f9eObE3HtsNJ2A1VT+t5qYsa7B45Zh5dGtW/A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(38100700002)(4326008)(5660300002)(6636002)(4744005)(52536014)(76116006)(7696005)(122000001)(2906002)(33656002)(9686003)(8936002)(6506007)(8676002)(83380400001)(82960400001)(110136005)(86362001)(91956017)(66946007)(71200400001)(64756008)(66476007)(55016003)(66556008)(53546011)(38070700005)(316002)(508600001)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/i6BZIlyUIFRFClUW1y/vj+ObGOM1Hsvr4/urFXe+/AMhdhvynyWr27vvrGl?=
 =?us-ascii?Q?sZE72DUEyIC3TtEsczKpHvktELaMcnrQmfFnbkZRdOAl4UO9/Cvq2lbNku0h?=
 =?us-ascii?Q?mJTs+aGMzf1yJwoSKJ7bS28omHaTioyWPshlIGU1j1FQyoCLSZQ7h7n4f5Kq?=
 =?us-ascii?Q?KIekpnlyun9/M2U4KM5dFz5yMEBZ/+UvtB3dZwE96KhovJdEc2PKTF2siTGy?=
 =?us-ascii?Q?UVTSeC6fSWPeCkyu7Tllows6u6PoDKKjst863BdaVj9meemx/+yabec5dCag?=
 =?us-ascii?Q?IuHqGbDjk3eytpv2TlVJsHjMwtFcTHAggXgnNUi1x3vqQmVOD8lkDfC861gY?=
 =?us-ascii?Q?O/4MfjkJ7pe34lBr3gnaHZp4oNEeVB48iZDI1f4YD7LdUJdkvGBYpfVz5de7?=
 =?us-ascii?Q?HFyTCshlFP+mEsoC/aEhefp4CwWp2y1AkxfKbff+FiVpAmKyeQPjnSi5xlDJ?=
 =?us-ascii?Q?9dTVa/rW4m/yyUaJYGpDJW6pQozlGuvRHVIkd/0Tvno2aoGJYWLAamDsgJg1?=
 =?us-ascii?Q?Lx1xDiw17rwutgmataS3/Qurxfy9OlC8yp2vfUwNmzzmP3VF8YAp6fzKTl/Y?=
 =?us-ascii?Q?UDw70RC5VtFE5Fc7Qa4iRy0GKHxo2xC1BMAxStn5WVwqADGubZqpGMDlUVSw?=
 =?us-ascii?Q?n1+tkf4BVkOu8exKDXsQ7/znb0kW9i2H3abXqX323j1sUYEg8Xqcs0aneqme?=
 =?us-ascii?Q?dqK1cU6hGo63i1R080yeduRraX7baClsNSMrkXQv20Dkwb4/9zMAuweYkZ5N?=
 =?us-ascii?Q?uwm/l1LTM/UE3B2xg3z0IhZqPeIyEjXEa7D7mHtd3rFYaoxXyqeqE7Rpst1G?=
 =?us-ascii?Q?T1ZBorLkEEhAVEO3QdUoLzi82fQbEngEGXJ2yZmvlNpXq9Z1O71Xzq9ululw?=
 =?us-ascii?Q?xgvyiOjBPjUFlZOBK+8awkp4nTVjLqRBAqEgGG7cLSZeoip5fGBgHX1z1W4I?=
 =?us-ascii?Q?7SlZXoR9iKn4g/6YkoZ5OJsshKvhbzb0d+ooTJVn0/ezou9t0ywsf3504dpr?=
 =?us-ascii?Q?CbaN5NROmmf6Xm72emA54tlJTcbKx/AA0xzfqNrSUeoUfccC50+J7QcxMwV2?=
 =?us-ascii?Q?+NVzR/ohryye4mF4yRdDnBgQPcKi0+m9Kzh82totFP4Qfn/Lz2OIOT4iLw5W?=
 =?us-ascii?Q?DPlocaPuXJlNaAVdfFHBuXYqZyd1qciieJ1AB43pIYjfJ2s8/5f0yQUvn2J9?=
 =?us-ascii?Q?mM9eB/vbGFvOPwlouKMlYtr+zcFCoUeGMgcSdQ3SV5zJb68NuMvBFkKG46zQ?=
 =?us-ascii?Q?oyYP/KXVUDbYNUnroCyYpwlMPhvDnuGATyRZwfvVxl+JjaFM6I2kx/sK1ur1?=
 =?us-ascii?Q?vimWgdypChKCDrRVXuP70fui/GYYPumlDaPLRH3m/OZuS18PMQQ6KSCDMBSl?=
 =?us-ascii?Q?pQKQcaSaHhkhzUm3XF7u0omhEISvLxnUTvA+CThAgLY/ymeiV/OInoM/PZ4V?=
 =?us-ascii?Q?7CUxZY0uObf0ULdKG5xseB43gNx8PjHNDHupZv9d3czeTfw+1w9OlJy/EdaV?=
 =?us-ascii?Q?TCxWqTaElFfyEA/c7xVJv3eQHP3EuHUIFfyuw0PDi2Tp2InieHYnqdCcDgon?=
 =?us-ascii?Q?21Aali4HlYUnEieNwErK4NG6J1pVwl1pk0Ngsinjp+OSOR/lEg7FfxYkYAeu?=
 =?us-ascii?Q?9+WmKcdvSSEzRMBa7blqDodZU/3HQa22dtZ5SZ7t87+QjJ/GkyeAZNRxxfsg?=
 =?us-ascii?Q?MSSLKY9DB3kAwza35RnwJcz3fBCRzrOFaZxl4GFEg2z1Ip3b67S60g2Mjz5h?=
 =?us-ascii?Q?y3GNYngjqO5kFoPVDTTcKCJDuCTdESc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 525e57b1-3052-41c0-bca1-08d9be0b044a
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2021 07:34:37.3618
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t2kJ/1q3YhdCZ5wu75W6JowshUxTreOlu1XjLEZj5GGsJa+PTA6wdxOIRg+MyuhHmbHA6FDb0ztt0IZRqJDU5VvWDUik/C+Av+GI0cQOxyc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7141
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/12/2021 15:21, gregkh@linuxfoundation.org wrote:=0A=
> =0A=
> The patch below does not apply to the 5.15-stable tree.=0A=
> If someone wants it applied there, or to any other stable or longterm=0A=
> tree, then please email the backport, including the original git commit=
=0A=
> id to <stable@vger.kernel.org>.=0A=
> =0A=
=0A=
Hi Greg, =0A=
=0A=
this patch doesn't need any backporting to stable. The failure can only =0A=
happen on v5.16-rcX.=0A=
=0A=
Thanks,=0A=
	Johannes=0A=
