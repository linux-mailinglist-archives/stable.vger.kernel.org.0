Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 608A746F5D4
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 22:21:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231851AbhLIVZR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 16:25:17 -0500
Received: from mail-bn8nam12on2065.outbound.protection.outlook.com ([40.107.237.65]:45504
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229446AbhLIVZQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Dec 2021 16:25:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MQ2hdNDwNrEGero8TDdDCVSqoOasmTfYJvK2xHhe34QXyMG3JZsb4GfUa7EwyJLVm0JPMEZpeVx63W2O1gERzXscC/9c1aux6J1y1palsh48jLHdPsvH+f/qsK0rfQNOKdqsH0p5Qc0caxv+cYK/mIUAepjRnpjJD2R5qSCtO3ZxdmAJr9E6B6ft8/NpuY8R9fXklF/n6LUC6SI/JMpqLO5nOhOLeaiY78HQsCTUMtjkfh8oYfwCD9UQhP8wO05W30zUymTJt9i1jld9Li/1bXeytvpeK9rNRLve9o4uoLIj++Ipvtammu64Raumw1tzMMJHBWIgkbK5Du8+BcxsiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sYfZcVXXu7pfdLktOZ1GFnm8sHBMygqk5w/lZkM8b88=;
 b=jzLWrMeGsVx2g02G41a62CAZya4n3cFEkdsdnWyBK6CyUrTGad9EkV87Q4ctxNuOcrF8QKr3KmadHz3gxkYaybInRAr2UxFDgGnqvyGKJ9+IHsUqWg3ns5JEJWnThFOGFQOwTrw1EWtLCvSrc5zMZXgi5fSMiTW9LxeoZEBVLYzbbVPm35qceIqhtH6mPSq1b5T3KEVIhyhBmDg4jAH8xF3Qz2mwRk29/sDXfmgwqe/ADC3ekR4FW64hPi5UzDpZYD0CzjO+G4rtTM6grM2SxjfYDs0+2uMI8xpFX+yo8edZ0Dl5bsyyzIGgioHCf+yz37X8Ob5gu5YOjbAua2+Uug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sYfZcVXXu7pfdLktOZ1GFnm8sHBMygqk5w/lZkM8b88=;
 b=gcI04njx3OjGFjzouOsbN6nJt4BE+lBQPdhpfpVoLOY5t9vjvOseHt2PXQS0idT/PAUVuR+w7A186yHvheRC2LPgymn6KpcKub34UDsRU/70cPZPrFoUJLlElRIKW8gFW+ow396S3voofxkfs9Lo4pDCKipZvuIANU9jx4utUBgEvg4wQ7+f3M3mZ8abWja2riu0HIOqVm85OWWF2lWwYHZbVeYrK//XzRgB0ktfjM8hsNeewZsn2wMAReMdgA1AJL6l6/7+9uwqZcyBGA3nCsxfdlP14rjG17Qza1WP2sG1Cs7zV/paFiyIAEr1YFPKd8CVv4kbCIpxPbqBN1WMxw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 CO6PR12MB5396.namprd12.prod.outlook.com (2603:10b6:303:139::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.22; Thu, 9 Dec 2021 21:21:41 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::ecac:528f:e36c:39d0]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::ecac:528f:e36c:39d0%5]) with mapi id 15.20.4755.022; Thu, 9 Dec 2021
 21:21:41 +0000
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Subject: stable request: 5.15.y: device-tree SPI ID fixes
Message-ID: <8f72e275-b2be-0caf-d88f-5767847e70e9@nvidia.com>
Date:   Thu, 9 Dec 2021 21:21:32 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1PR08CA0204.eurprd08.prod.outlook.com
 (2603:10a6:800:d2::34) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
Received: from [10.26.49.14] (195.110.77.193) by VI1PR08CA0204.eurprd08.prod.outlook.com (2603:10a6:800:d2::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20 via Frontend Transport; Thu, 9 Dec 2021 21:21:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 44fb1053-1247-4366-d719-08d9bb59e435
X-MS-TrafficTypeDiagnostic: CO6PR12MB5396:EE_
X-Microsoft-Antispam-PRVS: <CO6PR12MB5396931387DEA6C666A6669FD9709@CO6PR12MB5396.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1468;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uBvPFv4lwxs49DzmvN1cchLKggM1D7kQQAl5wRGALWzQ/Sn2welKfvbiZbUM5lCGrXkegTrC/1atVKc2anq2KDsHzQKqtgzCq17CpX0NP5C6xcA03rEfdbDG6nUugDjIAMmSoaQ63zRwDdhzdCTAa3fdjigz8Aevi0CqCg9+sP2xtFbatsr98pCEcaRoYLKki1CFIyGgG8BFwtDkowEFKLbInsjBY7ys7H2WibAPrNXhIfXgFUoYNabzyHOb4iFuST1tf3dqrvarBVpSEfT6m9pu8deffZyTWAN2RRweI7lqSXcM38ple8Fymx2RkIezM03xKnGvv+vlJJpK8YOKlnaVViyoj/zKjSUVVXaQEt8XMywMfWT/kXxVY1I4zyLd1aZf0y+m/H1DVCRQGIIoqJuEbhOw4fbm8bVHt3Ycfn4NS+P7EV1AxUNm+n4dm6fplge4xhBQ8T06Xalk2AMJXQL6iD4Mzv/gSSYSjHLQwtSHQMW3o1fd1AW+qVKGNv7zfnUxsDZFvPBsQBCPSkAJJ+7RtWnQ6OeoNoiigz2axGYJ2ptUOU/mwIPceSyH2xDGyeMP5fZ9n7Jlk51c/ooaC2+zuYJ3VdCxyav2VkLL/1pyGL2D5mdTwpgvGMu+06RwYLz4PbRk/JsbeDCsV/3gPY8bZt1FAczVOVAxN0U20xMdWjtbYaNqcH7NRx1hjojosEzJehV7jWDPFaRj4J5BuYd342jFP9AgZBnviT5l3UY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(66476007)(316002)(2906002)(5660300002)(4326008)(31696002)(16576012)(31686004)(956004)(66946007)(2616005)(26005)(55236004)(8936002)(36756003)(38100700002)(83380400001)(6666004)(508600001)(8676002)(86362001)(6486002)(4744005)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?LzJHbzUvRXhvRnBORHduaGJUY3d0NXU4MWhJQjQ3dTdzdERpclpOTUYwZGFy?=
 =?utf-8?B?OTFrYmlNRWtpWEZqK2FHbkZvd0xsUmFjY0x3NXltZVlESDZjOXVZYVdrZ1Z2?=
 =?utf-8?B?ZHNwU3BVOFFkUXFyemNnVDh3c1lqZDVNQWVaQWtJaUFqK2xUQllUSTRIcnBp?=
 =?utf-8?B?SDdBbFRTRk80cTNSdmZnNVJVM0N2emJqMEQrK3M3Z1ZSM0dPL2FQNUQvNkR4?=
 =?utf-8?B?a2hjeXNta3FITVBka3E2ZjJnTWxJMlppaEVjUk9YV3lVS0RUc1dabndsMC9p?=
 =?utf-8?B?ZDZ2SjlyOTk3S0dYZm1YTVhPcmxncjdTK0R5ZjVnZmpWQmVGRDJreFJxRUNu?=
 =?utf-8?B?S2x5VXZpWkxvbkZ2L0MxVmx4VStBQlJhNlVHditQR1p0TUVaa0JvdEZTMSs4?=
 =?utf-8?B?WHlyUzhRSEpZa25rSUI4M2hDL0s2aUpFMDlYYi9LTCtFNHd3R052aDBRUkRT?=
 =?utf-8?B?NFFEL0pJd05HbDhnMDNFKzNmM3RQUnp1WkU5ZUhUL05GK1A5M0lMbS95R2Vw?=
 =?utf-8?B?RjFXQlg2QkxVaE9tRWVodG8yTjFFaThkdlp6c2MwT1pHUlh0b0tkV0Zia3Uw?=
 =?utf-8?B?Rlp4SUZUQ3UyS3NPN0l4T1RFN3pVU2dZZmppMkRaWW5zZjVib2JXYnpkb25n?=
 =?utf-8?B?RFM3Q2dnQjRpMm5WZTVzUWFiNnMxQVR2OXN3dmtKcFpwOWRzc0VZekFvaVBM?=
 =?utf-8?B?WjNaUG1uOWpSM1VjU2Q5Nmh5MTJFb2EzWFBSZ1oyR09uSXd1Q1hsZUNNKzdh?=
 =?utf-8?B?VlFUOVJVQWtvdVZIZGF0Y3U0N0ZFR29MWDhhaitoeVdkb0oxZGsyamM2TDdJ?=
 =?utf-8?B?bDhwRmw3NGxNT2NVb2NiY1ZwbEZ4dG9zaDNVTWJhL3JkUzd6ckJZdldWWVh4?=
 =?utf-8?B?UjVUTGN1WXpiZXJPZWVUZTFReEdnWUt4N3R2ODBaQ1Q4U2RTdExUQXVqc1V6?=
 =?utf-8?B?T3ZkYmQ5cGpWbEt0YUgxeEN2cFRPdE9mMnRQUXlpMUhNWlhDQUIvQ2dNWkw1?=
 =?utf-8?B?VEtKRjFscmcrUFlFQXgyNjJTRUNkSVNwU2xXNmxyQ2FGUmxNTWNsZE9BUjdJ?=
 =?utf-8?B?RlRXdHQvVmJmQmxSMmhPcW1zaDJBZDFJVW0wYklWbVQ2K0NIRnI2bTBkWXB2?=
 =?utf-8?B?WEtWZkJ5SWdmZUVWQ2dVYzg0MXlXKzg1c250ZzVadjI0cXlSSjJETTdOVWFW?=
 =?utf-8?B?ZEN5VFl0bFZUQUdzYitlSFQzTU9NQlhEYW9ySjdQeWgyY0EvR0RWZ3RYdFha?=
 =?utf-8?B?ZnhNc0tYLzFBKzYycmMwMmtrTXVjb1VUeGtBSmNFZTFNeEl3QUlDb0xCQlRP?=
 =?utf-8?B?aTRydm9rVlhsZ0pDTC9qemk3eUh2aTNCNVFQRWg3TnAyRXZpeWNqSXBiNE13?=
 =?utf-8?B?MUY3NGt3ZEJIZnV4a2tjRXFGcFRYa01RMEJQK3B2NHBmQmhMWHhKK3Nla3J2?=
 =?utf-8?B?WDd6cUo1UDdPVElrMVhNR3lmeWdlelI0RTVSbll1cUN4Z1I1ejJMVGliTFQ2?=
 =?utf-8?B?Tnh3bXp6UnlBKytGVWh5U0tLZ1RjVFRzb2ZxOXZNV05INUhLcllKMURucTRO?=
 =?utf-8?B?dFVyUkg1MmFrZFpYZ2ZYNElHcFJUak8ydUxRRHV3MjQxU1NWNmhISU1JMWgv?=
 =?utf-8?B?TFp0ellmeWJ6dFRoRlhQNDhHcnJBcXlkZ1lhdEpOZ3JqaVljYVo4YUlDaG5D?=
 =?utf-8?B?dlhNaWE1amZVRmFXcldxNlpOTXhjR0NVQTFWK2JwcjliTk5oWXhiVHdwU1Fy?=
 =?utf-8?B?cGZRcXRUTEllQ3VSRloxMnVJa1hTcno2b3duUmd0aDBMTTJWS0lucnJvRTlU?=
 =?utf-8?B?V05vQkwxQURVdVZzeEQzL1ZtZ2lraXA0ZkNZRmtpeFgrN0k5bTR5dUxKNlYw?=
 =?utf-8?B?QTUrUTN1L2pKYjNkaDJoUnRDNytPNVZ0ckl0TnJ6WUl0Y1UyNlhyU3NQOE4z?=
 =?utf-8?B?SkZvaHEyUE51a2xaUG82UDg3SWZNNGhrWEM4UUdYR05HU0JLYjNMdjhBSTY1?=
 =?utf-8?B?T0JiK3h2MzllcFhvVUQ3SWxBRTNyQm5GZXFrbU1pSFNJUkl5UVM3c081UFd2?=
 =?utf-8?B?bmd1WCt3Slg5NUZianM1dVdiNWdlMko4V0tVUFJreU4xMHBJaTZmOHlpSzZx?=
 =?utf-8?B?QUo3THJkNHdOTVp1dHdWQU5wZHNlN1l6cldtWFV6eGpWMkw3Y2tOZTdmQ2dU?=
 =?utf-8?Q?W945eHhF0kmJnCCIjxTma6A=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44fb1053-1247-4366-d719-08d9bb59e435
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 21:21:40.8825
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SWbcpxWDXcxPvs+sVGppJEd5BfL6x30RWKXC6Sz8B9pOk+VDET9BOHtjkdhtf20hXb0rf2j8/KX3PTxdYc++Qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5396
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Please can you include the following changes for linux-5.15.y to fix 
some kernel warnings.


commit 27a030e8729255b2068f35c1cd609b532b263311
Author: Jon Hunter <jonathanh@nvidia.com>
Date:   Tue Nov 30 11:24:43 2021 +0000

     mtd: dataflash: Add device-tree SPI IDs


commit 5f719948b5d43eb39356e94e8d0b462568915381
Author: Jon Hunter <jonathanh@nvidia.com>
Date:   Mon Nov 15 11:38:13 2021 +0000

     mmc: spi: Add device-tree SPI IDs


Thanks!
Jon

-- 
nvpublic

