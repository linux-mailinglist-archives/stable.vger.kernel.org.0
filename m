Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B78B53B1481
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 09:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbhFWHWa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 03:22:30 -0400
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:34068 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229660AbhFWHW3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Jun 2021 03:22:29 -0400
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15N78T0G010403;
        Wed, 23 Jun 2021 00:20:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=ib4M6KAPYv6WFDBdrZHieJ+JbrfDPIdRfosMZ2eD4gI=;
 b=CCYG7tYYjDYqgNlxivlUTU8Ng6IiVRseyS2tol3y0Pked9H6+dC7asUveBwAk8SuRvmC
 moq3t+73a7uK8eoOHJL7CDQT4B8ozbxMJ4QRE3ur7Jtzo123WvjW1ftWWJMlQT56xYe5
 tl8TMsjCIRH85epKqhQTTNAeMPz4mU/nQr4yCDgx1BpAHADa7R3MQ+PZYbO0VXqachwQ
 vH9vWcmY2JXiKqHWTbUt0J5COgg7gzwq1w96CT6V+CHWr5EjyV46GC+me7LOKn/d+z8E
 IkekttxGiqUU5iYAxPbLiNVSzyQjFq8ZtH37mgmzj/2yjM11cRT8eSkBNaGv5Dy0sgAf 4Q== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by mx0a-0014ca01.pphosted.com with ESMTP id 39apms83n5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Jun 2021 00:20:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Boq9bHNsbwJjTDL3BYqgLwPAoyxyCG7uHkNdYx/NvbilFov6b7Cb4LDOkoiG0DZq/zdQHOV24FGuVDlcvTSBFGkmM7GozvCKvc2zO41J3bREXR58NlK3gMpTdf6f+SoyBl/A7TOBp1GZaypKLQng3ge5+okJ/5uMVsScdyeIrVTBh3D8QkVw5cqOgZo9YHfDjMQQ7GiadGm8yGiUiLOCGz6wU4tP509JZ1DAzCxN/QZr6r6VBIO9Fr/09herwQscWhDoUnLx0GAfvrNJdawIx5DfP7bnXaCGdrL8T+UiJ65ZanIGeA5y6aFZBwgYarEygmQ+v6bKL0Cj+Df4GwaVlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ib4M6KAPYv6WFDBdrZHieJ+JbrfDPIdRfosMZ2eD4gI=;
 b=G3j9+NyXl6wwhqTd+HFJGPUXX5YrWvw+q04IHBFoEpUe2oP7u7hlVDG3iXXSVJl2dw+A0foHii+HgXWCxj8ZDzoXU08MLMKdayZznDRksEdtYyNwlnlZ5vSLAdU1CD4BH0EhF08NhIaFJYeQWJuv/8hTz1ouI6soU+q0dVIP7MF6EQPpeuJEVx5Uns/zxVOFtQ+f0t53hZbUNxoa5UtDH9r1bkcQzt1YsCyVGtyBR2KAdolQAw5dRM9B0VjwF1laUfK/KHA6XYTkgdCwJMAq9MbHasIei/O7zb9UyDqqQWe4hPvBTnZLMtVSfkZGQaiBqlkK3ngMM+VMPBp2Ti8gzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ib4M6KAPYv6WFDBdrZHieJ+JbrfDPIdRfosMZ2eD4gI=;
 b=eqOdGGTvF8MiM0Zw0ItX3zw8eYAHBc0ebpBY4cemUFmFtNJNWgBtM/Wwt30gkbo4puh31WS3GpY5XwlDxp6sV30uUqZhnDr+c8p6HtQaGaPhGz1Hdwcm0UBk9o/MkTcrno7hQcG2k7zYlqj2Sk2fupj/G5Y0SOOh3ZTzRi2v6bo=
Received: from BYAPR07MB5381.namprd07.prod.outlook.com (2603:10b6:a03:6d::24)
 by BYAPR07MB6823.namprd07.prod.outlook.com (2603:10b6:a03:128::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Wed, 23 Jun
 2021 07:20:07 +0000
Received: from BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::21a3:4648:fcda:e438]) by BYAPR07MB5381.namprd07.prod.outlook.com
 ([fe80::21a3:4648:fcda:e438%4]) with mapi id 15.20.4242.023; Wed, 23 Jun 2021
 07:20:07 +0000
From:   Pawel Laszczak <pawell@cadence.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] usb: cdns3: Fixed incorrect gadget state
Thread-Topic: [PATCH] usb: cdns3: Fixed incorrect gadget state
Thread-Index: AQHXZ/yiP+pMzLyhkkCNMNT6n78nfashLyqAgAAAi5A=
Date:   Wed, 23 Jun 2021 07:20:07 +0000
Message-ID: <BYAPR07MB5381FE8BF40DC930E4DE305FDD089@BYAPR07MB5381.namprd07.prod.outlook.com>
References: <20210623065426.30638-1-pawell@gli-login.cadence.com>
 <YNLfm4Xx888Fzsr+@kroah.com>
In-Reply-To: <YNLfm4Xx888Fzsr+@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccGF3ZWxsXGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEyOWUzNWJcbXNnc1xtc2ctNmQzMjYzMTAtZDNmMy0xMWViLTg3OTEtYTQ0Y2M4MWIwYzU1XGFtZS10ZXN0XDZkMzI2MzEyLWQzZjMtMTFlYi04NzkxLWE0NGNjODFiMGM1NWJvZHkudHh0IiBzej0iMTIzNiIgdD0iMTMyNjg5MDY0MDM3NjE2NzY3IiBoPSJQNmhxMTU1dmNDZ1JmdjluN0t6VnBHaGFhZGs9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=cadence.com;
x-originating-ip: [185.217.253.59]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 710c4daa-28e7-4728-de91-08d936175408
x-ms-traffictypediagnostic: BYAPR07MB6823:
x-microsoft-antispam-prvs: <BYAPR07MB682304705302B6A7C8F77E6CDD089@BYAPR07MB6823.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xZQSumroUCiAmCWBL5vfstOcOHWHOJAp9zuLavzm4/KibQKX6V+VJDO9DUEomlPH1i39ZZJtHjwiORhAidr7lWwuPZ+TPzfvlqZrES/NYfEVsh6O2ASgpQXXFPm4xWqcOU7myAhVj0PqCniM1hBP7FoFJ/0E7ytJWdQOfJ3bo1igAsMTCdkgQhUgKRP79Z0W0ZOfGy4+4ogtRnA5P8EH8BTYRgHxDAWkGvCQCPjXDeknkN21tguo2ppemWTH0DOE6cQ2Bdy0k3PWRChPZSCxYZEOR8H+mPn+94AjYOp+rgQ8fb6JvcspPOdakOnl2BBn+hRLpssx5sVB9gWU2M0CkOTBK8FZVmFOYI+y0hzRZvqm8GtvIRpaMw9wlB93H4w7t2Uaf+6dH9Td4AydE/HVTslvzBJSREn1xjZQohQt2aQZ9Uhj965Bh9hCBFAqIc/ktrzMdc9pXXAum56IWt/cbtrZZpomWk69M6/Gz1WK+FeAcV+0Cic5KlxZRe+vYr2RNQ9jmVImARC+UXn5eXjQzCkUckvOfpsaObjJEQLV1Tq1GUzyIRvhlGZ+YCnZRsgfIQRVsz+bkGpPzhsflRVYjAGSIhWadgUGEdVEDcFRdqBEbWryeGWbpJX1DeLRHLby/xGMfJT6zC7lXP0+X2vtk3TKFaTuU65eF4AGM6gNSV/YCCiip2vfslCsBl5WF89LpdqyBmmEQIqRonTwGzJt8/Yq32OJuEcKPmPafHHYSSJNZ/mMe1d65uxTNRfB/78hXWazoqTSf0XF+Llb02SXnw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR07MB5381.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(136003)(346002)(366004)(396003)(36092001)(8936002)(8676002)(316002)(6916009)(55016002)(9686003)(38100700002)(122000001)(52536014)(6506007)(26005)(7696005)(966005)(4326008)(186003)(478600001)(5660300002)(2906002)(71200400001)(83380400001)(86362001)(33656002)(66446008)(64756008)(66556008)(66476007)(66946007)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?spP0TToufZuFtUmJ2jmi2aswBhKw3VKfhDJGdpl5YRo51oxjMNZ5LPtCILik?=
 =?us-ascii?Q?8iHOD0BX3MhLzcjHBhk1Z2pfE12L4jXudgSwTWVltha3nM/tWzbKE51IQHMU?=
 =?us-ascii?Q?BlCrPri4XKRiZ/1tLkew8q84gmRsX6JWgscKrc79UP1uAudyzeJP3hUsJFfw?=
 =?us-ascii?Q?HMgp6TYj28ILDKHmoRaD/4Di9fmSjwRSOhFO0L4OUos1Y78SpKE6nrVkg4Ox?=
 =?us-ascii?Q?SfFdDOfTnOrK/I+O7sKopP97vGwNvd0DEf9GEQ8akYpfyvgaEjXmkz6xjXsG?=
 =?us-ascii?Q?OIdhKrn9GTm9AwKeQLQD+O5JYOqbDIdAnPUncp3GtoyDWzBMmiLlr4cdeEir?=
 =?us-ascii?Q?TzjPm97FaX1WjLmHKpdvolqxlt+5R1YWZBcJsCsa7DnobcBNVhjaTaDnArK/?=
 =?us-ascii?Q?L3w8t995cHF7AlWO+ZbEUwfOUGDFxjDYXRpDX1T0NdbZEbDCa+r3iDlOjUA2?=
 =?us-ascii?Q?Z5yQcT5F6d+OwmIkF+Cm9BJGHPXSz/OgHv0mWw5iXsu0wBDXMi2Oo6UWsRxO?=
 =?us-ascii?Q?vDWUTDhaqRJFNoOnybvQ9OhK6xwEzvRtu13NRmbZKD+ENMwmTfMLaiLPZcd5?=
 =?us-ascii?Q?FfiKC3MtxwpGdhcGDogazIbex9HpAOiztP6ihzOI+jlsZrdD/NS8hiJGmfWL?=
 =?us-ascii?Q?UBzjFCo2SCakvd2en57v20kIBK9nwkVtIZInM6uvXvjvso7BF6gsPHCJNmT4?=
 =?us-ascii?Q?lPESURtRZQMLr+w2XdrvYqE8+nnA77Chi0ZaB5TwKlwKc5rnYTWLXQW+pooF?=
 =?us-ascii?Q?7ZRv1WMx7clDQzcoxJb08aDp1d7kKmAYl0twkgvSCUkNrr0VNy5RvAZsbdLZ?=
 =?us-ascii?Q?0WPCbvDhd1GareCoSuH0xmtT9YQduzcdKOcBhtR7/BJnKlcLyoGoQ2uKggnk?=
 =?us-ascii?Q?gbiproZ2LdZ4nS8UWxI4nPrPC07lhZ8dpyJHOijx6BLkAI5l4l0LhImovuww?=
 =?us-ascii?Q?N4R/63Im6OSAw/4FldXBQy2w6f/u+Wj+uMaJForSv+JGD5/7qpsJ2Hp1aenr?=
 =?us-ascii?Q?SoDKM9/s3Pw+mhNbZ4Au3jLOfBfnJY/4NBe1BX1JaeGr+ASWXmCKdIMCsb4r?=
 =?us-ascii?Q?VnrA3gVLziS0Q4vBoJGeCdLinPHSj/XHmvxcA7BmWWOaTiIr0Yoj2LBupbfX?=
 =?us-ascii?Q?zfemTuDhbqwN3HyMYyZY5iWL731kO02CPFJKU25FhbUV/yflW7453zgBuJKd?=
 =?us-ascii?Q?vHMeR71romaiDgYQCqYC88VN8OILmbv8CEMDsXNMIGDFbAMRHti3E5W80TVa?=
 =?us-ascii?Q?sUGXnKDEZ+/QGzH7JU26HhwEuODuJ0utH+2XSIFFyCByzXYyUnqQyAS5QS9M?=
 =?us-ascii?Q?gnQhR9RT3ufwMGVzjV9Abg/0?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR07MB5381.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 710c4daa-28e7-4728-de91-08d936175408
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2021 07:20:07.0691
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g/kBdakbX3b73JwTFf7mct673IYzOJfrTM3U81uQQ6YcH+uRbHbzkuX21VcFS5++gGpsM1tvaTvfFTE3oWwgOVbLpPl6UqI2R5Glge32QPk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR07MB6823
X-Proofpoint-ORIG-GUID: -C0UHTS3GOuJfuO1cWi-Uyt423-djYba
X-Proofpoint-GUID: -C0UHTS3GOuJfuO1cWi-Uyt423-djYba
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-23_02:2021-06-22,2021-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 suspectscore=0
 mlxlogscore=498 phishscore=0 lowpriorityscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 bulkscore=0 mlxscore=0
 clxscore=1015 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2106230042
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


>
>
>On Wed, Jun 23, 2021 at 08:54:26AM +0200, Pawel Laszczak wrote:
>> From: Pawel Laszczak <pawell@cadence.com>
>>
>> For delayed status phase, the usb_gadget->state was set
>> to USB_STATE_ADDRESS and it has never been updated to
>> USB_STATE_CONFIGURED.
>> Patch updates the gadget state to correct USB_STATE_CONFIGURED.
>> As a result of this bug the controller was not able to enter to
>> Test Mode while using MSC function.
>>
>> Cc: <stable@vger.kernel.org>
>> Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
>> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
>> ---
>>  drivers/usb/cdns3/cdns3-ep0.c | 1 +
>>  1 file changed, 1 insertion(+)
>
><formletter>
>
>This is not the correct way to submit patches for inclusion in the
>stable kernel tree.  Please read:
>    https://urldefense.com/v3/__https://www.kernel.org/doc/html/latest/pro=
cess/stable-kernel-
>rules.html__;!!EHscmS1ygiU1lA!XxaV_glFP_ZgaIhiOKJKx4mZ-8nVVerjwA9heaOgDrhV=
CXF7fwUSsF9nMg8B8Q$
>for how to do this properly.
>
></formletter>

Yes, I know, sorry about that.=20
Patch has been sent again in correct way.

Regards,
Pawel
