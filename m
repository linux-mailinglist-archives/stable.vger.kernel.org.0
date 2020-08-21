Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 041E624E0C4
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 21:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbgHUTkl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 15:40:41 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:7347 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725831AbgHUTkk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Aug 2020 15:40:40 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f4023290001>; Fri, 21 Aug 2020 12:40:25 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 21 Aug 2020 12:40:39 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 21 Aug 2020 12:40:39 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 21 Aug
 2020 19:40:39 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 21 Aug 2020 19:40:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jFytsqJhySf6aS0TFaxeKLUQQsNwtIyY+PwwXytjg5xAH60LJkzF7cW+TeMyRWSTIovNXjlGvNVdSJiDY2WksOLNs5Zu5WDJIKG0imssx8o7lyc99nJg+fdbNZYx8cy0xuMIxZ1j4ndMiTKbWzGv0IgjP8SaCrlxtKqyrwaRjSlEtt5O1ooC6hvjzOg2Kj6ANO0h8RXun4fOBzbXpukYGapHBpX5DbTFbRtCemTyhfiDU5tmFJ7K3omNOHuidsgVZZNBKooszyFMFJwikyqalM/RH+3t9vXT43ZcrFx+Uk7FBgkizwUimE2rqHmGF2ObIcNIJOEo4gUW2MjKQ7JSUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ms5lYmj2yDKCLP7wuU52VEwOMm2Nng+ahlfTRaofbJo=;
 b=ExiLCWcxjywAKoCunHBeIToo/ZTochAnDPi8nbl4Z4XDC4c+a3Hv71xRyYtBUn4n1G+niPV7+XucCO3sHu2Kb6U+gz2VL89LFvUz/zCnfM+qNuxnTkvSLXOsrizctl0qEOsm5CoIPdoDW38+0AwZ9XORWwYTaFPtoTyG2EZmVHDIoP6rDs9JDzkO0gnA4r8RqsYLP0LO5wbFAtC8P/dvm3jiNlUS2db1X3KVjoQoqRaI1C2ow7Q9AaOCfmm1xYhLUlhVMUOGYbtSvN1Yt9TLylZM8hQnWO1MUFlrr/bfIpLnvd0UjxJ85Mc5yswQF+35V7nZ/9QPMU1ZpalWnoLB9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1340.namprd12.prod.outlook.com (2603:10b6:3:76::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.26; Fri, 21 Aug
 2020 19:40:37 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::2d79:7f96:6406:6c76]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::2d79:7f96:6406:6c76%3]) with mapi id 15.20.3305.025; Fri, 21 Aug 2020
 19:40:37 +0000
Date:   Fri, 21 Aug 2020 16:40:36 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Sasha Levin <sashal@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Gal Pressman <galpress@amazon.com>,
        Shadi Ammouri <sammouri@amazon.com>,
        Yossi Leybovich <sleybo@amazon.com>,
        <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 5.8 55/62] RDMA/efa: Add EFA 0xefa1 PCI ID
Message-ID: <20200821194036.GB2811093@nvidia.com>
References: <20200821161423.347071-1-sashal@kernel.org>
 <20200821161423.347071-55-sashal@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200821161423.347071-55-sashal@kernel.org>
X-ClientProxiedBy: MN2PR12CA0028.namprd12.prod.outlook.com
 (2603:10b6:208:a8::41) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by MN2PR12CA0028.namprd12.prod.outlook.com (2603:10b6:208:a8::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Fri, 21 Aug 2020 19:40:37 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1k9Ctw-00BnNf-HK; Fri, 21 Aug 2020 16:40:36 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca920675-5509-4c94-c09e-08d8460a1438
X-MS-TrafficTypeDiagnostic: DM5PR12MB1340:
X-Microsoft-Antispam-PRVS: <DM5PR12MB13404B84E6B0492237F85BD0C25B0@DM5PR12MB1340.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:741;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5re0c6DNrvSH4aA9itG9jjVbrAUZfbH/zerGOR8X68owfxdg4YZVfG/5gZ6/O9p6rVvZ+Ya3LwuG8ML0sYVwWeHR201HYhNcnGnSYBCHSX/3WjL1gcXIjLHPQ2zY1tSwKV4prf6mFSoFKlCv03gkCVvfkE8NIbJ3dbt+mi7213dGMSyRPKCff22dP5fGXm4VUnCRzXNLUQePudcZYb1XHudfm7KsUfCj/vMCwDyOVKMw/EdpT2EEr9jX1d95t3YXDqdIe0R8V0a4naZ7LZyaU0ZV4c1a2mHBzcY8JBu7xcC9ZHAHF2jlweld4oyDt+lKGKGc/ecrmMs3TtvKwIoOAKLWaTKBrZg/vMi6UDCiYsWda3kbYf/IU9JgwTnFpQb8cFdBTSwgNniRkPaaUqHksQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(366004)(39860400002)(396003)(9786002)(8936002)(966005)(54906003)(9746002)(478600001)(36756003)(86362001)(4744005)(83380400001)(8676002)(4326008)(33656002)(1076003)(426003)(2906002)(5660300002)(6916009)(186003)(66946007)(66556008)(316002)(26005)(2616005)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: iEagGQ948LTNmcg/xFxjLNiUK8LotzoYYFnwEvvfuH/FlOMcGYR8zNKc1oqI9/TsGVwCzgNGzQ10pvbLfGbrmztCOkZVNY8v3QufhPxhzv16LtuVA83Z1+NjW3eo1G/SI6H9QVyIY64wN5PnQlnZLmCp8dKrIL6K59ncn7/YRbXANS25d+J3zsdoY0KxY/xuP0NrRILxYKQwX90wsIyaoYjJ5EIBPEyMFr65FFyBGvZvqpaVj7JBUsrAfD3RA3P+yavjbojSA1fL/Mjij+0HbQke3QKQ3mFyfXWw+NwMvD636ibHcRIVXFUCvkPJOdfhrF9LmAZ1Lz9QX4ioRztMGiMfHFkpVHjnASPiLH38kYHneOUSDJgWIxjCC8qrv4RNYuRE6vmWsIgh8yNQG74Prba2Q8lwhhWCkJltDLSsoXDKKVaTq0CQZg9i/v+V8lqi0ykdqxW+BXxLZw4QhnqxiB6ujRm0gRy8LhzJ92AxXcLk9f4ENsRvUK2a6GkvneYF0joenno2NP2Eq4YtK9De2As5QIpwKy6wzwtMc6rfZmpBg/2u6FlJ++gvW7k0idEmDe7bkEwumgNO+af7A56QXwxjZ6E6skQuvhkYIlRp1kk4CnSBxHChcl4J96hQHQDVN/Ag3j97M36Ukx+4WZLCrA==
X-MS-Exchange-CrossTenant-Network-Message-Id: ca920675-5509-4c94-c09e-08d8460a1438
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2020 19:40:37.7535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xzLxorYioUpua+bX4t8nuBbPXgrZHpIVFhdkv3vgRTPKIWMGSnfHD+88XaXmertW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1340
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598038825; bh=ms5lYmj2yDKCLP7wuU52VEwOMm2Nng+ahlfTRaofbJo=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:Authentication-Results:Date:From:To:CC:
         Subject:Message-ID:References:Content-Type:Content-Disposition:
         In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Originating-IP:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-Microsoft-Antispam-PRVS:
         X-MS-Oob-TLC-OOBClassifiers:X-MS-Exchange-SenderADCheck:
         X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
         X-Forefront-Antispam-Report:X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=oiLRwa4h5x6SymRZHDvRBy6cjGBP5DQPbiiqsT1xwToVm6Os4CX4Ua5nXDCQoFB0C
         qPy3bXbfrdMHtmYwQ+DRU5ZkVUqabAg5spRKd+Uwl6fQu2AVcGq5ujt0xmVOnfdo4q
         dpbgGqzZ8kACHts//v3p6ceDK3IVdGaIPCLFQa8Pk85bIqRNwUtkfD+KAkBlYoknU0
         kvhU7j+6r6hD2iDqkJPCbZfvXMTWdLgNGNvCblhBKVPw8eD7BZ96LnvDfVkbXNN8YR
         8ksKyIcd86RdiosjZq1BX8YTmaMfcPjpa81MpVNtPGU98us9r0P2eP5YwK1I5dDRZq
         7R8N49n9/LThw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 21, 2020 at 12:14:16PM -0400, Sasha Levin wrote:
> From: Gal Pressman <galpress@amazon.com>
> 
> [ Upstream commit d4f9cb5c5b224dca3ff752c1bb854250bf114944 ]
> 
> Add support for 0xefa1 devices.
> 
> Link: https://lore.kernel.org/r/20200722140312.3651-5-galpress@amazon.com
> Reviewed-by: Shadi Ammouri <sammouri@amazon.com>
> Reviewed-by: Yossi Leybovich <sleybo@amazon.com>
> Signed-off-by: Gal Pressman <galpress@amazon.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/infiniband/hw/efa/efa_main.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)

Wait, what? Why is this being autosel'd?

This needs to be the last patch in a series enabling support for this
chip, it will badly break this driver to pick it out of sequence!!

Jason
