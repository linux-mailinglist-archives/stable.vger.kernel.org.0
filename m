Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26A73595C4F
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 14:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbiHPMxM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 08:53:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbiHPMxL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 08:53:11 -0400
Received: from esa3.hc3370-68.iphmx.com (esa3.hc3370-68.iphmx.com [216.71.145.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A3BB40E17;
        Tue, 16 Aug 2022 05:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1660654385;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=jt80xUogDH7cV/6mCtxlkhtHc9teBJrNFjHTXmI7owo=;
  b=IjKk+O5RkDZ1wN0C8WY6neUsOFEA4KE670kWhdnyWZtZhlTmVvPZCUQH
   BGPu3Cy/I4R1cx9VjSjGiVsAaHS/u6CO7HL7c7RgJlGxa48rO5MJFiDuD
   tfjt0fKrl/b65O456mltTnvSRG858bZDOYqX38wmIoqJmmIzf1c5u/IJi
   g=;
X-IronPort-RemoteIP: 104.47.58.106
X-IronPort-MID: 78198276
X-IronPort-Reputation: None
X-IronPort-Listener: OutboundMail
X-IronPort-SenderGroup: RELAY_O365
X-IronPort-MailFlowPolicy: $RELAYED
IronPort-Data: A9a23:jJLINKKk2Dy4ZkxrFE+RmpUlxSXFcZb7ZxGr2PjKsXjdYENS0GAOy
 zAbWzrQPvqDYGf3eowlO4SxoBsH6MDUy4JrQVBlqX01Q3x08seUXt7xwmUcns+xwm8vaGo9s
 q3yv/GZdJhcokf0/0vraP65xZVF/fngbqLmD+LZMTxGSwZhSSMw4TpugOd8iYNz6TSDK1rlV
 eja/ouOYzdJ5xYuajhOs/La9ks11BjPkGhwUmIWNKgjUGD2zxH5PLpHTYmtIn3xRJVjH+LSb
 44vG5ngows1Vz90Yj+Uuu6Tnn8iG9Y+DiDX4pZiYICwgwAqm8AH+v1T2Mzwy6tgo27hc9hZk
 L2hvHErIOsjFvWkdO81C3G0H8ziVEHvFXCuzXWX6KSuI0P6n3TExMVFXHkzFJwhxeNeXGxn3
 L9IFmkVV0XW7w626OrTpuhEoO0GdZGuEKZB/3ZqwHfeEOosRo3FT+PS/9hE0Twsh8dIW/HDe
 84ebjkpZxPFC/FNEg5PVNRiw6H11j+mK2MwRFG9/MLb50D6ygBr3aerG93SYtGQHu1en1qCp
 3KA9GP8av0fHIPPkGvVqC3y7gPJtTqqApAoC4+oze5rgH3Llk4PIkE9RWLu9JFVjWb7AbqzM
 Xc84icyoLIg3E2tQMP0UxCxrDiDpBF0c9VKHuI56CmJy6zJ8wieG24IRyJAb9pgs9U5LRQu1
 1mUj5bqCCZpvbm9V32Q7PGXoCm0NCxTKnUNDQcfUQIP59TLvo4+lFTMQ8xlHarzicf6cRn8y
 jaLoSx4nLMegcIM0Y2//Fbak3StoITESkg+4QC/dnqs8Qp/Io24YoWyr1fG9epJBIKYSESR+
 nkCh8WaqusJCPmlnjSlW/gWEfel6p6tLDLYkXZrHp886y6q/X+zO4xdiBludBlBMcsefzLtJ
 kjJtmt55odUPX6gaqJfeY+9C802i6PnELzYuuv8a9NPZt19cVGB9SQ3PUqIhTm1zg4rjL01P
 oqdfYC0F3EGBK97zT2wAeAAzbsswSN4zmTWLXzm8ymaPXOlTCb9Yd843JGmN7BRAH+syOkNz
 +tiCg==
IronPort-HdrOrdr: A9a23:1NeeJayw6ZYZznwg47YFKrPxBOgkLtp133Aq2lEZdPULSKGlfp
 GV9sjziyWetN9IYgBapTiBUJPwIk81bfZOkMQs1MSZLXPbUQyTXc1fBOrZsnfd8kjFmtK1up
 0QFJSWZOeQMbE+t7eD3ODaKadu/DDkytHPuQ629R4EIm9XguNbnn5E422gYy9LrXx9dP4E/e
 2nl696TlSbGUg/X4CePD0oTuLDr9rEmNbPZgMHPQcu7E2jnC6l87nzFjmfx1M7XylUybkv3G
 DZm0ihj5/T8s2T+1v57Sv+/p5WkNzuxp9qA9GNsNEcLnHBmxulf4NoXpyFpXQQrPu04Fgnvd
 HQq1MLPth16VnWYmapyCGdlTXI4XIL0TvP2FWYiXzsrYjSXzQhEfdMgopfb1/w91cglMsU6t
 MJ40up875sST/QliX04NbFEztwkFCvnHYkmekPy1RCTIolbqNLp4B3xjIWLH5AJlO+1GkUKp
 goMCju3ocRTbpcVQGBgoBb+q3pYp30JGbffqFNgL3P79EcpgEF86JR/r1iop5HzuN8d3AM3Z
 W7Dkwj/os+MfM+fOZzAvwMTtCwDXGISRXQMHiKKVCiD60fPWnRwqSHqYndydvaD6Dg9qFC7q
 jpQRddryo/akjuAcqB0NlC9Q3MWny0WXDoxttF75Z0t7XgTP6zWBfzA2wGgo+lubESE8fbU/
 G8NNZfBOLiN3LnHcJM0xflU5dfJHECWIkeu8o9WViJvsXXQ7ea/tDzYbLWPv7gADwkUmTwDj
 8KWyXyPtxJ6gSxVnrxkHHqKgfQk4zEjOdN+YThjpguIdI2R/xxWyAu+CeEz9DOLyFeuaore0
 Y7KK/7k8qA1BuLwVo=
X-IronPort-AV: E=Sophos;i="5.93,241,1654574400"; 
   d="scan'208";a="78198276"
Received: from mail-dm6nam10lp2106.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.106])
  by ob1.hc3370-68.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 16 Aug 2022 08:53:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lwrmNSZdo792XVyDo0CKUuxTBNMvRo06hGnOwadsGLpIce96fEf72TWtHbKIUizqnnneZFDWz9aet31fBa3JybmmxcBMgC6rukp8fzbZYlFmJJrZiiCO28bSFVGjs4xTT20s7scv1m4tRChxV6KPuKUebAxs4BYjaKJpHpm9Kz5xO6SB3T5t9oRYcRdkDTANsmAdzb2NqT72OpzL80AsOi4r6AG2JdDhoJNCjNu3ik2zUeFc9j9YT/l4F6qumoV5WbeMIhOio7I/OaMQolsMleQFmyzdIjhuZYrHpG7jaLMfrIRB0jjp7tFoPYMdx5Y47m8ySBQ/P+dSYkU9zcMpBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jt80xUogDH7cV/6mCtxlkhtHc9teBJrNFjHTXmI7owo=;
 b=HG380eRP8BQG2Z90pVe5vMu686CpcbIDYo4y6NAzD9AFySLDtHh2povDjVLs4ddPKZD+1jOQAxziFMR250GM4k30OmqwmeOGjHsDMrv/ha2AwpXuDE8gMegaZCRTmJj3OK1UFm2TAVpWJYqIveU4pheb2IK0Q+5bcLaXzzim9dNRkguKnBiX1AfqObu+iAq5smrzNSKDr5SNJNvxJNGQBhe9BzTmuIXZPh4sUz68vDdENPJgflcUJ6FgWy4LF10WxS1OedAQ2HMGxn7MHU0v/adRaYoZnXvJujfMyDguwPT1BOhBWw8K+cstSC1IxdIpo4z/m7Jj2zIsnLIqU/Vw4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=citrix.onmicrosoft.com; s=selector2-citrix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jt80xUogDH7cV/6mCtxlkhtHc9teBJrNFjHTXmI7owo=;
 b=TeP6yZvPAonDpl5a/1DOldJpVrauYInChUVQHYYPmLAYZUqC/oOvxH8v+V3ApK+6OzOGaLwZegl4rHrzIzvupdCt6nYDrwWD3TB3k1nqi2j1OYEuhWZ+nG8XwL1Kki+13kSmiwSEaUnEnjFsWmnZssrTjwZu07zw780PLppnWiQ=
Received: from BYAPR03MB3623.namprd03.prod.outlook.com (2603:10b6:a02:aa::12)
 by DM4PR03MB6912.namprd03.prod.outlook.com (2603:10b6:8:47::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.28; Tue, 16 Aug 2022 12:52:58 +0000
Received: from BYAPR03MB3623.namprd03.prod.outlook.com
 ([fe80::b9c9:c866:817c:60dd]) by BYAPR03MB3623.namprd03.prod.outlook.com
 ([fe80::b9c9:c866:817c:60dd%4]) with mapi id 15.20.5504.027; Tue, 16 Aug 2022
 12:52:58 +0000
From:   Andrew Cooper <Andrew.Cooper3@citrix.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH] x86/nospec: Unwreck the RSB stuffing
Thread-Topic: [PATCH] x86/nospec: Unwreck the RSB stuffing
Thread-Index: AQHYsWvF7/t4XiFgOEaU/oN6P2AzRq2xe1+A
Date:   Tue, 16 Aug 2022 12:52:58 +0000
Message-ID: <82d09944-9118-e727-705d-da513eca0bf1@citrix.com>
References: <20220809175513.345597655@linuxfoundation.org>
 <20220809175513.979067723@linuxfoundation.org>
 <YvuNdDWoUZSBjYcm@worktop.programming.kicks-ass.net>
In-Reply-To: <YvuNdDWoUZSBjYcm@worktop.programming.kicks-ass.net>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=citrix.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9e15ded6-4928-42a4-9d6d-08da7f863ebf
x-ms-traffictypediagnostic: DM4PR03MB6912:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h7CxqBNtklgqovd718ztJseIQsgcjFvpl/9KqjEF+sjlZ/zakrmZPNhhdaKKW5tX7VmSafFasmF5b5mM3lt8PQwGVOdceRp2se6PDpaX22OpeN+SwjbUPv8KkHOZevAKY8qMs4TUbo10NevU9POTF1AOpXG97fQSWyohOdP4U1Bp2u45u7lcD0WkOJei+3x8nwPNxiaUzLClsUtE0g00ChOd/r9eSHDDq/kJzU9rj+lqqSRO4tj/2WX2l+J4IQe6N3hm5yDvz62wuMXk50M1ome7ryBy96R1glbFLY9Cu06Gy/iNzHS2vYzYJYfHOJcmppE7Qqo7ywTf2gajYohVeK24ZL971+AFhwvPEk6Gi6a5h+Af7XYrLn4LievbhpUOfpy5cLMt0Pg2IWvKo+A2h71TmNMjkXpqn1cXaYnvxGUXeJMWKjDVSEWaTBMeM5nisP7dvlfdivADgeYx7Weno8iuoXl2a97lScSM7ZUpH7RHyQdP5rKW3fvCvK57yVq0frGa1mWsmm75fLPeRrfQ9ODP4dV2L7D7tDATYrqOSRZQY/3jAAJ8ICBSM2hgiQ8x0Lu03rZbFxWFKB4k/unZS7xHPyM0muETK+UVTezhSyfSVPi/tpBUtKvDZzaKl9pvYGZhiNrVnyGa1R7PdZ+HLKrfSFOVXXOm2dNA6+y+MvN5ufkdADA4Phgx23riHUCFYRpi0F9zQJzM3YDZzhtJTMnGh/Z9hWnoAAA2I5STtfPL/Py0DrZpXBIVq2Mya7R4sglhctkayy0QQaVLJeVJblq3fwF1M3NZ1PaZPMMsh0mWYuI1/c1+6Ji5TzuF9r0K8zi70ExkFCipcGQdgiFdmMqVlaFgyv/jTP6GP5ivoageo9rIcgGRabx76d4EUxyc
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3623.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(136003)(376002)(366004)(346002)(82960400001)(38070700005)(86362001)(8676002)(31696002)(122000001)(4744005)(110136005)(4326008)(64756008)(38100700002)(66946007)(91956017)(66476007)(66446008)(54906003)(66556008)(316002)(76116006)(2906002)(8936002)(5660300002)(7416002)(6506007)(53546011)(26005)(6512007)(2616005)(71200400001)(186003)(41300700001)(478600001)(6486002)(31686004)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L3ZNaVN6VnRFTHZXSFFxZHVMbGVuY1BVbThCLzFrbGRwVXNjUnI4R3U0QWlw?=
 =?utf-8?B?OW0zZ2l0N2ptKzhVYzRsc2tkdTY0OFcwMCt4WHMzeUdWL0JvWEMyWHR4Y2Ey?=
 =?utf-8?B?OXhKMmdKM0xtNWcvZjY1WmcxbTVwNTRnUGRmZGpjM0pGdUNUVnFqMmpSejVH?=
 =?utf-8?B?TlJPN3FoaDh5MVRXTzB6NFQrQmFjSVhQVzBnRHBVWUdMVEVvbkpSeHVaSEhH?=
 =?utf-8?B?YTBJWW9ycFYvV25uVURGQndzZE9jK0puWU0rL0JGQXI1NSs1ODdUVXZpREVM?=
 =?utf-8?B?elVPKzNDY0krSVNSZ1BwMGFueTNiY1dqaVBMZXYwc1lST2pmM1Q3TXBsVjZN?=
 =?utf-8?B?MWtxWDRleGd4TG8vV1RlWUNsUGQyRFNLNThvWFU3QnhBYjBXR1Nab1NRRnpt?=
 =?utf-8?B?VysvLzN6Q2FOSjBsbkk0ejFSM0FHUFlLU1RoQWZsMlBlQzVEVW1HUFBSZjRt?=
 =?utf-8?B?OVdJbFkrTjBQaHBCLzllb0NiRGFoS1lRa3ZQTkhyaW0rV0ZIRVY5M25EUEZR?=
 =?utf-8?B?UkJMOFR6RGlidWFKK0VNNnFCQTNnMlE3MEgyKzdlamVlbDVDQURZYU04Y21k?=
 =?utf-8?B?MUd0LzkrZEwzQmdTdS9qTlZPMS8wQ1JhbFJYL3lyNDdXdnNEODJ6cW96RlhR?=
 =?utf-8?B?REFHT3VGQS9SVGsvZlR3aDVDK2dVRzZ6TktUZmJ4cEhsYkJmSldRWi9maUN5?=
 =?utf-8?B?bFRPRE1IUVBOdTFZR2JJU0NjUFhHTnZ3Y2V3RUp1ZHhHOHA3ckwwdWNncDAy?=
 =?utf-8?B?TGo1QllET0FFWHBVcVBFRzNERkVuNHRjdnFFaytWNTZGVTZpT09jRER4WEcv?=
 =?utf-8?B?SFRQUEJLOU1aZmpzM3JZdDNJWmtRV2w5WkFCODlxWkIxTk1JU3VROVdDV1pE?=
 =?utf-8?B?RGxtUThVY3JpRjlKaXJ2aUJtbFVYZmMxMmI2ZGJCVVVMQW8zNGMrUVJNZFhs?=
 =?utf-8?B?TExLZ29VZWhad0EyYlVqMGlJRC95SFFjU2hCOXZuKzBvTnUwTE4rdHN3RnBv?=
 =?utf-8?B?QXB0SnlZWUxNMENDNnQrQ2FEbFlFbHhRQzNpcTZUVXloUG9VeDVhVWthdVVw?=
 =?utf-8?B?QUFuclpXaTNkclVuNDB2R1hBbUg4U1pOVlhMeFlack9xdFpqelZhT3VIc29R?=
 =?utf-8?B?ak4weG8wTlhjL21NQ0JQaDlXNzIzR3FuMlJremdjL3BRbXRrQml5UTRjYUxn?=
 =?utf-8?B?MUVVcWhUS3JSaVNzZVFXeFNIdXBtbmljM09yNXFHQzBrQ2lOTHQ2SDc4LytC?=
 =?utf-8?B?Yi94eFVyZUhodGFPSmg0U0xxNWxybDExOVZpMEppNGJHYWcxUmN3enM1TGRO?=
 =?utf-8?B?MDJXR0hCZi9yeWpKeHNxRUlEdk5YRlZ5NXFhMUxYV3NlbExhcDBSZk5IYlNW?=
 =?utf-8?B?Zi9ZUjNoNThTN2xtc1IwTndFcFJqaS9MRmJ6d281UVkyc2FYbXZQcjEyeFRD?=
 =?utf-8?B?ZCt2eER4SS9DWXVuYnJtQ1QxVCswN0pHNlk5U0RnVFpPUWZERXZPNFNZaVVZ?=
 =?utf-8?B?TUlBRWJNNGhOWXM5djhjM1orWTRYdlFFN2YyYWtGQithaDhZZjQxOU9QSjUx?=
 =?utf-8?B?ZzRHdWFXYStwQmlSeUprbi9nbnhNU2xhYnFUdFU0dmlDTWdMaG11c2Q3UFgw?=
 =?utf-8?B?cVRSS0krejJLL3pCbFo5aUtiaTVxV1BpR1lqYThVSnhRQjhkRGxQK0d5aFhs?=
 =?utf-8?B?dzFNdlBBRlQreTVuNnU5a0g3V1g5RXBrYWdwUHVwWlRjR3YrRWR0UGpFZWtp?=
 =?utf-8?B?YTVSdElCK0NKZDE0Y0kvRzRQZGhxOTBxMm90Ync5YUlRTnI2WjNKeG5FaUwz?=
 =?utf-8?B?SkFrWEZKVUY1NE5YeVhQbmVyb0ZYb3FrWlh0ZGQzcjRTeUt3bTlyTWsyVUVk?=
 =?utf-8?B?ZE5lbCtnZ0R3UWVabFRlakVYeFpROU00TTNxWFBuOHQ2MW9SRjlOaGUrYVN3?=
 =?utf-8?B?RW5xSEcxWXgzb0hRVUhKbFNqQWhnTDlpUU8wWnI1V2l4cC96S3FnK24wS1Iw?=
 =?utf-8?B?SFdqNDgvQXd2V3R2VkRJZnNxNHFCL0tQaVVpYkIvNEh1SnRnQ0JpTlZFSzJz?=
 =?utf-8?B?TDF6MkI2K0FaejVScEFwSENNTWhsZVJycDRUSEtISzBjLzRuaEljZmo4SGtw?=
 =?utf-8?Q?NdILiliFJxBIucjAzBhzmWrRY?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <79AFE1B013117540AB4AE248F914A13F@namprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?WmRBUnRRajJ5MXJDZTFEbFRaVm4xMExTZVA3SEs2RnhXK2VkRUR2U3dUR0Iz?=
 =?utf-8?B?WE9MLzk0OWM2WGxpQ1Q2eXFQK1hPVGNkQ2hlTzdYSHNqczYvQ2lyYXpjRisv?=
 =?utf-8?B?TzFSYVUrNFp4dEJzeUQvVjJNM3VVVmc3KzIvVzNCdkJ3MjQxQ1RuZm9vWC9N?=
 =?utf-8?B?Qzc1dkt3TkFaSVhYbTk2bm1rQnZHdVhnMGpQdU1iN2F6cUIvT1FEQ3k1dHZ2?=
 =?utf-8?B?bjRZS3MvOFJBWFBvK0MvMitDcXMySm9DdHVVSk9HL3VWSHRBTzBhbjJKSk1q?=
 =?utf-8?B?U3JxbnBnYXdaNFJML1l0TGRWd2FKNjAwbmN6dkFsb2JyajBqQ1RId1djNjRS?=
 =?utf-8?B?KzZiZUZSTUlvVE9EbEZDcjFFL0U1Tjd2UEdrN2hzZTdLRDI0M0ViNG1NdFJj?=
 =?utf-8?B?QWVscEl0dUhVaUlGR3VIc2JvbXBKaXNRa1dkUnZtVU9SV2VqbUVteHM3S0VE?=
 =?utf-8?B?R3ZUMWFId0taaHFTZk5NRkg5akhPWDRhTWN4OStkY1RPdzdNWkJPVE10Y3dy?=
 =?utf-8?B?czhxb0tmQ1BhRU1iZFp2QUQ1UTJwNit2QXJLeXlEVDdpRUlhdjVUSXdweXFm?=
 =?utf-8?B?V0ZEV2x1SU9OT0lYNVJhM1BDUzdlaVg5cHRrUW9LNWtWdG1SUTlmREQzLzhx?=
 =?utf-8?B?MmtNM0hTTkxPSG9Lc01EZjgrOS8zY29NaVp6RUJPZ3NPR21kN0lyVWZGOERa?=
 =?utf-8?B?S2dtakR3YUk4a1hTMlIrOG1hd042MkphcHJ2OTZvTTcyT3hNVTZMbnpzajJ1?=
 =?utf-8?B?aDBCQ0JVOWNlTS9wbW5ieEdrdUM4Tm8vZDlsZXhybllCSWRxMEZYbGhzdlh1?=
 =?utf-8?B?VDErRHRpd0NROXdaVnYzQ2d6VnQxUFQrL0NyM3RqTmpURG9MVU5kTU5MNlAx?=
 =?utf-8?B?QTdHYVRQZlBSSDhOaWFYdDRQRlUyQW8xK3RuV2Z1T0kxUXBhMGhkWmVEV29y?=
 =?utf-8?B?emZMTXZQK0FpVFc3VWtCNXBXTm1wRUYxdFkyc1h0OVNFVFl6Mk8xa2U0aGhL?=
 =?utf-8?B?YWFON1FoM1d6bjhDRVZuTlBuM0tuNnhNQWhjSGJvbzVIRklmSFZKbHllZ2U2?=
 =?utf-8?B?RXZlYmZzdEtrS2UyZHpQVys4bDRjN3MxQ2JwdzdSMXBhdlo3SWRCWWlZUDdG?=
 =?utf-8?B?OStHa1RqaGo3MEt3aTNLVkUweC9wcEVKdXR5MWZqMlpaM1NiZU0wVTQ2VGFs?=
 =?utf-8?B?Z0kvQnVtZkRjbWxLaG11QXkzM1JzdnZEaC9MU3phRXNZUU0zbStVQ00xQzdn?=
 =?utf-8?B?ZnlXTXV1MTZlU2RFb0NxL3NOdDdNWlpZNWpSSVdxTFNRNndPWG5PazZHN0dD?=
 =?utf-8?B?dThxdkFiZ0RYaDMySmt5bUJKZ0IxV2pLcWlrUWMrNVB4WHI4Zzd6amlUMFgx?=
 =?utf-8?B?ZURCcFprVjR3YnRxUTRRT3p3amFBZzJNVUxrRVR2aHhsSjlobnpPT0VYQVZz?=
 =?utf-8?B?ODArd2o1dXpFaUh6UTRzbUlibmM0Nmp1aWZvU09Qb2pHaDZCOXpaa3NaU1Bn?=
 =?utf-8?B?Nm1UMWNuUFJEa1NoZGhlcXNRbXY5RnVHcUtFVUdQcDd4TmJESDZwN2ZVRHNP?=
 =?utf-8?B?am5BYnNYUWQrTUtUTU5qYjZUVEl5b3lmL1Fjbnhib084TWo5Ym9UNkJYN3RV?=
 =?utf-8?B?UE9TbmhzcFVJZzQzT0ZaUlAvekE4eHdjMU5XOHNiQm50eDlwbkdlM3VWVENj?=
 =?utf-8?Q?HHyuKv7V3LsUWuJGFYGw?=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB3623.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e15ded6-4928-42a4-9d6d-08da7f863ebf
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2022 12:52:58.0811
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /LFSftpaLJoL23zFwvGnlMI0QFk6d8YJ1fYwjKUN2I8B5leqLOkrQ94c91kSIXB/gLF2lb+3juHmjXJZuJZTVFBlGRwHFaMaMTu7LvVVW94=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR03MB6912
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMTYvMDgvMjAyMiAxMzoyOCwgUGV0ZXIgWmlqbHN0cmEgd3JvdGU6DQo+IGRpZmYgLS1naXQg
YS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9ub3NwZWMtYnJhbmNoLmggYi9hcmNoL3g4Ni9pbmNsdWRl
L2FzbS9ub3NwZWMtYnJhbmNoLmgNCj4gaW5kZXggZTY0ZmQyMDc3OGI2Li4zMzZmOGU4Y2ViZjgg
MTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL25vc3BlYy1icmFuY2guaA0KPiAr
KysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9ub3NwZWMtYnJhbmNoLmgNCj4gQEAgLTM1LDMzICsz
NSw0NCBAQA0KPiAgI2RlZmluZSBSU0JfQ0xFQVJfTE9PUFMJCTMyCS8qIFRvIGZvcmNpYmx5IG92
ZXJ3cml0ZSBhbGwgZW50cmllcyAqLw0KPiAgDQo+ICAvKg0KPiArICogQ29tbW9uIGhlbHBlciBm
b3IgX19GSUxMX1JFVFVSTl9CVUZGRVIgYW5kIF9fRklMTF9PTkVfUkVUVVJOLg0KPiArICovDQo+
ICsjZGVmaW5lIF9fRklMTF9SRVRVUk5fU0xPVAkJCVwNCj4gKwlBTk5PVEFURV9JTlRSQV9GVU5D
VElPTl9DQUxMOwkJXA0KPiArCWNhbGwJNzcyZjsJCQkJXA0KPiArCWludDM7CQkJCQlcDQo+ICs3
NzI6DQo+ICsNCj4gKy8qDQo+ICsgKiBTdHVmZiB0aGUgZW50aXJlIFJTQi4NCg0KT25lIG1pbm9y
IHBvaW50LsKgIFN0dWZmIDMyIHNsb3RzLg0KDQpUaGVyZSBhcmUgSW50ZWwgcGFydHMgb3V0IGlu
IHRoZSB3b3JsZCB3aXRoIFJTQnMgbGFyZ2VyIHRoYW4gMzIgZW50cmllcywNCmFuZCB0aGlzIGxv
b3AgZG9lcyBub3QgZmlsbCB0aGUgZW50aXJlIFJTQiBvbiB0aG9zZS4NCg0KVGhpcyBpcyB3aHkg
dGhlIDMyLWVudHJ5IHN0dWZmaW5nIGxvb3AgaXMgZXhwbGljaXRseSBub3Qgc3VwcG9ydGVkIG9u
DQplSUJSUyBoYXJkd2FyZSBhcyBhIGdlbmVyYWwgbWVjaGFuaXNtLg0KDQp+QW5kcmV3DQo=
