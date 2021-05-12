Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD7B37BBD4
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 13:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbhELLdo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 07:33:44 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46144 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbhELLdn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 07:33:43 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14CBP6Is096277;
        Wed, 12 May 2021 11:32:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=r7UIB7IM+7AnEBlTYgz2bx/r3KYJhkBlhOiDDXunl2o=;
 b=SEWRh+Y7s1xp3FKXT0FC5Lrq3hh9Wv7+4PMIlwLWNgGCXHcCPKDclMdS9vuv32AKybto
 0oSt0OurnFH6GBCIWOv44NUmmRdzsdvxulTQl7iT8z1beCpPlVevQb1bxm0bdl0KB3El
 VyUuhlBjeNel/jkucUjr+J4tD+5dkfwHys2pE/FPLZ+OhyxIU583anl20QctUTpYopm5
 DR/D7prjKzZDJCblaXrmGK7a81IBQvxJa//UgFWguazvHF4fnWirAkDUdX3+PV+uN3vA
 uLYaBs+HKxtrGXUApmDxYZ5Ojs0O5gyMKDYNL+5VIrcfZ6lqO9w4vQU1Y4Z+4SqPx9hA SQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 38djkmhq07-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 May 2021 11:32:31 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14CBPvrt142334;
        Wed, 12 May 2021 11:32:31 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by aserp3030.oracle.com with ESMTP id 38e5pytdck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 May 2021 11:32:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iL5vyVas6aj6amdBm0+EdbprLOFZRzncObwsn1bcpDamnFFqNgEl9VRvHiAo3zXKWbaqL/aQC/I3j3sn+Gv0y2qHKpNYiyS2BiwlYw2zGRO/YB8R0DuLi9Fp59hLgQjJgaGovX2sFa/uLHn3kQ2pX5VEoejJUxXflL1X4vSITIZJoUHzys9NCqyD8dXhK1rwksErZ8Zf5Mpy9U1mDF7e9Sj/c+VljeN+e1kFEzM7fMyrnskJoVt2Zvie4cvHGVS27IH4PiTryrz2MUIVlMfOCTBum4/BMiKFta98V5LwOJEbzP7MRxmdr4v9qZeBrm6QAKEq+0SyTiAcc8QdI6IIjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r7UIB7IM+7AnEBlTYgz2bx/r3KYJhkBlhOiDDXunl2o=;
 b=K2MQ3iRUYabopnY8mlwcYKRsmQL21bKZwiSmnwHW1JpDaXqkrxBEniDTC8OBdx9fNGOsMkKTm0/k1Zd/J182J/RSoLbnN6PtL3/vGLKbBHj/UAOlSgYo4FCefqB/pIiRJNaJ9URgF47N1KFVlsSwWnRo5Ol7Jh4lzGVDt+3NeO7Zwx56e9cMqaTPkPT0MqIvodnDeU+rE3Vmud3pNPzAni96WrxLIjL/aPHvMDfFeLZ9xCTd8M5KWFwlG1/Zpx4LZKSsgDzOeS8yPOSkCpPT9eYq2WT9uztacqiYIT4r/OkNfie0IL56cm1jdyvyHcaTxqyJFR9ziwsB+AIIX1rXVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r7UIB7IM+7AnEBlTYgz2bx/r3KYJhkBlhOiDDXunl2o=;
 b=nf64P6CJAhdYRwn4VNuO3ebnjH+FP2fzYCxj1/JE13ZcL8wWoRFnp8ualFiQ3GD/IKWg+mXN+AnDOb2AHnbTD2kBOJ3rpbHXT5x94lmQRpiys74l89EdT7G8xkgxuyX8YoJzYecORO1o3bZveBPJmcQ2qR4eaCWR7jGPOozLcMU=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3851.namprd10.prod.outlook.com (2603:10b6:5:1fb::17)
 by DS7PR10MB4894.namprd10.prod.outlook.com (2603:10b6:5:3aa::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.26; Wed, 12 May
 2021 11:32:29 +0000
Received: from DM6PR10MB3851.namprd10.prod.outlook.com
 ([fe80::e490:f9ff:f8f3:c1e6]) by DM6PR10MB3851.namprd10.prod.outlook.com
 ([fe80::e490:f9ff:f8f3:c1e6%7]) with mapi id 15.20.4108.032; Wed, 12 May 2021
 11:32:29 +0000
Subject: Re: 5.4.y missing upstream commit 4b793acd, causing: WARNING: in
 hsr_addr_subst_dest
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Dhaval Giani <dhaval.giani@oracle.com>,
        Dmitry Vyukov <dvyukov@google.com>
References: <c56d7a4e-d276-21e3-322a-66e2756ee6de@oracle.com>
 <YJuP1J+daFlz1fWv@kroah.com>
From:   George Kennedy <george.kennedy@oracle.com>
Organization: Oracle Corporation
Message-ID: <04538db0-ef0a-641c-8074-f13b37864319@oracle.com>
Date:   Wed, 12 May 2021 07:32:25 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
In-Reply-To: <YJuP1J+daFlz1fWv@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [108.26.147.230]
X-ClientProxiedBy: MN2PR19CA0045.namprd19.prod.outlook.com
 (2603:10b6:208:19b::22) To DM6PR10MB3851.namprd10.prod.outlook.com
 (2603:10b6:5:1fb::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.222] (108.26.147.230) by MN2PR19CA0045.namprd19.prod.outlook.com (2603:10b6:208:19b::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Wed, 12 May 2021 11:32:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e3b92a3-5925-4a37-ff49-08d915399fc5
X-MS-TrafficTypeDiagnostic: DS7PR10MB4894:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DS7PR10MB489484935D80391DFFAF7DE0E6529@DS7PR10MB4894.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CYYTUZm5oPaPBv11ZReFjQuakAWqM2dgQftNd4SHLFJD+xMTBWB6nHcZhZdl8WTJqxOgItjK8Prx0yfsv86IqXJBowZMjuzMyU3mCHdnKllbqokNyUu5pWbrNz/AIlHOzlaQDu090KCvEBTr95pNp5em+lgd4rIW0LOk+XDa6FdzVk3LtFU4uAXe4EBDO+S8ZrqSo8tAq+400rSrul1DJZtxh+ske448POuluz/iDC9GVmbB1h7MmaOpb7cUA9v08fPliM9U9uvsw/zP3FWGVq6+kmXfeu+9cxXG3iEdjWHMqIb1tGDJ4Pgenc0k4KCcOhX5C7iR7HZKuxXawyU0wKvn35b9G7hgKN6nA1N5izA+AU3iCG9v6gu8yfFZXRGUJ/8W3Y9kSurbYhzJhF3/QU89z5FLtbXIwbFRLG8F46vYCq+OxWIZoGooEGc0JNF1SdehtHfwW51O+u8fOy2LnS1OdqLmsz7vpX1Rxrjr/LmjH53TpuVbJiYnKNgOwmjji37AeOYUBZYquf7X5eAYw5F8P1Lz57uviRqsZPzOawhPX98dtd/51pAst9ME4HfEkal599mv0OB92YeliMnNOFvGvzBAYKxF9u4vcnGhvCwD20XZbu4WeW/ASFztcEIAChOumccRtbaUoeohNPFIQe4V1bN30ykh3qPE3iukCK5teXAax/VkhHPcCj7lZO1oKHO3YkSB46Wpq/9wIHz5PwaMLGM1RrKxDCSvjAbGL7+vKZ65QZAyp8WVPblHljV8j0/oUPTzavbeZEv6FpcVIiz4PB/HhQoiOWZCQ8eY7ag=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3851.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(346002)(396003)(39860400002)(376002)(86362001)(54906003)(316002)(31696002)(38100700002)(6916009)(2906002)(8936002)(16576012)(36916002)(31686004)(2616005)(5660300002)(956004)(44832011)(4326008)(36756003)(66946007)(53546011)(966005)(66556008)(16526019)(6486002)(6666004)(4744005)(186003)(26005)(83380400001)(66476007)(478600001)(8676002)(99710200001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?K0VKYTNYS0ZsTElpSERkM2Zxclh5eUxwVHlMSVJ2b1Yydm5DdVVRS3N0Ly9W?=
 =?utf-8?B?TUQ1cUpPWXplMDhmMmhrRHlvaEx4ZFJCUGFZOTJHWldiMkNZVUZzdklweFdo?=
 =?utf-8?B?dmpzMWZmSkhXMURpRVpCU0ZQMFdNMVpRWDExRVh3Sk91THp0ZWxJWmJ0cDlB?=
 =?utf-8?B?aHpUSm54eFJNaitISlFTcXo4aExTSkpUQzVEV0kzclFyTFRhUUhnQWFoUUEv?=
 =?utf-8?B?UFFwb1BUemMzaVdOYitxLysvb2h3djFwZmdnMEpJMEhZd1ptdjFYSHBoVGlQ?=
 =?utf-8?B?aldRTk5YdmY0QUgxRkVXTDdPUHVWNURlcGpBRUlmZkJ0eGdlL0lIZWp0b2lq?=
 =?utf-8?B?Wm9aNnlMTDVSZ3ZSQWpHbmRXKzNsK3Nyc05wdmhEenVUZUY0Sm5Ca0dhejJz?=
 =?utf-8?B?SFlwQUdwcFErNk1mdkkvY2RjRU1CeWx0RXBlUVpxQ1pzMnhHYnRsZWRidVBH?=
 =?utf-8?B?MU12b1BPenU0cW1rSlVwMUNDKzEySUxuTkhuaEhDVFUzdFU0NWVjTkRoVnNV?=
 =?utf-8?B?ZEJrV0Zvd2U5OEx5amFaV2xiVkExeklVVHhYSEFuQkxuUmtrVkJia240YzNU?=
 =?utf-8?B?MFlkL3VaRkk3dURmT2xxOE5IWDJ0czV4a09Ic2pyWU40czBNczFtUk4rei9a?=
 =?utf-8?B?SGNDbEx2cWl2K2cxVWJ0VGpBa0lzdmNjS0o3dW9yQ0ZWUFNSY0xuS1NtZUZ2?=
 =?utf-8?B?OVhsaUdHZThNcmJ4c1NXRmRzYkNMMDBubXYrMlkxeElXYWoxWkJpT3NnWVlS?=
 =?utf-8?B?Rk9rUHVCa0RhTzZPcm5hRm5nZTFBS3d2QWsyc2RxbWFwdk56Z0ROYW5JM3RJ?=
 =?utf-8?B?YjA3cnFLU2pkUVM2RVAybkNpUDZxQ25EbXVCZCtCanpaVk1qQVVZRHdHTWFN?=
 =?utf-8?B?U2V3Q3cyYWlmYkJCNUhPcnI4YUxLWVJsYjh6Y2tkWWV1M0RqWlRqQ1l2aW13?=
 =?utf-8?B?NmJRN0R2RmF0NGlyNnVtTm9UR2t4TDAwbUNyMHY1K0lzWUE5eFZVejdwY2VY?=
 =?utf-8?B?dEY5enY5S2UwTnF3UFFhUDdTbTBLWnplcEloR3lwRkV1c3d1dzhpZ2haMkVs?=
 =?utf-8?B?Nkl5SlNNbjZyNVZIQlh1ajg4MDVaeFFKR09aMEw4NDFpd0ZoMEpHS014cGN6?=
 =?utf-8?B?VnRuRytlSThaYjFrMjFUUzBUenRjTkpKZExkekNDNVJiZGJkUm83RldHeFRC?=
 =?utf-8?B?dkhGOHR6N2cxVW9uNldjanBwME56NGVJNy9rSzZyTjdVNmg2UW8reFRNT1Ez?=
 =?utf-8?B?MmV3NVBiTDVjN2YwdnJvSlZ1SzlyMnpWU1hDT1Zhd3BZWUl3TkdVTmsvMjhM?=
 =?utf-8?B?eXFoVkpEbkpIMDEySFF2RWxqVWp0TENCWlU2bzB5VmJuc2FJZEw2OXF2Q3VI?=
 =?utf-8?B?VGYxVGJ4eEJvazRlU2gvb3JHTW9tRFBTL2dsZk9qcEp0QzZyS2MxdEMwVlVR?=
 =?utf-8?B?THJSb05WbTBka205a2RiekJIaWlwSktmaG9adElCSjdsWUJIZklCZlNNK1pJ?=
 =?utf-8?B?aVJFUE92aFpPNWsvREJqa1QyVy92MmNISkN6aEphb0tINWtPMVEzZzdKOHAr?=
 =?utf-8?B?RkNjdmNtdzFaQ0RwM3gyTGQzTUs3Q0M5bVhCVlJlcDFuVnljVWNQK1VVVEVr?=
 =?utf-8?B?ODZEaTROMGh4UnhaMG5tOVltYlNubXlsZGZnejJPMlVZNWh6WHVkODJGSDRK?=
 =?utf-8?B?RGgyL1pBaDJlMTA5U1kwQTdzUVhycThabEVHbVc5bmozMGlTbzQ0ekFKbnNs?=
 =?utf-8?Q?zIYGCUP+fYprTXokzeNDr2aC1LQ/KWVaIdrHu5W?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e3b92a3-5925-4a37-ff49-08d915399fc5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3851.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 11:32:29.2725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1VD9g9N3vUbf1CPl1nJ/FcPXRV6DLsOTg3TXZA25608rAS2HnvhnjgS/T6he3MZNdy1FEvN0wKYaHBF9UFH3cDcojtKxs31La3Fx0oBHP6I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4894
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9981 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105120085
X-Proofpoint-GUID: JG4U5wEJk9jKks5p60trkyQsvfz4ueDM
X-Proofpoint-ORIG-GUID: JG4U5wEJk9jKks5p60trkyQsvfz4ueDM
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9981 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 suspectscore=0 clxscore=1015 bulkscore=0 adultscore=0 impostorscore=0
 spamscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105120085
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/12/2021 4:20 AM, Greg Kroah-Hartman wrote:
> On Tue, May 11, 2021 at 12:31:34PM -0400, George Kennedy wrote:
>> Hello Greg,
>>
>> During Syzkaller reproducer testing on 5.4.y (5.4.118-rc1) the following
>> crash occurred:
>>
>> WARNING: in hsr_addr_subst_dest
>> https://syzkaller.appspot.com/bug?id=924b5574f42ebeddc94fad06f2fa329b199d58d3
> That is not a "crash", just syzbot complaining about a warning.
>
> But I'll go queue it up, thanks.

Thank you Greg,
George
>
> greg k-h

