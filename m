Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0C0646E8B1
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 13:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236425AbhLINBR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 08:01:17 -0500
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:2116 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229379AbhLINBQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Dec 2021 08:01:16 -0500
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1B9CXn1o025637;
        Thu, 9 Dec 2021 04:57:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=IT8jaK5zP7ZNxGEYhxjNpVKQGG4g67jUubyDqKsLmtQ=;
 b=PsZkGmwrltTaWT4FFV3+eArvxViX/ku1YRaTNihTFYxUUzsZ44LTyitrz89pb7iY8wJY
 hU/Vxj/V0M+GlPEAM/GUrvOW9RNHIg1emtIc15KX/yRgLxQV0R+8egbOyRs17giAFLt2
 ccV70Ue6QgsN/0fBTnswXBNFI0vJEC3A+j2umiqinJneJBxQsQc2yxCkNbF5qewuBTo0
 Sw+odPWopzuQEvpo8l6fnLPNSTIpab9107n1cS0SCSGe+bYbdUb59a5VmKNo1SfQ4ACS
 9P4gZ/j7uPOMyyBkB4OAFusc9Eybdc6bVc1EUuBRimLzGzPQJGMn4rY8nHOF2oKcwW60 zA== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by mx0b-0014ca01.pphosted.com (PPS) with ESMTPS id 3ctgxfq470-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 04:57:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ViezB3desssMuz1bTVPtj5Xj/P+IKJpyrjDG3PJuLJEyyuo/9vwovKtICX8u6As7QtOKBQt2WJxR4jKWnahHF+Qey8fqstN7X9+MJucKHsgCtwmlVDuG7PjwqxXVQj3VPjTo19TvhhbYgFt3hfrb7fZdqS8uzPx3DD0FXRtBb2IclCqQCkXGS9zzK3/h5Su0wRbebwwu7d8F4jCyDdbgowZLPIJ+QKhTZXEI64wqbmy8rkOYxi8oY79cXNp68CYn7lRbXYzT+Rycgkr+ZxMVL+Diim/CMgn4Vk6ny28bwJ3gTO8qjp3euxMt3Z8mlj1Rt2SdRQCD0V6b7sBMdBegXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IT8jaK5zP7ZNxGEYhxjNpVKQGG4g67jUubyDqKsLmtQ=;
 b=jiNngnggrCEGxZ1NzV62Qpi9nfs6MfC9WNMQCFkMDZBDdeKL7DJIGKmr8s1h5jv2XqNTdajNxvoLJ/cm46PfwyVo+3WEQwzqwJLUZMGy0gdA0n23g/Mjsjtzd8ErC/A6UCE6RxtqYOoyUsZzyTXCBPA+aCxVXSSyrIZrGtSKT84Qz/MbLvARyEtHYXOoc47iROW1WxWkuxch1Cro+2bwVk5Xi00CdXoD1PSUBE9mZDEUf22tSOnwbwXmrrzdL/4zZ2UdqeSPRWV8uMwv4xYUNvHaT3IQ5rID4K2z+yGaTmC7QNfHv63aOhXLhHQ5KDdCihLKfbSo2bJf4CMbIQiFtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IT8jaK5zP7ZNxGEYhxjNpVKQGG4g67jUubyDqKsLmtQ=;
 b=LapgbS8WAu8gdmwnFSLkXGEuB21Y+vzbU8glWYKfqXubI1uhbH3f0cJZKr1qlwOjW+CvOjGoJL7aU7p7SIP9DkLY9nzEly2pjNWNmwGarWPsYP/WgFVBvjAvSBbjB/N7a9QauZMQGgQkwEWB6iA7/Suji/gq43lvCQdHF17Obk8=
Received: from BYAPR07MB5381.namprd07.prod.outlook.com (2603:10b6:a03:6d::24)
 by BYAPR07MB4791.namprd07.prod.outlook.com (2603:10b6:a03::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.22; Thu, 9 Dec 2021 12:57:32 +0000
Received: from BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::241f:218b:e5aa:9024]) by BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::241f:218b:e5aa:9024%7]) with mapi id 15.20.4755.022; Thu, 9 Dec 2021
 12:57:32 +0000
From:   Pawel Laszczak <pawell@cadence.com>
To:     Peter Chen <peter.chen@kernel.org>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jianhe@ambarella.com" <jianhe@ambarella.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] usb: cdnsp: Fix incorrect status for control request
Thread-Topic: [PATCH] usb: cdnsp: Fix incorrect status for control request
Thread-Index: AQHX60t+MP74NKbCqkG7HRhxiNimOqwqCsQAgAAVavA=
Date:   Thu, 9 Dec 2021 12:57:31 +0000
Message-ID: <BYAPR07MB5381415E88BAAC945CB47A93DD709@BYAPR07MB5381.namprd07.prod.outlook.com>
References: <20211207091838.39572-1-pawell@gli-login.cadence.com>
 <20211209113408.GA5084@Peter>
In-Reply-To: <20211209113408.GA5084@Peter>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccGF3ZWxsXGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEyOWUzNWJcbXNnc1xtc2ctOTBhNWZjOGMtNThlZi0xMWVjLTg3YTYtYTQ0Y2M4MWIwYzU1XGFtZS10ZXN0XDkwYTVmYzhkLTU4ZWYtMTFlYy04N2E2LWE0NGNjODFiMGM1NWJvZHkudHh0IiBzej0iMTQ3OCIgdD0iMTMyODM1MjgyNDk5NjQ2MTQwIiBoPSJiQ09HVFYyWjcwYmlOSHpZTlc5VkJXNzlVWXc9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d5b72416-15c6-42be-46ee-08d9bb1376bb
x-ms-traffictypediagnostic: BYAPR07MB4791:EE_
x-microsoft-antispam-prvs: <BYAPR07MB4791E8121B99A9A10FBAF8A8DD709@BYAPR07MB4791.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vq4C2GoIUSEsgLgrm+SSNyx2ZxdnIS29y/GnR4ly80sEKqFWvaGdDwIx0zz4crf9cPw8CJCsxgSnlwx0m0YHz4QvSJvozBzZPFu+BV5vI/QCuzgo4h5CeJ9LAETu/zVe7jT8O8TwXh8+yX7UrX6WCbJ+X8cHkAzNtRah4BEoS5UtM+I/DSvPuoiyDtLESqZmGKkQ9Et4Vkmqtfbg/lIVQyZ42JLAY+6OcBPNRN3DoCtQJ+P3JzRelaMNA+ly9XbNYerb4JXdXfok2y0wvhUDSSt6X6z6ccinx+9ybLHQLQ0fYm26UL1GRZtDuwMqrvIMS2pFAPGnSRxhwdUQdNJpgwktEkdDXC1fzxxGwYXtoGyCBX6MpYeRpBzyrLB+eFXIA6DDVbkWR7RLmOHK7f6BcC1KkDDRbG0ZUo1TRKFEfRZIa4sRU9NZtXAflPu2uaN/tbHJtII1bZi/FIhK00aEKBJ2EqcyhP4Li61Vi91H0goa95EG5981p0f6FJOSIzAXQ00qONAZcKA6PrXUAfln3FgSvuPC8qWG5KXxzQAIbNZGB3aeBJcId7xg3Xt3pxXM5VMSaAW1rC2FhevEJGL6B3+vCgPtdsqiRyxfNMmh+Dr810VqaflQO7SHai4iuUnY/4qdBftpp8YkybFXwTxn/Krs6TgFtjQfjb95vAnmVTn+wKtItkj1dQWa/pvQ5KBiA7vVhgmuCBZGhS5TF+sF8wC9Jzr73wTjZHjMEugGqUE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR07MB5381.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36092001)(4326008)(2906002)(52536014)(83380400001)(8676002)(9686003)(33656002)(71200400001)(122000001)(86362001)(38070700005)(508600001)(66556008)(316002)(64756008)(66476007)(5660300002)(6916009)(54906003)(76116006)(6506007)(38100700002)(66446008)(66946007)(7696005)(26005)(55016003)(186003)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RpBAL+g/1CIweOe2oxUe6OdDgz66TcUm1T9W8LzlgtZDcCBlYlgVInQzpVG0?=
 =?us-ascii?Q?OXZH6ZaQuJaa8PXwtOJ95dk0QVXxIiq7yDNVh6AaAn5+qNHYENMDBHzaqYS5?=
 =?us-ascii?Q?rkSm+QO6K1Dx4YscNOTt3iq5ZVY4U1cmto9DCILOFmzSHkIfku1fpVnO8uXF?=
 =?us-ascii?Q?KBagh35fQBQ21Q5dFSuIElJXQcnVQbI50W/8VRe45qrwe+mWYYUOIJ/4a3c4?=
 =?us-ascii?Q?4NcBoXwBPsDbu8VOhPjElo63nIPJB5vYVZl9uobB1QuxCy/4MoVsImfso5rz?=
 =?us-ascii?Q?QDs83SEfuz1nhR9YO+IulUh8lqHn/9y3ZMLecqA4Ehm1qQ15dkR/85ssrW/D?=
 =?us-ascii?Q?39VGw2w+H6sU55jwRahEy8LiqDOlXJCAWHypkRMZHQSkwNukItwQpL4Xm/GW?=
 =?us-ascii?Q?ErIWCbIg0C84yqKAHJ8vIv/7jJLwA0v1Cq+vxqB5mqyvCnJdBWvE+HVf+PSe?=
 =?us-ascii?Q?j98tLiKG2h44URPtz8gRWU05lN6WIbyWSPioZw9mNy0o0NQyfe+kCVjuD0pR?=
 =?us-ascii?Q?1S1FPhjHKdBiC4Ky4zcFmkvlzCjKBPip839VrpoIDPTTVSI16RHcsKYEHg9x?=
 =?us-ascii?Q?QbjLzKFiQpFTu6/fZc1uszDpXa71fnoHxboxReNwiI0jlsmxQszsO8ItrHeO?=
 =?us-ascii?Q?SOgaXFn6T9P4zYpKU9jWsVxgqLIiOlp3oCbPQAwK3vlTbbIS72spukXWNqdn?=
 =?us-ascii?Q?u60orqHhvqjeUpa+1pma5mHTDWB6tNXJi6WbvYK+odXylokthYzR9rgnrvbG?=
 =?us-ascii?Q?VOqydueBcyNyJZ9seFCNoXePM9LOUANG3vwM1B351xOPXZuyIbigDrTV8N6A?=
 =?us-ascii?Q?JoPVvdknkjoCUcfoNkDHYgCgLTwLhwQ7Wigs5z5MHxVaoZsk3ceHyZdkpdRI?=
 =?us-ascii?Q?rQCqT+9wUQQ++m60TjwwKI1vODDXQGy+WdBjAUca2BPF2XtxdR8yNdCebFbp?=
 =?us-ascii?Q?ueuSagCb+v7k9qfGcSBoIZVaoVIP3HvpsAdbu2itp0AEr2hK4dlIIHrxoGrt?=
 =?us-ascii?Q?JOaIH8SFO416GmlcRws9EhXWBjusCr5qLjUDlj1lkLCOunWcJ9wJFPFK9jil?=
 =?us-ascii?Q?8b3Zt6mTPZYAM8B7LZM0l+h73Hi0gUfDgKl/q0o8cOwJFnvk5WzFvvvP5ovP?=
 =?us-ascii?Q?4o0q2MQ88gNHXTrQ/AzF8ELjqjO0sGPu3zJP7UrBLDAmu+QTtUVWH1W52tDc?=
 =?us-ascii?Q?F6OmXwQfk1A8zoKPOsaWjqdmvn68wmNKgzLkt9Km6Ebc+0vaJ0ROkefYS4I6?=
 =?us-ascii?Q?0U7nitQ91MdDTCp1o7a5CKBqzWh4f4UFVzBCdCPmRTSl0d0gXuTJY+CDEWxQ?=
 =?us-ascii?Q?nuTqUD0/HSbPPmFl7q4bUzcsa5qsBSVgq6SMGMOyrrzgwHKhoWlx6mVJeswU?=
 =?us-ascii?Q?3hzXtizBdXS9Skh9TOtvVo+QSd04ss0MhBCog3IZjIs2kFdswQpeK/ka6R4g?=
 =?us-ascii?Q?5e56S/h7Sxejj1Ss/f0MwMYlDcTAdLBrpuw8ARN3p81aHzh871nVQcfoFX9H?=
 =?us-ascii?Q?DjzEP3KCRinn1j402KdKDiuvU8L7MQsfs3Llu/yqC7Zg5Ij/AKQ5wMYzLtX1?=
 =?us-ascii?Q?dLkeQ215TFfvNPVwQRKW4QzYbdNB1S37ziROktY3CBtxksUL7Mb0CTCj1jXg?=
 =?us-ascii?Q?GalpQ4kHjdNAf8UgCzFtz38nupaB/tpijfDsRNLYajUh+0fLiGmRwY3uDKeS?=
 =?us-ascii?Q?IdGwsA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR07MB5381.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5b72416-15c6-42be-46ee-08d9bb1376bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2021 12:57:31.9104
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 53OJu4v0RzwAQsXGIKC2RnY642ewfhokf1EQHd4s8sMtVuZ2EJFp5kpWPQ7rN2NoagYYjGmcFUNjlZ0OrZugmFLPG2S+uFgbS/dG6m7IAFo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR07MB4791
X-Proofpoint-GUID: xczO3D563VvqvvKj0k9xHZGE2tZ9vFPv
X-Proofpoint-ORIG-GUID: xczO3D563VvqvvKj0k9xHZGE2tZ9vFPv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-09_04,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 clxscore=1015
 adultscore=0 mlxscore=0 lowpriorityscore=0 impostorscore=0 mlxlogscore=734
 suspectscore=0 priorityscore=1501 phishscore=0 malwarescore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112090072
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>> From: Pawel Laszczak <pawell@cadence.com>
>>
>> Patch fixes incorrect status for control request.
>> Without this fix all usb_request objects were returned to upper drivers
>> with usb_reqest->status field set to -EINPROGRESS.
>>
>> Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP =
DRD Driver")
>> Reported-by: Ken (Jian) He <jianhe@ambarella.com>
>> cc: <stable@vger.kernel.org>
>> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
>> ---
>>  drivers/usb/cdns3/cdnsp-ring.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/usb/cdns3/cdnsp-ring.c b/drivers/usb/cdns3/cdnsp-ri=
ng.c
>> index 1b1438457fb0..e8f5ecbb5c75 100644
>> --- a/drivers/usb/cdns3/cdnsp-ring.c
>> +++ b/drivers/usb/cdns3/cdnsp-ring.c
>> @@ -1029,6 +1029,8 @@ static void cdnsp_process_ctrl_td(struct cdnsp_dev=
ice *pdev,
>>  		return;
>>  	}
>>
>> +	*status =3D 0;
>> +
>>  	cdnsp_finish_td(pdev, td, event, pep, status);
>>  }
>>
>> --
>I think you may move *status =3D 0 at the beginning of
>cdnsp_process_ctrl_td in case you would like to handle some error
>conditions during this function.

I don't predict any other status code for control request in this place.
I wanted to set this status only once after completion status stage. It was=
 the reason why I put this
statement at the end of function.

--

Regards
Pawel Laszczak
