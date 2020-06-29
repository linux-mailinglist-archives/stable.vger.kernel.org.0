Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D32920E3B1
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390395AbgF2VQn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:16:43 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:57271 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729737AbgF2Sy7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jun 2020 14:54:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593456900; x=1624992900;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=lY6KGRY00vZpk1y1b1KiXcuedCyfSrjBRDhgfWk5K0I=;
  b=TcFVjxro22BhuHZ5nabsMRL7XTlMOt3cJvfEnmWT62hHXz9ZHED2letI
   cBlr7khrvLmIimY63KRkyiupAWCXwrGA50erToCddhy132L4zRXN8huFo
   27YgCNkHO9kahTKTaePW56ITuZnQ25qufear1GHtQmZB74TjMSOjhKan3
   9vhjoJpI62zmS+YDYy5+DebipzRFtPA0PqX7aPesMImJwbKiwfXsL8ABX
   FHjKrqZgR3Tiv58GiSeHTRT6gWmcyf9ysoEeiCOOANG5K8vXnQLYAlIxM
   mzV6fQ3JHspdyyyEYRpO/3SLlymwOxn+Bsm3kEWYH+5WBMUREKRkzp/o3
   A==;
IronPort-SDR: +sk+bKUJJFv9M2SYNh3xaiqVDUNrfEHkaPB2N9Tqj5FKUA1Uu7H9w/4br9BKPdMgLy7Hw2bYiZ
 HfGJK+AIaM+tiG9Oxc+mAz7mJCQuTMbsMZrgS5xaUmtlG8cuFckmPsvjRrqgb9WnAPC41bwkb8
 hrAcy/877rNDNCc0Q0uKVq/IJaEiJtCrIlmzbHNKEWQAGEgxEEWCMLn8ufkmEXGa/k+SYzrmi1
 a0PDx/Au5gC9LG3zN2L7ARDN5Ce7PNlfQ3Zn6mI4JmH2P9ZrDK2lvcfE0DN1TuVu/sHhnVUNL8
 VVI=
X-IronPort-AV: E=Sophos;i="5.75,294,1589212800"; 
   d="scan'208";a="244177716"
Received: from mail-bn8nam12lp2176.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.176])
  by ob1.hgst.iphmx.com with ESMTP; 29 Jun 2020 14:45:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BXNdZ2ozQyAoMfujeKEq2ok2tFefx45bBLPJn7y0MP8bIoT7UFmDRrZ2EKrfCzNJFlICbF8JTla2oUblKzEuWQwZtjcthn91x2NKGrti06NKL6Bzu/vxTiX0UeszzQtoPf6jQeLTpepUEqMX742fmy8NEiCQpYpZpzBwkfndhpskIQzyxmAti5z1UI2gInDBi3sRYV/r9UPU/UBhjQX1z4VmBLgIRWkFF8vBiZs1hAZ55mnovNjKBPYN6BBmEP+ncEMfpyPUzDPtbzqqiWH/cmE87wFE8EFUFD6HK0K+M7xVbg0tinuolFGYZevtIjOFheMs4GEvWbGNwaRol80Q4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lY6KGRY00vZpk1y1b1KiXcuedCyfSrjBRDhgfWk5K0I=;
 b=YOcm0sZb6JcFko2WFtyPxfcJhfq5d901oVIXJw2n3dBs4ZwHkYG1GO6Vf7rvkgRmFO4J5aAPoJ89H9BDY1dac9KI0wzBgGI+4wgc8WIfclAjjrdZmDHPavOSNLvhU1QnWeuU5i5L4wSHGZYs4vLn5q0534ksz8kLAsWRvplXA0H3UeG2kw4cyTum3ImT8Dv17CuhmmHv5uLhDvqyz3ynlYdSqfVvRSucKfdgYCP5/dXh8INfBn89jgJaLAeEojCRW85PtozBap89+6MjvOo7vOBiPOyEICM0u/mndKD480+0/MD35ECSbKFWPtoSz9Dqz8ZgmvJ92R/9QoLFmBkHFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lY6KGRY00vZpk1y1b1KiXcuedCyfSrjBRDhgfWk5K0I=;
 b=lNI6Bel2dYgfBG5IenwNrbqYFyK+zmEBBmobn2pc3pgv3e9flEeEOIwOe8cWiCZcpLNf1Lbp0NkOgKRaPwbcHIj/IZ1R0x/O5ZLKFq+jym7JaJyn6gOe+pCTbZIzdFlCoY5o40KPjndHtGD/uAa7bbUpi7txoCV7BDkLQv3wZgY=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN6PR04MB4048.namprd04.prod.outlook.com
 (2603:10b6:805:40::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Mon, 29 Jun
 2020 06:45:53 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2%7]) with mapi id 15.20.3131.026; Mon, 29 Jun 2020
 06:45:53 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Hans van Kranenburg <hans@knorrie.org>,
        "dsterba@suse.cz" <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v3] btrfs: pass checksum type via BTRFS_IOC_FS_INFO ioctl
Thread-Topic: [PATCH v3] btrfs: pass checksum type via BTRFS_IOC_FS_INFO ioctl
Thread-Index: AQHWS8qrsfr/R1NuHEqOzFck7FJ8Xw==
Date:   Mon, 29 Jun 2020 06:45:53 +0000
Message-ID: <SN4PR0401MB3598651BFCCF4707CCE4C1F79B6E0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200626150107.19666-1-johannes.thumshirn@wdc.com>
 <20200626200619.GI27795@twin.jikos.cz>
 <e59c3b69-d10c-198d-2f69-b3936f908a73@knorrie.org>
 <b43e807b-97f8-3b46-b29d-46318398a215@knorrie.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: knorrie.org; dkim=none (message not signed)
 header.d=none;knorrie.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2001:a62:1515:bd01:5d2:80d1:159b:260e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 665844f4-dcc9-42d8-3eeb-08d81bf8117e
x-ms-traffictypediagnostic: SN6PR04MB4048:
x-microsoft-antispam-prvs: <SN6PR04MB4048A59AF7A30B6E420368439B6E0@SN6PR04MB4048.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 044968D9E1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VihssC/0IpPyraIPbQ+vssDsmC/N8+n6JjSkirHWCQEsb55eSEmtMFwnfLg/xJeh2hVFBbeNIAyczoNYv9Jnm8m5IMWRbUHVTJUfIyN3uPTGxSUmHdhTAnihxvJMXfmuhY9B15o+YCoWa0gBZeVvWc5ovkWiYCDQ4gXJ3UA5KX0LoislxEbgGQkCS9WFt+OE2ZXZjNM8XetK5QF5ZiOXS/JR076XRGu3n0W+DbRprw+PctfhXtHNJD6GIM5ll18ecAR2UXei19ofW+w+g5jTj7H8xj1qGmj9BMAzH1O3aFKORPADSvzb8Coyb7xRXpAgrY43EepFYA8YlF4rok1xyQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(396003)(366004)(136003)(39860400002)(9686003)(316002)(55016002)(186003)(52536014)(91956017)(76116006)(66946007)(66556008)(64756008)(66476007)(66446008)(4744005)(5660300002)(478600001)(86362001)(53546011)(6506007)(7696005)(8676002)(71200400001)(33656002)(8936002)(110136005)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: fGl+WBD0fYNXOKoIXFp8LJVEq6nE6yuIQpuGn5EOOGY1OLd5LoK83tBAfYjoKp0ZR/TZAF0uMZ3aVDbBzX69QGzyHMXV1SbKAuKmx8xq83/I5XIZFJu0AqBUcLynMmevD6wcIshkGDE0k4+/4N6o6D42El9Tl1aPVPpjY21PoSmXlYdCQgZVwarfTvCckiUE1zaIhWx3zlkMdmNaQQUx7ht4FAKBAb2uqeXN8dwXZKS/LuVGkuCi+8ap/FKZxrSidTrQhG+1WSTBKblUOBqJLIdmtzFRaxGbZ/RjMGugONKt0zy/Bz3t1rDuqGfRUwRq4REZt6s9ew0AnxIBAKWCP4U4VTl1SxADWFo83GcBwdoO3LgqRBRvojiK+lo7kWPiRY+NrocNXzftydZ6yKCXg5Gu3rUAY7emWrsB8HAyxRCUP7jfibT2p5xV2hjKYONAwhcqP/YtXlT2M8sHxgArgrkiraYXI/IakGwWdnsTNRF15BK835UIYJnboLov2cDNIWKSuoWHp2swmlrVQ3N8uvuxvyp4Ot9I/6zvAdkBJMs=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 665844f4-dcc9-42d8-3eeb-08d81bf8117e
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2020 06:45:53.1181
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5+FgrZdWT5yCUyUR+bc15GsFY132q646Uwbr3LxpzUwGPFip0OiRy4i5xdQYAE75xtMqrwRf/XxFO6zAHapRADc1Q/T+ckWN+aqYndXRux4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4048
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 28/06/2020 00:35, Hans van Kranenburg wrote:=0A=
> However, then I would propose to implement that right now. So, tell the=
=0A=
> users that "hey! there are new fields, if you want to see them just flip=
=0A=
> all bits to 1 in the flags input". I mean, the calling code has to be=0A=
> touched anyway to do something with it, so adding some ones in the=0A=
> buffer is a small extra change.=0A=
=0A=
Agreed, let's make the new features opt-in.=0A=
