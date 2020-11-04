Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 746CE2A60F3
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 10:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728066AbgKDJyH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 04:54:07 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:45173 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727110AbgKDJyG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 04:54:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1604483644; x=1636019644;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=Xzqf0UM+PzUIPm2L5evSYqgNsiqUatYL+uvodBiJxBo=;
  b=pEn98bS9Ip5OJOgDrRHHkD54WbT/bW9lcLyljVIEdSTvmEyWyRUgiY0/
   XeLpqSk2jzpqXvHhCEtC+yiqXWs9LeOX6qxHIxnfXstghlNK0sU92/iin
   Lf3D001ydvb4AqAshl1axWJ63a7wdUg1YkHKsGlsb0DhSDjGELk07eyyT
   Z2K5Qq0J/y1pFbnu1qYwFY3fQylpoHeonjP5sLz9nM/QFvAIWwSicdzLV
   rKMbwaME2FG2GdgYT/7DVxv3IfFs3pg6Ax8sfMkHJS/5XwyGXkOrIbzXp
   gk2ScsdyTsvVutBf+tyLaw87SYLP9c4JlXH+UxSCqJqnWiCzDCpdCk9X2
   A==;
IronPort-SDR: HczhM6zgdRZ7tzIHz0VPhe41uLrh0un8bl+co3lG99JZBmkzPz8U7+AVDkBStPJgbH6JDo6kB3
 5V9udVJn+cq+D0DtjGU9Z0P/Y44ZXieer18nitTgp9H1yDaYSgVRZOTZX3TOEiwG2U0d3esy8g
 G5jdSM5YS98JhqYqEk4HbK2ilLg4q5xZHMpQaFV2uNkJpAFmVH2wLA6OAPfie9P2w7aGaJKD7t
 yAbV/LqHUOSi5CHXDCacXuHjNLI+TlO+OPUX8h1mpjhVgpBHzcuvlov7+Yv1EFTWbyEw8qKEyd
 qwQ=
X-IronPort-AV: E=Sophos;i="5.77,450,1596470400"; 
   d="scan'208";a="151676943"
Received: from mail-bn7nam10lp2104.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.104])
  by ob1.hgst.iphmx.com with ESMTP; 04 Nov 2020 17:54:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e4gCUn3ZdLVdVIZBLFqP8gdiyysj1E9XjVIWSqgfixi+6h/yiyqK2CWFShVK/Qfbtp172h1NPLHEEigBXiehfpBh43VHFBNT19mqr8fb1QDTXlxs3efjYvUuEv1uxE+a2q9CARD2iFTXyRz8+ycok9ok+WR8vVSRWHmmSUnExZzGSlNskJAAV6MX5a0Q2XR/0cX4tJhPiEbPzKn7VbPT7O2GlE7UytzPhtLQxrXpQAYfYJaknJdxnJhB8QKwfeG7LAStE16l6uVPSz+4uwGieSOGO5reh9zPxns3j2AkBZB1EyLqgImME9YarJezxpfG80bHuAsZkDE8eiVuTcXNNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+hIsiq4DpXH/HoPOsj2IKx1MWpfUzwRuyRNBAA+mA68=;
 b=eerESs90TpZkvFMhkI/eRsMjjHE6eqTi6Y1AQKabwobxZo2bJGSF5a5g1iGvOMkVj1I9eNRJ4ED9zTLlGCYFzqS2jrggOgqkNzKWICaEpDNKxC4uGhnCd/3HHPXDkfO/9U3D6BpJDqDzFxi/iu0uQIe3xRmhi23s8XNPxMxTZZsC/wlGggi9gGetWnjyYfI9ife8x0UxRDD5AGU4ZF40lg8zNKC29GARe+giSRyKFSIDZSyizdCYHorEtDUNpf/kjtmA994pjmz4Ea+fUSioD/i0614xei8UbPguZffCndoBiJOkrMajzik+rrzJC0DthfXWQl1R8udYE/XPBnt2UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+hIsiq4DpXH/HoPOsj2IKx1MWpfUzwRuyRNBAA+mA68=;
 b=Dz4wvpEWbxbqWsnGi3Eam5aaMBM05da1IUDGxhQO+5C/bdDtaLna03N+Bz6W/AqMQEPFCuaT5gBWwZZAm6l00oC73jmfQ5Xlqq3ljxAuH/s/1LQ4p4isZ++Gs2kyTPVLTsy+Y66PgwA0RKG+Dgah4OwI74kIEEUdD4j6nnR7cqU=
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
 by BL0PR04MB4738.namprd04.prod.outlook.com (2603:10b6:208:4c::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Wed, 4 Nov
 2020 09:54:03 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::4c3e:2b29:1dc5:1a85]) by BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::4c3e:2b29:1dc5:1a85%7]) with mapi id 15.20.3499.032; Wed, 4 Nov 2020
 09:54:03 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] null_blk: Fix zone reset all tracing
Thread-Topic: [PATCH] null_blk: Fix zone reset all tracing
Thread-Index: AQHWsoo9zgKa9lyUMEWyXEEszdUwMw==
Date:   Wed, 4 Nov 2020 09:54:02 +0000
Message-ID: <BL0PR04MB651491B95B0F8A78DF9D401EE7EF0@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <16044134474538@kroah.com>
 <20201104052914.156163-1-damien.lemoal@wdc.com>
 <20201104091015.GD1588160@kroah.com> <20201104091502.GA1646828@kroah.com>
 <BL0PR04MB6514A24DB438A568A9C27CB7E7EF0@BL0PR04MB6514.namprd04.prod.outlook.com>
 <20201104092742.GA1669921@kroah.com>
 <BL0PR04MB65143D636C72588134EC3E17E7EF0@BL0PR04MB6514.namprd04.prod.outlook.com>
 <20201104095141.GA1673068@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:830:5e48:69b5:9288]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8dfbdf42-f045-4655-4a7a-08d880a78fb0
x-ms-traffictypediagnostic: BL0PR04MB4738:
x-microsoft-antispam-prvs: <BL0PR04MB473838610769C1611127454FE7EF0@BL0PR04MB4738.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K4vdveibXmDPYiEHJD3X4DGkBcjuWHNUxuZei6hPz7WDk9/cTvo3904ZoO5TKpDpcplt/Jych2dCzPOafXNTlnT7tds/gebh/GVFt1SbQAKJ4o7rrshPDLk6ZNcy3HB2Ai3VkxvqOQvgJZaE4haSo+cfwOExXCIjsxY2bDgtz2Hs3Jj0gtwrUQnjxLG7rQeRG+T6Y4W5Qk6L5dd681qe/LFw3PePYxpf27KbnFGfVmM0ediHUzgWU7fLUgcpc5h6L/dRVAnjT9DQWK7KbxkW773Kch3hnbvX5NPRZvdMv1Ic0dBU0JzVT4RUOiqExHaZTwf+s2uD/+eM2Fc2qgKCEw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6514.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(396003)(39860400002)(136003)(346002)(83380400001)(316002)(6916009)(8676002)(2906002)(52536014)(53546011)(8936002)(5660300002)(6506007)(478600001)(33656002)(55016002)(7696005)(91956017)(71200400001)(66946007)(186003)(86362001)(64756008)(76116006)(66556008)(66476007)(54906003)(4326008)(66446008)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: r/xSXhUwzA3ABy6KACwoQwt/Kb9K3RRSIkJOqKPRR87gOzrBtJbs6JN+OABPVFCxdB2zFWqK21lcqETtgrOm26glG6aEW3x+wBUrt7sP4AxNFel3AdK2VJCfy+uddxBmyuM/kymw5R0xeeJxafO19UGRkcxFvCOZgDNcHmgk6VT3lFpilseYtEv/j0YnzHy0meQKqWpYh86As22WLW1vbQaWLlM5W/+wlgUQpAKVdpksNGqky2/EFPVpmo2opG4MJ0XaiC302Bjv98TjwtGbfaZ/l8eU6djMZY7+alULkE1Sv/DZlqClLwoqN7gJA4DlWSrv2hApxyo3ZtUN9JpFcJV1zoVod8Om7URWdmAFJP4oGgoLI7IZu32/AHcO+rtAstyFHyqkEDpOYZvkAAURY/9VHVoOFgMJib488rKKwdVBchOLsYTcdpVtu0UpE0lnXKJk/fVzkbp8AjKdcVsHY25sMWaKw7GnHas2+CRRZTJvogMUqaQrWr5lwqETNUmifV+ERUmoMejBfpQm/DP34n9Uk2G6xg3AH2YfdNGCfxWC/AxxGFEZKx8ExSOOuflupNZcqXiyhM882ph+GjwiApsEI0IdKumrvH7d0FyxZ0yjxEJAQ++qfLC6vGToZsg8L+rZETcS3GPVAH0ixlkTCZUzjcRqiFPJ6Dyiy7p/1n/gjEoKeirpGL0RxdKpbwieWyFhjUE5n/qpPyke1tmLDQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dfbdf42-f045-4655-4a7a-08d880a78fb0
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2020 09:54:03.0060
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MgDul/1ln+ItJ9Ozk2VCPPDJhPNZIJSBcQJyVdhJd4SRm4IZ5SapwT4AETEAl2TFHbdSERgp6uxzRkjKVlOuZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB4738
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020/11/04 18:50, Greg Kroah-Hartman wrote:=0A=
> On Wed, Nov 04, 2020 at 09:31:40AM +0000, Damien Le Moal wrote:=0A=
>> On 2020/11/04 18:26, Greg Kroah-Hartman wrote:=0A=
>>> On Wed, Nov 04, 2020 at 09:21:27AM +0000, Damien Le Moal wrote:=0A=
>>>> On 2020/11/04 18:14, Greg Kroah-Hartman wrote:=0A=
>>>>> On Wed, Nov 04, 2020 at 10:10:15AM +0100, Greg Kroah-Hartman wrote:=
=0A=
>>>>>> On Wed, Nov 04, 2020 at 02:29:14PM +0900, Damien Le Moal wrote:=0A=
>>>>>>> commit f9c9104288da543cd64f186f9e2fba389f415630 upstream.=0A=
>>>>>>>=0A=
>>>>>>> In the cae of the REQ_OP_ZONE_RESET_ALL operation, the command sect=
or is=0A=
>>>>>>> ignored and the operation is applied to all sequential zones. For t=
hese=0A=
>>>>>>> commands, tracing the effect of the command using the command secto=
r to=0A=
>>>>>>> determine the target zone is thus incorrect.=0A=
>>>>>>>=0A=
>>>>>>> Fix null_zone_mgmt() zone condition tracing in the case of=0A=
>>>>>>> REQ_OP_ZONE_RESET_ALL to apply tracing to all sequential zones that=
 are=0A=
>>>>>>> not already empty.=0A=
>>>>>>>=0A=
>>>>>>> Fixes: 766c3297d7e1 ("null_blk: add trace in null_blk_zoned.c")=0A=
>>>>>>> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
>>>>>>> Cc: stable@vger.kernel.org=0A=
>>>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>=0A=
>>>>>>> ---=0A=
>>>>>>>  drivers/block/null_blk_zoned.c | 14 ++++++++------=0A=
>>>>>>>  1 file changed, 8 insertions(+), 6 deletions(-)=0A=
>>>>>>=0A=
>>>>>> Now queued up, thanks.=0A=
>>>>>=0A=
>>>>> Wait, no, I'll delay this one until the next round as it's not fixing=
=0A=
>>>>> something introduced in this -rc series.=0A=
>>>>=0A=
>>>> Yes, that problem is older.=0A=
>>>> The lock fix I sent goes on top of this one though. I can send the bac=
kport for=0A=
>>>> the lock fix without this patch applied. Is that OK ?=0A=
>>>=0A=
>>> If the order of the patches is needed, then yes, I can take both, pleas=
e=0A=
>>> submit them as a patch series so that I know this is needed.=0A=
>>=0A=
>> OK. Sending that. Note that I still do not see Kanchan patch applied in =
stable=0A=
>> 5.9.y branch, so I will do the backport assuming it is applied. Or I can=
 send=0A=
>> all 3 patches as the series. Which do you prefer ?=0A=
> =0A=
> All 3 is great, to ensure I have them all as I don't know what you mean=
=0A=
> by "Kanchan patch".=0A=
=0A=
I was talking about "=0A=
commit 35bc10b2eafbb701064b94f283b77c54d3304842 upstream." that you already=
=0A=
applied to 5.9.y.=0A=
=0A=
Sending all 3 patches backported in a series to be sure. SInce the first pa=
tchin=0A=
the series will be the above mentioned patch, everything should still apply=
=0A=
cleanly on your side. Thanks!=0A=
=0A=
> =0A=
> thanks,=0A=
> =0A=
> greg k-h=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
