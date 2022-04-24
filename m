Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F84350D191
	for <lists+stable@lfdr.de>; Sun, 24 Apr 2022 13:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237153AbiDXLz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Apr 2022 07:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233946AbiDXLz4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Apr 2022 07:55:56 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A121C1869EA;
        Sun, 24 Apr 2022 04:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1650801175; x=1682337175;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6q4mD3xYv8nC9UZt65knXruumPYeQ0MbFbiPrXmy+C8=;
  b=gJY0PaHCk/yHalEo99UoGCc0HH7rdhN9Bw1JLhbrrUazNCuRBZkxaUHv
   cx5nasp29L1r5FQMNM1ioMDy6uHlVVDWpLLx1II2pB0gr8qCB3HGO6Gtb
   rhVHFhIZMYEngegRVDo0gWwbp+ytm/tWLkYWNiZHFcLFSy5oRZQw3SZ2f
   ZDvIGRlKf6eNdJHUmSvUWq5Gv1SmUu0MBnEIPRiG+XFyVrES9jPCmHP+u
   rqYbiOYKFsian8uh5FAPCUUGGbNc+cDScyDNOoGggP7pJ305N3NT67JwN
   9fgeUBYkQ2IrCsO9gOIZQjnjNm0s3V/B+XCQ1qwsdJJH/xVmxNStSd7D2
   g==;
X-IronPort-AV: E=Sophos;i="5.90,286,1643644800"; 
   d="scan'208";a="203548504"
Received: from mail-mw2nam10lp2105.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.105])
  by ob1.hgst.iphmx.com with ESMTP; 24 Apr 2022 19:52:53 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vg2n6/aSRsy80FQdpRWLLGSiCn9gtfm/ktmPziwzBcdEwJwGmWr3zf3cJYmwj6049Pc1hSXEttYjUVD1SeZN9oFBap7GNQDtA8Dgu4HneaYSe/PHzOV1zsPDayI87p9j+O+QY8I818G2IXKn+0Dys8JG1t60o/Czvr7sZh5H71fOzHK82xgHMZSaS4MgJ2G12VOu2mPDEENHrhzn1QvVZnHQxcu6XOfjfrcePs7KVlvkvuaSuh7yRNwuLHXMSpUlA13ZQOy16rmZpPO2fJviXA/NYE7gRUAzk/CRE8AMrO9QM4xwl6WZC9cwi63WgQgxwdmYlLlAZmFS3saTuTwuyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6q4mD3xYv8nC9UZt65knXruumPYeQ0MbFbiPrXmy+C8=;
 b=eHhnhbYn63vgpU+0sS78Onpf7gCdJhE8yofwrM6338wF5wQUX7phkcieQu7MHhTccPNgu+p4eodDuaZzh4lOippjfomU5RvhHLn6WA6UjbNakWgVKIoSHlEOoHoMRjlUGhAX4JMVRbFkHpiSEXJD6XE+IWhvg2Z8gWe0AfjnyzTssHJfcUpVSI219gBEZ8G+OzkcVjc1LPfZ6Co314vWbbVHxoXHHbIy28AGoQ74o/d1sJpDnCVo7f5CWQl8ibH7oUTn4YtNofCNiw80elXlaUpIN9WFNR7BQDt+/0lo3gVsKVCgoHQRb7C2RVdHKA9ZjjWMwP66rt6VDTCiiykMlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6q4mD3xYv8nC9UZt65knXruumPYeQ0MbFbiPrXmy+C8=;
 b=RfdHrLt3IRT8FrJ6x8wqljXxiY7Qr0cxSz0K+pvC2Y+DkIACTKKl1S9CZRP4zFNZrDtrD08YmgoPE7HAXEV6JfPfpOxSmtxyOVM+pUxptQfl2xoiVX6MruuhQz9hy2qzvH5vJXYKWfzVeqj+zM+c79MfJGqXErG1ec2D2qcfpDk=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 SA0PR04MB7466.namprd04.prod.outlook.com (2603:10b6:806:e9::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.14; Sun, 24 Apr 2022 11:52:53 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::b049:a979:f614:a5a3]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::b049:a979:f614:a5a3%3]) with mapi id 15.20.5186.020; Sun, 24 Apr 2022
 11:52:53 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bean Huo <huobean@gmail.com>,
        "ulf.hansson@linaro.org" <ulf.hansson@linaro.org>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "beanhuo@micron.com" <beanhuo@micron.com>,
        stable <stable@vger.kernel.org>
Subject: RE: [PATCH v1 2/2] mmc: core: Allows to override the timeout value
 for ioctl() path
Thread-Topic: [PATCH v1 2/2] mmc: core: Allows to override the timeout value
 for ioctl() path
Thread-Index: AQHYV1/byxTDf97XOUGO2NhuYDjvCqz+9ISw
Date:   Sun, 24 Apr 2022 11:52:52 +0000
Message-ID: <DM6PR04MB65756F8A881F88DBEDAB5F40FCF99@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20220423221623.1074556-1-huobean@gmail.com>
 <20220423221623.1074556-3-huobean@gmail.com>
In-Reply-To: <20220423221623.1074556-3-huobean@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bdad0bd6-4326-4e59-e0b8-08da25e8f6d5
x-ms-traffictypediagnostic: SA0PR04MB7466:EE_
x-microsoft-antispam-prvs: <SA0PR04MB74663D6FA4342A2AD8926057FCF99@SA0PR04MB7466.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JCygUuF11MmVrBET5GAZls2v7PCpyCLFgwso0VxyCsYUVGg3IuLOFqBYJz7dSgp/mwGRQ7YfesHGuKOgVIVZn9jYsfeRLBfLfMffFllSvE3GA1ckqB0Yb0zw1ZIBwZM6v0prjkU4HTjdPtcn3ccijer9FANXCF4d02AE7fC/+GCWzDlLe2vGETDnS9eL7q/CkTvYNNbnhDZiLOrVKUcclzp0hwJhZs52obCATaDVwGul9iFnnq2+SdIPynD9rTwve/cceEZJvlxyeMBIARU/vWJbpfmn0OZbmKwBtfZJXgxFELmLslWCuAqo+sBUO1lrJVe1ERZveXDoh3H+RE2Juata5Pul3gAU36xfv8AgPmnMQg/Npb5VCfsSUS+vqqmrX7dKhfamJXpaE00EzDCtP+2ESVE8YswdBe66Zg2QnDEzuPCKebfB0fT5J8vPpExMG1C2gXtswQdxgG5pYIz+LZNJ4qekPVClwXnepTcdvWK1aXCVZP6waSx7hiH3ckOjzskjA/gdcvmeKESDIEL+LfW6z+TV1UBgGFcdOlDx+0yRonmRjO7f9ezANpQgmJPF1465VpKzn+aA6YmhcP366RN3SaZ7WZf2t7WDdaCkOFFFa7fviapRVqvXdKkM7OZ31aTdruEIOJ2/byvEbw6n+vC0FDYTL7D9i1eldsWZQl09KEdA5bKw+ue0teRsgc1ucHxvcX5jHTu0lBj6HCp+mw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(33656002)(110136005)(186003)(8676002)(5660300002)(86362001)(55016003)(508600001)(122000001)(54906003)(66476007)(4326008)(76116006)(9686003)(2906002)(64756008)(66446008)(66556008)(66946007)(71200400001)(4744005)(8936002)(52536014)(38070700005)(82960400001)(6506007)(7696005)(26005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DVEAVrMf8k4868flU5Te2svhx+BZoC6+n+9aiedL5WayJa9j6uAqE6jmUuVT?=
 =?us-ascii?Q?WXWy95vT8drvf3PvSiKjU9NNb71m8DLWM8hO9hOorrPmyIKFY/ZfaUA8oQOz?=
 =?us-ascii?Q?kgOQJuLeshcrj6H3gS+MeogcCugGRImv4p7Rtqkw7Gs9XEyXEinWxSB63ClM?=
 =?us-ascii?Q?oJjdfg4Lvxe2gMCjRIuMZ3jSc/JdyHnpjJlAjOdCC4lw145L4T8tbpL7maEa?=
 =?us-ascii?Q?6qHJIkJ7FcWb1HEgilp47fESY0JUTn7ejPehMAR0g0s0SopO0CtgON1ha1qJ?=
 =?us-ascii?Q?8Bn3LMg1Tee7+wnaLUO0ot2yBMx9wLp7N2kB8YGt6wF+r+x7MFYA1YW8hKvM?=
 =?us-ascii?Q?dfoYJ2dr1CUtQCmD/fDbcLLsYA9YhyxjCH/lBTUdeTw5vAiNU+acktG3MyFO?=
 =?us-ascii?Q?Qh2qecXe9fsiKQRCqLb1aVfqyG+gMunoiJ1cGvCNDs6ldZgrKutjj6cHfUJj?=
 =?us-ascii?Q?2GV2uWnzMNthyTkNrM4QH7rGr8CRn6KlxeauFc1l572WnCfBvZz4s6M49ecY?=
 =?us-ascii?Q?d7op5cUFOfpldTod+TLexhlfkjnQWG9Xnwm+7trUPpljQHh9f049vQkas8Ew?=
 =?us-ascii?Q?bvql8mWS31ThmeLfA0u1B1gODQafyPr0heV8H96CQD2Eomyw/eVlWxUFhskm?=
 =?us-ascii?Q?S/NhGSTopxndCFmmrBtD5VGDHOSUaqi0QOlXd1XFyE9VwBN5Oi7cubK2Q+bs?=
 =?us-ascii?Q?l5K+r+3w6ubaVcJOOM3/Nn6N764pfwnfK508wnWoNsY4KOYgRPCxJV23/tP1?=
 =?us-ascii?Q?3rLCgn26ccyex6Dtw4PvBWB2faeYjw+eQF3TkGkDW3nL/VAGTj6O/IbXWlp9?=
 =?us-ascii?Q?S2ZSIRzwCkISpuVB+Jkm4gv///LzWqndzGy4xwwETMUuRrsJ7CuADKN5QodL?=
 =?us-ascii?Q?2YXdMSZCRH1/klMa++P8Z5S1U8jnlmyOUOcdfC+VjwYMUlVsZP5uKXVBXsfU?=
 =?us-ascii?Q?/cuqnIXEMMrkIeikOxH52riLNvv2LqBwQqtIcctDKLJIAExDadzZF9e99qp0?=
 =?us-ascii?Q?9y2u+0oXfGFVkB97Lpf3ALJDTj/8e19V+RVC/DfcsBlTqEQXIEjIgUPckwmX?=
 =?us-ascii?Q?S1ED/LrhTBFB2/hqp4tCJ456s7XnprCZkmjB6GjIURcwYcQYVth/3z61zX8V?=
 =?us-ascii?Q?GEU7l8RX7tzdvrgne/tJO40RCU/Yqlbg8CYxvvVddYciAhVYXnHdO3rnYqaw?=
 =?us-ascii?Q?7OlSlbswkkSnpKurzhPalzmO3ox7gP+hDTl8pbOykfZJOw2IN2aZIdlwsgi+?=
 =?us-ascii?Q?viGE28CLhJTUSCrRcxY3So+tSUbv+yFs8ANvydTTMKsoKkZ+9iQN3eL3rorf?=
 =?us-ascii?Q?A2SlvhCrkO6SDOKICsaLgfOSo/MNud+vH0p8vyebwMf6rd41pduj3Zssct4r?=
 =?us-ascii?Q?V+LetExjrM5OJ6HTFSqmyUZ6bME8v25t7wnI5ngr/B2mWoK0OBpRU/4Jr8cq?=
 =?us-ascii?Q?Kc5ehtSShMieuYpC1M+o62KW2oFDliF9Q7p2KRPCf2YyPhNeUZGzRuOVlo2Q?=
 =?us-ascii?Q?G5jIHgv3gipqIyGd7OZ3XoCdHarb44ISxwTWwgwfv6Rdp8ygktMymhB5djSb?=
 =?us-ascii?Q?BXff9dXV6GVz7n8y7sireF5Z4dWt3LzMWA8j21r8R+Dni/HcJkAs3wcnjcqt?=
 =?us-ascii?Q?87DbzIddhKty/HnAzr7KETSD5vi6ivNgIf22tVPiRmTV4sKAOWSFmsJEy/4r?=
 =?us-ascii?Q?X8ps830kkq/busbPXCnsP7/duaQkETGv+c8S0z55bDZd3LWP92L/88kNfsL7?=
 =?us-ascii?Q?5hJRdxWsqw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdad0bd6-4326-4e59-e0b8-08da25e8f6d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2022 11:52:52.9730
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Fuzco4axbyufc1bejDzQ9BiEtVM0uaFBLsdjG3vjsWGTx10ltaqFlEiISTA+JVCrr3lfZi5Z6Iho4CWm2Xdu9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR04MB7466
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>=20
> From: Bean Huo <beanhuo@micron.com>
>=20
> Occasionally, user-land applications initiate longer timeout values for c=
ertain
> commands through ioctl() system call. But so far we are still using a fix=
ed
> timeout of 10 seconds in mmc_poll_for_busy() on the ioctl() path, even if=
 a
> custom timeout is specified in the userspace application. This patch allo=
ws
> custom timeout values to override this default timeout values on the ioct=
l
> path.
>=20
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Bean Huo <beanhuo@micron.com>
Acked-by: Avri Altman <avri.altman@wdc.com>
