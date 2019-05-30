Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB0A2EA77
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 04:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbfE3CCt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 22:02:49 -0400
Received: from mail-eopbgr140080.outbound.protection.outlook.com ([40.107.14.80]:34574
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726527AbfE3CCt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 22:02:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9NpNMEfTlthm3jGqhYM7d7QL+RNXpH5LKSdUtRrTB7o=;
 b=L5fdGYvlVj4w8sX2Dtg5XaRFqZW64hHOa8r3VeeMDKqfmzNdn14YXAaJtK2j0Dz03tP7OMJpUKYcF1otCJC4+cKQW7gvM4M284ul2XEJVbU9+3YfYJGrvRww1lDiWEbwcMjR+t/ic14/RC5gB3I80N3EnLtMrrrQBzWRJY72sVk=
Received: from VI1PR0501MB2271.eurprd05.prod.outlook.com (10.169.134.149) by
 VI1PR0501MB2462.eurprd05.prod.outlook.com (10.168.136.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.17; Thu, 30 May 2019 02:01:59 +0000
Received: from VI1PR0501MB2271.eurprd05.prod.outlook.com
 ([fe80::a0a7:7e01:762e:58e0]) by VI1PR0501MB2271.eurprd05.prod.outlook.com
 ([fe80::a0a7:7e01:762e:58e0%6]) with mapi id 15.20.1922.021; Thu, 30 May 2019
 02:01:59 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Sasha Levin <sashal@kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>
Subject: RE: Patch "RDMA/cma: Consider scope_id while binding to ipv6 ll
 address" has been added to the 4.4-stable tree
Thread-Topic: Patch "RDMA/cma: Consider scope_id while binding to ipv6 ll
 address" has been added to the 4.4-stable tree
Thread-Index: AQHVFnrdojY27MvgW0iSfMZmKZw+NqaC6KlQ
Date:   Thu, 30 May 2019 02:01:59 +0000
Message-ID: <VI1PR0501MB22711EFC034FE4C57C62C6B8D1180@VI1PR0501MB2271.eurprd05.prod.outlook.com>
References: <20190530000140.C90462054F@mail.kernel.org>
In-Reply-To: <20190530000140.C90462054F@mail.kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [122.179.25.149]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 02b88307-4653-49c6-c604-08d6e4a2cd0f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2462;
x-ms-traffictypediagnostic: VI1PR0501MB2462:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <VI1PR0501MB2462C09999FFEB8C56F4A4B4D1180@VI1PR0501MB2462.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2331;
x-forefront-prvs: 00531FAC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(136003)(346002)(376002)(366004)(396003)(199004)(189003)(13464003)(256004)(6436002)(81156014)(81166006)(8676002)(229853002)(66066001)(66476007)(66556008)(64756008)(66446008)(316002)(68736007)(76116006)(73956011)(66946007)(107886003)(6246003)(33656002)(25786009)(4326008)(71190400001)(71200400001)(7736002)(55016002)(305945005)(6306002)(9686003)(53936002)(186003)(26005)(478600001)(76176011)(6506007)(7696005)(53546011)(14454004)(102836004)(99286004)(966005)(54906003)(2906002)(8936002)(6916009)(486006)(476003)(446003)(11346002)(74316002)(6116002)(3846002)(5660300002)(86362001)(52536014);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2462;H:VI1PR0501MB2271.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +QPIqJDaWwj6/jWrNTNakeJOy2+YZiXvf/4h9mSar+Usc1gwhb9/feUTHMw5mtrNe245FiR5I5Sezjv9rTgx2gko/mLbnxjuCdcXsPfTzNIktaTuwzP4KDeqPo/6k2T4Rf6igYPRNu3582WwHjcziJ/YQifwp00fNi0R23q8w49I0W+5dsqBQ5fsiQy0zt5EM5/N/u8XuBkxMlvq3U7LhAO3uPAAyyzQkOz8tOeDaeMr6ymsd22ZCqcEQzZMQXQ60b/GAuv3aoRqEnHnsPexKL1IXzs5WaBMFIAsm7imZYJYJiKgHCT+ahBdIv1wSiPpR0OYlp9aJKc2xQ+Epi230TD8n50Lobyd6peiEUz6DHbOXA+uEwt5v1k1raXIESKoFf3Od1ZV5/orGi231YzL4p+egSXkW762CExsTVQTlxU=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02b88307-4653-49c6-c604-08d6e4a2cd0f
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2019 02:01:59.4550
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: parav@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2462
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

> -----Original Message-----
> From: Sasha Levin <sashal@kernel.org>
> Sent: Thursday, May 30, 2019 5:32 AM
> To: Parav Pandit <parav@mellanox.com>
> Cc: stable-commits@vger.kernel.org
> Subject: Patch "RDMA/cma: Consider scope_id while binding to ipv6 ll addr=
ess"
> has been added to the 4.4-stable tree
>=20
> This is a note to let you know that I've just added the patch titled
>=20
>     RDMA/cma: Consider scope_id while binding to ipv6 ll address
>=20
> to the 4.4-stable tree which can be found at:
>     http://www.kernel.org/git/?p=3Dlinux/kernel/git/stable/stable-
> queue.git;a=3Dsummary
>=20
> The filename of the patch is:
>      rdma-cma-consider-scope_id-while-binding-to-ipv6-ll-.patch
> and it can be found in the queue-4.4 subdirectory.
>=20
> If you, or anyone else, feels it should not be added to the stable tree, =
please let
> <stable@vger.kernel.org> know about it.
>=20
This patch depends on another patch [1] in same series.

However, these two patches only make sense on the kernels which has commit =
[2].
Patch [2] is not available in 4.4, 4.9 and 4.14 kernels.

Therefore, patch in this email should not be applied to 4.4, 4.9 and 4.14 k=
ernel trees.

[1] commit 823b23da71132b80d9f41ab667c68b112455f3b6 ("IB/core: Allow vlan l=
ink local address based RoCE GIDs")
[2] 1060f86534147c2830db4bbc9dd849d1892a611b ("IB/{core/cm}: Fix generating=
 a return AH for RoCEE")



>=20
>=20
> commit 33963c60bb63145227c96a9593526841d7f74809
> Author: Parav Pandit <parav@mellanox.com>
> Date:   Wed Apr 10 11:23:04 2019 +0300
>=20
>     RDMA/cma: Consider scope_id while binding to ipv6 ll address
>=20
>     [ Upstream commit 5d7ed2f27bbd482fd29e6b2e204b1a1ee8a0b268 ]
>=20
>     When two netdev have same link local addresses (such as vlan and non
>     vlan), two rdma cm listen id should be able to bind to following diff=
erent
>     addresses.
>=20
>     listener-1: addr=3Dlla, scope_id=3DA, port=3DX
>     listener-2: addr=3Dlla, scope_id=3DB, port=3DX
>=20
>     However while comparing the addresses only addr and port are consider=
ed,
>     due to which 2nd listener fails to listen.
>=20
>     In below example of two listeners, 2nd listener is failing with addre=
ss in
>     use error.
>=20
>     $ rping -sv -a fe80::268a:7ff:feb3:d113%ens2f1 -p 4545&
>=20
>     $ rping -sv -a fe80::268a:7ff:feb3:d113%ens2f1.200 -p 4545
>     rdma_bind_addr: Address already in use
>=20
>     To overcome this, consider the scope_ids as well which forms the accu=
rate
>     IPv6 link local address.
>=20
>     Signed-off-by: Parav Pandit <parav@mellanox.com>
>     Reviewed-by: Daniel Jurgens <danielj@mellanox.com>
>     Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>     Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
>     Signed-off-by: Sasha Levin <sashal@kernel.org>
>=20
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.=
c
> index 1454290078def..76e7eca35a110 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -902,18 +902,31 @@ static inline int cma_any_addr(struct sockaddr
> *addr)
>  	return cma_zero_addr(addr) || cma_loopback_addr(addr);  }
>=20
> -static int cma_addr_cmp(struct sockaddr *src, struct sockaddr *dst)
> +static int cma_addr_cmp(const struct sockaddr *src, const struct
> +sockaddr *dst)
>  {
>  	if (src->sa_family !=3D dst->sa_family)
>  		return -1;
>=20
>  	switch (src->sa_family) {
>  	case AF_INET:
> -		return ((struct sockaddr_in *) src)->sin_addr.s_addr !=3D
> -		       ((struct sockaddr_in *) dst)->sin_addr.s_addr;
> -	case AF_INET6:
> -		return ipv6_addr_cmp(&((struct sockaddr_in6 *) src)-
> >sin6_addr,
> -				     &((struct sockaddr_in6 *) dst)->sin6_addr);
> +		return ((struct sockaddr_in *)src)->sin_addr.s_addr !=3D
> +		       ((struct sockaddr_in *)dst)->sin_addr.s_addr;
> +	case AF_INET6: {
> +		struct sockaddr_in6 *src_addr6 =3D (struct sockaddr_in6 *)src;
> +		struct sockaddr_in6 *dst_addr6 =3D (struct sockaddr_in6 *)dst;
> +		bool link_local;
> +
> +		if (ipv6_addr_cmp(&src_addr6->sin6_addr,
> +					  &dst_addr6->sin6_addr))
> +			return 1;
> +		link_local =3D ipv6_addr_type(&dst_addr6->sin6_addr) &
> +			     IPV6_ADDR_LINKLOCAL;
> +		/* Link local must match their scope_ids */
> +		return link_local ? (src_addr6->sin6_scope_id !=3D
> +				     dst_addr6->sin6_scope_id) :
> +				    0;
> +	}
> +
>  	default:
>  		return ib_addr_cmp(&((struct sockaddr_ib *) src)->sib_addr,
>  				   &((struct sockaddr_ib *) dst)->sib_addr);
