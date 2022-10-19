Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1787604870
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232648AbiJSN4e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233141AbiJSNxL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:53:11 -0400
Received: from mx0b-00230701.pphosted.com (mx0b-00230701.pphosted.com [148.163.158.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 514AB1C5E23
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 06:36:27 -0700 (PDT)
Received: from pps.filterd (m0098572.ppops.net [127.0.0.1])
        by mx0b-00230701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29JAxEGj001284;
        Wed, 19 Oct 2022 06:35:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfptdkimsnps;
 bh=nBqRHmDKjgoUlDXAZlDUPZJvqkUvkvNyAPxbDz9qjfM=;
 b=QPKznEHRBz015YrLEGw6f6TjwpjHur/qLQjQWdfzje6cqftwl7q4sOKEJ+JRpGvht5sx
 7aUgsejJCruS4r8kNcQ5WrRN6q4GqwcN9ti1l/KRk2PrdId0nzLXskP9s5Pkaao6GCaP
 GVChCo+02uYTejBX5+8Lxwc10L2ti7GoUEhqxo6gG3vVfX98nj3IOBl9OHbK2wAo5BMO
 kh4QzTNz6nxFeZSZTTraxhoU4pBiP+CDE/qO6+F0qtileJ5IQ6cZl9KGeUXfhd4xWxJi
 218isgVWir/b2qFjvxqESqLPSzFJPmaHOeubzwJwjgARwSlluPjF1WnMP6y13wS181T6 Kg== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.73.133])
        by mx0b-00230701.pphosted.com (PPS) with ESMTPS id 3k7ughrhr8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 06:35:47 -0700
Received: from mailhost.synopsys.com (sv1-mailhost2.synopsys.com [10.205.2.132])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id B3D2840083;
        Wed, 19 Oct 2022 13:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1666186546; bh=nBqRHmDKjgoUlDXAZlDUPZJvqkUvkvNyAPxbDz9qjfM=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=AuAPf7Dy8lxVptm5RDdiuqa93AZQcTk6vDJ/XgU8WE+D639sOjaznlR3+EDh7uD5E
         SZ3ibs+TcFBb0ed51C1zjvIK5M5JoHv5zx5+puzQnl8iP0OT2/g2fvHQt+4g2PEuw5
         wvCt1xBofOnfIlb/lDOBRu/WAYuyi86AcTaoqDONIQ5iwsEuMxWiecM2CKE5k9TJ4U
         PBXGYk7v1h0ugtdKtOiovh1drF4VjLYKgtZMr9xKG8KMzxtb2p9pjESvO8shSlWzZZ
         VA0RcD0DymErBqtMSxDm0gxQajkd2FwsxRnmHxVo8c2QqBmv6ombvZnIPOtwf15wtK
         UKQ/S9OruYvlg==
Received: from o365relay-in.synopsys.com (us03-o365relay1.synopsys.com [10.4.161.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id CBA05A007F;
        Wed, 19 Oct 2022 13:35:44 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 998C580083;
        Wed, 19 Oct 2022 13:35:43 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=kozlov@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="fkXQS1FI";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kIgbEGPsO0EkCqPMFSulayj/rzOWLJ4gMQ9t/qTxZLejegvabCGCaPEyddXLfLUjXreY6NAX5oacWIYaZJc7FquGFpQOpibgUXdhcg3JR5dGAYtcYX1b6B7yLjz+pB4AlYMlEamQRcx5jTjwNcleoBtG5XYWnoPumPACyElgdFkjVDRMing5RoB5SIjDUuFSU6CjLf66oA27ISgkJRxr4nP5CXYn4eOgJwoCelDSR0e4qm6r3pkV5hGAvWpMWX9G9wihSRW0Q+V2fwJ3RMIZCGFoBE5P0kTVhZm2s+I0Ir+jBx7yERAyhw+FqiyKJYDm9rxrq7C4nxwpieqX/a7f2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nBqRHmDKjgoUlDXAZlDUPZJvqkUvkvNyAPxbDz9qjfM=;
 b=f0K2CkuCwcRjCiIfLUCarSWwtDCN04yAI/MQK5i1rrqjL8gdxzFenJ9XSC3hqe8YAuTsMKIfhw+mtbbd5QWCCt9sky5SBmHpReKzs52lMeB6tdvY4Dgxva3S60SIZoQJAYfgEC1UQibmcBeuvtWbqpR1cb544aYrQZ3fx2b1vElaLAmSDjX84LbqHuUHYLT4vdYEEi9a3nW/L2iVGsM/hfzu9x+zKRcuUi9FZEOH4LqU4QueUel5I8dKcgcdBlDbGZYDT2ZfkQGmzTbODNks6G6q0EOMwXaHfIF067gLDoReiAsEFKEI3Q06qcbIDlASUdqqt+gVPTdZA9Nv8vwLng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nBqRHmDKjgoUlDXAZlDUPZJvqkUvkvNyAPxbDz9qjfM=;
 b=fkXQS1FI7P1r4mKGJAXmfOKQmdFro5aJnr8hbeimVJXLiumpr2f1caVrqh/fL/9cN7T8lnPylUc0Chjesc4b6MmL8YhiLN3Z7fHXtLZEEfXsz2cceErDbqEFwCeYeKvKh7vdIxXeoztwtRBCF3obIcHcWD4HrHXnIBEuMshdy7Y=
Received: from DM6PR12MB3146.namprd12.prod.outlook.com (2603:10b6:5:11b::13)
 by MW4PR12MB7334.namprd12.prod.outlook.com (2603:10b6:303:219::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Wed, 19 Oct
 2022 13:35:40 +0000
Received: from DM6PR12MB3146.namprd12.prod.outlook.com
 ([fe80::c8c7:ad53:8382:e8bb]) by DM6PR12MB3146.namprd12.prod.outlook.com
 ([fe80::c8c7:ad53:8382:e8bb%7]) with mapi id 15.20.5723.034; Wed, 19 Oct 2022
 13:35:39 +0000
X-SNPS-Relay: synopsys.com
From:   Pavel Kozlov <Pavel.Kozlov@synopsys.com>
To:     Vineet Gupta <vgupta@kernel.org>,
        "linux-snps-arc@lists.infradead.org" 
        <linux-snps-arc@lists.infradead.org>
CC:     Mike Rapoport <rppt@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] ARC: mm: fix leakage of memory allocated for PTE
Thread-Topic: [PATCH] ARC: mm: fix leakage of memory allocated for PTE
Thread-Index: AQHY4kNKxLtHkSpGTEigR3UKzTe0wq4U3cmAgACy7Uo=
Date:   Wed, 19 Oct 2022 13:35:39 +0000
Message-ID: <DM6PR12MB3146EAF3528B26BF41FC96D7BC2B9@DM6PR12MB3146.namprd12.prod.outlook.com>
References: <20221017161127.24351-1-kozlov@synopsys.com>
 <1d9772ac-4b73-4c76-8924-89425b7dd30b@kernel.org>
In-Reply-To: <1d9772ac-4b73-4c76-8924-89425b7dd30b@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB3146:EE_|MW4PR12MB7334:EE_
x-ms-office365-filtering-correlation-id: 3fa4e30a-3a41-4fab-0bbb-08dab1d6d000
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jYV8rgaPRoEt3rOxhTqn28YOIhHG9yXAsjuyVzsDVG8CpgiY2q79yB1DzUWPT8qT2Jztd9f4Sl3EGIVzqdhA4HgKjH902U0dqm/YxR2BzfNjhcvECrwGYnQZ0z1QWe7qCyp9cn8E2ZtthKR6S34huTBcCMUcrqV83Tf171d2anXQ0671UlDtTrQytRvNYGx0fSw6gh3RPcIBvZvNAdHyBveiuVDadSld1eXmEpqAIubuyo2gqBDUiDa/rxWfu160zbnlWrt/3TJRNaBhVm9QkfkYLh0Sl6W1SQmdModGOzzQLte1O/6nE9VFDYN2PiOzxHVY6n6ZFBySmBmDNlV62y1thxNpyyBCKM/SZOIBd8i70IGgrF1NCaHn6oVSDNknV8Wzq574/MOigpw2QlY1bO8NUYwKp1n4N9UTF9lQ15MRYD6QlypkldHCo85KV94AxMSPM5uSXB/Lhs/1qcOTUyONyMDAeCjAA5H7zbhecuRAXoSgAt5cebJCsOyyWZ6B/qemM2SuVt5Kfgr95baOEhbJr+p4+sXBf89T9YoPPFgiehX4HhVsQ9zBGQOFaaYJfjZfvkeCBtqmX+E5OKjd1lLTbJXbfjM/p0N4vhX0QZOTdduerVl3fZyVTVoNXrWThiwSwo+BVHXcWu3/vp4asKgUjH6HjSEwavFo2+B8jzs/imspDTaBMqASRtW4gKJZrtUlewMplPzY+/IN8+7KbqD9RRn99oqyEdrZPq30Q6RvtI0CkLcB9hUk3Ro+ZDkFtwzcK+uxfLOBR+Sb6TvXsQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3146.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(346002)(396003)(136003)(376002)(451199015)(38100700002)(86362001)(66446008)(41300700001)(7696005)(110136005)(6506007)(316002)(26005)(54906003)(5660300002)(76116006)(55016003)(38070700005)(8936002)(122000001)(4326008)(71200400001)(52536014)(478600001)(66946007)(91956017)(9686003)(4744005)(33656002)(66476007)(64756008)(8676002)(83380400001)(66556008)(186003)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?u5uGFb9M/ay11ER23mAX+tLmW4Yfk2+JkV1zyVyWXEVpXWwabK9MnYnpEB?=
 =?iso-8859-1?Q?0017XPgvIhE3Iz25a4J/S9ym8SOBtQDjiUt3fFpDJutx1c+uYnXsMyNxhi?=
 =?iso-8859-1?Q?dFSGE7zo4O/ilLkgtLEc4huL9zVV7yWyD6fgrA7twNVAOz4PEQv7hmD982?=
 =?iso-8859-1?Q?DVCg6aUleiisNHBjnbS0T24phP1UIXMBzVhHeRpdScWbJJq/53A65GZP12?=
 =?iso-8859-1?Q?AzrFJGr1ECOMYPwrlbp0sxNba4/WxE5Zb5Dp+EEWYe8/YlkW07mv9SigUO?=
 =?iso-8859-1?Q?8PZnnOXu9bKngJUKS8EBDhVIRvvfCOcFQ6cM0APTizTjZMc6sH7nUCfU1e?=
 =?iso-8859-1?Q?VM2U/cMUxgQPjt/9uoqh0yfYnhhRzWbbjf5mCNTaLKTOruAg3sX619bLpK?=
 =?iso-8859-1?Q?vUben0DrKrhtqtpvVg99BF5WTpWcm4zU3WuoV07hnhvzOgth30L1HDk8mL?=
 =?iso-8859-1?Q?vg3U1ZsRi48i472dJKJ7AGRRr7AnhTtJ0PzLwh6sRQ+bS6WA1LJ6F1oJof?=
 =?iso-8859-1?Q?dkFirv0usN9Qtb7XGA8s4mFS0qs4bibZQyipMx3Wv8FPkpBGPLZs0XJuEC?=
 =?iso-8859-1?Q?nE1PXE9uq7LuRxMDbGpnmGdI7xhFiVE5TewfKfzZtxKfYTC/Rcxdy1dnIP?=
 =?iso-8859-1?Q?HQXHF/LhQOk6wEkTYiwlnQO36tqnzUrFKW9csc45CTX+L61qHB5Ax9rTPk?=
 =?iso-8859-1?Q?6X328YzdXObeSg7K8VsagBo/mwUVauhosz7ljsCH5FTqgwhMLk57nn8i3j?=
 =?iso-8859-1?Q?+oGbQL1biMqac9cuLjge/5MRmGI/I6d0foMHs4+yhlau8KzuhAvgQThfV4?=
 =?iso-8859-1?Q?MCMEKyT8NEukCuGHAULHxEqOIh54qEarfWmCpnKVxmuyjUlMYBrcaEF+Es?=
 =?iso-8859-1?Q?+DFgarybsGim/X2Wo5DPvnSEfDtsUdyJQswVieecupcAfwcYyy7Li67BK1?=
 =?iso-8859-1?Q?95Tw0VxX661eibCpFA6MGE+ZGmk+PT61O/0x1F/4Kp19Db0m0zjFiLGUXx?=
 =?iso-8859-1?Q?rfbbD8ehh7v4ccHydql0g6JA84Dq8o8imWLLfGRIA/7RM+6PMedrJU8r4V?=
 =?iso-8859-1?Q?IhiASn+tsfmskNB6ycCdwQseOxGbVdqg6ziSvz0Jc3sBgfV4onRXRcMvql?=
 =?iso-8859-1?Q?6PbFj05f9IUiYHDum9ofafC9votBG2VrG7toG+KztUVuGntURGM/y8l5ht?=
 =?iso-8859-1?Q?eYydCkiDylzvZgj5V60hMBzhkdoFs3ABGpyBCUr7IVvrD28toTAB1c8GmV?=
 =?iso-8859-1?Q?tN7u6k8w+V0GV3VAxh5+Y78FL9UAwNL0ome3FiakTOS4v4vqzUxlcjacR3?=
 =?iso-8859-1?Q?8iuWwgf+vtnYh37twxReJmCWTqVhzl6kvwgyQsCYrcVXsqFZZIpsqZylf/?=
 =?iso-8859-1?Q?qSFUB24dU2DZnZeQLj961/t7pthyWr9oZgP8ea51RwgsH7P1+E7XmiY/gI?=
 =?iso-8859-1?Q?XK1jTYFu6ozA6GiqpNEPGM5QAIjklQKgxs46BOGsodWXYmU5Tl8rH0y1mg?=
 =?iso-8859-1?Q?WNGKjbLDSNKCkIuDpFZoXfG5Auv2F2dFM4oX8zioacuSATIdnfAlnTtMJ7?=
 =?iso-8859-1?Q?dAN/Jv+ic3jHInfqlX1TbH6cbgKxsbD3aGa/XgM00ymKWlCs/5je0d0kJQ?=
 =?iso-8859-1?Q?KH0NoYj8SbwrAcS56lL0NPJ9Y9UxW6desr?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3146.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fa4e30a-3a41-4fab-0bbb-08dab1d6d000
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2022 13:35:39.6815
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: whrZMnIKm7BeoJc2fndqfTaAvEMAlMpmbetODlomzNB51SWIR+0TC4AnVaWwmSUwZFeEeRAhByGj3hSAdtwexQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7334
X-Proofpoint-GUID: 8aktXGjYyrK6GTE-8MQ21LZ8BgzwxOYB
X-Proofpoint-ORIG-GUID: 8aktXGjYyrK6GTE-8MQ21LZ8BgzwxOYB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-19_08,2022-10-19_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 impostorscore=0 malwarescore=0 mlxlogscore=740 suspectscore=0 bulkscore=0
 adultscore=0 clxscore=1015 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 spamscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210190076
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Good catch. Curious how did you find it. KMEMCHECK or some such or just o=
om.=0A=
=0A=
I've run glibc tests with 5.16 kernel and got many oom-killer messages and =
even kernel =0A=
panic because lack of memory. These symptoms pointed to an issue. kmemleak =
didn't =0A=
show anything. Didn't try kmemcheck. I prepared a small test and used git b=
isect to find=0A=
to the "blame" commit.=0A=
=0A=
>> Cc: <stable@vger.kernel.org> # 4.15.x=0A=
=0A=
> You meant 5.15.x=0A=
=0A=
Yes, you right, that's my typo.=0A=
=0A=
> Added to for-curr.=0A=
=0A=
Thanks!=0A=
=0A=
Regards,=0A=
Pavel=0A=
=0A=
=0A=
