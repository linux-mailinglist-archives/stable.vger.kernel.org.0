Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B08926A7944
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 03:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbjCBCEa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 21:04:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjCBCE2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 21:04:28 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D381C42BD0
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:04:27 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 321Muxi4010778;
        Thu, 2 Mar 2023 02:04:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=dgt5kwkqsCA+11hojLRYzMKql8HKNoPKSgkbrqmipy8=;
 b=b0Te2QO8zG3ZF0m2KGiFvCjxXE4OVueStbCOV7p98L0td3R8qeUlit3HH70Wd/miim3j
 9v4T2nMB0Qu3x57nEja2l6b6koyrByHWCCoOQwGcVy1jQthl/SJlbRv97gHasRdyp23L
 mHvmCRM+d9QoWby9F4mOw0D5sNtjugBrTf7IGzcMfYFLBEQOj24j80wPFr5KIWiXf5xe
 gE9IAPHiKsXvX/kXA5b38iOQf7lY8yzhS9WdRtqr2/IeU7u4fFpq8T9ZVPLE3kzjpRrX
 XsUaE0v79a01Fhlevnkjg9yS3Qyk8/RhF8j+WkOcEkQ1ueSKylENnC/JjtKkpPGW4RF/ 2g== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nybb2jh0m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Mar 2023 02:04:22 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 321NfEsI032985;
        Thu, 2 Mar 2023 02:04:21 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2040.outbound.protection.outlook.com [104.47.51.40])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ny8s9c75c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Mar 2023 02:04:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qwq5Yg/CI3E7GiifNEW+1adQZh7eUt8njjyKxfNZFXyv9G7Eid8oAZJxLxLiuMg2M0Yam3JWl5WjVODZJpzI2IbxkekZysrEQz4upR9VFFaBuJQqSD04KQIlJu1+EzykKo5uiqC2txh+W/86LLcE5JKR41IKAax0LYlR9P9pzJGJJi4YVROveRFC4W4SGpX8l45lvw4ZNkSi5YyiAAJ6C3m5P25bUUHTJwsop53C8+VJaBsNYgxurbe3qe6/WRyLxBq43b+pvU9eau4cxGiZt8P2wR11l7AfiY4tO8Z+jYZX5rW4Ks0sfTlZ28mL9Nmbgj8p6FoMSdMQbQAWd0k3pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dgt5kwkqsCA+11hojLRYzMKql8HKNoPKSgkbrqmipy8=;
 b=U/p+r2QRorm33BYuPDICKHDVsSG9EENWhkHkT0yhX//ElmXfzKDN8vWPhq0rvXvBTnALWPp2rViv21Dp+0URGyPg7I3JnrO+g0NYBGOVou3LDyo2JrepQuiPExRQaLhoCeUt3rqR58J0X9eT70zXZ05xqJbKyPm5202QKKBOMhdc59sn7Xfrud8TyY4Tpd8aLMGIcArq5SdoZ9pKqV/i1GEVV7VTd/afPc4dfJZ4GYDAVxYEU7P9LHINrAPEqPNZYkU0Q7c8GxsXqJ1SxobqY0+sJOG5cJl5Bnjt3afJ920TJRRif67821owNbnz1mjj29fE6ClN0U8jvVfrkMJfXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dgt5kwkqsCA+11hojLRYzMKql8HKNoPKSgkbrqmipy8=;
 b=wFW/9LSZe64BHN5d0DRhQ8O1P0rDho5fQtjd8GEOHdPjvhvKNMeatA9gEj1KnlKJjvK+35rEppqVXxzBjn9B6kJ3uASJXtTfTJW3+tn+dKHcsNUXHkxcZTAq8SzPQfwTFk2TdaG+Pc3UzlYUgiSGIeQUpVPFoEzMV9TWnVhRKDw=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by DS0PR10MB6872.namprd10.prod.outlook.com (2603:10b6:8:131::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.17; Thu, 2 Mar
 2023 02:04:19 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f%3]) with mapi id 15.20.6156.018; Thu, 2 Mar 2023
 02:04:19 +0000
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Tom Saeger <tom.saeger@oracle.com>, stable@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.15 v3 4/5] s390: define RUNTIME_DISCARD_EXIT to fix link error with GNU ld < 2.36
Date:   Wed,  1 Mar 2023 19:03:51 -0700
Message-Id: <20230210-tsaeger-upstream-linux-stable-5-15-v3-4-3431a425f0c7@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230210-tsaeger-upstream-linux-stable-5-15-v3-0-3431a425f0c7@oracle.com>
References: <20230210-tsaeger-upstream-linux-stable-5-15-v3-0-3431a425f0c7@oracle.com>
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.1
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0007.namprd11.prod.outlook.com
 (2603:10b6:806:d3::12) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|DS0PR10MB6872:EE_
X-MS-Office365-Filtering-Correlation-Id: 172f7fe5-b67d-4a21-43e4-08db1ac26f2b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mv4K8Sf5+a8c7jY4yytHhrW9R4zUkBmM2EHO3o96BGktaZ0Z2eGv+YGBeXGwrj+kuq7tpPYdUDgPcGy4VHEhht4XgQcchG4H/SeZ9oZsOlsrkhl7tGuwvGzKKBSVLAJBujqummhFEc5tgbW4kYaV5rZurTQo6RWFnuL78/l0kHhFs0bZydvOSxWTanVVL7PJG6tUexz/E2BAnKuLhm4oNi4uLvcXLDOi6FFUj5m3zqv1KRYFS/VoDOKnghtggTIbBAAR77xo8KVyETONLdqiUYAQ0BRlCfb5tfPNcQv7xNj7DmtQbCZsVxDP6BFJ4226GCbZS2krUSZTu9mZ3FsgmZLrcgUqCqVTvMyffQeNzUdmPpQszAGLoJmUACVohlEGsfIf6QiTsY8NO57g92LtegPMu+I181FPIMTlZLeg7V2HoYJNmjmdGXHC64q7Fy7UyAOXaEex2NIUwW1aGTIAl26kwMGVrwfZwfe6KEd8GPUskmGZCTT3NyR76oQq9ZIh55b/v0oYVJjIC0A805o8LQsv0bS/vDA4+Vegs73UKl3LNZPMPvwSixjo+5PwmwHAcpIrwu31W7piIwUdyQS5whD7QJjJIvnPlrv5Nj5pGjtBgMi8cN8ur8U65QXuTQHuuMUtlga38KgtHXyBHymNdVVN9kDaMVOCDdBRQd000bA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(346002)(396003)(136003)(376002)(451199018)(5660300002)(44832011)(66899018)(41300700001)(4326008)(6916009)(8676002)(8936002)(66476007)(66556008)(66946007)(966005)(316002)(54906003)(38100700002)(36756003)(2906002)(6486002)(6512007)(478600001)(6506007)(86362001)(26005)(186003)(6666004)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TjAyUEZrdUhvQTFST3poMjdSYTVjbDBUdkpDanZJZ0d5dzNnbXI1eDQzcU1F?=
 =?utf-8?B?c1hKY2g3RWpGZ3F3dHM2elE4OXBPRXpoOG10TEIvWkRISUVxU1B6U0wvMk9N?=
 =?utf-8?B?VFZSOGJHSXNQYkJiUlFMMHNnZGM5WUtvQjVMdXJEdWljK0J5ajd2dmtPVzM0?=
 =?utf-8?B?UDFHODNRQTBKT0ZneDNXRE5KNGJ3YjlIT3FuTUNXOUViajhDWjh2SFRPZDZi?=
 =?utf-8?B?cldHMmtVVlg3WGxZRllxOUFsUTJVWW1wejNTbmhic0pGR3krSW1UQm5FcWt1?=
 =?utf-8?B?akNmeDZyUTFwOThCaUg4Q0xBczZMWDd2aGlTbitYeENpNXdWd240SGhJTm9r?=
 =?utf-8?B?ZW13cEhVOTZpbHY5amtUcTB6ZFhvai9mV3Rta1ZLRExzeklXSEp3dUJIKzM4?=
 =?utf-8?B?aWFaVXhVOEdDQittSHV4amNPSVNKUVljczVWVXBMUnIvREZycC9nMXV4UFVZ?=
 =?utf-8?B?ZGFxdFA5Z0VaQVhSN09pSXB6OExubFFyRnRhVWRyWGdkeG1pdURLT0J2VzlR?=
 =?utf-8?B?bWUxRDhZLy9BQWpiNE9KTCtIVU1FOXhnQmt2UmVrLzNYOS9QT1FGRjNxK1VR?=
 =?utf-8?B?MENVRTBBc0dkNi9HZVJJL25iL1d5TFVVNE0wcTN2UHZ0bGhTQVI2Z0c2emNS?=
 =?utf-8?B?WFJ1dVR3Rk94dWZsWFFyQm9MUnJVbGdGbjJTeXc1Smlkd0prNSs0Mm5ZQkYr?=
 =?utf-8?B?SzFGTDduR3ZGOEtmRUh6cXBRRWJuaGhaTkJVenJSOHpMYWN1UmRqaXF3ZmVG?=
 =?utf-8?B?bVZvZzhQYm9GS2JLVmR3dkp3bFdaajB2L2pIRTdWZTJOWVpGekppb2MxK1ZW?=
 =?utf-8?B?bUNMVDZNSHMvTERMZXQxNzlvMloyUmxYQU9UNExXRWs4VzZaWlBXU1Yvdmlu?=
 =?utf-8?B?NTMwS0JiendxK29QUGtOaWEvUVZMRzR3SmpldzByclBrc1BrV2FIQ0p6Mis3?=
 =?utf-8?B?elRacmJUSEUxbDRrVXhvaWZJOUkrZW94YUpKSWJydThycmlHRCs3OWNPWm5T?=
 =?utf-8?B?bVNWZnVnd2dRbVl6REhFQkI4Y0xwUlFTRDQxUVpLbWdWNklFbU83K0dvSWhG?=
 =?utf-8?B?aHZvTmNHQkZlczhpbDU2Z29TZEtMc08xSUZvSnAwZ3lzbGhneFp4OFR2cUJq?=
 =?utf-8?B?dHN5V0JzTitQaTZ5ZVh2L1pVUlJLUENYVWc5ejl5N2dVdVpNVlkwRTUwYmhu?=
 =?utf-8?B?bEdTTlZsTllzc1lUaGNXaDJkaXBEcUpScVZ6TFQvVEYxdlpJR3RsQkVPekMz?=
 =?utf-8?B?RkVTMTIyc1NyL2ZJQUlLYkNudzlhZ0wwU2JHNEhDV2lDS0RTNVlKeUdtcTUx?=
 =?utf-8?B?THVvZU92SHpWbnlXZ2g3aS9mYy9jMHZ1TmhTMFY3NmNFdWVhMzgvRk5LTG1C?=
 =?utf-8?B?TytwQk94Vi9EdWFrbW0wNTdJSjhEbnZQYkEwdUVaSGxjZi9KQm5yRGlGdXhN?=
 =?utf-8?B?bEFwdjQrcExkdEFmUGQwdUZLNEdROVNpTXNKcXhnWlZxVElyV21Xa1hhbzY0?=
 =?utf-8?B?Z2k1U2xCNXdVL0hDVm9zVDVTclIrMmJhbEFqYWRZTDdzSTJrUFgzV1ZyaTZ1?=
 =?utf-8?B?Njc0c1ZaL2czNllIVEdhckN4WGliL1ZzNElVS3ladlpwZ2NISjNZVjEvekFx?=
 =?utf-8?B?VTRWNVB4L2FEczlTSkl6bjNtVFg0VkNteHArSE92NlhJWjdmK0Z1YmpWUnY2?=
 =?utf-8?B?dWtBR0ovc2FLNkxnLzFIUTEyZFVvWWVzZkVwRFZhajJvS0xWZ2Z5ZlJDWWJw?=
 =?utf-8?B?QjJxYVFLVU51bEZNYXp1d0RLZUQxY1pwRjNyWHpFUlRRUjhIU1Q0bEFFc2hp?=
 =?utf-8?B?c2pHaUx6aW1ZRFdqQ3A4TU83R1BLVDNjV2UzWjQ0WTJoQXhoWHEySjRwN2pR?=
 =?utf-8?B?aU5lVFJxdGpNRnlkaDdQWmxDWFJKVVJxL2EwSGNmaXVaekNEQ09yZFVxZ05R?=
 =?utf-8?B?emZZWlU4eHd2K2lOekhMVm0wSVNyME1sc1krcWFuTE9KeGtkanRVaDZyYkYr?=
 =?utf-8?B?YWdjQW85YU5hL2xCellML2NJZi9RNWV1UE1DZVFOZ3I5c1BKdHFTM0NVNzc4?=
 =?utf-8?B?QWovbUYxUXZUY0thYWVlZ0lESWRzWEdRWUFyeG1vN3JuSDhDRjJDamhLSVdz?=
 =?utf-8?B?TzEyQkVMRERROHJaMDNObUtnRU1Kd05MYWVMQ1BDeXRvaENXUCsyZjZYaUpT?=
 =?utf-8?B?L0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 4kJgx4/OvUECOIEZ4bcVV5fhZTwIQJC9YxFLSoZgfWx8h2ijiYgQEsjA+w+y+juqiRTaDG+GRdjPJGJs3YSzrnkcTLrqrBQnZ2g0JtTQRfufAVH38bZbtB+9Dd6vAXAdvAAgQ3rbTllEGeZpMhbVDWngQZQd7FAdRSf4mrgWDZGiJLSgQrMnjazoEdBN7d2JHODO1CzVLWU58R/iRNJen71IwO+C85ABbIuaBN2a/zz7fC0cf5pMx0sAuTCjLfo0O30JJwyRRH+qQ8heoO1N24KZmeQf5PbuM+3KF55RB4pbjgD0NNi9ZoOFFJt907gsbZ25p6LaLxUuvTNEbt5W274pU1iidLfkdv36wc29VhyXLAirOalhF622hkLiEfkEFEKG3jo742nAapk/AHSJEqXC4v6MveUAbHOmh73Wb9M3dOeMiZayYbqah44J3jonJy5+ITR/aiYKSdHwXGtYnJBHTv0blJgY/9oCXii79EMyaip41uD/w09BIlZ5yLMSLFv3Lkf8JzIY9mT+uwrnjTU5swSFYuf8ORAipU9Z9lvCLWKwEp0rcaQX9U07I5jRUBWT8X63YzCHiJnhVTWboYalh9+czvrJRv9mq2wO5nZsxA8zeGvYRHjhqENXgsHUmfK06dDR2UHW13c18aNC+29oum/qdEU0aFOxVqQ7HidYfGXpCzPvbVaabsfCVmE9pp7MlEhsTB02ORKRiRBLCm8RgxMxSPf/yw85WFl9SIGNCzNKAoJ4Ewl+0cgQxQX99txQmRha+o1MDkHlmUG6V6gh22xuEmK2wYTlkOomWLrfPIYbj9wibIVtQPzdeCGnmwzfaahcL4lxh+QhEt9jJSTeaRzNovmEk04AxHMPdJ0H6UcUZsRpqGUdXnnuuXEt
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 172f7fe5-b67d-4a21-43e4-08db1ac26f2b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2023 02:04:19.5859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L5JxRp/hBJpB5iEvX8GAo2Z/co0sfWGpygU9Xf+/PuUW0okp1eSbIthWUnWp3IwA6i5joWAc4DoZX1FcZJs3ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6872
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-01_17,2023-03-01_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303020015
X-Proofpoint-GUID: trMbrBiODV4-ex-HpLUKh8OSKeC2ZMNK
X-Proofpoint-ORIG-GUID: trMbrBiODV4-ex-HpLUKh8OSKeC2ZMNK
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
index 8ce1615c1046..cdc8b84b2db4 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -17,6 +17,8 @@
 /* Handle ro_after_init data on our own. */
 #define RO_AFTER_INIT_DATA
 
+#define RUNTIME_DISCARD_EXIT
+
 #define EMITS_PT_NOTE
 
 #include <asm-generic/vmlinux.lds.h>

-- 
2.39.2

