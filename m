Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97E05209E70
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 14:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404683AbgFYM2O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 08:28:14 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:29522 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404451AbgFYM2O (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jun 2020 08:28:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593088121; x=1624624121;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=jiaDmbQ1ITOjBcQg3sgdw8GC5QvSIpwJbqLfgCD1Om5Flz194aJ7QUwa
   /uob0vHmalWPRmNGA29Jug+zfvZDnT3DkThEQEewKTyhtT5Q8947+6/Ie
   ssyKvyyJhUmTDaE4ioamnyzgBcNLGh89CGkEIXrvGssjWpswR9seCSczP
   Xad9iViBvLXL4MmPlTXRWGU+6uGPF37xsgjYfZGWtxqpIA+3Cqa7KLMh/
   RcYqAr/jfUcVQEQmVTV8VpMlCqg/vAu9Ind4EZusfNUxvtp7zLlP/52PH
   dc21fnI0le6vctUFEdkAxVDo4AiIQBQ1mOFYqWAhuSg9lpDAOxybEXxtK
   A==;
IronPort-SDR: 1dqcDw9ARCVYhKEl3aEzEfEviRrHh+jDQSBNriRqZ6kNPChmZxdkb1/0VTtE1DY61CJxqTnnkD
 C7X93hBhXAXnFPVTGHOImn+pNF2a71UsGAiU/yv98joGQsL5lxetS+N/3MYwUu+WwajVl1C7Wc
 I9FIX+xRKq/K2p/ISGvY4A2lcCsMb0OL1Jw2S/6UMcA3OJdjyNsbIw6CO87WsojmphgGbRB6fb
 7DwRfNUQj58ZVBtpSWumsdHMwU5hrXWM7L3re9g0/h4RJ1VNWElfcR3Rj9Y6TpAeEk2/5h/iRO
 jPE=
X-IronPort-AV: E=Sophos;i="5.75,279,1589212800"; 
   d="scan'208";a="243906752"
Received: from mail-co1nam04lp2059.outbound.protection.outlook.com (HELO NAM04-CO1-obe.outbound.protection.outlook.com) ([104.47.45.59])
  by ob1.hgst.iphmx.com with ESMTP; 25 Jun 2020 20:28:39 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JtMo7mCBdiMGut6CHYD7WCF7p6aOl1jTaOGHimh6PbuFLRHRQKzTjgdA0AvmiVdc0n7Up3F8RXXzdQHLoq90nr4uO7uR/sKeO1xOtwMKGikWVhVCN6ozUM/8sE0c7cnYveMXku2/DmloNuQ5hMIpfW2ol/5ZVPSphSxB0W8cq9+0XEJtb8HV1Y3i5HGhbdTw5TmBkrWDhM0KHaZ/5XdVXVV/KfRtD7Po/R91hC/rvZjKk8kIK4++5d13eAUl+zy7n1VlrJzIb2umVAV7G7oNsMIp/QGaI0kpqAIDDZy9HPCxeuCoNkDJCVsPI0WSW+rI+VVPxu+HPrwNrjLDmFuZmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=UfnHT6CTPtOLvE1ivabm9IwY0smRu4A0QsINSP5V7pdXOpnhu0k8QRkJnSBWsSjeE0wqstgwmnuHXmJO3mpID9wa+enS4Czprh7SnEcQfHTvqdYete6Llk9mDlQ873YKO6bBdUsNt/AH1uBLOxr0Q5FMA8lt7TzqsyK71Xv7UpS3lF58hxru7OB+lwsyHaiJVs5/jRuKifPj+bGhgmEe8PYQCEVSf2czfbqXCS7wVJHWUBQYNo13H5Fq2jsY8fL4Frt08pwtecCrSXpL1hd6phVbifVJfoLAu98iIa3GzbN+NBSL0gq+yRM7ErFnXWMqW3vXc5vjJOmm7iVbLr17LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=MRhwVbLsKXwNkGRikB2ViQzupf/+b/51V+NiIxCaafW/7rXMmggVZLmgYBsxDvEsiEiU62/GLy5Vv6I7JqZasv47maePm19UxZ8z7B5228QXo0TIaxWLKNtjKq5+tZWP0VdF8ojs+9HHs46UR4EtNwgTsENNQ+5UWDgpXztDiZM=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN4PR0401MB3600.namprd04.prod.outlook.com
 (2603:10b6:803:46::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Thu, 25 Jun
 2020 12:28:10 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2%7]) with mapi id 15.20.3131.021; Thu, 25 Jun 2020
 12:28:10 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     David Sterba <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] btrfs: allow use of global block reserve for balance item
 deletion
Thread-Topic: [PATCH] btrfs: allow use of global block reserve for balance
 item deletion
Thread-Index: AQHWStxkHdoIkRro0Uqhi6kh+BBHGg==
Date:   Thu, 25 Jun 2020 12:28:10 +0000
Message-ID: <SN4PR0401MB3598175830F0F16B498476179B920@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200625103528.15154-1-dsterba@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2001:a62:1515:bd01:7422:e91d:655d:8b17]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1a72317d-afe0-48ba-4001-08d819033920
x-ms-traffictypediagnostic: SN4PR0401MB3600:
x-microsoft-antispam-prvs: <SN4PR0401MB360049519E96A1336F45DB4B9B920@SN4PR0401MB3600.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-forefront-prvs: 0445A82F82
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Pf76eB1OvUEod3GGZz2CL3Ft1bRBoCvEBIxCEdPJiuzlYOF4pFYHtZ1ZSFr86dZEbMjazVEd2rnWCOSvJ73jPohBlhCS13F3w/6lN+T6OCUGdI8JrXncW6nImq9s7mHy/vVSoI55rJMuxeKckGUwZHuguFL39yujrqvj6ZoY62ua2DCB/24O3D/1kMMThmMmDySiAnhkgpm91t/zxOorkjFuUUAWEgtd8xSKb7GWDlbqoK01SjLGyMeTT7xfqAdsUlR7V7cm/KZ+YMotiU4TlEZaO1GeRp3M8LGX6/5cy4DQzzp0vivfFf4lxxN1D47p6fm4tZvRcC7SPcr8GF5yxQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(136003)(366004)(346002)(396003)(33656002)(4270600006)(4326008)(71200400001)(86362001)(66556008)(64756008)(91956017)(66476007)(66446008)(66946007)(76116006)(5660300002)(110136005)(2906002)(186003)(8936002)(558084003)(6506007)(9686003)(316002)(55016002)(7696005)(52536014)(8676002)(19618925003)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: iK0Er9BHG0IPWeWwfboOKy7KOVGULQGo9FVMfDZe0u8ZC1iClXKTeyI9CKI/oNr1hkgI7c2y3Lp50KWZOOe1lUeAURiAwHNX+1d9JdUAyBxh9JM1arZRDhEOtSqjhGZ5wah/ZeGKA+g80pm/ta8n57/JUL2oUAzq/QzAr+sRBNtKp3Rl/snKN/UVfpHUF6qnyZNJR1lHxoHambBYn0QFtDbA+CleyAd9a70P59CmJ4ELa1doKz3T+RkgEo1Eshzz/Hm3Nguk9iRiutDZPmS1eD7TiV9jraduyXyohiSQ0anqxmL4nzmhv1iEoeh9GzXk8ZgAaDMkkpEzTO/9EOEZkDyIUxsbqujjOZjGsptBUeuyDnqkYVZD4GXQDAuquOSHG+YMeabNGVa6V2BZCOBm5Wb97tgKYOSWXu8B1L/meipWEf3FhOODv/V+pLhTVASwDIv066YL8HlyO6ggu05lc3UFfNyeQ2GMO/QXS7QHUT+Kxn85EYtbvEfExDxDZVUaz+4urua3/OUB8fKkcqFOD/GQHb3g7hhbei7niRnSTk/6EusbcQORi9XsoG3OsZ4K
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a72317d-afe0-48ba-4001-08d819033920
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2020 12:28:10.5777
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XQD1Gr/TUfKsk/2p8ryhM79wkCHLGpQfiIxzbLYjTdKoI/tNqhKulJc/7OG4GJzlLrFnS9Vn5x+Qy+RUSmZWIjW0pMsJZBi/2kOmmEfMRTU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0401MB3600
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
