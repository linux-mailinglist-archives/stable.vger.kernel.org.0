Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D04ED67A4AE
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 22:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234717AbjAXVPH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 16:15:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234700AbjAXVPF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 16:15:05 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB5924617D;
        Tue, 24 Jan 2023 13:15:04 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30OKx5qr024839;
        Tue, 24 Jan 2023 21:14:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=BM3xfK2KWRc6V1JYnFcUb7aUw9f+GcPCFNC5SCfVtIM=;
 b=YSpojkzlWcGhCFpnrEV9k3j1iaeDQ0pyi/FFVVJLrW+gYKBT2jN/gcw5bkijzUqR1hz7
 3TpXfk5Th/NrzQR7njVWNef3i5I1YH/2/NRdmRygzJOqLa8M+eF1dabGRs901KyZr0ND
 sxD9+htgZhUp/I9ycq4G55JyOQQ4We7YnDqWJgClDCat9I4v1+EPgpT3ERnXZoVVwQLR
 E1sF/EOFXZe1fEFit7mmlr4PtI7gvq8gLUHGF2z9NMsZtmk8R2zu4gZwHJtvOXOquIa5
 XH2g9PnBtTnJik51AILaG11Be/LXXqmH7DL+SG4L9w2sFj7Ht5fUmzSauNXikvbr6QlG Kg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n86n0xhma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Jan 2023 21:14:33 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30OKXPP7021283;
        Tue, 24 Jan 2023 21:14:33 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g5hd97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Jan 2023 21:14:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EY4Ft+8MYYbWwV8ICzlkTqiO6QmDg4fAvrQyNJ+1aDStp9idmNofbbapQJfY2+nDrn1hIdDfflwbpjfadiBYC5u/XNUzK10nZ477M2nopjQCbrp9RoIztjg44z5MXB5lXd6oNhxR8rQVuoqmiQSspi1stf/sFOWM41Tax0wLwx7KHDLLZrqrrM+JNfzOw4jyADNdc2wEEXUTzDmgtw7pit+GeWnjyRX99/B13MrutzU3uYoF2UnPDbK1An0Gog5FiSoagoFQB2W5LGOeu5ZqCaifcaTRAWDTO5dyMjsXeOQF23UR5K0gJXfAfbXhLZdZQQXcNZOJ47Xgd5k4EkJTcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BM3xfK2KWRc6V1JYnFcUb7aUw9f+GcPCFNC5SCfVtIM=;
 b=AuhqXwCcTyVS5Ttd5DxnM4GtuyLvKdWWXUEOSgVPCRtukqhFL1GfBdtyCKoOJr8eeyhEyQxubj+FTtqYT4eQ9HRks2FJoVBN3avsqIz8rLiY0dev3qUof+73NoHCwG7QJ9l0wQMV1qg1W9v8uVKTEAVLtNNasQnyI5Ek8TSuhRqIuVHWLb7UxYfSIkOgDkDBJgR66is5VEiqK1zf8CEL9NnZSCI3q1H/Huz2WDNcB/rUnHGDKwTnJaCMp6yD4UXfnLxBXvynNjHcnS0UoE0Zx8/BSRW7x0zC22C8ddfs+0vAvaM/aiFBVrci5qxGHqGPLkbAb/TfKZPiDTV3L4BPyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BM3xfK2KWRc6V1JYnFcUb7aUw9f+GcPCFNC5SCfVtIM=;
 b=sj2/YZ0p7fx+wRzjCHXv3d/d18PA9SATl2KFCTZLi1wELGL3wD8J+RJeuOK4WUTkHdueewkvFNcZA4iovLm7QQig7Mr6GPzuI6TNfc5LpND0p4DAGqUGvhWgJ7rTewOihXUjDH2l4h2RRdkUgVzZGk2SK0WAZ9fpIpr0ck5ZsFI=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by DM4PR10MB6232.namprd10.prod.outlook.com (2603:10b6:8:8f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.17; Tue, 24 Jan
 2023 21:14:31 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6043.014; Tue, 24 Jan 2023
 21:14:30 +0000
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Rich Felker <dalias@libc.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Dennis Gilmore <dennis@ausil.us>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tom Saeger <tom.saeger@oracle.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: [PATCH 5.4 fix build id for arm64 with CONFIG_MODVERSIONS 0/6]
Date:   Tue, 24 Jan 2023 14:14:17 -0700
Message-Id: <cover.1674588616.git.tom.saeger@oracle.com>
X-Mailer: git-send-email 2.39.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR05CA0089.namprd05.prod.outlook.com (2603:10b6:8:56::6)
 To BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|DM4PR10MB6232:EE_
X-MS-Office365-Filtering-Correlation-Id: aaf96e60-4e0b-48e6-2bc7-08dafe4ffbb7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bPfQkqG29BPAigoDEQ3Por3Mx4D2kWzs88NMWIJMDc/+BdtXkVd2iwlgRt29KW5vRoOXN2z2siUD8CfT4dPBsWDDGU3ASgscTkmB0KmcJw53efQ2o82d61VTia7/jv5KmHj9A9SV4NONFwFZFDPyyr8rnhNJp6506YXQG6uu/BE4lS9ku+IfyPYXgpSeiIVS89tBfVDameGv1h0EagaDYTUzo+5Qggwckg2p9MAXq00H4/GOISmxoCtFvXQ5aM17TsfYLXqIZL6TBK6+8dnKkbP9/gXhmzB0WhCyYamVia7+0DuVZbCn2K3C7R9g7tnwVP0C2LHSuAEfC9bxzwpYEvi/JLrTVSpiOCMqsuvEkQNnQZZ+1V+OAJGanChgvieLk1IHZmMdNP/qSnbIlOH9Q3wnjnXQoeDvOccxH/i93SebpXf9J95421zWM//C4rl5lV0rwzz5jPeakBedrslLs06dxO8pLIGiFFTQrdnOU5D8oNLvYuL2fNHa1/T4z1HO/yTsiN3r2hlIIIfXLmM63GyC+QFh6t+xtFdcryzlFXHDrmbQjjAgJtnfQoSaB6HV0EuV/qFlwihTHTY0hby3/Uc1yG6og612DKUhnK0O8BTO+z2/iVC4dXwu+0KuhcuZaDA+O6X6WhOmraTEhxuA/Z/cmOKXBzluJMOWSKFucpxkxBpj+Ns9WvXc4OTDTtUdnioQI4E3DLPA9w/1KBcP4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(366004)(376002)(39860400002)(136003)(451199018)(54906003)(83380400001)(36756003)(41300700001)(66476007)(6916009)(8936002)(66946007)(4326008)(66556008)(8676002)(316002)(38100700002)(44832011)(86362001)(2906002)(7416002)(6486002)(478600001)(6512007)(6666004)(186003)(6506007)(966005)(2616005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?t57fDNV/D7Upj0rKFXO3DSaI5e6J2kcWkErSVNYyJJI2aR2jG63E6qMmsI1t?=
 =?us-ascii?Q?kYJt0EI/pYCygU0+us62fYMXQRQdWYnzv4nRUfw3hl8OgY83ONbw/3kSwLUL?=
 =?us-ascii?Q?+Yxo3pLR9IcTgoDqYaBRrdjVdUsGWHsqBt7D0GoPtciTMU9GQDgJGUdOqhz3?=
 =?us-ascii?Q?6J0OQmZB+zYyFhOWjj3864e2Uz2jCLxgCdP1XYL68m13U8WOqLjIPKe5QRnf?=
 =?us-ascii?Q?ldAgz2zxLFUvyyCmQ1ZihYsKurUfFfbOhWhahsV5c0IeOU7o5Y7lQZ7oXD9f?=
 =?us-ascii?Q?vgJeiWZ+0etYdBKCmkXOYo2jCczHbi8O/suY6xKvSh2aiT7qBuntGWUtAubW?=
 =?us-ascii?Q?nxSP+axiD4nh0IlJ92toOq5Fmp6a7xxVwWpc6hsdiVhcO+EtAFmY07H7CsrZ?=
 =?us-ascii?Q?PmIO8tOrKGmLWBq4jtT1UvB23IzNpDSPMtzLe1rg7GABx7nL69hp658JPv5c?=
 =?us-ascii?Q?FjSlvVc/6Njk+fRMJAlWLxnSI+Js2f9tD1vBjocUOWQNtayaDTyhmY2UFLkA?=
 =?us-ascii?Q?xjtHLubHlSx97zoRXazL9CKAueZY/W3OM+qTwlxHfmf3Iwip3mW3ELGrBYAP?=
 =?us-ascii?Q?kLj7NFHJA1h4ygLDThvltvo9ZZaY6Tzn3HFBi81LBsn5HzEBPQIH0Xvw5RuR?=
 =?us-ascii?Q?gZECf+/GL9JKu3+7p6/MbF0WX/r77idoeaBffFDDFtuM1xUYsPdW48h0Cy7G?=
 =?us-ascii?Q?pY5kUQY6FIOgoP7MRc4W6cYRif55iXRvIWUkETybkpqUyQ0T570URC4/q0XG?=
 =?us-ascii?Q?jJqQVdYCQKE2O/dpPbjAz6+U0oL/u58YlwoD0j9s/8/EIKqc5kzuGCbNycGK?=
 =?us-ascii?Q?DSkJpv36A2trQmd7F+RlAfDyCj2y1wup3skbBZDfRoiMTZF4oBZ3tVDgZzQU?=
 =?us-ascii?Q?IR6brBF7HrWVVSb4zq2RtsAGwsjMpCHR7YeMYBXj3CHufisXsflDfZwYz9s9?=
 =?us-ascii?Q?eGiGmMQA5jtMGjvLW754LhWy4nt9CDGmjH+XbQNpkDkR6BftGuNeutf82+TT?=
 =?us-ascii?Q?f8rpePV+kPSvwD/+Ej2YScw1JRtBP4oQX6Ld/w8k+hV3VacfkqUy9cRm9/5N?=
 =?us-ascii?Q?iQ6m3YVV4BUoDQTqwkA+5RZXB22O6/LPcK4Z/Gqxv37dNrwPwLIXDznQe0/o?=
 =?us-ascii?Q?cUvdN94uKWwuFMsUkjH3cTnXnt21V1NQP/cmQ5xDErz3gW555boKSn4K2IVb?=
 =?us-ascii?Q?kNXDEXiF4MdljZvVDzmnlod1e1walCzaq8SNlWvTPmTdsB0/jpcl6hQtRR++?=
 =?us-ascii?Q?SLkduEVSZkBsvEnJppr8kq/7REWa1q56KgYlZtsFYk2/ZMyotU2jGx4WKJrA?=
 =?us-ascii?Q?JUa/QVUfARCeoJ53ohUD3mrFeIF6x9R2zjwUikf3MVMmPLm9R7SBB7k3Umcr?=
 =?us-ascii?Q?MCN+Y3K8KqbjbjY6H0CgSrqxmTmbOCPteVE78OpKyOh401uj8IErUFX7ZSD+?=
 =?us-ascii?Q?kD9pjMg4+9RvVVt/AnrLVKE4HGFp/Zwwx7uh0gDygQ/mn0qnY9rJUECaeFid?=
 =?us-ascii?Q?/lxI2QUiOpuKdDYuhxH1UEddsGPVUdsAJFMFngGNAL+1q7T6oHxHyVsXxdxj?=
 =?us-ascii?Q?50E9x6hV/hB3NmXWN+tqDui3i02B0cZyrC2imOUtPdkqSNe+ouRJQ2oJthIc?=
 =?us-ascii?Q?RCZYzuGyUTX8bV1ZTRaU+g8=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?F0liP2AIG9JWAdspvogybySUs5cD2jJFk4FFlqN7el9x3fTHaITno/3V7sRc?=
 =?us-ascii?Q?l7btTVn6qIYFDfVmxA/y2n7JcU4caznv4yUFFVRkil9OhosO5D16ZRnXNDDE?=
 =?us-ascii?Q?fjaP1w4CsefGhaeu11pPLkDGtGmlDThWFA/zCMVtakdcw/+0h1Jouq9UNTwE?=
 =?us-ascii?Q?ms/wzOIJkzWoJddV6JooE1xaLd8DuMyV+/KyhNxT5y7NzqesCEaf8+CnngBn?=
 =?us-ascii?Q?j0pLJjK6d2fjC6e5n/+HHNrhnHfo4jOHta14FKgke0QrZ/gu7Jq47wS+m9Ps?=
 =?us-ascii?Q?2uRBlxjTLKdvdMJkvpUmT9onNRK7gs0eYHwsp2Rft9Li8TFfNaceQ6Y6sF+3?=
 =?us-ascii?Q?RKHr2IXL1C7uJBumnBCxVp23gIr3XWZB61eqjqxV3KV2iIlbJTeDoGT+FFZw?=
 =?us-ascii?Q?QvqdglSrvHZ2CbUXKS1DZ5GyUwvCqNPi19I1sAAF2mSVR2ENdDjpet8qkh+1?=
 =?us-ascii?Q?ZAl78hs/Wq9tE0eEr/Vn5fQ5gbFM8fNNOQ0/UUTStjg872HdFkOqbG5E3KJy?=
 =?us-ascii?Q?EG6/LmAaChiKjywaYdyyDOFdzRvFy+LQ7M/oiRHp5xV6cM6uEamMyKgaY6EW?=
 =?us-ascii?Q?LvXkryEcCObsUnaaiQVUt2LFgwMbJnn36NpVtx/3f5HglK2bVqQwL7tv3iA2?=
 =?us-ascii?Q?ljFnw/PX/MJ/5sW5EKtK4Xw+vxT9Rr3YAF9qDu5XQpvq2ZO09WQGwaDTqN25?=
 =?us-ascii?Q?97kVDn5WuH1In6ZaeBZeKhp6W7Ppk33q8DsW5sU1rcfzuPKjjERdTao05bFM?=
 =?us-ascii?Q?0ngWiVdrvOhn7aQrZyAK6sVio6kGGTZcCsm94JXAvVWzEO55mxqaTXJuJ5nb?=
 =?us-ascii?Q?eHqRJ35iGwlG1YaRmFYXiatL+K4ZJfoPf4hdFXzvri1n4UyyzoPXybbo2XYT?=
 =?us-ascii?Q?FRJG2QvO67sSpaRObVAD6jxxzLcE7F6+MPF4zF9QbhQdvRICxo/DJYdFCdnO?=
 =?us-ascii?Q?imLWBJ1yzuf7L5kK/vbyAz6acfF2p/Eiq3vTBLk8HD8U2dOwDPJyUbIg+X6c?=
 =?us-ascii?Q?1OY/rEu3dJIB9fNG9jHZdo9K3g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aaf96e60-4e0b-48e6-2bc7-08dafe4ffbb7
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 21:14:30.7490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KbxKaqvFapvinnp92fTe6/fxF/A4MgFr/TevCukkitLwau/GqBO0Nm4duxLploLwsWhntxDohsKikTkpFmpvgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6232
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-24_15,2023-01-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301240196
X-Proofpoint-GUID: kklPTbyaRPvskdVakCfGzQDkTSDfcwEw
X-Proofpoint-ORIG-GUID: kklPTbyaRPvskdVakCfGzQDkTSDfcwEw
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Build ID on arm64 is broken if CONFIG_MODVERSIONS=y
on 5.4, 5.10, and 5.15

Discussed:
https://lore.kernel.org/all/3df32572ec7016e783d37e185f88495831671f5d.1671143628.git.tom.saeger@oracle.com/
https://lore.kernel.org/all/cover.1670358255.git.tom.saeger@oracle.com/

Which is fixed for arm64 with backporting:
[2/6] ("arch: fix broken BuildID for arm64 and riscv")

Which had fixes:
[3/6] powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT
[4/6] powerpc/vmlinux.lds: Don't discard .rela* for relocatable builds
[5/6] s390: define RUNTIME_DISCARD_EXIT to fix link error with GNU ld < 2.36

But broke arch/sh (or so it was thought).
arch/sh is also broken in mainline.

[6/6] sh: define RUNTIME_DISCARD_EXIT
*NOTE* is not in mainline, but was sent here:
https://lore.kernel.org/all/9166a8abdc0f979e50377e61780a4bba1dfa2f52.1674518464.git.tom.saeger@oracle.com/

There was enough breakage in 5.4.230-rc1 that the previous series was
dropped (which didn't have 1/6 or 6/6).
https://lore.kernel.org/stable/CA+G9fYuYi1Rvv19R_EVdht_7LV9qiR-6KVvZUGjct3kEk0uQTA@mail.gmail.com/

[1/6] 84d5f77fc2ee ("x86, vmlinux.lds: Add RUNTIME_DISCARD_EXIT to generic DISCARDS")
First defined RUNTIME_DISCARD_EXIT generically and its use for x86_64
specifically.

  $ git describe --contains 84d5f77fc2ee4e0
  v5.7-rc1~164^2~1

Which explains why the previous series broke 5.4.


I've build tested on a fairly wide matrix so far, but would appreciate
more testing.

with and without CONFIG_MODVERSIONS=y

  # view Build ID
  $ readelf -n vmlinux | grep "Build ID"

5.10 and 5.15 will have a similar series [2-6], as both already have [1/6].

If arch/sh is a must have, then [6/6] needs to find its way into mainline.


Regards,

--Tom


H.J. Lu (1):
  x86, vmlinux.lds: Add RUNTIME_DISCARD_EXIT to generic DISCARDS

Masahiro Yamada (2):
  arch: fix broken BuildID for arm64 and riscv
  s390: define RUNTIME_DISCARD_EXIT to fix link error with GNU ld < 2.36

Michael Ellerman (2):
  powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT
  powerpc/vmlinux.lds: Don't discard .rela* for relocatable builds

Tom Saeger (1):
  sh: define RUNTIME_DISCARD_EXIT

 arch/powerpc/kernel/vmlinux.lds.S |  6 +++++-
 arch/s390/kernel/vmlinux.lds.S    |  2 ++
 arch/sh/kernel/vmlinux.lds.S      |  1 +
 arch/x86/kernel/vmlinux.lds.S     |  1 +
 include/asm-generic/vmlinux.lds.h | 16 ++++++++++++++--
 5 files changed, 23 insertions(+), 3 deletions(-)


base-commit: 90245959a5b936ee013266e5d1e6a508ed69274e
-- 
2.39.1

