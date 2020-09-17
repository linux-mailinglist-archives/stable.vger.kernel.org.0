Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF11426DEBB
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 16:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727678AbgIQOvB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 10:51:01 -0400
Received: from mail-dm6nam12on2048.outbound.protection.outlook.com ([40.107.243.48]:10141
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727303AbgIQOui (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 10:50:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cY5n3L940zf4XfpEw0cXh4RvocvzsyBp9HzaurgZrWdt42PEawApwbTu1Y5Y2gz2tOr8CZja9NRmHVqkiVvx268gjncbiGemtJKpF0/Jag20K3v+KG34Nm3IKHprXqPf8fphaEZRroJ33qfxogpjqNxp2UU9+Vvd+s9LPb332nJwyVgnDbiukyGhyqbQRuPw/rzBGRbd1IRzVdM43zvXBRemz301ZoPEn8G3y9QbxQf8sYgiEgxLtpBHhxFQa1jiZDB0M2fJI2tOUo8fQTSunLbk4f6rDTPjacc1lJuqYUsFKGIdJPl4fXVFex6X+HFe+zo1nv8MbB/XbVl1GYpobQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=06Kwup7DMIrbMqDp+/XCnDH3E7IONMPd22j4HgHjzZY=;
 b=cRrTAN8b7HJeDdZvNJoYvk6TTEhkUflGUmPiCJGOERZISRqxCAg6OfEaGflDQJt84m04p0tCYb9Ou1hP8UuJswPjjt4joIoh7v7zM95Hsv+ZXPEheTonfMtzEv70Pu8HzVcU4HswdSLZ618Xa8nGOF32+6YlhYX9h+KW7ZMSf0VOcbxikrPiVxazf59uaAYJ+3MdYKGrHl/Osl59gCvoZqJcvH9U9tptEyq2fiPWraLsh5z4j12FNDdYJNRnm+8ZbG/eRm2bQLZrQtwcVacTLn7latTfVx5WTQ5HnaF8W8+e3FyXsIrQeMYvZh5kf75oAYAHJJq5XAPlLbfmfBfEAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=06Kwup7DMIrbMqDp+/XCnDH3E7IONMPd22j4HgHjzZY=;
 b=lOCWjHK9mcc49EcTeG7f9iiaf02lGzkOF71KXly2GT/MS2jw9jrcIox+ucqiYbILl14GVKaoxQaTNM2P2x2ztRn5j1o8is72VNnNcXPofjt2oKeQUrgtBrZgzypEFRrznYMf0ZYEst3GrOpR8OBpmGUAigf0woym7UMG4UYvYUc=
Authentication-Results: 8bytes.org; dkim=none (message not signed)
 header.d=none;8bytes.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1163.namprd12.prod.outlook.com (2603:10b6:3:7a::18) by
 DM6PR12MB4957.namprd12.prod.outlook.com (2603:10b6:5:20d::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3391.11; Thu, 17 Sep 2020 14:50:36 +0000
Received: from DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::48cf:d69:d457:1b1e]) by DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::48cf:d69:d457:1b1e%5]) with mapi id 15.20.3391.015; Thu, 17 Sep 2020
 14:50:36 +0000
Subject: Re: Patch "iommu/amd: Use cmpxchg_double() when updating 128-bit
 IRTE" has been added to the 5.8-stable tree
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>
References: <20200907030521.EF51E2075A@mail.kernel.org>
 <831ea167-0e19-3557-8812-b42a8ef23d1f@amd.com>
 <20200917143529.GG3941575@kroah.com>
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Message-ID: <d84863a7-6361-7353-8bda-2a5d034a2c2f@amd.com>
Date:   Thu, 17 Sep 2020 21:50:25 +0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
In-Reply-To: <20200917143529.GG3941575@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KL1PR01CA0006.apcprd01.prod.exchangelabs.com
 (2603:1096:820::18) To DM5PR12MB1163.namprd12.prod.outlook.com
 (2603:10b6:3:7a::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Suravees-MacBook-Pro.local (165.204.80.7) by KL1PR01CA0006.apcprd01.prod.exchangelabs.com (2603:1096:820::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11 via Frontend Transport; Thu, 17 Sep 2020 14:50:34 +0000
X-Originating-IP: [165.204.80.7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ba366636-087a-4464-2c76-08d85b1908f6
X-MS-TrafficTypeDiagnostic: DM6PR12MB4957:
X-Microsoft-Antispam-PRVS: <DM6PR12MB495710E16605030BD3AD73A0F33E0@DM6PR12MB4957.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t/6SqVCDAz3/eg76lwC/YwFtWfMFpTQSdd+IABXyJfZDaw35GoCDjAqXM7QQefNbkETxDsi6Pssm2BP9bxJdcxXKco7nS3RLmi7+nWVnK3lyYjN7IApbVpRZrpflQFvpihdpIQoWLy2Wd+poN7p6haNB8iO8ADS3EsGp5qrGVHtUc7euGxeiheeR07EShaWvZkymJrGVCwKyhwdgLGAf9poLumkRhBqKxmPxQ1bI62ia01Opp5mEWsJWPW+ll5Dr292jiQlZj4NW/NPIlyyTBMtIRNcBGwTGcr2rjnBitQDuA0I2OocF0TNCyK5t31HhSmuVOy1S+PvcoNRcrlvaYqlCohVnZe09Wor8HDChtTAskEPqjF2QwpAfS+ebZvqq+/hjdWvTREwFWfbfIiifENJdL6vosr9ETgV2zvJuH6wNN1Z8Wx6l2oOK90do7sJE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(39860400002)(376002)(136003)(396003)(6916009)(5660300002)(52116002)(2906002)(4326008)(8676002)(53546011)(6506007)(4744005)(86362001)(26005)(186003)(16526019)(31686004)(83380400001)(54906003)(6512007)(66556008)(66946007)(6666004)(36756003)(31696002)(478600001)(44832011)(956004)(2616005)(66476007)(316002)(6486002)(8936002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: SImVIYkUVh0RGz8roObb6XsqcCCW+ZzktH7Uev3zn4DfG5JN6rRyKX06alW8xz7WBEP3R/msfbZ6cCRSMmN3efku5bWr+XVYdlMq7xECwtEyEhww6+YWvuyp8rxLgZEphyvVc90CXYEn/5d9Y2Pls9VekObMCVEO4z3hQCo+Zsu/uPWkHxPpoCffoOZ/WKHW8xBjrCAzxSaPqr+bwOo0XhwU67cc7utUUT+boHgaT1bC2gJgT302YeSe8qC+99hEKGBcpGPuUzoQkqO+J/VY2KCNKmSSH0oiE1f5OhZ+LmQH4QxCNY2I7msh0x1Frgt8srB9hApMacUWTEhmnR2KS2/CU/LEUodDTZPtViPx34Ry3f8HRgF6UBScBRb02sKgeMpmFkjgCYl6PH+W7EyLubD2fRcZj/WkIKiWO3BrOYZ3ZUsfzwLUCW6WHUvES2lHF58VlNW/U9a5mTonssnl0HHjU0iV08AiY40GuffXltpOboFapjiopMd0t9KcXmlNPxBMavoB2C71IV6HyZE1Eun2k5ZpHFHGGGO7+Twho0MF4tq3sjOzgPavtLPWZyUfafqtjYPG/M/OOAsKEnVc5xPjmRZGhj7M/7c2N0iaqjlj/IBz3mzsLAOEebNsL2biu6mY1AjzCUmi3rmbrbwjdg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba366636-087a-4464-2c76-08d85b1908f6
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1163.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2020 14:50:35.9454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y1e8BiTXleSJPNSpxzf2gXbog1OBMIdEFgtw3S+66xrqxhGufqzr9a4LI/Ytuo8aB1OG3yM9Lr8wcXWOAaECkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4957
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/17/20 9:35 PM, Greg KH wrote:
> On Wed, Sep 16, 2020 at 08:19:37PM +0700, Suravee Suthikulpanit wrote:
>> Sasha,
>>
>> This patch and the upstream commit 26e495f34107 ("iommu/amd: Restore IRTE.RemapEn bit after programming IRTE")
>> are related. Since the commit 26e495f34107 has been back-ported to linux-5.4.y branch of the stable tree,
>> this patch should also be add to linux-5.4.y as well.
> 
> It doesn't apply to 5.4.y at all, can someone please provide a working
> backport?
> 
> thanks,
> 
> greg k-h
> 

Let me work on this and send upstream.

Thank you,
Suravee
