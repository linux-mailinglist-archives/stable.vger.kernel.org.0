Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79DC12B1806
	for <lists+stable@lfdr.de>; Fri, 13 Nov 2020 10:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbgKMJSN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Nov 2020 04:18:13 -0500
Received: from mail-eopbgr130120.outbound.protection.outlook.com ([40.107.13.120]:15110
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726200AbgKMJSM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Nov 2020 04:18:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZrnH1U3DS696WB+mt0oGfx6fjHWPO1HhjUhZcCy3NbpB9zlPNkcatyjByEdI1Fbh/5O2K+shRJ5/1YnoHCzr5SCH6uLsc3l7DZ8e0jXGzAdTqnHXPE6Ggr2OIVh0wRabZ15jDxyuy181IIAycKUXCBmvqGs1ylfgSwesQq3t3MScpULEXkFmlOw1ouYUyr0f3p4bt/Ou+1IArGh5ceb4B7isQ4oiGNbZIWsSAH4xI4Yt+1OaFH22gR0Iuo4WZsO9A/P03MRsyHg8ogPojV1s1JhTGZ3wcsfsxdMOegOvCms787NxjYGgIBEP1jivheWuPp8M1rSPq2kAwO3ZxzIYIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JTQXUBfgPgEEro2fPl6SoqVmvBAUC3Q/+5z/jDrhClY=;
 b=FwJ3PY0iKNrHBmse4aEhWW/Iia8j7nxc7JHk/0Z8fk0hz/Jim/LR0FvdJY3olhYLqrxd1a2hfnBY+vja+3rhO4doRVsXlrrRrnOQ3NghpRe/mfm9MqsiH7FgGSDuan8Y2Ek3PrnvPhAlcooo4U9mgka1RGm+qNS8AFnieH2lPewu//lPWYe5UzTB0ZPQ3Eh8Ay4XpluMXXcaCHcBOGAiWHxm17+opSKpAFAByfxjvozqvNLFzaYzHXSQ7dMv/B+43YvT+XrHl80K50IigeyuNgysM+a7Bus7w9hwlUTXuzKAuChE1XeW5U4+TiQ4UyqdeF65XSItkoSUK2fSxr3MmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JTQXUBfgPgEEro2fPl6SoqVmvBAUC3Q/+5z/jDrhClY=;
 b=EiJVXy1qwIL2LGijuW1cMta5d7HZDhEn8BBeGh6zEFt3B9i7Wpig+l6JyzNcgVMMsXwybVPbaLvhGdFVtu5iE6mc4wYD704a1wzaYg6QiNgwNLqC+zO+32wjEny3yvw6eQdsknIyuyUayGmbVfRy2XZ1ff04tffYrvVGfNC+LGg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nokia.com;
Received: from AM0PR07MB4531.eurprd07.prod.outlook.com (2603:10a6:208:6e::15)
 by AM0PR07MB6001.eurprd07.prod.outlook.com (2603:10a6:208:113::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.15; Fri, 13 Nov
 2020 09:18:05 +0000
Received: from AM0PR07MB4531.eurprd07.prod.outlook.com
 ([fe80::d527:e75b:546c:a85b]) by AM0PR07MB4531.eurprd07.prod.outlook.com
 ([fe80::d527:e75b:546c:a85b%6]) with mapi id 15.20.3564.021; Fri, 13 Nov 2020
 09:18:05 +0000
Subject: Re: [PATCH] MIPS: reserve the memblock right after the kernel
To:     Serge Semin <fancer.lancer@gmail.com>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        linux-mips@vger.kernel.org, Paul Burton <paulburton@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20201106141001.57637-1-alexander.sverdlin@nokia.com>
 <20201107094028.GA4918@alpha.franken.de>
 <1d6a424e-944e-7f21-1f30-989fb61018a8@nokia.com>
 <20201110095503.GA10357@alpha.franken.de>
 <c435b3df-4e82-7c10-366a-5a3d1543c73f@nokia.com>
 <20201111145240.lok3q5g3pgcvknqr@mobilestation>
From:   Alexander Sverdlin <alexander.sverdlin@nokia.com>
Message-ID: <4c58b551-b07f-d217-c683-615f7b54ea30@nokia.com>
Date:   Fri, 13 Nov 2020 10:17:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <20201111145240.lok3q5g3pgcvknqr@mobilestation>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [131.228.32.166]
X-ClientProxiedBy: AM0PR10CA0003.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::13) To AM0PR07MB4531.eurprd07.prod.outlook.com
 (2603:10a6:208:6e::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ulegcpsvhp1.emea.nsn-net.net (131.228.32.166) by AM0PR10CA0003.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Fri, 13 Nov 2020 09:18:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d147f0d9-eb3f-451d-ef7b-08d887b50725
X-MS-TrafficTypeDiagnostic: AM0PR07MB6001:
X-Microsoft-Antispam-PRVS: <AM0PR07MB600111562D6761BA7AB063AB88E60@AM0PR07MB6001.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dClwJctBkwrIJQs8lUy223ztRJOzrTjNYOdCiwcxeJAuhtFw8OrBHw2gFiU65MxnZV3ApjEivpy1t8Lfy14QvHgnwjAA5fJsLTjOEgOW+XC2mpOtpvpYsvd7rtAFy2pqB67cSzlQtzu5w46ZHb06I2dLsbjympA+InXv8I3u3BTbBnYq1RT282XlLCH13lwGS8pmV0U9W3QUe8rvrCGYEKAAUwAZsv/lqrE8S8GaDDq6jkkElkM6JZ2bq8yHb9MbWm/MP3l0qcdkbukipC4Dp4MutgInDn24KHxmS9I26O2rF6EeTTOs3bEzMW61ux6q/fHVHC1JFtCiKUUKmNSZ9WLAKHDxIc9dV5ra0CGYxodbRhHa144iWYzG4VXPmnas
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR07MB4531.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(366004)(346002)(39860400002)(54906003)(478600001)(4326008)(66556008)(6512007)(83380400001)(2616005)(31686004)(8936002)(6506007)(86362001)(53546011)(66476007)(26005)(186003)(316002)(16526019)(5660300002)(8676002)(44832011)(2906002)(6666004)(66946007)(52116002)(956004)(6486002)(36756003)(6916009)(31696002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: P/k5bNHQcZHSb8sQso72R4+eZDC+VJ8FU0P/iv8DHHdsMo+YVfRWRW7FZ+3qbYjUgxa6b9aRCJRDnwTUkFVvFbnXUVJvsXuniQztWGwW4K2RzQAni3v9+CMjj0FyjakoFoK1cxwEcGMwkDGawgIKptrNK09cGfyEOXugA4WHW/a1LQschOrckuHRiIsxL4S2CcIMqOZjjbnJD69paArgfi86LV/zl6JvdKmyDp8zQmib3a+J28sqOrZVYT2YAY0ht5DItYYGFvtxvQCc11/MFzznPcdFWY6nSJTbyx+lB2uObpyHowsGfBqQOpbBXT47pv5PoJ7WodYIBHRk/urhzHR56ltEzqcnmWG3/ycVPFsfFTT5FSNnAl8tVxz7LHxXAvhxfPjZGKi0cPgPibgwNidjravG1xjkrw76OAlqhAchrn31m2M1RAEUZd6wm59ZNrpBAeyU92+YvqEL0GRLowq6KbikDD7TThvZcaAO51HGovUZ0oqlmAj0cJ8Rxa1TjmYMsvhdOs2kkqOerWq/rlfb/lUCwxI0tV5Sscd4Uf225lv35kTmU+oHEmMFqoJa4LCdTSDlmHpFfAPvWqmUBDwbsM8rkRptzkqh3VoAquJNEP1jQ9kUAuKB66ADS6AlnasgN1D6p7bau6RI7Np+k8r5M6IsABzYwQmRPv44Tvapmhpuc8VxjARTirrIFfWqjHFWPNIhcVZJtyXYDp7Mh1jPb1ev9yYtmFD5hZjg1sXaGtV9hDkovK2P7prs3nwn0QlnpoC7+G6z4DZMu4v351Bz/7CyIrMsrX/tsr5pxZdGOAXhoRMME2CpGLbFVGmKsfvnxiOaGgzHPbq0xNG2qKjwQxeHRinOxjYxkTtOOgPLY6dRcnS4llixq7nIQ9tJmLv6XmYURo0LoWgUjQH4rw==
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d147f0d9-eb3f-451d-ef7b-08d887b50725
X-MS-Exchange-CrossTenant-AuthSource: AM0PR07MB4531.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2020 09:18:05.3309
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ynq0xcR42G4IE6FUnQMw2P4qElXAIfoP5lXuhrYNFrXoN8BanlTl6K1e4VA3Und7wX2JK+uLbIV4a/q7QUhdN0rmwb0C+mFSpJqyKS9+mng=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR07MB6001
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Serge, Thomas,

On 11/11/2020 15:52, Serge Semin wrote:
>>> Could you send a patch, which removes check_kernel_section_mem completly ?

finally I think you are right and this would be the right way.

>> this will expose one issue:
>> platforms usually do it in a sane way, like it was done last 15 years, namely
>> add kernel image without non-complete pages on the boundaries.
>> This will lead to the situation, that request_resource() will fail at least
>> for .bss section of the kernel and it will not be properly displayed under
>> /proc/iomem (and probably same problem will appear, which initially motivated
>> the creation of check_kernel_section_mem()).
> 
> Are you saying that some old platforms rely on the
> check_kernel_section_mem() method adding the memory occupied by the
> kernel to the system? If so, do you have an example of such?

Initially I was confused why the below patch didn't solve the issue on Octeon:

@@ -532,8 +532,8 @@ static void __init request_crashkernel(struct resource *res)
 
 static void __init check_kernel_sections_mem(void)
 {
-       phys_addr_t start = PFN_PHYS(PFN_DOWN(__pa_symbol(&_text)));
-       phys_addr_t size = PFN_PHYS(PFN_UP(__pa_symbol(&_end))) - start;
+       phys_addr_t start = __pa_symbol(&_text);
+       phys_addr_t size = __pa_symbol(&_end) - start;

... and finally I understood, that the reason was in fact that I tested on Linux
v5.4, which still had this code to reserve RAM resources:

        for_each_memblock(memory, region) {                                                                                                                                                                        
                phys_addr_t start = PFN_PHYS(memblock_region_memory_base_pfn(region));                                                                                                                             
                phys_addr_t end = PFN_PHYS(memblock_region_memory_end_pfn(region)) - 1;                                                                                                                            
                struct resource *res;                                                                                                                                                                              
                                                                                                                                                                                                                   
                ...
	
                res->start = start;                                                                                                                                                                                
                res->end = end;                                                                                                                                                                                    
                res->flags = IORESOURCE_SYSTEM_RAM | IORESOURCE_BUSY;                                                                                                                                              
                res->name = "System RAM";                                                                                                                                                                          
                                                                                                                                                                                                                   
                request_resource(&iomem_resource, res);                                                                                                                                                            
 
so I suppose that's where this evil truncation happened. Nowdays this is different
and I believe we can try to remove check_kernel_sections_mem() completely and
this will solve the memory corruption on Octeon.

> So IMHO what could be the best conclusion in the framework of this patch:
> 1) As Thomas said any platform-specific reservation should be done in the
> platform-specific code. That means if octeon needs some memory behind
> the kernel being reserved, then it should be done for example in
> prom_init().
> 2) The check_kernel_sections_mem() method can be removed. But it
> should be done carefully. We at least need to try to find all the
> platforms, which rely on its functionality.

Thanks for looking into this! I agree with your analysis, I'll try to rework,
removing check_kernel_sections_mem().

-- 
Best regards,
Alexander Sverdlin.
