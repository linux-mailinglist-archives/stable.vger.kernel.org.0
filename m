Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ACFB44A825
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 09:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235973AbhKIIKT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 03:10:19 -0500
Received: from mail-bn8nam11on2086.outbound.protection.outlook.com ([40.107.236.86]:54497
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235389AbhKIIKS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 03:10:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oEsKn6cVsz6fY/ovnXb0barrb7Rf+u6oZITRpHnt1FgvMXxa/F6YwQYCMFZhAUbkvsZGQDNlMEhqi4yxHuDRFmVTnhZ2nC4ytnAUqVqzulsPpLfJlFDGB4quMO6OA1Dol+lXk6Ie8+w7dqRuhPljoh2EVqT/6QNsuRYgs4oVg8Dr4Lp6J8VPkAJnGRCvPTVMrBsg0LAV2lFhXr+YDszG4TLWzhlMAFB34P81oSna6QjJjoX1GHoo86xmvC2XOH5n8NaCn2apEv8hz7Dgiw7GTnn+bPAWtWKTylvY/xMnIUGCyZTzyKOEoSfif/Zrtch+hwkyEnJWnpidNkricwVEsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UE8P2LReeqJBaVSY4oBIHfoxsyBe3PdmpbhwCNLQKow=;
 b=EVJTh8ZAAV+TbRCfUtfKYXVqL3mNuAI3CJGAeflhFV2Uii2Oi9J+sWJjTwsAntf4YesuzHXVOSjwG+qZJT5du6hjtndJHOfmhK+gFlACg+NuVbZjkx/35LIfG2mYDIHO1U1LUhmJSoszEwMp5No5QwrDZjmgL2Gx7Or65bQxtdRPKC8/evhr5ata6kS05lQ06RXNlZh453CAloam6l7UP2duOkK0EL9Szw6AxSqN4KbG9kPjNI2dP5xFpzcvwceNrS+dJvOhApCEWkXrIlrzeVtzmeAZfMe35/n4Ho66h88saI6E/S1LR12asLOUYN+zjWuyfdoSFowPjYBO/aupXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UE8P2LReeqJBaVSY4oBIHfoxsyBe3PdmpbhwCNLQKow=;
 b=nqInLRxa9A5tXJJ4NIyoSKojA/IuiRxnZd8rnWN9hY52NRIY54Y9S97nUsdLK6/Y6a2fPHrzy5sAjZ9nzazNLZq0tJ0oFVcQgstdjJO3uzCcUj0FlxU2hPL9r2/2K2AHkuhMdFt6KBVnH6nmji8WiJ2ycQtrkN6JtZlFaqGtI18=
Authentication-Results: lists.linaro.org; dkim=none (message not signed)
 header.d=none;lists.linaro.org; dmarc=none action=none header.from=amd.com;
Received: from MWHPR1201MB0192.namprd12.prod.outlook.com
 (2603:10b6:301:5a::14) by MWHPR1201MB0191.namprd12.prod.outlook.com
 (2603:10b6:301:56::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10; Tue, 9 Nov
 2021 08:07:30 +0000
Received: from MWHPR1201MB0192.namprd12.prod.outlook.com
 ([fe80::2d02:26e7:a2d0:3769]) by MWHPR1201MB0192.namprd12.prod.outlook.com
 ([fe80::2d02:26e7:a2d0:3769%5]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 08:07:30 +0000
Subject: Re: AUTOSEL series truncated was -- Re: [PATCH AUTOSEL 5.15 001/146]
 dma-buf: WARN on dmabuf release with pending attachments
To:     Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Charan Teja Reddy <charante@codeaurora.org>,
        sumit.semwal@linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org
References: <20211108174453.1187052-1-sashal@kernel.org>
 <20211109075423.GA16766@amd>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <29a8e3e9-b1c6-fbd8-ddc6-1dc9f16ef68a@amd.com>
Date:   Tue, 9 Nov 2021 09:07:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20211109075423.GA16766@amd>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AS9PR06CA0082.eurprd06.prod.outlook.com
 (2603:10a6:20b:464::31) To MWHPR1201MB0192.namprd12.prod.outlook.com
 (2603:10b6:301:5a::14)
MIME-Version: 1.0
Received: from [192.168.178.21] (79.194.4.163) by AS9PR06CA0082.eurprd06.prod.outlook.com (2603:10a6:20b:464::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend Transport; Tue, 9 Nov 2021 08:07:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e45af0ee-976c-4303-82ce-08d9a357fa06
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0191:
X-Microsoft-Antispam-PRVS: <MWHPR1201MB0191D58BEC7AF4F5D1FCCE3E83929@MWHPR1201MB0191.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DavXAhSekKnTg8bNUZVAtR/9ddwf6wjlAeFXhQlkUxdBVHT6rLeHjJgayKjsqpkhgODR47iM1iOPD3UW2KOVKRoynwGZfeGRk0SsdLCsbOvMyh3SINDZbN0CWEOwNYYMA4rk/7qj4yXzpWeODBqJsfxhDh/smBGLIrXQ/yruF7WmoIW82Y+sLrhkSkO+s6vwnEO44ZevUOVcXbzGCvIEHRGKecXS/ndeMGrbBaWIi9QgDPpdAb1BTYPlOuFuFRw6j7nDgVM/ELVUEbnfLLnQiVcYcdyNPi75N9BnhajpByvNQ2XNCCwLI0D33U91aDciM0/fGAknGa7piAVyqYaCePXqjxcA6aa+aKRwyJSjhSqAbm/YfJ04fysDw9MD2QCAmM6prPr/V+Xw9kbKwiVoGSgPQzNQsy7u4mK/69lUuN0ApuORXVfH9jLmixthcPE/JMqw/Cl0fzJWJRwATBILLXmkL9A2s6f0Aoye2kt+2XDSxniQxgA3A+/CmGrTnvaG8jr/YsOPz8JfgkXyJJ/XbfuLv9L3ns3uWKjzfx3EX2tIwhWcoS5BJcleHEY2DaSk2vz8f9CKuMMA1TKc1f3tA4H2VBD3mG8HPVH29PsB1Qg3BZbWo6gnWEI4h50X+s2tudJa0n0rAzmDlSLO3EWlVVg5vBD/wUZmIc4cna+DZ+6tg+8beoSufBBtrsxNuQRTw3IOV5axpiCa/y7ET3qsA16LJN91k/KbA85BbM0v1aQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1201MB0192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(6666004)(36756003)(16576012)(8676002)(110136005)(956004)(26005)(66556008)(6486002)(66946007)(31696002)(2616005)(5660300002)(66476007)(316002)(186003)(508600001)(4326008)(83380400001)(38100700002)(8936002)(2906002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?Windows-1252?Q?XmbUb1lu3RkwQ+eEcV4WyjwMDuefaR4ApF6NOtuqKDmkJGHf559J9Y8n?=
 =?Windows-1252?Q?gOd5DyYktfk19lYD16KuauQfOL0/S7RZofXGuVgDte9qhhAMB+SWWTFy?=
 =?Windows-1252?Q?Sy1JcAHL/h3EbS9yd0IG9gbY9VmtE56VY6LDy/Shw/GFcb929FX1PyzK?=
 =?Windows-1252?Q?VGP1hph0lZfj2lIrXSk0U2gYZaUMgdljowF2k4B/E+82Xd4YdpgLxy1J?=
 =?Windows-1252?Q?XIAlON0f4ZJJHIIhfhsulp2I83s9bSJM0KcFlVmFbE/2dP5Ed/QVzSvv?=
 =?Windows-1252?Q?/3TGctcbxKPZrBh9p6ASx81+FS7Yv+5C8mmcBemKB7sEvzjkM8G8GSJk?=
 =?Windows-1252?Q?gadgpyBkz5TX3NJhwuEeete4DiPeMeEqYGyzDpYUbm3re+4DnBARA0Dw?=
 =?Windows-1252?Q?4AZOpiziSXEDyKXV5BwDSYNIdo1Hofprcvon9mjqm5+kBp7a7dIRbVGP?=
 =?Windows-1252?Q?XRp93ba4rnAWDHL7b7yZRfetj/7OYWMHZGypYT4tBkC+1pAZ6a5wjzHL?=
 =?Windows-1252?Q?q9iCcD9PcnEIrRv/PERGdIm3D2vH0jDPbbYpAkhaRRkF3gHEbnEj9C90?=
 =?Windows-1252?Q?BstjFZG6DvB+6RRUtFXoS55bz9JVBQpWVzMPfeFqg7vycDweZ/cAszGB?=
 =?Windows-1252?Q?2AjQWMzx8qBUjfZDDnUOYZWd8iaJdzNpNX2qXm1n5ZBqGllxaz6YDyKt?=
 =?Windows-1252?Q?Sib4K+xOVfzg08cpBUX/aBCcBLjbIb/gYn0ufmwfMZ53SfwX7y7dCIfm?=
 =?Windows-1252?Q?i6yZF9DCLjIybD/nWHuymDJ94vuTOSIdHPTaJO0uf4Ib6aRHMPDU9Ysy?=
 =?Windows-1252?Q?PcG8Ng7n5oqDllMhZ0yfIqWhzQibPLhf9a/Y80fr2i/ZDmHzrBqGWAt4?=
 =?Windows-1252?Q?H4FxXtWmKFXvnU5H3PM1AHIp9lvXtynmsTKxi3qI7n0dxpGCKglQ9yE0?=
 =?Windows-1252?Q?6BMzH2q8XjWiNxzlbVjp/Q1V39AHd9higFneSh059zdoxwAo9DjPXzl0?=
 =?Windows-1252?Q?Lrm6UYwVAsDtda1UKMghcWAXcxco7iKVL3lep9zuiXqnkDEXl5xRhMqE?=
 =?Windows-1252?Q?XUuT9QqPzWHWtGBq6LhBxtF4471hwGgUkSV6TtiSh+UX3QSDus3kks8E?=
 =?Windows-1252?Q?VrElcwtALjdnTeIiz+tcrENNmQcnaqUldcSrjOyHeu5nldu6qEtL66mb?=
 =?Windows-1252?Q?E2XOlppv2Kl8iQ3u0OrIFQSMMe2lL0YJK1cAzVt8kYg7wMAkyfkPsIhn?=
 =?Windows-1252?Q?Z5L/xQFkBd+gTALuGhQQyf9nRuq895c8AJjYRlt7TBtuCmIOquT1h8d3?=
 =?Windows-1252?Q?bVbWd4kfJU9N2B+MslRDgkr3f93Hn8PcVznYgXeVz7hAjimwYwIu31BN?=
 =?Windows-1252?Q?jUJtE2St3637ElSwy4c0AJwqEMPRa9YKsc4cWDjA2m6AP+wvYIr+/QR9?=
 =?Windows-1252?Q?wAnUOjai49JiyhQibSKaO92oR7zVODrgpt5wCmECEBFkrln9AUBO6gbX?=
 =?Windows-1252?Q?3laNiS76D3VWJ6ZO+JB5DwUUxoithPcb4Nq3a6UIXnBBF9inkQynV4JB?=
 =?Windows-1252?Q?wv/U9grNaczXR7xHsklLcRID/1jwUzfpVk6K7ah8FQ3xirUl30fGr0ZN?=
 =?Windows-1252?Q?zZ/1pqudb1z5Buy3Zr9b4hg5bqtQhpArHWg9LPbbaYdJxmeD6oMdv1BQ?=
 =?Windows-1252?Q?XBAgr2cx+7U=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e45af0ee-976c-4303-82ce-08d9a357fa06
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1201MB0192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2021 08:07:30.3378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Y5+29/4QQTINJIosCxP8uIHhtAMW4OVsmS0N2dipQR8s3Ma6UgfoodC/VQcESQb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0191
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Pavel,

Am 09.11.21 um 08:54 schrieb Pavel Machek:
> Hi!
>
> This series is truncated .. I only got first patches. Similary, 5.10
> series is truncated, [PATCH AUTOSEL 5.10 035/101] media: s5p-mfc: Add
> checking to s5p_mfc_probe... is last one I got.
>
> I got all the patches before that, so I believe it is not problem on
> my side, but I'd not mind someone confirming they are seeing the same
> problem...

It could of course be a different issue, but I've been experiencing 
similar problems since a couple of weeks now, especially with mailing 
lists hosted on the freedesktop.org servers and long series of mails. 
The symptons are that individual mails are missing from a series.

I'm usually registered with two completely separated mail accounts 
(private and work) on those lists and if a mail is missing it is always 
missing on both accounts. The interesting thing is that if it is a patch 
set then patchwork (https://patchwork.freedesktop.org/) always seems to 
get all mails.

No idea what's going on here and so far it was to rarely to complain, 
but with this series it is totally obvious that something is wrong.

Regards,
Christian.

>
> Best regards,
> 								Pavel
>

