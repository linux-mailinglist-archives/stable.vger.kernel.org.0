Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84AC06D6E20
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 22:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235260AbjDDUd7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 16:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234428AbjDDUd6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 16:33:58 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E21819BC;
        Tue,  4 Apr 2023 13:33:57 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 334JtrlA028335;
        Tue, 4 Apr 2023 20:33:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=yFDLx1h3md+700A76Md/ikn+zegtEtByPl5boj/OPqA=;
 b=cAK7V3eTCFU05cOPP5XJo3UfA0kCNIj3Cazfw+Ut26E6aDWKH4NsIaYuMI2wNXJ46aIU
 7rrBxDVyBQuaj6C8OSb+xSMm6SJoxqe5xWQuLFT/X5iIUhkN2MkJoJtqHIwJ4Cc3Acg2
 ApWm515vh24IMcPbugVrnweGTvP/y7dwB8Wlg0+EcE+aMKoOU1GdnEMXjtA8WD8MLCQY
 WDQPqpj6NySsDlzzuWOnZt4LbdXM7KWw+X3fxMgCMUx6XqYU+wArhxlZrPjz+8QYRQvH
 iFZJFjUKifoAj9q4ss/Rt3Y81nNYILEZwfJBYJmfND8aBmOHf4jzJLx80ppI1t/ZCYTW 9Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ppd5uew1p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Apr 2023 20:33:20 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 334KGsxA020026;
        Tue, 4 Apr 2023 20:33:19 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pptp7p4h5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Apr 2023 20:33:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ez7D3O3ZN4FABOsGO0sMqTS2UEXzMWCHdMMSue83PiFKScDSaUZsx+RlEe0mw3ggbiLSdoxX3aJFto9pCV2Tag06Bhc6UCsKgUOIxJ+UT8FU2ccYOmyD1PYtXbdmJ5m7efpemv4zMujs/7rrS7UD/xUCOiRhonQ2NcC9lRDGUomIppwq+X1PBFm4APDG9vUUCnPZ2qJtc46UTCjXLTO5E7Vn6D/LfrIdfMz/fvzOE5QlYDaImTkvL++Hd2r15MGHXudG0f8NFQ8IUaRscVPEBTEf2R593pkhJ/CbA4GPYzl74P2C7H71sGxAG8KZNci4cfCy4BnugRyi1CvwIqV5KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yFDLx1h3md+700A76Md/ikn+zegtEtByPl5boj/OPqA=;
 b=CnCfy7MMAiNyWxHyBUFVdCd6VUk24XkSL1rhgBXqC/pGtaT62NLrZhY51tYI+uUqsYjChwvGEieWOTuxxU/uesDE0hlEqQIPWIo1ynVs0qQsKt1iy5ZVqG6kMffOidd35eq2kE6rGx6ckaIgRzW5dDRwGJcMSKTRQW8rexSkH6e6x8l/Twe1eSoAbT5TiS80ILXlG8zPEqCt1lX26KtrGOGckaaG4qcxAiiHWZf64RukaV+7uhQNoNNogKOphwIi6jXCxypQjc58GDkaFgwhy59LM+SFvyoEG1FHAtMqK7AH8Ek6IhMJv3Gj+pAJYoDncUV2s7IPOTtSs7KA0oR8PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yFDLx1h3md+700A76Md/ikn+zegtEtByPl5boj/OPqA=;
 b=QRgeNC5bPRKzcD1j+3u/dvZ6jQcE+OudRIzgMl5iOr/B6cGasxkh9aiGnwekifNYD7Rx3SvaBO3AjON1hABFfExEx8NK5+hN4/dVvyetqOlTST5LPiUplkKbspVPEMruQEwr5P8Mu5XW+Hp1gCSeOWxErgb9T2Eh9ArEGz/jLTs=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by CH2PR10MB4327.namprd10.prod.outlook.com (2603:10b6:610:7b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Tue, 4 Apr
 2023 20:33:16 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f%3]) with mapi id 15.20.6254.035; Tue, 4 Apr 2023
 20:33:16 +0000
Date:   Tue, 4 Apr 2023 14:33:12 -0600
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 000/104] 5.4.240-rc1 review
Message-ID: <20230404203312.2ofkv4jxyvgscxpk@oracle.com>
References: <20230403140403.549815164@linuxfoundation.org>
Content-Type: multipart/mixed; boundary="m2d4nofhitb3aief"
Content-Disposition: inline
In-Reply-To: <20230403140403.549815164@linuxfoundation.org>
X-ClientProxiedBy: SJ0PR13CA0081.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::26) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|CH2PR10MB4327:EE_
X-MS-Office365-Filtering-Correlation-Id: f19d6fe7-e483-4d2c-66eb-08db354bd1c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PSboBOIYaU16wRGsCG56UxcYZ9kOS+p1XUUYekDd69v3svDmRO9nR/Bk86rQZmNthgHGRwMLcybBpxxEZLbV5TqVvLYJrV/o7WqAcYfrzeQ4S69YPuN1ah3YRDHe24ic85ayTD0uXEIodfma3JbAC7V2lTmmVrmF0CqOOSKPGr3RGAEgFsbNY0Qua2fe3g4qAoO1b1y/USmb1a305J7CIcrYwKYu8p3d12eqhHFoXG58NuhDMFsMYV6ItyDp6/TulEPOdyH/G4We+hRYAaY5Hpi2dWJon7NLVtCz0znDNouMVEYi6x2nGy9bbnkG4xxbfYQinIUxgDuRVnzHTz8uRBuTyrmR3HiwcY9/WCf/qrKDIi8WiVmPQBlmhwyjFqSO7s8PVDC4e7tsV9vhXSKyVUr3ycnMdmmGmcW6RAH513W4fCeMAYWbFzd5t3fGsNlPTpGAcX8G+g28/oKUFBlysx1r4celPRi2XG9sgs8ryg1RWI+AEY673h9T1V7UYx5ACvYEUPBzymfJ9dDIgeUIZsbWEidaxhhz5eiO993W4Mg5YltCsr7lIxOqfr1XBm3g9+X7QWwS/ufkKfG8Ca4Tv4Rdb/ZkaZiI6KUpne6Oxnk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(136003)(376002)(346002)(396003)(451199021)(7416002)(186003)(235185007)(21490400003)(33964004)(44144004)(6512007)(6506007)(26005)(44832011)(1076003)(6666004)(478600001)(36756003)(38100700002)(66476007)(86362001)(66946007)(66556008)(316002)(6916009)(4326008)(8676002)(83380400001)(2906002)(41300700001)(5660300002)(6486002)(966005)(2616005)(8936002)(2700100001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZGpLU2VYcVRiTmV1dy9RZHdScFZpNDAxYk9rZlg2TzRhekw3L01ZSFF0K2JQ?=
 =?utf-8?B?dmRjdWk0ei9COEk4TGlsZDFiOS9mdW15eUVMMFBwNE5KQUlwM2Q2ZGora1RP?=
 =?utf-8?B?dzVGWE1EVlZQL093dmNqNkdoL25YdytJK25TZHVmM3dyd0RhVUhSdzVQdysr?=
 =?utf-8?B?dy9vWEJVTzFoU0dHWmtXUUc5WHR6aHVLVThTdGZwV2NGUGxDNFhCaXBVSjJW?=
 =?utf-8?B?NkdjSnkrME8ya1hoUk9BaFVVcklhSlNWNlM4Y00vYy9kd3ZHNXg3djFsOFNJ?=
 =?utf-8?B?blJicDJVbFZJRWFaMm1lTnpwYUZNR2dBKzVWRFQ5NzlnSXAreTI3eEFJL3dL?=
 =?utf-8?B?WHVVZnE5M3MySzFKNkVyNEQwVFp6KzAvRHozUE1teFlJVm13dDZwajkyT3lR?=
 =?utf-8?B?ZnRoS0xaaUEvQmtvaVcvVzhycWpFZHY0T1hvclVHZDNOblpTR0RwZFo4Q0pO?=
 =?utf-8?B?NmxHQytzS09RUDdwZ1FhWjNiV2NBd0VTaDdwbEcvOXVlWTRzUG1sV3Z0dHJh?=
 =?utf-8?B?VjE4NGRneHdRR0p4NjdJblltN2pKK2dVMkk0QWxKZWUyMkxPUFh1VVNXVkhz?=
 =?utf-8?B?NHpyR1RTemhaT0U2Y2pJdlRTN0xPQ0RZUEZMSmF2d1Q2elJOU05ya2Z2cG1R?=
 =?utf-8?B?RXJTZHBWRHBVUVRRK2lDTTlNR3ZiNFVuSEVJbmdjWkRkNnBSNFlrcUp5emts?=
 =?utf-8?B?T1c0Z1JUcGo4OVRIYlpQYzhnanVGVWZYVXpIL0Q2WktZSmRsSUVWUGFSeTNa?=
 =?utf-8?B?NTVjT2VtNUVRMWdwY0ZjU0RHOUZURzVPa3p0RVMwL0x5MDRUbUQwOTN1TmFx?=
 =?utf-8?B?VnRMenk2dlp0QzVvMFFjWVVvQlhGM3YyWklEemYrVkxvYmNOeUQ1RUM3WW9F?=
 =?utf-8?B?SUZINFdLekdieWRZbk9ELzJtMjRkQ2ZtcnNqdCswNUo3VFZPS0NMTlR2THpU?=
 =?utf-8?B?bWk0bWJKQ1M5cVA4TDQ5eXd6SVh1Vzk4K2JCbitkRG9Vbm02eVFlMjZLSWFm?=
 =?utf-8?B?WEJOUDZyZ1QwanhjMnVBdG1BdWpUZ3Q3YW1lejNXTnJHUmVQZnZDV3lqL0xk?=
 =?utf-8?B?b0l2RnZxbjVXaTQwVHJMOHN4ZUVtT1JIZ2VGK1h6RHFPbjlwZTIyOHp0anJa?=
 =?utf-8?B?UTBHR0dhMlZNNGVqODVHS0ZJd3grWk1NNFJ0Z2IxVGhuTG0xcFhVTXFtZ2JH?=
 =?utf-8?B?UjJyZkgvbzdRWWp4eUlnbWJLUWxPYUJPWStGOWZqRmU5KzhpOEUwbkpDbnAx?=
 =?utf-8?B?Myt0cVduelZsd1ZkZ3RrRjltak9QWnJlQXRMOVQweHJNK2ZxMmxleGZyTHFJ?=
 =?utf-8?B?VGNsaW1XMy8rU3I0R1A4NlVyNW1VNDhwQk5lTDhtQzhGRUErRy9WK09tREE3?=
 =?utf-8?B?cGNvaDlKVTNxY3dWZmlFWGpscFpwWWtMZTlmaWZSem1PUmFuOFQyMmZiWFZL?=
 =?utf-8?B?ZStpckRtR2loOFozUlNIbTU0QWpLQ2Y2NXVEWjhnSWFYRnRseFRqUEZYaGN0?=
 =?utf-8?B?Q1Z1bWN2ZGNTY01xZlhuSlFHNTJsRE5PbklvbFFEY2VQQzJ1Vjc0SFJTc1B1?=
 =?utf-8?B?U2pLenJsOHJmU1ZpMGVDWjdhMU0xU0xmVlFpdTViRFNlM0dQR21VOENkZUVS?=
 =?utf-8?B?bFZzd2dhYXBuMTFtMi9CVEhjZk4rN0c0WDlXd0NKc3EvUlROTm5xMXdWRDAz?=
 =?utf-8?B?b0k4eGFULzJMOWRyZk5Da0V4OTlUY3UwUThFdVQ5MEtVSDE0VEFZdXBNL2ZZ?=
 =?utf-8?B?Q1dUS2ZMRDg2cEVYb3ZCOHNqT3haS0VOTFUvWTdqZ0laRUo2R2NOYVQxUVlN?=
 =?utf-8?B?b0lCSTYxZGZYeE4wWTJEZEpxWXVJN0RoaTJiMVdQMlhxT2V6OXNIQnJqM1c4?=
 =?utf-8?B?VE9OR09UK0k4bGxWWW9wN0xzdVJJZEoxVXNaTWg1RG1Kay84REFENm5TMThn?=
 =?utf-8?B?QWVzVXB4YVlWQUxiS1VpUTJDMXJxZW1FcmR5L2N4Y3dEOHBuSFE4WEdMQmhP?=
 =?utf-8?B?UmNOSk9VUER3Sm5yTmF3RU9KVlBLbVFUTHExS2lhVHYrb2lqSEdOSEp1QUtN?=
 =?utf-8?B?MSttMS94SkhTRWg1aCtTOFRWVGR1V0YxbUdzZTZjU3JxQjEzMFg4M2o2VjV6?=
 =?utf-8?Q?/yoT9wlxGw+5RPQVFO4LacKzj?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?TjJ1TXNpZ0hDWlhMbHpvaDVKL1loWUxDS0lmQVZVL2UwRGxYSmZ6ajBML1Y2?=
 =?utf-8?B?ZXVDVlQweVFYNlplQjd1NXNWR0dYaFlHUVJGWjVxTDY1K0dZZ0NTNWNFSEJk?=
 =?utf-8?B?Nm1laUo5MEEyMjBSOThSbGp3eG9JdTg3djZqQ2FTd21aM1U2Mk5RNVE4VVBw?=
 =?utf-8?B?ODBPN1hkV2wxanBKU3FMYnN4TXgycXlkNytXSVMwQ3VSTHRueUpuMWQ5RUJW?=
 =?utf-8?B?VVM3R09RV2NlWnBmeEhlVGRZRlhZTkMvYUJndFg5ZS9LODJQTHMzVWVzM1VZ?=
 =?utf-8?B?WHRveFpOTU4ycS9yR1k3b0ZONnJXVVJ3YUlpM0MyWlFGUTh5Z2d6QkRXQlZw?=
 =?utf-8?B?WjFkV3lkT3A0SzdSeXJWQzhjV1I3M2hVUXRXYjgxczBhNUFUazdyTjVHbTJ4?=
 =?utf-8?B?bHhjOVRCbHFBSERLQXZQWS9KQlpJSVhqeXJVLzJDdVI4bS9nVHpXOUJGT1Zu?=
 =?utf-8?B?d1lJT0oxT1U3WXZHT2daOW5GMTZzQVd2THUwejhYSWMwdjR2cGhkQkE2QXpn?=
 =?utf-8?B?MURRN1NDbVlhTVY0NW5JUE51QklNYUFPRnVCNkpWWHBJR0JjdEZyNUZrNjBq?=
 =?utf-8?B?VjhNaXFpRTVxLysvQmZyUzlUUkx1VlVjT2x1WUFUNFQzUFdDZEdCa2J2OVd5?=
 =?utf-8?B?aU1ob2Ura0lPZlNHMnVJZjRZcWUvZ1VHTTR5VDErcmJmeURueHQ5d09hR3VT?=
 =?utf-8?B?bUlyd1p0dWVaNVJVeERHWjRNNHJMU0lCOVhnSDY0SmxvazBTZEpoZWtzY3NY?=
 =?utf-8?B?WktkbDFUN3czbkdXRHJhcTFuWXA0ekNYZFI4cmIzQzdvVkUxakRXNEJZSnZT?=
 =?utf-8?B?MGNoeFNqblZBTmZrc015ZVUrV0dZWXdvbGd1Rm8zeTBOcHBMOCs5anZZTGhH?=
 =?utf-8?B?azhVMW00bmxRaGU5aEgzWE5EMXJBWEtKVVNSOUhFbGUzOEJDTUtSdU1ld3hM?=
 =?utf-8?B?RGFOdWpaQ0NyRGliakttcmoxc0Z1SEpmNlhKQmxVOEhTc2xvOWthSUVNY2lr?=
 =?utf-8?B?TU9SV3pVYmljU3RydlQ0cEMwNnlzaVZ5UmFWN0NsV1ZYbUFRNGVVMUFTUzJj?=
 =?utf-8?B?TnVVVVhTWEdCWVpvTnd3dVcyTzB2aHlLL1cvUWJmbGl2ZEpRaDRwV0lKaFNC?=
 =?utf-8?B?Y0hadmxuNG9SYjhhTHBDQVBFcG5sNit2U3ZHcEdwalhoc1VwMHFncXpwcFhK?=
 =?utf-8?B?emFEWERVUXJJc0p0eUo3b3BscGNYVlhXbFV2RmZMYW1raGY1UE9yTXF4Y1Uz?=
 =?utf-8?B?bFpkSEIxdHByYnROa2k2UlE4S3BGaFJleXpqTy9aQVNvSUFSTDVONThYSzNa?=
 =?utf-8?B?VjZNcWJSVERxdWtvWThtcTZlMHErVkhnMmdaNXdaalhyZW1jSnprbUJ4T0gr?=
 =?utf-8?B?KzJEN2Z0eDNFVnI1SWkzaWdGTHY5SjBObEkzZ2lkNTcrdlJzR0c3L2NxUWZD?=
 =?utf-8?B?MWpCNDRVNEozWjJ4RHdMMU9aenZkd0JXeUxYMzBhOTYyWmZ0VGZ0dHlYRzQ3?=
 =?utf-8?B?M0tOV1VVK3JVNHZBZ1dtcFZFcUJCUmVjSktCZDVkOHgydjRzdUhyV1VZNE5q?=
 =?utf-8?Q?+L2CvvvFHYjVU/sRisPtdjX7HyZj8xJ84b2wqxBG3Wk61G?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f19d6fe7-e483-4d2c-66eb-08db354bd1c4
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2023 20:33:16.4984
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a5kgnJdHno+bfOnnx9nxrPton0N4K25cQPPt8dLqVBpRxorm+sujCEBaihA8B+WW9YQhpl5yyHi+QSouAyT6EA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4327
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-04_11,2023-04-04_05,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=465 bulkscore=0 malwarescore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304040187
X-Proofpoint-ORIG-GUID: IFxUQhVBVKI1DJC9wsCYlaIAGiOW8jWT
X-Proofpoint-GUID: IFxUQhVBVKI1DJC9wsCYlaIAGiOW8jWT
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--m2d4nofhitb3aief
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Mon, Apr 03, 2023 at 04:07:52PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.240 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.240-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Hey Greg,

This still reproduces:


cp arch/mips/configs/lasat_defconfig .config
make ARCH=mips olddefconfig
make ARCH=mips


.../linux-stable-5.4/arch/mips/lasat/picvue_proc.c:42:44: error: expected ')' before '&' token
   42 | static DECLARE_TASKLET(pvc_display_tasklet, &pvc_display, 0);
      |                                            ^~
      |                                            )
.../linux-stable-5.4/arch/mips/lasat/picvue_proc.c: In function 'pvc_line_proc_write':
.../linux-stable-5.4/arch/mips/lasat/picvue_proc.c:87:20: error: 'pvc_display_tasklet' undeclared (first use in this function)
   87 |  tasklet_schedule(&pvc_display_tasklet);
      |                    ^~~~~~~~~~~~~~~~~~~
.../linux-stable-5.4/arch/mips/lasat/picvue_proc.c:87:20: note: each undeclared identifier is reported only once for each function it appears in
At top level:
.../linux-stable-5.4/arch/mips/lasat/picvue_proc.c:33:13: error: 'pvc_display' defined but not used [-Werror=unused-function]
   33 | static void pvc_display(unsigned long data)
      |             ^~~~~~~~~~~
cc1: all warnings being treated as errors

Attached is mbox of fixed-up revert/backports.

Regards,

--Tom

--m2d4nofhitb3aief
Content-Type: application/mbox
Content-Disposition: attachment; filename="mips_declare_tasklet2.mbox"
Content-Transfer-Encoding: quoted-printable

From 0b1ed2eab2fd9d748523d951bef0acfa533fd838 Mon Sep 17 00:00:00 2001=0A=
From: Tom Saeger <tom.saeger@oracle.com>=0A=
Date: Fri, 17 Mar 2023 08:25:30 -0600=0A=
Subject: [PATCH 1/2] Revert "treewide: Replace DECLARE_TASKLET() with=0A=
 DECLARE_TASKLET_OLD()"=0A=
MIME-Version: 1.0=0A=
Content-Type: text/plain; charset=3DUTF-8=0A=
Content-Transfer-Encoding: 8bit=0A=
=0A=
This reverts commit 5de7a4254eb2d501cbb59918a152665b29c02109 which=0A=
caused mips build failures.=0A=
=0A=
kernelci.org bot reports:=0A=
=0A=
arch/mips/lasat/picvue_proc.c:87:20: error: =E2=80=98pvc_display_tasklet=E2=
=80=99 undeclared=0A=
(first use in this function)=0A=
arch/mips/lasat/picvue_proc.c:42:44: error: expected =E2=80=98)=E2=80=99 be=
fore =E2=80=98&=E2=80=99 token=0A=
arch/mips/lasat/picvue_proc.c:33:13: error: =E2=80=98pvc_display=E2=80=99 d=
efined but not used=0A=
[-Werror=3Dunused-function]=0A=
=0A=
Link: https://lore.kernel.org/stable/64041dda.170a0220.8cc25.79c9@mx.google=
.com/=0A=
Reported-by: "kernelci.org bot" <bot@kernelci.org>=0A=
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>=0A=
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>=0A=
---=0A=
 drivers/input/keyboard/omap-keypad.c   |  2 +-=0A=
 drivers/input/serio/hil_mlc.c          |  2 +-=0A=
 drivers/net/wan/farsync.c              |  4 ++--=0A=
 drivers/s390/crypto/ap_bus.c           |  2 +-=0A=
 drivers/staging/most/dim2/dim2.c       |  2 +-=0A=
 drivers/staging/octeon/ethernet-tx.c   |  2 +-=0A=
 drivers/tty/vt/keyboard.c              |  2 +-=0A=
 drivers/usb/gadget/udc/snps_udc_core.c |  2 +-=0A=
 drivers/usb/host/fhci-sched.c          |  2 +-=0A=
 include/linux/interrupt.h              | 15 +++++----------=0A=
 kernel/backtracetest.c                 |  2 +-=0A=
 kernel/debug/debug_core.c              |  2 +-=0A=
 kernel/irq/resend.c                    |  2 +-=0A=
 net/atm/pppoatm.c                      |  2 +-=0A=
 net/iucv/iucv.c                        |  2 +-=0A=
 sound/drivers/pcsp/pcsp_lib.c          |  2 +-=0A=
 16 files changed, 21 insertions(+), 26 deletions(-)=0A=
=0A=
diff --git a/drivers/input/keyboard/omap-keypad.c b/drivers/input/keyboard/=
omap-keypad.c=0A=
index dbe836c7ff47..5fe7a5633e33 100644=0A=
--- a/drivers/input/keyboard/omap-keypad.c=0A=
+++ b/drivers/input/keyboard/omap-keypad.c=0A=
@@ -46,7 +46,7 @@ struct omap_kp {=0A=
 	unsigned short keymap[];=0A=
 };=0A=
 =0A=
-static DECLARE_TASKLET_DISABLED_OLD(kp_tasklet, omap_kp_tasklet);=0A=
+static DECLARE_TASKLET_DISABLED(kp_tasklet, omap_kp_tasklet, 0);=0A=
 =0A=
 static unsigned int *row_gpios;=0A=
 static unsigned int *col_gpios;=0A=
diff --git a/drivers/input/serio/hil_mlc.c b/drivers/input/serio/hil_mlc.c=
=0A=
index d36e89d6fc54..4c039e4125d9 100644=0A=
--- a/drivers/input/serio/hil_mlc.c=0A=
+++ b/drivers/input/serio/hil_mlc.c=0A=
@@ -77,7 +77,7 @@ static struct timer_list	hil_mlcs_kicker;=0A=
 static int			hil_mlcs_probe, hil_mlc_stop;=0A=
 =0A=
 static void hil_mlcs_process(unsigned long unused);=0A=
-static DECLARE_TASKLET_DISABLED_OLD(hil_mlcs_tasklet, hil_mlcs_process);=
=0A=
+static DECLARE_TASKLET_DISABLED(hil_mlcs_tasklet, hil_mlcs_process, 0);=0A=
 =0A=
 =0A=
 /* #define HIL_MLC_DEBUG */=0A=
diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c=0A=
index 6ac6a649d4c2..a2527351f8a7 100644=0A=
--- a/drivers/net/wan/farsync.c=0A=
+++ b/drivers/net/wan/farsync.c=0A=
@@ -569,8 +569,8 @@ static void do_bottom_half_rx(struct fst_card_info *car=
d);=0A=
 static void fst_process_tx_work_q(unsigned long work_q);=0A=
 static void fst_process_int_work_q(unsigned long work_q);=0A=
 =0A=
-static DECLARE_TASKLET_OLD(fst_tx_task, fst_process_tx_work_q);=0A=
-static DECLARE_TASKLET_OLD(fst_int_task, fst_process_int_work_q);=0A=
+static DECLARE_TASKLET(fst_tx_task, fst_process_tx_work_q, 0);=0A=
+static DECLARE_TASKLET(fst_int_task, fst_process_int_work_q, 0);=0A=
 =0A=
 static struct fst_card_info *fst_card_array[FST_MAX_CARDS];=0A=
 static spinlock_t fst_work_q_lock;=0A=
diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c=0A=
index fb1de363fb28..5256e3ce84e5 100644=0A=
--- a/drivers/s390/crypto/ap_bus.c=0A=
+++ b/drivers/s390/crypto/ap_bus.c=0A=
@@ -91,7 +91,7 @@ static DECLARE_WORK(ap_scan_work, ap_scan_bus);=0A=
  * Tasklet & timer for AP request polling and interrupts=0A=
  */=0A=
 static void ap_tasklet_fn(unsigned long);=0A=
-static DECLARE_TASKLET_OLD(ap_tasklet, ap_tasklet_fn);=0A=
+static DECLARE_TASKLET(ap_tasklet, ap_tasklet_fn, 0);=0A=
 static DECLARE_WAIT_QUEUE_HEAD(ap_poll_wait);=0A=
 static struct task_struct *ap_poll_kthread;=0A=
 static DEFINE_MUTEX(ap_poll_thread_mutex);=0A=
diff --git a/drivers/staging/most/dim2/dim2.c b/drivers/staging/most/dim2/d=
im2.c=0A=
index 774abedad987..64c979155a49 100644=0A=
--- a/drivers/staging/most/dim2/dim2.c=0A=
+++ b/drivers/staging/most/dim2/dim2.c=0A=
@@ -47,7 +47,7 @@ MODULE_PARM_DESC(fcnt, "Num of frames per sub-buffer for =
sync channels as a powe=0A=
 static DEFINE_SPINLOCK(dim_lock);=0A=
 =0A=
 static void dim2_tasklet_fn(unsigned long data);=0A=
-static DECLARE_TASKLET_OLD(dim2_tasklet, dim2_tasklet_fn);=0A=
+static DECLARE_TASKLET(dim2_tasklet, dim2_tasklet_fn, 0);=0A=
 =0A=
 /**=0A=
  * struct hdm_channel - private structure to keep channel specific data=0A=
diff --git a/drivers/staging/octeon/ethernet-tx.c b/drivers/staging/octeon/=
ethernet-tx.c=0A=
index 100b235b5688..fe6e1ae73460 100644=0A=
--- a/drivers/staging/octeon/ethernet-tx.c=0A=
+++ b/drivers/staging/octeon/ethernet-tx.c=0A=
@@ -41,7 +41,7 @@=0A=
 #endif=0A=
 =0A=
 static void cvm_oct_tx_do_cleanup(unsigned long arg);=0A=
-static DECLARE_TASKLET_OLD(cvm_oct_tx_cleanup_tasklet, cvm_oct_tx_do_clean=
up);=0A=
+static DECLARE_TASKLET(cvm_oct_tx_cleanup_tasklet, cvm_oct_tx_do_cleanup, =
0);=0A=
 =0A=
 /* Maximum number of SKBs to try to free per xmit packet. */=0A=
 #define MAX_SKB_TO_FREE (MAX_OUT_QUEUE_DEPTH * 2)=0A=
diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c=0A=
index 0da9e0ab045b..68643f61f6f9 100644=0A=
--- a/drivers/tty/vt/keyboard.c=0A=
+++ b/drivers/tty/vt/keyboard.c=0A=
@@ -1241,7 +1241,7 @@ static void kbd_bh(unsigned long dummy)=0A=
 	}=0A=
 }=0A=
 =0A=
-DECLARE_TASKLET_DISABLED_OLD(keyboard_tasklet, kbd_bh);=0A=
+DECLARE_TASKLET_DISABLED(keyboard_tasklet, kbd_bh, 0);=0A=
 =0A=
 #if defined(CONFIG_X86) || defined(CONFIG_IA64) || defined(CONFIG_ALPHA) |=
|\=0A=
     defined(CONFIG_MIPS) || defined(CONFIG_PPC) || defined(CONFIG_SPARC) |=
|\=0A=
diff --git a/drivers/usb/gadget/udc/snps_udc_core.c b/drivers/usb/gadget/ud=
c/snps_udc_core.c=0A=
index e76f1a50b0fc..afdd28f332ce 100644=0A=
--- a/drivers/usb/gadget/udc/snps_udc_core.c=0A=
+++ b/drivers/usb/gadget/udc/snps_udc_core.c=0A=
@@ -96,7 +96,7 @@ static int stop_pollstall_timer;=0A=
 static DECLARE_COMPLETION(on_pollstall_exit);=0A=
 =0A=
 /* tasklet for usb disconnect */=0A=
-static DECLARE_TASKLET_OLD(disconnect_tasklet, udc_tasklet_disconnect);=0A=
+static DECLARE_TASKLET(disconnect_tasklet, udc_tasklet_disconnect, 0);=0A=
 =0A=
 /* endpoint names used for print */=0A=
 static const char ep0_string[] =3D "ep0in";=0A=
diff --git a/drivers/usb/host/fhci-sched.c b/drivers/usb/host/fhci-sched.c=
=0A=
index 5c423f240a1f..3235d5307403 100644=0A=
--- a/drivers/usb/host/fhci-sched.c=0A=
+++ b/drivers/usb/host/fhci-sched.c=0A=
@@ -677,7 +677,7 @@ static void process_done_list(unsigned long data)=0A=
 	enable_irq(fhci_to_hcd(fhci)->irq);=0A=
 }=0A=
 =0A=
-DECLARE_TASKLET_OLD(fhci_tasklet, process_done_list);=0A=
+DECLARE_TASKLET(fhci_tasklet, process_done_list, 0);=0A=
 =0A=
 /* transfer complted callback */=0A=
 u32 fhci_transfer_confirm_callback(struct fhci_hcd *fhci)=0A=
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h=0A=
index 30e92536c78c..89fc59dab57d 100644=0A=
--- a/include/linux/interrupt.h=0A=
+++ b/include/linux/interrupt.h=0A=
@@ -598,17 +598,12 @@ struct tasklet_struct=0A=
 	unsigned long data;=0A=
 };=0A=
 =0A=
-#define DECLARE_TASKLET_OLD(name, _func)		\=0A=
-struct tasklet_struct name =3D {				\=0A=
-	.count =3D ATOMIC_INIT(0),			\=0A=
-	.func =3D _func,					\=0A=
-}=0A=
+#define DECLARE_TASKLET(name, func, data) \=0A=
+struct tasklet_struct name =3D { NULL, 0, ATOMIC_INIT(0), func, data }=0A=
+=0A=
+#define DECLARE_TASKLET_DISABLED(name, func, data) \=0A=
+struct tasklet_struct name =3D { NULL, 0, ATOMIC_INIT(1), func, data }=0A=
 =0A=
-#define DECLARE_TASKLET_DISABLED_OLD(name, _func)	\=0A=
-struct tasklet_struct name =3D {				\=0A=
-	.count =3D ATOMIC_INIT(1),			\=0A=
-	.func =3D _func,					\=0A=
-}=0A=
 =0A=
 enum=0A=
 {=0A=
diff --git a/kernel/backtracetest.c b/kernel/backtracetest.c=0A=
index 370217dd7e39..a2a97fa3071b 100644=0A=
--- a/kernel/backtracetest.c=0A=
+++ b/kernel/backtracetest.c=0A=
@@ -29,7 +29,7 @@ static void backtrace_test_irq_callback(unsigned long dat=
a)=0A=
 	complete(&backtrace_work);=0A=
 }=0A=
 =0A=
-static DECLARE_TASKLET_OLD(backtrace_tasklet, &backtrace_test_irq_callback=
);=0A=
+static DECLARE_TASKLET(backtrace_tasklet, &backtrace_test_irq_callback, 0)=
;=0A=
 =0A=
 static void backtrace_test_irq(void)=0A=
 {=0A=
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c=0A=
index f88611fadb19..565987557ad8 100644=0A=
--- a/kernel/debug/debug_core.c=0A=
+++ b/kernel/debug/debug_core.c=0A=
@@ -1043,7 +1043,7 @@ static void kgdb_tasklet_bpt(unsigned long ing)=0A=
 	atomic_set(&kgdb_break_tasklet_var, 0);=0A=
 }=0A=
 =0A=
-static DECLARE_TASKLET_OLD(kgdb_tasklet_breakpoint, kgdb_tasklet_bpt);=0A=
+static DECLARE_TASKLET(kgdb_tasklet_breakpoint, kgdb_tasklet_bpt, 0);=0A=
 =0A=
 void kgdb_schedule_breakpoint(void)=0A=
 {=0A=
diff --git a/kernel/irq/resend.c b/kernel/irq/resend.c=0A=
index b7af39e36341..98c04ca5fa43 100644=0A=
--- a/kernel/irq/resend.c=0A=
+++ b/kernel/irq/resend.c=0A=
@@ -45,7 +45,7 @@ static void resend_irqs(unsigned long arg)=0A=
 }=0A=
 =0A=
 /* Tasklet to handle resend: */=0A=
-static DECLARE_TASKLET_OLD(resend_tasklet, resend_irqs);=0A=
+static DECLARE_TASKLET(resend_tasklet, resend_irqs, 0);=0A=
 =0A=
 #endif=0A=
 =0A=
diff --git a/net/atm/pppoatm.c b/net/atm/pppoatm.c=0A=
index 579b66da1d95..45d8e1d5d033 100644=0A=
--- a/net/atm/pppoatm.c=0A=
+++ b/net/atm/pppoatm.c=0A=
@@ -393,7 +393,7 @@ static int pppoatm_assign_vcc(struct atm_vcc *atmvcc, v=
oid __user *arg)=0A=
 	 * Each PPPoATM instance has its own tasklet - this is just a=0A=
 	 * prototypical one used to initialize them=0A=
 	 */=0A=
-	static const DECLARE_TASKLET_OLD(tasklet_proto, pppoatm_wakeup_sender);=
=0A=
+	static const DECLARE_TASKLET(tasklet_proto, pppoatm_wakeup_sender, 0);=0A=
 	if (copy_from_user(&be, arg, sizeof be))=0A=
 		return -EFAULT;=0A=
 	if (be.encaps !=3D PPPOATM_ENCAPS_AUTODETECT &&=0A=
diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c=0A=
index 392f8ddf9719..46ba86b8df28 100644=0A=
--- a/net/iucv/iucv.c=0A=
+++ b/net/iucv/iucv.c=0A=
@@ -128,7 +128,7 @@ static LIST_HEAD(iucv_task_queue);=0A=
  * The tasklet for fast delivery of iucv interrupts.=0A=
  */=0A=
 static void iucv_tasklet_fn(unsigned long);=0A=
-static DECLARE_TASKLET_OLD(iucv_tasklet, iucv_tasklet_fn);=0A=
+static DECLARE_TASKLET(iucv_tasklet, iucv_tasklet_fn,0);=0A=
 =0A=
 /*=0A=
  * Queue of interrupt buffers for delivery via a work queue=0A=
diff --git a/sound/drivers/pcsp/pcsp_lib.c b/sound/drivers/pcsp/pcsp_lib.c=
=0A=
index ce5bab7425d5..8f0f05bbc081 100644=0A=
--- a/sound/drivers/pcsp/pcsp_lib.c=0A=
+++ b/sound/drivers/pcsp/pcsp_lib.c=0A=
@@ -36,7 +36,7 @@ static void pcsp_call_pcm_elapsed(unsigned long priv)=0A=
 	}=0A=
 }=0A=
 =0A=
-static DECLARE_TASKLET_OLD(pcsp_pcm_tasklet, pcsp_call_pcm_elapsed);=0A=
+static DECLARE_TASKLET(pcsp_pcm_tasklet, pcsp_call_pcm_elapsed, 0);=0A=
 =0A=
 /* write the port and returns the next expire time in ns;=0A=
  * called at the trigger-start and in hrtimer callback=0A=
-- =0A=
2.40.0=0A=
=0A=
=0A=
From 11fb97c7ec4af4f962125246e0230812707fea06 Mon Sep 17 00:00:00 2001=0A=
From: Kees Cook <keescook@chromium.org>=0A=
Date: Mon, 13 Jul 2020 15:01:26 -0700=0A=
Subject: [PATCH 2/2] treewide: Replace DECLARE_TASKLET() with=0A=
 DECLARE_TASKLET_OLD()=0A=
=0A=
[ Upstream commit b13fecb1c3a603c4b8e99b306fecf4f668c11b32 ]=0A=
=0A=
This converts all the existing DECLARE_TASKLET() (and ...DISABLED)=0A=
macros with DECLARE_TASKLET_OLD() in preparation for refactoring the=0A=
tasklet callback type. All existing DECLARE_TASKLET() users had a "0"=0A=
data argument, it has been removed here as well.=0A=
=0A=
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>=0A=
Acked-by: Thomas Gleixner <tglx@linutronix.de>=0A=
Signed-off-by: Kees Cook <keescook@chromium.org>=0A=
Stable-dep-of: 1fdeb8b9f29d ("wifi: iwl3945: Add missing check for create_s=
inglethread_workqueue")=0A=
Signed-off-by: Sasha Levin <sashal@kernel.org>=0A=
[Tom: fix backport to 5.4.y]=0A=
=0A=
AUTOSEL backport to 5.4.y of:=0A=
b13fecb1c3a6 ("treewide: Replace DECLARE_TASKLET() with DECLARE_TASKLET_OLD=
()")=0A=
changed all locations of DECLARE_TASKLET with DECLARE_TASKLET_OLD,=0A=
except one, in arch/mips/lasat/pcivue_proc.c.=0A=
=0A=
This is due to:=0A=
10760dde9be3 ("MIPS: Remove support for LASAT") preceeding=0A=
b13fecb1c3a6 ("treewide: Replace DECLARE_TASKLET() with DECLARE_TASKLET_OLD=
()")=0A=
upstream and the former not being present in 5.4.y.=0A=
=0A=
Fix this by changing DECLARE_TASKLET to DECLARE_TASKLET_OLD in=0A=
arch/mips/lasat/pcivue_proc.c.=0A=
=0A=
Fixes: 5de7a4254eb2 ("treewide: Replace DECLARE_TASKLET() with DECLARE_TASK=
LET_OLD()")=0A=
Reported-by: "kernelci.org bot" <bot@kernelci.org>=0A=
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>=0A=
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>=0A=
---=0A=
 arch/mips/lasat/picvue_proc.c          |  2 +-=0A=
 drivers/input/keyboard/omap-keypad.c   |  2 +-=0A=
 drivers/input/serio/hil_mlc.c          |  2 +-=0A=
 drivers/net/wan/farsync.c              |  4 ++--=0A=
 drivers/s390/crypto/ap_bus.c           |  2 +-=0A=
 drivers/staging/most/dim2/dim2.c       |  2 +-=0A=
 drivers/staging/octeon/ethernet-tx.c   |  2 +-=0A=
 drivers/tty/vt/keyboard.c              |  2 +-=0A=
 drivers/usb/gadget/udc/snps_udc_core.c |  2 +-=0A=
 drivers/usb/host/fhci-sched.c          |  2 +-=0A=
 include/linux/interrupt.h              | 15 ++++++++++-----=0A=
 kernel/backtracetest.c                 |  2 +-=0A=
 kernel/debug/debug_core.c              |  2 +-=0A=
 kernel/irq/resend.c                    |  2 +-=0A=
 net/atm/pppoatm.c                      |  2 +-=0A=
 net/iucv/iucv.c                        |  2 +-=0A=
 sound/drivers/pcsp/pcsp_lib.c          |  2 +-=0A=
 17 files changed, 27 insertions(+), 22 deletions(-)=0A=
=0A=
diff --git a/arch/mips/lasat/picvue_proc.c b/arch/mips/lasat/picvue_proc.c=
=0A=
index 8126f15b8e09..6b019915b0c8 100644=0A=
--- a/arch/mips/lasat/picvue_proc.c=0A=
+++ b/arch/mips/lasat/picvue_proc.c=0A=
@@ -39,7 +39,7 @@ static void pvc_display(unsigned long data)=0A=
 		pvc_write_string(pvc_lines[i], 0, i);=0A=
 }=0A=
 =0A=
-static DECLARE_TASKLET(pvc_display_tasklet, &pvc_display, 0);=0A=
+static DECLARE_TASKLET_OLD(pvc_display_tasklet, &pvc_display);=0A=
 =0A=
 static int pvc_line_proc_show(struct seq_file *m, void *v)=0A=
 {=0A=
diff --git a/drivers/input/keyboard/omap-keypad.c b/drivers/input/keyboard/=
omap-keypad.c=0A=
index 5fe7a5633e33..dbe836c7ff47 100644=0A=
--- a/drivers/input/keyboard/omap-keypad.c=0A=
+++ b/drivers/input/keyboard/omap-keypad.c=0A=
@@ -46,7 +46,7 @@ struct omap_kp {=0A=
 	unsigned short keymap[];=0A=
 };=0A=
 =0A=
-static DECLARE_TASKLET_DISABLED(kp_tasklet, omap_kp_tasklet, 0);=0A=
+static DECLARE_TASKLET_DISABLED_OLD(kp_tasklet, omap_kp_tasklet);=0A=
 =0A=
 static unsigned int *row_gpios;=0A=
 static unsigned int *col_gpios;=0A=
diff --git a/drivers/input/serio/hil_mlc.c b/drivers/input/serio/hil_mlc.c=
=0A=
index 4c039e4125d9..d36e89d6fc54 100644=0A=
--- a/drivers/input/serio/hil_mlc.c=0A=
+++ b/drivers/input/serio/hil_mlc.c=0A=
@@ -77,7 +77,7 @@ static struct timer_list	hil_mlcs_kicker;=0A=
 static int			hil_mlcs_probe, hil_mlc_stop;=0A=
 =0A=
 static void hil_mlcs_process(unsigned long unused);=0A=
-static DECLARE_TASKLET_DISABLED(hil_mlcs_tasklet, hil_mlcs_process, 0);=0A=
+static DECLARE_TASKLET_DISABLED_OLD(hil_mlcs_tasklet, hil_mlcs_process);=
=0A=
 =0A=
 =0A=
 /* #define HIL_MLC_DEBUG */=0A=
diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c=0A=
index a2527351f8a7..6ac6a649d4c2 100644=0A=
--- a/drivers/net/wan/farsync.c=0A=
+++ b/drivers/net/wan/farsync.c=0A=
@@ -569,8 +569,8 @@ static void do_bottom_half_rx(struct fst_card_info *car=
d);=0A=
 static void fst_process_tx_work_q(unsigned long work_q);=0A=
 static void fst_process_int_work_q(unsigned long work_q);=0A=
 =0A=
-static DECLARE_TASKLET(fst_tx_task, fst_process_tx_work_q, 0);=0A=
-static DECLARE_TASKLET(fst_int_task, fst_process_int_work_q, 0);=0A=
+static DECLARE_TASKLET_OLD(fst_tx_task, fst_process_tx_work_q);=0A=
+static DECLARE_TASKLET_OLD(fst_int_task, fst_process_int_work_q);=0A=
 =0A=
 static struct fst_card_info *fst_card_array[FST_MAX_CARDS];=0A=
 static spinlock_t fst_work_q_lock;=0A=
diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c=0A=
index 5256e3ce84e5..fb1de363fb28 100644=0A=
--- a/drivers/s390/crypto/ap_bus.c=0A=
+++ b/drivers/s390/crypto/ap_bus.c=0A=
@@ -91,7 +91,7 @@ static DECLARE_WORK(ap_scan_work, ap_scan_bus);=0A=
  * Tasklet & timer for AP request polling and interrupts=0A=
  */=0A=
 static void ap_tasklet_fn(unsigned long);=0A=
-static DECLARE_TASKLET(ap_tasklet, ap_tasklet_fn, 0);=0A=
+static DECLARE_TASKLET_OLD(ap_tasklet, ap_tasklet_fn);=0A=
 static DECLARE_WAIT_QUEUE_HEAD(ap_poll_wait);=0A=
 static struct task_struct *ap_poll_kthread;=0A=
 static DEFINE_MUTEX(ap_poll_thread_mutex);=0A=
diff --git a/drivers/staging/most/dim2/dim2.c b/drivers/staging/most/dim2/d=
im2.c=0A=
index 64c979155a49..774abedad987 100644=0A=
--- a/drivers/staging/most/dim2/dim2.c=0A=
+++ b/drivers/staging/most/dim2/dim2.c=0A=
@@ -47,7 +47,7 @@ MODULE_PARM_DESC(fcnt, "Num of frames per sub-buffer for =
sync channels as a powe=0A=
 static DEFINE_SPINLOCK(dim_lock);=0A=
 =0A=
 static void dim2_tasklet_fn(unsigned long data);=0A=
-static DECLARE_TASKLET(dim2_tasklet, dim2_tasklet_fn, 0);=0A=
+static DECLARE_TASKLET_OLD(dim2_tasklet, dim2_tasklet_fn);=0A=
 =0A=
 /**=0A=
  * struct hdm_channel - private structure to keep channel specific data=0A=
diff --git a/drivers/staging/octeon/ethernet-tx.c b/drivers/staging/octeon/=
ethernet-tx.c=0A=
index fe6e1ae73460..100b235b5688 100644=0A=
--- a/drivers/staging/octeon/ethernet-tx.c=0A=
+++ b/drivers/staging/octeon/ethernet-tx.c=0A=
@@ -41,7 +41,7 @@=0A=
 #endif=0A=
 =0A=
 static void cvm_oct_tx_do_cleanup(unsigned long arg);=0A=
-static DECLARE_TASKLET(cvm_oct_tx_cleanup_tasklet, cvm_oct_tx_do_cleanup, =
0);=0A=
+static DECLARE_TASKLET_OLD(cvm_oct_tx_cleanup_tasklet, cvm_oct_tx_do_clean=
up);=0A=
 =0A=
 /* Maximum number of SKBs to try to free per xmit packet. */=0A=
 #define MAX_SKB_TO_FREE (MAX_OUT_QUEUE_DEPTH * 2)=0A=
diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c=0A=
index 68643f61f6f9..0da9e0ab045b 100644=0A=
--- a/drivers/tty/vt/keyboard.c=0A=
+++ b/drivers/tty/vt/keyboard.c=0A=
@@ -1241,7 +1241,7 @@ static void kbd_bh(unsigned long dummy)=0A=
 	}=0A=
 }=0A=
 =0A=
-DECLARE_TASKLET_DISABLED(keyboard_tasklet, kbd_bh, 0);=0A=
+DECLARE_TASKLET_DISABLED_OLD(keyboard_tasklet, kbd_bh);=0A=
 =0A=
 #if defined(CONFIG_X86) || defined(CONFIG_IA64) || defined(CONFIG_ALPHA) |=
|\=0A=
     defined(CONFIG_MIPS) || defined(CONFIG_PPC) || defined(CONFIG_SPARC) |=
|\=0A=
diff --git a/drivers/usb/gadget/udc/snps_udc_core.c b/drivers/usb/gadget/ud=
c/snps_udc_core.c=0A=
index afdd28f332ce..e76f1a50b0fc 100644=0A=
--- a/drivers/usb/gadget/udc/snps_udc_core.c=0A=
+++ b/drivers/usb/gadget/udc/snps_udc_core.c=0A=
@@ -96,7 +96,7 @@ static int stop_pollstall_timer;=0A=
 static DECLARE_COMPLETION(on_pollstall_exit);=0A=
 =0A=
 /* tasklet for usb disconnect */=0A=
-static DECLARE_TASKLET(disconnect_tasklet, udc_tasklet_disconnect, 0);=0A=
+static DECLARE_TASKLET_OLD(disconnect_tasklet, udc_tasklet_disconnect);=0A=
 =0A=
 /* endpoint names used for print */=0A=
 static const char ep0_string[] =3D "ep0in";=0A=
diff --git a/drivers/usb/host/fhci-sched.c b/drivers/usb/host/fhci-sched.c=
=0A=
index 3235d5307403..5c423f240a1f 100644=0A=
--- a/drivers/usb/host/fhci-sched.c=0A=
+++ b/drivers/usb/host/fhci-sched.c=0A=
@@ -677,7 +677,7 @@ static void process_done_list(unsigned long data)=0A=
 	enable_irq(fhci_to_hcd(fhci)->irq);=0A=
 }=0A=
 =0A=
-DECLARE_TASKLET(fhci_tasklet, process_done_list, 0);=0A=
+DECLARE_TASKLET_OLD(fhci_tasklet, process_done_list);=0A=
 =0A=
 /* transfer complted callback */=0A=
 u32 fhci_transfer_confirm_callback(struct fhci_hcd *fhci)=0A=
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h=0A=
index 89fc59dab57d..30e92536c78c 100644=0A=
--- a/include/linux/interrupt.h=0A=
+++ b/include/linux/interrupt.h=0A=
@@ -598,12 +598,17 @@ struct tasklet_struct=0A=
 	unsigned long data;=0A=
 };=0A=
 =0A=
-#define DECLARE_TASKLET(name, func, data) \=0A=
-struct tasklet_struct name =3D { NULL, 0, ATOMIC_INIT(0), func, data }=0A=
-=0A=
-#define DECLARE_TASKLET_DISABLED(name, func, data) \=0A=
-struct tasklet_struct name =3D { NULL, 0, ATOMIC_INIT(1), func, data }=0A=
+#define DECLARE_TASKLET_OLD(name, _func)		\=0A=
+struct tasklet_struct name =3D {				\=0A=
+	.count =3D ATOMIC_INIT(0),			\=0A=
+	.func =3D _func,					\=0A=
+}=0A=
 =0A=
+#define DECLARE_TASKLET_DISABLED_OLD(name, _func)	\=0A=
+struct tasklet_struct name =3D {				\=0A=
+	.count =3D ATOMIC_INIT(1),			\=0A=
+	.func =3D _func,					\=0A=
+}=0A=
 =0A=
 enum=0A=
 {=0A=
diff --git a/kernel/backtracetest.c b/kernel/backtracetest.c=0A=
index a2a97fa3071b..370217dd7e39 100644=0A=
--- a/kernel/backtracetest.c=0A=
+++ b/kernel/backtracetest.c=0A=
@@ -29,7 +29,7 @@ static void backtrace_test_irq_callback(unsigned long dat=
a)=0A=
 	complete(&backtrace_work);=0A=
 }=0A=
 =0A=
-static DECLARE_TASKLET(backtrace_tasklet, &backtrace_test_irq_callback, 0)=
;=0A=
+static DECLARE_TASKLET_OLD(backtrace_tasklet, &backtrace_test_irq_callback=
);=0A=
 =0A=
 static void backtrace_test_irq(void)=0A=
 {=0A=
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c=0A=
index 565987557ad8..f88611fadb19 100644=0A=
--- a/kernel/debug/debug_core.c=0A=
+++ b/kernel/debug/debug_core.c=0A=
@@ -1043,7 +1043,7 @@ static void kgdb_tasklet_bpt(unsigned long ing)=0A=
 	atomic_set(&kgdb_break_tasklet_var, 0);=0A=
 }=0A=
 =0A=
-static DECLARE_TASKLET(kgdb_tasklet_breakpoint, kgdb_tasklet_bpt, 0);=0A=
+static DECLARE_TASKLET_OLD(kgdb_tasklet_breakpoint, kgdb_tasklet_bpt);=0A=
 =0A=
 void kgdb_schedule_breakpoint(void)=0A=
 {=0A=
diff --git a/kernel/irq/resend.c b/kernel/irq/resend.c=0A=
index 98c04ca5fa43..b7af39e36341 100644=0A=
--- a/kernel/irq/resend.c=0A=
+++ b/kernel/irq/resend.c=0A=
@@ -45,7 +45,7 @@ static void resend_irqs(unsigned long arg)=0A=
 }=0A=
 =0A=
 /* Tasklet to handle resend: */=0A=
-static DECLARE_TASKLET(resend_tasklet, resend_irqs, 0);=0A=
+static DECLARE_TASKLET_OLD(resend_tasklet, resend_irqs);=0A=
 =0A=
 #endif=0A=
 =0A=
diff --git a/net/atm/pppoatm.c b/net/atm/pppoatm.c=0A=
index 45d8e1d5d033..579b66da1d95 100644=0A=
--- a/net/atm/pppoatm.c=0A=
+++ b/net/atm/pppoatm.c=0A=
@@ -393,7 +393,7 @@ static int pppoatm_assign_vcc(struct atm_vcc *atmvcc, v=
oid __user *arg)=0A=
 	 * Each PPPoATM instance has its own tasklet - this is just a=0A=
 	 * prototypical one used to initialize them=0A=
 	 */=0A=
-	static const DECLARE_TASKLET(tasklet_proto, pppoatm_wakeup_sender, 0);=0A=
+	static const DECLARE_TASKLET_OLD(tasklet_proto, pppoatm_wakeup_sender);=
=0A=
 	if (copy_from_user(&be, arg, sizeof be))=0A=
 		return -EFAULT;=0A=
 	if (be.encaps !=3D PPPOATM_ENCAPS_AUTODETECT &&=0A=
diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c=0A=
index 46ba86b8df28..392f8ddf9719 100644=0A=
--- a/net/iucv/iucv.c=0A=
+++ b/net/iucv/iucv.c=0A=
@@ -128,7 +128,7 @@ static LIST_HEAD(iucv_task_queue);=0A=
  * The tasklet for fast delivery of iucv interrupts.=0A=
  */=0A=
 static void iucv_tasklet_fn(unsigned long);=0A=
-static DECLARE_TASKLET(iucv_tasklet, iucv_tasklet_fn,0);=0A=
+static DECLARE_TASKLET_OLD(iucv_tasklet, iucv_tasklet_fn);=0A=
 =0A=
 /*=0A=
  * Queue of interrupt buffers for delivery via a work queue=0A=
diff --git a/sound/drivers/pcsp/pcsp_lib.c b/sound/drivers/pcsp/pcsp_lib.c=
=0A=
index 8f0f05bbc081..ce5bab7425d5 100644=0A=
--- a/sound/drivers/pcsp/pcsp_lib.c=0A=
+++ b/sound/drivers/pcsp/pcsp_lib.c=0A=
@@ -36,7 +36,7 @@ static void pcsp_call_pcm_elapsed(unsigned long priv)=0A=
 	}=0A=
 }=0A=
 =0A=
-static DECLARE_TASKLET(pcsp_pcm_tasklet, pcsp_call_pcm_elapsed, 0);=0A=
+static DECLARE_TASKLET_OLD(pcsp_pcm_tasklet, pcsp_call_pcm_elapsed);=0A=
 =0A=
 /* write the port and returns the next expire time in ns;=0A=
  * called at the trigger-start and in hrtimer callback=0A=
-- =0A=
2.40.0=0A=
=0A=

--m2d4nofhitb3aief--
