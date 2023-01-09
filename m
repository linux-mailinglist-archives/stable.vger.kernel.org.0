Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B122266322C
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 22:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237794AbjAIVEu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 16:04:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237769AbjAIVEY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 16:04:24 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 838998CBC1;
        Mon,  9 Jan 2023 12:57:49 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 309KjIfe000806;
        Mon, 9 Jan 2023 20:57:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2022-7-12;
 bh=4IKJhcoltiudoOa/lf2p2clrrd/wDHm/vRF83QKLx+s=;
 b=qYI8IovRrhnWhCzE3BJMTN/rLJPS/ZWqj3TWJ5yP2UXyXg2S/IvLhAceY6wxPCtdI39j
 g7pi4JlXHh8l4e6Q8eYEH5NYPGYAGdCI3WvnTmEM1e3Q2bZnxPse50qDPULDQFZLHXxb
 3DuiBceJnBuYbG7PbOoji0TogC0VTXmkr02a4sFatQPqkayoNjBDUcg3Xnc9/ezzLe0p
 ZbnO5f0YGPahz1adAT1A/u0zkfTR1rnzBTXIN7kyKtNqMH5ctc2BrtyFXpHWSK+uGQkX
 c+SO7riLCkSlRPp3jUaVLVHN059fUc9IycE2i8FZ1AeR7+yd0Ds+5Yq+pTWu86XH3lci Rw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mxyh3krt7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Jan 2023 20:57:25 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 309KSTpb033101;
        Mon, 9 Jan 2023 20:57:23 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mxy64hbbv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Jan 2023 20:57:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dG4Fdbkf6KRjUaZFTHxPkOwBOoK4449fH23v5kk1ynR4ZjFRvF1mBehOy4psI3llnO0gr52iJbnpv1qyOpvRwGbY4jjJfkr0dxDsGN4d+AEUNwynEhRYM8z2nKeRytZYA0yadCqDpm+Tj7vradBG4sarAts+jwJ7SncFAYmmYOz+R69WP2WVJ7cWrDT7T9GHfs9vCuBXMaarMmOQY0DOdx/4wDdZqdgQfCIHSAtE/tU2wkBcgZmcStcMhjtzCWl7S4vTf13jMOB/HO4rjnGqkCP+nyfwBXinTrKdLJAZVbeeRFEZAR/hfp6e6/eSnRze+/oZHP+8JFto2o3TY4HA1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4IKJhcoltiudoOa/lf2p2clrrd/wDHm/vRF83QKLx+s=;
 b=l/GnZK6+dA2344Y3vWFH/X66SKFcMaFdvAZCsX7uqLAK76IXBl4R8ca9N4tKs6zsiw2ZuKEn1vsCC2Fza+mja64d0yQ4YwczW0IqtfKoshAFwYFdJfOZyZdbvJI/VJf8P0rxBd0iOe/oI0SqHWVwoj2nTdYE8Jm5pp7v2lnpUiV9u7h+nyzXK59YAnMc803v7F3IKVJLTWYUo1hZsbmJr34H5ZI4amUQ7JLsOYAVf0FF236m8aKRSQjVXplisCYyRi4ARTIvmSqXkNGPDWcyM50NVPAvKP6Cntdv5hQ5a1aivrVjmi86QAzi5yD0nkjRTmGtLq6Z/K+trVQPaSe7mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4IKJhcoltiudoOa/lf2p2clrrd/wDHm/vRF83QKLx+s=;
 b=th7RNE63KhXBBQpOpAODRHfCpw9YHM7CdvXBzg+wP94Coe83DJWqJ64ks4hICSpIl3zwfo3B64FYlLHWxsEt50YkqpWVF3NZH4Yfe5xbmV210bSpiWG166d/ClJXqOFklCF7xr3rx91Cd1AnbSo8ztOVr30XGQmmiUfHxXwgRGE=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.11; Mon, 9 Jan
 2023 20:57:21 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::a02:2ac8:ee3e:682]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::a02:2ac8:ee3e:682%4]) with mapi id 15.20.5944.019; Mon, 9 Jan 2023
 20:57:21 +0000
From:   Liam Howlett <liam.howlett@oracle.com>
To:     "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "maple-tree@lists.infradead.org" <maple-tree@lists.infradead.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Liam Howlett <liam.howlett@oracle.com>
Subject: [PATCH] nommu: Fix do_munmap() error path
Thread-Topic: [PATCH] nommu: Fix do_munmap() error path
Thread-Index: AQHZJGz3m8dIbeKOcEefX21DSXtTIg==
Date:   Mon, 9 Jan 2023 20:57:21 +0000
Message-ID: <20230109205708.956103-1-Liam.Howlett@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.35.1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB3022:EE_|CH2PR10MB4312:EE_
x-ms-office365-filtering-correlation-id: 01ef2296-c146-4658-cc1b-08daf28419f9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T1d11ckX7WyBma6D/GJPnZjSyUxkA22eFKs1JijgIOj5bB6PeP3iZoRIOrcOWph5KDpHQqGg93cxPHsZwZXG00gatdcGvLp6zVARJ9fZ5lXI34qQgojC88kvd0sVJqukeFGW5DhbvqD47Y/5qQ+lrHoQddHsLhCxH7FHUuW7I1k/JrzCW8v+NBzbkGlFLa5hbifzIeYuh5XzSeuBN6eSbEDbIjEssPo9UgEPk1+Il3SFA1/FGRcUDfqCFiXpScTih7SABF+hBs1ONkm/dNBzj++fjc44fGuBFT+lyc5H+roDim3Et5OBNRAgNzbsGfCI2vQS7ZX9mhdJZyrF3i+6g/HxKXd+1wqdJCzPucoVdRB9sH0xHioBP2xkj1R4o+IDQa3STN5GyHcQQNcSN1IOpq5QDbSAis4L6OR7wuRFrQ9+anTDZVzlZ2sRGBgYzLBw7j23JDC3TBaU1RPcnhoWCN+2IUMH+l29R0MiDA3gDXOssTEb9s+XiJE3dI0/pZSDkmPDJVg9uJnVMxo+yr6JsJlUbTaeU5qsk2oFnjo5KEvs+oH9eu0CuMw4RlLv9MWlryz5eecuva6V6Ttu9WCxj7/MdkMcdfWvYY/GuOEYjuLhFxmL2cSAgB6dPj0B3kaod3l8g4oKqUIw2u0FaTfGL+FIbsM4u7UHmIE4qsT5r8Uu8ZRe6Yy8jxdwmIGM4zhazkDyXaWc2lU6pFXP0+PypQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(346002)(376002)(366004)(136003)(451199015)(122000001)(83380400001)(38100700002)(86362001)(38070700005)(4744005)(44832011)(5660300002)(8676002)(66446008)(4326008)(2906002)(66476007)(76116006)(64756008)(66946007)(66556008)(8936002)(41300700001)(1076003)(186003)(6506007)(26005)(107886003)(6512007)(2616005)(54906003)(91956017)(110136005)(6486002)(478600001)(316002)(71200400001)(36756003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?w7wzCxp01BATxNM1eycSw3aypiWiqI+Vx9LvhlkjQyKioUQsnUeH6yB9/4?=
 =?iso-8859-1?Q?HoVyQpGdh/oT0RfFgOCwhzWtf7zKWcPD26RYTY5v1HZAvbjEfwoTNMuWiI?=
 =?iso-8859-1?Q?12qY9E2xaXdwR7cINHDIQWJ1eTRqtTUPzzkaoseq6fxA6Z/1icLob8s/cp?=
 =?iso-8859-1?Q?xwOT/nTmxErKB0C+UTQPFoIQsyaEgAFPZg/xXPqpivrqebtezeUa88dA0J?=
 =?iso-8859-1?Q?5MsIlkrRTMseMWTa5lOfsUSQYCh5RcaHf5H4u+8hQyWehWNMY+EvbfBJIS?=
 =?iso-8859-1?Q?Jbnc30Po7McMxmKC8OM1nJrcf4Yq0oi6dxPkJmAgNjGHMcmtuv5Zjk06ua?=
 =?iso-8859-1?Q?/ox7u2Uu3zqdeAj+hq1Li4UmKF1fdN3DOmdiBDARuA5gYFl5MudAZ9i5zp?=
 =?iso-8859-1?Q?FjWtBk+pLKnP60060Ewpg/oidPSA0m/iK84TFjiHa5vFkGAUqMvQIkm/Xd?=
 =?iso-8859-1?Q?BINOKzp84rBeZHTXY/UAZKlpjasd+UUH54VGmz4KCVM3rWkP0KJI4W7s0n?=
 =?iso-8859-1?Q?ULgoJSQ5EyD5Aad0d7qgR9cJ6S7D68PosjxiQKmeNIyhQXR0kPsGudhutK?=
 =?iso-8859-1?Q?DfUmFCHDjv+QHnl6U8oOVOrmA1aIN94dSC72EQ8DTewhJSWGuG0sw2kjgz?=
 =?iso-8859-1?Q?Z/dFYbQAa2yaaZqk9dMBkqyICx7qzyCWUbaixmBNCchwi0OBswWroyShpa?=
 =?iso-8859-1?Q?dQy5aGnECjrym+uYBg3dtD+9YQqwMNXdF0CLxKToa6Zbg+SpArXeQ4OkA1?=
 =?iso-8859-1?Q?Hz3oF4eimjhp6rUY7jMk5FsFVH0nS/mcDQdxmJ6OEbMBZrA8vkM1YTXYYr?=
 =?iso-8859-1?Q?7Xi2hAxnDuT6jkVX20c5wtpk9nmagtqjaOVCgsj5rFWaZovalBuPcKXZyx?=
 =?iso-8859-1?Q?WHWSKLYY0XkHJ0sb/vCeOGprgefIurWnsgMUp3vEQO8+/klLY7tTYZgDsg?=
 =?iso-8859-1?Q?kwrpssMHti9NAEefFEe7yGNgYCcZiRq0DpMQkBYe+MGijMv1E1MYtTBr7V?=
 =?iso-8859-1?Q?J8a1cn2KQtg48pNluh6LsID4AxwpBIgvZpcc66OPgL+s2SuZq6tEA6Uc0R?=
 =?iso-8859-1?Q?COmKEVeh/3YCPAYZJUbCwjsf/ahjdE7HF4keobFEaDojmgZEnPJVDW8R6C?=
 =?iso-8859-1?Q?zW5SrZqciCQAvnXjyoCigjSHXbIL8q2n9jXH5cDjeHQrEfRFqYdh0sM4BX?=
 =?iso-8859-1?Q?FLbc3H/iLq+z3zdQrU2aouo6pSgjtwNxJfGm+7KHgiTyV3CEopcLwHl4D5?=
 =?iso-8859-1?Q?DS603Q11oXBsMcAp6Kr1gfRbCslYV9VkKA64zQZ6bi/QVVJjrmObD4u8tW?=
 =?iso-8859-1?Q?8mH55nlw57rFxCuMTJ9X3bL6AAEB3V5kdQzLxjqH23r3E7Da+V5B3aX+zb?=
 =?iso-8859-1?Q?6x7aPnxU1r/oEBZG2GYiDcdmkT+eYDqD7kpWgbwXqoZZOvItkwsm7mDKPa?=
 =?iso-8859-1?Q?tL7lXXS1FDkhdhWvdC0AhCCXFKs+cBGbvaU7mU5hvB4jq08rSSinSV4TLe?=
 =?iso-8859-1?Q?5G0lrL7DSdyYT37kIVNbqDh2xQd8PbSPrlgEOUlD71WUbxJOpdK3F1x1ti?=
 =?iso-8859-1?Q?nYWNVSRCKXB2aPmZfJrpTirmfz+3uKL1dBZUdzEO0BlwDGc9mzsLVIZ+wl?=
 =?iso-8859-1?Q?x6ina7FizZnVEes+q0tAOQTrIFIrR4MXEHGv/A4Mr6MvCs7lfoIoKi6A?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: wmrFZfZd2+Z7zYQw+1q6DgodcUG5F0CTlTznQIZWbYE8mszrNCNL1ydcihBIpHTuqEcO0q8eHwWabfJEXbsy8GYuXH3D8j4A2hIdA4fT+l5A8yErOIGIqYeZOTQsliMPNTZpP1N0Eor6bTPnvPiM2yBOlJ+mrgn0urg9xa3mOEz0X0w1JpEHrBYXRu3rDSY7swWTenkr+ytunLSecd3AKeVJ/cLkzWQA5kjDRAxwb1WsZGRbk7lD0BPtcc4QkqwCnyZ2lmracCP8H1fj2pXf34vztxoybE9FUL3f0CsWL9zKW3AJ+2zY0v6vH8YYuXfiIroNQ1rUhrVaZ+tG6SqfoByr5xqKSi8PBGhIiGrELKNeywnpgMrgJxUscu3LCquzotQhWnUW6Ht1UocXTIATV9InXVVuw+7iQzo9iquacX3nR25Acm6Uq+o1dPBUTOhe+IPjLYzMjaUF7ZC6H30sH3Zg2Ivh9d4/ARo3yHMHWQtlgVE6RYCAU4B+cqfnAF3MDPCyV9xtLJraAG+7FSGLQbBQ3s6C8JmpjhyiI/0smAUV29S8b/lUMIl2hF5IOeyInh7kWQEI/V9B7UxhwxCxK91vHufVaEy2lpynSKVnHFFjYbM49kR5VHxZm1s+WDdztfBb4GwAkY3mxn6nzYSlLPDf1jt9B5LJFBHWn1yEh9T/+Go6POp2TogLoQBg7dzAqkbLVdytpzmSV9SvomnXMX+a8YL1CqaLcT7+rgwxcBuCJOEV06aBVqLqjTURpZZU7W+pGEcpBJ6jDMzwcNOMsnUxFJnQU+53Qc/GRpp5yPLgbz3h/GJAcrjS8yduWfdXS5dte3gqy5uxck0TpXpCMZSAxi3RUx0lJJ6NLICi97nQ4MMPFnHzi5x+DaN3R++A8ywJ+yP0fG9hQ2TBsxYfhQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01ef2296-c146-4658-cc1b-08daf28419f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2023 20:57:21.1596
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nglDMF9yC0QXh2GaEEwqpubK/8EEpwsvCV1ZgT0g3bdlDhMQKs1Y3mKxUVdfIDLTC4Jgt/lcGG2ee+pgAZUPrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4312
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-09_14,2023-01-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 adultscore=0 suspectscore=0 phishscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301090146
X-Proofpoint-GUID: W-fdNgrJXUkUZT3iZbTOTHxD2PTbdU2t
X-Proofpoint-ORIG-GUID: W-fdNgrJXUkUZT3iZbTOTHxD2PTbdU2t
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When removing a VMA from the tree fails due to no memory, do not free
the VMA since a reference still exists.

Fixes: 8220543df148 ("nommu: remove uses of VMA linked list")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 mm/nommu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index c8252f01d5db..844af5be7640 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1509,7 +1509,8 @@ int do_munmap(struct mm_struct *mm, unsigned long sta=
rt, size_t len, struct list
 erase_whole_vma:
 	if (delete_vma_from_mm(vma))
 		ret =3D -ENOMEM;
-	delete_vma(mm, vma);
+	else
+		delete_vma(mm, vma);
 	return ret;
 }
=20
--=20
2.35.1
