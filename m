Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51762623AFE
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 05:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231726AbiKJEgf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 23:36:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiKJEgY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 23:36:24 -0500
Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E8DA18386;
        Wed,  9 Nov 2022 20:36:23 -0800 (PST)
Received: from pps.filterd (m0150241.ppops.net [127.0.0.1])
        by mx0a-002e3701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AA3m8dH006614;
        Thu, 10 Nov 2022 04:36:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pps0720;
 bh=E5egBRuKG1IXybHVuCSGRouIjcPHn7sUoXfDDTgu2BM=;
 b=h8qGuWz2w0PkuPEu5uTIArj9j543jF0y6sMaoAKcQS08SjqrV9vOYl+n1ZOljlbSqpnZ
 BPEsA9JaaCRJkNccNX/um+c5B46y9s4ZkIoxrJLpeqjfaC3/Z/Myn7eRAuawTXdXD2KH
 ty8vd5Lz25a5ROTUOFcfAmxB18W3GRJWIlsWE+mkCaSoiJlXUhUFwiVoJItI9yRcdU5p
 RYsh+cCWmE742v+GZjbRoyyuK+2XaJMKDTUoVZbH1QH/SeJL8OfanOCezXPU77UQUlSh
 kMZixcdUGj5pDZQdJjJh5T6pjmC/hfSVcnlQTQjQuknocRF5BWyokLsHAxC7RiQ9FglO pA== 
Received: from p1lg14881.it.hpe.com (p1lg14881.it.hpe.com [16.230.97.202])
        by mx0a-002e3701.pphosted.com (PPS) with ESMTPS id 3krsq708pe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Nov 2022 04:36:20 +0000
Received: from p1wg14926.americas.hpqcorp.net (unknown [10.119.18.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by p1lg14881.it.hpe.com (Postfix) with ESMTPS id 983B3804738;
        Thu, 10 Nov 2022 04:36:19 +0000 (UTC)
Received: from p1wg14927.americas.hpqcorp.net (10.119.18.117) by
 p1wg14926.americas.hpqcorp.net (10.119.18.115) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Wed, 9 Nov 2022 16:36:19 -1200
Received: from P1WG14918.americas.hpqcorp.net (16.230.19.121) by
 p1wg14927.americas.hpqcorp.net (10.119.18.117) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.15
 via Frontend Transport; Wed, 9 Nov 2022 16:36:19 -1200
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (192.58.206.38)
 by edge.it.hpe.com (16.230.19.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Thu, 10 Nov 2022 04:36:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MpnUVWce/MYqdScEI6lBU2dH/kIiI4kPb42jLL4DweTT0JBJhwcUC1ytdXoFYkm86ecZwt4l3e1sAOCE+DeCiA4uuaexbE10DIUgKFjaJUZjpEjV0cS/iJQDmSN9tUn3KTmZyx5iZXN4j/ZpGkzBUZ8s1Sd6yjj8r/cmN6V+plgafFN+Q7PoeAf+GndNW9fl+9zGLM2sRU8h3wyn/qIP5R9DYaPU2ngDqCvCyjbheZdYqYLMCB4ExaWrFinxpSZ6YzheynwzCTd/oKlW7oOprcjqON8DzOFJ43RFCpsk6xqCCfOayZOeQe0WL97PIxsBH7i/kg2oYwwvbkSN7yHV0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E5egBRuKG1IXybHVuCSGRouIjcPHn7sUoXfDDTgu2BM=;
 b=ShYX8xNWmZoNEiqTYkVyFUlSbYv4QbQoKlcWU481UZe05ClLc7dleM6JrtqNqGLNnYKv5rdgCknSbwA0atF2zFlxvQttBU4J2UtTQNyOs+dw8t2vt7QwXOBCeu/t+HqpARrD00MdTUh1BAouKHka+wkKX8sZzb8MMKO6CB1IQpGOdcgqtAVp/RH6btwVDdEsksjmAW0UO0+GzwS77mse34dto9IgkGth1qVOdg+V/riW5fvCLWmeqNx+hn1XNixDsYSOOi6nIstu0cMIMPaDaLUJrh+jUw6uXQdpyVwD8+VEL1Xj4Dl69g7jJu3MGEAaewrA73ZQklbdwVkfX3jkuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1c4::18)
 by PH0PR84MB1787.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:510:161::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Thu, 10 Nov
 2022 04:36:17 +0000
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::e739:d90:9fca:8e22]) by MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::e739:d90:9fca:8e22%7]) with mapi id 15.20.5791.026; Thu, 10 Nov 2022
 04:36:17 +0000
From:   "Elliott, Robert (Servers)" <elliott@hpe.com>
To:     Eric Biggers <ebiggers@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] crypto: avoid unnecessary work when self-tests are
 disabled
Thread-Topic: [PATCH] crypto: avoid unnecessary work when self-tests are
 disabled
Thread-Index: AQHY9K3WsJLeKML8BU6fq4PYLEp6IK43jf9w
Date:   Thu, 10 Nov 2022 04:36:17 +0000
Message-ID: <MW5PR84MB18426B2DDE014FBE9F91C016AB019@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
References: <20221110023738.147128-1-ebiggers@kernel.org>
In-Reply-To: <20221110023738.147128-1-ebiggers@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR84MB1842:EE_|PH0PR84MB1787:EE_
x-ms-office365-filtering-correlation-id: 9be9a313-1d74-44b5-3b92-08dac2d51bac
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eIjtYmyVMFmZmCk6AC3gt13cJrgsAXdl76zDl/J9a9FVwlG3wtUfX7K0i8zlTvgJdN3aXypjLYxpvcEP1xt4Rb1gcSn5BJhnoi8Mag2MHsGBP/IArItmBD04OIYF/IfNNMrEQxXSOTiRL61EoXs3g4uRgBw1ZCGKpKG8ToBNPqas/pFZSACgjGW9/bcJhw9Rkyg/v3vo+y496qZxROrXX2WG65J9ajDaOho6k8I7nxlqN9ZyYQ3h0AsSWgV7CCifprldiPSqdoPU5q8Nl4byh9vFolGalU+rF2Te9ong8nYBDS452/pMQHRp+iuu/xyBNuWrD3KuuCybE6VrTxsBXlYmgwANp6HYaMeuhwf2wqgcu0aCOXo3F/nyr+7Kn3RiA3G9vHm5b7e+wodwGMvw1GlAN6yw2e8Q9M2Sc91VeviCXjnsd/+8FyEvoA/ULdSoyAWD6sGYgT283airXnQdEpqsU+5cV8dvH20bykx0sJ5cHywulF7A1qGjZIVATtsINkX6bsfuKUuhLrlSlCjZ3AslFC+6EpiYRXoOW/+M/Jg9xlXLMqXaRKFHWBtcEkKn2WBzQttWzDfxC6gEESYQsH+6cqH1Coo2vELI+y0Wo7YB3v2bN4fao1YQYM7AbtrS+5zvX4kuTfPrp/NIcWBQtvt5TOOsNnpDrGHPSBqNZtq4eAGxGfJzhhdwR0ninJjYXUbQeHLH3tSqYup9q1+3YphGfXt1u3zZNjFtVryNEDv+iDTS9BpF14EouCuIUVp72uMHWpzpAYxMuDAGFsnRV6WEp++liNSuTaVnrddIIcQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(136003)(376002)(346002)(366004)(451199015)(316002)(7696005)(6506007)(5660300002)(110136005)(53546011)(2906002)(55016003)(76116006)(186003)(26005)(4326008)(8936002)(33656002)(86362001)(52536014)(9686003)(64756008)(8676002)(38100700002)(66946007)(66556008)(83380400001)(41300700001)(66446008)(71200400001)(38070700005)(82960400001)(122000001)(66476007)(966005)(478600001)(45080400002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?rfBBOLbzlrJR0PHPvcjiW+wEvmvBZhgvs/xBn5YgRgSCuxePgC8ccgXX+g8I?=
 =?us-ascii?Q?b9L/N3O/KhuLyWb58EqUl5BJotVklUlCcz3Uy3mU6meMeTrByVpw3FeE3D/f?=
 =?us-ascii?Q?uJPdBZXVstbbeZJBx6G99ae1WxMLmhyqnJNQPnJ1ApBwGcGtgA6ZdloMMLij?=
 =?us-ascii?Q?kPy/Ihc9NCdk1FD5TtKynkRM8LRQAgC0fw5OTiwirnpv8nDjOud8SFIQq1YK?=
 =?us-ascii?Q?iC7rje8XiaACSf/8YY04WTM9WY7AxX9NaJe2wAH4ryti0bFXWxIXC7p5UV4P?=
 =?us-ascii?Q?XfQDR89PuU3aeYb20toss2eRZqw3gXO00YqAyPEK+qtHqa039bgQpMboFjw8?=
 =?us-ascii?Q?pkaScYIqPIDgSZ6rxCYhHX4ZCnpp2SOwqDt4r4XMdjbOzjeY8FQv0cBZBxP8?=
 =?us-ascii?Q?2lsNqC/WvfQ/pEKVN7/3r+f2ht4gdP1SvFMLtvs8Nq0MP63aHQiuluHnFUVr?=
 =?us-ascii?Q?5sHIHiWqe6xx37m4UXNMVKbgrSTZEfxvwAz+6XY6dO8mbd/deeYHr0jpwiZF?=
 =?us-ascii?Q?wqdPoL0opM6xEJLHD6xsrQEfi4SrsKb6CMoJCIkQiKYox31Uf3ioQROrlGgL?=
 =?us-ascii?Q?Od5oQBGDoP+j0cgoyTPjCY3Zj1Q2gLXmo4ipgJY/kDGLSoLv73aCLC6/Yke8?=
 =?us-ascii?Q?lIJpMJzCqyxXu4EM0c2xWcNeXdEGZqkeZDkykOvIdNvSoxg1tOSngE5UemBi?=
 =?us-ascii?Q?s5923PYnJh2o4jFOtjqbl5g3D36oBePxENoKY0rI0MroqVH0pnmvrH0vu5BR?=
 =?us-ascii?Q?HWMVggcP7iLleE1q2u+i/c8S/WGDjzNLvkDZV/pE/QHdxzahIqRKaM60q4ab?=
 =?us-ascii?Q?eEtXcZEuATgT5kqdS3zC0YRbfwmvd/obaaMxBWrVeNN9FZdxF1W5089XMXd4?=
 =?us-ascii?Q?ouuWQm3oGqmQrt+4xSRijWfmJRT+k3v87HysA/oUJgdTdJr2czq/bx/S32ZS?=
 =?us-ascii?Q?WcQZQhdncahRy6AHqJ5IOXU2saxI6RUXxm42C5a5Kh8Y9p5oiAg4UAr9q2pJ?=
 =?us-ascii?Q?owkBOsrRsYR47jGFQQdmQyMqIcvCYLpQE3wlcCODJtBLKadx5FI/b3YND0rf?=
 =?us-ascii?Q?YugCPcWxNIMFIX5H6vHIjW+JyF8UXcIl4nKHhTdr7misChzHwDdDwBqOLdLN?=
 =?us-ascii?Q?Jnsu/trTawzh1f/B2FwrYSl+fcr+c8ZrX/Yyp+nYtAuc2+JvMQrEwkELvmE2?=
 =?us-ascii?Q?XoHPLMaznha40ZR+uOxEw67c98nq7CHvXVFwbfm92CtfrYfT1Z0o41irxhGb?=
 =?us-ascii?Q?oGayP9uxQ9iYwzfmQXEDiHLiKdi6FcgWMMeFGqsYSybmdlgbTlW8SegFHNcX?=
 =?us-ascii?Q?gV+tGDPOgETRoFpsuZe1wqX3j03XpBhh5lTOi6mV2ZLfi+N9DjDuCGCy1L28?=
 =?us-ascii?Q?qjLHR/HJHHIMVn2YrAKwNAV7+p9SAKDX8jAQ7offYwRpq6w2gc5kEJrdUuKZ?=
 =?us-ascii?Q?nKVzQMJ/kMHGu31YPjvaC4lopXIV8jTCYXMAKU8MlIi5cm/91xezuSZ3eLfR?=
 =?us-ascii?Q?8SfzS0PA7hcywCJgvWZSSH71sUtTnSzJHDmrez0BsatHwiA36n5y2cqOHxOi?=
 =?us-ascii?Q?qnh5ZeMgQv2c0b5WjBU=3D?=
Content-Type: text/plain; charset="us-ascii"
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 9be9a313-1d74-44b5-3b92-08dac2d51bac
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2022 04:36:17.4128
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QqRbnVsFdeVWp6ziBTsf5r+jO4fkXyXwhNn6TtaJT/YJhKQ4zscWE0pfdbQ4v6lo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR84MB1787
X-OriginatorOrg: hpe.com
X-Proofpoint-ORIG-GUID: oTWiVG7lNm7kegRa3hw90DuDg_EpJJOV
X-Proofpoint-GUID: oTWiVG7lNm7kegRa3hw90DuDg_EpJJOV
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-09_06,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 phishscore=0 lowpriorityscore=0
 adultscore=0 priorityscore=1501 clxscore=1011 spamscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211100033
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Eric Biggers <ebiggers@kernel.org>
> Sent: Wednesday, November 9, 2022 8:38 PM
> Subject: [PATCH] crypto: avoid unnecessary work when self-tests are
> disabled
>=20
> Currently, registering an algorithm with the crypto API always causes a
> notification to be posted to the "cryptomgr", which then creates a
> kthread to self-test the algorithm.  However, if self-tests are disabled
> in the kconfig (as is the default option), then this kthread just
> notifies waiters that the algorithm has been tested, then exits.
>=20
> This causes a significant amount of overhead, especially in the kthread
> creation and destruction, which is not necessary at all.  For example,
> in a quick test I found that booting a "minimum" x86_64 kernel with all
> the crypto options enabled (except for the self-tests) takes about 400ms
> until PID 1 can start.  Of that, a full 13ms is spent just doing this
> pointless dance, involving a kthread being created, run, and destroyed
> over 200 times.  That's over 3% of the entire kernel start time.
>=20
> Fix this by just skipping the creation of the test larval and the
> posting of the registration notification entirely, when self-tests are
> disabled.  Also compile out the unnecessary code in algboss.c.
>=20
...
> +#ifdef CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
> +static int cryptomgr_schedule_test(struct crypto_alg *alg)
> +{
> +	return 0;
> +}
> +#else

The crypto/kdf_sp800108.c init function currently ignores both=20
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS and the cryptomgr module's
notests module parameter and always runs its self-test, as described in
https://lore.kernel.org/lkml/MW5PR84MB1842811C4EECC0F4B35B5FB3AB709@MW5PR84=
MB1842.NAMPRD84.PROD.OUTLOOK.COM/T/#t

Paul reported that taking 262 ms on his system; I measured 1.4 s on
my system.

It'd be nice if a patch series improving how DISABLE_TESTS is honored
would tackle that module too.

