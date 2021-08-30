Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5F13FB320
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 11:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235583AbhH3Jbn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 05:31:43 -0400
Received: from esa1.fujitsucc.c3s2.iphmx.com ([68.232.152.245]:60763 "EHLO
        esa1.fujitsucc.c3s2.iphmx.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235073AbhH3Jbm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Aug 2021 05:31:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1630315850; x=1661851850;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=HuNYY1KzzC+a5V1jYVD3pBpRXY8IKOIaxS8SyKzYI4Y=;
  b=hE6ftFl+zAz+aBExvIlKu+YkhHZzBTO6lh3MmnOOV7vxTAo7Frj0Zls4
   hWOcFTuaGVmk/I3bLEcpvYRD+PAcl7AVttJwaps9a/xeGqN8Myiqwy89M
   arG0GbPa/TOVmJEpTEUc7RWL68zBTqedAak5tSiF+PDNilk25wVvDAfic
   5+uYYsrmLLJcCJGRVwKlPRU+sN42rWEgsz7zJOlDxRfAkmPfDVUiXA/UE
   rgjXoqpvL0JeCbWmo4YVWA0iG8u5C0pW/Tz8ysmly5SPEwkMUKuprH+Z6
   YrhutxP9nlEWxG9+qj0oz+Pe+dyGVfY/til5H4xPQCuOCZXQeUGooaLJq
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10091"; a="46189407"
X-IronPort-AV: E=Sophos;i="5.84,363,1620658800"; 
   d="scan'208";a="46189407"
Received: from mail-os2jpn01lp2057.outbound.protection.outlook.com (HELO JPN01-OS2-obe.outbound.protection.outlook.com) ([104.47.92.57])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2021 18:30:46 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DGYJ8Zf96FAJSxl/MqMI7KZ+J5Td6WzxPhMMQ8M2vrJ92PSZpSMYJwPtOtTA6gEaN2oqYs1qfYujAn6kGIYXUXVsyToLXmO5z7ZJuCkc/NYHY9McAjVMnqsuEx//L2IIgy4dtlZuhd/5LP0ec7+JTr/vQyC3asTvYO232m7t5U8fk4XK4Mx7+eP2yC8DrJ8ApNa4yRl0N0zy0aQU0mhT4kIEzLNxXKqgYCa0ALwIq8OJp+4zQ0URlbRQL3xDBis5NLodI+/3FyrlL3u/GdFDI6caCAd16EAHb00u7P/sHlj51rI6RcM6z7eyaBA6t1lIsF9bgm+XQUgIPfhv5zK3hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HuNYY1KzzC+a5V1jYVD3pBpRXY8IKOIaxS8SyKzYI4Y=;
 b=P1wtLjTX/o5z+qZg1RN4V7t5yV1GCgmfpDn3TPOIef6iBBIKSCMUmrXMWeyYE0QJYVowDVh90gw0eGYEqpu4FbfqGHpmDVDYXUVrOSrqMv+v6wRisH8G+yMcHPzyGakzPfklhuzh3X/TCXohEA/F4FoBhXX6kImqSYag1x1vxzf8wPAbgmy8IYlQFBCrDvXtcjuhijDUEUGzOlka1x0Tbjiv886U3QyB2Z7G7A1f1Jwmu8MifZyb0/Q74M+/UfIbaVuyZgLawvxQCo6QB4g7JMm4dprWrjskvJ68VEn5/NDOBbiJJfIPYwtR5F/onUlYzEExS/rfB3mqBf7b/srTiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HuNYY1KzzC+a5V1jYVD3pBpRXY8IKOIaxS8SyKzYI4Y=;
 b=j7k5nCfzJtj6R84S5uvAALuwh9e+tPVFBlaVaF2c3CynNezUpym5NaBsNQqgF3rS4g11z22vmoRfM7XDQpDDrySaO/kokKyM5AZ/H50rR6TpseewfeI8K+QOW4MnQ2fzvORguB0+JwMyaAGBdkO5iVIcKCNdzRfIVo63EhXYNyg=
Received: from OS3PR01MB7650.jpnprd01.prod.outlook.com (2603:1096:604:14f::5)
 by OS3PR01MB7732.jpnprd01.prod.outlook.com (2603:1096:604:179::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.19; Mon, 30 Aug
 2021 09:30:42 +0000
Received: from OS3PR01MB7650.jpnprd01.prod.outlook.com
 ([fe80::7407:c85b:2ea4:2ba9]) by OS3PR01MB7650.jpnprd01.prod.outlook.com
 ([fe80::7407:c85b:2ea4:2ba9%5]) with mapi id 15.20.4457.024; Mon, 30 Aug 2021
 09:30:42 +0000
From:   "lizhijian@fujitsu.com" <lizhijian@fujitsu.com>
To:     Christoph Hellwig <hch@infradead.org>,
        "lizhijian@fujitsu.com" <lizhijian@fujitsu.com>
CC:     "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "jglisse@redhat.com" <jglisse@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2] mm/hmm: bypass devmap pte when all pfn requested flags
 are fulfilled
Thread-Topic: [PATCH v2] mm/hmm: bypass devmap pte when all pfn requested
 flags are fulfilled
Thread-Index: AQHXm6gDsEE540LMXUaYx7tJ64dd9auLqvOAgAAgjQA=
Date:   Mon, 30 Aug 2021 09:30:42 +0000
Message-ID: <2d30c629-5169-1405-4f3e-03d630a99678@fujitsu.com>
References: <20210828010441.3702-1-lizhijian@cn.fujitsu.com>
 <YSyJdUirSGv01nTy@infradead.org>
In-Reply-To: <YSyJdUirSGv01nTy@infradead.org>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6749c6ad-3bac-4f34-de28-08d96b98d664
x-ms-traffictypediagnostic: OS3PR01MB7732:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OS3PR01MB7732A6D1FBC89B62C22899AFA5CB9@OS3PR01MB7732.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OaG4YSLRjLhR2G2eJSUN/HO2HBmrZP8PdWZbX88QYRw4Mw4Qq7gKp9909goHP124U+JKIMB7FgB9aZoww6G2R8c2uAqMx2CoyyYXnlpFQgidXmAQHzm9s5fw95EHhacZua9aT5oVd5qYALwZ2KqS1u3MJ92jHBAvZSu1vLIox700e71JjSGVpQ2rRZyli4jXwhrTktnOYJuAm7lLd+O4W9Jwun+ubyVqcZgfhZsmVYP7wvbV4A4raHmsaPGfV3aPbAR0bZPIneSZCtoKl7n4MkDwUJibzk5wzrudWQFufBBChVwgCt6ivkm5E5LZEIgEP7HAHe6lB4rvivJ/cxzDDj9UAiPJbMXD9E3QVPfCPCQxn69FtHYBqxt+OR/2aFKrvq0sSfpzwGEMarB8Tzo1BEx3bPtTJ2CWlsneVRBvsNMa81QZz3Z8OWYFOpAloMRr8IN3wPRTqZBRoz0g4LieMcEJcNY1OJUOXLNgPRewWG1iZacxlpbi1OtFHPQrRz2vUxZ+W8Z56Sm1PlduA7Udw8atlh+iYq6E+Rnh7aKFhaN7TDm/qkvzCvZn/lktuDvTPKvBdSjYWb/W3jnW2IEnvB/Qpt2EJfRwrcCS31ucNk9XY9TRWH+ZSAEIMG16bQLMichKiaJYswZ50iMfLMtXe7pkFHqUlVYrgTObaETGVxp+fWXMUqjk4PwwUhRi9Vo7Wvb8wFpx7nw6DSa8qb1olTiZqAsHyA0WoDoHWMnaNTdUCclnHwTLgcGuzSY8MDAeo/A4M5RQ/0vLqmQawFsj/w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB7650.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(376002)(136003)(39860400002)(5660300002)(186003)(38070700005)(122000001)(6512007)(71200400001)(36756003)(31686004)(86362001)(478600001)(2616005)(83380400001)(31696002)(8676002)(85182001)(2906002)(4744005)(66556008)(66446008)(6486002)(64756008)(66946007)(66476007)(91956017)(76116006)(54906003)(26005)(38100700002)(6506007)(53546011)(4326008)(8936002)(316002)(110136005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dW81Tk1uRi9aT3VHSU5MVkl2VXBMSThVdjNoRUQ0bWVnUVFERDBzdFRzdXM5?=
 =?utf-8?B?d01jY3Jib1lzTXkvVTVpaE9LdDhkTmFoVi9NUkgvVENBblpiaWNuVUIrNk5S?=
 =?utf-8?B?Mi9BRkZvSTl3QkdkUmZycG14OVVwWHNvZVNWU1oycE5saDYvMTI2d3hpTGl0?=
 =?utf-8?B?dXpocGFMYnpuZGZBb3IvMzF6Q2RmMUZvUFFBY2Zxa2NzalI3S01LM2cxbkJ6?=
 =?utf-8?B?MVplQU0vYzFBMmdDVzV5aEJ1d2ZuTHBpU1B4dTRVOHFxeG9zUVFlT00wK2xa?=
 =?utf-8?B?MXhrMTUxUlVOdzkza01JdTl2MExVT1VQU21JemFtV293TjJjWlFrTzNLdEtO?=
 =?utf-8?B?eitaVWp3RE1LT2JRTDBxVVlnWHZHRUdmR0NMZVI3eWhzUng0SDRKeEFsclg5?=
 =?utf-8?B?ejhCRDhjZ3JjMVlNT3dEZGNUWkN0cmdsU1RuUzQvNW5lWUdmVEJMOThOSHBG?=
 =?utf-8?B?SC9GVWRlRDd4WHpkQmRjc0NubkxreVljSHcrTUZ5L1hGVEVmbk9IV1hFdExE?=
 =?utf-8?B?ZS9HQzNlOU96RmNzakRtL1YxdXR4L255bFk5aTdjVFpWQnEvK0ZRTm9JamNW?=
 =?utf-8?B?UGNORzBGUVh5OGlqUDg2ZW9WU2xaTGVFU3pXQlAwQjFuNzY0a1FSM0ZkanZC?=
 =?utf-8?B?eUZyeThsbjBzYjJNMmRpNDdlbjZ0ekQvem5XWllqWitMQVNIQ3VtL08vOVFX?=
 =?utf-8?B?MXVCcDFReVJ6VmUrelJnVGpLMnhLMGhRV2oxdnRVTXl3bVl6ODl0V1lOR2Za?=
 =?utf-8?B?TDMybGxELzE3UGtteERqak42WlhaUlUyTTA3VG1qTWJvd1QvRk9ZYnNYb0dr?=
 =?utf-8?B?dFpXQ2RiZ0NySmpoZjcxU3IxMVRGckZwWlFSdmlBdDUzdHdBTHhidi81c2Vl?=
 =?utf-8?B?RDBJVnhIc0RYNnhMQUNrRzUrdFZZQkJkYmhXUUdjbGxSa3VWN0dZUk9rMzRV?=
 =?utf-8?B?QW1MaUF4ajFXTW5mTW5xNWliYnE4RFIzL1dUSGFRRzBuS1ZkT0ZvZzc3NDQv?=
 =?utf-8?B?SXNrSFE1Syswa1VSMmVkekNxYU1PbVFDODhDRTl1OXlvR1duajNBcUlVeGl5?=
 =?utf-8?B?N0xwL2I3YTI1dkZBOU5IeE1Fc2c3UU1CWG1WejJvNW8xeDAyeDd3YnZ4UUFY?=
 =?utf-8?B?RFRCMVg5cG5YOC81dzU2bHlBdFJxMUJNSXF5akdCN1VKOXR2WnE3K2FGcTla?=
 =?utf-8?B?M3I0M293cFJIbldzVk5xSnFzM0FCcTdTaHZHeFRuNlp3QUlBdktwbzRpNW80?=
 =?utf-8?B?a1ZkVk9VUVhLYUFuYitNWi9sRDRrRVZSNzlRdmk4cmk1V20xVEVpd1Bic1hP?=
 =?utf-8?B?Vmg4WXc5ZGlOb0pDc1RMMHNqZzVSTVdtOHEyeUl1RmxlejQ1UVNQUDI4Wk4r?=
 =?utf-8?B?a2dUdGdudnBsbHlpc0tkZ0FrNHBoZWYrRzBaLzlyZUkyUW9aank2VWJsNjJl?=
 =?utf-8?B?Tkl3RnNFb3R5azRycHFJb2Ezb0N0K2pqazRzUXVXSVRHMHNTOTh6R1orditu?=
 =?utf-8?B?bEM2N1BlME9xUGd6QVJWbjltZjl1SE11Z0hJRkNrUTR4c3lWT0o1VDlRbkRK?=
 =?utf-8?B?ZU13aHYrdXNCVTBBVVFGWE1ONVNLQWRRbzFkWGNUTjBNWmhmOTErbVRKemVp?=
 =?utf-8?B?MjN2ZnB5RVl6VHVhWG9BbU9mQ1BhWWpKNG5KbTU4YWdIUUpqTFk4dXBZVmJx?=
 =?utf-8?B?V05QaW1uUFB2cDNOZWtRcWhZUEc1dWRNRFdjRm9Oa2VjajdjQy9MNUxNN3ll?=
 =?utf-8?B?aS9YSGd0MGlNRnlZbW1wMWVCeFUybUZhamloT2NaRStsMGZtc0E1MTFIVmNS?=
 =?utf-8?B?Wk03NnpBYXFCNnZadHdpQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8DE2A6C44072E744BD3E3B8F6FACA496@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB7650.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6749c6ad-3bac-4f34-de28-08d96b98d664
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2021 09:30:42.4875
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qBMTQ03aXtNMdBXkLfulYosbDT5BQW21o4VgJMFcDxaKXKeaQuJ/xMIzAD3TKIyUphKSvRrNE/+QpTpCwxFXDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB7732
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCk9uIDMwLzA4LzIwMjEgMTU6MzIsIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOg0KPiBPbiBT
YXQsIEF1ZyAyOCwgMjAyMSBhdCAwOTowNDo0MUFNICswODAwLCBMaSBaaGlqaWFuIHdyb3RlOg0K
Pj4gKwlpZiAoIXB0ZV9kZXZtYXAocHRlKSAmJiBwdGVfc3BlY2lhbChwdGUpICYmDQo+PiArCSAg
ICAhaXNfemVyb19wZm4ocHRlX3BmbihwdGUpKSkgew0KPiBNYXliZSB0aGlzIGlzIGEgbGl0dGxl
IHRvbyBzdXBlcmZpY2lhbCBhbmQgbml0cGlja3ksIGJ1dCBJIGZpbmQgdGhlDQo+IG9yZGVyaW5n
IG9mIHRoZSBjaGVja3MgYSBsaXR0bGUgc3RyYW5nZS4gIFdoeSBub3QgZG8gdGhlIHB0ZV9zcGVj
aWFsDQo+IGZpcnN0IGFuZCB0aGVuIHRoZSBleGx1c2lvbnMgZnJvbSBpdCBsYXRlcj8NCj4NCkl0
IHNvdW5kcyBnb29kIHRvIG1lLCBsZXQncyB1cGRhdGUgaXQNCg0KVGhhbmtzDQpaaGlqaWFuDQoN
Cg==
