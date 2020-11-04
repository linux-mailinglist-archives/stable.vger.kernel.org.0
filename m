Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB11B2A6084
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 10:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbgKDJbm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 04:31:42 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:43627 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbgKDJbl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 04:31:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1604482301; x=1636018301;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=ojfZlXyKOrNqvwi6p8PVUDnxRWIKABr4Wx9e3xAjP9s=;
  b=qB1XmlCbupnU5CJ7BDXRaZR9Xtcxn8R/2E0+Fg3lSoi/Ckh+6Gg6rhN7
   h8TuRB2+Go8qPE+vulYJmObWgN9wEuUrSRwz33R7gUNJyay0e4fLIPwvL
   HZtQEloz8Hk47ZI+R1XQf9BsIldalSAARtDULZ9GfG/cLWkVkRj/1xwkI
   tP30vxg3LfC3PAu4R/Ln5QmHHV3ur0yyh0/xI1YGOYNdiPwufosYAVzxg
   4+ZHRr+CGGePByBF+OP/JsrXzEVwQ8dveVth6CDHnip9Y2gKjS29GcsF/
   3gHfhJSv9v49LuLSoLnLzxhC2/NKTUKBTzhus1aV5HoCO32D6eDHZfeCN
   g==;
IronPort-SDR: R08o82b5sy5vAQm2djHsWdigNqmDQHP6vYA0gp4gHKaoXRhGX2CYlpmhUKQMamUrLSVCHcfaxB
 x1d5+nEGZS5p1Sr6fq0oesZS8vvPNyFiTiMg/HseHIdcDyAkURPXuLjyz7ORmhAdtAVykTqgOh
 IaoxPivUCH+VuLdyCfkgw0W5Fd2YBsps5l0+rHsDn+TA1m51w4Jz7uuoZSh1vS4H+fBXZo5q1p
 xpAIPHZlLjKjjHtA52u8HXF1ex0omN7xQtxuuM1RNLoScjF6Hwz9aOHKQcwRPntXLBQcGMdLq3
 JxM=
X-IronPort-AV: E=Sophos;i="5.77,450,1596470400"; 
   d="scan'208";a="261746626"
Received: from mail-cys01nam02lp2053.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.53])
  by ob1.hgst.iphmx.com with ESMTP; 04 Nov 2020 17:31:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HGlbp69z5MS4vT9dmb9/UNBgBnH2GVPj07B05KiI0Ylf0y0+QUf4eZmk2uUpkRzkcjxyejFoaf0GHw/+A6OkjCnCoF0AfH11qx1FoA6G+MadSmLg3Wju9OZQ9RnCdyrlmA7LaOfgyN8y8lqfKWUHN3m2AFEuF4Rj0BT15oLDd756nZxzvF/3uri44xMba/tui3+qfArRyznP+xjw765VoghU77w5fBYr6R414q4UQmCyJlV/iaq2J4ZqZpKyp7kbEDcLefq3FPIaUJ9kckSqfAPLizTjL8ar9xhVQkC4u8puTntIOtRBoy09z0EBHq13PsTPM1JhRCoUGmvxyfZV2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pnPW3JMEbeA2qZnQ5yEV8gK16wmTQMvifBocmcZBD34=;
 b=kodGic38YhwWsvVEZQm+C8xT1gSblK4lgZJvdJ0Z0bcTusKBohWJtrSVg+qMrL0iWr23OI8GfKfSsHxsdH9894Nf3dfzYbhtGFkklBp+LqjP7rb83g3iddsb2zHDE8Tw7IPdTxuCt5ZdXrNVheNUuiHQrs+NaLqazatQN1274EIgjDRLRxD1Vey3JlAze2HWNoRm1xMYKOK9FDEcMA8Sw69yU2lTpQ5h2Cmzjx6Z5IdsuhX4yUtz//cYS89ZB9kFQQQjnK4EHH14CsthS4NPMHmm2TxPnSyMVd6IxjDkmZzBfJXxeH4tzuT9OjT1rB1lFUZ89xdFZkm2z/ixyFCWQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pnPW3JMEbeA2qZnQ5yEV8gK16wmTQMvifBocmcZBD34=;
 b=xfS6AB6tdxLTnF6C8qLvGazwl6NDRnLjDuuiT5mRQGXN1vbh+wv2phH4cnArI3fFWU1QOyfyvIoT5Et8XuuqkLILlby9ygIvjehlmi8hTEYYF4bgnXZiB2uzkDBU9A7y1fAPycohwook/wcXwp6A1JNegN2RAJez75XnZ44pZfk=
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
 by MN2PR04MB6640.namprd04.prod.outlook.com (2603:10b6:208:1ec::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Wed, 4 Nov
 2020 09:31:40 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::4c3e:2b29:1dc5:1a85]) by BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::4c3e:2b29:1dc5:1a85%7]) with mapi id 15.20.3499.032; Wed, 4 Nov 2020
 09:31:40 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] null_blk: Fix zone reset all tracing
Thread-Topic: [PATCH] null_blk: Fix zone reset all tracing
Thread-Index: AQHWsoo9zgKa9lyUMEWyXEEszdUwMw==
Date:   Wed, 4 Nov 2020 09:31:40 +0000
Message-ID: <BL0PR04MB65143D636C72588134EC3E17E7EF0@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <16044134474538@kroah.com>
 <20201104052914.156163-1-damien.lemoal@wdc.com>
 <20201104091015.GD1588160@kroah.com> <20201104091502.GA1646828@kroah.com>
 <BL0PR04MB6514A24DB438A568A9C27CB7E7EF0@BL0PR04MB6514.namprd04.prod.outlook.com>
 <20201104092742.GA1669921@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:830:5e48:69b5:9288]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8fd34e4d-ff2d-414e-b2fe-08d880a46f2a
x-ms-traffictypediagnostic: MN2PR04MB6640:
x-microsoft-antispam-prvs: <MN2PR04MB6640ADCD4496EF10040BF708E7EF0@MN2PR04MB6640.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +5LR7sEufjXcD9v7mPPzf7eIB4FMNiFPtbB+DeMGf/+WspkYJYb23vqVGvDQdihL8fxL4h+B5S045/bxvvCM93T8EjhdKNWBGUQzqEOfnWJ2J1LD2/0M0w/nrdEAntYCo8yNeoBrAk/+O5WcgV53C7OALKh+N/i5j41k/NqgQXEN2Fkuh12elH11gEFnube0e2PxhbwgsBntQeKXJ5S4m9fUvLJZWt0rI5gAJD6ZcYa6mtxW8V3OPUxGlkWusxIiZhCwjMblK5hFm+0NwOIquWYdXp1PW5R6Tp/tdimmbhEhnYPwBNm9Q4+I+ZWH0DrOfCNTM5tyiFZKDcwQV7LjIA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6514.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(136003)(39860400002)(366004)(86362001)(8676002)(4326008)(6916009)(33656002)(8936002)(71200400001)(7696005)(66556008)(66446008)(478600001)(64756008)(66476007)(66946007)(54906003)(53546011)(9686003)(91956017)(76116006)(55016002)(5660300002)(52536014)(83380400001)(2906002)(316002)(186003)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: eoE44XxMjOrwfo6P0+42Y0BCRIVlE6WgZk//ij56Pn0qqeDTYs+BDwmoW9Xl4cj+lJnZ7liQ4rMKe0Sz4cUV2zWotVTvZx27Wf9wh2LnIQZWGRFylLBXDxtTMSqH1q9JO4RxKwlwtgXE87CtOMrpYlBPW2TDcu1oK//2rbAxhyLPpo/vfWsZJ8ozuCx8mRT143g8ENuo+jlAoZ65Q7UdsZuJp/pEbj7R4wtW71eHmGItHurs+YeEaVhjRya364XqCE25Ewhj59mmAJFZNTuew1K6LnwxRSvUlpJ0fjKLJ5jBboSy/SjQrlRy4ngPhbcWBZRyH0F23iL/wi6U7QRvnayxoLnGvZ6IBR5MjX260bz2Manl//n7mEMzvsPnxpNFxNcdlwXMjnQ+THnomzGsl/c6BSUzC7cA4SCLih8G2aQqg5z1QO5q2IbWkoN1N+73Apda4TeOjganSOpC81ofsTDWSFCIyGjQdrAHSxETdwMgqc2JYLEeH3J7mSz1lcHndi5wjeJ3bzaFQ+TVboL9DgAFXiS2i9BOy1zIVawHbkgMEhxtkHJ31Yway3dgNtZisuWFRJK+j0bXUKTKpRrhHTT//HWUYxZevACRp+JQyW4b7HC64TXOPzFHwaKNndYYfoeJXnH9ePrzLMqKyT2aptlPW2KyjFyIw9l5XaI20bjY0ZxEb43+KPUUMS2g+e3ApYB7fwe714ZA4YR2QxBHUQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fd34e4d-ff2d-414e-b2fe-08d880a46f2a
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2020 09:31:40.0309
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: auQu/6I7GJTqIItDsX1WL7xL1CRaOxycFPK8hI6Hpn4M5zcknB/5fzCHgFlFRz9oDajFJ5/lZjNowh2p1o/zbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6640
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020/11/04 18:26, Greg Kroah-Hartman wrote:=0A=
> On Wed, Nov 04, 2020 at 09:21:27AM +0000, Damien Le Moal wrote:=0A=
>> On 2020/11/04 18:14, Greg Kroah-Hartman wrote:=0A=
>>> On Wed, Nov 04, 2020 at 10:10:15AM +0100, Greg Kroah-Hartman wrote:=0A=
>>>> On Wed, Nov 04, 2020 at 02:29:14PM +0900, Damien Le Moal wrote:=0A=
>>>>> commit f9c9104288da543cd64f186f9e2fba389f415630 upstream.=0A=
>>>>>=0A=
>>>>> In the cae of the REQ_OP_ZONE_RESET_ALL operation, the command sector=
 is=0A=
>>>>> ignored and the operation is applied to all sequential zones. For the=
se=0A=
>>>>> commands, tracing the effect of the command using the command sector =
to=0A=
>>>>> determine the target zone is thus incorrect.=0A=
>>>>>=0A=
>>>>> Fix null_zone_mgmt() zone condition tracing in the case of=0A=
>>>>> REQ_OP_ZONE_RESET_ALL to apply tracing to all sequential zones that a=
re=0A=
>>>>> not already empty.=0A=
>>>>>=0A=
>>>>> Fixes: 766c3297d7e1 ("null_blk: add trace in null_blk_zoned.c")=0A=
>>>>> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
>>>>> Cc: stable@vger.kernel.org=0A=
>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>=0A=
>>>>> ---=0A=
>>>>>  drivers/block/null_blk_zoned.c | 14 ++++++++------=0A=
>>>>>  1 file changed, 8 insertions(+), 6 deletions(-)=0A=
>>>>=0A=
>>>> Now queued up, thanks.=0A=
>>>=0A=
>>> Wait, no, I'll delay this one until the next round as it's not fixing=
=0A=
>>> something introduced in this -rc series.=0A=
>>=0A=
>> Yes, that problem is older.=0A=
>> The lock fix I sent goes on top of this one though. I can send the backp=
ort for=0A=
>> the lock fix without this patch applied. Is that OK ?=0A=
> =0A=
> If the order of the patches is needed, then yes, I can take both, please=
=0A=
> submit them as a patch series so that I know this is needed.=0A=
=0A=
OK. Sending that. Note that I still do not see Kanchan patch applied in sta=
ble=0A=
5.9.y branch, so I will do the backport assuming it is applied. Or I can se=
nd=0A=
all 3 patches as the series. Which do you prefer ?=0A=
=0A=
> =0A=
> thanks,=0A=
> =0A=
> greg k-h=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
