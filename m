Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F09D6D8ED5
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 07:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234881AbjDFFdg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 01:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234723AbjDFFdf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 01:33:35 -0400
Received: from mx0a-0014ca01.pphosted.com (mx0a-0014ca01.pphosted.com [208.84.65.235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 780DA65AD;
        Wed,  5 Apr 2023 22:33:32 -0700 (PDT)
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3361UePF020061;
        Wed, 5 Apr 2023 22:33:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=Pm0Vuz19WIq1W4OI3wCS85uqum1/c3ajQBMBlCN9VAs=;
 b=BpTjFlV16ygL0W6ocExslpcg/KNLVVETjbvNIRUUlg3W6PILnI+l8PyckRK9zUjV3PNL
 QuAE+7gFjjyXJu2Ucj6VxXtLKTdZMeVbRXiXyURx5PbigPivK2FqJrenSj1IsSTGeN0o
 SteIuQe13loGhMeKvFcnt0gc5z8Qcn3uJbtttpys6VVFhEXD6Tn1Mk73wS7rA/gDJShl
 je2ysT2QTBxp8Twmio7FTJW1lL7zW8QdUywWL1ektjRukklMtceMsOUl/occYlA3xquf
 Kvq9xZcTzSjuBNTTTVR+Oh1lcwBQVOI/jEz+e25Q1cGI3/AHXDYkE1+RJPM66/5tI+5B sA== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by mx0a-0014ca01.pphosted.com (PPS) with ESMTPS id 3ps22drmbu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Apr 2023 22:33:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JN/1C9xeR0SC9NabwQzrmwKmza5DJbmEvLxn4U66zOsOSGgh+Bfv5i8qUc/4FpYvAcMe3M//GSw1UgjQNS9344Q0cBdgOj184vhTYtoAAjn607HflDzI79xcQ4MDddg4M5FOT9cm4ChHuyOUHS09tLHreNCeAXAKLAgv1DJCq8j5r9b+1cAoLCRESV4RJUX3GayXcwGektAGkFV4RKRTiuSNjCI2eBC2b0thhjQ9uWcwAhLrtN69DphFL0kl8myciHDE0KEXCIu896kx+0RRCjwQN10q0bbtb9yOCyc7SOJ0aBdHPaHACsttOrw8duL4lJ+GNAyQTSthqePErjE7IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pm0Vuz19WIq1W4OI3wCS85uqum1/c3ajQBMBlCN9VAs=;
 b=oXhO1Fv+VtK4bTadNLsuNT+l3P84SfDz0GsgmNeKUOQupnBgFvjj8i2U0BAy0nzG+6GwZAbpdtcuc7QNxL7VgzN4ZxrjIAUMEdc03PJfSndJnGa3yQ1GQATVU/CQIuwig6rlEMMw6QCaiMWYRapmHE0zUwCbi41vObdxys2zNVVmj3MFqTjw488GZPerv8lUlbiMbFci1eri/c64N0t6fqFJZPrTtRyX8qgDsAiCuVXdD1N7UEjixzjUVk5chy22mh2RxaleS/1dkr/uBFLUm/yneFZpgEpT3WnVXf7ULQmr8y1VIEPvhljY5yaRdHs+PuQ65bbIwkGjFuEI9UD9+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pm0Vuz19WIq1W4OI3wCS85uqum1/c3ajQBMBlCN9VAs=;
 b=EleUZG0UT/yccpWARgVN7CatieYomgtB6WJ1/wh4XfMY9FnRNHcGHS4XHBNQvtjbj6cN+homsKdm72OgVUXpm0UOEXvyXHIHDRC/MWF4DrohaL/xZshf+0//+jbJzLrMOFSIBqPzyULJfOJsKz2aYFRposVviqJ630muVyZuzLw=
Received: from BYAPR07MB5381.namprd07.prod.outlook.com (2603:10b6:a03:6d::24)
 by MWHPR07MB3504.namprd07.prod.outlook.com (2603:10b6:301:68::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.30; Thu, 6 Apr
 2023 05:33:20 +0000
Received: from BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::7a9f:f44:4172:5bb8]) by BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::7a9f:f44:4172:5bb8%4]) with mapi id 15.20.6254.033; Thu, 6 Apr 2023
 05:33:20 +0000
From:   Pawel Laszczak <pawell@cadence.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "peter.chen@kernel.org" <peter.chen@kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] usb: cdnsp: Fixes error: uninitialized symbol 'len'
Thread-Topic: [PATCH] usb: cdnsp: Fixes error: uninitialized symbol 'len'
Thread-Index: AQHZY7ATLLPsq7d+qU2aYOKDYjOe+q8c/2uAgADJgEA=
Date:   Thu, 6 Apr 2023 05:33:20 +0000
Message-ID: <BYAPR07MB5381895A02CE7B92E6396A2CDD919@BYAPR07MB5381.namprd07.prod.outlook.com>
References: <20230331090600.454674-1-pawell@cadence.com>
 <2023040514-outspoken-librarian-3cde@gregkh>
In-Reply-To: <2023040514-outspoken-librarian-3cde@gregkh>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccGF3ZWxsXGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEyOWUzNWJcbXNnc1xtc2ctODg0MDQ2NTMtZDQzYy0xMWVkLWE4NjQtNjBhNWUyNWI5NmEzXGFtZS10ZXN0XDg4NDA0NjU1LWQ0M2MtMTFlZC1hODY0LTYwYTVlMjViOTZhM2JvZHkudHh0IiBzej0iMjA4OSIgdD0iMTMzMjUyMzI3OTc3NDg5NDAyIiBoPSJZckVjZGliUlFiU01OblhZekxzSE0xWXNvVnM9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR07MB5381:EE_|MWHPR07MB3504:EE_
x-ms-office365-filtering-correlation-id: aa60ab3b-f80c-4dc8-66af-08db36606eb1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Vlgj2SZaiIX9dRuen6+lTPtgtvLIuEUOfv/kvgz2WEbPGQzPd1g2BT0WUew5fEPgDK6A/puFc9WypJichlJvcCYnjrD7G532+y7qZCvi3y1Z9sV//YvhBaGWGO8B17A4xenqaIQ5kGyss6nC/9r/Yq9O1E03pTfVH3xmUUzdsu6EJznmvsFi0aGq2bb0HxnVv1tmOWB0jRDGHmkzYD2R25TF7GLIhlOt+gcEYIYmejRUraQs9/uxi78pq71g3k77mcFPkwTUjdrJXkjcoPSyCrm8MdI6XECQZp3jzfeKhcdmBEDisOrxZSudQtquDKyn9ehrrMfMI7v3mD9N7AYoqxdmuiPMmQOeEgXDzdObgAlMxF3figeZY8n6vpTSeQLLV3oAHM4NkRp9axZJvas9UtPCm+spw9XfHWQgNfZLGJx6TzGVOEM1YDMOsqarsCQKI27Ddm8d/guKrjynE3JsqGw6c9WHyG+v/zi0bL71LvZHdDTDw/RooU7TwTp5h48BMMkm9UGm2yhv7wRZxZjmTKH31rAxtMJju/+QMD46FLzpp2oKz3rBy6yMqqLMF8neeu2tn9C1SEElLo3EMV6pcL2cn4FbrcWb23iB3qq9iPk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR07MB5381.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(396003)(366004)(39860400002)(136003)(36092001)(451199021)(83380400001)(966005)(316002)(7696005)(71200400001)(26005)(186003)(54906003)(9686003)(6506007)(478600001)(2906002)(5660300002)(55016003)(33656002)(38100700002)(122000001)(8676002)(64756008)(6916009)(76116006)(4326008)(66556008)(41300700001)(66946007)(86362001)(8936002)(38070700005)(66446008)(66476007)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/i8YA2yOrjLN5eLfvSO5CmDxFfhLuwnMirGJeF6uVyFlmUa+IQsoXOlGTcng?=
 =?us-ascii?Q?mK95inxWXBc5t0RrQFIbsw49oFn9V/BPKSRmAVa8c610AbRVF3usNqXiIriI?=
 =?us-ascii?Q?CAsydHx1M0qe52hUGhiETkxg3d/66KabCNOuHDT3xn+7R2uid71DeBaSj97Z?=
 =?us-ascii?Q?m32WSuW0DuVp0Xx2BDCYnnKuSWmb+OnssZyWdWho26d+nSv6YUwMAOhSZJJN?=
 =?us-ascii?Q?8SREml/Pg3IWq64NBlv0EwW4tHa0DXGPfWCj3BCpzVaMORelTy5m8IIcI+z7?=
 =?us-ascii?Q?Df/a+e4XHcksg0+GYeHQRy43VSHB3ZEIPfpZRTaxbDYdpOmtVVC+gIZCvQlo?=
 =?us-ascii?Q?JjcqRnIwb2Rt7NmieDoDr/gWGISIpBCRX4gK1CKkB7cmxS1VExompEey2R9u?=
 =?us-ascii?Q?ipYagoW/WaTTR64a+KXUCUHHbXHjoLkCaMjo2y/s0UcLdx9MObzvwQIBQ9+c?=
 =?us-ascii?Q?XYG/lZ8q9eDZpaE+L/nuc43Ndikrj6FsMFlkKdEzkYPmHn3+tnqUp0PwsWLS?=
 =?us-ascii?Q?7B/bjLpT/k4ubI+eWZPLD4U9I+b4XWjJ/aGTwFMKrW97w2hFH46eEhimqYD4?=
 =?us-ascii?Q?sBPP2HOWAgi6U0Pgd1Ypy5LeE4ZG2ZLce/35ZFTY1+lj9nlPxy6IvkYwdLj2?=
 =?us-ascii?Q?mozOnUshYeBBembJuj3SeuT3b4rQMx0m3C/aNFUJ3QP3hU/a8RA77mq9Caqw?=
 =?us-ascii?Q?3fiaXYXwAbqto9JuLjBD5vSeALhYjNEj6FuXyEXrAQFI7LK4cxO9C/26h48w?=
 =?us-ascii?Q?556EPfKokIBIAHq1joRDk0VXg6X+u38jjYmaRgv/mPWQcPGwYpoiB7dZ8pwD?=
 =?us-ascii?Q?8q+Zw+pjmliIpAlLtqgCb8cQ0ry0dt5HY6n2gtTPq3IwuXeb1grxjKrSgzcX?=
 =?us-ascii?Q?i/uWDvI1F2VyFtrkyHjZTNf/ShC8fYtL3M7LAPywrDs4gMX8O8wo9ZXrsjst?=
 =?us-ascii?Q?uvnYGTCb4RX8Nd/iVk2752UT0E7qP7BcocHRyD7QsFoVbpUx67dyeE+GHx3K?=
 =?us-ascii?Q?GpsRF//4nTq+77xMmfydtsa6SXdi9jLgGrREftilPijGM1fY4Lkt60q42EnN?=
 =?us-ascii?Q?FRuKss5T5/AOY//WJChJ/3IixRWGmFWlb4pwPmvv1bmW1rmK5qDwzHuu6T/9?=
 =?us-ascii?Q?C8X4wA5B2dYVHQZfMl/et6WjHfBS21EW0roQf0QFN0MYsM4OfN3OqS+1TO9T?=
 =?us-ascii?Q?l2eYRvIN6V16FicQxFmDCZPT6sJfjEwmrXlGm4kFWLPYQNcEJm9HR2/dIUDI?=
 =?us-ascii?Q?OGGNvMLfeAjXfP+sFDJvowJ7ddR6IWFrCMOoXSZv5oSv86VTLf67edKW4n5t?=
 =?us-ascii?Q?uvyXm8HlurYxMXYmF3iMZbFcoBhy2jkTB5eHrZ9rFKJ4JKKJTjL4l1WH5b5h?=
 =?us-ascii?Q?+hs2kI2xrOIMuF2pYii5RyZZQuofS+ZUfZd1E7Ugz+Ccs2Siy8Jg0UdbhUYE?=
 =?us-ascii?Q?tjwZsJEY3anvpmsG6co6c/suEMKIQdNfg1quixI8lDuuqWte5RnayWIoRhDh?=
 =?us-ascii?Q?q/ZbnNNZNSJO5rnLEmNRyjPhN7gXOuNt/KJvlCJcVebkNcF4d9PyBC2UmuSm?=
 =?us-ascii?Q?MtcNvnRRm8J8nVUpv4M7kU/0+NfmDfuMYMiXbM4V?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR07MB5381.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa60ab3b-f80c-4dc8-66af-08db36606eb1
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2023 05:33:20.4774
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AMDocEV7H4Ngzm90uWwEldBKZYuolNB0AWmD7GRUBIppI7d2hKdhf4RjB+PVqxM9qGo8luDBcQLwTU8RzSrZ+iyuX62711zuWyp6QE8tbGE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR07MB3504
X-Proofpoint-GUID: j4StLJ-ppRsoWmn9p-uFKhANpmcuTbwG
X-Proofpoint-ORIG-GUID: j4StLJ-ppRsoWmn9p-uFKhANpmcuTbwG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-06_01,2023-04-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 clxscore=1015
 lowpriorityscore=0 phishscore=0 mlxscore=0 priorityscore=1501 spamscore=0
 impostorscore=0 adultscore=0 suspectscore=0 mlxlogscore=819 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304060047
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



>On Fri, Mar 31, 2023 at 05:06:00AM -0400, Pawel Laszczak wrote:
>> The patch 5bc38d33a5a1: "usb: cdnsp: Fixes issue with redundant Status
>> Stage" leads to the following Smatch static checker warning:
>>
>>   drivers/usb/cdns3/cdnsp-ep0.c:470 cdnsp_setup_analyze()
>>   error: uninitialized symbol 'len'.
>
>Are you sure this is correct?

Yes, I'm sure.=20

>
>>
>> cc: <stable@vger.kernel.org>
>> Fixes: 5bc38d33a5a1 ("usb: cdnsp: Fixes issue with redundant Status
>> Stage")
>> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
>> ---
>>  drivers/usb/cdns3/cdnsp-ep0.c | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/usb/cdns3/cdnsp-ep0.c
>> b/drivers/usb/cdns3/cdnsp-ep0.c index d63d5d92f255..f317d3c84781
>> 100644
>> --- a/drivers/usb/cdns3/cdnsp-ep0.c
>> +++ b/drivers/usb/cdns3/cdnsp-ep0.c
>> @@ -414,7 +414,7 @@ static int cdnsp_ep0_std_request(struct
>> cdnsp_device *pdev,  void cdnsp_setup_analyze(struct cdnsp_device
>> *pdev)  {
>>  	struct usb_ctrlrequest *ctrl =3D &pdev->setup;
>> -	int ret =3D 0;
>> +	int ret =3D -EINVAL;
>>  	u16 len;
>>
>>  	trace_cdnsp_ctrl_req(ctrl);
>> @@ -424,7 +424,6 @@ void cdnsp_setup_analyze(struct cdnsp_device
>> *pdev)
>>
>>  	if (pdev->gadget.state =3D=3D USB_STATE_NOTATTACHED) {
>>  		dev_err(pdev->dev, "ERR: Setup detected in unattached
>state\n");
>> -		ret =3D -EINVAL;
>
>That's a nice change, but I don't see the original error here that you are=
 saying
>this change fixes.
>
>What am I missing?

The fixed patch is:
Commit:  5bc38d33a5a1209fd4de65101d1ae8255ea12c6e
And here you have the link to linux-next tree to this patch:
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next-history.git=
/commit/?id=3D5bc38d33a5a1209fd4de65101d1ae8255ea12c6e

I send this fix as v2 for patch "usb: cdnsp: Fixes issue with redundant Sta=
tus Stage" but it was to late and you recommended me  to send this as separ=
ate patch.

Thanks and Regards,
Pawel



