Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7E6168241B
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 06:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbjAaFpl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 00:45:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbjAaFpk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 00:45:40 -0500
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01olkn2047.outbound.protection.outlook.com [40.92.107.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 327F32BF28
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 21:45:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DM7qfpOVYFKLh/09Zf3rCBe5vZkYVA2KmAbh/8z17sGUi1yId9K94MBLJsvl1dbvyiFiNopbcYnYnJZPpx5Wuyi+AmP0TF940H2ae8YJvT9obaPU3AQXVSCxiYbTBUynHteWWWtuVJn9IQVWE17KyuFsCyjus1yE1hJwQ3J7rqqFFL7v5sHrl3wD4JMc3dKTQx8WQs8zfJLiXGcZmMfrCVc4sjWradGjBzsV2BBhIqzIKO3/uoMyCHAn35bn5tUQVDkLCpyy9CFbHKo5ar2k6gldOcagoTjyK3ZthEip4zqGC3QKanjJBVkZ88bUiyOcGTaueFRKq+NoJ5jh5Lcnlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RDQ1TgS8RjqOhyiq1mVId8IMr37b3vZ7hnckRcEnTK8=;
 b=IWKgQERUUeme7ABSh0F0DXb+f7GZkrjK0gfR4eGY7e9GG18TEO9SVlQOFnw1ym24BdKTw4dQt5hh63og6GCpGz6u0ubWqto4aNSb9Bt3DqnE+iRFosxQidsZ7o1cLsV+MRiC0VGsMRJcjQ77y9pCyVTSPSrLU0ooUwQZWUsEksungkQ0C5Vo7FOW3fzLzhc4bOp+oDzfUWxcvkFUejpQdli85nJcu2+AhAOB++GN8mwZeiY518OXqWYH76xXfk8yJ4qgeFZwdy9KuQxbtQOXFbvIRgU806i5dWkw8kbz/NoP0ZBKivsy081IrEHeynbfjrJMAXBAsqzk5O7+dGkXaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RDQ1TgS8RjqOhyiq1mVId8IMr37b3vZ7hnckRcEnTK8=;
 b=Vg8PqAWL1wDMSW8LzTAd1WACDD9iTOToqysajqok9AwBzTmF3ViK3m+iwyCKOb/633ElClV1q+3skZoB/mEAjIgS6ouzqckNHVrlkQUs3TbC1NQ2I9kUVXCa+RnhlUTstAPmG7jWR2iXD/Ki7j0P8HFvAxvZRmJE1bMnmL1q8lzJ9vPJuxyLSdXdXHBAu0uPVve058pxNWwb/ObWmIGjqBxj261RZmDJpb/O6jmdGf2d0SiIMkBm2enKy75ppKoCeCep9nr2SPpNOboluC4p7ZM72cIr85Zz8TMvFKE/Tfl55S3VmEAkgo+DxTuunlj7Csy3ooTVWYoBcGKzEYH4xw==
Received: from OS0P286MB0193.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:aa::11)
 by OSZP286MB2315.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:181::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Tue, 31 Jan
 2023 05:45:37 +0000
Received: from OS0P286MB0193.JPNP286.PROD.OUTLOOK.COM
 ([fe80::202f:5bbf:ade5:e4f7]) by OS0P286MB0193.JPNP286.PROD.OUTLOOK.COM
 ([fe80::202f:5bbf:ade5:e4f7%3]) with mapi id 15.20.6043.038; Tue, 31 Jan 2023
 05:45:37 +0000
Message-ID: <OS0P286MB01937E0F8CCCB0F83D8FF6C8B4D09@OS0P286MB0193.JPNP286.PROD.OUTLOOK.COM>
Date:   Tue, 31 Jan 2023 13:45:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: Bug report: kernel oops in vmw_fb_dirty_flush()
Content-Language: en-US
To:     Zack Rusin <zackr@vmware.com>
Cc:     "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "1029602@bugs.debian.org" <1029602@bugs.debian.org>
References: <OS0P286MB019398DDFF6011038AD841C0B4D39@OS0P286MB0193.JPNP286.PROD.OUTLOOK.COM>
 <accd0313931a3633a7e1997cb06bc824336f1f8b.camel@vmware.com>
From:   Keyu Tao <taoky99@outlook.com>
In-Reply-To: <accd0313931a3633a7e1997cb06bc824336f1f8b.camel@vmware.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TMN:  [vyOS4CGO3TFV8VM+hQUxxtO9Jjdu9H+LtfSlVjqY3vlc1gd5kNFVJGJ6T5teYRbb]
X-ClientProxiedBy: SG2PR02CA0075.apcprd02.prod.outlook.com
 (2603:1096:4:90::15) To OS0P286MB0193.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:604:aa::11)
X-Microsoft-Original-Message-ID: <7b7f71fe-5335-81ca-a558-08d37b98f6e9@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OS0P286MB0193:EE_|OSZP286MB2315:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f0b8486-1966-4b1e-2beb-08db034e6080
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vnhgYjpfufKhrwxso8sZOW/kqR8QKJ6rkBrNWSw2jRsjWmM30bWvtpWM/APmxZdxDCWIQVJNOCUt7XVIuYF+knaxwsEerCUj4Ky9RjjuBW9y7Pi1lMcQubK9D0Fm5T1J4kqE/l//xK8EjcM741UYZL4jstZmom7QNL1xlEOSWA244Aep3R6Vqzp1XKRd0xpP3W0jDAsP56l7X29fr/YqGt1+HV8MuB+pg7/3NDV0ZJ3DSZOSCuiS8tvxyf1fTL88cZk771p4b51ZPv7fRfXvKReGdHgi0TjWZW5Xzqn9M3yVrTRwmQ1azjJe6x6vfzlnipLAqLhV1eyhJQCiw4PJYC3QNFA8IbWkTXQnHRpXkIxsmomlWBDwbuLwqR8FzadXgZ6yMLmiHOoej4wRBrmJ57RlaBjqfGjhzM9DNryPv9pIGJgpTZ2jEJHHxgS6LGEwt32f5KkSXSoAQ52BeRKwsJHWsEx7UsH7CgVGniqJHAjhntopAuSgdHEGXD4pxdUjFESGcdmqsoW7z/WYFcg+dO3BxqneSDwCm1+u8Uer6rcYEw7hfh+Q1GSIq7E/Lww/AUvzgRzDwwgyJakGOC3iVBClp7yRadKO/SyXIexb5lmJVkyY29blSaaWLD8UUTZxLrTGuNTcKLGz0Gg6Op6ANA==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b0xMdjdOSXdSZ3doV241UFVDZkFZTzJEMm1udmFqRVpYZElxS0NkM05DQlhm?=
 =?utf-8?B?d2ZoSHZ3eVNnSXp2dnU0OHZ5WWRkaXFSdkhXamFvSjlPZjV2ODY5WWQ5dEhG?=
 =?utf-8?B?TGxmcnhyZTZoeGJsdDNaTTNEWGh4ejBsdENxY2ZpT0lGbURZZm1ybjE1RGpV?=
 =?utf-8?B?TnRsZlZ3dkNBTjBIcHdGck5MbDk1cERONFJaSGFReUM3cDVydFNTdGVmbk1r?=
 =?utf-8?B?V1RpU2xoM0JmaWNmbkE0NkZ0eFhFSmM3b0xhVm5RdzRIZG1wMWVKdU1JQ2Nk?=
 =?utf-8?B?T2s0R2ZlaTdyUkp6cDBveE51YVZrQnFpemFCQUlnbmZ3dHR6NlpUcExJWHRK?=
 =?utf-8?B?eW56M0k1MVd1VS8yOThQWHNCVExCWDI5em81WlNxNVJwcVZXck5XbGRLZWJI?=
 =?utf-8?B?ZXlpK1QyalJ0LzhaV3djRExaY0VtUXRBbzVWQXNpMDRMa3hrMUFPWUxrWG9E?=
 =?utf-8?B?cnZlUUdqeVNHaG42ZG9SZWNGVGcxZVdKN3pKV0xUVE9EZWJ1ZC8yWksxL2Nw?=
 =?utf-8?B?b2M2L1pacG0vN0I5UDVzWXE0K2J2R29henZDRWhZUXR3ZE92RTJjTU5tSEQy?=
 =?utf-8?B?c0NnQ2pQbnRWVlN4LzdQbEVPSHhjZEcwYmVtM0E3eWJ6WDQvVy8vWFh6N2dw?=
 =?utf-8?B?L21MclgxYm9uYjFlOEJBd3JCaTRTa21VMm9ZVDM3UCt1MzNMTW5uQytZdEcx?=
 =?utf-8?B?bWdRZHEydGU4TFcwMi8xdGtIZW93dHhleGt3SXpZMFhzSWV1U1I1SURUZkJK?=
 =?utf-8?B?Y3V6amh3STVMMzdKdnJZRWdSU1kxNlhPZzRaODU4aVVMQm9YUVorWWFob2Zk?=
 =?utf-8?B?Ti9nRU1nczZhNU4rNEhIWjlkdThXRXdRMjFUdmNsYU5obkJoS3FlRkdST3ZL?=
 =?utf-8?B?K1N3M3BTL2JSbXBTTVRzekFLMlllVEptUnpYTUpWVFdKblhzMGNiSUxUMjB1?=
 =?utf-8?B?T3R3ZFA1Q3hnRXpBcGplNm1mTUN0Y3plTnk4UDN2UGtTOCs4R2NPSGQwV05v?=
 =?utf-8?B?Ty83NnVaSjFIZlNleittaE5pNkpycUNiei9pYVZuWmhrVWtKVDB2a3Z4Y1k1?=
 =?utf-8?B?cTY1UEtjYWpmcUhBL2xFajc2UCtIaS9nWkcwa2ZhTXpvUXQwaStmUEt3ZnR4?=
 =?utf-8?B?Mk9XUlUyaEhuRWN1d3J0K1VWdXpHaGdoNFBYcmJXUm41WndSRUFzcW5zV1Jh?=
 =?utf-8?B?OVBNVldPSXROU3RSaHYwRTQ4LzdaN05pK2llY1c1Yk1Fc0cxK2NkWEcyTEtk?=
 =?utf-8?B?TXFrSXZlZnNFZVoxZWp6WUQ0b1hFVVovOUw1SWt2Sy9kcGNHQ091Z21ybW81?=
 =?utf-8?B?WTkxdmJDZWFsSW52THlvQjRPZC96UmIxZ0Nra2l0Y0VLNitpY09YTUkrblU2?=
 =?utf-8?B?bWdncFZFUitrbVdUSEEzVnZ6cEQvdTZZa2x5STdETzVCZlo0ZS9DNExBVDNJ?=
 =?utf-8?B?YlNGRUwxNVdLa3JmNExXRExrZnJzRGxYSXZoZkdYazF6VWR3dk1nT0dLZHdy?=
 =?utf-8?B?VHJZMGpyTHM5OHhXdkRoYjV4WFNpdjI2cjN2TDArMk1RRkIrcjZKWkF0THU5?=
 =?utf-8?B?VUxvbEZjTXFLN1BMeVlRdVBBQnVVdCt4ZVNXZ0YzOTFwSllya2NrR2w2Tk9r?=
 =?utf-8?B?Q1NwUkZYMWVqZmVXNCs0ZUNXQjloL28zb1NQYi9mMmgrSWRyYlhwZW4vZ3g5?=
 =?utf-8?B?dkxIZnlUUEVzUi9URmRTZ0xDZkUxOENLV0pKczQ0UHV2ZUNOZ0dvbzlLQ2VW?=
 =?utf-8?Q?0ZsjvoFdCrmqoZKjlOf9dWqr5D/Jg1DyFbGmaYv?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f0b8486-1966-4b1e-2beb-08db034e6080
X-MS-Exchange-CrossTenant-AuthSource: OS0P286MB0193.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 05:45:37.0026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSZP286MB2315
X-Spam-Status: No, score=0.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,HTTP_ESCAPED_HOST,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Rusin,

Thank you for your timely response. I tested that this bug is not 
reproducible in v6.2-rc5 yesterday.

On 1/31/23 03:54, Zack Rusin wrote:
> On Tue, 2023-01-31 at 00:36 +0800, Keyu Tao wrote:
>> !! External Email
>>
>> Hi vmwgfx maintainers,
>>
>> An out-of-bound access in vmwgfx specific framebuffer implementation can
>> be easily triggered by fbterm (a framebuffer terminal emulator) when it
>> is going to scroll screen.
>>
>> With some debugging, it seems that vmw_fb_dirty_flush() cannot handle
>> the vinfo.yoffset correctly after calling `ioctl(fbdev_fd,
>> FBIOPAN_DISPLAY, &vinfo);`, and then subsequent access to the mapped
>> memory area causes the oops.
>>
>> As current mainline vmwgfx implementation (in Linux 6.2-rc) has removed
>> this framebuffer implementation, this bug can be triggered only in Linux
>> stable. I have tested it with vanilla 6.1.8 and 5.10.165 and they all oops.
>>
>> This bug is reported in
>> <
>> https://nam04.safelinks.protection.outlook.com/?url=https%3A%2F%2Fbugs.debian.org%2
>> Fcgi-
>> bin%2Fbugreport.cgi%3Fbug%3D1029602&data=05%7C01%7Czackr%40vmware.com%7C63862e731c
>> 3b4a97796808db02e03145%7Cb39138ca3cee4b4aa4d6cd83d9dd62f0%7C0%7C1%7C63810693415592
>> 2769%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiL
>> CJXVCI6Mn0%3D%7C2000%7C%7C%7C&sdata=uVOtDBAyn%2BDx5w8r1twuKO4Xd0Lma6zCr2ie3lQ%2BRR
>> E%3D&reserved=0> first, and
>> the maintainer there suggests me to report this issue to upstream :)
>>
>> Relevant information (for self-compiled Linux 6.1.8):
>>
>> - /proc/version: Linux version 6.1.8 (tao@mira) (gcc (Debian 10.2.1-6)
>> 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2) #7 SMP
>> PREEMPT_DYNAMIC Mon Jan 30 21:09:02 CST 2023
>>
>> - Linux distribution: Debian GNU/Linux 11 (bullseye)
>>
>> - Architecture (uname -mi): x86_64 unknown
>>
>> - Virtualization software: VMware Fusion 13 Player
>>
>> - How to reproduce:
>>     1. Install (or compile) fbterm
>>     2. Run fbterm under a tty (by a user with read & write permission to
>> /dev/fb0, usually users in video group), and try to make it scroll (for
>> example by pressing Enter for a few seconds)
>>     3. The graphics hang and it oops.
>>
> 
> Thanks a lot for the detailed report. Is there any chance that you could try any of
> the 6.2 rc releases to see if you can reproduce? We removed all of the hand rolled
> fb code and ported it to drm helpers in change:
> df42523c12f8 ("drm/vmwgfx: Port the framebuffer code to drm fb helpers")
> which for the first time got into the official kernel in v6.2-rc1 . So any kernel
> after that shouldn't crash with fbterm, if anyone could verify that'd be much
> appreciated.
> 
> z
