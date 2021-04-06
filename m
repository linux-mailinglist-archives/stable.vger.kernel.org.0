Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD24354BD2
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 06:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242506AbhDFEwu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 00:52:50 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43858 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242465AbhDFEwt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 00:52:49 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1364o7aT161702;
        Tue, 6 Apr 2021 04:52:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Mv78ZTm3DOhf7+3h3TF4VJpdvaSWHSfVGUr1+aK3Jw0=;
 b=rL1bSL4l0G6eY1k5RP5Jnu6/VFn8sIhMLDvayUZRv+R1MpwIFQ4AwqcllaD4eiAqOLH5
 xHKSxfbBGA7lGSTPja3cxlJzv3O0bKOJFh1FYmTXLKmNFPGKAVuY6T93IjvcqSBxybLA
 5KwoPbThARuvs4EjFl+45F7lp5+pDlQ9cA7OWmrSFFM5y6QPXNEeLKyONftjL80JiC6x
 afyVP2Z6jQTz3tUbWGOEPKcLAZ3QaJ/APsKvvotM0zippdeBMJAorlnjxaAP4GjfvNzc
 HbhRaHuYIZ+GIrp+d8v0o7kqd6ZD1sgbNan9lges76GsHGkD5iuC231+1ICxqrozpDdE Ew== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 37q3bwm181-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Apr 2021 04:52:42 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1364pEWR029313;
        Tue, 6 Apr 2021 04:52:41 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by aserp3020.oracle.com with ESMTP id 37q2px1rky-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Apr 2021 04:52:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hxQb9kVPYTFBoXjPn8LV1z83vdcuHYBlDMkCNOWDe/Sm7RzRiu9L0HLX1cX+s0pPcENEx96soUJmAA4/+e4UzMJwpx3N2Eb2zdZFKUAXacKN2q4UvnBtrdFyhhI0ffxdUJc2luuXPiRR0ybyVK644tAr/VDkuRFVSzA+qfElJZVZW3d0ATaeRSofwMxTBSV8aUF/zVNzmp55k23ougc9fWPLi4ryt2aKKz2p580JSEGz6sdvpY1USN3XO+YG24XRFTwZ1GEpu/cq2AnBw1hSHkWFvKRbvUGqr7zAGe1fPr/nSvpwi8dRFAzx77GmxtStwrWWJsu3iPSjk0OMucKeQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mv78ZTm3DOhf7+3h3TF4VJpdvaSWHSfVGUr1+aK3Jw0=;
 b=Nzd3kSGFFGhY9N2rW7fM7IC4+Ax9woEH3YdF+p+rTYxbWyZhk9yPdmJPUapvGS04U2EgOt8BU5/n4cQ7ieyIVdDhtfySpzHZlzkGBpj3803vNDORtv+eb/TLTfKr/m+bVbolqNucl7jiK/iPM7c5XdvOiNnFpjnzmwtUuZMYrpBm/YkUqIO2VUr+NmMQnaT3lGn2QCwBxBR4ulDVij39MD7Bs0/OdVrnruLpIQAByc20COl7SEV61zVsOzwWiZ6S+jXddGJsCT0O9upxmxd9ThQg6Sk55Pbvi9VckVsKTCC5HQVVmmGVwL0mE1U8JUF0Snst17Trmw7/ME7TGSZR7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mv78ZTm3DOhf7+3h3TF4VJpdvaSWHSfVGUr1+aK3Jw0=;
 b=k1ibeCS49kpeED8fYecbwm7CZjNG2IkqMX5zhcIci9GGGdN+K8WsafanVgAZHxYdKnEN1rnYVKkAaYOhfYknIwv4BCc7CApHrSIfZ7bk3Qjj/zPd/XN/UJI3GMqnn/L2Aym9H2NnVsGX9fWWg8Lnf/HWKDeBdbhYhl71OPaTLTs=
Authentication-Results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4407.namprd10.prod.outlook.com (2603:10b6:510:31::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Tue, 6 Apr
 2021 04:52:40 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 04:52:40 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Roman Bolshakov <r.bolshakov@yadro.com>,
        target-devel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux@yadro.com, linux-scsi@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] target: iscsi: Fix zero tag inside a trace event
Date:   Tue,  6 Apr 2021 00:52:34 -0400
Message-Id: <161768453466.32039.13148048434409190605.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210403215415.95077-1-r.bolshakov@yadro.com>
References: <20210403215415.95077-1-r.bolshakov@yadro.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SJ0PR13CA0058.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR13CA0058.namprd13.prod.outlook.com (2603:10b6:a03:2c2::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.9 via Frontend Transport; Tue, 6 Apr 2021 04:52:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: de34c232-72e7-4299-d723-08d8f8b7ceb5
X-MS-TrafficTypeDiagnostic: PH0PR10MB4407:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB44076D96406F618FF2E9A2708E769@PH0PR10MB4407.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z/DPRyOv/hzbeB0z9N1EgB9czPDZq7DHaT1fbTBUpYC2j/YTImwTvyIg7Q83I9yqcJQU2inkUeSiiv17vTaFSLFmQeE2gav5c1S3ZpiLZrbQucOqBfrAK/2NCl1aNX63Pstku9AnhU7pWTn9DNL4mvhEJO2/emdDLYMiHz5/o8XVu39c6mcQG1mQXdpyegy3Ghs/aITScZlZJORIapCiK3F5G6kTCH32T2ueIe9fbFStyePxvn+AhilTqUFljot3LwwE0G+EFTLu90r7o1Srw0lQa91IWcnjQ37Po+oiosU/woepd/DBHMxbTgpsXsLskElvxVLKVhCD9pxnlwx+agnQa9Ww2xmgb495FGamwXX44QSDXnYKelCLiEF5MBOqPLeWeJMeRARYprlk6tn9JGL9yi8V0RYfNMVg1NrOg6AR9dCCEAq5f9hIlvsfi/FnTs169FDf07aumj3ANV+sd4FzA9qoJN6uOzQjyTuT8uYhlqLKs3AHtOJw+MjXH2wYPEe6SZUSnX2l5XNY67jkENaPG7x3gjpAxE9wCmEjsothHFX4u4KQLdRk1Qv6ENRqfgboLXRwpu3tf0yWuTPk782emYxrFRIgFV/KkmvCUrdEGD+aIFzLgcN60K5WfN1ApAk+Ys9qKMzyDvbdqtZ2vKJfCeSXBS5fJNQADae7pWGcPuIRf7SnFre5dqwETjg9+rxmD1ofkBc/WRIinGSWj1xAnKa0a7Cb5RU+xy61X545tDOqQvxcIIQL4OjDNHUmoJLvvnspQGIY0lXfJbO63w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(366004)(396003)(136003)(52116002)(8936002)(6486002)(7696005)(66946007)(66476007)(186003)(478600001)(86362001)(966005)(8676002)(4326008)(66556008)(956004)(2616005)(6666004)(26005)(16526019)(4744005)(36756003)(316002)(2906002)(38100700001)(103116003)(5660300002)(38350700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bW41WjNEOWQ5M2tLTjZCeVpqUHQ1bDM4c1dLSE1rNmFEc2NDbzFzNXBkUjNt?=
 =?utf-8?B?NkU0cERmOWFyY2thOUpCU2p6WEtNMko1Vzh5TTJjTFRyRlgvTnM3YkxVZmNC?=
 =?utf-8?B?d21mNkMxZUhWV0UxQ1IreXNSOFhTY1ZwbzZkZXgrZXZlYWQ1clljSWRvUXRF?=
 =?utf-8?B?Sjg1ZjNqN29LbUhMVDJnUWJTZExoTHdsOWg5blhGUWtHaHVXVCtpYjkzTmsr?=
 =?utf-8?B?YTIxV2xJbllUR1I2REZUVGM3Y0ppaGFJYW5KK0lZTGtpY0xXbDlxbTU0N0ow?=
 =?utf-8?B?WmttRzNFQ052MTRidi9VdHJLYTAyK2pjVlVIS3lMZ2RTZ2t2M2ozWHFEYUlY?=
 =?utf-8?B?ZytRZEhybzFvcEtPcTIzOXFjMGhyK1lNU2c5dEl0V0VkNk9rNElnZnEwTyth?=
 =?utf-8?B?RElGdEpxZUdHR1B6NTF2VTQ5V05BdXdwQkNYNktZYXdveUUrR04wbzYvMzkz?=
 =?utf-8?B?Zmo5LzM0OWF2bWJVZmJZb2VUODdQMmQ2U3labDJmT2dJa1kxb1NpcCtIdTBv?=
 =?utf-8?B?SndvemF0RHFodjFuRS93V2cxUFJhdVY1TjZwSFp5RE44enlpS2ptSmJnMUc5?=
 =?utf-8?B?WHFmVmtDa1c5MmlCQVMzRmtsRjFuYTZhaVoyT0MxQmdSVHFoNWZrRmg4WkVi?=
 =?utf-8?B?UmxBYUZWSFhVbjhvSmN2bktlbmNkRk1va2NhTmRvOWgrNElHRTV1YXU4MkM3?=
 =?utf-8?B?b0VaVnN1M3JiS2x5ejRrQldOcWc0YjMwOVkxR3cyczBzYlVBMExldXBrM0cw?=
 =?utf-8?B?K1IycUpGWGZuRVFlTllXcGZqRUIvR2QySGJVbTJjTWtIeDFyNXdFMGtoRG90?=
 =?utf-8?B?QXg3VmloWFVhKzVjRExDcUNWRnY4YkZENGpsTE81NXA2bklaZWpnaXMyclFk?=
 =?utf-8?B?Njk5NURIT3NHQWw4ZjRad050ZjNZcU12Ry9DZ3VWUG1YUnI5SFdldnYyNW1K?=
 =?utf-8?B?d1g2a25WNlN2cThWb0ljZDl4dG9pTmFtbGpPazN4ZUwrUWFxZkUzeHpLWXZp?=
 =?utf-8?B?Y1A5cTlnRm4zbkhJa3A1NTlGZzFPNW1SRnJKYmVaUGdPZUl5WFdPMjc2bzZs?=
 =?utf-8?B?VXh0Ni83akUvTTR6MXBiUXhoOEhkQk9jcGhOSVpML3BuUjJoaUlTc2dEVUJY?=
 =?utf-8?B?ejU1N1h1VGtvTXIxZC85T1lyTEFHN3pqdkFjdnNRKzArMC9icnlDWW9zcG9K?=
 =?utf-8?B?R2Q3dGZlOVJIYjdEaW9NdzlwN004Wlh1UDNDMk5USnkvWjZ4MXIyZHA3YjdS?=
 =?utf-8?B?R1BCTzJHOU92dWRuVkFIek4zK3MvNmI3V2pwZFV0a1RES08yUExtS0hwS1NK?=
 =?utf-8?B?eWtFNzdMY1AvSVlXQUN5ZFo5LzYrUzNLcVRQSVdmZUFhSlRyUVdxN3A5KzI2?=
 =?utf-8?B?N3Azdk0zYlRWU2c0TkF1RlZsb0tndm5jRFc3OTMxMW1pMFRFMGN5MDFSWWVr?=
 =?utf-8?B?bVNpRTBwWWRoM0J3dXBzdWFYRk1XWmxJd3lkcE1qSU0xaXh4TE5lbG1DczlS?=
 =?utf-8?B?ODI1R1F2K2hzTG13MXRhbS9aRGg5NGJFRlJza0VBbS9TcGIyVGxNclJ3NndI?=
 =?utf-8?B?NjBLOEx6VGp5eTZnTm1nVUNOdDUrc2Q5K3lYY3dIV1dWOXJyRHB2M2tLVXJX?=
 =?utf-8?B?bkFFVEVOOFI1SVhvbnYyK1VFajIzRUsrdElDeUppSHRNZDdzVld6eXdJYmtL?=
 =?utf-8?B?eVQrV0dQWmhpL1pUZ05TdXBBS05FbXM1VmVHbHRrZllMZk5hdHpOTElPbDVy?=
 =?utf-8?Q?7gQm+YaOVLPsXRhBl+nHFkyTCzRthsW613qlR6s?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de34c232-72e7-4299-d723-08d8f8b7ceb5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 04:52:40.5822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5kPsXSvyij5gjnKYYOTDlRRelybPsNGmZuW0WJcSvVaEhFb/19KKPrczTPelVvLeuuQUt71boJwqmS3Dd3goM81QZPmxSyL632LTP2joGcw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4407
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9945 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 adultscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104060030
X-Proofpoint-GUID: DXQy75CSpxi_DYu8GD8LcR3eKUuuGFCZ
X-Proofpoint-ORIG-GUID: DXQy75CSpxi_DYu8GD8LcR3eKUuuGFCZ
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9945 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0
 priorityscore=1501 clxscore=1011 impostorscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104060030
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 4 Apr 2021 00:54:15 +0300, Roman Bolshakov wrote:

> target_sequencer_start event is triggered inside target_cmd_init_cdb().
> se_cmd.tag is not initialized with ITT at the moment so the event always
> prints zero tag.

Applied to 5.12/scsi-fixes, thanks!

[1/1] target: iscsi: Fix zero tag inside a trace event
      https://git.kernel.org/mkp/scsi/c/0352c3d3959a

-- 
Martin K. Petersen	Oracle Linux Engineering
