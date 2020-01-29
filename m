Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 024E714C451
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 02:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbgA2BGP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 20:06:15 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:63372 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726551AbgA2BGP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jan 2020 20:06:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1580259974; x=1611795974;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=Jq7S8+0ydLwEVWbHEoSJ4pfEBgN0bXxGspmcNr3ieBk=;
  b=ZDPJ4UjwNcFCFqT/nWPRcmLZa9azeIVBGal/GjWDl7YshQj+/lHgssx5
   MNKx5r5of7DOhQdDmcGy0dI2ADgTDq20fQkdkcxZ2pyzb4SOAoM3mFLfB
   /Bmu684RmHyxwotYw5aVxrowyxd3xsSFcPfGot2WM4GFx+Vo7kH8VYwdP
   G09JJP1rK2hofsMXj8XwECAOleTxvaL0/9XK+3Nm50Xh6aHSJ7nSUKTDK
   BB6NEiqrnHbaA4gAYDbd6E1lIrfgiHCRvRHjOu2UsgZ+ewY5aE3GaogNI
   m3Nj/5kop94s8SgdkzecwbHF5PydwNOscnctK557wdQWtWg4+ydbq0Aod
   A==;
IronPort-SDR: tJwUokIb+R4QaevTZSmxRAhsMq/OVNygvd6773xCdP86Rixy+T2z/rxqEZs3E9KE5nQ+oONEkN
 AY43iTCbU4ENpPxnUQWS7JCao9XhWBJegtwV2i8tbZy9AzAwWgzHzbP0h9t8DKmFZQfNe3dsrF
 LJs/TFeqCy+VhSMW4vc3Z6HuO42v9jWENMXXQHlCJCx64RvPvLjSGJCJqFzw5mp2vF7TNgnepq
 cyqi/pBbCP7nMkj+abs9FhjjOWSrwoe/RnJDJv4VymqaLkJoikwgzX/doJR1WwbtJvHHaetx8m
 S+o=
X-IronPort-AV: E=Sophos;i="5.70,376,1574092800"; 
   d="scan'208";a="128615455"
Received: from mail-bn8nam12lp2172.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.172])
  by ob1.hgst.iphmx.com with ESMTP; 29 Jan 2020 09:05:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DZyeogTYefENSFLPdICVH844marC1V20i/xq06Ab+5dLFfXrIY2WZBV1/0sfK6kXydzAqjETv+mFIYS89iIpCcjrgi+8kJNMCxoYeLBApGRLVSu2BNr1dM3avM+x+V6ai2ZVTD9dpsFc/dP1tqzOD+13ZlxJT9hQzIIzH1fY9f8U6hJeEtXfyjA3a5X5N1wZdaJkPhFYwaM/ogmfL5SFY5oPOpGoPtMypMkhbkbgSQsn7pSB2wv5CsFDkWBkszuBKOWZeVIJV8yihZNQ2ZNTBQjfoSKOzAcCcvrr0O5tJ+1qwDq/8BHbWpggVXTf6/6XkgItFJSNocKK2NMT8PKg6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jq7S8+0ydLwEVWbHEoSJ4pfEBgN0bXxGspmcNr3ieBk=;
 b=k+RTsHH56FTyHMpsdaodX+xdoQn8mKkZlQQBBWb0uPK/cDlIG9U0s5nxe2OfVVjKc6WdNdvAsNk6ivszccjl32fHrrcqklkZ1fyEhsSzYi0Y+ZTetXESq+2HhIvj40HnT8CG4ES9sWS8MgK5zKicseRv8U0JmmPoQm930KsULGgylauLpQ4gGAkVoAO7FS7zzjyfB/wH+v7hXLg0OOiQYHjtM7HBZo6sKwbq6mUanXsOmil4ZLcyTPvcel+/nJr+MDuRYNLteywZFv39mNAM/kj1E+TVXZyMy7fa3H30FhpYgOMk+Xo887f4VbHzyiZlG0byrOJex/Gp5kadn1szsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jq7S8+0ydLwEVWbHEoSJ4pfEBgN0bXxGspmcNr3ieBk=;
 b=NLT+0lPRjoiSK5gXRLJv/9sW0Bw9HGRfL9+21nePceCLjo1qVjKSTWaXxlQm9OaTavGpqBZFcy8QJhskjPlLO+OyRAHgM1iLMI5M99a4XaLXBpq7qKMtD9J4r26wtWxyaoQbfsSaBqo9nac1hxAHFQxI1M8DfBAeQsWuazwh2ko=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.59.16) by
 BYAPR04MB4951.namprd04.prod.outlook.com (52.135.232.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.22; Wed, 29 Jan 2020 01:05:44 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::cd8e:d1de:e661:a61]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::cd8e:d1de:e661:a61%5]) with mapi id 15.20.2665.027; Wed, 29 Jan 2020
 01:05:44 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@denx.de>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Masato Suzuki <masato.suzuki@wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 4.19 59/92] sd: Fix REQ_OP_ZONE_REPORT completion handling
Thread-Topic: [PATCH 4.19 59/92] sd: Fix REQ_OP_ZONE_REPORT completion
 handling
Thread-Index: AQHV1edRzIEinANzs0mRqVpDC7kdnA==
Date:   Wed, 29 Jan 2020 01:05:43 +0000
Message-ID: <BYAPR04MB58166ABC7687F035123AFF6DE7050@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20200128135809.344954797@linuxfoundation.org>
 <20200128135816.802992447@linuxfoundation.org> <20200128180231.GA11577@amd>
 <20200128181513.GC3673744@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [199.255.47.12]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b14bb713-bf83-4b02-eba0-08d7a4575ddd
x-ms-traffictypediagnostic: BYAPR04MB4951:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB4951D01A9C23F3CD498DD5E8E7050@BYAPR04MB4951.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 02973C87BC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(396003)(346002)(136003)(366004)(39860400002)(189003)(199004)(316002)(8676002)(9686003)(5660300002)(110136005)(54906003)(4326008)(53546011)(6506007)(26005)(71200400001)(478600001)(8936002)(66556008)(66476007)(81166006)(81156014)(66446008)(86362001)(64756008)(66946007)(33656002)(52536014)(76116006)(55016002)(186003)(91956017)(2906002)(7696005)(21314003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB4951;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eIA7Leeiw0ShxfQ8ibWoBC96m7sXRu+YvUzGXs99g2jTB1cvIaFXIewn6azaMMAvoUvvyMW0slHIsW497hx2/rWqb6WVs6dzUXRvN7ggzlI18FHj3Tw6k9rNtxtHCTNmZOEC/6u9rufRBSw2jA/EQmYpOZS4CEjL6oGQ5XThGbMHI61ETwb7AgQnANilf+IdXWeyHoVsBXyLmUX6GvWiO27TZXGBbFwtqP5OcTIFt+mHUikl/qyeiFITNLCnZ8Hz6fx+Ruz9hWpHGzLfMxXf7FpoeL4faoiPeL75iCEqpi2EfDm9zZ82fUa/pdo52EgrL8mehGonzrKvFW898mvIARK1kQblkyCdeefbvFvhOXnkoWNaF11PlTr3kx9NUIjJBQctEc7ZveGhxghcL4E40mB6hwB+0nCFHG3ekGknUOxO1SEaUFPabarfYB+gdDqK24RD7l9KzcLpFLw3zxxIYlWWHR+zj2l5Oa7jhJqsTXL9F4pq2HuECgAWntxqO6lH
x-ms-exchange-antispam-messagedata: zu8vQIEPFAs0ouhKBTCDVUF+perqDOiJD7UJWmZdTH0zzKqgxhBXpmExG9PH59+OdSe7HcNq9bf5irEGSRv8JuKHadmyxbZ1nb5UJTyKusX1QZd0Mmi+emwYfsMxkPdc11vsh7Qi5i87utWOu4rcxQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b14bb713-bf83-4b02-eba0-08d7a4575ddd
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2020 01:05:43.7291
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BniQXuk23voqji2+YcfkquOPc/xp2UeDSYF+2RKs93CS5gurcHxlKiDmKETsJqoakjuM0YB+MdTkiJ6dYJNPxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4951
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020/01/29 3:15, Greg Kroah-Hartman wrote:=0A=
> On Tue, Jan 28, 2020 at 07:02:31PM +0100, Pavel Machek wrote:=0A=
>> Hi!=0A=
>>=0A=
>>> From: Masato Suzuki <masato.suzuki@wdc.com>=0A=
>>>=0A=
>>>=0A=
>>=0A=
>>> ZBC/ZAC report zones command may return less bytes than requested if th=
e=0A=
>>> number of matching zones for the report request is small. However, unli=
ke=0A=
>>> read or write commands, the remainder of incomplete report zones comman=
ds=0A=
>>> cannot be automatically requested by the block layer: the start sector =
of=0A=
>>> the next report cannot be known, and the report reply may not be 512B=
=0A=
>>> aligned for SAS drives (a report zone reply size is always a multiple o=
f=0A=
>>> 64B). The regular request completion code executing bio_advance() and=
=0A=
>>> restart of the command remainder part currently causes invalid zone=0A=
>>> descriptor data to be reported to the caller if the report zone size is=
=0A=
>>> smaller than 512B (a case that can happen easily for a report of the la=
st=0A=
>>> zones of a SAS drive for example).=0A=
>>=0A=
>> What is the story here? Mainline does not seem to have this patch, so=0A=
>> this is not the case of "upstream commit xxx" line simply missing. If=0A=
>> the same bug is fixed in mainline different way, it would be nice to=0A=
>> point to that commit..=0A=
> =0A=
> Yes, this is not needed in 5.4 as it was rewritten differently there.=0A=
=0A=
Correct. REQ_OP_ZONE_REPORT was dropped with kernel 4.20 and report zones=
=0A=
is now handled through a device file method with scsi_execute() instead of=
=0A=
a BIO. So this bug does not exist in kernels 4.20 and upward.=0A=
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
