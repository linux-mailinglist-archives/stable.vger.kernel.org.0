Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E916E4AF072
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 12:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbiBIL64 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 06:58:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231791AbiBIL5s (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 06:57:48 -0500
X-Greylist: delayed 482 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 09 Feb 2022 03:00:18 PST
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 557FAC03324F
        for <stable@vger.kernel.org>; Wed,  9 Feb 2022 03:00:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644404418; x=1675940418;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=tHppJeaJpPhXT9AmvF8duxSd6Z8UX7oI9NmtzZshtJE=;
  b=oOWexMOe2ObmTtepq/I79JacYdFAvSSSN2B60eqbFfkhaqUoD42RWh9N
   8S64zAj6Oi9wqUKU27uj31XLmcfge0fiG869vfYRvqNf3PVB4LbFmTXu2
   DkNBv2ia7ES0N7dTl1FZXU1rKzI+InwHuj0Ax3K3hq9y0nPqvObg9L+Yt
   na5Sbifw4xJU7rbcGKkdNk/iXQ+heGhK1/5dbcJfG5KUtOGoi9YWzCgpv
   eI5CMZweeBrkp5Cii8kz0pcWU/+qidcph5GTlPpsZSxmvf/elxYVuMFOx
   mVjO8eySG6bnLOt9oy/kb0K35F4wvnZdM9f15qj4E0fRxmprg9f3YnwZ+
   A==;
X-IronPort-AV: E=Sophos;i="5.88,355,1635177600"; 
   d="scan'208";a="304404218"
Received: from mail-co1nam11lp2168.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.168])
  by ob1.hgst.iphmx.com with ESMTP; 09 Feb 2022 18:45:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y60jx5FFHj8rd4jg/AsYdiOY+y0nh0ExYhF+T1sI4SeW5hTmqoBVa8OE8zlW+Zt2MMuLxy98aPxTMOIZIJq1L/pmBCF1MjeihJt+h3OIpxYcdefBwCop40PofbNOpmnOQL6b77bhJpHM0GlRLwrAWVbRSxtdJq5kdr7feyKG1nQT/4GpVf0v76MO9UJoZkOYFLMgeDgShsa+oe0NiE2BjmsmlFENbK4EB2gCQh9iHzLHYqRcxSyiGkFn3Z7NwgCx9XrCLKgCE3n56CvxnqMU+Pni4BbNlXfr4R7x/DjZg+tCJ+W6BgbqNxv8fqm3/BlL+NmgjTTHBlBOrfrsp4N0Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tHppJeaJpPhXT9AmvF8duxSd6Z8UX7oI9NmtzZshtJE=;
 b=E39ObwwN9zdDJyowU9i8sHqn9G/pEt8vzHpMZdmTp3WIXLE6Ke3+jBnMAElkqr8lMI1JoKCae1DgZebJluIrMovCRjLq5hTiZm7HuLGWAODnsOct+Db8fHSfn8Zhz6UHWD+gNqGBGDBkUKKgUxhPDby3fLdpwgleIpueKO1XFudlFXvL6fXk2JdhUJ3US9KQ3LFp3mXzvEUdD6w6p/JkqXB5DgB7XHgps7hUdN9C5sXnhQmmr0fcoRBoqW1lHJOPZR5L3UoJrdS/n0CRCgz0USqzyz0uXhIxsec2jaQ9YPZFMZWTROR4HArX0ShwEp3tFyoFyPYIE7pCcUgb/+xFBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tHppJeaJpPhXT9AmvF8duxSd6Z8UX7oI9NmtzZshtJE=;
 b=WcDbnE58Wea3m4WAAZNrcQyqYPMBdb3ZzZZn9aA4ClT+rPGsKPA0fXL5axUoBJmyzwvPo2S2xm/3NabMCpJeVZfEoCcSa+5Bw9PPYAFBVyjTUFlgA43FJsqAr6KRggyrKd4gr3+dAh9L9Mc+Gy9GwrsC2aXRAk454uiJjpaCknU=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by BYAPR04MB4342.namprd04.prod.outlook.com (2603:10b6:a02:f3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Wed, 9 Feb
 2022 10:45:04 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::c8f4:8499:a5fc:1835]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::c8f4:8499:a5fc:1835%3]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 10:45:04 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Lee Jones <lee.jones@linaro.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Bob Peterson <rpeterso@redhat.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Johannes Thumshirn <jth@kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "cluster-devel@redhat.com" <cluster-devel@redhat.com>,
        "syzbot+0ed9f769264276638893@syzkaller.appspotmail.com" 
        <syzbot+0ed9f769264276638893@syzkaller.appspotmail.com>
Subject: Re: [PATCH 1/1] Revert "iomap: fall back to buffered writes for
 invalidation failures"
Thread-Topic: [PATCH 1/1] Revert "iomap: fall back to buffered writes for
 invalidation failures"
Thread-Index: AQHYHZKAZQ1UEr0uOkW3jy3YFI7yZ6yLCQqA
Date:   Wed, 9 Feb 2022 10:45:04 +0000
Message-ID: <425511ee-8845-45b2-8750-db42e82938ae@wdc.com>
References: <20220209085243.3136536-1-lee.jones@linaro.org>
In-Reply-To: <20220209085243.3136536-1-lee.jones@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a368c7c3-2e6a-49e7-4bc6-08d9ebb93b41
x-ms-traffictypediagnostic: BYAPR04MB4342:EE_
x-microsoft-antispam-prvs: <BYAPR04MB4342CBC9115C538F626E779FE72E9@BYAPR04MB4342.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1265;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gPH14BuyDgkZm1vEP2QA9HXbbH0diAfpy50tuy9jopcvL0l2zm+aMT7D0yzz2Mv5nX4xqbvDNE1rDdW82vEfbw6ew6eLPgXe0d/F6NmFO8pJLvHC4SSk79MQ4v+lfRWTmkZQFb8KZtBmjfwaea3VXoBitwREQLqphbgiNjW1Zqzp5IU06Xbhv1wW/iuEJGDVenhx32lZnG0aECdjx6ktivivIAgPDJ6xy5ktZUv8imjvA8cc6o58KDroVgvValfG3DOKt1JjObHwsuo6yfXisjoShMZTBPDsyGVu0KEg8qbeJVhJWMhs2zuYMtP3R4kdYfsOFh3BbPuxXnIL9zZsC0+J8FrE9NpRttUrK2/vQ6BbjK52r/relDnzpCqZ5T5NzbZrzr7skhTN4NGifh4I/jWh873Jc1agvkTqPOYj2DdJrJSFIdkTDEytUq6F4hVqwJTauCP7vEa57HiagNR8D+USwTeVupzxpQlQFDlkbUIocsbwbOp1+Gvmn8/EAUVHLIlJYckCdGYmHy0wCbIWVMPxD8C4PSF3fp6+Ha6hPu85JmhyjacZhvkKn+CFONreEhYSoatB+V6one75505uX0DibQFeWomYoo+u20vN3rKvJZ2rt2tqnSCndHTiXrVvY+DG/cecpPAbqtDnDzPk4ltKARZlqE1dbWSjKct+mGw3hLbpHNiNNlFxU03MnaGH7/4gtdjvEjWS8nuYJNduMnbqJ/h4bk1cXaKxmBKRUj0jZ6rI7aXdAivaOcX269XhW2ZhySRB65aeLO1tjIF3ppjynO9+zkBCy18K5gKvS0/iFsSMK4An25atXoOvGaELaMEiZY13rTvDTXBKcux8L8bxPW/97/OvGipjnh6F9UdW6Eb5mANE7+ACLSPYAYBT
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66476007)(66556008)(66946007)(8676002)(76116006)(4326008)(38070700005)(64756008)(66446008)(122000001)(38100700002)(2906002)(31686004)(5660300002)(8936002)(6916009)(54906003)(91956017)(316002)(36756003)(7416002)(31696002)(6506007)(6512007)(53546011)(26005)(508600001)(186003)(6486002)(966005)(2616005)(83380400001)(71200400001)(86362001)(82960400001)(99710200001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MnhJMmtmWUpkbklPbE9oSGlrUWx6WUJGYThvT3FYdGpRVDRtRU1ENHZqY1pD?=
 =?utf-8?B?RnlwL1QwRTIxaXRuWGlxK2JTTlczdGJrdWpsZ2FZQnVYS1FBeUtRNktvZlhz?=
 =?utf-8?B?bXZVU1RNTC9JQU8vbkYxMG9oZnNWZDAxUDEwb2NEYUJmTXRkU2VkUWtzTlpy?=
 =?utf-8?B?WlViWjZ0dTlkcnVmTHlNVUJDS0haMWc0ZzJjNkVNeWt3eWNxWlVaMERnK0h1?=
 =?utf-8?B?SkxHWWdDdmJUMmFEYmVodm9VN1hJMDk5TXdvQ0hudXIzdkxLSGRkYW5pWXMz?=
 =?utf-8?B?YllJRlNCZjJwTHY2dzBFd2FkTVB3UC9CQzNSSVhUOHhBMThGTGdMQ2pRZVVW?=
 =?utf-8?B?Vkk4VTBTOVQ5eWdTcGRTTmZDZStua25zVnN5OFZvbkFYRmI4Z3RHSXUzTCs3?=
 =?utf-8?B?SHVnWExBQytHOWhSUnc1Z25kSlJzaGlUbVVldEVYRmI2amFRWTRiNEJlVlEr?=
 =?utf-8?B?YnZUY0kxWVFnK3lOUldVUFdsSVlzWkZpWUlLay9QaC9kUzZKUHhxK1NTZ0Vu?=
 =?utf-8?B?Z2FFWEZkSGJWUmlia05jZGxFV3hZN2ZFN2pSa2lUVFNPODdtYS94dWx5Sk5C?=
 =?utf-8?B?UHlBU0RkN2syTjkzMVo1ajdPS1ZqeUNvckhDejdIWkZCZjExbUovbk9PanU2?=
 =?utf-8?B?WUtVNTNaL1BLQk5TdnpXTk0yUDBVRFBicXNJNG5RM1RYb0VqMVlNeXZpdzNj?=
 =?utf-8?B?VWIwS1RzeVRVZWZQS1VsZDlPbUgxT0xnRDh4OU1SN0FLK3ZVOG9Ba1EwdFNp?=
 =?utf-8?B?YmlWQ2ZzNkhBUUhocytSOWFXY0UzS0V2cm5RYXpEUUhoQm43eEtKbXBIcmoy?=
 =?utf-8?B?S0NzL0t3eE4yYVE0ZlFLL3lLR2VaZGpCYm9VWWpkWk1aS24vd2pKZUZEemlY?=
 =?utf-8?B?YXMvQ0dyOXZPTHRjRk5TbEc4TFByeHh5YmpzNWI1NzBuZGNqVFlmaSs5VjN6?=
 =?utf-8?B?TlM5ZjdJOE9sWmlrOEpTNm41OWRzTjNMVVR4eGNvL3VzL0dDTklSUzkwWitt?=
 =?utf-8?B?ZjhDNWNORi9KMFNGWitKR0VZMWttOVVnNWUxREd2OW1ycElpTWNkRmJqNWZC?=
 =?utf-8?B?Qk5wWmU4Vkp3ZFpidFBraDZ3Ris1cEtyelFVSGJyV1BPQ1FmKzVvc0czeE9z?=
 =?utf-8?B?WmJvZ1FUa0piQ2ViR1p1K083Tzdrd2VxMm9SUjl5RytQWWsxeDRGQVpad2Nj?=
 =?utf-8?B?UStYSVM5MmVCR0w5bzN0RC9SM2dmSnVMN3NMajEvYkZtM3piM0Y2MUVKRTV3?=
 =?utf-8?B?b3U0VFR5WmpZY2Q3ejFkS3h6SzFCNEF2OVhCZVRubDBhRkc2NWFTOTdLajFI?=
 =?utf-8?B?K1ZIeEh1aTNYUE1heDE2TkdLWnhNeE81akIzWDN2NXc5dkpyVnU1bVVYNDZa?=
 =?utf-8?B?cCs5bmh0YjBJNk9DMXZQZTZtSVcwb0QxTXlJclkranR0Um0wUEs4aW03MjBO?=
 =?utf-8?B?Zk1oT2NEY2JxK3ZYOFZhUkg4cWxGcDArWDJFdGluVHFzQWVETzNRenA2b2M4?=
 =?utf-8?B?NFZuNWJmSXR3amxHbHoxVlE4aWNhQS90b29KTXhsaVZzMUwvSHA1RnhHZEJk?=
 =?utf-8?B?UVhheFc0d25yc2VPSklhbnBPUVZCaE4wdnpka0sybjc2ZDY3VDdNZkJHWUx4?=
 =?utf-8?B?MWVUZ2N3S1AyTUt2N3pac2MxellSSWdRUTVNVkU3YzdpWXRnbFpMblozb3E0?=
 =?utf-8?B?dVVNemFaUnNaSzB0R3lxK2MxeC9Ia3c4YkRkVUZlR1hML0lBU1NZbzFQRXgw?=
 =?utf-8?B?WUVZaGgxb3gvZW1sY09VRUYzbmhYbWZTZkZ1a3BCTXVoZU93bUI3VTF1d0Fx?=
 =?utf-8?B?TWxQVlFHd1c1YzJIV0tERGVWWTJuVm5TdU5aWmxzNGp1QWIvRUVRWGk2TjFa?=
 =?utf-8?B?M29jSkNWa0h3bVBEa2pOdEJ3aDhFZmg5bUo1VnNpdGJaWVFkR2tMT3ZTWHlj?=
 =?utf-8?B?aFVxZVorTFZ4bVA3T0Z2ZkxIZ1BmSVI5UjhQaTgzUml6Y01kWklTZ0JESEFB?=
 =?utf-8?B?T0pHajVjMGxCY3c3SDRoL2xjemJuVFZST2doUEVjNng5bXhGK28rVDVFMm9x?=
 =?utf-8?B?SHExUGYrWFBJUjNtOFA3VjZVQytkUVl2bHVpWjVvZGYvYnNkSzhQbGhQMlU4?=
 =?utf-8?B?ckxHMU1tN1ZRMjQvQlNSQ1FTZkRsNG96cDhvazQySG5MMVg3dW5VNDZFZjQ3?=
 =?utf-8?Q?58HZQg6hrhsRb8Uy6bvW2y7+mjEh+p0J4CYKBRL1pwj9?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A956AF6ABC3C394A9D245BB411A313FC@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a368c7c3-2e6a-49e7-4bc6-08d9ebb93b41
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 10:45:04.3998
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S3yqBSJ3BfWOQO9yCnLMpL+NiY5iMk8ZQxMoaICQXYSrQ6b+WmCgvJ8Re7uE8DTTHANf9iOJl48IqljUKziktw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4342
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMjAyMi8wMi8wOSAxNzo1MiwgTGVlIEpvbmVzIHdyb3RlOg0KPiBUaGlzIHJldmVydHMgY29t
bWl0IDYwMjYzZDU4ODllNmRjNTk4N2RjNTFiODAxYmU0OTU1ZmYyZTRhYTcuDQo+IA0KPiBSZXZl
cnRpbmcgc2luY2UgdGhpcyBjb21taXQgb3BlbnMgYSBwb3RlbnRpYWwgYXZlbnVlIGZvciBhYnVz
ZS4NCj4gDQo+IFRoZSBDLXJlcHJvZHVjZXIgYW5kIG1vcmUgaW5mb3JtYXRpb24gY2FuIGJlIGZv
dW5kIGF0IHRoZSBsaW5rIGJlbG93Lg0KPiANCj4gV2l0aCB0aGlzIHBhdGNoIGFwcGxpZWQsIEkg
Y2FuIG5vIGxvbmdlciBnZXQgdGhlIHJlcHJvIHRvIHRyaWdnZXIuDQo+IA0KPiAgIGtlcm5lbCBC
VUcgYXQgZnMvZXh0NC9pbm9kZS5jOjI2NDchDQo+ICAgaW52YWxpZCBvcGNvZGU6IDAwMDAgWyMx
XSBQUkVFTVBUIFNNUCBLQVNBTg0KPiAgIENQVTogMCBQSUQ6IDQ1OSBDb21tOiBzeXotZXhlY3V0
b3IzNTkgVGFpbnRlZDogRyAgICAgICAgVyAgICAgICAgIDUuMTAuOTMtc3l6a2FsbGVyLTAxMDI4
LWcwMzQ3YjE2NTgzOTkgIzANCj4gICBIYXJkd2FyZSBuYW1lOiBHb29nbGUgR29vZ2xlIENvbXB1
dGUgRW5naW5lL0dvb2dsZSBDb21wdXRlIEVuZ2luZSwgQklPUyBHb29nbGUgMDEvMDEvMjAxMQ0K
PiAgIFJJUDogMDAxMDptcGFnZV9wcmVwYXJlX2V4dGVudF90b19tYXArMHhiZTkvMHhjMDAgZnMv
ZXh0NC9pbm9kZS5jOjI2NDcNCj4gICBDb2RlOiBlOCBmYyBiZCBjMyBmZiBlOSA4MCBmNiBmZiBm
ZiA0NCA4OSBlOSA4MCBlMSAwNyAzOCBjMSAwZiA4YyBhNiBmZSBmZiBmZiA0YyA4OSBlZiBlOCBl
MSBiZCBjMyBmZiBlOSA5OSBmZSBmZiBmZiBlOCA4NyBjOSA4OSBmZiA8MGY+IDBiIGU4IDgwIGM5
IDg5IGZmIDBmIDBiIGU4IDc5IDFlIGI4IDAyIDY2IDBmIDFmIDg0IDAwIDAwIDAwIDAwDQo+ICAg
UlNQOiAwMDE4OmZmZmZjOTAwMDBlMmU5YzAgRUZMQUdTOiAwMDAxMDI5Mw0KPiAgIFJBWDogZmZm
ZmZmZmY4MWUzMjFmOSBSQlg6IDAwMDAwMDAwMDAwMDAwMDAgUkNYOiBmZmZmODg4MTBjMTJjZjAw
DQo+ICAgUkRYOiAwMDAwMDAwMDAwMDAwMDAwIFJTSTogMDAwMDAwMDAwMDAwMDAwMCBSREk6IDAw
MDAwMDAwMDAwMDAwMDANCj4gICBSQlA6IGZmZmZjOTAwMDBlMmViOTAgUjA4OiBmZmZmZmZmZjgx
ZTMxZTcxIFIwOTogZmZmZmY5NDAwMDhkNjhiMQ0KPiAgIFIxMDogZmZmZmY5NDAwMDhkNjhiMSBS
MTE6IDAwMDAwMDAwMDAwMDAwMDAgUjEyOiBmZmZmZWEwMDA0NmI0NTgwDQo+ICAgUjEzOiBmZmZm
YzkwMDAwZTJlYTgwIFIxNDogMDAwMDAwMDAwMDAwMDExZSBSMTU6IGRmZmZmYzAwMDAwMDAwMDAN
Cj4gICBGUzogIDAwMDA3ZmNmZDA3MTc3MDAoMDAwMCkgR1M6ZmZmZjg4ODFmNzAwMDAwMCgwMDAw
KSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwDQo+ICAgQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAw
IENSMDogMDAwMDAwMDA4MDA1MDAzMw0KPiAgIENSMjogMDAwMDdmY2ZkMDdkNTUyMCBDUjM6IDAw
MDAwMDAxMGExNDIwMDAgQ1I0OiAwMDAwMDAwMDAwMzUwNmIwDQo+ICAgRFIwOiAwMDAwMDAwMDAw
MDAwMDAwIERSMTogMDAwMDAwMDAwMDAwMDAwMCBEUjI6IDAwMDAwMDAwMDAwMDAwMDANCj4gICBE
UjM6IDAwMDAwMDAwMDAwMDAwMDAgRFI2OiAwMDAwMDAwMGZmZmUwZmYwIERSNzogMDAwMDAwMDAw
MDAwMDQwMA0KPiAgIENhbGwgVHJhY2U6DQo+ICAgIGV4dDRfd3JpdGVwYWdlcysweGNiYi8weDM5
NTAgZnMvZXh0NC9pbm9kZS5jOjI3NzYNCj4gICAgZG9fd3JpdGVwYWdlcysweDEzYS8weDI4MCBt
bS9wYWdlLXdyaXRlYmFjay5jOjIzNTgNCj4gICAgX19maWxlbWFwX2ZkYXRhd3JpdGVfcmFuZ2Ur
MHgzNTYvMHg0MjAgbW0vZmlsZW1hcC5jOjQyNw0KPiAgICBmaWxlbWFwX3dyaXRlX2FuZF93YWl0
X3JhbmdlKzB4NjQvMHhlMCBtbS9maWxlbWFwLmM6NjYwDQo+ICAgIF9faW9tYXBfZGlvX3J3KzB4
NjIxLzB4MTBjMCBmcy9pb21hcC9kaXJlY3QtaW8uYzo0OTUNCj4gICAgaW9tYXBfZGlvX3J3KzB4
MzUvMHg4MCBmcy9pb21hcC9kaXJlY3QtaW8uYzo2MTENCj4gICAgZXh0NF9kaW9fd3JpdGVfaXRl
ciBmcy9leHQ0L2ZpbGUuYzo1NzEgW2lubGluZV0NCj4gICAgZXh0NF9maWxlX3dyaXRlX2l0ZXIr
MHhmYzUvMHgxYjcwIGZzL2V4dDQvZmlsZS5jOjY4MQ0KPiAgICBkb19pdGVyX3JlYWR2X3dyaXRl
disweDU0OC8weDc0MCBpbmNsdWRlL2xpbnV4L2ZzLmg6MTk0MQ0KPiAgICBkb19pdGVyX3dyaXRl
KzB4MTgyLzB4NjYwIGZzL3JlYWRfd3JpdGUuYzo4NjYNCj4gICAgdmZzX2l0ZXJfd3JpdGUrMHg3
Yy8weGEwIGZzL3JlYWRfd3JpdGUuYzo5MDcNCj4gICAgaXRlcl9maWxlX3NwbGljZV93cml0ZSsw
eDdmYi8weGY3MCBmcy9zcGxpY2UuYzo2ODYNCj4gICAgZG9fc3BsaWNlX2Zyb20gZnMvc3BsaWNl
LmM6NzY0IFtpbmxpbmVdDQo+ICAgIGRpcmVjdF9zcGxpY2VfYWN0b3IrMHhmZS8weDEzMCBmcy9z
cGxpY2UuYzo5MzMNCj4gICAgc3BsaWNlX2RpcmVjdF90b19hY3RvcisweDRmNC8weGJjMCBmcy9z
cGxpY2UuYzo4ODgNCj4gICAgZG9fc3BsaWNlX2RpcmVjdCsweDI4Yi8weDNlMCBmcy9zcGxpY2Uu
Yzo5NzYNCj4gICAgZG9fc2VuZGZpbGUrMHg5MTQvMHgxMzkwIGZzL3JlYWRfd3JpdGUuYzoxMjU3
DQo+IA0KPiBMaW5rOiBodHRwczovL3N5emthbGxlci5hcHBzcG90LmNvbS9idWc/ZXh0aWQ9NDFj
OTY2YmYwNzI5YTUzMGJkOGQNCj4gDQo+IEZyb20gdGhlIHBhdGNoOg0KPiBDYzogU3RhYmxlIDxz
dGFibGVAdmdlci5rZXJuZWwub3JnPg0KPiBDYzogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3Qu
ZGU+DQo+IENjOiBEYXZlIENoaW5uZXIgPGRjaGlubmVyQHJlZGhhdC5jb20+DQo+IENjOiBHb2xk
d3luIFJvZHJpZ3VlcyA8cmdvbGR3eW5Ac3VzZS5jb20+DQo+IENjOiBEYXJyaWNrIEouIFdvbmcg
PGRhcnJpY2sud29uZ0BvcmFjbGUuY29tPg0KPiBDYzogQm9iIFBldGVyc29uIDxycGV0ZXJzb0By
ZWRoYXQuY29tPg0KPiBDYzogRGFtaWVuIExlIE1vYWwgPGRhbWllbi5sZW1vYWxAd2RjLmNvbT4N
Cj4gQ2M6IFRoZW9kb3JlIFRzJ28gPHR5dHNvQG1pdC5lZHU+ICMgZm9yIGV4dDQNCj4gQ2M6IEFu
ZHJlYXMgR3J1ZW5iYWNoZXIgPGFncnVlbmJhQHJlZGhhdC5jb20+DQo+IENjOiBSaXRlc2ggSGFy
amFuaSA8cml0ZXNoaEBsaW51eC5pYm0uY29tPg0KPiANCj4gT3RoZXJzOg0KPiBDYzogSm9oYW5u
ZXMgVGh1bXNoaXJuIDxqdGhAa2VybmVsLm9yZz4NCj4gQ2M6IGxpbnV4LXhmc0B2Z2VyLmtlcm5l
bC5vcmcNCj4gQ2M6IGxpbnV4LWZzZGV2ZWxAdmdlci5rZXJuZWwub3JnDQo+IENjOiBsaW51eC1l
eHQ0QHZnZXIua2VybmVsLm9yZw0KPiBDYzogY2x1c3Rlci1kZXZlbEByZWRoYXQuY29tDQo+IA0K
PiBGaXhlczogNjAyNjNkNTg4OWU2ZCAoImlvbWFwOiBmYWxsIGJhY2sgdG8gYnVmZmVyZWQgd3Jp
dGVzIGZvciBpbnZhbGlkYXRpb24gZmFpbHVyZXMiKQ0KPiBSZXBvcnRlZC1ieTogc3l6Ym90KzBl
ZDlmNzY5MjY0Mjc2NjM4ODkzQHN5emthbGxlci5hcHBzcG90bWFpbC5jb20NCj4gU2lnbmVkLW9m
Zi1ieTogTGVlIEpvbmVzIDxsZWUuam9uZXNAbGluYXJvLm9yZz4NCg0KRm9yIHpvbmVmczoNCg0K
QWNrZWQtYnk6IERhbWllbiBMZSBNb2FsIDxkYW1pZW4ubGVtb2FsQG9wZW5zb3VyY2Uud2RjLmNv
bT4NCg0KDQoNCi0tIA0KRGFtaWVuIExlIE1vYWwNCldlc3Rlcm4gRGlnaXRhbCBSZXNlYXJjaA==
