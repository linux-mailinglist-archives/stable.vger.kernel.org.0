Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 587951D3932
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 20:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbgENSi4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 14:38:56 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14190 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726188AbgENSi4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 May 2020 14:38:56 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04EIVbCu016121;
        Thu, 14 May 2020 11:38:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=//EOt1vLsmFdpDGhSyWjqy63vscIaMTpukbdJMu+tw8=;
 b=JaaVa9Duv5qTB3+sM+4s9YLe45UYTg4FXA6xTzKTbLEmolK2rn95ijOgUt9dG/6dEQtt
 cr0p7t13UHo3P0AtwhoS2AA3ziTUEsRChqiOumXE5WzVi6RvoFvqJ9tC+C1mc+dCVA2a
 Tq/LSC3bSo7myhssf+7yFfS+8gRxiBls+SE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3119kprqvb-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 14 May 2020 11:38:51 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 14 May 2020 11:38:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XU20D1M/ZPR/A9iRCdwoGNNTzPhs//kV+WpK3tcbuMB9srJFxvp7iNWv07X0aMLwZyy9KsDHBw0EQLQGTrFh8FnyCG09KYqeonoGoUKL67NpXnCroASdsdNt/X5YcLtwvfObh+Dbam4iWyvoOpaeRKF10H/aVS92P0/GuLZdZ/z6OClotlbTXxu3w6iBusRyH9HsMdzKbdJ5XmVK2Eayzr34tB5Hzo8xfITwFloRzDhJ81bv8cTLQYkf6Qcd6BH9fGxTXdh33swdMdudNKFX5dQczhXW2JZ9+MpECzvPrPIheG/YrpLXuJGvnkRQP5k81JRecD+lp1WllLssgrPgkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=//EOt1vLsmFdpDGhSyWjqy63vscIaMTpukbdJMu+tw8=;
 b=LoIf/SK46h/T+gQuofRJOKJGJedTkZR079iJlfzUiuNSEdDV/OWh1E8aMQNfbpsUwEfz5K/VjVz7NGfElm9GH5+p7nH2gS2WGwqylGdU69Q6NG/qfOh7GX/5PqAx0SknMs0mu+wlGZ1pWWgrosk+8V3IKWGkgDPKSmdweS/troVUstnS+iFcG33yiBrliDCWgnQ4ti+i1m1f5aAzCntxBElKJZbsqih+S90DUoBzt5vPBmWTm6H9Wikfp7qsMoG70tS4YrP7DCcZH9Trt9XA+FcpEKP6KrPraWlNzF/c8kUNEDe6oH38aAc17k9N3wHq289hopTsG6qj+KVyIbl8pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=//EOt1vLsmFdpDGhSyWjqy63vscIaMTpukbdJMu+tw8=;
 b=Q5UQQb9wukDvLXtZ+Q7x+psC5aY9oImK7jGiyxbWdhLzHA4N5yZ/8987dyO2UDhpt1Hx9eU2M7mfE7W3VJIYwgcPWfrv6rq0O5R3m3P/P8EQ2Hv9bewX3FfkKcJo1IKaXCNpMwolI0VkySwtPFmDw6uXZOgZOXd8Jiw8Ud7yAa0=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=fb.com;
Received: from MW3PR15MB3753.namprd15.prod.outlook.com (2603:10b6:303:50::17)
 by MW3PR15MB3932.namprd15.prod.outlook.com (2603:10b6:303:51::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20; Thu, 14 May
 2020 18:38:29 +0000
Received: from MW3PR15MB3753.namprd15.prod.outlook.com
 ([fe80::599e:12d9:5804:c0e7]) by MW3PR15MB3753.namprd15.prod.outlook.com
 ([fe80::599e:12d9:5804:c0e7%9]) with mapi id 15.20.2979.033; Thu, 14 May 2020
 18:38:29 +0000
Subject: Re: [selftests/bpf] da43712a72: kernel-selftests.bpf.make_fail
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hangbin Liu <liuhangbin@gmail.com>
CC:     <stable@vger.kernel.org>, <lkp@lists.01.org>,
        <bpf@vger.kernel.org>, kernel test robot <rong.a.chen@intel.com>
References: <20200513074418.GE17565@shao2-debian>
 <20200513095835.GD102436@dhcp-12-153.nay.redhat.com>
 <20200513102634.GC871114@kroah.com>
 <20200514031420.GE102436@dhcp-12-153.nay.redhat.com>
 <20200514103017.GA1829391@kroah.com>
From:   Andrii Nakryiko <andriin@fb.com>
Message-ID: <e5221ecb-04ad-bc77-d66f-b438c1a8b5c7@fb.com>
Date:   Thu, 14 May 2020 11:38:27 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <20200514103017.GA1829391@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR21CA0010.namprd21.prod.outlook.com
 (2603:10b6:a03:114::20) To MW3PR15MB3753.namprd15.prod.outlook.com
 (2603:10b6:303:50::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:2103:51:fde8:f2bb:1332] (2620:10d:c090:400::5:8ef9) by BYAPR21CA0010.namprd21.prod.outlook.com (2603:10b6:a03:114::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.5 via Frontend Transport; Thu, 14 May 2020 18:38:28 +0000
X-Originating-IP: [2620:10d:c090:400::5:8ef9]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce63b4ea-4fd5-45cf-f424-08d7f835ff1d
X-MS-TrafficTypeDiagnostic: MW3PR15MB3932:
X-Microsoft-Antispam-PRVS: <MW3PR15MB3932191FC8394A7BBEAD3638C6BC0@MW3PR15MB3932.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 040359335D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bcrr6P/mjK3JhXaeySA9qpDJ8CrzDrJrXQgl3PNcL7ZRKfiE6DXqD6IlEEvQXrYC53xMacGgaSxIFCPV/M7Op6YDia6PRdnlqHHvq24TyZ4L4I7JmiGHmzQlh530JFZHd1f/miMoNXw8ETRxzOewFlvWIQhMqgOj+5mbxtkfe5zHz4nvr8FEttrQyrrROT3E7/OtHZkgNODvpczTVKIeL1S2OiW/kxQZb2L4ddPzmoYxtnrlqe1ImO5aGL8c84rdEKcme9UaHh9yxBCS2Oa/ZiZdndV5EBYoTvL7CxuFcYrd+LPhr4oMdoB/KkhUKGMIXmtC6I6L2ZDKhlFUECx5Qwi4gAyGpyeKAx9xCuXBq4OjjwjbCFl/hKCMV91yK4FpCds28S0X9xz5UMKFiH7fr1rvKHP2EY6qO19eVvgnNKwuQtbr6Lqn+WU2RUdfKz757666KFhBwDgHX3+OjtikWjIO1Z2HaDoZdAkQreUOVwJOhJJGvjee8dpycTOOUOrS9M3sXxT0SkLYaAni1trrbJ0o0yaCUyuq39Wgli9ZhzV7jG9u3DAuLFgGF+pEJ49CtzGXo8yY1xTp5pjuRYV0BQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB3753.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(376002)(39860400002)(346002)(136003)(396003)(110136005)(16526019)(5660300002)(31686004)(316002)(6486002)(52116002)(186003)(2906002)(53546011)(31696002)(2616005)(86362001)(4326008)(478600001)(66946007)(8936002)(8676002)(966005)(36756003)(66556008)(66476007)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: sYY/Q6Lg0059LsL5lqMf9zJ/9h8+fEe/8qzzeHxxKu2lPeOh7yAqrJMDxuE9wq9VxbgpLIQMhSNePqfDVARtGD7cAG1M0mLb8zNyKFc5xQD1gDTh54SqrhjzhW17WeopKdc8f2gsTK2CNpizuAtF4xdWiCxIC6/lrol0F6sBDE0vsg8EdZP5wDLCjEnY5xXFK+3vK7hM5xlC4GYDfQLmj8wilrH+eBPw22CYdwTE5w6qHHhXp6opU7kNqDEIsBiNM4FghySE8JinQbiJYMttGmjQ0Vw4wCeu4NGAdKlONdscA2Zg2wH/KpJOJWo1zbh9uj4rUIuUBxOkKh67dv+hJhZklR2KeRY6f8HPOFniStQ7Bzn5wZYuxgEvNbjVuHkWWEI/voIcSp+5FzhejQhdNnn4ucGmcsgmVnAZVEIiZ6h9lJWDM6IDfrOkb7nAHg/vRjmAdpTNmty4hhXfidLSrk1VOB0vzUzYXXRyVOqbSib9kUYMBt+mTQQL1uK+q+9PdQDThpsqZ+2l2ERlPFIzwQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: ce63b4ea-4fd5-45cf-f424-08d7f835ff1d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2020 18:38:29.5891
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cIpIJI8MD25KSFER9OtoiMhbvv52F6q6MHfqmT42mvGWiiH+YLihn0TPC+D6rToD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3932
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-14_07:2020-05-14,2020-05-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 lowpriorityscore=0 suspectscore=0 cotscore=-2147483648 mlxlogscore=999
 clxscore=1011 mlxscore=0 adultscore=0 spamscore=0 impostorscore=0
 phishscore=0 priorityscore=1501 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005140163
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/14/20 3:30 AM, Greg Kroah-Hartman wrote:
> On Thu, May 14, 2020 at 11:14:20AM +0800, Hangbin Liu wrote:
>> On Wed, May 13, 2020 at 12:26:34PM +0200, Greg Kroah-Hartman wrote:
>>> On Wed, May 13, 2020 at 05:58:35PM +0800, Hangbin Liu wrote:
>>>>
>>>> Thanks test bot catch the issue.
>>>> On Wed, May 13, 2020 at 03:44:18PM +0800, kernel test robot wrote:
>>>>> Greeting,
>>>>>
>>>>> FYI, we noticed the following commit (built with gcc-7):
>>>>>
>>>>> commit: 77bb53cb094828a31cd3c5b402899810f63073c1 ("selftests/bpf: Fix perf_buffer test on systems w/ offline CPUs")
>>>>> https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
>>>>
>>>> The author for this commit is Andrii(cc'd).
>>>>
>>>> Mine is f1c3656c6d9c ("selftests/bpf: Skip perf hw events test if the setup disabled it")
>>>>> prog_tests/stacktrace_build_id_nmi.c:55:3: error: label ‘cleanup’ used but not defined
>>>>>     goto cleanup;
>>>>>     ^~~~
>>>>
>>>> Hi Greg, we are missing a depend commit
>>>> dde53c1b763b ("selftests/bpf: Convert few more selftest to skeletons").
>>>>
>>>> So either we need backport this patch, or if you like, we can also fix it by
>>>> changing 'goto cleanup;' to 'goto close_prog;'. So which one do you prefer?

Hi, sorry for late reply, missed emails earlier.

The above "selftest to skeletons" commit will need some more after that, 
it's going to be a pretty big back-port, so I think just fixing it up 
would be ok.

>>>
>>> I don't know, I have no context here at all, sorry.
>>>
>>> What stable kernel tree is failing, what patch needs to be changed, what
>>> patch caused this, and so on...
>>>
>>> confused,
>>
>> Oh, sorry, I should reply the full email. I will forward the full message in
>> the bellow. For your questions:
>>
>> the stable kernel tree is linux-5.4.y,
>> my patch is da43712a7262 ("selftests/bpf: Skip perf hw events test if the
>> setup disabled it")[1].
>>
>> The reason is we are lacking upstream commit
>> dde53c1b763b ("selftests/bpf: Convert few more selftest to skeletons").
>>
>> This will call build warning
>> prog_tests/stacktrace_build_id_nmi.c:55:3: error: label ‘cleanup’ used but not defined
>>     goto cleanup;
>>     ^~~~
>>
>> To fix it, I think the easiest way is change the "goto cleanup" to "goto
>> close_prog".
> 
> Ok, can you send a patch for this, documenting all of the above so I
> know what's going on?
> 
>> For the other error:
>>
>> prog_tests/perf_buffer.c: In function ‘test_perf_buffer’:
>> prog_tests/perf_buffer.c:39:8: warning: implicit declaration of function ‘parse_cpu_mask_file’ [-Wimplicit-function-declaration]
>>    err = parse_cpu_mask_file("/sys/devices/system/cpu/online",
>>          ^~~~~~~~~~~~~~~~~~~
>> ../lib.mk:138: recipe for target '/usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a7262891317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/test_progs' failed
>> make: *** [/usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a7262891317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/test_progs] Error 1
>> make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a7262891317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf'
>>
>> I think Andrii may like help.
> 
> That looks like a bug, we should revert the offending patch, right?

6803ee25f0ea ("libbpf: Extract and generalize CPU mask parsing logic") 
added parse_cpu_mask_file() function, so back-porting that commit should 
solve this? It should be straightforward and shouldn't bring any more 
dependent commits.

> 
> thanks,
> 
> greg k-h
> 

