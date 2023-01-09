Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E20AA661E81
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 06:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234261AbjAIFsB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 00:48:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234205AbjAIFsA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 00:48:00 -0500
Received: from mx0a-0014ca01.pphosted.com (mx0b-0014ca01.pphosted.com [208.86.201.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6CBD1164;
        Sun,  8 Jan 2023 21:47:58 -0800 (PST)
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 308DmfRC017668;
        Sun, 8 Jan 2023 21:47:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=4RaNBArRjpBwkKN0jECxBTrijzXhXfCcA3RjfHmLX60=;
 b=G2LDu/et8hrUAdfkGB9sigZTkQwmfIq8hfFjj+X9tOjxE+boD0PD8dl9wLVvXtY+b2jA
 PNAIJAlxx+lSxELFY/kEB17sFXJZMSK+DEnHNCDEzk8/PCIg0bDqpj3fHO/l4lLn/QiY
 qL53LDOZTUl9D2oJQGUw1aRmqyv63uOGVkyxSdMl9kSA2t7AeEZKytm4E6Q8BNXVNhbX
 s8pDh/TH8STjdd0C3HRpmFi3yHs+pia23OW9ivl+hktG4ZhXG135DYinsLuHikt4Z36/
 UKizWSQWIw4Vn0sEnTqPadY+nW7YRohbG2KwXlI0yXmIPmctfVAZ9dg+EUlCED1En0JP iw== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by mx0b-0014ca01.pphosted.com (PPS) with ESMTPS id 3my576nvw0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 08 Jan 2023 21:47:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bico1rAAVDph5+A3XBrP9bJStVjfYHm4+E1a0ZkEof3GjWGjAe7KTQjevANMmzu0RNSBGp4j2rLxcHOjhhwYBs8jxRDh6j2O8CaZY1/Q4hQDQrloiK0cBZtBBJuzWD8yUXDuV9tuICjZysW1Bu7AIJcEabtT/57cUvCQOAkE1wccyDCcnvDKCkfXprLTBBcApDGM004I6j1/FkUjPce5T51vcWmzcqIbP/3J85aBVUSSzhbOhEoWPYekQ6yTQEVKjy1YL3sz4XLjnjV/u265Sa/XTcQtoKtgnpYiyV9hrmrPuXQ+jeh/jAA1gc8iefOMFCASSqS+YBvQbyY70cespw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4RaNBArRjpBwkKN0jECxBTrijzXhXfCcA3RjfHmLX60=;
 b=EVbN1nndVzRryoH0TiGO9GO6FK28Js1h5ZLGVXqXzY1zUHO8uRM7KTR8N+PSr70soqpUirlEysdfLNgX3h6UYoa7xLnjRFSY5ATf3vdRryGTi+HyhO9oGU7mx3OVFngCY/fCvp3roQiNkeixeZj5ft5jZxJe+qzCEy0NXocGr3yMQ3cu3gW2WF67B4zwcLfqDRPqmEIWIzQ7fDyLK0THdx/3e62GMoKj28rHjMijKew0fhzc+iZ+jCUztXbF01tzYpRcLKFBufLKta1Rrr1NKW7fC41+2kugNlo3W43acGHwuEvf8nmutw58yu1RwBKDvl0S8xEC80mJgKwQuBmqIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4RaNBArRjpBwkKN0jECxBTrijzXhXfCcA3RjfHmLX60=;
 b=1raMsdN4LcgM6ASfmW3y6J/Hq3EkLdd23KO9T3Oe2y0ffvrTBTZdDVd7qpTfXH62RpaI1JoaJGj8YXp8XfXXUWKNAaMrowXQfwIZdlBFVKcfnVmL6jul/6mM9yv7mxKwo1NX/gfsce1cT81CdcExE44Hcbyftsd5BPEG5acIwLs=
Received: from BYAPR07MB5381.namprd07.prod.outlook.com (2603:10b6:a03:6d::24)
 by BLAPR07MB8260.namprd07.prod.outlook.com (2603:10b6:208:326::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 05:47:49 +0000
Received: from BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::f36d:8292:963:59c6]) by BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::f36d:8292:963:59c6%4]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 05:47:49 +0000
From:   Pawel Laszczak <pawell@cadence.com>
To:     Peter Chen <peter.chen@kernel.org>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] usb: cdnsp: : add scatter gather support for ISOC
 endpoint
Thread-Topic: [PATCH] usb: cdnsp: : add scatter gather support for ISOC
 endpoint
Thread-Index: AQHZFeUoK5K4NcemKESrscg3rCfnOa6K2lGAgArTY5A=
Date:   Mon, 9 Jan 2023 05:47:49 +0000
Message-ID: <BYAPR07MB53814954118F9A671DF5AD4DDDFE9@BYAPR07MB5381.namprd07.prod.outlook.com>
References: <20221222090934.145140-1-pawell@cadence.com>
 <20230102082021.GB40748@nchen-desktop>
In-Reply-To: <20230102082021.GB40748@nchen-desktop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccGF3ZWxsXGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEyOWUzNWJcbXNnc1xtc2ctMjUxMDlmODQtOGZlMS0xMWVkLWE4NTctMDBiZTQzMTQxNTFlXGFtZS10ZXN0XDI1MTA5Zjg2LThmZTEtMTFlZC1hODU3LTAwYmU0MzE0MTUxZWJvZHkudHh0IiBzej0iOTQ1MCIgdD0iMTMzMTc3MTY4NjgwNjEzMzgwIiBoPSI3c1NONk9XY0pqVUwxRjNGdUlVdjFQQUhtVjQ9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR07MB5381:EE_|BLAPR07MB8260:EE_
x-ms-office365-filtering-correlation-id: 379664db-08b7-4561-d4fe-08daf2050ac7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 51FxjgWNjWkLHpADQMiXxsw+J/9UsJb8fjSrkmpumbvvnsGumCmZ36TFdPw0L5qhbFi1/4H7Wo9vCMpprD2dT+27TkktNZaAY1uO5oVR3aMJoBkRHjhunUF4Fde2ooDOZaBV2AEa7x/paJHK2e6aGqv0b7k3YtcJoobqa3yHXLb2r3IC4uZGyCMPGZ70IAE7ZsS5tkDwQ86NmbS2mUMMH8y+Fhdz7HJ+DcASnsGQlldjDHJZA0wFUW2ZoaM1uIUyd9RB5xk8PRoCdccySeCqAFclgXqbIMV+z+kp+tlRU1N2CO3DvZPJ4lifjMV5iwPSNBz3Ja0CCRhK3LJiQIuqeX/rwtV1oCRfUFO70qvbQtY8Fxrdl/nbrzKcbhqKITrPII4dyMAYQv76u36eK7v2DpkWtQJ/D0bsq4nzjPY8ffXbcQZixIBDXbxazzNaqScFvQQzBtEBSABBYYkMHO/gxP07UppMoy1s1hojPoSHEo98pUb42aFlQgMdKU0AaUm3Cpo1k/AuFwUZG3URIk6JI/EcFsw5XWhMJ9U6Rst2oXxEC64DbFE3yGJU+OAWPjNmnLwzfMsHrqigbwlbxEumm3QVRCYfPhNLU/BHmln7rGes0GljZrHw5RNClqW15hl5tpUjFTroeRMpV/HErjK2zwKbi7K5tmlTHMkJL4Z8/+wRt0nO+pj19EdjGf8aXF7lDB4HXhuAa0RElgbYZPUwlg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR07MB5381.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(366004)(39860400002)(346002)(376002)(36092001)(451199015)(8676002)(4326008)(66946007)(76116006)(6916009)(66476007)(66556008)(64756008)(316002)(66446008)(7696005)(54906003)(38070700005)(5660300002)(2906002)(71200400001)(8936002)(41300700001)(52536014)(86362001)(83380400001)(6506007)(478600001)(33656002)(122000001)(55016003)(9686003)(186003)(26005)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?P4VgpdjDOKcv9da3/O/C5+b4LQ6eRwTuBr1/5go1hNA8u/yYAGq9zc6WicLG?=
 =?us-ascii?Q?29zW6vGWdWx7/IZ4Praemslm2XPR4ELN+HGdMqyhfDacVi4pw/wmsVfSMiRT?=
 =?us-ascii?Q?c2EQUmLM0TB10aPbw9w7WwVRSZqirjqnTskd2pVYQUDQi3Bxvfx6lGYwlVEe?=
 =?us-ascii?Q?IHmBEpAmC/+Bvcfix0d0e7GrBulTH2YpEX7qhBVXpHxbT/tbgzH/e+eGUvtN?=
 =?us-ascii?Q?FwFgAyQ6AofRcC7RoDdjt9iygfa0JgXr7ZGuqzR8LOpHVna74BNarkUsmgl0?=
 =?us-ascii?Q?82whzc+EdWWi+P3DISU20frZAK87p1KJ3hNdNiHYWvMu89G+2Bn5wfzycgq1?=
 =?us-ascii?Q?+kSJRdV6zRC9Ml1cfaLULlg9/LQRcaLJXv9g3vWzQAoyoLrdcvZbMIR+5EbR?=
 =?us-ascii?Q?rvEWgivc/vSQNnZcH5HB/TrY5TlmMATVTj9e2tz1Cgo4DpXIcYXxmAaTmKT8?=
 =?us-ascii?Q?2PIXvSQbnsVgziYLLzaprbyd6HoZB2dn7eEohGuYDMTOt1yQlQdSZe7hM3gK?=
 =?us-ascii?Q?NEt5ZBN3lXiNCq+kG1mSmgvaFjWiuU6X+trGG6+6UpeYDdzehY5Fmz8DcGKD?=
 =?us-ascii?Q?4QTZuGgXGtTb3Pq/qugYRgs68KaHaJySioZTQts3nrPPe3NfqkJJD2uY8IL/?=
 =?us-ascii?Q?E5praMzjoWxQv6to6hHFEhPsVdYJw4iUHAAPePaukNuyNu1NlFI4wlFP3yKF?=
 =?us-ascii?Q?AnQqcm1BzjiAFBjU5FZd279DfqhdyT2kKedVxczf+lpMK/GMA6QDaUWoFnIu?=
 =?us-ascii?Q?3A+ZrfgLtmPvURyiW6JwIqOg2JNiqLMFHB642cCKqIbAOEpttLpKmcO4CpC3?=
 =?us-ascii?Q?kaV+IctXQJMCIQAOwIzOCPDM2iWVnlvsYhh6i3i9ws9Y/h8LYe2CcqAXbDPE?=
 =?us-ascii?Q?3CQURTDbjfHPBVT5SZSDWUJzU3HApWpdcqh3FMIlJ2MnrBtheJZ7yixy1KVl?=
 =?us-ascii?Q?m4yIEin/5qDQbIjuXMrjkYct+A8hyOAe4XeaGhc1WhO+6Ob57ojytSGNFvE1?=
 =?us-ascii?Q?2kWpCSByRs01rlcrL1FiNcLmXTTuZhPJmeS964doxajCmlnU2M2Kci+wwllm?=
 =?us-ascii?Q?FO2/WADZ8E0drKCfMq2Zk0paGaCbT/jD0MjbdzN6xOK9B4q73u8ij+t0rAgD?=
 =?us-ascii?Q?mqGkPPfPl3/trQsGzzTsaNyoGS4+77C+kAzx7GY0RTCIIucIYSGGJTpbQKvk?=
 =?us-ascii?Q?KDuT3SoQu23OgP6bBRmBqNAr5QzT7A9bp9uw+L8Oqi1xEC9sn/jH3r+PqQGn?=
 =?us-ascii?Q?Lt8pQxRZXtRmyXb2CIEZwNwNCcpzzMu16bVkLeY1ct0DvMvPJZgOVO6LFZWd?=
 =?us-ascii?Q?umjxBaVS0Xc2XBoIgpoztVzFIo+Dlbh5vb5s5KXK4EUafprGwOAQs6zLpdnx?=
 =?us-ascii?Q?mgt/zc26cr09XLWFBNY/PC1X+VC1dfy1b/bxK6HP5od97bmrUnEjgng2LqAI?=
 =?us-ascii?Q?vfyd1VBpLutYW56/CVGodYWf90js62nmC1Ww3okK/XWxvdte6uwLQ2BYsGXV?=
 =?us-ascii?Q?v9J9sjEVEPKj1ugi5Hz9J6XiRKdheJ2o31rIxbQROpo1Erg0rHtl705ao+Eo?=
 =?us-ascii?Q?RSWCpqdAalXZ1lSDbtfRSa3isaEX1YpHJyaOR4tJHLYCBML8l7A4bb+vi71q?=
 =?us-ascii?Q?+Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR07MB5381.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 379664db-08b7-4561-d4fe-08daf2050ac7
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2023 05:47:49.5504
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xHKnIOCYJkouoq/Y60lTGTRNoOZE3iY+QEDrGa7e7E7oWY6iaqGs/S1QxQBBCgOjN29XJF3sWl0svp/a6FabUVga24s8mqHE1ZtTaGwehCk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR07MB8260
X-Proofpoint-GUID: NwH0nMAneqKDhH2ymMwY-0N5nIo4CR5v
X-Proofpoint-ORIG-GUID: NwH0nMAneqKDhH2ymMwY-0N5nIo4CR5v
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-09_02,2023-01-06_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 mlxlogscore=999
 lowpriorityscore=0 clxscore=1015 adultscore=0 bulkscore=0 mlxscore=0
 spamscore=0 impostorscore=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2301090040
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


>
>On 22-12-22 04:09:34, Pawel Laszczak wrote:
>> Patch implements scatter gather support for isochronous endpoint.
>> This fix is forced by 'commit e81e7f9a0eb9
>> ("usb: gadget: uvc: add scatter gather support")'.
>> After this fix CDNSP driver stop working with UVC class.
>>
>> cc: <stable@vger.kernel.org>
>> Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence
>> USBSSP DRD Driver")
>> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
>> ---
>>  drivers/usb/cdns3/cdnsp-gadget.c |   2 +-
>>  drivers/usb/cdns3/cdnsp-gadget.h |   4 +-
>>  drivers/usb/cdns3/cdnsp-ring.c   | 110 +++++++++++++++++--------------
>>  3 files changed, 63 insertions(+), 53 deletions(-)
>>
>> diff --git a/drivers/usb/cdns3/cdnsp-gadget.c
>> b/drivers/usb/cdns3/cdnsp-gadget.c
>> index a8640516c895..e81dca0e62a8 100644
>> --- a/drivers/usb/cdns3/cdnsp-gadget.c
>> +++ b/drivers/usb/cdns3/cdnsp-gadget.c
>> @@ -382,7 +382,7 @@ int cdnsp_ep_enqueue(struct cdnsp_ep *pep, struct
>cdnsp_request *preq)
>>  		ret =3D cdnsp_queue_bulk_tx(pdev, preq);
>>  		break;
>>  	case USB_ENDPOINT_XFER_ISOC:
>> -		ret =3D cdnsp_queue_isoc_tx_prepare(pdev, preq);
>> +		ret =3D cdnsp_queue_isoc_tx(pdev, preq);
>>  	}
>>
>>  	if (ret)
>> diff --git a/drivers/usb/cdns3/cdnsp-gadget.h
>> b/drivers/usb/cdns3/cdnsp-gadget.h
>> index f740fa6089d8..e1b5801fdddf 100644
>> --- a/drivers/usb/cdns3/cdnsp-gadget.h
>> +++ b/drivers/usb/cdns3/cdnsp-gadget.h
>> @@ -1532,8 +1532,8 @@ void cdnsp_queue_stop_endpoint(struct
>cdnsp_device *pdev,
>>  			       unsigned int ep_index);
>>  int cdnsp_queue_ctrl_tx(struct cdnsp_device *pdev, struct
>> cdnsp_request *preq);  int cdnsp_queue_bulk_tx(struct cdnsp_device
>> *pdev, struct cdnsp_request *preq); -int
>cdnsp_queue_isoc_tx_prepare(struct cdnsp_device *pdev,
>> -				struct cdnsp_request *preq);
>> +int cdnsp_queue_isoc_tx(struct cdnsp_device *pdev,
>> +			struct cdnsp_request *preq);
>
>Why you re-name this function?
>
>Other changes are ok for me.
>

The function cdnsp_queue_isoc_tx_prepare has been removed and replaced
with cdnsp_queue_isoc_tx.  I just add declaration of this function to heade=
r file.
Before change cdnsp_queue_isoc_tx was static function.

Regards,
Pawel

>>  void cdnsp_queue_configure_endpoint(struct cdnsp_device *pdev,
>>  				    dma_addr_t in_ctx_ptr);
>>  void cdnsp_queue_reset_ep(struct cdnsp_device *pdev, unsigned int
>> ep_index); diff --git a/drivers/usb/cdns3/cdnsp-ring.c
>> b/drivers/usb/cdns3/cdnsp-ring.c index b23e543b3a3d..07f6068342d4
>> 100644
>> --- a/drivers/usb/cdns3/cdnsp-ring.c
>> +++ b/drivers/usb/cdns3/cdnsp-ring.c
>> @@ -1333,6 +1333,20 @@ static int cdnsp_handle_tx_event(struct
>cdnsp_device *pdev,
>>  					 ep_ring->dequeue, td->last_trb,
>>  					 ep_trb_dma);
>>
>> +		desc =3D td->preq->pep->endpoint.desc;
>> +
>> +		if (ep_seg) {
>> +			ep_trb =3D &ep_seg->trbs[(ep_trb_dma - ep_seg->dma)
>> +					       / sizeof(*ep_trb)];
>> +
>> +			trace_cdnsp_handle_transfer(ep_ring,
>> +					(struct cdnsp_generic_trb *)ep_trb);
>> +
>> +			if (pep->skip && usb_endpoint_xfer_isoc(desc) &&
>> +			    td->last_trb !=3D ep_trb)
>> +				return -EAGAIN;
>> +		}
>> +
>>  		/*
>>  		 * Skip the Force Stopped Event. The event_trb(ep_trb_dma)
>>  		 * of FSE is not in the current TD pointed by ep_ring->dequeue
>@@
>> -1347,7 +1361,6 @@ static int cdnsp_handle_tx_event(struct cdnsp_device
>*pdev,
>>  			goto cleanup;
>>  		}
>>
>> -		desc =3D td->preq->pep->endpoint.desc;
>>  		if (!ep_seg) {
>>  			if (!pep->skip || !usb_endpoint_xfer_isoc(desc)) {
>>  				/* Something is busted, give up! */ @@ -
>1374,12 +1387,6 @@ static
>> int cdnsp_handle_tx_event(struct cdnsp_device *pdev,
>>  			goto cleanup;
>>  		}
>>
>> -		ep_trb =3D &ep_seg->trbs[(ep_trb_dma - ep_seg->dma)
>> -				       / sizeof(*ep_trb)];
>> -
>> -		trace_cdnsp_handle_transfer(ep_ring,
>> -					    (struct cdnsp_generic_trb *)ep_trb);
>> -
>>  		if (cdnsp_trb_is_noop(ep_trb))
>>  			goto cleanup;
>>
>> @@ -1726,11 +1733,6 @@ static unsigned int count_sg_trbs_needed(struct
>cdnsp_request *preq)
>>  	return num_trbs;
>>  }
>>
>> -static unsigned int count_isoc_trbs_needed(struct cdnsp_request
>> *preq) -{
>> -	return cdnsp_count_trbs(preq->request.dma, preq->request.length);
>> -}
>> -
>>  static void cdnsp_check_trb_math(struct cdnsp_request *preq, int
>> running_total)  {
>>  	if (running_total !=3D preq->request.length) @@ -2192,28 +2194,48 @@
>> static unsigned int  }
>>
>>  /* Queue function isoc transfer */
>> -static int cdnsp_queue_isoc_tx(struct cdnsp_device *pdev,
>> -			       struct cdnsp_request *preq)
>> +int cdnsp_queue_isoc_tx(struct cdnsp_device *pdev,
>> +			struct cdnsp_request *preq)
>>  {
>> -	int trb_buff_len, td_len, td_remain_len, ret;
>> +	unsigned int trb_buff_len, td_len, td_remain_len, block_len;
>>  	unsigned int burst_count, last_burst_pkt;
>>  	unsigned int total_pkt_count, max_pkt;
>>  	struct cdnsp_generic_trb *start_trb;
>> +	struct scatterlist *sg =3D NULL;
>>  	bool more_trbs_coming =3D true;
>>  	struct cdnsp_ring *ep_ring;
>> +	unsigned int num_sgs =3D 0;
>>  	int running_total =3D 0;
>>  	u32 field, length_field;
>> +	u64 addr, send_addr;
>>  	int start_cycle;
>>  	int trbs_per_td;
>> -	u64 addr;
>> -	int i;
>> +	int i, sent_len, ret;
>>
>>  	ep_ring =3D preq->pep->ring;
>> +
>> +	td_len =3D preq->request.length;
>> +
>> +	if (preq->request.num_sgs) {
>> +		num_sgs =3D preq->request.num_sgs;
>> +		sg =3D preq->request.sg;
>> +		addr =3D (u64)sg_dma_address(sg);
>> +		block_len =3D sg_dma_len(sg);
>> +		trbs_per_td =3D count_sg_trbs_needed(preq);
>> +	} else {
>> +		addr =3D (u64)preq->request.dma;
>> +		block_len =3D td_len;
>> +		trbs_per_td =3D count_trbs_needed(preq);
>> +	}
>> +
>> +	ret =3D cdnsp_prepare_transfer(pdev, preq, trbs_per_td);
>> +	if (ret)
>> +		return ret;
>> +
>>  	start_trb =3D &ep_ring->enqueue->generic;
>>  	start_cycle =3D ep_ring->cycle_state;
>> -	td_len =3D preq->request.length;
>> -	addr =3D (u64)preq->request.dma;
>>  	td_remain_len =3D td_len;
>> +	send_addr =3D addr;
>>
>>  	max_pkt =3D usb_endpoint_maxp(preq->pep->endpoint.desc);
>>  	total_pkt_count =3D DIV_ROUND_UP(td_len, max_pkt); @@ -2225,11
>+2247,6
>> @@ static int cdnsp_queue_isoc_tx(struct cdnsp_device *pdev,
>>  	burst_count =3D cdnsp_get_burst_count(pdev, preq, total_pkt_count);
>>  	last_burst_pkt =3D cdnsp_get_last_burst_packet_count(pdev, preq,
>>  							   total_pkt_count);
>> -	trbs_per_td =3D count_isoc_trbs_needed(preq);
>> -
>> -	ret =3D cdnsp_prepare_transfer(pdev, preq, trbs_per_td);
>> -	if (ret)
>> -		goto cleanup;
>>
>>  	/*
>>  	 * Set isoc specific data for the first TRB in a TD.
>> @@ -2248,6 +2265,7 @@ static int cdnsp_queue_isoc_tx(struct
>> cdnsp_device *pdev,
>>
>>  		/* Calculate TRB length. */
>>  		trb_buff_len =3D TRB_BUFF_LEN_UP_TO_BOUNDARY(addr);
>> +		trb_buff_len =3D min(trb_buff_len, block_len);
>>  		if (trb_buff_len > td_remain_len)
>>  			trb_buff_len =3D td_remain_len;
>>
>> @@ -2256,7 +2274,8 @@ static int cdnsp_queue_isoc_tx(struct cdnsp_device
>*pdev,
>>  					       trb_buff_len, td_len, preq,
>>  					       more_trbs_coming, 0);
>>
>> -		length_field =3D TRB_LEN(trb_buff_len) | TRB_INTR_TARGET(0);
>> +		length_field =3D TRB_LEN(trb_buff_len) |
>TRB_TD_SIZE(remainder) |
>> +			TRB_INTR_TARGET(0);
>>
>>  		/* Only first TRB is isoc, overwrite otherwise. */
>>  		if (i) {
>> @@ -2281,12 +2300,27 @@ static int cdnsp_queue_isoc_tx(struct
>cdnsp_device *pdev,
>>  		}
>>
>>  		cdnsp_queue_trb(pdev, ep_ring, more_trbs_coming,
>> -				lower_32_bits(addr), upper_32_bits(addr),
>> +				lower_32_bits(send_addr),
>upper_32_bits(send_addr),
>>  				length_field, field);
>>
>>  		running_total +=3D trb_buff_len;
>>  		addr +=3D trb_buff_len;
>>  		td_remain_len -=3D trb_buff_len;
>> +
>> +		sent_len =3D trb_buff_len;
>> +		while (sg && sent_len >=3D block_len) {
>> +			/* New sg entry */
>> +			--num_sgs;
>> +			sent_len -=3D block_len;
>> +			if (num_sgs !=3D 0) {
>> +				sg =3D sg_next(sg);
>> +				block_len =3D sg_dma_len(sg);
>> +				addr =3D (u64)sg_dma_address(sg);
>> +				addr +=3D sent_len;
>> +			}
>> +		}
>> +		block_len -=3D sent_len;
>> +		send_addr =3D addr;
>>  	}
>>
>>  	/* Check TD length */
>> @@ -2324,30 +2358,6 @@ static int cdnsp_queue_isoc_tx(struct
>cdnsp_device *pdev,
>>  	return ret;
>>  }
>>
>> -int cdnsp_queue_isoc_tx_prepare(struct cdnsp_device *pdev,
>> -				struct cdnsp_request *preq)
>> -{
>> -	struct cdnsp_ring *ep_ring;
>> -	u32 ep_state;
>> -	int num_trbs;
>> -	int ret;
>> -
>> -	ep_ring =3D preq->pep->ring;
>> -	ep_state =3D GET_EP_CTX_STATE(preq->pep->out_ctx);
>> -	num_trbs =3D count_isoc_trbs_needed(preq);
>> -
>> -	/*
>> -	 * Check the ring to guarantee there is enough room for the whole
>> -	 * request. Do not insert any td of the USB Request to the ring if the
>> -	 * check failed.
>> -	 */
>> -	ret =3D cdnsp_prepare_ring(pdev, ep_ring, ep_state, num_trbs,
>GFP_ATOMIC);
>> -	if (ret)
>> -		return ret;
>> -
>> -	return cdnsp_queue_isoc_tx(pdev, preq);
>> -}
>> -
>>  /****		Command Ring Operations		****/
>>  /*
>>   * Generic function for queuing a command TRB on the command ring.
>> --
>> 2.25.1
>>
>
>--
>
>Thanks,
>Peter Chen
