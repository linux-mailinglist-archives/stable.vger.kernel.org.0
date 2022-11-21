Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6633B631E7E
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 11:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbiKUKes (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 05:34:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbiKUKep (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 05:34:45 -0500
X-Greylist: delayed 62 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 21 Nov 2022 02:34:32 PST
Received: from esa2.hc3370-68.iphmx.com (esa2.hc3370-68.iphmx.com [216.71.145.153])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B349D2871B
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 02:34:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1669026872;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=OhG1pbo0HKf03bdp7i14jI3MJOhmG5fyzzDFeRToEuM=;
  b=D0OFAemWYKYxu7Dmhri/nhkEnXTUhM/DPviUiHZWBXgfVSxjc/4YMyJ0
   xB1bjjoL79rK/bE6bOKragG6ScM1Xjo0e/lYHOH+PBhHtnKcGAkZVxAL2
   PU6BPIicyW6lvqUWqAE5PL/okrQOx3BM92SrFH1heLEZH9WcNE/CyLnsT
   I=;
X-IronPort-RemoteIP: 104.47.66.41
X-IronPort-MID: 85257545
X-IronPort-Reputation: None
X-IronPort-Listener: OutboundMail
X-IronPort-SenderGroup: RELAY_O365
X-IronPort-MailFlowPolicy: $RELAYED
IronPort-Data: A9a23:yb8t2KsqbvNlQZnNRYyVSp0py+fnVEZeMUV32f8akzHdYApBsoF/q
 tZmKWzXbPzbYDb8ftknaozkoxwGupeEn9IwSwFp+CExF3hA+JbJXdiXEBz9bniYRiHhoOCLz
 O1FM4Wdc5pkJpP4jk3wWlQ0hSAkjclkfpKlVKiffHg0HVU/IMsYoUoLs/YjhYJ1isSODQqIu
 Nfjy+XSI1bg0DNvWo4uw/vrRChH4bKj5lv0gnRkPaoR5QaEziFMZH4iDfrZw0XQE9E88tGSH
 44v/JnhlkvF8hEkDM+Sk7qTWiXmlZaLYGBiIlIPM0STqkAqSh4ai87XB9JFAatjsB2bnsgZ9
 Tl4ncfYpTHFnEH7sL91vxFwS0mSNEDdkVPNCSDXXce7lyUqf5ZwqhnH4Y5f0YAwo45K7W9yG
 fMwLxJQVkG5wNON76unaft2i9sgMtnQFdZK0p1g5Wmx4fcOZ7nmGv+PwOACmTA6i4ZJAOrUY
 NcfZXx3dhPcbhZTO1ARTpUjgOOvgXq5eDpdwL6XjfNvvy6Pk0ovjv6xabI5efTTLSlRtlyfq
 W/cuXzwHzkRNcCFyCrD+XWp7gPKtXOmAt9NSeHlnhJsqHe460kqGBQTbGCmgN+QsGSGX/9SJ
 mVBr0LCqoB3riRHVOLVWxy+vW7BvRMGXddUO/M15RvLyafO5QudQG8eQVZpeNEg8cM7WzEu/
 luIhM/yQyxitqWPTnCQ/avSqim9UQAXInUFfjQsVhYe7p/op4RbpgnTR9xnHYargdDvXzL92
 TaHqG45nbp7pcQMzaSgu1fcnyiruIPKXyYy/AzcWm/j5QR8DKa5aIi4wVza6+tcNoGfT0nHs
 HVss82f6u8JJYuAmCyEXKMGG7TBz/ydGDTYgFNpT98t+lyF93e9cMZQ6TdlKUFBNscCZC+vY
 UnPtAcX75hWVFO6PfFfYI+rDckui6/6GrzNVujdRshffp9rMgSA+UlGf0ee1m3puEshi6cyP
 dGca8nEJXIXD65PzzesQeoZl7gxyUgWwWLVWIC+xh+/0JKAa3OPD7QIKl2DaqY+9qzsnenO2
 9NWNs/PzgoFVuT7O3PT6dRLcQlMKmUnD5frrcARbvSEPgdtBGAmDbnW3K8lfItm2a9Sk48k4
 02AZ6OR83Kn7VWvFOlAQioLhG/HNXqnkU8GAA==
IronPort-HdrOrdr: A9a23:W3xG5a74aS/2UGjmfwPXwaiCI+orL9Y04lQ7vn2ZFiY5TiXIra
 qTdaogviMc6Ax/ZJjvo6HjBEDmewKnyXcV2/hrAV7GZmXbUQSTXeVfBOfZowEIXheOj9K1tp
 0QDJSWdueAamSS5PySiGfYLz9j+qj+zEnBv5aj854Hd3AOV0gP1XYbNu7NeXcGOTWuSKBJYq
 a0145inX6NaH4XZsO0Cj0sWPXCncTCkNbLcAMLHBku7SiJlHeN5KThGxaV8x8CW3cXqI1Su1
 Ttokjc3OGOovu7whjT2yv66IlXosLozp9uFdGBkc8cLxTrk0KNaJ56U7OPkTgpqKWE6Uoskv
 PLvxA8Vv4DoE/5TyWQm1/AygPg2DEh5zvLzkKZu2LqpYjcSCghA8RMqIpFel+BgnBQ9O1U4e
 Zu5Sa0ppBXBRTPkGDU4MXJbQhjkg6RrWA5meAeonRDWc81aaNXr6YY4ERJea1wVR7S2cQCKq
 1DHcvc7PFZfRezaG3YhHBmxJiWUnE6Dn69Mz0/k/3Q9wITsGFyzkMeysBatGwH7ogBR55N4P
 mBGrh0lZlVJ/VmI55VNaMke4+aG2bNSRXDPCa5OlL8DpwKPHrLttre/Kg13ue3Y5YFpaFC16
 gpaGko9VLaRnieSvFnhPZwg1LwqSSGLHjQI/hlltlEUuaWfsuvDcWBIGpe4fdI7c9vRvEzYM
 zDSK6+M8WTU1cGJrw5rjEWI6MiT0X2cPdlzurTCGj+1f7jG8nNitHxVsr1Cf7ELQsEM1mPcU
 frGgKDafl90g==
X-IronPort-AV: E=Sophos;i="5.96,181,1665460800"; 
   d="scan'208";a="85257545"
Received: from mail-mw2nam12lp2041.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.41])
  by ob1.hc3370-68.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Nov 2022 05:33:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AvScgZsGqDa0NR2KIR7n5fVNr0diVh/savKaYpSfFFxvqyuJM6azyU+/FRCEzzJO8a+hm8DmeGQusqvj++TYP3vwpreShwlPGrYiJpsh2HN2EQNrNSdrNbW/oQKttzeusjbD7slYu+dRlU4bZoDuxZ/V09uRdE27d35zjgeWl9hwY8mCqRgylctDeCSbm/AgViwmq1M091Vx4blPlG3dQB5JvC0YELHPdLqDp3ekEftmEtJwGcbyse42d5dVRTGxtIfkKl+BSEeXbPKJTyCSgAAr01cgTwOKKKZ96CzUsVgP3vZpMjjQT0TiXDarx9phC6WOEFEH12vkuUZGquXMSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vg+rjiccX1faa/xjxY+0Qw0fO6LNKDvwiUc3ugbC6P0=;
 b=Py3N2rqEMs/y1gkTEcMh/PjCOddExM1RzWa67Z7mN80rLzUhIFE5qExWUwMD+yXd7IZ8I/OI53QFkQw6SL7Lr3gP8fwz2ooHKf9lhLSy3gg3r2DDeRJfZLJAU1gnywePhVHGg+91ru65G4RGSFAvPeBEivCtztzQNg2+HZaBvqNGbMBWNvLjeFDeFqI85SUkm8QR7xQy4zNSYcAkBG6DMeSPx7Va0NEVFi9l8tH+6fIaf/qlK502RIIRe3Dj9aWJ9PyyevadtNt3dDjxPoMphuzbopdQPlCqQOVIiJClWNJEvAPinqPDcNExFNYFEC7e4fWuHJPFYAHhpkeoCWgyFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=citrix.onmicrosoft.com; s=selector2-citrix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vg+rjiccX1faa/xjxY+0Qw0fO6LNKDvwiUc3ugbC6P0=;
 b=bROBq+vzMaJTAxcK/2L/Upt6iBUzd4VaYgeEazMlekeqA9ESeQAflW+CyimXXv793g+E4NW/rwqqgSHpSx8Tv/BwkprMRmz0pprW+E7HDcdUcSAUFkSKfiNjW8KFgZPcqAoC6D0M4TFPFQPzF+KZADKhkfeS4iUMeI8fUcSeeQw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=citrix.com;
Received: from SJ0PR03MB6360.namprd03.prod.outlook.com (2603:10b6:a03:395::11)
 by BL1PR03MB6102.namprd03.prod.outlook.com (2603:10b6:208:31c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Mon, 21 Nov
 2022 10:33:27 +0000
Received: from SJ0PR03MB6360.namprd03.prod.outlook.com
 ([fe80::740b:4e0a:7de4:5ab1]) by SJ0PR03MB6360.namprd03.prod.outlook.com
 ([fe80::740b:4e0a:7de4:5ab1%7]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 10:33:27 +0000
From:   Roger Pau Monne <roger.pau@citrix.com>
To:     linux-kernel@vger.kernel.org
Cc:     xen-devel@lists.xenproject.org, jgross@suse.com,
        Roger Pau Monne <roger.pau@citrix.com>,
        stable@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH 2/3] acpi/processor: sanitize _PDC buffer bits when running as Xen dom0
Date:   Mon, 21 Nov 2022 11:21:11 +0100
Message-Id: <20221121102113.41893-3-roger.pau@citrix.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221121102113.41893-1-roger.pau@citrix.com>
References: <20221121102113.41893-1-roger.pau@citrix.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0273.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:195::8) To SJ0PR03MB6360.namprd03.prod.outlook.com
 (2603:10b6:a03:395::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR03MB6360:EE_|BL1PR03MB6102:EE_
X-MS-Office365-Filtering-Correlation-Id: dccdf515-9599-4924-fbb9-08dacbabd331
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lea1d1MD2u4Fp0UglumcYiXvBnRvEZ5AAHOuqAVmAQSC0xxngLaohYJcCpofPr1Ktxqx6Iz24PpBB1dH+wEPvPoqEiqSChtGDpGMVevhDsTVUufyoZUV5w/ELvvKC89yE1prq2Uk6tqBPr+HwuJ2+2EvIORL6sHOqzXnAF7Sd1qZewPHSyc8MGyPt4fL4rDhzDXmeqKO9Vie7xFLHIAdSvZgqm1uc4PJIa/9I9q0K6AvKpXqGYzBYeEHmyFOcYvN1OXL7KDHk8kPzSPeyPWWgpYoPGfCKQ1YA9GqYaupkkHaVJr2H/vApoMroBF3RRi7chNaFgTOOEjfhDLdaNCzorUL32Z/ygf1jfgJkN2xSxq/C/UeMAQXPHXI7dTZL5A0ZHBbmPL9X+0A/u0/ENcrc2H5mWE48QTNkpzrZyVGcw9a5ake6tYALhZE8ZwvwCff6NUJcMpNWnlRGxm5E/bfjH1w9kgjA53IaddG4mj6Yc0DmYo6J0jKdk/56x4QZ/O9y7hUmekiToAGnOcc/8VATzHl4/BGRw16l+7m7X+fyCVgi9lOhtMEpnDW0OU9gAcWBx0FmH6k8i+f66g/xOo5rEKDreaIrOaPh2+d1iyyGvve5IMI35xCk7+Z68L3AZQcAM4SqqPTPD2QtmGfIU/pMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR03MB6360.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(346002)(136003)(366004)(451199015)(478600001)(6666004)(6506007)(6486002)(54906003)(38100700002)(66946007)(66476007)(26005)(316002)(8676002)(86362001)(6512007)(83380400001)(6916009)(66556008)(4326008)(82960400001)(7416002)(5660300002)(186003)(41300700001)(8936002)(2906002)(1076003)(36756003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U2ZsMzlveVFqQ1BIbnFpUmRPVzBvMGxvRGlpTlZWSGJjV1Q1N2R2b05Memdw?=
 =?utf-8?B?dWxtTTM5MVVZM0ZCVFh4TDRpMXBYUi84cXVsMVRnNGVieUVzMVBjQTYwYlpX?=
 =?utf-8?B?RDRKUkprS3QrakM5V1gvNG9BYi9UTE85cXQzOGxLZE50bUNqVUZnanRTNWhh?=
 =?utf-8?B?Rmxtc3M4aTdKcHYycFdNdG1EY01vYnEycktFZEJQYkdtNEdydnZQVXBZdzNU?=
 =?utf-8?B?RStCY2FQYWZoM29SaFNKZmlUSzlkMzlZbi9Td28wWDROdEF6RmQwQnBVKzgz?=
 =?utf-8?B?cnlhOE5NZWFIQjlvOFlkS04zaXhSRTRKVGI0TnA4RDVYK2lyOEtyejhLZ25x?=
 =?utf-8?B?ejVkZzFuSm1RN0U5TXNHZGJuZzVKVitRcUFLeXpRL2lZNXJ5b1kxWm9nbTli?=
 =?utf-8?B?TmZmR2dBcndVSkU4TGlVeHpvS1NNYzBqZjV4c2ZDQWZEbDZtK1AvNHhsK2dV?=
 =?utf-8?B?MmNVR1NCNmdjbGZhVTdXQmNjTkdLUVYxQ0pWZ2FwSUlHdlBOOVk2SjYwNDhQ?=
 =?utf-8?B?QVJYK0tVNzdjME5Eb1RZSkZVMFdScmFITjN6dFEraFJ4a0VZMC92K0d1RnV4?=
 =?utf-8?B?bVBmeFROZjAvdTZaSHlWTnNrbFRpcGNJNUw4ZTNZS21ZcG1CMW9BYXBGNFdw?=
 =?utf-8?B?REl2cWV6QWFxZXROQW51VFFaUkUrVE1QdVk2WDVkckpSSys3b3RCTEdFalF1?=
 =?utf-8?B?azlseHp4eEdGeU9MTmtaa3hLSFM5Nk5LNXduaGR4dzFCaXFQSlAzNytVMzE4?=
 =?utf-8?B?aWswaEZDMjJDYVl3eXBIVnFRQ0lWa0piVkJ5OG4wODQwd3g1eDRXYmQrRkpM?=
 =?utf-8?B?Mmg2RzYrem1QNlJHSGtuUXBTaThkYU5adERvNStjbng1SDJXTG5mSCtFVWxE?=
 =?utf-8?B?ZFFFMEtXSXM3SEY0OTNjL0tDWE9DdWhKQ21GOVVLSUs1akZwd3VTbVNHdGM2?=
 =?utf-8?B?dXpKZVVERGVIRU83R0hZd0I2Y2MxNTNmL2ZOc2lJZURDK0VSTVlQWGY0V2w3?=
 =?utf-8?B?MlU3ZlNOVHVSdk5WbUVMSUVUUzNxdEJXMkFldFI5QVZmZFZVY25VRzVjQWxu?=
 =?utf-8?B?cUlkYjh1R3gvYjRaM2dEcVVGeXhHYTBGUk5HaEZuNGtyZWJ5aWdiVjJWN2Z1?=
 =?utf-8?B?b0E0U05XRmcwdXZvaFNtempTTFRBcnFTUXAvQW81OGg5cVpiNjgrY29taWlW?=
 =?utf-8?B?YVNSL0huS3NqcXlST2h2SzJTMzFMeHhaWWtBV0ZHYUdPZmwwc2FMYk40ZHJw?=
 =?utf-8?B?clZ1NnZkRWllYUllbVdDVmFrcTQyUjJaTEpGKzZzclV5bUdtVDlRMEEwV056?=
 =?utf-8?B?SEc3OEorM3ZrZkRrRHY0Q0NJeDh2ZkFaRWtPYVVEMUNlbDkvNmprOThsbFl4?=
 =?utf-8?B?ZStwK2NHeWpzelBRNHlUaS9tdTlKdEdpVCtOVncvNjQ5Yk1vdmhJSVBUSzVp?=
 =?utf-8?B?Y1hlOGZNRk9Yd0pteFJYZlRuaFBKVDByMXJIR1hITmNvbnlSb0hOM2ZySFd1?=
 =?utf-8?B?elBSU3gxUS9TSityM0xXTkpJMTNrN3Fwa1pyclhqdjZIcFpXN2RzUXozWkF5?=
 =?utf-8?B?RExyM2FBaXFVVnB6RTJ6em5sYjl4Vzd5M2NRSTRVbnc5azZXbTNaM3cxUFpa?=
 =?utf-8?B?TTFHRVFJYXY1UGtpMmdJKyt0Z3ZJVGRpWWswN0gxWnQ1MW1uV3BSbFM2TmNC?=
 =?utf-8?B?Q3dGTC9qeTJzTWQ1aURoWmc1ejBLSDJBdy9OTGdBc0cxd1BvTUg2dU9oWUFR?=
 =?utf-8?B?UEFkUlhJZDVNY0QxdkllVXByVUVQWmpicThtUmNmeXF5WmRLUHJXb3Y4b3pi?=
 =?utf-8?B?ZFBmNUoyT3o5T29QbVZGdElJd1FDN0U5ejdHY21YcDhXL3pMeWNhYUFWVlgz?=
 =?utf-8?B?M012cDdLWWx3ZlQwYTdlYmF2OUZra0FJNk5FTjBxTUJJNEhjNGE3d0RHMUpL?=
 =?utf-8?B?b0p2L2dydmdnM092OWJHRWphdjBkYTNuMnVwUGRqcktkRVdJN2JKb0p2OXg4?=
 =?utf-8?B?ck1laG82QVdOdnB5Q1FkUU1DeWZGOU1FWXJqRXlLVUhteXh1cForRTRwZTJU?=
 =?utf-8?B?YktRNXU0QTlOSjZ4Vk95c1VaY2VJNS9XaXJuZjFZY3RkYlJTeExiTE9OS0tn?=
 =?utf-8?Q?C3HmYVmPnXyqkGobWoj01hTtV?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?WjZqeGJPWmJuWFVDTStIQkhCTXhiZFRRSEtaZ01aTWl2QjJwY2dadWZyRHVL?=
 =?utf-8?B?THJLS21adDlON0QxMlMzZTFlNDBaTk1HcFQzeVI1SXgyb1hXOHhCK0Vyd1ZX?=
 =?utf-8?B?c0swTWNwMWRBdGhRK3VGakZJRE9QQzdzc1Yzd2V2L2RLbHZSZXdvb05mVWlp?=
 =?utf-8?B?RU13S01XZmhwQlN5NXVzclJkNzVKL1I4dDFaTFkxajJrc3VoYzRqUVpjTm5p?=
 =?utf-8?B?VVFNa2NTbG9sU292bGVPanJ1MGpwU3k5NDMvdmtTM2U3cm9Nd1JtdE1UVmx0?=
 =?utf-8?B?cjl1QVNxemxOYTRSc3Z3ZURiSFFLVFZNd0JIMERjQXFMd1dZSUhITktqNXJm?=
 =?utf-8?B?UlFMSVMybm9PaWJETU5FekZRWUZDdmdwbEZCb2ZMcTNyRmVWUm5KVVhUdjZ4?=
 =?utf-8?B?U0lUd2tOT3BvRXBGVmgxMXNvZERHNFE3aUtlR1NkN2NuYVR4NGdPKzBBVFZX?=
 =?utf-8?B?eEFHYU9PeGFKTnJxRVpzNTZTV083M2pLL1VKekQ0bU9QWjQvdE9Xa3Y5Q3V0?=
 =?utf-8?B?VjU3U3BVSVkrWFBwU3ZIYmduWHVhdFRPd2ZvcC9lZHdzaWVLMmw1NHJRNDdI?=
 =?utf-8?B?UkJrY25Zb21xU0VHdWcrNllDNmUvcEptSmhuRnZwWWpidWVHeUhBRkxNRjlU?=
 =?utf-8?B?Mkp0YXF3aHFUaElBczZRYUJOSmh5YTRsY21NY2piSk8vR3lhMXNYV2QzL1NY?=
 =?utf-8?B?UTZYUTNUcm4zT2dwUG9RWFJyY0g1SmN3WW1Sak00dlpGVEFqZGk0b28vbGZz?=
 =?utf-8?B?aWV2cGhZRkUzTU1lWm0wOGE4N3dLRWh3aE8rWnBIQ21sNW9xNWJDVVh6THBU?=
 =?utf-8?B?ZWZkUU9TZTA5YWpja2M0dHg5RHgyVm93d1I5Q1ZqMVBTUHJsVGloVVkyTHBG?=
 =?utf-8?B?VkxUQUVPS2IxMk9nTUx4NGxIVmNKUGVxSVI0M2Y0K2xPZzljenFpSkErTnZR?=
 =?utf-8?B?UlcvN3p2eWR2Q0xtZG1iNW1RMkhmUXh2ZTdtekFQQXJiakJQdnlBYkxINHNL?=
 =?utf-8?B?dER6c0dBc2pHNHdWNXZURHkrWUpyM0tHbVZ1Sm1SR1JBNXlaMi9OajM1RzJ5?=
 =?utf-8?B?SVdqQUFhNndsOExtMW1sSXk5NGhvc0MwUmdQNlp6OHNsd3N6Tzd2RXZXZ0ZM?=
 =?utf-8?B?SmdXR0tEcFl4ZHBaN0xLUzVpRGlVRk42NGVyWjRyZmlHTWxrU2I0dWpkY0pw?=
 =?utf-8?B?MEV3T3Q0NldrSW1wTEFwdmw3Wis4Q3lWQlp5ejVpMDMwd29xVEZ6RlkyYzFi?=
 =?utf-8?B?VzBEcFp1dSt4bkZXVW5uWDMycWdqanJyN2N1bHVWbFI1QzMybGZaNGJHdE4w?=
 =?utf-8?B?eTZNYTVyL1ZHQzArbUV1OFJlalNPV1RHODBoZUZEaVV2UW9vejltekE2d2xY?=
 =?utf-8?B?YXJrc0Zxd1ZDRXpITlJ0aDlSamNPSUhuNlg2TXpuYmhwMS9jdi9KWXV2aDR3?=
 =?utf-8?B?TGRFVFVrNWxjd1ZYeDc3VVVsem1UMVh2Z1dwaGdXYkoweU1pWk8zUnVJejh1?=
 =?utf-8?B?Tk16NGZDSmJVd1A2L2xMVllaL0J0TTg0bndaR0x0N0J0NG1JMCsxZnlOZXdM?=
 =?utf-8?B?WUZOMmEvMm41d2FZeVoyd09KLzlTZi9wVjhNUUpnNXRlZnQxUFhXWi9ZLzUx?=
 =?utf-8?B?NGhRY0pNWXdSK2RTYVhBU2dicmtOWEE9PQ==?=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dccdf515-9599-4924-fbb9-08dacbabd331
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR03MB6360.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 10:33:27.1804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j9QCyLUjfjXEGBx7UlRAyBtNMf5Q6/y0WQFVbwDgLK1TWirOJP5fSUmLL397XKna5j2ailLu9tQha84uY7bT+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR03MB6102
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The Processor _PDC buffer bits notify ACPI of the OS capabilities, and
so ACPI can adjust the return of other Processor methods taking the OS
capabilities into account.

When Linux is running as a Xen dom0, it's the hypervisor the entity
in charge of processor power management, and hence Xen needs to make
sure the capabilities reported in the _PDC buffer match the
capabilities of the driver in Xen.

Introduce a small helper to sanitize the buffer when running as Xen
dom0.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Cc: stable@vger.kernel.org
---
 arch/x86/include/asm/xen/hypervisor.h |  2 ++
 arch/x86/xen/enlighten.c              | 17 +++++++++++++++++
 drivers/acpi/processor_pdc.c          |  8 ++++++++
 3 files changed, 27 insertions(+)

diff --git a/arch/x86/include/asm/xen/hypervisor.h b/arch/x86/include/asm/xen/hypervisor.h
index b9f512138043..b4ed90ef5e68 100644
--- a/arch/x86/include/asm/xen/hypervisor.h
+++ b/arch/x86/include/asm/xen/hypervisor.h
@@ -63,12 +63,14 @@ void __init mem_map_via_hcall(struct boot_params *boot_params_p);
 
 #ifdef CONFIG_XEN_DOM0
 bool __init xen_processor_present(uint32_t acpi_id);
+void xen_sanitize_pdc(uint32_t *buf);
 #else
 static inline bool xen_processor_present(uint32_t acpi_id)
 {
 	BUG();
 	return false;
 }
+static inline void xen_sanitize_pdc(uint32_t *buf) { BUG(); }
 #endif
 
 #endif /* _ASM_X86_XEN_HYPERVISOR_H */
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index d4c44361a26c..394dd6675113 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -372,4 +372,21 @@ bool __init xen_processor_present(uint32_t acpi_id)
 
 	return false;
 }
+
+void xen_sanitize_pdc(uint32_t *buf)
+{
+	struct xen_platform_op op = {
+		.cmd			= XENPF_set_processor_pminfo,
+		.interface_version	= XENPF_INTERFACE_VERSION,
+		.u.set_pminfo.id	= -1,
+		.u.set_pminfo.type	= XEN_PM_PDC,
+	};
+	int ret;
+
+	set_xen_guest_handle(op.u.set_pminfo.pdc, buf);
+	ret = HYPERVISOR_platform_op(&op);
+	if (ret)
+		pr_info("sanitize of _PDC buffer bits from Xen failed: %d\n",
+		        ret);
+}
 #endif
diff --git a/drivers/acpi/processor_pdc.c b/drivers/acpi/processor_pdc.c
index 18fb04523f93..58f4c208517a 100644
--- a/drivers/acpi/processor_pdc.c
+++ b/drivers/acpi/processor_pdc.c
@@ -137,6 +137,14 @@ acpi_processor_eval_pdc(acpi_handle handle, struct acpi_object_list *pdc_in)
 		buffer[2] &= ~(ACPI_PDC_C_C2C3_FFH | ACPI_PDC_C_C1_FFH);
 
 	}
+	if (xen_initial_domain())
+		/*
+		 * When Linux is running as Xen dom0 it's the hypervisor the
+		 * entity in charge of the processor power management, and so
+		 * Xen needs to check the OS capabilities reported in the _PDC
+		 * buffer matches what the hypervisor driver supports.
+		 */
+		xen_sanitize_pdc((uint32_t *)pdc_in->pointer->buffer.pointer);
 	status = acpi_evaluate_object(handle, "_PDC", pdc_in, NULL);
 
 	if (ACPI_FAILURE(status))
-- 
2.37.3

