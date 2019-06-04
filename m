Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3E5733D5D
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 05:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726223AbfFDDEJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 23:04:09 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:60704 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726076AbfFDDEJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 23:04:09 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x542tvQK000344;
        Mon, 3 Jun 2019 20:04:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=unhx8NRTUbXuqBmrTMa9hXJj0NkRcaeMiEyye/d8ddE=;
 b=GBjCdM45TS/UJGhZk7wp0BvD+vw+SRE4j1y6ODDM8iy2TsnJCfBf/33Hg9y2nLKCzSl1
 Hs+kDyw4awFH5tmzSu7IfRwaybSmU8tlmX+XSe12d1KH1v0kuMdi0h5dSYyPaHNJhm1i
 ZsPb86rjKVYuWweDOwSsj7wc/xQ9e7hdfICgR1SdtiTYJhE+2SbcKfEVGWlFp6BQ0FiY
 4RH33kNqJ1eQGeCXXYZiHe78HVzejc6bQuzdDgPFBJ+Z4b4xERApVw/vu4oqAZNgrusc
 CpnJU73Utt7+6aoXG7ILHdwcPy+kVV/Hx9LDet9OsOM8Kb4YKnv2FgxgFXGpItZuSEzw VQ== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2swejx8cy8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 03 Jun 2019 20:04:05 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Mon, 3 Jun
 2019 20:04:04 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (104.47.32.55) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Mon, 3 Jun 2019 20:04:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=unhx8NRTUbXuqBmrTMa9hXJj0NkRcaeMiEyye/d8ddE=;
 b=IYVmL2spx+KW5rCGXOgWSpZ8h1nucxr4/ckRPIEmWFnSHxGzW/wnAnxCy2FAHlANfkVAg35CTR8bd1X6iUIcwB9ub4crL/KvKnwo2oijHkezm0Fyo2YWgblbJ7ObS29Rd5YdaQw2S2x6cRztSXzz08gHZhfNuMNBx9gO/JZQgKA=
Received: from MN2PR18MB2637.namprd18.prod.outlook.com (20.179.80.147) by
 MN2PR18MB2752.namprd18.prod.outlook.com (20.179.21.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.18; Tue, 4 Jun 2019 03:03:59 +0000
Received: from MN2PR18MB2637.namprd18.prod.outlook.com
 ([fe80::3c77:9f53:7e47:7eb8]) by MN2PR18MB2637.namprd18.prod.outlook.com
 ([fe80::3c77:9f53:7e47:7eb8%7]) with mapi id 15.20.1943.018; Tue, 4 Jun 2019
 03:03:59 +0000
From:   Ganapathi Bhat <gbhat@marvell.com>
To:     Brian Norris <briannorris@chromium.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Amitkumar Karwar" <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [EXT] Re: [4.20 PATCH] Revert "mwifiex: restructure
 rx_reorder_tbl_lock usage"
Thread-Topic: [EXT] Re: [4.20 PATCH] Revert "mwifiex: restructure
 rx_reorder_tbl_lock usage"
Thread-Index: AQHU1VdpBggtVOS6I0GyhcvAXdDin6aLWDtA
Date:   Tue, 4 Jun 2019 03:03:59 +0000
Message-ID: <MN2PR18MB26376D3A660956396D0E60AFA0150@MN2PR18MB2637.namprd18.prod.outlook.com>
References: <20181130175957.167031-1-briannorris@chromium.org>
 <20190308023401.GA121759@google.com>
In-Reply-To: <20190308023401.GA121759@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [117.241.207.104]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3f628d0d-b000-48d8-cb20-08d6e8994a77
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB2752;
x-ms-traffictypediagnostic: MN2PR18MB2752:
x-microsoft-antispam-prvs: <MN2PR18MB27527162C73774581B2842DCA0150@MN2PR18MB2752.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0058ABBBC7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(39860400002)(136003)(396003)(346002)(199004)(189003)(66066001)(33656002)(66446008)(68736007)(66476007)(64756008)(81166006)(81156014)(66556008)(76176011)(11346002)(8676002)(8936002)(476003)(446003)(26005)(186003)(25786009)(76116006)(54906003)(73956011)(66946007)(486006)(305945005)(7736002)(6506007)(71190400001)(74316002)(4326008)(55016002)(5660300002)(52536014)(9686003)(53936002)(6436002)(229853002)(14444005)(256004)(71200400001)(86362001)(7696005)(14454004)(6916009)(6116002)(3846002)(316002)(102836004)(99286004)(478600001)(2906002)(6246003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2752;H:MN2PR18MB2637.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: P8LEtjR4Y6kHJSS9kkMn0nTRulfCP9gmuxGMu0frxW3I4xPsdLj/0bU/ImbXUZIkUcV7DHlAgkJwZgDKcs7g4HBDkexu1aOKvleGjxWus1cCH3bVwaQ2GY0X5xwZSWeuc5Ospu/Zn3/lAiUq/6Ixue8ji0O26yGTMU4KefS9qor0b+hgu3cZ6jUIWo8e+ax3pIAvXOSEc/5FukvLpyeieo8LbZfvL59oIqVBkYowhrF0dkno3fmmcowNKKyPT6EC9roLcUs8x+AmlcDCmSGua27x0vVOsDjqSGc6HxXQnu8FtwTiJisOvP2LGSVM0DRSAKdc2xJtelHS4E1Kt8dCPLfsj9xyjk/LHBFOI5YGKqs7bWvn7byxkMV2ObimYyPrYq1eJRtmbmYNv8ebyyydn08dov1Dssikp0m2H1rWuRQ=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f628d0d-b000-48d8-cb20-08d6e8994a77
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2019 03:03:59.6029
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gbhat@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2752
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-04_03:,,
 signatures=0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Brian,

> >    netif_rx_ni+0xe8/0x120
> >    mwifiex_recv_packet+0xfc/0x10c [mwifiex]
> >    mwifiex_process_rx_packet+0x1d4/0x238 [mwifiex]
> >    mwifiex_11n_dispatch_pkt+0x190/0x1ac [mwifiex]
> >    mwifiex_11n_rx_reorder_pkt+0x28c/0x354 [mwifiex]
>=20
> TL;DR: the problem was right here ^^^
> where you started running mwifiex_11n_dispatch_pkt() (via
> mwifiex_11n_scan_and_dispatch()) while holding a spinlock.
>=20
> When you do that, you eventually call netif_rx_ni(), which specifically d=
efers
> to softirq contexts. Then, if you happen to have your flush timer expirin=
g just
> before that, you end up in mwifiex_flush_data(), which also needs that
> spinlock.

Understood; Thanks for this detail;

>=20
> There are a few possible ways to handle this:
> (a) prevent processing softirqs in that context; e.g., with
>     local_bh_disable(). This seems somewhat of a hack.
>     (Side note: I think most of the locks in this driver really could be
>     spin_lock_bh(), not spin_lock_irqsave() -- we don't really care
>     about hardirq context for 99% of these locks.)
> (b) restructure so that packet processing (e.g., netif_rx_ni()) is done
>     outside of the spinlock.
>=20
> It's actually not that hard to do (b). You can just queue your skb's up i=
n a
> temporary sk_buff_head list and process them all at once after you've
> finished processing the reorder table. I have a local patch to do this, a=
nd I
> might send it your way if I can give it a bit more testing.


OK; That will be good; We will run a complete test after the patch; (OR we =
can work on this, share for review);

Regards,
Ganapathi
