Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0028841EF34
	for <lists+stable@lfdr.de>; Fri,  1 Oct 2021 16:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353676AbhJAOQq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Oct 2021 10:16:46 -0400
Received: from esa3.hc3370-68.iphmx.com ([216.71.145.155]:33705 "EHLO
        esa3.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231807AbhJAOQp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Oct 2021 10:16:45 -0400
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Oct 2021 10:16:45 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1633097701;
  h=to:cc:references:from:subject:message-id:date:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sZ9eloPsu4iCQQoDz1m0YdgfuPGATtrP531PBvHpSwM=;
  b=Bf9rk3gYG3J69sjQnaJH9Ua72K/M4iEtFqizyT8naKssdT4QQVyJttFr
   6KZWEYd5ZKPn8s3VbBAWjLh3q4x+KWcpT+uhVVJub3E4FAXKikIKwSaw2
   hc2oOIdmFSYDdFoIIB+JQzxJy1j8RnmZMwCu3OzKfozP0KNAAxmWVSgx+
   M=;
Authentication-Results: esa3.hc3370-68.iphmx.com; dkim=pass (signature verified) header.i=@citrix.onmicrosoft.com
IronPort-SDR: CDTxt9H7yoH4mkjP2mB8ZspV1+o0NYB/CRAt421JURCnd0D+/zw1+6mGgZJk+4UmK1Vw80ieNf
 /cJ33EaXM/UYNkkUhP9fjqYHYQS9zNPy8aiV60PuejeO6zBTfWKTY41RUeJ0slGtV4rmdyPy/v
 +SkmtqKMYkhsieqHN5pIi5XjyIqNvphPEf/7S4o0dBJ5T2XQJcBCcJ8t2DygsXhflSg7JdWvnL
 8HmCxibgmOaGwuPgWOWb2ESAoGsbHkOwUtnnPfSiO4AcmMzOMLSs7jLieB/REj4qDhMbYfiU+C
 oi2MUYJD2SDOG1vH+oCPkv9c
X-SBRS: 5.1
X-MesageID: 54146127
X-Ironport-Server: esa3.hc3370-68.iphmx.com
X-Remote-IP: 162.221.156.83
X-Policy: $RELAYED
IronPort-Data: A9a23:5zUNC61fun1t8pOzAvbD5TR3kn2cJEfYwER7XKvMYLTBsI5bpzMAn
 GdNXWvSPqvfazf9ct0jaoy09UlX7cPWnYdrSgdspC1hF35El5HIVI+TRqvS04J+DSFhoGZPt
 Zh2hgzodZhsJpPkS5PE3oHJ9RGQ74nRLlbHILOCan0ZqTNMEn970Es7w7dh2eaEvPDia++zk
 YKqyyHgEAfNNw5cagr4PIra9XuDFNyr0N8plgRWicJj5TcypFFMZH4rHomjLmOQf2VhNrXSq
 9Avbl2O1jixEx8FUrtJm1tgG6EAaua60QOm0hK6V0U+6/TrS+NbPqsTbZIhhUlrZzqhpvVv5
 45Cv9uMaB4DELDAvcIcFB14DHQrVUFG0OevzXmXtMWSywvNcmf2wuUoB0YzVWEa0r8pWycUr
 6VecW1TKEDY7w616OvTpu1Er8IvNsT0eqgYvWlt12rxBvc6W5HTBa7N4Le02R9t2pkSQ6+EO
 KL1bxJeTT/qUTYRF2tLK59js8qyqXneSTZH/Qf9Sa0fvDGIkV0ZPKLWGNrNc/SYVNlShACTo
 Weu127hKhgeNdGZmXyJ/xqEnuXImzH6XoM6DrC09vd2xlaUwwQ7EAAJWF2Toei2jUj4UNQ3A
 1xEpAItoLI0+UjtScPyNzW8oXiZrlsfVsBWHukS9g6A0OzX7hyfC2xCSSROAPQjtck5QhQw2
 1OJls+vDjtq2JWJRnaN3rOVqy6uIy8TLH9EaSJsZQ8Y/97Lo4wpiB/LCNF5H8adlNTkXzHty
 jaFhCE7i/MYistj/76n9FrDjhqyqZXTCA04/APaWiSi9AwRTI2kYsqw6Vnf6fdYN66QS1XHt
 38B8+CG4fwDF4OllSqDWuwBEbilofGfP1X0mlNmGZsq3zuq/HGncMZb5zQWDE1zM8QJYj+ve
 07VtgN57ZpfenCtaMdfUoujBsJs4qjpE9LsU9jda9YIaZ90HDJr5wk3OxTWhTq01hFxz+dvY
 v93bPpAE14jLLpIlzW8ANs8yJUF2ywb42KUQbDkmkHPPaWlWFaZTrIMMV2rZ+8/7b+ZrAi9z
 +uzJ/dm2D0FDrShM3C/HZo7aABSdCdnVfgavuQNLoa+zhxa9HbN4hM76Z0mYZAtu61ImurS8
 ni5Vye0I3Kk3iafeG1mhp15AY4DvKqTT1pnYETA3n7yghDPhLpDCo9EK/PbmpF9qoReIQZcF
 aVtRil5Kq0nps770zocd4Lhi4dpaQ6mgwmDVwL8PmNkJ8Q/HFKQp4+1FucKyMXoJnHr3SfZi
 +f+vj43vLJZH1gyZCooQKjHI6yNUYg1x7spAhqgzih7c0Tw6ol6QxEdfddsS/zg3S7rn2PAv
 y7PWE9wjbCU/+cdrYmY7YjZ/tzBO7YvQSJn85zzsO/e2d/ypTH4n+etkY+gIFjgaY8D0P/5O
 LoJn62iaq1vcZQjm9MULouHBJkWvrPHj7Rb0h5lDDPMaVGqAalnOX6IwY9Esagl+1OTkVHet
 pun9oYINLOXFtniFVJNdgMpYv7ajaMfmyXI7ORzK0L/vXcl8L2CWERUHh+NlC0Cc+clbNJ7m
 b8s6JwM9giyqhs2KdLa3CpawHuBcy4bWKI9u5BEXIKy0lg3yktPaID3AzPt5M3dcM1FN0Qne
 2fGhKfLi7lG6FDFdn4/SSrE0eZH3MxcsxFW1l4SYV+On4Od1PMw2RRQ9xUxTxhUkUobg74iZ
 DAzOhQsd6uU/jpuiMxSZEyWGllMVE+D50j861oVj2mFHUOmYXPAcT8mMuGX8UFHr28FJmpH/
 KuVwXrOWCrxeJ2jxTM7XENopqCxTdF18QGeysmrE97cQss/aDvhxKSveXAJu13sBsZo3B/Lo
 uxj/eBRb6znNHFP//1nWtfCjblAGgqZIGFiQO16+PJbFG7RTzi+xDySJh3jYchKPfHLrRe1B
 sEGyhijjPhiOPJidgwmOJM=
IronPort-HdrOrdr: A9a23:Wuaoka/uWSXlPrs/mBpuk+DiI+orL9Y04lQ7vn2ZHyYlFfBw8P
 re/8jztCWVtN9/YhodcLy7UpVoIkm8yXcW2+Ys1OyZLW3bUQKTRelfBO3ZrgEIcBeRygcy78
 tdmwcVMqyXMbDX5/yKgjVRsrwbsby6zJw=
X-IronPort-AV: E=Sophos;i="5.85,339,1624334400"; 
   d="scan'208";a="54146127"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RwzlbsQpCpIX/Sk14e7n8DN6ZAloy7lD2KJTCHrQHN8CNPW5fIsr7Gt4nrN/qVq1/jrXnxQ6oEOMSMQYT1NvNyMY/Am3BZ6ckrNoASvCQPqpIoGlVAFzwY0ibTAAXnYQMd7srBuEouwubKd4Bwoo490lHy5BxlIz5ypFNORrWgIHoDzFvJlU+I+Ek3ntBinGTAbyIUc4EKCPxXyrbiz93SYqFikFYAtIS6qhuxV/VHLInUi9u34Zz8YL0ipXU/m82ywsHaxoGZ6cFbl34PI8FNZsTyTRfwUI+dJhYhPNWhPG5OKa2fftmpv+IVGb7d1XjUBnoFOs90dNn71gPVXfnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sZ9eloPsu4iCQQoDz1m0YdgfuPGATtrP531PBvHpSwM=;
 b=FoPzK1A/CCMK+P5OQKOFGsVTotvmffpIEYk5w9/0/8kdlXgzqYdR3oNGl5j5zkoUvvRNFoWF0DuqjsNrrFmpCn17zhc3Ln/usrPwZP+kwVcsbzhIMdj6x+YeNXUpfvBhsswNSry/RFddwzw3khWcw9zu7Obr9IlD9gVRuzaMPTPk9fsDRRKej/H6DqS88Z63qM5J+KTavHOVhUwjkTvg7Pa9IO0QV0qKE0RORGEXc4//iPtvTWy3RpGJwGP0RtApImdv9bYzzb3Stu/NdR5rPk47g1yI69iWuq7zQDz7pOFu0T1VD4P6CtEcIIBKSqKTWRRdEW3UGtbtl9qcWQnB+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=citrix.onmicrosoft.com; s=selector2-citrix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sZ9eloPsu4iCQQoDz1m0YdgfuPGATtrP531PBvHpSwM=;
 b=YlablSEaPcXf1djgaoL7+5tvtoPfEjk9ObsR0RHLRtTbu6PbeUPoJMqEKiPGCX3g/Y1slktNjUxwdjPb65S7psZN6r9CtW/kODWCXSUERC2cX8+6ziU7jY+gL0Yq8tN97s/+ZNyexlHEiBvc2tzbrGxZIV7jVjNbLqNIAa7Lk4M=
To:     Jane Malalane <jane.malalane@citrix.com>,
        LKML <linux-kernel@vger.kernel.org>
CC:     <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Pu Wen <puwen@hygon.cn>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Yazen Ghannam <Yazen.Ghannam@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Huang Rui <ray.huang@amd.com>,
        Andy Lutomirski <luto@kernel.org>,
        Kim Phillips <kim.phillips@amd.com>, <stable@vger.kernel.org>
References: <20211001133349.9825-1-jane.malalane@citrix.com>
From:   Andrew Cooper <andrew.cooper3@citrix.com>
Subject: Re: [PATCH] x86/cpu: Fix migration safety with X86_BUG_NULL_SEL
Message-ID: <68a9f1b7-0d8e-b25f-8330-345c039277b0@citrix.com>
Date:   Fri, 1 Oct 2021 15:07:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <20211001133349.9825-1-jane.malalane@citrix.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
X-ClientProxiedBy: LO2P265CA0481.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13a::6) To BN7PR03MB3618.namprd03.prod.outlook.com
 (2603:10b6:406:c3::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5ee7138e-c6f3-43f4-2361-08d984e4d46f
X-MS-TrafficTypeDiagnostic: BN3PR03MB2369:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN3PR03MB23699A3B7860E1F1C4AF1378BAAB9@BN3PR03MB2369.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RI89mMq22JoqsZvMlA6HIqs2CUymCeVRo+Uha19t4gaWv+LZWsz6exEeYISKG8hi+gUdVKb27VXDKHv4eHwoRVC4ehCzWIKbg9U7qrY+hKSSd7dc/pGN/gElrJJaA4+goi9v1oZq5HNqBzW9T9Tr2nTxKwSBh454PdWzQ4Lxw/yPH5aQbqdrC5ZzyEmY3btEN5IM4US4glGG3eh902KbZiWqE8j82QSBlunk+MjaMwFDklTsCam5re1OFpcKBLaTrIiJcz8st1w2tQyWS86MRibn7AT/jTmf+kKhmZYpwejqkjiowfkoP3qoKlKEQoFujvpOz1Hoi8LPJDzQLjLXVubixp65Aj8eT08ehTRlr+gq7ed3zfMGmS/zPhf5+Em7EZ6ByrSbSGSyaEfCDoRavIeLteQ/pZ91VCbWxKkySADavfbREsktKU8cagLIbkrL0oMyPDIsa1NbGdMfpGV6/FAZM6Dn9qy2TurlsGY0+/BlwJPgd4lhLShA0PAnbNY1emXWS7zXsWp4R7LiQBu7gL4CJjE0MRhqWEv1WimsF1N3B++GN1qkJvBcePw+2U29mcYISxNgdo1N0/Mhj/KWJRvs0owUpTfRo9Yz76noZBWAQSGXnHH1ZWRyaByynSpWZoRk8KSU58mnmroGv/y07q80/jjYrPfKP+PBBuSmlnfO1yxpCBiz+kgVX3gsNMq8/rMYjxD8n4YQ3tHubB0cG/rUoGBabsQ3x1CDa7bj+pM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR03MB3618.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(186003)(7416002)(53546011)(5660300002)(8676002)(26005)(4326008)(8936002)(55236004)(4744005)(6666004)(6486002)(2906002)(54906003)(31686004)(38100700002)(31696002)(83380400001)(16576012)(66946007)(66556008)(36756003)(2616005)(86362001)(110136005)(956004)(66476007)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cHZYby9TaFJZanZFMlBKdnF0ZEZJQVI0SVgrclh5dDVGSkNGb294RDJBMW9t?=
 =?utf-8?B?eVFsRnhSVVhVbEJ2bng2QUNPeWJ4bktwaDY4RjhDaXJsUUxGNUVxUXIvMmhO?=
 =?utf-8?B?NTROSm90MGRIQWNESjFmWkFjQVFUbHYza0RNQXBBdTlWdGJSakcreU5mMFNx?=
 =?utf-8?B?MDBtWGw2T2ZLc0htVXlubDVyNFZvamY4VXcwR3BKbjZ3czVZTWNGM3BtckZ0?=
 =?utf-8?B?a2RmaStGTCtQcC9kRWVRS1ptMG10TlhvM3FkdlZaZWtYRDY0Vnk3Mm5wL2Nq?=
 =?utf-8?B?QWw2ZVZEanNtem01VnlUVHpPbG1EL2hOWnY1VXlDYVpYdU5maFIrUTg5TnZB?=
 =?utf-8?B?cU01OFZXYXV1VTBIeU9BVmE3WUhVQkhRcEZZV3NZYVZuNWhvRE1xNXlKRkFh?=
 =?utf-8?B?cTJETkxmN2NYcDdjajg4Vmp5VnRBQVVEc1U2U2dHcnFKNmZhc3B5cG04T2VY?=
 =?utf-8?B?aUJoWkpKRU5JNmVJdEVtMkhCS0Q3c2grMmhFbkh0TlNKcHRHSlJjY1g2WEtw?=
 =?utf-8?B?MS9PT0dzcksyTzg3d3VtMGhST0N1bGVxbzMrTCtLY3g2MGV5MDdyaHhmSkp2?=
 =?utf-8?B?U1NvR1duZXo4a1BoRlRiclh0UjVnRzArTnh1bG1yY1gySzVmQmVVLzJuQ1ZL?=
 =?utf-8?B?NVV5M0hjbW9nTkRTU0JtcFNiRk04eXVaRHNXRjYwQS84bzI5WC9WdXcwU2d6?=
 =?utf-8?B?SlNaVDQ0ajN0eDJJd2NURWJIQ3lPMUZiYkpRZlFnY0NOTXZaemFIWGFGTjEw?=
 =?utf-8?B?MFpNU0ZKOWs2UFgzTW8wMmpvanJEalZsL0EvODBva0prN2FZL3Y1dnVXZUVJ?=
 =?utf-8?B?UFBYbmJ2UTRCd2lGWTJORjZScFEwb2VwczczOVYxWDZYNWQwVXpNc2VOd1p0?=
 =?utf-8?B?Q1pNOE9jQnM5TVFraURKMGYvUDNhMU9lN3dNbVNSU01ZaUgvRHlUUmJvZVJO?=
 =?utf-8?B?REdWaSs0c3VUUTRmcHlSYkQ5VE0wMFozMzJVQTVHMUVGUVdvY1dkaDBUcjMz?=
 =?utf-8?B?RldCQktHNFZLVzhyb3djOUpaeithY3FJMGd3VzBNL0UrT0I3NUhTdnFiZGJJ?=
 =?utf-8?B?UFN4ckdRUGg2a3NhTmRScjYvZDhhaHliL01FeEI5Y2ZieWFEcmxWV2Nld250?=
 =?utf-8?B?dnkzekp5WmxCYVg1RHZlNjdGT1d2QTdNeEZlZVc4Q25UOVVlUmRpWUxJYzRW?=
 =?utf-8?B?VjU5K2Vwbkx1L20yOHplenN0VERwZ29CSk04L1ozOHZQb0ZEa09UYTYrV2k2?=
 =?utf-8?B?cm8yeDVpM3gyTWpNZndIU2FFWDhPNFFKdmdEaXliZk9sK1RnYU9uVHZ2THFu?=
 =?utf-8?B?cVdoQ204WVlmcFhCQk9jSSthS0YxMGs1R2hDdUV2dDM3VXNIOEtmL3E3UXRn?=
 =?utf-8?B?RW5HTTcyYWhtT1NKL25GY2NvcnkyOUdMUkVWOFlCTE94OUlOSE0yL2llNVlQ?=
 =?utf-8?B?b3ArK05oSEVDWW1uZ2xxWGpkWFdQOVNHMW81bFR2WlNUYkRxdS9vRGNIS2kz?=
 =?utf-8?B?akFHaUpONHYvbWJ2VnBybC9Yc1FyMnkvWEVTUXBzVVNRZTdRanY3ckV2ZFEy?=
 =?utf-8?B?S0ZHeEdoSFhSZ1ZXbDVQZGtWbWtuYmxoN2VUcTVpZVJsaUppdS9tYjczT3Bz?=
 =?utf-8?B?ZmtJM0c4T2w4RjB2MmNhaERBanZwb0NkdjdlOXYrN0htNEdJc1ptazZ4YWRU?=
 =?utf-8?B?RDcrd3pMM0pOWndSYTRLTmVURWRHcHZRVmRSblRHL0REZ09VcFo1MlJNV3cx?=
 =?utf-8?Q?azZkTAHfqCpnhQYplDsXd/IH1RSC48hgzPr1daa?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ee7138e-c6f3-43f4-2361-08d984e4d46f
X-MS-Exchange-CrossTenant-AuthSource: BN7PR03MB3618.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2021 14:07:42.0418
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qr3eMgbVpQbCPecPm3EXZsFYEuBLtPXOsOti++29KiA2sy/KWtdcAvNiN0mF2kmcMwVutL4w6/NLqY0oQB28mZ0y+9WKaFzeEatwa6eTOms=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR03MB2369
X-OriginatorOrg: citrix.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01/10/2021 14:33, Jane Malalane wrote:
> Currently, Linux probes for X86_BUG_NULL_SEL unconditionally which
> makes it unsafe to migrate in a virtualised environment as the
> properties across the migration pool might differ.
>
> Zen3 adds the NullSelectorClearsBase bit to indicate that loading
> a NULL segment selector zeroes the base and limit fields, as well as
> just attributes. Zen2 also has this behaviour but doesn't have the
> NSCB bit.
>
> When virtualised, NSCB might be cleared for migration safety,
> therefore we must not probe. Always honour the NSCB bit in this case,
> as the hypervisor is expected to synthesize it in the Zen2 case.
>
> Signed-off-by: Jane Malalane <jane.malalane@citrix.com>

Reviewed-by: Andrew Cooper <andrew.cooper3@citrix.com>

