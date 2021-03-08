Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8AC3318A6
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 21:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbhCHUeK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 15:34:10 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:33890 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbhCHUdv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Mar 2021 15:33:51 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 128KTV7p153061;
        Mon, 8 Mar 2021 20:33:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=sfh4bTAv0pzzVgRm13LxdL0UG9lCgW8MA+UnVFVa5II=;
 b=D53UHi50/fVZS/Jcz/5qwp7YCiv29LOXYW4LKbKKRn7RVN49aC2zUQ+4LbpGUX6tn2QQ
 WLFhoaTMNkrcfWiXdh/0EU4ZvZVUcQR5u60QJ/DRILGb797/TrVe5yEjbeZY0sADs49f
 borj2KQJqxTt9xkah8v3pJP1ZMnMBvWK6HNa2/bOce62QHutc7L+YwsIifY4/79+UsSb
 hPj8rd5hQ1d6hTMEkg4n+FQJxHgjSudFU9Ynb2J2EKZtn9Ycm5Cwtmek22dzaTZ/eyYN
 uxpAYVcZtrkG3TKh9N9uqsUdAtUdKF0hl9U2NX1VrrHhui1r00gP/h42xMAQGpwcbB4A Vg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 3742cn50n6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Mar 2021 20:33:41 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 128KVPfQ103050;
        Mon, 8 Mar 2021 20:33:41 GMT
Received: from nam04-sn1-obe.outbound.protection.outlook.com (mail-sn1nam04lp2054.outbound.protection.outlook.com [104.47.44.54])
        by aserp3020.oracle.com with ESMTP id 374kmxfu46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Mar 2021 20:33:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g+0BiV0H2HQJOgOK8QmRlz5ud817vLtBPhMN4Jszh1nBDmj9kPW3eA3EzVcOIGuGdlAaFgsZ1tHPIPY4dKioX+2LEveDwHb9C42YfnAvSYZcZH9YKW7B6oT1juRkuYucrGDr+DM3jtTzt6y3t9c0z/kabHCVzJPkZF1/kRWm+aJz2rqNzPnXJMPML89aVhF6qBi/Ozy6eHWrdqXhzIOGiGN0947Qk31PSWJzkx2vysnTo8RR8XCP7q9sdptqZMEWLHSIZrRf0vMZWNgxy77rBNf6RK0Vjg0R4Q9XlnSeMn4Z2ExE9BUT+8lMwnplM0n3PCZW0jNQDCmW8rFJmYztXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sfh4bTAv0pzzVgRm13LxdL0UG9lCgW8MA+UnVFVa5II=;
 b=cCb9APGjKrVkBvJzhoTJeUQX5X9iqJ1voTS1NBsmzl4hA5zFShgEyCuCMHlEEw3k3XE3UnWyn3dRQEjX6mGpP5NxefEYEYjs7KNylVDRuWIH1YCjEz3ECdCJylze95kwTo5X33bckaW4qht2I9yrbhqMqUYjMQ87ojQvC8dLfxfR118uGO1ZV1SYHoYnoMOiqG3T84U3Qeue5ylNxCIFW8B6J+NK7b0VGuaXprD/4+lyBBd0UZiNVKyJsHYVdUG/7b7TzpyPrW4ZedInHoN2gE+yr1Q5PbH6yMzsVnPfF7ZVnTNIbhnwD9OS8M5KcDNvbOTtm9OWWDp37VSPmMyhWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sfh4bTAv0pzzVgRm13LxdL0UG9lCgW8MA+UnVFVa5II=;
 b=wRRhexa8eTzrzBqBSTqLvC9DcJnMI2KnaZA/FNE+QOYcjQKsGMREXs/q8rD+qs+Os465dS25nga10bYZraSz8+At62Kd5kudUrp9RUKepLq+wiy2m1Z5mxhpGze72DBYzKxr1unO7sjqohFewbYD4zJklls6EuxJDM+Bla0F2FI=
Authentication-Results: amazon.com; dkim=none (message not signed)
 header.d=none;amazon.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3288.namprd10.prod.outlook.com (2603:10b6:a03:156::21)
 by BYAPR10MB2728.namprd10.prod.outlook.com (2603:10b6:a02:b9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Mon, 8 Mar
 2021 20:33:39 +0000
Received: from BYAPR10MB3288.namprd10.prod.outlook.com
 ([fe80::f489:4e25:63e0:c721]) by BYAPR10MB3288.namprd10.prod.outlook.com
 ([fe80::f489:4e25:63e0:c721%7]) with mapi id 15.20.3912.027; Mon, 8 Mar 2021
 20:33:39 +0000
Subject: Re: [PATCH v4 2/3] xen/events: don't unmask an event channel when an
 eoi is pending
To:     Juergen Gross <jgross@suse.com>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, ross.lagerwall@citrix.com
Cc:     Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org, Julien Grall <julien@xen.org>,
        Julien Grall <jgrall@amazon.com>
References: <20210306161833.4552-1-jgross@suse.com>
 <20210306161833.4552-3-jgross@suse.com>
From:   Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <ff9fb99f-12ca-c04e-e4bc-1b1c67381cc2@oracle.com>
Date:   Mon, 8 Mar 2021 15:33:33 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
In-Reply-To: <20210306161833.4552-3-jgross@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [138.3.200.0]
X-ClientProxiedBy: SA0PR13CA0025.namprd13.prod.outlook.com
 (2603:10b6:806:130::30) To BYAPR10MB3288.namprd10.prod.outlook.com
 (2603:10b6:a03:156::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.74.106.64] (138.3.200.0) by SA0PR13CA0025.namprd13.prod.outlook.com (2603:10b6:806:130::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.22 via Frontend Transport; Mon, 8 Mar 2021 20:33:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0c6b90f5-001c-434f-67aa-08d8e27174a1
X-MS-TrafficTypeDiagnostic: BYAPR10MB2728:
X-Microsoft-Antispam-PRVS: <BYAPR10MB272805732535B091418B1ECE8A939@BYAPR10MB2728.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MqrKX6HA9vF+ia18hPRRU99v9ZQz4XXiO3Ih2VhHEn/k2LeFJ9TYGtrXEGUq0P8ocVsEFirUM94WwoMYKuRP8euiXlYo08OP7anRMJo/oUsuSM/fpmX7Jx/YBpVVjgLib0/JOLDE9r8yOeu2+NhGAyZNGlWrLvrdg9fXJaGHkKBm9i20742LSNxy7D1SnCEzNoJZg3a49YyB3Z+jxvhyrfql4rkycGcm8WaPh6ehKyng4A3QPT7D+ei8rauhWYOlu4nBvlJJ6sBOSsgKnEM+mey+p2wmQoZGGSclFhOz8JRG7YD9EJf4ioGt/u7uKUulJYWbyEL0ueEJt0QsbJwNYEBWIOTBnjXJMfHGqms4PE4geUr5TGzMO+AHdw3WBwO1GwMXTaY/urTsJ5oOLAcyfcrf//Q19OxPNSNDZKiaqkj8rb/IWJmjq85n559T6A6aObuO/6kXA4eMC2n3TmC+tvpprNI7tb2SAXW/5+WG8Ck5NZ6xOOvVsUr3KVEZjQF4z6UkdPh5Rxn/J7l4T+6axIM+Zxvsmbq9X/ym88R7entTe5iNp6brwdocRvl9cciGDlfwo5opIvKKokmAroJjoP3fZP19VkbfwzjSzWmb88o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3288.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(376002)(346002)(366004)(39860400002)(956004)(186003)(31696002)(2616005)(478600001)(83380400001)(316002)(66946007)(4326008)(66476007)(66556008)(8936002)(26005)(6666004)(16576012)(16526019)(8676002)(36756003)(54906003)(53546011)(5660300002)(2906002)(31686004)(4744005)(6486002)(86362001)(44832011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?S0hFQ21HUFhZQXp0OE83dnRNdmpuNEV3V0lmYWx1TE5jTUxUTVlPT3BYb1Zn?=
 =?utf-8?B?SzZ4eWVFSWQxQ0dqajZxWHFHMGJBa1QyREsvcWo1Y2xkM09lZTdyUDhjdFps?=
 =?utf-8?B?dk9BZHNJNmhmSi9BazBBTXQzK2tPdnlqK2U3djB6M3pPNmM5WmtYaW92TWUv?=
 =?utf-8?B?VGExR21HWXJEZlFBN2VoeFJKdXMwSlRWZDcrRFRNeWU2M3JSUi9rNGphQ2lm?=
 =?utf-8?B?bVQ5ZzhWQTRsZVhCSEpPVFo0MXRxNmFFRDFsYmZmM2JMeG92M3B0QllBWW84?=
 =?utf-8?B?QjV6SHdIb0w2YkFxdkRIQlB2dFphOTRDYkthT0lXdlB2cVBkckxWdVhBOERs?=
 =?utf-8?B?NFBTQkdmSUFONTFmdnRLQktMMkdsS2I2WmNqcTJwRzdGdmx2cU1mbFVoWFFG?=
 =?utf-8?B?bFNPY0xSUjFEUEI4NE04UElwMzkxaUM5cUlnOUNBelZuVWR2UmRYN3VJVmN2?=
 =?utf-8?B?cmFxZ3NuV0UvR1dLb2xXTnF5TWs0UVg3UGgzWUcrdGttZ016QXBHc1VTSWU1?=
 =?utf-8?B?WXhVZFZTdmpoZnJSenV2R3ZXeVVwUC8rMlR3NlJPWi9UNjVVbk5QbTBLQUgv?=
 =?utf-8?B?eE9waGVuUHBpbHF1djdQcXU5MVR4UmpGeVR3eHdmZ2ZMdEVTUFkyNmpMb1lN?=
 =?utf-8?B?T2N4emlZTThSTkE0d0gySXoyMnpteHVRNkJUa0tCbWsvVHl3L0JpQjFYM2FE?=
 =?utf-8?B?TUY2dTVDZnlVTERLZEt5enduYVhLVlRFMGYveDFaMDU5UUxOdUlNVkhrcDlT?=
 =?utf-8?B?eFV6QW91L1JoNlptVmZMUHQ3RyszOWx2MHk1dXYwcVI5RHBmYWRGUzVZN1c1?=
 =?utf-8?B?QmY4TzdFamlWMnVPRlRpRFZ2eHkrdG9YUFY0Q3kvR1FrdzZYRHFUMUJPZkx6?=
 =?utf-8?B?L0ljZktPTGlUSEpRd2xFaHZjblVIQUpMRGl3UVFPY0JPcmp6TkNJMXZUcU42?=
 =?utf-8?B?VzZ5cHRMYmhGSis2cUFUR3NjamQvdXR3b0tpV0RPaW9DL2tURVNGZHBmL2FJ?=
 =?utf-8?B?eVJRT1F0UFRCd1U3K2VCTTVBSzBLaEpaKzl6cmMyWEdMT0ZMQmRPWXJDbkwz?=
 =?utf-8?B?Zi90eExVWWNUenZOU0FlZlJEQno3bHJxdDB3b0FhdndEZE9XU1JjaDhHbGZB?=
 =?utf-8?B?cjlqQUtZNm5QcE0wZ2Zvak01WlI5SlgwQy9xWHBmVi84TWhBMkNpdFF3OG9K?=
 =?utf-8?B?bGVaeDVXRkFxWHREeWtELzJObFI3ZUxGVGNOaFhUMnBrREhKR294NUVwVmdF?=
 =?utf-8?B?YnBKaDY1ZjlRZ0V2NnNuMXJnUElEUzJQcmdxcTZvODN3UFdHYjI4OW0vZ05t?=
 =?utf-8?B?UHJIS1FsV3BZSEw1TUlZYkNzTUo1S3BYc2RVUkdOcHVFeER0U09uMG5vcU96?=
 =?utf-8?B?ZzROazI3SklickhyenZaVnR5cW1YNkt5WStxYmgyZWZOWVMxeFRZd3JTQSt1?=
 =?utf-8?B?RVlXak1McXdidWY1dURKOHRHcy9nczRVUWlEOVN1Nng2Z2l0MmZZbHNMejVr?=
 =?utf-8?B?MVBTZ3lidDI0M0hkQzFqTU1RNXhvKzFyNlZXTlNrVGR6a0FCU2ZKM0JqMGtP?=
 =?utf-8?B?K2N2SzRvTFNQL2dIYlZZOFVGc3VkY2Y3U2VDeUwyeUFnL21OU2ljVXpPeFhO?=
 =?utf-8?B?M2FFTldaL3ZaOW5FcUV1cGxhVmxCRFN2Z2RiTDdsdnZVTFZWUVdPSURHMmJ0?=
 =?utf-8?B?R01ibnJmbUdTV3BQUStFUTdaQXBPOElkUzZCVzBVQTlnQjZveENwTjV0T2hZ?=
 =?utf-8?Q?AH1vbiBJb8S0q7b09AlgLrRjGu8lylV1S/jlSgG?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c6b90f5-001c-434f-67aa-08d8e27174a1
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3288.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2021 20:33:39.2519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pl7VJxOi1ZWKq7QP/LBfqnR9ISM4Z4q8NhIP6UMNroaXOGvg4QVUx3NSFDEq3b08h+zkRwJ643twzkWeO/fV67ZTX6OAYCcIQRhEcoA+IHM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2728
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9917 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 phishscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103080107
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9917 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 clxscore=1011 phishscore=0 adultscore=0 mlxlogscore=999 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 mlxscore=0 impostorscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103080107
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 3/6/21 11:18 AM, Juergen Gross wrote:
> An event channel should be kept masked when an eoi is pending for it.
> When being migrated to another cpu it might be unmasked, though.
>
> In order to avoid this keep three different flags for each event channel
> to be able to distinguish "normal" masking/unmasking from eoi related
> masking/unmasking and temporary masking. The event channel should only
> be able to generate an interrupt if all flags are cleared.
>
> Cc: stable@vger.kernel.org
> Fixes: 54c9de89895e0a36047 ("xen/events: add a new late EOI evtchn framework")
> Reported-by: Julien Grall <julien@xen.org>
> Signed-off-by: Juergen Gross <jgross@suse.com>
> Reviewed-by: Julien Grall <jgrall@amazon.com>
> ---
> V2:
> - introduce a lock around masking/unmasking
> - merge patch 3 into this one (Jan Beulich)
> V4:
> - don't set eoi masking flag in lateeoi_mask_ack_dynirq()


Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>


Ross, are you planning to test this?


-boris


