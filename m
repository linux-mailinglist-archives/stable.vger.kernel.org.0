Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82EA841BDF2
	for <lists+stable@lfdr.de>; Wed, 29 Sep 2021 06:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243956AbhI2EVW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Sep 2021 00:21:22 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:41432 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243937AbhI2EVT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Sep 2021 00:21:19 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18T36kXE001820;
        Wed, 29 Sep 2021 04:19:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=lj8pLGI0rkFmMc7x++/rnBbPx4zJBH45TtWIB1Gf3ZU=;
 b=a8T/4BTY6WbTC3Bg47Ulb3RZxuuJsqH4lD1VW+ijtDYkKGSpl39f4NlfkokC724Pb7/9
 bB7BNPL35zBqFRcN9b3FQ4XFatoMLA39/uLLYeS75ssWNqoD4g8thKRHYlebBzLrH1xF
 P11WzTeveeJRqY+AJLwPknzTpBD5CQvDgN+KNuRkPVvPVHjO2pDljnMlRlZMYuTEaGUq
 I1qIyPjogcbsfZMohfuOaM+jGaPKUnazHQDF8v6IkReCUbcCPiIN3E+sIenkCJTJdOy2
 sixawywpZx3h49jeasWdm6kz1M4/tXMKVgNXcY4rkSeDjWIiqA1BNcKPAO8yOC+kn9M3 xA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bccc8958b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 04:19:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18T4BdCl132115;
        Wed, 29 Sep 2021 04:19:31 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by aserp3020.oracle.com with ESMTP id 3bceu4usv7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 04:19:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P4tqi1vi1lfeLvwsozsXsG5TuZc+VfGm3d6MvLlVaBW+g+LbB81UcN6TL1pxshq7awFZ+GAUlE6CjXkN+q5lMNPd7eFcInaTsf5ZyqiOUt70BmEk06GSvNr0cWS609Ha5nwQGTMqhmOzfHoLcOhNt1iORrpox4Y8jg0o+dl3YyaLMk7Zh3umJwnS51z3ledT7Rvilb4/OC6oq829TW3PQGYS5frlqmymGodSPx0TjJT8vskKQZk2taWCujD/sBM7yIvZVkmtVgWN6G4BiNdVNfAPYouTqqFpMskQ3Grtn50zTxhewdznODf+N9nhoAU2nWRxs9JzSFGu0FOKhEicLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=lj8pLGI0rkFmMc7x++/rnBbPx4zJBH45TtWIB1Gf3ZU=;
 b=n/S//HSLKmFjFFHEhXfhcIdBHLU3xneMLO3VTlqvtqISrSL0f9eufkZcUg311095OHGAoTlxOShr1gtqnkM+SKhlml1Io/mTS0J+UWj/rh3DGYcZHkkCLZREZKxL6Xo6MEEGRNyfvERYdt6t27NO7K2RKIcpjKQD7EO/jPtKMMGfHy3sFSUef80urJGrcpp5TPG6XjVmZB2tXnYDYkoaC4QZWCPhVztlvca3mU88VHqxIt3z9oAqzQcYc7Q9iIyO79uq3rmMGwGjxSb9A3QZRNg9zdq4O5dDuKo3IsK3b3P0kM9EDVZUFYmZsbQ0Bnb4FZrepTkxAp7fyaccZO3IPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lj8pLGI0rkFmMc7x++/rnBbPx4zJBH45TtWIB1Gf3ZU=;
 b=ca4HryyZK3MT5Vl0ZWDR7DI7oZ5npFU0tE+WZ3umDoNh42IiU8U3x+Rv/umq7cwCpGx+TUWtXOCNBBXtMCxI4ldWdOtvYzqwI6/Qsoz3lN8tmhYLcgI7wcwUFg4ttSH2ALHBNtKDV1yJCiP26foAtBf+ye/mXCxNKIHixQTI/vk=
Authentication-Results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4551.namprd10.prod.outlook.com (2603:10b6:510:38::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Wed, 29 Sep
 2021 04:19:29 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%8]) with mapi id 15.20.4566.014; Wed, 29 Sep 2021
 04:19:29 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        Jonathan Hsu <jonathan.hsu@mediatek.com>, jejb@linux.ibm.com,
        stanley.chu@mediatek.com, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        powen.kao@mediatek.com, jiajie.hao@mediatek.com,
        peter.wang@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chun-hung.wu@mediatek.com,
        stable@vger.kernel.org, wsd_upstream@mediatek.com,
        chaotian.jing@mediatek.com
Subject: Re: [PATCH v4 1/1] scsi: ufs: Fix illegal address reading in upiu event trace
Date:   Wed, 29 Sep 2021 00:19:19 -0400
Message-Id: <163288913990.10199.16644318029908421038.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210924085848.25500-1-jonathan.hsu@mediatek.com>
References: <20210924085848.25500-1-jonathan.hsu@mediatek.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0026.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::31) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR13CA0026.namprd13.prod.outlook.com (2603:10b6:a03:2c0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.8 via Frontend Transport; Wed, 29 Sep 2021 04:19:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 55f56766-ac21-4339-0635-08d9830054ab
X-MS-TrafficTypeDiagnostic: PH0PR10MB4551:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4551F346FB47412316B248D38EA99@PH0PR10MB4551.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6FBGQYCBG23ftiopmbgrvQhMMegwg/cfj3kLZATh9vcKEPleDq5G+tVvfGS6Ks40OyUfUPstWgpw+uotd2k2j5xrqwV8Sd92yA5nK5KIwNw1DNSr0bRE5ZID6eN7UevUNEd6491w5MLP0KTc55AA7NoCzX8ekNoTbCNEVx9alnClyS2bru04bk+Qe05H56KY3PcrUBTGG5BwQQ0vapE2geWd07UP4vpgLzu8CXvAo7JagyIxADJze9kMuSAJMse9eFuJ8IWKIMR4DlQJszCVqWtdbb7oqbXqOhqBxWvyTRGVZ3V35eVxubhG6qkg2mI4cj27V82DcNG/klx0WYeYek+6VBCycu8PO3UdcWN4dZUZ6j53m+YrANWI8XtKL6mU+yLe11wF81m8D/+G6RS5boxPM5qHVMfQkpNffZMNLlFGPyNNwVCEQiFIZJnLy3YYJhHJ9l3Nl5s2I/Zc7ud+ZQZBVDzTa6MWacx+pga7SAcvT+nW6fgBgvwlnDQfTMVXCj/OuWKP35Z9+Aw4WGte4ValXC+sDFvVE5FWo5nPqEP61+vz1Itye72D217KcZ7Grs3qhH0L4fGA4zCXq2HuQktq30NlzjKPmdI9YMjLpCNtNeoTxtQkY4Hs7mnMKarcw7Advkz/sHKVFMQvS4t2ICbuyH0Z2ku+3Jc8Xid4+9WlV4WtlFdiui2Rq/PSh/Vp0IUINTypQH9tkM81b2pRnyIxzAIfU7UuohVtuNahRLhSnjPrTsHSZ0EcLjGHRejEnbc9PNEdFR/+s6d5luTj+UEUMt6kmVcEoophviTChuc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52116002)(4744005)(966005)(6486002)(36756003)(103116003)(956004)(316002)(5660300002)(8936002)(38350700002)(38100700002)(7416002)(2906002)(26005)(508600001)(66556008)(66476007)(186003)(66946007)(8676002)(4326008)(7696005)(2616005)(86362001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b1lqdWlKSFA0NlFDMGY4MUUwS0VDWjFvNVcwTVJ5NVZWZ2I3UjhxVTFHUWVj?=
 =?utf-8?B?U3VEK04wK01DLzk0bUlGVUhuanYzVUdRd3dYL0ppaG5zOGFKN2VSSnRPNk03?=
 =?utf-8?B?K0lsTVVIa01oM2d3ZFM1d2pUc3hCZk5JWGkxTnA5Wk1NTWluUFFpbmU4NjNs?=
 =?utf-8?B?ZEZRemx4dTc4ZFpQV3VDWDVjMTN0OWRlV1VlZWt4TGEzclNYSHdxdUIxQzZx?=
 =?utf-8?B?UVFpN1hTTkpuNmk2L1puUlRhbzdMVGlleFJZcFVrSUtOd2dpUmgvbmkyTHlP?=
 =?utf-8?B?cGIxcStDQjZhaWFrRHVnMGdhVU41b3hTd2N6VzZhUGM5K0w5NGFqNWtyZWJR?=
 =?utf-8?B?clUwV3MrVXBNaXhmZnFoM0p3cmFrOWh4Z2RTbDdTVWVtenQ3WU4rZ2J2dm90?=
 =?utf-8?B?OW80V0ZjTFExRjdqNFhobHFGeTlFUDdnRm50OHJjOWdZWXpIMVZHL2ExZzNj?=
 =?utf-8?B?bXFsSjY4bEszUTAwWk5ad0VSWTJ6dVdITG4yUHJQbnBDaVZHSy9wVlJ3ZFM2?=
 =?utf-8?B?RmUydGJiOU9COUo0K1dvVVlsS0pJQnBMUFk1MWtBRVkwWWJ5MXNlQkRkQUtq?=
 =?utf-8?B?cE42SzFtbXdMckRTL2prWDUyVGpjSm9zMHRneE9yTTV5TlpjbVc0N2xHVGVq?=
 =?utf-8?B?WXBPZ3VjcUUvVVk1M2p3dnJWZG81Y1dXb2M2R1J5bGtyQ05JNHdiSUpkVlFM?=
 =?utf-8?B?a3dnR203WW9ndFMwY2taU0gzUExxbVowZVIyZlZCeTQ5MFhWSCs5RHFXM3Er?=
 =?utf-8?B?R3Y5bDM0WWJqOS9yRkRXaUFKTGdINndOQnMxRThWVXZpUW1QajdnUzBRdDVt?=
 =?utf-8?B?MlA5N2hxV1JVU09YWkl4Nk1qQlVqaFZaMW1lYngvZWhCdU56dFlleVh3a3lt?=
 =?utf-8?B?UWJRcWZ3S2NOaTM0dDNVaXdIVTNKU0pNcW1PdUMyZmwxV1VnMklxKzVIV0hL?=
 =?utf-8?B?RHRldVpFYU1qaFpuUncyQ2tYL3V0WXI3RGowOUZrYjFHak02RGFibkNHUGsv?=
 =?utf-8?B?dVRhTEdvRzV3Q3hzbEZxT0E4R3YwREk3VW8yUWxOMlJhT0xDRURkamFYYlBD?=
 =?utf-8?B?aUFMZ0dqc0hiNFZPL1NvZ2NWZS9iR29iUkI5SXRYeHNjWVlrR2RRbGxXOXZh?=
 =?utf-8?B?OEQ4S1E5NlZhWVRxV0ZTZ01OSG5qa3ZrWVF6a1poMDUzSllDbll2bk9hYXRP?=
 =?utf-8?B?Y3F6Y05hOEdHTWszZk82N0pYN1ZuRUZ1Vjlmc0dkQ2JRbTJCVFIrdUpqNzQ5?=
 =?utf-8?B?TGdMczV0amNGTDlSelVOWEovVTN5cTZZMWpENHhmWUhSMlNqUXR6RW4waGJO?=
 =?utf-8?B?d0EwMXBLc0FQTG5qelhZMDkvTGVhNEpPeE1la0Z6bDNPNmFLVloyampuTmx2?=
 =?utf-8?B?OXpkY01vODNMcStqMnBYWkZrZHI3bHFFN2x5UmdmeEhIV0JuOHJMZ3hXaG1B?=
 =?utf-8?B?OVhlNnVPZG4wbEV1S0Yyb29QUC9GNnFsWEVuaGorazNuNFNYQ3MyNTlRQ1pG?=
 =?utf-8?B?ajFtb3R1SEJaMXNoMDJYaExlSld1VzdTSUpkN3gvWnoyQUh5TG44R1FQL2dv?=
 =?utf-8?B?dXZMcko5M0I2T1hwTG15OUdQNDZ3d09mUXVFTW1nQ3JEY3FlS3FHR3VUaEdB?=
 =?utf-8?B?OTMyMXhFMUs2anA1VkhoM1lmK21wMFlXOW9rRkVuc3FMRHNMbE1DeUVPWVk1?=
 =?utf-8?B?VkxXaU9ybTlIZHpDbGJ4cUhSdDcybGJNUmtnYW54K0xJb0MwekxHWUZzYThn?=
 =?utf-8?Q?In08JBnKqku3MXUxRz/W7bch3ygcEXAmAwoUhuV?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55f56766-ac21-4339-0635-08d9830054ab
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 04:19:29.5459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rXdL/VM7PyQPT5Vper9nJ+ztZHJlf4S8Fp+Gbxe5+08VN8ST2JsxzcCtzlEhsLM3bmmwDcfmzl1D4XqKojBAPXcX3vEyiSnje5/rzTBh3qo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4551
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10121 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxscore=0 malwarescore=0 mlxlogscore=944
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109290025
X-Proofpoint-GUID: HpNxMpB-mCpNslDeLynQt7ILgdxopTVW
X-Proofpoint-ORIG-GUID: HpNxMpB-mCpNslDeLynQt7ILgdxopTVW
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 24 Sep 2021 16:58:48 +0800, Jonathan Hsu wrote:

> Fix incorrect index for UTMRD reference in ufshcd_add_tm_upiu_trace().
> 
> 

Applied to 5.15/scsi-fixes, thanks!

[1/1] scsi: ufs: Fix illegal address reading in upiu event trace
      https://git.kernel.org/mkp/scsi/c/e8c2da7e329c

-- 
Martin K. Petersen	Oracle Linux Engineering
