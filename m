Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4F6C432872
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 22:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbhJRU21 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 16:28:27 -0400
Received: from esa4.hc3370-68.iphmx.com ([216.71.155.144]:28588 "EHLO
        esa4.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbhJRU20 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 16:28:26 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Oct 2021 16:28:26 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1634588775;
  h=to:cc:references:from:subject:message-id:date:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=e0WEoxviSomcfgv69YZIFtnnJemFellICfA4UqB9ER0=;
  b=hBJaviOrdGI6MS7gVpbSMnzR444ll/MU7ACQvtUKRTssOE83ZBh80F1x
   jTouhSEBnDv/rL47EmFWfWJpwZrBBn/OnFyD4w/mc2XIicCgyl5NgqMDq
   F6fhpou9CfpAt/9/xu1ex2WgP87oizhr4oH3LlrkKSRwoTAYl+VZKUiA1
   A=;
Authentication-Results: esa4.hc3370-68.iphmx.com; dkim=pass (signature verified) header.i=@citrix.onmicrosoft.com
IronPort-SDR: 9+WH82c/lF1K25fdZtOYfpQKKcmWeJDlEqVIzMDI79TVkW6gH2oC99+wGRL5qym2Yf4SFASQ1p
 JnkOz9NM/dqzl5N+Za/LhH/8QgvMpwt7nJkz5mQ3m2YOTxNAJq7dOBAK0UcC/PIi8dvaQLQVbC
 Yf8PejmvwKaQbj+xLETPj4cUXK8chhwDC5SqeNe4vsCaWEmZlqjdM84HgBVa5Tpb4GW1tlNjpF
 KR5mCcUD2dQ186ndQO7EvWmVyKpCGMYHI2JcbmR35Br2mSOFHXmZTPcX5S8RMvQns8V0tjLSzc
 nqn/Zr2i/6KPDg1hXcseX39I
X-SBRS: 5.1
X-MesageID: 57371604
X-Ironport-Server: esa4.hc3370-68.iphmx.com
X-Remote-IP: 162.221.156.83
X-Policy: $RELAYED
IronPort-Data: A9a23:d+ipa6p0f9ZEydS+cKl8hmBREQJeBmL/YxIvgKrLsJaIsI4StFCzt
 garIBnVbvyDZGTzfN0nPNyw8RwF78PSyddgTFBrriwyFi1E+ZuZCYyVIHmrMnLJJKUvbq7GA
 +byyDXkBJppJpMJjk71atANlZT4vE2xbuKU5NTsY0idfic5Dnd84f5fs7Rh2Ncx2YHpW1nlV
 e7a+KUzBnf0g1aYDUpMg06zgEsHUCPa4W5wUvQWPJinjXeG/5UnJMt3yZKZdhMUdrJ8DO+iL
 9sv+Znilo/vE7XBPfv++lrzWhVirrc/pmFigFIOM0SpqkAqSiDfTs/XnRfTAKtao2zhojx/9
 DlCncLgWB5xNerVotoiXyhnGgdQHfVGw6CSdBBTseTLp6HHW37lwvEoB0AqJ4wIvO1wBAmi9
 9RBdmpLNErawbvrnvTrEYGAhex6RCXvFKoZtmtt0nfyCvE+TIqYa67L+cVZzHE7gcUm8fP2O
 pVCNmMxNEiojxtnOUkrMYI6rduUtnT0SHpYlmKRpKg77D2GpOB2+Oe0a4eEEjCQfu1Qn0CXo
 Urc8mj5Cw1cP9uaoRKZ/Xa8ruvOmz7nQoUUFa3++vMCqEWO2WEVIB0HWly95/K/4ma+Q9t3O
 V0I/TBopq83nGShVvH0Wxy1pi7CshN0c8FdGus44ymCza3b5wvfDW8BJhZROIIOt8IsQzEuk
 FiTkLvBAT1pra3QSn+H8LqQhS29NDJTLmIYYyIACwwf7LHLpJwviTrMQ8xlHarzicf6cRnqy
 iHMrDU3gbo7hMsHka68+DjvmC6lrJzEZhA66x+RXW+/6A59Iom/aOSA6lneq+5ALYKdT0Gal
 HEBl46V6+VmJYmAiCGXUs0MGr+z7vqIOTGahkRgd7E5/TOr6X+lfKhK7T1+LVsvOcEBERfje
 k7RtBhRooRSOnSqRaZyb8S6DMFC5ZnpB9njEN/UZ9xIa51ZfQqLuippYCatM3vFyRZ21/tlY
 NHCLJjqXS1y5blbICSeGbcMyOcggTkE+1zfdK/y6TqHibqleyvAIVsaC2emYuc85aKChQza9
 ddDKseHoylivP3Cjjr/qtFLcwhbRZQvLdWv8ZYPL7/cSuZzMDh5U6e5/F83R2Byc025fM/z9
 XahRlQQ9lP7gXDWQelhQiE+MO2xNXqTQHRSAMDNAbpK8yV7CWpMxP1GH3fSQVXB3LYypRKTZ
 6JdE/hs+twVFlz6F801NPERVrBKehWxnh6pNCG4ejU5dJMIb1WXoYO4L1a+rnVSVHvfWS4CT
 1uIjFKzrX0rHFwKMSorQKj3kwPZUYY1yYqeoHck0vEMIR6xoeCG2gT6j+MtItFkFPkw7mDy6
 upiOj9B/bOli9ZsqLHh3PnYx6/0Q7oWNhcLRAHzsOfpXRQ2C0L+mOesps7TJmuDPI41kY3/D
 dhoIwbUYKRWwgca7dAie1uppIpnj+bSS3Zh5l0MNF3AbkixC6MmJX+D3MJVsbZKyKMfsgyzM
 n9jMPEGUVlQEM+6QlMXOiQ/aeGPiaMdljXItKxnK0Tm/i5nurGAVBwKbRWLjSVcKppzMZ8kn
 rh96JJHtVTnh0p4KMuCgwBV63+Ici4KXZI4u8xIG4TskAcqlA1POMSOFi/s7ZiTQNxQKU12c
 CSMja/Piu0ElErPenY+D1bX2u9ZichcsRxG1gZadV+IhsDElrk82xgIqWY7SQFczxNm1eNvO
 zc0ax0pdPvWpzox3ZpNRWGhHQ1FFSa1wE2pxgtbjnDdQmmpSnfJcD83N9GS8R1L6GlbZDVao
 u2VkT63TTbwccjt9SIuQko5+ef7RNl8+wCeysCqG8OJQ8szbTb/2/L8YGMJr13sAN8rhV2Br
 u5vpb4iZar+PC8Wgqs6F4jFiuhAFEHafDRPEaN74acEPWDAYzXjizGBJne4dt5JO/GXo1SzD
 NZjJ54XWhmzvMpUQuv32ULYz2dIocMU
IronPort-HdrOrdr: A9a23:qKSOXaPpfjUuE8BcTjujsMiBIKoaSvp037BK7S1MoNJuEvBw9v
 re+MjzsCWftN9/Yh4dcLy7VpVoIkmskKKdg7NhXotKNTOO0AeVxelZhrcKqAeQeREWmNQ96U
 9hGZIOdeEZDzJB/LrHCN/TKade/DGFmprY+9s31x1WPGZXgzkL1XYDNu6ceHcGIjVuNN4CO7
 e3wNFInDakcWR/VLXAOpFUN9Kz3uEijfjdEGY7OyI=
X-IronPort-AV: E=Sophos;i="5.85,382,1624334400"; 
   d="scan'208";a="57371604"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O6/bGCzVWiWkZeW14Cntvd7ZcDAjCM376qRm7qHWgVdStFopjbuIPGC7bH7cwrlshu/ftwpb3KAlxMBauTRoozwntNm1vQ+GRgNQxLEerH/clEurk6LTO6gRjTFI8nQ8M7mYUPDRAPTQ1QUHj7kYX0fpU0ZQdPPHVZuMqWFkO9X1IJFV4aZbwlM1dxWj7Uuf9pWTkIc5PxUelkfWTbJTBx+usgf9YedS9FkYUmzEMJkL5aO3ivyTx8MDUZURdnNUrqt4UnNpNpdzHQqDMJvznZjyXM72LQZ79dqWpopSBqTDaYn+S8tpSHJei5gIusX2SpVcYPns5c7TbxL0V9lrsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hSu1MkRiPyeVF66HHg2Trf9sGzHNSV3VcvMsEeEroIE=;
 b=NaxUUxUf+meAPQNSMYSFSDtvoCa5tGfAPsSd4vKHI9Fd8Y8g6WSWhxfJKbDXoQibGfaMPzfCnaAAH9Cduz+VwmmaPbGwtai7D/aIxm1ptOtsRlfo22wdtp3RyxW9FNoKUIKGb/0DbCwMZ2+8BpHkt5l+E4wk0F5XreE/Rt9W4RazG253YVHVkZG/KtzqSrkDYp6hVix4epGPqJV24AiI3e1NgjJqUctCq2favfyxtRoy0//C0NkLtKXsZAewfQGNNdvUoZ2l3o9Wy98nk419YAtJRj8FqIvnjfEizr93m/RSiFhARkfzJik9g46ZPJnJ+x1bevK2RNlC9Ly2ZQi4Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=citrix.onmicrosoft.com; s=selector2-citrix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hSu1MkRiPyeVF66HHg2Trf9sGzHNSV3VcvMsEeEroIE=;
 b=dHMBDUi3lxK28DH8DDd/3cePRFxS9k2jIAnhv5ljwpLehn5GCiQMZKfCC2Nv3/WqK1IpyOM0Mh5nXcQf8FX+iR3w65lgicoQu0fNbUs4KCVsiq1d5vH4Kkas2mIzPcYPNejuhbmBeUo6Yz+ZP4/i4fUTk2CASgq8XLgwhb17xq0=
To:     Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>
CC:     Jane Malalane <jane.malalane@citrix.com>,
        LKML <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Pu Wen <puwen@hygon.cn>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Yazen Ghannam <Yazen.Ghannam@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Huang Rui <ray.huang@amd.com>,
        Andy Lutomirski <luto@kernel.org>,
        Kim Phillips <kim.phillips@amd.com>, <stable@vger.kernel.org>
References: <20211013142230.10129-1-jane.malalane@citrix.com>
 <YW25x7AYiM1f1HQA@zn.tnic> <YW3LJdztZom+xQHv@google.com>
 <YW3M40tOILjI3DiD@zn.tnic> <YW3TdmEe/mx/5aOO@google.com>
From:   Andrew Cooper <andrew.cooper3@citrix.com>
Subject: Re: [PATCH v2] x86/cpu: Fix migration safety with X86_BUG_NULL_SEL
Message-ID: <16b82fc8-fbcd-bca4-f290-ef96cd747a15@citrix.com>
Date:   Mon, 18 Oct 2021 21:18:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <YW3TdmEe/mx/5aOO@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
X-ClientProxiedBy: LO2P265CA0468.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a2::24) To BYAPR03MB3623.namprd03.prod.outlook.com
 (2603:10b6:a02:aa::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2db98353-33ad-4a74-6303-08d99274862a
X-MS-TrafficTypeDiagnostic: BYAPR03MB4743:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR03MB4743CC74B31903E68E323D0ABABC9@BYAPR03MB4743.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dyhs4fSANNih778vh9oXGNN97iBFCD9LQBzJARoZh7qOwN4eI1++Qy1vdSW/yoEkhWKidFOpYc9tisuAo16/Kh1q59e/Xge4hj99f43hBOGk1D6mT/UelduliIg89Fm1e/8Fv9Ffh0KfacWy1rU++Wf630B8w/fbcww3yQgEGpnjwj6ChfltZZ9TVytiutD5vN4hFlamAvWJguusUaCMkqPoAbNXfEBozQYYrjKOKyqCV/zPVpIeLIMt1imHKA46Yir/E4yLXTpIL9NDUbZznfZ1FcGsf5aUQQYpQMlRdY4fY0Lsm7dwfaSxGuBWUM8wPrxzBdMmkwG/vcWm3O20QA4Bn+/9iLvgPZ2rJvQkrhiXBTpZ9C65Bh9ig+JEaOSjxCMg6p2Tpp7jcAwmOvaBOnItZz7chtAy5/8tOoA85peZxTb0athBMknEYXjterdHUw64EYUSx1Z617mTQ2h4yLY5BUzkjXgGtkntkR2nwN6IFSexwrT8VlCCBVZQ6GiULjHE+RnKaLCVzXFzEguv+HeB3/16VZU0LOo351UZuV17Ilr+n3i8JTOu1muwxGGUub2mwo8z/m7Ph3XdXlti2TnZSsSk/d4Q2Blv/E/EVZhuBgHoLzldJXzhaaaLgkciaSYhGZHRadEGZosJqXOccRCCOlIyuaxIr2QAunQSpjIyhlRmLoNp81vj3AZchguuJGRQQ8xFgIM0pbFVUErznWfUwhukJ1PLiSXhACYYapMz8+7lmNiolFK2ztWGFDQ+xB4nH3wn/BPz0GoSLicEB/R+2TBuMMXneZHgxkzZUdEzJi3/3tUD+VscQDwW91nX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3623.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(966005)(2906002)(53546011)(8936002)(316002)(6666004)(86362001)(956004)(31686004)(26005)(16576012)(508600001)(7416002)(54906003)(110136005)(5660300002)(38100700002)(186003)(82960400001)(31696002)(6486002)(4326008)(36756003)(8676002)(66476007)(2616005)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RndSR2FWbmxKS2tRSnk2eFJUNlFjU05nTU9JK1V5VDhMR0lOQU9YWnkrT1pi?=
 =?utf-8?B?OWxZTlpYdTN0WjZJTFBZZEFlaUZ3b2VQalkwaHQ3dG1kTmFGTEFBQkpvTjJj?=
 =?utf-8?B?c1E3YlUvano3citkYlRoQS9WTzNjTzBUT0FGWWcyeWdQYzc4RFk2cEdDZk1k?=
 =?utf-8?B?WTI0N0xZRWd4TjI4eGhxbUFwZll3OU1JUC9odURjNEJBU3llbis3c1N0NnRF?=
 =?utf-8?B?V0FKTVlRMEFndGZUWWc1cTZ0cUk5aUNKazc0UjJQUW4va2lXQlBZVHNydDV0?=
 =?utf-8?B?cmNOQXlGbWw1NTNQSFI4bk1qdkZ2VklkVzZ4YnppQXFVY2xjZFMzU1J1K1Nr?=
 =?utf-8?B?NWJnVU5GQVRiQ1J3bnIyTGhpRlRyR3NiUmU5ZUJCWlN4TWhEelFZeHFVeDN3?=
 =?utf-8?B?akJPNTZSSWJJVnN0eXYzK2dQTm96OFpiLzFLbjB1aXVvVThnYTVvSy8xSE5t?=
 =?utf-8?B?dWwwRUJCcEdRTGh3QWIzOEVmVGE0VDRwSEN6TFZ2bjgweVU2YmtzNW9odDYy?=
 =?utf-8?B?TFVsLzhZNU5PV2J5WjBoTkNJY2MrN3Fralh1WG1heERub2JpQWZqS2U5K0hy?=
 =?utf-8?B?UUVPZG43c1dzZm40NS9CS0lXMlJxQlg4Mk9vcTFoTmtTU2VXL2hHRUhyUDNQ?=
 =?utf-8?B?VWh0Q0M2NFpsRGxkSzVUZksvOWFVZmZoK1N0NFJpSWdQMm5mMyttRndYZjJI?=
 =?utf-8?B?MFdtdVdiSC9YcnhHR25DTjZ1R1dNRE9VOUtvTVZEcHllcStyVG1CNlZPNVdK?=
 =?utf-8?B?YTB4N1NQelIzdEVFczdac0xtaXRzWS9MOFVwazBsZE9NQ1BDNkVDUFJ0ODNo?=
 =?utf-8?B?RHNkTXVmQjNCMVU5U1Fadm5pcnVSREJuRFdFSWlOWGk4QzFWc1NPM2ZYUzJT?=
 =?utf-8?B?OUZPQWVJc1F2Rm9jWEMvYXAyeFRFcFBEbmpSYlJyUFNQMTg2dGJDNEs3MTNT?=
 =?utf-8?B?T2U5SVdNbjEzNzdvQ0RuSTNWR09vM0hubHl0ZGtoRmgvRjFXV2pjSzlyZXNK?=
 =?utf-8?B?TFVLbm1FNFY2ditSN0xWeU80R0FEekJOMS9aNlNZY2daVnk5ODFlSUVSdVFI?=
 =?utf-8?B?MUQvQkUwUnFaM0t5d09nR1BMZ3QrMkVCVkZ1cy83cW9UWWloL2lKSFRUTmxW?=
 =?utf-8?B?ZGNpMVQ4WWJZV1J5a2NGT2dTTlJhYkFVL0hRNlZyemliei9aekxiNlJwcW14?=
 =?utf-8?B?dERqQlk0L2pGSm8xQ1JJVEQzTXUrT29qWnlIWFMwVk5TODgrdlphZWhkNDVW?=
 =?utf-8?B?d1NZYXkwV0c3cHk2dHcveUtHRWdteTI5UmRpc1gvd3MwVno1YnZIbnB4bTE5?=
 =?utf-8?B?eFdYdGc4M1hYVzVCS25DY0YzNHRjVWRTWEVncWhERlBBYWxVZEswbzlwRWhH?=
 =?utf-8?B?Q2RQVWRxa2RLYVZRWjNFWkNjWDJodDBjVHdtcmNaZjlOS29VWDFHTHBtZ2VV?=
 =?utf-8?B?N2VHSmhyNG9mMlZmL0FLMWdlZy9VdkFNM3JXUXgvT0JBV2w5UnZXNWFJdDF0?=
 =?utf-8?B?S1pXODRGMlBNTWRuemYvUWYyeWZRL1pZK2NwQkRTa1VKdGhTTXV4dzFHbkZw?=
 =?utf-8?B?aEkzMFZ0MEsxWlNtR1VuTklXLzlFR0pleXh4d0hpZmhzYU5xYlBmNldsbTdP?=
 =?utf-8?B?M04xbVdTcEtkMm5UYnp4V3NPRkNTdG9WMllyWU90UTd0UjJsY0NBUkdnN0JK?=
 =?utf-8?B?eWdGSGxUMy9yZWFMSFRPMnlraGxPTy9tMit3bnNKQlZhM2EwY2c2TkFieFZz?=
 =?utf-8?Q?3XEvoTCZ/V4kpdABdUom8aGp5zlNYOmC7dq5x+W?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2db98353-33ad-4a74-6303-08d99274862a
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB3623.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 20:19:01.6071
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +ppQRtMOEU2V66dRDYTg6sG5Z+96IJqqDgP+fdzywo8zeQ51L/wsRReOt+8hYrC4g5waxx5pQBW8epYvSG/6lI90IL4XfXwG3cmYWpdoHJ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB4743
X-OriginatorOrg: citrix.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18/10/2021 21:05, Sean Christopherson wrote:
> On Mon, Oct 18, 2021, Borislav Petkov wrote:
>> On Mon, Oct 18, 2021 at 07:29:41PM +0000, Sean Christopherson wrote:
>>> I agree.  If the argument for this patch is that the kernel can be migr=
ated to
>>> older hardware, then it stands to reason that the kernel could also be =
migrated
>>> to a different CPU vendor entirely.  E.g. start on Intel, migrate to Ze=
n1, kaboom.
>> Migration across vendors? Really, that works?
>>
>> I'll believe it only when I see it with my own eyes.
> There are plenty of caveats, but it is feasible.  KVM even has a few patc=
hes that
> came about specifically to support cross-vendor migration, e.g. commit ad=
c2a23734ac
> ("KVM: nSVM: improve SYSENTER emulation on AMD").

http://developer.amd.com/wordpress/media/2012/10/CrossVendorMigration.pdf

Yeah - it really did work back in the day.=C2=A0 For Xen PV guests, it stil=
l
largely works today, because the most obvious vendor specifics were
already abstracted away in the PV ABI.

Of course, none of this has remotely survived the speculation
apocalypse.=C2=A0 A cross-vendor VM has 0 chance of getting speculation
safety working.

~Andrew

