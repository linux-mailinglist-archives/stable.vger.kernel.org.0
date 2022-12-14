Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7B6D64C2A9
	for <lists+stable@lfdr.de>; Wed, 14 Dec 2022 04:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237224AbiLNDQ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 22:16:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236910AbiLNDQZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 22:16:25 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A24E17880;
        Tue, 13 Dec 2022 19:16:24 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDLOA0n014258;
        Wed, 14 Dec 2022 03:16:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=K0EaNu7eV76td9RAUkqBIxlp89gblDOGztoVW8+box0=;
 b=uhBCyOoeKl3jRzPX1QUnSJlUvfUsOGRn94JSNsTARNM6NT21T1IyWmyQJHZfDD1pDZdZ
 l/6zMXEYkQpTZV22GAzIO/wusaiW4v9Ripy3KnPSh7shCPXA/6+nWdB47cqABYwRxmdA
 0PClWrZgenkqfmSBRl6263qfwvMktR8t5MnqIiKOw4Krspm9RfzH5AWVseN8PjrSS+J9
 krIy6wVgp18iFUy8i8ASuze4Ttk4nGPnq63dI6A3M9iad/OnAhOYyhNKOzKVmcNCQfq+
 t7noInRrHp2wn53q7/5c+4q1uvRsuTruJgmr5FQGkKbcN+kEo0QTTUhMC/eXgtM/LyQa Zg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyew8vk3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 03:16:13 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BE00tMt012243;
        Wed, 14 Dec 2022 03:16:12 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3meyev98va-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 03:16:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VoHc4b5AapvXa6w7TReG4ioPRIfIirQjg52ip46sP29KvCeb5BPT/B1HE8WcMhtaJfi7geVDkfrDDwxN3rk6Mq1k3vEYysTHCuhHgr0JiENvBlBO/Nwi986ideKD9aFXT6v1ssfdGAcIEwXLWSSLimhtlrVNXpkgf5lDlNVzesRlUrmytZwUP+K8FMu2PNfLpknGTh5e6czR+EQ+JMsNZXvm+XQ8xwpu23u2PKA3+URyu0MnLIsEEw4JHA4sipxQbsbCrPOcX/rKado6wJVwJpvygiA1JY2yOO3bOnkCD0kM5+JlHEjc0npuF+Vn9o0oUSCZEpl63/Db0jDT9INa1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K0EaNu7eV76td9RAUkqBIxlp89gblDOGztoVW8+box0=;
 b=Wz8oiHp45rhK7zKQnvJWaTTf18wWScTHuMuArRLL5KJ0l5Pe8mtG/Ssb6YQdZQDBr45D3laV9LVszttUxdfK6YkQ991MMi0S2mZhI2vl+13ylZaNP0aTQEyUT0OUk2WzVFocxFm9QkFl4oN6ktGHbdUpI2NiqHjFkoKtcTKTVyvWrCp0B6W/x5o/+Gc/YRSymXk7jJmHF3lcDjO/R/f62myVPiRaekn4PV2ldc2mdggvI+hjrvyAvmK+ql4+u5W7bJ4Fq7JgcBrMY/8xBA+sOas4+ywQxhHQwnoTy1aes+PQJ+93Brs8d9yQWmTqSglZGTd9nrTt8k6ZoY9ZofLSmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K0EaNu7eV76td9RAUkqBIxlp89gblDOGztoVW8+box0=;
 b=tTveRhpU6FgArkjZaXDfiH2SXjGeXAZvMAG/NrmyGAwpr2yWtROn8sGj/oWKCHh1+4UOyJwB03dmbH7tS+hnT7JnWU1cJYfHEC4Tyk46nIL7mcMsGPeSSIutSYr35WqYv/jwcIMSbXWsxUZyUA3dRN5SLvcTY8pwjeGbKCZnS/Y=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CO1PR10MB4561.namprd10.prod.outlook.com (2603:10b6:303:9d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 03:16:08 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::25bc:7f6f:954:ca22]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::25bc:7f6f:954:ca22%2]) with mapi id 15.20.5880.019; Wed, 14 Dec 2022
 03:16:07 +0000
To:     <peter.wang@mediatek.com>
Cc:     <stanley.chu@mediatek.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>,
        <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>, <powen.kao@mediatek.com>,
        <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
        <tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
        <naomi.chu@mediatek.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH v6] ufs: core: wlun suspend SSU/enter hibern8 fail recovery
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq14jtyekv2.fsf@ca-mkp.ca.oracle.com>
References: <20221208072520.26210-1-peter.wang@mediatek.com>
Date:   Tue, 13 Dec 2022 22:16:04 -0500
In-Reply-To: <20221208072520.26210-1-peter.wang@mediatek.com> (peter wang's
        message of "Thu, 8 Dec 2022 15:25:20 +0800")
Content-Type: text/plain
X-ClientProxiedBy: SN7PR18CA0023.namprd18.prod.outlook.com
 (2603:10b6:806:f3::16) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CO1PR10MB4561:EE_
X-MS-Office365-Filtering-Correlation-Id: dcebeeea-8bcc-4bb2-ab36-08dadd818a0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XmYXRthKSQTduZCxJQ0GnPkD7WtSdMflRfS0ybvmvetF7dQIUzHyhAhWl3mxbbLiWbuxu9cY78sN9Zh+qgKJz53XDP96GIoot+lqRER572X19m21ibB9Y+3rn4Q7x7bLXHSPMR+DwP2jwqEBAnFIXWmgB9HtokBTWRwrauQSyiYwlLUQfLnsd8CuUaCTDBK73nDQXYii7I5Trh4PCmk6zX/uFcd/RmNawVpdb9sLknT63WjpemmMhnviKDdpPCd+nvhLoi0DCZGReoHNIsk+KBqxwPXw3xYc2l5gPxQLif8aFLAnoecCiF1XEeG1Aet2+Dl2/T7dMP93CN+8cNgtMHyVIWQG89N26DSvgeJbmnNWEMriS0ELeRlHeJCjyUBntv2/+4jBWwYR4gKVHN99L35RZuL5JXjs8dvY1Fe+z0C3S9oTy8cbrZR768Xi8vdPc7o68SYZrWAKLe7AZ6YUdVvRa0alMaY2COejTsUkVJhso6xWdbygHi8SlbM1qSs8gEepjpbyRBo48rlhCOa/wE38VkmQ9fp6I+XuTbC0Zh2euMvbNZvoMiBxNHpYIIDb+LEGfDmHx0roRMdETKAYwOX4JWvuSDDN5kc0Y8xghV2B5jLmQqvYIy0OSo2yw8YIosz4lL8f6HpU1S/hp78ifw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(366004)(39860400002)(396003)(346002)(451199015)(86362001)(186003)(38100700002)(26005)(478600001)(6512007)(6506007)(6666004)(6486002)(36916002)(4744005)(7416002)(6916009)(316002)(4326008)(41300700001)(5660300002)(8936002)(8676002)(2906002)(15650500001)(83380400001)(54906003)(66556008)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cXIuDTAkEWHUwtM9SXFkVrYeOn88RU0oOKncof/KKeZOuDLMnxUN+RdFNex6?=
 =?us-ascii?Q?33Y11u3p5NpUuVXc9W+bC0rtNBijIktL/O/bqsCp28uU3XfWt026sxI6/C3d?=
 =?us-ascii?Q?df11r82mcQXCGViU1bz625Hp/nZkF4jYHMvFRUpeN8So6GGPi4Ck4byVaZIP?=
 =?us-ascii?Q?ZFkCjOR5Z1OzjG1T4VmuNwcwECZyrYtpR7BXD+Ma6mQPFmgbAz3ak/Ajxw32?=
 =?us-ascii?Q?COP+mu7O+1w2cAaPOAykJ2MQXCASkttvfw/tSFj11654SGcP1aLFawTqYTQe?=
 =?us-ascii?Q?Odlv3k0MW/5k80tcDBNLwla8FjZ5p+ApLBFy0Q8ssN5wqAHjaiw9k3Y7dcKO?=
 =?us-ascii?Q?d7GBtjigrPvO9Ve46HXaOzxPqIUJIhYFtixa/WLNoQEzqxOLUFA0E3FAYCfn?=
 =?us-ascii?Q?6VOJAqRvRCuZjwyU0TGX4yY72S0oE/Y4LGSAbv6yz7GqW2/Tm+p+Qbe5PQiR?=
 =?us-ascii?Q?aZwUm52KtZ8tuRtbNrHam1yzxBgg9YM3ZYcmCQ06UiFnND8GJEXoEVhHCVgk?=
 =?us-ascii?Q?09jRwI4w8hXw560CfAv/lW44ZmLHF64L1l5Z6L0kobi+xhDe8wzGNSoTn3Bi?=
 =?us-ascii?Q?NOpXcHlFfgNicxex6unOu4C3TBm4PrPRkD1l2T+TegbPmSTtpeLqy9x6ZHxl?=
 =?us-ascii?Q?k8Ubcu39kk2ronI1abT0Yz0keZ7QyjTTkddvZajPmblqxUovyTQWv6sk9RA+?=
 =?us-ascii?Q?JsgONhYa/z/1milLhVapM/bPSSVO9tc1KZETh9LuEGsJZRK3tMoJFf8vyLp6?=
 =?us-ascii?Q?/mAOAoq3AhgbFfEzz6ReGapj0o3rOdcGA7Q/rTwVnD5UGFIr23glzftSGozt?=
 =?us-ascii?Q?5cjrQyTPKFQlUhgeo1R49thtkCT9wfJRcnpdwpxE8O8zboFSpapn6qAhJrmE?=
 =?us-ascii?Q?FUyG8kKiT+dLL2CcCXJ9fQEPKInFf+zX1ESko7ly/N2GIHAWuN1Pk5OgdwX4?=
 =?us-ascii?Q?6UkDrLnjJnygMEMaKSMcotTBwr9/cxHZboEYjWc6oE0+uf+3DfCQ8nardPzN?=
 =?us-ascii?Q?JRjV4IKz0y0QEMTE6DXBWfPiWohNZ9m1dWk2/ggf4mg51vafBCfaPN0qwl8B?=
 =?us-ascii?Q?qvvm2SSqK0BcOlYuM8r2lJ+X5Nl1ZLZdT7tpIUOsb7+ZeeoOd2dd4AF0sqky?=
 =?us-ascii?Q?lb3eeuutUufmx+gtU3fWHyi+9pw/U/y5oF2pDtIYJnNXXf66hiBYy4VLQYKv?=
 =?us-ascii?Q?OiMc2e61+dA41FmG0CTzz3t5CulG2+DSEZGrpulww8cxMmSJ5VYDpkCQXC1Q?=
 =?us-ascii?Q?ErNpxy5BCMnYZjas+05oOW2j5UWMS0XPcUGz47CpmNchW+md6vQe/NtV/8Vc?=
 =?us-ascii?Q?3S5spxqxUss8Un01/iogTHmFzKsLPOwFnwVzxs1Kxyd72lFsAkUJWTW79LLd?=
 =?us-ascii?Q?CYe1KvJZYRR9wRbPhp7Oiknri/0C7mB0b4Jz0nfbUXo+la0wCw2GqNP4iW9k?=
 =?us-ascii?Q?Wa/oEZY+ggaAbu+ofeXcQH8zFbQEUB51/suUd/4UE5pLvE0bzADPcTZaCcy4?=
 =?us-ascii?Q?RguXUBompEsOQ3CvCWv+HHNbuSHkR5LBetVGl+LjN+N7POs92cjmvK4a1C48?=
 =?us-ascii?Q?iCm4gGwM8chFKf0YdqcrbJe9OVYHDiyvz9Ygp7RyJ4viZ4nAglrTfBKNG0j8?=
 =?us-ascii?Q?JA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcebeeea-8bcc-4bb2-ab36-08dadd818a0f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 03:16:07.9094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ycmiTuNfDrlK00peBqfiXjwReNTqfjxzdbyCd+8ZXGcFdsBnmegXHPcJfxaauzW66LDhAileRHyioqT7SFAuDL/setm00pHW3YtUSkV8LOQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4561
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_10,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 bulkscore=0
 spamscore=0 mlxscore=0 mlxlogscore=751 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212140024
X-Proofpoint-GUID: 44RzLwCi7laCf__EItwpKcEZsYL0Wqcz
X-Proofpoint-ORIG-GUID: 44RzLwCi7laCf__EItwpKcEZsYL0Wqcz
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Peter,

> When SSU/enter hibern8 fail in wlun suspend flow, trigger error
> handler and return busy to break the suspend.  If not, wlun runtime pm
> status become error and the consumer will stuck in runtime suspend
> status.

Applied to 6.2/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
