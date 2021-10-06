Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59D67423FE5
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 16:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231540AbhJFOSN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 10:18:13 -0400
Received: from esa1.hc3370-68.iphmx.com ([216.71.145.142]:26958 "EHLO
        esa1.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238837AbhJFOSN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 10:18:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1633529781;
  h=to:cc:references:from:subject:message-id:date:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4293qVjv3Qi/WD2efTcDzmVnov0rOTHrH9WRwXvvzmg=;
  b=OXogeiOsoK50bhFlniVBR50ipXdDhIqILGnzUPsZogcKyoYJTWVhTwEs
   15VktakIwBwA2VZJ92waWDumd46pqcTswM7MaTiorMTcEuhoiLusdDFIQ
   2nwx+gib9IrIVGzVTAzjve4si31ox5vBm/ioEEgGd9RJwbnjcl22DHZrE
   A=;
Authentication-Results: esa1.hc3370-68.iphmx.com; dkim=pass (signature verified) header.i=@citrix.onmicrosoft.com
IronPort-SDR: 0ljsfb0rJwpV6a66AVYnpU36S+cG6/DgMckovWy669x6HCdLfiXf7nW0txW4UJ6nNtGiJAG8fU
 Z36AqMlyAmFAKKyjr7Vb7x/EjC6urjFBb9SReh+q2FoMtq3EPGxlrldPKkQSy/zdb0KlqZaViE
 uExjgWp+o1NxC+spruXDq6PM8/ToU1yATHTQfzOkOnyMpFMsFbLyGjtaV+lYYpcQhKnq+zLA+J
 tktR4Ww4ugd1JMIzjas3gKYHZAKIyhy44AL+KY8rAZsaWO3PCdXtdiDAsJIoM8rVWN6JJqwebJ
 JVZMSX91npJ8HhHeOYz3qpT3
X-SBRS: 5.1
X-MesageID: 54909841
X-Ironport-Server: esa1.hc3370-68.iphmx.com
X-Remote-IP: 162.221.156.83
X-Policy: $RELAYED
IronPort-Data: A9a23:LXcXNKDzeZj2vxVW/87lw5YqxClBgxIJ4kV8jS/XYbTApG8ngTABz
 zZKC2mObqnZY2v0coggOovn9xsP6MDXm4BkQQY4rX1jcSlH+JHPbTi7wuYcHM8wwunrFh8PA
 xA2M4GYRCwMo/u1Si6FatANl1ElvU2zbue6WLOs1hxZH1c+EX550Uw7wobVv6Yz6TSHK1LV0
 T/Ni5W31G+Ng1aY5UpNtspvADs21BjDkGtwUm4WPJinj3eH/5UhN7oNJLnZEpfNatI88thW5
 Qr05OrREmvxp3/BAz4++1rxWhVirrX6ZWBihpfKMkQLb9crSiEai84G2PQghUh/iSusxdND9
 /506Zm9SQMwI7XsocAwTEwNe81+FfUuFL7vJHG+tYqYzlHccmuqyPJrZK00FdRGoKAtWzgIr
 KFGbmBWBvyAr7veLLaTY+9gnMk8auLsO5sSoCpIxjDFF/c2B5vERs0m4PcFgGZo15ASRJ4yY
 eI3OQZUQjb/RCFXHWk3M5M1mbeMr33gJmgwRFW9+vNsvjm7IBZK+Lj1OfLHa8CNX4NemUPwj
 mfH+Wv+KgsXONyW1XyO9XfErvfFmiXpWYQTPKe1+v5jnBuYwWl7IAULSla9ifmohUm4HdlZQ
 2QQ+ywzve0x+VatQ93VQRK1ujiHswQaVt4WFPc1gCmH0oLd5weUADhCQjMpQMApsN8eQT0sy
 0OTmNXoFXpjvdW9WSLD3rSZtzW/PW4SN2BqTSsZUQwt4NT5pow3yBXVQb5LCqekyN3oEDf/6
 zmPoG41gLB7pdUX3q+/8HjZjD+24JvEVAg44kPQRG3NxgB4Yci9Z42s7VnD9t5JKYrfRV6E1
 FAcltST9vImDJeDjiWBTewBWraz6J6tKzDVh1xkN5Ym8Dup9jioeoU4yDtkJUVkKcZCYj7vb
 0/7sAZdopRUOROCXKZlboT3JMQjy67pEPzsU/ySZd1LCqWdbyfeonsoPxTJmTmwzg58ysnTJ
 Kt3b+6uE1NACpZY5wPqQuod1aY23gAH4U7MEMWTIwuc7ZKSY3ucSLEgOVSIb/wk4K7snDg54
 +qzJOPQlUwAAbSWjj3/tN5LdA9WfRDXELis86Rqmvi/zh2K8Y3LI9HW269pX4V4k6lPmu7M8
 xlRsWcDkwGn1BUrxeiQA02PiY8Dv74j8xrX3gR2ZD5EPkTPh670t8/zkLNtLdEaGBRLl6Icc
 hX8U5zo7g5zYjrG4S8BSpL2sZZvch+m7SrXYXH+PGVuIsY4G1CTkjMBQucJ3HJVZsZQnZFuy
 4BMKyuBGcZTL+icJJy+hA2TI6OZ4iFGxbMas7rgKdhPYkT8mLWG2ASq5sLb1/okcE2ZrhPDj
 l7+KU5B+YHl/t9kmPGU1Pvsh9r4TIND8r9yQjCzAUCebnKBoAJOAOZoDY61QNwqfDmvpfr+N
 bkLlaGU3T9utA8ijreQ2o1DlMoWz9Duu6Vb3kJjGnDKZE6sEbRuPj+N2swni0GH7uYxVdKeV
 h3d999EF6+OPc+5QlcdKBB8NraI1O0OmymU5vMweR2o6Chy9buBcENTIxjT13ANcOoraNsok
 bU7pcobyw2jkR52YNyIuT9ZqjaXJXsaXqR56pxDWN33ihAmw01paIDHDnOk+4mGbthBaxF4I
 jKdiKfYqa5bw07OLyg6GXTXhLIPjpUSohFailQFIg3RyNbCg/Y22jxX8Cg2EVsJnkkWjborN
 zEyZUNvJKiI8zN5v+R5XjihS1NbGRmU2k3t0F9VxmfXeFalCz7WJ2onNOfToE1AqzBAfiJW9
 a2zwXr+VWq4Z9n42yY/VBI3q/HnStAtpATOlNr+QpaAFpg+JzHknrWvdSwDrB6+WZE9g0jOp
 O9L+udsaPKkaX5M8vNjU4TKh64NTB2kJXBZRaAz9awEKmjQZTWu1GXcMEu2YM5Me6TH/ELQ5
 xaC/S6Tu8BSDBqzkw0=
IronPort-HdrOrdr: A9a23:CWwZX61H+sGHX8CxZCOCyQqjBe1yeYIsimQD101hICG9Evbyqy
 nOpoVi6faaslcssR0b+exofZPwI080lqQa3WByB8bEYOCOggLBRuwPgrcKgQeQfhEWndQtq5
 uIHZIOa+EYQWIK6foTpmODYqsdKL7sytHSuc7ui11qSgZnYbxh6Ak8Kj/zKDwIeCB2QbA+E4
 eR4dcCgjamd2kXB/7LdkUtbqzutsDGj5XvZFojDx4jgTP+/A9Av4SKdSSw71MmSDVIzq4l8W
 /Z1yLExojLiYDG9jbsk1bJ6ZJYgd3gzcYGIvetpIw6FhXA4zzYHriIItW5zUIISIfG0idYrD
 Hryy1QS/ibL0mhC12dkF/QwQX61z4r5xbZuCalvUc=
X-IronPort-AV: E=Sophos;i="5.85,350,1624334400"; 
   d="scan'208";a="54909841"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a1JLcPuAdVaLhFb8RppoWUt/BYMDFE66UwJJ2FW+vCTII0nRRx+fXpK4RauFlBAw2S2UtnbKw4GyUqU9nH+5Ll7DLMA5o0K2rCsbuiwsYJ0MptOLvjl/9kPehOmp52PmY8ITRw2IrXD0XU2k//MRPjxfvzEIzIuHo5Ty1WU9ftPnrP13AUXJvRYejCROS+XvJDmvQ/MNUh7P50q+vEDPe/N+qHrG14a2u1Vmn5xnBAYnWQ87bP7aZPlH0t0UcGgJ38hVpY5per0wfNu+HpzTKZENJNUaYXQkOdaPYNp132yymFU9/E0OG/+dIPVPkKep3h/W0KM9UtS5pVBl95s8pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4293qVjv3Qi/WD2efTcDzmVnov0rOTHrH9WRwXvvzmg=;
 b=LFsVxAEPyyfLhkKe/7mxoB0YL3uCgxq4tGnqFoK/WsxN7NCt8dzO+VIulrcqAkt+YpcWDO9hvim+8h1T4v9lL3VCxFyeh6KpyoppDWI9jliX1y+O8cmPZ1/CKURZ3qB/eqGfCel5qTof/wydfEnalMSLJnWA84PJqYcEWz+5rkY4EI37iLamnCPFlZJjin1OFFtm0Oe0dCobxN9kUf/JWePCo14FM7+eZoCZvGuUhtTxfouxsHlHFHAsMonrc+wBqpmroYjWL//F1XWv7h7bC9ZKMKrKbDIE1fOxmDvpwhRhUZnvYsnf21k6RIAhrSf2uBC5bGpTd4nSU6rmiwp52g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=citrix.onmicrosoft.com; s=selector2-citrix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4293qVjv3Qi/WD2efTcDzmVnov0rOTHrH9WRwXvvzmg=;
 b=JYyXHo5O4Y7+frYA0v0jDHst0fsVouQyf7JbFeTWF4L2hkZxBMzGTCW8FOt3q8k8b99rc5juieREyJy+UXrtgj4x1redwsK0TCmGf3Z9bGDkEKtvwCvGWsUD9uTcFWWbwO19dZglB32chcncCf6ze+IengJ8CCe/Dmt0igCcis0=
To:     Borislav Petkov <bp@alien8.de>,
        Jane Malalane <jane.malalane@citrix.com>
CC:     LKML <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Pu Wen <puwen@hygon.cn>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        Yazen Ghannam <Yazen.Ghannam@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Huang Rui <ray.huang@amd.com>,
        "Andy Lutomirski" <luto@kernel.org>,
        Kim Phillips <kim.phillips@amd.com>, <stable@vger.kernel.org>
References: <20211001133349.9825-1-jane.malalane@citrix.com>
 <YVcZCgOVkCPz1kwO@zn.tnic>
From:   Andrew Cooper <andrew.cooper3@citrix.com>
Subject: Re: [PATCH] x86/cpu: Fix migration safety with X86_BUG_NULL_SEL
Message-ID: <c2d96a84-64d2-b4b4-261d-e98612552ba0@citrix.com>
Date:   Wed, 6 Oct 2021 15:15:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <YVcZCgOVkCPz1kwO@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
X-ClientProxiedBy: LO2P265CA0390.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:f::18) To BYAPR03MB3623.namprd03.prod.outlook.com
 (2603:10b6:a02:aa::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aea9918c-bded-4736-469e-08d988d3d258
X-MS-TrafficTypeDiagnostic: SJ0PR03MB5438:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR03MB5438999542B0BA148286D443BAB09@SJ0PR03MB5438.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xZorUB8BMxB9PUdb9STj4o+rfZHI5Ru+ytRQuaJV+2Ki652S5J0kqz68JiUs8JyoP2fbKEccVT70wciK0N36QqYTx8rm9ZnoMKVhsaKEIepQq+kiUMoUG20JeC/DTOOFM4upt7o2BdLmkZI97I5RgTRF9VxQvsJShkILQQ55uk5Gin2u1o3ecLVKm0IjMeg8uWaqfhKFOa2ri7wR7zI0e+LARcnpJo7F+Ow/RdCWnmx1YjKHM6QyYV5+jHL4JNPLvMY/JpgSK9OCaC0yIR5VxZ//lXKMXmh8PVIpUo/ntbY1MnqIYjGj/E+8Fuw4Qlo4oAlYrgW3Fcgi/8AEwRAlsUeFDgfRsK9VcUGG4GX6Y2Qit+CuiQy2eUO99bjP+J03O26/k4ustYG5hRlpRtwcKAhaVU7taWML8aoR84nc4untVue2qL0AXWco712yI38CSfzvdqv2xWMZcSUb0mmpsrVHd3+2SegtseIzSqUbOUlFdaAaZRoaoe5gR6CC+i/WswzPuvIGFjraOoupiYCeAD3OnnfaiZxO+KgW6U5YGvRHqHJ/LwV7hYkjhJV+9NpK7wVpAFfFDrw3aEbhPvu5o2/fQPtchQJx5oWFWVHIbSUxvqTiY3Oc7/TNQCRhdhsQgw5oxQMgv59vOMnFbhiICNKRPvueTvFu0CD0qxHTtXt5xeqlHiYyTSnYBlhj+4QPvjyVycrm/q83eApOYeWQ/pUsPnerHE1DF+JWybbbhF4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3623.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6636002)(7416002)(8676002)(31686004)(55236004)(36756003)(86362001)(186003)(66556008)(66946007)(66476007)(26005)(110136005)(316002)(956004)(16576012)(54906003)(6486002)(2906002)(4326008)(5660300002)(508600001)(2616005)(38100700002)(8936002)(31696002)(6666004)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QzM3azdKKzNYckV6djZXNU03TzBETnlhWTBWYjNpZXRjY2dqb0tnWTFVTTV2?=
 =?utf-8?B?cUVTanhHaWFqVy9UVjNYZHYvdFhtc2JrUHN0VEJMekVuNEhZamhEN1p3N2Uz?=
 =?utf-8?B?cnFCeS9tbS9lR3d1TlJMaDR2Tm5pRnFzOWpTTGVzeUR6NGZkM214bWdCV3pR?=
 =?utf-8?B?elYwM1BOSVMyRk1CaHlsVitUcUk2MGZqT1NyNWE5S2JYNmh3QzJON0NQQ0Mw?=
 =?utf-8?B?cWxzKzVUSVlkWjY3VWhuejRadWNKeTdsYm90bVR4R0hHekptMGQrbVMyU0to?=
 =?utf-8?B?cnZIcGNNQy9TVWRVNTRDTUZVbDRjYnJZbTdlR05RQk1nTlBsZFNwVzhBUkJX?=
 =?utf-8?B?YlBacy84TVl3Wks2UDg0K0ovZUMvYTRIR29IWVpoSnRLKzRkZVVxaWVIUFdp?=
 =?utf-8?B?dzdqMGR0WUFGSkhwcU9kaGRsQVpxWXlDWEc0RUtyV3lpcUxOa3NnbDNibVRZ?=
 =?utf-8?B?UTV2MndFWUdJcldVUm05bFErNk5KOTRaVmVpVHZUei9FNysrRERJbGhsMEQ0?=
 =?utf-8?B?N2ZMQjdUa1Z5MjJNTG9qTVlVeGZmWDJZTEVQT1lXM3NxTlB3UHUzc25iZ0gz?=
 =?utf-8?B?QisxVndsM3ZRMkNRVTFWMjFpcldhUkVDQnRaK29rQmkxSFRHZDRzZFpKL2p0?=
 =?utf-8?B?NnI3ZlkvNVowa3JoLyszN3JLdkplV2c4SGxDbHUwS3BoRkEwVGhzZ1lJeHEw?=
 =?utf-8?B?QmlzYkpHekdqcGtvS0xTUzR6ODZkbkdycDRob2kwVXJUVytpL1ZNcjhIdVFJ?=
 =?utf-8?B?dlVFME5ySHV1K0RIRmJmYXh2UHJIMTRGdjIrT1hBMUtxY0xjVTR3U0VMWFpn?=
 =?utf-8?B?THNTSmNHNnBwYmM3TnlERWljYmtPK0lhRzlCMnhNZE43SjBsT1BiTy9oaHRV?=
 =?utf-8?B?OVJHS0JwaDRQR1oxMzJsbGRNU2ZTN1hqWXRyNnRnTUNrMHpKMVVxQm5RMjVM?=
 =?utf-8?B?MDdudjdCV2cxZUo2NU1tbmo4MU1Ib25NRDYwU1NsNnJuVi8zWC9aaEhWOW45?=
 =?utf-8?B?WWQ5TWs0YmJKbUZxTW1taUZoS3FqTmlxd2pjcnR1SGdzd09uQUNEYzAvTXBN?=
 =?utf-8?B?RFNmbms5WGRZQVI1MzFyRWFVY1VZcDBqNWExRURZck1CbkpXRXZBWDBWakNU?=
 =?utf-8?B?YUJRWU9WZ0tjU2ZEUGhoY0tIT2V2SmxLTUtkbGFkRFZlWUhwUGVlOTN4RHZt?=
 =?utf-8?B?NjFlTHhLbURRelplMGxqQTNoaFNoTFljQlNRWUNsUXpXNmtnSlR5Nnp1SXRE?=
 =?utf-8?B?c0NCQ0llM0R2bS9aVXVwam9YS1pIL2VHQWxjQUxuQ2NvdEp4cFBPTlRPZTVM?=
 =?utf-8?B?d1hsc1ppa0xpWXowVExIUmFnVXcrSnYzZFFhT3A3OEtDTEgvYlBWK0pjc3RZ?=
 =?utf-8?B?djBzc2J3cFdlUGxKSXpURmVVaWtubGo1OU1EN0NkNm9kRG5aMS9YRnJ5V3FK?=
 =?utf-8?B?bE5waTlXSlMzbFdlL2FWTFB5WlJIMjNPd1h2WW1tRFQvSmU5dlhpZ2d2akor?=
 =?utf-8?B?K1o5Wk5hVnlRdzRpWEtpTkdNTFBrWXIyUWNXM1ozWXBaN3NBMkg4Ym1lK2sz?=
 =?utf-8?B?UTllKzl5dkwvcTVMSW1Ea2o3dUJaWUNUSCtiUkxCR0ZWVGlUdHQ1WWgyVWZh?=
 =?utf-8?B?M3FoUUFmSUlIekVlUE1SZVhtU1FiTTc2QjZhSi80ZFdXR1NsbSs3ZVlqQTMx?=
 =?utf-8?B?dG1CSTNjNG8rTzU3LzNLeFZveFllNEJFc0V0UWcvWjluUnFvRVpXOE9TQm9C?=
 =?utf-8?Q?tcZgKTxTnD/thOGnwvRD+PXTKVB7C68YgckqTDR?=
X-MS-Exchange-CrossTenant-Network-Message-Id: aea9918c-bded-4736-469e-08d988d3d258
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB3623.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2021 14:15:59.9522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ocFCqUlpQ/xidiuPKT+lRvIFy27JINpka9Qdvn9SRXS74WaCFqZv+iLmJImU68ty0/wH/FVFmueX6uQw6h5EoYTOfh7WxHLU7n7/6A7s4ZE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR03MB5438
X-OriginatorOrg: citrix.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01/10/2021 15:19, Borislav Petkov wrote:
> On Fri, Oct 01, 2021 at 02:33:49PM +0100, Jane Malalane wrote:
>> Subject: Re: [PATCH] x86/cpu: Fix migration safety with X86_BUG_NULL_SEL
>> ...
>> Currently, Linux probes for X86_BUG_NULL_SEL unconditionally which
>> makes it unsafe to migrate in a virtualised environment as the
>> properties across the migration pool might differ.
> Sorry but you need to explain "migration safety" in greater detail -
> we're not all virtualizers.

The case which goes wrong is this:

1. Zen1 (or earlier) and Zen2 (or later) in a migration pool
2. Linux boots on Zen2, probes and finds the absence of X86_BUG_NULL_SEL
3. Linux is then migrated to Zen1

Linux is now running on a X86_BUG_NULL_SEL-impacted CPU while believing
that the bug is fixed.

The only way to address the problem is to fully trust the "no longer
affected" CPUID bit when virtualised, because in the above case it would
be clear deliberately to indicate the fact "you might migrate to
somewhere which really is affected".

~Andrew

