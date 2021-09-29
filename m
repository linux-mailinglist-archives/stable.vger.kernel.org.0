Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C506241C038
	for <lists+stable@lfdr.de>; Wed, 29 Sep 2021 10:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244235AbhI2IF5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Sep 2021 04:05:57 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:9624 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244241AbhI2IFt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Sep 2021 04:05:49 -0400
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18T6slnK000876;
        Wed, 29 Sep 2021 01:03:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=subject : to : cc
 : references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=3e2U3EDvj90fRPYZOdbnQp6zHmJ2zHNZuh4ro6nM2L4=;
 b=N3Q6qls7NwQHV6vZcWlYtVwjR72/Z9jm346nVdZAWd6f5yaVHi5J+UjV/aHrg72fRF5m
 m9eLMASdAkaeK8XhEorsfV/ZHyNX8IEisKlMFjyReo7yY2e+krMFCJOJ0gQ7qy+Y1PJG
 TNmSjb3w2S1pHwDSr7j7Mf3OJmmafxudiLc5W0IN66Vl12NZxpt4yxp3ElyXKR1WZt/F
 VM8hswqvFvkRgQkag50iN54IIun3G4R5YgjfKPI/uWS6JKzS4JtASG8D8aphY+1VpQBK
 DeWplI5SdEJpL8lcOqiWauPyecUaSolmAqpRx0ef0OVqxvA2ELXhW+cGGcCOKBRBDIkQ cg== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by mx0a-0064b401.pphosted.com with ESMTP id 3bcceqgb6w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Sep 2021 01:03:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iR7wmj/4FgWvOoNrQe0vzumSC1vwDeMh+9oRMtd4KmCrDmSy5dgVWJq0zYxK38dMzRa+sNN40oBm9/HLHYhXWQlUUbBnjO2sZYkvjNAbm1QmjtBNoBoIR2m3uetAklstBNb1/nHyUN2D8AAirHV3sMRqT2bNacqQKI+iCCIBaGSCNWmYRpizNYDxxnVDg0U+iDqaM/jMoKVA6R8vo5G+MxCwEQ5VBmgGy50Jl+ICbbCAllmjN8OJjhjoxnX+/TuU4Y8CVFa/IpZOZt4UnLuu5UEp89fq52x2342BxERlkz799O1i8KuGEafj9315rCoLlXU/bxH3Zas36639TOpk8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=3e2U3EDvj90fRPYZOdbnQp6zHmJ2zHNZuh4ro6nM2L4=;
 b=gndUJGUvfPehGndhrZeTHoJjN5dozn/BKz0YpwZTNmspRnWtbnsInYJaXXHrvtKCNXyJRguxKguF64DSyjdBSwbiy6JrV+/Q+dxvc7TM9ri5WG7UygzoQ0sH3T7zorXTJERdGJ8QcifoeezxP2LXgFS172f4jWQ0a6WGdvqIoDFaIh5tvidppPeYVyI9yJDBVwkcd3e2TJslPlG1C1Y9ciS/UkrabDCmmwvGyFnm76FNo4wUiHE82yNuTorg7ZKdvLHt9mSp/sKamE7sPpCXPk/8tVfYFhMjlc+zkERlPbT9h139FtbN/ceefdQ3Wa02tYO5WaojDRuJa+Ub3DyLlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: kroah.com; dkim=none (message not signed)
 header.d=none;kroah.com; dmarc=none action=none header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM4PR11MB5261.namprd11.prod.outlook.com (2603:10b6:5:388::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Wed, 29 Sep
 2021 08:03:26 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286%5]) with mapi id 15.20.4544.022; Wed, 29 Sep 2021
 08:03:26 +0000
Subject: Re: [PATCH 5.4 0/3] usb: hso: backport CVE-2021-37159 fix
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     stable@vger.kernel.org, greg@kroah.com
References: <20210928131523.2314252-1-ovidiu.panait@windriver.com>
 <YVNs/mLb9YXNz7G+@eldamar.lan>
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
Message-ID: <2c3095ae-9f67-2a38-e258-1f8d707c4fa2@windriver.com>
Date:   Wed, 29 Sep 2021 11:03:19 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <YVNs/mLb9YXNz7G+@eldamar.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: VI1P18901CA0020.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:801::30) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
Received: from [IPv6:2a02:2f0e:c515:6a00:97d3:e494:133d:3340] (2a02:2f0e:c515:6a00:97d3:e494:133d:3340) by VI1P18901CA0020.EURP189.PROD.OUTLOOK.COM (2603:10a6:801::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Wed, 29 Sep 2021 08:03:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19a1c83d-ea20-4085-36b9-08d9831f9d8a
X-MS-TrafficTypeDiagnostic: DM4PR11MB5261:
X-Microsoft-Antispam-PRVS: <DM4PR11MB52616DC158536527966200E5FEA99@DM4PR11MB5261.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dtO1B7lBuLpO46m2lz/uZ3Z7INmJlYEsbLVP6jOtaHgGWc9jdF/pJAz2z4Y60egTyGFRYZesYQjhzL4uWWMvy0dcAv4k6BWRRU++eUWzCO6nlWNIRKsyABFrY1IktUzQQtJ5nMEEkuYJoNIqmyAGEaH/9Cx1403mqbzIeEvwsFDMBT6vpmMs/f5J8gXmt2DRTVTHppdnRGBZR0g/jzSOmBMWy6sp8G1tHTvGnibFrqxlm+0KEJdMymeXhqeXdRT6RS/Zpje3tji8Oe/b5gvcss7KSdj3EiagGiq70EnP87ekkX1yz7lDv8TBA7Cy8/8fJzEu0XYKnjW45nVnUFEBvXQHf4zr9tqlvzUrs1ssIBSioQZJuqDgDokMA3OCoB1yHfVALrL5gE38KahqhHwvJz6FVktA9YduGccIzJiyirWBT7lHCRuQFBa2XDhxoGBfVPftQJvIfDtKBxTJJ2lIY3UFFZUVgMiwBwocJ1IL9PHh1KN9iHK1g4NFIySl90xyAOPVJWSPsjfFARjxvKximIWlz+QqofFVpchNZjRgTnlqqxYstKX6IaDdA11NiHsPnskqIGv88h7r3z64d+t3/7MJDb26AuzeliFp4gmcg1l7C8hVvo5qH3geS8wH6Am77KL69yNiNgwAEBRUvzHIOBXLOdrExcX4x2HMptbn1BWHD5elOjSf09F/CXpbIWzyUptS3Oq6JIt0EFhD8uSYsbNi4ygSm/RZ5nbeRTiPzBDZ2Doe3pW+1tVbUnLrrlzfTC2K/O2jh26XvgqoNlCtd0VeoCl6O9JsZqaqzudWmEVh7dZczhfCWlYienfurPNr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6486002)(2616005)(8936002)(44832011)(66476007)(66556008)(53546011)(66946007)(4326008)(316002)(31686004)(6666004)(36756003)(5660300002)(6916009)(508600001)(966005)(31696002)(8676002)(38100700002)(86362001)(2906002)(186003)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VXdyUVVIcGFlTi9ZVGdkQmRwemQxeGp6a2ZZOXVmZTc3aFpUUEVrOWhBenVI?=
 =?utf-8?B?cHJmVXJISXZ5R3d0WlZOVmpPTG1HbVBMR2c3Mzg2SmQ3OTV2WG52M2NNRzZx?=
 =?utf-8?B?cjQ0R2ZQMms3ZW9WYXMzOC9OU0ZBb0NaVjZIM05NMTZMa2xXbVhWWmE3WDRz?=
 =?utf-8?B?RDQ5V2k3ZEc0YkVna1NjSkZPNzdlZ0tObFptcWxxMVZBVENxcUVJanpNY0RK?=
 =?utf-8?B?SHE1Y3cwam1iQzVLb0dCTjZILy8vZ0xROGlhUEM2T3lCVCtvZlJzOVFTcnBs?=
 =?utf-8?B?aVFjMkRGYlNkTmxFeE1hUjVhSE5qK0NnS1pZTzF1djJPdDFDd0tkUUhaL3M0?=
 =?utf-8?B?S1M0aVFyMWp1cmRXUlQzN3hBbjFJNEZEdE8yc1k0Nm94KytXd2tzdjlaYlJO?=
 =?utf-8?B?N3NkNEorVzg5bjFjOEVTb3d6Wk44dHNhbjVpcnp4NUZuWkI1Ri8vQ3hTMmpK?=
 =?utf-8?B?by9mM2lRdGZuSXJtQW9XOUxERUpPbkhlZGx2SHl6NVNSdytYMUMrNjYyTkZx?=
 =?utf-8?B?UjZIMnZlUU1UZ1FRTExnRWxnRk5mTXlzeCswQy9BZE1SK0ZIOHBKelVBNm1u?=
 =?utf-8?B?QWpmZ2xwTWlsblJKMmZ3a0c1OUtta25ZYllrTlVxSVIxQlpWS0VubUluZFFz?=
 =?utf-8?B?NjhRV1gyK2ozV1U3M1RsZzRuQ0NMVnY4RU40UkgvZzZiZnRrczd5bGJoemYx?=
 =?utf-8?B?OHV6MEtsWTZWMmRBLzByY0hGek52NkloVDZvelhWa0F2dnJnaUlzMmk0OHdW?=
 =?utf-8?B?L3ROTkNKb0FDQXZpV3ZlaGl1dG55dGhYd3hUSmQxYXdYUk1nTldKeUV3Tisv?=
 =?utf-8?B?QjQzYVpqYW5PdkU3K3R4dURXMDA0MU1MZ3d2SjNMN3RBNHZBRWVYU1R6bzJY?=
 =?utf-8?B?cWpQMS8wdFdwZEdqU0FQVDVuT3BrM3h4QkUzdVhRd0hxRWt6NHpjVy8wVHpk?=
 =?utf-8?B?SUVuS3JBQUlMY2xCVnlYMmRoaE55U2xKZzI3NHdhelQ4dmxIdzdtbWIzZ0RQ?=
 =?utf-8?B?MjNRT25oK2NlNXFJQW1kUURTRis2WnYrbnhTSTlLR3NUY2RVajJFcklTdi9B?=
 =?utf-8?B?cU85TXhzQ2lhSXROQ2xmSDYxU1ZZUUNpWENBc2dTMmU2RkdlZU5YR3FTeDhN?=
 =?utf-8?B?MWR4ak03blNKUVlXaG54TjV6SUJDTVE2OGo0M0JaczE5Y1FIN3ZZcUNSaUVM?=
 =?utf-8?B?OVBEaHI4L1lvUmFhVTJEODhyRVNZeEtwZW9xc2dLUEdxVzJjd3lHTERPM0N4?=
 =?utf-8?B?UEJmNEplYnRyZ2huUTdxTnh5OU5vSmY5cUxVQVJzT3V6UnBpNHR0SFdJT3hR?=
 =?utf-8?B?Tk5MOGVjNVhlWWpBcVBTSzIvVWs2UG9VZEphNnd5U21WYi9FamdWZmN5QUpQ?=
 =?utf-8?B?SGFGY0p3LzJGTUdYdEwyOHBsWDR0TEh5Z3k1cGh5dllZUEdHN1dNM0t4S2ti?=
 =?utf-8?B?Y3pkVTZuOWpXM3RwY29RdE43RmhURElyTGhXbXlhSkFqQUVzdGxYV2EzRjVo?=
 =?utf-8?B?OCsvRkMySzV6aG9CR25SMEhOYmx5RHQxUjdSWmFnd1FlVnRrTVZ4Ynp3ZzNL?=
 =?utf-8?B?L1RhR01FM1k1c3ZHZXdRcStHRG02QVU5T0dFNThKTlNZNVliSXRIMkJDWTRk?=
 =?utf-8?B?TktYUDdqMFJCNXprNUpVaUNtaHhnNS9IWHltUlM1dVF5QjVQY21iNy9EK0V6?=
 =?utf-8?B?UEE4SEVabUE4NEN4NXJPelpMLzExTXg2d0o1R0NBd3lJQkV5ZDlCTGxyMDdi?=
 =?utf-8?B?QkFFOU9WQ051RGtDV2J5dENHVlBYZHNoZVVxdGRYMU1iNTRMNHVxNW90Nlp6?=
 =?utf-8?B?WWVzaGw2WjNaVWZkWThQU0lYa0VIZDFwM284WEtCaVY3VGRwVHlWL0RHRXQ2?=
 =?utf-8?Q?bARTOvJ2dPP0t?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19a1c83d-ea20-4085-36b9-08d9831f9d8a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 08:03:26.0967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 81BvPjLPrCvoqwd8LA1HModOpYD3wY8yi4kvxVWzCGx97XctXzinNZ3aWqF9avldd4gm9wJQMtNpVF+0nfYmLMSme+SlFac4eBXBD53bYvo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5261
X-Proofpoint-ORIG-GUID: hD63d2nW46d14mGYo65kmzGcxofHw4W5
X-Proofpoint-GUID: hD63d2nW46d14mGYo65kmzGcxofHw4W5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-29_02,2021-09-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 adultscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 lowpriorityscore=0 mlxscore=0 impostorscore=0 suspectscore=0 spamscore=0
 mlxlogscore=801 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109290047
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Salvatore,

On 9/28/21 10:29 PM, Salvatore Bonaccorso wrote:
> [Please note: This e-mail is from an EXTERNAL e-mail address]
>
> Hi Ovidiu
>
> On Tue, Sep 28, 2021 at 04:15:20PM +0300, Ovidiu Panait wrote:
>> All 3 upstream commits apply cleanly:
>>     * 5fcfb6d0bfcd ("hso: fix bailout in error case of probe") is a support
>>       patch needed for context
>>     * a6ecfb39ba9d ("usb: hso: fix error handling code of hso_create_net_device")
>>       is the actual fix
>>     * dcb713d53e2e ("usb: hso: remove the bailout parameter") is a follow up
>>       cleanup commit
>>
>> Dongliang Mu (2):
>>    usb: hso: fix error handling code of hso_create_net_device
>>    usb: hso: remove the bailout parameter
>>
>> Oliver Neukum (1):
>>    hso: fix bailout in error case of probe
>>
>>   drivers/net/usb/hso.c | 33 +++++++++++++++++++++++----------
>>   1 file changed, 23 insertions(+), 10 deletions(-)
> Noticing you sent this patch series for 4.14, 4.19 and 5.4 but am I
> right that the last commit dcb713d53e2e ("usb: hso: remove the bailout
> parameter") as cleanup commit should ideally as well be applied to
> 5.10.y and 5.14.y?
>
> Whilst it's probably not strictly needed it would otherwise leave the
> upper 5.10.y and 5.14.y inconsistent with those where these series are
> applied.

You're right, I have sent the cleanup patch for 5.10/5.14 integration as 
well:

https://lore.kernel.org/stable/20210929075940.1961832-1-ovidiu.panait@windriver.com/T/#t


Thanks!

Ovidiu

> Regards,
> Salvatore
