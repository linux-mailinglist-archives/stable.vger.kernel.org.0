Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 730272A6072
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 10:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbgKDJVd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 04:21:33 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:28373 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbgKDJVc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 04:21:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1604481691; x=1636017691;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=lx/EiCKDUqaBwi2auVmQUlzst3jndcoBgfeDaBFsHXM=;
  b=kz1gxpf6JYZszQdpkieoNYh/bD3vZ2rVQy5cMxZrwntwXd8JC8r2D1Pt
   /Ixf2FCdsV9rsmsBldg7mN5tQja7XlN5ZPM6pPu+dCKJ8EJrbl0+4m8dl
   A4D56VPO789Tp8Ls+rNK5UseNg/KE0167vA3bRlMxWvVL2r6qbxJ/j05Q
   wIozT/LiYfQ4pnFrIDaFIzJ2qD5Q+Hvmt71NLEM0PCuJF5noa+Hp7SFPy
   x5R9Cnkz3+a5gxzXpU6Iv0wgug3BJ6WvLwXHa0RuPqOR5ZMFdN18ef1o/
   kfxQiisb0+ZF0sdpmDUWNCzQ7jZ5IbkjqZL8O4V3zG4oyzDNIm3KlESSh
   A==;
IronPort-SDR: 46Y516HBLidBi2vHjNnMm+9bTz/xdss+7qQ5gZW4SE7nRpasYhBeTZyQ9QO9bV6tyqTK2FsHOY
 wXR7ztlclCpX5fDUGAtuJtbc3Y+nyiREyNgOJZYGcZLnXUBsFMZApiZxM63RkAvxceImpGsAwf
 2ohepejApr0/GQB5Bisqr9Kpf8o4uRQfC8on4hLUmwlrk/TgK2La0SzFhxg/i5luWqS9Fdq8Kb
 NTPdZ9dzRFrSd58fQHvNyuTh7TzvGLQ7ZttbuKH+Ar8v5pZ2V9DX+xXAc1tnZFb8o/v+xbiWpb
 7GI=
X-IronPort-AV: E=Sophos;i="5.77,450,1596470400"; 
   d="scan'208";a="152980682"
Received: from mail-dm6nam12lp2172.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.172])
  by ob1.hgst.iphmx.com with ESMTP; 04 Nov 2020 17:21:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f/I26icdeaLycB0paGfsIDe4iy3ccbuxOCl1HFC3cbwX3jRCadZqnPij1+DXrO84wqhBHlBLBxGwJeq0oePiW3rBm5sXKSL3ncI9VYcUSpyCH4iFBck/h7WCq0f+jhcUZSQJDOfQkEuB34nxt1EUXru8DEQ7zHSdZkXhFttkwRHDALWXg2sCuwwCiqpz8bzne5ZNJkOT8VBmjE6mOX6J6AsjsaIaZKNK1VBYyiMAmiUPW+jWXobwh0g8UjhnGmuhTV/aOmkiS3Trz7G0R0dVFaedJ4GFWT4RS6KLyv0xMl4jcAcn+5KPzkKHyHkTmJgEycMWjgU9T+we4G8HJRwuBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b0HfEk0gdhF/bmfTigEjaI7rST8RxhBHIU8tWb/rWNQ=;
 b=EKSniu7TRaJuwnEam8SH/vDbDAbayTRxuDZA1RqeCPglkWHRsOSJvXB+W66CyisEil7lwDfLvFQcNk7ySzV1lC/bBfjkkQCCneL64d0y99n/K21aoDP8/VsFI/v58puvWhIsBXX6eCSRyaIDXpDs1BZNHfhqxgI3glrraoiBYO/FpmCVvX9xK7FW9vqWPZmyC2y9LyhTWfB1rhn23/wa8JKH1c+LZIHCTS/uiaCbnUb0Q00TGNJFmV1SGGW+t5zCXvILM/xiWwt+yK7ER3YSR68X6tO8UOZ/0KgUO/7qIyljrndDOc/SV/R6s1Vz+5ozJKCLHAlbZqEthVCd4pAk1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b0HfEk0gdhF/bmfTigEjaI7rST8RxhBHIU8tWb/rWNQ=;
 b=iMfmVkZM2mhb1m15d+RSwjZ7mA7xvaOXHtgoQ0sjGNQdao5Asyqy/mMjLWDrFsDu9N5ja35q8cnZMZlay9ZNsebZl8xhTIYEF0oAjBIPyJvlv4cE9VJOK+mCf3xz0SVmGNzWwwEQMxMxtQG45DQ0lMLkRMQIpK3ZE0T3Wjv+WcI=
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
 by BL0PR04MB5059.namprd04.prod.outlook.com (2603:10b6:208:54::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.19; Wed, 4 Nov
 2020 09:21:27 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::4c3e:2b29:1dc5:1a85]) by BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::4c3e:2b29:1dc5:1a85%7]) with mapi id 15.20.3499.032; Wed, 4 Nov 2020
 09:21:27 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] null_blk: Fix zone reset all tracing
Thread-Topic: [PATCH] null_blk: Fix zone reset all tracing
Thread-Index: AQHWsoo9zgKa9lyUMEWyXEEszdUwMw==
Date:   Wed, 4 Nov 2020 09:21:27 +0000
Message-ID: <BL0PR04MB6514A24DB438A568A9C27CB7E7EF0@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <16044134474538@kroah.com>
 <20201104052914.156163-1-damien.lemoal@wdc.com>
 <20201104091015.GD1588160@kroah.com> <20201104091502.GA1646828@kroah.com>
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
x-ms-office365-filtering-correlation-id: c31ac3c6-7244-4f27-24cc-08d880a301f6
x-ms-traffictypediagnostic: BL0PR04MB5059:
x-microsoft-antispam-prvs: <BL0PR04MB5059EA59239F3E048182A059E7EF0@BL0PR04MB5059.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:569;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +Kxmx0Aen9R6sDywtP0rFjxMU2vnzU6mCkxduDeqej00vRZmxXPdrzc9OHbZZLkOMWfkpiAONWzV116GG2TVydPcCXvlihxjUHgWPvsCbeRVA1HTYPihdBEDTuFW0MZR4DLw2ol6gIigxPe0NGVerSAKTjIM7xe7IZAkl628nc4tQLUb4iApUCU5YQenxN3QWc5S5JBeWzU/cLzbvacgWny6PnT5t0a6mObKkLaH952R7QgERm/ac36EeVEPsz4SZV7/Mjgw8LDLFIas6l18Barz0O7haB+3p65+Sdp/Zw6WEQMClGUkFFdVXWCth6furqAjPZSxmcPpHF6UYdYMRA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6514.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(136003)(346002)(376002)(396003)(316002)(6506007)(478600001)(53546011)(83380400001)(5660300002)(6916009)(9686003)(4326008)(7696005)(33656002)(8676002)(76116006)(55016002)(186003)(8936002)(52536014)(54906003)(86362001)(66446008)(66946007)(71200400001)(2906002)(91956017)(66476007)(64756008)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Z7mkd3RVG7+CjbKLaMDLnjaToddMgOZX+Hq+LMUH4mtpCAUH2jIisz2kxiy9kZWx3encs6q/CpeWmqPO8QTbme3atZuwIlbmM0FsnFMDduct4y8gk0lagTxxFO8Vei+oKKwiey8LBIchQr/nlfAcAIXycnLDkRVbTrIMccJJp5tRGzVy4k0+AB4o1cWxCkLFjf1eQ2//lG1AnOgcblsHlkM18nGs8X4WaYH4yro3s7QLZgQCRgHM1QQHPZxWD9ROMrGBR+UA7hvxu4uBasE3aP6AFNNHO3IBsZFBMBN0BK+TSTokFYyjNxdlwtNDhla/G/fH6G7q54wFgXCsHn5zj3WkkCseWBkBaUbBclOI8w7KdrJGlimRRCeIEvD2C9I6WXXUxbG9rqh/E03JDxWUU338h3B8lqcnHsS8WHfCb3ZD71Ez0wtzz29h5wX69LZ/s6n/ywuULIuXITWjgkAdR42tM8ZR3SInD5iPrIHc6NxziRTZmm6FQVRU5HfxyaZDqDHq7/8CAkxzL8nAPwlSC4fPz6RTpaXi5us3MYl0OYFZoOsBAkH77VkNDAo34Uswmm/H247VRuR+FkfZ/lTneltuGAIf7+vWyPx14Jy3NPVz12m/QxcHW/L81lH63jdh3GtX328LJdIXhRAcqjj5Y51GtvxbZLWNfDe+kCtAfXGhzVCMGp78fpGlWqKAUZCfa1RIEVJiL5uTFtwQrvdafw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c31ac3c6-7244-4f27-24cc-08d880a301f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2020 09:21:27.2384
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: stLxpRPDA1rb2pPMYZ+rcqDxobJmD6+PX11ld0cCXUI7flFcBcc0K124xysGxtxYjNxaXSA+zeC6OWRoaJ3uvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB5059
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020/11/04 18:14, Greg Kroah-Hartman wrote:=0A=
> On Wed, Nov 04, 2020 at 10:10:15AM +0100, Greg Kroah-Hartman wrote:=0A=
>> On Wed, Nov 04, 2020 at 02:29:14PM +0900, Damien Le Moal wrote:=0A=
>>> commit f9c9104288da543cd64f186f9e2fba389f415630 upstream.=0A=
>>>=0A=
>>> In the cae of the REQ_OP_ZONE_RESET_ALL operation, the command sector i=
s=0A=
>>> ignored and the operation is applied to all sequential zones. For these=
=0A=
>>> commands, tracing the effect of the command using the command sector to=
=0A=
>>> determine the target zone is thus incorrect.=0A=
>>>=0A=
>>> Fix null_zone_mgmt() zone condition tracing in the case of=0A=
>>> REQ_OP_ZONE_RESET_ALL to apply tracing to all sequential zones that are=
=0A=
>>> not already empty.=0A=
>>>=0A=
>>> Fixes: 766c3297d7e1 ("null_blk: add trace in null_blk_zoned.c")=0A=
>>> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
>>> Cc: stable@vger.kernel.org=0A=
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>=0A=
>>> ---=0A=
>>>  drivers/block/null_blk_zoned.c | 14 ++++++++------=0A=
>>>  1 file changed, 8 insertions(+), 6 deletions(-)=0A=
>>=0A=
>> Now queued up, thanks.=0A=
> =0A=
> Wait, no, I'll delay this one until the next round as it's not fixing=0A=
> something introduced in this -rc series.=0A=
=0A=
Yes, that problem is older.=0A=
The lock fix I sent goes on top of this one though. I can send the backport=
 for=0A=
the lock fix without this patch applied. Is that OK ?=0A=
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
