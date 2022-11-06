Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47D5F61E346
	for <lists+stable@lfdr.de>; Sun,  6 Nov 2022 16:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbiKFPyr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 10:54:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbiKFPyq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 10:54:46 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60763DF51;
        Sun,  6 Nov 2022 07:54:44 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A6B6W2Q017285;
        Sun, 6 Nov 2022 15:53:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=cSvUo+le1rI8oVU2k0T5Gw38mNxSkMixOYKCf8XMRw8=;
 b=M22IOAfrwtn35BDYe5GGfGXJmIvmBX18bphT2zat7NYUMmnPTfGPagQpPN2WOf/uBo+f
 ywCAW1hIxKLUH7+W1XpAZbDcLy3wzZ0RwYXx4ZAbbvf+4L7PrrpM+EWV3d0gTsMQRFWJ
 phnnTBX+YNn3XK+p2PQ9n0e3IaFwzA7SblxCPE2j77S0P8OaZnuBsS5H41o3kMstl+jw
 1UAGPvcPDO7mJqj5waBGxoOp5FvOt1Za8pmFKz5L+rODvYc/hsBBpEnJyIX3GFV+FVbW
 IBi/jj8osDf7ZuDvVWwB/4fOPiQu8bfxcWGuV4oV4ILUj2927E4Tji1moAvgeMrnIX75 bQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kngrehvdh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 06 Nov 2022 15:53:45 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A6CBpaB025104;
        Sun, 6 Nov 2022 15:53:44 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcqe2pwe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 06 Nov 2022 15:53:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EtRt0xk54WHrQtcib37gcsW2pgk7zooQbPJGuMPHExNKMtdzFEDvHEeGQbYiX6xmOoUnDhT5hZqqNamn+OF69D7sIlYOApo2hXk0Sb1FMh3c/qvHc4JRYx2T4EGwfpMyzPXf8HDddi5EuOExv+DHoO6r7emkz336VJLdB24CvhIHTEkPch6+z2Pwpw1JbbXBvInhhu5XnRTPTFkWmsomZ7HhlQliSNo9sNWqRveXYGByIh4GkwZsJz0wge/s5Xv9NrNP97ucDrM9SX9U8+qFDyyTp31hhT41hfVROhKdcKK2TY7KnM3ItrFYKNuEJD+hSjKPkOfWuiBKYV4wjXF1zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cSvUo+le1rI8oVU2k0T5Gw38mNxSkMixOYKCf8XMRw8=;
 b=clEWQHsdVzjS87e1QhgDxdSp6AkydwnWQ4UGJIm6fr0RZDWiY5vBwpTNWDdwFtNfSuipyDv0VZZcV5McPZ+yVldmTLY3VXCZJtrV6hQvVdyFyMMslTLnmeo+MIKzx8/tPWkq5U54dfLgs8OuasWEu0HJ8UzvdvXG7G3yQ2AXHaeFV2RxlxqLe5PMotBsmDhp8PUGq5DdSbgn5e7FoOTrV7aZarncPi0HK1jOeBYpVedkdt02ZuGzjAWNboZmeIj9wfYiGIX0XLBI7VhoNNSum7UwjPwFQirTHMbnni2B9wbnhe2n7D+aB6v/uZTakC0Oe+37RVsytzsmsxlze8CMEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cSvUo+le1rI8oVU2k0T5Gw38mNxSkMixOYKCf8XMRw8=;
 b=esckrFs4OUI3SulQRWnmLYSXgbsFJLcG+h5J1c7bQvFxZfSj/uez1tJmjk7YK3ReYg9X2y7d6dbc2eiJGelEWZR7a1szTtEo3e2pEj4TxvyntHEDAJRvK4jqlrbEJt+DlJ10HjCuBbAJFgpnLDk9WDHV1ixgRqV2YM4YBZLpdgg=
Received: from BN0PR10MB5030.namprd10.prod.outlook.com (2603:10b6:408:12a::18)
 by PH0PR10MB6433.namprd10.prod.outlook.com (2603:10b6:510:21c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Sun, 6 Nov
 2022 15:53:41 +0000
Received: from BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::c13d:dad:6a35:b25a]) by BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::c13d:dad:6a35:b25a%6]) with mapi id 15.20.5791.025; Sun, 6 Nov 2022
 15:53:41 +0000
Message-ID: <3d25a0b4-6957-d070-db11-69ec9e0132ba@oracle.com>
Date:   Sun, 6 Nov 2022 15:53:32 +0000
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.1
Subject: Re: [PATCH v2 9/9] KVM: x86: remove exit_int_info warning in
 svm_handle_exit
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        Yang Zhong <yang.zhong@intel.com>, x86@kernel.org,
        Shuah Khan <shuah@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Colton Lewis <coltonlewis@google.com>,
        Borislav Petkov <bp@alien8.de>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kselftest@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Wei Wang <wei.w.wang@intel.com>,
        David Matlack <dmatlack@google.com>, stable@vger.kernel.org,
        Liam Merwick <liam.merwick@oracle.com>
References: <20221103141351.50662-1-mlevitsk@redhat.com>
 <20221103141351.50662-10-mlevitsk@redhat.com>
Content-Language: en-US
From:   Liam Merwick <liam.merwick@oracle.com>
In-Reply-To: <20221103141351.50662-10-mlevitsk@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR04CA0033.eurprd04.prod.outlook.com
 (2603:10a6:208:122::46) To BN0PR10MB5030.namprd10.prod.outlook.com
 (2603:10b6:408:12a::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR10MB5030:EE_|PH0PR10MB6433:EE_
X-MS-Office365-Filtering-Correlation-Id: 02f79a65-7c92-43d4-9440-08dac00f1362
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CgD3AgoO5Kb3ClBhkEhqmanh87y1nOSjT4z+h3HC/WaAaXBt+vvTimbGLtdrnkjj3U+lD0XhHVr+XeyV/XrXxMQ3qioPW5Re7nt2zVr92p719ocdxVxsUFFbTi+rGbT1ertgR+I0HeUvCf0zDAoMxTPoffKWXkNw/SL2C0P/+g4N5hK5flfx2UOobh5CCVfi9lzDax5Sm5o439Q4cAMswAyPIM2zbrNQB4rpFziC6lM3FmzAMkFdfdBhCVQDTbWLlnit9A+QotSysOGjaXFJ19qZa9+h1pZHbFAaZifTdnRcVDdyAphADH8PMJWu8SXiC0VBRgXJI9vUptA75n1AyjDiCbDZV4SFFqOzBeRqqzdMabrgJIa1rb0+najuaMZ8vWRuZTLNRQxosu8CvKqWRWsNS/OOrxWYxNylYDcqbeeOqgA7jtypoT+GZ0wlfFz1IODNn4KDre0Qyjofj2VXhiE2sF9ahPWayrZpnE/BRone2v9Mbi6jp3sPfExerTbujCSdNRBYPynCFpLFZ/FSO/dG/yt5aK+1n1PGwA9vqdOQ5wKWdW5Qa6YEv23O/aUw0Ch5W8+/76iLbofhlFU2yOSALU3OSkZyy7cQYWx3UhbQ6cQPF+QPkWyEVO1PyFL1y1AdEOxZnzCi90J4ClXOHUkUUUIf74Klss77UaUW+nXC7egZCPRWIka504dfIOMZhp25Wmjx0q4L6Br99b+/pDwYa8hlgDOEqws9qygNk8xg/7qnUTD0DIePwUb1YocEzbvtwaVTPpmaT7LiRArNKQG2plxr6XXzzGGlGKrs5FM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5030.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(396003)(366004)(39860400002)(346002)(451199015)(31686004)(83380400001)(186003)(316002)(38100700002)(8936002)(41300700001)(478600001)(2906002)(6486002)(36756003)(107886003)(53546011)(6506007)(6666004)(26005)(6512007)(54906003)(44832011)(31696002)(86362001)(2616005)(5660300002)(8676002)(4326008)(66476007)(66556008)(66946007)(7416002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Mmg1OWJwRGpmZ0xQVXpYemtJY2d6Z281NEUyZkdjam8vL3pUZjI5ZlFCZ0ls?=
 =?utf-8?B?bTRmOS9GSVFFZnZKMjBGZkJmb3F0UVNKL2Z1TFkvbTgrVHJoNWRiWjRIL2px?=
 =?utf-8?B?YTlJdXAyQXpIYWo4ekFEd1FEemRpTktoOWNGckJ3ZWdjQlhYRWhldWpkWGtI?=
 =?utf-8?B?MWljOENlWk02TmNyR3NkbURrU3lGUFpaTXFWd3Qzd0Vxend3R3JYTDhDZWwv?=
 =?utf-8?B?REtUS2dJd0VyOGVLTk1wMlhJRFpqeTM4a1A2Y2thVnlja3V3NEF3NElyTUF3?=
 =?utf-8?B?ejdzckRNU3pDeFc1dU00QlZTdmtFbExLdFltYmpsaStES3Z3VzAvT2pzRjBq?=
 =?utf-8?B?d3FLY1M2cDhnYmFGUVNHc1c0VVppd1hnd2pUSXpvbTdycFUvMU1yKzJqL1I4?=
 =?utf-8?B?aDBZcnhMdkYwckZqN2hZTzNYcklHMlpRSk83b2hYVEJTUzBZdWhITlpyZENi?=
 =?utf-8?B?SnJHSzZGSEQvdHoyV1M3L292VExOVlZyaGVIYStyclFiTTNxdzJyUlVnVnoz?=
 =?utf-8?B?aS9sR0RhdkpwOUtDMU5xMHZ3U1RoM2FEbU9vUDRhRUl0TU1RV0d2WnpzQ1Rr?=
 =?utf-8?B?Nis0ajFCUUhxY05RdWVDVHR2aUVvbTdOZ2pKYmM4MklUY1RiaTFWZHhRUnhl?=
 =?utf-8?B?eHlWcklYSTczRG02UUdpN1JSSzZ0YzJNMnRrTytrQ0hiNEUvK1oxWVdXa0R0?=
 =?utf-8?B?MlRlczg2ZmY2MmRQL2t6NlVRSFhMd3I0ck5SQlZoRFVHa0lZMWEwNVhFenk5?=
 =?utf-8?B?OUNVU1g1bWpOVFZ4NG1td1VFNGc2YVN1djU2dGhLNXRvb2FJTEZOaS9BeGxu?=
 =?utf-8?B?MFY2b2I2OXA3SXg2b0c3Vzd1V20xTmYrYi9RdzJMbXVDRzcvVVJmaElhRTRQ?=
 =?utf-8?B?VHIybU9mb1BpNmY2cWxlTGphd3hHaHBnRVZvN2JpTWc3WFJtZVhpRDNuS2hS?=
 =?utf-8?B?YjR1NGpqR2Y2WEM0U1Y1aHhDbWhZU0VvMXMzTk96YTROZ3BwVWxhWmJka3ZF?=
 =?utf-8?B?d3hHNlcrVXBCY1VEMzhsMlVHcktKT01SS2ZYOHYyQnJCV2xqT21TRzRZWERY?=
 =?utf-8?B?MzV2T1hlQjBoN3ZqeWw0WUg1bXhDMzNhYmlwQ212OFFFdzdOLys4SnFoWG44?=
 =?utf-8?B?Mm42RkorSlhXZmxSNVhSeHJnUDJIT2ExUFllTUkzQlFlVE1uYnhGV2NsMWpD?=
 =?utf-8?B?Z0NDa1pLT0pSNU5IZ0tnOE1ZU05qTFJRZmZRM2hJbnhqSTVLODY1clcvVjV4?=
 =?utf-8?B?ek02dkZtdVU5VTZ1Ykx6YmlEVnZjdmpTWlRYR0IyVEh5dmxYeXZaZkRqdFZo?=
 =?utf-8?B?MHg2M0ZsYUJ4TSsySWhpbnJid24xRjR4UGU2Y2h2a1pkd0pZdkt3RDl0eU4z?=
 =?utf-8?B?Zk8wZHpSS2tnTmdKTko1ZHlZSVhLV1ZPMkNpYkJQZ2hJMVkzYUFCL1RId1VJ?=
 =?utf-8?B?N25LUkFPYzdLM3hEY0l3K0c0QnJQWVE1ckpXUGRyZ3JQcitDK0NvUTdOM1hE?=
 =?utf-8?B?Si9YQStTR3NNV0MrTjRlcFpPSFZsclB1aGs4NEw2RkNCNVhjcGpvZmpXM2xY?=
 =?utf-8?B?b05nMVRYajM4OWliREtnaWh5R2ZoWGlkRndWMzI2K2lXTzFBSUFBeXZSTzk5?=
 =?utf-8?B?T29jcG8renNtdFlNNDZSSjJVYlc4b3UwME9zckR2YUladlZmU1p3QXljaWpX?=
 =?utf-8?B?RTRtajZXQVcxeVpzTXFQQ3VJcEQxUkxZWEttME5IQTdrWHdaTHdyZHpIdTRE?=
 =?utf-8?B?WDI4RDN2RGNyNjYzR3RFcGJqWFpOa0RSZWNDamNKWDViMjBxeFhZUmEwb2h5?=
 =?utf-8?B?YmRidTB1WjFCV0JMQTJpZ2pBbmNHbFJZR3Z0NEVacHhzN2NMRFp6SWZ2eTh6?=
 =?utf-8?B?dDVZQlhzbjZBTThqcXBvaVJZcHZvdGZTcndnaGJTTmlDbzRxM1BRMTBYVkdj?=
 =?utf-8?B?V3ozTEErY25jMmZVeVVjRTRSVmVBSWdHWS9EeG5GN3M3WDVydzl0SVUzdE1m?=
 =?utf-8?B?Q0NxSGNCNDVVRGNZRjBrUGdORmlnVDJibi9MWU5lNzE3OS90ZU1lQkI4MCtD?=
 =?utf-8?B?MXZsb3AyMm9XaGV1S0JNSkxyTDlOeTErTjNlTk1aNklOSU41NElZall3VkVR?=
 =?utf-8?Q?TIgb8u5bxxhY0LdwTJIyeguDs?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02f79a65-7c92-43d4-9440-08dac00f1362
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5030.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2022 15:53:41.1271
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 82V6OFqi1bO7DRJvzc6M/90FDWySRclyWaL6rxYyhFTwNmb1RoXQgEMfulbDyinc27Y5ar/PHjCtyqCgAuV5Eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB6433
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-06_09,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 suspectscore=0 spamscore=0 malwarescore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211060146
X-Proofpoint-ORIG-GUID: 2kAgiid6Ag2mVxo2lMWdZlukFPqEuE6h
X-Proofpoint-GUID: 2kAgiid6Ag2mVxo2lMWdZlukFPqEuE6h
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 03/11/2022 14:13, Maxim Levitsky wrote:
> It is valid to receive external interrupt and have broken IDT entry,
> which will lead to #GP with exit_int_into that will contain the index of
> the IDT entry (e.g any value).
> 
> Other exceptions can happen as well, like #NP or #SS
> (if stack switch fails).
> 
> Thus this warning can be user triggred and has very little value.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>   arch/x86/kvm/svm/svm.c | 9 ---------
>   1 file changed, 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index e9cec1b692051c..36f651ce842174 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3428,15 +3428,6 @@ static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>   		return 0;
>   	}
>   
> -	if (is_external_interrupt(svm->vmcb->control.exit_int_info) &&
> -	    exit_code != SVM_EXIT_EXCP_BASE + PF_VECTOR &&
> -	    exit_code != SVM_EXIT_NPF && exit_code != SVM_EXIT_TASK_SWITCH &&
> -	    exit_code != SVM_EXIT_INTR && exit_code != SVM_EXIT_NMI)
> -		printk(KERN_ERR "%s: unexpected exit_int_info 0x%x "
> -		       "exit_code 0x%x\n",
> -		       __func__, svm->vmcb->control.exit_int_info,
> -		       exit_code);
> -
>   	if (exit_fastpath != EXIT_FASTPATH_NONE)
>   		return 1;
>   

This was the only caller of is_external_interrupt() - should the 
definition be removed also to avoid a 'defined but not used' warning?

Regards,
Liam
