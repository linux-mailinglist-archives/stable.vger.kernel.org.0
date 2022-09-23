Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA9235E79F2
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 13:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbiIWLr5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 07:47:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbiIWLr4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 07:47:56 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8987713506A;
        Fri, 23 Sep 2022 04:47:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WBDgrEnlAxytHwCitbgbQYFGoQguMqoCKyv8cxgCc4AShaCAegK1dBAPMZkx2qD8OyqwB0kp6//qKQ6oOm8oY8dqv8sd/kE0V6eJ2ML+H4+yOSZHQyZHwsGjqMUbkeTROuGV6C3E3MkXXVzFVhGFoXucNEfnRGgSheUuczI4kUtNyqssHerEi1bBJ1NiApsUTL+3WQ8ttCFAW/UYl5wYopRlT5EKsfnB7y92u1N5N376i4pCYFQODCqFSE5pTV+mfZYIYek+2llcADQRMOtcFGhdf/SeWyzclqGES7klr1XO4zkPA9q/8oY4y9iqHViLtvlzu0HdjcB3wr8nBHMnLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VgTwoMIz9cNS2RSHnaJdBaW7uwEc/VPLDY7/Bub+LS0=;
 b=XF8X22vz8O1wDkOQt9WpGPcTmIaKLDQyfBxkOpZjJUajzA0tGtyXL0iI9PjoUk7EJYGzjB3m1SQpMagMxSSDcn07Xmr/e7oKD0lI1bn7q+Wu6w4YfiNXzCb1ou3ZalysRLhTzdjMHBndeQvbIm+a4QNxPfO0z0MszSb60SwPNJ1lfMdA7fqxLFEADvVYJgC59FB8qV3dy4roFQf2vIDfHMyqp/zFATXbyrIeQ3zylMWDOSjpPhoN0lkO8Mmm1GOU/OPYrK0x4k0NXp3DggxZp79J4/JQ1chzGhBaE97BrH6fXNufArFg5r1FXRUnPeezMsZliuAiDXnIOpYNMEQN8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VgTwoMIz9cNS2RSHnaJdBaW7uwEc/VPLDY7/Bub+LS0=;
 b=y4E9IIEN3wfpXjLD74cv6ABQSlux3XhtZbNPFtgtcUy6tcREwolXaVnp1+uEKw0ldqAcRCKvmsblBkVbZSfR5wdIXrrPYLC/jo8W4jP1Ql1v9ZM8A3TqnMJ97/rxbk1Hgzpn75bkGv+pBDIyzWwiX5SEHak7O1LHvrTPB8MUPb8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6204.namprd12.prod.outlook.com (2603:10b6:930:23::19)
 by CH2PR12MB5515.namprd12.prod.outlook.com (2603:10b6:610:34::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Fri, 23 Sep
 2022 11:47:51 +0000
Received: from CY5PR12MB6204.namprd12.prod.outlook.com
 ([fe80::5557:a7f7:142d:5b0a]) by CY5PR12MB6204.namprd12.prod.outlook.com
 ([fe80::5557:a7f7:142d:5b0a%6]) with mapi id 15.20.5632.021; Fri, 23 Sep 2022
 11:47:51 +0000
Message-ID: <dfc687f8-3c3f-f866-7e6c-8fcb68e0cd89@amd.com>
Date:   Fri, 23 Sep 2022 17:17:35 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
From:   Ananth Narayan <ananth.narayan@amd.com>
Subject: Re: [PATCH] ACPI: processor_idle: Skip dummy wait for processors
 based on the Zen microarchitecture
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Nayak, K Prateek" <KPrateek.Nayak@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "rafael@kernel.org" <rafael@kernel.org>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "andi@lisas.de" <andi@lisas.de>, "puwen@hygon.cn" <puwen@hygon.cn>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "gpiccoli@igalia.com" <gpiccoli@igalia.com>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "Shenoy, Gautham Ranjal" <gautham.shenoy@amd.com>,
        "Ong, Calvin" <Calvin.Ong@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
References: <20220921063638.2489-1-kprateek.nayak@amd.com>
 <20e78a49-25df-c83d-842e-1d624655cfd7@intel.com>
 <0885eecb-042f-3b74-2965-7d657de59953@amd.com>
 <88c17568-8694-940a-0f1f-9d345e8dcbdb@intel.com>
 <MN0PR12MB610110D90985366A4B952CCCE24E9@MN0PR12MB6101.namprd12.prod.outlook.com>
 <9d3d3424-a6d4-4076-87ff-a1c216de79c6@intel.com>
 <MN0PR12MB6101D3B6F6FF4C5BC2208FB2E24E9@MN0PR12MB6101.namprd12.prod.outlook.com>
Content-Language: en-US
In-Reply-To: <MN0PR12MB6101D3B6F6FF4C5BC2208FB2E24E9@MN0PR12MB6101.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0038.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:98::6) To CY5PR12MB6204.namprd12.prod.outlook.com
 (2603:10b6:930:23::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6204:EE_|CH2PR12MB5515:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c1db8ad-7996-4897-2e44-08da9d59715a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qXZH/jdBmHg62H9M3lPobTs/A2m51wcJoPzhm6TylP+7kdOvEcHZlXQZo0bCB1dTZzODJ0OboyWp1UtRCXh4APy5yUnEmZ/9Sn+jMtl3QQC01jDk41cIDazYfhI1qiMppNcmkFvB6yu28JfVoiAcmac3037JB1OYS7Tbpep6Mk7uInkIjT5WFDkfUwtYEzdEhTXDV80+Wclz5ZpTIBUG5kt8hd+JP3KBd+DEgh/+VNOXtMnFatYOVY6pKjlXbd0HO+mulKnDC5unBCeBQtuJF5sp9RlQ0JWYJULt8yfW8azWQGFbES9lD4/BNuPBuDZ1uuCeqOrBbJeKShkxIwMw3vR8Pt9+GJ+oSNEikGQzr18d6e5hiIbvqzEFF7HKvuNt1Tx2HuRZSelsFnyZLb2YyvO1eAbgYAoBaGomqX/AKYLrXuyswdw0REosRxd+PPgRKZThk4x9EPIRF9rdjfkVoSwh7eSP53UaFyc4FMguHkezPxDm8PcSm2/ErJa+YGSaHE0Eq2mrXRaOz4ir/xKIe44GfTRuKHPuks9i205GsoBE7szWCbjU4w+02p3X1fbHac+A5hq/0Kb/kzrgSLiuBvhAKbR7+WjX/aEkR028O0mZPw5miyTn6mDG54VYkhcc/Rb106/Dhq7HzDR+glw94KxI0JVYC8pzRGZ63fAEiq9+Ac45ChpDAzUnZ+WUYGo2ETrRtja7yjBrvNQZ8WMr66FPG8o3EWMlf/rsktrzo6nfrOP9a+aYVvK01rZfxrczhYj9QAqiiMdm8yV54AW0BZamGTJNXm9ENwxMUPxocEU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6204.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(396003)(136003)(366004)(376002)(451199015)(8936002)(31686004)(36756003)(31696002)(2616005)(186003)(86362001)(26005)(6512007)(2906002)(53546011)(41300700001)(6666004)(6506007)(38100700002)(44832011)(4744005)(7416002)(478600001)(5660300002)(8676002)(54906003)(110136005)(6486002)(66946007)(66476007)(4326008)(66556008)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NmtmVFY1R0MrbFVtNENIK1Z2TFI5Z2JZd2E0d2tHY3dRVWIrcFF1UStlRS9p?=
 =?utf-8?B?MUZ2dmt4MGxqOHNUMnM2eW8wdVltdUJNZmVXQ0dYQUlYQjlJdzczT09iRDRK?=
 =?utf-8?B?THRlM250SmQ4Y0ZLdUJJN0pLcThQZzhyUlRhWE9IajAzOGg5dUVFanQ2Q0wy?=
 =?utf-8?B?V3VHTGY5RWhibzRLdUp5YWUyUk1DZjdhcVd0dG1VV0J2RlY2WVZqc0Z4RzVj?=
 =?utf-8?B?REp2OHJHaWhxdVRPR2FOTVJXWjQrOHFQQTAvT1RsQ2k5dm5PUUJUbGJnN0xm?=
 =?utf-8?B?L29UTHNmV2hqS05KN3VHdElOWHBuanZYbXhjdm1wYUpxeWJ4Q1E4SWo0bFhQ?=
 =?utf-8?B?OUdRZzZoWXNxYmtPS0paMWlxVER5Ui9QM1Q0bHdtamdKSDdpaXR3akc4QVc3?=
 =?utf-8?B?bGIrQzM5YjJkZFl6TVVlek1BSkZWeDRYVzk3ZGdndzdvcW50bFJ6VXUrREZF?=
 =?utf-8?B?Y2FGczJWeVhDVklUUXk0MFJBeGlVbHBKUlVjY21FaFlMT3VZTEJHL1N3UEJP?=
 =?utf-8?B?cnVQc1NXZkJVRGxXYVRkb1p3V2VJU2RvV1hiUS9Tdm5qV3MwRXN4dlRuY3I5?=
 =?utf-8?B?ajFlbzhHalF1a2srb2NPRlVSeitLd2N1eTlkbFRCdXZ3eE8yMkdMYWdoQS9a?=
 =?utf-8?B?dXlscVVaMDd2ZE9QUlU3VU5ZVEVibUpSYlVzT2tmSCtQUmo3dFo4V1gyS25r?=
 =?utf-8?B?RkkxV2w2bHZ6MjdZUGkxanZHMDA2M1RIejE2VGVIWXRDcjZiQzhLVDBSVUYz?=
 =?utf-8?B?SzE4eHVDOEdHR013ZEhIdjZTQVNWWUVzcTFLZGp6cGpqdVRvSTBvTklXTlNm?=
 =?utf-8?B?RDQxSmljRW9zU0Nvb2dQbmtEV3lPLzJBeFZGWU4xNVJaMlM1U0Q2S1JJQ0Z1?=
 =?utf-8?B?dDdJZUpMakNEQWVrVHp2MDRlQ1N2WEt0RUI3N0R4WDd1YmEvUkJvTWR6UHd0?=
 =?utf-8?B?RWhlNkdxWHNMdFBEamZSaHZvOGFtYnNDR1JYOUprTGgvVFBYWHB4L0Y3RW14?=
 =?utf-8?B?dWhDTXdEVW1Fb3h0bHZOZTNEdVRvTndHVTE3MFNKZStMdkt3ZnpsMjFCeWI4?=
 =?utf-8?B?UnpodWZhUWtzaTZLbUdXaVRvM0RFaHcxZ2lpNlo5UjljYkppd1MvZ0ZTYmtJ?=
 =?utf-8?B?eXRadVkzMGZhNDNXejk0YzYxamEvZEg2L2MyRm02ZXp2MXNoZm5MNWdiYlZ3?=
 =?utf-8?B?WTNYSUpGdldRSkpQS2oyQVFKeDhGenhpd0FrbDdtWWdUUTdsSVZRL1RYR2Vm?=
 =?utf-8?B?bzhHSzVQeGdpWllqRnJFYmVCS2gxVEw4VTA5ejZvckFpaHZEUEdsVDQrcG53?=
 =?utf-8?B?SkdOcUdidTlQSE82dTRkRFUxWGExazVxTzgyQkN3N2NoOUhFdHd1eUVjRnd2?=
 =?utf-8?B?SDZ4UXZ1QUJDYW9KaTl6SjBhVUdCTUhST0lLVktpVlhzVlA0M01LSkd0aHVC?=
 =?utf-8?B?dWhJNVZ5Q1lPZmNieDRmQUVlc1plQVdWWmVENkVzOFBoZjJicmtuQXd4S0wz?=
 =?utf-8?B?c2tYQVFPTGNMNFFEbVVsenVNaE1mbGw5L0dJYmczTDZUUUd0QkVXdUVLcVhx?=
 =?utf-8?B?Mzd0TjlKUWNESUtOUEhKdHJheVVvVHdDdTFJYllwaFRkZVNxNFBSMmpMeXo1?=
 =?utf-8?B?Ymk5U0Mrc25ucDFuWFY3QmJMTHgrVnJJZzBROUpNaGtQNTdIWjJLM3BMUlhr?=
 =?utf-8?B?NElzVmtCUStVTzVzNTI4U3pIdzJaMjArclplZUxzSi9CYVVuOS8vdnhteTMw?=
 =?utf-8?B?Z0JzR2tyVUJUbXNZTWRFRGhoUi84Y2M1dGV4RkFYckdWOEtZMm5JdVRMdjdP?=
 =?utf-8?B?Y0xVSXhBSXVRRFR5aTE0MThNMnUrQjNFV0ZFOUNxMmdQZUcxUmc4eE1hRzQy?=
 =?utf-8?B?UVJzZWUrMEhhUFFWM090OERFdHY3ZGFnTHZ4OWltQ1NwbGtCN0JDVDJLVVVF?=
 =?utf-8?B?dTNER0VYcGJ5WVNrdDhxaUNCY1VoVVk2U2FNMkZzQ0VkaGd3aUM5c2trZENZ?=
 =?utf-8?B?VHllNHc2a0w4RkY0eU5UTUVvWmxRK1BIZnJoWmY2QXdHUVVWVnJ0QnZQQTFr?=
 =?utf-8?B?U2NQMTQwd1pSOEpUVE51K3h0aXNuUkVpYUZkYUZuTERaejhEdm0rOVQxQW03?=
 =?utf-8?Q?YmmFdb3FWrod3bSZuk069mndX?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c1db8ad-7996-4897-2e44-08da9d59715a
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6204.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 11:47:50.9793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c1omTvrZYGof39N6Xop2S1nlg0mnKgB119fp0HiAZqk7axkH4cPqN40W89cN4RAECfnTMgsfleifyEvu9Rm1kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB5515
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22-09-2022 11:58 pm, Limonciello, Mario wrote:
>> BTW, is there seriously a strong technical reason that AMD systems are
>> still using this code?  Or is it pure inertia?
> 
> Maybe a better question for Ananth and Prateek to comment on.

We have evaluated using MWAIT for C2 entry and feel that there are good micro
architectural reasons to stick to IOPORT based transitions for now.

Regards,
Ananth

