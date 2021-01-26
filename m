Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53878304BDB
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 22:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727483AbhAZV4K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 16:56:10 -0500
Received: from esa1.hc3370-68.iphmx.com ([216.71.145.142]:31952 "EHLO
        esa1.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732735AbhAZR3t (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 12:29:49 -0500
X-Greylist: delayed 326 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Jan 2021 12:29:48 EST
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1611682188;
  h=subject:to:cc:references:from:message-id:date:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ktSy6tjjtPLYTkYFEYWkWhkT8/l/YxW3r48HMuzyB5k=;
  b=ZckTG24sqEdgs/jWhm3iYFi3zET7sBjHo63nwysvkZrcQ1Y3w39bYwfc
   mPbQx499ZwjFsknZSc2oFj45wn/Xt/Mbbx0i5Dmpwu9AyPPrL3ktrORnG
   pzePfx/WM1Oi1y9Cw9K6QBBRVD6AgrXSBYQu3o0iEbBu2A9uc+Q9xJ6Fm
   I=;
Authentication-Results: esa1.hc3370-68.iphmx.com; dkim=pass (signature verified) header.i=@citrix.onmicrosoft.com
IronPort-SDR: Lp5TFtVM00pkPgaNGhUdBqhlZNMzxb6hXhtQjW5JoLp+Kp1kSq+p9cEsS4WMx8Ly7AvoLNR+PL
 QalhoZ7AxjubF8CnjHIbb4O8RvkWTYCaAGKeHSNOy8EaT2TNB1Hvf81avL/UEZoAyb2guhaRW2
 MP/Nattb4w4GVst/XsKwyESiGvCaFdQe8xAANZJBdXxrxEjOtB0BsU7qNZV9pi7VNPsK903LZi
 PLaG0Avdt8quHRZXJzeaRnjxSBpFV7lf/MVFmHP4GRIqA37A3q65XXza3K9valIS+ynHqHgddX
 O0c=
X-SBRS: 5.2
X-MesageID: 36265250
X-Ironport-Server: esa1.hc3370-68.iphmx.com
X-Remote-IP: 162.221.156.83
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.79,375,1602561600"; 
   d="scan'208";a="36265250"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CpjJ8lp65THn+6rPBL7/uOiTp1EpUabZPOwBgJ2CeZXogVR3iJ3QXfdVt7t7uAkvki6HMqlxJZVGZfdqsU5qTLsK4OEmRElqDN3ERQmzRUTv7xW6aYH8sSXwwNUWMlHLB8HlOocxOi0vu5cVQ930QhKV5UELJ0/H/0h8gOamPAM/7oQPzhqOQ/ifXNOqlv3PQcsRJW+fydKvX2Zt/SJpZRy3EHevL+bXXiPEfs4C+kZC3FmreR/WXYrFJPLbQ6pOFa3cgxyWHv4tZWPvskmHBrV2cmahDMWK1LBjzdujDvHPnmgmPfLGgLsG+oBzMdhXwdT/oRSfqRYu/CK1U/vD6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DbwPhCPnskchRDmL1tvYgzjZ8Efur8tL/415t6LC6v8=;
 b=G8DBWgIHrnybAnsAEyFAGVdDT2iMVaQEkrAPdCo0aDiFkegf9xDb7kzV7fBEZ0ECYNG2z35q6E2QqmaNdtyEBJCpMqAQC0nFzBRzWYQQmkk6Z0JzOmnhI9G4GuS3sK0HLqXI994+hkEP2cFPGYWM7BFsM/fMuhEUnuDd/9CIN1BVVjy9a29YtGHjySzlsRH/8QzDZm14jb9uLU39UBd3VFZd9PFRzeCWKbQnh4WoUbFJCCn8/3ikLHrIJw1MRcpWzrA19x4ZVWOKRm+llevRg7F9L96/bFtwF6FbC69I7X454RvzT54a1a56OF3EhTzbgL3tRKcbPS1BPAkNfisOtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=citrix.onmicrosoft.com; s=selector2-citrix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DbwPhCPnskchRDmL1tvYgzjZ8Efur8tL/415t6LC6v8=;
 b=BHb3r//0dDy/nIIvVT7Q1QGIMBHAyjPhn63cbAE7n1g+cZs3+EVgqGCU2ATuHryjGIP1vWrCmsWcuW5iBQsBYPa5+5nfk6ec4S9SKjqK4ZRGUDk203dmqawiL7Q15aLAWQsXdvXP6RXvRR1C5vZ6VFuOHSQVccAohOD4lYNHj0g=
Subject: Re: [PATCH for <= 5.4] xen/privcmd: allow fetching resource sizes
To:     Greg KH <greg@kroah.com>
CC:     <stable@vger.kernel.org>, Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        <xen-devel@lists.xenproject.org>,
        Roger Pau Monne <roger.pau@citrix.com>
References: <20210118140426.80458-1-roger.pau@citrix.com>
 <YAgN7hlFe73mrBWE@kroah.com>
From:   Andrew Cooper <andrew.cooper3@citrix.com>
Message-ID: <1a70f632-1437-5501-faac-98f05380d5ea@citrix.com>
Date:   Tue, 26 Jan 2021 17:22:59 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <YAgN7hlFe73mrBWE@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-ClientProxiedBy: LO2P123CA0062.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1::26) To BYAPR03MB4728.namprd03.prod.outlook.com
 (2603:10b6:a03:13a::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9d0a0735-a7dc-4911-bdd9-08d8c21f0b5a
X-MS-TrafficTypeDiagnostic: BYAPR03MB3477:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR03MB3477CC4FF490F2F2DAA3861BBABC9@BYAPR03MB3477.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 32LSysQ65t1nI890MDCM5wdFuK+k8AdPO9df3RRSmx3G+q6pG8SPo42bE4arXcl1fD+0e9h0QXdsQGmpvNtxfVj5kbrBs2vc+7OXhRJ7DVIdou1HVOjNXCPWcOAWadXC/HIB2ozfH4wAAMA5IrUazIGI0FUevNCvjevjpPxN/s29ZpodJAQv611D9thQPo2sLzIn/OlmSHledtOGIHPkuQzXMdbdV5K08gY/hgOyI/b+QBYG2GUVJ9FSddnOu0UHNEdoGcSovhScBKbK7R+OGvbXjZbWZ3dUZqoQxlSrgO5R4ne8J25vx190vXINsTsVTrpJ+0t9I6w6Xiu9iol4e9noUKez6nBP+E1kORVRytHHB+CuRRZDxqoYWUXua9xz1F3T0Nk0z3Ao/YROSySEEjv5IM/jXjOAecWOkjhnYlwoTcTOWHblg6CGfeX2dPPdw8MeXhfiqrn0mi04R7tTGoNpIpNeE/5d1lGPUj3om2dCVp0lhWuwiIXKYzsl5bKjAaBEsPAAFqFHSuoyluYAihgxs//K2RbTkrK1fve2PLEn5rfrRhQWhZURc86W+ujaRtMMLSIYea2tbuOQZRvIBSjKZoEw//91w3mcD9LskZrrcg4wO0i8wfx0CCGUrn0GFP97cK/DjLIL8CvUFZ2uTycBeTZ3cl/VV/RYYvU2jIxm59hnB+MITMBRKYWG9w8N
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB4728.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(366004)(396003)(346002)(136003)(478600001)(66476007)(54906003)(31686004)(36756003)(107886003)(53546011)(956004)(83380400001)(316002)(5660300002)(186003)(2616005)(66556008)(8936002)(4326008)(66946007)(6486002)(16526019)(6666004)(16576012)(31696002)(966005)(2906002)(86362001)(26005)(8676002)(6916009)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WVVIYlBDZ05UNW9XSGhRS3prVWJkSmFrNzFvbm4yZFJSeDAyZTRSRzNPTC9E?=
 =?utf-8?B?T284K1hiVG9QSHU3eXo1ZjZUeVNtdkpLSWdQdjRzYmhsOEhQZXliRjd5TXJU?=
 =?utf-8?B?RTBBNDV4MTUzMWlJeVlSVE1HK3JSS08rbzhaeTYrS01EeCtpS25vWnRDdmRw?=
 =?utf-8?B?RFE4NVg1d05ubmpwTzVlQm5lMno4SDU1ZkZTOHFaMzB6UXh1VFpBQ1hMZXJW?=
 =?utf-8?B?MVhqWU54VkdtNU5VQzA0YmtWZ3U1aHhmM2MvclNteTlvWmxPMG5oandyYnBS?=
 =?utf-8?B?UjUxL2RiWTk0UEpPVHdLVjJ2WTN3NVFVSms1SERRWnc4U2xubXY3c0x5QmJl?=
 =?utf-8?B?ZVJuMVFTVG1EdDJnT3E5UHlLTEF4TkJZVzFvSWdPN2dQN1h0K1VMR2hLbU02?=
 =?utf-8?B?cEpkVjJqdWh4YnlDN0dzWjY5akJSZnBVeGR4MTE3UnpKQ0p4bkRkZXVuNUNZ?=
 =?utf-8?B?Y3B1QU9KVFNZZStnTXFHdFdMNDBiQ05nOXdPeXhwZUNJNXhpVG1MVFdTL2JT?=
 =?utf-8?B?RHY5Z1ArelVHVDk0cWRxNEQveXBkRXVzTytWdDBtbDdoOVRWUWx5MUl3M2g2?=
 =?utf-8?B?V3FKT2ZLK3UrS0lzZ1FuVk9HelNWSVBGYlovQjRWMmpQWm5mbWxJaUkyT2g5?=
 =?utf-8?B?VnNBQ3E3UFV1R0tENUxkVkdhdnFmeXBQbnNrTGE2RFFNQW12OEpUamYyeXlx?=
 =?utf-8?B?TVJQZGFkdkFnNTVUblJ0Um9WVXNyZTBlWFdqQzlRdHozSjFSa2k4cWNQaXZG?=
 =?utf-8?B?Lzc5QWx6QlVYeG9KQ2RuOXUrQmM5cW5maHdTMXVOZUxiOVk0cXNpbG5iYWtK?=
 =?utf-8?B?VWMxMTV0UmFBOENYMkdmWHUxemw0UlB6a2xHaVhTZ1MrdkxsajdIQ21QRUVq?=
 =?utf-8?B?ZnJvTVlKUEtzNDhOUU0wKzd2OW1OcHFjWkhjOUg5V1ViSTFpbE1HYmU1R1Zq?=
 =?utf-8?B?bGdieDVyMm1iL081Y1hnTEVBT3UwS3Q0Ry9DQVJNZmljNi9qbzdYTFpQeEoz?=
 =?utf-8?B?a3BldnhVRDMrRnFlaUtnRWZROERwRFNQUDU1dVROeVNMTGZwQ3pXZGh3cHNm?=
 =?utf-8?B?MVpIRElTNTVFMjR5b053QWtJeG5iYkZRV0tjc25oRVAvT293UExOWlFPOXFC?=
 =?utf-8?B?RDk4NzliUFZvVTFIV2trNHdZYUt5U2M1M3lJWWFXOVJkV0RqNGdtRTUvcmJv?=
 =?utf-8?B?aVZmR0FQdG5GZGxYZVA5Y2xxSWRtNGxVMHMyZnUrS1FsNFZIci9ENXJFcWRu?=
 =?utf-8?B?YUUzTWsyMnlNUiswYkE1N3hIOGZnOTdMbmdNLzBPYlVLZHo5QUFOdk45LzBE?=
 =?utf-8?B?enRZVFV1VmNNUU5PbXpSdXppdTJvbVJjcU54SXlGN3MwZXpRMVVSbERyRE1X?=
 =?utf-8?B?NVFvWDU3cTYxdGNjcVBNdFVaWFNPbmp3UVEraERhd3JvMW9oY2FXZmdLTVFD?=
 =?utf-8?Q?Oxyf5U/a?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d0a0735-a7dc-4911-bdd9-08d8c21f0b5a
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB4728.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2021 17:23:06.7583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NQmKYEsdouPg0r4VyTQnMBMHBXHu4c2K3SB6UF4vakYCn8D5QhxlsUO/ZSezYGPHWUgPjO1Rn3Rb0+lRvLjY4PhoEsaJ+ZdTCIWh9rq1UHQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB3477
X-OriginatorOrg: citrix.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 20/01/2021 11:03, Greg KH wrote:
> On Mon, Jan 18, 2021 at 03:04:26PM +0100, Roger Pau Monne wrote:
>> commit ef3a575baf53571dc405ee4028e26f50856898e7 upstream
>>
>> Allow issuing an IOCTL_PRIVCMD_MMAP_RESOURCE ioctl with num = 0 and
>> addr = 0 in order to fetch the size of a specific resource.
>>
>> Add a shortcut to the default map resource path, since fetching the
>> size requires no address to be passed in, and thus no VMA to setup.
>>
>> This is missing from the initial implementation, and causes issues
>> when mapping resources that don't have fixed or known sizes.
>>
>> Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
>> Reviewed-by: Juergen Gross <jgross@suse.com>
>> Tested-by: Andrew Cooper <andrew.cooper3@citrix.com>
>> Cc: stable@vger.kernel.org # >= 4.18
>> Link: https://lore.kernel.org/r/20210112115358.23346-1-roger.pau@citrix.com
>> Signed-off-by: Juergen Gross <jgross@suse.com>
>> ---
>> Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
>> Cc: xen-devel@lists.xenproject.org
>> ---
>>  drivers/xen/privcmd.c | 25 +++++++++++++++++++------
>>  1 file changed, 19 insertions(+), 6 deletions(-)
> Now queued up, thanks.

Hello,

The upstream version of this patch was queued against 5.4 and 4.19, both
of which suffered a patch conflict, and are fixed by this version.

Was it an oversight that this version didn't get queued for 4.19?

Thanks,

~Andrew
