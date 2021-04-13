Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67BCA35D783
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 07:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344704AbhDMFtb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 01:49:31 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45588 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344697AbhDMFsy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Apr 2021 01:48:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D5k007146774;
        Tue, 13 Apr 2021 05:48:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=C0yhGACtRtRZ3KGiAlhj+PMQwc1NMM3DdfUOLViJSaI=;
 b=Th5GP22Niuak5fwyg+Svp6SphRKsWnmOccNFJ4i0MplCzQt3yBOJeTpull/arWNGc5Oc
 qiAtkNXTzas2BleDtYG3wYLY8KA5VDwp23mNnnRmnV1swZBFjRxL475slNkkLp5GoFF2
 YFR3KONqQY9s5iSdjcDifiWND2tVKiNOhmpe074kWNxtw4UYrjuRDZf2UsLBaoivazGN
 rC1wUtjw97vx16JKxmLmE9jCO1u6LaJwLnlULj9W4iKSY5ZU8s84KO6HCcKDRlS6vkTu
 MfLzE8gyyxTwvt7hvuthB3xMpLIZfsEvjhG4eq0Vz6riCnJ6Jx1M+ENtRMgBrlrtP8UT qg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 37u4nndswr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 05:48:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D5kRNA137234;
        Tue, 13 Apr 2021 05:48:33 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by aserp3030.oracle.com with ESMTP id 37unkp3mdn-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 05:48:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iVKaSxj1dgO6NmlRk99fXGyhLgGB7ozf/eNmGyPZSWckxBRjvkKqAsVXE55Ds3ospz+Lz/VUdAt9icSc61gwm/25REj/qcFJl8Rf5/OnJfv4Xop5jMx7HANa7JyzjlL2KW3Ld8iP2jl16srvAeg4z7a+smzrTb3HW0rfVSk7m5ubFc8TLrWcI2XVCIPc0HZ+hDCB8CkuWyVb1lElcYQUBbC/EHDjhflo2+m8BUcPVzBvsPDQnPa5aJjEY+jBl/QcmiNVxkWWinhVi3SUvyzM8FtpvZ2zQxyGAoHfGkWueihboT5St1NT/+YIJ42Vuw7IEmQTZTApXrY/i2ic+O01wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C0yhGACtRtRZ3KGiAlhj+PMQwc1NMM3DdfUOLViJSaI=;
 b=GN8SYvBz6NOBtk2lgw7Vwyd7lnWOI7ldZx0jkOaZ1DaCn0Q+9NpfCJ8ITjoAa5W1W48byd3EuGRcuYhY7duKuo5CMwk4CAlyYhQ8FagKz+kMBteurKCfQ/6XJdNhki4mVGZ5cn6QyBuLrjxtwfI34tUEKNmp3GF1B1+gYKs0jhiFAm36fwHpwX7u+70LBmY9mbLtC1rXCwWmp2fGkdwZcnRd/T4y7H6VuKD87P8Jp6d69KgvXY8U7KHuv6pNIsYeimJLGXZRnThZfMqownAfgTZxk20ZZ1J7k3dR6ZtnoJtx7Ptf7c/I84e2aFJQQzG79uv93iQht0aNufLsqdoIeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C0yhGACtRtRZ3KGiAlhj+PMQwc1NMM3DdfUOLViJSaI=;
 b=GY4QIaGZfy/R3Nim5tmCrvhgV5TCjWLCugSkDsB9RCHCAFbIlgF1U2nKvGEwWD7RQL7vJfRMfgdB8UlhEqCxIqAWJcRyFjnZVPKp4hl47CZh4tGxrKwqfStZUyJwPOVGaevHy2mNDDbaj7NoGS/7paTfAtCINs+P7e6h0QfFCfs=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4614.namprd10.prod.outlook.com (2603:10b6:510:42::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Tue, 13 Apr
 2021 05:48:32 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 05:48:32 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        suganath-prabu.subramani@broadcom.com, linux-scsi@vger.kernel.org,
        stable@vger.kernel.org, sathya.prakash@broadcom.com
Subject: Re: [PATCH] mpt3sas: only one vSES is handy even IOC has multi vSES
Date:   Tue, 13 Apr 2021 01:48:17 -0400
Message-Id: <161828336217.27813.16277582509807263066.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330105004.20413-1-sreekanth.reddy@broadcom.com>
References: <20210330105004.20413-1-sreekanth.reddy@broadcom.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: BY5PR03CA0008.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::18) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by BY5PR03CA0008.namprd03.prod.outlook.com (2603:10b6:a03:1e0::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Tue, 13 Apr 2021 05:48:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f0ea90c4-0d9d-49d6-7d36-08d8fe3fc578
X-MS-TrafficTypeDiagnostic: PH0PR10MB4614:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4614B00CCF7D79287FC088FE8E4F9@PH0PR10MB4614.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S8h1nzncykJXHKAKSGMhJdgdvZTm1QM1p9TAUcAGwDJXAyrrG9PS82MX8dlmgkx1wHJ+nV+OD1Ec2ioN+1XQtbY1aO4wiD8vNHhXfkgDJYYZm30M5NHGrW52jyYXnCOFQbnOYDcPcmFEOhaJB0HZLDRcnZjq4X87WySYncWlIFh1YZhKvd01CMRuMIkg5dnqZ5QbPV8tgpSalNwHG9WKoMW+gFFky19UFOjCJisGbd0otdqX99N6Ltop8kTp2opejn+FJwtP3TyUdl2Jio03c4sJiZf80xGng1CoRKdWrRNicAc+w+ajLm8hPTolAR52nvAHpVqVbsegrr5h6+lWz7xxvWGW1plQbXQmv3YBm/6bs4vPndKawjZ+/gRA8+L1ssC/hBM+9zEZz3joW7k9BIHkZKl+FGco3RiQUbhNfuWGwSNM8LeQC/8FHczYjoVS4vl8vx2Ru0EPU5HljtcRoNiUEzt9eEOVRTkiNt1DdjhtWKNpKO6mOoQE/POqLE0NVmWg+ic+eezUkY+mWGevRvbA7YQ0C/eMxw3qHNa/XMBmlYBaCDkFsg92l7oX8zXyf2QO+8UJgF31GnWLHZwSWowOENiTB84f1AwngBC5VnRE62wVIeXQ1eoqYGlJtdqXPe3588DpOWN8wrrxWXDFX1SsyGLTKoAzDvPOdlOZcNa4p4PzNEKp2CgoO36HuliVu+eZr8r0G97AL0dGttC17G4QiCnzjyXmKfd/HE74KMsMne41wlZ5Wn2Bm38koOjp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(136003)(346002)(396003)(39860400002)(966005)(2906002)(6916009)(4744005)(6486002)(4326008)(316002)(478600001)(66946007)(8936002)(38350700002)(66476007)(16526019)(38100700002)(186003)(5660300002)(6666004)(66556008)(26005)(7696005)(956004)(36756003)(86362001)(52116002)(2616005)(103116003)(8676002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Sm1ob2w0aXdLMFVhRDVxNlVoZDRyTjVBaFE4UVlBVjZzTjJpbVBOd0I2a1RX?=
 =?utf-8?B?RHIxWUd6c1pjN1QxRE8rTnNtSWZqMlJlZlg5bHJqdE9NWi92ZDZIbWtWOUFm?=
 =?utf-8?B?a09pbW9DY3Z3bFhFNHo1UFcrcFc1YVFQcWU5Y3ExTzEwYWNGdnFUaEh6Vnpu?=
 =?utf-8?B?aDR2WkpvaEtJYXFjb0hjUXFMenZjQ054THBOQTdJY1dwWkd4NGlCNTZyOEts?=
 =?utf-8?B?N2NOclpwMVJzRVVCWnM4L20yWDdnSkgrWEIrZER6TURIZ0JSUXdrNEJaT3ht?=
 =?utf-8?B?S0xNZG1IU3BVajJwZlJ1VHZ3eEpuTFk4MGNLQWZaa2lBNTIzRzA5T25IQ3FK?=
 =?utf-8?B?QjV2WHdaaWRlek5qYVFISVh2NHZGSDVUN3V2dEJaaUxVVjNUczNjd1BaQjJP?=
 =?utf-8?B?UGtFdEczTnNaMlA3MDlENy9QdnFHNjF2clE0a3pRV0J6WklNMWhJUTIrc2NK?=
 =?utf-8?B?bDRBaG03MkRqNkhwcVRwZG9pYnpWcm5vUzZMNU9FbFcvVEszQlBldG5JY3ZT?=
 =?utf-8?B?ZDQ5M2dPdVkwanBva0pSMHB3a3AwZ0tQYXh6aEs4c3JSVkV5Tm5SVGRxWkkr?=
 =?utf-8?B?enBUMDFXbG5kbmxmRnV6SUt3eVhhalFUU0FESXpUS2NlOHltNDdsMEJWN3dH?=
 =?utf-8?B?NUZpSVJ3NXA5SnIxSnJ1NHBDQ0kyNE1sNFB3MzZmdWU2TUZaaXIxaWNyc3Jj?=
 =?utf-8?B?U1ZmY3dIMFhOV1hoUFRpRGhqb0hVdm9RalpoTThyVFdyRHNOazJQR2xCY0xx?=
 =?utf-8?B?ZHo3N3FkZ0JlT1RnQkxTOEc4ZTlhYkNUZWlhN1FrQ3FnTU5jUklaUzlqZzFz?=
 =?utf-8?B?dXpnaGU0UGxHYzNCL2cxaDJFNG0yeFdBZ0FBYVpnallmci9pVUhmcHJ1NW9i?=
 =?utf-8?B?UDJEUnpya0VOYWNsSm9DNEQybkw5eGNVU0dLT1BicFJzVXpwcjR6bmYySS82?=
 =?utf-8?B?bDJteURKa0ZtVk1XbGlEckxydGRlak9yTmk3M1R4bXlBUGlzYTErSEhIOXFH?=
 =?utf-8?B?QVZyWEdCUkd4L3BZOUdzZnJyd0N5TWFtbnYvSk5tUDBvSFJMT1NqQjlQZ2Fa?=
 =?utf-8?B?SkR1Qk1FNCt4akdhWmk3MmN0OVQ5eDNwaUhFZWR1Y2xJcTEwd3NSWWtINmph?=
 =?utf-8?B?V3RoYlVwOUJnM283OFA1U2dPOEk0YzdBOGRLRUk4Z09jNit0YWZGUG5lZkxu?=
 =?utf-8?B?OEI3QkE5cWhvaUVTTURDRjU1Um96dmRpZkF0cE1EZ29SM3VUNnk1alJoS0Jk?=
 =?utf-8?B?cmdqRjd5c3RNUWhFY2Ryeng1dzJRbjZXNzZReEg4bEVsbFNxVlIyNDdoNjJH?=
 =?utf-8?B?bGp6cGpaOEozS2VZd1VGb1VXNkF6N1dkYVIwd1ExUnphemVHYVVLQXRlOEFB?=
 =?utf-8?B?SFZwc09sQnEzK3RmUWVteHIvcCtVTElkdm1pM2FnaXdIc0dIYWNsOW9ZWjJl?=
 =?utf-8?B?ZzBsT1JUZ0x0V0JCSVRuOWthOFBFVTlQbUpWb1ladGxuNHZBWGl6L2lNYzh2?=
 =?utf-8?B?blpPcjZwWTNtVi9ndmNDU3JaVHd5aW1BMDVoQ20zRG9SVnc4M1U0SXFUbEVh?=
 =?utf-8?B?emo1TTVpQUdXR3ZDY00yTGVreFdWbkM3R1BvTEFCV0xjemJYZ3piNE92UCtI?=
 =?utf-8?B?aGFsYm1kV05wOGN1eUx3ZmQ2TmVKWm5oeGZCdElsckxNK0dZYnlDL2ZhbGF5?=
 =?utf-8?B?N3ViRDhnTnBidWdDUUxiayt0UHd1Vnh1S2N2WkV1d2V1RFJGY0tvOFJycXY3?=
 =?utf-8?Q?Uy1dFFGH4G3oNx0LK7zfby+7GmH8Zgh90bw5G89?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0ea90c4-0d9d-49d6-7d36-08d8fe3fc578
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 05:48:32.4100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: StlfbldLWnhoUPnTLdOKtJskJwEmApBsPmqAAWE9b7DAfsJOTgD8n17+WQcHD1q3OYAP3j3KbaSV9755NY7fDzzFxdhmR5Xupg5vzHBqzv0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4614
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130039
X-Proofpoint-ORIG-GUID: jJoxXvjJoPga4gQ3PZpFNA5le5jLZNB8
X-Proofpoint-GUID: jJoxXvjJoPga4gQ3PZpFNA5le5jLZNB8
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130039
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 30 Mar 2021 16:20:04 +0530, Sreekanth Reddy wrote:

> Whenever the driver is adding the vSES to virtual-phys list then
> the driver is reinitializing this list every time. Hence those
> vSES devices which were added earlier to this same list are lost.
> So, Even though multiple vSES devices are configured in IOC;
> but while scanning the vSES devices driver finds only one vSES device
> in the list and hence adds only that device to SML.
> So, don't reinitialize this list every time a new vSES device is
> added to it.

Applied to 5.13/scsi-queue, thanks!

[1/1] mpt3sas: only one vSES is handy even IOC has multi vSES
      https://git.kernel.org/mkp/scsi/c/4c51f9569651

-- 
Martin K. Petersen	Oracle Linux Engineering
