Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7942165A606
	for <lists+stable@lfdr.de>; Sat, 31 Dec 2022 19:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbiLaSWD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Dec 2022 13:22:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiLaSWC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Dec 2022 13:22:02 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2054.outbound.protection.outlook.com [40.107.21.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 750FBE9E;
        Sat, 31 Dec 2022 10:22:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GRlBJgCGwmK/H5GaRizGus+msZPZPvZH16uXKufUhH4z7t7px9A3AYUqoOdaVEEFBZlqxA0EZZq2cy6BwM7HI09NonGy4K0oar17nacIRM7dH/f76/P0Wpej/A7o8cOJ2dh+borU7j3rXq30DcrxoYUw1n+ai+gvw9qBoZsnr60apOHUuxVa0RN8mzDONJtJvEyuKSTLdve39nbgI6/FZRe1tPc/uqJ6jRIuz7IYIUrzRmPEFalkWTBNWb1qAoI2fq+WYrvOVcNiQdtRiDRD5+fINkt4aFm4vuG/kIkp5bhU47C91IPFD20xDRzEaTVf3QXPPJT0+XfU9CwJ5AgSbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6rRo+JQrGoK3uIZWzz2g+ubJhgB67RQeEJz9XWmZTns=;
 b=LjyXUfySPDVs41rdz1r3xtp9XZw3Wxd4A9eejCKXkxQm+SCBlHCx+PtY1/R3j5Yo2f5wYAzCoLWPn+/4S9ac4noaBeiAtXpo/52d+tP9VBhb6GhMngcIiwWwWOJQ0lJrohzop44BM9V2YACH8JSee7UiZSEzweA12FraKUaqtIhhg3n4VdAVXWL1lQzdRGnBO+yGFXeyuXj4RoOikvvfDGTWcc0ETsXX7aPzvom6TYGzeWhnSoApyllB9yUAtQPAn9S0hx+nluRqKKMuONFeK4y5aIvqHDnTLcQW1MIGzBz+fquWoTOrpNduA86E+7PMnNInsSqms8wuD7YE2C2JMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6rRo+JQrGoK3uIZWzz2g+ubJhgB67RQeEJz9XWmZTns=;
 b=zWYF4VzCJ8drogXbAaHugWuM/LVCa1XyZDYMxEDLJF+FMycZyQnnE2RTQ5LR3BWwFgHddWwobQ1RSN1kM9An5jameLhP2Fkm60AMX4LTgJq9LAPykxLr1xUvDyRnL8Lq1UxuuctR9/OF+ZmGS28axkA28schxzxU6NWgu5eW1k7Qx9Imv8qysbJ+z6xBXM+0Mo4WJPsK9zAvrJHbxnVnEC5JNbdio2gRpRmVYZrql4Rtsi8ZffcOFLfAZH1iLhnUMA1sH3OydkY2D1jEwHufRpbp0O1eugRAaD90h8FjzSs9wM60VdSD7QGct5V5+1r2N19yVBD+DpYmYct7Zsh8yw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR04MB7104.eurprd04.prod.outlook.com (2603:10a6:800:126::9)
 by PAXPR04MB8224.eurprd04.prod.outlook.com (2603:10a6:102:1cb::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.18; Sat, 31 Dec
 2022 18:21:59 +0000
Received: from VI1PR04MB7104.eurprd04.prod.outlook.com
 ([fe80::8d51:14ac:adfd:2d9b]) by VI1PR04MB7104.eurprd04.prod.outlook.com
 ([fe80::8d51:14ac:adfd:2d9b%7]) with mapi id 15.20.5944.018; Sat, 31 Dec 2022
 18:21:58 +0000
Message-ID: <4a9bf157-af42-8247-8b66-0c66e425f9af@suse.com>
Date:   Sat, 31 Dec 2022 19:21:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] usb: storage: de-quirk Seagate Expansion Portable Drive
 SRD00F1 [0bc2:2320]
To:     =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <zenczykowski@gmail.com>,
        =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>
Cc:     Linux USB Mailing List <linux-usb@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20221230215942.3241955-1-zenczykowski@gmail.com>
Content-Language: en-US
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <20221230215942.3241955-1-zenczykowski@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0029.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::16) To VI1PR04MB7104.eurprd04.prod.outlook.com
 (2603:10a6:800:126::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB7104:EE_|PAXPR04MB8224:EE_
X-MS-Office365-Filtering-Correlation-Id: 4adf710d-80cb-43ee-6844-08daeb5be758
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CTwbc8VLs7t9JUkCh4PvRV+keVcdI3cJ04cxR15gfkdRzmqUBqzszMHwTCZjgtqICAMpNmamSsYflDZd+frrg7Xetz7suLG/u9xyBXG4IjxWs+6PjMM7PRau0v3uiBpzlRJ0Q4rHOJVZ+kJ+STb96rgYxIz8ADBBnlJ8jgQJdHo8Q98FE/JI1Tb/t/E2wGhc/7QuUIHwyp4b9K4q8kR7YQgU0HjeivtjsxIvoqp744AJQhNXFBl3Bpjd04X6CqU14WikeRErWXwpexgG9+ffnuPEHzSz/HVaVqs2k73c8SyZl1B0ehD9/iYylXuoLp3K3G9BdtnfmzvJ7PmIm4fqRGJpfy7tpIpQbDDWGNJdfklzX/tql5ScVnL1WzjqsHIQjI4TegWI6BbK+RnuSGcyyBxirkp2MMwZGElR9ihvi1AGpA7kyXjD+jm4x90JjTySiIpvmRxjgb0k5Bn5xlDHULHqLzVrlvxFKpzMKfZvUlqQQa5tlWkYJjeeeLa65S0h04odnqzupxtL1RSXa/pAnWwEqK1IKuoA+4rSGuMtGKh01dZwZiDILVUCLe3Bv55pDT5SBdxQZRna2RREz7B2JTHSN4y1cEoMyj8pQrOzIXC6s/43LJ2qeRWR+I/2r/RV/57+iQnC/ZyQCjAm18Ve6Cm2i39Aw36R9l45cXfofoNxbJYJOtS9GyiJwDFNaNMrIrUT3l7qjGqPck6Ufx2WDQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB7104.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(396003)(366004)(136003)(39860400002)(451199015)(5660300002)(2906002)(4744005)(4326008)(8676002)(8936002)(31686004)(41300700001)(66476007)(478600001)(66556008)(316002)(66946007)(110136005)(54906003)(6486002)(2616005)(53546011)(186003)(6512007)(6506007)(83380400001)(38100700002)(31696002)(86362001)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L3dIY0kydjBQL01iaUYwN3k1djl2TStuUzdrZkRnS2pnRlF2ZWl1cDRnUlN2?=
 =?utf-8?B?ekVJRnhkUXFWRlhrdDhDYWJlY1dXR2ZlcFVWajJaT2lKM2wzT2xFTkhPWUhS?=
 =?utf-8?B?WlFJL2hDVU9VZ2ptRURaeExQYkNaa1dheFU2eDhrYzhxeCs1V0hIZmdxOHp2?=
 =?utf-8?B?QnYzYy9EV1FzbGpsYVJ1UmFUWW1iOVpvc0t5dUQ3TEUxUFg4Lzl4cEkzR3k5?=
 =?utf-8?B?cEhSM0NqRTlIYko2MzkzT2xrTmVMVWt3RkZuUFM3ZnFscWppd3JkTTk1MSsv?=
 =?utf-8?B?a0gxWGRBWjUxSDRJRFNibzZhQW1EQ0krWFUyYXhxeEZnZ1JqRVpaWjg4cjIv?=
 =?utf-8?B?eUZxUHZHbDMxRzlHT1YzOVY5MlFVZ0tGdUhySWZFZmErRGdsZDJoUGczWHgx?=
 =?utf-8?B?TGZLNTgzTDJyNFBFUGlpc1pmQnBMckZsbGd1dzV5RTZPcmlMQWxFQktOZ3J0?=
 =?utf-8?B?ZXRob0JkcTVzanpCTldPTTNUYW14THdNTE5vRXFVR09lakowOWlmNmtKY1Bs?=
 =?utf-8?B?eDdHOWlJeFdyOWhmTkU1RTVlMUprYzgwODlPaDh0TjNndHZOUjRYUEJmekIy?=
 =?utf-8?B?Y0tJZnNhSG84d3UwaWZSWjIyaFpURHNRbzNIVTh4SEdqU1M4RVU4a2p1N1dz?=
 =?utf-8?B?aTRGS0N3SFhsSDdNdTAxd2hmWHpKc1huZ1BhcTFBYTcvUXREbDAvUm9JdGVC?=
 =?utf-8?B?cm1kZzh3d1lNaVJpaWp2d1E0YVRnTFNzbENvTyt2M2QxMktEUW1YZitRQlFV?=
 =?utf-8?B?NE51T20zeFVjempsYXNYOEoybWRnMTlVUEY0ZnY4dVhJUFRYdFZvMDhpVzhC?=
 =?utf-8?B?MUpFK0NsQlpCRGlqM1pWZm83dTRDM1NYams5bWl5b1dSZTJHYWRUY0pRMURH?=
 =?utf-8?B?QUI2WVFsWXhkbXNENm91cVpDNSs5dVh1NmZSWVBDc0Fjckt0YlR5UUVacGFW?=
 =?utf-8?B?Vi9zbU1VSnJEZDFPNjRuTlJpRUZnckhoTTRYQzB1T3R4L1lPZDEwaUViVDJJ?=
 =?utf-8?B?a3cwSkRMNjJZb0pJNDFnbWVUd1pVakpBYkdyNDE3NjExQWR6TzczMWg4dCsz?=
 =?utf-8?B?TkZBckJOLzg2RTdiZkhmUElNRkZUc3FWbnF0RzB0Sm01MjVPekpycHhUZkFx?=
 =?utf-8?B?Mkh4aG0zem51NVp6UVhLc1F4NmlXNDc5eVhMRzZQcDZKc0lEVXplTlA2TW5y?=
 =?utf-8?B?QW9GMlhMK1BhZ0VpZ0FnMGRZM3grdFdjbFlhdUEyMHpxTndnZkVWMDgzWU10?=
 =?utf-8?B?d3p6MG5BYWlrTFpFeVZQNTdNOU50YTAzeUJiOVp3NEVhVTNkUVZKTUlFcitV?=
 =?utf-8?B?dVVIanVQQzhHSWNwT3lOaXVFMDBuQ0tzdzR1Y245WUozYnpML2RyUCt0Q3No?=
 =?utf-8?B?dDl3SmlrUENEQlI2cThaaE9nRXhFcURWVE1NWU5VR3BiOUFISWVQQjdMWmJC?=
 =?utf-8?B?OWozV2JyRnhua3pFL0JTYmlESkhQYmorMmVCNE52SXMxa1pHdGY3Mjk3cnFv?=
 =?utf-8?B?TjdmeVZ4V1ZBdzJOUy9kenJCRHZ3RllpRy84U1pZdFNvY1M0M1o4eVQwM1Zw?=
 =?utf-8?B?S1BRc1k4UzVRYkZBcnlBTEVCRlEzOENkTVlLc2xDSy82cGl6MjVtK3VhZDUr?=
 =?utf-8?B?UitIVUZtK1huS1B1dG5nTjJEcFpIMFVzSnQ0aDNkZm8vVUdGWm5CbTlBQXY2?=
 =?utf-8?B?SUk4YnUrekZYQ3REZGhBUzJERGo1SG1ZU0RLaDgzOTVxNUJ6WHRrZzFhRXpu?=
 =?utf-8?B?WFNkcE14OVh0aklFN0RsYW5JZUtFUkxmRFhJTG1TK0QwcFgrVnQ4c2szQm1F?=
 =?utf-8?B?SU9RN0tJT0RGV1RqOHUydmQxU3hjMWRYRnJnQTg4ZHUrUDQvMVFFNXEwTjJo?=
 =?utf-8?B?OHN4RjlXWlRoRmRRV1pEQ3ZMdU9vWG85dU9JWm5zaW1BSUFDNmdmM0JXVkQx?=
 =?utf-8?B?K05RYzhFTXIrYTN6dzZ2ejJtdk5UMTFYQU9Ob0N6MEk0b1llYmxTcS9Kd0Y1?=
 =?utf-8?B?UFY2anp0UVY0QmF6dG9EL0FCdzlFYUxML0xnZTJJb3YzWktvRWt0bUVtMVdK?=
 =?utf-8?B?cnpqZmY5ZDUyNmlTM3RPV1pDa2dzUXU1M2tUNjRwRnF0YTRzM2FoN2IyOTJ2?=
 =?utf-8?B?K0U1R1NSNWFEbkRQM2VCeHdpY1hER0hHcGN6VWVmU0NiK0dxMVB3SE16cU1y?=
 =?utf-8?Q?q4Pd8Q4wkDbf+KpciYjFDjN/0wQlHZOeThcm9W5H5zz8?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4adf710d-80cb-43ee-6844-08daeb5be758
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB7104.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Dec 2022 18:21:58.5665
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qLClrkOf/cK2QKplawhL0aCQbFKkBnTmf6bDkb7YTdPCPnItf1ZyCa28gT/pNLJ9Slt+9+aEtJrMKM5ukhhYPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8224
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 30.12.22 22:59, Maciej Żenczykowski wrote:

> -	/* All Seagate disk enclosures have broken ATA pass-through support */
> -	if (le16_to_cpu(udev->descriptor.idVendor) == 0x0bc2)
> +	/* Most Seagate disk enclosures have broken ATA pass-through support */
> +	if (le16_to_cpu(udev->descriptor.idVendor) == 0x0bc2 &&
> +	    le16_to_cpu(udev->descriptor.idProduct) != 0x2320)
>   		flags |= US_FL_NO_ATA_1X;
>   
>   	usb_stor_adjust_quirks(udev, &flags);


Hi,

I am sorry, but no. We cannot accomodate a list of of devices to be
dequirked that is sure to grow in the future. Please define a flag for
these devices.

	Regards
		Oliver
