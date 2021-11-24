Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B35145B566
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 08:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241095AbhKXHgQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 02:36:16 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:24855 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240800AbhKXHgP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 02:36:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1637739185;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/gta5DZArVhcL3E/yTesEapUc4qE/6mmL65q1KJqu70=;
        b=VejlyyXkbkWsCJP/DQBQWSwpC6mfjqBdNSXtJF0fKwLKOVWUTdDsk831nPHKkQc0X/gx6E
        yP8F8MgqEN8W5wAmugKMAY6dz1qZWuPnHW10GGIhPeUjW4gHuq/WK0uptkHPfjucObfekw
        NN67tqGgbGrpwVj7x/lh/Jaq9rypPPg=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2174.outbound.protection.outlook.com [104.47.17.174]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-28-IaJaG3v5PQKWOXMM8w21Xg-1; Wed, 24 Nov 2021 08:33:04 +0100
X-MC-Unique: IaJaG3v5PQKWOXMM8w21Xg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e+HOdRowXh8cUc7s1MCcXI+TKCfMpEXVAIfaN2ty60BNS+Vpn/jkHvuONRFhU14KHEOBH+b+5Aru8xo3AW3Q8qJEnXXrCJF52xR6AswObucOumrwa8XC5l3BCfD5cQJo30ommwcXMQwQAP2v8Vrwdvlcpz/V6TwjbwKwjoNgNqm6VG5B/sAHAouwqjX1Y3kVIFcoMJ57O0UEOog7aUniorXXMgV5Q4YK7qAqAmqt7qmdSAuU2+gNSOuCQPjcT+j0H/Szo7KoNGp79ZvgQNJEScgp8Z8z752yyqibBabJZZg++r5yoKMCukA5vmF6/TZOp9sZjo9ExNDLxFfKPDwiRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/gta5DZArVhcL3E/yTesEapUc4qE/6mmL65q1KJqu70=;
 b=inp+SiGAEqjvD32SCxJsQDh6z1ADOwmeFvcr6aSaP76iJJPI1/hK+tUlu/5uKUCdEpcxV0Uc3EvaGZauStQKScp2IU3/yL7cfe7t3VDXXE5J9+gZF89rm+bF5pMVneVg508vyoyHlTtUndcFgM71dgjDMlzYokZtViqf4A6AF7rlj5tkO3odJXA4KxkEwH92yDFUOtuOi/gaelKxktZ/YLdY/cQY1eoGiRxQ4LfQjK5GqmQ3jWcCCL2m+s0DOPvPC9EIAJe6IRb+3W4eiH0nV9XXJBsYXuk3PbNjsQ/Pw1qJkgx1T2zMHLbj4Hgm4LQHEBiR512Pc862eAEo/F9rgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR04MB5600.eurprd04.prod.outlook.com (2603:10a6:803:e7::16)
 by VI1PR04MB7038.eurprd04.prod.outlook.com (2603:10a6:800:12d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Wed, 24 Nov
 2021 07:33:02 +0000
Received: from VI1PR04MB5600.eurprd04.prod.outlook.com
 ([fe80::8062:d7cb:ca45:1898]) by VI1PR04MB5600.eurprd04.prod.outlook.com
 ([fe80::8062:d7cb:ca45:1898%3]) with mapi id 15.20.4713.026; Wed, 24 Nov 2021
 07:33:02 +0000
Message-ID: <9d2b7ee7-4498-da49-bd74-5da0dc38d1de@suse.com>
Date:   Wed, 24 Nov 2021 08:33:00 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v4] xen: detect uninitialized xenbus in xenbus_init
Content-Language: en-US
To:     Stefano Stabellini <sstabellini@kernel.org>
Cc:     boris.ostrovsky@oracle.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@xilinx.com>,
        stable@vger.kernel.org, jgross@suse.com
References: <20211123210748.1910236-1-sstabellini@kernel.org>
From:   Jan Beulich <jbeulich@suse.com>
In-Reply-To: <20211123210748.1910236-1-sstabellini@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6PR10CA0015.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:209:89::28) To VI1PR04MB5600.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::16)
MIME-Version: 1.0
Received: from [10.156.60.236] (37.24.206.209) by AM6PR10CA0015.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:89::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.19 via Frontend Transport; Wed, 24 Nov 2021 07:33:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7168824-a29d-49fc-727b-08d9af1ca568
X-MS-TrafficTypeDiagnostic: VI1PR04MB7038:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-Microsoft-Antispam-PRVS: <VI1PR04MB703840C5017CBE7C6DD4D012B3619@VI1PR04MB7038.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rvuohZJVzOuN+2+WaJctRyTpKbzmFLzoSQyRu2fRZg2i4HpyYg+xTBOfyZkah+tg3+9Kal0xCfdgMcxwqsnFN/Tfv+bkewIRw47SLT5n+MfEigjuiHHehkx0RFF6x94IhuIWcaYRVJH/BUy5rKdUFigGamUmiCX80h0RTWQSTR+og+rj9xuQUx+D1fGV4RjI3sYJloIbhaUBfLQAwp3eE/nEuOHYaRKlnoveD3QnZ+tc6Ux+oXTzl4v0ziwMHKNLk7gQXiFpr7V8ctVtb9tWL1wxCR4sZczN4s59w5tsIp/RIRcFm9xudwZqPSsEu0QdTVlrWwpjHrlTsCeAR95ipWfoDRNq4/EGMf/BQEIZmBhRYqarRyanQ+JywaDRBJxumdI5iqiY8Dh0fzGCR3n/QHBw5cLNij/UF4Pw7ZItQAAKOKK4JvlJ3oiX8FDa47Lij+41s/6TqtblFfo6nZDc8SFrtIGCc+lOnk8nJltqsmpR3L7ABn3AqHBcQKURkZO7DyzQfeg9AyJrb6kHBRQwUhmO8RULdrs6CFph2CDVHp7QNXcrS/sJ84yBXv5udMV4SF6NbI6wmHprkD/OHhh5K/pUfLzpamjej9cOujQWcQPKehT1Pi+8WeLw3mkheLnsXtA/VlQ5dg6y0FT0DadCVRDkMVODUqH4iCM1EVW7bFAHgs9jh8G0lZnSB6dgHME8aBVfMgFfWkyc4x69O2tXSnrEoNaGJHpNOHUpteOfXoE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5600.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2906002)(2616005)(86362001)(6486002)(956004)(508600001)(8676002)(53546011)(26005)(8936002)(4326008)(31686004)(316002)(6916009)(36756003)(16576012)(186003)(107886003)(38100700002)(5660300002)(4744005)(31696002)(66556008)(66946007)(66476007)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S1ZxSTJSWDhOTFhPNy8wUm1LdkttYmVtUXYyVmlqR1IrcVBsVDE4azRVeFdU?=
 =?utf-8?B?UjdqdWU0ZGxxV0k4VDQ2TzgvV1k1L3BMNlJ3UG16UTBkemhlUW9keUVFK0J6?=
 =?utf-8?B?NHd5SXZwdFhnTVVKdWgyK1laVHJ6MW9yZ0gzbU1VVzFjbDZzT3IrUlFZOGk0?=
 =?utf-8?B?WkJMVXBpWWQrL0ZTS09VWERkL3QzNDNPS2cvazU0WGxLd3kwaFRLTGQ0SWNp?=
 =?utf-8?B?S041RWxwOUw2QzA2TFZXZ1NCcW9oVy9GTHZkZHV5bjJ4YzZyRk9YTFFGYk9S?=
 =?utf-8?B?VlpVQmREcjBYT3NPenV4TmQ1Yi9ROEk5ejMxYXgwUGtYOHhmeTNONEdPeTFP?=
 =?utf-8?B?WEd2cEE2cFpXZVp1WUI5NXk1QnB0RXFMUDM3MWRDR3FBWjZEZStSclYzbm5z?=
 =?utf-8?B?aFlpS0NPWkVrYWNZVjNJUDJqTC94ak9wYzQvdHFkZFdiM2tqUThzL2ZnMkFx?=
 =?utf-8?B?RitqNjQ1YlFHWnF5VGtxalFMTkFuM2pIeXUyaFFleHdUZW5xQklQby9yU3RB?=
 =?utf-8?B?SE0zcmtJaXI2UVNVRHp1eGEvOEZPUWJmRHhpRUVYSmgxTUZBQ1IyZTBQUWpG?=
 =?utf-8?B?UitIdTU3RGJ2bGk0ZHNZYzVNdDlWdThXcFhoYW9rbkFTQzI4MXRVaktEZldU?=
 =?utf-8?B?TzNhTGw4Y2E1U0pPMkdEYTgxelVGYlJVMkhqNmZraEJibjdwU1Q4M1VsOEcr?=
 =?utf-8?B?bkVQM0lqK0dLV2JPSHJuUERWUTBoVGZ3SDAySnJ5S0JoellFOWhsc2NWYVZq?=
 =?utf-8?B?RWdmdkJ3UVBpNnIyL0orU3NNTVJZcFVvMUtHZk92NlBVRTE2YjM2eWtDYW1M?=
 =?utf-8?B?WUlNa0VDTmFtQmpmTXlKaVhNNDlZaEhxV1RTUDJYWnNqZFdMQXFLZjJCZzd3?=
 =?utf-8?B?MUIwMnZpdXEyakRjOWRjcUFGUHdZZ25YNUI0WDdnTWRLeXowTGF5Y3oxRlJn?=
 =?utf-8?B?Q3BTN1VWNHZFSjdDMWE5amE1bm43V28zcXJwU2JKWkRSRFNiWXhKUzNhMU9O?=
 =?utf-8?B?RW44TUVQUmRmcVBsNDk5RDQ5ZFBzQktza0FIQkkyazYzZmhkZTFtNnBLV3Ns?=
 =?utf-8?B?NDc2R2xJMHhVQ0tSbTFtZUVWckxmaHo4SXIxVGFBR0N4a2xEVjZxNDQ0T0RV?=
 =?utf-8?B?bVg5Tk5PUkRqZWpQWWdlQ0hNbzFGZ0xVNFljZ0ROS1FGUDk2RnJ6UDgwTFJi?=
 =?utf-8?B?YnlCU3haTS82ak14aHNwZjlWcnVVYmxCLzExaWlVaWd0bDMyVmk4NmU5cXhu?=
 =?utf-8?B?MWI2ZDVmaWVaNlV2aDBKUXR1RHJXcnVqT0pIeTZFdXJsWHFGVDJGK3oyOXAv?=
 =?utf-8?B?WnBuODJkRHhIYUdWUHlqejY2RzlPeW8yQnBBOFZwT0NNSTYrSm5iam9HaUxa?=
 =?utf-8?B?bjY5YUQwQ0RWelhVVktRQVMxeWoyUHpvaG5keU4zNmZMSzhpTG5XZEhZY1JJ?=
 =?utf-8?B?UmVJQ0xmWHY4Y1Q2ZnNnK2lWeTNhUU5RUEFsVEZJRTVlVXhyZGZDZERmNm1X?=
 =?utf-8?B?UEN4Wk4xZmJtV2Ntb2h4Vis0cWptN3pKWWQralFYbm5ydStCMEFKbFMzKzJJ?=
 =?utf-8?B?c1N3VWMreXVYdHFvZnYwaEJEeURDeWVUZzlEclQzL3cvYWF1QS9ZVExJL2pI?=
 =?utf-8?B?VE5XeU04MVNDRmdCOFhMc2RaT0pPZmxlaU8vNHhITEpHM3NibGF2ZkZrTURr?=
 =?utf-8?B?ZFRLRHRoandOWjVuazZRdUpWSFNiYTFhQUpZYkVySmoreXhuaXFyQUtWQkF5?=
 =?utf-8?B?ZDFZcHdLcDNnTThzeGdCZG5CMlBRTkNIRmN5QnJsNUw0YmhmR3RvRm9KcHpT?=
 =?utf-8?B?amd6Kzd5RTR4TXg0WU5PVTgycnFrdFJET0FrRGdKODZkc1R1eFRmdjhWMHUx?=
 =?utf-8?B?RWg5U2lBSHB3USt1ZHNadU80VExDUTltRVNkYmtqNTY2ZDVoQml0RVpaTW13?=
 =?utf-8?B?TFdmZC9ySmYyWXBwY2I5RmMvNTY0YjFhaHo5U3dkbGNqbnpxdFlnVDByZnBu?=
 =?utf-8?B?OG1MVkpraEpldkdGWE5ma3FkSnROeE5EZ0locHVyR1A1dVhObitoSmFESmRI?=
 =?utf-8?B?NExtaVcxUFJqWVJvL3pnTXpnNXNCWjBQdDg1N25YSmR6RXJIRkZWRDQwUWxJ?=
 =?utf-8?B?UWVjSjJQREpRTkVpVmgwUFJ0NTNtdGVyZEgzTEpSZEs2THgvOGplQ3l3TXRJ?=
 =?utf-8?Q?039yiT6+ZWeeodVEWrwa5AQ=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7168824-a29d-49fc-727b-08d9af1ca568
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5600.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2021 07:33:01.9795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9KqD0pfn0oJuJR3EroIt6CLBVN7MVqBop63hZg1y/oU3C6HrAAnGu+2ijGsW3bf8TrfhEeCioDYPbYDKAOvrXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7038
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 23.11.2021 22:07, Stefano Stabellini wrote:
> From: Stefano Stabellini <stefano.stabellini@xilinx.com>
> 
> If the xenstore page hasn't been allocated properly, reading the value
> of the related hvm_param (HVM_PARAM_STORE_PFN) won't actually return
> error. Instead, it will succeed and return zero. Instead of attempting
> to xen_remap a bad guest physical address, detect this condition and
> return early.
> 
> Note that although a guest physical address of zero for
> HVM_PARAM_STORE_PFN is theoretically possible, it is not a good choice
> and zero has never been validly used in that capacity.
> 
> Also recognize all bits set as an invalid value.
> 
> For 32-bit Linux, any pfn above ULONG_MAX would get truncated. Pfns
> above ULONG_MAX should never be passed by the Xen tools to HVM guests
> anyway, so check for this condition and return early.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Stefano Stabellini <stefano.stabellini@xilinx.com>

Reviewed-by: Jan Beulich <jbeulich@suse.com>

