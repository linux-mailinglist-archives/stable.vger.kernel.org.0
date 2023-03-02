Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3EAF6A794A
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 03:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbjCBCFm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 21:05:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbjCBCFl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 21:05:41 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE9694C6ED
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:05:40 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 321NEAWa012647;
        Thu, 2 Mar 2023 02:05:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=sugbXJIgNK/5yjwt5IOQi1sXQv8RfNO5+gIPVVOhqew=;
 b=yU/jKyFBkH6g/KOz5BxOaO3uVBrqoTeKkynBkaK9hPvaR6Kv4mRiDIPXl4dPaDGRmohI
 UDHyKSkAKq39GHdpC9zhlsm397L2AtRuzXZGRj/lNuqq9BReGiFIA9u9xjMnxjEHlTGx
 SPQ1nmrqrdGbb7RWzRlO29EQWqoFzGIVT9e9D3vvTyi4ZJqWnk5LPQqA6/eJOnsAygia
 fJH1fjnK+0jsdgphkow512X74QyRtknGUM9dah39vxIVdCptg8rHTAe0CiOyZ2Wj+4nI
 iZuKo/Po6KIrV7y+RV5LIil8SKOvQn5ZXiY91/L2OQM7UVuZW0a965S81Vql7MQDsEVD Ig== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nyba7jda6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Mar 2023 02:05:36 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 321NfEsc032985;
        Thu, 2 Mar 2023 02:05:36 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2043.outbound.protection.outlook.com [104.47.51.43])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ny8s9c85a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Mar 2023 02:05:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xr0ZA4vWZX6VtcttmaDkc8ezYThxNJK7zhNf/NVRGrAQmbHLfgDtH63sIv9IwIlWBZEwVLJRly3CThRY82jlnVXVVszGJdy5c73KHUgnOMnqDvwwZwJB7DNdX+hsyhV/epxZAKCml2CQiOZXRdPBWB13X8H4pC21mDPwmCc8x/SYT1iPip4VTnUb5CIr8zqUiQxKOktVMHB0zkRPGlbQmaPFTFLbw21g/bTwVepNk3OPiaTA2JVKJvK+rv5+rc0rCHyQBhxKMmOuVaVbej0kbL4PZY0nd1DFGbCatmJNY892ugGIJyI3Lap8vOcE95eOjT2eMo29rvte0EpirMmJWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sugbXJIgNK/5yjwt5IOQi1sXQv8RfNO5+gIPVVOhqew=;
 b=Uuhz3dxSg6H3WfFaIGQ3VkAmqqcsyQLBCF7HCqu85xPu7aPVHKoXOAwbROjvAbBXdGJm2Q0aQH2oYsRFLAKxbrhE78UPYtbHTa1V9ok1Z4NrVEDmVH7OV1wSZuSTJoOE4nFCXyIuMINEYcDfvQQFwdg7HuTrEjzUEmAWEe5SuDuPA4/uiRTWmXYT/fQ24wPxPH37hqcURwbYxwdj8ouY/D0haQgSv0BIsB5PjaFtRtOYY57D+N3Lg4Zben1uBlGUG3Wh8JyGKgfuvI47tsl97UfzPfFhCtt5ADsE6hX7N+Gla+O+ndI3cob4nIJoqVu0BwUyzAqCv0ZbjQcn6Q9/6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sugbXJIgNK/5yjwt5IOQi1sXQv8RfNO5+gIPVVOhqew=;
 b=zUoRFGkT6ovSJqjD0dJoyWHQQQsX45PpVlFcRZVyvRRnQEOGpRmpDlphp3qjFkVPSxPMWca8n3eqtrxR1ZisMhuv8gFqBmkgjMgYlmbJQFxyBl35DLEjtVYUzDtFzCRDijyZ2dzPu8+SDWMOLd8NVJmzmtBC9NapbwCMxhelGmo=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by DS0PR10MB6872.namprd10.prod.outlook.com (2603:10b6:8:131::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.17; Thu, 2 Mar
 2023 02:05:34 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f%3]) with mapi id 15.20.6156.018; Thu, 2 Mar 2023
 02:05:33 +0000
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Tom Saeger <tom.saeger@oracle.com>, stable@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.10 v3 4/5] s390: define RUNTIME_DISCARD_EXIT to fix link error with GNU ld < 2.36
Date:   Wed,  1 Mar 2023 19:04:55 -0700
Message-Id: <20230210-tsaeger-upstream-linux-5-10-y-v3-4-f7f1b9e2196c@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230210-tsaeger-upstream-linux-5-10-y-v3-0-f7f1b9e2196c@oracle.com>
References: <20230210-tsaeger-upstream-linux-5-10-y-v3-0-f7f1b9e2196c@oracle.com>
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.1
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BLAPR05CA0033.namprd05.prod.outlook.com
 (2603:10b6:208:335::14) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|DS0PR10MB6872:EE_
X-MS-Office365-Filtering-Correlation-Id: d9cd55cc-206c-41f5-7b7b-08db1ac29b6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D/c9ejzVAb8T+jYbaJM845WMnUnsgshwevmsHhKndSBfEHOcJsTztc9JaEKcvce4EfzM7wAit8FVoMTamSZ2j0AfbQJwp2/6JYOhrqk4knLPjSwOlvOj5EoDL088AhKZVXTuMJYm4HzShGsn1mdz3xY7fBroNUTdxSC9MgqOVl5gtuVUCeJxdl/jDsbpGfNH9gh2nuPtC/LkoNPUvodwWC77hIYfLebdJe+ICs7bIeK4j8Hdbq71uEwO+DNg6/UDYTv2qwhx2Dda+lZKLWkyrJ+kYArIhZtWziD7HRyGA/V7KPgV6fA5XeUFplRed9gKIfgEbnXLUV9lb5JKLUVabmA9gXklU8vLaOE5A/2JfVwo+Szl+6oIzJ0w5S/yLMOkHVE8Fej43J5Gk/WTecJzkVeaO5l5eE01ju/pDxPqmVpgej2HGU5OPNeDQ88/rmoudNonMK/FAPFihJTZsxWOoywuvoNfycqKerw6fF+fMXBvsndcF0hbDefNoSulrDw7R98Z/kAdwagc442d0HDdWmpHz3koG9j8mQBVFu3B6bvXYMBLfYLuXeKO6GgB2t73YH7zanbs8CcoU3PZd/HlnMyJENaiDIfNdDawQ6Gaf5K6+ptM/vBLhRrUxY5BjZXW7XJPvYOwjirbkQdEReYs7TjTN84xRchdRMo7tJ51RUs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(346002)(396003)(136003)(376002)(451199018)(5660300002)(44832011)(66899018)(41300700001)(4326008)(6916009)(8676002)(8936002)(66476007)(66556008)(66946007)(966005)(316002)(54906003)(38100700002)(36756003)(2906002)(6486002)(6512007)(478600001)(6506007)(86362001)(26005)(186003)(6666004)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RW82dUllaUJBbng1UW9QQURPVVhOZEd1dkFiWUZBbUR2QlNKalVKcTZYZ3k1?=
 =?utf-8?B?cG54enBSQXB0Y2wzMGNrNUNvTjVrL3QzZGJINHY4WTlZUGJidEdKNjc5YmtM?=
 =?utf-8?B?SmhwYVJyOGhPd0Jpb1VCelVZWE96M2tubFlQYy9PUlEzVXdiVER5RlI4UzZl?=
 =?utf-8?B?bVlMNnE1cDAyKzRnTWJHVEF2dE9CRDJDNGhpZnVZeFZDYlFrQklDbVkwT1c5?=
 =?utf-8?B?RXNHMVBiMjJlcFRKMm4rRGhNUU44ajBhczR0MDhSaS8yRmpEUWoxeHJML0Rr?=
 =?utf-8?B?enNmR2FoZ094T096b1diTUU2YzA1M0JrVGE4NEloUlRrZXk2NnU3NGM0T0ZO?=
 =?utf-8?B?Qm45bFlzNWFIVWQ5c0E1NWR2S2diNFBtMHlsbkhEb1UwVU1xTWNtd2IvKytT?=
 =?utf-8?B?WTJtS1YybTlCcXI3dEpqWHdSK0NwSXZ1S1NrcW9weUZQUHg4V3JoN2k1bWpr?=
 =?utf-8?B?UkNiZEw3cmZlREtpSE9iSGxHSjR0WDJKbEVqaWV4azdrZGErVmM4K3pabm9S?=
 =?utf-8?B?UWUvZ1ZHV1BjZkdOVU9jYWJvY0lnYlBpREJDREh0aWhiblRyTi9kR1duYXdu?=
 =?utf-8?B?SmQ5NWFHWDAvRGk1dm4xbWxjNjYzRGRkQmk3U0ZWeStqYzNqdmFoQ29CN0w0?=
 =?utf-8?B?YjliT1A3dzhjdS9HbGJoa2FMOFhNbkY5ek43RWNtRDRtcGxpWDNJZTNWZWp5?=
 =?utf-8?B?R3BWeXdua1lRbFczL3VXRC95ZGx3ZkVBRFlnZDVZdGpTODJFVmRnc3hLeWw5?=
 =?utf-8?B?OGRFZUFvTFc1L3NRU01ZVUpIYlRteFZzRlQxOHdmYUZpQlBaMVAvYm12RjdE?=
 =?utf-8?B?MXFRajhSeStQYlVIanU5OC9WeTMvZEcvWjZ6YXNhK1pobVVOWm05R1BROVNm?=
 =?utf-8?B?OWNJZ0RHZERoL2VlYkYySlpIdk1XaTNwWmM5MEQ5RjFEMXlXMG81dVhkWkFL?=
 =?utf-8?B?VE5udDcvN0tiVjBJdHRHNzQ2Ky9vOWNQZWtsK1NRbytUM01ndFpnY0ozTExz?=
 =?utf-8?B?RmJGTFRnQXV1SU1PK1crMUZTbjNUVjd6YXFPa3YzUyt1TGhYbWs3UlRLMjJV?=
 =?utf-8?B?dlU3NXRZUTFlazVxMGpvTGJLRVlmVHRjdHIyclV6RERVZTBkVExSM0UzZzU4?=
 =?utf-8?B?YTh6UTBSSUU2cjBiWnBTZGh6U1dDOG9GVUg1cHZkZkdzcjRxbmVQenJNeWp2?=
 =?utf-8?B?VXlWYjdYbmJLSEtNbGQ0Zm90Z21WREN3cDBMM3hyeTRCQmd2MGJkL01ZbGU0?=
 =?utf-8?B?R05OczlWMnpuVWJHa0g2RDZNak1xZlYwMTR0VC92NTd3UzJXblRRS0oweS9h?=
 =?utf-8?B?cVFtU3dmZjR2anhONTFZTUpGQTMvQ2RyOFBFdGhsbEtIL2lXMmtMWnJjQzlG?=
 =?utf-8?B?V0kybGdkU05OVDY0ZVY3NUNtb2V6M0pJNjM1KzBFbGh2YTYyMHlicnRzMUNw?=
 =?utf-8?B?Slh3NlNBWGg3ZnVGWWkxdUdBQ2FLRmsyWUorNkdUTUlKU1BlSVhLeURTN0h0?=
 =?utf-8?B?ZHIxcW1IdlcxeVFJM3ZkdExFTjVNY2xDbXNEeXpVVFJMSUc4cGhkaHllVVZK?=
 =?utf-8?B?bU4ycXhQUjdOUWFUbFJscTNaRWF1djlsUlR0L0hzMURpNEpDSmJoUWxuRmcx?=
 =?utf-8?B?K2U1ZVZNTS9OakN4T0pPU3dHa1ZkY1dndGR0TldyVzlXWWllUVE4cEtMNUxS?=
 =?utf-8?B?djNKa3RMc0lpZVljdW9QTnI1VW9GVHRXWHlxSGZ1bkgwTlR4YW51UktvSTNC?=
 =?utf-8?B?RjZEQ2dSbEFYOUlVZ3NQdDI5RHg2by8vQkc5V1pRRDJPWVNSSVdPSEVGMER2?=
 =?utf-8?B?KzI2alYrWWQyL2FnTHNGRmpwV0I4bzVkZm9FOEltd1BlQVV5TWYrUmY5bkhT?=
 =?utf-8?B?eE9BODhtZVVnVjh0K2pNVEFTT3BNS2ZTK0tDc3V4eklIc3g0WkI3dFQ0WlNR?=
 =?utf-8?B?TGRaS0IvNG5BWWhuaklUTkpyTFVBL0IwSTZ1aGhJaGFSendiSXZVeHU2L2xG?=
 =?utf-8?B?Yjg2Yzl6VFZTai9vc1lkMlZEZEFwK01CNUxrK0E0cXhUblpyRDU5MEllektn?=
 =?utf-8?B?cGE1Rk8vZnp2emRnTVdJTXYzZWFjRVM5aWF4UXJlaG13SzFlVjRkWVB4Y2V1?=
 =?utf-8?B?WFdiQXFEcXQyWWc5NEU2SE94VlhWZ1Nqd0cwNHRhNHhhamVNcElkM0J6MWpo?=
 =?utf-8?B?RXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: kReG+PKqsY7f1ZO53AqzkU6ZAjzAFQ1lmXQ47Iq2lJmX07h7l0HcA0lUC3mo81pD9EAdS9O9+ISv8PmbKIIzImgh+4eqHyQmjdBB6nt7+2g+/NqYyg+K1tIgmKy+/g4VF/4bkpwdeCge1NYe8qL6pZp+G4RPlogfyMC7GpSWLWEgD5hHV8JuF2bn0LbZwMa2uF5Bw+kMdIfUmjm5qonzrZy6k5ISzc55xpZna7UbFoQc//ddFFWcA/xgd5dMwd3TgRQUB5h8Qd2vv1z37Irzk7obViEFTGeUdLdJvb3Csr+pByOICV2nomUMZ2SOxT2uMtd/PalykBoOI6Dh9UoThq0Pi0/CCTstWS/Hj8lUn4OwFm7utwAsnfRrpJIEv1zScTSZtLduLaNmLv2VC2TRn4q4FBMbEhdfXuvnA9foNXhpNBS2VGxLEarrqgv9kbh835NFhHaQKDLFsj7ZvvT29lK6tSS72ieD9DepU01JgJP5OfMO+nrz0EBZG+tBY9hRRfVY83gVF0m2gernanb2pxQTH4D4mLXTlK13g1R/6j074Ohp2JSR7UHA+wx+4twGJVJQ3aqhWS5Hr3XT2ko7C05XNperBJgJ5Y/LG3g/LBoNY10tqnojVD+Cih91cDRqYGX8U1ohrn0huN4keZN5NvAVtwr3HOkmiBv74SaghQmzwZvAnXWeQEClsDzU/DbuwFSdFpecYJFVVwFukif/gq6Wd21P+BSu6i8Hbq5zMg5FRt0f82nW+CPnwjTsY+gMUmcKLpr8sFNRQ8VNTw1vW/hgiabiF29FyCOuuL2OVd1e5sAKki3BpgHiT8BxlaeWNdLjNQzlHNuduM0PmqEKlztL3/MXJq6BNcWtYBpm0xM4MsvkPseI/xrFaIl0GHU0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9cd55cc-206c-41f5-7b7b-08db1ac29b6e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2023 02:05:33.8305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jz1rSnbS9e7lCSUK+6GdRRAt7zNG3IaUOq+genZ19KQhfrJJESIHbrwZVbfm7FxMMgHN5FSFL1AFhS1cs88K5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6872
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-01_17,2023-03-01_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303020015
X-Proofpoint-ORIG-GUID: cv8fZQIfrfbiINeHuO2g8HWmCupbJGMS
X-Proofpoint-GUID: cv8fZQIfrfbiINeHuO2g8HWmCupbJGMS
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

commit a494398bde273143c2352dd373cad8211f7d94b2 upstream.

Nathan Chancellor reports that the s390 vmlinux fails to link with
GNU ld < 2.36 since commit 99cb0d917ffa ("arch: fix broken BuildID
for arm64 and riscv").

It happens for defconfig, or more specifically for CONFIG_EXPOLINE=y.

  $ s390x-linux-gnu-ld --version | head -n1
  GNU ld (GNU Binutils for Debian) 2.35.2
  $ make -s ARCH=s390 CROSS_COMPILE=s390x-linux-gnu- allnoconfig
  $ ./scripts/config -e CONFIG_EXPOLINE
  $ make -s ARCH=s390 CROSS_COMPILE=s390x-linux-gnu- olddefconfig
  $ make -s ARCH=s390 CROSS_COMPILE=s390x-linux-gnu-
  `.exit.text' referenced in section `.s390_return_reg' of drivers/base/dd.o: defined in discarded section `.exit.text' of drivers/base/dd.o
  make[1]: *** [scripts/Makefile.vmlinux:34: vmlinux] Error 1
  make: *** [Makefile:1252: vmlinux] Error 2

arch/s390/kernel/vmlinux.lds.S wants to keep EXIT_TEXT:

        .exit.text : {
                EXIT_TEXT
        }

But, at the same time, EXIT_TEXT is thrown away by DISCARD because
s390 does not define RUNTIME_DISCARD_EXIT.

I still do not understand why the latter wins after 99cb0d917ffa,
but defining RUNTIME_DISCARD_EXIT seems correct because the comment
line in arch/s390/kernel/vmlinux.lds.S says:

        /*
         * .exit.text is discarded at runtime, not link time,
         * to deal with references from __bug_table
         */

Nathan also found that binutils commit 21401fc7bf67 ("Duplicate output
sections in scripts") cured this issue, so we cannot reproduce it with
binutils 2.36+, but it is better to not rely on it.

Fixes: 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv")
Link: https://lore.kernel.org/all/Y7Jal56f6UBh1abE@dev-arch.thelio-3990X/
Reported-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Link: https://lore.kernel.org/r/20230105031306.1455409-1-masahiroy@kernel.org
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
---
 arch/s390/kernel/vmlinux.lds.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
index 9505bdb0aa54..137c805d6896 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -15,6 +15,8 @@
 /* Handle ro_after_init data on our own. */
 #define RO_AFTER_INIT_DATA
 
+#define RUNTIME_DISCARD_EXIT
+
 #define EMITS_PT_NOTE
 
 #include <asm-generic/vmlinux.lds.h>

-- 
2.39.2

