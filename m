Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBC22692828
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 21:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbjBJUXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 15:23:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233859AbjBJUWr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 15:22:47 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0550583CC3;
        Fri, 10 Feb 2023 12:22:00 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31AI0WOe017288;
        Fri, 10 Feb 2023 20:20:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=VrxY6FEeDrhSrD6bnLrKzJPNvn5vXR3scp2L28Wycvk=;
 b=qNI9wbxLSv7kWMSkpBdey5vfeY1V9skUwsk1UjqgkB+YZa04BuLZmcr1kWe2Dg2J/fNT
 bg61T4bN46ryJISn0MV2CLyVcg0sTjuPxzboK586EH48WHdFSIBqsfOEaR4U/fROfrmh
 0AdtBHsAouYtQde4kv36eUX10tX7wt2n+F0JVGPsIJ91nZPzIM3J1VqbnQMMc9H1bEfp
 9WXFmM8BakFh0e0rXKoQ2VkmxiZMjQ58oSPTy4ynyprJGycyzl8NxNWCQX3fECUMZ1HK
 4Ek5S9epfg2BzKmvFolkbZC0zTJlLk5MLC30K4vNvoINr0ujMZSZ4/hUKP7jdxl786BD lg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhe9np5vf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:20:46 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31AJZVFZ036245;
        Fri, 10 Feb 2023 20:20:44 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2040.outbound.protection.outlook.com [104.47.74.40])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdth2d6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:20:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DoKy2Nthrr4tYEcrHbhtUAr5RMI2Y0UwoXsv/zSLakgqXSZRhrY/GzurSNlrd707KYMtaOi5gLtXoooHG/52zV/LRZlFd1cVsf7k1BipL0YArlLRiO/oKoW/Dh5ratCMYhJiUj9OGMJxkcKv0fsb8oUJZ48HldMpyz/py5mgzdNSvRvsMKHABhx4BmUJUDDq8H8Xdm5b/XS/LnQ+uO0vLhsrtrd3gPAwKqKmFA89uk2MrEFLNGC9+sAjEcIU0iBf18PoMcB8gKJspDWfSCRhFvq9YaK5tnXMkXz54CB9N4Sm0TLhW/zlBI9HCRICdazUbFX2AeyXEcLysnae4E5Ktg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VrxY6FEeDrhSrD6bnLrKzJPNvn5vXR3scp2L28Wycvk=;
 b=IhXNMpsFqSCJMNECsphUzQgxSAlgRbfv+AXiMA8QkXmf1nXquywnV2FMoQUvlA7gKwCJ3o9y+r6KQyQjD4gEMnRPvI2UF/EDa0QRFEvl4nA4+vIkaJeKW8c8Ejao0AnkPHUBN5esL8esBpFSfPqufqKvn6SnjRq6veBTvEPVS4gcj3Fw/k4CJT0m1ZKh8Vp+JWwrfRiGvfaYCRaG3hYF6ad1mh1RqLbyl67WZhYUXnOB603d0HMV9CKmsgdzbmUKEQ/LZXVBSvOyBnXOpBuqm+Ky0RUkt15JJKAtlJLei122/TZlRQYrWe53rNRUpUHktjz6r/SiA/nA91AmgEIarQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VrxY6FEeDrhSrD6bnLrKzJPNvn5vXR3scp2L28Wycvk=;
 b=bvJZY4PcOHkyG3uCh8NZdwMBvjgJvo/xZ+R7pL0PFgriGrouJ0SE/w5TowqvEiCKLtCuVwFLJtZre46QUf/sqGECblBRwSZL6XIQLZSuAaFkQG3moWs1/glW1fm9yhwpX2NeCZKyKpW8yemvV6nz3R+VtKemvHhsHrTGMtz+/7s=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by CO6PR10MB5652.namprd10.prod.outlook.com (2603:10b6:303:135::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 20:20:40 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6111.006; Fri, 10 Feb 2023
 20:20:40 +0000
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Rich Felker <dalias@libc.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Dennis Gilmore <dennis@ausil.us>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Saeger <tom.saeger@oracle.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-riscv@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org
Subject: [PATCH 5.4 v2 2/6] arch: fix broken BuildID for arm64 and riscv
Date:   Fri, 10 Feb 2023 13:20:23 -0700
Message-Id: <20230210-tsaeger-upstream-linux-stable-5-4-v2-2-a56d1e0f5e98@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230210-tsaeger-upstream-linux-stable-5-4-v2-0-a56d1e0f5e98@oracle.com>
References: <20230210-tsaeger-upstream-linux-stable-5-4-v2-0-a56d1e0f5e98@oracle.com>
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.1
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BLAPR03CA0114.namprd03.prod.outlook.com
 (2603:10b6:208:32a::29) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|CO6PR10MB5652:EE_
X-MS-Office365-Filtering-Correlation-Id: 52d07fb7-ddc2-4805-0cb6-08db0ba44745
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ruZKfL6Vg08tBeLdIIsuTdYy+XmEAtrzFfy+gcmCgzIVfwSf87v6604Ix0OUBGCqI+AxkuWEUfoMQpb9myfNIcS++YYssMURP99AXKZf/t1sLsdGdqeULrMYpeoZ6IxL84GrqPrnePqwic+G4Wmo9ahRkdNzdxVEUOKdTcVyz56BozlapQmkZ4i75UejpFFthzqd6HXx9kHrR5e3DlfKzVd2TIbOl3CboBZl4o/MYrhzNxr/ds7l+cs2MbLFv5Vos7oHD/SyNBfsgxhg9OTYURdeJBA862pJHEuPdFXyiZ5WRn3nnp0qOKlW2DAw29dbhLqOcmpIB7zPujBMVz08+B1DfyiMnzCnMmieyuoBbEiPzGJ1CDGSPBqjLqc1ZAEumwwws0NYuNFiBUlv0CiqCP466mKA3qQdYPPdmC60Nf0X+gZQGiYrLsP5k0pYjZDMkiFDWlrIaOWsNLwN6hxAnrUYQm5woU99CXSojnF03KzvJUbYcLKu6XYYTk9SEHh5lgG7ACpzmK1JMzkAZBvwDGtmBRHDLKYVffSTgRhV9HV05u8KLmUtz4VmafGFsuCIuSraWwynx5wpMqIysbD8fBtQLt6Z6xiVumLWHRkeYwIc9fIOSXto2C8QL7YgL9VqR2FW+c1PnwEJ7jGWELqN3PJQ57qpAx2UGemTAQezETw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(396003)(346002)(366004)(39860400002)(451199018)(2906002)(36756003)(966005)(6666004)(6486002)(478600001)(6512007)(86362001)(2616005)(4326008)(83380400001)(6506007)(6916009)(8676002)(66556008)(66946007)(66476007)(7416002)(44832011)(186003)(5660300002)(316002)(38100700002)(8936002)(41300700001)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZHJTdmdlWmQ3UlZwS215c3ljSE9QUmZwUk9yNGRGbkROYmd0bFAreXBLbWY5?=
 =?utf-8?B?bVljUXN1WjdWOUR1TC9qNGhucEVLLzFpMU5XNHRhem9YL0haZVFEQWV0VGF4?=
 =?utf-8?B?S1BuYmJyVzN5N2tKQ3JDUGxyU2Yyci9JTXVETUNvNU5Kenp0bnRqUXg5NEY1?=
 =?utf-8?B?bEx6WWtVYjdHQkhBU2xSWklWZGtqNjhGbSsrcTZCbTRwL0hDKzNGRFVUSUhP?=
 =?utf-8?B?R0FqaWRsRHpqMU9EOThURFhVQ3JPM0w1TlZXZEI1ZjYycVVmSnllamsycFBE?=
 =?utf-8?B?OER5ZzJ3TmlETmJHTjVHRzJVekFKdmpxbkU3b2szQmtRZWRZRVl4WWpjMWM0?=
 =?utf-8?B?Vk5mdGFOWGk5UHhBYmtwa2tlUDFpc3lYUmJLTW5HWDVYa1lpZDZ4bjZvanhi?=
 =?utf-8?B?VHlYVmhBRlpQZ1pPdlNIYkI3cVliSjAxbkhaRWtSNHRyNmthZXdYVE96N0l2?=
 =?utf-8?B?NjgwQzZFUm14cUV3dXFHS3h4RFc1NExNanM2elVXUk5CSWxOTFNaUFY2eGlj?=
 =?utf-8?B?SnlCaVhXVkxUTmtMQ21rQk81R1hCazZHT3o5T3pkSExVMWtOdXRBaEFxeVpD?=
 =?utf-8?B?ckhxWkk3d3lBTklTMFZqaUoySmZoTG9lMTA1bGpXSThtdUhNWWZMdWlOdUJF?=
 =?utf-8?B?VVBFSFBaMWFqc2lwc3IvVUliTUdoNVZTUTRqWVA4MGJDY1VVcHczaW0wM21Y?=
 =?utf-8?B?VzF3Y2dIcU1uMTEweFh5K0dqVVEvcndiYzR0bHhrWjBxaVJYSkdoeUdtQjdn?=
 =?utf-8?B?WFJHR2F2MXhrN1YzK3lhdXY5dWdPejNvLytidVpyaG9QWGUycmpvK3ArTFZv?=
 =?utf-8?B?ZFNoZXVpQWdqanU2U1JVNGFQWlViNEJzdWF3a25oVkJTL2NUQk12c0crZjBF?=
 =?utf-8?B?TVRxTVp6bFhHWnhCK2RmZnNQSzQxNTBhZ3MzZXk3ekM1SFNaNWNVQmNtV2xq?=
 =?utf-8?B?MjF3UTJsZGMzMXEvTHpyeExQdFJoN2F3ZGpNYlM2QzNnU1hvOUhldWhjL0NR?=
 =?utf-8?B?QU1kNFo3Sk0rSU5FSVVRMFkzZExVbGlEK29RMDhwZHJNNWhQNXFySmM5MGEz?=
 =?utf-8?B?UGR0NXhlcFZvZ25sMU5ucVVJTXJ6WkNLSzBZcnZ1S2V0K2tNcW5zaU1VcFdZ?=
 =?utf-8?B?OGZDY044dEt3UDhWNWE0TEZodjRidDJ2WWxFMUcyZmVFUzhYTlpjS080aFlw?=
 =?utf-8?B?YWlJellQWFBXOUtRTjc2aE1NUWU3MzF4U241dVdxcCtONmV3NWlybS9OOFQ4?=
 =?utf-8?B?M1hDb0x6K1AxdWMyVTI5R1gwdER6Y3RsUzU1VWh4R3lPMXJqUmdwR1FlY05D?=
 =?utf-8?B?bDV2TUduSlZjUHBUVHNOUVNUOUpYdjBKRk1YL2NQVkU4L0hQQVFYME1wUG5n?=
 =?utf-8?B?eC84dTlGOU1WT3ZzNW5Pd1AxMkdKVTdjdHVmeFNmZWc5YWhvMlp3TWJEc3Fl?=
 =?utf-8?B?Sk5obnhSMmZJQThTNEF1d1hlTzY0NnIyVnllS0dJQmRkdjBLOHdqMVB6cVJ2?=
 =?utf-8?B?NjZ6LzFqbVVudUQwanByR2M5Z3M4cUFaM2xLMytxM3UvQ3Q2R3FoWjhNcThW?=
 =?utf-8?B?Vkk3ZGcxM3JJQklqdm5wZTZhL1FhUVBOTDV5eE5DeDRtd0tzUHRGUWxRYWEy?=
 =?utf-8?B?c0llT3EyYi9hMVpWSlMwdWhJb2tLcHM0RlRURjNtK21WNXZsbXIvTzc3WTJa?=
 =?utf-8?B?NzR3YkN5WldtMHBySXZ4L0tHUDl5cC8xMWQyK0xGRzFaVWNXNGpIUnJRdHdS?=
 =?utf-8?B?NmhkL0psanNRZUVnWHdoSGxpV3FkaWNCUUNqeDB4empYL0tQU0NSREc2WEli?=
 =?utf-8?B?YUhUSlJqN3A0SytTZGNRTlhQYnY5Y0pnSnF1cGF2WGlIa2d6VzZFejlRZGoz?=
 =?utf-8?B?emtXUzF4VVFWMHJMTk83dS91WDhhL2h2YmYzZGxKQWlRWmwybm84bHVRRmdQ?=
 =?utf-8?B?aGJ4NzJwVmdkd3dDL0w1dk5yMWtMaytCMTBqbk5jOWt4L3lGbkpyYzZpQS9F?=
 =?utf-8?B?K0QwT3dtallUZW5LVXJ6YW90RUFtU3FtV2p5UFo1QW1tQXU3VUd1WkU2c1pI?=
 =?utf-8?B?TlVPb2dzREh6YVprWTZuNGRGTXlVeVNPSVFzd3JHcXBlaFZaT3RWenprS0xL?=
 =?utf-8?B?RTE0bEZMWk96TWthdEsvN0lMV21CYzZiWDd4ZWRSZ3dlR1VEYlJMVUgrNGxK?=
 =?utf-8?Q?kO9PEPzaY72FdopwNGEYbZI=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?b3gwaWFST2xyTXU4UlMzbzN5aFJScXIzQTFiTkhPNlBIeENyWnUrQml3dzRv?=
 =?utf-8?B?TzdBcS91SmVBeDExRlZ0SzM2WGUyb29aa3ZWRmc3T1JzSzQ4WmFYZXMyZlE1?=
 =?utf-8?B?cUpwWEhTb2FJd05ZeEFoMUhkVitwbFVqL29Wa3JvU0RjK29ML3p4c0dQUFg0?=
 =?utf-8?B?blZTVXY2aEk2MmN6WHJtS3krdis3R3ZqT0VLTHdvQkRUQ2tHMHVta21MQzAw?=
 =?utf-8?B?L3gxL1FMSFhvS1lYcVByNmJLL2FGdkFjc0dqZDBlRFBJOERuZ0ltaEtVVnpo?=
 =?utf-8?B?eFIvcHB4OVpxd0JhQWVwNEVTUDRjMElQKzdjVU9ITmI4Y2t2UWtub1dPd2hZ?=
 =?utf-8?B?K2RXU0Rhc1pEbDM5THYrUnZnUDk4eTErUHdFS1N4Z1JESElwUEZhZndhbzJG?=
 =?utf-8?B?cWN3M1Zqam9sTnJXWGkrS20xUVd6c3NkK3lIeTExMTdLaldFMVdYQW9jZ1cv?=
 =?utf-8?B?ZXYyQWVYNWZVSjVydk1TeDAySkw1S3dGeUd6MUtOUFF2U0tQRWl1VUpqa3Zm?=
 =?utf-8?B?dTRLUzBsdnJWb0hPbTY5dk9Hemc0VlVPT09ubWV4ekxTSE1aY1ExYXQ3a2pD?=
 =?utf-8?B?TkQ4eldDb21TSlg0ankrc3kxYUo4L0s0VEFlQTJCcTdVTXBuU0k4YU1SWmFx?=
 =?utf-8?B?UWRZY1dPSkQ2WFA1Zkl1QWdFRXJjdlpHLzh4UlpSS1VJWHZ4Njg5dFROSlFS?=
 =?utf-8?B?VC9XRUFGb0R6ZTdidllFR0FkR3p6YjJTVnJqalYrclRlZzdwcTFRbWlJemxI?=
 =?utf-8?B?M0ZzMEYwbm5WOVloV0ZtQlh6UUY5WUpkYnJ1L2ZlMXc4UkJla1I1T3pRbndu?=
 =?utf-8?B?dmRSdFNlMUhKR1ZpUjkzTnI0Yk9qQjE3bXVaQ3dQM1gzaU1LTThycXdOamM0?=
 =?utf-8?B?cW5hbUMwaFNDbGg4eW9vYjBNdDlPZzlzdXRCcG5TZnFPZVBRU0xJQzlod3pD?=
 =?utf-8?B?Z0tuMnYrK1luZHJPby9BSnpVTmVETFZlSjhnN21WSjgweW1QajIvV2ZLT08v?=
 =?utf-8?B?RWprcDdQQ0t0UWxESXdKM2FpeGZXMG0xM2d1WGtQRHlRSjdqZG9WeldVRFFN?=
 =?utf-8?B?dTAyUWZsMGVwV2xtNXp1UDNVendRKzV6d283bTMzdlRUOWV4c00zVjR6TUJs?=
 =?utf-8?B?UWhxZnVkMWE4TGdFR0F6N0hzeS9XVTVkLzF3TjBaeXpGTUZ6T1VObDZxY1pF?=
 =?utf-8?B?WWppS0pNS3ZyMjhvR1lReTVVTXBKY2tncEJjdVNDeFNzU3FaKzVuL0tCSjZ5?=
 =?utf-8?B?aXlucnRiRE8zZFM1Zk5IKzZMcjIrUStZbE04blV4Mm5rQ1gzWDc4UEFKTkdK?=
 =?utf-8?B?bGQ3cXlLeW9YRnhjU0M1YXJCK1dvWksvN3phT1l6V2pSSkxaRE8zQWx4NUxH?=
 =?utf-8?B?UWlGejJPbG05K09LLy9GUEYrbjByRmhhOVA0YmRwbkdpS1J4cGpOZk1jQ1lX?=
 =?utf-8?B?azM1UXM2UEt5R1dQdk9aSFNVcmtwUFJkYXp1QmlKY2RIN3VLWVgyZzJ4ZHRY?=
 =?utf-8?B?cnZEaGo2RlZhY2xsTTUxVW5Tb29hL2w4Y05KYzNnTUJ6NWVnTlF1THBzY3c4?=
 =?utf-8?Q?V2CV+Fu8QM3eJN/YAfKOgQXv9w91bNnjtBGgiVLbbarJWi?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52d07fb7-ddc2-4805-0cb6-08db0ba44745
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 20:20:40.3337
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UAjtaVZI8Za08TwmF6Ht0kSGyZQWL714modtBainm9TwXKIDyxxUugDIT5cPfKNpixW3jcr5b57K1SX0cRISMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5652
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_15,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 adultscore=0
 malwarescore=0 mlxscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302100173
X-Proofpoint-ORIG-GUID: EyXU24meCM88HAVzdZNV_09UdtD1bkia
X-Proofpoint-GUID: EyXU24meCM88HAVzdZNV_09UdtD1bkia
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
2.39.1

