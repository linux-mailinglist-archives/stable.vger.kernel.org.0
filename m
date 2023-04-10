Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF1246DC72E
	for <lists+stable@lfdr.de>; Mon, 10 Apr 2023 15:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbjDJNNd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 09:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbjDJNNb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 09:13:31 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF78E55BA;
        Mon, 10 Apr 2023 06:13:29 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33ACo0Qh002751;
        Mon, 10 Apr 2023 13:13:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2022-7-12;
 bh=tqjR24dulXcubzU3N9mythttLC5Hsbq9He86L/610Ow=;
 b=P3atcdEBgim5BOy9N7gR0KVbmv1l/vmJ1svHaMcwx7Sg1FaGpP8PuXAY5cTFb51EwD/m
 0q+TrG6JoKVNtOCBk5SYaEy4nyrcooXT6WWsD8nRoYRr2pBcq8d/k7uY9lr+yBh7IsBM
 sjLdd+iasps6JEnmYPqXNetrTmC95yMCNUcFKwd2qfcPklQkNNoagvCDam9eETY6c9J9
 6sjvcr+ogwyGtA4mB21e1f6bdkDxb0L5zxe7990tOiEePqj8S49es1nah235sCDS0ihn
 fYG5XXx8YBHZmZFny+l9A1A2ECsBT425y5RkGzuvRBIxFsTQY6cP5mBySZvahA3OQ94Y HQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0eq2sbj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Apr 2023 13:13:04 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33ABRvS0001726;
        Mon, 10 Apr 2023 13:13:04 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3puwe55a2s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Apr 2023 13:13:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wb/Kg9izQQG7c0bnqRM28V9E9i/sM/Zt7qdOsZiLSgvPJCUI/hMicpGPWA0dNXk/gB2d873BAyW5tyRTE3yfNW5XLkpYIfO9CX21+wbh/pbKYwEpW5l6vqrFarJ+Vu/7k/eK8P0WzYJCZpMUCyvqVwV0wcmszD8ZV7C39t8V09LeDLqZcKXKVymLDSXiJwkEbwVkwoQJ5OXq8m9hVbyxG50+0Cbg+4O3WikM7yWjNG32+pAuS4EYGHiPzSOBvs01kZjGd23bFP+j0hbPJvRXaG65wbv6XlPiveO+myegmJfalfmD7AHQ0L1w1ZMlEs6lfFw7wTElUF7vQykAME6p1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tqjR24dulXcubzU3N9mythttLC5Hsbq9He86L/610Ow=;
 b=NnoBWBrvrM4o6IkAxY/VmAz1xQZuDouqT+YlgdmtQxPsZC9yXVuq1idmituP/KoTyiTea/3jGV1n8vjJBWtXB/NNebNgrAXK030PyI1iiPhbJCy8pIt/wNQKMARD5NRtp+/p2TxlzSJ1kMmlW1atIWrnsTsK800PmVDOo0+fsOGoXeVkV+TLeTdlm0Ze94vIhl/O8wkL2XnLk3LyGWGXRCP5SLsTzC7JzwejUh2KlKAff3sifY2kxfuxif5fOMTdZz6PI+Dz2G/e6RqTcgDLyG+kabVNT+BBDQh4uK64/0S0RUrDksfdHL891X8K8HW+AGlxRPFmTTSRlWFwg5QweA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tqjR24dulXcubzU3N9mythttLC5Hsbq9He86L/610Ow=;
 b=MJJi9WiIl5N+bET8kxLml1NNwPYGah6MFZyIkRfSVK3dZAfIEhrqY+Vjs9D/WGRZwlMHbG90bSKBEm6ADmALyY0GDuV/MzH6LGAjciKLbdJ1FEFaxLB4QiOZzRwQMRd5VDS1doEbl1TBP9Ulawb2tkj+u6HGvuZfKb+9GaC1ZOs=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by SJ0PR10MB6399.namprd10.prod.outlook.com (2603:10b6:a03:44b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Mon, 10 Apr
 2023 13:13:02 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::8bb9:2bb7:3930:b5da]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::8bb9:2bb7:3930:b5da%7]) with mapi id 15.20.6277.035; Mon, 10 Apr 2023
 13:13:01 +0000
Date:   Mon, 10 Apr 2023 09:12:58 -0400
From:   "Liam R. Howlett" <Liam.Howlett@Oracle.com>
To:     Peng Zhang <perlyzhang@gmail.com>
Cc:     Peng Zhang <zhangpeng.00@bytedance.com>, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        maple-tree@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] maple_tree: Fix a potential memory leak, OOB access,
 or other unpredictable bug
Message-ID: <20230410131258.txkiqa5eudgsrmht@revolver>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
        Peng Zhang <perlyzhang@gmail.com>,
        Peng Zhang <zhangpeng.00@bytedance.com>, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        maple-tree@lists.infradead.org, stable@vger.kernel.org
References: <20230407040718.99064-1-zhangpeng.00@bytedance.com>
 <20230407040718.99064-2-zhangpeng.00@bytedance.com>
 <20230410124331.kijufkik2qlxoxjz@revolver>
 <84c50299-5b5b-867e-1e96-2d3a0c6ade2a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <84c50299-5b5b-867e-1e96-2d3a0c6ade2a@gmail.com>
User-Agent: NeoMutt/20220429
X-ClientProxiedBy: YT1PR01CA0064.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2e::33) To SN6PR10MB3022.namprd10.prod.outlook.com
 (2603:10b6:805:d8::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:EE_|SJ0PR10MB6399:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f61d187-f95d-49c2-6900-08db39c54fe4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k+36yNk+qO3DaDWXM56KPyLfu2eY9DRVtR8EoOj3kxqkCgsxSFwtCnHTIMVJJBq7tMUxGzVV+Ck1M8dPH/Q2iMW4jTrfBWWTGxs157vwKiH7AAKVg/C9F6nK2cC5lOM1pcslvOc8UnrHI1GYWHdnx4wk+5IyIjsJPkESkhpHOs/KPgdI65cZazUQvY5cPzJjf3bZKhFvM175zQ9Vp0kCFMoNA5/S1SbfaxSD9+LkBofBbq2BCO54EnbzwiqZRJyzqzLRNkxu+w53ihWgRFINK5O14do+cCcjJVXCsYNVL4frWuZtP8g8qQxtIDCVA44nqs8d3vukOPiepJ5TfAgO9P0nLf6nezOk4K+qOs3epgwD1bkFytGMFuI8M3n9gnmcpVdBUe495Tukt3rlwUKd8cmwR5moPrprEhuYaGmOyRVE9WD//cA7SLLk/f63vAOPKCSmIyYekOj4Ybh2SPgzh3aF4nzIphBWX47dHOTtnEchlFO1El+P0yAblulHNdKx2RxcKs4dte3j4qng8TZrkapK4AbOj4JVLcHCeEN8THNbsCDmD2mP5LgXfINbm/2o
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(376002)(136003)(39860400002)(346002)(366004)(451199021)(66476007)(6916009)(66946007)(66556008)(4326008)(478600001)(316002)(5660300002)(41300700001)(8936002)(38100700002)(8676002)(186003)(83380400001)(6486002)(6666004)(9686003)(6512007)(6506007)(26005)(1076003)(33716001)(86362001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VExiYy90ZmcvcVRiZ2FoTTR3WFQxblZhTFdSaklNcFArbzFrWkVyc0d0YWFC?=
 =?utf-8?B?YVI5bUM2NUJua0NBR1B5dE9WejQ0RlFrcUFQcktWSTVPRDlKRkNTMk94d2pn?=
 =?utf-8?B?NnZicFd0Y1Z0djdnRDgwNkVtOVM5cEJGa1R2RG5UYU01MnBrTFRrZE14UGRI?=
 =?utf-8?B?NXFXU0RDdHVEblF3V1BadjVicytoQXk3V3JXMzhVRm9xY1VUNlBsQWlmWUpw?=
 =?utf-8?B?cmxMb2ZCcnl2WlNhNld3b29vczI5MzJldzdkV01YaEFBMEpEd3IwYWwzMllr?=
 =?utf-8?B?elZQcEhoN2pXcHNqWTF5U3p0b0pWTlpaUUtDZVk4OTZZZjhjNFRhWWVFRmtq?=
 =?utf-8?B?WXkwTlplU0pIUkpRQnNEcXFVWHVVNGczVW5VN25xd3RFUmgwNFl1aUg4VDVG?=
 =?utf-8?B?cmdLdERZNjhvemlnVys5OWFoTGkxOUJuQVZwTjBpVmMxeDE0R0hzdDJaMitS?=
 =?utf-8?B?SlNNZmlKYUFwdkhRbnhBVDNiQWdDSHhnWWhWWmZpMjhKeURWZHdCeUF5T1pX?=
 =?utf-8?B?UlcvajgyeWFzZGV1eFVOOHFkWU1HcDB6Ri9nUjdBejJuUUNiSnhuRG5wQWJx?=
 =?utf-8?B?OWd1OUZNejhMVzNDazZURGhKR0tjeFc5bXVENjVQOGhkWm9IZDZ4REVMSWdy?=
 =?utf-8?B?VlN1UHRaN0hmdmZqV2RSM1Z5amZSOHVQTUR3OWM2RzZaTUFSQUF0eVFxTzht?=
 =?utf-8?B?RkdBcEkrN0Q3LzIxeXFvajdSY2ZvVkpvK04ybHkwR2kyb0RseWM1Q0Q5VFFr?=
 =?utf-8?B?Y2NhelFwNjFqNUd0NzM4aFI2YnZKUlh1dTJGVFFGdEdla0xtdE1MRkdIaWJs?=
 =?utf-8?B?OTVyazY0RTVDTVJJbUJoTzE3NkRqT3p3cGxjMU9NbVY5Vkl0ZWRSQjAwMFBz?=
 =?utf-8?B?UGV3eDc2czBEMWN5WkZJeDF2Mkw3NUdmZDV4N2E3UzdpQjNtN3dlOGQ0OXhC?=
 =?utf-8?B?bkU5M3BTc21nL0w2OU1CQW9jejhPMnkrZzRJeVpmQy92L2xMc0hHNituVE42?=
 =?utf-8?B?QTgydkdaQ1Zxd3YyblVIaFdweFhFRUNtSjhiSVRZQmJkRlBYQ2c3SXUrNVlW?=
 =?utf-8?B?WHFXN25taDZuYVl3eW92RXQ5TVNIMy9XRFFURVh3VyttRm9XT3lvZzR1LzFt?=
 =?utf-8?B?allpZGhwVHN5Y2RoODJCU1Vtc2FJR0VmajMzS2M4amIrKy9tS1RJV1E0eU1h?=
 =?utf-8?B?VmFmUW0zODFaUzBudTBOR2pkaHlhVE1NTU56V2psbE5pTk5WVmR5S1djbFlU?=
 =?utf-8?B?TEo2NW1yK0pCUzRQRHRMV3A4Y2ZIMituaWJhazIyRjRoQ3JGTnpDWjdvQU1J?=
 =?utf-8?B?NDA0SllXd2dWemxaV3Z1NG80bWQ2WjN3Vnk1dU5HZVpIbmVnU2dmUTR3Sk5u?=
 =?utf-8?B?NHJFRmVuYnU4aGJQTDhGcEpyWEs4SHVNdWdjQzJjdGgzeEdTcXhGWFF6cUpj?=
 =?utf-8?B?Y1gxVVBQQUlBdzJtdDJyNnFZeTRwUldYVkg0a2xQUEtEYlF6T3lDamluOURz?=
 =?utf-8?B?NURjc012OUlQZTZPbVVKQWlGTWh0ZjRqdHJhYml2S1AzaUhjQTJoYU8rcENV?=
 =?utf-8?B?bENQSnd4NFJDbXJ0RTBqeElmVE9GeG96Vkw0NTNiWnByMFF2Wjdza0I3eEl5?=
 =?utf-8?B?Ni9pZ1RNclFQZUFEemY2RkZBV0loWFBaVXVkelpGZ1Q3Q1h4SjZ1bXRQWHN5?=
 =?utf-8?B?ZVJ4RWdRcEl1RVpkVjUyZmI5RzFnbDRYaUpzREdyVlJydnF6N0djayswZjRh?=
 =?utf-8?B?UG8zVTZlQlVRNXlLRkpQZ3phVEkyV0dGWmtyS3pQSlRnbjNDOUNxZXVIWmw3?=
 =?utf-8?B?K2tOOUluRXRQTDAvTG43UVJtODBrKzNVZUtTdXJjUUJySml1Mit6clUrTXRR?=
 =?utf-8?B?b0pvK0p2Tk9aUmt0N3BiaS9oeFZaK294ejlFbHljT2VMMjA3cFNEeTdRaTU5?=
 =?utf-8?B?bkhYM0R4eHNtV1hBSm1NTVBQR0VlallTSVBGWjFZQ1FRR1A5YkJjaWhVdWhk?=
 =?utf-8?B?SUY0b2s5NkNHSkpWcUdEazlKbUFDMWFuNWE3cWQrMjNwZ1ZqTElKOUtOUmtU?=
 =?utf-8?B?K2tHRzNTa2p3ZmszYnhrdHlvT1NnN1A2RXlvSk5ReVpyQlV1dHA4R2JrdjlX?=
 =?utf-8?B?aWN1bXR0M1M2azZDY1NReFFNYWxrdXppa0I3aGlBWGVMTWpYVEVWTElsaFhW?=
 =?utf-8?B?V1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?OWxpT3dTaGE0S2ZqZlZ5YmNLN2V2dWFSL2R0ck90ZGE0TnhLZWpGbE9Ock51?=
 =?utf-8?B?ZXBlMWY2VDRCNjJUR3FBZGhvZzc5MkVRTWdGM0UybmFNV09BZWpUNW5SZ0Yr?=
 =?utf-8?B?YjRNYjc3R005anhlVFlJemwzVjR5ZHFldzBIMXd5aTR3dktvYit1dHFlK1da?=
 =?utf-8?B?STJ0blJFR3RydEpDSmgwTysyZXZkcWY0aDdkMFY4VmdMaUQ0Wmx6RmMyZ0dn?=
 =?utf-8?B?LzlZb1drMGFIT0lvcEo0MzZ2eGltL2tmaDB5QUpMNkRJS1I2ektkRHdEUG9j?=
 =?utf-8?B?eDkyQlY1Rzh3eE1VbjlVT0VHTG9JQ0VpUnNpRS9YR29lUXdKaGtsTlpKbjl6?=
 =?utf-8?B?S2dldWV2SlUrMU5BdGZqNEhVOXQ2QStiamoyZlhlbkRKZUdvdFZlUUtoNFN5?=
 =?utf-8?B?NzlYUzREQkN6b3A1UUFxZ2hZWHIvSldvRm9kdXBLbmhxZ2FsQ2dQZEt1clZi?=
 =?utf-8?B?QUJtNnNYTnIydmErSlhuT1JCdlY3Z2lxMmhoUWlPMWF5bjNpN1NRSmt3cnRj?=
 =?utf-8?B?dzM2NDBwZjlrbXNwTDVxdkNadWxhN3d3bzNDZmhkM0EwU0JyaGhsdGI5cS9S?=
 =?utf-8?B?cWVZbmlBZFdIdW50bGdDOTJzRGpNVDFXUkcxaFN1Uk42enorS0RwQWlZRTVx?=
 =?utf-8?B?RG5ZYlpwNXV4VEREVDJMaWxvMmZYU0pwbEFPc2NJRUpadjh3NzFhRGVJT3Vr?=
 =?utf-8?B?di8zOVBiQUdYZlJOLzdjL0NKNWhYZ3E4aFVKMDN6WnFqMmdnMncyM0xteG1i?=
 =?utf-8?B?MTBtRy81b0UvNUhkU1JNTGR0ekRHQ0JqVVhJb1hNOTlxUjFGYktPQUVrRVFM?=
 =?utf-8?B?b0NlUWZvV0dpQU5EV0F5RnViM3RXSjFDckYxZG9ZaG8vaUwzVmJQWG9HMmpo?=
 =?utf-8?B?RXNqaEtMWmxlTnhWUHdBMWcyU2Y2WWFpWlhFSEhUNXAxdm5zajErdjEydHBN?=
 =?utf-8?B?VUViL1ozdXRhT0t5aUVqMGtYc2xzMW5CT1ZlZ1hWRVFpdkpRRndwblI2L1Zy?=
 =?utf-8?B?TUhUSVFNNWR2RWJYQUR3b2tvRDBubENCM3ptemN4dEJ2dEYyRHBOakFSMUJz?=
 =?utf-8?B?b04ybTJKSkxxV0JDUkRTbEFuOThQdkwwWWFUa1JkdDJ6eEFwa0tRNkh2RGg4?=
 =?utf-8?B?bkdiazZyaXdHelRHQVpFVXBOSmF4M001UGorOEhEeFRSYmFudDZYczYvbTZm?=
 =?utf-8?B?aTlURW9vcmhrbWRSN2N1bUlUbE82OVgzcFpSNEhXNkNhaTMwekhpYlJweU56?=
 =?utf-8?B?dDNDTmVxWVNnME51QWtDYmlTREx0ZVpxQmM4YzVXZ0RNV3FkZz09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f61d187-f95d-49c2-6900-08db39c54fe4
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 13:13:01.6153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E7nSe64BtATdB905FHdhMZLyUpktwdlfICKSUT0bPwzeUK2xHrb2vFT2VOcINn74/31NkO144DjJTY+kJYfTSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6399
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-10_09,2023-04-06_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304100111
X-Proofpoint-GUID: CD4JBnVto8CXDckAz_yWNWch0u6w75UD
X-Proofpoint-ORIG-GUID: CD4JBnVto8CXDckAz_yWNWch0u6w75UD
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* Peng Zhang <perlyzhang@gmail.com> [230410 08:58]:
>=20
> =E5=9C=A8 2023/4/10 20:43, Liam R. Howlett =E5=86=99=E9=81=93:
> > * Peng Zhang <zhangpeng.00@bytedance.com> [230407 00:10]:
> > > In mas_alloc_nodes(), there is such a piece of code:
> > > while (requested) {
> > > 	...
> > > 	node->node_count =3D 0;
> > > 	...
> > > }
> > You don't need to quote code in your commit message since it is
> > available in the change log or in the file itself.
> Ok, I will change it in the next version.
> >=20
> > > "node->node_count =3D 0" means to initialize the node_count field of =
the
> > > new node, but the node may not be a new node. It may be a node that
> > > existed before and node_count has a value, setting it to 0 will cause=
 a
> > > memory leak. At this time, mas->alloc->total will be greater than the
> > > actual number of nodes in the linked list, which may cause many other
> > > errors. For example, out-of-bounds access in mas_pop_node(), and
> > > mas_pop_node() may return addresses that should not be used.
> > > Fix it by initializing node_count only for new nodes.
> > >=20
> > > Fixes: 54a611b60590 ("Maple Tree: add new data structure")
> > > Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
> > > Cc: <stable@vger.kernel.org>
> > > ---
> > >   lib/maple_tree.c | 16 ++++------------
> > >   1 file changed, 4 insertions(+), 12 deletions(-)
> > >=20
> > > diff --git a/lib/maple_tree.c b/lib/maple_tree.c
> > > index 65fd861b30e1..9e25b3215803 100644
> > > --- a/lib/maple_tree.c
> > > +++ b/lib/maple_tree.c
> > > @@ -1249,26 +1249,18 @@ static inline void mas_alloc_nodes(struct ma_=
state *mas, gfp_t gfp)
> > >   	node =3D mas->alloc;
> > >   	node->request_count =3D 0;
> > >   	while (requested) {
> > > -		max_req =3D MAPLE_ALLOC_SLOTS;
> > > -		if (node->node_count) {
> > > -			unsigned int offset =3D node->node_count;
> > > -
> > > -			slots =3D (void **)&node->slot[offset];
> > > -			max_req -=3D offset;
> > > -		} else {
> > > -			slots =3D (void **)&node->slot;
> > > -		}
> > > -
> > > +		max_req =3D MAPLE_ALLOC_SLOTS - node->node_count;
> > > +		slots =3D (void **)&node->slot[node->node_count];
> > Thanks, this is much cleaner.
> >=20
> > >   		max_req =3D min(requested, max_req);
> > >   		count =3D mt_alloc_bulk(gfp, max_req, slots);
> > >   		if (!count)
> > >   			goto nomem_bulk;
> > > +		if (node->node_count =3D=3D 0)
> > > +			node->slot[0]->node_count =3D 0;
> > >   		node->node_count +=3D count;
> > >   		allocated +=3D count;
> > >   		node =3D node->slot[0];
> > > -		node->node_count =3D 0;
> > > -		node->request_count =3D 0;
> > Why are we not clearing request_count anymore?
> Because the node pointed to by the variable "node"
> must not be the head node of the linked list at
> this time, we only need to maintain the information
> of the head node.

Right, at this time it is not the head node, but could it become the
head node with invalid data?  I think it can, because we don't
explicitly set it in mas_pop_node()?

In any case, be sure to mention that you make a change like this in the
change log, like "Drop setting the resquest_count as it is unnecessary
because.." in a new paragraph, so that it is not missed.


> >=20
> > >   		requested -=3D count;
> > >   	}
> > >   	mas->alloc->total =3D allocated;
> > > --=20
> > > 2.20.1
> > >=20
