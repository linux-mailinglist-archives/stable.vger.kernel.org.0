Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE19577AC5
	for <lists+stable@lfdr.de>; Mon, 18 Jul 2022 08:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbiGRGIF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jul 2022 02:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233351AbiGRGID (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jul 2022 02:08:03 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20069.outbound.protection.outlook.com [40.107.2.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 097871400E;
        Sun, 17 Jul 2022 23:08:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ETYOJfMeDxXpPQEfRSnLKM4quMgV14NEImj3h+j9Gbp3N+t+uiRmEHQscelc9vpREj0j+G4e2VLCut+qyaNi7BV53OcyJwJknnm58IA5H63NmZ732JF0zQTman9SEMeheZ5jGXfWJJcwCyw/h0p2Gn2tHokVVhBZOGeXsSPdf9O0Vh3UHLZR+BMV63BWn8xUyDOhxKhVK+awqOre0cFvmq16HIo8KbWzYwWGE3aFsQMOee/aBelwtsnc4pKHnUnNc+6EdvxtZRolUOjU44+HOleK68vSG8PeNeGaRL6A+K6WvHLj1yXuos32jr0zAnF0zItCxyOnUCRNsidl4hXczg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1IXuJHho9OSOXl7UV/zLebNmFWmzinEovfcnOoaOWdg=;
 b=E3rE0F3WSLSYgPteSKr1Xg4uEOw/Tp6UZ/Oi1Q0bTKs/NGyDj9XPKgx0r7Rth77WY6WxBTgnK1vSx9W+Y1xvSJUXXjFZUUnTkNfGKD40GlWTjVSl2ggiMkYhhE/TtbmDiQy8UpvOC/aFhi8gp08z7omG6PczezOpxHRTZu5QZrc+v+ps9LsrA1TYH+yaBBgoN7iCPbIgbGAFgqPoCnvK8NBav5ZuOUVDiXnBDLfvGl7ut8UXv/TB5rDBkXzV3fRHmwr/7Obb8Cn4LmWx6QHEMC0iiZ+dxV5Yy2q4m1t4wYOMbk77ccuRiV9GSM+KIHqxcujBc59vMnaGP02FCUOn5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1IXuJHho9OSOXl7UV/zLebNmFWmzinEovfcnOoaOWdg=;
 b=YXnzq6b7PQOkppzmoYhYAaxWI0o4IGdlFtLExcAfLKh3pBkyv4JC15JI/q7/GJ20SKI40uAHLAOazgkl0B9Fcmk4KTpf/05Uf0t7jWFKczFardOYca2o23FDH9zRMAUFI7wYcgo41yiWBpkKeL5d+7bWj8GKGuvK2f/TeWHisz/4qn+ZMlpbrwC2eU6jXY1IfVPf/9i7OM16pugfk8xvCCkj1Vmd3C7p/L1cdWVw73WeLN8wMWd5JDNTd9GsDM5tbJe4RKh3h9SuanYJqlyvJMas1JD335GkHljfQuNIE9sphd2XX9UrQUbva//0iJZQhBpNtOd08820AJU+eHC5cg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com (2603:10a6:803:122::25)
 by DBBPR04MB8026.eurprd04.prod.outlook.com (2603:10a6:10:1ed::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.21; Mon, 18 Jul
 2022 06:07:56 +0000
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::60ad:4d78:a28a:7df4]) by VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::60ad:4d78:a28a:7df4%4]) with mapi id 15.20.5438.021; Mon, 18 Jul 2022
 06:07:56 +0000
Message-ID: <764ea65f-269a-6f32-c780-cbdd7cf09120@suse.com>
Date:   Mon, 18 Jul 2022 08:07:56 +0200
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
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Jane Chu <jane.chu@oracle.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Juergen Gross <jgross@suse.com>,
        xen-devel@lists.xenproject.org, stable@vger.kernel.org,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        linux-kernel@vger.kernel.org
References: <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz.ref@aol.com>
 <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz@aol.com>
 <5ea45b0d-32b5-1a13-de86-9988144c0dbe@leemhuis.info>
 <56a6ab5f-06fb-fa11-5966-cb23cb276fa6@netscape.net>
 <d3555a74-d0cb-ca73-eb2e-082f882b5c81@suse.com>
 <1309c3f5-86c7-e4f8-9f35-e0d430951d49@netscape.net>
From:   Jan Beulich <jbeulich@suse.com>
In-Reply-To: <1309c3f5-86c7-e4f8-9f35-e0d430951d49@netscape.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0037.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:48::19) To VE1PR04MB6560.eurprd04.prod.outlook.com
 (2603:10a6:803:122::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8789e7cb-adcd-486e-ee7e-08da6883db80
X-MS-TrafficTypeDiagnostic: DBBPR04MB8026:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ib6hWwTUpm8/rvKtopY5kGkyrZa3GRJKV/R7txsEmtstaa/tlcu+HxkAM/GUCQf7Mb5PQ0qh0TDCyB9NVMGR04bCmszQE5NQCA8xMQCdZF2IqMtMqjSmdjy4Cxr75dzfCFX8dnFTjNx9J4NG5xWZyVqjzDHLos13OMwhduA3DrdAUhpWATGEsXXeD4OQKKnyR4ydMMjVKWPY9eT5jWnIeswgZ4zDUdIrRT4zPoLx36ho8vPokyXBajsIYcRcaYxApyHdBESM2934egBKIgXwGSCtiyIhsP00SgvAPk7JyJQ7YT3Km9IdF61Xo91aEXYlW04Dg3+d910a4Aew7g/jBJmBVDwcsutJlkdYRffSSv0x3pGKHci263xsvHXqRGIjVmxQdYW+SpBif09hDAhLyDKTfYug6vFqEtIeTnOPQk2GLFO2WQme13FzLjVu/vnyilZkIOD8QZSBQWrFPlnenYOa1kZC17yCcKpzZiTXpR2jimabcnCFC+bbhVFKwLCsUf2OhYJhZQ1vrlOSLcc7YQ5PJiSr1aNtZBghkpB+xwTcaFJRvrMXfJjGBjIkCu1Bb7RQ804NGd/HEjB+XmwLTqnsBRPO9jx9zaNnGgRqPTfXFPKKiF9tbYcBc+eS1XvRfWFtg6yHQpov1+j7/NbMPsMGRHOHOBWcGAsKRQHFY848FwNf7O0wKWZDRpTUXMR1P+jLu2j0Y8vxpwPZV4sYD6d7l7h32UaXu7FffcVgwy9NyjLtwfCk2GWp94y6+vPyh7p9kbjLHJX6r9oySroReTNwOA7OH5mtRF62myS9TH33rsSaZ52Be//Z7+FSBj4u+XPviv/nAcF98U4hZGzG0YiZer3CSJ7EcCQLkB/l+iU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6560.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(346002)(376002)(39850400004)(396003)(136003)(6486002)(6916009)(4744005)(2906002)(41300700001)(83380400001)(8936002)(7416002)(66556008)(5660300002)(86362001)(2616005)(31696002)(54906003)(478600001)(53546011)(38100700002)(6506007)(31686004)(36756003)(6512007)(26005)(316002)(8676002)(4326008)(66946007)(186003)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d2tkN3d1d0JGNkM0YUp3RlhReDM0cFpMQjVCZXNaYWlESUwxdkZCeXZhU1Zv?=
 =?utf-8?B?NWpkK0pqQ0V6bmExRnFHSCttQUxzS1dGbE1uc215RzJ4ZFoyMUU2RmZkM3RK?=
 =?utf-8?B?MytKbXYvQXhGdmxCMUZjcVRLSGhCZlhLU0R5N21RSzhKQUVtMHVyRE85dThk?=
 =?utf-8?B?dWQ4azU2N3BscXZoYndVem9QMmtLR29GUmlzcGs5eC91M21GU1ZtTWx5VzRs?=
 =?utf-8?B?Q3pPNkUwenJFQzNHZXE3V2k5blB2Rm50YUs4Sys1N0xhdUJFTFEyYlV6em5Q?=
 =?utf-8?B?cU9FYmlYWHMzTitGRkpNdnhLZFYzZXdPdm1oRks0Q0R1ZDAvYlVYbzhXTm1Y?=
 =?utf-8?B?d2VJREp5eFc0WVEwU1AxV2FDMU9tSGxSZG5hdVNOMTZSbEtYVGtxdlQwMXJ4?=
 =?utf-8?B?QXh1OWx4Vm9pM1pHQmEzb2hTVmlIODMwWlR4UW15S1I3SVpNRE9jZEJGQkFZ?=
 =?utf-8?B?VWxQcmJCWlZ5cDlCdHlDSXgzM0FjQWJUbkY5ZE1VY1BuQjhlKzNKNmtsSUda?=
 =?utf-8?B?QWdwRVFQOSt1K1d1VzhBMXdpYmMvMGZFa045UE1QNkFvNzFBTXJBcXk0Qll5?=
 =?utf-8?B?SlVtVnhZL2R4K1NiM3p2RHN6d0FhbVZsVkloUjc2d2x6R0xuMTAvaUxManZ5?=
 =?utf-8?B?Zml0S3FZNkg1WVd4TTBDYUpJazhoSUlWTWRPRm9lU1pTS01zNHMyaHQvRDU5?=
 =?utf-8?B?bnNLWmd4MFJTK1Q0MUhxMnVpOCsra3RJZnN5VUY0Z0RIUm9wcUdxbGZsQjhW?=
 =?utf-8?B?b2lCK0pSNGh2dlJ1VlB4Sjh5eXJTNlU4SEhLRkpLTy9MMGRoTXNoTitvdEsv?=
 =?utf-8?B?WWMwWkVjcm9CVEg3MGRSOEZ6OENuYk5MWmJENzBtWUJ3aXNya1lVMERsVklR?=
 =?utf-8?B?d203enVWeVNPSjJBMnJhenNRQTdOc2pkTjd4RWdZckZKL0xySVhoUHhSWk1n?=
 =?utf-8?B?VEFUbzlzVCsreGdDbmdDQkcrcHo4Ym1CT2NHaHErVmtPM0VlWlZBZ3VsOHBL?=
 =?utf-8?B?V1BNOEsyWjJ3SjJSY2NiMGgrL2JJWUFVVmxaV3FSeWNNbFhUd0tzNWxZMWNL?=
 =?utf-8?B?cnkxTDdWdHExdmZyNW1xR09Tc2EvZi84cTM4bVJTRUwyTTZhLzhWVk9xNWd2?=
 =?utf-8?B?NUs1bmdDL2FCWHM1WmZyV0VsU1dXZUlua3hLbCtZRnV0MXA5cHhNR04zZFVm?=
 =?utf-8?B?TE14Z29ab2E1c1FLdjhRalYzQk1mS0k5eCttT2FzUHVtNmZXeWtrMkFyOWsv?=
 =?utf-8?B?TVhHUkFPazMraXd0Z3NoUVhmT3hsSGZqdUEvd0l1R2pKTTh1Tlk5QWhiZ0Zk?=
 =?utf-8?B?QmFtY2I2V2RZOWhaN2pYSFB6Mis1Yld1ZEhpNXhva2tsdHV0ckZaQ2VJdm1K?=
 =?utf-8?B?ZS9WTnQvbVkwa1EzQ2dEcTdtSUF5amQvV3YvL283UXA2b2tPYlZJaTVpUFcv?=
 =?utf-8?B?Q0RORm4vODBKVHpHTDIxREVGOFE4SnZPdlBnU3p0NzlwQVE0OTVBWjdrVTdi?=
 =?utf-8?B?UmtkQ0VGZXNHM0ZuQWJvb0RXOEpHYnBBbHg4VE80ZCtJdTVrTG50djhSLzJh?=
 =?utf-8?B?R3pldzhuS3J4U2JTWVJINzQ0MXI1UnMza0ZHa3d3ZWFyc3RLYis2TEx5Y2hv?=
 =?utf-8?B?SG1JV0tPSytZRnpQT2hydUxmQ1ZEMWdwYTZKa3lQbE9mblJuRC9TakdqSlho?=
 =?utf-8?B?UVludmFmRWo3UWYxbWFVWHFiU09IMGtaRjd0Tzg5K0tiQS9TMDliSHB4RDlm?=
 =?utf-8?B?cXUwN0hpN2hWVU5xa3lZRFZzMVF0TEFsT1k1RE9pdlF6WjIzbEg4dkZjRVNF?=
 =?utf-8?B?ektlK3l6d084QVVFWDc1cjJWUzQ4d00va3FzVWFoVm5iQVpyU2NQSnpBMEJr?=
 =?utf-8?B?RmdaSDBrVlBvS3pFY2Y2TFhMaDNlTzVNUmsyUkQ0ME5iSkZDSld1ZFVoWUN6?=
 =?utf-8?B?L2FjT3NkaU9ISTcwc1lETHJSUmcxUTFOQklyL1M1OWJ4N3ZCRVl3elpmQkMz?=
 =?utf-8?B?Yzhya2lOdndpTzRVSzZzNVpzcFlsSzhJbXdsMEE2R0hsbjBuRk1zZFhJUVRY?=
 =?utf-8?B?OUN2VnIwcGs0RUtKb0pPZUxlY2V6eWhqd28zM3Y2UFVNK2p4RTJTUEFQRnI0?=
 =?utf-8?Q?xANokraIXdPXr3Re9SC36O35v?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8789e7cb-adcd-486e-ee7e-08da6883db80
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6560.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 06:07:56.0885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SfWz5ydNitlLQuAlzLNOK2GMnbdeziDfGDNQS5pRtK23635iJbDj/oVy06/IJuWwOkIHZDQ92ALvOOlmvWwXoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB8026
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 15.07.2022 21:53, Chuck Zmudzinski wrote:
> Two things I see here in my efforts to get a patch to fix this regression:
> 
> 1. Does Xen have plans to give Linux running in Dom0 write-access to the
> PAT MSR?

No, as this is not technically feasible (all physical CPUs should run
with the same value in the MSR, or else other issues arise).

> 2. Does Xen have plans to expose MTRRs to Linux running in Dom0?

Yen does expose MTRRs to PV Dom0, but via a hypercall mechanism. I
don't think there are plans on the Xen side to support the MSR
interface (and hence to expose the CPUID bit), and iirc there are
no plans on the Linux side to use the MTRR interface. This also
wouldn't really make sense anymore now that it has become quite
clear that Linux wants to have PAT working without depending on
MTRR.

Jan
