Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 774A21BD4BD
	for <lists+stable@lfdr.de>; Wed, 29 Apr 2020 08:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgD2GjM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Apr 2020 02:39:12 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:54701 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726158AbgD2GjM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Apr 2020 02:39:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1588142351; x=1619678351;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=vxtXkWz0FtRjFtD2YFm0KRJeZvltPaDMX9Pp0g0j5iw=;
  b=OgUzqy996nDQsFseARQ6cDBnFDIjaalK1VIWBMKsFak4WhiUOFLKotbW
   BPHyDaed74pDg9Qo235i23nXjE7ffmuUpdXXL37007timrpZE/cqqRqdJ
   Lrp/cl1KvNgXOvoICYGacMv7eGUmDgpwBtkfHTNoKRBScHTxsx7xXOJim
   AtyBp6Gd6inNx85L0/ZQQqXD81+L8tR1bGA8X5Wv+1BMF4vMhRfvOHRle
   DdBRKKv8j16PQkvB8ENpEzvuaa4uy66V13u1UtQAdPIcG4gB/KgXSOkxE
   UzMzNny9Gj2tJwjkoeOP3drsVbK1Y8VzInIVCBKpjFsGms44Wuvzm+1sn
   w==;
IronPort-SDR: LuKOuPadwbSto9U2BGbN5nGSjwXd3Cwc/jQiG4fkgAdnBn7DDVzvDXkDfTt2QX2eaXKCkm7eaQ
 UlCnLfL4HG0cQ9XnVeGtFZsTEowERTMSPjaBn+Ic76fTRYrOaF+F1U+ANhZ9fxga37cb8qsyqQ
 mVsqWmnbF8LrA4piuUmUS8w7fQgx88m+vnhycef+bznrPS4Ekkw1l+Lp1fuMlfprMCco0q6Eev
 Qbfm652E0puw9b5cw4Aac1XTEx09clnh1dC0U16GRkHuEBKxwWzsutdgolcxxoJOsVO3GLnV56
 Mns=
X-IronPort-AV: E=Sophos;i="5.73,330,1583218800"; 
   d="scan'208";a="74896253"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Apr 2020 23:39:10 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 28 Apr 2020 23:39:06 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 28 Apr 2020 23:39:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kquvVSQZCZSg/IzJkFh7cSXd+4IEmVdUy4BLC2O8TxqoznfdC2yOmyyKFzlHfRd/CtvTxyuy0EUzCPZyBtGSeJmt1fKRzwftRZdNXZCYHEMstHvLeOnAIm3Zo3pDTgX795qL7/FN66f/f1DDywNxja9UUshRUguaaonjKTx8buZ2hZz4kVbl2y97dqgPdGuyiMVSWBjw+uYy0Kd3n+pFORs9auQzVcY5oxUSdkY3+TqVHpeodtJ8ASGjZ5YoEhS+2PZxS20S80C0y7DXvpSTJD7Lxu2hJo/mZ6HgKy3k9WG+ZTam/hCDYkBFgTbdcnDxeiQGKdSFkVnmeR84Zu75Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vxtXkWz0FtRjFtD2YFm0KRJeZvltPaDMX9Pp0g0j5iw=;
 b=hH0dPTmxeZlosJraspGSA9Ddqphv6tTB44djckH/15J43oHz8ZdREWRCG3b4OPXgyFTl5o2x+SMU+s1d1SlKNK54zyXVBWRAWkcmP3L3IXIUryqpyjz6WKYWUZuj2qibMR9qNA+Vb4hm/6Z6jqX+D1rjnE0z6p9HX0FD+QfhAcLRWgNSj3iSjB5p6k+qKBBr61z5Iqw9tAGXCwjj/7KodiM0guBRvRhjz+f3W21A7dhAIJanMzz3KXgFKb4NJx/SuvSUUOZ5q5FzX5cgi7g+F9C3u1f4gyyO4sex43ZIfKnQqfOJz45WNsmUP1inUaHv3eACLqiKufjk+lNngNWvOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vxtXkWz0FtRjFtD2YFm0KRJeZvltPaDMX9Pp0g0j5iw=;
 b=cr8sNwT5BU6YMaKkYcItObFXO8m547NYOVWYl9UGwf8SVbXTZ2osDR32RFStqa18VU2+q7ItgNGrBxXZk3Hy0Lkb6ZD3UrDLI8coK0vD4kSVUQAJjsRYmSXlK6r9562adix4BxX6wFS+QvnBbe2vDVBJBeDn2+DJ6iL84OV5jps=
Received: from BY5PR11MB4419.namprd11.prod.outlook.com (2603:10b6:a03:1c8::13)
 by BY5PR11MB3863.namprd11.prod.outlook.com (2603:10b6:a03:18a::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Wed, 29 Apr
 2020 06:39:09 +0000
Received: from BY5PR11MB4419.namprd11.prod.outlook.com
 ([fe80::d847:5d58:5325:c536]) by BY5PR11MB4419.namprd11.prod.outlook.com
 ([fe80::d847:5d58:5325:c536%7]) with mapi id 15.20.2937.028; Wed, 29 Apr 2020
 06:39:08 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <alexander.sverdlin@nokia.com>
CC:     <linux-mtd@lists.infradead.org>, <john.garry@huawei.com>,
        <marek.vasut@gmail.com>, <dwmw2@infradead.org>,
        <computersforpeace@gmail.com>, <bbrezillon@kernel.org>,
        <richard@nod.at>, <stable@vger.kernel.org>
Subject: Re: [PATCH] mtd: spi-nor: Fixup page size and map selection for
 S25FS-S
Thread-Topic: [PATCH] mtd: spi-nor: Fixup page size and map selection for
 S25FS-S
Thread-Index: AQHWG+EDIWpaopvk8EurQ9gTxEc0wA==
Date:   Wed, 29 Apr 2020 06:39:08 +0000
Message-ID: <1796337.6gi5k0bXAV@192.168.0.120>
References: <20200227123657.26030-1-alexander.sverdlin@nokia.com>
 <2670775.TqFIqkCU4V@192.168.0.120>
 <97ac42d6-29b5-c5a6-a32d-2214f5f5b047@nokia.com>
In-Reply-To: <97ac42d6-29b5-c5a6-a32d-2214f5f5b047@nokia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nokia.com; dkim=none (message not signed)
 header.d=none;nokia.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [94.177.32.156]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0701ae86-d9ba-4951-8e00-08d7ec08053e
x-ms-traffictypediagnostic: BY5PR11MB3863:
x-microsoft-antispam-prvs: <BY5PR11MB38636089F6A484129D3AC067F0AD0@BY5PR11MB3863.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:421;
x-forefront-prvs: 03883BD916
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4419.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(376002)(136003)(396003)(346002)(39860400002)(6512007)(9686003)(53546011)(6506007)(186003)(54906003)(296002)(316002)(2906002)(6486002)(8676002)(66556008)(8936002)(86362001)(66476007)(4744005)(64756008)(66446008)(66946007)(26005)(5660300002)(76116006)(6916009)(91956017)(966005)(14286002)(71200400001)(478600001)(4326008)(39026012);DIR:OUT;SFP:1101;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ipIhjEGoY4CfN1fGMSH4EfZ/qKjbDN8JMpOTxfKXu25RVwsShSXI4ObSTzXdy2XpKzW9K9wAhuIabETWWXWZ87wPO7lHt50aHUovBfUY0BOVQfKIg5DS9+O0sBpcMcekpsL64Hy29cC00l0hljB1Jf9ZLeGnEb71vIatp2IR0NZ5e4cUx0MTvZj0y08mPVles4pOM7S8gqOM1Z1XKtgoMnTXOXCSJckBggGIoMJzBwvkvXFnRoFLoQr6QASyutTxRT8pJG5XSxliIx7wUPCaCpn0D5t5XONkcb9QVDgKqCKhqJ7J0YyW/YspDx9LCkIJdN4u+xrUWDQM0492ODihDzl6b5jJQyh/UOZ4mUj7rkB2jct+toGR3O0+E1K4wgpRuNHc3MayxNKrEoXVsuD57bC3912xTpR6Yo6a7uDJm+uLhwhk7y8K+dagOKcfBbejBeR1/ZK4rglmdfXrfzKFUiL84bkxumWUKCDCtVTFW+FFU4VsSJNKaGBXTratAaUq+NB80PDwJycO4xMLsY0I5JKFEUX8T7Sk+L8wsCTDnWHphl/OJfs+wX4ACRXeRQkaRd5IkpqePK8DtAQATeBr8w==
x-ms-exchange-antispam-messagedata: 5fTCOHlvQIhiJhjakFH+0IHZzOjY8ILr37IprOSF7jWYU3vt4SAwDFaLtREugf+YIaL5Mn7DC/iN1891NwcAU7B9RtAjDpi61e3sPXGW0UqfcyZzl2qp99lu9ZVpPYN3MZxZ6qw9CZ3/h7ohmNSFdYN8zByltSisW0FzlVKXBztLC8F/q2+e9wOjGF9VzlyMQtWZHtmq3BRDS2GzpF2oCGQ9O+l5KNtbM2sdxhUx4mGkVe5sMfdZf1Va3MiyykSnQRGlB5xN1ceXKNaQF3C5cyUDOUNg8rRZSD5jUAV+s1ZY4k/xVDKqkVKnRloIJMGJ6G7FjCQBhgy18it4NJZR6/q1NzdsTuwyRGZKrUhUWmZ1dtJLYr6v4ApI23P8AjPKuhBFxzE20n6AGjKxq8+H5W2Q7M0Z9aXiPmUmgaH+m96DmSlgxXKVL9sxkglO60pdiUyY0Lh4tz31vYVwUYpl7V6LbBwbxkLVlYGGIn5CTgo77S0E9Vvooi/tQ89Ccg5MkeHaOglfGOZDGSxI9SvKDSGC8rNEal8FE0INq9WmgH8e6i3DfcBnmZlsbyu5p/zvHJoo7Ve7HT/3PrBwR7F4uK01PHiRZsUzzWkg3c99OWNKKsaylywvn430ZrRAGap74Ku8+0ok2pR4JZMkIJ+OroZWH3FyQ3+TUTk6QxOxg8Q5ThR9RtQrwyyp072f0EPije9kSxFni94Tjb4aYw2d2FKy8e2r6EM3dZ2x5NmR1d6u36lfUzqHiTk3JVUHePIH/vmFn4m4/qARvlv4pZradTDMtQj9SKi0zB2tQ+xke2E=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3E0C28CBA2E80A4698EA56CA36573740@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0701ae86-d9ba-4951-8e00-08d7ec08053e
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2020 06:39:08.6504
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: If6ZOJJOsX9bfKlQT2Od5UvS/oC0ngAL0pNeTY8eGIGpz2I9fKsSUKX5sq4YFYEwEAvC8P/9y26Ix/gNCx8a3m4XQOr5g5gtmeeL6vAnPCo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB3863
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Alexander,

On Monday, April 27, 2020 11:23:40 AM EEST Alexander Sverdlin wrote:
> > Fixes: c4b3eacc1dfe ("spi-nor: Recover from Spansion/Cypress errors")
>=20
> The patch itself looks fine to me except the "Fixes:" tag above, which ha=
s
> a potential for improvement. The mentioned commit is not related to FL-FS
> aliasing.

Oh, right, the flash was added with the addition of the SPI NOR framework,=
=20
will use the following instead:
Fixes: b199489d37b ("mtd: spi-nor: add the framework for SPI NOR")

Have you seen my other reply? https://www.spinics.net/lists/stable/
msg382714.html

Cheers,
ta

