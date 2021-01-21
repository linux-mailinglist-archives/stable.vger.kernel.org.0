Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3A202FEF05
	for <lists+stable@lfdr.de>; Thu, 21 Jan 2021 16:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732224AbhAUPhQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jan 2021 10:37:16 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:36934 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733034AbhAUPhE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jan 2021 10:37:04 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10LFYII6146890;
        Thu, 21 Jan 2021 15:35:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=8EEkYBvY8fbSdFP6aylnmPi0I4ePUFrr4CiDFcJK23w=;
 b=LWOeLbm+9QhJopEnu8B+dl61YhhGdd7Czpv6JFBy3LBpwOjJVs+/wG8ilyEsgjR8ndbO
 eELCqJP/gb9T9fryFi5bFAkNm1Fr9ycPh6jBD1Ne43UyngYrYGFI1UOOGFid6RcDWW8g
 5p7df5nyKkmVfT54MsAb4URqDgQTZOdIapg+EJqKIDbXf1NolK0J1BiA19Dw0ooOVZXC
 D2NhJr+9n7Yjhvl+58vGkwaxVZGx8yRyEHcwZbZC6qpD4ISO89YeJjU4OPfQBf1NytQO
 WG1mNAjm28ZvmBs6g1UHyC23+tZ8EwuftWb7RkoAFlbe3vWx6pMrC3PwczKtH9Nu3gvM GQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 3668qmyvg9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 15:35:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10LFAtnQ180049;
        Thu, 21 Jan 2021 15:33:02 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by userp3020.oracle.com with ESMTP id 3668qy9awk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 15:33:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TIu1/8t+XuHVGCHMzYrcQWEJyW46DuR4nAwtQbR0ose6HBelGioPidBbodi4jraB9GGEWZ+2wD48b58MJuba4hx46tCTllxEB5JlsnFWdThiZklNSC1jMNz1kr2atxiRau3u3XMZr+kXqTvilZt2+GVqLPCCpBWcvBjlKFWN3Hxco9T8NN4tdrgNgX+Gy3Dm1OcNbrTFbwlbjD9+7o8VxThGqpr9lXwUwAHWWEzkuXfJ9uGOybErAA9aclrRfeRu33XqMsjMHR84Qm+Jgct2aK/wCm6gzdLxJdHKD77Z+5U+Yv34XFVxg4sA1TXOLZSLaRvtEOjpkB6Jb9By6zG1UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8EEkYBvY8fbSdFP6aylnmPi0I4ePUFrr4CiDFcJK23w=;
 b=a1gkk2tTh82zTKBZYx12iTIr3qaWWCYzieM/PDGZPWoqFRlbdT+nROL62m6HUCFNPX96vaRLeO/bAyRHq7u3GO5/7pOGCmljwuvk7y38DxwRWjsUdqsRkRjBLtd1JFB/BHdUGMeBmW7vAAX14HUFKmxOTiW0RKH/sZ3Hz6w+ElpQXs044D/xYFu+ZzdC56GTvapi26vuGoG8r4hNwFgwfWwvptgMkQk2HcpmjpbbvPt67FfptTtciw28Pi1WAFbtVlTnSpIFtnL2OuT7y3lZhy7eMjBcTQRnIVEUUwrsc7EyRdfzxIrwviBznzqlUsIVGzQvrQGFTWhaUZQsk5VzQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8EEkYBvY8fbSdFP6aylnmPi0I4ePUFrr4CiDFcJK23w=;
 b=H/xAOxjT+zzfOB0Aor6AIzYCh9qj3qZ69a6ud1vjd7D137T4rqVsElUGGtlHgKE0ansAl0yNj4s37cv3zk3ReLXCr4XG51JoSVch8FlKkceaj90JTmzEmBIfbaOrCs0mZYscJQkFgu2EPLr3fAvaItBZUE/Ghx956IwddyDc9f0=
Received: from CO1PR10MB4722.namprd10.prod.outlook.com (2603:10b6:303:9e::12)
 by MWHPR1001MB2285.namprd10.prod.outlook.com (2603:10b6:301:2e::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.7; Thu, 21 Jan
 2021 15:32:57 +0000
Received: from CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::50a1:9424:e4df:af22]) by CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::50a1:9424:e4df:af22%4]) with mapi id 15.20.3784.013; Thu, 21 Jan 2021
 15:32:56 +0000
Subject: Re: [PATCH 1/1] kernel/crash_core.c - Add crashkernel=auto for x86
 and ARM
To:     Dave Young <dyoung@redhat.com>,
        Guilherme Piccoli <gpiccoli@canonical.com>
Cc:     Kairui Song <kasong@redhat.com>,
        Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-doc@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Will Deacon <will@kernel.org>,
        Anson Huang <Anson.Huang@nxp.com>,
        Jonathan Corbet <corbet@lwn.net>,
        the arch/x86 maintainers <x86@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, Baoquan He <bhe@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        kexec mailing list <kexec@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# v4 . 16+" <stable@vger.kernel.org>,
        Li Yang <leoyang.li@nxp.com>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Vinod Koul <vkoul@kernel.org>,
        =?UTF-8?Q?Diego_Elio_Petten=c3=b2?= <flameeyes@flameeyes.com>,
        Olof Johansson <olof@lixom.net>,
        Shawn Guo <shawnguo@kernel.org>,
        John Donnelly <john.p.donnelly@oracle.com>
References: <20201118232431.21832-1-saeed.mirzamohammadi@oracle.com>
 <CACPcB9e8p5Ayw15aOe5ZNPOa7MF3+pzPdcaZgTc_E_TZYkgD6Q@mail.gmail.com>
 <AC36B9BC-654C-4FC1-8EA3-94B986639F1E@oracle.com>
 <CACPcB9d7kU1TYaF-g2GH16Wg=hrQu71sGDoC8uMFFMc6oW_duQ@mail.gmail.com>
 <CAHD1Q_yB1B4gu7EDqbZJ5dxAAkr-dVKa9yRDK-tE3oLeTTmLJQ@mail.gmail.com>
 <20201123034705.GA5908@dhcp-128-65.nay.redhat.com>
From:   john.p.donnelly@oracle.com
Message-ID: <d6b5b7f3-ba38-be61-d3fe-975c3343a79d@oracle.com>
Date:   Thu, 21 Jan 2021 09:32:50 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
In-Reply-To: <20201123034705.GA5908@dhcp-128-65.nay.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [47.220.66.60]
X-ClientProxiedBy: CH2PR18CA0055.namprd18.prod.outlook.com
 (2603:10b6:610:55::35) To CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from jpd-mac.local (47.220.66.60) by CH2PR18CA0055.namprd18.prod.outlook.com (2603:10b6:610:55::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Thu, 21 Jan 2021 15:32:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8ab371a-c393-48d6-e2f2-08d8be21d395
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2285:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1001MB22857299E775521EB3E55E35C7A10@MWHPR1001MB2285.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ajnS0mZ2M3Gs9r41n5j9hiQcd3bMZn1zMSoCuz6LdzETDOIOWIjnLSE9ejRtj9Uq2xpEwyzwsLP0zVWo0j+RNJH9ZYzOxgEf4A+kUN6AmoJ48yG+buS+PtA4mlaKdEpA+beJzDqUdQilY9wajZH+6mJZhI6eNT2dAUvPXE5PuFRioHZQAGYHDA5Eqqf3W8vXu/PiEiaByZrkEAmNiAwC1mMtJ4e90I0WyIa3aUwQzuub0guj9hxQhtlET0MVP9pRe+lI0DmvJ6+P2uLJzDX5P9X9qBdg3W2zQgA4luBgAgwk5TGtwZ5TEugFnsx8blQbE39039r+uk0S4fQals4nnEaOO2xshfQBIYtpNap5sYNahQw/194+KqC/FPAiQqrbrjZCixkib/gGtZhfxDVk6FZTRb63pLGTIzeQSmIx2jg5emVOYKTQhZA6Q0480qhi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4722.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(110136005)(36756003)(53546011)(31696002)(498600001)(54906003)(107886003)(8936002)(8676002)(6506007)(7416002)(16526019)(956004)(6512007)(86362001)(26005)(9686003)(4326008)(2616005)(66476007)(31686004)(6486002)(66946007)(66556008)(186003)(2906002)(7406005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?a3JEa0QzZjBWaGJiV2JBZ3RRdytOeVBnYjBxQXcxTmd2NjJsU3JHVCtaMjl0?=
 =?utf-8?B?NC9WSHRJQUxYS21Ja29WbnpqRkpLVm9aMXRoUUd5bG5GWTJJUEFtczhYVTRK?=
 =?utf-8?B?M3E5WXA4MU1xRVhOTW5yMDZqcEdVcm02TDJaSldYMEp0UGk3c2toM2I1V3Br?=
 =?utf-8?B?QW41VzUyVFlackYyYTZBYUdiTlRRdVR0VlFJS3R2cy81NzA4R2J5Y1dVbUx5?=
 =?utf-8?B?aWZETkFSQXFQL2FoWStUVEpTM2lnRmlTRENnVFZPd1hMNlNYWjVMQnRYc1gz?=
 =?utf-8?B?aVMvMUoyelNpTmlramZYdmRiZFJBeGMwcDZGQXVBbVpwb2w2cEM5SlB4aFBL?=
 =?utf-8?B?enBKUVk3SExGZEJlVy9FZnBmSjkzZlp5aG1acjVLM05kb09LYStINW9hdUU0?=
 =?utf-8?B?NkNjL0h3d3MxMjFBNzdaazhWcFVtVnlTSlBhUEFaUnFldXZ5V2RINWR5YVZ2?=
 =?utf-8?B?TzFwazF1cEt2c3lkWGo1SEhETzVyYmtlZGVIWjNFL0tyeUhYNTZtajk2K3Zm?=
 =?utf-8?B?cUFzK29lbWRIT0J1aVlHRTF5YUpLanBZUXg4MENtQ2VYU2NhbURIYy9ER2FZ?=
 =?utf-8?B?b0JXTEZ2S0huYjYyNzZMYzNpTzFuSldJTzNjYjcvMEhKY2dGZllTZTFxcUVZ?=
 =?utf-8?B?RnZ1QUwrQ01yUEo4TE9MK1dLNklMSVFFL0dvaEQrUStiZ29tVHZJMG9HakF0?=
 =?utf-8?B?SzVxR1k3M21PdytjcDVOMVhCcWJ1TWlGd0RxV1VpVUxhMFhxdWMwOVM0eUgx?=
 =?utf-8?B?OGhCaWtRQUZrcEFQSzJ1Nld0TFJGbms0cE9IcXRKWkhndXhwZThjSjl1V0pV?=
 =?utf-8?B?VTRXYXZDTDZld3hsYjZDaHhBZU9QR1hYRStFN2h4Y2tFM1NGdXViaE9nMzFj?=
 =?utf-8?B?TFNXZXJwZzBYb0Y0YzNIN0RYM0d5TDNXZGNsYUJlWmtQa3FwMFN0Mmdrcnhm?=
 =?utf-8?B?NjdsTmtaNmtaUzJQOGhtcGd5Y0t1V1UxNHpRelVvVzdvZ1pmQlhmd3ZhcENT?=
 =?utf-8?B?a3QzMGxZaC9EeFBkSDdZZ3JQbVlXUEJ4QWh3V0JKS1lnMFFrdEZQYVFoU1p2?=
 =?utf-8?B?KytiUUF1MWg3WjVDa2NnRDh3bWhTczlQY2xwWi9lNUdEZ3NwaEdBY3ZqTkxO?=
 =?utf-8?B?RFV5NmQzdjg3UWpDclY3U3NZTjJvc2pESzNjMEpZdkRmZUNDdlQrM25WNGdB?=
 =?utf-8?B?SmpQNGlRYXR3aEFQbUxRdStjbG5hNUtSVXduaytrV1NteEw5MVhLRFpOTmZF?=
 =?utf-8?B?bHVYcmcyWG9KRXV3WEJPbkVHdFNBYmVGVnFMN095dTNlanM4ZXY2QlY2TTFy?=
 =?utf-8?Q?+T/e6vEjKuCJF35UEpdKh6I3kRQsJyIoCT?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8ab371a-c393-48d6-e2f2-08d8be21d395
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4722.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2021 15:32:56.8268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s/bpvvowYX45ZJwsy5yxSv3KK3uXzMrvUyjo0Dd/uskI0o8twY5UnC7nytsfr7yOxSL+a0a3WagRrivgIDD49L4megK1+a8HvqNeU5K1qjM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2285
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9870 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101210086
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9870 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 adultscore=0 impostorscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 phishscore=0 clxscore=1011 bulkscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101210087
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/22/20 9:47 PM, Dave Young wrote:
> Hi Guilherme,
> On 11/22/20 at 12:32pm, Guilherme Piccoli wrote:
>> Hi Dave and Kairui, thanks for your responses! OK, if that makes sense
>> to you I'm fine with it. I'd just recommend to test recent kernels in
>> multiple distros with the minimum "range" to see if 64M is enough for
>> crashkernel, maybe we'd need to bump that.
> 
> Giving the different kernel configs and the different userspace
> initramfs setup it is hard to get an uniform value for all distributions,
> but we can have an interface/kconfig-option for them to provide a value like this patch
> is doing. And it could be improved like Kairui said about some known
> kernel added extra values later, probably some more improvements if
> doable.
> 
> Thanks
> Dave
> 

Hi.

Are we going to move forward with implementing this for X86 and Arm ?

If other platform maintainers want to include this CONFIG option in 
their configuration settings they have a starting point.

Thank you,

John.

( I am not currently on many of the included dist lists  in this email, 
so hopefully key contributors are included in this exchange )
