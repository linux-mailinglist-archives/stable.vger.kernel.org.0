Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 884D243F8AC
	for <lists+stable@lfdr.de>; Fri, 29 Oct 2021 10:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232414AbhJ2IUu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Oct 2021 04:20:50 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:15890 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232438AbhJ2IUt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Oct 2021 04:20:49 -0400
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19T7uLpQ014216;
        Fri, 29 Oct 2021 01:18:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=subject : to : cc
 : references : from : message-id : date : in-reply-to : content-type :
 mime-version; s=PPS06212021;
 bh=MtZW+xb/VqfffBgoHg5+12/Z5RAl4D+IqDz1Mueywug=;
 b=ZwGEIIeET7Ftvo4jBzlHrjmOWtEoM6gGxs29XSM3wbknw7rZVd0fm0wNgOUY/ef8B1I5
 HZpocznU0d4ntV66E88lV2U/lqGbY072SUVL4w1uhScpBMfpi1RosGAew38t8dEzc7pL
 52T3UKvwMlL058Z7cJAcTcIjFavEcpZemFTTJFtx/+jE0L48gjZSGxqvclswJfAaCGw0
 wQgInn0VVFXTzWa9X80nVA+hKfqAFVKESWCSOgWZAnlcl4t4xu7yuu0D1vm7mJqtlYIp
 QpWh8JYwxuc2GkWS/VKjXsKfPD9a21ZKFjlSSdU7Ha7bc+/2M5/TEn31RtBReVRMBO08 EA== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by mx0a-0064b401.pphosted.com with ESMTP id 3bycjw9h8j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Oct 2021 01:18:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rl0W4ab08K82QBRqIUKIgPCrPiEYXe0nGykMCx//DCnDJG3pDNHgX/PbQ6Pr5hoLK0OGnC6AxkzID+SiOuO4otmRpdfqhY8ULgPFXaALqHIXh2cn41yP2t2vBlHc4TYv36B6rlO5+GyhzUQMD92waAc1hVLgA1Iw0z6EghhNRejFkO/wefbm3m7MHh2gaPxb+3GbIe84kywGW6OviFT6H0VxyzCVhfkNgqllCi7NM/oyYp4P7cTF1xBQ6UpEequAupI0IgnPQxbrfp8v8gJ5eNMazPO4VfTrg/XuPm0cKF0bATdICRLmEFRpnFVPc/4zlnStsaLt96i5vw6RgZJaCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MtZW+xb/VqfffBgoHg5+12/Z5RAl4D+IqDz1Mueywug=;
 b=bT/+lJq0K8+x8/t6uOBL1GZdavXppZxbztHuJTTPDsgB5zxJ3AHZgsMe9c2ZiaAvdAMwgDaky+qef7O+uNTztJUBOAmF8BWPaje7lKgPx0NcVLss8s1FHEQkn0O6wB2U3fsgMPxpIt1Bq8vCm5m4SpHID1Rw3Bn39dh6RvhI7zWnynDuhkDeVM/N58MswPOsPRaN/nkYguF+8rt/Tw5eD/Msw5kLWKi8t6IBEUYVwAVI+WpdoWFBiY7BongBO2C9PzpX1ypRqwUF4FYoh71NwB5OInwP934IcvlZK3cmUzuhTzEzYvVokRgBYoql+1suuf1+4IFXMm3p+Xan00gVeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from BN9PR11MB5321.namprd11.prod.outlook.com (2603:10b6:408:136::8)
 by BN0PR11MB5727.namprd11.prod.outlook.com (2603:10b6:408:162::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Fri, 29 Oct
 2021 08:18:17 +0000
Received: from BN9PR11MB5321.namprd11.prod.outlook.com
 ([fe80::98b4:7a11:22a8:3916]) by BN9PR11MB5321.namprd11.prod.outlook.com
 ([fe80::98b4:7a11:22a8:3916%7]) with mapi id 15.20.4649.015; Fri, 29 Oct 2021
 08:18:17 +0000
Subject: Re: [PATCH 4.19 0/3] ipv4/ipv6: backport fixes for CVE-2021-20322
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <20211028190901.1839515-1-ovidiu.panait@windriver.com>
 <YXulOpILxpS+ljKY@kroah.com>
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
Message-ID: <cdf08090-1f48-4a90-4c68-139b706fdd88@windriver.com>
Date:   Fri, 29 Oct 2021 11:17:16 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <YXulOpILxpS+ljKY@kroah.com>
Content-Type: multipart/mixed;
 boundary="------------36A833CC57B22FBD3667A872"
Content-Language: en-US
X-ClientProxiedBy: VI1PR08CA0125.eurprd08.prod.outlook.com
 (2603:10a6:800:d4::27) To BN9PR11MB5321.namprd11.prod.outlook.com
 (2603:10b6:408:136::8)
MIME-Version: 1.0
Received: from [128.224.125.152] (46.97.150.20) by VI1PR08CA0125.eurprd08.prod.outlook.com (2603:10a6:800:d4::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Fri, 29 Oct 2021 08:18:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e28a87c2-355d-4d55-3137-08d99ab4a8e4
X-MS-TrafficTypeDiagnostic: BN0PR11MB5727:
X-Microsoft-Antispam-PRVS: <BN0PR11MB5727D29AB7AA459D8363A071FE879@BN0PR11MB5727.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tTL3QNfVsxZA35nhiwV67ESYPkqCAT8p+kYr8VpdZQYdow5QQyEEtD6i2kNqePv8FKjJ36V2pKVR2N8n2AEfkSx7ZN4k5wmUuHyYKS/dg+KgVfBlnnO3PhMu1/VBAmKTg1D2WI/zG7Gty4XqNd95O1XnNqBf4hrJ+VF5dfU3ZlzPe/nr3xOz/DGB0xsZ05hnNT0Tk5nEzRsxNURJZEpZAlcTHwNU7osvERlsDlviFGe3+9wklE5tQqvUfLsANdGmuDm9ewcAaU9Kg3Lix8mtqE9JDprnc90QGkssul+ksqfbRVV9a9UWwF9/mXX6uxqj7k8i0vvs622wIpZvldPYNVJ2Jwyfgx7UFYAv+Y/e/FTMp032gQbUyvbHNGGy1l5FFwE6KHCXxY5+vz1rzYUfNrHk3titGNfZKrqqbe7XKe/P6OrfOHg9jw0yR1hhWAqp6ooLPPIlVTw3O5kQWo2Czk33l3mSx+NSEPXLv/RRxwrVvYNClFfhuyATeRcD5yY5AKZ92qqyZPYwbxhGsshHsRTLNcK1+eQcn9RS34LfoVX+je4GvbQOpKGkmSfsf8gTdKsNI2PKt54dImrHgHCd61zqHoPMxVfhEjBEMGms/tSlstTQzqCOAhxR9FHx5ReC/j1nG1B/GVYm4/9eDKw2IM0wTdyipQHiSAyB504a2WiGhQHGZ/jxM35Inah6bguKTZY3WtHNlT4ehrXK78g2a+wWWzgKlnXYmt8X+nhMMI/rlK+zfeHgTlYfUCFDf5K2Qjyn5zYyr+ZARe9/vQMUon1DwAS1svPcQWMlLniU+gE6Te8bpeogi+EKEsa34Wj84Ptj9DFwP4mdGJPXRYCOZfCttWwQ0LqaFQfvRHVo5pQHr7ZF/oMnYVmRwBCWG2PJPaDNNCy/6ERQpfJVGgZ5v7zoTysng3jM8LmTMm18Nd8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5321.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(83380400001)(8676002)(16576012)(38100700002)(52116002)(66476007)(316002)(186003)(4326008)(508600001)(36756003)(66556008)(38350700002)(235185007)(5660300002)(966005)(31696002)(956004)(33964004)(86362001)(2616005)(6486002)(31686004)(6916009)(53546011)(6706004)(26005)(44832011)(66946007)(8936002)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V2l5VittblQrSGYrZ0xBTEFwbnBLSW9XYU9Ralhwa29USktZUHJUSTJnU3Ir?=
 =?utf-8?B?c3JjOWdidUpKUVdTNE9EZGZNdkloRldnVDg1UXAwOWZDcEZvaVpHc1NGczdn?=
 =?utf-8?B?eUJYbk84Tm83RnltRTVtSnFFQXdsVndwY1Ntd0tkRG5SL0FwWFpYZnRTQ2sv?=
 =?utf-8?B?RHRMTVVwdVRaY2cyM1JXM08wVC8xSmo0aUhRVElCWVpvc0FET3VjMHcrVE5M?=
 =?utf-8?B?ZUJYOE85SG1oanB0SWIxcTVLeEYycVNlVXl5U3ZSV0V5VDNFb1Q4SVM1bWZq?=
 =?utf-8?B?UmFEUTdQQ2M0aHhrYUZ0aWpJNDlYS3hmOVhONC9oZEt1QkpKRnF5N2ZoelFF?=
 =?utf-8?B?RW5hZHlQYW5zUEFhZWZoTEVyKzlKY20vK2g4MGFEcmljdDVvTzhoTS9jT0lG?=
 =?utf-8?B?SStDMzFGVmxWRjJuTVVsTGR2NXZ5cFBiVnprL1llNnVDbEhDMXJPTjRnbEZw?=
 =?utf-8?B?VUNoK3lvRXhDcUNxY1FNVjcrQU9WaXV4dnZuM0dqblVOanpDeEk3WWFnYXBO?=
 =?utf-8?B?eVowSkhRNUpHU3MwWnlJbk1pZnRWNFFScGwxdXJ2T0JzQjNjVVg4NStCaWJw?=
 =?utf-8?B?eEszdEtob2hiSVk3V1NRbVB2T3pYb3RHcXRZZEFnOFFkdVYvQWF6QXVpQmMw?=
 =?utf-8?B?ZFptcFZhckUyVG9SSjZCV1hmUng5ckhVdmtLN3FMZ2RBNjUwYWtDOWk3Yi9O?=
 =?utf-8?B?WHhDdGZYTVQvVXVJOXUyUnpROERiMUU1dEl1cmdScEM3M1JTNFZtVkFaazRq?=
 =?utf-8?B?N2RpUWVGeGRFN0h4M3kzOXJVWXgwcUFSQ3NoQ1AvbEtkZStobnZwU0RKdlBU?=
 =?utf-8?B?czFxTTU4T0VsSHFxS3JuQVJXSzdWTmpwbUNqZFhua2hGSGwrS3FZNnFnMitR?=
 =?utf-8?B?VDFGY0crYWJScXZXV3FOSE56Zkg2Tnk3aGZaeWxaem1kUXNnN2I2QjVEOEsw?=
 =?utf-8?B?dGlHbU0xWVo0K20xTXUzU2RWbmVpYTBERjJkT2J6Wlp2c1U1Mys0ejNmQTlW?=
 =?utf-8?B?V2ZicE9xdzJEKzZteis5cGNmckVQVTVFSUkyOC9rTXZWOFdCQlpLU3FmNzRR?=
 =?utf-8?B?dnRpbXRnaFJLVVRyaXZwdHBTY00vVTY4N25WMElENUpaNEM0ZWxHelFuaWtO?=
 =?utf-8?B?aFVjUzBOQjNabGd5T21mcXNCaWwzSG9XRlhVZ0lNcWY5ZnArQysrK3lWN0hD?=
 =?utf-8?B?VDA1UDV6RnAyZlQrYlV5aGV1QXFZdkFod3hjM21pRG51aThEQUFleXlTUFRl?=
 =?utf-8?B?MEpmYWtkSHNIVTBaRGE3eWZCUXhtWVZHSExDNW56dHZDbXdxMkVWMGZsbnRk?=
 =?utf-8?B?U3NQdC8vazdsalhhczFidHlRL0hhTzhXalMrQllIWEoza0lpZlB1cFNJdkVH?=
 =?utf-8?B?K1V1TGJpbkRQcFRlMUxZdmR2SnFhL3h3bnJ0a1I4OHhYdWdrZ1lOZFdsUTN2?=
 =?utf-8?B?bkovT0FYWm5GcDg5dlA2NzlSelJJekRybVVXSnY2R21sME1CT1prSTVJN3dY?=
 =?utf-8?B?cDRrWXlvUmZVNEdUQzR6UVdDOUFHSk5CNGVvQUlpeWtSVVZaV09tRThaY2hh?=
 =?utf-8?B?WThSTnVWb09LWklJK2UyQklEZ0FUMllRbGdkanBzVXorbjZDMEpPTmN6QXR5?=
 =?utf-8?B?bXIvb0NZbE9tbk5TY1JNNkdKUjArMU1jYnNtTVNrWGwyYUhRUDZHaitLWW5z?=
 =?utf-8?B?NitGRDBoMnVFNGE0cG41cWZUMVlnNjFhRlFvTFRwakUvTWRoM2dDd2p3bmJK?=
 =?utf-8?B?T1VhSTR6U256eFFQeTEraXZaT3p4dzV2b05MUlk4TWVZcjZFVjhHOFpTYTZF?=
 =?utf-8?B?TTlDWFBsNUZyc21EbU9aa1Noc3NZTTRHaWhSaTBCQzZxSmFLQXZWSTFHeSs3?=
 =?utf-8?B?SkxvMlpBdmljNCs0d0xpUTh0d0xQZVVMTklicStTSDJrS1k0MklLWHA0TGxS?=
 =?utf-8?B?alViYXlmc29QSHphd0VrYUZSVjRMdWZRaTZaNEdHUG1NVGZncG1nZ2VoNmNz?=
 =?utf-8?B?Ulk2bWJOV3Jlczl4SWxFWnc1RUxWOGRGL05BMEFLU0l3VERzZWNiZk50UGtS?=
 =?utf-8?B?NFJSMGlqR3AwM25wdmZnZldCWE9hbWpTa1lwNHNibTJqWkpDbWhNa3h0NlJN?=
 =?utf-8?B?T1B6Ly9lc2FOVmJjQ0tBOC9SbUs0MmNWUTRGRnp2Q3FwRW5NNGpRWDdmci9J?=
 =?utf-8?B?T2NaRDRpN3YrNUNrajFoL3VZazB0cU1MV2FhcGNkOGFSVHd6ckN1STZCWTdn?=
 =?utf-8?B?aUl5bzR3RXpnREdKeWxyMXlGaGNRPT0=?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e28a87c2-355d-4d55-3137-08d99ab4a8e4
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5321.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2021 08:18:16.9646
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gVyRuTkLNyHLss55AJcnw63ydD/HbBe5eFJP1IQ7NTqmplUCY6fcPrIVxe1dJLnZQHlW+9sb48R/zqPFFtrim4KHTDn533uLg/qQVnhwRTM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR11MB5727
X-Proofpoint-ORIG-GUID: 713VV3Sh3K3NBy5zkHPmZkcVmtDIwGE8
X-Proofpoint-GUID: 713VV3Sh3K3NBy5zkHPmZkcVmtDIwGE8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-29_01,2021-10-26_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 spamscore=0 clxscore=1015 impostorscore=0 mlxscore=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=362 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2110290047
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--------------36A833CC57B22FBD3667A872
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Greg,

On 29.10.2021 10:39, Greg KH wrote:
> [Please note: This e-mail is from an EXTERNAL e-mail address]
>
> On Thu, Oct 28, 2021 at 10:08:58PM +0300, Ovidiu Panait wrote:
>> The following commits are needed to fix CVE-2021-20322:
>> ipv4:
>> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6457378fe796815c973f631a1904e147d6ee33b1
>> [2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=67d6d681e15b578c1725bad8ad079e05d1c48a8e
>>
>> ipv6:
>> [3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=4785305c05b25a242e5314cc821f54ade4c18810
>> [4] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a00df2caffed3883c341d5685f830434312e4a43
>>
>> Commit [2] is already present in 4.19 stable, so backport the
>> remaining three fixes with minor context adjustments.
>>
>> Eric Dumazet (3):
>>    ipv4: use siphash instead of Jenkins in fnhe_hashfun()
>>    ipv6: use siphash in rt6_exception_hash()
>>    ipv6: make exception cache less predictible
>>
>>   net/ipv4/route.c | 12 ++++++------
>>   net/ipv6/route.c | 25 ++++++++++++++++++-------
>>   2 files changed, 24 insertions(+), 13 deletions(-)
>>
>> --
>> 2.25.1
>>
> You sent 0/3 but only 2 patches showed up?
>
> Can you please resend all 3?

I tried resending the full patchset, but the last patch is still not 
showing up.

git send-email doesn't report any errors:

OK. Log says:
MAIL FROM:<ovidiu.panait@windriver.com>
RCPT TO:<stable@vger.kernel.org>
RCPT TO:<gregkh@linuxfoundation.org>
From: Ovidiu Panait <ovidiu.panait@windriver.com>
To: stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org
Subject: [PATCH 4.19 3/3] ipv6: make exception cache less predictible
Date: Fri, 29 Oct 2021 10:50:27 +0300
Message-Id: <20211029075027.1910142-4-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211029075027.1910142-1-ovidiu.panait@windriver.com>
References: <20211029075027.1910142-1-ovidiu.panait@windriver.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Result: 250


I have attached the 4.19 backport of a00df2caffed ("ipv6: make exception 
cache less predictible").


Ovidiu

> thanks,
>
> greg k-h

--------------36A833CC57B22FBD3667A872
Content-Type: text/x-patch; charset=UTF-8;
 name="0003-ipv6-make-exception-cache-less-predictible.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0003-ipv6-make-exception-cache-less-predictible.patch"

From c9f6f8ebbc70e5cf357f80b77400f0233027b39d Mon Sep 17 00:00:00 2001
From: Eric Dumazet <edumazet@google.com>
Date: Sun, 29 Aug 2021 15:16:14 -0700
Subject: [PATCH 4.19 3/3] ipv6: make exception cache less predictible

commit a00df2caffed3883c341d5685f830434312e4a43 upstream.

Even after commit 4785305c05b2 ("ipv6: use siphash in rt6_exception_hash()"),
an attacker can still use brute force to learn some secrets from a victim
linux host.

One way to defeat these attacks is to make the max depth of the hash
table bucket a random value.

Before this patch, each bucket of the hash table used to store exceptions
could contain 6 items under attack.

After the patch, each bucket would contains a random number of items,
between 6 and 10. The attacker can no longer infer secrets.

This is slightly increasing memory size used by the hash table,
we do not expect this to be a problem.

Following patch is dealing with the same issue in IPv4.

Fixes: 35732d01fe31 ("ipv6: introduce a hash table to store dst cache")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Keyu Man <kman001@ucr.edu>
Cc: Wei Wang <weiwan@google.com>
Cc: Martin KaFai Lau <kafai@fb.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
[OP: adjusted context for 4.19 stable]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 net/ipv6/route.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 9bc806a4ded6..d04f3951c5fb 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1454,6 +1454,7 @@ static int rt6_insert_exception(struct rt6_info *nrt,
 	struct rt6_exception_bucket *bucket;
 	struct in6_addr *src_key = NULL;
 	struct rt6_exception *rt6_ex;
+	int max_depth;
 	int err = 0;
 
 	spin_lock_bh(&rt6_exception_lock);
@@ -1515,7 +1516,9 @@ static int rt6_insert_exception(struct rt6_info *nrt,
 	bucket->depth++;
 	net->ipv6.rt6_stats->fib_rt_cache++;
 
-	if (bucket->depth > FIB6_MAX_DEPTH)
+	/* Randomize max depth to avoid some side channels attacks. */
+	max_depth = FIB6_MAX_DEPTH + prandom_u32_max(FIB6_MAX_DEPTH);
+	while (bucket->depth > max_depth)
 		rt6_exception_remove_oldest(bucket);
 
 out:
-- 
2.25.1


--------------36A833CC57B22FBD3667A872--
