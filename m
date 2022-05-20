Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54A0B52E538
	for <lists+stable@lfdr.de>; Fri, 20 May 2022 08:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345970AbiETGqM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 May 2022 02:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345969AbiETGqI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 May 2022 02:46:08 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A05353632A;
        Thu, 19 May 2022 23:46:03 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24K5TdqO016949;
        Fri, 20 May 2022 06:45:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2021-07-09;
 bh=1iQV7BXiNeAjgHtftthAUHLQslOSZwxCeLkcw0+B4Nw=;
 b=LI/PLbg8r+rx5gD/SEMMvfJubd0RTbGywlBmliM4HxfObKy5HYKAZtWafcRZ3NwFLWb0
 1oMqCStVehfL4X7v9x84NKqY8cqYBKYXCIO9+yHNhWyyO1wEOZ4yUbPMscU4TAp5V40U
 NQ5FscUc9MNs5E40wKEhb9ISzCZKF6uq7kUYAj4mqOZnwv/sK1VEEwJ2VnWhdsGsYUKn
 56aUoZ3reO1V0asDoiudff0EHDRbAIx7cIFpD9WB8YjiJd4UtB0XYtTcfval0Ebo+Py2
 IemVtShOIy9cZrU88k4/oGej2qtcIjCTVxT64BD2nB6QnXwVsxdLsq+1Ix9VBjYmtxs6 qA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g24ytx79n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 May 2022 06:45:53 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24K6jode011087;
        Fri, 20 May 2022 06:45:51 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v5ruxd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 May 2022 06:45:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mbjbnXbTyFzfKiAyOtYCQ/hKr6AcvSU7stwK5fKRvEVmes3MRwfcAWryV2gORQv85O19G6dZMopmHZzJDb3C/eulJl42Rjmy1gyh68HwD9pn2SEF950p6kL3QR/eC+3WlFOYEjvwf66URuK2+DOnh+zonE10GlRXtu9Xj3X7yqkGFEAj1JdO9w8j3RGiziOklbZ9pa4M0Vb6CkasbWYV0OAsu1hEtW2OCBpL7aWOmf+IvROSGDgBd2vUAQfBaAZlC10MvctoW1dcNsRAAS6cWts8Hr2embAKNPnGIkXw2UP3roJB5c9Fipf9UFewc/gV2NjOYYSpGsSqNJtYGnBuLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1iQV7BXiNeAjgHtftthAUHLQslOSZwxCeLkcw0+B4Nw=;
 b=WsmQpmLRnTWXQJhJyFMfoO5tvx9ZskKuuIDkFydggWDR4LcWl71lFtWViCLidkbfcgBPlGmln3AFXZL6+z7gtqR0+zzs7SEVk7umebU3Fza89gjQfn9bFdN+Q060UVcGbA8A4GKkAsG0IU+WKV8oD2E9BH5wmKPWJ87kyPrIdKURYVS6IM1atVI39KTuUYJRUw5KD01b0T6cQ1aqwIIdeC7ICUjc6ZAuvkNhvMi/Z5Rx2Np24F1xs2DM6MK+YdSdxRi4EcVupJ5G6vJP4l318fImaOj/zM18c8o/u4PcK5hOFZSbcufqnRuxLFt1FKdztk0zSX1QfXgLTKtg+3jQNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1iQV7BXiNeAjgHtftthAUHLQslOSZwxCeLkcw0+B4Nw=;
 b=o42CkV1T0rgt4cOzxI+5MTECnQu/q66RskyPb8A7qnK+ziJaD8E/DcNJ5okvDGmJicgkPGOnDmzah8tz1MqmH1xSVFAvX+y/niya9en+LRYg6FbzTrgYNK4yvyaV1Pvyw4W9X3Gu8vZGADvVOsCKG8AFhFsET/srCfJu3IvgNrc=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by PH0PR10MB5435.namprd10.prod.outlook.com
 (2603:10b6:510:ec::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.15; Fri, 20 May
 2022 06:45:36 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e%2]) with mapi id 15.20.5273.014; Fri, 20 May 2022
 06:45:36 +0000
Date:   Fri, 20 May 2022 09:45:16 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        stable@vger.kernel.org,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v3] nvmem: brcm_nvram: check for allocation failure
Message-ID: <20220520064516.GX4009@kadam>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MR2P264CA0176.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501::15)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ab31446-d7bb-4b1e-aafb-08da3a2c581c
X-MS-TrafficTypeDiagnostic: PH0PR10MB5435:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB54352B817D8DB75D89BF299C8ED39@PH0PR10MB5435.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RyiIOaS6fpKBGLI1zqpuvDiJVpHf82XXOJJnhG1/Hiq5Wpn9xxnhJOUHhIB7JeQjixMX8ysN+6ESBYrry8Kk0B99gkKMVtUv2SnZQ3YtVSWmmKMhzB6nlCWV8rvmydYR9l4708OqQRGEjyVgry7LviRn6Dnx4xGxHAdO83TN6EhQqDsJZLAhNy4TJuYW3svSVWp7sUTZltSi3F/4zCB97Gg3fDjAgM90XXOEJ6saLRMtDq64Jk0a9nJUk+FKJjeZySvb9eKxgTU8UCGIYUDdAQzfatP1wOqwLMI8h7LWohge9DsXtpp+I7eS2q5viPKp3h/52LadStR4ym5/XMDkxjJi1hv7bGgbpEB5XS30PVZkA97mRfGXoHqqIUvh81X2Vmz9BR/a0frp3gKShEsqSM2ePWW0XBvubFFQmlNh0oPPe/hPQ47tHOwmM3Y8Q2yJ/ChmS9yVAwUZ2Fy065A9VDehZ4Gm5/qoGLawY7n6kZxpoxd+JmgJbM9376ohLebhgiEzeG0iGkVIaWOECitwbpfQFoT20Pas+dPFgYjipKkWaDYAZ4NdJmVv9VqwkM4Nxg43wBKcm9GE0B55/a/v5oRbyZiZ3G5RRpb2DbvmwJlajRNs9nv9fGKZDa5q2JA03fCjuo5fbIPC8LLvwLToZyLSrckTpwL/7s/eEaOY+fITgQZH067be09i+oHtLuhYOaO3WzJZCxat/IWQLDvGYw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(26005)(6506007)(52116002)(6512007)(6486002)(5660300002)(33656002)(6666004)(9686003)(2906002)(33716001)(38100700002)(38350700002)(83380400001)(186003)(66946007)(1076003)(66574015)(4326008)(8676002)(66556008)(508600001)(66476007)(86362001)(54906003)(44832011)(6916009)(8936002)(316002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aXVtTk9DOVVaclIxQU1BTHJnZTRDaXBlTWltL2Y1c1FLWFpMRVF2dy8ybWhX?=
 =?utf-8?B?RXJhR0l3YUtxM2pwRlVYTUJEMXNHS3o5dThENVpCOUhzTklDM1FWeGZQLzVV?=
 =?utf-8?B?aENVQ1JXRE5QTnY2L0laKzE3RVpPMFQxVHNQcC9ib05DdElHeEF4cExpZlYw?=
 =?utf-8?B?c3hwRWl1NXMxOGpUajlpY21HeVpjYTM5akZpdk5CWXBHVVJ0Z3BUcm5FRlMy?=
 =?utf-8?B?WjlmNUhRdm81cVFmbmRQS3cxNnFRekh4aU5SSXdza3Bxc1JmVVBTdnYrZ3hZ?=
 =?utf-8?B?Z3VjM2hDTWsxVGUzWmM0L1hoSmRkR3J4Uy92QmpFM0kwSjN5bXdmZ2R6VTcv?=
 =?utf-8?B?VzkrZ3hoeTQ1TWdBa0RFTVp3WXdPbXllYXFUMzQ5dU5Ham9BTzloemZyWWs3?=
 =?utf-8?B?aFkwWkV6d2tlalhQeDErV1VkWWhtdE42bDRJejNIbGkwdkY0THozd2ZFSFFi?=
 =?utf-8?B?WUxacTFZNG0vWGQxc2RHUnRQMGJOOWtudDFxR3BQNGFicUNIc2RlZ0Jzd1M0?=
 =?utf-8?B?cVFOOGtzeVlUNENWbTh1NmlUTEZjRTczalRzb0dqVnFYUzRHbXJjM29qdkhy?=
 =?utf-8?B?MjBaUFpTaUxXZDU4dE5tYkRRN25lOVVEQ0Zwb2pSZnNBYjh3KzU2dUIvSkJs?=
 =?utf-8?B?bmV2NStMU3UzR0tVaGo1NDdWeW1qdFI5Q1RPQWJhU2pDaEg0ZlExVjNTaDMw?=
 =?utf-8?B?ckhYREtES3BJOVQ2bGdCWnVBM0dsSm0vNG1FOWdqeCtFZVhab0JNdHRSUkpN?=
 =?utf-8?B?ZDN4TDRicGMwUUgxRkRCekpmT0FDQjRZWHBwc1lsOW9GSTZoOW5ZUUhIMDBo?=
 =?utf-8?B?dDFFTWlNYWxlRjFNUDgzbVdTT1MwQmkrNlNQRmV6SHdPZElkZzJCcEhHU3Rx?=
 =?utf-8?B?dVcxZFRDK2lBaEhzci9IdGpkRjhoNkN5SFZ5TEoxRGJpYmV5dG9WeDluSE9Y?=
 =?utf-8?B?dDdscmhRVzFVdi9PTzZic0VSNHBURDR2YlQ3N2pHZlN1bnRXT2J1b1FWRXlJ?=
 =?utf-8?B?ZWp6ZjNWUE5tbDZMOEhTZEJJaWM3NU93a3lmcU1RZFh6WTlxS3p3Mi82ZXJJ?=
 =?utf-8?B?SDcraEk5bkhFTjZZcDhsWWJKTzZaWlhwZW50OW5hT2NMSmtGd2NUVXJXS0hD?=
 =?utf-8?B?L2tES3JzbmN6djU3aXpoNytoNW1RenhsWlJXUk1aWk5YZ2UwZGJiaEhBWTds?=
 =?utf-8?B?dzkvNEZqTHVORU9zeFlMWnRGS3Y5T1cxeWRIV2J2aDJHRUYxRDZFT1k5VjFJ?=
 =?utf-8?B?ZGcwRFNvYi9BSHhsTVJ6M1lycnJJc3JTWjQzNkZMbnQ2Vm44VEt5MU1UK0oz?=
 =?utf-8?B?ZHcyRFNvMFpxWlVRMmNTRDQ2MjZtVGVQcHB2YTlGMDB1NE5QTWZ2YlBSMUtT?=
 =?utf-8?B?QUJrSVdsUk1obk1xalo4SEVyWFEvSzV5SDZvZ29xQ25vYU1FSy9IN0NkYkl2?=
 =?utf-8?B?aHM5b05RWDYvdXhDWHpEVjh2MWlsdkNQQ2NpaGdqMFFacDhXL1YzWVdEZFlS?=
 =?utf-8?B?cjBSUmlzd1d2ZEJJY1R4dllsczNlTlBYQnhZZys1Sjd4a1RKOXlkdWoyZCth?=
 =?utf-8?B?WExNUjVOejE2ckZzN2dPTVk3M0xQZWJMNXBJeU1EeHkxV1JwRkc1V2Uvd0Ru?=
 =?utf-8?B?dGQwUWhRa2pNQ1BYV2lHbUxzNlAzMVpjYkU2VXNVdnJTSzdjQ0dRNndNSi9Z?=
 =?utf-8?B?TXBYdldidEhTUVBDY0pORVNaM2tYVWMzM1hrWmYvMWZTMmdHMzhES2IyS0RU?=
 =?utf-8?B?a3BYbGdTZnkyQVZaRXJoQTF3NlhKd2dpbmlYblQ5UlRadFNaM3lvbHN2RGZj?=
 =?utf-8?B?UE9wQTFreWN0L0MxMnQyU3ZTdllENElmQnRFTjZWNGYzRVo0RVNFTHE3YVhP?=
 =?utf-8?B?RU5iSmlFTXdvbHEzTnBEdnNleVNlbEZjNytKdGF1alFYb0lWdGRJVHlFQnV0?=
 =?utf-8?B?dmNBMkU0MTE2MjNNR3dDWU90QzRzbEUvM2FlakpPcW9UK0J3YnBqQm9qaHR0?=
 =?utf-8?B?WGxqNmp1b29Qb2RyTkNLRi9LMWE0alFQRDkvU0tTRFMwMG9ETThWcjQ0WUUz?=
 =?utf-8?B?elBPSldwL3hlT0I2NFB1aWdUSnU2cVBNcG5Oak1hS0wzS3VLaXZtcmtMRnRC?=
 =?utf-8?B?Zzg5KzRPNmN3OEZFekFQZkJ5bUJGWHgzNStDZUtkR0ltZTU0bDE0bUdJZ2dM?=
 =?utf-8?B?TUVuMS9jZVRNZnBYc2VGVUlYMldaN0Zwd0xpODNqcEcrTzVhblZvUlBYT011?=
 =?utf-8?B?aU5iclZIVk9YQWo0bDNCaHNSZXBoTGFmTXJ0eWVPRTNkMDRpOVQ5N2tRcUx5?=
 =?utf-8?B?SDI1NnFGcitRMFNTendLRWYyL3lFbUxqazVoMmhmeVd0VmdzRGZVV2hRU2NL?=
 =?utf-8?Q?2nSfy4qDcxK9gbeU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ab31446-d7bb-4b1e-aafb-08da3a2c581c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 06:45:36.2279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W6q+MQwtc4IOdyspKG21HbHkM2nDDpL0/7XRTyKbIO1XbQzoVOLClfwTM1WeUSmRpNrZk4eay08XkyBtkgXBnWbkuMs8ScxIFR1AUwU7d1E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5435
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-20_02:2022-05-19,2022-05-20 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205200049
X-Proofpoint-GUID: GkelnxO-GOf9GFGSnAP6iX4j4cme0CSO
X-Proofpoint-ORIG-GUID: GkelnxO-GOf9GFGSnAP6iX4j4cme0CSO
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Check for if the kcalloc() fails.

Cc: stable@vger.kernel.org
Fixes: 6e977eaa8280 ("nvmem: brcm_nvram: parse NVRAM content into NVMEM cells")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Rafał Miłecki <rafal@milecki.pl>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
v3: Update fixes tag
v2: I don't think anything changed in v2?  Added tags?

 drivers/nvmem/brcm_nvram.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvmem/brcm_nvram.c b/drivers/nvmem/brcm_nvram.c
index 450b927691c3..48bb8c62cbbf 100644
--- a/drivers/nvmem/brcm_nvram.c
+++ b/drivers/nvmem/brcm_nvram.c
@@ -97,6 +97,8 @@ static int brcm_nvram_parse(struct brcm_nvram *priv)
 	len = le32_to_cpu(header.len);
 
 	data = kcalloc(1, len, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
 	memcpy_fromio(data, priv->base, len);
 	data[len - 1] = '\0';
 
-- 
2.21.0
