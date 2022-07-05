Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6E9E567142
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 16:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231908AbiGEOgV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 10:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbiGEOgU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 10:36:20 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF44A55AE
        for <stable@vger.kernel.org>; Tue,  5 Jul 2022 07:36:19 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 265DV7LE030671
        for <stable@vger.kernel.org>; Tue, 5 Jul 2022 07:36:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 mime-version; s=facebook; bh=p15WkyAXqX+KvWkSQZko33u1Sgstt4iSyMmkmUKWIu8=;
 b=nUm0/Ji+84xPe7hQO1pPyBa+URIY0pV5RjJXZfOXM9bH6RnmM99HWsDYkZgWT/bOAuoc
 0nGS1QliEfGM0/iXG+szf74GtYACA6yPy/sbXwK7bX/l+Cc5H+RCybYttQeNTpmNvEuq
 xs8ZEHSZfQNemgG4Q+jnRTkqPZMZ9+Ndfq0= 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2048.outbound.protection.outlook.com [104.47.56.48])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h2hbqr74s-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 05 Jul 2022 07:36:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IHg+dWCGhyFN+EUJR2X6x4qgFXT8kIiJPhpgbJ8yXyPKYc7I9WJ5xeQliVpwkZ/i3HzwUUDMaznqagt2Nlez7HN3yd8GMh4mUBwIaSX3l7DhsBLiDn7WsExPIvRMEzrtwLBn3cOqljbxA+lFqVEzzJ5Xb9dPp8FE2g6F9q6bYe6VXEp8dK+UD/m5dkfhVK/soV5fGtd7Fy1V5d/zo6LJdYB9cLp2rAuSMkekco+VKTsCM9bB2lzLyJZithEOV7sL344ZdLNVu7cg/j9fsUjR+BvkVjJa8PK28No2gl8qMISDwbzKuXKUhvltGbyZ9SO97dZSe20Vb+MwTlRnlX77gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p15WkyAXqX+KvWkSQZko33u1Sgstt4iSyMmkmUKWIu8=;
 b=SELdUCgiUiEokthLcnuhZ/G5lkX9en+1QSLWPlgrDbaUwbjca72FkYEO4lhRGFiUJ5VXXSKXwqrJ8LduOPQZhddYPC6+0HaTfuuSFw6SVrkCPy2lysFvQz1b2hv6Ezlqes6YPohR7ez65P4A4ICxO6ZYNqS2uMxri+7k1VrxgXOt3U1/CUjSyx1ceEhzUFCszrLl/xk/kBGnlQgv9sq7t/CwMXJ/mxH8aEGvjq44DVLO41JHSAMbh3mcySbkWsbZ128VHhiIW7utG3bCMxa3pvJ9zO4nb46Aw7uZWp8JA43ESUXYlU151vpm/8Z92oPBdt5/mNVONTSERx54rbjk8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by DM5PR15MB1595.namprd15.prod.outlook.com (2603:10b6:3:cd::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.18; Tue, 5 Jul
 2022 14:36:16 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::9cb0:7576:f093:4631]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::9cb0:7576:f093:4631%7]) with mapi id 15.20.5395.022; Tue, 5 Jul 2022
 14:36:16 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] io_uring: fix provided buffer import"
 failed to apply to 5.18-stable tree
Thread-Topic: FAILED: patch "[PATCH] io_uring: fix provided buffer import"
 failed to apply to 5.18-stable tree
Thread-Index: AQHYj6ljmn4IdP/+TEuA64KLFoaRP61v2daA
Date:   Tue, 5 Jul 2022 14:36:16 +0000
Message-ID: <459dd43dc3f05e34eaf520752f3eb46daacd536a.camel@fb.com>
References: <1656941060218130@kroah.com>
In-Reply-To: <1656941060218130@kroah.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 89575b16-559c-4ad8-c0c8-08da5e93b7cd
x-ms-traffictypediagnostic: DM5PR15MB1595:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ppawj1J561RsS6RyS4yhd+RBUWyj9pyJZwB2/D0QbPBXakEJFsX7aWxtMjtGe45Eamt5JhltIc7NDqyEF48yrhtMP2KUoSmJWAN1WuBMLP71RB4ZtY1rbWErArdFVjelcx2QR9hD5bviuXRowwgZI8p6iKLXcvj33cBnIei0ChV+c27645wPQEu6QM8fYpN/yjB+K6wHppLMXZBNtLO3c9qQZPj8hPQdQpmuLFhzmmH6UUlRsCgjPaihVUXwHePDvu1mBYVbATrqYtidfJo6881Qo91aSfpbLYnW2bvAdLm3zYWZ5j1RAO2BjV9JniD40G6BhN19gAX3LzLzvLpCRdnKTJZxBLm/vn0lsY/3/6DevAA9sjIxn9fiIUnng70EOH3YQhNh+Nss1BgMrQKgLwKyeV7iEtPwe/MTPtZg+LT27Fdd1w2KmWlrfO9KfInCzjAmbP89B4rh8yuB9ZzLGo8SbMsKPV5wV2SU4wjI0YINnsD0+L86NEA5bA+ScT1LrVqYOW4jY5Wrw+gdn3PrJfz+wYy/1Kfmf8gnnw7b9wxSm3IlkfNTaTO8McGyV7NYp+aTBK7U9Kgq/Db/ajjgB18ZX+BxLii/xOXvAc7cnqwDzCxo7CmcMs30VV5cRVdiq/sAPVOA7ccDIWwdd97NZIZwOfb9QgF5hXkY73OmjzN+Y4P6iV2OxjgvlME1ReVeEdQPYGVRK6C/BTXLq6aHQhSZxdaYUqx13XCXC/Tc3OGRmHtf2VLqayMFnixEYdjnyRzWWzM9TW/FhcP+bC0dV15XZEPP+ZBnNz/H5IcIY4igKEmf9Rdt4YCFcQIgAprD6EJqYwbDUp6SgVbhWf7vrB2JbjXwg1MbN5GvMMChUjw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(376002)(39860400002)(366004)(346002)(186003)(2906002)(26005)(6512007)(41300700001)(2616005)(99936003)(316002)(122000001)(6506007)(38070700005)(83380400001)(86362001)(38100700002)(53546011)(5660300002)(36756003)(110136005)(6486002)(966005)(71200400001)(76116006)(4326008)(8936002)(66446008)(66476007)(66556008)(8676002)(64756008)(66946007)(478600001)(91956017);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WkE2cUc5NjA4TldMc0J5dWpxRGkwVVA2ck55aktGQ1VxZnBBSWhLbUljZG8r?=
 =?utf-8?B?cU9BOG5PYWw2YkxSWmRobVlmRUsvdllxZXMrTjVhQWlQZ3REWHFEOWVQUkUz?=
 =?utf-8?B?T3hCbENzYS84SjFtaFFzMjlvMlIybm9EWjZMbkJqNTN4RmlQS3NzVWYwVVdh?=
 =?utf-8?B?QVE2RVJWSG5NWVhxZXpNcjFXV3RNdUR3ZDVZVlJwbEd5ckFjRlFWRE9WUkVj?=
 =?utf-8?B?ZHUzcjArQjVzY0RpWnFSNHFNd2hnYmVnTWRaQkZ1N0VFOWR1SHhwZzBHejJJ?=
 =?utf-8?B?ejNGeWg1N05xMEpreWVLd0cwQUloQlNpaXUzS3hubmRDd3I5WWZGMHdJaWhq?=
 =?utf-8?B?TmNzSHNFMG1NTE1lbUIxTWliNmVScW92MjZ3NnhvbTBJWjBzOGFOOHBtNkNt?=
 =?utf-8?B?REJhQlAwVjhUTDFEeXZJcWRuYWYzbDFhKzYvUkUwOVEvSy9FbG5uVGtQcHJ1?=
 =?utf-8?B?QnEvaldMY09TTzdweHBKeWh3MDBIT3Ryc1RTSDRVU0M5UVlzZUhqU2JkOEg1?=
 =?utf-8?B?bGJJS0EzQzlVS3h4OFdRNElRbDI2M2luN0I5c0RlVWllTS9sTG5NQ25UMlhv?=
 =?utf-8?B?MUxJSWRoRjlKZHlPZGtlb2VHR0RHV1gzOU0wU2JSWXZOZGZpTEhJdjlTY3gz?=
 =?utf-8?B?WWVDK0oxdGtNSlpHa2J3UmUxZ296UGwzbEliSklOMmtOV09ZRzZISGVlTXE4?=
 =?utf-8?B?WURmSXhPOERGMGkranNzbXI5UzIyZU0vQzVnK2RvR2F2aE5jZjYxZU1yekph?=
 =?utf-8?B?U0MyZ2pNM201dmE4YndJV3RsY1JDLy9pTXhsMHFtYnpkcWl4ZXo1WEFXR01Y?=
 =?utf-8?B?VTBNT3lvREVrQ05hVTloZGwzbHdlR1BHY0tlYm9oS2RTVi9qMk5SSnJRemFq?=
 =?utf-8?B?NFlKZWE1Q0lVbWVKTURtaU81NzJHWFZ4VUJSNFk2dzlTZzZKeDFRRVhPaTdS?=
 =?utf-8?B?VTRpTTZVNk9KT0YvcDE2S1JvaGxoWXV3SS9OWTlSYVFRK21FWmg4eTd2b2Fm?=
 =?utf-8?B?cFRZbDVPLzZMU2IxSUIvWHN0eEx5SFdMcXpGcjEzTVptck8yZkxENmdlVzht?=
 =?utf-8?B?NFBiK1lKTkJGZkFaZkZjaDNud3k3ZDgvOXlUWDdQQmxReVdNS0I5MER2N1ow?=
 =?utf-8?B?KzJ4QkFzajlZM1F4VFMwVUJZUm1GZ2RoMUpWRDlubGUrUm80MDk4NERlTUlq?=
 =?utf-8?B?TzZMNyttOEpiWEtFL2gvRkp1dlQxK3k0U3E4L0hoenlhOC9QNWhyazh0em92?=
 =?utf-8?B?NG1VTGh3TTJ6c2dJOE1zRlRTMjBza2NRbHFOR1RkQk5nQlQyd0RQSTA0d3VK?=
 =?utf-8?B?V2krd056U3oxOEJXdTA3aFZUanFYOGNFNnNQV2R2MXB1VXFEUk9LTVZtTHNs?=
 =?utf-8?B?MEphdkJKNU16YnZISEFnNjVEcWd6eDVYekp0dS9KZitBOW5vZmZhWHN2NXV0?=
 =?utf-8?B?Ylc2TzZoMlVTUlcreEhic1FTd09OVEdwdTcvOVFwVzNhUklka2tvMTZrRkVZ?=
 =?utf-8?B?emphbVhqUFVsYzBvV0ZrbGxhRVhCL2lEWnMwNmh4UmNJSG9pdTgwci96MGZY?=
 =?utf-8?B?Nzd4K3NYb3l6cmlBLzJJcDFiSTZQZDM4RWo1MW5JVStvVnNJc3hCVlk4WnNG?=
 =?utf-8?B?SVNKa3B6dE9Db2pweVJXb3crV3JuNHhhdzRFUG54eHB5Y2laYkpFendUOEpq?=
 =?utf-8?B?WkR4SlVvcldXa203bUZ2NVdXZ2VtVHZNMU04QmNDbkxESnhuUlIrK09JQStL?=
 =?utf-8?B?eU1BdHRWWW9JRnNuMHY4aWc3RHJ1SCsxZlJuQzdVbDVkeHBnYk4yUTRKblZw?=
 =?utf-8?B?dEk5cjd1QW1HVjhDVDRrS1ZNWThpUG5PbUg4UmlVbC8wN1FybEFmT25mZjlC?=
 =?utf-8?B?Z1VZYUY4ckxwM3FvWWtmQ3JpMTdqeEF6eDkybGhtbFpwM1lIWjkwUkFJSStV?=
 =?utf-8?B?dHc3YUw0Titka0EzV0l6SEwxQm1hRUlFNERMRDZXSmRkSDdMUlR0RXRmWVl5?=
 =?utf-8?B?S29RNlFFRmVPY2hlS0RvWXQ2MklVQzRwdDArOExKNGVGWUJvQ21tMlNKZXlC?=
 =?utf-8?B?V1o2LzdUeWdOZW1aWWxjUUk2bE96T3RxK3gwVDVPTUhZWTM5SG9GMmcwL2NE?=
 =?utf-8?Q?MWM547qaki2pCudJ/EqvML58T?=
Content-Type: multipart/mixed;
        boundary="_002_459dd43dc3f05e34eaf520752f3eb46daacd536acamelfbcom_"
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89575b16-559c-4ad8-c0c8-08da5e93b7cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2022 14:36:16.3108
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tDT5ntx+BrhNlUn4xOA9HsmEA1gcixPLgM5ua5gE9/henpgW3nM63Rmm98bVuDNI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1595
X-Proofpoint-GUID: zjm7p8Z-O7XmoUmidtyAgtID2oA7umU2
X-Proofpoint-ORIG-GUID: zjm7p8Z-O7XmoUmidtyAgtID2oA7umU2
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-05_11,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--_002_459dd43dc3f05e34eaf520752f3eb46daacd536acamelfbcom_
Content-Type: text/plain; charset="utf-8"
Content-ID: <0D5027445BF9C84881B3161DE17355BC@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64

T24gTW9uLCAyMDIyLTA3LTA0IGF0IDE1OjI0ICswMjAwLCBncmVna2hAbGludXhmb3VuZGF0aW9u
Lm9yZyB3cm90ZToKPiAKPiBUaGUgcGF0Y2ggYmVsb3cgZG9lcyBub3QgYXBwbHkgdG8gdGhlIDUu
MTgtc3RhYmxlIHRyZWUuCj4gSWYgc29tZW9uZSB3YW50cyBpdCBhcHBsaWVkIHRoZXJlLCBvciB0
byBhbnkgb3RoZXIgc3RhYmxlIG9yIGxvbmd0ZXJtCj4gdHJlZSwgdGhlbiBwbGVhc2UgZW1haWwg
dGhlIGJhY2twb3J0LCBpbmNsdWRpbmcgdGhlIG9yaWdpbmFsIGdpdAo+IGNvbW1pdAo+IGlkIHRv
IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPi4KPiAKPiB0aGFua3MsCj4gCj4gZ3JlZyBrLWgKPiAK
PiAtLS0tLS0tLS0tLS0tLS0tLS0gb3JpZ2luYWwgY29tbWl0IGluIExpbnVzJ3MgdHJlZSAtLS0t
LS0tLS0tLS0tLS0tLS0KPiAKPiBGcm9tIDA5MDA3YWYyYjYyN2YwZjE5NWM2YzUzYzQ4MjliMjg1
Y2MzOTkwZWMgTW9uIFNlcCAxNyAwMDowMDowMAo+IDIwMDEKPiBGcm9tOiBEeWxhbiBZdWRha2Vu
IDxkeWxhbnlAZmIuY29tPgo+IERhdGU6IFRodSwgMzAgSnVuIDIwMjIgMDY6MjA6MDYgLTA3MDAK
PiBTdWJqZWN0OiBbUEFUQ0hdIGlvX3VyaW5nOiBmaXggcHJvdmlkZWQgYnVmZmVyIGltcG9ydAo+
IAo+IGlvX2ltcG9ydF9pb3ZlYyB1c2VzIHRoZSBzIHBvaW50ZXIsIGJ1dCB0aGlzIHdhcyBjaGFu
Z2VkIGltbWVkaWF0ZWx5Cj4gYWZ0ZXIgdGhlIGlvdmVjIHdhcyByZS1pbXBvcnRlZCBhbmQgc28g
aXQgd2FzIGltcG9ydGVkIGludG8gdGhlIHdyb25nCj4gcGxhY2UuCj4gCj4gQ2hhbmdlIHRoZSBv
cmRlcmluZy4KPiAKPiBGaXhlczogMmJlMmViMDJlMmY1ICgiaW9fdXJpbmc6IGVuc3VyZSByZWFk
cyByZS1pbXBvcnQgZm9yIHNlbGVjdGVkCj4gYnVmZmVycyIpCj4gU2lnbmVkLW9mZi1ieTogRHls
YW4gWXVkYWtlbiA8ZHlsYW55QGZiLmNvbT4KPiBMaW5rOgo+IGh0dHBzOi8vbG9yZS5rZXJuZWwu
b3JnL3IvMjAyMjA2MzAxMzIwMDYuMjgyNTY2OC0xLWR5bGFueUBmYi5jb20KPiBbYXhib2U6IGVu
c3VyZSB3ZSBkb24ndCBoYWxmLWltcG9ydCBhcyB3ZWxsXQo+IFNpZ25lZC1vZmYtYnk6IEplbnMg
QXhib2UgPGF4Ym9lQGtlcm5lbC5kaz4KPiAKPiBkaWZmIC0tZ2l0IGEvZnMvaW9fdXJpbmcuYyBi
L2ZzL2lvX3VyaW5nLmMKPiBpbmRleCBhZWIwNDJiYTVjYzUuLjBkNDkxYWQxNWI2NiAxMDA2NDQK
PiAtLS0gYS9mcy9pb191cmluZy5jCj4gKysrIGIvZnMvaW9fdXJpbmcuYwo+IEBAIC00MzE4LDE4
ICs0MzE4LDE5IEBAIHN0YXRpYyBpbnQgaW9fcmVhZChzdHJ1Y3QgaW9fa2lvY2IgKnJlcSwKPiB1
bnNpZ25lZCBpbnQgaXNzdWVfZmxhZ3MpCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqBpZiAodW5saWtlbHkocmV0IDwgMCkpCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIHJldDsKPiDCoMKgwqDCoMKgwqDCoMKgfSBlbHNlIHsK
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcncgPSByZXEtPmFzeW5jX2RhdGE7Cj4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHMgPSAmcnctPnM7Cj4gKwo+IMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgLyoKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCAqIFNhZmUgYW5kIHJlcXVpcmVkIHRvIHJlLWltcG9ydCBpZiB3ZSdyZSB1c2luZwo+IHBy
b3ZpZGVkCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKiBidWZmZXJzLCBhcyB3
ZSBkcm9wcGVkIHRoZSBzZWxlY3RlZCBvbmUgYmVmb3JlCj4gcmV0cnkuCj4gwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgKi8KPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
aWYgKHJlcS0+ZmxhZ3MgJiBSRVFfRl9CVUZGRVJfU0VMRUNUKSB7Cj4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoGlmIChpb19kb19idWZmZXJfc2VsZWN0KHJlcSkpIHsKPiDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXQgPSBpb19pbXBvcnRf
aW92ZWMoUkVBRCwgcmVxLCAmaW92ZWMsIHMsCj4gaXNzdWVfZmxhZ3MpOwo+IMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmICh1bmxpa2VseShyZXQgPCAw
KSkKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgcmV0dXJuIHJldDsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oH0KPiDCoAo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBydyA9IHJlcS0+YXN5bmNf
ZGF0YTsKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcyA9ICZydy0+czsKPiDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoC8qCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgKiBXZSBjb21lIGhlcmUgZnJvbSBhbiBlYXJsaWVyIGF0dGVtcHQsIHJlc3RvcmUg
b3VyCj4gc3RhdGUgdG8KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqIG1hdGNo
IGluIGNhc2UgaXQgZG9lc24ndC4gSXQncyBjaGVhcCBlbm91Z2ggdGhhdAo+IHdlIGRvbid0Cj4g
CgpIaSwKCkkgaGF2ZSBhdHRhY2hlZCBhIGZpeGVkIHBhdGNoIHdoaWNoIGZpeGVzIHRoZSBwcm9i
bGVtIG9uIDUuMTgKClRoYW5rcywKRHlsYW4KCgo=

--_002_459dd43dc3f05e34eaf520752f3eb46daacd536acamelfbcom_
Content-Type: text/x-patch;
	name="0001-io_uring-fix-provided-buffer-import.patch"
Content-Description: 0001-io_uring-fix-provided-buffer-import.patch
Content-Disposition: attachment;
	filename="0001-io_uring-fix-provided-buffer-import.patch"; size=2159;
	creation-date="Tue, 05 Jul 2022 14:36:16 GMT";
	modification-date="Tue, 05 Jul 2022 14:36:16 GMT"
Content-ID: <0B344EE9603DB040969B9B00EFE5DC2A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64

RnJvbSA0OGU3NmU4MTA5M2RjMmU0ZTdmMmZkMmQ5NWYwYTM5YzEwNzhlN2JkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEeWxhbiBZdWRha2VuIDxkeWxhbnlAZmIuY29tPgpEYXRlOiBU
aHUsIDMwIEp1biAyMDIyIDA2OjIwOjA2IC0wNzAwClN1YmplY3Q6IFtQQVRDSF0gaW9fdXJpbmc6
IGZpeCBwcm92aWRlZCBidWZmZXIgaW1wb3J0Cgpjb21taXQgMDkwMDdhZjJiNjI3ZjBmMTk1YzZj
NTNjNDgyOWIyODVjYzM5OTBlYyB1cHN0cmVhbS4KCmlvX2ltcG9ydF9pb3ZlYyB1c2VzIHRoZSBz
IHBvaW50ZXIsIGJ1dCB0aGlzIHdhcyBjaGFuZ2VkIGltbWVkaWF0ZWx5CmFmdGVyIHRoZSBpb3Zl
YyB3YXMgcmUtaW1wb3J0ZWQgYW5kIHNvIGl0IHdhcyBpbXBvcnRlZCBpbnRvIHRoZSB3cm9uZwpw
bGFjZS4KCkNoYW5nZSB0aGUgb3JkZXJpbmcuCgpGaXhlczogMmJlMmViMDJlMmY1ICgiaW9fdXJp
bmc6IGVuc3VyZSByZWFkcyByZS1pbXBvcnQgZm9yIHNlbGVjdGVkIGJ1ZmZlcnMiKQpTaWduZWQt
b2ZmLWJ5OiBEeWxhbiBZdWRha2VuIDxkeWxhbnlAZmIuY29tPgpMaW5rOiBodHRwczovL2xvcmUu
a2VybmVsLm9yZy9yLzIwMjIwNjMwMTMyMDA2LjI4MjU2NjgtMS1keWxhbnlAZmIuY29tCltheGJv
ZTogZW5zdXJlIHdlIGRvbid0IGhhbGYtaW1wb3J0IGFzIHdlbGxdClNpZ25lZC1vZmYtYnk6IEpl
bnMgQXhib2UgPGF4Ym9lQGtlcm5lbC5kaz4KLS0tCiBmcy9pb191cmluZy5jIHwgMTQgKysrKysr
KysrKystLS0KIDEgZmlsZSBjaGFuZ2VkLCAxMSBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygt
KQoKZGlmZiAtLWdpdCBhL2ZzL2lvX3VyaW5nLmMgYi9mcy9pb191cmluZy5jCmluZGV4IDdjMTkw
ZTg4NTM0MC4uNGQ0ODhmZmIyOTdjIDEwMDY0NAotLS0gYS9mcy9pb191cmluZy5jCisrKyBiL2Zz
L2lvX3VyaW5nLmMKQEAgLTM0OTUsNiArMzQ5NSwxMyBAQCBzdGF0aWMgc3NpemVfdCBpb19pb3Zf
YnVmZmVyX3NlbGVjdChzdHJ1Y3QgaW9fa2lvY2IgKnJlcSwgc3RydWN0IGlvdmVjICppb3YsCiAJ
cmV0dXJuIF9faW9faW92X2J1ZmZlcl9zZWxlY3QocmVxLCBpb3YsIGlzc3VlX2ZsYWdzKTsKIH0K
IAorc3RhdGljIGlubGluZSBib29sIGlvX2RvX2J1ZmZlcl9zZWxlY3Qoc3RydWN0IGlvX2tpb2Ni
ICpyZXEpCit7CisJaWYgKCEocmVxLT5mbGFncyAmIFJFUV9GX0JVRkZFUl9TRUxFQ1QpKQorCQly
ZXR1cm4gZmFsc2U7CisJcmV0dXJuICEocmVxLT5mbGFncyAmIFJFUV9GX0JVRkZFUl9TRUxFQ1RF
RCk7Cit9CisKIHN0YXRpYyBzdHJ1Y3QgaW92ZWMgKl9faW9faW1wb3J0X2lvdmVjKGludCBydywg
c3RydWN0IGlvX2tpb2NiICpyZXEsCiAJCQkJICAgICAgIHN0cnVjdCBpb19yd19zdGF0ZSAqcywK
IAkJCQkgICAgICAgdW5zaWduZWQgaW50IGlzc3VlX2ZsYWdzKQpAQCAtMzg1NCwxOCArMzg2MSwx
OSBAQCBzdGF0aWMgaW50IGlvX3JlYWQoc3RydWN0IGlvX2tpb2NiICpyZXEsIHVuc2lnbmVkIGlu
dCBpc3N1ZV9mbGFncykKIAkJaWYgKHVubGlrZWx5KHJldCA8IDApKQogCQkJcmV0dXJuIHJldDsK
IAl9IGVsc2UgeworCQlydyA9IHJlcS0+YXN5bmNfZGF0YTsKKwkJcyA9ICZydy0+czsKKwogCQkv
KgogCQkgKiBTYWZlIGFuZCByZXF1aXJlZCB0byByZS1pbXBvcnQgaWYgd2UncmUgdXNpbmcgcHJv
dmlkZWQKIAkJICogYnVmZmVycywgYXMgd2UgZHJvcHBlZCB0aGUgc2VsZWN0ZWQgb25lIGJlZm9y
ZSByZXRyeS4KIAkJICovCi0JCWlmIChyZXEtPmZsYWdzICYgUkVRX0ZfQlVGRkVSX1NFTEVDVCkg
eworCQlpZiAoaW9fZG9fYnVmZmVyX3NlbGVjdChyZXEpKSB7CiAJCQlyZXQgPSBpb19pbXBvcnRf
aW92ZWMoUkVBRCwgcmVxLCAmaW92ZWMsIHMsIGlzc3VlX2ZsYWdzKTsKIAkJCWlmICh1bmxpa2Vs
eShyZXQgPCAwKSkKIAkJCQlyZXR1cm4gcmV0OwogCQl9CiAKLQkJcncgPSByZXEtPmFzeW5jX2Rh
dGE7Ci0JCXMgPSAmcnctPnM7CiAJCS8qCiAJCSAqIFdlIGNvbWUgaGVyZSBmcm9tIGFuIGVhcmxp
ZXIgYXR0ZW1wdCwgcmVzdG9yZSBvdXIgc3RhdGUgdG8KIAkJICogbWF0Y2ggaW4gY2FzZSBpdCBk
b2Vzbid0LiBJdCdzIGNoZWFwIGVub3VnaCB0aGF0IHdlIGRvbid0CgpiYXNlLWNvbW1pdDogNjRl
ZjdlNzI1ZGI0MTU1MmMyMTlhMTU1YWI4YzFmNmNhZjJlN2NiNAotLSAKMi4zMC4yCgo=

--_002_459dd43dc3f05e34eaf520752f3eb46daacd536acamelfbcom_--
