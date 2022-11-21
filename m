Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC387632976
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 17:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbiKUQbX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 11:31:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiKUQbV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 11:31:21 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EA14C6D2D;
        Mon, 21 Nov 2022 08:31:20 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ALFNHRg023984;
        Mon, 21 Nov 2022 16:30:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 from : subject : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=pKz0QcQ0FJ/JJmnviopq8HED3iqVQojNE0inxPnJSsU=;
 b=FS5Xc3ZJV5NG8Xo8QAJFy3KlWpkdnQP/wDTRKT3pkW9y8cG82i5BJPia4jAN+bKsX4b7
 EtCnvxN50SkdbTXd/FPWLt6OrB8VnZd+Wxtk5VXwKzAYMvCdioaM86621mlmjzmt6RzU
 BcjofE08j4kE4ECZhUS4Lt5zuOWIemUMEjdEZit0BekfEJJeI0uM4YfQd3BVwt8VMUEt
 Oya6Wa5sAx5eJM0/klU7UK4lzzBHOk4+tokU30Vgbh8KlnJuTLfqdEfdbJJEin3wh94t
 qOk9IlFU6u6PhuvmadM0XjavD/ny5iuTew/NFSrznt94zgKl8oBa7Gah/SCv20IndNxt mw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m0afr0m3j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Nov 2022 16:30:57 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ALFX9DJ038864;
        Mon, 21 Nov 2022 16:30:56 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnk3xs6f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Nov 2022 16:30:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ftQIhshXKPZ6QcOOx3wVFH8IfZm6fE6Ym8aHXHIQupCh9KVvkQqy5Jow88p23a6RCcYRv1609wFPcv4RwZQietBIN3zjgAGezewosc+aUVVcU+m8vPDWDR6qSfU+6SdPDenY7TWgML0U4eM+hbOmYuz8vEi/Zx6RPn/0DgzyoQRyP+qEsrjdBgyMCF61UPqL4Nzl8WPP2EnUKroeRgoL/q9pxF6hcDy1aSnj2Cel7yNLkm1KOp6wz9f9LvOLd2i7xg8ICVgz6uU9WKGCnr/2QyeInP0uGydxFERlLNmVB7rTEJxx9/q32MesItQID8YEzdNGQpOc9F0EF5BwkB3Ogw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pKz0QcQ0FJ/JJmnviopq8HED3iqVQojNE0inxPnJSsU=;
 b=S6kJBgNUK01SXLHYhNrP1SUABEfVwk1Ry92q5bV6jtEmrTlCeqf3S4AVby3cRTQhN3+W1w5tcUAXSu1+ntNjWR6TMxUI0OxBWC8fgYf3Qf0vuY1z4HkFaE6bQ3UEiiXHS+kfRNeJFFh10U9bsx7QY8z+u2uO1jifsmxPVKH61ydr1u7gKENoJLTcf1FkzgX9ufO8Et6Gb3jQDp4DXobxANLeZ4/cUJUpCc1QNd6Ci8GJpNBYc1dZIALGRySpHP9+k3LZ0VeQBMT+tkCp5IUGV/j8tJzklaydwlcVlObs6w7LYcsoKN6L1BMEF/n1m7SBA5qjHy/NfYcPKx9iS3jK7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pKz0QcQ0FJ/JJmnviopq8HED3iqVQojNE0inxPnJSsU=;
 b=l9/DOdw1JId1McrG0j7TbiNVp68OjF8rqikqCaE+n46zt9oaDKkgqyEiepfxeER5oJR0evvqIgReymRogWLtDIxeNOC2p58kK5+fTDYfIfl1TlPKRWRNqIjbQd3XiMYIrTkPxR2CACgFRWscq/bE2udn45iZybwRCn3bivoDW6o=
Received: from BN0PR10MB5030.namprd10.prod.outlook.com (2603:10b6:408:12a::18)
 by SN7PR10MB6978.namprd10.prod.outlook.com (2603:10b6:806:34d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Mon, 21 Nov
 2022 16:30:53 +0000
Received: from BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::c13d:dad:6a35:b25a]) by BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::c13d:dad:6a35:b25a%7]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 16:30:53 +0000
Message-ID: <cd83ff1c-b70c-f0cc-88fc-598fd25bcaa0@oracle.com>
Date:   Mon, 21 Nov 2022 16:30:44 +0000
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
From:   Liam Merwick <liam.merwick@oracle.com>
Subject: Re: [PATCH v2 2/9] KVM: x86: nSVM: harden svm_free_nested against
 freeing vmcb02 while still in use
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
 <20221103141351.50662-3-mlevitsk@redhat.com>
Content-Language: en-US
In-Reply-To: <20221103141351.50662-3-mlevitsk@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P123CA0022.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:313::15) To BN0PR10MB5030.namprd10.prod.outlook.com
 (2603:10b6:408:12a::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR10MB5030:EE_|SN7PR10MB6978:EE_
X-MS-Office365-Filtering-Correlation-Id: 566a050c-9929-46ff-2a16-08dacbddc228
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L0YVay54dXf3gExr6ElixRF5NUeQUuY/PC/QVlG5QMnNdVc+RaxQHiCRJt3bzK/H6ZZzFdBp5vTrYLYePqE+IcOR/0E9/4WV65rvAzeNH2dKIjnOGVHd9jtKMKlVpw4b7fwVIs2h6ktMgCwz4rXGuOul/tl4UcJjUNVxb0IhqojLuBWbjxjxbRQ8JjpF6e+9CFqLBxiNg1rkgGZ97QlQT2+2UKc9BdaKoj2hX6o6Gyvmw1MlO4Tyh9bW8RzwT4Q8Q45Kq1Fa+x8e5LzijOL9OVOeYjhG3SibBFZ7btp2xRJgAlS7fwjwg4gRmYLcdbnaVjt9jJBx5tOO8loGLgyS/gpffCoimZjA0gbiJQ+V0VGy0MTBdmZ2gMdYmAyEJ8TcztBfim7i3OF/Mepz8Om9LutCWLZrvElzCM8LklnqjyLB39hwPMfA5SJ4N61MaPePWuCWYhaYrDA+k++zNsRuJ4+ZM6ui92Z2dkyiuSf4f4mnDyg03bos5rU2uWB83Tt3vpqaOwyIqUDFiAqanqk+XSaDbT5nDU345+vnlWRINxcVd+OpJtc2ieJ1YZaWbBWZYyMaFRQp1Q0P4Cblq53M9qN2Pvh5HBKhFLcMSQatKkAdb6gne34SaFMp3yYOHCGxl0SpmZjYOfqEG+l5iqKd8h2kHkHaCVonilxU241OgZp0aIMQYSiKhfuBPIWrzysUwJ9RSG70GRsTBCK2yvuQLbCtndXvhSxPA8e1TFzJ52s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5030.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(376002)(366004)(396003)(346002)(451199015)(8936002)(7416002)(31686004)(31696002)(5660300002)(86362001)(6506007)(107886003)(6666004)(8676002)(6486002)(4326008)(53546011)(6512007)(36756003)(66946007)(26005)(41300700001)(66556008)(316002)(54906003)(66476007)(186003)(2616005)(83380400001)(2906002)(478600001)(44832011)(4744005)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TUczb2IraS91ZjNmQzVLQ2tmU3NKSi81RFRtU2Q3NzNaSzFGb0N2a3dsdjVC?=
 =?utf-8?B?cTBzS095TTRqZmVxekdpR1ZRZW1xdTZyZjZFMEMyVjdKMXhhTE9yeWpmQ1ln?=
 =?utf-8?B?WW1NUlNHeExMV0NRTVU4bEdmTHZ4Y29PKzVTVkJJK0hMQ3Z4dnltREdOV3Ro?=
 =?utf-8?B?bGFLOGx5WmxPTUpCL0NNbWllcTRTWndxVnMrSG1TSjJqTDNienBiVTNlTjda?=
 =?utf-8?B?Ny9EZnYyYWMvQ2hEUFc2OG9zKzBqZkdDWDFIaEpUVHJzK2RhM2tRWnpnbEE1?=
 =?utf-8?B?ZzFuZU9ZcHBoNEJqNlhuRHpJbk1TMFFNRVlnd29GN0djbUhMdUllcnFNMUFj?=
 =?utf-8?B?V3ZaeHRSK2JjZDcxVHFtMkNiKzludnZnKzhrek9qZm5YbHIwTVcwNVJtYm1t?=
 =?utf-8?B?ak5qeC8rYW1mR2J3MWhCbnZVeW5EVDNuWTZrUmQwaHZsQ0ZOYnl0TUZPaDZS?=
 =?utf-8?B?RG5FcHdteFhRY1hxMzYvVzFKcXpWa3ZZZVBXRXBSNDBwb3ZlMW5kWWVaalp2?=
 =?utf-8?B?UkFjWlJDYjQ4cnJLVzNGZEpyVCtMWEhRTUM0T25HODR5Wk9JUGtKbkUyTlpE?=
 =?utf-8?B?MnFtUFBFNHhPcGdwaTVDYVcvajd2VURCSGFIUXpxMURDcE1DeG5IUU1jK2cz?=
 =?utf-8?B?M3QwTkZ0Y29FeWtaRVhobndZWFhZRExGdzJtMWVZWHBEVjU5YnZJcWlxQ3Vj?=
 =?utf-8?B?NDA0ZDgrYW1UR3ZtNE5FMGdWWEo2Y1dXSzNMQkorZXUwRWFPdjRpZUJQMnJE?=
 =?utf-8?B?RjFpdjFUTHBVN3pkeUNEM3FVUTEybCtvZUpDOWpoV2pTWVNTN3hDbGhaaGJh?=
 =?utf-8?B?cGdSSHBic1JrbHVVaTZXZXhHSFFnbllGSVJqaU5NOTdVK1FoTkRsSFovdkpZ?=
 =?utf-8?B?Vkl6RXZ6cy9oMmp0UjFlbzJORjZWdnJYSXNML2JsZWxaZ0s1K2lOVlpJelJw?=
 =?utf-8?B?K1NqMTVoZEtkZmxQUk9GN0FyVkhKbC83TjExY1VUK0M1NWRhOUVGcVVmR1lN?=
 =?utf-8?B?bE9tSnBnL0ZTV1VjclFXbDhmRndRYkJ3dDlianJNdFhRMWRpa1UrWU4wU2lI?=
 =?utf-8?B?NmZxT2czWW0xL1FKZ2tFOHpuWDZCRC9hQWEwNzdleWpQOEFSeDlVQnlNZUVK?=
 =?utf-8?B?bFhkRHBBSU52QW5yNXJKMDVpZUxnSWh3bnVtRkdQUFZRa2ZPUzd1UVhoYWtu?=
 =?utf-8?B?WFVZc3A3WFBCOTMxS2xrTEVsQTROUVdkNHhKMmxwMXd2eXJwNlNsMUZKMnk3?=
 =?utf-8?B?QnNlR2pic2Z0bWhhaHp1QUh5Vi9yWGxCcElOcmt4a0ZXVkl6dk5mbi96Y3Fj?=
 =?utf-8?B?MlNudlNSbWo4TEhTdlRvd2pZSGlJWmIyOXNkZnJFTlJKMmg1VHJDd3BqeTh2?=
 =?utf-8?B?SDhOYzJUQk9QNWZkcm91Uk5QSSsxYWVoVzk5SWZzeTZyeGYranZZRWRxQ0VS?=
 =?utf-8?B?UG44djdYYjM0Ly9zL2lSRFVZTVY5ejZuOE9iM3Nua2x5V1JDdndJTkdjVDRM?=
 =?utf-8?B?eGNJUW9BWkdRbzJ0VlhhelM0TDJRQVBsTGh3Uk1vSWdXTmNBWnlVNGhkMDFM?=
 =?utf-8?B?eDZGUjR0c2lkYThyYXdPbWJQcm1NQTJZRnU3bDQ4TkxoaFdsK3ptUjUyYTNY?=
 =?utf-8?B?Q2phdE5JaTVQUVRYU0ZhQUc1SXhva0QxaU1XaHNqbEQ1ZG5JQTRHTDI2UUp5?=
 =?utf-8?B?a081a05TZVVkMUozc3Q3VXBRS2xwKzNucWF0c29KUlBza1h3aUMvSUZSRC9n?=
 =?utf-8?B?d1FYZjgzY1VCSHREMTVLeW1ZNjZGQUVTTkRFKzBNc0JrMklEcUkvczBoeVU2?=
 =?utf-8?B?NXhFZDZPL3lza1phWjlKVktlclVjV2lkZU41TUxQelZGUEE1VmFWNlFOaldh?=
 =?utf-8?B?MFhMZ2xqTERmTGxzQmkwTXprRzA1c1dvNW1iWGtaTnVaNHRnTGJKWEp6OU9v?=
 =?utf-8?B?RFh6dHBFTTc3clNrMWExU1c4RVZIUVlYS2doVHNoczZqK3ZxRVQ1aGswTzVy?=
 =?utf-8?B?MHVrcXNZV0t0anpwdkdJUzhsTnNZL0pSL3lDTGJrbWRhSDl6MTFOMXk0dXoy?=
 =?utf-8?B?YUFrNEJmNlRuMU5TWDdxMi9aWG1kaHJUQ1N6MmljN09rY0ozelNWMkd2d3ZM?=
 =?utf-8?Q?RASxbai7DTMaDyNFECpT7AD3J?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?SlllVjdQNjBqSVhHVFF6K1Q5ek1paUNvY01UVmY4OE9pY3NQK2ZvMllTK0xV?=
 =?utf-8?B?eTdYbmZsTFVWUFFpWWZhMTlHaklyb09KSE1ua1hJNXVKWTB4ZGRUYWkxWnB4?=
 =?utf-8?B?ZUhWbldPdkprc2ViVk9rWFplb2x4bGkrQWtQL2ovWnIwcnl3Kzh2d29ESDlJ?=
 =?utf-8?B?SEJVL3RoSVFOYkZPVGZWMmJCOVVEbzdaSFpSa2lVQ0cyRE5nQmFuRWdiL0h5?=
 =?utf-8?B?b1B5N0VaMXowKzJ6VlNLTmg5NlB5ZFR2ZVEzdFJoS1ZjOFB1NFNlR0k0RU9q?=
 =?utf-8?B?dFA1VVB6WXkyMnhOcENRbjJMR3pxd3RGajhVa1p1OGxZMFJuS1ZsNWlIekxQ?=
 =?utf-8?B?WnppVFM4b2JtK0NUbDQ5Rmo4eGxsRDZPTXdmTzQ0RkpaL09NNzdPbTZ4Q2NG?=
 =?utf-8?B?dzFQSzdNRVVhc1JqNXVidEJuSnRxSVpUemt6T3VMZjlrY2NFSFh2TmF4V08z?=
 =?utf-8?B?WWZXNk1lZEt2bE5aekpuTVRKRkFOY3NUT1FTeGUrWWl3ZDdGTXlKSWpIODVa?=
 =?utf-8?B?RVRtQ0U4Sjh5WU1tWWRtLzlDSTB4U3dRTVBLV3J2bFFWZjJHOC9tVkEvNG5o?=
 =?utf-8?B?enlaalNiUjBhRHUyM01sOFVQcUVHMEZCRlB5dDZTdUdIUTJsZGwrWS9uanp4?=
 =?utf-8?B?RHpUWi9Hd05XWTNxUkdXSkl4M1kvWjRJVFhnZ3dhbVF1WFloOW5oNWVXeExK?=
 =?utf-8?B?WDNCaTNRU0hZWExSNWlJZFVaeEJVNC9EcmtmLzNVbnRUaHVhQnVuZFg5UitK?=
 =?utf-8?B?dnZMWlJ4OUpERUM3NXZWOFljL3dKZDlnK0JZdEM4cy8zdkt4OWNjdFIrVXB3?=
 =?utf-8?B?WUFIM013L2dsL3U0ejQvZ1hOV0JjYzlUSTNueGxJWnZzS3hIb3I3eUFhbnE4?=
 =?utf-8?B?TTB2anljejRLVWhVNGxCNGlROExROU0vdmpOWWJMWFJWRytCSUVwY0ZtWitP?=
 =?utf-8?B?dzV4d1hOaDM0bXpjNXZQUVVRK0llUFduY3A0akkyeXVjOFQ3L1Fkc05NcmxJ?=
 =?utf-8?B?aTRlZy9uNVkxajA4NzI1U2NyaklIclJ5Nm5YVTRmWWpoSXpJRFZ1bmNFUDAv?=
 =?utf-8?B?TmhRak9iUVNMcEJkM0xxb0F6U0hMVnhvMTFyazRqbC9vWStmSlBpekt3cDZz?=
 =?utf-8?B?TXZTc09ka3R6NFA1MHlWV1NUVkhCQTBHOWRIRVUreXZXckV1ZnFvbnVQVHRu?=
 =?utf-8?B?bmVxUEZueCtuYWtPUWgvTHYyNTRkYTlEVkZ1bXdEVVBWY3BrNTJkK1cwNkZs?=
 =?utf-8?B?dHBwcWxGSnV6Q2tJRkhsVVZOOVdHZldRZXBQUWl4ZWxsMFdwWnBHL3dFbTJQ?=
 =?utf-8?B?VnV4OUR3Y2ZEc0FNOXp5R3hhb2hkRWlqdVZYQUViNXRNWEliZUpNemdHck9J?=
 =?utf-8?B?NUdJaXd1dTJlU3RKeFdhbzBIQW50TTRhVlFRUkFlV3hkVXVpZ091UUlSWm53?=
 =?utf-8?B?ODROa2s4V0FmZ1I3S3BSYWliQVA5VVpkYlc2dHZiWlV1bS83K2Z6bHRhcGRi?=
 =?utf-8?B?WDFYZjJkVDZnZHhSU1E2dFZqNm8yNmM2SDNjTEk5RFl1TDYycmgzd0owUTJw?=
 =?utf-8?B?ZDI2OHFNQU5hNkNGWEFmUisybXRqU3VIakIyR3hkNEpKWHpKeFc1dlpRbThS?=
 =?utf-8?B?bEpSdVRsMTFzMHdlVm1tRXZmMHJqL3JSbXFWN1RIbTQvMXV3a0ZrQ1ZUYXVL?=
 =?utf-8?B?N2R6WDZUZ2lnT0xNWEF6MjUzRGxQYkNwb0E0RmJUUjN6S0x2clpHcEpjTm5V?=
 =?utf-8?B?eno0M2p0WlpCUWljM0I1OUd6YVFaWmlVckdqQklVZmkvYVlld3pXeS9adG95?=
 =?utf-8?B?MkF3anlUUjd5UTRMbWFtT04rM2dDZDFZMFRjdTZqVHVVczQweVBZMzcxaWdJ?=
 =?utf-8?B?Vk50emN6dlZsMUtGTnMrKzQ1MXBDclYzSDBZUDFsalN6R2c9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 566a050c-9929-46ff-2a16-08dacbddc228
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5030.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 16:30:53.4155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bl0QWp0GKCfPh93uBPT2hI2khwrg/qvayIEjOg3MavoFegQfRvUy2tElhowpeqjPPp4t+FfM3g3nHcBNR3XPhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6978
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_14,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211210127
X-Proofpoint-GUID: 1JDdu7RjRNKWKyCSw8qRofNJvvVKKvW4
X-Proofpoint-ORIG-GUID: 1JDdu7RjRNKWKyCSw8qRofNJvvVKKvW4
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
> Make sure that KVM uses vmcb01 before freeing nested state, and warn if
> that is not the case.
> 
> This is a minimal fix for CVE-2022-3344 making the kernel print a warning
> instead of a kernel panic.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>

Reviewed-by: Liam Merwick <liam.merwick@oracle.com>


> ---
>   arch/x86/kvm/svm/nested.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index b258d6988f5dde..b74da40c1fc40c 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1126,6 +1126,9 @@ void svm_free_nested(struct vcpu_svm *svm)
>   	if (!svm->nested.initialized)
>   		return;
>   
> +	if (WARN_ON_ONCE(svm->vmcb != svm->vmcb01.ptr))
> +		svm_switch_vmcb(svm, &svm->vmcb01);
> +
>   	svm_vcpu_free_msrpm(svm->nested.msrpm);
>   	svm->nested.msrpm = NULL;
>   

