Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB73F6A794E
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 03:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbjCBCHa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 21:07:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbjCBCH2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 21:07:28 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8704C51FB0
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:07:27 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 321NRc0M029067;
        Thu, 2 Mar 2023 02:07:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=XVsiiaGbigWGx6drx1tO7xR5U/0/S3ReKqvY9p81Amo=;
 b=mSt4ALxSgow3tGmiropHBOpCcjgBxjZ95IY+K7a+2doWvGWoPUzfSeUs2WnHL0lEEOSR
 feBqRNtkBFCEsqaCvHSfBfyG2Mbc03YTZrfZsbbgKUuBuQiknXculTVFMjRfTZkXUYHX
 8YZhGKPWxi7kDwnVTaCgUuhSvgm/PWUV4/P9el800x3K74Ke+ozeUovwog/smQjA2SED
 kBvSxdOczMdASIfEqmXN2X28osiCtiFptacd2Av9j0fS9A7JiRMdiIDEpMepbFrOv0J6
 KiW/ECXjWy11ST88KFaet6B47j/X6XOE6gANaZXRumqeVNQtZmPCzCPFCbjJS/PMFwcI cA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nyb6ejfnw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Mar 2023 02:07:21 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3220jtoB001019;
        Thu, 2 Mar 2023 02:07:21 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ny8s94hhn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Mar 2023 02:07:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WIiNJhXEAW+OEYjI28PQ1nydv5huWtyrimHmhBpibKtx4rwrkZ8inhqgdeRtOKCljN66eUfohyssRam56UXcoWfwBmFrGTO6BRgWbaUtN31kVAj7a+zlZ6U1fZXOKyBJKnw8lvhcKpuRWRZS57xwcXxI7RAkn7a2AcRQyU6/5fY9EkXhVNf0pNkg3c+cc8Nzbx99J2MKIB3i9Wi2fBffKO4lGOzq32YOFh6qQ55E8EgO3F3nWqNLKoZRK7Xjb8U7ieNCN60VFP52QkpO7JvZCay6cfnemFJ+0a/Qsm5patabuyTA23+zUs79/O8RO+YXfYHHbM6wWAzVxjMMADugdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XVsiiaGbigWGx6drx1tO7xR5U/0/S3ReKqvY9p81Amo=;
 b=C7YrGOmfRbArtgdsVDF75rk96ZcvkqWcKBCXrRrGrkmT9Xjc/bHzSJt8/tBlw7cu1b9Z/XC9mU9K3VOiQasPOsLtUTTZAyaKi5ETlkh5yWUHfTav+HWF2qWFC5G1cXmADEkuD3BD9QzCuAhT1bh+6msLuhunoZQSOLtbOGwhiOKCiCDobGN960e037s7Uz7kWE+qiQI2AHycmo9dHz5wUG0Nik3m5xLxob/SJy+IbPBD3jac3M+EZo5Mmf8V4dt/+TeWUEpaBkwoxuD6DUDMDvT///VdgrrGObSVeI2nC0cZ69YUHX8kt1kWQc+YLGgoSc0lqamD+0iyb7djhnRHIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XVsiiaGbigWGx6drx1tO7xR5U/0/S3ReKqvY9p81Amo=;
 b=RV5y1oxctYxpAkUURVDZCxLaV9snm9dkzXn7OnhzPMYyGOl/zmew2wUDUCjy3xUEQyInymS4YV2NldIhUFMe25njUwkO2KxwlTBkxMZuxe8xRejzajwTl/I26cpNwlf9WaoP7vpr5e5/btuGRy7F+E8B0taSbJmnP0HVrAdvbCc=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by DM6PR10MB4284.namprd10.prod.outlook.com (2603:10b6:5:21f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.19; Thu, 2 Mar
 2023 02:07:18 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f%3]) with mapi id 15.20.6156.018; Thu, 2 Mar 2023
 02:07:18 +0000
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Tom Saeger <tom.saeger@oracle.com>, stable@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Dennis Gilmore <dennis@ausil.us>,
        Ard Biesheuvel <ardb@kernel.org>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.4 v3 2/6] arch: fix broken BuildID for arm64 and riscv
Date:   Wed,  1 Mar 2023 19:07:00 -0700
Message-Id: <20230210-tsaeger-upstream-linux-stable-5-4-v3-2-122fc5440d4c@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230210-tsaeger-upstream-linux-stable-5-4-v3-0-122fc5440d4c@oracle.com>
References: <20230210-tsaeger-upstream-linux-stable-5-4-v3-0-122fc5440d4c@oracle.com>
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.1
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0140.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::25) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|DM6PR10MB4284:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a8e458f-ff09-4c0d-6e4e-08db1ac2d9a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lo2Q19ZWSJi8rc3zA1xYpzzeBrPvuDM2tjkYcqKeFx+DkmKuughiPuYmWN2dyqT7TNuT0PKlHk3XYpDp2CXXmCuENvxJQ12wkX/HU/Fc+Oq81zgGApWGUZWLwxEmQaQuQtmh/VHiXOp5mUpGoDs8esDkBWtQVRtFxZMQNvSi+aYTjbJhP55aF47jU3C7yJe19tW60rC1qyY1mThGiIeFyaF9oikzNVdpwcQ4XC1SVUoBEIpoUC6VCIty9X+DojaRwtdtunPn8Qi5oJvuH2M1Uo3GvEtSAnWGXSEwE5YwqGm3qlZOdNn15JnKbFU5CuNpfjIfEDg8QboRuOBCK4tjZwTqUuD5pLJKyi5+k8qemiS+ccnfNUcsVpy12WitZ0LRtCTU55PdkCNdNH4ld8zbpffFe34f46p9VA41zArpXvTI3NjLwzQaC05Pg+GqAdSyxaA2ntA8IJChMIFrHFor8F6Y0oPZkWiEWmfo/IhtC2xbyJbWs3ZmombefTpdlpLXFUVENW98FhPN+2jQNYWKOmAIO2Tfc7mynRb3VsGaeRMA4phhHPZj0FeL4ftNbXYlOaLUxEsZMj67cGSFiCofCp7HsGXr9NDdZxu+IK0HPHX/qPDe+fCbClTYPXZZGXkDXwlbSGI6NV4EcB6DgyVBZan7n7kfzb69fojgb7IxnPw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(136003)(366004)(346002)(396003)(451199018)(5660300002)(44832011)(83380400001)(41300700001)(4326008)(6916009)(66476007)(66556008)(8676002)(8936002)(66946007)(316002)(54906003)(38100700002)(966005)(36756003)(2906002)(6486002)(6512007)(86362001)(6506007)(26005)(186003)(6666004)(478600001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UFlMQ2liZ3JaWDhTR0JiejlKODJYcGJMMDVlSFkrQUpwbnpvYUI1UFZZUmFH?=
 =?utf-8?B?TmhhSU1QUkZ4UE9RaTgwRUttVmYvK0sxcS82MDA3RnovZHdrZHdqU1hxcVps?=
 =?utf-8?B?MU9WZDJ4Rk8rT2piZHRpWTRueXBHUlFIYjBpYjNQOEVBMnVQZUJ6bzAxS0d6?=
 =?utf-8?B?RVZvRzdnZlh0M29qSndiSjhKcG5GNjNnZTlkajdNN3BqRFZlRU5Qd284a2Nn?=
 =?utf-8?B?aUtheHVaMUE2YXUxdkhrbTBrVno1NDNpbjRLejFTdUNNK0JUWXo5OEwrU1cy?=
 =?utf-8?B?eXFXTmZxaDdTaUNFcFVTdW82UXlTL3o3a2k1NzVZTFFQR2l2WFFFSmxkUUQ3?=
 =?utf-8?B?R2l1R2M2L3VscXJFMkxSZ09wK2VoSzl4N0ZwZ09yVWliOFBZZmJ4UWVQQzhk?=
 =?utf-8?B?RXIvMHVZaEttcDVsbjZ1YjIrbTdKck1VSGVTTFMxOWVJVEFFZWxGVFVGdERk?=
 =?utf-8?B?SENlQkpwTzdib0lXaGxIR3p5UkFKQkFzZ055NDVVVEhwZkRTdVo3Y3NEUGZs?=
 =?utf-8?B?aCtBNUpOb2tXVzlMYlhUb3c2VFl3S1NEb1NpczNvS2FhMHE5blNmMHZUckRw?=
 =?utf-8?B?MzdHQzB3dXVUNEtlK1k5MUZpbHB6K0x0QXJteE5PZEZSZXZmVkZhN1ZveHRx?=
 =?utf-8?B?ZjIremxBZXdyb3U3Mlk5azFOL0hsRHJOVXNrQ1FqK0hIUXVZRTlMeVp4cFQ3?=
 =?utf-8?B?MXZxaVFFMURsSm4wbkhyYWRUNUZVbmlSZXRzdHJqR0NoZjdYNFNGYWJNeGJr?=
 =?utf-8?B?R1Y4eG05N1hPcDVQeWNyZ2E4YnFEVWxQTDV5VngrSjV2TEtUeXN0T2lHNW5q?=
 =?utf-8?B?RWZrT253cm4xaHl0Uk9mbmQvS0gzRlpMMDk0RjlERThJcUp2ZlFFNGl4ZWV2?=
 =?utf-8?B?RWE0V2tJeUMyWUJRb3A5N1VJYlp5YkdKemlBRmlId2R0MkEvaVUwUnpld3A4?=
 =?utf-8?B?ZUdRd3BUQXF3a042bTB6VGh0NEJHNzNuTHQ4OHBNNG8reXBXZG9rWFFadURY?=
 =?utf-8?B?MW9rUkJWdEJsbU5temFXVjhrUVdyY1lYNGNXL0F2cDduRGRaV3kwTEx4SE9m?=
 =?utf-8?B?ZlNIUlJIWFFtalBqem50YktyTVJ4eG1VSmdoMGYxOFBvSkxUR3BEeGk5Yk9T?=
 =?utf-8?B?UUo3SGVRWDNWWFJZbXE2Sy9WS1U3QjBhVnNLZnJQS3hjMStYbkFEaEtUeE1V?=
 =?utf-8?B?MjVCRWVvRDZub2VLSDdhTjBxM2N4NVNmeHhPdTNwZklON3lNR2hsMUplT2FU?=
 =?utf-8?B?bnc1K1RGVENuQXJNWWovR0xDU1VCS1BoM0tFb01SK012YllpdHlxNWhuZDVN?=
 =?utf-8?B?Z08zd0tNR0lxckhlMXdldVFKTlBSTDFoU0VuTEVyS2lGZjd5VTZHMkpvUnZi?=
 =?utf-8?B?cGZvQXdPM2dYRStLMlUweTBkQ0hvYithU2luWUhsTlh6MUJ0d2dPcm1ET3dv?=
 =?utf-8?B?SW5pTmxOb2I0QzNPV0pTemJrYVQybW1sRnhGRlY5cGJ3bGVyWHgyK3V5UEdU?=
 =?utf-8?B?YkgycGlJdTVqK3ZKUkszejN5V1hwSHp3elliNUlnRzh6L0ErcHVMTm9Hd1A0?=
 =?utf-8?B?N3VQSGZYZ2k4ZmlkSlQrK1FueXplSDExUENTVktNSWFMekJuZXBZYWpkZ2Uv?=
 =?utf-8?B?TmExZVQyaU1OTVZUWFVLbG8xdGpwejVYcmRSeFFzWWFDSFNwbFRnYTlIcHBV?=
 =?utf-8?B?WFBMNjUvRkQyWksxUmJVSm1Pc1JTQmpFRExwTm8yZS9lRWhOMDBHZ0NRVCtF?=
 =?utf-8?B?UmN0NE5VcG1HWlBuNWh6WXJ6bGJyUEwzNGE0dWFIL0liZ0k5aDZPZDFqWHNi?=
 =?utf-8?B?SElBM216OHJleGMwSmNOL2ZKLzQvQ0o5TzJ2T2JiRGJhMUh6TnVndEthRjdT?=
 =?utf-8?B?S0NEVFNCbjJNcVZkRGdLeEZ2VmtqT2VCQm0yaGwyWXB0ZkxBdmhPUkZzRXdU?=
 =?utf-8?B?WWNWcy9LOVE5am1Rb2tUTkN4Z3VwSWNQM3J2bDB2Z0hyRlMvVzU0QSs3eGtF?=
 =?utf-8?B?WlB3RGU2VTdhZFVEZWhYcTRFcU1kdjdkNytZMGVRY08vRnV6Ym9UclZOZTVp?=
 =?utf-8?B?V1BtbnladHUxM1V2Tkg3TDdsbnAzZ2VzS0tPa0xKK0lMOGcxRVdOaXpDeUc3?=
 =?utf-8?B?czNoSFAyYlhiUElhei9RQ3NZQVhVQVJJY1VpRjg1VWIrK2RDRU5FZko5RlpP?=
 =?utf-8?B?akE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: AGMd81mPWELIffCHx2aeee0UiYwlUwvUPqCYLfBG4vAq/5Q6PvdDd5StRVlSy3rscAf6SzShUTYSjs8QP/4AUj3aJjvGVvlpHoO4QS1EKk1CkM3PJp8oqUKkIjL7oTJpYVbx4yWBaBD0yiPu4UR4zcpCD1RwPEiaHEEi3YqGnOznMuojy8LwEUnnLb2yMPS8VtRdttRnd7HvFQOawUo3+Vi4CFjwVuF0z8cSY+h/xF3OsjH2BUD76dlx9X5S4TGLk0xSZM22FgWJpEf5EyoMrA8Zr4srQ+TxTAbkifkZKxWcU43Ayy1cOVl3hGcXYGBM2122TKPbnmCHZ/Xoo2Oyh6T9ZVEWfAJ2yARzYIMj9kxFEthlPVCleWhVdY5YGCzvZM7//y6I+T3WNH6F8rt+5FlGHBW71tMZbZHz/3syKV7Fo2B4RziuhGG5veTkhO1rGUOPJvGrjucH9c/Ah9Wvd8+jTF1Jn1eTa6JyF/aDkjejHDfOFoVzk5zC7l5dqeWiDRzKjMlzbSE9oxPCVpMDqzIXGcRvfxfaNejN99wvzIQF8OhqtJ5Y+3r53pptnjaPxmgnsqjD5L/KPwqt7g/x+SK6IuwSX0548MTmHJMSnKD1idZphwQ9qsug3AiFczgg9+swxrxGOKcr96WjxqtRfP8ZEYbrtw4N0dPEpv6lbM8hZrm2ZYK1CpsLYD82OYWQ4NBS3qpjeXsAM1gdJvTrDvj+7sNJ3SMyCiUC0LelOudgtDKoixklrc9tUHLoj4o1AOxu3RwR7+6JOLbYZYDbhlH6QohP55yNu4A7uhfdsjycRsxEN+g/X1fkKVoA5YWbYXG/Q2cIXrz8bkV+ke0oMtc5j1OkAqWLqXP5GPmb2LRjl0jENhWJvVAmPoQUHt+8yYxm1BLxfJBPc9msXJAz0w==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a8e458f-ff09-4c0d-6e4e-08db1ac2d9a8
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2023 02:07:18.2447
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BdXNo9BbRbi62suxqyHqiKZ6qHW46nYvNaEkRcuer7VqxTpc85475/R4kMMH0TXs/9a1dq1CwF9Rnu+RSpAj0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4284
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-01_17,2023-03-01_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303020015
X-Proofpoint-ORIG-GUID: x4jS7VVRyMmJCtAC92LrOnV9Jgsvp0_8
X-Proofpoint-GUID: x4jS7VVRyMmJCtAC92LrOnV9Jgsvp0_8
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

commit 99cb0d917ffa1ab628bb67364ca9b162c07699b1 upstream.

Dennis Gilmore reports that the BuildID is missing in the arm64 vmlinux
since commit 994b7ac1697b ("arm64: remove special treatment for the
link order of head.o").

The issue is that the type of .notes section, which contains the BuildID,
changed from NOTES to PROGBITS.

Ard Biesheuvel figured out that whichever object gets linked first gets
to decide the type of a section. The PROGBITS type is the result of the
compiler emitting .note.GNU-stack as PROGBITS rather than NOTE.

While Ard provided a fix for arm64, I want to fix this globally because
the same issue is happening on riscv since commit 2348e6bf4421 ("riscv:
remove special treatment for the link order of head.o"). This problem
will happen in general for other architectures if they start to drop
unneeded entries from scripts/head-object-list.txt.

Discard .note.GNU-stack in include/asm-generic/vmlinux.lds.h.

Link: https://lore.kernel.org/lkml/CAABkxwuQoz1CTbyb57n0ZX65eSYiTonFCU8-LCQc=74D=xE=rA@mail.gmail.com/
Fixes: 994b7ac1697b ("arm64: remove special treatment for the link order of head.o")
Fixes: 2348e6bf4421 ("riscv: remove special treatment for the link order of head.o")
Reported-by: Dennis Gilmore <dennis@ausil.us>
Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
[Tom: stable backport 5.15.y, 5.10.y, 5.4.y]

Though the above "Fixes:" commits are not in this kernel, the conditions
which lead to a missing Build ID in arm64 vmlinux are similar.

Evidence points to these conditions:
1. ld version > 2.36 (exact binutils commit documented in a494398bde27)
2. first object which gets linked (head.o) has a PROGBITS .note.GNU-stack segment

These conditions can be observed when:
- 5.15.60+ OR 5.10.136+ OR 5.4.210+
- AND ld version > 2.36
- AND arch=arm64
- AND CONFIG_MODVERSIONS=y

There are notable differences in the vmlinux elf files produced
before(bad) and after(good) applying this series.

Good: p_type:PT_NOTE segment exists.
 Bad: p_type:PT_NOTE segment is missing.

Good: sh_name_str:.notes section has sh_type:SHT_NOTE
 Bad: sh_name_str:.notes section has sh_type:SHT_PROGBITS

`readelf -n` (as of v2.40) searches for Build Id
by processing only the very first note in sh_type:SHT_NOTE sections.

This was previously bisected to the stable backport of 0d362be5b142.
Follow-up experiments were discussed here: https://lore.kernel.org/all/20221221235413.xaisboqmr7dkqwn6@oracle.com/
which strongly hints at condition 2.
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
---
 include/asm-generic/vmlinux.lds.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 2d45d98773e2..a68535f36d13 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -825,7 +825,12 @@
 #define TRACEDATA
 #endif
 
+/*
+ * Discard .note.GNU-stack, which is emitted as PROGBITS by the compiler.
+ * Otherwise, the type of .notes section would become PROGBITS instead of NOTES.
+ */
 #define NOTES								\
+	/DISCARD/ : { *(.note.GNU-stack) }				\
 	.notes : AT(ADDR(.notes) - LOAD_OFFSET) {			\
 		__start_notes = .;					\
 		KEEP(*(.note.*))					\

-- 
2.39.2

