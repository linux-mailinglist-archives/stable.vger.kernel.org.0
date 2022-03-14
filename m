Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7061C4D81A6
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 12:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239638AbiCNLvc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 07:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239653AbiCNLvb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 07:51:31 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40DDA41F96
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 04:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1647258622; x=1678794622;
  h=from:to:cc:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=G1SCYCSOcEHF5rYD5j7FRHGwWbkZbj80UT8Irvmx/0A=;
  b=WYiGelEVU/Rb7eBXsCeCb7MoWeUxZ+ESqUrarEQ7XWuEV3JUfJ1dRAKp
   1L9xSmSi9YKP4DN1vAVFkpJKos47L1rlhoYGdBvrKzECFo1bgkm0iwwMn
   i8H5UW6aVxq61vLdmiezN08Eqw3q0g4ASpLrKyOIYbKZXvFxl8BscqNqr
   r3MTzE4PZf0pSX+gZztCt4XlvNYGm78wjO9Cb+ddTxW8j3Pg2rXlNKZTi
   cMRCXd6e9XyeTIkZ9CpYpM0PoM3Mvp1Nef/sU3RNZvsHPLK7li9SgI7k/
   ZnK0GsauV9nPMNkPQdRHeRVe7hvJdx9XsAj9NSr1jCQI/XSRBYB8Wi+jY
   w==;
X-IronPort-AV: E=Sophos;i="5.90,180,1643644800"; 
   d="scan'208";a="194221121"
Received: from mail-bn8nam11lp2168.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.168])
  by ob1.hgst.iphmx.com with ESMTP; 14 Mar 2022 19:50:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i9vpaUZRZr5IGh+Q7aeFipgU2z+EOob/+W2HgtYeDPjewQPiv77df+H6eDusiSViLw7Lfj167/UyZMLtB+HitmLVNJIqYcAOlnARth8pDY8PyYO8iJ7In6LjrKka+opqRn0PcMHl5PwMnRiG+lQOdhtFpSQDqDgFGLjbyPZM6T+zv9OEQy3lGgPkv4zqphWzYBOLt/+a0sfux7auWAwYIbUJ4sUyVKH6LSSx25scEL1OgyGfkx20ASHrgO/PXsq6ocZ2Bui7J8nyGP0uH1rSUM3a18UsBUojPZxT6dFedeeuI2Sb9rMv75hFadE5kls6lbqL+HJrG1MdnECUsh/FEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G1SCYCSOcEHF5rYD5j7FRHGwWbkZbj80UT8Irvmx/0A=;
 b=FyLZtUhpJay5rmsreGd9K+UQz4IJhX8y6R8nLRTwAJHWAyyZB7kJ2fbfsOmP9X0jtia4NYQ2CrK8se26gJvNg/6LicNz32mMh4PeUsMFUD88VnZ4DKHb2RTOrIl98J3pnlRYMhD+z0RiavRX/PNkC6z4q6C+oxNj1lHI2Tk+o6tPyYQcQXKmg+fCxEC6++wPt+ob2iXBx+wlEFTwmE9Y0tF2a6i/a76TNngp8ZGHIcgyeIGgV1Ar9nW36oMnMtp8J+LayIK1ItXEA297hvDY0vph+Ity92Xh94Jxgssjo95WV0UpZ1lJVnjh+cE23St0NjDE9Dsi1oFiUOhPADXTvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G1SCYCSOcEHF5rYD5j7FRHGwWbkZbj80UT8Irvmx/0A=;
 b=jsiInxq3vIZ2wpHKZyNWB12uo7Li5Rm6fhpnUxi0Csno7bm5rRKJ65C3ZgKnjDvbJmQhn3+iTX64s7UKgo81l+Boxt9nUZfmWrKEmTbSy7cro3OGUEjMNbP9uIWBP/BvFIptKvDWKi1MTJoGzXJwNX4W4FWwvEnmTzw1H7aT70c=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by DM6PR04MB6681.namprd04.prod.outlook.com (2603:10b6:5:24c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22; Mon, 14 Mar
 2022 11:50:18 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::f025:4f23:8e46:b2ed]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::f025:4f23:8e46:b2ed%2]) with mapi id 15.20.5061.028; Mon, 14 Mar 2022
 11:50:18 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Christoph Hellwig <hch@lst.de>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Subject: kintegrityd workqueue fix backported, but only to some LTS
Thread-Topic: kintegrityd workqueue fix backported, but only to some LTS
Thread-Index: AQHYN5mtjBWghYPVmkqkfGiiQU6Z4Q==
Date:   Mon, 14 Mar 2022 11:50:18 +0000
Message-ID: <Yi8r+UyK092FE12X@x1-carbon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c2735e63-c976-4bc2-40db-08da05b0cfc5
x-ms-traffictypediagnostic: DM6PR04MB6681:EE_
x-microsoft-antispam-prvs: <DM6PR04MB66812B15FD408B0C8971D227F20F9@DM6PR04MB6681.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FLauftynklhZd7o+XPhWWnW7+L3eH2gHQzLY9gPLo9IV+DZ2qwuBpaySc/Mpj7lIFqdXAM4vR/aE0/A8S7MxR6LVJtilSx1XLIb50MhLX1mnrWJ49faKgSsz6+BycQj1hzTVBp2Cr/DzvdYR+fZBJTA+R+IJoKt2udzDrFHoEPqHhZ9Tz7R6bHPaHFB5eEmdW4uDPWapBYbqk8dk8gJkpxZynFMqOaE5YtoFXlSFpDnB7fA4Cq9tG5L5LIaaMsDJXgoB8u8g158E0V7QnQCtRwqCjJY67iFM9tCLHAf4hR9JgZi4z9q7Xacml8M+LyhMHymQTFYfbxqva8VWHUNdcjhKnT+NMbLijj/X4cxh9ZnZ78+sfyTaLOyOH9pi7y6XQpI8sFQ+XtvwlMwsibZAVoabvq0WI1U8B349SFLazUwj2xzsLIzBqQr4UglF1izlpcimz8D0PJPchFYgl+8v5ayufZs5zDghr9cpK5t/GSrzMU5rWEZ8w2JEt5F2uLQBTSRSBJHJ6Oq7N3Dhs0qXUj0QlLWFbULIk/bWq1ztKyc42RKdAdK6sg9OLBv/6zTnEvjTSDsNj6dnlP23Tw0O42nYcQtQ9s9DW1KoAvzoG7V1m64Gd9IK7G7NtaJLk/upzgZb4PBi1NqJTCW+ikhLAs0+p+u3iha8R5s1nqrL1Tmw3HeA6iYvq1y2nLcbUlw2ojGVAbjF0H/tDPR0ah3aLbhDVrjby2l0Wo5K8bU20DT3DRAygoUUmGyKFAIuxTvdfAStZWb/UUiQ4a8S9WR8z5RbG7PyfwmZTqBLbWAZIKMsjhvhyRWMUyIXV1fbOvYD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(8936002)(71200400001)(64756008)(38100700002)(66446008)(66476007)(66556008)(66946007)(76116006)(508600001)(4744005)(6506007)(26005)(186003)(82960400001)(5660300002)(9686003)(6512007)(6916009)(122000001)(6486002)(966005)(54906003)(33716001)(2906002)(91956017)(316002)(83380400001)(8676002)(4326008)(86362001)(38070700005)(67856001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?713wzqXtsxjhzIiQPU1g14HcgQTaWiV4mjonMp+MCLdKHfb5SvIuRwl9BX1T?=
 =?us-ascii?Q?5MqtNDS/smLLWVvZQrrgWE7ajm5mcw9tar6Z3ML/2zPXy5qwDG2YmR4IKkZ0?=
 =?us-ascii?Q?FYPmpxdZ/kx3M5hih6DMrwpFGZ8MKS1w1zM/Jrb2q/+9qlPoR8kpU/IA+Rm5?=
 =?us-ascii?Q?OzllXcrZpVSCOUfdskSSawYyEghWcpmM+qHlDrjbibVMoWZG8YFV1iXJkRTT?=
 =?us-ascii?Q?CcnPRmxhay0Yeb7wXk1KfYlrW5Ur6WYSU3/Euy8cTIZkzofzSIPyWJ2Szzln?=
 =?us-ascii?Q?QsRwfU+OUfaSel4HpOJ19k4uKZdCx8APHsyuzOkrqLyCNB3R64f0PVoHBOWg?=
 =?us-ascii?Q?gHebeYA/6MI4tY8DH0m3ytbQaMTkl2yLoeh3mOI7ACRlwj94SjyAgZvwt5CW?=
 =?us-ascii?Q?H48sVMvzfzOAdbXVYUNV6KBV1WBSkAs86e9bjG0ihO8rylx3EDjYt4LzPdUm?=
 =?us-ascii?Q?8wicNmQScmpFb1axEULw+/Aw1bsX+qy6hDh63f1SPYAYxa9jJPL2hm0fo/hl?=
 =?us-ascii?Q?t3dH5wFqvpnajQnTrvhcqFmm/fZZYGCUF30lHHzBRfVJMM+ZQ7dI+32jngZj?=
 =?us-ascii?Q?0CXFKCtTVelWdebpAuxtNXxOe2c4C9HOv3UPG23wkSUQqFa18qZYuRQfIxdf?=
 =?us-ascii?Q?x05wwqjeO/LvBIXWMT0PnlEFvf+QGzZUTZpyVdIJ/YJr/o0Zb5x4wa8cNRH9?=
 =?us-ascii?Q?2GUl7FjJLeUGSqRLs1QIlkOTZwZTqwKKhrx92MBaMkr9bJsVCSdvD5mDmVBI?=
 =?us-ascii?Q?JcuclYfLC4WyH1jFXJw3F37xhm5Kro9TyOolrNtSkeDDYmPVXc114xHYMoMg?=
 =?us-ascii?Q?+TG5uhyCsu4rxg/rWj33b6EF8fhLCr6i1QWqMyKTg/eu0JOAIlstneQkpwOg?=
 =?us-ascii?Q?vhz8c2lkiHnAAq1AGJknnG/0VKabe4k6ehC19z45bpQ5BBFYPjJo0bbyg6Kc?=
 =?us-ascii?Q?vvQUiHV1LIe2aLtfdGtyvmCRYmfHvLygAEqmNDTqSZNMKt+hxOOhiRSNfI/w?=
 =?us-ascii?Q?kbH9nC108hDBaeixvTgWYHgmCPb3JlQDLW2VMbxmf7NOSgPBpj/gnirQ2NRQ?=
 =?us-ascii?Q?a3+XDYvXRRkxPVY7o+TVS8/f3NIKjRFImaz093VAueOmthcDShpDkrpSDWWK?=
 =?us-ascii?Q?D2BmBCqfMrY5N/dPl5LYqld/tjyqCWUvKT970bfenqTzIUB4Tyekl6ku1u7k?=
 =?us-ascii?Q?QcBEZCc6stEqMJqwThtxrTIjk2wlQMVpsJE+J6J66YcBQxLghzGpcM928BMp?=
 =?us-ascii?Q?y6844n1lDFDjpy/qKspgz7Ne4Rn4cxaG0rdp9xbNMuyZ6avGgm0MuB6eTvNR?=
 =?us-ascii?Q?OjpeZwO4XJV0usuKsvfGO0o5gbjl6C5+t5qblAmuUx9LcsKO0coO93ZbeKp/?=
 =?us-ascii?Q?ofnVVE7kJvn0LMoqZDN7pMdE75NIRV673IoAA99k4FrHk0YA+QdvXwglzeYS?=
 =?us-ascii?Q?ppn2ZD+OD+m320C5ZaVBUcMFyGw4rb9FfciHF49TOj0Xvc/TD8aZww=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <730FFA68B3CFD844AAEDB3EE1A94C668@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2735e63-c976-4bc2-40db-08da05b0cfc5
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2022 11:50:18.2977
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: StTKeKr+BqXuZAPfxJe0b3W3DJBwhvdLK2dpuHt6Uje3RwcZ/zF/2aYOMicFmLoJobrbXKTFm1rnwg89NItYvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6681
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Christoph, stable,

I recently saw a crash caused by the kintegrityd workqueue that could only
be reproduced on older kernels.
A null pointer dereference in function bio_integrity_verify_fn.

The fix in Linus's tree for this:
3df49967f6f1 ("block: flush the integrity workqueue in blk_integrity_unregi=
ster")
was first merged in v5.15.

The fix has been backported to v5.10 LTS branch in:
1ef68b84bc11 ("block: flush the integrity workqueue in blk_integrity_unregi=
ster")

The fix doesn't have a fixes tag, but from inspecting the code,
I don't understand why this was only backported to v5.10, AFAICT it should
at least have been backported to v5.4, v4.19 and v4.14 LTS as well.

Original series:
https://lore.kernel.org/all/20210914070657.87677-3-hch@lst.de/

The blk_flush_integrity() call that actually fixes the crash should be
trivial to backport/add before clearing the flag and doing the memset.


Kind regards,
Niklas=
