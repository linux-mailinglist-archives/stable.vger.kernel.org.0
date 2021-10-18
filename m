Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5B0B432824
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 22:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbhJRUJf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 16:09:35 -0400
Received: from esa1.hc3370-68.iphmx.com ([216.71.145.142]:49397 "EHLO
        esa1.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbhJRUJe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 16:09:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1634587643;
  h=to:cc:references:from:subject:message-id:date:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jgxrFk8fpaY8MiNzLqeU2eC2ScUqVQghwC4SsEoIknY=;
  b=iS4Nm9/xabxkxE1o6QECkcBjabLVcHWM9Far/m8ge0w1ieFwszfUFrnu
   W2smghfrnqY9dhGtTzUdfj+UMeaSE4iNMT29trgzxdRlhvf9bWF5/3f6K
   cbyIV8G0Q+A+JuaeqSSjciV+WNLXUuDyRfTApdLspX4apPxRMGTF47MrX
   U=;
Authentication-Results: esa1.hc3370-68.iphmx.com; dkim=pass (signature verified) header.i=@citrix.onmicrosoft.com
IronPort-SDR: A6wJEtyGrnvIoLu7P9Pq9ZX2IHk/VwBmDFJA9Ma8rx4kgH7PA/c6roliLPXI/bfPaRfm1ILxne
 sZgewW6UWSe/mq3ck9xUyNVOs6yM1Jtb/ZT9p2EZwlgBnxt6Kko8avcNBRL5VRiMCOnFYtXSq1
 lU4nowwaqRtLw9MzN7kpLXw0KjDBHPmCKkt6dUEiFFKahi0c7Deta7TK9dG6vy4qNI1DQIMjxP
 2spnC08vOJZINIV5Rwr8LCLONBxe9JyMqSZwz7Dz4olJx+WG2WM3SusbCVdqMUXnnqNjJxHN/y
 abK6Z/OyXdAA2jmMXfydJeJz
X-SBRS: 5.1
X-MesageID: 55873248
X-Ironport-Server: esa1.hc3370-68.iphmx.com
X-Remote-IP: 162.221.156.83
X-Policy: $RELAYED
IronPort-Data: A9a23:TUpo0aMT/P/+dmDvrR1DkcFynXyQoLVcMsEvi/4bfWQNrUoghjcCn
 GEeUT3VO/+Oajbxe98jbdng8UIBupPVzdRlQQto+SlhQUwRpJueD7x1DKtR0wB+jCHnZBg6h
 ynLQoCYdKjYdpJYz/uUGuCJQUNUjMlkfZKhTr6ZUsxNbVU8En540Uszw7RRbrNA2rBVPSvc4
 bsenOWHULOV82Yc3rU8sv/rRLtH5ZweiRtA1rAMTakjUGz2zhH5OKk3N6CpR0YUd6EPdgKMq
 0Qv+5nilo/R109F5tpICd8XeGVSKlLZFVDmZna7x8FOK/WNz8A/+v9TCRYSVatYo26ohe1Y6
 4oSjrmtRRoXAq/vktgPYzANRkmSPYUekFPGCX22sMjVxEzaaXr8hf5pCSnaP6VBpLwxWzsXs
 6VFdnZdNXhvhMrvqF6/YsBqit4uM4/AO4QHt2s75TrYEewnUdbIRKCiCdpwgWpg2ZsUQaa2i
 8wxTyB/MS/NbgN0GGwSFo0YouySgEXxWmgNwL6SjfVuuDWCpOBr65DtKNP9aM2WQt8TlUGdz
 krD/mL2BTkAOdCfwCbD+XWp7sfXlyT9SoMUFZWi+/JqiUHVzWsWYDUOSES2p9G5m0G5XZRUL
 SQ8/isosLh390GxSNT5dwO3rWTCvRMGXddUVeog52mlwLL86gKYC25UCDJMAPQ6u8smbTgr0
 EKVhdTvBCwpvLD9YWLNqJ+XoCm0NCxTKnUNDQcAUBcCy9ruuoc+ilTIVNkLOLS8n5v1BDj2z
 BiDqSR4jLIW5eYQy6yx+V3vnT2hvN7KQxQz6wGRWXiqhit6ZYvjf4yp7Vza9e1oJYOVCFKGu
 RAsg8WC4focJZCLmjaETOgEEPeu/fntGCbRiFhtFLEu8DOi/3PldodViBl0PkZrP90EPyToZ
 kDTkQpU6NlYO37CRZ5+cY+3TesqxK7mHNHNX/XYKNFJZ/BMmBSvpX80IxTKhia0zRZqwfpX1
 YqnndiEVlcANI1Ek2WNYvoRzIEXxAM0+XHjbMWup/i46oa2aHmQQLYDFVKBaOEl8a+JyDnoH
 8Zj29iikEoHDrWvCsXD2ctKdwpSdClkbXzjg5UPLrbrH+ZwJI025xY9K5sacIt5g78dqO7M+
 nysMqOz4Aui3SOZQelmh3YKVV8OYXqdhS9jVcDPFQzxs5TGXWpJxP1OH3fQVeJ/nNGPNdYuE
 5E4lzyoW5yjsAjv9TUHdoXap4d/bhmtjg/mF3P7O2RjLsMxHVCVoI6Mku7TGM8mVHvfWSwW+
 OXI6+8macBbG1QK4Dj+OZpDMG9dTVBCwbkvDiMk0/FYeVn28ZgCFsACpqRfHi34Ej2anmHy/
 1/PWX8w/LCRy6dooIihrf3V9O+BTrohdne26kGGtN5awwGBpTH9qWKBOc7VFQ3guJTcqPzzO
 7QFkauiWBDF9X4T27dB/39Q5ftWz/PkpqNAzxQiG3PObl+xDahnLGXA1s5K3pChDJcH6GNag
 2qDpYtXP6unIsTgHAJDLQYpdL3bh/oVhiPT/bI+J0CjvH17+7+OUENzORiQiXMCcOspYd19m
 epx6tQL7wGfiwYxNorUhC5j6GnRfGcLVL8qt89GDdaz2BYr0FxLfbfVFjTyvMOUc9xJP0Rze
 m2UiaPOiq5y3E3Hd3ZvR3HB0fAE3cYFuQxQzU9ELFOMw4KXivgy1RxX0DI2UgUKkUkXj7MtY
 jBmbhQnK7+P8jFkgNl4c1qtQwwRVgeE/kHRykcSkDGLRUefSWGQfnY2PvyA/R5F/jsELCRb5
 ryR1E3sTS3uIJPqxiI3VENo967jQNh2+lGQkcyrBZ3YTZwzYD6jia6yf2sY7RDgBJpp1kHAo
 OBr+sd2aLH6anFM8/FqVdHC2ORCUg2AKUxDXeplrfEAEmzrcT2v3SSDdhKqccRXKv2WqUK1B
 qSC/C6Uu8hSAMpWkg0mOA==
IronPort-HdrOrdr: A9a23:XslT7q0BQRSehov1RS+5agqjBLwkLtp133Aq2lEZdPU1SKClfq
 WV98jzuiWatN98Yh8dcLK7WJVoMEm8yXcd2+B4V9qftWLdyQiVxe9ZnO7f6gylNyri9vNMkY
 dMGpIObOEY1GIK7/rH3A==
X-IronPort-AV: E=Sophos;i="5.85,382,1624334400"; 
   d="scan'208";a="55873248"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FKlyOvsKqTaQJmkK/CIuGBaJxenVGC3QM3Uge1opRfoz0dotTHMJAISycG64QtbrtEKMLNpLI4p3cy7QocqnwbkZKgaK6f5tqjbzvQm9a/I9IgHuxOLGE1PWsEOwIE/Q1Sfu7Zw3lXeKVh0bWyo5K98c1mIijhszd97sRcSI1XWlY3ZDh0dC9ZkD4C0m2o79FiFfNQJdljiyUdd421tVZ9tn9Pb8ZY5ZeFSsgN6PcnnPBR8u7yYva4vHpQkp3ijwEQnLQAbuVs+UNTzLiM96Wpx8nsbFCXWD4ukXvlZEK4nlFJ++HIzj/qVM747warFJ7h9v6Rv8cECyyb0q0NlTcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5knk/G5/FdeNTwap9pTcEh5mIeDZTk758qceqq96WpM=;
 b=eWvDKM7qhU+zAaqb5A+wpdirRS460b9ZCrKY4VWcpyn4ePFPJNNoa8bN09CzYvQW2fufUHJ2dGu3nOTOKmTGms/OkiSkXI1aDXfg9KeiU09yl7rZF8Gl5NpDa60tHePNUYiLIhqQYYCoJ2SIot6cPQM6HDNpqyXEWUXWQRftzjqQBhvytOssAi0bqnWxUzPJ7aYop8S59em/M87lElaEzJYoH+VEKUrJ+SlEmmfhOAxiudNZ7ydYfjuo7SO+CJ7ky2be2tnKkbFVJIsMQXhMRL0LD4JMb7RooO+lnfCEfdv3wSyQFXDyIez6f4S4oI6aa6dj+X9o5m+0rq/y+V8FVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=citrix.onmicrosoft.com; s=selector2-citrix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5knk/G5/FdeNTwap9pTcEh5mIeDZTk758qceqq96WpM=;
 b=dE6Ydz9VMSp+HPKZbWXhHWNszhkJDE8UBL3lTqhWDZDoJd8uGw9sN1IFJkPQQ21ZZpwiZvMx835IxaHknmmpcE24wImEgbyksXv5qSmcohM+vy8MU1AioLWzY3qfwwsic3X6i88aK3UwLyWkggmogJS8rlF2YovuAxgXhNMZbwE=
To:     Borislav Petkov <bp@alien8.de>,
        Jane Malalane <jane.malalane@citrix.com>
CC:     LKML <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Pu Wen <puwen@hygon.cn>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Yazen Ghannam <Yazen.Ghannam@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Huang Rui <ray.huang@amd.com>,
        Andy Lutomirski <luto@kernel.org>,
        Kim Phillips <kim.phillips@amd.com>, <stable@vger.kernel.org>
References: <20211013142230.10129-1-jane.malalane@citrix.com>
 <YW25x7AYiM1f1HQA@zn.tnic>
From:   Andrew Cooper <andrew.cooper3@citrix.com>
Subject: Re: [PATCH v2] x86/cpu: Fix migration safety with X86_BUG_NULL_SEL
Message-ID: <bfa45053-1dbf-1cf6-4c6e-f6ec74a50422@citrix.com>
Date:   Mon, 18 Oct 2021 21:06:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <YW25x7AYiM1f1HQA@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
X-ClientProxiedBy: LO2P265CA0189.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a::33) To BYAPR03MB3623.namprd03.prod.outlook.com
 (2603:10b6:a02:aa::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 66b699f8-0d2b-425e-afe7-08d99272bdd1
X-MS-TrafficTypeDiagnostic: BYAPR03MB4421:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR03MB4421B7A91071D06AF9ADC4DCBABC9@BYAPR03MB4421.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9FcBtA+Vmu0m6D26EnQCkSARCpwskfp7rYPV/hZS4P5W7+7WspY4fyAc6L9FnXHBrD5RaLUKGS3WTesENrlb8NJbpSFC8vWt9Uj15ASk7uffJDURRC5HKS2XZcFeiOfJApXb70zL4GftYi0LLYSQqZY95tfM+dNuyJRllbGIOTbDaNdhlFiR/J9iUTJKcuTtaYcDWe6UcBGuU7+sE6R5Jb1zvdQIDFwi2ypZmPSqZpvUF9bpHPqcf7+t+j7NFoGwhhipFEAMi6uI9p4gXsaZ0yiKfDs/WbfsF0F4HHOQRIzK6bzT12nsvBxSfVlaioIXJ/3ZHmteryfLSEnmHBPkEVI9vAoTyTSlKQJkgW7lsZ1FaWxJEDUl0uFGXoWoGaHvWhFgytE37EAkeTV2f9jPtQhZYW4IRYtf5FX4YDEmrxYazTwMgIgbmN2nR9O+nyUMi+ta2YrBacE8cbg3RDftVuPXwSzhmcC2pFXaj+8p7Pg3Ce8u4uZ0o85mP3pXzfbnv8wkOQ2PzRY66n4GZ/IhYDC8OHBBDKcHgDCwJUbVBKFJvpzRQyUUn9lJILN9OdxqVU6c1vhdCg92JR53nYBnJatP8inPajFe48QxaGY9GwRYycpAWDF1sZ65GfV+ud440okLe7u7pHqckVS4CspMc0jmQXYEZRMX9oXhyWCLG+SeB1J26wIlmnDFntslamKGXFI2TjD47ePvhMvDM6sGKrxxIOHPlmXFRwPkfXOV85o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3623.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31686004)(83380400001)(8676002)(26005)(110136005)(54906003)(31696002)(7416002)(8936002)(66946007)(2906002)(5660300002)(186003)(2616005)(53546011)(508600001)(6486002)(956004)(16576012)(6666004)(66476007)(82960400001)(66556008)(36756003)(4326008)(6636002)(316002)(86362001)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Qi9UbHJVRjZ1NkxTQThlZ3dPT2g2RkxLd3hKVHNZc3dLbnQ2NHRwcnNINE55?=
 =?utf-8?B?UHhURWh6cG9TeTh6ZXlQNG5WNi8yMGdITkltMlhJVysyMnJjeWY1ZFhwQXdp?=
 =?utf-8?B?akxOekdtck1zejdHdGgzblZveUNxV0pXUkVHT1Z1VGc3MHRvMDFHTkY5K2Rs?=
 =?utf-8?B?UVJ1U2MvRFFaNVJrdXI3ZHg3Nno1UnNBbUFyYVZsN1NJQWFRNmpVQktOcEZa?=
 =?utf-8?B?ZkFrN0VzeVU2VlUvZm5uSVN3VHlqMUpYRW4vZ0s3VjBPMkkwM0RjZjZqSGl1?=
 =?utf-8?B?WDUyZDRaS2RlaThXbWUrSkc4OGd5QUhKd0FtRHZ5MHNrOXpwMG1MYmNxZ3Yx?=
 =?utf-8?B?WllUREtYeGFMTkZEQlk1TWdGTi9FZXNldHF1dU9vY1pZM3ZZUFp5OVhDcnd6?=
 =?utf-8?B?WS9TOHI0L3Q1Tm5Fd1Z0MDM0Ulk4cDZWMnJEUkVLRFFYVkwwRjZuamNoSzA2?=
 =?utf-8?B?MTg5SGhhQW43MjJwYXRqVkxlQUFzR3ZNd3dQOGVxaDdSeGMvZktnNVVpTkUy?=
 =?utf-8?B?SUpJS3pLdHdiMHhkRnhnOVpVYlFCOS8zYVo1YVhLcWVidm9Sci9ySFZ4UUln?=
 =?utf-8?B?MFhLSnRCeVEwY1lZVnYvOENMOC9rcDhBbFdzMng5aEc4NEEycUxoKzRHbSto?=
 =?utf-8?B?TmRxNHhBMkRIT3JQcERSMG9hUnRlMmxzZkY3ckd2c2JOeHBjM1RVa2E0UHJn?=
 =?utf-8?B?RlJ6T0djZnZxcG40ekQzQXQzYTU2MERucFFGNW54NndUWk9ROEZKRDJzNVZJ?=
 =?utf-8?B?eE93R2d3RWZnMVhvazBqMnJzdXZmb2IvckNHbHZjdE5BckxMS012TzFSRlox?=
 =?utf-8?B?cmtEa3V6Z1J6cmtITVhNZTVOYjduaGp0elRHYWJDWXkwV2RPTkI3cE5CYkhZ?=
 =?utf-8?B?QnIwdTlXeUpobXEramJoWEhVYklJY2NpbmlUYWl3NGdRbGhyQ0NrWndiR2V6?=
 =?utf-8?B?OHN2QXB2OWFBczdzc3Vld0h4cGFYcmowdmV2cTdHbURqM3FzQXYvSEFxakh0?=
 =?utf-8?B?VXV3amViS3hMbEFJTUUrSEdvZmx1ZlhPYm9xVkpSZTdrQTUvMmpHeGNzYlM2?=
 =?utf-8?B?R282NlIwUlBkZFlwanpIbEZlOWwrWE1vQUh5L05mUTZKVGtwVW1RTndmZFJj?=
 =?utf-8?B?TjVqUG80WXlOSzlhV0pHYlhJSUNkV2x4ZlM5Z2JPZVhSTUR5aXB0UE14ZHdw?=
 =?utf-8?B?Yld4NFlmcmZmNHpGRWpjMng4VlpHVDZMOGt0K3lRUWpJTit5RmJvY0EzRjBk?=
 =?utf-8?B?OUlIK244TlFaT2xPZXhaN211eTRvTFU5WlUzNTBCdXk5SHN2MGY3c0FhUlJv?=
 =?utf-8?B?QTUya05La3Bid2E4RCsydnh1TDZEQko4d09qTmxPZ3FwN3pTRGxRd2RyMGhL?=
 =?utf-8?B?MWpBRE8yWXVZd1pxVjE5TmhoVHQrbXZKajQxNE40ZGZDSHFxVEFsS1UvOTZq?=
 =?utf-8?B?RTNOckJpT1VYVjVxek9FMDB3cXpzNEtuTXpaTDVvOE4rWjBPWDg5ZXN4R0F1?=
 =?utf-8?B?eFIrQnBOK3FZWm5oV3Z2YzczUnVYMC9abjU4cWlCbW9OK0Q4RHdLYzNqL1p3?=
 =?utf-8?B?VUZWcHFvM0lEdE9sbkFPM0JFUG1jdU1TWG5la2FKUUVDbVUyaHJuaTJZcHhw?=
 =?utf-8?B?Z2taeE95cWorUk92a1BTQ0htUE1ZMFFETXhURTgrRHl3MTM4TEJBMUtxVEd0?=
 =?utf-8?B?ZDZsU2RGMWhGK2ZDZ29KZjJnenpESjI5bVdtWVNhK3RMWEo5WVNub2t0Vncz?=
 =?utf-8?Q?ENza4rGVt8rpSfaeYk+mbvtBe8Lh1yZwjrKGJ10?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 66b699f8-0d2b-425e-afe7-08d99272bdd1
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB3623.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 20:06:16.0247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eX9AXiT8waMZRaYUnUHp0SYHqMsPeAvGtX3dWGlEtCAfVOhfDeHbxlpXMO4y5O79R7npIxESvT1w4WAKatUsxyTF+QYnpPlyPz0zI50touo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB4421
X-OriginatorOrg: citrix.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18/10/2021 19:17, Borislav Petkov wrote:
> On Wed, Oct 13, 2021 at 03:22:30PM +0100, Jane Malalane wrote:
>> @@ -650,6 +651,27 @@ static void early_init_amd(struct cpuinfo_x86 *c)
>>  	if (c->x86_power & BIT(14))
>>  		set_cpu_cap(c, X86_FEATURE_RAPL);
>> =20
>> +	/*
>> +	 * Zen1 and earlier CPUs don't clear segment base/limits when
>> +	 * loading a NULL selector.  This has been designated
>> +	 * X86_BUG_NULL_SEG.
>> +	 *
>> +	 * Zen3 CPUs advertise Null Selector Clears Base in CPUID.
>> +	 * Zen2 CPUs also have this behaviour, but no CPUID bit.
>> +	 *
>> +	 * A hypervisor may sythesize the bit, but may also hide it
>> +	 * for migration safety, so we must not probe for model
>> +	 * specific behaviour when virtualised.
>> +	 */
>> +	if (c->extended_cpuid_level >=3D 0x80000021 && cpuid_eax(0x80000021) &=
 BIT(6))
>> +		nscb =3D true;
>> +
>> +	if (!cpu_has(c, X86_FEATURE_HYPERVISOR) && !nscb && c->x86 =3D=3D 0x17=
)
>> +		nscb =3D check_null_seg_clears_base(c);
>> +
>> +	if (!nscb)
>> +		set_cpu_bug(c, X86_BUG_NULL_SEG);
>> +
>>  #ifdef CONFIG_X86_64
>>  	set_cpu_cap(c, X86_FEATURE_SYSCALL32);
>>  #else
> Can we do something like this?
>
> It is carved out into a separate function which you can simply call from
> early_init_amd() and early_init_hygon().
>
> I guess you can put that function in arch/x86/kernel/cpu/common.c or so.
>
> Then, you should put the comments right over the code like I've done
> below so that one can follow what's going on with each particular check.
>
> I've also flipped the logic a bit and it is simpler this way.

:) Sadly...

>
> Totally untested of course.
>
> static void early_probe_null_seg_clearing_base(struct cpuinfo_x86 *c)
> {
> 	/*
> 	 * A hypervisor may sythesize the bit, but may also hide it
> 	 * for migration safety, so do not probe for model-specific
> 	 * behaviour when virtualised.
> 	 */
> 	if (cpu_has(c, X86_FEATURE_HYPERVISOR))
> 		return;
>
> 	/* Zen3 CPUs advertise Null Selector Clears Base in CPUID. */
> 	if (c->extended_cpuid_level >=3D 0x80000021 && cpuid_eax(0x80000021) & B=
IT(6))
> 		return;
>
> 	/* Zen2 CPUs also have this behaviour, but no CPUID bit. */
> 	if (c->x86 =3D=3D 0x17 && check_null_seg_clears_base(c))
> 		return;

... this is 0x18 for Hygon, and ...

>
> 	/* All the remaining ones are affected */
> 	set_cpu_bug(c, X86_BUG_NULL_SEG);

... hypervisor && !ncsb still needs to set BUG_NULL_SEG, so you really
can't exit early.

> }
>
>> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
>> index 0f8885949e8c..2ca4afb97247 100644
>> --- a/arch/x86/kernel/cpu/common.c
>> +++ b/arch/x86/kernel/cpu/common.c
>> @@ -1395,7 +1395,7 @@ void __init early_cpu_init(void)
>>  	early_identify_cpu(&boot_cpu_data);
>>  }
>> =20
>> -static void detect_null_seg_behavior(struct cpuinfo_x86 *c)
>> +bool check_null_seg_clears_base(struct cpuinfo_x86 *c)
>>  {
>>  #ifdef CONFIG_X86_64
>>  	/*
>> @@ -1418,10 +1418,10 @@ static void detect_null_seg_behavior(struct cpui=
nfo_x86 *c)
>>  	wrmsrl(MSR_FS_BASE, 1);
>>  	loadsegment(fs, 0);
>>  	rdmsrl(MSR_FS_BASE, tmp);
>> -	if (tmp !=3D 0)
>> -		set_cpu_bug(c, X86_BUG_NULL_SEG);
>>  	wrmsrl(MSR_FS_BASE, old_base);
>> +	return tmp =3D=3D 0;
>>  #endif
>> +	return true;
>>  }
>> =20
>>  static void generic_identify(struct cpuinfo_x86 *c)
>> @@ -1457,8 +1457,6 @@ static void generic_identify(struct cpuinfo_x86 *c=
)
>> =20
>>  	get_model_name(c); /* Default name */
>> =20
>> -	detect_null_seg_behavior(c);
>> -
>>  	/*
>>  	 * ESPFIX is a strange bug.  All real CPUs have it.  Paravirt
>>  	 * systems that run Linux at CPL > 0 may or may not have the
> So this function is called on all x86 CPUs. Are you sure others besides
> AMD and Hygon do not have the same issue?

No other CPU vendors are known to have this issue.=C2=A0 (And by "issue",
even this is complicated.=C2=A0 Back in the 32bit days, it was a plausible
perf improvement, but it backfired massively for AMD64 where there was a
possibility/expectation to use NULL segments.)

Andy only put the check in unilaterally just in case, and even that was
fine-ish until AMD went and fixed it silently in Zen2.

> IOW, I wouldn't remove that call here.
>
> But then this is the identify() phase in the boot process and you've
> moved it to early_identify() by putting it in the ->c_early_init()
> function pointer on AMD and Hygon.
>
> Is there any particular reasoning for this or can that detection remain
> in ->c_identify()?

No particular reason.=C2=A0 It needs resolving before init gets created, bu=
t
any time before that is fine.

> Because if this null seg behavior detection should happen on all
> CPUs - and I think it should, because, well, it has been that way
> until now - then the vendor specific identification minus what
> detect_null_seg_behavior() does should run first and then after
> ->c_identify() is done, you should do something like:
>
> 	if (!cpu_has_bug(c, X86_BUG_NULL_SEG)) {
> 		if (!check_null_seg_clears_base(c))
> 			set_cpu_bug(c, X86_BUG_NULL_SEG);
> 	}
>
> so that it still takes place on all CPUs.

This would only really work for boot cpu and setup_force_cap(), because
no CPU is going to have X86_BUG_NULL_SEG set by default, but this still
misses the point of the bugfix which is "check_null_seg_clears_base()
must not be called when cpu_has_hypervisor".

In practice, the BSP is good enough.=C2=A0 The behaviour predates the K8,
which was the first CPU where it became observable without
SMM/PUSHALL/etc, and quite possibly goes back to the dawn of time, and
you can't mix a Zen1 and Zen2 in a 2-socket system.

>
> I.e., you should split the detection.
>
> I hope I'm making sense ...
>
> Ah, btw, that @c parameter to detect_null_seg_behavior() is unused - you
> should remove it in a pre-patch.

It is made unused by this patch, so can't be pulled out earlier, but
should be adjusted.

~Andrew

