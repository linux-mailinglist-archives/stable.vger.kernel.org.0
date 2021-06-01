Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58346396F17
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 10:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233374AbhFAIlL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 04:41:11 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:23924 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbhFAIlK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 04:41:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1622536768; x=1654072768;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DtJ4hJf/z03wTkZKFrDfWAl40d9VrkijrvmSgH/A9qE=;
  b=p/DYkqOosI+4eVe5+sRJqqwEf4FkvkFTXAX4oOPT2C1YaEh+7SO7Zfpe
   OS7cWxa0SLQvV7hP5iYEBbS7CikwjQDqh0iuTGIyaUp9JUhMGmAa/cUkx
   q0vqZbF41U9qUdyyxvGTNwj1EOhZUsEX55am7rCVHJEkJmf8hFXtjH0UH
   gC4C+5Ma8WXgrEnLJ1gzULKj0U8y3C6pLI1NawcJadRp0qylssNra4F8F
   mZG38BksnaoRqqQrGb6tywn0w64eCWYzPeyKInsNlRfceUX0Qoi/JY9GP
   N2jon7j1+wtmnaXsA9xWO83uwNGxyc5XjZL2F0IA3BeB4ZE4++9FmcZOl
   g==;
IronPort-SDR: 1mbTYWpWrjQ6iWlpWLJ4SReRNp39D5QJ3OwrxvZ8GqMdKZRw173Iu1aoCM5OcTbP6fGlzu6C2f
 GhKCNC07q0pPMSkRimESWQfspNcCC/Z24r6MnXValQxz6usm1csn3Zs+toAqATbMt+9+gAy9F9
 wGSHVZi8KJEDRZHgCGsVPC0vH+Vr0Xq1xR1TQkgBKucLj9iE0Rh6QpZbgeCIB0kxWs043yziDt
 fIKN0yIxEGcfQGoV8vWA1+BEsgWzdKD2abuXWImqGLFa02qwOAoPdR7zUe4zIyVMZPoHugRcw+
 jEQ=
X-IronPort-AV: E=Sophos;i="5.83,239,1616428800"; 
   d="scan'208";a="170253880"
Received: from mail-mw2nam08lp2176.outbound.protection.outlook.com (HELO NAM04-MW2-obe.outbound.protection.outlook.com) ([104.47.73.176])
  by ob1.hgst.iphmx.com with ESMTP; 01 Jun 2021 16:39:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NmEgB/LTChFSkVtzx22GiCJZSYPttzXwyOtXS5K4mrmmoAnQsAWPkBjsnruLhka0D6zRQxUyAxqNSmxrMwix8LFkWhh9JAV8yy7x6Xk6nSg0zpOOf9izGsb1PTOyWbqzXxx7VW3cMJiB6QYhiOIiCg+RYkN8X5M0xmbvKlLGA1J0/iGWZYZ537SrUVv7DZXuSylgC/Krn69URLeZ6O8TonhMAgj2KJGsRfeP5jc30p6B28xJ17tsCAt0K+4uEILkDI8mkEog6nTvtPN0E14+Dd+irf0QQQirWFDvvdpgru4PLNfxAyE/hfFtKzKiMFCj0kPtA1dntTiHgkcW5Srgfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JqVcN0931a2aXWQGyDWz+BT7MX0E9mpsiwWZAK/2hcI=;
 b=RLkGwIPrR8kHuNo8bDDA7kKk8LRPxaBRFhWPRUMm0ZeP/tFFF8wEfZvmHg3zUwlAwZEDrpw0Y624y1mHSxHUuaBvks7WXVryVAzwrMUSQnKLV+h2EJiordooiC8Z+gWojqZkRdBwMoIvxKkYw0muBv4V9vHuyeaZZaH5lxWC8ajINVIhBXV9QKQAmWielDOssejSC2e4qbIJBqj3HJ6XSmhykirqVkOUhsptL5oizB7iIIbMYmsNpuy9LilVG0rMka8WT7yskgCmJajFc4aVlvRW5R+umnpR5a2GbYawF/k0Pr5XzT7jGmNp2DxqccE46I3k8Z8mmzsFDqsnSXFlQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JqVcN0931a2aXWQGyDWz+BT7MX0E9mpsiwWZAK/2hcI=;
 b=x6H/kyVrrV+pXB/qZ7alabWMzROPO6q3NHWhhWxMSpuXZcTJymkLsJqDkYk9rPjhVWCq/QkMAry2n0zbAKwrCw7qq2O5ljr7PQ7HWLX80TF+ZchsErrF0GKHvUeFqKcQLlciB1dOubb5By4zRArH02cmIQYxgBcwoyLzfMq6XPc=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7317.namprd04.prod.outlook.com (2603:10b6:510:1e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Tue, 1 Jun
 2021 08:39:28 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::45d7:388e:5cbb:ae1e]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::45d7:388e:5cbb:ae1e%6]) with mapi id 15.20.4173.030; Tue, 1 Jun 2021
 08:39:28 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Hannes Reinecke <hare@suse.com>,
        Shaun Tancheff <shaun@tancheff.com>
CC:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jens Axboe <axboe@fb.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/2] blk-zoned: allow zone management send operations
 without CAP_SYS_ADMIN
Thread-Topic: [PATCH v2 1/2] blk-zoned: allow zone management send operations
 without CAP_SYS_ADMIN
Thread-Index: AQHXVsGgYX0QC3Ho4UCNzFW5ZLQacA==
Date:   Tue, 1 Jun 2021 08:39:25 +0000
Message-ID: <20210601083915.156476-2-Niklas.Cassel@wdc.com>
References: <20210601083915.156476-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20210601083915.156476-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.31.1
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [85.226.244.4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: daef2deb-d426-4a9e-73af-08d924d8c4ba
x-ms-traffictypediagnostic: PH0PR04MB7317:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB73172AAF2491CACBE59F0674F23E9@PH0PR04MB7317.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZzJt6DqVKKeT89wLLDBn+xFeAZYi94v+Q1gv7MvkuZo+SrOlxroJKoDbxpvoak0qnqANjbTdEbfNn3C6UgHRE2uHXrJY4TNjNtgDHgp7jZyXOaXDjUiEZ0pEv5GmCA1kxkB/CWX7r2aHD4OoJUAP0M7p/iEptRyBkPtRs1Jpkh12HmNjuh1tDzp+3GVFKmGiggnzykEw3MWp+sNJtXMubhXeW+l16tOaK4pc+c2k2WOWmuEBNt55Ai4JQ+/F21n7FxM954SdYaMvEJwno1fC63Wl5iXL5Eak4eqcFtC2Du2/9yvrb7f4q0aVLrQixbytKw7cKRQi4buPdsyVwxMIg7h5CFG+8lqmgiK4QLrxBHE63K/+LL4nM1llAC759ivUEQWf5dzotRxmiKippYaHRBI5xP7cMi8dNYtsbnTmqJBggEvDxgZU9H1+E3FQXDA8kgOKPg9kp2OD/q8ptl5NfCrLSHPVFHWoSgNQr0vuAytq2m7TXUZWZsU8ckeerILtLDk7mwHze0kLIFg0hjdOPxd0/PJvqhbycarWiE4kbL7wiDcFdUJ2XEq1M2Dtzd7G/rf7orVW8MQSLcX1yHJwA8I4HZ4JOW/cuurhkQ8HgIQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(346002)(376002)(39860400002)(122000001)(110136005)(186003)(54906003)(38100700002)(66446008)(6666004)(4326008)(64756008)(316002)(478600001)(36756003)(5660300002)(76116006)(2616005)(66476007)(66946007)(91956017)(8936002)(6512007)(86362001)(26005)(8676002)(1076003)(83380400001)(2906002)(6486002)(71200400001)(6506007)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?1RVhDkyBBkiyNNczkEYcIFzHlE1K5TUd6fCW9BEv6s8dlqHc3ZPf1JxzAK?=
 =?iso-8859-1?Q?Epb9FW3ORLN+K9EqoJmYZ7xmDE9lFG+utFYbFCxvV0iOFu6Z4Lz1xUMbwm?=
 =?iso-8859-1?Q?IGx+ZKU1noTLaBuO+PavyFttyBUwprvfZDc+kyaCHCmgp6apJPsKsnsDHB?=
 =?iso-8859-1?Q?ZrRbkzxXnzzfYp1loAqmOAxQcNtppJk+0U7HWlm80B1iQGFw84DKAeoPE6?=
 =?iso-8859-1?Q?9GyQVqbJrJQJ9DfNggMndmlTkCFEdKIolh6hg8/t6/g8bS3ZeFMkw0Zs5V?=
 =?iso-8859-1?Q?sPb4CC+ZSP53NS/+oCEQJ1Q8ICTpeKRYKdHNOxVsFMOZmUsLElIhp0br3R?=
 =?iso-8859-1?Q?lNYn1I1Szi9qdg6jcGOC2OQjDhPkqNTEEfQKkp/U8GhYx6w3LCQKYNw1L7?=
 =?iso-8859-1?Q?Z9CsdgM1hsH4iTbm9C+kzB/nnNmXO4hwcW9SsXfyLjjHg/seAyKlXxjKLu?=
 =?iso-8859-1?Q?j9R/S41UrslHwt7UOOj3xwk6SbLnAVLSX/5am6caHH0Pl7tEwrntiuDe5f?=
 =?iso-8859-1?Q?LB5c8kmQsBxYOEWmnX5kTh9i078QVILVLfy3cjBijg0wXRF5qCTiHgCMwX?=
 =?iso-8859-1?Q?/3dcno8t0DrQWIUSTcw3YbjXcE2ZQCXZuxfBu5nv6JzoS4qrlKFYdZ0zBL?=
 =?iso-8859-1?Q?9X2LEy1cHRgeIkpaDi3145u7TcRMTgq5Egm5uT61yLtisjbi7u5KS4ei1Y?=
 =?iso-8859-1?Q?/hRnQidttAUjkYP3RADgyirHr/U0xNUUCt2i2U2Ft3lo4vuSByhi+at0xU?=
 =?iso-8859-1?Q?9KRyfcF80WMq9UYivjwa0F86wy9Z2vM7aOVnL58lHncJWLyfyQvODKyMHU?=
 =?iso-8859-1?Q?UGPjA3sPnuygmEt+znZxbV30gzY/q4eSMSsXccyT0uF5l7rMQiBhbYcrPo?=
 =?iso-8859-1?Q?dYHn94nOppQjDsKb6u6Vxpj5gTOOV1Rtc0u9JYncGhwnaxMoQNKXXqu2wR?=
 =?iso-8859-1?Q?OBcmRErqU/S623pZMndptViE54hpxxZFSTTVMhysq6TdaucY7eUAVnaSDf?=
 =?iso-8859-1?Q?LamvNlX9lHDm0ksnrU5YyLAOds4QFJHtqLMr83BeYmxaNZi7EChLAc8Wf8?=
 =?iso-8859-1?Q?Fpp4vlB+5sf0WB42YDXeTT1rXTEurdfxdpOYH3mO9RPUyGcNtrbNB0Me+4?=
 =?iso-8859-1?Q?l4axhbvBswP/nMT5yHkkmraYJnm/qeFqzU9Xpv5RS6FQ/8g0gsQhZ8gdRs?=
 =?iso-8859-1?Q?xtdqqbMoKGlgsNXmpmTKLOijP2q88jA7OeNYQfjSHoqZ2fzswMJozhjEKG?=
 =?iso-8859-1?Q?jm2uGNGL0ALLX5+fF7DLrOk9lqscfdTY554nXKNqZimk9YjJ/eu3l6tSfW?=
 =?iso-8859-1?Q?3GRx5YMVRd+jLEb/x6huj+2T90j3IXWCTU8blz6O8nK6gx5NsW4vTEJxz+?=
 =?iso-8859-1?Q?8cfBpsdt3C?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: daef2deb-d426-4a9e-73af-08d924d8c4ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2021 08:39:25.1478
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aaE8XvT+/XF7JBOybxSo2t/MLyL6qTT8SLm8JPOESqptaWXwLdCfQpgUJARR08OBj99wMyu01ca6oeYYbxF2Yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7317
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Zone management send operations (BLKRESETZONE, BLKOPENZONE, BLKCLOSEZONE
and BLKFINISHZONE) should be allowed under the same permissions as write().
(write() does not require CAP_SYS_ADMIN).

Additionally, other ioctls like BLKSECDISCARD and BLKZEROOUT only check if
the fd was successfully opened with FMODE_WRITE.
(They do not require CAP_SYS_ADMIN).

Currently, zone management send operations require both CAP_SYS_ADMIN
and that the fd was successfully opened with FMODE_WRITE.

Remove the CAP_SYS_ADMIN requirement, so that zone management send
operations match the access control requirement of write(), BLKSECDISCARD
and BLKZEROOUT.

Fixes: 3ed05a987e0f ("blk-zoned: implement ioctls")
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Cc: stable@vger.kernel.org # v4.10+
---
Changes since v1:
- Pick up tag from Damien.
- Add fixes tag and CC stable.

Note to backporter:
Function was added as blkdev_reset_zones_ioctl() in v4.10.
Function was renamed to blkdev_zone_mgmt_ioctl() in v5.5.
The patch is valid both before and after the function rename.

 block/blk-zoned.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 250cb76ee615..0789e6e9f7db 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -349,9 +349,6 @@ int blkdev_zone_mgmt_ioctl(struct block_device *bdev, f=
mode_t mode,
 	if (!blk_queue_is_zoned(q))
 		return -ENOTTY;
=20
-	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
-
 	if (!(mode & FMODE_WRITE))
 		return -EBADF;
=20
--=20
2.31.1
