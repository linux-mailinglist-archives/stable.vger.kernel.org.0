Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1230821D875
	for <lists+stable@lfdr.de>; Mon, 13 Jul 2020 16:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729840AbgGMO2k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jul 2020 10:28:40 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:45370 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729782AbgGMO2k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jul 2020 10:28:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594650519; x=1626186519;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=4j/vCu2e767l1mTbS63vrJycWLvnEj5yhKsaGbrWHHY=;
  b=A+iJlUa/7o76cfmbieAnkVo1B6ptB6wO+7AeGOY/K+Xigvw76YlIM85/
   +PnKMVSExQY66j+Ww+YfpOInPhqLtpk2sGxhzqsR4FNWIyyIFBnlzALPd
   tSRUMFGEm/3FkupV+qaDUVFS0EGHT6NK4IZvrqpzkY2iH5VGuS+4YsiuS
   hObHDoaMSBdVcW2j81bXmPO6EUzgKzBlnwjbaYyTKKQ+uYl2VOsDjUEKC
   Zl6hHXqKs0A4eKjVH7PJUNOHxm2dxGa6P06jQALCg+tcuF1dMKwqyyYbV
   v7k3Y1R7tEMY4zn8Gl0vPlFt60X2xE+xQilS1PzWHuM+Qw/PUCMsGUU3Y
   g==;
IronPort-SDR: cyrsxsVj2q0WvLPZYL55M8byRc5lFsKFoz/MJJa5jT5jZ721N6eYalCvnG4+vP75XwQH+cBlYb
 +1k7ylvudX7mEbW/5PgzB9rO3jIdgDZV+7ALqAIZaX7WhUWdyNvX/BLWB4StXm4vYuwEW+vp2n
 Tm4I79JlUhqYpJNRBK+xWIjceMC+pA4J8d827eV4rqD8GR+wOWndDi1OgBOhbzTBIr1v2LdVpl
 Q2IZV8+MAHQuVPzZsOwi9hrTUkb9NYkPZ0bdZrrnVk35zHXHyg2xDfGghxZX+5Hu5ySZ+j9eWd
 clQ=
X-IronPort-AV: E=Sophos;i="5.75,347,1589212800"; 
   d="scan'208";a="251580483"
Received: from mail-dm6nam11lp2172.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.172])
  by ob1.hgst.iphmx.com with ESMTP; 13 Jul 2020 22:28:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y+crvGPiftgBAuYkB3aiV7RoytuASz4mgEHaMtBsJ56M7UUZM0UyyahlG8Hy41NqniN7EIbRFo1GUmwV8017/BagidB05Cbm4nGXqumSmLzblaLBALTb7CiCsefSbi5g3+54XPUqhNzW7Jmi9sKcGvVkmwpY+iWS2Fn43taRD+iv6d3feyusKN98lYfL3U/J+3wo3cDQMjGde6v1Rx/0ZniikYuSVj4WwjidFBR9IrcSrMTZCWe3AACtI3Z6jc8tQT336N4rHNBNxrE/GdeqoiPVr9JoWshtxGUEUkohomKPgpSFSS9rHQOYcyIaIV4jNAj0HkbUMF1kBPDSQRpIQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AGIjfDqrObQLDM950YHfa/R/oR2pUiDxxlJwd94fMNs=;
 b=BHLJoXXnAdz5fbAuB4161yzjaABkuNReCNWxj1bn3bkmib99LdX0YsuRc87wOQzKgtGW/ZHagRF12NnuT0DoLpGYfhnmu/GpEg1Uu0WfDGCFy81w69T+PeAipG97wDF3D2ZKMBELEd1tu2EfYrFF2zEwvxLnAfIBbB3rp7EfVgDrOfclT4g6kFv34ZPSWsoa/x+mWvehfTQyr8i+PR/DgnutkIiVNY3LEs7dXK1UO57WKVEBEk7HDN0dyBxwyp4RrRtX2MI6CZQsD3PvdL540yFTMrv48EldxrlYKnENahBI80UXE3zO9dywIO2p46046fQoDI5NYgWzPm24BSLveA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AGIjfDqrObQLDM950YHfa/R/oR2pUiDxxlJwd94fMNs=;
 b=pc967qpBSQPvRB9c4qU07mv8jr5qe7Ozu7jUAA7XIM8Pd6oiLLW8fxGS0FzIeigDj5HmuT+HAyf7FYVheQoj0gKIXn4mxk87WvnpLQOAbE6CtZdrFZHJika+oKioL5Wo+dEZI6CSa9NB/zzNRmshsskrhDIWUZRR9TBEqaHbhAw=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN6PR04MB5406.namprd04.prod.outlook.com
 (2603:10b6:805:102::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.24; Mon, 13 Jul
 2020 14:28:36 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2%7]) with mapi id 15.20.3174.024; Mon, 13 Jul 2020
 14:28:36 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "dsterba@suse.cz" <dsterba@suse.cz>
CC:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] btrfs: pass checksum type via BTRFS_IOC_FS_INFO
 ioctl
Thread-Topic: [PATCH v2 1/4] btrfs: pass checksum type via BTRFS_IOC_FS_INFO
 ioctl
Thread-Index: AQHWWRE4GCWqGtnEz0qAd66keW+r6Q==
Date:   Mon, 13 Jul 2020 14:28:36 +0000
Message-ID: <SN4PR0401MB3598A0145F197C70A681EB5F9B600@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200713122901.1773-1-johannes.thumshirn@wdc.com>
 <20200713122901.1773-2-johannes.thumshirn@wdc.com>
 <20200713142716.GJ3703@twin.jikos.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2001:a62:1515:bd01:3d54:75d5:bb74:f595]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bf924607-4916-4b27-def4-08d827390761
x-ms-traffictypediagnostic: SN6PR04MB5406:
x-microsoft-antispam-prvs: <SN6PR04MB5406DCEA2AD1F4E34EA28EF99B600@SN6PR04MB5406.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KrXRi4AKlaXrrLgdOH7lYdBYUm9yJPMvSqRUc5LvaZRDtajOuEUIE3tu3O7Mjf0QOrVROeckpfPeM8QLjE8H1luEpFb/Tk4gYMfaAm1HiqtY/al/dzfM0frgxdfn5EW1BNE9HjMvm2ZBPhT0m5Yw6YT6c7ozUmgQBjVwo4w/hVOJB17I0XJFJxNb1vXksNcfwk/8a0Jm5rlLPGJzKNaq4ghhdj8/R1dJvceFLoPZRSnccKv8ZFUuk8Wk9e0jsvikk3i1pVJqz9As96DuaqSJ6nUd8AvAKiXTWBs34iug/hthoWpKdBqYynt3nwVXx2qIjoBZKCXK2qju23ZvEKsQ4Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(39860400002)(366004)(396003)(376002)(316002)(186003)(478600001)(76116006)(71200400001)(33656002)(91956017)(4744005)(66476007)(54906003)(66446008)(64756008)(66556008)(66946007)(2906002)(52536014)(55016002)(86362001)(7696005)(53546011)(8676002)(6506007)(4326008)(9686003)(6916009)(8936002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: ollFJQJcOgd+0YEfppXxLBDQnCN91vRlSkZ6Ad8vZvlXpMZetUeWVkh16GUKH4etTUQ+eSIVl4BYVWnwPpipFZ7LxOfNMnTbziaGaGliHETMeZmXHhYetmYHBEdo7A5lSPwiDAeC5LMsY/qeKsQ1lTgWcwcPaPPFB4CBoYX4MeCFsHu+kPnHPhR1UDkKBodVa5TkZlP7h6am0ceYPq8GipWmxvWcLBboydEXw4MNbALqCAKhH2tYO9Fh/ZXdir4fzG5t4Oywn0lcZ/m002MbJOVyPfA0YZofz9yGGnMX6rGusPzeV8I30ItV+X08sp+QkUqbky7jdX58d8MNhiU2hGcYqaLTsee6EXE0JSMdRFhekerxt6ajknDmi/rfUred+Zhdj/eh0+495KQoQwvStiQB6XVUhNBpeBkj5Ggg17UQ+0svVphX48k51ScXXxA+ZbZ8iUDeA88SUKqMfuUTeg6m0WZm2MxMgglm6Q3GhBkRB8KP01QDsLHap2u2HX5l6ODPD0vWsvDa8WOE1fk2VZ1YgpPzFSKtDuMnSW+bWb/aTtKx6irNOKPDu5W/XILy
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf924607-4916-4b27-def4-08d827390761
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2020 14:28:36.2529
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NjGLkG3Rrj/Y8GErPh6qWV+slA5sifP5SBZ2pKnepjnKf0hTqXyKGBw2YfX0a73iUvbgmGGiPyKzcccCOIaDIS3thtvoOm9LGOP2OpvAIZ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5406
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 13/07/2020 16:27, David Sterba wrote:=0A=
> On Mon, Jul 13, 2020 at 09:28:58PM +0900, Johannes Thumshirn wrote:=0A=
>> --- a/fs/btrfs/ioctl.c=0A=
>> +++ b/fs/btrfs/ioctl.c=0A=
>> @@ -3217,11 +3217,15 @@ static long btrfs_ioctl_fs_info(struct btrfs_fs_=
info *fs_info,=0A=
>>  	struct btrfs_ioctl_fs_info_args *fi_args;=0A=
>>  	struct btrfs_device *device;=0A=
>>  	struct btrfs_fs_devices *fs_devices =3D fs_info->fs_devices;=0A=
>> +	u32 flags_in;=0A=
> =0A=
> u64 here too, I'll fix it.=0A=
> =0A=
=0A=
Uh, surprised why GCC didn't warn me about the truncation=0A=
