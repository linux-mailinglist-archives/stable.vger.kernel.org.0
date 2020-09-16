Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D96E026CCE9
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 22:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727219AbgIPUvE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 16:51:04 -0400
Received: from mail-dm6nam12on2136.outbound.protection.outlook.com ([40.107.243.136]:60128
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726632AbgIPQzG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Sep 2020 12:55:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KZj9VGOOfHYQtcK0n/X6LzxsU8lGGOwTA2iVSSK8Pb3pxiXnK2gRFolzTyq3XKscFMNyBIaNvHQugsnR1Ngs/+gcK3JPt6ZqQTxdVNZ9iJfFBRKFLB7co9g6zLMOjBpAgxZpLs+Boto1hbXRwYkoyXV+VTttu3v92EKby/33YBMiPNCNrZVOlduvcM4QvqcQ3MgN26IDInWQhqSVcV+viblovh75oaBCD04lfVHSx/r9cqgfc2ZZ/UgkgURPk9FV80RejqqeP/gL+rS8izdtjmyAQOq8eSw7ESWp0Ll0ogSTm2AszXFUea1Gdjw5u0nSOgSN95ysRv+MHaIsL8vh7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZAVySKPqq0bJ6LTHgXOI2XLH86/ENszW7urzXEMjpAM=;
 b=FhxU2P2XqlHVMQ7yuYdT0hhDEa73nDVIMD9om+8tDwNzJHhsHro8uGim7Uz83LLTvFyLiYNVuzI0EgV2ubkbZzOUyNiHanTc2g3wOkI2T/lxIadMRSMYIQiij9ZDswhyqHkelkrQO04U/zmcVz/WeR21NA/nMHSYcXPu/ipms6hgtRH3ai8ZoLhhzdilNWNcX+lFIRNrI/W3Hmfe0QycRVXDx5aq4A+Ah+VAbuPE2MXnCDQ//+w6fKLyPgji+I8Q/3HRZ31UNJ9oOdvI0VvVmOa2RowhQM3IekCSqN2GgOd/fXLG1ohCM04PZaYT0klSxgTmHKsHs6NlAW4M1fsfrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZAVySKPqq0bJ6LTHgXOI2XLH86/ENszW7urzXEMjpAM=;
 b=rS3p9fOc6E1sDzY+BD17FFITaN19ts9OcUBnSAi/p+9iIYqPoWu+rR/K6pf/++GBaJuuSq6BgEcRP0oTP/xfZmVFabnUAxNwceAUQoI0d3qLhrdIRcgmbbBFuGBoq6VnqPR809M4hYDoLtxVNzZPgIN9jDqe7DXqsLf/tBvHtKw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=os.amperecomputing.com;
Received: from DM6PR01MB5802.prod.exchangelabs.com (2603:10b6:5:203::17) by
 DM5PR0101MB3147.prod.exchangelabs.com (2603:10b6:4:2e::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.18; Wed, 16 Sep 2020 16:55:02 +0000
Received: from DM6PR01MB5802.prod.exchangelabs.com
 ([fe80::ed9e:20e7:332a:704b]) by DM6PR01MB5802.prod.exchangelabs.com
 ([fe80::ed9e:20e7:332a:704b%7]) with mapi id 15.20.3391.011; Wed, 16 Sep 2020
 16:55:02 +0000
Subject: Re: [PATCH 4.19 0/5] Add support needed for Renesas USB 3.0
 controller
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <20200915213039.862123-1-jlvillal@os.amperecomputing.com>
 <20200916063116.GI142621@kroah.com>
From:   John Villalovos <jlvillal@os.amperecomputing.com>
Message-ID: <e92b6d88-387b-1b06-9df1-49897145e0a7@os.amperecomputing.com>
Date:   Wed, 16 Sep 2020 09:54:50 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
In-Reply-To: <20200916063116.GI142621@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: CY1PR03CA0027.namprd03.prod.outlook.com (2603:10b6:600::37)
 To DM6PR01MB5802.prod.exchangelabs.com (2603:10b6:5:203::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.200.146] (50.39.163.151) by CY1PR03CA0027.namprd03.prod.outlook.com (2603:10b6:600::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11 via Frontend Transport; Wed, 16 Sep 2020 16:55:01 +0000
X-Originating-IP: [50.39.163.151]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 27e8f5c6-12d1-4298-9e56-08d85a614102
X-MS-TrafficTypeDiagnostic: DM5PR0101MB3147:
X-Microsoft-Antispam-PRVS: <DM5PR0101MB3147DBE8500DB7983200E88BED210@DM5PR0101MB3147.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6gYYH5cQf/dPG8e44NvZVpzQsfI/GhElaA67wDEbGdlNNU4DP/mtfvltQzcTp96E1QQe6jNIlOLIYIfEUsQIdxH8qL6GMLSWpXmONME2fR8YqCVWXr4KwKUdMTERjnAnq5aPZ7IDOEizvnNkTgW9LhwQCuXwo8Z4u0Uj2ZV/6Zf7dXOTZoUkRKcmkyVi0vE1Xw9crtWw5Yh5Ha+vmr06Ak+D7f2KiLZ93cGF8mfP3Cmbc4I3yFFoE3PeEriyHFcqop08HDCitRhA+oHxCg7y5MQcJnMrk1d3JJTh1b1ZnnT83ssuB55t9icBz2rbRHtxDZ+7vxnLIMHMZt1aIIJoFE5RrDJIJ5v02tDaUzJ+qOQO/vS25SJim23we3kdxNL2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR01MB5802.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(366004)(396003)(39840400004)(2906002)(186003)(5660300002)(4326008)(31686004)(16526019)(6666004)(53546011)(66476007)(52116002)(66946007)(478600001)(86362001)(4744005)(66556008)(2616005)(31696002)(8936002)(6916009)(956004)(6486002)(316002)(8676002)(16576012)(26005)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: KKdb4gevIulf0cBNvPXZqiYadwP+AhxJ8xV4rTDDN4Ys5Rnn6gRqaxFuuxiFFryQrhIUDDmhzYwj+Pf7VDnSaxQ2iSrcAYdzWAWXLiUOaZzWS6ouR4BQ+SMZ2ZYRiCmme7JMi5dcT9pIdybCphjRzF6+p/f6ThnBp/2iDfYHeRw0e860KeepfidUcLHJJ2Ve0so2dyQ0Rfo+QFaVzWlkGE/DVbTVqooZFepzJFly0D28JEUl5bG72GB9kWnAaQigN6HaWRJqrtfCHqP1PhcV26rWqDrMPZmyZFkONkuQoYE1KHvdzHhQsA3UVCPGac9sCVOkriXItLzc44akfDvZbFB2qzVbAfEqt0+VH/ScoEAqZ7NEKIabpQnJPWzs9gUzL4GKQNLYKeMuGJd6N431hZ7tP3bbwjY3yZ4NfNSIiUjc23SJnvnY/sUJ0ET+iswmvCrGCAO1M/aCwWzOir9d5j3b4AjHoxRHWsuPNDy2EE/xTdg+WPGAT4KesB1YQPjjqTZPuaQCqEgL8XAG26ATpF7VsKiuK7AzNEmDEHGmV7ZIDxkUhfRl/Zc+JkwckKuoRBLcnIS5fK8IcWTDsPcNWo+F1xOkFUqFGy+d9VE35SxnB9SbceyDCQTBDvq65KA8SxXkgN+7JohDNt0b9BLaYQ==
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27e8f5c6-12d1-4298-9e56-08d85a614102
X-MS-Exchange-CrossTenant-AuthSource: DM6PR01MB5802.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2020 16:55:02.3842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4A9vmNbWq0OloNcyrk+NwsKxL+EdTAtCQUM3tnlRasltlkOUH8lZzdJN9CzC4veSVba98zGjszozygsOPSobAksVSZCPwq/TKI0naNddgvTqhNSVepvHXi3kox5Ngn4P
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR0101MB3147
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 9/15/2020 11:31 PM, Greg KH wrote:
> On Tue, Sep 15, 2020 at 02:30:34PM -0700, John L. Villalovos wrote:
>> Add support needed for the Renesas USB 3.0 controller
>> (PD720201/PD720202).  Without these patches a system with this USB
>> controller will crash during boot.
> Is this a regression, or something that has always happened?  If a
> regression, any pointers to what commit caused this?
>
> this really feels like a "new feature" addition to me, unless this used
> to work properly.

It is not a regression. It is a crash that occurs on new hardware that 
has this USB controller.


Without this patch series, hardware with this USB controller will fail 
to work. So in the choice between "regression" and "new feature" I would 
say "new feature".


Thanks,

John

