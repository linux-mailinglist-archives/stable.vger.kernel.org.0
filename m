Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFE7421B312
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 12:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgGJKR6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 06:17:58 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:13883 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726955AbgGJKR6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jul 2020 06:17:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594376278; x=1625912278;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=+WSeFlDbClBS7HkfGkLjXAxMFJNfUH9DUsmhgZujBVw=;
  b=KXH3sOUAB2tKeHHj02GFEpVCp5/cCbrzoG+6BTyDxZsP5V2+FPwtSTtH
   ud5D9E3Yvjrp1DKUR3IP1IUkF5x1UmYx8uTbgE7fBgztBO+CCW8LlIxW5
   o9J0AONKIMbh6PDJedBqsX14jh9rd8CPSLApI8TaASSoaqzpiLObEFPqC
   GEKwXXcBpch4POPhcimWGW9/jt/LB9JxnOYEi40ZxfktDeM59dNX11oxx
   aXwYd5XzNrpd4Ca/lnPkgN5bUNYlKP/gstMuTH1X9scIKhhVspNK97lfD
   LX4O3HqECfevawHqS5clKBXl3MkHSpCcefY8YvwH55+mVtbvS630uqPLO
   w==;
IronPort-SDR: Rt1lK/2M9jD+YrpxrY+VfIrAJDHnVYR5AGnOGSMgSfO1qvFM1ad6SgRDlD3aKph3eXrDFn7ZzK
 WET8suq0hritb1mbmym4KG052z245PIEF3YMnUPv0lEGZHu42FXrF/94D8E8HGxGB99CIyN47U
 lWDzDYprnD3YZw7JalzaOg7xBfe25Wl3xJt6WYc5FsgODUpOSV+vNT26aCYwWbxkq2CuEWGYsG
 Ds/4wgjKjtpVFrD3ftmF6P3ZWUBu2fzCL7H2K+VFnGqYf0hIhBShdbJ6o8IDEShzuppeS4SsiL
 r/I=
X-IronPort-AV: E=Sophos;i="5.75,335,1589212800"; 
   d="scan'208";a="143442221"
Received: from mail-bn7nam10lp2100.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.100])
  by ob1.hgst.iphmx.com with ESMTP; 10 Jul 2020 18:17:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QSe7bVeoZHgFPBUdNN8yrnPyMjtgNuJlfy8KguxFB6Y+zao20zRu+tlG2VyJEB1dccOZK9iK9vo1AaVZnakJ3XNL476Qm7H65QeizZ6TJe6x+rd9y5a1L7X2jknWwAiS3hnPo1HJidJ0vFsN2vTi5hbjcpb4Zwh8GcccbJGe8FxHp782B63+d0/+yNivbRknxcZteVrvtxGolekHCQfveFL3NRJIZTFukoSASTZvpsrLkOR7IrTJrQP1HkojBhzIH8KmOc6L0bwOFcOcEYyMkugwGv7sH+bZjsS/JtyWGazyDb1LfDtNjYO8DOThPBPdyrbIn6uauSWCab238EIDTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GKgnj83Hmqx/FpKtVj26OaN9k+BBc/ICDoLg6ZidqIw=;
 b=Ky2ecnXbXyzIVu/eKWdKBrOgTcwO7OwqedA5uBJIDD8qzUBtQDugpqCfQ347L7g4KWwtce3jQTqTNkXixOqCtLdcJZfDMuVLPJ50F12tWcV8KjNX2p5dRZEufgEWwEsd4h8GHNIXzbELiUG46bP+eWPdjwTiCN7nOhugOPKHmA5dB8CN7v/6VlSHicUxPysYBeWBMRrzggv0C8ZbXgxIgdKZx20WXQsZf6ey9C3V4+fXLzqfgLVPjaz6u1t1dPLFLqO0dVvVC/FmkkG1hVbYgj3mvGUoDbVc/bGxScIsdBPBy7+pAD3ObKrgD/94Lpzo8qCpuDN/dI5IwtPls0J2aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GKgnj83Hmqx/FpKtVj26OaN9k+BBc/ICDoLg6ZidqIw=;
 b=EGJFuSFruh0U1imqV6H1urhWwAM4e8FKQwdlHdSNBrotOWCj/fS4V4pi1etLyxEMuQP7EYWMNaHPLPmj97ve36tDFpnd7WbeFuBmZ7uM1V3HJk4pP8PLSYfKR1TpVhnEZsT+ctKCvazB2YuTyRdxXgG6KqgXwUaF0SdGdYi5IEU=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN6PR04MB3968.namprd04.prod.outlook.com
 (2603:10b6:805:3f::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Fri, 10 Jul
 2020 10:17:55 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2%7]) with mapi id 15.20.3174.022; Fri, 10 Jul 2020
 10:17:55 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     David Sterba <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] btrfs: add missing check for nocow and compression inode
 flags
Thread-Topic: [PATCH] btrfs: add missing check for nocow and compression inode
 flags
Thread-Index: AQHWVqHChUbiUOrc7UifhT3qjKbQjw==
Date:   Fri, 10 Jul 2020 10:17:55 +0000
Message-ID: <SN4PR0401MB35981E3913C16CB69DA42DF29B650@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200710100553.13567-1-dsterba@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2001:a62:1515:bd01:3d54:75d5:bb74:f595]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: cddc3097-491e-45f5-5a71-08d824ba8315
x-ms-traffictypediagnostic: SN6PR04MB3968:
x-microsoft-antispam-prvs: <SN6PR04MB39686204C583AA260ECA6E8A9B650@SN6PR04MB3968.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xkKCZY/vnpT1zb8WHncUyJtjGJN2aYk0WZxmyzRje2KHxkrKAMmuzir0VRjWPZABrEGlHn9aZgZXl3FkRzLZRpPhcQQ3k79dz/ADEarwb6NiVogEK2NXUN7q79KbCLRddkjShe/UI3G27YhLm5ULf7gHlnX7V3v5GByhgv4ossBSe2mR+6h61pBFruk2Ci+0geJXI6t5oLsObhSY2IaDZZ+zUDbi2nc4URSH013cu52Lycb+/ENQy/2hhngWhuRxoddmhpIrjlROna6GXpYXcDfJ1xEuaRx8hPOQp5QmQqEO13AE5qtru6a+VG7xC2Ai
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(346002)(376002)(396003)(136003)(366004)(2906002)(66446008)(186003)(7696005)(53546011)(83380400001)(316002)(66476007)(91956017)(478600001)(4326008)(66946007)(64756008)(55016002)(66556008)(76116006)(110136005)(4744005)(6506007)(86362001)(8936002)(9686003)(71200400001)(52536014)(33656002)(8676002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: z44vvPvieZSsUX5wJq9mt9DKUAhM2P7L/zZCowISnJPSRaIMSsbX/7048FODLoJgbjsEj2utVHU2Fl4FRk044q393tia21MrrDp+I+umTEPqS0bE/PzZ6r21Or8QqwiELsjoIgLE1/9LZ3MehXZIjG6/itVLKzqIxtNedj0bQPeNl3osegHtIYTuf4ZEQLQraeJzqbDnE/u/60eaxGpw83rv4ygOV+/udqT9Ap8B68gn51pvg6KKSogh64G5MxfOSK3QXmgFiuPappTPZMubJCUcMxBjzKYrzDgVjk+bptZ1lUF8yM1UkNWyQLxI1Na1NdyvFJKmw7gJOorM6x/qNBJKlFb9i43tlpWwn7oc8l8oa344Rz1r/8FXcgKlm/kELAagSg47LmbsgtkI83ptOCtwd31OYhbNMCZPOXl78oq+ok26K2wQKzrr/tkDTcw+cksrVvuXy0Cl40ozB48hKM0sRzSmEC0esJ21b9w8phK76a5agTilmQIn9v+sGseZscDWdj6UN+xhd9oVcTwwY2nrb0lFI3OkfM/Pkc3nNxBCZuTIoxE39HIj/dr5JcxB
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cddc3097-491e-45f5-5a71-08d824ba8315
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2020 10:17:55.3357
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0OVSudbL1ZVDNNTsW0HP/9/FLMVEnYsfhcBTsIEkfnCIpUT/B1S1jBYJcf5Y2ZKWBNKlaHFGCaYxTkiXab7+7/4As4Un/AZzSLY6McpekaI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB3968
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/07/2020 12:06, David Sterba wrote:=0A=
> +static int check_fsflags(unsigned int old_flags, unsigned int flags)=0A=
>  {=0A=
>  	if (flags & ~(FS_IMMUTABLE_FL | FS_APPEND_FL | \=0A=
>  		      FS_NOATIME_FL | FS_NODUMP_FL | \=0A=
> @@ -174,9 +177,19 @@ static int check_fsflags(unsigned int flags)=0A=
>  		      FS_NOCOW_FL))=0A=
>  		return -EOPNOTSUPP;=0A=
>  =0A=
> +	/* COMPR and NOCOMP on new/old are valid */=0A=
>  	if ((flags & FS_NOCOMP_FL) && (flags & FS_COMPR_FL))=0A=
>  		return -EINVAL;=0A=
>  =0A=
> +	if ((flags & FS_COMPR_FL) && (flags & FS_NOCOW_FL))=0A=
> +		return -EINVAL;=0A=
> +=0A=
> +	/* NOCOW and compression options are mutually exclusive */=0A=
> +	if ((old_flags & FS_NOCOW_FL) && (flags & (FS_COMPR_FL | FS_NOCOMP_FL))=
)=0A=
> +		return -EINVAL;=0A=
> +	if ((flags & FS_NOCOW_FL) && (old_flags & (FS_COMPR_FL | FS_NOCOMP_FL))=
)=0A=
> +		return -EINVAL;=0A=
> +=0A=
=0A=
=0A=
If we'd pass in fs_info to check_fsflags() we could also validate against m=
ount options=0A=
which are incompatible with inode flags. Like -o nodatacow and FS_COMPR_FL =
or =0A=
-o auth_key and FS_NOCOW_FL.=0A=
