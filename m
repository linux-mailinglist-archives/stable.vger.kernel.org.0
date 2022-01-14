Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9C7448EB5C
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 15:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233634AbiANOOG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 09:14:06 -0500
Received: from mail-eopbgr100099.outbound.protection.outlook.com ([40.107.10.99]:65301
        "EHLO GBR01-LO2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230191AbiANOOF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jan 2022 09:14:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jy3hqb8BJi3M2pUyn5uUPS5zBjuHM6qSu6vheoNEvbHQG7WGVQjiNzdOCxYMf73WKgTKM0z0VfdA3drDbx5WXD7Fqm6koPwqqGYdIuzwChUsE3bSv2977RjIWlSJR0yuLFAQqEw5rxYWjDzBUfS4363r0OVbH+92+Fsk9zctENqvQsBR0wNXvR3kySilYH+KEmxkNbTmU+huGbhnW0AZARCTR0iVAGr8ekkfsHHec/Wq/gOtSjnicKsCzBdiPhf8Go0hxYLwYfu1sLxyDfYyz0o/Qijny4sLWMroTt4XBfN8JJ3cVzy9zHtbXv9kNurCwk+cQ2hrAAUC7x44rOlI9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9+fC+1i3C/O79TvrYHF+FsXNN77zin8A2AxECB01jqU=;
 b=nT+DLuEsozDp/zNCYvraq6oup7Li9/08BB6EdVi/JRyFpCrw4HcsXROeBj9JgEBeX9FoXU6yHgjYSL8OAN8bgZ9SrhgjIFMO/5ZU1NS4W2MJ4nrZtEHmPYpEL8KlFo4xHMhvFWv+cEamPcVdvUjrocplHb/V3Q7V9jnKvTzkXxu9reh9paupZDrXkfUsnIaEBgiOqhFqd7bTjo8GVnHc+i0+bsKsQPGEzbqXMtQN290w4h1ZidUeH/WFZfulABp4WHXW/70miEuRyueV+KBgQs53GwCQkXNSorhVyKnWIQDtJlrviGrzIR99c9CBBv3cNP8UljjrVGUXjTszxxVWkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sancloud.com; dmarc=pass action=none header.from=sancloud.com;
 dkim=pass header.d=sancloud.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sancloud.onmicrosoft.com; s=selector2-sancloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9+fC+1i3C/O79TvrYHF+FsXNN77zin8A2AxECB01jqU=;
 b=bqJMlIn/CGWYTpJ7MaTmNhJHiXB00EfX2GaRpA4HwQvLrkg9GQDtXGgycfctMZsvFDglkXBkaLoBz/GijFMnY8Ziz19eMURtWsoiPh0Vso/+Pm6UthijyhsQM1bW3NphpbwG5CxufAhkukoibXB8yQBFd2G3NZSewFT+ipvJLfE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sancloud.com;
Received: from CWLP123MB2241.GBRP123.PROD.OUTLOOK.COM (2603:10a6:401:61::19)
 by LO0P123MB4074.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:154::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Fri, 14 Jan
 2022 14:14:04 +0000
Received: from CWLP123MB2241.GBRP123.PROD.OUTLOOK.COM
 ([fe80::4ce0:d9e3:cb2f:7992]) by CWLP123MB2241.GBRP123.PROD.OUTLOOK.COM
 ([fe80::4ce0:d9e3:cb2f:7992%5]) with mapi id 15.20.4888.012; Fri, 14 Jan 2022
 14:14:04 +0000
Message-ID: <04598430-7383-b725-2f5f-3f2b16aaca36@sancloud.com>
Date:   Fri, 14 Jan 2022 14:14:02 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
X-Mozilla-News-Host: news://nntp.lore.kernel.org:119
To:     stable@vger.kernel.org
From:   Paul Barker <paul.barker@sancloud.com>
Subject: Backport commit f634ca650f72 for 5.10.y, 5.4.y & 4.19.y
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0047.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ac::14) To CWLP123MB2241.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:401:61::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 23ce3d4c-19f3-4468-9e97-08d9d7681e89
X-MS-TrafficTypeDiagnostic: LO0P123MB4074:EE_
X-Microsoft-Antispam-PRVS: <LO0P123MB4074AC4AC0071DFD462ABEC893549@LO0P123MB4074.GBRP123.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IINDEjDUjz5RiSITpdxtHlY0roicByaP2H5x83onqilN3fHqmOU3raQ2sEnmKFxDbXzMsSOWNENsVIZmjDPVrG7KPN6+RTw/Q5ideFpeJswjcC6F/NgnTv+Dyq92mS6/4m9ayaizrj0q29InON3l4yolFXDqDROJWc7zSks0fA61h/NJDmpVMK4K9CwFTos79geU0P05HG5Hz6ZvhxC2ZRKGc9JaTXMg0STSgo7MsY9i4nqmVcg6XFBC37arq2m6PBUkynPj2cPLxN2xWNPrC3Wus/4hyagg5qQTBLLbb6C6SeVJX+wReNzepNlna209iafuDXa+tAw5Uv2ZTB7CWv3MyMzP6hzjddqZt0loXB+bXydo2AiMsP684DZg1bQ5DJ/gWTi3gi0nMOQLyLpZKprHHjZjGcVoRjWQRe4UQ/h2AKHVS71lKyLfiMuP1nFZgMmeOqfhCMfXQFuj6iGTpXQVzLCXjXcvZqA1DGpgZgJdEYCjg1C5z+qHjfCq7jW56pSHqain9/wYkQpo2mrnYvVH4r8+S/xZByHWwlfPcqfzvEz/6uzojgjqIyz7ej38ymQEMlGR7olVbTgC7YWz1U2yGEmIjmvOP2QTtBEorg2PxTgivCOtiSYjicY2Xi/5OKpdEiFakLeY0xqdqnfRyLD3RybEdt/QPx+eIhSeb8F6l7CrVwrrVNbsMy73mVDd276hN3ZVQe4L6/NMgHGu4KF2JjYP5bDxVplsJ3+uELY2fRybP2M3hdKOhOa/DC9U6vg1uM8PX98KqyTmUdsntK1z3dxLw3xKcpVd5ec7FKyH2sLeBOIkFG+KdVGiYGWkasmSDvnbiKTJbQA4KPePqb6sCqLl7g91HFXr8ZSl2YU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB2241.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(396003)(376002)(136003)(346002)(39830400003)(66946007)(31686004)(66476007)(316002)(52116002)(2616005)(36756003)(83380400001)(38100700002)(66556008)(6512007)(31696002)(6506007)(86362001)(6916009)(38350700002)(44832011)(26005)(966005)(8676002)(5660300002)(508600001)(186003)(8936002)(6486002)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aDl0eXl0bkZvWU9UQktJc1lLaGdCODYydU9HT09rMWJyTVlzRkoxdThmemJG?=
 =?utf-8?B?c21zOXVBUDdjUncxNlBiYkd3NmFGZ2Y3Wi9McGEyNC9jM1cxMlBRK3ZqYVJY?=
 =?utf-8?B?dDBxWjREdm4rTjF2Q0dORkp0OXdRV21vMjNmendmaGpCSkNDRDRpSVFla1dO?=
 =?utf-8?B?RUl0QjFVSDVtUVAvMmIrRXJmcHkydzBlUFZRbVFBZVJqNEM0anpUZytoOVNE?=
 =?utf-8?B?bk43Y1dSanFzaklyZDloYUNRS2lDTnUybEoySk1kdEFxT1hJeVdrRlYrWGxi?=
 =?utf-8?B?VDFWWEx5NE5kYzNIWVFRS3BRMEVHZlVaUWdmQWFGK0ExZldkeGszRXA3WlNZ?=
 =?utf-8?B?OE5sTnNQRmtoOUdrY2J6N2szVE9YdWNFQUt1UllGZEcxZ2I4VjRoeWQyQW1N?=
 =?utf-8?B?RFg4amZ2UWNIZEg5MDhZL3M0ck9HWlhBNkkyamVJejQ2SVRZZjlFVTNUMFps?=
 =?utf-8?B?cGxmNzU2anYvdS9zMDJFOFZQZ3ZvNnQvUTNFeDNSVzQ2UDJrYy9tOGU4S2V1?=
 =?utf-8?B?V1ZMWHZvc1VkYVBlZnM4UjYwVkNiY05jcHhtQzgyZU8wT2hyN2xSaTFSbDBJ?=
 =?utf-8?B?Ui9BOTFnemk5dFZsYUxyQ1BDeVpFeUFGOUJBc29WSVBKQmtnZVFxcWhDaUlm?=
 =?utf-8?B?ajRVVEhPK3lZWGZvQWpUb1NZRGV4eGVXSnZKUGpvMlh6VHB2VS9rOTd4ZDgw?=
 =?utf-8?B?R2dyeWVISFZhN01BN21YN1dKVjNjVGJPTllhaDM3V2RLM0tMV0ZkNXVCOTdY?=
 =?utf-8?B?OU5xZjZrZXo5UU1ONStEL0hxMG05cGFuSG44TS9GWW05SG1nOHNZTVo0YnJ2?=
 =?utf-8?B?Y3hPb1o5cURLL0s4ZkIrYU1HNVVWbG9kS3l5YVlnbjBFZWNUNjYxeXNjMm1z?=
 =?utf-8?B?MkIvcDMrTmZpeHVkQ0VEM1JLMzJITU5HdWVuZnMrbVBkSmI5ZTBjdnhWc1Zo?=
 =?utf-8?B?NjRaUnlxSTVnc20yaEpIWEo2aXBFbXlGNjBvT0JSR3p2VmZLd0xVNzhvS3RY?=
 =?utf-8?B?Z1MrSmNUQXdpSHJ3R1ltTXR0SW1tN2xVS3JmcDV0SDk2YUZHYW1SMEVZcEJ0?=
 =?utf-8?B?U1FIT2Z3c2VmU2wwTUR0YlRkTGdxWjRXSEFXV0JEVmFKOTNSV3Frd3BSc1hO?=
 =?utf-8?B?UWZ1YTI5UnFPMkE1NDlHOUVkajBQMzdPeStFMW9INHBUNXB4MGVnenZoTDM1?=
 =?utf-8?B?bFY2NGxBaWVSbjZzYzdsRzNzM3E0aWZ0MVhoVlBiQlYxT3ErWStyZWd5SVVu?=
 =?utf-8?B?MVp1MFIyM1RYOFRGNTQ5dXRiUXNGbHU1bGowOFlyRVIzTDdUUVBwaUNJK09t?=
 =?utf-8?B?cXdhL1A4RGRVWjdkVzJXSW5VL0FSdGptdkRoNnJUZng0WTFHZ0lZd3lMc0E4?=
 =?utf-8?B?VzhUNklKNThRNy9tS1g4VTBuTHpiV3dKZVZOTkwyamM0WDF2UG9oR3lEUEhS?=
 =?utf-8?B?ZlFMaDlqaWdzd0pkQi8wWU91Zzh0YnJ0WVBLUnNYa3VITnJFL0xxbU1nNVBs?=
 =?utf-8?B?NDRZYW1ManZyTjhwTEM4Z3daNkVYTEhEcEcxd1RwUGtTc3dMYUdFRk1XV050?=
 =?utf-8?B?S1dVSmRteWloZUZ0UHlqYWxYTHo5RjF1SUlXUTNZNlFxWlVIUFpmL3IxUUxw?=
 =?utf-8?B?R3pUQWlPWm9xV3R1Tk1NOU00T3Vxd0VUTW1sdS9WNGtsUE13YlRMT2h2NUE5?=
 =?utf-8?B?KzZmaXhJUVR0NlhUZGJ2bHpoWHQ5WHRQdkY4U3FhQ1Q5aGttaXVJZnUwT3Bl?=
 =?utf-8?B?L1dBeTdIQWM3SWs4OFpiNHUwaitqSVVtbjE2ZXd3Q3IxY1MxU3h6UG9xL2Zi?=
 =?utf-8?B?bkRIbStiOFU1SGdGK0pvaXRIOExVcGRMaitLVVdwNzlJUUdEdUhLbTJLK1lF?=
 =?utf-8?B?eE4xN0lQN3hXK3VVN1BoaTBrcVFzR0JSQ20vK0ZralZpNkd3OFdQQnMzR2kz?=
 =?utf-8?B?K09vVVhaemQ4ZWhXM2grTUh0TGpNazZJUFdZQ1BPNzRmemxjRFh0QVRVZVVC?=
 =?utf-8?B?SnFCeFE0MUJ0OW91cE41NmNwK2lJenZoN01wM0lqWXFhYVEvVGg0cjRQaHNO?=
 =?utf-8?B?MldXencwTUdaWjlqUEJxZE9LeUFVS3czS2FVdFNNQ1p3cDhvVGxreDIvOWkv?=
 =?utf-8?B?N0pDdDJ5cUYzUWw5a3ZzU291UmZiOUZLdGZUa3N6c3pxMUdRMGFOWDhaSFZz?=
 =?utf-8?B?a0xaRk8xZTZ6MlVuK0lWZ3p6RU1KamVuVFlkMnlybnh2MFFKTGpwUG1uWHVm?=
 =?utf-8?Q?fURWmx7clpb945a7ir6eHuAarWwY/kSbnpzu8FGuWw=3D?=
X-OriginatorOrg: sancloud.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23ce3d4c-19f3-4468-9e97-08d9d7681e89
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB2241.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2022 14:14:03.9635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 840be37c-244a-450e-9bcc-2064862de1f4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4OV5o+Gsuvmr4zga+c1fpQgSlhbS8R9KEW45TNxcjz6tMemP2R9vrZmT3jGz9JJXbvMpDq4GSrzVmU0yG9ewh46kGGlxx02E9c9xe6maFTc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P123MB4074
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi folks,

Please backport commit f634ca650f72 "kbuild: Add $(KBUILD_HOSTLDFLAGS) 
to 'has_libelf' test" to stable series 5.10.y, 5.4.y & 4.19.y.

This backport is needed to fix builds with CONFIG_UNWINDER_ORC=y where 
HOSTLDFLAGS is given on the make command line containing library paths 
needed to link against libelf. The issue was found when trying to build 
stable kernel branches for x86-64 using Yocto Project after commit 
7fd06a57a1d9 "kernel: Rework kernel make flag to variable mappings" was 
added to openembedded-core back in October.

The backport to 5.10.y is trivial. The backports to 5.4.y & 4.19.y need 
a minor tweak so I'll send patches for those following this email.

The build failure is also seen in 4.14.y but I can't see a trivial way 
to address this as KBUILD_HOSTLDFLAGS does not exist in 4.14.y and 
backporting the commit which introduces KBUILD_HOSTLDFLAGS would change 
several other kbuild areas. I'm happy to workaround this locally by 
disabling CONFIG_UNWINDER_ORC for 4.14.y builds but it may be worth 
considering alternative fixes for this branch.

Let me know if there are any questions.

-- 
Paul Barker
Principal Software Engineer
SanCloud Ltd

e: paul.barker@sancloud.com
w: https://sancloud.co.uk/
