Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 861EE472D0E
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 14:18:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233634AbhLMNSB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 08:18:01 -0500
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:8586 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233626AbhLMNSA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 08:18:00 -0500
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BDAhVw7015025;
        Mon, 13 Dec 2021 05:17:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=y3CnN17TdbMOeQ6O2EZ2JiGaYT3+CBAecJ5ubjqELPo=;
 b=bryRVoQgxrcdD2wIyKC3FQPHzuujZB/K7b4WyOjnTZ2ecPITY9mui5QXdovIRrfo3K+0
 yXqoVOx5V/98vUUa3vNbyoYe+qpK5nia1Q424HMECyvoEX0oQ2fYOHypCo3xmPZa4BXT
 ybJ8nmnpCkVBvYcf+UMvmL+y4xF+m7e+Ff854RrZSPLGEUtxYR7dT8f4PBmLZdqjC9gs
 sUp3r/fDNEa32rKWNdQ5YZ2T2z2Ib4IbVEPQ5NumUW//0SKm/nnkYAciMfgcfdyBBPq3
 gcrCwvWZ+p4VlC8DJSbFTxQyFSEsuw7+Rn8rpMNY4Ed5PIMTC0RfZEMk/PeduZ2dTiQM iA== 
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2045.outbound.protection.outlook.com [104.47.57.45])
        by mx0a-0014ca01.pphosted.com (PPS) with ESMTPS id 3cwc3uky3j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Dec 2021 05:17:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eUSZK+KLsy5HK3zNMKywf0hX7ycayDel3sRCj9QEF/nxRdyNQKRbEaEChCJP7ifEgqtgax+n+dySsjzftk3/XcMEmJeJDNew7igdm5rOHgnxDZ6ZOQo29JAG2Jvvw8m46EsotbzCeqpGdE+SiaSirNFDPpbAZ8zIuVXGUiPb9zzLxOxk40ENsylFYrkcMLb386x6w9zWCjtxdeGCOyn30WDGXWi0RN/uAab2XAJ7iHoIdTp20AyQ04VqiKYj5YI+mAH3RT0XKdsTKtD1N2RHJs31Kmv229MAtJdHtY3gqjnVMuxgMjvWnwsljGt6HUGqkVmiObsSN3HOVKzkm9iCZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y3CnN17TdbMOeQ6O2EZ2JiGaYT3+CBAecJ5ubjqELPo=;
 b=BvLG+nVSH0AQitLecFrx9ZfUM46GzxwlrICrKDJdbGSbeaHbSUnkfspPXUyQw9vkrrF5GtVOZFqL8RuNf+oG3+ELXEyF84SxQZmqvpu6k/dPeU6EZVWMive3zJwK7V83ArEzKo/S48G/UjrhHxiQRSzzf5wiiOHXbl//wvpWatgZdP0GTkV7Xh69K1OSMq9L/dPFuLZBxsx2JJINFjlaMrgDxQ8Dur0DjYFu32LAGnNsPS9sEs3BeTTFstTWc7d+9P0gMYP0no/HbBQbubhkkejqDYs2H+VnaBaFws+Wl3x7pio9GBjzTj10wXQJDDBfKFBbtdPbqG2/i9pvHuE6lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y3CnN17TdbMOeQ6O2EZ2JiGaYT3+CBAecJ5ubjqELPo=;
 b=P+JLBtJZ2MkBsYffjLz1dNc0v4IPyYkbfLUl59bgIxwYvFq13UUfNl4xsb1I5BQ9Ha2XIitTQ4k1j1PCTGZ85Yz8ug7x/duJ/zOm3GMFcGcYRTNEWW7qme0V1bJCOPi0UigSVwr2Zdmb8yUyOd6abPJiI7x/5lZssgvTcbFWUd4=
Received: from BYAPR07MB5381.namprd07.prod.outlook.com (2603:10b6:a03:6d::24)
 by BYAPR07MB6071.namprd07.prod.outlook.com (2603:10b6:a03:13c::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16; Mon, 13 Dec
 2021 13:17:53 +0000
Received: from BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::241f:218b:e5aa:9024]) by BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::241f:218b:e5aa:9024%7]) with mapi id 15.20.4778.017; Mon, 13 Dec 2021
 13:17:53 +0000
From:   Pawel Laszczak <pawell@cadence.com>
To:     Peter Chen <peter.chen@kernel.org>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jianhe@ambarella.com" <jianhe@ambarella.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] usb: cdnsp: Fix incorrect status for control request
Thread-Topic: [PATCH] usb: cdnsp: Fix incorrect status for control request
Thread-Index: AQHX60t+MP74NKbCqkG7HRhxiNimOqwqCsQAgAAVavCABky7AIAAAgcA
Date:   Mon, 13 Dec 2021 13:17:53 +0000
Message-ID: <BYAPR07MB5381078C05112F8453C4914EDD749@BYAPR07MB5381.namprd07.prod.outlook.com>
References: <20211207091838.39572-1-pawell@gli-login.cadence.com>
 <20211209113408.GA5084@Peter>
 <BYAPR07MB5381415E88BAAC945CB47A93DD709@BYAPR07MB5381.namprd07.prod.outlook.com>
 <20211213130258.GA5346@Peter>
In-Reply-To: <20211213130258.GA5346@Peter>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccGF3ZWxsXGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEyOWUzNWJcbXNnc1xtc2ctMTIyNmM3ZTAtNWMxNy0xMWVjLTg3YTYtYTQ0Y2M4MWIwYzU1XGFtZS10ZXN0XDEyMjZjN2UyLTVjMTctMTFlYy04N2E2LWE0NGNjODFiMGM1NWJvZHkudHh0IiBzej0iMTk5NyIgdD0iMTMyODM4NzUwNzEwMjY3MTM3IiBoPSJPdERVcEFJbC9ZSnhRUTlHNnVsSFBoblRVckE9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 43d94288-3691-4b4a-b75e-08d9be3af883
x-ms-traffictypediagnostic: BYAPR07MB6071:EE_
x-microsoft-antispam-prvs: <BYAPR07MB60712F2CF7A3F56777568C33DD749@BYAPR07MB6071.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jw/mPx71m0ZRgy2L71IJatcB5zhOTuMgyAEJTjqvsaaSHHPC24lav5RL6dcT4fiXFISbQHFI2cfvpgFeUa99fZ56ouFO5bHskwyvxEwXv3mXC+Vy/NyFuAIe6svQoSnQK4D4tfPoczr9I7vYxVkuxCaS9ASVtRZGHdvpQZlvw1WjS7Y5qDnkR56/bUUieivoDvkAvHvGmGpIfGPjEwVfy4kXPRQHO01+mwvqRbrzdFog9UJF4QDjwBqXnbkb/FAM0z5NzNPGhvjaiHX7FIMGzk2M822cYvnbo9TYbEKux0nmDtg/HAhwRm8F3RL4hULcmKVnrSNuzvi06/6LknNYCBsxhP97Xz5BQCiTZm9WmaD+/o8e9H8ePUBdmTvc2piJ3vHCcUhHPFDJvUTv/K1bPN+ejZ3HSRsc7i1dyWdhTOAJWKlW7iOcDQB+oWP/c2og4LQ+1oQRbVsRF28D49Jp9P8pAXhCtNTTcyWNGFgv8ru0NPY37YvNbzuZ9afMRFppi6mKDT1OG+Ox3JA0GKhpbxTxWEHojwYtuuexMdsybN9QwGMuu+nucOzHIsFj6JkjpRWPC9x+A7/lG7OVqg/v37NIUctolfJxkRrYxTyiTYALKrATvD00lFMjaMrQsw7iPyosy0aaj+eITN8+LDA97eCGciYSotguc7p3QIit3563NsDhbt+VD+ger1cW4wSTy9HJxCCHExn7HRPo/djg1wu/Is+1WWZghMdg5FYBMJE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR07MB5381.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36092001)(66446008)(66476007)(186003)(26005)(508600001)(76116006)(4326008)(64756008)(6506007)(33656002)(71200400001)(83380400001)(5660300002)(52536014)(7696005)(38100700002)(122000001)(86362001)(66556008)(55016003)(66946007)(8936002)(316002)(54906003)(2906002)(6916009)(38070700005)(8676002)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AxKUG9UJp5VYGvWXnc+mv3u9U0Bwdt/AJg2aCTm35LS2NwFAjNkLcaPPgU81?=
 =?us-ascii?Q?MAltrP157/NXsn7Ms8Jd0SBMqXFARqTp0Ar/rpQsxTBf6FYW4xqkNXqn1rr2?=
 =?us-ascii?Q?3WRuges9834vyXC8oJczGAjS+lUnURkARuRNR7nQyd7jPvaWLLjH1ndgQRdK?=
 =?us-ascii?Q?ORQ/PvURCsV9vxKiEp4iMukdWO5qwjf6+N9PZqeBVBh69oHTpWDmkPqv7z22?=
 =?us-ascii?Q?yMJhEgkyQC5UA1cIB9b4/86l/NRslWqL+69vMvUyQkZBRrA4N49papYfG544?=
 =?us-ascii?Q?Cmpn1KoU9+HZ3Rkvv0EFNFt+G8douw5NkBobX7UN8jn1IQjHc0H2JT+fiKa4?=
 =?us-ascii?Q?pyT+43ZNLqefUzJcG98bQShWVEeBJpNM86wuOzjc2DxBUBkFJ7nD9LA1+zhm?=
 =?us-ascii?Q?8HCsYi+pf3a5ZeeHpkZnQ/WE1Ux48xJuIlCBYkglPj08TFzx/UHI6k+kq3FB?=
 =?us-ascii?Q?OeEBfZ+IWp4hxOtAG12qINxT2Cw4qLyIGLm1UoZq5EQZM+FKpNbOj498umS1?=
 =?us-ascii?Q?v9z8K3LBYNQ+m7aM+KfD/T23iKJPicH1jOD3IweNyjSAccguj6ByA/9VvMco?=
 =?us-ascii?Q?cfuVf+B4+09YAixg6KkBZDDIlWr6eRXIJlfGElpwuIRJjThN6DYR3dHUC8AF?=
 =?us-ascii?Q?iKNAp/zUzgXJB0lRT643Xhk3Prtm0bAnAIRmW1oQB8yVn4uW2R8KJrHKkUs4?=
 =?us-ascii?Q?+LQ410bsvwECV1GXGK2wyORuoLFAp+gW/SIK6v0YYiEPrxZkT9kdB9HldFzU?=
 =?us-ascii?Q?19cj6vZPPxVd0mwumfEg/VE7KSdDxTZW4OePhX8e1zmSy1foZBhfxZ8bNvtf?=
 =?us-ascii?Q?O3Y+nP8xFl+rs4b+uhJLLoCY0byZ9lNGsdpn6MTTiE62qc2OjtJGktL2AD9Q?=
 =?us-ascii?Q?U8Muio98kx0hhIFgBofXRwcmD8Irl38ezeLJitt+cl6lyAUS4VsmD3TeA6+4?=
 =?us-ascii?Q?Hmx6d3DwhwtCRWPPzmqxBYCfwLRx+Doag+b//GwJ7ZtIMK80myII8y68j/kM?=
 =?us-ascii?Q?72Jk5nTm8pQhleQx7boF3cqUMEFpxPfrZVI+mTy9RtWVvbi8iqIE83nOwzkE?=
 =?us-ascii?Q?NXu/WkD5Hk0ORev2c7BnlP3v3IV4WvD1feBa7/+haMjpUYHE7VZaWoGkEgwu?=
 =?us-ascii?Q?MfNX61Xve7nxLxT9Ft74YUyqSoRWLAi8XIPWP5aQQTsKY9iUUl+BpBR3/j6N?=
 =?us-ascii?Q?Ihi1ar8FMrt4a5X3hgXEKX5wtj4v7+SI6bCe+UgLxAZInPx3Zc8OpaUdYLPC?=
 =?us-ascii?Q?BNZ7ldDXj/JD11YlyCxaJFGT1XIbCxNmuJgegSDc6YBwfEFPj9hBK7GwOZ+J?=
 =?us-ascii?Q?z9pzzZyWutmbuLtOA4fQ9qPfSh3hD5dsRdbahRfbCyqDEV8XZOJgtxYYdkdR?=
 =?us-ascii?Q?6HTBstW7ynI0+INd/ProVONA9J0RJG2FMLSYPE9sTc2jE2Ln1EVlpOv/GWPK?=
 =?us-ascii?Q?NDavPM6fc89PS8EcT6ZmVjI46t84qKxd9zlfLRfvArGACqyT9dXe+7QLqK0X?=
 =?us-ascii?Q?T2lQIFvT/y/kZqwBC7QLNaoTxSEZ4DfbxQQJMEn9FLVWo+FToXssE2v1wpeS?=
 =?us-ascii?Q?5AdP99Mjx9sJiM2cVoxzExdormxsVoMu+lLl5KlUts5YQ+dDFKXhUzrx+wTs?=
 =?us-ascii?Q?bPOTX66aYYd1Wx44JN2S2XmFlsotGcyczXku8hOzpXHrdPOq60QctbEFFd5q?=
 =?us-ascii?Q?uns/7w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR07MB5381.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43d94288-3691-4b4a-b75e-08d9be3af883
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2021 13:17:53.5038
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8bwvjEloyEQOt4DuDdge+q48XhHgZnaody2QMK4UXWEygrkr3G7YhGJgRBDfoW1QqcjiPFDWBzpv3yAIYQsDxq/gOydVolQ0E4zmLLvo5Ks=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR07MB6071
X-Proofpoint-GUID: lojRaZ2sAAuqDa7G9l2TzLoQd8iHEb2A
X-Proofpoint-ORIG-GUID: lojRaZ2sAAuqDa7G9l2TzLoQd8iHEb2A
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-13_04,2021-12-13_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 lowpriorityscore=0 bulkscore=0 mlxlogscore=699 priorityscore=1501
 mlxscore=0 spamscore=0 clxscore=1015 adultscore=0 suspectscore=0
 malwarescore=0 phishscore=0 impostorscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112130085
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>
>On 21-12-09 12:57:31, Pawel Laszczak wrote:
>> >> From: Pawel Laszczak <pawell@cadence.com>
>> >>
>> >> Patch fixes incorrect status for control request.
>> >> Without this fix all usb_request objects were returned to upper drive=
rs
>> >> with usb_reqest->status field set to -EINPROGRESS.
>> >>
>> >> Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBS=
SP DRD Driver")
>> >> Reported-by: Ken (Jian) He <jianhe@ambarella.com>
>> >> cc: <stable@vger.kernel.org>
>> >> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
>> >> ---
>> >>  drivers/usb/cdns3/cdnsp-ring.c | 2 ++
>> >>  1 file changed, 2 insertions(+)
>> >>
>> >> diff --git a/drivers/usb/cdns3/cdnsp-ring.c b/drivers/usb/cdns3/cdnsp=
-ring.c
>> >> index 1b1438457fb0..e8f5ecbb5c75 100644
>> >> --- a/drivers/usb/cdns3/cdnsp-ring.c
>> >> +++ b/drivers/usb/cdns3/cdnsp-ring.c
>> >> @@ -1029,6 +1029,8 @@ static void cdnsp_process_ctrl_td(struct cdnsp_=
device *pdev,
>> >>  		return;
>> >>  	}
>> >>
>> >> +	*status =3D 0;
>> >> +
>> >>  	cdnsp_finish_td(pdev, td, event, pep, status);
>> >>  }
>> >>
>> >> --
>> >I think you may move *status =3D 0 at the beginning of
>> >cdnsp_process_ctrl_td in case you would like to handle some error
>> >conditions during this function.
>>
>> I don't predict any other status code for control request in this place.
>> I wanted to set this status only once after completion status stage. It =
was the reason why I put this
>> statement at the end of function.
>
>So, you always consider there is no error for control request handling?

Not exactly. In this place driver handles only case when status stage has b=
een completed,=20
so control transfer has been finished successfully.  =20

Driver still take into account for  control transfer such errors as:  STALL=
, EINVAL and ECONNRESET but
in other parts of source code.

--

Regards,
Pawel Laszczak
