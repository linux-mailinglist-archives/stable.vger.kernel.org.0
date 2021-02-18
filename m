Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8C731EDF3
	for <lists+stable@lfdr.de>; Thu, 18 Feb 2021 19:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbhBRSEq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Feb 2021 13:04:46 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:41310 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231234AbhBRRfp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Feb 2021 12:35:45 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IHYP9a163995;
        Thu, 18 Feb 2021 17:34:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=t0UAfYqWXZ/tWvy2yjsS6V/VgpzWAILEsv3eAbgxpKI=;
 b=pgfLXVRBNfQvpuxU/ItgIMv3e/7UQrGSWEROyFsS9QZmsDVyYr6SuWem0iGqnQwMOFEE
 iUnsUoHBiydCjRDMJLV5yqoIfaVSjPtadx5aOGFHmIf6eDbXwgYUVW4sJbW0wzKmogjN
 B47t0VwxVdIguELqcXNM+xN8vtex5re0i9Z61gxPl9qKM9yLI6QEueypnZ1j+vNVnRvg
 bPZ2UTKeW1/so0B/Nhip/a4LcvnWFFv2A+1J8Y8jevQVhHfJJkH3u86C9iV2Idv8Hsl1
 IrQieRxFBeZTkI1TSsJK8tLR4eZzbYkqvFcaLKwglmdgY+8S7Zs4sFBGe6B2xY0R/+Ek dA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 36p49bey71-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Feb 2021 17:34:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IHKGhu106026;
        Thu, 18 Feb 2021 17:34:45 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by aserp3020.oracle.com with ESMTP id 36prp1t9se-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Feb 2021 17:34:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jkKUQ7c977gLR+KoaluhHCwxvp5YO7ZmmAG90XTi4tsEoRAUqIPbvHO5rHpT6ElASaDYfFVGdh/pOG1ppIIobZ6qev/mgzLVmIVCeImazYg6+7k5nFK50+Qog/oAPsb6zIkmYR+aca/aPqscZQxI2Fq36/RFvFw84RVGVjF+sWDYeQyFu4UODcsJxJYkDGPtCmF2l6PUoGWTU+aOf9fcpIvbbuVnA9MaZNTAIcOndxGcRU9UYZ5Ql1PPnv2/+mmT/6MXhpdVvvWt6R1OfxKY1wWQPuvtEx/1kLQim3Jy+2n+mX8P0a+GrHkQa5QQRjXmLcqV0C9+XPVOb4F6coVp1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t0UAfYqWXZ/tWvy2yjsS6V/VgpzWAILEsv3eAbgxpKI=;
 b=WeAVeVZnP/yz+vSzNERtaw6Ux93YXLf4/qBNP7D2+hlWgWqfxeWF5bKyut6/1oplAyN/Vl9uRJtGaXZuOV8j0999NUFNkhrUazJlIC8BHFV5PNXJt4mx47UEc1vQKbZd+812oL6Fmt05sz9vjaOPGQcuXKOI2R7dcK0tT50FwX1bIjhFdezOkLftyyiuZZhi7z2n3fIUTL5pTZBLkP1JCIkrvaiBO7gsvExJ/UF1BdgVHNOJ9cezM0YbaKtNUS7oZt64EpaXShBk9OcUVShiyJlSmx6JZt1915pSC3v6AwDfs3lrin3afGaDkrag/T5D4Z6OnGXAAjKdcjo6jWXz3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t0UAfYqWXZ/tWvy2yjsS6V/VgpzWAILEsv3eAbgxpKI=;
 b=MEklJqwpywsZLMudZufOM17XpI8os7gGq1Z9PiRzNny9UhFrd5RRYfj9KabrJ72bMmIN1bHSwpweOWv68aOuFR3mLiktNwapFu9vhn1dBbJ0aNrrBV3re1W/p4cTG0T9LOEJZz4K9ZqnM4C6qFlLp80bG9Z12FqccQKTeIgD6M0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by SJ0PR10MB4701.namprd10.prod.outlook.com (2603:10b6:a03:2dc::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.41; Thu, 18 Feb
 2021 17:34:43 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::e035:c568:ac66:da00]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::e035:c568:ac66:da00%4]) with mapi id 15.20.3846.041; Thu, 18 Feb 2021
 17:34:43 +0000
Subject: Re: [PATCH 1/2] hugetlb: fix update_and_free_page contig page struct
 assumption
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        Matthew Wilcox <willy@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Zi Yan <ziy@nvidia.com>, Davidlohr Bueso <dbueso@suse.de>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Oscar Salvador <osalvador@suse.de>,
        Joao Martins <joao.m.martins@oracle.com>,
        stable@vger.kernel.org
References: <20210217184926.33567-1-mike.kravetz@oracle.com>
 <20210217110252.185c7f5cd5a87c3f7b0c0144@linux-foundation.org>
 <20210218144554.GS2858050@casper.infradead.org>
 <20210218172500.GA4718@ziepe.ca>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <cc94992a-0eff-bf5e-d904-b23d5facfca3@oracle.com>
Date:   Thu, 18 Feb 2021 09:34:41 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
In-Reply-To: <20210218172500.GA4718@ziepe.ca>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [50.38.35.18]
X-ClientProxiedBy: MW4PR03CA0181.namprd03.prod.outlook.com
 (2603:10b6:303:b8::6) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.2.112] (50.38.35.18) by MW4PR03CA0181.namprd03.prod.outlook.com (2603:10b6:303:b8::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.28 via Frontend Transport; Thu, 18 Feb 2021 17:34:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 59c179f5-f8f6-4629-0bb0-08d8d4337a55
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4701:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4701C2DEC159CA271CDA9BFDE2859@SJ0PR10MB4701.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /0Km1Fj55QVIhEt7idI8igYPn9k54Lw/vM0Kh4rADWoK48KhIOIUGwmz608kGO4EIGTjpMeSydjY2+itpJHsqlZ8WewKZRE/ruYcyfJtmdsKRI1Lxze6didAVMo0U8oqXRRMTYxYPpSPwfu1y+t8Cv5OwKaOmEwl/RrcW1TgEklWMGp29kb0fCM3NnVT3gm8pwRgy+HMxU7GV7MtA++mV8pxf17xLNnz0xJYUW1jrw6FkVr0tMAV9LIiqXcMT9sROUKE213pDqyG4DzXf3QrffZyVo5k4DtdeMUO2PrjWWb4hzPc0SXGFkn0RfRcsksBhuZuvVHPi/liL/+P2vOu661rBrdfC0/swwVnO/d98qgO9kzasjQk5jTvL4ibQcM4ZSQgqPS2eikwYlfLQg3c3GnHHEe4zjIZar7CrStIgLOwtxiZTw58DLmz9sI0XJdmVDylVS8IVD3zM3ByLpd1vdlrx77HwAtYXkwquAMeBtG4pJN9+fCRdpK40yuJUqtM9BEuI8iyytZfrXFaTk6s8ZseRemRswGDt54MZFEjRHLwNjgffDg3oHI62JTYWnlAVWU8lJwEPPH3d/pa8t1EyE0oD+hP4l3hEIMZahUHFV4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(346002)(376002)(39860400002)(366004)(2616005)(8676002)(956004)(7416002)(26005)(2906002)(36756003)(44832011)(52116002)(4326008)(66476007)(8936002)(186003)(478600001)(316002)(66946007)(5660300002)(86362001)(110136005)(6486002)(16576012)(54906003)(16526019)(15650500001)(66556008)(83380400001)(31686004)(53546011)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Y2ZHZGxLMjk0SFFtMHVia2lydXd4NDVOc1VWUnFQTWJGbWplQ3hEdkNUaFp1?=
 =?utf-8?B?NzFiYWMydm9BWXlobkJwVVN5d08zS01iamp5UnI2Tm9vQ0FuTktyREpyM011?=
 =?utf-8?B?cTdoUlJUcDlUWmRLT2t6TCsvWEZKWjhSTjNadURtOXFyYWJGR0VrVC9tU2Ra?=
 =?utf-8?B?M2poMk9JcE5RNGp6UHZxSlFBYnR3WmwvTUcvYzA3ZWV2NmFKaFJUOURrN3RO?=
 =?utf-8?B?c2l4cmlSaTRTVm4vYnZPWXdGSjRmdFFLRUpja1hZYzVoYWVTRmRkUnI5TXlT?=
 =?utf-8?B?N0VMM2JCWUQwKzRzTTVQMEJIUjVyUDY1VHhXd1o4dGRya0ppMU55UTltbzRG?=
 =?utf-8?B?OFlQdENIVHdWVEN4SjJWUXcyZzJMVmFHc3NGKzFoNkEvTnFLeWhURUp6d2da?=
 =?utf-8?B?bVRSSkIyNmwyVVo3Y1RhdDgxZmlic01RQXhIV2FtZTd6aWVUNGJzUHFKaE5W?=
 =?utf-8?B?WkJxalBtQTZVdkcxUlE5cW8wV0FpUW9zZWROaFh2eUV1T0h4dzFHWDhZZFRB?=
 =?utf-8?B?Nk9lLzB5bUNqV01ZTmlVbjZYK0t5VmpMVWhPd2xVdDBWR0pEdjFmazNZWWtF?=
 =?utf-8?B?K3g4Z3ptU2xQU2tmVkZpU1UrMkhUZXpId1dYNmFoYW1vUGFpVzdtKytDUnFi?=
 =?utf-8?B?YmlKTWtJY2pNUkRURXI5UGNnQmhQcnMwU0JSdmJwRXY5OFUrTW9DRW9xTGhk?=
 =?utf-8?B?RGFYV3FLRUpveHdmeG5aY0V4M1pMdkN4ZWljeXc1SXFCbzk0T3NLb2NOdm9U?=
 =?utf-8?B?Mzd2Tkc0OXF6a3NtR1ExdUk3V1VUaVZGQ3UzZ3lBVGlpZEFSdXArNENKS2U3?=
 =?utf-8?B?SkxDNURCcmhVQm00dVEvUy9YTWpJQy8rOWEzWFhzZzU3eFkxckFmL0lyM04x?=
 =?utf-8?B?TFUzY0I2QmJTZWVGTS9NU2Y0dUpwdGhMeVdFUE1uZDlTWUhha1JwY3duZFlG?=
 =?utf-8?B?Q3hYUUEzUU5pRVpNUzZBeEh0WUNKM0ZBWml0SldaRnRpMU1WY29BaXdHa1JP?=
 =?utf-8?B?WjlPejkvSFBqT0ZUN0V2akdHbXZFOUJZV2Mzb1Q4ZmdZdHB6Y3NYd2xwMUto?=
 =?utf-8?B?UE9MTHlzdW9LemZVaVBPY053N2wvK3lnOWQwTGVGV1NOWHVDQlZ0S3pIWDdL?=
 =?utf-8?B?OXFUa2FEYzNZQWVOK2dYK2t5dDZiaFN6MkZRNTIxTTYvRlNlKzBXTXRTWCtt?=
 =?utf-8?B?QTF1b3NGUXdGSTNtckhjR3BpYTZRZ2s1a3NwazdJTTVleVROcDdEWDFVZGM4?=
 =?utf-8?B?cVlFa1lJalc3ME5PcFQwbjcvY3hxbTBhZXdBVEp4QmU2a3lOVVQ1dVBZbEVV?=
 =?utf-8?B?L01vNktwblRZWGlSZXZnTGJTemwvUUI4Nm8reW51UUJ6anEvdVVPYldtaEVI?=
 =?utf-8?B?Ym5tMWFmZGR3dG8yUndRSWdoSmZBU0hxVjdzalMveUpBRmk2dVFDeFlhaTho?=
 =?utf-8?B?YVNyeFR3VEcxSWRGM1lhZDNZVUZKZk5pNW0xMUxnMk1pQmErajFaNnRUT0J2?=
 =?utf-8?B?N2o1VzRYQ1UxR2xKQlFlZGtZcDc2YnpoL1daS2FUV1pjRkxRSVBTNDdDOUVC?=
 =?utf-8?B?UDd4MGppLzJtUkR4VEdDOUhOV2pNWnBCaXhrb0JpbXJTSzhWdDVieVpadU9n?=
 =?utf-8?B?WGJoRGpZblBQTVpBR21lRWZOS1B1cm0xcC85ZFp1N3lwUDRWVFhneWNjRFJJ?=
 =?utf-8?B?VlM0WXVWbEZjQk5rT3N3V08xYnNVL2ZvNjZMeFJtYmZJVTFRRDZTVDh4M0pm?=
 =?utf-8?Q?lz3mFSJNeTt0StM5ZtlMH2eWau624uK5nQC4s75?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59c179f5-f8f6-4629-0bb0-08d8d4337a55
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 17:34:43.5332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QDuebWJUtzBrRqkGIy3NT7U7ui7NPLfRnHhW6GjqzsKAc+77te0WnP2PnytT/Oc6SaKa/z56r62/MpjGBSR93g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4701
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180145
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 impostorscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 phishscore=0 clxscore=1015 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180146
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/18/21 9:25 AM, Jason Gunthorpe wrote:
> On Thu, Feb 18, 2021 at 02:45:54PM +0000, Matthew Wilcox wrote:
>> On Wed, Feb 17, 2021 at 11:02:52AM -0800, Andrew Morton wrote:
>>> On Wed, 17 Feb 2021 10:49:25 -0800 Mike Kravetz <mike.kravetz@oracle.com> wrote:
>>>> page structs are not guaranteed to be contiguous for gigantic pages.  The
>>>
>>> June 2014.  That's a long lurk time for a bug.  I wonder if some later
>>> commit revealed it.
>>
>> I would suggest that gigantic pages have not seen much use.  Certainly
>> performance with Intel CPUs on benchmarks that I've been involved with
>> showed lower performance with 1GB pages than with 2MB pages until quite
>> recently.
> 
> I suggested in another thread that maybe it is time to consider
> dropping this "feature"
> 
> If it has been slightly broken for 7 years it seems a good bet it
> isn't actually being used.
> 
> The cost to fix GUP to be compatible with this will hurt normal
> GUP performance - and again, that nobody has hit this bug in GUP
> further suggests the feature isn't used..

I was thinking that we could detect these 'unusual' configurations and only
do the slower page struct walking in those cases.  However, we would need to
do some research to make sure we have taken into account all possible config
options which can produce non-contiguous page structs.  That should have zero
performance impact in the 'normal' cases.

I suppose we could prohibit gigantic pages in these 'unusual' configurations.
It would require some research to see if this 'may' impact someone.
-- 
Mike Kravetz
