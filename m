Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 044C66DD6E7
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 11:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbjDKJer (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 05:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbjDKJeQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 05:34:16 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2045.outbound.protection.outlook.com [40.107.6.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A19163C2A;
        Tue, 11 Apr 2023 02:33:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZGVWt8iu20xA4Iv3Bxo9RPGPcFO1wSd4Jp35fbKkT5GSx/2A2AHr3Tiw2vCrqvp+sYbeCpoBDD2tAhI01wrLMGblFQ5zGmY0bgirG2Kx+CnQapoQSTmeBk2U21bQplEy8au5w53TAfRv4lRIj1ox5shrqylPXOMBLHSPW3sNvCCo2Y+SiFNDjP9rpVYyXSxVSfHVSf/8uf02EJq0w9lHASKQAErjkHzbSkXBNGksTo8X4xU4u5oDwh0zFtI4qYFXQMfLoFKouXhzRLLpS6pLYQT5dRt1cn0bTXyQD6rRJ6rZf7tnH/soa4pShjxVpQUxX4PbIXkBJlDMYjqSaMdj+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LIgOMlBQZu6tXSklCJJDZW++dQYKkPInGELXZBALRxU=;
 b=JHm+01GyppuCZgMPiyXC/TrPnG6toBSj/+FDO5vBhwUplqqp4PnCz2LsVLm33ZhaKslb6BB7sE4uyKfT3CFy0ZXNcMsSFFaxuceGXjoJAa1V7zUdU6dmDadbQbvZ2b3nU7H12i5NNYYatUI3ggrly+gov4ImTgJ1+04K8dJVYB4YZXV6c4NU5GwFd5gBPy+8WWRa4xjSH99BDYuiqHvTrgTcouZpmYY+EcYCG7R7SU0ZutSfRORhZT/oevrfrm0gMTsocvHE5Qey/0mZsifz+N/A1H65hGbxEfC6ZvJGW+RNyXFGgmOTAs8OFUgntg5hPAxwqU9H8yxIR6V65wN1jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LIgOMlBQZu6tXSklCJJDZW++dQYKkPInGELXZBALRxU=;
 b=Pkox4WJCZCoQE8tps0h26mCYCGHYCguwxhiY9+xzyi0Te9O6TUzALHx57nB4mLfGETdlHZ1+AHFHsvATHz7BGXWc+oOcCtFBIQWEwLguUQDz/QlA6IPLgWF79ZyLK1bkxDwk79RpttWdFP7WafLDI3hYZqMEmyFe2kheyZ2zncjX8QS5tQIe5vQjqPdmivGxG6GeF51giikUcXNwOv1FqiP9PngDXV9InWnPdtn1bMivEf+pUBFa0kyKukOh37K7NSpbpQREX4SvBskRKSf0WMwk+MPbe1iWlmjDy5fwcBdz0rlaFokfIHh8zo1DPwn1g/FBzcl/82IrWZveLoMJSQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR04MB7104.eurprd04.prod.outlook.com (2603:10a6:800:126::9)
 by DBAPR04MB7238.eurprd04.prod.outlook.com (2603:10a6:10:1aa::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 09:33:55 +0000
Received: from VI1PR04MB7104.eurprd04.prod.outlook.com
 ([fe80::74bd:991c:527d:aa61]) by VI1PR04MB7104.eurprd04.prod.outlook.com
 ([fe80::74bd:991c:527d:aa61%9]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 09:33:55 +0000
Message-ID: <cbb850f7-86db-3ddd-cece-c4e0d413c298@suse.com>
Date:   Tue, 11 Apr 2023 11:33:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] usb: core: hub: Disable autosuspend for VIA VL813 USB3.0
 hub
Content-Language: en-US
To:     Jimmy Hu <hhhuuu@google.com>, stern@rowland.harvard.edu,
        gregkh@linuxfoundation.org
Cc:     badhri@google.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20230411083145.2214105-1-hhhuuu@google.com>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <20230411083145.2214105-1-hhhuuu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0096.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9b::19) To VI1PR04MB7104.eurprd04.prod.outlook.com
 (2603:10a6:800:126::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB7104:EE_|DBAPR04MB7238:EE_
X-MS-Office365-Filtering-Correlation-Id: c9e7ba23-048c-4f7a-d140-08db3a6fde3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b02vshFX6wUbAG2kx1lm1OqfrhzTGHjuCrhFUbS48dn7elJX2ZuarYGZo5bJt2LB11bVf7ToaqyyDlrtNKFBSSw4r7zAq59+SzO1kpqekleHSninMrp+fTZqJVrOQYX8kgC1lC/XkS/qm5yzLUz1KGj0Q7NMfdQI5gRNjsDTjTLoM3VLN5MKwlBEkQcr/tInHhOnBVI30YwpTDpifKwErre1Y2wg+VfvINke44L0A95Fj0HVwX1PDdRzkjFBkCVNj/0WuCfo05reS4irLvwTvPEmBU4n1PEmJscdy+l+Iw1g9C7g7n4cVggp5t2ub3MSyzBGhjn8ez5EbIlccv8Ut+y/EKmYNNJ78qoO05a8EUmG+t7iHSBgDv8Dg7wj2h2vlLQiwV4WMBNPGeVJnYYrmJ4+orWoJ2OtP0+8VvAtLp/HdLvacgQ2lbVFhE5Q7KOJ8glFrkyKINXw37LTzERkpDByi01UrKNd8WfvUJC5iBSjQKW8WFmz+LJBOQGAKAbPEQHrBW5MAeFBd1a9P66CBTTFwMdSvDU7tqf0wNVPhOrCCcQ6tFcmJX4Yrg7STZVXeHZV0jUhd3nEvkZv36nbvDNlxpuc1IhEAom7uhjKBK3d64misfANLIWzfxIb9fFMO3PFpWvd9Bbqw+l0VE9F+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB7104.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39850400004)(396003)(346002)(366004)(136003)(451199021)(36756003)(86362001)(31696002)(6486002)(41300700001)(316002)(66556008)(478600001)(4326008)(8676002)(66946007)(66476007)(5660300002)(2906002)(8936002)(4744005)(38100700002)(186003)(53546011)(6666004)(6506007)(6512007)(2616005)(83380400001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bmtRcFI5TG5TZHlsODJYRGRwb0lFZkJPKzdrcWhoYmsyR0lpeDVtcjlJa2ty?=
 =?utf-8?B?elNtaXczMjQwK3B2VkYyNmhiNXAzaVdkYXB5citQcGJmaytrZWNLYk9OcWFJ?=
 =?utf-8?B?ZTFOV3lCN0txenZOOVF0eGdWMmJlRU5lNTBrNUd1K1cxVHpEQk9qYlNRZ0FX?=
 =?utf-8?B?Qmc5cUgxcUcyaHB3UjJOeUFkQTdwMzBidjFLWjlQVHhNTHZSdTEycXJEc1NW?=
 =?utf-8?B?QURJYzFEVENTRVZIWUxsd3dRdE53aTloajFtZHIyTFMzamFtNGRHWnpwWHQr?=
 =?utf-8?B?Wi9mcEVVYzNZNFBQSnNKVldyUWxObWZVY1dsNjcvZHVHTnA3ckxEUVArcXRy?=
 =?utf-8?B?eERVYVZHeXNRU2x3bVdXanNEZlRKVHZlWjNmdk4rb0Mra09oZ3U1NzB2Z2Zy?=
 =?utf-8?B?RlN4UmVWbUVHZUtRUXNOd3ZCdUkzY3VmV3dkdklQSnpubkgxeWpsblpOZEZH?=
 =?utf-8?B?L1RuZG16aUkrMUE0TTBMaGJGd3p6L3NpeEg2WE5ZLzdzQzlyN1JMeFRydndC?=
 =?utf-8?B?cFVDMHE4ZWN4V0h4VG9wMXhIdVc4Z21ickVuUERkMGhOVDV0aVJFTDhKYlFt?=
 =?utf-8?B?d1dzdDgvQjVUbVJucWorVG5ZZVp3cUdqYzRxSGd3dkVrWkZQWWpRVUxHejBU?=
 =?utf-8?B?bHk1NGZiZjFWNDhQTGVlNlhya2R0Q1dDMjBMZk5PazAzSFU5Zm15ZGErVWNE?=
 =?utf-8?B?TmpGNHBqMUFFVDhBMEs1Y2lwZ2E2OXFQcTExN2s1WFpkc2RYZmV1emR5VFFF?=
 =?utf-8?B?b3RtV0FCUzhQQVhSL0Vpa1d0dUJHRi9OYk9KampTREJPeXhyWDBYR3MzQ0V6?=
 =?utf-8?B?cy8vSG5zZTRpZnVsbTRkNFpYblFlaWdqOFJEcm5Vang3M1dmeUhwdzgrNE4r?=
 =?utf-8?B?TEVzWEJya2dxckpnQU1TYmpzTG1LR2lJWjYxSGY3OTVjcWRZNjBJcGlJanBI?=
 =?utf-8?B?VWR1cFBCS2NyUlpFbUp4bUFvT0tic1VrUVNUZE5QNWRqdjJrSnRHWnJvN0tI?=
 =?utf-8?B?RDRtd1REcUJPRmtKdTBtRE4xYmQyQWs0VFU2ZDZoUGlXM1pxUUJjRUxZZXlU?=
 =?utf-8?B?NzRTQzloTmZ6WDU5QStXMkpnMmV5ZXJGanpBVXQ4RVkxanpuVXhzY0oyNjV5?=
 =?utf-8?B?ZnlvUS9KWmRldTRtVDg1Tks0RmRNOFI3MGJCdmxydEJMOG80Wnp2aXJQTnly?=
 =?utf-8?B?SWRyMHhJL3pYOGJxeGpLdlpuTzllN0ZBSHhMdXd3MTFyN3FZY1R4bFoxdkJa?=
 =?utf-8?B?WkExRjhVUWtMYnozZ2xKUTkvTEZNTXk0anlsREFtb1I1MEpNQjBqMVJ0QWFZ?=
 =?utf-8?B?Qmh1RFNYcUZoWEhkSUFuUW11WGNxODZ2ZFpramZ2UE1tOUVCbms1SHpUczZS?=
 =?utf-8?B?T3kwdWUzQW8yN2NOMHpMU2tqbUZXZVRCSER0L3MzL0xncXNSckVlQ2NnOFI2?=
 =?utf-8?B?dmt6OXlSSzNrbGdQblo5aEZIQ0dlQmwrNGFtVGRubDE3cmNtSTZjVXdndnZ2?=
 =?utf-8?B?MjhCckZzKzZxM25QMUU1RFVnenpoMm1XNGQ0ZThXTTNHaHAybGM3ZlArV2dV?=
 =?utf-8?B?TE00UjV3TXc1TEJxTTJpRFdKT1ZJczZMUGNKSTRhVjAvZnh0aXZSWCthMGZF?=
 =?utf-8?B?VUtYU0MvZ1dMZ2ZMMk96R1hWLzlXZXRXRlM3bTlwdVNLcGQyUFJObEdTeXBX?=
 =?utf-8?B?M1pnMHJ3SG16TnZKTXdDazhsWlF6NWFBY1Z5TnZHSVhoMSs2WGcyek5CQ012?=
 =?utf-8?B?RWxqQmwxbS9NeHFtcDF2TUhWZWt0bVd0VkVCMmNuREZJRjJ1OFJNajlHSkJC?=
 =?utf-8?B?KzJkWVJJdldmN2ovZjFpQUp6R3dEMmxscTIzdTBwVnBPcVpLT29xbWdFcU5a?=
 =?utf-8?B?Q092SjNKTzdYSVU0OFFsQ2grYkc0QlJEVWVyYkJrWnMyaks4TlUwSDBEV0Fj?=
 =?utf-8?B?WnlreW91L1V1OHRqd3BkL1hEMjVzSkZsVmpYSXBXR3NSdXBnVXVUdit6Tlpk?=
 =?utf-8?B?QTJha2lnS0RsbC90QzhJZ3B3SEpuemtyd3FicjZrZHM5R2hZVGdRUk9kaGVh?=
 =?utf-8?B?MlRlNlJrU0pldVdFZzJxcG5vcFdnd0NSTGliOFFOQ0RxZFZtakhwZWM4VHhC?=
 =?utf-8?B?SWtiS05GMkR2T244dUdodWM3VzdsSVYxcVV4VnBqQ0RTTldmYzB2YXVVczlj?=
 =?utf-8?Q?hv7qmZXdGY7QEg7GvUqkyzAGwic1tq9tAHLW/VHrY6cv?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9e7ba23-048c-4f7a-d140-08db3a6fde3f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB7104.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 09:33:55.2274
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W32wTPiDXPTiaCw7e2PE0Zk2G4pUM35VHvnxxWWbL+OEUtuHObTqcJ/HJs3zGD+/UYOACHk4HzPiqev3Ms53Hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7238
X-Spam-Status: No, score=-1.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,RCVD_IN_VALIDITY_RPBL,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 11.04.23 10:31, Jimmy Hu wrote:
> The VIA VL813 USB3.0 hub appears to have an issue with autosuspend and
> detecting USB3 devices. This can be reproduced by connecting a USB3
> device to the hub after the hub enters autosuspend mode.

Hi,

out of interest, could you test whether this also applies to disconnections?
That is, does the hub reliably wake up if you unplug a device?

	Regards
		Oliver


