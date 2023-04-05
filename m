Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 544C96D7A6B
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 12:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbjDEKyE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 06:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbjDEKyC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 06:54:02 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2044.outbound.protection.outlook.com [40.107.22.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6428593;
        Wed,  5 Apr 2023 03:53:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GfodN7paT5FHPC2P4qjl3LubF4qD057UJYBSnj8/Uq2Ige1T+eAVjnN8xpTDkKW/hBYDLEpi7cvDZiMcyOVgq6SUuZv8NzJBOGwzMVjxIauebVmkT101Xo6nqhRZV6NT1LQr+apDRsBe33vcm5nsk+XY5blxnPmYJtHF3UBcYn0oYz8L7D3of4NSorVO+WNLLkUumv/zzARh0kpsVv9JHGBSLjNlh9bLWXo5w7qeggtU3miWI0sFxK9GZ/26uHs2F5tdB7NaYibzjIXNIspI8t7MJE+rQlfw5GwURGpEu+etqC2uKO6y6BOlQGsuA+j2Nkj7vGseRXtjATSzwagZeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z+GJgY93Ct2szR7Cnk0Q+TlFgUy+yEdnmsQbDvbZJb0=;
 b=mPRf31IEcYbV7+aQv91rL6vhWJyIQDDBwzstfQ/b6wn3o4sAkJH80dNPL/izWo3KriIknYlgyawXcjGs5rXGXg8ftX4lbNO6lu0xAIAfCkgAYioNPL9X3aJtcGh9A7W81mP6ETeOFS2cChfp7fk+CX7QIpYYus2Cs9w/X5Ck1S1OKI0WPr1ZcLEmWy07tDsPA+vou+Q9Qp+JqOirwl1EMsI2b/JhIkv9lanNo93FrNVDWl1tlPnatDKfMBaYDOy2kWXbDIh8UOtjLC2l/oxx7VTpNG5e9wILKGvOlAmVkXBiOM8zF3LYUG8Sf96aDaJNwi6fKqChlhKQXdftcNNhlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z+GJgY93Ct2szR7Cnk0Q+TlFgUy+yEdnmsQbDvbZJb0=;
 b=NVR96hf7DkZfI3vMGBQwc2Sw1M6MgtHBUX9dQJT+iFX3ATPJASRlRx+MfwNtT0OusCWsG1wVQSEnsFcvBJ3DPnHPh1l5US04YoUi7QqiUWBnMagYKUFQ9/RELIClwXnTtvcD4WpA5+Ndyodj28cNZvdgQXCJvCyQMDK+TJGCjKl6+6zSbMR/aiRgYgK7HCUnaByfgXCRfim8rtsRviWh39NbFYOGg6Mo+G8xvDe54tWWWGOkiY2PObi2QnIhSjarjt4feZpR+3SeogfVogGQHT3t5R4EqMXQqEcLKMacjfw5wjgJEqgT5yfrrBlwEL0Eb4oqAoQZu8WZqFIBgNFkWA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR04MB7104.eurprd04.prod.outlook.com (2603:10a6:800:126::9)
 by DB9PR04MB9940.eurprd04.prod.outlook.com (2603:10a6:10:4c1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Wed, 5 Apr
 2023 10:53:49 +0000
Received: from VI1PR04MB7104.eurprd04.prod.outlook.com
 ([fe80::74bd:991c:527d:aa61]) by VI1PR04MB7104.eurprd04.prod.outlook.com
 ([fe80::74bd:991c:527d:aa61%9]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 10:53:48 +0000
Message-ID: <3a51acb5-6862-7558-5807-c94f8e0d0f64@suse.com>
Date:   Wed, 5 Apr 2023 12:53:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: issues with cdc ncm host class driver
Content-Language: en-US
To:     "Purohit, Kaushal" <kaushal.purohit@ti.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Cc:     "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
References: <da37bb0d43de465185c10aad9924f265@ti.com>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <da37bb0d43de465185c10aad9924f265@ti.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0053.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:93::6) To VI1PR04MB7104.eurprd04.prod.outlook.com
 (2603:10a6:800:126::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB7104:EE_|DB9PR04MB9940:EE_
X-MS-Office365-Filtering-Correlation-Id: f0c44ef6-6e37-4a52-93fd-08db35c408ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B4b1pNXWC56wL/JMZuJlRPLN0bHk3m+x6FNuH4Zx1Px2L1Tl4LQ+GrO8b/61YgylyKSsEAD5pBCOKPXg5405VWof98uduqpwyCleQUjVcX8mn7OXO00jt7I1t3oshHVghLfWrnz8ZOF8QH93Li6WhC3rSHRz9MQrpItmPLK2i+NiznvaS1n+HcA803CFvbQr0s79sIwfdnS2rhpnwrq+7hTwDKMbIuQa5nfL5QGz3n/kWIx+32mGucXPLlll986fa0yG5oxWpHdS8AD5yG1hvc/WM9vQp2LcviE7StDRjvO/2a8w+k7FmEAdI3Tc1G56HWn4ngkFPNgIKRUdq4Rswd61xC2ihMwRmuNMkOTUJgg1jDlISouGdn+b9GY4yURbbWIL+5c7lrhuiNgkAvRNLMwr116QaW7f7j2vsp3YuwytNKFPhztzOD5mXbw212EVzpIerC0Hn10x4sYGIl5Cq2fm49Z/hstwBdBj3DbjdCBWmhBw6G5QVNXk32XNEtJRg4PalW7sG6Ti2URTvokNQeexxG3AKiDdvGjVtohUbMUX7wpPU9KWaOiOZ6yQujh+1ACXnlVyUzzWBTteFVBreaZ1dXql932dyhKpLOgZg3bZeOTUP0085DNGfWjJvYb6mbdBFLbZdtfc/7jlqeDEIg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB7104.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(39860400002)(376002)(396003)(366004)(451199021)(6486002)(5660300002)(478600001)(36756003)(38100700002)(110136005)(31696002)(4326008)(66476007)(8676002)(66556008)(66946007)(86362001)(41300700001)(54906003)(316002)(8936002)(2616005)(4744005)(186003)(31686004)(6512007)(6506007)(2906002)(53546011)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZGJtK0NvUC9NSy9nbW9XenZIS29rdVEwNzZuTE45dDNyM1J4U281SWtVRWw4?=
 =?utf-8?B?RGZrcWxEMVM0RXVnT1BnUDYxVlNqUVdvNkJEN3UwY2dLK0FkTERibFZKdWMr?=
 =?utf-8?B?a3o1dGZ1RktzQmZvK1lhNi91NFdEeUd1UlBvOUhnelNJZ0JUL1FpTGFNaGxS?=
 =?utf-8?B?OXFNWXYyTkx1ajc4aURZUGozZ1NEaENzVkFzWFRlSjdzUzFqTXBrUzBoNkJv?=
 =?utf-8?B?d1lIUU9oTldkcVVvVUs0M2VIakJ5Y2w1VkFGUDNVUE9tRExBM2tFbTB5UVR2?=
 =?utf-8?B?S1NWM2U3SE9rWU94RUdpWldMZHpnZkpJczY1Y2x6TlRUaUUwd01kS1lQNEJv?=
 =?utf-8?B?dFhLM1RjN2dUckMzTytua2JqSDEvbWpMZDYvSzZSd1lKT2VKT284UU5EV0Jy?=
 =?utf-8?B?OWptRXgxZjZWbnVaa2NjT0thanFSamNLTzVnVmRYdE5vV0dxbzZtQzVoWmxk?=
 =?utf-8?B?NUJ1WkZPaUJZSythVWt2b3BRUE5SN0FwZVpEOUwwVWxsV1UwMTNyS3REYWJG?=
 =?utf-8?B?VWI3dXUyVjlpRTNjZnVMcGtrUkIzOHZGbEhSZnU0YkVXcU54YXBlTUM4T2Zn?=
 =?utf-8?B?MjFiZkVsUjRMbjgzRiszaUhaK2p2YlF5ay95ZWhIR3FEekYwMjNDR3dwWE9j?=
 =?utf-8?B?MGQxZTA1Tkc1S1FCTm96WFAwa0hWMlgwUTRnbWtmbVdnbnh1OU5uQkg2RnFj?=
 =?utf-8?B?WDYyVUxPQmZUQlRSV2pSQnlLQ00vazZPbnhPVlBNYUE5bldjS3RnZjIrS3h6?=
 =?utf-8?B?amVjbG40eWpmNmVNdzNxNXcxc0JMWTB3V2Z5LzRMQUZnUVFwK1lZVDBQbzdS?=
 =?utf-8?B?dWo3TE9xMUFLZ2tTM0d0VjIycjIzU3VodVFleUdTanp2ZGduOVRsdHVCNVYx?=
 =?utf-8?B?dW9ZUVNUSVlqNWRmcWphUnJZMks4M1N5ZU5OMGNrYjJHdFBndk5GdVNkOWF3?=
 =?utf-8?B?NXpNQ2VaSUZFbitwZkw3cTB2dythVjRBakxDelNpSnVvcjIwRml5d0xCYlFi?=
 =?utf-8?B?WjA1Y2M0M0llTVRvbWZMSVFwVmRUcEEvRnA1TXdqeDJ5VlVqcGxVOHVnZ3Er?=
 =?utf-8?B?R29CRitaUThZUHo3T0l2YlBid2ZhbVlMYXdmV3hUTk9KVTEzWDhIM2wxU3Z0?=
 =?utf-8?B?WVQzUmtyeWVsdTFrc3Fkc2VyYnFkL0NqbnlhdVhkUmlTekVvTllzS21zV21X?=
 =?utf-8?B?L2dnWmNjdVBLK1lOdlF5VFBpNE1tMGlIOGVlU3ZlQ0FzaitRSXdSRG1vU3dH?=
 =?utf-8?B?dkJXa3VudTh4OFpYZUxLeFdUVnV4cUU0NXE5QjQ5QUlHSnI5WTNzQXUvWWh5?=
 =?utf-8?B?d25lVUl0bFdxQjlKTUFkdWxaOVZFcVQybS9wOHR3NXB2c3VZSlVwQ3g2R0lG?=
 =?utf-8?B?eElpYnlJcmxWNFVKcHJIRXFPTHlHbzByUVdtb2F6cExzTXZ3RlFxdzBIRVI3?=
 =?utf-8?B?d0dWd29vWHlQTCtra3NHQ2FoQzVGcldqSnZIY0ZranlaSGIzTll3Njh3R3hB?=
 =?utf-8?B?aXJnVHRHQ0FDUUo5NlpyemF0ZkR0Nm95SWZ1YzlYT05wdEJjUk9xOHJIL1p2?=
 =?utf-8?B?ZmtpNExZMG5BZWZueGJ6K0VBYkl4cVQweU82dlIxMU9EVVJxR29NYjA4a2FD?=
 =?utf-8?B?NkkxNENXeEFhL1hNZmZiNzdiRUJ1NUlRd2FvckFBeU1BVnBWaDJIK3dFaHQz?=
 =?utf-8?B?T2xyWG00TnZYeFJMeG4vMmRDM0tCcnpwTFk3bkxVKzNqR2R6clFNVEJ2Mklt?=
 =?utf-8?B?dlZBcmFaU2JmZkpTdXhXdWlHSEtwVFBJZWF3SWJGcFI5RkpWVFVUeXZrdTdG?=
 =?utf-8?B?THhoMS94R2dFYm1NbG9TVUhoUXcxWEdtTzVXSkI3NWh1MHBhUVJ0UGh1Y2Ez?=
 =?utf-8?B?a0luR2hadEt5M0Y3dW5JR1ZpUGExanNId0wxYk1GVjNvNjhSZmR4NC9nQXdB?=
 =?utf-8?B?WHEwR1B2OUxMQ1NCS1JsODlnbktjeFovVGhNeUhFc0ZWTWRaaG5wWEdnbU9Z?=
 =?utf-8?B?UXdFUStVOVRkSFQ3SlUybm5YYU9RZUpwQ25iN3h6cnB1bnBBRTJXbjNTWjZH?=
 =?utf-8?B?NDMvdC9tMGNma3hIb3ZvWjVhUytvZzVZbjArY2k3Ti9IbzdId3ZiUjdXTmV0?=
 =?utf-8?B?T0IyYTBTNFZGSE02bTJlVXdpVzZYcTJBUjRzY082Z1FhRFVnZGdDK3VFUCsx?=
 =?utf-8?Q?vf0G/VJ5IszpeN+33KnEsfLKDPS4ADik3/Yk594T7TVU?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0c44ef6-6e37-4a52-93fd-08db35c408ea
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB7104.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 10:53:48.7859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qw2IfosxQmQvrsX78gBHgZ2rHRuy1VIIOLOs2c6GQovGss6qJjq9+d9iplhsxb/8RDI5ZMhWHgOtTe2VUFtY+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9940
X-Spam-Status: No, score=-1.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 03.04.23 08:14, Purohit, Kaushal wrote:
> Hi,
> 
> Referring to patch with commit ID (*e10dcb1b6ba714243ad5a35a11b91cc14103a9a9*).
> 
> This is a spec violation for CDC NCM class driver. Driver clearly says the significance of network capabilities. (snapshot below)
> 
> However, with the mentioned patch these values are disrespected and commands specific to these capabilities are sent from the host regardless of device' capabilities to handle them.
> 
> Currently we are setting these bits to 0 indicating no capabilities on our device and still we observe that Host (Linux kernel host cdc driver) has been sending requests specific to these capabilities.

Hi,

please test the patch I've attached to kernel.org's bugzilla.

	Regards
		Oliver


