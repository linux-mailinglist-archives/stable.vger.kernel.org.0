Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECA4F6D4192
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 12:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbjDCKJ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 06:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbjDCKJY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 06:09:24 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2083.outbound.protection.outlook.com [40.107.105.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72FC7213A;
        Mon,  3 Apr 2023 03:09:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dcnQd8c/QbWvLVVASTThZlhTM3A17IXfF6U4I3jRE2Y9HOb9ZrFvyVnkz/rgeyRZvcBqBf+RHySZfAp/Mx4e1O8ttD3JgmMBKM3SxuD0KuDD41I5hNHEPzdT1dBF41SOm7YD6wVOlrVPK2S9YTnwxygfQcY207yC9bDpe57eQhNu8N6dPzz73LhNDOlJm5tf/2fBnxNI+Qu/rRWnkJF+fJvwFJV3HBgcDG6bC3UFcdKHis7WLzTzGx8A12MdeekUbbfschpTHBdMzw8GXVZowDmNxmIryVtbVf/BqElArBLl64HGjBmlOX3zq7tZiORm64FjPpDkO49jEBjji2/FAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cqBYy8+9RVsf+te3aMsiLo6/GEMh97TxhPMb0ywJ42Y=;
 b=g8LGMel4JRjtYALMP2awasyUSNXSjJ9af0nbqJ6ODxCre5IQpaTqzM2Rpg64BnuEiN7bXqd/6sBM/yZ0804qQDAsatnEwVC864vq8g++nZ4XvOJyjkm6lX5AIi2OfmroS+DfD7R73x56IFtZ/FusPuQTuUWT99KvH6o2UBTIgg+H/y0ToRF1itbXszeoRFFnZI8x6FLpGWrNJrGcD/RqPPY9pslSRBoWyQaFxDXG6j4EP9tHe1x6gK8qIcBnE8txLkatVRtjeokmbWYryFvneNrvt1wWETMHRlUPwAjy9ya8fZjosKRcEOOtAnwf1VkpSdGaW6dOjUYAQ4XTdBRWHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cqBYy8+9RVsf+te3aMsiLo6/GEMh97TxhPMb0ywJ42Y=;
 b=YA8dbKOHTJtDNyQ+2qoCAhi6wV1yMMAZgJdYliKbggVjZyGF4NYMYr+BNBMpiT5HaO6t9nyAW/adKPt0R7v1AigIgkB/bY5fz/qOcTPVzsEJW903nzFXVWQvt20JBGMrZZUiDRAUUMzbl7kIFShA072aOjuW8MRYibsxyMGLY5HNnUHy1SfgIDmySekWgz3m37g+T5GzxoYOLjUETbeSmNrL3AEYVSw3/W9UXFgGoRwCbSe+Sh5qJGLqkvpiBmFFXRhFG5R7NqTNro16xFHrWIRTbMj5JUh4j1zlHiDcSoag/BXt12ZL7BvKkBNcHcznhXPOsgFAfm8KG/8f1psiBg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR04MB7104.eurprd04.prod.outlook.com (2603:10a6:800:126::9)
 by GVXPR04MB10071.eurprd04.prod.outlook.com (2603:10a6:150:11a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.30; Mon, 3 Apr
 2023 10:09:20 +0000
Received: from VI1PR04MB7104.eurprd04.prod.outlook.com
 ([fe80::74bd:991c:527d:aa61]) by VI1PR04MB7104.eurprd04.prod.outlook.com
 ([fe80::74bd:991c:527d:aa61%9]) with mapi id 15.20.6254.033; Mon, 3 Apr 2023
 10:09:20 +0000
Message-ID: <28ec4e65-647f-2567-fb7d-f656940d4e43@suse.com>
Date:   Mon, 3 Apr 2023 12:09:13 +0200
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
X-ClientProxiedBy: FR0P281CA0136.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::10) To VI1PR04MB7104.eurprd04.prod.outlook.com
 (2603:10a6:800:126::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB7104:EE_|GVXPR04MB10071:EE_
X-MS-Office365-Filtering-Correlation-Id: a650da2d-b676-4874-bbe5-08db342b7c87
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uXccuJqktl/ZkbxKr5ykxslqeUzcQNwIes9RNoqxpIQzyJ9G2iT5glB69HlWGf7H64cXOZXkLlhiTf1MYh/3IwAe8tjFGfPTJD0zsyZxkEsZXvmss9I4Fj92k+JjFbWOmC/S1N0RmW+HDSP4/Vv+b/ulxEMbRoY7hg6Y1IodqRZjj3bdXj6gTM4fCK6XnfNms8Av5HqQFEej2ksJ6JkoNHA1vA3yVwFgRaAOQr2z4GQUvJ7E/F0FlmG3FNhNtH6kOg1iU0xLzLPRauyhqnJ/Ggt94L7YMoLfVTE0p/S251T+rw6R2MyU3UnDcJU3s2/1Q/iwDgTb2kOZ8vPFPttLPdVlCsMA4ZhAo0asHsD5V5r6YGjUcJe3Zv+8kXAro0dvR/fLGj1y6DBNqDfyNom2MhqPGy86wAMXnI9pwULLNejgiLWzfdDOdy/IgFYr4acBELFAUxGI+sNCQW0U/8+C1O98UQ0l1ApRAyQhP4PXURBSGvs6FDPoI1qsd5clbqd/aB70ZGe/GTr4eJd6ubjo71IreGZ4sVkNw4/LgTErDegclepnIBolgB3ng2s7iZdRUmcpMi6S+oe/gYp7SWXHyCCvpIXtHHMdD0x/173NAUCq7rAKR9C+u3s4DjNwq89Q+K9sInIXGgSOuG0V4b5Rpw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB7104.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(136003)(346002)(366004)(376002)(451199021)(31696002)(86362001)(36756003)(2906002)(31686004)(2616005)(53546011)(83380400001)(186003)(6506007)(6486002)(6666004)(6512007)(4326008)(8676002)(66476007)(478600001)(66556008)(66946007)(41300700001)(38100700002)(5660300002)(54906003)(110136005)(316002)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cFNTWkxNWVhXTm1tTW9raUE4djhEODBmRGJyYTlEeFpHaWd6cTRWZjdaOGxM?=
 =?utf-8?B?NEFaM0VSSnBVTXJJVUdwViszZysyNTA1THhscjNjbjAyS21wQm9UazMzV2JE?=
 =?utf-8?B?cTh6eklJQ1lpUytjSFhBUjlpdWptYWFucGpYZVFYTUdzM2hiU3d3eUdVeTVP?=
 =?utf-8?B?aVd5MjdsbHp1c3dCUXh3aTZPWWgrRHpkakVEUDVkeFBQbWJpQVRiYWtnWW1S?=
 =?utf-8?B?MmZFbE5ybWdnSkJSOGI2OUNhRExPU1BMdEozLzMyVTU3Sjd1MFJTekp5UlRM?=
 =?utf-8?B?M0E0cjJYV1VEdVBra1pzdXZvWFd4cThINjhjSUlSd3l1cnJHUXpnUEdWMG9S?=
 =?utf-8?B?V0F6WmZlZ0tYUThwaUljaGZFaXZFMHFHUHNGK0RQc09VRWViWkRodGlFOERQ?=
 =?utf-8?B?UEJRODNkVE05TjZqMFJmSkFQZ0tXVm1ITnRRTE1WWitXcEVVYVlJWDZqUXhX?=
 =?utf-8?B?b0ZoRmNNV2c0UjUzYXBwZ3AwYTlITU9qLzdNOUVNVi9ZTjRzKzZDZ3lFSU8r?=
 =?utf-8?B?cWlwb0dCclZVZjMvQ29YRHNRSmV5TDJvTitDOXZsczVrTkh1ZzRMbG1HWW95?=
 =?utf-8?B?TXN1RFNkSmw0TWRvL3ZHMW1MQkFQd0MxeHVOQzZWbkh1Q2FRcmJsSnloMFox?=
 =?utf-8?B?bGEvNWJjU0lJN3pXTVFKTTJTUVpHL21tU2VKVVNJVWtFd09KRWkrT092T0th?=
 =?utf-8?B?dndwRUpDMkpsUDFVenltVjNOWnY5ZFFiYjlIdVZYMldONTBiMGREVWY5WW1m?=
 =?utf-8?B?REpDZGpyU25GNWNRZCtSSGoxdWdYb2RZNE5obFlxaDBGKzBHWm1XNk9SYkhL?=
 =?utf-8?B?VitCdzJpVUtLaE01aU5pY0lvWnNZaVA1OGdnU3BOdkpTSEdZWXNRQ1lNOHFK?=
 =?utf-8?B?UlZTNitZcGRKd0ErYnNWQXBIdG9mVG1UclI4MFdickh5OUpGbTQwcTJ6UnhT?=
 =?utf-8?B?MlpIWE9mdWt0R3d1OHYrRklRZ0NDT3lQQkhMMXUwSis3RTJ5Z2VoekFBSDFh?=
 =?utf-8?B?NFlmUC9oaHdzaFM0UmYzWjgyQjZWZzRqWFZmQUM0L0NpbmZYNmhDNFdUbHg5?=
 =?utf-8?B?a25pamR2dmZ6WmV1d04zSm5QcW1iT0t2QmhaOWxsMHZlMFl5SnArVGovYjls?=
 =?utf-8?B?YWlFNy9lVGVIM1FqM1NJMXhsRTk3ZFJjdkRySjZ2alU2bkRvckQ4T3ZQQ29X?=
 =?utf-8?B?dHcrWE5zcytLNmliUVppVVk3c1lQdVdXY0wrdkE4Q3J1VUVoVjZxSVd2VzBn?=
 =?utf-8?B?aHZkZjVqbDh5Vm9HTWJUT1hrNGd3WUd5bkdvUE4wR1ErY0ptaGVQTWlRSitL?=
 =?utf-8?B?aXFpbUF2MDlnZW9pVkJaOHg3NXFRMlUxbXRJZFVybzFwcTRuTWU4eS8xek9Z?=
 =?utf-8?B?bzN6c1pjLzNuMTRyTjRJQW5TMjJld3U1Q0crcHNxQnlPdUVqUXhDSUpmeEd2?=
 =?utf-8?B?WkkxTTF0MFJGNStuK2g4cXBlMDlzdEVZUzl3c29qT2RzQ3dzc0w5b2dSZmFr?=
 =?utf-8?B?aFMzL3BWUmQzcHpNV3FWcExNQjVPcnl2UllPQ0toU1ZUM29uRjBuUTg2RVFZ?=
 =?utf-8?B?SThKT1BJRC9oZWJRVlBaMzFjaHc1Q2VFSFZuM2tPc0xkdmYxNEc5ZVEwTHVu?=
 =?utf-8?B?Z1ZoUzVyRmZtMWxham54WjVTeTMxVGFYcjNmdG4yUEZkZ1ROeWticzNmU01l?=
 =?utf-8?B?d3U5M0ZPNjJBbXJBdHB4TUl4VjNtVzdWL3dRRG44OS9mOXluWStrZzUrTXRt?=
 =?utf-8?B?dVFiRXJ1UnAvRGJTWUNUVDk5WVYvdWpSOE1NaWJKL3BMcW9CdmxQc0I4K0Yz?=
 =?utf-8?B?a0R0WnhROE5wam9NbXVPZ1VrZUZxdVIxbGlFd1lzRDIxb1JlWjVSRktXck92?=
 =?utf-8?B?UGc5ckFoTk5MK0dkRlcybWJqdzlpaHNLeXg2Z3R4elM1S2JLRXRucDJrTUJ6?=
 =?utf-8?B?SHN3Q0prcUx4Witkc2xaMVo1bEhpbDU4Tk9YajJPa29RbWk2VU9EQjArcG5P?=
 =?utf-8?B?N1pjSWRaWlFYcWE4aC9VQTJ5Z3NPMkxnVC9tcThkZkh5SWJuVXhQSW9DS1ov?=
 =?utf-8?B?cTNjbVMzT2JENU9GemhrR0xvN2hIMkZndE5XTm5Wc1JqMnNzODAzQXVMb3A0?=
 =?utf-8?B?eDZ0TG1ISlZVL2x6TjhmdE96WnJaa0tsZDJrdndqS052ei8rZkp4S042OXNx?=
 =?utf-8?Q?JN7qamF6owfn74RozfVtGdfhrXramhwylK0UgKNQYplB?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a650da2d-b676-4874-bbe5-08db342b7c87
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB7104.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 10:09:20.4607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BPGPZy+ZxXlfbGXq6SXJKwsf4cqiAcSkgWxDqIxKvnqIZGqRqWFYUPUk8s0l57pdMSLCJdMMg2y1snMDklZ5Jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR04MB10071
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

Hi,

> Referring to patch with commit ID (*e10dcb1b6ba714243ad5a35a11b91cc14103a9a9*).
> 
> This is a spec violation for CDC NCM class driver. Driver clearly says the significance of network capabilities. (snapshot below)
> 
> However, with the mentioned patch these values are disrespected and commands specific to these capabilities are sent from the host regardless of device' capabilities to handle them.

Right. So for your device, the correct behavior would be to do
nothing, wouldn't it? The packets would be delivered and the host
needs to filter and discard unrequested packets.

> Currently we are setting these bits to 0 indicating no capabilities on our device and still we observe that Host (Linux kernel host cdc driver) has been sending requests specific to these capabilities.
> 
> Please let me know if there is a better way to indicate host that device does not have these capabilities.

no you are doing things as they are supposed to be done and
the host is at fault. This kernel bug needs to be fixed.

	Regards
		Oliver

