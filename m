Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25FF2276648
	for <lists+stable@lfdr.de>; Thu, 24 Sep 2020 04:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbgIXCQu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Sep 2020 22:16:50 -0400
Received: from mail-mw2nam10on2080.outbound.protection.outlook.com ([40.107.94.80]:22625
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726281AbgIXCQu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Sep 2020 22:16:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aLkb7SCk3HQXf+/ewl11UJ8H1Bkn7q/uPNJQ2jVSnj3nCMTWilh0XTbCrczGu63x4qdikDu1rPyAGssoq9zRVF0xh4bfvPrSWwmvPkiRh/l6QUE/Wn0RkmQ0fkFHI9Z5tSEbwgZ1tXjkq1nL5J5Ji6NliPri43r+LaaZrms8PmFIkGhTcnx+dZQ487Mb/fq4YNb2OX/iV3lxMd8YTvWc5af7hno2EkCFm39fjsP7m4pcLPuuAhN3lZ7UDJiJTNjLx8B/Dr9fi0hlCK9J4/4qvPfbAT0V0e7w4gQ80SBuNeqnsxfKqVdx04b5cjWkwO4LKIIvgaNNUyaTFqQKwa4rYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1dtf1e6yRafuL4tQwKfZLKkaWEiTgLv9GXmRi/ilacY=;
 b=Scu1xJ7rgaUlvqSTe/pJrKBsrL+IZH37TuLtIhRTdoF53q3oxu3OXEMjnKfFZ3dLCHS3adm+A33Kw/wni8VVAqtDERbDObxZrn2cmz6Kl7BPtvWibFQxmAuk08fuAeEbWDGOqKmr8YXy2Q4AFvi5GaYtm/7VqOvKc1Vs2JwFmiDni8sNJEWwLyTKMjsKwhq4LwM/pO5w7xPItr9iuz0OOF0dbrL3byzASvRES3p6x8bZk3+rMB0Ht9TcixzpOLnHOk1OCSdO20ep5yLLlVaGMAxzvbyAtGS7gtiNbO21nBR5/j3bQKW0iZnsQLxLj74YcSFLS6Us1XQlpvxbnqXCmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=tw.synaptics.com; dmarc=pass action=none
 header.from=tw.synaptics.com; dkim=pass header.d=tw.synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1dtf1e6yRafuL4tQwKfZLKkaWEiTgLv9GXmRi/ilacY=;
 b=D+GwsTogZwSPDcgpEp+uUr2nGg5qBf4Jz5/Dpz1AVyQENot4heSWSy+V93qxurlDxI4fR0dmgtAXbS2XVyP+GFwrxzAf1H9LSwIQJWXVW2XFLKP/KiBtMyrP+n8kdyjMXp0uyvdeJRzmQritqk3zCQHDIOQDfvM747eQyaVjodI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=tw.synaptics.com;
Received: from SN6PR03MB3952.namprd03.prod.outlook.com (2603:10b6:805:75::26)
 by SA0PR03MB5562.namprd03.prod.outlook.com (2603:10b6:806:b7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Thu, 24 Sep
 2020 02:16:48 +0000
Received: from SN6PR03MB3952.namprd03.prod.outlook.com
 ([fe80::3c54:f5cf:3148:407e]) by SN6PR03MB3952.namprd03.prod.outlook.com
 ([fe80::3c54:f5cf:3148:407e%7]) with mapi id 15.20.3391.027; Thu, 24 Sep 2020
 02:16:48 +0000
Subject: Re: [PATCH 4.19 43/49] Input: trackpoint - add new trackpoint variant
 IDs
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20200921162034.660953761@linuxfoundation.org>
 <20200921162036.567357303@linuxfoundation.org>
 <20200922153957.GB18907@duo.ucw.cz> <20200922161642.GA2283857@kroah.com>
 <20200922202403.GA10773@duo.ucw.cz> <20200923204206.GN1681290@dtor-ws>
From:   Vincent Huang <vincent.huang@tw.synaptics.com>
Message-ID: <0b8d7397-0898-0695-e6f3-60a025f409e4@tw.synaptics.com>
Date:   Thu, 24 Sep 2020 10:16:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200923204206.GN1681290@dtor-ws>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: HK2PR02CA0173.apcprd02.prod.outlook.com
 (2603:1096:201:1f::33) To SN6PR03MB3952.namprd03.prod.outlook.com
 (2603:10b6:805:75::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.14.216.15] (60.250.40.146) by HK2PR02CA0173.apcprd02.prod.outlook.com (2603:1096:201:1f::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22 via Frontend Transport; Thu, 24 Sep 2020 02:16:45 +0000
X-Originating-IP: [60.250.40.146]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9dc45ee9-629f-4d05-1355-08d8602fe3f1
X-MS-TrafficTypeDiagnostic: SA0PR03MB5562:
X-Microsoft-Antispam-PRVS: <SA0PR03MB5562706B0549CF53C0DB5C0CD6390@SA0PR03MB5562.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lOxjzATyErJ40Wq8doUtS3iC19fUhx49KhWRyiECDA8JZEHGRgSLCABikp3rLMLmvkhL67dSPjU6Qhqjsgsoa52QcZdo9lRuI1IlGmUFPT7GC072VloLyEicvwZSZ+5Zasr3drMAVQ3NBUyejqs+nX/s1HjM1KRTKxTVrgJ2SBRiRZ3SpnR9DW0KgnJd2DaQ7ZN6Z40YAdG53o1nv2AtiFemRhEJnahENuVXCnE9SeeHssMuvkIhvVkE2fkQYDqDSXnB2mg1ioOZh+O4MRJY6I17VRBVq9/89qjOi9tiacsZv6Nh1BvlQLgyG6SkHn3zXXJP/shfn1nTn4+LuD3nrpJY7PqwxRr6S9JF3E9x6xlf2+k+KKHxIE/4OlDIu1Cp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR03MB3952.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(39860400002)(376002)(396003)(346002)(44832011)(2906002)(31686004)(478600001)(5660300002)(110136005)(4326008)(8676002)(66946007)(6486002)(31696002)(86362001)(186003)(52116002)(26005)(956004)(6666004)(66476007)(2616005)(316002)(8936002)(66556008)(16576012)(53546011)(16526019)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: KZI9fryhaVrpHWT8UoXDoM1Eo6sIL4EkitXnmWu3Qo0bgf1Fp/2e3QoSzzs/OD/Kmly9fg8Fnn9Y3AUQy6SDhs41dZY4bK3I0+s9eBOI7DmXcVHLSt9cc/BlHG3SomemtyJ6YXXlk/AZCYIdRWFE5F8u8AsfIzi+VgQLBkkIMBiRaNWh2udp3oWnluVu0x1Zqi52MJkhhy4Fk0K8cAGfHEXrFTEyp/PvAQi3MLs9kixlcrwpMdU3kaE1YPsdnvDfnyHESMdMv/cXjuA8cnB6kIv0Bhs4P5d/p1EziU0eB55r+/OXcD4TmrYd4E7cw1+7uoSDQOHVOBSWUEWT2qdD+mMMkCi3VcGr1c+vsQLLDn/Azy8q/BVksoqIR+xGsYGMYNhK27ZTTaBG11lMYPRqclkOTt+hqhNQzBMfvpSynJ6uhVxOv2WeQXprioRo2YRzPIpBUjf4y4KFa3CZlnFf4PxBFVF3aArjMFwwLURLqMJAAF5ekZEhx+y1enbfCxPJB6+vDuo25YtcnYbppc3tAZ/BBgBDPXsIbeRl3AJdBKSrN2b94S+D9BI7HKGuymvJNbScmcu94HJlLvFsenwr1Q/6p79IHt/a0RyT1aCCQrsaVb/2ry5keLLZE3HvHKqsahj72uZ+CtZNnTFHCuiZWQ==
X-OriginatorOrg: tw.synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dc45ee9-629f-4d05-1355-08d8602fe3f1
X-MS-Exchange-CrossTenant-AuthSource: SN6PR03MB3952.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2020 02:16:47.9107
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J9Aizy65425w9qr/xgXqa4FWiHXr4NBCCv0Ft8LoUTd0eTS0zLbws3QMpfHvGO8lS6vA1DApcBMTAI+jTfmUag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR03MB5562
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 9/24/20 4:42 AM, Dmitry Torokhov wrote:
> CAUTION: Email originated externally, do not click links or open attachments unless you recognize the sender and know the content is safe.
>
>
> On Tue, Sep 22, 2020 at 10:24:03PM +0200, Pavel Machek wrote:
>> On Tue 2020-09-22 18:16:42, Greg Kroah-Hartman wrote:
>>> On Tue, Sep 22, 2020 at 05:39:57PM +0200, Pavel Machek wrote:
>>>> Hi!
>>>>
>>>>> From: Vincent Huang <vincent.huang@tw.synaptics.com>
>>>>>
>>>>> commit 6c77545af100a72bf5e28142b510ba042a17648d upstream.
>>>>>
>>>>> Add trackpoint variant IDs to allow supported control on Synaptics
>>>>> trackpoints.
>>>> This just adds unused definitions. I don't think it is needed in
>>>> stable.
>>> It add support for a new device.
>> No, it does not. Maybe in mainline there's followup patch that adds
>> such support, but that's not in 4.19.
> es, indeed, there is a chunk missing, so this patch is incomplete. It
> will not cause any issues if applied, so I'll leave it to Greg to decide
> what to do with this.
>
> Vincent, there needs to be a change in trackpoint_start_protocol() to
> mark these new IDs as valid. Was it s3ent in a separate patch and I
> missed it?

Hi Dmitry:

You are right, I think the code is missing in start_protocol(), I'll 
send one patch to complete it.


Thanks

Vincent

>
> Thanks.
>
> --
> Dmitry
