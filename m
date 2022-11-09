Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9A5E62237D
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 06:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbiKIFm0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 00:42:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiKIFmZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 00:42:25 -0500
X-Greylist: delayed 64 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Nov 2022 21:42:23 PST
Received: from esa16.fujitsucc.c3s2.iphmx.com (esa16.fujitsucc.c3s2.iphmx.com [216.71.158.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B84351B1C6;
        Tue,  8 Nov 2022 21:42:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1667972545; x=1699508545;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=R2Xg/OuK9mjGgFIwMSPVW9YOVVsNrMZCrMbduinE0uY=;
  b=JytGyUyrlPH8o2ZkxWY3uiLk9g2vYuCdfhC4dOfsdZREci7YRiyHwtC7
   HSn98V33hFho2D0MGNH3eFo5Q9o8Ne8L6bKaeU4UjyuIY0tUvTLgH4k9Q
   i7ZSlw/AhVR/ibCK6ol+5gXt1I0k4eV7mfJUBQSWGoZ0DG/34nibJHVUp
   1JrP3HX7vRIQ4vJVhSsR7UqsWAfTRL3c+jm/bELX1vta2N1PZsA3r/hzZ
   pwVIZ/ePZQewUs/PX/gsVzjMYqhxBFZGSyD4VwOzHXXfjy+3q6vfS41fX
   tPcPl8M6b4+faYA9JtiAvr8CJstMo4qCPkuLFGmIAcY1HJ5uWpu6zq4od
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="69439720"
X-IronPort-AV: E=Sophos;i="5.96,149,1665414000"; 
   d="scan'208";a="69439720"
Received: from mail-tycjpn01lp2176.outbound.protection.outlook.com (HELO JPN01-TYC-obe.outbound.protection.outlook.com) ([104.47.23.176])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 14:41:17 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K0CaFslNqR/6ANQeu55Ini0CoVCCKoCrzD2B277qO0jG1b8lkENeKpRV/n3/zBCQmkO6rcZWRkXXpAsoVYvB+o/SNEnjou7oZ/xhzT5Oeo53gRPpWha5qiXYiUwdwh19w/PR970FJdXjTNzTxGRibb5v4uRI8XD4UTduJYWK3Cx3MwjkEVwu6kTgsF7CBxPbn1aZVsgiarI3g7sJ8ATIHO/cViGrT32hvi9xyT/H3i8pvb9E9Dc1q7kEzgTZDbS6YIyxTFXP4tBpCx0GG+KgFNBqT+7LCBXKIvMy51oDlKB2rrLLvxSIdOa2qUq3mtiBiQYw6TjkQbk5e3yKBwm70w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vy7v3dwkDZW2i+lMKEutsdF5BCuLGsR6CjM7e4ipnhY=;
 b=NtG40UkQRvxETGgWNejUF93zczzuBFPH2frDOWR/ApLb3A1/QY7yzXlSr9ZCoT2lNMIVDAqfBdCmBCBbdBS487uKV7N9eUe6Wpb8iRF1lPTjKrAh7fXZ3Vk4+fc+iOPNR+R4eIsBOT5XW3WRuV55KJAuUjAAtRwgs81+34vNItRL6xP77DDnmdQ51Zk+nkwwr1IM8QoxtxYs7Tcv8O6XYOVpy64vW2E/km1SCzCJn8CzRixqDTzo/vppKFw2BO1dvizjaQtx2xN0ECEpVLwaTMLdx5oJNkVeQ65RntrOUqyfT4Xp/6NnUEgrWQZhaO876+FxpKViJusMwIrfrANd7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TYCPR01MB7775.jpnprd01.prod.outlook.com (2603:1096:400:180::5)
 by TYYPR01MB10592.jpnprd01.prod.outlook.com (2603:1096:400:30e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Wed, 9 Nov
 2022 05:41:13 +0000
Received: from TYCPR01MB7775.jpnprd01.prod.outlook.com
 ([fe80::2c55:97e2:6dff:bfe6]) by TYCPR01MB7775.jpnprd01.prod.outlook.com
 ([fe80::2c55:97e2:6dff:bfe6%9]) with mapi id 15.20.5791.027; Wed, 9 Nov 2022
 05:41:12 +0000
From:   "Akira Naribayashi (Fujitsu)" <a.naribayashi@fujitsu.com>
To:     'Mel Gorman' <mgorman@techsingularity.net>
CC:     "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "rientjes@google.com" <rientjes@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Akira Naribayashi (Fujitsu)" <a.naribayashi@fujitsu.com>
Subject: RE: [PATCH] mm, compaction: fix fast_isolate_around() to stay within
 boundaries
Thread-Topic: [PATCH] mm, compaction: fix fast_isolate_around() to stay within
 boundaries
Thread-Index: AQHY6S3O4xnDu8L77EevMVig1gEQ/64iskiAgAVyM4CAC1JoQIAANjcAgAE2EwA=
Date:   Wed, 9 Nov 2022 05:41:12 +0000
Message-ID: <TYCPR01MB7775D957483C895456CFE146E53E9@TYCPR01MB7775.jpnprd01.prod.outlook.com>
References: <20221027132557.5f724149bd5753036f41512a@linux-foundation.org>
 <20221031073559.36021-1-a.naribayashi@fujitsu.com>
 <TYCPR01MB77752C15C512BB7EC952F05BE53C9@TYCPR01MB7775.jpnprd01.prod.outlook.com>
 <20221107154350.34brdl3ms2ve5wud@techsingularity.net>
In-Reply-To: <20221107154350.34brdl3ms2ve5wud@techsingularity.net>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: =?iso-2022-jp?B?TVNJUF9MYWJlbF9hNzI5NWNjMS1kMjc5LTQyYWMtYWI0ZC0zYjBmNGZl?=
 =?iso-2022-jp?B?Y2UwNTBfQWN0aW9uSWQ9N2JjYjczYzEtOTkwZS00ZTI3LTg5Y2ItZjE4?=
 =?iso-2022-jp?B?YzkyM2U0N2FlO01TSVBfTGFiZWxfYTcyOTVjYzEtZDI3OS00MmFjLWFi?=
 =?iso-2022-jp?B?NGQtM2IwZjRmZWNlMDUwX0NvbnRlbnRCaXRzPTA7TVNJUF9MYWJlbF9h?=
 =?iso-2022-jp?B?NzI5NWNjMS1kMjc5LTQyYWMtYWI0ZC0zYjBmNGZlY2UwNTBfRW5hYmxl?=
 =?iso-2022-jp?B?ZD10cnVlO01TSVBfTGFiZWxfYTcyOTVjYzEtZDI3OS00MmFjLWFiNGQt?=
 =?iso-2022-jp?B?M2IwZjRmZWNlMDUwX01ldGhvZD1TdGFuZGFyZDtNU0lQX0xhYmVsX2E3?=
 =?iso-2022-jp?B?Mjk1Y2MxLWQyNzktNDJhYy1hYjRkLTNiMGY0ZmVjZTA1MF9OYW1lPUZV?=
 =?iso-2022-jp?B?SklUU1UtUkVTVFJJQ1RFRBskQiJMJT8lUhsoQjtNU0lQX0xhYmVsX2E3?=
 =?iso-2022-jp?B?Mjk1Y2MxLWQyNzktNDJhYy1hYjRkLTNiMGY0ZmVjZTA1MF9TZXREYXRl?=
 =?iso-2022-jp?B?PTIwMjItMTEtMDhUMTA6MTM6MzdaO01TSVBfTGFiZWxfYTcyOTVjYzEt?=
 =?iso-2022-jp?B?ZDI3OS00MmFjLWFiNGQtM2IwZjRmZWNlMDUwX1NpdGVJZD1hMTlmMTIx?=
 =?iso-2022-jp?B?ZC04MWUxLTQ4NTgtYTlkOC03MzZlMjY3ZmQ0Yzc7?=
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYCPR01MB7775:EE_|TYYPR01MB10592:EE_
x-ms-office365-filtering-correlation-id: 563c23bf-e487-44b6-0658-08dac21502ff
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Tt+FmC4BMbtOlcC6CxXnh0hGVyL2B3u0FK1E++GY/0tIolBm0iNJLo4PfibCxtwGs0DkZyo31AG72Y0sJ646yrPGxCfJpd800HQMc9WOtOzeeHB0wPUesvjwNCDAIrksygXrp8q/d/BXdecYpBKQ7W5sZNcgP7UTLFXKzp/Ym6oOlVGejbejCD9aacGm7P+9+B08v4/boiX+R25ZE+FgR1mwm/mdssxX/bzaE7w0c1bNA2WofftUommL3J2/prlD68SLQpyo3RLitllc2KhYyMmMw1H9xxYUZYiwzjH8xxssTfUnaViS3ajV28jHnRle5yysYGxK/VLc2x5V7cjFB0p8SVXakyTo0SSpMQjZ/EFt8WVdBp7D7gatXpIaydJXj+vUkEU6mwmtoCbeD77hC6Dd81y5cmE24nUMUp3HRpWRpyO6dfVbXKckp7n92NCuOdDdJQf43UYI8TWpVjxYI5KkCE3qK7M23jgAVMAqIa3T3BYmuLSZ/kRsC1jLFt1i8F/rIllIigVdkecERFyAgZViXvqTa8KS5Zx7yCOkEambBdXG3w5OhoalorIBQf7fQmKxrXdB0ZVDwV/iUlksBfKmYgekJpq9HsnbGUgDi2ua/CHksknidaG7wX7RaI+o239wiCspeQid+e+VpNDSSXiZGvCZJjY4ip/BzKMmGnGcm3iyX4XTbbZsWoONu7ZSRNGFNFFUvJpGDaBF2HQA6YIlSZRbOXB8BCwkDjbkYOmAe0bFBswdwQFPt8N+qjGDr6oy7siynHt7NzH9D5b8fII4W5PLu6geu7TrCczbfx4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB7775.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(366004)(376002)(136003)(39860400002)(451199015)(1590799012)(107886003)(478600001)(26005)(7696005)(9686003)(6506007)(2906002)(83380400001)(55016003)(5660300002)(33656002)(86362001)(38070700005)(52536014)(82960400001)(38100700002)(1580799009)(122000001)(6916009)(64756008)(186003)(316002)(41300700001)(85182001)(71200400001)(54906003)(8936002)(66446008)(76116006)(66556008)(66476007)(4326008)(66946007)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-2022-jp?B?UEtKdjRQYURBSEZjL0FTNk1PcVo5OGoxN0FEK0pYZTJKaEs5d0U0OG90?=
 =?iso-2022-jp?B?dzUwMmFKcGVFTFZib0tldUhMTEdTZU8rKzhteVZSOUoxSzVWVDdGUHJ4?=
 =?iso-2022-jp?B?MTR2eXFvbE12dFd1QlNZMG5VNXk0YjJRejdxRDNmY0VSQml3bmUybFBw?=
 =?iso-2022-jp?B?WjgrTW9MWUVFVGQxdkVMb3ExNDI4SCtCWm0zdkwwMUx0ekpqK3JQYkpq?=
 =?iso-2022-jp?B?dDNjMFJwVlkxaGEvemhjTlpBSFpUMjFadi9IK0JmeEhqM0tOc1Q1Z2Nq?=
 =?iso-2022-jp?B?Qm1VelAycEVhbGFtdFQ5OUk1aVVzclYxbFphajkxVHJBdURYZUx1aGQw?=
 =?iso-2022-jp?B?Z0FjM2N1WGtJRXNydE1ORkN3Nms0Mlc4U2dEcnZNL1Bwc3NFOUtFeDcy?=
 =?iso-2022-jp?B?eERtREF2dnZ1V2ZJMVFQZGVsKzRjYlNWbjRKMEI4aVhTVGJCamVtcGlO?=
 =?iso-2022-jp?B?Nml1NnR4a21nL1k4YUNOZ0pMbytTWnhRMENDUXlVSittQ1dXRUxvM2d6?=
 =?iso-2022-jp?B?TENzQnhKV1NRTHlHUTRzRW5MM0FsbURHSktxekVZUnZpSy81RXUrbnh6?=
 =?iso-2022-jp?B?TTRvZ29CSS9oc2RrM2pneWRJVWErQkt1SnpYNEVxdnpwUkF6Q3E0cCtK?=
 =?iso-2022-jp?B?d2Vqb0Y5QmtkMG93Snd6MkUwc0pldUwzYngrVEhZamJYbUtMclBwTStt?=
 =?iso-2022-jp?B?b1hzUGJzcldmUnkyQTBvZGJCNGhhdytLRlZIMms2UkZlMlpGbVlVeTh0?=
 =?iso-2022-jp?B?V1lTYnMxQWxuWjB4dGRtQ0JGMEdvWW5sL3l4bWtpZHRGazJrMFFYM2VZ?=
 =?iso-2022-jp?B?cVpqb1FnanJjVDZobkVocFVBSDdTOVV5NW9JT1JvN2s2a2ZrL0VGb2RT?=
 =?iso-2022-jp?B?VDg5TjVwZDVVa0U4NXNUTm1ScHhCMVo4UFZzSC84aUhxR21ybWl2K2Mr?=
 =?iso-2022-jp?B?ejBiOWMwdW1FYnZKZlJuZTVMOGo5YzBxMWRMVVc4T2tZWmZsZzFMeGVl?=
 =?iso-2022-jp?B?bEtHYWhOYzk3VUxzb1k4ZWhveFRiSllUUXl3Zkppc3lNd3N0Lzg4Sndx?=
 =?iso-2022-jp?B?Tm9EZnFFN3JpSHlUYWpsWHB4cFRTUTlPcVhSdktCeUUzbCs4YWhIbzVw?=
 =?iso-2022-jp?B?NWthbmFnVElPTDZWdE5ucXJVcEEvZ0VsQkZvQXVPY1BKanBFem5VTVRj?=
 =?iso-2022-jp?B?dW40bEFhMmswbUcvNmpabW1JZGhMM1BtQVJrQSttSFF4dUpZVmlzNWxn?=
 =?iso-2022-jp?B?YTVENVRXaFZWckJOZjN3Q1YxVFZqRjE2N2dEVE5aZmdvZ0tJbjZHYlow?=
 =?iso-2022-jp?B?MWVuVi9WUGRyWU1tYU0yR0lQY3BBQ2JGODUvVkpReGxDVTg3U1pnUWs1?=
 =?iso-2022-jp?B?RUIwYnhDVkZxeHBJY0NIcWZnMlVhQWVmL1A0SkJvV1JYQzVaNmduL0lq?=
 =?iso-2022-jp?B?ZWJBUUc2VXNIcU9heXF2WTBPS2J3V3FqOFRoQ2ZGZ2ZYbXROWUI2aTRa?=
 =?iso-2022-jp?B?YTZIcW83V2JmVVZiZzhydVhTdTFrTThpNDlUQVhiWGV1d1VDWXZhMm9C?=
 =?iso-2022-jp?B?TVJnVGFaSEhONm1adG0vYWJPSk40cC9DRFRXQ042eWN3QVJFTjBnN0lo?=
 =?iso-2022-jp?B?VmJLdEEvbEptWFFvMUd6am9DUkpFMFNJaXJDWFN2OGhLMUl1bStKZmVW?=
 =?iso-2022-jp?B?SFFNSTBFYThOZ29iTzFLWGl4TmdOejI1cW1wWUhQVkNUK1JSamFFVVdz?=
 =?iso-2022-jp?B?aDEvUUo5ckROZ0llSU9NQkhML0ZJTGZBbXJVWGRLcFBrRW5EMkNtb1cw?=
 =?iso-2022-jp?B?ejQrOHJ2aVdOY01IMU1wS3cxU29zVlBsQkJUQVg4SC81ZVpLNkppYjJZ?=
 =?iso-2022-jp?B?U016TkFKT0RhY1BqTjAzLzJUVkIzZnhMeGRTQlB5RTdHbXI3cFh3YURs?=
 =?iso-2022-jp?B?dXhyWHVVUHRmRzQrWFhDRVA4aDFoMXpxVHJzNDN3Z3VYYlZFeU9WN25l?=
 =?iso-2022-jp?B?K3I2NTkzbEZPVGlWRGduWGRwUWV5NWxYWElhS3NJQ0o4eFJ1RGhIWGI3?=
 =?iso-2022-jp?B?aVpLaDdkK2Z6dDRDRlZDNDB5alM4Y2dwNVpGQkVkZWZ0cHhMMVovdm5N?=
 =?iso-2022-jp?B?MlVBbDlOT2NGblM0TjE5dVdhMW9YYWlHS2lQL2tlaDBkRlRJd1hLYXNv?=
 =?iso-2022-jp?B?bXZuVlRLVXU5aUxLdFEwWmNWRWxtTHk3dmJ3TUdwL2t1V1JYT3VTVy81?=
 =?iso-2022-jp?B?b09WbzB3bFB4Skh6dW1MUzI0bWVWd1N2MFFpNWVZVXFDU1RvdW9jUzFt?=
 =?iso-2022-jp?B?L3BqckI1VjkyWFRURXZhYU1sYXJPK084S1E9PQ==?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB7775.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 563c23bf-e487-44b6-0658-08dac21502ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2022 05:41:12.6559
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r8VN2iOHfciwiGNTWOErtvx+44Dxak38fGIcwe0nqu0xjaqJlsa8OidOMbMqJA6fKmIevFX6Y+Pax+r91NwbW5sro6wRnoQIHr0CQlDcwEo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYYPR01MB10592
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 7 Nov 2022 15:43:56 +0000, Mei Gorman wrote:
> On Mon, Nov 07, 2022 at 12:32:34PM +0000, Akira Naribayashi (Fujitsu) wro=
te:
> > > Under what circumstances will this panic occur?  I assume those
> > > circumstnces are pretty rare, give that 6e2b7044c1992 was nearly two
> > > years ago.
> > >=20
> > > Did you consider the desirability of backporting this fix into earlie=
r
> > > kernels?
> >=20
> >=20
> > Panic can occur on systems with multiple zones in a single pageblock.
> >=20
>=20
> Please provide an example of the panic and the zoneinfo.

This issue is occurring in our customer's environment and cannot=20
be shared publicly as it contains customer information.
Also, the panic is occurring with the kernel in RHEL and may not=20
panic with Upstream's community kernel.
In other words, it is possible to panic on older kernels.
I think this fix should be backported to stable kernel series.

> > The reason it is rare is that it only happens in special configurations=
.
>=20
> How is this special configuration created?

This is the case when the node boundary is not aligned to pageblock boundar=
y.
