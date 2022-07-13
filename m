Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46F2E573998
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 17:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236751AbiGMPFM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 11:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235819AbiGMPFL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 11:05:11 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2082.outbound.protection.outlook.com [40.107.20.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 198D341D24;
        Wed, 13 Jul 2022 08:05:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TWrrf36zn+WGTDn2EtvRflW2F/L+FYKbmI0vdGTKofAhstqtnwLp/Y8gwXpgy2+t4jxBv2IGJXQMmB5gyjUDK1DMVZY/+V9e11XiYNi4OP7fK2SQzG9P5Y4MpVfQVuX4GJH7lcmcCHV2O212GU0xx7Iiyzwox08U7anrIBLO/sIgUbX315W/g+nF4UFCWlBvpasneFqB0LoDNF5NiKx61Bnz+7b8/myvoqVy5uxzal0DJj4t3E4LtMkP5NHza3az1trHL0G+zBQ82rNxFIkPcvWSQTL/5QFeJFNNu7MVvi7DtVeVvXYohtlF5m2AIcGs1CEeCZtov2boWdveqUTM8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n0XTmufvoscCX9eQghwm1iURatTZslRInzx94/0oYLM=;
 b=EK6hfz3P94Aw8pNzo0ab8v5rTJijwF3fhFXnsG0PhnhzvNP/b03wOcndbRKiuzP9ggIoGxWg2DTlJqwgB9qCDaSTCcUi+Prrz/NGvyET69ru+rJl4jLYJnKO7Oo5QmoVPcnRe9XG4IYs5R4NSisNF9MkM7M3fXp7gnqXyjg3jDJ+UMDmN6Kpr89/SRvne/HFgL+gXXIk9lqLrAl2qZBScMft/Sh6mVLXv3JQdL03VovMWmVzjhiTaijkclPCYu6tdEhH6wDbLEnVm+SpaNmTg1IkvEcYi2git0N+5RJxee9zHFHydncVSNUoLQ2W76tREHl7bs7MC9k2+k93skXHew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n0XTmufvoscCX9eQghwm1iURatTZslRInzx94/0oYLM=;
 b=rBP6zkkFSl+TZcLENW3vNcozVqLRw6VjCIQw9T6039dBaqXaF+uXXFEGk8+KqRw7JsjPvABWsGcZ3TiXtrdNK1scI5Om+gakQJl87lhF4oJftLPTG1UELuPOGvYYNSC3xdHhKoPmFcPQKq/fMDXS4L8mkdaE4bpLZgBr6pm91hE0c9eIvPIdLn9DbuHBsuu52h/+v7RqLPDD141oprVsLTgoZT6+h9xISgBIm6ejaeIcGlML8XmrzasAvIjs0Bn3c14Joj8EB3FLLz6xaYsqQU/sJRI1rPm1uSQxg+rpD76hhdSxp+W4cQqBQ9fh9wmxEKeuUR3LF4NNTMsOe+kQ7Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com (2603:10a6:803:122::25)
 by AM6PR04MB6598.eurprd04.prod.outlook.com (2603:10a6:20b:fe::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Wed, 13 Jul
 2022 15:05:07 +0000
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::60ad:4d78:a28a:7df4]) by VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::60ad:4d78:a28a:7df4%4]) with mapi id 15.20.5417.025; Wed, 13 Jul 2022
 15:05:07 +0000
Message-ID: <485a998b-614f-9749-2064-fea30c17d2a7@suse.com>
Date:   Wed, 13 Jul 2022 17:05:04 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2] Subject: x86/PAT: Report PAT on CPUs that support PAT
 without MTRR
Content-Language: en-US
To:     Chuck Zmudzinski <brchuckz@netscape.net>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Jane Chu <jane.chu@oracle.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        xen-devel@lists.xenproject.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
References: <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz.ref@aol.com>
 <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz@aol.com>
 <e0faeb99-6c32-a836-3f6b-269318a6b5a6@suse.com>
 <3d3f0766-2e06-428b-65bb-5d9f778a2baf@netscape.net>
 <e15c0030-3270-f524-17e4-c482e971eb88@suse.com>
 <775493aa-618c-676f-8aa4-d1667cf2ca78@netscape.net>
 <c2ead659-d0aa-5b1f-0079-ce7c02970b35@netscape.net>
 <1d06203b-97ff-e7eb-28ae-4cdbc7569218@suse.com>
 <62e32913-cfcb-e0b0-2bbe-75cc8597951d@netscape.net>
 <dbfd3a14-781e-c66e-b11c-e21ba4134067@suse.com>
 <dc0ee2d8-fc88-e4f1-6867-43d3ca3732b2@netscape.net>
From:   Jan Beulich <jbeulich@suse.com>
In-Reply-To: <dc0ee2d8-fc88-e4f1-6867-43d3ca3732b2@netscape.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0072.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::9) To VE1PR04MB6560.eurprd04.prod.outlook.com
 (2603:10a6:803:122::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 451afe67-d48b-4cd5-2714-08da64e11257
X-MS-TrafficTypeDiagnostic: AM6PR04MB6598:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jHM6yo0ntGF1EJaMFG0f+fhXnFKTOUwPZlwEvd/fYn5sfG1miJFQ7ZvGwTLJ7Ds+1dcWB06VBqOYzjX4E9dc2YsYT/OJwzf7JYnIDL9XgV0Oy490FjpvLRjW2WK0DG+ooQk4CPyTdxMhKN9cUfM7M0mNzAynvuCFCVWLx1n05XT2N1udHtZvoEDiYCS9YFn/ovD6Du3VnAI5I4UiL33D/33iH6HVSz3zjTui7gAQ2bg+NjcxYdO3okWdi9KCP6w2UB83GH6zEx3DSH0f5fXo8WQORbBJ+U28R6bEMqxTmKRlJFBUsZ9s/zGia50scLNxXwDF2/Xhnt1qI+oXurAF60eXlSvqG4SrQF35YYd3wr8c3dJM19VSdoI1id3oIt0gu/tYo52o9biHxa1zHTkDbVsMxvkCNwDMVA1o00QGQVHqrmFr41xi3yPzupi67L1S4iQKXiVNXabLsLoOCgXSy4WzKrVOQNw4bKalVaEEeEmTO11g3Vl/iektk3pVvfv551wMvHwLdY7vKGBQRzbFFJCa3qXgwWqNTmnXAPmwPXAfUYy3lcduod2LHZU/fYy4Kp0u0KedNphVoh9xR4wJhN/IP0caQqE8L6HQYVlkaMMetK0MLXhJ/pkCwQDgeBEbwqq/fQ77EZPwFME6FZeHOa5dQtXYfdpbJHjCku0KML4mji9JFMVAG0PjkYgLbRnCMqydjanv2/wX6FUzf4h3gqS0aoKNKftq+PpsgjH2l5os5CDE4Htdxi95t7s7V92V4vQXXQhYcwgnXyqMfpMWgNDXfMKUnCbZSkEB6rX91WWv3yXuBv8cMCFeHxCRs76fWDkYkcgoeH5YSol6bgm+tLcEy3OoopxfpvZlsGhpedU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6560.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(396003)(346002)(136003)(39860400002)(366004)(26005)(38100700002)(31696002)(8936002)(4326008)(8676002)(66476007)(66946007)(66556008)(7416002)(5660300002)(86362001)(2616005)(53546011)(6506007)(36756003)(316002)(6486002)(6666004)(558084003)(31686004)(186003)(6916009)(54906003)(2906002)(41300700001)(6512007)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dTNDVzVQbjlzbWlUeFQ3U0xFNUh1bnlJTE1kcE5IZXlPN0ROWnQrdmh6aS9u?=
 =?utf-8?B?RHJxakhhTEd2SVFtZkVmTmtqbkFuT2s3NWFkR1BLSVB4aUc0Sk1XdmVrRVli?=
 =?utf-8?B?WXhFVnA1WTdsLzBTVnh0RXVXNUhpSklzaUp0b3luUTRGZDBOM1JCaFZEL2Ez?=
 =?utf-8?B?bE9mcXhmQkNFRDd0Y0FQUE5RL251R2JNN0hkWkl4aDNFRlozQTBURVBOZk9w?=
 =?utf-8?B?ZGhCa0ZnNG5hNDRzc0Ywc1NzR1AwZUJaeWxISDFXQWx5MTFOQ3JLdjBOYkhY?=
 =?utf-8?B?UXRIZ2loa2s4dzQvU1JUR0E3eVF2QVZ4ZXMwbkR3aEVDQjFMcnVQVm9TT1NQ?=
 =?utf-8?B?cGlaZEE2eUtheVFncnBHWjdFYVpEVEQvK1ZxMWx4bTNMdFBEdHpubWhmSjgx?=
 =?utf-8?B?ajc2dGd1QUk5cDFVTDJEZUdjWlErb092NHlzV2lCNHhYaWZvMVlVcUZRS3M1?=
 =?utf-8?B?MGw5YlVlR1JlNFJNdU5oUzYyYnd4RjhkYUtnVjRZV1FuYVFJQVVkUTVNdWxv?=
 =?utf-8?B?LzIzaGdHc3p4L2FULzVybWxoaWhicmxRL0JBUlNhWnVsWlVUNVlHY2hoQXRT?=
 =?utf-8?B?RUQxQ0RvbXFRQzZlc0RGSFErVUNwemRiUU9NdFlhZDhxUVUrTFpIak94SmFJ?=
 =?utf-8?B?MVFrT1BQTVVaSXVTaHpXSm1uY3FsVjBIVk1aMWdPeTB0QU0rOXljSG8xWU9o?=
 =?utf-8?B?eDJQdE1YQnMzckI5d2hpN2paK2U3ejY2bThKRjl3c2FTRm1Hdk1NVFVzcFh6?=
 =?utf-8?B?QkJHcU5CWEIzRGdzaEhsUlMrNCtEdTJJVmtaOU5WN0thNyt2ekt4ZkU0Y0dZ?=
 =?utf-8?B?bW13eEZoMzZpaCtpNmZNTTJFVHhjWExQcXZxdTkzUkxCcklJcHVwWjJJd0I4?=
 =?utf-8?B?Wlp1NXBPY29mYjZyYXozdU1FQytxeGJ6OTFRT2VYREFwVDN5akZCelRCVlQ4?=
 =?utf-8?B?dGRZQXo2TzhOUmdvOU9GRE50bFlrZVRacURUY3VZN254ME41UTYrRTdaRkpj?=
 =?utf-8?B?SVgzSGl2WVNvZ2pOQ2kzS1F5SG9SaTByOVNVdGlUcW16WmlXTVNlU0RYL0hk?=
 =?utf-8?B?bEExVXo2c2pyOS95Si9vQkZacWJreHJXa0NZaVliMkhjKy92UGlYTHF4MEIx?=
 =?utf-8?B?eG9rc3lrZjVZdGFNTWdKNjhsS29TOW1Vd2haTEZUSzgxdDV1c1d5ajBOMGJH?=
 =?utf-8?B?RStuSmVrR1NJVDZRNVZ6anltMWtxMTZoMXQ1b1hYSlp6b1NsQ0xHRlBvZEF0?=
 =?utf-8?B?V2dVNnE5d3RnUmt1aFVEdFlhMnZSckxNYzZLWGs2bVpxZm1hN2pwUjBZZ3Vs?=
 =?utf-8?B?OHVvRHhuRHlQNFgxZ205NE9ZV2VZUTFhcXAvTkJiYzk1MVRGRWV6Zkc4dElT?=
 =?utf-8?B?b2ExdjRORU5CS0J4K3BWSGRDNlpaajZjbUIxVUFraUlkZXRFd05ySzNuV3gr?=
 =?utf-8?B?cm9JQ0g1VkY0eCszWHFpN2lsUXl4TVVzZUI4d0lGeWxTZStORlZSeUhSVS9m?=
 =?utf-8?B?Tnd3V2xYZE5oTnZ0TUVyN2NHUm9VeXBYV0FGaU9pNFJWQklDajVQU0JiRU5a?=
 =?utf-8?B?bzFmU3JrMGQ1NFE5U05XZHdkYXk0a0tsanNwMUlucVVPNEZ2azBGb1FuQU1Y?=
 =?utf-8?B?dmVaOThsNFRPa0d1MUdURGwweG5tU1RaM3YvZk5HUWM0blVxeFd0eFRYeWtS?=
 =?utf-8?B?NzdjdE5ienNaSk1zVUVYZG5kelRCS09vMnRMK3dDNWtpWVRPcUxEbVZkMFBS?=
 =?utf-8?B?U3Rwc0Zva2FycDlmcVJsakJjRFZzVjVodi9OZE1XM2F5d0ppc0dzYzdGTW9R?=
 =?utf-8?B?SnNaMkttQVByTGR5dlBmbG9OT1VKM1lkL1g5VFZYaUtxL1RkZElyQThRY3Nw?=
 =?utf-8?B?UnUzMWRVd05DL1hKTnoyQ2VZYkpqZGc5TkZDK1c1RThsWmpzMVc4MWxqQjF1?=
 =?utf-8?B?UDA4aThNc3RJSVQ1SDEzZnhsaEJac3hhWGtOUUlxNjRONjhUY3AwZ2RuSW5Y?=
 =?utf-8?B?TGk4aXVaM1VkbldMYmFPNXlqcWI3WGE1N090Zm1XcEZuS2VJbHF4SlBwNXlF?=
 =?utf-8?B?N0IzQU9CdHQ3MkFYUWVZOThBVGlSNi80TG9PNlRoRGs3dUljUWJvaUczVHcw?=
 =?utf-8?Q?mHaTf70QIC1lby+4Mz/em3NIx?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 451afe67-d48b-4cd5-2714-08da64e11257
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6560.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2022 15:05:06.9310
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z3MPmRnzJeHg09N7VH8OyG22xUujdyQ4MeoZe0WcwZ2lFqgwMTZV/8cn594Raq9gnRJV2X8cvSpujQ9a1inbJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6598
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 13.07.2022 17:02, Chuck Zmudzinski wrote:
> 5. I have been asked to help backport my fix to all stable branches.

Before anything can sensibly be backported, we need maintainer buyoff on
a patch. And then they may have an opinion how far this is reasonable to
backport.

Jan
