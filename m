Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5141632971
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 17:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbiKUQbK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 11:31:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiKUQbJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 11:31:09 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52CE7C6BDE;
        Mon, 21 Nov 2022 08:31:08 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ALGMndu022965;
        Mon, 21 Nov 2022 16:30:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 from : subject : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=EZV8yzBTjdhvktftK949KI0eLoEOq5/Di9ziZ3uAlDI=;
 b=FhjDfasWx46pksFR4gcavYkWOOy3KpAbzQk6Qnp/GbTs8nC+fyVP/7L+/Y2e0B7ZDBiO
 4tFPhrIBCEIYOhWL7cWLtai1RtDz2em3vTCDuOsrbMLfqB0dgCeKzPnoIWezKS68cSiv
 F+0rx/sjVXh9ct6OYgbbi4PegoPyjPngdaCKRTgS4jvWesHdQZApikmObH2hx8d47ZjH
 kT3UgPZWncGERmgQwAlCfZw518K6fy6s86JXL4MmpFNMwyPnPuEucSkq5JcEiygP0FDq
 J6vNzNDaYAhKe5KZg14LOhBiXqloKYllVX8W8yExfw5Mn2zIZVm0x7NVN4x6w3+t0DDf zQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m0ct1g0vt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Nov 2022 16:30:31 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ALFfxvj002239;
        Mon, 21 Nov 2022 16:30:29 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnkaqmgr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Nov 2022 16:30:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XLDW8hf+dB5uQ6v7me24fsjbYZf2+FncxyICne8FeRo0A8SQlT+6gW0wVXZqsRugJS0GzM7oOY6POhEFy6EuQtbvshwsci2wxEOXHpme9ZYkQ0BA9FxrPU/idkloPpku+5sF006Iy9UAa57KeuLH0kx1Pbyq9WJgoqTiwFONVohKUbXevEDnQ8rfvBf8E3QzG9p65Mp79AYaUyiEB0sQitUcDL4UpOZwmA+nCTyzuyPPLRc9aNAdPke7C34ab4Bh4BUtCL8AHTVxovieCqNMg7lHlecFgNteWlKo7xgSsGREmAgR7fGqytsY5fypXJNBpKsWwgXZM+jMqkmbc/ex5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EZV8yzBTjdhvktftK949KI0eLoEOq5/Di9ziZ3uAlDI=;
 b=LcCYxrCluJqeg8sR1dT0KZSrsDSeTnU5ri9ypPEgrJIsoo0m7wz6Qmk2MLHqdtPosm/IfrPaueVkFG6KcjpQ5nfMfjHheKVd/U15J9X6KFylllBCEtJsjiYG5qFkUhfQgOPhao+bK+Q2pWjnuGH68NxfUaT8V/HhGZWwWGJraeVSEUHcQRc7yWXTtO5ym9hZv19tCUd2b9HwsvtIvv+/OboXtnne+v/fPBfacm2TM9XNs5c7HmXxQR/T1ZliZv3+jitGTo7WO7E6TEIwxFKlAJNZjxmfjgot3fMZISn/XiN/9vaFXMM5TRNrGaVnX8fWxS6xcynu4Uu6aLL+Pl7XSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EZV8yzBTjdhvktftK949KI0eLoEOq5/Di9ziZ3uAlDI=;
 b=AghitE3JqYkp+oeWd85K/hMwYcfYie3ZvAMDQZwetasWCdCkC1e0wxK7HIydGyV9F+cvyA4OgMDS/hSOn7X8RGRMeBuA4zwArxTakuvNVX3yKZZIYsdcflq9ooQEX8kc3LFoG2CAokJnJgqVCHtOmNuDHaEViJwewxXa3b3Y/OA=
Received: from BN0PR10MB5030.namprd10.prod.outlook.com (2603:10b6:408:12a::18)
 by SN7PR10MB6978.namprd10.prod.outlook.com (2603:10b6:806:34d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Mon, 21 Nov
 2022 16:30:26 +0000
Received: from BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::c13d:dad:6a35:b25a]) by BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::c13d:dad:6a35:b25a%7]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 16:30:26 +0000
Message-ID: <d4d23b53-8355-c218-061a-c98b7d60c5f4@oracle.com>
Date:   Mon, 21 Nov 2022 16:30:18 +0000
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
From:   Liam Merwick <liam.merwick@oracle.com>
Subject: Re: [PATCH v2 1/9] KVM: x86: nSVM: leave nested mode on vCPU free
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
 <20221103141351.50662-2-mlevitsk@redhat.com>
Content-Language: en-US
In-Reply-To: <20221103141351.50662-2-mlevitsk@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P123CA0020.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:313::8) To BN0PR10MB5030.namprd10.prod.outlook.com
 (2603:10b6:408:12a::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR10MB5030:EE_|SN7PR10MB6978:EE_
X-MS-Office365-Filtering-Correlation-Id: ede40b65-0a3e-4487-b59a-08dacbddb200
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6kzJV1V1flmsWCeGQv6p5Ss91mL++OgoPI7EoN5/8IfzQyij4TQpPPxonZxZ9LPgkVKjjmRkxlNu6KJ+pmI19nj+4m8pkTo9D6BAxcWWYzvPMNqMBNiIjz0z8jqX+Goon7G1Upv1BeD2C1pADXch5fdWg5190aPOGIfQO6UjwrtNeqNo2d427ws7zv/fUmOLUvk+RmtRMfMOU8J2bg6ucPNK7iQdK8jiXPoGMmoZGxTQANJIhZGLA8nr2OpY/WoJQBzcrjmeJL3EGk5+B5nyJyTd8Vg5OJIySyi2F6CgT16oIan/a17Ve9Ywo3c9lYxaeolvRGoll9c9gAVcjpjhKq30s5QBjnObvWxjTvQqHG5aMSIs5Z9rs7BJw/8Xm4G1oc6ZVeQoqa97y5ZsxRoDW+v/qYsowz3Oe6wXlTsFkWH1Dk675rARCjjDfwOpUjPDv2TYi0iGUUoYQzTHacxEnI3yLDtaPOXmD+uI/akjEH7FPZXEtRsFCYxHJx/V/TDGwUZXyRpp0Mg3KyeDw8AveqPfvxjr9Mjoj4+ntA7ayVuYq9jl4Gj1DviT2Nk8vOXxIvJ880Ln+maqczbOKDLBaLm3L1t3dPrpTEznJiXO12lRkReY3X27OJBEQaMka1HUFrDXbgOcKOSOkO2eUkpsgH+ijtbigCzIhf21X/2FkdL+hF8+jy2K9X9ZyJxZ+NP5PDXqOSKtZsBN5hHoVXlf4JXDK9h2Nwlf5YI2TlRiB8s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5030.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(376002)(366004)(396003)(346002)(451199015)(8936002)(7416002)(31686004)(31696002)(5660300002)(86362001)(6506007)(107886003)(6666004)(8676002)(6486002)(4326008)(53546011)(6512007)(36756003)(66946007)(26005)(41300700001)(66556008)(316002)(54906003)(66476007)(186003)(2616005)(83380400001)(2906002)(478600001)(44832011)(4744005)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Tkc4VW1UKys0UXl3WHpQWWNTUlJudmhjajVPQXFyMk1MZWF0MHd3VlJWVFg0?=
 =?utf-8?B?T2syaS9JbDZMYVdiMlp6b0Y4QjhmRi9aUHlqOTR3ZGpENEM5YWpBSVlyNk1O?=
 =?utf-8?B?WGpvR1ZYY1FuTVMrNGE5ME9HVGdicXhBOW5ZYUJNTisyYmx5ZUxhNVF4YjEv?=
 =?utf-8?B?OWRlY1BaZTRnMEhqU05OR0gybUNNVkVUa09DZS9TOUFhbnpUZjc2dW82YjVH?=
 =?utf-8?B?MEdXQlN5ZDYyRkFGNDRmM2x1dVpqWDdhYndiNzcxbGJDYVYzMHZpMW1GQ1lo?=
 =?utf-8?B?UWwvcldTK3ltbU9zSk80S1lkTFNhN0c1ZlB6ZUN5aCtxYnhnNGw4U2NEMFM3?=
 =?utf-8?B?b2ZlOFA5UzRlOURLc1k5RVcvSnlIL1gvdjhmT2czWCtlM3JTaGZ3Mlp3R1d4?=
 =?utf-8?B?TTd3WnN6RXg0Y2duWiswQUpTRWx3K1dYMG9mdktLUTZCaGlvTVlkVG1WeEYv?=
 =?utf-8?B?NFBKZHUwN1doTzI3UEwxNXdEYU9BMUxsajZ5c091dnVNbE8vbGhhdkpaWEFG?=
 =?utf-8?B?eSsrZDduUEI3RFpRTFd6U290RStRSEJVNUlHNE90T25IZG11UDlGbUZpekJ1?=
 =?utf-8?B?UWhzUUZpTDBqUUQrc2o2MzgxVFdnNzFkeXdockU5bkxKbTlXMTYxb2tSWlg1?=
 =?utf-8?B?cnpTTk5FcVpaeVM0cXlzTEV3MGc3RUd1bHQ0V2R3eHNLdnp0LzBXc20yeUQ1?=
 =?utf-8?B?cE02UkZYV1ROdGlUY1dYOWxKNW50VzhkbmhVUzlQYnBEbjZ5b0w5K3B4dEgw?=
 =?utf-8?B?WmVnMDhHOHphRmRVdDVKRzJOUmRSM3ZJTENXdkFWM0QrazBWSkFQRjk5MFp6?=
 =?utf-8?B?dmZRZnc5MmNUamZXbXF1Qkt5MDdPN29taklIdjhlZENES240d0plTHpaRGJm?=
 =?utf-8?B?ZE5IQlhsV1FGNGlYL05icDMxeFo3QzM3NUd5WnNmR0k2Z1JwUU9NQjQxOHpi?=
 =?utf-8?B?c1FMS3ROaGdRTkJ5aDlFbXlhWGlDQkRDbUV5K3oxTWJQWUo0cHlNalliUHZU?=
 =?utf-8?B?NE4yb2FQNW0wVWdPR00wWjdpRFV4TTE4QmtJLzF6ekJKWEl2TVc2MFhSZVpu?=
 =?utf-8?B?T1pXWTRRNnFCWFNQSGFaWjM3YXUzSzlpQUxCZ1EzNmMya0FDeFpzN0pFeG5m?=
 =?utf-8?B?K1ZuTm1YTlFocUtXV0p0dmdWUCtQQ0NVemNieldGUjRQNDJHUThIcEZ1bWpB?=
 =?utf-8?B?dmRqQWwzREs3RGlROVdVSTM1NGhYNVZKekJFcmoyRHQyNkRmTWMzZHd0K2s4?=
 =?utf-8?B?dld0VktRdGhqYlZXWU5UQUI0ZkFoYnd0TmJjVE5zR1NjS1MzQ2ZmN0VmTVM0?=
 =?utf-8?B?bVhuUk1tWm5JaG10Nnd2K1YvU2dOcFRvazFITm5NZGtVMlBTMzZYWVU5R0lm?=
 =?utf-8?B?cy93L0ozZkNtckIrK0lDaUQrSWFtdkJOK2R3U1hiK2hpWUdwOFBjalBhcCt6?=
 =?utf-8?B?cnBZSEl3WTdOWjVzTXEwS2lWYWZydkJjc0tDZFN4a1dETVhmZ2lkOGR6OGU4?=
 =?utf-8?B?blFIdG1Rc0h3VXh4eG9yeDlJTmZmT3VLTUpzLzFQSm1nMThleFdWZnlSeHJF?=
 =?utf-8?B?L0pSWkVEb25JOG52V0dyZXo4cGx2ZEVtZm82cUZCM1V5U1dGQ3d0OC9YakNr?=
 =?utf-8?B?cUVYQjJIaVlkSHAwRGtTY0d1eUxtZ1QrVmtvS2RwYzhaRk9raDhOaTRYejha?=
 =?utf-8?B?VmNteGR1blhCalo5d1c1Yno4cnZMM0dXNzdkYWNPRGVxVGI0SEExKzgwVHRz?=
 =?utf-8?B?UGdFSVc5RXBrcFdoL0lUYW1hWnovMHNkTHlPNm9GQTg2Tkxha3F6aFpYTVJS?=
 =?utf-8?B?S0FmdEVlRC9hbFNXdEprdFAyZGU0cnpXRExkWkExY1JDMnFZL3d5dXR2eSt3?=
 =?utf-8?B?dy9tSlptMHRaVi92VDlnN3NrZnFJeWE0cm5YdEhGVGVpaUN5TS9TWXR5N2hu?=
 =?utf-8?B?MzJCZHJsS3VaV1hYZUVuaThFaXhhbDNIN3MxK04vZWxQZGswSEpoTTdzbURU?=
 =?utf-8?B?ZkVDR3dReWlldDJxVXJLYjFucVlTRkx1dSt2R2NZVTlxY09ka29mc3g0aTF1?=
 =?utf-8?B?eTdkRmFOeWRYek1SdUlHMmJxNCtYOU1iNWtmYy9HdG1CTUtsbjF5Q0l1cmVO?=
 =?utf-8?Q?5sI0iD1vEQUL6Hjx8lWXzILjr?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?aEZDZzJsZnJ6MUkvUkd1enFwNjV1SGtQK3FxUTdZYXVSM3BhMUE2SVIrVjZm?=
 =?utf-8?B?ZHUyRG1tdXU0VVhRV2NPZEtQNkdVY3c1RDY5R3JEZVZNSjlUaW1KQTBpTEpR?=
 =?utf-8?B?SXppUEdOU09jTHEwYTBMc0NVcVNhSk1WK25IVzhGKzMrOFUvV3BFQk1ZUklu?=
 =?utf-8?B?Y0xVVFhick1SdTkwWFhDVmhTa2FKMEtOWXNiWkRraTIrdHduTmVmL3ZkeWc1?=
 =?utf-8?B?Q1FxQmpFYklRTlUrYmc5L2ZDRS9VYzRHeUxqaEk2cG1iVGlFeGhHWndtdjMr?=
 =?utf-8?B?TVcxVmFsWHFWelpFa2NUbWcxeDJKN0o1UjBIRDQ4OURLeFRzL0VWVlI5TGJQ?=
 =?utf-8?B?WTBMN0lFSzVqckIyUXp4aUxmZWVzNHhqWjhGVkRxeXBpVXhxUjZFSjhIWVNh?=
 =?utf-8?B?Y2ZYQTlBemlKT3ROQmFGYk9DanBBZmlYUFNYRXN4Z0pKOFp0cUVzZUhiUXEr?=
 =?utf-8?B?VTJLM0J3OXNqT0tKZzJZZzZxS1laREdkOFU2bHhMNXYwYnBPWS96aDdibXhl?=
 =?utf-8?B?TEMvZ2x4VFdTOC84Wmw2MnAveGg4QWJFLzNBQ3Y1OWpVV3VWUUFjWHAxbTVP?=
 =?utf-8?B?T21SZU1YY1ZhUy9RaklBclB1NHM3ZGhxMmdWZ09qUVRaM0lUSVlUdGo1bmZy?=
 =?utf-8?B?L05NUTlBaVJLVHVYSmd2UVFNWEtORE4wM1ludjBkSk1WaVd5bXZoK0ZBVmVw?=
 =?utf-8?B?R2F2ek9NVFZCUDZtWDVoNUh6bk12MkZEcmV1U1grck1sQjRGOG9RZm5XWnR5?=
 =?utf-8?B?M1Z5ajh0QjVzTWYwUmFZVVhrMHJia0ZRdThQaDN6dHBPTm1UQUFOZTVkckxi?=
 =?utf-8?B?SjB1U3Eya2JUdDRHSG5pcnpVVUdKOC9pSWljdzg3dFNoY1JKczUzQlVJdUsv?=
 =?utf-8?B?OTIwbTFGTVJpaHAwWSt5ckpIU1crOGRUL3cybWcrQ0tQQ2QrbzdCeDU0YkRI?=
 =?utf-8?B?WmRCb3Z6Y2JWY2F2THIvSVJLSURud1RaWGZxbjNqSWRxb2s3aTRseng0VGNS?=
 =?utf-8?B?ZFdDVUkxYVIvc1ZoS0Z6N1F0Y04xUmlHME94QnYwMDluK0wwWjF5bTlQcm5u?=
 =?utf-8?B?dDU5SjByRTN2NGo2NjgwZ1RaV0xiRjRoRmYrWEV5V2JRRTE2cVZiSVIyZmFO?=
 =?utf-8?B?RjZIb0Y4dnN0aW5BSkhRM1Zlbk5USldoSDhsN3lSK25zcnN2b0Q5eHNDYTU4?=
 =?utf-8?B?bXRzTmxpbkpBSDQ2Y0F2SzZ0N0x4NDk1M3BtWjJYSURnU2ZybHpFY2hxamhp?=
 =?utf-8?B?MisvRVBPRTJKd2ZXWi9qS0dSS0RjVS9adTkvcEY5QU54S2VBaFhyNDNpalpp?=
 =?utf-8?B?bTA3a0xNbkhCcXlZSGgxdEJNeWxINk1Eb29KakxBS2RLYm55VUI5VFgveUw0?=
 =?utf-8?B?VzBDYjFib0I2VWllU2swY1RxRUZtUENrbVB3bWlERXVRWnllSjZ1Sm5EWTZJ?=
 =?utf-8?B?ZUo2RHRyNU9KbWpjWDEyNGVKaDhRWGExbkg5OSt0UEh6ZktXZS9WQWkrcDd5?=
 =?utf-8?B?M0Y5cHQ3UnNwUTVTNjlQNDQrN004aUd1Yld2LzQzYSt3UFpvRm4yNzNDZkEx?=
 =?utf-8?B?azNSKzdSdVhzWW4yaDFBWXZsd0luL2NjSE9CNmxyYkNSWVozZGVDTDBJa2Qy?=
 =?utf-8?B?MG1uckN0ZStZNHlFTFFsZElibkFjRFBGL053QjN3UU40N0QxSHRwS2JJclRu?=
 =?utf-8?B?dFg0ZG5rcFBuZThtNjIvcjd1OGU4SFRmOWp1dUxBbWNVU0h4Y3pNMFQzL0Y2?=
 =?utf-8?B?ekVYc01GTVZ5cXcwRXBRdFRydFJ0U2JvOWd0cEJXeDk1TnFIdDNHbFd6a0dn?=
 =?utf-8?B?R0Y2enA0UWVNRnNOeHJscTdnVFJhbVpZdEZDVXRsdXJwSjdsN3JVS0pSSk9Y?=
 =?utf-8?B?MGNhd2taV1F0WUd0RWxsMnlreldEeTYzV3grWkIyUzdSNXc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ede40b65-0a3e-4487-b59a-08dacbddb200
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5030.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 16:30:26.3610
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MuOIhbAqyPpGDd2YSXDmptaW5oAL3rXQvnptD4zyrHDEhwkCwQMqmE96X8QtYCYEdAUsVzhPUIFun8XqQTxNQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6978
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_14,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211210127
X-Proofpoint-GUID: XVcQXg8e2hNH9CkksPgFJ80pSr6vPyG4
X-Proofpoint-ORIG-GUID: XVcQXg8e2hNH9CkksPgFJ80pSr6vPyG4
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
> If the VM was terminated while nested, we free the nested state
> while the vCPU still is in nested mode.
> 
> Soon a warning will be added for this condition.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>

Reviewed-by: Liam Merwick <liam.merwick@oracle.com>

> ---
>   arch/x86/kvm/svm/svm.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index d22a809d923339..e9cec1b692051c 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1440,6 +1440,7 @@ static void svm_vcpu_free(struct kvm_vcpu *vcpu)
>   	 */
>   	svm_clear_current_vmcb(svm->vmcb);
>   
> +	svm_leave_nested(vcpu);
>   	svm_free_nested(svm);
>   
>   	sev_free_vcpu(vcpu);

