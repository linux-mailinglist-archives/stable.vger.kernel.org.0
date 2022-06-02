Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1D553BC8D
	for <lists+stable@lfdr.de>; Thu,  2 Jun 2022 18:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237070AbiFBQbL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jun 2022 12:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237058AbiFBQbI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jun 2022 12:31:08 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D07D02B12C7;
        Thu,  2 Jun 2022 09:31:02 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 252E1DIo031806;
        Thu, 2 Jun 2022 16:30:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=pWUJyuH+vh5pOYWIX3WgFxPKa6+7wJ0Lsvo0LdNtNdo=;
 b=AFIweS0UCZTjCkigilZlmakH2Ke4kTmZ8QFVQ9Xmd73n7JrbMZrrNjEMCCnUiRM4CTDR
 /8ps43V7+bF8ojuLrYGtyutd2Xubu5atIX4gBwEC1EnpAyq1Ilf9KJwmC7pgosaWOPjJ
 q/dj5QA/Dj0U6PackXqvvXqiAqxAZrG9KCHLhFfoN42lmI/DSXktjKhN7YhJvpd67kdR
 m3MTq0n5Lm8sjJhqq9pK29d4dpT6d/cBfxlm8QqaxfuPnOvM5jgtvGNq/3CBF09A1bzk
 A7m1AfKgsgqYhdux1kjxdT6DykyIW9/Q4qlBnInlU2jrVmqxvuhh2eTHeubJJ/QKavvz ag== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gbc4xu043-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jun 2022 16:30:49 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 252GGGME008790;
        Thu, 2 Jun 2022 16:30:48 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gc8hyb0p6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jun 2022 16:30:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aesFd0/hXh2gDu4suamaE1nhYfjemJ43sHq7xlTnnPxzXENVm6u4Yl9WHMh2ZQouunsXEhOF6/UJQM5nzc4bCtDMaInVakrR9KICUqvCb7eVVsmphN4tKefF5RWocRlIdxV3PwxSKAaXYLCadzRV43G2cKh8nN7gaIhsZWK97HWdsNVabCjaI+hxiuL2v9obt4yP0g16Axe+OF8zeOTaX+/VgDRaAk59nQ8ujOIU+vICgGW4GYKJCcfIDCfKNHB3BC0h3SOby+m3D4O1xX3fZjZsNo6cxAUYbmXq7d+5JBXPPHDgav5eew4k9tfW1FOMN3qTqKDfemwiTkGcKUU4Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pWUJyuH+vh5pOYWIX3WgFxPKa6+7wJ0Lsvo0LdNtNdo=;
 b=Czwl97wDy8/QRNvwO8zWz1UPxnCiTAolpc778wUoz+405PifuBfAiGKbF0YzHDNYX0g4EZ1E2sJkDZ9lyatJ1tSq+vsqcxcQw80V5huQIM8bvsIUh9CmEoDC+IgM4/3iFkBzA3jU9E5/FArkG5t1MdCelh+GZJK6ECYSE5jYHu13Vdb+umekmzNllGMLUX9D2XsNezYBT2Hv1aM7McJTTIBkX21EAI5dEbFm7+vCXHh78/9JE7IkiB7fsNARUu8FsBDIatx9daFhNqwGH9tXL2i8paEJSgWIavr8MsC55bUcmkDGTfsPFrfdiX2rcg5FOqP4IC825BQ0lSvmUoBW5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pWUJyuH+vh5pOYWIX3WgFxPKa6+7wJ0Lsvo0LdNtNdo=;
 b=wfsCDGqEZK4P2BQsqEveOWiWdCUwiDXPEHQVgrkqKSDvxEhUFaep89fffov/si5W3k52oQm0XSFom0b3/jhBdU80xGFfXc+NFAiCg+yvlmru/+qNgAD8Wlt3GwQj3o95d213Ygw7NdH1MPSM2GCvarxl+ccNezUN0FbdZoJ7uDY=
Received: from CO1PR10MB4627.namprd10.prod.outlook.com (2603:10b6:303:9d::24)
 by BY5PR10MB4242.namprd10.prod.outlook.com (2603:10b6:a03:20d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12; Thu, 2 Jun
 2022 16:30:46 +0000
Received: from CO1PR10MB4627.namprd10.prod.outlook.com
 ([fe80::8477:e4f2:ed5d:8cff]) by CO1PR10MB4627.namprd10.prod.outlook.com
 ([fe80::8477:e4f2:ed5d:8cff%6]) with mapi id 15.20.5314.012; Thu, 2 Jun 2022
 16:30:46 +0000
Message-ID: <05a88b72-a814-1e46-4d77-c93fa6298b96@oracle.com>
Date:   Thu, 2 Jun 2022 20:30:33 +0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [External] : Re: [PATCH 4.19 01/20] nfc: st21nfca: Fix potential
 buffer overflows in EVT_TRANSACTION
Content-Language: en-US
To:     Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        theflamefire89@gmail.com
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jordy Zomer <jordy@pwning.systems>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20220325150417.010265747@linuxfoundation.org>
 <20220325150417.055045556@linuxfoundation.org>
 <20220602161229.GA32444@duo.ucw.cz>
From:   Denis Efremov <denis.e.efremov@oracle.com>
In-Reply-To: <20220602161229.GA32444@duo.ucw.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DX1P273CA0013.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:21::18) To CO1PR10MB4627.namprd10.prod.outlook.com
 (2603:10b6:303:9d::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f202b45e-2bcd-4d95-af6f-08da44b53e79
X-MS-TrafficTypeDiagnostic: BY5PR10MB4242:EE_
X-Microsoft-Antispam-PRVS: <BY5PR10MB42429A5C9488C828B3CDF719D3DE9@BY5PR10MB4242.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9QgUfsckXju8M6n5cDBF0vIpMaQIQDaBBYyxK1QSXN2sBrkcoAS/hqleDtbijK9rHkf39O0A3kUVi8iBdsxqUEtVAPKQhdyjoI1dkvTyqrrP8QcIQJnJRitX83FTJeayTqx6eXyZ/f+BMDqaegXmK3XYyrmXo7TiKkr0KSet6dk518uyytkWznNaZzQuy8Tc1jyF06J8BIKrEtsEHe+tsIyj6VdI0mtOSKMq0gIfeag2vi1g+J3OfGaLzGvcQJ+4PqxT49jpd+KGGnr7W2No5rOe/2VLtEqwql46NQNnj72msBJU3PPl6fZvl5sSHCH9zf80oqBTFL7Jz88oCAzDmfRMl/4x5lEiKX0Ys62c9NMnBP5F8qHfonO01qAt4ZAzG9a71b/C82xCIDBUZ5WXXANAwEKfxiWL11HkK4T3Ptt1Owo1LTQJVOHK5BLG94jAcZbDsLDh/S11L7nUMBRdLcrpxCrNpXPXO1hkPmE4Lo9xJ1CnDF3sNryQI3WDlR7SHgUz4S1P/qCy9aZAeRtUBdFJrI/IO8STanlBLQDvxCAfKhYT/abxozIlCBZUCFWU9PfeFFOj1ENH77gtLySEW88nMu2XHZECZdRHSQNzdqap8BbB0fAAc+tk8yG1upLofAxXuk6CJ0SYeCUEkDA4YQ/RLat/pM0pEMzR1Urq1Klnq5rq8TM6zdg7U6Og2hUQkFTQLq9qlf+rPzhvjFmIXWi2NZ9V7MwyGIjbKOyEKss=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4627.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(86362001)(6666004)(2906002)(6506007)(26005)(5660300002)(508600001)(6512007)(6486002)(8936002)(316002)(54906003)(53546011)(36756003)(110136005)(4326008)(8676002)(31686004)(66476007)(38100700002)(186003)(66946007)(66556008)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UU1SMy9GWmFuWkVFaG93RUNVNUlSSkx6VzJuaXdNSEh1aXFZWXFSSjBMYlFR?=
 =?utf-8?B?R2p3WEtnREdjN25PbXNTNkU0bnNFdm1ZbHpDM3oyekE3enBrdTR6Y2xsME0x?=
 =?utf-8?B?cnRCVXBqTW1mRU5WWWxtSkFSUkVKc1lKMkZPajJjMFk2OGJ3T3NCTjdhZXQ0?=
 =?utf-8?B?aHNYMWJqR2d2SlFNU1Brb3hMZW9jM0ZYQmp2OXRRVlcyUkQrRDZOaFVMSS9M?=
 =?utf-8?B?UytiSWFrQm5SUE00THBxV3RFNVd4dWJSZUI1MGJBZFcrcXR3dktRbm01bGFR?=
 =?utf-8?B?MlRQcThkZWlDM0hOZzlxMkhIVC91REFtaXRSRjRSRTNUaytwVWFabjFWYzN5?=
 =?utf-8?B?QTlkWlVwVVR5L0dia1FEcVB1dGI4U1VNZytYSmJaK0piRFphb0dtS1F2SFZ0?=
 =?utf-8?B?VkExcjgvLzFkRGJFL2xWY1IrdUpQN0NIa1BocDM5STR6S0h0UEI3UnJyOTg3?=
 =?utf-8?B?WnJkRmxuRkIwUWZiei9LMWV4bWE3eFlabitYSkowMkhwUEZiZlljOU1wTmI5?=
 =?utf-8?B?NDEvMVRkNEp5MW9uOU1LMTdGWVBTMWpkcGFIdEZNWDdRb1FoOGxMdHRSOVZ3?=
 =?utf-8?B?QkowMjJsYlB0SUcrNTEySWtITldnejVCV3FSeVJIcmltbVdzRkNWMDVOeDJH?=
 =?utf-8?B?STYyZXRJL1dFaGZLK1RlMzBGaHQrVUpPUzJKR1lMTTZnLzdlOEZvbGlRUmlO?=
 =?utf-8?B?ZFdMQ3o0TndCUlU2b1JvaHlGK25zZXBIeWZ5ZzZwRnBHMmZBWnpMc3ZsWVlV?=
 =?utf-8?B?TkRLSFNHbHp5aDlZdFZ2R3U1MHBEQTJWMHFCZmFyL3pUb2tiZGV2M2d1YXEy?=
 =?utf-8?B?cmEvUmV0dGtzb3p5MWhoVzcvbU1HMzc3WUVFUXN3d1o5SzBXV2pIYXNLa3hF?=
 =?utf-8?B?UkZlNEgvK3l1VXNjWXlxbHQzeE1rM1RJMFZJVmVkdmdkVFI5eTMrckF1MkRG?=
 =?utf-8?B?K3NPWHc3eTZ6NVNYYVJSOVVROERxYVE0dk9OR0RWZXJQRDR6NnF5TmI0MnFM?=
 =?utf-8?B?RVV4dWxra0doYXpxY0pOSi9yR3JFaXk2ZU1LTVdrV0QzQmpNdVBVeUVmV3B1?=
 =?utf-8?B?ZDRZUXdZQVJ2Y2FnSmRBZ1J5MWc0WlRZMGhjVUcza2VwbGQrTWxLMS90NzdY?=
 =?utf-8?B?bmdGeVMxL09qSE02b2pBMzlSaG1KS1FiYysyT083NXVWNFlsK096UzBQdzB0?=
 =?utf-8?B?djN0Uld3SUNhMHFJNjhhaEpnYUkzN05RVWFreFcvRUVsTENRV1RPNEtyUDBz?=
 =?utf-8?B?NkNvVld5N0ZyVWJUZzRoS20yallpY3lvYVg0SEVvblNqTzlCcWZzcHgrWHpr?=
 =?utf-8?B?VGx1TkZLRjBzeVdzYzF4bExtNk92akdvL0cxWnVqdlMwRDloWlcvSE0rRzVu?=
 =?utf-8?B?R3RxZGhQZFdYZlRNVjNXMjY2cjRYYmpoNFh3M05pTHIzcXE0RENad3FwSUpa?=
 =?utf-8?B?SXh0MTdJREd2Ymd1bmNwcWFncGZXNGtTN1RDNmIxU28xNEJBdTg0R0hscFB0?=
 =?utf-8?B?SWJUeFNzaXJYbW1sSFhHVzlGZWx5Zkg0d2IxSjU0YlIwV05rdUx2VTV0QnZG?=
 =?utf-8?B?QkVnTExlcy8yWVN3UCtnT256Z0NuRWVaZ0ZxTTBudEdGR2hVTElwT3RpV0hK?=
 =?utf-8?B?SVRJVTdqTHdabHdBMzJnc1NIMVdaM3c2aDhZcDd3WGV1WHBGaFFKaTg4bVRs?=
 =?utf-8?B?TW1McHNpYnBRVkN6eUMrUmlkNmlkcHdTbkxpTTZrVXhsbFFNWlJCd1ZpNG9i?=
 =?utf-8?B?LzYxRjNXbC9ab1h0cDRZMzJNSkQrbUZvcU9ncWFlVU5qeFY3cGE5Ykh0aFA1?=
 =?utf-8?B?WmEvdmIrSktDOUhseEFYOEJVeWxuZ0dnQy9MRVRaOVRkRElEMkZDcTEraGVP?=
 =?utf-8?B?SkhPdmFGTVhUc1FwS3FJYW1nNkNRYk1sa1pvWThzVjEzMXBwU2l5RFlqL1NO?=
 =?utf-8?B?NlhnM3ZTaGwyMWt2TEI4L2VDSG4wYzlQWTBLdjNwSE1kTzJLVyswMy90U0hW?=
 =?utf-8?B?MHZXOVdSZDhVVXZJcEpZUzByaXN5emxhZkMyeUJua3NQR0c4azJLUHNyR2Q3?=
 =?utf-8?B?SjdkQVY5cnJVdU04TS80cFA2dEdqRCsyaFU4dGtMTVhsQ3VTTmovSkNKRnQy?=
 =?utf-8?B?T3NDaGliRW5sVkFhNFNBOWR5VVJna2JZeDJuVVMyTkE1dDBGaEc4dG5jVlZ0?=
 =?utf-8?B?NXVqNjJ6ekNZTTBKUjhwZWZHWWRiS01WV3FDZ2ZzMEdkSnFKVWFXTk1adzNr?=
 =?utf-8?B?VTVUSTV6MVM1RWQ5TkVIbkFFUG1pdG5pc3FpWFcyRHd3MXp4WFJ4cTdadWZS?=
 =?utf-8?B?R0pPWkxuZStwbDVsWURvQjEzT2g1cDdFV21SNllJSEY0aS83OFRqaU1tZmx6?=
 =?utf-8?Q?8tDUeE860FwW2TN8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f202b45e-2bcd-4d95-af6f-08da44b53e79
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4627.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 16:30:45.9578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MWWAQ6oFDxk8iLWOt8n8g3D0M2fvL8FUS0ue7D+iee9YooLoU0GtI2CaGyJXbOu2jY6fbsstGP6y+1EPU8W02Ex2VjFZnCywA7Xkk7G0q/w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4242
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-02_04:2022-06-02,2022-06-02 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206020068
X-Proofpoint-GUID: sLTonTvOWEOaclURDaR7GO_Lc2S6tr4k
X-Proofpoint-ORIG-GUID: sLTonTvOWEOaclURDaR7GO_Lc2S6tr4k
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 6/2/22 20:12, Pavel Machek wrote:
> Hi!
> 
>> commit 4fbcc1a4cb20fe26ad0225679c536c80f1648221 upstream.
>>
>> It appears that there are some buffer overflows in EVT_TRANSACTION.
>> This happens because the length parameters that are passed to memcpy
>> come directly from skb->data and are not guarded in any way.
>>
>> Signed-off-by: Jordy Zomer <jordy@pwning.systems>
>> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
>> Signed-off-by: David S. Miller <davem@davemloft.net>
>> Signed-off-by: Denis Efremov <denis.e.efremov@oracle.com>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> It seems that this patch causes an memory leak, transaction does not
> seem to be freed in the error paths.
> 
> (I also wonder if the skb should be freed in the error paths...?)
> 
> Reported-by: <theflamefire89@gmail.com>

Same for upstream code and it looks like the problem existed even
before this patch. I'll prepare an upstream patch and cc it to stable.

Thanks,
Denis
