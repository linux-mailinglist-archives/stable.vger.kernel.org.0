Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D66483AABCF
	for <lists+stable@lfdr.de>; Thu, 17 Jun 2021 08:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbhFQG0n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Jun 2021 02:26:43 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:61397 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbhFQG0n (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Jun 2021 02:26:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1623911075; x=1655447075;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=hgDL/thGvEGY3kt000M0Lt/Sa8bk2hRKAY+luVbQxAPj/SCiDIvnHKUV
   O0D3Xfg3sWN2lJcT1XiBUdNR5ni2zlA+VrbRXW6cQmgKUCZOS09TcHrf6
   c0Qdq4B4xwTOMiS2gESToPwwfR7EkzLZfOUag8quEoRTwQLXQBQT+RIt8
   PpvJcHfyXON4sLRAKoaWFxTovIl9ZmMlMzdHvjQBWIQMx4gQy0ct1OaS0
   xOCAxLUXwTL/yAFXfnOT4wFB+YW2JDGoDn0aM3kTge6IhF1DO6IOKD0Cb
   bGxkMVtdzrdpULErLrrzYDJv7jLkKsWn8D/i5kPIt+3CAyk7dXjo1ee7d
   w==;
IronPort-SDR: a2qd3i5bnUv0k0ZsU3TG6kJBxuBpgtB7Dis0HrINgnxgxto++FA7CZNKtzULC/bRKIg5FzDFvI
 xsecerauE9xHOZlT4WYW4UVpqdb40McO9FhQxplkhBZmgcoeTZuGOgGvcDJftgrAwKDbO0B35R
 LUNmKcMhymIjRVDqf3PtZ7HoQOPR9/zl6S0mH5+cjkcwT8NTTB33uMOdE22eghDd86VD03o/Dz
 6x/R6Wxx8fZyiZqB5p9HdjRgNMJr+RKuqrVoMSdqIyEWsBRwwHk6A0DhCn1mpWuU71UbO74K/1
 QRw=
X-IronPort-AV: E=Sophos;i="5.83,278,1616428800"; 
   d="scan'208";a="176965370"
Received: from mail-dm6nam10lp2101.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.101])
  by ob1.hgst.iphmx.com with ESMTP; 17 Jun 2021 14:24:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l+TG76MsZYlpyCaFoV3idDKw6ieRHh/c9dM/IqoYbuQ43Zm55v+t1uvsKw+qHyGgLcjxONZPSllJHw746VUwwxPlAhnEd4hpGtIbxHaXkMxv7QgTL2GfjZhiLdXZOyI/tayrADKFOtSa2gQ8bbUouPKTzCslJTIrmJu4vDV9POKWN6YdcKXOV6LoBoWx9yPvh7q4NMOKsERj/9ORXnUZDwnZ2Q+SPClYVVQh1Ofj5rUN1gQpD6Ud8dU1iIIvA/7tT+HPy/0S0DT1g+q66LiWDA9ztRvORbTw2Rh1MrTjCBNDYeSNFBRHEgzgj6D0NwttBLfzVVngXJwNjllPjNC2rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=nWabjOqhiKEg4ZLmhyvWzNaeHTvpD4WrD/rVEiiK7vBZUMsPPBVbCDgS7Iw2CcCRw6sL0/zZGSMVJvpnGW75BVWM5B70ZiCLHbufmNEhqShhDhCKHGjndRcZ+8ax9uQAuj8pZrZauX9AaPJFIedKCHUFjscsKOvlYIvJioeuZkGFiTxlobdUqIkQ+6ZWVmQoOmkyqqIwwnXPbj5OrFPDpxDQol4xBj71gNvfFAuOFa2DV16KcY7+59z2maa5xCKim6PJrELdh1sO/3kxEfluU7f8Ps1fcqTjH99t3Lklu8wIQ1oKfu2vS+6vy5YUNezMKEr/L+82v7eEJieJj3FHtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=RqxlHClm8oQ1klJoafxsLlvznlc1XsJ8uMjtZ0I6qXWQrFU8qsu7IZ3QSdn1bXX196ElDOzlGIkxu1YEMlOe/CbMSZbcxDYG2yVhP7USVaxjKldtHwXFMAUO84R5Ve1wqLUxdNf6+x2gIthTKJuqQsWrca6NTGJFITm45hE7eBY=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7285.namprd04.prod.outlook.com (2603:10b6:510:1b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.25; Thu, 17 Jun
 2021 06:24:34 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::99a5:9eaa:4863:3ef3]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::99a5:9eaa:4863:3ef3%4]) with mapi id 15.20.4219.026; Thu, 17 Jun 2021
 06:24:34 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Naohiro Aota <Naohiro.Aota@wdc.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC:     David Sterba <dsterba@suse.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] btrfs: fix negative space_info->bytes_readonly
Thread-Topic: [PATCH] btrfs: fix negative space_info->bytes_readonly
Thread-Index: AQHXYzU07S8mk0NO6EOOUuTbqrP2LA==
Date:   Thu, 17 Jun 2021 06:24:34 +0000
Message-ID: <PH0PR04MB741607F1AAF7F4929835CE219B0E9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20210617045618.1179079-1-naohiro.aota@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2001:a62:15c2:9f01:55e5:e83c:a916:2f3a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bf3ef087-447b-45cf-9b51-08d931589327
x-ms-traffictypediagnostic: PH0PR04MB7285:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB7285D8809E30B48370C2AC989B0E9@PH0PR04MB7285.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0JBlVx/yqPyGAdnaXuGmZ/u+ra8CuHnqviE32n/VOySFKCmEwXZz3WMFn0IsaoNVqiulPNOIydfd8Q4h/2sZEIE0BQuDyObAal2xJvn27kXtVhGmDprfWUxEKUaLjCGtYN0Je0bmXNJADIGIhiUWiYq4vvAod56wCg96rl9Yyy5DUtDY46xZpKYI+nd6nM2N9Dax/vGryjuPa85dkaJCsW+o1bNLB5M6Ew97yEA2ziiJjB85eoux4bNsr+FlDu6/8jvMbeOP2v0ItC90QlZAgUhz/fNmkIxGflpcloMAZrOzDBn7SjwP/XjIFvr2z0KtDfRzhkeujoeCou+EUUxWur1YF7UIYmQ8C9aJET8WvSJz+JUVFWfGGAi3rvXAk4klIckfohrRxa7rN6pdOQvpZ3cFhhztV79R5s1N/CDjjNgmtDkjqBh2QSsCtmvX1ucad9IYB87xIWOV9VrhQoUqlQ5F1eq57olSb7YvzxsRIIOGG3bAizRP8JYmq+U/KHwpT2eWOqmJyBjjmsoASaorYknt+nq5L6sJOVzsXIbpwNpZkeEjBTxnnVxTEJicZh8J/XWY94DbZDgGsPSVMS/iU4Gr11+TLqOs4QdQO6vQgdo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(376002)(346002)(39860400002)(4270600006)(4326008)(110136005)(316002)(91956017)(122000001)(66446008)(5660300002)(52536014)(54906003)(8676002)(7696005)(66476007)(66556008)(64756008)(478600001)(19618925003)(76116006)(9686003)(71200400001)(8936002)(55016002)(186003)(6506007)(38100700002)(558084003)(86362001)(33656002)(2906002)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bsxVEjn39z+wrTKTq4vtyxYEyXZ7YzjEeJDnhEhvEHx9TIJUykid5z2zDMuI?=
 =?us-ascii?Q?PkoitTLZSC6jBd5LJqFGONpGe71J3ZrYRZLJpV6k9Sqb96Sgo2BpkeiSKAlW?=
 =?us-ascii?Q?levbQH2/excswXGX9J3IqYG8vgRp7n7CG+/bhnsPp/gZKqZDpFAdxQmrc4Xw?=
 =?us-ascii?Q?duQ/xalXF1uSQ8g18dWJyilnoYs6r6VJKKMtCWcM6gwDXbW9lnRJQ5ZbU4dI?=
 =?us-ascii?Q?vPryBMJPymrk8X+pHf3+y1Mwfs9kmG9my66bpN1cD5rJT5YtS1vvVEzdlveU?=
 =?us-ascii?Q?qYmBdiKfr42YlmJ652CvZphOlOt+xSsIdtbP9ZKQCaQnpbDLEj+WxV9g4cv3?=
 =?us-ascii?Q?ob0UVupcIo+L5UvnsCxwlau05eCOMyBHq4luRYKrQCQEV3g88bPIEXG+y/0I?=
 =?us-ascii?Q?ua1WFPh/gLkmYEIKybfEdnrAS8yKxl7uhljIAfjWYOuN6u9L0udpaGwIpx/A?=
 =?us-ascii?Q?SPXZPpYlzzVV/PGLZyDBUXhQxrWrFdJlkTaW5kPtp2R27Sbx6dVnkl7/28f5?=
 =?us-ascii?Q?KBY0tOVZfPYkrOdw/UGwfuT1dbaCdk8NzKrjxd21eCvESpbqHvpgLLFu/0G2?=
 =?us-ascii?Q?lXhT8owp6TaLyxYc9JzqXX0o+IMekanjCbDqj5ZydAcggPzlTf+Y0GqerpLn?=
 =?us-ascii?Q?MtAoCy52EoraCOKnFu4lWNLDRWNMpqBdgbSXVcqgKbGNypZYhZAh4OaeTUey?=
 =?us-ascii?Q?Y05mdCCXysGA5QTDJh8E+2YAjVtJusATbNrdXxMV4jO19sAd1X6ZSggQdwWz?=
 =?us-ascii?Q?A4RP1bjg+eyAbRi1SoRxr5ypXAB3YyjZqUNWoULPhegg5QEUdtDdsgfE9X6p?=
 =?us-ascii?Q?vlf4gdpab0EwYCLP7EVz+USTGlLEzU1lHXEUAttB/d1hCGsW+ZRFfTIa+KmZ?=
 =?us-ascii?Q?c7Mur8DXCdojgzVMMvQJwlpvo6ez0dcSkyhmuuTsoZXVvRrR6yWDLjn0sWQK?=
 =?us-ascii?Q?fjGqVrTpWBT7iGX5Ekn8hr5Ca+s2gmObFMyqKs1CQtJOJ9/K/Yx5oO6A8Yxs?=
 =?us-ascii?Q?HSK5/6g5Q+ohr0NsRXC4y9UmvZbBdsFxR72LEiqdi/kXm8LhGuWv0h2nBui1?=
 =?us-ascii?Q?6vpULBIIzkUsMjpjx1MQIMmLjui/ub653Db87KIXH4BnQzM6N/vg5BVRFJOH?=
 =?us-ascii?Q?2cefxUjOZi+2FYbcOscVqtZiF8ugjmsMUA8dgqMkdjC9vaGBJ2VwY+In0IWW?=
 =?us-ascii?Q?1lW4W7E7xiht2lPXi08PPny9tVsSGt3KtutvyLmec3sm6unFZKMxihu8zcMt?=
 =?us-ascii?Q?UNO2LGDmXC2GyBDugZK51LE84ctrE/oRmYF6I4pHk58IuBBjRNfXdPx3RGpT?=
 =?us-ascii?Q?FtqSe7/Cf8IwYlypst0QVRKUzgMYURy+1CRafW65UDHA0qP+aDZPjfTaef6+?=
 =?us-ascii?Q?Q1n+pLSMkGUHz6gL2rHe7q3cVz1D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf3ef087-447b-45cf-9b51-08d931589327
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2021 06:24:34.4130
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GPQPrwJgS2TXlhnmnAMFzYjWyJB7butr+WdQY3WGViNoSsl2FFQVpessiqIqQZ7k+GqH/4LMAUGrkV8zSaKY0v6D5Vu+6CvpnMK4v+OsUaY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7285
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
