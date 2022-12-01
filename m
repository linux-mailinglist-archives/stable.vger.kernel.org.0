Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4908363F07A
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 13:29:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbiLAM3F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 07:29:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbiLAM3D (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 07:29:03 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2058.outbound.protection.outlook.com [40.107.22.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6118B68C9;
        Thu,  1 Dec 2022 04:29:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lMUZOpW+08Pr4puRhRggg9VrJtaXw2+UQxlztPvMJw4esFd6ZnjQJZqtO/J118VALfhxAAiwjtMxq5evUZk6VHGixdJOE40/Qk2uC7gH5CuExCmrcbYL3vP+SUOXkiY7+mWDQ7YnAwPo977PpGqpB6qyrap/psnE2fKk+eWp5Y40rIbk7odz3MrINbmBMwWqQEERpppFrEuKfEfWqGRRwUSTMKfXylH/e8rtJn2L0ImjWv/clP2qmvrXwdWJTyLxsCeu4HSOw760JM4GktV1B5pV2toMmuPGPD5K6If4fzuENn4282JMRaWAy+xdpiEbqC1ODnYWaCkP1WTkUa2Ifg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kbPn24pTxFwoaROkJViyJRGM1iepzDiLGCKo3Kahd6I=;
 b=DLZC45v+Md9T0/1zuhu7SidMtxE9cV4UifK8Gk60QTirxWkM5bWuMIyF2reZ44X/O7iVacLAjhZ9LVM90YiwVwiOlc9GVxWfLputafoitNBJMMmWyx3AacmkatLs79El/TtmTx/iP2v0O9XNuFilGMGgdEg8nLkbEkP5vDKsA/H90G6BsgO8ytLgIq1oG5hNz1GYK/3OUe74SXFc8F3CBqqxSFUuvNw2nZaDXmZflCzDZJIqsQ5N2HlFCm5NXdlKfUG7T1j8iu9NeWOVq08JsUsOKpn4IrFaDLqIHgukuLnU+B2z//oNoHA4kHO3myy5mBGi7PpFKx76WA0S26AHlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kbPn24pTxFwoaROkJViyJRGM1iepzDiLGCKo3Kahd6I=;
 b=i5HTMCKQRLoAOCdnQMR+32SxyS9ve6LOjsF3ZUbHCPWLPvgZokA7OuSHlhKgt5tuF/sDjpJN99oScj9QJWVwMab3GTMoIMD8YH4xIxBWKkr1WY8YtSY5Ui2WqFQBL6f44Dy7v8oQTQljVvkT9HVNfuf8SFu7XZkABG3oCutf3Caj5F3Ud/eVxP8aNI+KTh4ZYtAmxt+B3tO/qcIbyuGKKJYUOU8c311VOssEnq8OquLydHLe61Ntk94fB3ZzJa1ypWH9WNPRkOOPPVUPnPi64VluDsxt5NpqLAQdDtgqZJkr0ltT26n5MydSrCSde4l8hpLraT5Pj1wzOhDjNTNFEw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR04MB7104.eurprd04.prod.outlook.com (2603:10a6:800:126::9)
 by AM9PR04MB8455.eurprd04.prod.outlook.com (2603:10a6:20b:414::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.21; Thu, 1 Dec
 2022 12:28:56 +0000
Received: from VI1PR04MB7104.eurprd04.prod.outlook.com
 ([fe80::ae59:a542:9cbc:5b3]) by VI1PR04MB7104.eurprd04.prod.outlook.com
 ([fe80::ae59:a542:9cbc:5b3%7]) with mapi id 15.20.5857.023; Thu, 1 Dec 2022
 12:28:56 +0000
Message-ID: <716e5175-7a44-7ae8-b6bb-10d9807552e6@suse.com>
Date:   Thu, 1 Dec 2022 13:28:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v8 3/3] ASoC: SOF: Fix deadlock when shutdown a frozen
 userspace
To:     Ricardo Ribalda <ribalda@chromium.org>,
        Juergen Gross <jgross@suse.com>,
        Mark Brown <broonie@kernel.org>,
        Chromeos Kdump <chromeos-kdump@google.com>,
        Daniel Baluta <daniel.baluta@nxp.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Len Brown <len.brown@intel.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Eric Biederman <ebiederm@xmission.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Joel Fernandes <joel@joelfernandes.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Pavel Machek <pavel@ucw.cz>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Ingo Molnar <mingo@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Dexuan Cui <decui@microsoft.com>,
        Takashi Iwai <tiwai@suse.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org
Cc:     kexec@lists.infradead.org, alsa-devel@alsa-project.org,
        stable@vger.kernel.org, sound-open-firmware@alsa-project.org,
        linuxppc-dev@lists.ozlabs.org, linux-hyperv@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        xen-devel@lists.xenproject.org
References: <20221127-snd-freeze-v8-0-3bc02d09f2ce@chromium.org>
 <20221127-snd-freeze-v8-3-3bc02d09f2ce@chromium.org>
Content-Language: en-US
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <20221127-snd-freeze-v8-3-3bc02d09f2ce@chromium.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0014.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1d::7) To VI1PR04MB7104.eurprd04.prod.outlook.com
 (2603:10a6:800:126::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB7104:EE_|AM9PR04MB8455:EE_
X-MS-Office365-Filtering-Correlation-Id: 29c366d0-5774-4a3b-97b7-08dad3979d37
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zVbWyMn4/DuS8MYtN3KTtDv4rUlNzeen87tWNvTVUVcr5esyw72ceS4hYCqUUB400bUO4vwZ5DyHr3ybZCgmkm47mTdTNRdiDGypM3Laj/sgHa5NlcC5WHJy6NAtBPgj9cRxjludZUjzXD8qhN3vuKt2/+lAP/ucCeXOLvV8o0SE/k6VT41+/KjKkbWqevbg7U16v4lDFfRGO7/Adb5A1iTXPZurSBfMPOV9b51tdoW9zg3sMbxxBXQffwvSyMVB/nUwhkboS4gwCUuoP1wwQp0byiryMb3TTLTIPHVacO1B/Dpj4uA54Z2sZ6BlVvuYFQYXWNbC6vGX5GSd4/dsj0EVoASvq23HLJZwKwn/QdMz9hHRZS+FyhpUao1l1IPpuA2r6HjA86Noxe85XM9a+wWpsdP6t7K6uQQ+JP47J/9b+TumDx9gs2ATXYpwAombbO6p9sGW5WDiZTEMmwndFW1PPsrdc43IeuW2/cjt+WsdcUmpT0M8n+NagenZCc9Tap0gv0w1vx6fT7j6JDVCroeM5ZjBLHwrfd6y296yRDesM/SNvT+pB7gwv2XhoeCaNPndrLKJKKS99tkz3Y0vOPP6vAUmR5zRAeKlkvA/w86QBRVY+Oo+NJm932Vbeu/A351RnLCj0bauS4g+rIj4qNSX8xUaGNshS82fPYKFEE0g2Jr16m16VXeeRiKFPLHqqvBXYhDZ/ZQ7JlUhMgOag+fJCW4QcELjQqnH7JTqwzc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB7104.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(136003)(39860400002)(346002)(366004)(451199015)(7406005)(4744005)(921005)(36756003)(66556008)(7416002)(66946007)(6666004)(110136005)(38100700002)(5660300002)(6512007)(316002)(186003)(31696002)(41300700001)(6506007)(8936002)(66476007)(2616005)(8676002)(4326008)(6486002)(478600001)(2906002)(31686004)(86362001)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OVlrZ1ptbTI2dlFISXNpbEFvdjZKM0E0K29tTytkNlJuNGN5R1pRSWR5aEIv?=
 =?utf-8?B?TnNOODBhaWVpbGlUUzZzMm0rQ2wzM0dacjlWcFdISVhQUEREL0xhQTNReCtD?=
 =?utf-8?B?MlhnNEUyckVMZElXa3lRc0xWN0JpQmU2QUlZYmRCYXZZRFJCd0hyeDdZb3BC?=
 =?utf-8?B?eFdiUzhZQm94blZ0NHBFOFlibzVITlM2RmpFWDBMUFRydkxOcy9NUXloR0E2?=
 =?utf-8?B?a2srNSt0T2pPK09uNGhFT2lmZ21HcXFua01jeTJhNjZJcnArYS9HZWVmWGNm?=
 =?utf-8?B?M29XT3ZpMmh1MUJ4clIxaEp0SWZpODJ2VjBMc1dyak9GSjV4Wk1meE1WL2N1?=
 =?utf-8?B?b3dSZ2NnVWpHUVYySEI3MUFKMkRGVUlZSUgrREdIM2FCejh2dUt0eWZLN2ZZ?=
 =?utf-8?B?Rk9keUdqNDVzZUxIRUJwQ1R1c2cwMFVhK3l2blpvRXkxbEFMUThqUEx1UUp2?=
 =?utf-8?B?QXBFNys3LzFNb0JLZlRWaU1UWlBiK2RQMUZUSVAxV1dzekt5eWtpTmY1WWx4?=
 =?utf-8?B?R2NnUndyL3ZJSDNnZ3lKUFB4ck5ENkhqNkRqRjFnR29HOGJKVWlhUHFqbDk2?=
 =?utf-8?B?M2toWmtnUnZWNkNTMnk4MHNMTHhXSkJEcC91cEdYcVh3aU1YQ1l5SFpjWXE3?=
 =?utf-8?B?cmRGd09NRk1jdExtNngzUW5lOW9zbEp3V09aMWRMbExXRmdVeERMWUJCa1JZ?=
 =?utf-8?B?WE94SXZOMkxIUW9GL25STlZ4Ymxrd3o0aWFPeWFGVU8zMUtER1RPeVZhOFBT?=
 =?utf-8?B?aE5mSllnaVFjS2ZVS0UyYmFGMkZvelh5cWJHYWc4Zko2aUdEUkVsZEZYTk1K?=
 =?utf-8?B?cit2WGRINzVXRHJMR2xrdG13QWpWTUFVbG9Lem9Ld0xZbStZblJ6MHYxNnZ4?=
 =?utf-8?B?YW9idUwwdlViZzQ0NzBHN2h5QTYyaUd3eGxNTElYUXVIV255NVVmbDk3Qllr?=
 =?utf-8?B?ZXJPeVA2Ukdib0ZhUjhGaE0zWjVTSmNnK0svVmRSNWMvUGJMdUJjZU5TWlVs?=
 =?utf-8?B?SHVRTG84VjB3djl4UmRhcWdnR1BWMmt2REcrdVBWSnZnbFUxZTJPM1lPOGxm?=
 =?utf-8?B?Q0NpN1JJQUJvNzBQakoxZ0lWZVYySXlhcjZMeEcrYjRhanZQdDcvUUxtWFN6?=
 =?utf-8?B?WFVVWTdJeUFmcGFsSW1nWXgvc2MvekdOSGlVaTRmQ0JFUHcvSDZxRk1KMElZ?=
 =?utf-8?B?VkUwcjFnRGlTSUF3R2p3REhTRnhNZkpWVTNqdGxQU2xjdnBkMFVnTnpBTmgv?=
 =?utf-8?B?a1RCUGRudjdpeCtFUGxjMU5PL0puajdlMEkyaXYzTjZ0c1ArbytBdmgxK3dS?=
 =?utf-8?B?TnpoUmUwTUhieVNtOG52Y1ZyaStjMGZheVFlbHlObnZIODJjTnNZTEQ5TURE?=
 =?utf-8?B?V09TMWcxa29FbERBaVQzRlZRelAvWDNxMlllbHQwcUNqYU41NkpnN2Y4ZTVQ?=
 =?utf-8?B?aGt6NUhkMmlCN0NhcXUvc2VZTTY4T3BjL3FBclBhV0FxVHhOeW94Y3JhMnRK?=
 =?utf-8?B?SmxTN1RFSVdIY2RQdkdrSGpLa2xNaEZ5bmRGYjIvOVBmOVEwaTJkNWVmaEM2?=
 =?utf-8?B?bVhEZVZEd0JmeDVvb2EzTlRMM0hFbFNTZVNhcDVtVU5aQlhLaGJtcXVPOXpW?=
 =?utf-8?B?YzJ6TS9HaTI2WUtvTzErd3J6dEp5d0pJa1RTeCtEN2dkMXZOc2VLTWFkNVZy?=
 =?utf-8?B?Z2NPdXZnTzJHMXNDcFBlOGdZZDhaL0VnTG9qUVpLZDFyaGZBOUpURnd0UXgy?=
 =?utf-8?B?dU9QWGcxdVVZaXYybnphazN4L1dKUHBScjFGZEliRGo5UGpuYWF2bVhBazZY?=
 =?utf-8?B?VGpjVVNXY1VPZEp3L0gvRnRjMUdTTGtCL1FiblhlbXFYbTI5cVhLMWRIUEpm?=
 =?utf-8?B?Tk0xa3FNRkt2aDFUVUZ2cWJiWVB5WkZDVWhVbm10Q2twY2prd3ZWZlo5V1Bi?=
 =?utf-8?B?WG1ZSFFXK01aR1R3Yk1EZHhLZlEzNzQ0dXJqakpMMFRNOEVaRUtqRFVYVlYv?=
 =?utf-8?B?bmNlOVVQQjllT1RvblhMbjVIOWtBRS81VU1hcTlncmZmc0QydFBHNTRLLzhS?=
 =?utf-8?B?T21RMmZOK1pWM3QveldCWW90ZWUrbU9ScDYwRFVqRVl4U0lORUEyaDRvcDB4?=
 =?utf-8?B?NGp6QkpjYTRNR0piSnRPU1dZZEpDMzROWjNMdmYwenZ3UnhjbG84bVVoSU8x?=
 =?utf-8?Q?JFcao0VCb3jYRTJVFTLNZGmc5RBKCYEQxjcQNk2JFBOc?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29c366d0-5774-4a3b-97b7-08dad3979d37
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB7104.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 12:28:56.0173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sy2UDu5ykQolAf69IiRIuk8PvYqQdxYUYZRj7WM4ObYqmqhC0KI8te3qkmjREbzF6vXnR7/FSIW5WTl3+D0Vxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8455
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01.12.22 12:08, Ricardo Ribalda wrote:
> If we are shutting down due to kexec and the userspace is frozen, the
> system will stall forever waiting for userspace to complete.
> 
> Do not wait for the clients to complete in that case.

Hi,

I am afraid I have to state that this approach is bad in every case,
not just this corner case. It basically means that user space can stall
the kernel for an arbitrary amount of time. And we cannot have that.

	Regards
		Oliver

