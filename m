Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 594F93D0DDC
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 13:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238463AbhGUKxy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 06:53:54 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:41576 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239851AbhGUK0L (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Jul 2021 06:26:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1626865605;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s3fScAKpV6YDStRyxZAfKbYlzvFG/elfA0hJZlTaXSc=;
        b=iHbly+OLjXD162jYMGOom5Ix9uMCyzyWqrMA3Ra5GU6cpWMtPdKfWcRQ150cmJW2jZ5Jba
        EMypo8MgKJpWWt0Yejd4wVNOsSux7q5/f36d3hxyhEbnRMZJ944VpZRLfNoTzAnFXw+Ov4
        maQHgjvEYd6Sm8LTqzGY5oNHk4VAvjQ=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2173.outbound.protection.outlook.com [104.47.17.173])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-14-g5Q9l3QDO92ws4dKl0mXwQ-1; Wed, 21 Jul 2021 13:06:44 +0200
X-MC-Unique: g5Q9l3QDO92ws4dKl0mXwQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eAGZxsuH6/613mUyma39FWl5EIj5bskj0eh6/NdwgHbasodxb1Oo+svW9L6GrJO73TWPs24J3OylOwTnChWM2qCAJ8LpFDOOabJrHWMeVvnG6WbRBZrQW4U3fejnsVnmVmx+1S/RvllfeHd2v6dnU2JfoWrauQdQjSazmk4VP/kERMLOR5nZAL0a5WEQi8RGJrjlfcEcA7CF5wtKZdlihN4NKsIEknu0p2xbQPZ0WabbyKRBjlS8xFCV6pNrvFItpbs5pLwrFDkdXW+rFQJfUlqja7FW0rm8DWwER8RHLfeYr0ignfSjwVe1+rdOvYHIHtGeKnMHbzxhgBAYX/atsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s3fScAKpV6YDStRyxZAfKbYlzvFG/elfA0hJZlTaXSc=;
 b=JX/N8WsgrzV4gOh/sNnOsdPBboQA4cyPzMx6wn8R6frdWcv7VXPTKoLEGLx5GN1/6Xh3Yv4BxQsjHAOBZ+ZLdrYzsBGk0mdn5NVp4l8YmUahaQJhhptnjnra4ICwisGXncOwVI7uktNWoTz16RgzdEuqDib/GUXhPMpcLFDj1Q/FASClzkPq/ENWjBD9RIHZRsWE01tY2RTc8TrkyChNk0cMDgKiK4g6X83JFiEeIxt/ZbCRUiiQrtsjU3Lu13cP/kq2nKbznLXpq5oWALGRZMhuEEGoCgb/pZredP4wqUNHAATxv0zywim4/P9+2CoOCBkNKhfy+g/Wug/eMVsfOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com (2603:10a6:10:22::23)
 by DBBPR04MB7644.eurprd04.prod.outlook.com (2603:10a6:10:20c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.24; Wed, 21 Jul
 2021 11:06:43 +0000
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::4cc0:191d:5c04:8ede]) by DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::4cc0:191d:5c04:8ede%7]) with mapi id 15.20.4331.034; Wed, 21 Jul 2021
 11:06:43 +0000
Subject: Re: [PATCH] Add LaCie Rugged USB3-FW to IGNORE_UAS
To:     Julian Sikorski <belegdol@gmail.com>, linux-usb@vger.kernel.org
Cc:     stable@vger.kernel.org, Julian Sikorski <belegdol+github@gmail.com>
References: <20210720171910.36497-1-belegdol+github@gmail.com>
From:   Oliver Neukum <oneukum@suse.com>
Message-ID: <e3741d60-d058-f730-e14a-bfe6d02023df@suse.com>
Date:   Wed, 21 Jul 2021 13:06:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210720171910.36497-1-belegdol+github@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: PR0P264CA0139.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1a::31) To DB7PR04MB5050.eurprd04.prod.outlook.com
 (2603:10a6:10:22::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (2001:a61:3b82:3e01:c3c9:c93b:1b8e:a220) by PR0P264CA0139.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1a::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24 via Frontend Transport; Wed, 21 Jul 2021 11:06:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8faa22d5-4450-44ba-eadc-08d94c379f60
X-MS-TrafficTypeDiagnostic: DBBPR04MB7644:
X-Microsoft-Antispam-PRVS: <DBBPR04MB764482C8EC5DF69BD5451EB5C7E39@DBBPR04MB7644.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:595;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WXcqbotUxgYCXFOdM59eTxbnQ4Eq5sguCzPtoE+6QszooGMWq4Ey5C5tJoPLA4tbhSJrndWoXS/Lg5Yfj1jbSnX7i4dB0NfFZCt9SePjN2hKpPGTnG7M5XiDRDo0o0AIL9QkZ3g5CoruUh0gZgeAUceA5apZUGmfZS/zktwdIzw70ipP9nDBoSfWBgadbnxWjsa/qeyWy7A9MoNAqW4Aih4zYqPuSypcER9PXiNqpQ8VE4446AEZQ9ULXLDgbJVyP6UpLEUe3T6PBCVcoG7OaU8WHYXpvAnO2HCKosZ2CA/mf0O45QYjBjs1qbopXhDCYp6uOj78vCQlVYkp7lplSWVI4Y6nN12T51ZZb/C8seoi2EqUjQzmo6u1HTKTkubSHKEfLBvB8Cl1T9jkpmTHuFF+B44X2K8P/i2fZULyN2HpvT/0oazKt94T4F/6XwUTIFRXL87xRmBo7tD2S3ZZWGe5dF2ODnPNpZCW5jKAbkRUAUM6/ECPdw5GzqiZvIKgCFGcA33IepCcJUGqQYtI9jFtVjl+n7/dT9AZePyVB8RKD/KqQNDzj8Z4m4K+2S/6CYUnSA73ydqKKqBw7UgJBLtE3u16ZNVK3y9WvpJ+y8Yx5doQlPNvIyWf2wWlaS1nMSB0vyLYf1yTI/Q6oYVjbDKKHy4Jk17pJI/U4DMqx72dA9cpSXH6NurA9PaBBXI6sewM2nxMbkVYvOexAi14wSPNhrEpCOStAiK3OGwGke4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5050.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(6029001)(366004)(36756003)(316002)(38100700002)(8936002)(2906002)(6512007)(6486002)(53546011)(86362001)(66946007)(5660300002)(6506007)(186003)(66476007)(2616005)(31696002)(31686004)(4326008)(8676002)(66556008)(4744005)(508600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MjgrdmNaWVBpQ3hsbk1PRkRIa2lvV2lhZGNDenhUeFQyc2ZNMXQ1Um8rR0hu?=
 =?utf-8?B?U0RyWSszMTlrZklxbk1xbUpKWFdjM3ViczQycmUvVkNDYnZ5MTdzdmY2WU1K?=
 =?utf-8?B?V0dqMHcwZ1BFa253ZytBYVlzYWtmZjFiRVBBYmdjUXUwY3lTOVJMdURudDUz?=
 =?utf-8?B?aEhNREJZRTkxa2FiRS94cXhraVkrNnlyUVdxeklOSk9nUUd1RXlld3pDdDht?=
 =?utf-8?B?K0NiUUZjYUcrZGVtY1oyU3JxMXJKa0E1clQzSlF0VVl0aWhCM2VWZ1dFcGFt?=
 =?utf-8?B?OHNzRWdNMDkvdS9EU2IxZW1Bd21heVp3NGVLZXRnenlOYWhiZm5CbEdkRUhD?=
 =?utf-8?B?R2tNZjRsUi9tWnVCNmN3WTN6bjhvLy8xak9ZUDZ3WUpjeVFHVmQ0Y28yMlpO?=
 =?utf-8?B?RUdRVktHcGR2VE1xU2NSZ1l2LzhOdkFValZXVTAxVE1oNG8rZUNUemI0dFJO?=
 =?utf-8?B?d24yODFYYit4b0pnYldINXZzYTlZWjlCZG5xeVpDM3cxbGFaMWNGOEtFY2Zy?=
 =?utf-8?B?dzNZMEd5NGI4Q0hRcTFjb3FDbnJwaXhyRHBGWmExd0w2Smh5SXZnM1Fta050?=
 =?utf-8?B?aU1aRDUyaEd0NXRhRkJ6Tm14OUpZR3lRMGZ0emhpRzQ3MnBSRkRMNDNPRkNN?=
 =?utf-8?B?NXJSbU53SFl2bVhKdXI5MjJNVG0rRkFtRnp5eWZWNGpHcWhLa2x2U2dWQzZM?=
 =?utf-8?B?cFJRL0QyYXpmZ3B5b3NhQ3dPak5RQXV5dVlqYnltUHV0bzZnN2Zia0tod2tM?=
 =?utf-8?B?aUs3cm11V1M0dTN0SWhNRFBwR05Rb3ZhR0oxdDlzaTNMRlZmeEFoSk4vdXln?=
 =?utf-8?B?bjZXcnNxa1h4RkJZN2dvdjBMa2JNVVhQU1R3aDlGZDJ5VGc5YWxqWTBETHNn?=
 =?utf-8?B?VEJWZGN6bEFUd0ovOXY5QXMzTnorQktxV2trS2xwbHdrazJ6bGVMVzNlMklz?=
 =?utf-8?B?SHQ0MVdPanhyb1RrenBWYUNqKzdCMlQ2dld5emtmRzdDYkgzZUVQZHJVbU9o?=
 =?utf-8?B?RExleXBqTi9xc3lXcWVZcEp6Y05kVzZaU0lMOUI5aHc3MUlVTGhRakpGZHlT?=
 =?utf-8?B?SVFYRUZ4Z0ZocDQvQ0xyd3lEOXE5aEZFOGcvSmJpcXE2V09yVXpIdEFtSS9B?=
 =?utf-8?B?a0JkajBuR1VXZlFkQTNsb0wrbDBIbkpOM21xMTFOb2pBM2p0WUNPc3MyV1hv?=
 =?utf-8?B?ekJhbGR3NlBGM2tEQVNsNDNWQjh3MzBaRXlXN1FCbWhZTjVZL2c2QWUvYWVX?=
 =?utf-8?B?QmFsYkxsOEd1eUFWOVpycTc5QTEzSXkxTFNUaHVWTlJ0MEZuR3dGVHZrN2ZH?=
 =?utf-8?B?TjIxUld4MDQvWHlicE9IV0hQN3JCTFpJdkZZYkI3Z0h0bzFPZzNUbVpLbFQ0?=
 =?utf-8?B?VGlFQWlSVmVkYlJsOEozR0o5QXhiaCtFNDUwT3FMa0ZydmFJWXNKMDQ2MzVS?=
 =?utf-8?B?LzN1eWprVzMrTFZ0UCt4ZEk1L1JTdHN5clVXSVFtcGxiN3BFd3FwYTVBTmdO?=
 =?utf-8?B?TUZKT1lPR0xNaklqVy9OK09CK3JLQUVET3dQYmsxRnM2NXZ5NSszWlpWRlRJ?=
 =?utf-8?B?NmtCbEo2elphV0pKWXJvWmFRVDhURHh4QmJ0YXM3U05pK1JiQmJwZ1dSL0I3?=
 =?utf-8?B?SDlNZWpock41S05pVU80NjdGaW9QcW9jd0lkWVVya1lubnY1aUdSdmgxNFpy?=
 =?utf-8?B?dG9kc0Y3VzhZWUkyaHk5R1NreEJrckVtUHRKVlNiRTlScDNtY0lTbHo3WlVq?=
 =?utf-8?B?ZlVBZnVCQTN2dnpoMjlQZ2hMcEpjK3ljWEd3Tkdxd3lpRjlGWitoVHVjc2ZX?=
 =?utf-8?B?RXA2ODZYdzJvaE1GdWJXQmRFVGRhaWc3ZDlHQkg3OUk5NjhGUDBaOGNIRUZ3?=
 =?utf-8?Q?A/U9mNtKK23+R?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8faa22d5-4450-44ba-eadc-08d94c379f60
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5050.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2021 11:06:43.2495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zT6cB+sd+7B9GVPSsH+O4uo71DVzpToDkFv8TmcG1dpd93CzRg3kyoOlCfeZ1BLXKHR2obLC0qGAYbue5CuSZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7644
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 20.07.21 19:19, Julian Sikorski wrote:
> LaCie Rugged USB3-FW appears to be incompatible with UAS. It generates
> errors like:
> [ 1151.582598] sd 14:0:0:0: tag#16 uas_eh_abort_handler 0 uas-tag 1 inflight: IN
> [ 1151.582602] sd 14:0:0:0: tag#16 CDB: Report supported operation codes a3 0c 01 12 00 00 00 00 02 00 00 00
> [ 1151.588594] scsi host14: uas_eh_device_reset_handler start
> [ 1151.710482] usb 2-4: reset SuperSpeed Gen 1 USB device number 2 using xhci_hcd
> [ 1151.741398] scsi host14: uas_eh_device_reset_handler success
> [ 1181.785534] scsi host14: uas_eh_device_reset_handler start
>
> Signed-off-by: Julian Sikorski <belegdol+github@gmail.com>
Acked-by: Oliver Neukum <oneukum@suse.com>

