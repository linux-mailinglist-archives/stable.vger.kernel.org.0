Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B11C116610
	for <lists+stable@lfdr.de>; Mon,  9 Dec 2019 06:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725842AbfLIFMd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 00:12:33 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:61000 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725854AbfLIFMd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Dec 2019 00:12:33 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB95BPoN003998;
        Sun, 8 Dec 2019 21:12:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=ndwEEqqvZ4U7/P6HS/H9IeZkp63Nrae0Gd7LLEVaozQ=;
 b=ZzpNORYL/1gLpL67+wzPTNpMNGe2r9uhmkFODgDhPQgSbU3APCNnCiXB7JdBNwJA+PTB
 l8fsXQD/FKXm182OGrA+OacnPMHjyi3US+Z8s0nDUxLkSpqwUDWZQ7zb2/9+zuKoBSvQ
 91aPznU97Q3EGIOx0R3NRtj5gHJ7iVOJeZ4vF1zvm+SzcS8WmZ3EuRftveaHn8hmv2pZ
 xgbRT9t+k+WNUZ7BezwshR20RcUjC3/uPDSzXF96lB94LaAVxutbmGtNbDV4/sKByFQD
 VZNVQfS6hifVjcrVNTljJkgLiavufTNeTDcwEQp0Z5JUyaikrxlJoZPTM1rVCJ8zCxeT Ow== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2wrbawmjw8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 08 Dec 2019 21:12:31 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Sun, 8 Dec
 2019 21:12:30 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Sun, 8 Dec 2019 21:12:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lwkTUf+eOErD99VoIew2kOt0GICUJoeDpZUItmachz4pyLnf5tiiA2AFyKZYknkz08M6+zU5g1efHIvSpLrQZcsG93F0sLkHmP1UBeurDB4UKULT5HmC+mxMcripmh5ue6+paqDN0erj/wzUd8DEPxySKgoS4Zs8puAFe24wh+fXCMvmoXpVsnsx2xoE9m/xqlw0pdBeXGcqIlRI0LjiHEuLF/tItdt5KA2JdpIus3RUiGuu50BauTNKCpL24ozXQZHXHz1ACFGty5eqoN7CvaiqP1hS3QOKGKXKgqwuTRxnp7Y4Kk08phgq+vx1NygkVn75IbYdTqErmDBoR0P+Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ndwEEqqvZ4U7/P6HS/H9IeZkp63Nrae0Gd7LLEVaozQ=;
 b=k2ku8awWSHgV/qp7pCIi5ybDzKdwdWA3kotUXzw2Q7VzmbC9tvqGRZRqsQDCANX7jADD3YPPrSWgtnr4xuz6bxAe9Gf5lTSUmTKWDNX1kdLeqkcI68VZk8Fqkcr5lxJ5pUkJcCiAkh2cdaS2sOZP/HfWlgW2jm19wGwia7xWJudr3SYGADPaDwUt7OKefVvjO/effzT4iT5b3M0g75Y8pAXr6h0jzlasfKg/34fYabRvy153dOfQ1nXL5Cp/rQxmBcMBJZlintb9K//Dmcb/+S671gM2igNbp2yQ4Vbh5cOfmc78Yo0/mUNXpQ4R6anVdUt1eNdwlZfROmGsxGffgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ndwEEqqvZ4U7/P6HS/H9IeZkp63Nrae0Gd7LLEVaozQ=;
 b=Jdu5yfN6rH/+YH811SOCyhBd3+8cRHeibTdG00eVXYSpiEhhDFj2akxuKhsyN1VY1ptCdm2tppDP/x24PTOfi3kx2ZZMF85FWjyKtU/TnVO+4nGABR3JeQKba3jP5ny923CYhM6SHyugHbA956VkuOSGf8OQes14gAS0z/EL+A4=
Received: from CH2PR18MB3160.namprd18.prod.outlook.com (52.132.244.94) by
 CH2PR18MB3287.namprd18.prod.outlook.com (52.132.247.84) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.14; Mon, 9 Dec 2019 05:12:29 +0000
Received: from CH2PR18MB3160.namprd18.prod.outlook.com
 ([fe80::69be:199:ad84:8034]) by CH2PR18MB3160.namprd18.prod.outlook.com
 ([fe80::69be:199:ad84:8034%4]) with mapi id 15.20.2516.018; Mon, 9 Dec 2019
 05:12:28 +0000
From:   Nilesh Javali <njavali@marvell.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Sasha Levin <sashal@kernel.org>
Subject: RE: [EXT] Patch "scsi: qedi: Allocate IRQs based on msix_cnt" has
 been added to the 4.19-stable tree
Thread-Topic: [EXT] Patch "scsi: qedi: Allocate IRQs based on msix_cnt" has
 been added to the 4.19-stable tree
Thread-Index: AQHVrHqlZu7OjNQiXUOKd/ws9bM3eKexRJIw
Date:   Mon, 9 Dec 2019 05:12:28 +0000
Message-ID: <CH2PR18MB31604EB0E41782F8ED27A493AF580@CH2PR18MB3160.namprd18.prod.outlook.com>
References: <20191206211757.E90A320659@mail.kernel.org>
In-Reply-To: <20191206211757.E90A320659@mail.kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [114.143.185.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3a223ff1-c2f2-4275-4345-08d77c6662fc
x-ms-traffictypediagnostic: CH2PR18MB3287:
x-microsoft-antispam-prvs: <CH2PR18MB3287C3EB33591CBD5DA620E9AF580@CH2PR18MB3287.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 02462830BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(376002)(39860400002)(136003)(366004)(13464003)(189003)(199004)(7696005)(76176011)(478600001)(9686003)(99286004)(8676002)(74316002)(316002)(966005)(5640700003)(55016002)(229853002)(2906002)(4326008)(33656002)(81166006)(81156014)(71190400001)(71200400001)(1730700003)(305945005)(76116006)(6506007)(53546011)(86362001)(66946007)(66476007)(66556008)(64756008)(26005)(5660300002)(6916009)(52536014)(102836004)(8936002)(66446008)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR18MB3287;H:CH2PR18MB3160.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nZQNuMvAeqa5gONopGvNZkoC3qtETnWF8haQl7gtkgssREwBtKW1WxAdW/2e0ZR/iliYG1idsYsG/RSfdySp5gOKFZ4CfDVVSXWNyKx/XIxFbQb1H66H+l7BKqTftL5w3ceHsZIM43fqIB0ijM8DF75R1s7l0hxblAH3pnbSrA+jgMYpPCoNg5BtyhfRFcznwRaqKBwRQRnRkLN8ytWKJRkId7kBuXKAvvP7St8aa2g5ZBvab0xnm05VqqOgxtpmAgAumlh3aMYmz/ymBQPzLRMxv3/9evJwoLKVw3u8u7hNpzC6ZEfDNFnyzYOaS6kEMl1yr5LSpwp+NkEXpe9dXwuPt9BE5nqUm+/n67ceJy+PQaoy5H4GilHxtSdNS+YKRynC+V8HPZeqCpUns3cs0MqK8LVALpo94wf5iV3o2/HCl1lNGpgj3Ui127ebdx+krpFQGE4GerulBZp11eEcelIZvjQGaDc8mlekGOJOEX4NBC/2z3KdcK0qyb5LD3W2IrF0OFmLTeVGe967WWZtUh+9tzdasJJosWoZX/ATfDs=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a223ff1-c2f2-4275-4345-08d77c6662fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2019 05:12:28.4672
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M/iuzFNRXoswJN7D4r3L+dXmrpUECzEgSYelcSpUnbq+vkN1KeiicWvcv1hZ/wMnquwgwHsJn3SgkcyH8IHqow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR18MB3287
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-09_01:2019-12-09,2019-12-08 signatures=0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Please do not add this patch to stable kernel, as there is another upstream=
 commit which reverts this patch,

13b99d3 Revert "scsi: qedi: Allocate IRQs based on msix_cnt"

Thanks,
Nilesh

-----Original Message-----
From: Sasha Levin <sashal@kernel.org>=20
Sent: Saturday, December 7, 2019 2:48 AM
To: nilesh.javali@cavium.com
Cc: stable-commits@vger.kernel.org
Subject: [EXT] Patch "scsi: qedi: Allocate IRQs based on msix_cnt" has been=
 added to the 4.19-stable tree

External Email

----------------------------------------------------------------------
This is a note to let you know that I've just added the patch titled



    scsi: qedi: Allocate IRQs based on msix_cnt



to the 4.19-stable tree which can be found at:

    https://urldefense.proofpoint.com/v2/url?u=3Dhttp-3A__www.kernel.org_gi=
t_-3Fp-3Dlinux_kernel_git_stable_stable-2Dqueue.git-3Ba-3Dsummary&d=3DDwIBA=
g&c=3DnKjWec2b6R0mOyPaz7xtfQ&r=3D3vadieLZ6erxpUMwvocjUmY37pP2-gJT_x5dkpeN2Z=
0&m=3DHC7dgils6ymNvCnhkzOJL_7dYmpVgFuxxHOAVg_49fM&s=3D7vpcOHlnTbG1jyehoNBpD=
A9P2JYZdpPG83ElZhG0k9g&e=3D=20



The filename of the patch is:

     scsi-qedi-allocate-irqs-based-on-msix_cnt.patch

and it can be found in the queue-4.19 subdirectory.



If you, or anyone else, feels it should not be added to the stable tree,

please let <stable@vger.kernel.org> know about it.







commit 858d07cc26891658bb0c2c3aeee3ca4f84012655

Author: Nilesh Javali <nilesh.javali@cavium.com>

Date:   Wed Nov 21 01:25:18 2018 -0800



    scsi: qedi: Allocate IRQs based on msix_cnt

   =20

    [ Upstream commit 1a291bce5eaf5374627d337157544aa6499ce34a ]

   =20

    The driver load on some systems failed with error,

    [0004:01:00.5]:[qedi_request_msix_irq:2524]:8: request_irq failed.

   =20

    Allocate the IRQs based on MSIX count obtained from qed module instead =
of

    number of queues.

   =20

    Signed-off-by: Nilesh Javali <nilesh.javali@cavium.com>

    Reviewed-by: Lee Duncan <lduncan@suse.com>

    Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

    Signed-off-by: Sasha Levin <sashal@kernel.org>



diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c

index 763c7628356b1..a81ea8f6c2087 100644

--- a/drivers/scsi/qedi/qedi_main.c

+++ b/drivers/scsi/qedi/qedi_main.c

@@ -1304,7 +1304,7 @@ static int qedi_request_msix_irq(struct qedi_ctx *qed=
i)

 	int i, rc, cpu;

=20

 	cpu =3D cpumask_first(cpu_online_mask);

-	for (i =3D 0; i < MIN_NUM_CPUS_MSIX(qedi); i++) {

+	for (i =3D 0; i < qedi->int_info.msix_cnt; i++) {

 		rc =3D request_irq(qedi->int_info.msix[i].vector,

 				 qedi_msix_handler, 0, "qedi",

 				 &qedi->fp_array[i]);

