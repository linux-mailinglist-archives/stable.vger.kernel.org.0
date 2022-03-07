Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C332F4CF3C1
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 09:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbiCGIhG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 03:37:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233599AbiCGIhG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 03:37:06 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73F5D205E3
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 00:36:12 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2275iDEb010192
        for <stable@vger.kernel.org>; Mon, 7 Mar 2022 08:36:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 to : from : subject : content-type : content-transfer-encoding :
 mime-version; s=corp-2021-07-09;
 bh=79nSwkUGlm0KOOaaWnQ8Dk6yiScMlEoGfTNSNR2arKc=;
 b=wc4Fg4NUUNHBVPIitvh2N62PxOIi1zfC0/fLI3IG8bVUm7OXMFOfa+fZFqwCfcKjh6Kk
 e+tKfISBoRbNAXmovS1Y3mni1CgeKSk5KzTtocQ8GEaPZ5qB4TezojBdHGIWUPscoIt9
 rk95m+otoklJ+nQyhi9phbbTfmCmmz0oZgFIYfMPVGjQ1mkOM33X+/qoI4unqzezlT/6
 lbNs/sBvKMdkb3w0RzepNHcjRMRbgkKaUaiuoY9qoIBgo3b2JOhZlGHgtS5IvbO6gLV5
 2T0ZM6irkqX2L2OPAJENLxJmb/k/RqAjsfqlcjrP4g4/mSVATBO4nS+Ly5pur+PKyt45 eA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekx9cb1b1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <stable@vger.kernel.org>; Mon, 07 Mar 2022 08:36:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2278H5Te112738
        for <stable@vger.kernel.org>; Mon, 7 Mar 2022 08:36:10 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by aserp3020.oracle.com with ESMTP id 3ekyp0v64p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <stable@vger.kernel.org>; Mon, 07 Mar 2022 08:36:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MLj4huTpgoyOxvLGAVZ2G3VQYQcHZ7Llwz3BpsY05+4F8CE9hzI/XvINBS2Z7XjKIoxiWC3J39ict4/vWQ/laeO3MJss66POxTKRh5udRDKb225KcDh87DbDR4zvyc79AcGtUAmFXyapGs4OZrw99OuNR7HlPegPjJwrNrlACpJm0/F5GFdhnzgbRQomQuRasUudEt7Wm42Ya0MNkzFZ93schyQNNJsp3MVwDmnWxfzeAQJHjKQYSky4xOBgyzDPh5MF8UW0u2/1SynEMfCDxxKzOzbXoUJ8x7Qfn+ipK7q4vRPIdLBxU2Wu3EwRFj6vGI6VL/zGmk8OnTxBy6AVng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=79nSwkUGlm0KOOaaWnQ8Dk6yiScMlEoGfTNSNR2arKc=;
 b=Rd1gGqQm+DKktGuAC9fT8l4909YiqmUOJkE0YqRcTs/TjWuqCV6ksG4j+QFxD7rKSoVofBHWraF5w4dNpkvTqo4DW7XzTsobKI5i9yBtTAvbL8GeUSWL+XPbjqeHiZx6AnV3xcGbEsk8zdpHEFvuIGYGkPj4ENOrVBP7HtmLyDYF9r+gh4Oqv6bT8maUDJrGrm1aSQ56E87rr5gMNvxvxWKFzB7f6IhQ2UWctCrlUQPRuSR27P3A/IlNuMwWwfUS96iEMfGCckRbw0OQsnxPiOskKi/LOhdeBa/9rGWnexeLf8ZGYPra0MU8rrumqpRYbj8Eemp+bT4PqKboOV9/TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=79nSwkUGlm0KOOaaWnQ8Dk6yiScMlEoGfTNSNR2arKc=;
 b=GkK4QlAKITk7n+4kWKlun+rhYAVq7BY8NRM4AvJrs7oOQWMSK9sQ+ObJqg2XXW/QnOiohkA7mT2Emmf7fRz7w1ZriOc1HDd0c4i7cIin94a6x4GwREyZ93KCQEVPH2QlQr0rS5qsI8LA1ENjOjCpeOlRbBJwMQrrioGHvvHHGt4=
Received: from DS7PR10MB4958.namprd10.prod.outlook.com (2603:10b6:5:3a6::14)
 by BY5PR10MB4324.namprd10.prod.outlook.com (2603:10b6:a03:205::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.13; Mon, 7 Mar
 2022 08:36:09 +0000
Received: from DS7PR10MB4958.namprd10.prod.outlook.com
 ([fe80::4015:f479:5194:d12d]) by DS7PR10MB4958.namprd10.prod.outlook.com
 ([fe80::4015:f479:5194:d12d%5]) with mapi id 15.20.5038.027; Mon, 7 Mar 2022
 08:36:09 +0000
Message-ID: <77220306-bc8c-92f8-e5f9-8d8a7120d6e0@oracle.com>
Date:   Mon, 7 Mar 2022 09:36:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     stable@vger.kernel.org
From:   Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
Subject: Request to have commits applied to stable/4.14
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: OL1P279CA0063.NORP279.PROD.OUTLOOK.COM
 (2603:10a6:e10:15::14) To DS7PR10MB4958.namprd10.prod.outlook.com
 (2603:10b6:5:3a6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 79ed2253-f2a7-407d-32a5-08da00158717
X-MS-TrafficTypeDiagnostic: BY5PR10MB4324:EE_
X-Microsoft-Antispam-PRVS: <BY5PR10MB4324DD04F988242B3A3BB347D8089@BY5PR10MB4324.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Es4j70bTtqkjZyCPT7/Zn+hWV36Dq6N3uJlp2pWt3siTwruY+ns7/ntqBzzKK2js+iy/4zySS2UQN06ldghuk8I4COigJ7Bu7DyR8EQQq751u7Hlgo90oabBGOVnuAEtsGUm7OMoR2eULgxTIoL3kwQyrntfxKkPb6gbPHjVErVEv7uRPsK10rsFTXXgrwWfOCsZl9teSTPQZL5uQmoHjOPPEiT3lMwvor9RB99LhzmGQTtYHTsEybsJOwqCMrolZmeeTUG8LHgNnb7TOtl+UljVvJeKoQfCiN8RjQ8o302eZtSVaxjljf1uE9RRaZ5BLWbTaLYO1QEiyP784YbT2lkm4Tm618biu0B5H2kmiQeSdeGHSn4EjgPTqkUk8R57ots/sLbXkLnlRZ0KlPcbz+HyNTXzkbQvPYJaggQBG1XXvhRdtTA9VwR+oQTLUOBLHi+gS/Up8uMddbODRb5/rDb5WL3ySJG4IWtlaRGVD7IGaZI5YupmL6coUSEaNEnpdrIBUign4N0I9tX7PJyv/saPPH91flI+PwIc4ami8AC6sU0h/jGXuz3CH0ABrtvu8o+My5ZFmV/R8hSI1nOBn/NOgcawQabNe36Y+SVWMZt85Wif8QMbbQvdSQLrc3v/y6PAkVL/tzwBhwoBEmeD1PXDM2dyFM3sapodjhrmmGWfZM8k7iv7NcbGUK3y3wDhpjMPyJC2+xphFBwadhL5rkWNZRgjlv58P0kWlqvUDnU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB4958.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(36756003)(6506007)(2616005)(31686004)(2906002)(83380400001)(5660300002)(316002)(26005)(66946007)(66556008)(6512007)(8936002)(4744005)(31696002)(6486002)(86362001)(186003)(6916009)(6666004)(8676002)(508600001)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WTJKRWV5bUlNT1cxQUtja1pLRWpsTmw0MUZzdFlGYUwwOW1pRXFxdUM5c1lK?=
 =?utf-8?B?RXVPQ3NKVlFOYkV0a0xyUWlxVVBoRnZoMUFmOFJjdVNFNWRkSGczMSsydXg1?=
 =?utf-8?B?Ym5wNDRFdUZwT3Q5Z05zYXhScFBPYk1BRDY0b3JCbUFYNlgwZlc4SU5ZWU42?=
 =?utf-8?B?NThZN3BIalBBblFGWHE3cm1pNEpvSGsyMXpSNjZZSE00dGpWeWMwSkJZR29O?=
 =?utf-8?B?endMZmI2OFFWVktSSy9RUHpReE9ndFlmelQ2MzNDdHNUSHZCdUcySmF4aDMw?=
 =?utf-8?B?ck1tU1R4SGF0ZXVKNEExeDVJc1l0dnBoY2RoSEN2YnJ1YTlBWlErVkdkMG1y?=
 =?utf-8?B?RlFOV0NLQkpVTFZNV0ozZkRDUDd0WjNUYmtPU3NnaEhkSy8ra0ZWN09mTHMz?=
 =?utf-8?B?K0IwUDdaSzkrVkI5dFhuU1ZGMFFsSXEvUlIwU0dxVDdsREkrUzFBMlZLT0tC?=
 =?utf-8?B?T2ZEWWFJUXBuMzBreHl3VjdPZkV6bWZqd1A1NTYrRVpzTyt3TFd3NXgzRjRF?=
 =?utf-8?B?eUlnNXdnWFMvN3RtMHpjMDhNbllEUTJpRW5JZFZhd0hyV1BXZjhUdldEMTNq?=
 =?utf-8?B?NHZFSUJuaGYvajc1MkpuTm5jV0FzcG41QUZ1S2NkMlE4ZTBPUXRxUitkK3J1?=
 =?utf-8?B?bWJicUk1di8yNzdhU1J5UkZ5U0tpL2xlMXgrY1B6YzVPY2VQSnVzdU9ZUGV2?=
 =?utf-8?B?d1VPRHFsOGtjQ3ZEWmc0MTNkcUozZ0YwZHhlN2xhNko4TVlxM1YxcTZDN3By?=
 =?utf-8?B?eCt0a0F0RGdCUVU1S2VxcVZENDBPRWlINU8zOEpTaUtTdzdIT3MyWHdKeW96?=
 =?utf-8?B?NmpQdUdPMExORnlEdXI5c2FJNzRuaUpYbTlnRVcxalFQdStINmNhZ0lNZ2hN?=
 =?utf-8?B?Vnk2SkJXb0xZQlVmVU5XQ3RPbmgrUXRDcE1LTjhlNDE3bjJ4TnB2b2pBTG5F?=
 =?utf-8?B?ZE1hQVp6YkNMWEdnelozd1g0dGg1OExlcWU2UE5FUEE4Ti8xZ3EwTjc5RGNu?=
 =?utf-8?B?YjA1Qzl4UmhWeXV6MnZPM3JPZlB6dlFlNzVtaDFNZmlyUkZab3AxZDdKaGJl?=
 =?utf-8?B?VXA1OTQ2S0JKeUlJODByOW43aFhZL3dPRERUaHVQOXQrWll1dTZmMExRYmJS?=
 =?utf-8?B?VjBDWVQ4ZDk1U3V0cUtQZHpMN0I4NG9ZdThFdG1EbGVxdGlPVGFBVHU4bjRT?=
 =?utf-8?B?M0hMN0JpWkZFRy95eHViMVNsU3V2UDRocjI3RnZFVUhZNGlWN3NPMWZXNjRy?=
 =?utf-8?B?eEY5VWFvWlp6bmlmWUJSdEEwWnQxR3I0cGZaeC9Beld3dEtNK3NRb0JyY3lB?=
 =?utf-8?B?NHF2MlVWNDVxNmNmZk84NHdEWlRtRzFGekNrQlFLeFlVUVBsc2tFbTYwcmtW?=
 =?utf-8?B?MFZHOXd0ZkorRExGZWZMcXJMMldhT2UyeTlLcHc0RU1XdVFCQ1FSN3ZyRTkr?=
 =?utf-8?B?alNXVzNhQWxTREpRQXRaVTRDS3NRUmhNTFZ4a0Q2NURrajZwY2pPQVErZno5?=
 =?utf-8?B?YVM3YWtwREVOV3hCdDlHd3RCTDJFUWluUEROam0rcVVwSnpoUjRXRVhBS1gy?=
 =?utf-8?B?dDJhUVBsbmpkSGZsWWhST1hjTjVWaTRDZXNEdU9Wbmxtem1GQlFkd0F5N3o1?=
 =?utf-8?B?SWt1TVZ1TnZTb0VNd1FIVlBYdFVFbW1Zd3daUnRnZGE3SGNHR0hEWHpEQVJk?=
 =?utf-8?B?L0lKUGRVK1hGMjhrR0hXU2JETUdLZnJBSm92eHNtRGhwalA0OE94cjBjeHdI?=
 =?utf-8?B?S3J6UldZSVZmQVBvSC9yQjVSSmZENnh1SnVMVkJ4SzQ1ZkkxTEVpVlp0YWdk?=
 =?utf-8?B?dDZzZkw1dVFsWUZmSEhkUXVqK0xtMSsvWkhMdHd5MGM0U1lhZVpIc205aDVp?=
 =?utf-8?B?VVRDUWgxS2xoZVVlZkQzVmMyVnRGYzFvK3FoZGdjaGNxVzN5dXhuQVhoTUYx?=
 =?utf-8?B?cUgxUmVuczNWQkppQXNKRUQwN0hFc2hGVkxvNXpIVFZGeUFVRERSeE5FWmti?=
 =?utf-8?B?OUZMVS9oRkx1bXhZSXYwQ0EwM2pmdUs4RmxxSDM2M1lwZGxYV3QvQWlOSmhL?=
 =?utf-8?B?cjExQ09LNEVINTV0S0ZweXJYMnU5dGt2QkIxY3dYamxrTHl4WW9pS0tkdGxt?=
 =?utf-8?B?SytFV05Qdy83TFhmUUxMUXNGQVF0R0lhY2pDa0RLZ2dGRk0wZ3prZHhLNUcv?=
 =?utf-8?B?SWFTSTdHME9KME5HMUV1TlE4SUYvazV5N3UyMytQYU9uRkUyanBrOXI2a0lT?=
 =?utf-8?B?RzI5NDlkRWdMMGNOK3ZIRnpybU1nPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79ed2253-f2a7-407d-32a5-08da00158717
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB4958.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2022 08:36:08.9447
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: upZ63iWt4lz4kaRAw7V2ZjDCIkO2o9eQUS2J3TfnzCLBYuGT/+/R5ZtZ91iBUvajHv+ZQI8yKq6ad55OJAW4G8C98SIeM5jtqYbtieK8LWA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4324
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10278 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 mlxscore=0
 bulkscore=0 mlxlogscore=692 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203070049
X-Proofpoint-ORIG-GUID: KyKjvHRsJDzZ3FMTAuxhirY9BRZp43UF
X-Proofpoint-GUID: KyKjvHRsJDzZ3FMTAuxhirY9BRZp43UF
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I would request three commits to be backported to stable/4.14
c75ab8a55ac1 ("net/rds: remove user triggered WARN_ON in rds_sendmsg")
7dba92037baf ("net/rds: Use ERR_PTR for rds_message_alloc_sgs()")
bdc2ab5c61a5 ("net/rds: Fix a use after free in rds_message_map_pages")


The commits fix bug where input-parameters to 'rds_message_alloc_sgs()'
are just tested with WARN_ON instead of error-return


Regards

Hans Westgaard Ry
