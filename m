Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED41666939D
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 11:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240722AbjAMKDP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 05:03:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241110AbjAMKCw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 05:02:52 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 482663AC;
        Fri, 13 Jan 2023 02:02:48 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30D9khAQ031574;
        Fri, 13 Jan 2023 10:02:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 from : to : cc : subject : content-type : content-transfer-encoding :
 mime-version; s=corp-2022-7-12;
 bh=TOrxaIKfzLrWfd3AeCAdfJMYYwWfpFiqwhVLY3wBWsg=;
 b=kPiqi6Pf326k5co48Gve8AOOZBNXlfUXD1AMPjxJZPmpcCWtUpQ5h9OsG4NdBFEyCnsm
 325IliMsx8M9Bt+3r6zHlJGX9nisYt5O/Zb7e+AK0Kd3SVarrJuebDW7bxaH4cxtlm81
 lhMbsyTyerG8vMsDz3gerwbE0uLWSgf8tqVpBRQxadkgd78sU+61wZRvLNZ30l7GuBPR
 pFVsULUWDkTxSYTxmwJxLePR7moSFuQ8OM0gFep/xSbUZcX2yicYg3LmlQXza8JqlIOJ
 pRsqf+YAe6B6hWLQ0u0PINWdleCOC4CQxomFfs2jN7p1xUu6VNc0U/8jSuSMw1W2Pt1v gw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3my0btvdjb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Jan 2023 10:02:39 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30D8diFP007424;
        Fri, 13 Jan 2023 10:02:38 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n1k4ce52f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Jan 2023 10:02:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n0WmIpvYcrTpWA7RY5W7dCdz24sx2Ds5V+Le59DAP/TqYqlYogehjgqZx7jyhuBOaAcxqaAEnSjA33Db2Iog3//sWMw2aWId+IHCSkBaTGppAUqBTWh3C/Dqrn8Z30n9KPyxQ075WB+P9gOMwkH9rt1hG8FclFrtwcaWc0uiJI4X6+v28OOnYFtCspCjOqXly/y0sIxKGxNywAMRhTQd7J5AykrgnboDT4PuxNzfLx/teVnmw2aFoFI06ghcvRXDxBXytHo6dAfvXt4ktDBcgWO9ZLstVm7FEwB9tYJao2XoceajoCtqAuu7abFCf+aDAX7Zxw/dZvLRJaQzipHLVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TOrxaIKfzLrWfd3AeCAdfJMYYwWfpFiqwhVLY3wBWsg=;
 b=d3RejSZOqiCleZyFQCnV9+ZjQQt4hpLEnpZI34bG+q3XywcHBML5AzZjIzFP1R8xlZWf1v5ve9CqkgLzDDd8MFqSWJaPfn/fkKb/fKVkAoaFPG8NYyb8Ay06MaqL/7CIuAvdwXF31jZPkBaggUB6Dyp7sSroJi4hcE0NOrKwb1Db2HhUxVvA4tD7+yTjMqwyFcfZJTRjbQuJAQThLmwlXQS8n3Puh97wf1TP8O0XestCJcW5KsM2dOi31OTdUH8r0ab5PAQWatGCSWUHqVCBQxKSfFMhyxSeSE7Nd1tLpwiP+0pyXokQFMwLzHS9z3Gk76GHJKp2pKUAhsqm92WPng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TOrxaIKfzLrWfd3AeCAdfJMYYwWfpFiqwhVLY3wBWsg=;
 b=MrOQKIul0eNmz0jESCYfxsYGluzLvJMBljBgDxaaf1WTIk2A0LQTkCXLYVsuqko6qGCG9JPDM8rgwOMrGrfrdWaolbu++ZCiKJXr7nma9hoCYbR4X08qjRNs7IqoQNs28PEnAqtixQGeA5hQZoeVg4CwTWFYSDLX/pcPHvLmOBo=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by PH7PR10MB5745.namprd10.prod.outlook.com (2603:10b6:510:125::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.9; Fri, 13 Jan
 2023 10:02:36 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::475f:4f66:d927:ea15]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::475f:4f66:d927:ea15%9]) with mapi id 15.20.6002.011; Fri, 13 Jan 2023
 10:02:36 +0000
Message-ID: <2322a626-ac5a-9400-82bf-3aaccc5fddb7@oracle.com>
Date:   Fri, 13 Jan 2023 15:32:25 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Content-Language: en-US
From:   Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
To:     stable@vger.kernel.org
Cc:     pbonzini@redhat.com, shuah@kernel.org, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Darren Kenny <darren.kenny@oracle.com>,
        Liam Merwick <liam.merwick@oracle.com>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: 5.15.y backport request to fix compilation error in selftests/kvm
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR01CA0163.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::19) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|PH7PR10MB5745:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b97baf5-4666-495a-98d4-08daf54d4bbd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HE+Tb4Dd4xVLaZ+DRmOTcis3/KvmFJBdQ8TmgHV7wLMVeprl5p+sxVRltE98EK97RE+CrWT9qZRum9OC6zz7aigObsOoRhAwCwAqMcBZdQaD2uxgyxD8dEQkPEQyL7HWp89hUkd2MpDA4g4ipRgK21ap5itG79AWZx+SdqPm9u2HuIIc1OAH+UgI/C111sqmpM7Xwrxbwlh+Yl0b3Vs68RYgYjeTHkGYTevH9EPs+Bpx9OFrPECjvzFsj2NkPLD8P0i+tDHHkfxcM5KYtLkxxaufN1hVKHjkbJCvCxReKv+phKQiq8hXp+XzKBSRiRTOhRjKS+jR6veeM793DYfbMb7U40UDu6lOmrE4GIXWewDiq9eaSaEMJDxLsl4DdWL+e/vfKsUiG+NdGyoTk+2L8SxDkWBzdQJwdOBKqUTPS1pa4yrCq/qPJ2Rz0mUUBa7JaFbZimTOz2z9iwSixynDYdkiZgzGNUluD4u8GSqtABMc58FuIZUteh6mkBxYwEZ1YBvfL/O6/4KTu3UvBeC+dBDp00qNg59gjnt5Bf9oLvjAW7PTJK9X62LyB/koa9l/tYpoBE6Q7h4r/gcAYek6Dy17IZKSG5YVCpHVLWCX5U+FFdRWCX64SeSt3NDNnEPgvERLW3jnUpKTvBA6wjBGEFgE8LvR4Cw1E60i9kujgq6Q10DOXEgd15kUIjHS7NtLW/pnORxnJMrgeGl24YGm1bPWGyyvMdt5pYd4G4OI6do6ROpx3ojrcHmu8iRftkINwiUpaoctuVNX0nluFN872Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(366004)(396003)(39860400002)(136003)(451199015)(83380400001)(6486002)(966005)(31686004)(8936002)(6512007)(2616005)(186003)(38100700002)(26005)(5660300002)(316002)(41300700001)(54906003)(6506007)(31696002)(4326008)(8676002)(6916009)(86362001)(66476007)(107886003)(36756003)(6666004)(66946007)(478600001)(2906002)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VVU1U3pwdzZSRk5OaXpjRkpSdDEwTWlKRkJ4ZVFxTlEvYUhpTG9SNUYzRS9n?=
 =?utf-8?B?V2VaSHJpOE9wV3hOUXRab0gzYy9hbXp0RGpnWVR6a2RjWGhGYjFmOVRWNDY5?=
 =?utf-8?B?UXM1d1FwK3NIOC9vM0NwazkxbnV3VnZHZWxxN0JlUzFJYzd6ekZHMXhJZXpr?=
 =?utf-8?B?SUtUMWpiZTRQeVNFY0FLZzFPOTM4aVZ3TXNOdEwyWnNOV1B1dzhkY1VqZ1ox?=
 =?utf-8?B?UTV3L2NiY0VkK1QzSDlKc3kwUXo2L2orcWpyVGdoOVhwd1pOSG5CMmhWeG84?=
 =?utf-8?B?dVpzRm5NaVJpQXRZVjZWNjdCVUx2MVBqaVk4R3E1RmtnUFY0UHEwamVJdUZT?=
 =?utf-8?B?dUYzYW00TFp0UXRzMnFneDZIMk5YRm8wdC8rbzF0WTVEeThhdmpyQjgzRjYv?=
 =?utf-8?B?RlMyMkUrQjlxbS9KU0lKcU5lcjhNSk5KU0JkTU91Rm82aXlaekFEeEYvamFU?=
 =?utf-8?B?UE9hdXpxMTNjTHc2bFM5ZkNmbnZnQk51UTNieVNqTVNKWmw2QW8zdkc2MjZj?=
 =?utf-8?B?b2srcVBqWW44eGE2ZGtsSDV4Mjc2ais1UXVUZVgvSE0vWTNidDJNcU1HdUlz?=
 =?utf-8?B?WXJhRGFBc2JQbEpLenpzd3VqaTF2RnI1ckpLWkVqbE1aREdKTGxUNEdDM3Fn?=
 =?utf-8?B?eEZTV2tQNUNLQ3RBN05ycTZ0NFdHS3JLRDhvdG9UQlh3cVVaMTVIODlDVEYw?=
 =?utf-8?B?dWJiZzFudC94bmFKZFk3a3UxNkIrQ3BiY2FYN05Qb3BSTTQ0Wk1NbDdKazMx?=
 =?utf-8?B?d2dHRlJLWjc1eWVoMkM1OEJ1OXlERGIvdG05UGQxNDE3eEh0aGIway8zSDJT?=
 =?utf-8?B?YWlnVUw2WWVDV0txVWJYOHFKS0lLQnAyL25waFVGKzVqMUdBcTVYZnZxWDBh?=
 =?utf-8?B?cWhiL2Z3R0hUclZnamZyM0hIUW9vRTBlUzhrUUliVHQ0T0hoTmdsaVBVYm5n?=
 =?utf-8?B?WjBrZkZhMEdXcGh3SHhXTlVhNDdDbFNhR1V4TWNUbm5LOXh5bi9UMytsUEw1?=
 =?utf-8?B?cWNWQ05oa0M5aGZ3MGRqTDlZOGhJZ3VYa0FycnBrNG1RdktmQWo4UG9mby9E?=
 =?utf-8?B?R3JzS09ZY2ZZMHoxckdBSTZNajc4cURNUTdaN25McS9sVFBDbDR3bTd6ZzRQ?=
 =?utf-8?B?SXk3MXNqbm9xVVVKbnY3RlRmK2RvSGtkbFFjUUdvMVlUZjAyNVU5UVBBQXVm?=
 =?utf-8?B?RFIzK3Z4ZU51cXVPMmpNWUJCeFBKZDF2aFEzRXF3cXU4MmtJaldnMkwwQlhz?=
 =?utf-8?B?eWtocjZpYnZDQzAwVzNoRWV2YmJKTmVzOXdNZGc4N2gwZ1lrV2JLYkhRVGlo?=
 =?utf-8?B?WlFadENiUXZyUkVZNis3Y2JIVm54S3NRMWQrWVFMZmI5UWc5SHRpbGRPM0FU?=
 =?utf-8?B?cU5CSUxaUDZEZTNvcjJrRzJ1d2h1bGRYWmpyS3lyUnp3N3R5V1dUQVhOakJ1?=
 =?utf-8?B?QWFaeDFGZFhOWEVlSUR0cnRmZWk4N2EwakY0cEc0RGNVb1NycFBPNElGeFpJ?=
 =?utf-8?B?eUVBVlRVYXdqb1FKd2dxOFZ3T2tld2g1eFU1bHAzNkQxd1ZOamM5Ukk5eUJW?=
 =?utf-8?B?TkxNSmtuQ0EvTUpacTVHeWE5OE9URVlxUXM2Q1BaSnRnSndBUTczNkNqdXBI?=
 =?utf-8?B?Z1lNWFlCWmdOWjFqRHhLd3ovOGpUaFdMbXdVdndTZGJyS21qSEFTQTFFRTdp?=
 =?utf-8?B?MXFVL2dXV1VKZm1iMmhIbHdyazlSL2NuRjlGVTZvLzBGOHEyL2JwQWYxVWsx?=
 =?utf-8?B?YTJBelQwNnJHMFF5TXpLRmhXSWdQWmVHREVyTEVEL3FuQjlWOWZhbC9ESW9l?=
 =?utf-8?B?NzhiSVRRNGFRNldzVjRGUUtlQnRtUnoxU29HR3RTejhzWFNUNmR1dEY1cW5V?=
 =?utf-8?B?c3pYdkIyNmRPOXZBck1oeHFtMnVnSHZ3cHR5TDJLZnVaMnVreDEyN29YZzRH?=
 =?utf-8?B?Y1k3T1dTK1hXUWc4dkRMYUpMelNBajQ3UGJTSUo3WlQ2ZWc3cEphdGpDSkF4?=
 =?utf-8?B?UVhuU0JMa1IyZkFXeSt5NjBHYS94dUdUZVB4Q2NuOXdWWnhWOWtTdHRQVGVy?=
 =?utf-8?B?eDFJbVNRUERJNmVySDUrcUx3MmVueUhxVzNrZWZrWHQzSHpZYi8wS2dFTndx?=
 =?utf-8?B?ZEFUdm1qd25iSkNmQWwraVpCcStIMlE2SldQdVl0Y2VML3UxbmtVZU41aHlS?=
 =?utf-8?Q?/TWB/dKLY9QTmU4EHMyVcPo=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 1Lp/+1wVDygPGqZlDuu0F/aMVvACMqB4lQavaNMOR3vhjqQ9twwyXBO1/Akpt4kxr0Yv2yej0p8Gki272Xpp9tEIPlBOF2gTb+FtO9/QgoVZDSYuJtr3cSLqggXvLFKKwJPBkHv+heL0xww7j458CAYFx8FxCWjuJtY48140cbyIw1Xotl1t5J53AsLrZz3e2mTs8ZISbMW+wKB7UGrguh1++k7baypLXqsSn5sAQjxhILskvIQz+S/gk2wRCLVeToX8oY2iRjey+6A5xShzM3ACo5opi6JVyfOnH4UvfpsgDtVJMhY9lY6BWSLLvYSZwICI0VhOEVTrUEMaBDHvryUR4FmQXZ7Bwv72Dr4mh60GH1DnHDV91lrNCkZnTmrRf/y65o0kejGZ9vITufBBmhdZ/uuluj4IdXworKDXBcRcZdSfwyVRKP8ry6kWxlbkJP1sYB1fz8rVIhmaRTiC+cMlSKpD4FuRSE+FaN0nzjdIG7IQg52Isfd8yil8+aY0XKv0LxDMimMjXHTwah6doUv21uLK7yuW95bcNeApislk7ikU/UwJfKxAE1IFENWlLdLNi3edFws0DV9oNrCML5IiOKpmEzujjCFdCUFKfVfXNkMPLYYXLoRTFp8r0qEaOMRHu+wDab6EGxgGVdFhpVsUdMiCYGweUc3b4x55Ol9h6hr+H65ufv5wd0560uTGLLFhSRA36MxOovAiMWmRufE/Pz2almKmkjJSRJKs2diPjQn5lfLD84ptLzbr2y3ioY3LhG8RU6hauTi6wnV8XCvQJC5/lMvq9Reh0gn06YxAB3vosqw9VT6ROidGU1hB
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b97baf5-4666-495a-98d4-08daf54d4bbd
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 10:02:36.1474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UUDQw2dvx1UQLRMiz+IbYVezcxeyZrNXE1Ff8tZcZbo/65ryZbJ/1BnMORyN4eGjAH4PELT+WM7Qmpt6+yK1780roTK8s/dkmAs5CsDTI/WZlkixuPjyPTdI0Apx+13C
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5745
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-13_04,2023-01-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 spamscore=0 mlxscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=913 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301130068
X-Proofpoint-GUID: JG2eCkR2PDH22yxnPg8ynKXtd3nxnu4c
X-Proofpoint-ORIG-GUID: JG2eCkR2PDH22yxnPg8ynKXtd3nxnu4c
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On arm machine we have a compilation error while building 
tools/testing/selftests/kvm/ with LTS 5.15.y kernel

rseq_test.c: In function ‘main’:
rseq_test.c:236:33: warning: implicit declaration of function ‘gettid’; 
did you mean ‘getgid’? [-Wimplicit-function-declaration]
           (void *)(unsigned long)gettid());
                                  ^~~~~~
                                  getgid
/tmp/cc4Wfmv2.o: In function `main':
/home/test/linux/tools/testing/selftests/kvm/rseq_test.c:236: undefined 
reference to `gettid'
collect2: error: ld returned 1 exit status
make: *** [../lib.mk:151: 
/home/test/linux/tools/testing/selftests/kvm/rseq_test] Error 1
make: Leaving directory '/home/test/linux/tools/testing/selftests/kvm'


This is fixed by commit 561cafebb2cf97b0927b4fb0eba22de6200f682e upstream.
Kernel version to apply: 5.15.y LTS

Could we please backport the above fix onto 5.15.y LTS. It applies 
cleanly and the kvm selftests compile properly after applying the patch.

Liam pointed the same in [1]

Thanks,
Harshit

[1] 
https://lore.kernel.org/all/fdfb143a-45c4-aaff-aa95-d20c076ff555@oracle.com/
