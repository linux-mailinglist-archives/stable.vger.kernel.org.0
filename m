Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A80F41FBCA
	for <lists+stable@lfdr.de>; Sat,  2 Oct 2021 14:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233159AbhJBMi1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Oct 2021 08:38:27 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:17554 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232821AbhJBMi1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Oct 2021 08:38:27 -0400
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 192CXXUW003173;
        Sat, 2 Oct 2021 12:36:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=subject : to : cc
 : references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=OkYabFan7CPOub0J7oktjZnIc27guCb1CcwSldrHU24=;
 b=mxWRsA/GGnaWfD0Xw7QMnG6x1pMH3kS38qyIlUioL8tc5STfOCOyNQyKY9+LxBAcAzbq
 NZocTK/JTFkUzG8V65UCsi2f35ZG9r3yIuuHsicT1khnhzFlYQ2hxkHRfPdk+chwF2up
 vRua2nuCln9a4u8OdAthEEPUuAX9hiZSgDBrJ6zIbAvMCvBRarvTvzCJ9imp+dd1nBZV
 yFIpqeEWH6paHfGYDF+u4rjEjIHieMWi1JeAVVLGC6e8/xlQqq14uF0bM37vv2cydliO
 9FycYytVIE4QP4pQozvvY9SBqKKUTXcqSU2+ojQvfBeBU29MvINYDR8+Zsled1hYIyIN jA== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by mx0a-0064b401.pphosted.com with ESMTP id 3beeda0ade-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 02 Oct 2021 12:36:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R5/h56/i6TQCS61/5v09xisH5pXY/QJKkJFNXC2PCC9zI450x23kS+g/eFOxaQfoTPdZdxcK8BXdb1qH3Ec1VlipcelaEmYTiymQJqaJXgQTpN7f980OUt1ba244Mi01ILJd+6YUoYd6L9bS/zb1RmU54sYMKZUTuxkxMvM6Mpiiw9nW/A0SRWxoP8zknljSgqL3p/fuBNfrG+7GMT6AXsfRvzoC7dew8BKfeWfObRmVLXRXMlMG/cvRsKS29wZUjfKz33N14dKopnRbp102751xnQx7hEts/60EO4JTgcf6yhrIDjxnnCH7PP2j0pCAzF5/BWxdpfYc66jDoZEzdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OkYabFan7CPOub0J7oktjZnIc27guCb1CcwSldrHU24=;
 b=J96/cOzVCtVJ6iaKq5x9PSH2/jG4MWY4KrazYxuRI2eQbTsZdFDXTU0IV54oXWuXSwNr5H6rpZO5AeqDGUi5rgH+3EGD9cEOcQbtdf6536v5LcVyxyjxV6fGlCwXkHISrFwXolbMV68JxLPFS3EM0xl12vEhyHcGD325BuTQB+BOUdG8kiTbGt4H3HA00dhko6L/CU3Ic5nJz+wDYxQB3F4gJYFYf8qJsg2DTTFWrwszZf/80+ADIsbCbGs1jx7peF0L1Fjie2n4Ni7Q1g73q/4lB73da86s6cqWnhkdw05kUJqF+PO/IhKajdnYjNjNwBEtczudiRi0FJTJZXUjOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: kroah.com; dkim=none (message not signed)
 header.d=none;kroah.com; dmarc=none action=none header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM5PR11MB1404.namprd11.prod.outlook.com (2603:10b6:3:c::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4566.14; Sat, 2 Oct 2021 12:36:28 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286%5]) with mapi id 15.20.4566.022; Sat, 2 Oct 2021
 12:36:28 +0000
Subject: Re: [PATCH 5.4 0/3] usb: hso: backport CVE-2021-37159 fix
To:     Sasha Levin <sashal@kernel.org>
Cc:     Salvatore Bonaccorso <carnil@debian.org>, stable@vger.kernel.org,
        greg@kroah.com
References: <20210928131523.2314252-1-ovidiu.panait@windriver.com>
 <YVNs/mLb9YXNz7G+@eldamar.lan>
 <2c3095ae-9f67-2a38-e258-1f8d707c4fa2@windriver.com>
 <YVc9mtE329rqf5ab@sashalap>
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
Message-ID: <18e2816e-cf21-27c2-afc6-bc46fcebde88@windriver.com>
Date:   Sat, 2 Oct 2021 15:36:21 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <YVc9mtE329rqf5ab@sashalap>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: VI1PR07CA0238.eurprd07.prod.outlook.com
 (2603:10a6:802:58::41) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
Received: from [IPv6:2a02:2f0e:c515:6a00:4bdc:f623:e766:c965] (2a02:2f0e:c515:6a00:4bdc:f623:e766:c965) by VI1PR07CA0238.eurprd07.prod.outlook.com (2603:10a6:802:58::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.13 via Frontend Transport; Sat, 2 Oct 2021 12:36:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 294e63d2-b9e9-4ab4-cd7b-08d985a1416d
X-MS-TrafficTypeDiagnostic: DM5PR11MB1404:
X-Microsoft-Antispam-PRVS: <DM5PR11MB1404056B601ED325899B6752FEAC9@DM5PR11MB1404.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l+yZbtNtNIERGRm4W98uFX4Jf6GKIxVLGPS1LUfxVT8KIxls168W69S+I89KefUugAcgibNrAy/cAal/BffNB4OG+NGRIPKBi4/lzaXw92znJTW46LE1wa0uXWyLXe7PgrGhD7HzLhF7SM4TdQNWcRWzPLb7g5z3gZ+SsXd9x1u2Dm+G6XZQDIxbDAkC1x5rnavJ/9IqY016OLAPZOdtoHNZVlvIk27WDi+osRmRxYrQ2Ms7dXXi8Cv4nQwmTxq03BPYzsT63xUELTKhOtWNwa27vUpYt8g91GSnDsZ2gLrHA6uGGaqwowQ0AGVyO07VxHQoYnx2BMsgGV+7hsagz7+DK8B3vx9g7Ff+TPKZl0Imli0crZR19slRGyuGQtmIO8M9uvP80mzEG6dp4ZKa/286M6kdMeny0MCgcAm6hopB4ys1OgnY5HVoNjnbJu+Yrn70KLMZaEK9afpWzsE0RSNvrIrc2ViPu8pyHQDb9whXJaaN0WSvNslri1zBnGGc/o6gQ7e+EyacAbpqlJJqNSG4JCiOJhJ8eGZGJvrin2G73i+UdkL/s7eHW2YGnFzuYHrgMnf6e6kKMDSmHJcRYBJJhRYpyYVW7a93V+vshKMQSSxF91KgTpQpThU/X82mpWC69Yy0G7oPfu8gDplDbBB/v2cRnus6A0wmlGVH7W1K/w1fFZp4D9FThwdCRgz0p9BoR69XOGPjC8GpcfEf1B+dcicjFiYbHdbVxv67ON7XFfA4J+ey/VOnGTznDDbovo3HWh4uRJWIGndVEwzktV8jtZcAjTTBVkKInus1P2Tx5a21boTL2pCIqUuAhzNA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(31696002)(186003)(6916009)(4326008)(316002)(44832011)(2616005)(5660300002)(8676002)(6666004)(966005)(53546011)(66946007)(83380400001)(2906002)(508600001)(38100700002)(6486002)(86362001)(31686004)(66476007)(66556008)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UDhSL3ZUUGRZZzNwcEVOMHR0MklkZGtqRW1GcTRsTEp0SEdCd2QwN0Qvc3cv?=
 =?utf-8?B?Y0tSTlN5MTluRlVXcUlWRzRRKytmU0xIUlNRbjRwa3FML3VXYjVzeURrckVu?=
 =?utf-8?B?YXhHbVRpMlc1ejBSejR4RlpwNTFZbW5aWU9xVVgzN1FMMHJtZnJQdHRpTzh4?=
 =?utf-8?B?amxEb2t5NTlCYkh3TlZkUUpGVkQzbzRxdTVFOWYybTZwdFkwcUxEWlJ6N2tK?=
 =?utf-8?B?d05BOS8wd3EzVUorZE9yQ1AySWdrVFBCMWxKdmYvVXp5cTlETWNUK01xdjVu?=
 =?utf-8?B?dkx5azE2UHVPb04rUXJWUWt6N2tWTi9PazFJZUpZQ1VCajFERDJPVXgxcXR1?=
 =?utf-8?B?c0tyL1hVYko5Ym4xMG1rcVJTZGVVNFZ4UHN2MXVVRTBNNG04OWwyTFI5eWhT?=
 =?utf-8?B?bGRjK0hnS0JzWVhzTnlJRUQ4T1VGMTZCNFQzS0ZJWExzR0w3dHNZbW80WXZ2?=
 =?utf-8?B?VkFzb0VkNWh1ZXRFOU11RTBIUURMcEJrSDBxbmdsTGZrbXErSzJKc0tmL3Rv?=
 =?utf-8?B?OS8xMUpSU3QrQWpINEtsMXFGK0poU1VtMSs4Ty9hRlYvamIzaktabmdnRmFR?=
 =?utf-8?B?bnVBLzQ1UVQzWm53eGMxeFYxUDVJbGZDdU1oQmlrOW9QVTlBdDd0VklESGR4?=
 =?utf-8?B?dGhITnkwd2JtbDl4Nms0ZHllMXBmY3pOeFRuNFFLWGNtWVpyTjR5ZnlkODJR?=
 =?utf-8?B?UXRwV0wxU0JkUk5SSmczakRnaEFONEhLNVFmNDBOY09JT01ibXByUVpzVEY2?=
 =?utf-8?B?UXdKUldwaC9rWENTK0VnRVNpNmtsY1NxckplN0x1Vkc4bFFiU05EMEZHb09U?=
 =?utf-8?B?QXdKckM4V0hHay9naWt5djR6NGUzS2k0dmNZMit3R1d6OGM0eFBwb3U3SnYx?=
 =?utf-8?B?TFA3VGRucVhoQkJmbXpKb1Y2WkFIZ0V2OWNzYWFMS3VHZE5GSkdUZmowbk5s?=
 =?utf-8?B?VzJxK2pwZytyZC9JS1BnamVVQmF3Ry9nVURkdnVoOFRFUkdId0FlM2lqM2Vu?=
 =?utf-8?B?STM3TERIQThXVW5yTmFuMXp5WVFaNnQzaWswb2MrU2hxcG13UWt6UVArSExx?=
 =?utf-8?B?aEJWVHVnTHZrNEhCQjV4cFNRUWN3TVRyelZoZmFRdk5Ea25DWUlMS1ozQ1E1?=
 =?utf-8?B?d295MERCMTFvTXpxZDdyYSt1b3ZSODZ5YzdubGMvMGpwdzNvTUx3YzV3Y1hY?=
 =?utf-8?B?VDF5a2xnRGJsZzRLek1VZ21GQXo1ZEZVTml3bmErR0FpY1ljaGF1ckNoVzJq?=
 =?utf-8?B?dTFGeXlEalBsa3p5dkJjYWV6R05SL0RkVk5EcEkvcmdFQUxDOGgxUlFONDVy?=
 =?utf-8?B?c2Zpc0h3NXlvQXpYbWFtUUtmWXRzUGVLcWR1S3pyWWRnMU1DOXNubEJsakQy?=
 =?utf-8?B?c09vbTN3TFlSRWVBU0ZwblBicEppVERSVkpOT1Z6UWFUOUxmWTZja0RYR1Nr?=
 =?utf-8?B?ZXl0akIzdXpnOXk3K25Cc2pzVGllcmVuSFEyS3dvVzdGaCtldXVPQnIwOEJr?=
 =?utf-8?B?azJ3OWF2bVl3c2pZWEJVYiszU3R4a0JsMzRIV0FvY25hZDIrcWg5VHp0SklD?=
 =?utf-8?B?am1DSGIva1NXTndXMXM4clhqelU2a0k0QUlsUElBMUhzVkJLNUczaWpyQ0w5?=
 =?utf-8?B?Qy9XRSs3R3Rnamg0bHVCNnRNbCt5TVk3NW0yWGJGRjd1UlVPR0JlMzYvekhu?=
 =?utf-8?B?aXdBMitEeXg5WTdoaXVydHFEUXh1djN0Z3BpV2E5QXE2OUc4S2NnbGJKUHRK?=
 =?utf-8?B?UW10MXZpZHRCek1YUFZyY1NRQ0xvUTByblloVXNNOXNsNm1yY0lia2ZPaUpr?=
 =?utf-8?B?VFovMlRycnRucTN5c3pMam1WMlFOZEVGbFQwNHgyZWtwREw1ZUdvMjFRY0Uv?=
 =?utf-8?Q?rGhFFS4sQshbx?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 294e63d2-b9e9-4ab4-cd7b-08d985a1416d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2021 12:36:28.8607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o40lAg+Vj7leSTcb2nejArqJ4WXwWVX6yj8MX57ehQfb3x7omXS3hMTRCrkA//nbwSWZ8Fogtagp2tBjEfRfTd5jzX6LVaG12cu80TYgZzo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1404
X-Proofpoint-GUID: _PGYPsuG_ERr5NaRAuioTy_VtvNqWV92
X-Proofpoint-ORIG-GUID: _PGYPsuG_ERr5NaRAuioTy_VtvNqWV92
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-02_04,2021-10-01_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 bulkscore=0 mlxlogscore=787 spamscore=0
 adultscore=0 impostorscore=0 mlxscore=0 phishscore=0 suspectscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110020093
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On 10/1/21 7:55 PM, Sasha Levin wrote:
> [Please note: This e-mail is from an EXTERNAL e-mail address]
>
> On Wed, Sep 29, 2021 at 11:03:19AM +0300, Ovidiu Panait wrote:
>> Hi Salvatore,
>>
>> On 9/28/21 10:29 PM, Salvatore Bonaccorso wrote:
>>> [Please note: This e-mail is from an EXTERNAL e-mail address]
>>>
>>> Hi Ovidiu
>>>
>>> On Tue, Sep 28, 2021 at 04:15:20PM +0300, Ovidiu Panait wrote:
>>>> All 3 upstream commits apply cleanly:
>>>>    * 5fcfb6d0bfcd ("hso: fix bailout in error case of probe") is a 
>>>> support
>>>>      patch needed for context
>>>>    * a6ecfb39ba9d ("usb: hso: fix error handling code of 
>>>> hso_create_net_device")
>>>>      is the actual fix
>>>>    * dcb713d53e2e ("usb: hso: remove the bailout parameter") is a 
>>>> follow up
>>>>      cleanup commit
>>>>
>>>> Dongliang Mu (2):
>>>>   usb: hso: fix error handling code of hso_create_net_device
>>>>   usb: hso: remove the bailout parameter
>>>>
>>>> Oliver Neukum (1):
>>>>   hso: fix bailout in error case of probe
>>>>
>>>>  drivers/net/usb/hso.c | 33 +++++++++++++++++++++++----------
>>>>  1 file changed, 23 insertions(+), 10 deletions(-)
>>> Noticing you sent this patch series for 4.14, 4.19 and 5.4 but am I
>>> right that the last commit dcb713d53e2e ("usb: hso: remove the bailout
>>> parameter") as cleanup commit should ideally as well be applied to
>>> 5.10.y and 5.14.y?
>>>
>>> Whilst it's probably not strictly needed it would otherwise leave the
>>> upper 5.10.y and 5.14.y inconsistent with those where these series are
>>> applied.
>>
>> You're right, I have sent the cleanup patch for 5.10/5.14 integration
>> as well:
>>
>> https://lore.kernel.org/stable/20210929075940.1961832-1-ovidiu.panait@windriver.com/T/#t 
>>
>
> Why do we need that cleanup commit in <=5.4 to begin with? Does it
> actually fix anything?
>
The cleanup patch was part of the same patchset with a6ecfb39ba9d ("usb: 
hso: fix error handling code of hso_create_net_device") fix .


I think it can be dropped, as it doesn't seem to fix anything. Can only 
the first two commits be cherry-picked for <=5.4, or should I resend?


Ovidiu

> -- 
> Thanks,
> Sasha
