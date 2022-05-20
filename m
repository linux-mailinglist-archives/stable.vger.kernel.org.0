Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4E2A52F149
	for <lists+stable@lfdr.de>; Fri, 20 May 2022 19:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352013AbiETRJS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 May 2022 13:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352009AbiETRJR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 May 2022 13:09:17 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B27B56B020;
        Fri, 20 May 2022 10:09:15 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KFXTaA004407;
        Fri, 20 May 2022 17:07:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=hljA2fdzVGt8+Zgc+yCy0XZEX+ORJx1xIG1juHSoJgk=;
 b=eMsyy8e1vrDb2iKvq745VHsc0RBpWtxfxdCpI35LdZODvP8zqniLcqCq5CDzdfqYV3Zd
 OWmw7CNgtaLKHCjcsATcQFby/EGjbjavUh0waGJnrHgdAAsKW4Uwd1iQguHzQl70nyan
 Rc9MoFLs1wTXZv4jv4qkmbH2127ahAUMSIKX+hkeA27AbAB2MobUgGu7cJM145dWTUWf
 QF8P9dDyHOAfCIdz5UPw6uOnJLCJVNKVY7boT99MpMx0XGJD4yFcfwNT4opWaXuNrd98
 I92hRCSgnQTPnUBJWOj9AMr3NKug+IPzwd2A/R+x38ChiSdTCCMf7IWRSxNObH4q0Tey GQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g22ucf601-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 May 2022 17:07:03 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24KH1q5K004984;
        Fri, 20 May 2022 17:07:02 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g37csnhqw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 May 2022 17:07:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IInsd6BLBXTxgk1LxWzkObr9O/2DgK8092LinN7OgUT7ad8udLaoXOYlrNr1lx/BDicSetflN3aEf257dj4H+IgQd2okPGQLIVavCR0DCbCyVVFg8B+Ztg82aYOWjLM1n1tHWNptDq4E240ZxlRRT5i0IxgiZftgszdJvtyI17QWCJ0/HlRsBEeGkVe2bdXljfiVACS4QjaLfdEQXJZB98xSP8QMP0Jv7wxUQ76PUVVtfoOpaR37MCA2ME/2uEk2WJ2qRSb+HkQx906vGOJGJqfzoGyg6DUWk66rdYz22PBxxSWKXXZip+SNKZaX5wxBJfNysOaYa2we/BO5o1f4Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hljA2fdzVGt8+Zgc+yCy0XZEX+ORJx1xIG1juHSoJgk=;
 b=ftH1Au3OqEsLGl4pom5MohjgCzd5nZ0AyCGFh2Xl4tZbiqL9uPI3ZQ8gfLsXw2x/w7yTfen8CBxxXEdhHVdEdQgbP0cBKLK1gxpBEcbkusG40MUA+pDFR24c1u7vXIliZat9lOeUqB9rek95QUR4jC5UMV8pNB2AMOGX5m0prK8jm7vDqy6uQxI6WyGfAsQEqG0xjtU4w4WOdKQKq/i/CkGnYFCQkFB0O6/YUq16sWU2Q5JR4Dri2d3FL0ouuCG+qXLtCTbwEb1VStrVFowZ4zE0rpeJ1iHyTbo7v4YVtgcIs74Dl+tD0H9pmNZS4rNZw/w57jImYdATdBhS/ma5XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hljA2fdzVGt8+Zgc+yCy0XZEX+ORJx1xIG1juHSoJgk=;
 b=kAHG48LiwJLZ8HnNVBPxKFGpGquQd+QkHAoNMK+3cZTbNuCfdJm1sSO00ldgE8xSAJ/d9Nv5BY/jKXFs+iKsemuFQlMWdajbJJf8exTHKr6guJev1FoggiRea9Ob5jsHUjBqA+NwCAe0IcdfyA0oNd0pwEs6YlIvcv7EBEfuakM=
Received: from BY5PR10MB4257.namprd10.prod.outlook.com (2603:10b6:a03:211::21)
 by DM6PR10MB3148.namprd10.prod.outlook.com (2603:10b6:5:1a4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Fri, 20 May
 2022 17:06:59 +0000
Received: from BY5PR10MB4257.namprd10.prod.outlook.com
 ([fe80::3584:4c8d:491b:33a9]) by BY5PR10MB4257.namprd10.prod.outlook.com
 ([fe80::3584:4c8d:491b:33a9%5]) with mapi id 15.20.5273.018; Fri, 20 May 2022
 17:06:59 +0000
Message-ID: <422c4805-90a8-db91-cd57-d6808361104a@oracle.com>
Date:   Fri, 20 May 2022 10:06:57 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: 5.4.188 and later: massive performance regression with nfsd
Content-Language: en-US
To:     Trond Myklebust <trondmy@hammerspace.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>
Cc:     "linux@stwm.de" <linux@stwm.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <f8d9b9112607df4807fba8948ac6e145@stwm.de>
 <YnuuLZe6h80KCNhd@kroah.com>
 <6A15DEE1-CAC9-4C64-8643-AD28EA423046@oracle.com>
 <YnvG71v4Ay560D+X@kroah.com>
 <0F5EA15D-08A0-4D3E-B5A9-D62C49BF2B56@oracle.com>
 <59118799-0148-41F3-BA03-BB69151B74EE@oracle.com>
 <1792eb49d2a9820bbcf7b240f53158170041da6d.camel@hammerspace.com>
From:   dai.ngo@oracle.com
In-Reply-To: <1792eb49d2a9820bbcf7b240f53158170041da6d.camel@hammerspace.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0051.namprd11.prod.outlook.com
 (2603:10b6:a03:80::28) To BY5PR10MB4257.namprd10.prod.outlook.com
 (2603:10b6:a03:211::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e30d994-8c32-4dda-1c3e-08da3a832704
X-MS-TrafficTypeDiagnostic: DM6PR10MB3148:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3148A8A24390843533121FF187D39@DM6PR10MB3148.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hq14sBa7768tSEYdYBZar4WyxAQnzukdd5m+Y0+s8jbQ9gk7ux9NrZ93cPvEj33MkMLNpID9+M5dFsKf+sCIYIGn1Ews5XjLeWNl9r/aI9DGsMJZomWTpBDJtOid/Wc6kZ6VGFCsZWkrygrDRjW6daHQkD27FFf6nQHfYsOGzgn+aab2iqJF3SiUMLiipcZlY/8QYQkP3B5Zw7TDtaMhxX7FGZb1jtTFJUtxsETJ51ztA75Slp3cS5xTcbsYKsYPuUl6UWoo7b70+pgcOJynx1bjsNkKL0Y8TKnKvlj20fOKA081RJy7fIMW+2a8YfnhkF+7ChhcOJGxytx5xTpgH5k7FUu8DHBkDsUCzOXdpvLM2QswnLeEOEVs98T0oRwqb0hPcc0A4vtfBRl0DYIBvlJQ4cYg4fRzlA0beU3MjxT1L0/BPCuN3m9XrBuov9rP9Q8G801zhJ/A5+DglZzvmDHszu9t/GgNPQ44CJErPO4WCn8lVazxg72K5F/lGbI76LX/mjbYqWLgeOeSGyA+VJLhPX9j0BEUKL5+BQWgrwKiu8xM6RUR27//BrO6yk7PNaoZlLocn19shaqJ2ttrDhOzxdimP7tlpRSmL3KC1srswSQy7oU3ZUfL+Rmjr0PKpERYp/mbvlq1658UmDgH3cTqPP3tA2rEHsD9gPPuPoJdpagT8R0i5ErZQ5n9D4c4QUKv5qQI7d3JJPp6rMKHOwDHG7cTupOQp2Dq4fFHbZSPG5+q7lLvdv+m2JTVAY6egq2MA0GNtl6fy9QOIZy6ZsgaiROS0oLRWxRbRDy/MlxCBqAMbyCern0RlydLCAZR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4257.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(36756003)(9686003)(6486002)(5660300002)(83380400001)(966005)(316002)(54906003)(6512007)(186003)(2906002)(31686004)(6506007)(26005)(31696002)(86362001)(8676002)(66476007)(66556008)(66946007)(4326008)(2616005)(508600001)(8936002)(110136005)(53546011)(14583001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TVlVUHlnZHBWS3NmK3FTeUIrb2NiRHl4U09scC9QQllTV2xFcDRZR3RlUXFZ?=
 =?utf-8?B?c0ZnZGNTQUJkSldqNithT0xEa1Z1d2kyNnhiR014RTR4bnZSRWd3b2lOMUFk?=
 =?utf-8?B?MHUxWUdEdmFMVk9MN3NJNXUxV3dUUE9TNlNhWWFzKzlUQzVXWDdoVk1VNUY2?=
 =?utf-8?B?ZEZoY3h5d2xzMXVLWGNYNWFFdkwxcXJDU1VBT3dJbDJhSFhJdWwwLys1bFlM?=
 =?utf-8?B?c3JOb0JGSlRtQ3NHRmgvR0JFczd0R0lkTUFnRURIS2dDWit6TDBxRFA2ZXNS?=
 =?utf-8?B?U2RLM2hUN2E3RGxWK1R3UTRpakVwdkRVK3VOS0Jsb3QxcGdjdDZvb2xGRmhi?=
 =?utf-8?B?UVVjRHRyZVR0V3FTWkxYQlRrUm1CMHkzdEsvNndqYlBJWWdpRHpZUnByaVJi?=
 =?utf-8?B?NXY3Vk1GNXlQamV3U2pWQlk5Qkp1ZHBUampSc2loL3NrWXhEcXQ0Uk5rMkta?=
 =?utf-8?B?aDNQSFMwNllRMGlUZmEzTDBVMUgxc0g3WVMwTWRkTlNIVHlEWEx0ZjlhRFJs?=
 =?utf-8?B?bmpURFRieTRoMHdrTnVZVmtVMmk1WjZFT3IwWnNQZDNlamFscVRNTlBpWG1n?=
 =?utf-8?B?SStSTityQ2JtcWlIODZBdmZhWG90SjErdHcyd2tZN01XcTNzaDQ5YzEyQkZX?=
 =?utf-8?B?dVppN2ZOSytRU2lXMktzM1ppL1VGUzdFSzZhSkRQNjRhSWhhSG1xVS9qdC80?=
 =?utf-8?B?ZFE3UXNuVmd4V3ZjRm9KL3lZSWJjbVVDY0t0ZEZZUi9JbC90MG5UMjhELzEy?=
 =?utf-8?B?OUozT1FHK2FVVk1saVRPVGFIdlJWNEVNKzVTY2UyQUNEa3hqbS9UVGxzSHlM?=
 =?utf-8?B?UzFEK3lLaHptMzEvOFUvUVQwUFN5dFQ5ZVIxZGNocjh3ZGNIM1g0MjRPQlFH?=
 =?utf-8?B?V1dhQWxzaXNoZ2NxM0hwNWJGZ1VjVWdWaFlKTVNLamhDWUJ1RW5iQTBONVpn?=
 =?utf-8?B?V1RGYkVyY2JOTlRSWWdsOFk0QTZEUmVhY083YlNhVkRwcGkxbnkrQlhlZGpG?=
 =?utf-8?B?OWxWSEs5Y0VwWUk4eGVVdDJETUI5dThHaTAvUFlUMGZFcG5xSm4zbUZ6d0FW?=
 =?utf-8?B?bE1qeXoxR2xjdWZxVnBybnZFMUJ4cWhrYWRyK0o3Qy9EK2Vwb0htblY3U3Az?=
 =?utf-8?B?Q1lwbU1mdnAwYmpiRmQwenVkUk9Xc0JwbEhrb0krMzVOUGpTKy96ZXpwZWs0?=
 =?utf-8?B?MGtFTTRUZEViWEJqbjN5WmJqcUZXUENhaXIvcUlwT0MyZUVFYnBiVTBoVENF?=
 =?utf-8?B?UkVwRHdtTWpoUzVnVXZkVm1pa1E1Vy9HUitFNlQvalAvcmFoM2d4UDVOT2Mz?=
 =?utf-8?B?Y1Q1dFIwTGFPNzYvUDhPTVlCZktCOHZhVlNXU1YvWXhnZ0RmdVhuY3JQb2h2?=
 =?utf-8?B?dkwrdE1uNWRLSmVKQzMyUUQySFpIeDRYVm5ESTJQMDBnZzlGQmJVUXRxK0F4?=
 =?utf-8?B?Tm8yUGFRalJ6WVBCaTFiRFdrb2lxbzNwdE1uMXY2V0ZYYlNvNFJ2SzhIS2l3?=
 =?utf-8?B?Z0VnL3ZuS3B4bWF0NWo5Zm5uQ0NCSG85bk44OFIrSStvdnRVdUEwMkdneERw?=
 =?utf-8?B?S1ZucmptWWJaSFpzRHFpdFdsSTZaVDAxZVA4N1J3Slgwdng3Yjh4ejBSVk1J?=
 =?utf-8?B?YkZXS0lIWW9yMVo2dFJPM3VOMlZuYXljei9zUHdrYlQ4WmlBN2F3eUUyT3dS?=
 =?utf-8?B?YS9GQ21lRy9lN1pkb25Kd3RuSTRBL0IyQWtJM0pDYTdLZ1ZQUGp6UXdXdVJr?=
 =?utf-8?B?TDhVZFh1VHBtY054RG9ocVlBaWxkRFErU1d4TUxlWDUzTTVqc0FQUjN1VG1I?=
 =?utf-8?B?WG1IT2xacmZYUG5NQXBMRDhGa0NSb1EwS3M2OFNwMjBaaFV4U1JvaUppdVNq?=
 =?utf-8?B?SHRuMW1xQ0tFV05PV1drV0c3OTA1R2N2TlVxR0FYWDJCcERtZG1XUldxSWNK?=
 =?utf-8?B?QXc0VWJudjVMWEhhN1hpNzgzbFYxVXpYQ1RZbjlBNFk4TUh1ZnpNY1pIREwv?=
 =?utf-8?B?dDA3ZGRaZWJNVGgrYStrWEJ1dXNNQno4N1NRZTRBeU80alhObGRPUXU4U0hT?=
 =?utf-8?B?M1ZwZzhCa25pbnFHUks2TXBNdngvN28rYUhTSFBqZkI1SVBjeFp1a2Nka21x?=
 =?utf-8?B?MEk1cTRZY2ZOaGJJUUhJRTU2WkhxL0NuUTVJakRHbUpMT1gzRHBZa3I4NS9h?=
 =?utf-8?B?cUlMNGNqbkliTGFUbWhVVFlhdXBWZWgyb0pjSTk0V01HY211QlloMWZqa1Nv?=
 =?utf-8?B?RmNrNzdiWUdBcjB3VllpOXUyMHhmSUF2bTNUZ2JVdjM3VUN6OVNVTFhDYnNP?=
 =?utf-8?B?WGVZcXZKZ1plajNxT21VYkt2dWpKTDBBd2VwelBBUmFpQXdSaTZvdz09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e30d994-8c32-4dda-1c3e-08da3a832704
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4257.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 17:06:59.8084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IxWknlYGlLswWx8bjLmH5LPU2/74dFdUBKviPnab3bf95xJJ1OCejrj0Hu+cZUld9qu5il5x44t2KpFBCiR9ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3148
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-20_05:2022-05-20,2022-05-20 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205200111
X-Proofpoint-GUID: AtJcekIvWyoUay3i7Sc6E2XbeXpO0nn9
X-Proofpoint-ORIG-GUID: AtJcekIvWyoUay3i7Sc6E2XbeXpO0nn9
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 5/20/22 9:40 AM, Trond Myklebust wrote:
> On Fri, 2022-05-20 at 15:36 +0000, Chuck Lever III wrote:
>>
>>> On May 11, 2022, at 10:36 AM, Chuck Lever III
>>> <chuck.lever@oracle.com> wrote:
>>>
>>>
>>>
>>>> On May 11, 2022, at 10:23 AM, Greg KH
>>>> <gregkh@linuxfoundation.org> wrote:
>>>>
>>>> On Wed, May 11, 2022 at 02:16:19PM +0000, Chuck Lever III wrote:
>>>>>
>>>>>> On May 11, 2022, at 8:38 AM, Greg KH
>>>>>> <gregkh@linuxfoundation.org> wrote:
>>>>>>
>>>>>> On Wed, May 11, 2022 at 12:03:13PM +0200, Wolfgang Walter
>>>>>> wrote:
>>>>>>> Hi,
>>>>>>>
>>>>>>> starting with 5.4.188 wie see a massive performance
>>>>>>> regression on our
>>>>>>> nfs-server. It basically is serving requests very very
>>>>>>> slowly with cpu
>>>>>>> utilization of 100% (with 5.4.187 and earlier it is 10%) so
>>>>>>> that it is
>>>>>>> unusable as a fileserver.
>>>>>>>
>>>>>>> The culprit are commits (or one of it):
>>>>>>>
>>>>>>> c32f1041382a88b17da5736886da4a492353a1bb "nfsd: cleanup
>>>>>>> nfsd_file_lru_dispose()"
>>>>>>> 628adfa21815f74c04724abc85847f24b5dd1645 "nfsd:
>>>>>>> Containerise filecache
>>>>>>> laundrette"
>>>>>>>
>>>>>>> (upstream 36ebbdb96b694dd9c6b25ad98f2bbd263d022b63 and
>>>>>>> 9542e6a643fc69d528dfb3303f145719c61d3050)
>>>>>>>
>>>>>>> If I revert them in v5.4.192 the kernel works as before and
>>>>>>> performance is
>>>>>>> ok again.
>>>>>>>
>>>>>>> I did not try to revert them one by one as any disruption
>>>>>>> of our nfs-server
>>>>>>> is a severe problem for us and I'm not sure if they are
>>>>>>> related.
>>>>>>>
>>>>>>> 5.10 and 5.15 both always performed very badly on our nfs-
>>>>>>> server in a
>>>>>>> similar way so we were stuck with 5.4.
>>>>>>>
>>>>>>> I now think this is because of
>>>>>>> 36ebbdb96b694dd9c6b25ad98f2bbd263d022b63
>>>>>>> and/or 9542e6a643fc69d528dfb3303f145719c61d3050 though I
>>>>>>> didn't tried to
>>>>>>> revert them in 5.15 yet.
>>>>>> Odds are 5.18-rc6 is also a problem?
>>>>> We believe that
>>>>>
>>>>> 6b8a94332ee4 ("nfsd: Fix a write performance regression")
>>>>>
>>>>> addresses the performance regression. It was merged into 5.18-
>>>>> rc.
>>>> And into 5.17.4 if someone wants to try that release.
>>> I don't have a lot of time to backport this one myself, so
>>> I welcome anyone who wants to apply that commit to their
>>> favorite LTS kernel and test it for us.
>>>
>>>
>>>>>> If so, I'll just wait for the fix to get into Linus's tree as
>>>>>> this does
>>>>>> not seem to be a stable-tree-only issue.
>>>>> Unfortunately I've received a recent report that the fix
>>>>> introduces
>>>>> a "sleep while spinlock is held" for NFSv4.0 in rare cases.
>>>> Ick, not good, any potential fixes for that?
>>> Not yet. I was at LSF last week, so I've just started digging
>>> into this one. I've confirmed that the report is a real bug,
>>> but we still don't know how hard it is to hit it with real
>>> workloads.
>> We believe the following, which should be part of the first
>> NFSD pull request for 5.19, will properly address the splat.
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/cel/linux.git/commit/?h=for-next&id=556082f5e5d7ecfd0ee45c3641e2b364bff9ee44
>>
>>
> Uh... What happens if you have 2 simultaneous calls to
> nfsd4_release_lockowner() for the same file? i.e. 2 separate processes
> owned by the same user, both locking the same file.
>
> Can't that cause the 'putlist' to get corrupted when both callers add
> the same nf->nf_putfile to two separate lists?

Thanks Trond for catching this, I'll submit the v2 patch.

-Dai

>
>> --
>> Chuck Lever
>>
>>
>>
