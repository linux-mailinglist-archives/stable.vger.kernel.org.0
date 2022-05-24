Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1BB532FD8
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 19:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233792AbiEXRtG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 13:49:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbiEXRtF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 13:49:05 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F8D5D5E5
        for <stable@vger.kernel.org>; Tue, 24 May 2022 10:49:04 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24OHTpPt006687;
        Tue, 24 May 2022 17:49:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=uRHNvnNGKMBJS0cmj77O6/0ErE2oIgsLTAl4SAey0uI=;
 b=R/IsNJAAH/4Iw5OXzEvPepdXcsnmSkOjvvEVtF54gb8G536HMnuQhhTMEqbtIxlgpL3U
 yX9CbesVJoHaSF7p3+oe0o9kSDRy61l/FGGVc1+OTSMMLhODSVtZP3Xx1bmCIr1S/GYs
 k3Rdt6wMxIzom2z2VscXHcjx4wlcG5zQobxMWB4VFysyApMPuGGst16Cp8MrPo+wm51M
 lnlXmeK10A6S/WgosabTNb9taS9IZmpfp8IfUS0X335nnnbs6ilROw4VinQWt/v3YXJI
 1GY6VDkAPoSEoarNpGq5wTYOyh3LFRmbi9dCC5yMT6K0qwEtgNT1ZVmpH3xT+pGqGqI8 0Q== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g93tc01v1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 17:49:00 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24OHfbTj032382;
        Tue, 24 May 2022 17:49:00 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g93wpr965-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 17:48:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EDPGuO2jm2bvI0JNfAjUyTgvugY6S8HHq+KtLO+kWPKp/bOhbj/TlSZShIbduH/PXMpJ2emUHi3U+b2VrqfRz7POLRFsEYz9er65ZlrR7UX+8fXqn7ZfgkAIAWwRKnEPFQYdTYzbInvH48nJsS0lbA00tTM+PYNdo09tjslBxI81POtvRe1fyJxKaCtdC/a0M5XudO9CQsBI9vH8+2K02puNHlnlGGmv/CTXzUb6a2/jPdQlQ7B45qFO6HWhspW32piTXGSfTWX1tvvLrxxTdd97DTTHb29Ga6mGKKIqA8N21NhipQzC00nKUY714l9kDxQskXyeyHJ0rhh7ihnz1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uRHNvnNGKMBJS0cmj77O6/0ErE2oIgsLTAl4SAey0uI=;
 b=NxTxFkEP0Cxd1zNcfp9tbtGgyEf4UgkpMwIEAUvrm4x0mXwmOQxJVfvtgXl7ksHVU7UvJ77fpEoZ+7nV/Wud/JLZ1YQMMR081sInPInasGxU6N26rqc86aOMtaOVvoMoTp7LTf+CubBWRUhIoMcTFqOsIBPKcIH3uPDykEp29oMPyrWcwbJktWdNZ7FjUVmgzWqkbvoV4a5dxL+etpKEo2+SbzzUyswPwlP2ocrzQnFx7Xm8xacO7+CWLMn6Jm4UZhbPxmuZOX59F5g799bZwVBEK3PKRQcaqO7RgM2oVAM3eRrg92OcQhl9uA1k5Yyc3Dw3PTDrXkFRqzjhLIRl3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uRHNvnNGKMBJS0cmj77O6/0ErE2oIgsLTAl4SAey0uI=;
 b=T1wVbc6aMj01QRowMvUCAhX4E6oDP2Kw8S0CVsKWCx1prRGJl0Ooz1PZFDuywxq4LbEMaC8OcIxa44bDGxsJtbUpC/j55myLhr81gl5BGTuHdYqDz/UE3frQrxqvSDnqUEMpFhp2tnwC1SyAFlZpP2ISi3MvF3SjFx38N0pmHP0=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by CY5PR10MB6142.namprd10.prod.outlook.com (2603:10b6:930:36::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.23; Tue, 24 May
 2022 17:48:58 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47:2730:1cb1:bd51]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47:2730:1cb1:bd51%5]) with mapi id 15.20.5273.023; Tue, 24 May 2022
 17:48:58 +0000
Message-ID: <46577540-6ed7-0ff5-11d5-2982cd29e92b@oracle.com>
Date:   Tue, 24 May 2022 19:48:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] KVM: x86/mmu: fix NULL pointer dereference on guest
 INVPCID
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Yongkang Jia <kangel@zju.edu.cn>
References: <165314153515625@kroah.com>
 <20220524151118.4828-1-vegard.nossum@oracle.com> <Yoz4Qg+a5C/lw743@kroah.com>
 <e4127ebb-c589-ac2c-e77a-6c56a9c8fbc4@oracle.com>
 <Yoz7SFl7dIb65kPw@kroah.com>
From:   Vegard Nossum <vegard.nossum@oracle.com>
In-Reply-To: <Yoz7SFl7dIb65kPw@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR3P189CA0034.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:53::9) To PH0PR10MB5433.namprd10.prod.outlook.com
 (2603:10b6:510:e0::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a3ff4f40-cb16-44a1-8f8e-08da3dadadbe
X-MS-TrafficTypeDiagnostic: CY5PR10MB6142:EE_
X-Microsoft-Antispam-PRVS: <CY5PR10MB614204ECECD370E9C58FBE1D97D79@CY5PR10MB6142.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xA9WmQuMcWtTUn4H6TzSP9LdIb2h94kFYVIe7kXMA5hTy7DFU53i3Cr1Nn79xulnm9c3d6jwvs8uep+zv9udcYd03r96N3n42ESgqZCyNbrKFHDXbik3EYvp3PKFauUdrR574Ej+aTB65DQIavllYMTvp1L16ytmJR6HP7jpV13hgHUlfqlGXPHJGzFpqP8AmiNT8XHC8gLwF3ZlXPA7kxoH6TvWrRusKh2G5AOSDI8/9NCfwX8HVF8iewqkoPqfNJtgabK0eQ/xm0jM+dIb3ek3mNs6FC/+azp8gDpa3MdgdZGpnbhvFV5eE7GyG1SaohhHa1de/7G03MGWrRo3TIKSexNvvYFIHKpzWWY62eiP+sP24OsIfYu61ZPoA3rjOUdsPgbyUYPe84syetyM25hkIbcB7Mknb3LCXDMJLG4vzqxpvKQYFw+fgr12r+5Dmeah4mEsx1fWHB66KcJCakVVUmWAxs/W4ynP8BB3BXLy23+83zgr9hW1H1SZw5079UuTATPaSgBzknH8IGICbf6IfhI+2bo5D93FbWB66peiu6wCVxGK+SA4qi+F+adyQEEwxHSy5xyi3SUzxEmOErMnqO8zjTfVn6EbYPgCZQmYnp9rbFnyqAKuqWi5LU05oMaIp5w+7uHIGlEdVGzyfTJxHFnA7S8UF0daJL8wso+nWbgaWJ2M7AFz1mN/mylaiN4sVlGJm81DD9g4LlhHQrZDI3pyT7cdz5VjDgs3iECFqVIB2bDWqL8uMXVg4u2vXaq0LIs9/C/8jFSaX5EzNizODIsdKqjPMR20e4bPt+x+kQhJXKzcFf3lJsHhUsfOR3LloJ0jfUWx2unjvWZqMD1i5pzMVgM8bvpbsL1/4y402BVROR7UIi8qLfBfSF29
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(31696002)(2906002)(44832011)(5660300002)(52116002)(38100700002)(38350700002)(8936002)(6506007)(6666004)(54906003)(6916009)(53546011)(86362001)(83380400001)(966005)(316002)(6486002)(508600001)(26005)(6512007)(66476007)(8676002)(4326008)(66946007)(2616005)(186003)(66556008)(31686004)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MlBCbUtTQ29Uamw3cmFaQjF6MkhDNHQycWtob1pKdFhFK21wMmp6YmN2MFVl?=
 =?utf-8?B?SjNPVkkvWmg0TE9zcUJzb2daVDI5MjBDLzFmV216OW1VWkltL3ZUYXU3OUp5?=
 =?utf-8?B?SzZ4RlZ5Tkd5SHVkMklKZnJpemM1aXI4MW1MRFdNbXorUzFCSE4zZEVJY1dK?=
 =?utf-8?B?VHVNWWtjdEpYR2tzc2E3VEVZS1BzN0hVa041eGVNeFFVdEF1NllGUlh3c0Vw?=
 =?utf-8?B?V3R3TGc4SkFBVGpjMTFhRUhzY1lOK1dCVkNkdjVWb05uTk81WndPVHI1ajlo?=
 =?utf-8?B?cmNDeTVHaFFUMExIYXBXZDVyK1Foc01LZGdMd0liVGxGYkFtVzhoWXFoNlhO?=
 =?utf-8?B?aWRhbXNURWZtYWlqWW1KTFFHekozQ2xiMGx5WXRyZEFMWExUU2F6Rm9oRWVS?=
 =?utf-8?B?NnNheXFMVTNwd2RLZlNiYkorbUFjUnZPSlpUdG5CdXppOCtkOFJGbzVXL215?=
 =?utf-8?B?ZjlSV2EveVhFYTZHQmY3R3NlT3gxLzNJemlDeENwYW1nRVJCRmdqak1GREgx?=
 =?utf-8?B?ZFNsWGVhMFVNQ0N4ZGk5MDNpQTZ5Ylc5UTVxWHlmRmM3VXpxbStuYmljMmUy?=
 =?utf-8?B?allsMSswVVFlMzNYMFpBaEhqb0MwMVc2Y29FREczU0s2VjB5K252T2dHWHRn?=
 =?utf-8?B?U29RdGVTUzhoTHVWZXFhcGREVVppandBYitnbkRrRlJybDZPRzFHUXJ6SkZS?=
 =?utf-8?B?RlJHV2FwUnNWVDd2dHd6Y0FnT0xMczFnM0x4Z3M2WFJvMkdkOVh3Zk5KcHlQ?=
 =?utf-8?B?QW5hNEVVTytyTjhoZHBKam9oOHloL2RpYWsra0ZwVElSR1g1N2M0RWRpbFVh?=
 =?utf-8?B?cnp0VWE0UEs5bURXWlFkZlpIbVVDU3lEN0gra0IzSS8ybFprbTFjbm94bWhI?=
 =?utf-8?B?dVlaeDhrV1BsNUpCYzNpVGNvMmZ5MHRqSU1aTUY5Y01iTlFYS2lGVlI2ZUg5?=
 =?utf-8?B?WEc3MnFGNWp0WlFwZFZ0Mml3MFpxL0hWaW5paTB5dytkNlFsU202MjRmQWs1?=
 =?utf-8?B?L1drZE1pZ1ZWOEpVOE9nSDNMb2tvSnA2TFI5MkQ0NWUvVWIvbEZNV1ZVSjRY?=
 =?utf-8?B?T2NjZXdJOStrV0tnWENlM1RRODRDNXJ4M21rMGtZMGYwUE8zd05KZWZrdnUw?=
 =?utf-8?B?b01kUHpod1oyU0J0YmQvNEJqeGRObjJtN0RUVGhIaDJYWTVWZytkSGl5UGRj?=
 =?utf-8?B?d1E4eTVELzlFcmowVlllOSs2czYrUDY5TEtTVmlVQUlWVTBsNHFaVEErVUtW?=
 =?utf-8?B?a1YyeExVbStuV1NvcEZCNXRjU2wyMWdTaEpjRnRsNVB0WklyeGlrazJHN2ZZ?=
 =?utf-8?B?N1ZoS0ZueVZ0a0FnVDRkcmlmQzBxUFBtOUwxNGlrSC94ZGljWjFoZkFieFI0?=
 =?utf-8?B?Z0UxaHpQMkFTQlRrak4veXUyVyt5aGFiWS92eWo5aUprMHpIR2c2RG1GZXox?=
 =?utf-8?B?SU0zOWdwR203Y0xkUTdLZXBsZ0VWNkU3ZjFjSEtFT3c1MUplandGL1NNVXM2?=
 =?utf-8?B?dGZKN2Z0Q2FZQ0cyK05SS2xXVWYrM29HYzlLMHF6SGlBdU1XUTdJQi9uM2I3?=
 =?utf-8?B?T1B0RHNvK1k1ZDJtWVdpOTF1T1Foa3JpTld0d05NZHFHYjg5RHl2K0tuRmVU?=
 =?utf-8?B?eWFzUWxuQktVYnVWdWYvRjJSSFBCUkZtSy84MnRDc0UyZkRtYnpQYUVDK3Jl?=
 =?utf-8?B?THpMblFqL3ZxY1hGREM3T2k1TllpbC9sZzVxSVN6dVRBTkRUaUhkU1B5SDY5?=
 =?utf-8?B?L3ZjVWR4ZkVoT04yZ21sQXRwTUR0aWhNdjlnb0xkVU9XT1JFTkhac3poT3Np?=
 =?utf-8?B?MDRsRGtuZ0pPV0FrdFZ2V09pSkMxSTV0cHl4emtJZG11bGZjL0ZXTTkvT2hD?=
 =?utf-8?B?MnR2ZDZ2b1VUR2lQVDNvTUdaTjNpTkxNZEJRQXUweFIxSGh2ajVNaVFyWi8x?=
 =?utf-8?B?UVdTZnpUUC9rS2MzakVpY1JpZ2ZCell2VmlkYmhZR01GMmpqRCtmMjJHSU8x?=
 =?utf-8?B?d2RDSUg0bEt5UHlsWHp1Mk52WW5mVW5LaXQzNUh2TGJiRDZ4YTJ5bXFVM25m?=
 =?utf-8?B?UzFMZzFpZDQ3YjAzeENkT3dqbHFOd2IrZDBsNm4ySi90NnpMbmRvcjZDTEpv?=
 =?utf-8?B?K3ByY2o5eDBIZHFTOHdhK2h2MW1vZFFObkQ4QkJYTC90Q1hoa2N5RGZqTUhl?=
 =?utf-8?B?dktWMDRLczJscFlCWkpVbyt4SVNWRFdCL3drRXI5RW1DVzhvN1doMlRpVlUy?=
 =?utf-8?B?cC9yVmJwb0RmcWFrNFdiZFFtTnY1QXhjQkFiekkyVzViNHJvNktHUDU2OVg2?=
 =?utf-8?B?bEZZTW1uT293WngvbEUydVp3ajB3blczWXB5WGd0cWQ5QVZyZTE5cVQvRTN3?=
 =?utf-8?Q?SZkVtw/dH0McZChI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3ff4f40-cb16-44a1-8f8e-08da3dadadbe
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2022 17:48:58.3991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P7eH+OvxqZRbcj+Lc8yx7Rdn1/hy+GjsUs7kqOJUykbsvRwf14IusJ1wEmIM0xxBfk9JXCBHISX9dYVtOnz58LE+7fEkC8nGo2xt+mPamc0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6142
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-24_07:2022-05-23,2022-05-24 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205240088
X-Proofpoint-ORIG-GUID: RLvwtbT05ox-bnPrjv7eH3GoxZRLw_eQ
X-Proofpoint-GUID: RLvwtbT05ox-bnPrjv7eH3GoxZRLw_eQ
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 5/24/22 17:35, Greg KH wrote:
> On Tue, May 24, 2022 at 05:27:56PM +0200, Vegard Nossum wrote:
>>
>> On 5/24/22 17:22, Greg KH wrote:
>>> What kernel tree(s) are you wanting this to be applied to?
>>
>> I replied to the v5.17 email
>> (https://lore.kernel.org/stable/165314153515625@kroah.com/T/#u) and I've
>> only tested this on top of 5.17.9.
>>
>> Is that generally enough to trigger attempts to automatically
>> cherry-pick it onto the older branches or should I test and submit for
>> the older ones as well?
> 
> You should test and submit for the older ones as well please.

Thanks, will do shortly.

>> How would you prefer to indicate the kernel tree(s) in the future?
> 
> Just say so in the [PATCH 5.17.y] subject line, or in the signed-off-by
> area or below the --- line.
> 
> Responding to the email and relying on the thread alone doesn't usually
> work as the original message is long gone from my mailboxes, I can't
> keep that old stuff cluttering up the place :)

If you want to make it easier for people to respond to these emails you
could change the FAILED: message to list specific git commands needed to
fix and submit. For this one in particular, you could for example make
it say:

git fetch
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/
linux-5.17.y
git checkout FETCH_HEAD
git cherry-pick -x 9f46c187e2e680ecd9de7983e4d081c3391acc76
# <resolve conflicts, build, test, etc.>
git send-email --subject-prefix 'PATCH 5.17.y' --to
'stable@vger.kernel.org' HEAD^..

Just an idea...

(And argh, just sent out for 5.15 and I put "PATCH 5.15" instead of
"PATCH 5.15.y" -- does that matter?)


Vegard
