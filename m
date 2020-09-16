Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC54326C615
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 19:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbgIPRc7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 13:32:59 -0400
Received: from mail-bn8nam11on2103.outbound.protection.outlook.com ([40.107.236.103]:17665
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727182AbgIPRcc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Sep 2020 13:32:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AZ1kaFEF0y2Rk7JqELjKZyfvG1XH8R+MvlRG8Tyq+OKJ0mDJr946iS2wZvKkbIWHq5DDo2xWR2OI8k+MiotqqTp9cyL/EYXmUX7fkHZt0/4eFKKQuTYL7ihInBny5QDuJsIHKNBvj+PhD3TJ3C+BDIvIsOn7YeOf6VKClrgRGZ033auB4MKrIEzh+t54uLDMoWnygPOko19+vwa6zJnXV1u/X/H3uOaaRSXo+rhG0O5x6IAwjbGWULNy8AIchRgJPzZlVbfoHHIqYLZoUTFNNKYucIG5qip8OHABFId50OuozYOXrFz+BmvEfCLMDytJrzkG3RkXCCyGL9Qps0WwPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KRUyMHTHHdzGrBHYxs0OCL97dbLB7G0oQ6u/ezYMgq4=;
 b=lmndJg+xeL2CrTL6XL2UmfG82GGv/ilzxI8OyBodmwuDp6tuRdF1ToI3xJhwtnZ8udl15Pg5/m2wCm9n8eHlLEbn3MQet3lOwyNHHJ2vFQ8X927bfBvZaQ7iH6msTl8wVEom++xHSdsCOz9wqFbGYci9TwiOBircBLZhUDP5tOc/77gcu8IpWMrvWWmFjLcWVNZJsREZ58TvtkgWjiCjsZ9JPlOEZKKSnjhtaKlOoyv29uMIhBFFbvUamt0pwW6pybmKSNrSE3o8alDOCYqis/ek94nubLrUyIURP9hWn4urKHIwpZ0eo9pSghnRCqy8UXonW0OkFs7y6V5FN+/kBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KRUyMHTHHdzGrBHYxs0OCL97dbLB7G0oQ6u/ezYMgq4=;
 b=g9co/hGSLrWtx2n9QB+Sod3AHUZeUD8EAGJPhRi56BG1bKHkVXOBLAft0EaaU/uK7eNQSyU2/+ykz0t/WxBwatQQofhtH9nq+7owXnzVEaUbylPreN9nDzFlixRFI/HwEJJMZX2zTzteRj9IgtuLNApHaPN0lHHYt6LrvY1+8Nc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=os.amperecomputing.com;
Received: from DM6PR01MB5802.prod.exchangelabs.com (2603:10b6:5:203::17) by
 DM5PR0101MB2955.prod.exchangelabs.com (2603:10b6:4:36::34) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Wed, 16 Sep 2020 17:15:24 +0000
Received: from DM6PR01MB5802.prod.exchangelabs.com
 ([fe80::ed9e:20e7:332a:704b]) by DM6PR01MB5802.prod.exchangelabs.com
 ([fe80::ed9e:20e7:332a:704b%7]) with mapi id 15.20.3391.011; Wed, 16 Sep 2020
 17:15:24 +0000
Subject: Re: [PATCH 4.19 0/5] Add support needed for Renesas USB 3.0
 controller
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <20200915213039.862123-1-jlvillal@os.amperecomputing.com>
 <20200916063116.GI142621@kroah.com>
 <e92b6d88-387b-1b06-9df1-49897145e0a7@os.amperecomputing.com>
 <20200916170821.GA3054459@kroah.com>
From:   John Villalovos <jlvillal@os.amperecomputing.com>
Message-ID: <935e6153-f249-56ef-0696-f46968993038@os.amperecomputing.com>
Date:   Wed, 16 Sep 2020 10:15:12 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
In-Reply-To: <20200916170821.GA3054459@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CY4PR1201CA0015.namprd12.prod.outlook.com
 (2603:10b6:910:16::25) To DM6PR01MB5802.prod.exchangelabs.com
 (2603:10b6:5:203::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.200.146] (50.39.163.151) by CY4PR1201CA0015.namprd12.prod.outlook.com (2603:10b6:910:16::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11 via Frontend Transport; Wed, 16 Sep 2020 17:15:24 +0000
X-Originating-IP: [50.39.163.151]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed3de9d7-4f34-42b7-358f-08d85a641987
X-MS-TrafficTypeDiagnostic: DM5PR0101MB2955:
X-Microsoft-Antispam-PRVS: <DM5PR0101MB29551E7E9024A6D4CC1E65C8ED210@DM5PR0101MB2955.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6Zd1/wyaUi35hg0eENYsiqfDye45HZQaQgs5e9vUuqeokvimSQqS7MqgG68PnNnRFa2ieQo2QKOwEtzFIBpfYCr9gqM3aMXQUplJCEH29ATv7z9e9WnyFoyUFYPPJt87aB+ZJgwSgQB7b9xd2bUbsqlYnNhgoRqtpqBHLzYKTYk5iDhXz9787YefaVha6UO4lF0LLN+4pzkhOdvIf/mbt/27EmNpl7qnX8ZNNyLkr3pkidSt5OTYZwmh9qSYAs5KzNmbPY370nHqzExDYDzTnuRDueC1H6wlnRF3QoQFysYoATtko2zsG16OKt/6uTAFTv6xFXDWkH3fq2mcRZdYlFfOJ1N1btD3h+f/zlTwhr118hY3nIyjwp3lAHXG7H/S0BSPEPtVFywThY3RhBMrbWCUE4r3Cd5ylwa//PZ2HY/rP3Fyt1NL16GCn9ZMyU7X
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR01MB5802.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(39840400004)(136003)(396003)(4326008)(8936002)(6916009)(31696002)(16576012)(16526019)(6666004)(8676002)(186003)(316002)(31686004)(2906002)(53546011)(26005)(66556008)(86362001)(66946007)(52116002)(66476007)(5660300002)(956004)(478600001)(2616005)(6486002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: rmjQURswK7AJzudsXUq+4uTA/wySNOMV4UWWKZjquFIsZSeIvL4bgm2dP+XcQf++kcED6VwAVoGR78JK8yzp783PBnKUrroRXGurwL2lmFXXJUqdaz2hm//iwA6BxLsVIZr77BWB84JmzK595rUzLWwPS6KjVYj6Gx8uPeTIkFzM26DLQYggmAR1uBX1bDOI6jqpqT0VdxLdOY0H8Xj8W2GSdXWxCAzm0f/8rnwIJTXvtKQK8ikoYtUlReAcq3+OL7oVBlZ4Tp3exg4ic4HCOnTxNT1iNaaZFF1iN5g0lGdYAqZVUYPCoJQsMkGC8A7Km/MBblEll6uiBsFb8XRFvOwAg+JeSnD7NOpUa3jdHlBdY2BWQ53lPUNhkJYg1H9WoPghiRdTyLPElH0EOLFxv2lKF2V+R4fV6QCNG5q4oYZvyZSvHR7nVkas1zW94ufUKhk7Za4T2/s5gk6puoIbtQekyHYT4HrQL7PGV0FiEqQ1CONPuM7rJHObIYGpfsmw0kzsRoTO7X50hhzpMi+NPGdnwllwNd8UY4Tr+Zpy68ipyMFjaGNJZKE15IacjMvHYz9sgWOqbvPd+LYD/wlhScymlbaeBRbBkQRnLdcvO9rSEZ7Womw+Z0nMKlRUGZQiXJO1YzNWKhky7q1nVdV3pQ==
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed3de9d7-4f34-42b7-358f-08d85a641987
X-MS-Exchange-CrossTenant-AuthSource: DM6PR01MB5802.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2020 17:15:24.5725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5T4OrUiBAKcVs/+TFI1nTHh2dBJlFVVk/duiycC0vgvAQrRByBN52XSYSVc8M/O9mJVPTmRHlqr8f/X1PTOSPb87iVcGAtxyMfWr54Od82CLVD7pWRQZB6KC+Gzwf36D
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR0101MB2955
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/16/2020 10:08 AM, Greg KH wrote:
> On Wed, Sep 16, 2020 at 09:54:50AM -0700, John Villalovos wrote:
>>
>> On 9/15/2020 11:31 PM, Greg KH wrote:
>>> On Tue, Sep 15, 2020 at 02:30:34PM -0700, John L. Villalovos wrote:
>>>> Add support needed for the Renesas USB 3.0 controller
>>>> (PD720201/PD720202).  Without these patches a system with this USB
>>>> controller will crash during boot.
>>> Is this a regression, or something that has always happened?  If a
>>> regression, any pointers to what commit caused this?
>>>
>>> this really feels like a "new feature" addition to me, unless this used
>>> to work properly.
>>
>> It is not a regression. It is a crash that occurs on new hardware that has
>> this USB controller.
>>
>>
>> Without this patch series, hardware with this USB controller will fail to
>> work. So in the choice between "regression" and "new feature" I would say
>> "new feature".
> 
> Ok, to support new hardware, use a newer kernel, no reason why 5.4 or
> newer will not work here, right?

This is true, but some customers who want to use this hardware don't 
want (refuse) to use a new kernel :(

Can I take this to mean that this patch series is not allowed to go into 
the stable kernel?

Thanks,
John
