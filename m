Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C69826E9D0
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 02:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbgIRALZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 20:11:25 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:44167 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbgIRALY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Sep 2020 20:11:24 -0400
X-Greylist: delayed 637 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 20:11:24 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1600387891; x=1631923891;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=X7a9WaOIOjFzeHUIeiShtn6z+X2bReOco7w+L/KdyIM=;
  b=NQMy2QJ7EZqEMZzRp7zPGhjYFIU/CfF/gnIdDbR5zxZBRyOdCH7tFy2m
   4M6VWG+uWBMVVViQN9a4YHPAmgciwvwgV+KnRCQKBk7HYX7RlgTLWWdwG
   YXPfLxbpSLZZQkRwb9qj8p6SaFLx7Shd3psA0gw8D3iMdR0JgFEv24CmW
   nKyLj6/sagdwxTT2D1lJNiqyJPw8PzhZXcpgdJ0J4VLXI+XFvVevp1oyZ
   GHNOnPdVlCAnS5AQ+jOFIZzqc4HZ1PmGX16FAWCKQalnRMPHAfj+nvOG/
   ln5ZoMdXyErfp+6ZRN1rUGRcSzi2Wj2QgMadUTxDz9uV1spgG/oQVaQ/V
   A==;
IronPort-SDR: O7vyrTd/kVzARrWOTlmWhTnu/u0u/aZXxpiCBXoaCUdzKJ25Ogai4jd3T7pgd6g8czB1g4YZyx
 nogZEdGvoRm1qqp9zhlu+MYZWS/CAVaSc4LDXVm0G9jBB8TKk5/v6UfO1PFwRmPO4bqehhMYYC
 KvRemId2Y9YSaef4lPvfgZlX8Z/VNaDmJnK3jgTYr0Y/iUpLhEEK3C3vuxSmkoF9+1VEe9Ej7G
 XxeM7Q60zJljCI3q44/eDM+L7oPRgHL+TAUOuoyuJ3cfSR2AjjKgz6qgGty3CBrQDEWrnnACF0
 i4I=
X-IronPort-AV: E=Sophos;i="5.77,272,1596470400"; 
   d="scan'208";a="251026492"
Received: from mail-mw2nam10lp2107.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.107])
  by ob1.hgst.iphmx.com with ESMTP; 18 Sep 2020 07:50:53 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dwe+1AhmJZyru4869Tbb2MdlVgj/br5qnVzJoU//aT+sBNFwu57HcIs+MkbNRJik41+3E7kpkviJwydhAl3c+fC+cLoBT/mbIBHWlINKugt8XYuoATNtGNML7W844sZvNKVtQUgS6QBiYXt9WBkWok4gKt2vf+ZEDxN6FntPuubXSykRh+CWxU/V992j7wKIcd4G0LhFh+ZVYHRU20WerK3+jLBp1anRBw2IxUxZDrds/t9HtljS2X84zjR3T3sJ0qXdTNna58VnpW7htu076mBPuKUsNooODGUPhLTslHCDGcyMxbbO2yoj/6bWeZMODJhRqUOaScAjDrcMc5N0LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8lMi3QJapMJED0kjBj6LLbBJL8keHFV/nYLife8+mk0=;
 b=gCQviaL4yuOJMw1Pp77qLs58xa4CWhLN8WYp1x8DTd2XHOsqjH9mxAgbK3NeKHu4OJPFBbc3amxeevtEzb+9RI/QBw3BqyT48yDQtnuhlA8dvolbQ2tSMEHpxFyQjwF14MNgxD7bviauPnsORhAjxGDUixmnOOdDHk9wjQTu4qckp86qfVC6hnC0GwUfgmUSUtdqKh8rBew3Ol1SQgfK158Qeo6tUtDUMobYGpggKSHkDIpk+XxcqCjN4+ehm0N7etfh/3Xjz7/RJM+oDuF4fIGzoeYKghmqhIbg3lm1b+eNXNDSofPRqMhTvEcvHlDVlboc8yX3HOxSMC7sE5dfVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8lMi3QJapMJED0kjBj6LLbBJL8keHFV/nYLife8+mk0=;
 b=NqfsqC2jUeD4HS38qgOt8V8vQyDXaCsjHxonR1kJmqPY0lGjnnyIOch3f+JwttU9Fp6ZpRBoyFEi1+4/87A6EqM8NdwkqOqTRjEwC2KXeOAczjK6KZws8D9d4O+GxzvRzdb8dOGNhJQzALTmm8/5nby0FobMRMwFzT6JOmAPojM=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB0758.namprd04.prod.outlook.com (2603:10b6:903:e4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Thu, 17 Sep
 2020 23:50:44 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::9124:2453:fe9c:9a7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::9124:2453:fe9c:9a7%12]) with mapi id 15.20.3391.015; Thu, 17 Sep 2020
 23:50:44 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Sasha Levin <sashal@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] scsi: Fix handling of host-aware ZBC disks
Thread-Topic: [PATCH v3 1/2] scsi: Fix handling of host-aware ZBC disks
Thread-Index: AQHWizKYugjPQJBBvkOKOwpDX/vtCg==
Date:   Thu, 17 Sep 2020 23:50:44 +0000
Message-ID: <CY4PR04MB3751FEC907B8C0FD50B53624E73E0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200915073347.832424-2-damien.lemoal@wdc.com>
 <20200917155335.19CBF21D24@mail.kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:c162:b6b0:12c6:8cc]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 416fd3c8-02bb-4d25-28cb-08d85b647e13
x-ms-traffictypediagnostic: CY4PR04MB0758:
x-microsoft-antispam-prvs: <CY4PR04MB075846E0E8381FF5EBE85E0EE73E0@CY4PR04MB0758.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M+UthBem+mHkC7Zsui1H/oE5DfhhMUzNGxxvwIR1JQFeFFpUC+YZmH3XKais74RBjlXZBnAdAhRJ6JChZyvfr/iIGJT7ZfMoXlF5sGnSUjyTDw5HLIhMkymFBT/PMbD6+eW6qV5LZaBlJpopbOEXuCXnzW1emwNTQq5bd6qPYJzuW/y3RprLzGmNNbCXMDnUnS4dTBleS1hq/PFTR/pI+H8i/smHNeUZjTLlHYzOpZdxYZHbVPn9NMGvi+PCXLqJCmbsQoIdEWq+gJbea4ByOfQmoBbUQoOJMJOKqg3dytSmrbe3Ovf6Ueh2xt1U7/c6ZaRFLuo08Pz38UCTAWmjZpfV2lKU7aDcyqkGbThMexqspMKeR21lijTMxm9Xcxjj
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(366004)(346002)(136003)(86362001)(8936002)(64756008)(66446008)(66476007)(66556008)(66946007)(8676002)(33656002)(76116006)(2906002)(91956017)(4326008)(54906003)(110136005)(53546011)(7696005)(71200400001)(186003)(6506007)(4744005)(478600001)(5660300002)(83380400001)(316002)(52536014)(55016002)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: P7U27qeWfgQGo9KjPAOWQ52NKJME6JzPNu1pXcTcu31ju2QDualMqeXARESNiF7NWDkJVqAO7k8kyPVeqn2Ns0SgaBrEPNqcULUzBnn9AYQUZuXDQXo94eRXl1BG6i8A8Ycoi4hy8PzJPgSR6xbq7It26yhq6V17+p8ACmvfLRTG6GdVNs02BS6M97uzwJHFqkAPs5X0zDLioN/ZOydxUCmL+c7kQ/g+eQX8jxB4Uw1zSNsatRUaiqfnqKPb3R5vfImMVhhSLAk8npuHJT5zl+v6eWbMu1+VN64eQARoKOXerY7I8OIhv8qyfKyGVjQkeohvmPEp6lAYOALc7L0sEhq+70QbSmzsYnxPo6Hunl5kND+sMTyKrVV8XyBJ+nW6UFZI0PRUXW/3Aw1Qhg6ZyiKmmc7z54DBnzjkHWC2AHZoQ/v0dolgHPdJ2fiVdWPpUcoH+IHs2J9aLygBQTBz/u7RdV2vqLDTinokCXklrwQasnKgL/bT5U8+MRQiY5R/4IKhZ9Jox5oxpTwj5GoHeNgZU2v0FDm06wNfte7XloiAAMqccAqZ2GeR/dvHfEJ8KFOXMroYzVOigbhR7oN1dyJGijteNV6HkBFTYXWZsyPL89Yv5FGv6ro6e1GHwxby2vvMZzRas51pKt7SJnAr+kqOrQlrSQ4nQzqQnnl86sBaVcnjElFxIMfiI6doGvUa0xg53+DI7soDH6gaNTPKoQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 416fd3c8-02bb-4d25-28cb-08d85b647e13
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Sep 2020 23:50:44.1467
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Lw2Isp04mU+YDdYO3W6ogJ43GEzMKWT68SEgv2Ec5HyhmNYE6/uA5iCknmHOa35HcfkUiPpas0kcr9B7qcOrOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0758
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020/09/18 0:53, Sasha Levin wrote:=0A=
> Hi=0A=
> =0A=
> [This is an automated email]=0A=
> =0A=
> This commit has been processed because it contains a "Fixes:" tag=0A=
> fixing commit: b72053072c0b ("block: allow partitions on host aware zone =
devices").=0A=
> =0A=
> The bot has tested the following trees: v5.8.9.=0A=
> =0A=
> v5.8.9: Failed to apply! Possible dependencies:=0A=
>     a3d8a2573687 ("scsi: sd_zbc: Improve zone revalidation")=0A=
> =0A=
> =0A=
> NOTE: The patch will not be queued to stable trees until it is upstream.=
=0A=
> =0A=
> How should we proceed with this patch?=0A=
> =0A=
=0A=
Usually, I wait for Greg's bots to ping me and then I send a fixed up backp=
orted=0A=
patch for stable. Would that work ? I can backport now if needed.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
