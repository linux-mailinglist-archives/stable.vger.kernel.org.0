Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C17035186F
	for <lists+stable@lfdr.de>; Thu,  1 Apr 2021 19:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234598AbhDARpu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Apr 2021 13:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234789AbhDARkI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Apr 2021 13:40:08 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on20717.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::717])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20FD7C08ECBA;
        Thu,  1 Apr 2021 07:02:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OqoZpF8igR/B1zLphaj2SvoQ7E5Qqgvgd2L1BdBXe6nPXfpPIO8GBCnl8FGdTJxi6MSuFQEIWiuVT27oDwAmK/2ec54bkCpcFA18oyOlWcyprZsJmKfKWrQ2WBJowCiOnyp24yBWemfHksWC7V7l4z8z+ilQnRYqBFCDPbWtv2Ri61IshteNzJaVcnZKZu+FJdhfbLhDHub3ROKDaZFoMgT5GfCCf/XO5nLbcgQB6+nYBO4FfckZCNFGVQE7BTHGksmBQWfIawYGfM6qayMUmGsehZQvpbbODpFenQXm/UTyecS7us+6Bs+3dm2/DI4blCbMVxGqur5xJDi4u5V3Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HyfdVZyDorTvynWb/IRwWQGkaL3yTvHCwP/IYac+a2g=;
 b=Y2e7e57W1kqVyPDOHJeQ+kTReHdaTlSkEKWlf7NJ3Og8zKjb5X0TsqeYqOa0TQUXZqbn8pcX5ghuaVoNhy7W+lEMoFNXmw39lb79ExxlDKlDztuZlef2vaJ8v1jnjhRaSKHeUqlsAWExLcGk6H67Y0MP/StQnnSFwkd3eW5cjw+Y7aKoPZL5FcLobFJOXrMxZhc9S22TSwmWVAGIcRE8QGBKw5h58Fi/GK+t8QAYIl4A01Ao79/p4DMp05TV/iAZBdoDSCkqejGIg4zakzDtYG+AnMdKgQVFv0iVDad3Isr4lw2vSHnSEMVzLwJvD1Z4NmEwKIng8oao9PXVKi1R2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass action=none
 header.from=cornelisnetworks.com; dkim=pass header.d=cornelisnetworks.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HyfdVZyDorTvynWb/IRwWQGkaL3yTvHCwP/IYac+a2g=;
 b=FElNOt0hA07bcUkl1A9C5khnnEqCsMJ5jxIqIJ1whUpGti2cdvQZBSQgvdGkrYf8FDX4fGF4u9/cQcmdLQzfM6NsJso0XBtWxeI0eSVqCI5jvADEYedXRHmRyZQpRUuCc+MOixblk4eZtPWxezVEisFw0bI+kQLo2l2wxwFgZQEcFIsV4QkzF2Hsezd5HkVIJtSJ+9RVkfQbmiCsnpxgJtwCSq/NRG+xZXFoeLr6vVpxQaoSV5JQlNuOD5BPrRlr8/j13bUh3RT/yCcMekooN45/hvGh3FrigOOD2p+gQ1Jht8aUqesRiPdExaHCYnoGTSIiMSaIb9Ba0lK1L43h1g==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=cornelisnetworks.com;
Received: from PH0PR01MB6439.prod.exchangelabs.com (2603:10b6:510:d::22) by
 PH0PR01MB6471.prod.exchangelabs.com (2603:10b6:510:b::11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3999.26; Thu, 1 Apr 2021 14:02:40 +0000
Received: from PH0PR01MB6439.prod.exchangelabs.com
 ([fe80::75a5:79c6:dd14:3860]) by PH0PR01MB6439.prod.exchangelabs.com
 ([fe80::75a5:79c6:dd14:3860%5]) with mapi id 15.20.3999.028; Thu, 1 Apr 2021
 14:02:40 +0000
Subject: Re: [PATCH for-rc 1/4] IB/hfi1: Call xa_destroy before freeing
 dummy_netdev
To:     Greg KH <greg@kroah.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, dledford@redhat.com,
        linux-rdma@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>,
        stable@vger.kernel.org
References: <1617025700-31865-1-git-send-email-dennis.dalessandro@cornelisnetworks.com>
 <1617025700-31865-2-git-send-email-dennis.dalessandro@cornelisnetworks.com>
 <20210329140922.GP2710221@ziepe.ca>
 <7da1174e-97a6-3933-ae35-166a9dcbf38e@cornelisnetworks.com>
 <YGVi7uT9kyfk7Mo7@kroah.com>
From:   Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Message-ID: <5d90f5b0-c161-bba7-5151-4d8a1c679b44@cornelisnetworks.com>
Date:   Thu, 1 Apr 2021 10:02:30 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
In-Reply-To: <YGVi7uT9kyfk7Mo7@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [24.154.216.5]
X-ClientProxiedBy: BL1PR13CA0166.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::21) To PH0PR01MB6439.prod.exchangelabs.com
 (2603:10b6:510:d::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.40.159] (24.154.216.5) by BL1PR13CA0166.namprd13.prod.outlook.com (2603:10b6:208:2bd::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.8 via Frontend Transport; Thu, 1 Apr 2021 14:02:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4966d9ad-0e20-4467-aeab-08d8f516cfad
X-MS-TrafficTypeDiagnostic: PH0PR01MB6471:
X-Microsoft-Antispam-PRVS: <PH0PR01MB6471FC591CEC04D9B8C6932FF47B9@PH0PR01MB6471.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tEZnPG1M7XNuXf5/7JlvkQuT2INBJ9nCgJNI4rvOxatGn5fN5+ETQuI3icL/n69+UwY8OeqXjhWpxb3aSxTpk8U+oQvlhGIxrpUt6M5FEugFo6wYKDnVSjvLMnjPembRK+No/F9FuWeNqpZCva9RJPM443jiYBZ2OXBcJhsPm3xXIAgqO1CYPToQZZWyg1shqaf3CxhIrG6eDlEhXWQXT5nIXErH41eSOkb1hSGYwkShXAUJiE/64IkMMC/ovL2DcLXjPXHm8U8GOi/g+o0fZPENv+HgGqS+eqnoOmaCUovQ048BBRVKB4ZioEgX+VPhFTCektVrXDecdfyqSMfkqHU8UT556XDoUIs8Vy/U53MdL/Jlui8WucfYooB6XwuuLGaZNXZDMUfZ14ezaTZgCkyTEYgBJImyXT4WnDtGkm8TSIjp+h+q9SMu0OaI9yUpX+kxfbVPW5qz6rjQBRGTgtza1+wXJ+b9fbXAq34jWbmqOqUHOFYRdhNqBE/CjZYNLIrdGf7RaLockaMUla7I7KLj8BaEwssR4jgJJH13l9xNdzTPNSYULagRe4ZI6c0N6W9TGp3pIVNGYw4WURSg62G7ueg7BuYhiTWm5pT4wSxsRFJ3W6hjaAp+vUyTQh1tm/8BiyCb7O96r8GDI064YP7do/SwK92hDEpSSR9RdRHbnS5zkgtzsPWl+KExxhAZ0r5uhHyjNTPbH1tAKewXm1i+OZ53WC+bcXYYZPOQGRb24uIouCDRxBdZKlhmV03/yO9IHhPOKTv2xR4FoKcq0Pv6mV4A3I2XrnM7Hj/SqPM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR01MB6439.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(39830400003)(346002)(366004)(31696002)(31686004)(38100700001)(86362001)(478600001)(2906002)(8936002)(52116002)(16526019)(66946007)(66476007)(36756003)(54906003)(16576012)(66556008)(44832011)(316002)(6916009)(6486002)(4326008)(53546011)(966005)(26005)(2616005)(8676002)(186003)(6666004)(956004)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dTB5bFNOZUVTR0MwQjN0R0QyUjl0RDNuSnoya2JxRWp4K0RMU1JtN1BjT1FN?=
 =?utf-8?B?ektaSDhkclhsOU92bWx6N3A5YXQ0eDJUQzdRbVBqRGJESTZucUtYS1llOFBP?=
 =?utf-8?B?ZTlPMVNSTElEOFJ2NytSNjc1NFROdjdCZUJsNk9pN1NobEY2bFZFUGFSYlV2?=
 =?utf-8?B?N25WeFIweEExQ2ZDdCs1dWlnUUI3c29iOWN1b2FZc3lxdDhodFNHazdFY3lG?=
 =?utf-8?B?dEF6Sm9LN2RvUWJMWFNHRHlYM1ZtcS95NVRMY1RaekFlZ2JENHAzWXJQOW80?=
 =?utf-8?B?ZmZ1azNHSDlyZ1h3bUsrMk9GQ2NPbEZDb0hteGVLMlRweEtDZmxNUjVBaHpQ?=
 =?utf-8?B?K2RIcjk0OEd4aUxEUWlPbmJqKzJOV29rY2FoeUFmMncyWCs4ak4vbEVtNWQ5?=
 =?utf-8?B?TTNQTTZ3OGEwT1dLT1d0RTJVcWJReU1Pdndsd1VBRkwvOXpySEM2amtKSG5Q?=
 =?utf-8?B?MVk5R1JpYm5iaDMwa2s0K0lnM0txS3NNdTZkUnN3bDhRa29Zc05JRzBvR0d5?=
 =?utf-8?B?eE9IZU9TU2xTSjU2TWRrdnQxaUpSbmdHV3M1RTVWSXlFbzlvM1dHTS8wMkgz?=
 =?utf-8?B?RTFwZGNuTDAxUVVoMkhXWDkwUTRrbksrQ0ZnblhtSjVNRDJBck9GekdMWTcy?=
 =?utf-8?B?RFhzdk5pWTJxWEQvT3ZqVjFlRE1USW9TOGNOQjQvd0I1R3puVklpZ0FzQjhN?=
 =?utf-8?B?U1NaNFNDZ1RvYUFER21jYjQ2K081UGZJb25ubVBIRS80VmNzYStLTXZCM0Vr?=
 =?utf-8?B?dkt0ak9oWGgrUVJybWNRaENHOEVod1VrOUt1bG01TE1RajFvYTVraTZjOFVO?=
 =?utf-8?B?T0hqeWlIejZscFdhRHZGWk8vbkxmVmE4cmhRaWs4ZU5PT045WEt1aklhYkoy?=
 =?utf-8?B?bFJyV08vRnpyd1BCZnRRMThjZzdGbkovRk9QYitzbkM1ei9scDQ3U2ZqeFlk?=
 =?utf-8?B?Y25nbXV4aVMyYzBHQWVyWDNJbVAvVHZWMkRnM0tpMnIzTndZYW9TREtpcjBi?=
 =?utf-8?B?VWJtekFkUkpqWi8zMXpZTjBJN0NlbWF4Y2lVOHpSWmF4Q1hvWldpWnJ2dXRp?=
 =?utf-8?B?RTdnOGR5Rllxc3ZBSVMzSFFDUkhQSTg1RzhjQ1M5blJUSHV5RUMyRmg5NGhm?=
 =?utf-8?B?eEN0c1gzMGFSV3lnSjhHTUhYTVdBWityazVxYzdHRlAyQ3hXNVpEM1g4Skpr?=
 =?utf-8?B?MUlwM2JobmhST0lpdGZ5ajVwQU5LdXRpYit6Q3RBN3BHMEo3ekd0MzMwdVVp?=
 =?utf-8?B?NWtFMzBSTFNndFh0M0xaMVRMYlk2S3VhQ1dTdXM0VlVKeC9EdjlNZVhzZXBk?=
 =?utf-8?B?dzB1b255MUlScS9kMXdWeGU5empPVHh2cUFCc3gvSDM0RkgzMEhkZUdZYjhU?=
 =?utf-8?B?RnF6T3NPTzVTMCtHVUd1bHdaUGV1dEtacUU3Q1p2ZExvaGlpN3E1OGIxZkJt?=
 =?utf-8?B?VXZPV1MwTEJpNjFhU3RGMmhMcnVMYUNWdFVBS3JxdUVIekZIWmhDb1czRGpF?=
 =?utf-8?B?ZklmNGtseEtCRFBjZS92bEJGTTY1b2RQY0hNUWFJdXZ4QjlMcTdZSVU0OGxj?=
 =?utf-8?B?azY3T1RCY2IydkJmUWJrdkIrT2YyRStCenpOVDF2V0Z0NW90RjZlcytTRXda?=
 =?utf-8?B?TWh1b0gzeHpReVJEMksyUGZpNmRaWSsvVnpadUdNcndZSkdwQXZNWG1Rd1Rv?=
 =?utf-8?B?WWw1eitiUi9wNGdjM0JEb2tMWGlZdkk4MGJLcjgvTU5oY3A2dGhXeXdlaTBq?=
 =?utf-8?Q?yfE7sZcvxyqLTAtCFJouWWRivRhi5nTOaktTcpn?=
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4966d9ad-0e20-4467-aeab-08d8f516cfad
X-MS-Exchange-CrossTenant-AuthSource: PH0PR01MB6439.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 14:02:39.6810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TWnjv8Da+MNDtLPDNxjtJ0+BYI3Sk1czS62aF1pczOeSIITNoeHgf1MWtJDa3MgL5mm3sD552niGkalHhVdzvhPGJdi5FlKkMmfx9vHPGNRQMS8DWtK7YGu01EBrm6H/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR01MB6471
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/1/2021 2:06 AM, Greg KH wrote:
> On Wed, Mar 31, 2021 at 03:36:14PM -0400, Dennis Dalessandro wrote:
>> On 3/29/2021 10:09 AM, Jason Gunthorpe wrote:
>>> On Mon, Mar 29, 2021 at 09:48:17AM -0400, dennis.dalessandro@cornelisnetworks.com wrote:
>>>
>>>> diff --git a/drivers/infiniband/hw/hfi1/netdev_rx.c b/drivers/infiniband/hw/hfi1/netdev_rx.c
>>>> index 2c8bc02..cec02e8 100644
>>>> +++ b/drivers/infiniband/hw/hfi1/netdev_rx.c
>>>> @@ -372,7 +372,11 @@ int hfi1_netdev_alloc(struct hfi1_devdata *dd)
>>>>    void hfi1_netdev_free(struct hfi1_devdata *dd)
>>>>    {
>>>>    	if (dd->dummy_netdev) {
>>>> +		struct hfi1_netdev_priv *priv =
>>>> +			hfi1_netdev_priv(dd->dummy_netdev);
>>>> +
>>>>    		dd_dev_info(dd, "hfi1 netdev freed\n");
>>>> +		xa_destroy(&priv->dev_tbl);
>>>>    		kfree(dd->dummy_netdev);
>>>>    		dd->dummy_netdev = NULL;
>>>
>>> This is doing kfree() on a struct net_device?? Huh?
>>>
>>> You should have put this in your own struct and used container_of not
>>> co-oped netdev_priv, then free your own struct.
>>>
>>> It is a bit weird to see a xa_destroy like this, how did things get ot
>>> the point that no concurrent thread can see the xarray but there is
>>> still stuff stored in it?
>>>
>>> And it is weird this is storing two different types in it too, with no
>>> refcounting..
>>
>> We do rework this stuff in the other patch series.
>>
>> https://patchwork.kernel.org/project/linux-rdma/patch/1617026056-50483-11-git-send-email-dennis.dalessandro@cornelisnetworks.com/
>>
>> If we fix it up in the for-next series, what should we do about stable?
> 
> What does stable matter?  WHy can it not just take the same patches that
> end up in Linus's tree?

Guess it's more of a general question. What is the best way to handle 
things if the code changes drastically in Linus' tree, to the point 
where the bug no longer exists there, but does in stable?

-Denny
