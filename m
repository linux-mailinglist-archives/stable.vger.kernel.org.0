Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 466ED6C89F9
	for <lists+stable@lfdr.de>; Sat, 25 Mar 2023 02:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbjCYBWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Mar 2023 21:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbjCYBWK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Mar 2023 21:22:10 -0400
Received: from AUS01-ME3-obe.outbound.protection.outlook.com (mail-me3aus01olkn2172.outbound.protection.outlook.com [40.92.63.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7601F1204D
        for <stable@vger.kernel.org>; Fri, 24 Mar 2023 18:22:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cYz3rTyBLbVPT0F4JJKTUilG5rpek8kmHlAqsqkWsRUsESoSaMvsW4KsnXL+OmbQkOIeRLrxiDP053HeQtteqK7KOMNtaAJ4xMYPnSRazl9QOEAESSC9PTbpOVeRh7G5OoB61PaT7UCVcFebOdUu/cza7r7aRXGDC/Y+IvFf36sFUpjRRzPRtAZ3XjcdA5rdh0XkwI+HW4tds3eUPoBe84DAEz4ziNTBXb/7vYWEN51sbfK1ydlQhsPXfqEPPu1Ru6Pn/62AhplJqaR0dLO4xFZGcCKG9Vi5LiWcoGn2JarSKbhFTsDunABVhmaB7z1eBL/f8nyAPKlosSjfwN4FYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UeK75VGjlsko4BzJY/hr0CRzjXMLHQJojZKrS032cUY=;
 b=USSah1DqWaM7eqMB+Q8UKcLRS/fdEhngkeB5H2cVGKV+Wsci0P1A2ztMMloneTslLSiqRblm0NdvIa4IsLXCiiZwWvr82ysbbmv1yBE7TWd/5Plpc2QnqLyN6xhSEaV8VWQhTJ3MGYhStq+bSn1ZzLBzf9t6WbO5TBXdLI7ys0ny4lY8tceiO0RiT6p030PMBOs12g+vj/aPrAm4sLRrX7/8MG834MI8nbQMu8caGAJ5shmVEKr3FuK0uYguXFv36B/1h1QTX2v8jVlZ5ZD6tI4y9uIFQBb0wyOvhcXyiA3SWVIVH6DPZfLVVQ2Y5cR5COtHqiFtXLPJWHsmyKW6zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UeK75VGjlsko4BzJY/hr0CRzjXMLHQJojZKrS032cUY=;
 b=k9hDU0qtcC7rEHVGBFgqGEjsppD8gq3UUYyOLHBzpAg7vE+3OgNn7EOVU4edlOVuU6RF1OHymtOjv/wLqi5Bdxi93cEO5H0urEwpjqmLv66M+mk0LaW+gq+osC6rbAe4BNkzvxJ8ke74SvkzjdsZS/7d+aNeu1fhMtSseMboz05IkcO3kAR02IpoUGT5lpT45yYVdJU6ifYjdkBsqOHEn8/tr9kFwa46YdNvCT4VzBQVVsgSWFAFPNh+C53NcxhKV8kfGFFqNzO+X0rd9M9jik1WeIxoeSZf6dnA5KiH3HXJU+a+rFHwr6sM0k48n9Xgm2xjOf3AFV7BIQLDuiDCgA==
Received: from ME3P282MB2515.AUSP282.PROD.OUTLOOK.COM (2603:10c6:220:10a::8)
 by SY6P282MB3133.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:164::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.8; Sat, 25 Mar
 2023 01:21:44 +0000
Received: from ME3P282MB2515.AUSP282.PROD.OUTLOOK.COM
 ([fe80::9873:522c:cec6:3608]) by ME3P282MB2515.AUSP282.PROD.OUTLOOK.COM
 ([fe80::9873:522c:cec6:3608%6]) with mapi id 15.20.6222.008; Sat, 25 Mar 2023
 01:21:44 +0000
From:   shang kun <topmanufacturer88@hotmail.com>
Subject: Adapter Ltd
Thread-Topic: Adapter Ltd
Thread-Index: AQHZXfh4GOCjevy3LE27HHTvEGyEWw==
Date:   Sat, 25 Mar 2023 01:21:44 +0000
Message-ID: <4d1fff06b91243b5a5ba03fc8ed34914ME3P282MB2515E8B27F2FA6D701D74857B3849@ME3P282MB2515.AUSP282.PROD.OUTLOOK.COM>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [gaqMz7r3ynMhGlTvmaOOgCTtUjdpp92m]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: ME3P282MB2515:EE_|SY6P282MB3133:EE_
x-ms-office365-filtering-correlation-id: 63f33b59-b7f0-475b-db41-08db2ccf4b99
x-ms-exchange-slblob-mailprops: q6Zzr5Fg03GO2M3QR8yWeieC5CaT+nMZGnu339QigWxAa95gLIAgk/biwRdA1iBHtCpMqmYuavEO1a7Lnh86OMVh7gm4B1rxjrbSTC/pZFNnMDiWhx8cFlIQ9j/B5295XHW/Rzju1wYjD5m/HNJC4450FVMbqe6pUTvq6RD6irpQs/u3CtBFhORTHtLu7TlaVun//G803EMakz+VWw6/2JDgPA5P0ktBE2ICmiGfWnaAaO2adUOu2KBnj1wyPfDEb9n5Hr33zchX6bDi58aHv5f+DgjWEzkCTvzwdlfd8/dhbmF4enTzr7QTqbjC/6+ITFqOiAO6SvewxYi2B9iPyiJ+7A43UNnjZVnHJbFLC2IjxqF+A184KhU56q81rheylgdgjCtrJnDvGLYDcplJVb/sTS5T9YSXSTra2/XNQ3gAGG4LLFm0jS9+pin+HRcUXaZtSfCqTRGLZpkhKu7dVsunr6jD6DuLcPiYYrxKuf+H3yT5BeC5q7hk8EMOkIecfafvrdvhqJvIerFLRISyvymxHtL1GT3PFDQIrA5Nz+dGrrc9AhuMW1uFuWpwftGUGd3HiEVGf0HdhOwWjsp3yUyC2YmOgJca0QKsmuIOKslYUKfYAt3RGlAg+H/brBe8ZER5IM17MtXNPNbAX0feYvh4ATyLJEW/LFMk9O8rFOjPzYuPTdOzLWEt/ceMix1o
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Mo6C0gEo0nP8r3YOjkOK8R32D45ezD5MHdxkN/ID+qIUrHdOBtpToZcbYFYj9umdTJt0LEensBqINQjjhZ+ELDG8PxFjuJUqGLfwdgaHr0ZQ+YlqAWZs3/Z0gMQbzcl2vN9xEeWXcY7Tdt93Tm4AkSVvrT7O9FOvIoLpQ+u/mXHQ+qu9BBKjoi8Qc3G2yHE+mt7xNsNbYnjGGI8uaYG5TrR/x2Y8k/yQLMaqFFW5G3UxzalDKFC+P4DKomhiOfnzuGCzjcZ2UOe6k+zR2nSO4oARdHMEvjUI15K2KoJ1opcfM0HQvgGLwPNxrH5WEhySgiFuULyn8iQwu2DPZX0NTuCqXnvFXGjKvcJhzB332fKRNoeQo3xJGEx4IwTZDY1kK344qcrJ8+WqtaF01WXo9t68RmTXHcw1z+przjH39U2OBNlTPmVEs4lM4QbDiH5yJwssn1FIZ+q0tmxB9MTgZi7qa9K8kYNVn5VQ8AGHE/diCH5gmF3LN90cw6JZd/S6oUtK49yC78HQ9CpTtN8NnstxQTq7bNC1n6ByYkTDszUl77tunaDV95SCZQrrhlz5fNc7+XiqO+2s2RrLQCnsbm03KxLGG9oQ0WdVUTX6f3U=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?Mllpd01CSDhTQlBlR0NQTW5aRGVHOCtrRnRpODhpVDhLTGFEYTdmSjBmWklo?=
 =?gb2312?B?WmZBeU5kZVd4cDRtMkJvTTl0bHhGY1VVbnVTbm1ReWE2WHR5aExBUlpBdkZz?=
 =?gb2312?B?bUVGVUZYNXA1dUtMbUxyR1VxeWIzUVRmZklVa0FQdE04WFJXR0hNWEp6em5Y?=
 =?gb2312?B?Rm9nMmRxd091MmNaQnU3anM1UkVhS2hwanNFZ3JHeS9NeFN1TmM5bFMzVVBn?=
 =?gb2312?B?N1UyZ0J6bDhWSHBDQUpBa0orckQ5M3ZVK01rb21QdlJpbHRhWHBhclNucHFk?=
 =?gb2312?B?YTc4aTRXWnA5dkowTE9FaG1TVkYwM0pZaWVsZXpRcjVhdE9xWU5QUUlIZXFH?=
 =?gb2312?B?c1BRNzNNc1pHV0F5YXlYai8yZ21iMS9DL0pPMWZuWjRFM1J4UnBET2x6ZUtv?=
 =?gb2312?B?b2kzVmh1U040NU1ySnNMeHpTSjNWakc0QlNLK21SdW8ySkxuT1kzejhvdlkz?=
 =?gb2312?B?MTRFaU10Mk9iNHZOTEZ0a3ZvK3oxcEN4TkVUR2V3T241eVpiZWR3WDlacXBK?=
 =?gb2312?B?T29TWjBsZHF1TVU5Ym01ZW9BWGx5bi9kaHVXTkZRNjZtVEpGdDkvaU1yb1Qw?=
 =?gb2312?B?TWE3M1NzN1dOQXpZMTZaOWZFRDIyWE9Ed1NYNFpiWmZQV0NnRTRYOGMvbGZK?=
 =?gb2312?B?RmVpNjUrSCtBMyszeXc4cXI3TWRmR29rMHlzakhrMENxQmVTZnJqNzhGNXRD?=
 =?gb2312?B?aEltV05GRmtiSmhPRFRtSlFyd1dLWE8yQms2U1p6bnJIdXo0ZDg4OHBRcG40?=
 =?gb2312?B?amtSNHovcjdXeGR1NFVMYll4NmFYeUxWd256eDhoUmt0cDJGMnVGbzNidkVP?=
 =?gb2312?B?b04xU1J4SXN4UUhkK2pmemZrRk4vRFBuOUxKVEZlYkIwR1NDU3NXZlZ6dE9y?=
 =?gb2312?B?Zld4VHhDRmZXaTJxRW1vMmdSVGxzUloySmF0ejRzRHdBM0RGY3RHdk5tMFNq?=
 =?gb2312?B?d1NrbUp5b3VNWHBqWnRUejRYbTBRNitzcFk0cGJtcG9Fa1IzbHpBWGEwZTJS?=
 =?gb2312?B?RkQ5Sy9yVkJiSCtsMWN3bDNCS0tiQU8rSm8zYWNMMkl1TUtFbEd5MEdjNEs4?=
 =?gb2312?B?TVNqbTNsN0RHdUN3SkxLeENzU1BCVjM4WUkrdjJLTDhmMitmZ3psZnFRM0ow?=
 =?gb2312?B?SklPZlA5YS9tbTVMNCtkU3RWQ1hBYlp5NFoyakhIVzZtK2k4cVR0amJCb21O?=
 =?gb2312?B?UDZJcGEzM3dMSjNYZnE5VS9td21kYXVCYzFQSDdJUTcxUURJZDVxSFdEQjFN?=
 =?gb2312?B?YmFsM0tnUlJsQ2dJOWY5ckttUnJpWFdLWTJlcWhlRmFkUG0zTDluT0pjcURk?=
 =?gb2312?B?c3pibkVRMzQrbVFSMGJQZ3ViMldXOVhwS0NmRmNqSWtRWGh0Y01yalNVek5Z?=
 =?gb2312?B?RzlnUmM0MW5LKytycGljV2QwZkY4SzRTRUZSd2t2VjdQZDlTazhaMk91bFNJ?=
 =?gb2312?B?Y0RSTHJBdDBtYWE3c2NLV005WmRNNVZBY2syU3Q1OEV6QXBGRmVYRUdJbnJu?=
 =?gb2312?B?a2d4QWFJVFNHY05MOFdIdlBhbEpOSGRBenIvQ0pocG9ZQ3hDQUx1K3FPVTAr?=
 =?gb2312?B?QUoxSFFoL0k0ckNyTG12Vm1oR3RLUU80ajlkWnF4OHhZSWhTSlR6STdjVG1s?=
 =?gb2312?B?SU4zYjF4aWZaOEU1SXlhNG1KNFp4L2k3ZVhaV3VyaFE1dm9aUENFeEZtbVdI?=
 =?gb2312?B?Z2dCQncwYnhlNmpieSswZS9UbWZ6UXdVU0FjS1pIV0kvT2R5ajVuNWtRPT0=?=
Content-Type: text/plain; charset="gb2312"
Content-ID: <9FC8A28727E9F341858CEDCFB08E2CE4@AUSP282.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-746f3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: ME3P282MB2515.AUSP282.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 63f33b59-b7f0-475b-db41-08db2ccf4b99
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2023 01:21:44.1251
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SY6P282MB3133
X-Spam-Status: No, score=1.3 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        MISSING_HEADERS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgVGhlcmUsCkdyZWV0aW5nLiBIb3BlIHRoaXMgZW1haWwgZmluZCB5b3UgYXJlIHdlbGwuCldl
IGFyZSBvbmUgb2YgdGhlIGJpZ2dlc3Qgb25lcyBpbiBzb3V0aCBvZiBDaGluYSBtYW51ZmFjdHVy
ZXIgc3BlY2lhbGl6ZWQgaW4gQWRhcHRlciBwcm9kdWN0cyBzaW5jZSAyMDAxLgoKTm93IEknbSB3
cml0aW5nIGZvciBrZWVwaW5nIGluIHRvdWNoIHdpdGggeW91IGZvciBmdXJ0aGVyIGJ1c2luZXNz
LgoKQXMgb3VyIGZhY3RvcnkgaXMgbWFudWZhY3R1cmVyLCB3ZSBjYW4gQ3VzdG9taXplcywgT0VN
ICYgT0RNICBhbHNvIGFjY2VwdGFibGUuCgpJZiB5b3UgbmVlZCB0aGUgY2F0YWxvZ3VlLCBwbGVh
c2UgZmVlbCBmcmVlIHRvIGNvbnRhY3QgbWUuCkFuZHk=
