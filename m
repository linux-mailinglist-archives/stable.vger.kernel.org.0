Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFFEA27862D
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 13:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728150AbgIYLnb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 07:43:31 -0400
Received: from mail-dm6nam10on2050.outbound.protection.outlook.com ([40.107.93.50]:23369
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726368AbgIYLnb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 07:43:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CCNAFYF6hEVEH07JRV0U6i7DkkZ6ituEZfJHxm8+V6yw0nphtGci6/nDL7Zcj6L4gWGUU2e9XP+9B5VqTr80SWTSOVlyu3poI0fh14iVsC5PAHnbt3zkHKGjH8pzfx6rAi4t9xMnWrLm/e69/bny8g1cUo24ob8IIy1sCLkzwChvz6U0MKLRVhEBQRZ+1k1Y+CF4rpvfAFNVA/A/U0wf81K7ogtOg/fjj/i0HARc8qirwbCJsZ0rxxhShiciVw+eeS/sHAtwoVkzNXaGvR4xmONSLVDSf0oNO/xT9DbKTKZQX80yrjWNSYKEtIlxA20RqHD1JpYusulHTFIVll08pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zh87nfaock6qTLxDxgl7TfX2UQbAG+Y6UX8nXBBp5+o=;
 b=BDuexiR4yWSEPwDdz/roBpZBzBfiJDFgzGKoBCuVcyAIrPkQbglpLIsisbVRnQzxfZryr5kdtEMjAAwe2eXGssqdzlY/Bw6PgJMio5Kh4+QBR1fg1KH8pmhs/ImvCaoSt6289XGeTJsBpNj9DZsPFkyrnXrSthXIE5AFSmuc4tqVg82KayAyYZqbYjlAK85Ptxq5kNYTouy/KlTMsxMLxAB968QPVMrOYrrRwMxJERXP+S65BccjJaM8e/BTb203HFbgtbTKtDEvDBK7PlqE/8YjKaV1gmBESzV+Pwh6FVoelKdr2X+Nt8x9pMTjkq7fQLc8+1+oV9r1CnM8HnU3Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zh87nfaock6qTLxDxgl7TfX2UQbAG+Y6UX8nXBBp5+o=;
 b=rm9o2ig2d4XEk13GKzfhA/rYiYXocGY+dPLrmw0HrtTgCR3XfJLLkZByn8lrEAWVC63Ciw8hkBj3O9eeuhwieNe6x8vDQVhUKCHrT1qMi0lBYQsOBIqu6jHpRK0eA/Fta5gxJUZ+T6nBGnGpMjXX1JOHW8D/YppmrWVDYKMwzh4=
Authentication-Results: 8bytes.org; dkim=none (message not signed)
 header.d=none;8bytes.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1163.namprd12.prod.outlook.com (2603:10b6:3:7a::18) by
 DM6PR12MB4957.namprd12.prod.outlook.com (2603:10b6:5:20d::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3412.20; Fri, 25 Sep 2020 11:43:29 +0000
Received: from DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::48cf:d69:d457:1b1e]) by DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::48cf:d69:d457:1b1e%5]) with mapi id 15.20.3412.024; Fri, 25 Sep 2020
 11:43:29 +0000
Subject: Re: Patch "iommu/amd: Use cmpxchg_double() when updating 128-bit
 IRTE" has been added to the 5.8-stable tree
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>
References: <20200907030521.EF51E2075A@mail.kernel.org>
 <831ea167-0e19-3557-8812-b42a8ef23d1f@amd.com>
 <20200917143529.GG3941575@kroah.com>
 <d84863a7-6361-7353-8bda-2a5d034a2c2f@amd.com>
Message-ID: <24701d55-fc03-be77-3abc-3194a65b4fc5@amd.com>
Date:   Fri, 25 Sep 2020 18:43:08 +0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
In-Reply-To: <d84863a7-6361-7353-8bda-2a5d034a2c2f@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.80.7]
X-ClientProxiedBy: KU1PR03CA0022.apcprd03.prod.outlook.com
 (2603:1096:802:18::34) To DM5PR12MB1163.namprd12.prod.outlook.com
 (2603:10b6:3:7a::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Suravees-MacBook-Pro.local (165.204.80.7) by KU1PR03CA0022.apcprd03.prod.outlook.com (2603:1096:802:18::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.18 via Frontend Transport; Fri, 25 Sep 2020 11:43:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 760ba866-3705-493f-efae-08d8614838be
X-MS-TrafficTypeDiagnostic: DM6PR12MB4957:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4957780741AB893928339DB9F3360@DM6PR12MB4957.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ES86EpJtOO9RWvs67pCzY/9fF7Lqgpj1oLteUAor4lKgXdaUGPA22C7bmGU5Ge5PCOzgXS+UHeeneN0Evwqyy6ebRkgyzx2uBlWhEI7a0SEy9jMqE9i5eK0c/niYTT4MhgMVnZV8bkOPzA3MyPtXcaV/NyFcws03JxuELKC3qimHt29yWasc5A7JZVmZsHRXAiwHEWrCAqRudAnVEbmtfdKfJLS1mP4bSbsdpol0rhF03goe8itjCHrKjTe/uMUjqq9gYlG/jypedXWFtQLcaieyos5NH14MbmQPPt3cwvATfhyNLZO9xEo5Kdyoc9ZMCD+6GBNkAdqrsOfPcK3ZJ1OYwE0rJ5yHG+GmskkkYENKPvZEo4j5VmVECq9/jB00OxP9o0cV2cnN4ZH0OppJphCk7R69OTH9nS33c7fhJJwjKpN0bGLtb7Dlp3WE6YMS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(136003)(366004)(376002)(396003)(66476007)(66556008)(6506007)(6666004)(66946007)(86362001)(478600001)(4744005)(54906003)(8676002)(83380400001)(8936002)(6916009)(316002)(53546011)(31696002)(2906002)(52116002)(31686004)(36756003)(5660300002)(4326008)(6512007)(16526019)(6486002)(44832011)(26005)(2616005)(956004)(186003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: l5GLJMtjoDLacvDfe0qnoiqGP4nJ7valfvfSw6raTgPitCqhOH0K0Y5coSSKjDlE0oAVqe0b5C1pI7X972rVF2Ucx2XmGFFJhmDyCc/OI8bE9XfAP0L4qGvFQ2nA3+QyyfiuHwLedQ0pJYtF8bCzXo8wILdU3QfeJaRe0OnHd7DJ9U+zknmM+nNOG+k6+5xyQ/Kag4Tsy6xjEAPQ0wr/+Ggr8IOPCY0oQN/cgIt0Xo6kKrGrx9aOLx7yKxnSBsNWIw3qvHgWJujZkJAnc4y98ipMuKDKIJL7grqzfxcNhcSOktcpj+3N/KjgZzqk417sqFPalGu79iXPzk1yuBykzA6G9jaac1hyhskQBsYKiGHDzdGDxgBFrONAuXnXl2TVuXlD8kYPdzW0FP313eSwLB+gmiT7fw+Uy12hFKhZPwDreygYIa+7owdR29rezXoDiop8qc4YfgGXttDHo2yFsAJwOxf/Nx8XQ05jpWO6O+sMIgiA4o5q3j6Nx5vjxVxqUx6ZSE+eEAlkP5z4cpux6DMs3kMPY2HEKvmat8RynxsBx3jnav54U1TvTTX7G3ADWkkVmcvlidzDw4oP+H/7xTV17KTytD+hxt6E7CwYobdT1uafe43nP1hPOus9Jj4C3oAw38ff7TeZmDGB0obiNg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 760ba866-3705-493f-efae-08d8614838be
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1163.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2020 11:43:29.2371
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CMehRgmEasjljgUd8DTJHLiAiOkPLOgh8rbwUjdjsyjKvcwYuuukhnw0BdxKjjQod7uII/4fDTCkUTZGTTx8PQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4957
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I have just sent out the patch for 5.4-stable branch.

Thank you,
Suravee

On 9/17/20 9:50 PM, Suravee Suthikulpanit wrote:
> 
> 
> On 9/17/20 9:35 PM, Greg KH wrote:
>> On Wed, Sep 16, 2020 at 08:19:37PM +0700, Suravee Suthikulpanit wrote:
>>> Sasha,
>>>
>>> This patch and the upstream commit 26e495f34107 ("iommu/amd: Restore IRTE.RemapEn bit after programming IRTE")
>>> are related. Since the commit 26e495f34107 has been back-ported to linux-5.4.y branch of the stable tree,
>>> this patch should also be add to linux-5.4.y as well.
>>
>> It doesn't apply to 5.4.y at all, can someone please provide a working
>> backport?
>>
>> thanks,
>>
>> greg k-h
>>
> 
> Let me work on this and send upstream.
> 
> Thank you,
> Suravee
