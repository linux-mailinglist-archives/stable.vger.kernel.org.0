Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4C93ACA4
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 03:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387406AbfFJBNd convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 9 Jun 2019 21:13:33 -0400
Received: from mo-csw1116.securemx.jp ([210.130.202.158]:40462 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387401AbfFJBNd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jun 2019 21:13:33 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1116) id x5A1DLZS010038; Mon, 10 Jun 2019 10:13:22 +0900
X-Iguazu-Qid: 2wHHQt19ee7x6MxTMp
X-Iguazu-QSIG: v=2; s=0; t=1560129201; q=2wHHQt19ee7x6MxTMp; m=PkVytovximZf+X04eLdOmqmOwtpqG1GewyRvU/NImc8=
Received: from imx2.toshiba.co.jp (imx2.toshiba.co.jp [106.186.93.51])
        by relay.securemx.jp (mx-mr1110) id x5A1DKDP038143;
        Mon, 10 Jun 2019 10:13:21 +0900
Received: from enc01.localdomain ([106.186.93.100])
        by imx2.toshiba.co.jp  with ESMTP id x5A1DK5b006560;
        Mon, 10 Jun 2019 10:13:20 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.localdomain  with ESMTP id x5A1DJYx025356;
        Mon, 10 Jun 2019 10:13:20 +0900
From:   <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     <nobuhiro1.iwamatsu@toshiba.co.jp>, <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <alan.maguire@oracle.com>, <dsahern@gmail.com>,
        <davem@davemloft.net>
Subject: RE: [PATCH 4.14 03/35] neighbor: Call __ipv4_neigh_lookup_noref in
 neigh_xmit
Thread-Topic: [PATCH 4.14 03/35] neighbor: Call __ipv4_neigh_lookup_noref in
 neigh_xmit
Thread-Index: AQHVHuNu8OzoZhxZwE2KmkrEWxzIOaaUFMqAgAAAXmA=
Date:   Mon, 10 Jun 2019 01:13:16 +0000
X-TSB-HOP: ON
Message-ID: <OSBPR01MB418448C373F7E3F2D4BCFE0592130@OSBPR01MB4184.jpnprd01.prod.outlook.com>
References: <20190609164125.377368385@linuxfoundation.org>
 <20190609164125.756810906@linuxfoundation.org>
 <20190610011024.utn5fft7nocabqxb@toshiba.co.jp>
In-Reply-To: <20190610011024.utn5fft7nocabqxb@toshiba.co.jp>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=nobuhiro1.iwamatsu@toshiba.co.jp; 
x-originating-ip: [103.91.184.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 44e7b07e-efaa-4a66-c5bb-08d6ed40d150
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:OSBPR01MB2454;
x-ms-traffictypediagnostic: OSBPR01MB2454:
x-ld-processed: f109924e-fb71-4ba0-b2cc-65dcdf6fbe4f,ExtAddr
x-microsoft-antispam-prvs: <OSBPR01MB2454C2B4B944B62129ED26CA92130@OSBPR01MB2454.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:576;
x-forefront-prvs: 0064B3273C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(366004)(376002)(396003)(136003)(39860400002)(13464003)(189003)(199004)(8936002)(256004)(110136005)(66556008)(64756008)(33656002)(229853002)(54906003)(66476007)(102836004)(14444005)(76176011)(66946007)(81156014)(305945005)(99286004)(14454004)(66446008)(73956011)(2906002)(81166006)(7696005)(8676002)(7736002)(53546011)(55016002)(53936002)(6246003)(6436002)(74482002)(486006)(6506007)(4326008)(476003)(74316002)(9686003)(68736007)(52536014)(3846002)(66066001)(25786009)(5660300002)(86362001)(6116002)(478600001)(46636005)(76116006)(186003)(446003)(11346002)(26005)(71190400001)(316002)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:OSBPR01MB2454;H:OSBPR01MB4184.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: toshiba.co.jp does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: TkKm08qU9iFw+Yi5RUB+fFrdc52Buw7G0Uhmzzt5HGCjF1Y4fq+xxHEstl8ROQO4ONNFmt5XuoPL89ySwV5y1+LZBx0PjNNdGjVfQL5MfDSAEzNjIbSTID7Blq4hOAOKkvvJT1NIWUwiYd/UnT0pNsVRbZDf1a7q36erbZ5m/ezmkXbQTlimXYOZXJNcAUlo2+Lq1S2XUBrhiLZ6QVvDFv8h4wVUDPUYSo2J5DsDcRmfMfNzNxAgcTcMLdyq5Pe7HYwsljtvKCe9ouJjFsGL4Y/BBNxxtgydCIsCiXqjJhnNPAB4nrW3YBrw8vDRu7iuHlhHh807AO1d8lEhdsZ4BubEg2nKFiyZO/B96Kl9h1QeUVK/nyEt+9AcW0LE3mq40iCG0mpSsx+FUG6GAJVxeWx9TkMvlOOOFWtfXKLqO7w=
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 44e7b07e-efaa-4a66-c5bb-08d6ed40d150
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2019 01:13:16.3626
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f109924e-fb71-4ba0-b2cc-65dcdf6fbe4f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nobuhiro1.iwamatsu@toshiba.co.jp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB2454
MSSCP.TransferMailToMossAgent: 103
X-OriginatorOrg: toshiba.co.jp
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi again.

> -----Original Message-----
> From: stable-owner@vger.kernel.org
> [mailto:stable-owner@vger.kernel.org] On Behalf Of Nobuhiro Iwamatsu
> Sent: Monday, June 10, 2019 10:10 AM
> To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-kernel@vger.kernel.org; stable@vger.kernel.org; Alan Maguire
> <alan.maguire@oracle.com>; David Ahern <dsahern@gmail.com>; David S.
> Miller <davem@davemloft.net>
> Subject: Re: [PATCH 4.14 03/35] neighbor: Call __ipv4_neigh_lookup_noref
> in neigh_xmit
> 
> Hi,
> 
> On Sun, Jun 09, 2019 at 06:42:09PM +0200, Greg Kroah-Hartman wrote:
> > From: David Ahern <dsahern@gmail.com>
> >
> > [ Upstream commit 4b2a2bfeb3f056461a90bd621e8bd7d03fa47f60 ]
> >
> > Commit cd9ff4de0107 changed the key for IFF_POINTOPOINT devices to
> > INADDR_ANY but neigh_xmit which is used for MPLS encapsulations was
> > not updated to use the altered key. The result is that every packet
> Tx
> > does a lookup on the gateway address which does not find an entry, a
> > new one is created only to find the existing one in the table right
> > before the insert since arp_constructor was updated to reset the
> > primary key. This is seen in the allocs and destroys counters:
> >     ip -s -4 ntable show | head -10 | grep alloc
> >
> > which increase for each packet showing the unnecessary overhread.
> >
> > Fix by having neigh_xmit use __ipv4_neigh_lookup_noref for
> NEIGH_ARP_TABLE.
> >
> > Fixes: cd9ff4de0107 ("ipv4: Make neigh lookup keys for
> > loopback/point-to-point devices be INADDR_ANY")
> > Reported-by: Alan Maguire <alan.maguire@oracle.com>
> > Signed-off-by: David Ahern <dsahern@gmail.com>
> > Tested-by: Alan Maguire <alan.maguire@oracle.com>
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> 
> This commit also requires the following commit:
> 
> commit 9b3040a6aafd7898ece7fc7efcbca71e42aa8069
> Author: David Ahern <dsahern@gmail.com>
> Date:   Sun May 5 11:16:20 2019 -0700
> 
>     ipv4: Define __ipv4_neigh_lookup_noref when CONFIG_INET is disabled
> 
>     Define __ipv4_neigh_lookup_noref to return NULL when CONFIG_INET is
> disabled.
> 
>     Fixes: 4b2a2bfeb3f0 ("neighbor: Call __ipv4_neigh_lookup_noref in
> neigh_xmit")
>     Reported-by: kbuild test robot <lkp@intel.com>
>     Signed-off-by: David Ahern <dsahern@gmail.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> And this is also necessary for 4.4.y, 4.14.y, 4.19.y and 5.1.y.

4.4.y, 4.9.y, 4.19.y and 5.1.y.

> Please apply this commit.
> 
Best regards,
  Nobuhiro
