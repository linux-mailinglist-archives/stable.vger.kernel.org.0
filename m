Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 706BD35D77A
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 07:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344717AbhDMFtA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 01:49:00 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50990 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344700AbhDMFsw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Apr 2021 01:48:52 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D5iIxc053753;
        Tue, 13 Apr 2021 05:48:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=5tvwgte5mJiZRE/g1iq/YghMPlCg8ZOqU5IbB7njzSw=;
 b=fLzmAUa1Ri2GHNUHG3/I/hCRrGz6qKDAfDro+HGBikXb3JaVS8OC+oDvdK/kpXSIqbGD
 orrfH/ERhdziZGD5PDwE6ZuEAyn8MWsxA9VbgCoK/jo4nWRjj2HMpV6x/IsYikjJRc2R
 Nw30wDGlyDAr1mfCGAY6/iF+dGuhdfdJrDbYn7ODep4U7bWxm7+C4vFhvqE1anNQxIJ6
 dWxPGNpIcZs3vjtx+xiL7OTTHaCj9XNnVOGqqLYrzEYaQfZQvzaasmYeKodOD04HOg7+
 7hX63tPLF1hm5EsdiU7EAagVduinJS1GnwdZ0WumBIIvFUT09kh2cl/BcQPauT0+J5aU +A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 37u3erdusx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 05:48:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D5jRk8090719;
        Tue, 13 Apr 2021 05:48:31 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by userp3020.oracle.com with ESMTP id 37unsrxccu-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 05:48:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TVrfRYgtP3Y2uhnJX/kKq/UCmd5ET+S+LbCV8YJPLPbPGAyq/fGl/qHmwJop/H28XL8ovCtONesZFRLIyFW/SeL18ip+T3OBVaB2fAX610TX+dx8PVkvCAm60thylz/X394OWcmnXECJn0QQTLVw06j+ImM5E8OMZZ2DrZag9NpFErRv7h+r/rAtrTtyNPwB5M1ES8HMV3qwadYsE7UjUWIQUr/SRcbVqMEafhPM4nunTerdlDv46aPfCrUSfWkvTUYzaxBwLM7Kosc2cI6S/BXTPw3nut5qyjG75fiyWeCIk+qWEEhiuI8TlJBiaBQcpc8s+sogpmuPueEs+tzNbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5tvwgte5mJiZRE/g1iq/YghMPlCg8ZOqU5IbB7njzSw=;
 b=m5qCzXwsnVYEBcUsywOcNy8w8BkhqgK0HH0R0e4hOmghAE0Odub+v54jW66DQCv2CsKnrgMRqf1Hu1cdQJYH9lg4iM+NA9NRZvam7+0AnHOnqyoDxAUBSXE+OQb6rUVs7e0hOjBAKI+zDX+HBqxpF/YhMvAW7/caZr+EHC8144PKzG8+C+fy67zLoSB4mPL7Mtt4mCOgmFE0cpzdd3kfyY/Y5hnFKUlUl0imgR8Xn1DZFFpZlOJSCCelFEz7VSZCTkwWR2oeKirElFOwNcZ8pPaBM8NhsZ+y9zY/OCEtLZUVV3rVKmpD1jgm8qzh7iy5EH/uyVz7q+SHHl6nxgMvEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5tvwgte5mJiZRE/g1iq/YghMPlCg8ZOqU5IbB7njzSw=;
 b=BtUpUb6X88Dd4Xo1j3OShfQO4pdloMMh0UMWkN+9HJu2iYb7goy5D8CaTcoi4JGSSBXyBYSc4y6JaBt1X3pN5K5TS4wBDokjQB/xbRWqDzKksInhNAsHZyuR3m0MD3aQ4bo1hV6b9Zm6goI83KBzClM6vx/6lMwicsWqhdDbLY8=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4614.namprd10.prod.outlook.com (2603:10b6:510:42::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Tue, 13 Apr
 2021 05:48:30 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 05:48:30 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        suganath-prabu.subramani@broadcom.com, linux-scsi@vger.kernel.org,
        stable@vger.kernel.org, sathya.prakash@broadcom.com
Subject: Re: [PATCH] mpt3sas: Block PCI cfg access from userspace during reset
Date:   Tue, 13 Apr 2021 01:48:15 -0400
Message-Id: <161828336217.27813.12188273841667891929.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330105137.20728-1-sreekanth.reddy@broadcom.com>
References: <20210330105137.20728-1-sreekanth.reddy@broadcom.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: BY5PR03CA0008.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::18) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by BY5PR03CA0008.namprd03.prod.outlook.com (2603:10b6:a03:1e0::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Tue, 13 Apr 2021 05:48:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 68f07e9d-78a8-4359-16b1-08d8fe3fc420
X-MS-TrafficTypeDiagnostic: PH0PR10MB4614:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4614227EC16BCA9BD1255ED88E4F9@PH0PR10MB4614.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6rUisn6TSuf5HdBo6brEtsipbS/DjQlngD5UQo2gWo9D4YCROLKbpn77sw77uEMSkMj2vC5wJxQjuKKLGWb3juUaeHH6gHtMINzdXnMzT6JQ1ktKOCdTy2nSLp0As4q/5ihsq+9QaQAMKol3VmImwOjGyikrbvstvbqNmuSGB60MYL1XozNtmtyZ8Y/Z3YxiwV2vFxA0Jfo7C/LIdIePNvzRPEqEyHEVUv3lCWc0zyYW6ClwC+R7Zm5/VBGV1VUKd1cgOYYVaXG17fHHWnIeyfbaQtmcAmlK9rHYXpwZMZYKAG207Ae1x9PqrxikizfIl9qoaDVUINrUz5hZGUopRjWRjDeAUcsSR1zhjMTc/WzU7DZ7cBKh85RpqWe0qKMZXdBl/vIkPKRK9PO4mahrALe/Qm2PRrPJ2661XInNBWb8v4lM1q9Rvj58e9LDhA2W3PvHQl1ip9BgF0s+/GTliUKr8fsOb2WslMdh953r6HOgWi0ldslZgBmv6rRuk2Q/lOiApQnSUdKaGErBuA/2xty/6TU4VbKY2EcoAr5Gmk5eYx38CDvH/bPedEgH8RDJnoVgs0/mPd4dXNIfwQy5SklXJJwpb4/IKN1bEMf7DGKX+FMllgnQ0RmdUexS65pUCmyUAEajoq25MsWfpCu7awABnkWf5VlqFR539MUw9Blz+IyQo+W2bvmyeagjl54OFi1HbLIS0Olh0BV5FkgxfK/cF+NLH9xopwvBKB1Je4UBSAaLQ4w3gVxrIlPt1C/j
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(136003)(346002)(396003)(39860400002)(966005)(2906002)(6916009)(4744005)(6486002)(4326008)(316002)(478600001)(66946007)(8936002)(38350700002)(83380400001)(66476007)(16526019)(38100700002)(186003)(5660300002)(6666004)(66556008)(26005)(7696005)(956004)(36756003)(86362001)(52116002)(2616005)(103116003)(8676002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?emV0VUkwVGZVMTdHZzZ4WG4rOElRS280NFQybG5DL1NEWVBWeWJDQ25pQUhR?=
 =?utf-8?B?SFdTSElVamNkK3MrZFh3a1BzTDU4T2Y0dGY0MjRZejk1SURHZld3TzlGcStQ?=
 =?utf-8?B?WGlPRi9ldjZESG5tL09DbjJsMXJ5alo4eFVPRnFrVjJuNEtjMVBKa1ZLTWFa?=
 =?utf-8?B?bGhKQWtoUnNQaG9NZzZpOEpNMmkydTRuMjJCcEhSaEJoVTFoUzNSTkpIRmlr?=
 =?utf-8?B?bzBSRitBSzdkT0xpcnBkTm9KL3Fxd3p6WFJuMXB1SC9tWnVrK2hVTG1Uclhk?=
 =?utf-8?B?NDFZRVJZMTJ2SzIyaTVuYzZFRU5BOWFqVzVtS1VJUDd3VVQwRTVJTTRKRDRl?=
 =?utf-8?B?MTN1SE0xajhwbGF6Yzl6UlR2c3hzZjNsWHg4blZaN2V2UVdDRFRlcEJtVkFn?=
 =?utf-8?B?ckUvSWd4QnlRSGRVNE95anVQczlTa3pZZTZXR1ZzV3A2OFlpVTQ2Z3R4ZHNL?=
 =?utf-8?B?bXh0dDRCNVh6UkJ2bk9RS25lQnJaRTB6RUUrWHhLakIxTjhMMDVqdS9selQv?=
 =?utf-8?B?U056bitMY0xpa3pjT01pNjdLSXhxdWQ4alQwMDYyVXlvV09UYXBiZHEzZml6?=
 =?utf-8?B?bXNqNXVWNHM3Wnk5VFJSWDNLTVVDQ2RybC9pTFJYS05SMFpqSkJOWnBYMDJu?=
 =?utf-8?B?SUplOE5UYVdJSE9pOTB4dlFBcEt5N2tvUm93R1V4K2dCSXpkTFppTmdxQzk5?=
 =?utf-8?B?MHJkMm1xeXl2WHBlZWh5aENHLytib2Zha000RUgzUERNM1R1S296TWZJamxQ?=
 =?utf-8?B?WG5aT0JBWHhSZmVnUHNkaGRGY01WcnhpV0NlMFRrajM0R1dVRDNHTlZlM2cz?=
 =?utf-8?B?VWtlMW8vQ2tRUFhhVm96RklYczRLdnhWeE9sWjBlZjF4ajVrbFl1MEpwN1dT?=
 =?utf-8?B?dVNQUFFoeHpienRuWG1xR1hmc0c1bmtpdDdMeWFkWU93ZVlRazc0aXVxUExG?=
 =?utf-8?B?QzBqT3Z6cnNta3VNazdKejVEZGxUSlBGVW4yY2VOdm9ETXZGcHF2RVNycFdw?=
 =?utf-8?B?cDBTN3MrZFEwdG1ObGRXb21MazJObDBaSUh1U2tNUldEa0U5WE5WMS84UlZE?=
 =?utf-8?B?WnRYV05uL21LOS9zc2lBSkp0eFpoRDZHYThCL3FDZXpLamFNNXpJSHNXUUFm?=
 =?utf-8?B?M0kzQnZHVS9UM0lsZlBWTC9nSmkyaEpWQUMrVm1YTzFKUVl3UjZ5OU1lYUJq?=
 =?utf-8?B?SUNrRzNLMGxzRkZZTTA0ZzdtQ2xvb1lqdzhidjFFMHdZeE5oSURLL0NuQWwx?=
 =?utf-8?B?anVuYUhQYjNEWkhBbVQxc0lOTERyeWtVQitoR0RoRGhwTjVaNitZdTRVNGVz?=
 =?utf-8?B?dEZmOFdVTytkbkpkbHBmR3pQeWJQNmRDdXNueG5JMTlBYXF0SjRyeTJpSzIz?=
 =?utf-8?B?cnd2OFJzRk1mUmZrZkJHQWZSMkM4eGl3dUxZV3dkNVpFREhWRnd4UC9SeHpw?=
 =?utf-8?B?aEZEaVRJS0txQzhFS0xUcC9xVmo3ZG1DUmdiQXlDWWNrYVo2cnJQOXRrdy9l?=
 =?utf-8?B?b0hXeUtJUWNVVUpEWjNaRkJJWjRITFI4dFlhbGpheGJPckJOaXFmQ2dvL01T?=
 =?utf-8?B?dlZLenV3cTlRN2RHeCtHc0lPejg1cVJqck9ucUdhRmUvMENJeHhxRTJiaWhW?=
 =?utf-8?B?ZjcvdVFraUdEdE5OdWxodWkwQkY4cHdpY2VoRGt4UUprZkFIMmdScWczMmUy?=
 =?utf-8?B?bE9mV1I2WFNTQkJDeFhEaTNOTjFoemZiMnNSWkJoNDJmUjVtUENETGtuLzNy?=
 =?utf-8?Q?nQXZ0P1loOoTDGawJJrBr+Gs8jfOokuhCx/dv3Q?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68f07e9d-78a8-4359-16b1-08d8fe3fc420
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 05:48:30.1628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: osOlbmupEEdeN8nSRZgxo6ahAeSV4DvVQlCo0zRcw3TQW+lRUiTzYJTLTU+GSZi9uyBLP4LoXobB1oBWlAQWdCSCap9HSE5g5vn5AR3h8Tg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4614
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130039
X-Proofpoint-ORIG-GUID: 1jf6oiVuKBya2lUEWIaT1ktDLKaf_-gT
X-Proofpoint-GUID: 1jf6oiVuKBya2lUEWIaT1ktDLKaf_-gT
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104130039
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 30 Mar 2021 16:21:37 +0530, Sreekanth Reddy wrote:

> While diag reset is in progress, there is short duration where all
> access to controller's PCI config space from the host needs to be
> blocked. This is due to a hardware limitation of IOC controllers.
> 
> With this patch, driver will block all access to controller's
> config space from userland applications by calling
> pci_cfg_access_lock() while diag reset is in progress and
> unlocking after controller comes back to ready state.

Applied to 5.13/scsi-queue, thanks!

[1/1] mpt3sas: Block PCI cfg access from userspace during reset
      https://git.kernel.org/mkp/scsi/c/3c8604691d2a

-- 
Martin K. Petersen	Oracle Linux Engineering
