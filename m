Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F44E5A0EDF
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 13:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238494AbiHYLTm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 07:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241413AbiHYLTl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 07:19:41 -0400
Received: from mx0a-0014ca01.pphosted.com (mx0b-0014ca01.pphosted.com [208.86.201.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CADF0AF0C9
        for <stable@vger.kernel.org>; Thu, 25 Aug 2022 04:19:40 -0700 (PDT)
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27P7wesD024490;
        Thu, 25 Aug 2022 04:19:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=AaNIu31JQvuTXLfpDlqg1QssVigwuu61E8Cxr+wcEY4=;
 b=pK/GW0u1AMGwhD+syUmuX4RI/wxsfvHIY5PnaSQO8IzfhDcStylj5cvbc3UyATzvSJJB
 tR9hHH/ApgTRMk1btODHfzdpjaU/6Xx6qOPjN416q8QDh6VF83NsTLWoa+Cm+boLCiR1
 Yv7Nqbwg0E7xeroz7ppODRnT+9oswjcAVv2NPQteNA4Pm4DbnwgCdbgOzhhGQBltIQXj
 2dhGLOtI+Z30dpCw6GB7W8O8J3JsD+79oVhsYo4xcIKxKtBbTU128d1qPoZhQB5640qm
 dFhLXXjPdhLY07smuY7lFVOYSQ5JuYpptzeyDjne90mxVVw5DTuamuhJZar1XqYGH3TK 7g== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by mx0b-0014ca01.pphosted.com (PPS) with ESMTPS id 3j59t28fwt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Aug 2022 04:19:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bD82AGeBS3I+OFWNHGju6hlzMy+KdRs03wJddCUQAyp3HuRZrU30wW//TqCnXfKE6YJMM/6CFubmvtVyJA/F8Gc2jF/tSPe6zgwd+nKseMJtZHUtfdnoIlvH6HTc+lpX0VtpyvPLGqalptuYSOzSXeOakWsRTCd5kJnhHmbOWSkwGIn1SdwplakyaBFVIQsb0uMY6Az0FpuQYVPGDWJNQEZ8+CAdQz6Y48A8/Otwrlsk38tVtpjhKppw7a9MVmvZi48DqJl4FKjLFR5pxmr+nUN3P49RjCez7Domwr+4eiG+bmCfxIzdkuFFgrPnj2g1mwdEZpvZgkTRVv7mo3Axag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AaNIu31JQvuTXLfpDlqg1QssVigwuu61E8Cxr+wcEY4=;
 b=jtHebsXKz7HxV5T0i6LCc17XC4+aMN6uzb4KlUMIvwCBFG0kTS6ZlBwaAtNLjDfrmKkvt+tWU+s4/TTMKI2u1qXe5+HQylJd+nXEjWBkhkY0fc80gNhPpmKrwf30q2cfNxjF5AAsOu7KTdNn+qToB6Jg8lSerdEuU+ak0m9mxEoxGbRrCh57qvmsb5ICziSzXY0MkIeSV+nD878OQEz3p06p75GbBFwe9Gg9HHaB4LLb0q8H74JpIachL7acX25qz6TzZqG6pRptmt2ux7dmvKojDJIN159mTnH9jVyx1nX/twBO8v230cyqCyKbbGjCzUiXCM9ERgJUD2Bo6oOq1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AaNIu31JQvuTXLfpDlqg1QssVigwuu61E8Cxr+wcEY4=;
 b=yC5W+n9eL4G6e2k5vtL2M4g5Tub4n0m3hA8BcsAlnnfOhG0wtE7GdeT8svATcCBR06w9lFZyi6+L384tcKyOfkSiAbhmPQs5kIU1V6h4Nk1xtFizm7u2WsYrJTISJ9AUeLQ0QPSwJZZghZ/GAVJtDR8Wut2LAj1UESB7zuADgSw=
Received: from BYAPR07MB5381.namprd07.prod.outlook.com (2603:10b6:a03:6d::24)
 by DM5PR07MB3610.namprd07.prod.outlook.com (2603:10b6:4:68::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 25 Aug
 2022 11:19:33 +0000
Received: from BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::9822:423f:52bc:eeba]) by BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::9822:423f:52bc:eeba%3]) with mapi id 15.20.5566.015; Thu, 25 Aug 2022
 11:19:32 +0000
From:   Pawel Laszczak <pawell@cadence.com>
To:     Pawel Laszczak <pawell@cadence.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Peter Chen <peter.chen@kernel.org>
Subject: RE: [PATCH] usb: cdns3: Fix issue for clear halt endpoint
Thread-Topic: [PATCH] usb: cdns3: Fix issue for clear halt endpoint
Thread-Index: AQHYuHOiBhWb/vQuOUyfq9E2un4WDK2/duEA
Date:   Thu, 25 Aug 2022 11:19:32 +0000
Message-ID: <BYAPR07MB5381C9E9D86FB39C28456D24DD729@BYAPR07MB5381.namprd07.prod.outlook.com>
References: <20220825111235.29250-1-pawell@cadence.com>
In-Reply-To: <20220825111235.29250-1-pawell@cadence.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccGF3ZWxsXGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEyOWUzNWJcbXNnc1xtc2ctYzkzYjY5NWEtMjQ2Ny0xMWVkLTg3YzMtYTQ0Y2M4MWIwYzU1XGFtZS10ZXN0XGM5M2I2OTVjLTI0NjctMTFlZC04N2MzLWE0NGNjODFiMGM1NWJvZHkudHh0IiBzej0iMTkzMiIgdD0iMTMzMDU4OTk5NzA0ODQ4NDY4IiBoPSIwV2pTRHMvWGt0Tk1ORHJnM2Y4S2YrVUJDS0k9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9cf8bc96-dc07-4461-5c7d-08da868baf79
x-ms-traffictypediagnostic: DM5PR07MB3610:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rHsubIXi5GeqBjxE47pEIqRSVEP2nik0RXzxr+cJlHDz6sezuTvNtny47O3J3G8yKLzM3kHmf2ICHU2bgMqn01J1iuuPadSYs4dLMnjBgpcaJVwytkfxhM2Gh0rTGcMvCmH2WqG9soP+SXTdRxSojb/GDNqvh1xVjr5ewwGVnSxeELtrMTgYZRAP9v5gtTYrJoh4CQE/7/kssqsA75MJTpxLpb02L/BspEg5U/U8hKMrpm2j59CQRZezbOs8pjxoYA0QoG7Wy9uun2RH2pAGWS5MoYg5E4yV/oBxTstut5N3UFHbJcHUnBPEcwhWr8FTZPyZSNXaSdMgZ700ubRUTr/Jn2FIWzCAOiEE/sKeMzp4sYKL9ZoyFiNIMnCLSDHD27CRLBIm6hpLfyz69F9Q9+Fxjsi50beWHOnavGhaFuzv6O4xTeLpR0NCL+HUuCAkEtQGpGSujutIxcNW6YLOfgxy1PSE/MQ3s0FiV6iPKgBKQMPpujau1LxvGJFBY8H2EO8uwK9IOv+QYRfyxpj47EhC2rAmcd/IQwd2+6YJOgY+BD8niORac8z702eE7SC37Qo0xu2EJrQa2B07dUFZuUBf7XJk88AlqZRMZJzATzRdkEo0PDYOJ7YMla+3D3bn/5OwBWAKF9F3NmuDkQvPG+87drJLG+1C/VnnfbIZdICqUzuWInKevUXaNXDnrVk1PEnzojx1w12Rl5p5cjrWOFdvnXpvfJzoLmfX1Lm0cZz2dcabKl9liR7JZD4TWFVI7yVQhHmryJ7Ta+icmYmHIQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR07MB5381.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(39860400002)(396003)(366004)(376002)(36092001)(38070700005)(186003)(122000001)(83380400001)(2906002)(52536014)(6506007)(71200400001)(33656002)(86362001)(7696005)(26005)(55016003)(478600001)(110136005)(4326008)(8936002)(8676002)(41300700001)(316002)(5660300002)(66556008)(66476007)(64756008)(66946007)(76116006)(9686003)(66446008)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7ZuW4ZGPjzrnGvaCtHZPpF9rnaczJyly1aQzACBnu8q51tHU947alNaihrph?=
 =?us-ascii?Q?EP6oVc7uBjOauQts9gKXaHLdiuX2Y2i7J4oJ89TdKjfsKOlsgwr04ayp82wo?=
 =?us-ascii?Q?Iq87lwphwfnipncknWCN/CKrIbMGMsBoxuJQM1fr/XzafquJ12U4dYo08GTr?=
 =?us-ascii?Q?DHrjuAp2htDlES9XpmM7b65dFty3ULk1ODVlEgsrljAFrsz/j3UZf112/0KD?=
 =?us-ascii?Q?5C6jPRmWV5w/MDK+QAAB7oaj0qBvN83TZCuNNtRqicVwKf0+6VCWo+MohvDq?=
 =?us-ascii?Q?6a4G02yViKOkJSusd3o9X4xl+EEaj4lL063FbDNm0Z4nTHmexywCdeSZ3SLv?=
 =?us-ascii?Q?ee9pspWXztqa/ihO1VL5xW9xDDNy807YXslLx7QsU37uEXA0GLK9/oVdrlxI?=
 =?us-ascii?Q?Pk3ywRMPcXz05wHDv4csHDakNu/DmwPho+t+dasmMZsAW3DX9v9evs+d1lfX?=
 =?us-ascii?Q?/hHhuHfI0DUgLOBTDiMHDBEYa1XMZ8cponsABcLwvvPNxl3Tuyc+eGE+hMQT?=
 =?us-ascii?Q?YKKifnjAeYvVWjTKGnam0Kagzpe2saxrcDSSz1LJHQZN/y6byVbaly5fLUoP?=
 =?us-ascii?Q?ltsohYFCg5+Xbs69VH8OcoPoJeMLnL8TxuqE9NsAfp10BUscpdM+wPR75dcs?=
 =?us-ascii?Q?5aQkYldMRqcY/uTkTxBk7pZj97s88lfHyUdejKrFPsFsaZ8cyWPA0pV4z1C4?=
 =?us-ascii?Q?WhPu5AMwz/+bhyImrqbQ9aP7LWPToWJ6Pl5B/B+V1fv7/lZ7fsWNRmmI/uqu?=
 =?us-ascii?Q?nVDsK24UXkNfuZUwZn3Xy3WTGvLlRsoCHgm4ERHFaJi2E164CbC+cFtJideR?=
 =?us-ascii?Q?dwL/x01cLjsA2+Uo2Am0xqZ2OyjVsEAKX7KHorQyTEa6CXIZTx287611JoAa?=
 =?us-ascii?Q?VTrYVQCGevTAhrYf99VeHJoEZlKWxKbcr5y4cuKZ3Uu748zcOi6kSw+5LQeI?=
 =?us-ascii?Q?g24eXZ85mImtJArGeXt2PYsuomKhuYe6quWevlWT6m+w2wO8mBGtZ8s33Okj?=
 =?us-ascii?Q?jgiMhV+lVhmsGrzHdwUJoMN1NxiGUukBZDrwIDB63ddwGlWqOmBPhBtDhGHw?=
 =?us-ascii?Q?h6MCWwnle/awXyCD37ARR6HMMZpRcFdgFevgt2+1nDRp6RN/8iGU3kL7VtwI?=
 =?us-ascii?Q?M1HJEiBPK9wGKAn/QFEG/4mVIHqb3tlynPrs92c4w38w/HraBSELX2nyCknN?=
 =?us-ascii?Q?IdsOWAVx6TsGFyAeq7BNbu5lOV29MOkxNPeT2nY3Bqf1+wCAn/00SaEWigYe?=
 =?us-ascii?Q?m17D7HBnurIUU9nEngVVEg4czLqlczCylRMzBsiAmOJmb8cKBoGzD3Q/RLnc?=
 =?us-ascii?Q?7Ip1pH1zCfDa9dz2tRrTvzXlVKJ/AwoxgmmG2CkOgGqyvt4QEleO7BO59/KM?=
 =?us-ascii?Q?aqEP35v/quDHc0rmVYGVn3nYgm4k0mXj/nluP7C7d+zsHdcPG8f55GnLJx/u?=
 =?us-ascii?Q?M5hy7nyQ/GPWYFhTSDlD0uSDBruH9LSd/NWSVDw1IJyeBX3ej2x4qi5RHfU0?=
 =?us-ascii?Q?gCGEQZ4GT/S4KeMAqZfOkF49RZk52mqNlce6MeADiZkv4fDJW8svlBgRIOX+?=
 =?us-ascii?Q?g4An+wGZOm5Hebeq4Gqzw69xVmZFLY5S7aA6wpNSgN+cXGYgBdlHCtndAfRF?=
 =?us-ascii?Q?OQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR07MB5381.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cf8bc96-dc07-4461-5c7d-08da868baf79
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2022 11:19:32.8420
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: on+JhO8JutUH7Z4dp5Hi/Fy5ZCKvSgicdjEZ6MMz5X6IT7qi+LJs9RCssh1IpCogW956gCWbJueH1HCzqbJdq4M5K2yMfgSDsOXAT7AvgHk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR07MB3610
X-Proofpoint-GUID: JQ0-wohsTQDHDTtT5TLdQPCojMSfwzOA
X-Proofpoint-ORIG-GUID: JQ0-wohsTQDHDTtT5TLdQPCojMSfwzOA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-25_05,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 clxscore=1015 suspectscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 adultscore=0 phishscore=0
 mlxlogscore=683 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208250044
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hi Greg,
=20
It is backport to 5.4 stable version.
Please apply this patch.

Thanks,
Pawel

>commit b3fa25de31fb7e9afebe9599b8ff32eda13d7c94 upstream.
>
>Path fixes bug which occurs during resetting endpoint in
>__cdns3_gadget_ep_clear_halt function. During resetting endpoint
>controller will change HW/DMA owned TRB. It set Abort flag in
>trb->control and will change trb->length field. If driver want
>to use the aborted trb it must update the changed field in
>TRB.
>
>Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
>cc: <stable@vger.kernel.org>
>Acked-by: Peter Chen <peter.chen@kernel.org>
>Signed-off-by: Pawel Laszczak <pawell@cadence.com>
>---
> drivers/usb/cdns3/gadget.c | 8 ++++++--
> 1 file changed, 6 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/usb/cdns3/gadget.c b/drivers/usb/cdns3/gadget.c
>index 296f2ee1b680..4990f048d30f 100644
>--- a/drivers/usb/cdns3/gadget.c
>+++ b/drivers/usb/cdns3/gadget.c
>@@ -2166,6 +2166,7 @@ int __cdns3_gadget_ep_clear_halt(struct cdns3_endpoi=
nt *priv_ep)
> 	struct usb_request *request;
> 	struct cdns3_request *priv_req;
> 	struct cdns3_trb *trb =3D NULL;
>+	struct cdns3_trb trb_tmp;
> 	int ret;
> 	int val;
>
>@@ -2175,8 +2176,10 @@ int __cdns3_gadget_ep_clear_halt(struct cdns3_endpo=
int *priv_ep)
> 	if (request) {
> 		priv_req =3D to_cdns3_request(request);
> 		trb =3D priv_req->trb;
>-		if (trb)
>+		if (trb) {
>+			trb_tmp =3D *trb;
> 			trb->control =3D trb->control ^ TRB_CYCLE;
>+		}
> 	}
>
> 	writel(EP_CMD_CSTALL | EP_CMD_EPRST, &priv_dev->regs->ep_cmd);
>@@ -2191,7 +2194,8 @@ int __cdns3_gadget_ep_clear_halt(struct cdns3_endpoi=
nt *priv_ep)
>
> 	if (request) {
> 		if (trb)
>-			trb->control =3D trb->control ^ TRB_CYCLE;
>+			*trb =3D trb_tmp;
>+
> 		cdns3_rearm_transfer(priv_ep, 1);
> 	}
>
>--
>2.25.1

