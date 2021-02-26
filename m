Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6C6F325B9F
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 03:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbhBZCXu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 21:23:50 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:53180 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbhBZCX0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 21:23:26 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11Q2K474151347;
        Fri, 26 Feb 2021 02:22:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Vo5QWPvoCiCWv6cyFS3+JIXlyyBpuBZygn6s+ogxOUQ=;
 b=Mvw3XOQqpNe/XKNNaO+KmzVUoYjsmjpHqnieI0QrrUryxWnjyfR0SeaE1JQkhdnKPC//
 U7ubJw3Rfew+AbgGBPI+nXWhXsqAeZCYBPaiVUhgV+I4qBix7Gn5AlNa6+b93rFXi0Ip
 ceGu3rM1yYQ/oMxTbT0+Mp1iIMjdCqSWjL/lfSTAOomPhYAEcb92L2wEgyNaD0RYsMI8
 HtMdHYgbWopJD1hG6DVfGy/p3IHtMBXveIA3t8Agyxm3uBVSkuqx2jMliLm1JdWF0FhR
 FUSVZAD1Qol1yWuyFqCaLuu4VSActb53TLZ3waY2DdBThZ8AIMY1Zz7hmO5hgWYWbGAP yg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 36xqkf81gw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Feb 2021 02:22:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11Q2Ke4S106931;
        Fri, 26 Feb 2021 02:22:22 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2052.outbound.protection.outlook.com [104.47.36.52])
        by userp3030.oracle.com with ESMTP id 36ucc21p6j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Feb 2021 02:22:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RPvOSwsgukxm4V/SIVR4unkYpXFNv5DxZsZC32DFtJPj1Jz2I1/RjJkDT0pMgLTB6NglTAhaedHPmQPZQQJ2MN4GUsWCj7WhQdORy3hKlQP68N8iX4ldHml/oLDxcMQfa05bdtVS6Oz4GJ7lX6jfzH8S84QMTQrjGSUhE9TiZhBiUBwDB8YO3WnksNwauHrTvTu6HDYmxt1afYNNvGehrGw/sGixT8POGWSwsejscdpo/BEn5yomVmGUpuP3ttwRWUOb13MswKwmJJwZINiprRiaYEsIPck+JL/ifB/+EdQfVWgPuYxUFwmpkZLEFapo91Ou7B67wz6r6P5cCw9Sug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vo5QWPvoCiCWv6cyFS3+JIXlyyBpuBZygn6s+ogxOUQ=;
 b=PeTApbrCUTcKTxXpS529OwdKn11jTULSB1PcTT60ul3Tq/0PXzDQ3oHmu0JhB0+lUdJXjcIWWpWmG2GqWU2yOUFXpSczMMoj42BjobDPD+aoC6YIXL3MwUELG4X9XWL7UpozSzl+IXICuBmVlyfs03lZ971T8xwvYcfcV17QuJyI0t1b2lNgUJ1l1Ou9Gm68c7HlOUNTb7H7mkbvGoWVU2Xqj2eKJDce8TY2sjf2JDxmNTnOaLW/FtzDGOpP4Q8iA/I9vhMm+izwX07E2rBFEJJxs5crPNNpumB5TJGzYKaMg/2SILUmUoumV3DG4qodA/+wgqRMj+bexvrLG5WaEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vo5QWPvoCiCWv6cyFS3+JIXlyyBpuBZygn6s+ogxOUQ=;
 b=I4arrg4hWADRw7SleyYFXfObFhgXgqOIN1L6XiW8mga7AgexHRXyv11s6sUSvQEFMM0h6chii5NzB4hKRrTUaSxVUlw2FXGHD2Dh43vBYsz/8a0X9m0Rt7D1cWf93HboLLsfCnTXoxZh3IhjXxEk536xSANbWeIhTODcXOiZnqo=
Authentication-Results: linux.vnet.ibm.com; dkim=none (message not signed)
 header.d=none;linux.vnet.ibm.com; dmarc=none action=none
 header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4696.namprd10.prod.outlook.com (2603:10b6:510:3d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Fri, 26 Feb
 2021 02:22:21 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3890.020; Fri, 26 Feb 2021
 02:22:21 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, chriscjsus@yahoo.com,
        Alan Stern <stern@rowland.harvard.edu>, stable@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] scsi/sd: Fix Opal support
Date:   Thu, 25 Feb 2021 21:22:07 -0500
Message-Id: <161430583252.29974.16247555471733411498.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210222021042.3534-1-bvanassche@acm.org>
References: <20210222021042.3534-1-bvanassche@acm.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: SN7PR04CA0031.namprd04.prod.outlook.com
 (2603:10b6:806:120::6) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by SN7PR04CA0031.namprd04.prod.outlook.com (2603:10b6:806:120::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Fri, 26 Feb 2021 02:22:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c02790b-feba-41b7-7782-08d8d9fd5890
X-MS-TrafficTypeDiagnostic: PH0PR10MB4696:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB469684FCFBAFA3A298278B518E9D9@PH0PR10MB4696.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XJeHxB4H4kND6G+LWKv5YO1upz2GTQjtW/ClMQ36uAOBViOzkCsu30gc4DdvZYy75qVRUjv81YXAvORYw3XdiXs9ikKFtTSRgwfdmsRXNDVTbElgOK+oxij4tcsLJcQAYcplBT90o6BpffMSJCGGeOo+UyMZruRKbga9dtFKWDXmn+AFY6JcRFlb+6WRG/RCgW495Qknn+pe/e+lLhA5OiuAzCpyjx4M5jNguH5i75DefUL1hLPwIbb+oh4x0eoWXXFr/jD9L62EhsBV7SyIyEfjCA81t4I5f+cEA2kugloIRc3yXDFs1ZJ/Yh2HUZUafg/3oZp1/CCiDN5FPATFGbX9/uJLpTaC2huu4yiUXBHKEUPHTSqypC2s3v5vQ9A2AggZrhgWPffuwTh8FyHRHuYCdIkRqVdQ5h8WhVTXpsDe5fwkbKbuJogehLcfdYAYNkF9KrF18/8ZiktEoTXFet6vCpbNXZnQMBtPZncDsUcg3e9JnayBOd4KQxWrwbvLefHqHAisI23FKbdGQ8SE5OtAG3YVxcL1M59lrvkTtLr/93brDj7c/55X1ozyfrtI4ZV89IVZPgV1gMceZ2ImVSEq11ipCA8iyvK2CQV3AbI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(366004)(346002)(136003)(376002)(36756003)(4744005)(8676002)(2906002)(7696005)(52116002)(2616005)(956004)(966005)(103116003)(8936002)(478600001)(26005)(316002)(6666004)(5660300002)(66556008)(66476007)(66946007)(54906003)(110136005)(4326008)(86362001)(186003)(16526019)(83380400001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Yml5TndSQzBIR3RoTnNlb0VzbDVHRDgxMnUvWVhteFVmVVJDN3dQQlpVWVpY?=
 =?utf-8?B?S0VZNmUwYnlCYTViRllrYW9XMmFwTzZ2aHB0cmJNR1hjODl0YUNMdXhJNFVy?=
 =?utf-8?B?ZHVHS3BVTzBITUFZVEdjSExWdzFXZzU4cXUyOTU1RTQvMnFrK0ZxOHUyVUpz?=
 =?utf-8?B?WWt2WjQxR0hkRDZSaEJoVnA4bE1rOUNuYXZKWXZqOXo5NEVwWExGUS9yc0d5?=
 =?utf-8?B?TzNzTWpuYnI5Vk1wT1NiZVNOMlpwZGtPT1NYS0JuQVdVaUpQVXp1RlJlUGM2?=
 =?utf-8?B?VFdHTzZma3p3T29LYXFHRTRXWktCR2lPcFIrL0VYckxmdHcwV3laN0xwOCti?=
 =?utf-8?B?U251clFyeU5qTFNjQ04yU0c5Y25YeDVQSUNZdUk5OUlVanducjVKUjV3YnJo?=
 =?utf-8?B?blVjL1JTK29HVHc0eEwxUUpXYnJnY2s3Ylo3cWdSM25UT3ZDZ0djQmNjbkM3?=
 =?utf-8?B?bERuS0JiK25VVEJocjhobU94NGxjSFZQdzdMZE5kc01FV0VNVzFCcHp6aWJl?=
 =?utf-8?B?Q2l5ZFhDYXZ3RHRCZzFoU3JOazFhQ3A4bkVndkFtY2ppTzNxVXlpNFVRRDVH?=
 =?utf-8?B?dDdPWEtIcWE1NGE3KzRnOFRIMndla0pBREZjQmcwR05NV0hGa1lrbytJaHQw?=
 =?utf-8?B?T1o4eU9EaVJrU3NWaTl4SElNczBjWmNVVk51akl3U09Rdy9EbGVTcGphOTdX?=
 =?utf-8?B?UGhid1ZhRnRjR3lCR2Z4bHhEcS9jV3JnVGlXancwYjZPSVRmaDE4SkJ2aGtE?=
 =?utf-8?B?QUpTUXB5c1B5Vm9UN0doVlljRlFablVGelk0alVLUlV3K1o5QVdlakNobUV6?=
 =?utf-8?B?NUU0bzMvQklCMDhma3UvdnZTbllmNG54N1c0VzBzNjdXZVZVTzBZa0Q4d0lE?=
 =?utf-8?B?Nm8vb2hETS81cnJ3ZEpYYzhxQnRNSjJMaWtBcEMxbUg2Rlg2bjhhcmtGcXVh?=
 =?utf-8?B?T29BaWdVNm5IT2lJc1pRaWllNjlGbnpkd3IyeWZsa2EwUGNITTA0b2YyOU1N?=
 =?utf-8?B?SjdUbzV5Y2xXek5lQnZaR1VjMnQ3TnZmZnFpODMxSWMwM1lyMmN4dnlzYTgz?=
 =?utf-8?B?VklHUFdkVVpLYnZpNmtoSFN0cVhESE5LQ2RCSldyM3JldjNNMmU0cnlSZWZy?=
 =?utf-8?B?enFFYSs1S1Y3ZndRb3hQNE41UlVqNDJIMXdIRTVvK2toOHFmc3JYc0VldnAy?=
 =?utf-8?B?M3pXaVJ4T29WNmlsQTVpcWM0dGtiMTByNjV0YzZCZGJvenRzTEhFenVydFEr?=
 =?utf-8?B?QnVqcHljenFMV3cvZEpHVlgra0t5QjFmWXJkb0FicWdtZ1V3ekd4NkNDSllx?=
 =?utf-8?B?c1Q5Y2c4RGNZbFlQZzFYR2l1eTlXcnJUN3lnaWZxYTFQeHBCTFFENnhKZlVP?=
 =?utf-8?B?Mzk5Ukl2RVF0eDgzcGloVXMzOGkrMWhRQkNTcGxmYjY2VHlLVWxFZ0ZMSzRp?=
 =?utf-8?B?THBWNmgvOGw1b3NMd3NqS21JVDY2RjZ0MlJGeGFycUw5czVYb29tYWVDc0dG?=
 =?utf-8?B?dmNneGlubkoxN0NwMW1FdU11MDJyQkszVVJ1bmxNY05ud2lpak5YdEhZdEJG?=
 =?utf-8?B?ZzZ5SmtKYU1URVZzeXVFTDRuVGJyTmYyWmQ4dW5aeE10bGovY2kxcUhadCtu?=
 =?utf-8?B?T0E3ZVZFalprc1dManBrbzNLZ0hzV042dHQ5K1kzOWoxMExVK0Rra29ENldm?=
 =?utf-8?B?Y2dlNkZXTnltWFRKRVdtamZwb04ycHk3SHY1U3EzNC9JU2lmUE9qUkJTYlYv?=
 =?utf-8?Q?gweuo/7T/pU3hoQUsb0M6eTotqHHLEHUhCUsF31?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c02790b-feba-41b7-7782-08d8d9fd5890
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2021 02:22:21.1011
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2k6FPvUwRarnZR5juX9LdEqWmnEG/4IoEW6x9Fg+digd5eJx6h0fD13iT2MwEti6tG4Xe0q6bbc4on2ppL7OdjMV8dFlxuV5L3lApMNfbz0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4696
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9906 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102260017
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9906 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 clxscore=1015
 malwarescore=0 suspectscore=0 impostorscore=0 phishscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 priorityscore=1501 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102260017
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 21 Feb 2021 18:10:42 -0800, Bart Van Assche wrote:

> The SCSI core has been modified recently such that it only processes PM
> requests if rpm_status != RPM_ACTIVE. Since some Opal requests are
> submitted while rpm_status != RPM_ACTIVE, set flag RQF_PM for Opal
> requests.
> 
> See also https://bugzilla.kernel.org/show_bug.cgi?id=211227.

Applied to 5.12/scsi-queue, thanks!

[1/1] scsi/sd: Fix Opal support
      https://git.kernel.org/mkp/scsi/c/aaf15f8c6de9

-- 
Martin K. Petersen	Oracle Linux Engineering
