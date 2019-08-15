Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E66ED8F771
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 01:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730638AbfHOXKt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 15 Aug 2019 19:10:49 -0400
Received: from mx0a-002e3701.pphosted.com ([148.163.147.86]:42672 "EHLO
        mx0a-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387636AbfHOXKt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Aug 2019 19:10:49 -0400
Received: from pps.filterd (m0148663.ppops.net [127.0.0.1])
        by mx0a-002e3701.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7FNAirA002217;
        Thu, 15 Aug 2019 23:10:44 GMT
Received: from g9t5008.houston.hpe.com (g9t5008.houston.hpe.com [15.241.48.72])
        by mx0a-002e3701.pphosted.com with ESMTP id 2udeyt8j0y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Aug 2019 23:10:44 +0000
Received: from G4W9121.americas.hpqcorp.net (g4w9121.houston.hp.com [16.210.21.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by g9t5008.houston.hpe.com (Postfix) with ESMTPS id 3B46D57;
        Thu, 15 Aug 2019 23:10:43 +0000 (UTC)
Received: from G2W6309.americas.hpqcorp.net (2002:10c5:4033::10c5:4033) by
 G4W9121.americas.hpqcorp.net (2002:10d2:1510::10d2:1510) with Microsoft SMTP
 Server (TLS) id 15.0.1367.3; Thu, 15 Aug 2019 23:10:36 +0000
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (15.241.52.12) by
 G2W6309.americas.hpqcorp.net (16.197.64.51) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3 via Frontend Transport; Thu, 15 Aug 2019 23:10:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gG/HvUX8hGUPrWbV8lXa5MoWu4nvFFu9CTuxIKK2EYPxo/giKLqEiEO0/NJHEGKlaUdCyY2mIzHnlOPujK5jIjOrVLMG+nekuOjMOw6Xud3dMqf1H7Vr40ghj7xLXzfgh104AgI+iEgrHoeXHpe5Pqzlm3NbD//0wD/PT778tJlidRGvY4+yB4yZ8EMcY44J4oPNamhWRVgTv0O34ggHT6ehA8Hr1ik0nAIFR1RY67MnAEiMlOe+hXcjAcrMZYjc5G76jE89sR6w9+H+F8lHff+Mu1VhGGxqoIJy+kXnj9gE5WuOCzN57D8fYXaMC/eWMAYbFO3GQC5ir+uVei8S5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zXfuhPaNJFRgXlGJb1ytUBphAfPyTmDCyY3X6QdxgVc=;
 b=KLIsJqp3WdUuNl19QtKeN2jnb2aWL7NB14dIEi0vHMmwguyE/90ZaaNVDXk4CC+szAD68vOmgMdf8FsBBjzPo80YdQanjXfWLyPQXj6wfxYqkwyAcNMs8WwBCJYCt2ToGKkG9QgFHR1nHviM7gMN79iVxyBVJHx70pdhFoP4R5xlS/jV2JhFSrpPLT5iCJorv8qVxte17dxpzZ1Sf+B8Sy34g/TwNyzrmc2/b1GNaBWpI/FYHQ/IaOK/GcsusajxmrXzfpLcSk6J/IPwXXp8dXi4L++ydwUMhMDJSiS08JvyIwbzBRgwdRDPxwK5sYNFcXcY74FkSIsPeeGoC+wQzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from AT5PR8401MB0578.NAMPRD84.PROD.OUTLOOK.COM (10.169.3.139) by
 AT5PR8401MB0641.NAMPRD84.PROD.OUTLOOK.COM (10.169.5.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Thu, 15 Aug 2019 23:10:35 +0000
Received: from AT5PR8401MB0578.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::e5bc:403c:fbdc:7026]) by AT5PR8401MB0578.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::e5bc:403c:fbdc:7026%9]) with mapi id 15.20.2157.022; Thu, 15 Aug 2019
 23:10:35 +0000
From:   "Ray, Mark C (Global Solutions Engineering (GSE))" <mark.ray@hpe.com>
To:     Ming Lei <ming.lei@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC:     Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Ray, Mark C (Global Solutions Engineering (GSE))" <mark.ray@hpe.com>
Subject: RE: [PATCH] blk-mq: avoid sysfs buffer overflow by too many CPU cores
Thread-Topic: [PATCH] blk-mq: avoid sysfs buffer overflow by too many CPU
 cores
Thread-Index: AQHVU2MoxEteYEWqIEmO0zyt7t+tmab8IfKAgAABWwCAAAHLgIAAAi0AgACuUfA=
Date:   Thu, 15 Aug 2019 23:10:35 +0000
Message-ID: <AT5PR8401MB05784C37BAF2939B776103FC99AC0@AT5PR8401MB0578.NAMPRD84.PROD.OUTLOOK.COM>
References: <20190815121518.16675-1-ming.lei@redhat.com>
 <20190815122419.GA31891@kroah.com> <20190815122909.GA28032@ming.t460p>
 <20190815123535.GA29217@kroah.com> <20190815124321.GB28032@ming.t460p>
In-Reply-To: <20190815124321.GB28032@ming.t460p>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [211.219.0.129]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c5fce7bb-94e7-4476-33ec-08d721d5c774
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AT5PR8401MB0641;
x-ms-traffictypediagnostic: AT5PR8401MB0641:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AT5PR8401MB0641B4DC3DC5C8CABEAC4E6E99AC0@AT5PR8401MB0641.NAMPRD84.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(136003)(396003)(346002)(39860400002)(366004)(199004)(189003)(13464003)(5660300002)(14444005)(86362001)(25786009)(71190400001)(76176011)(71200400001)(7696005)(6436002)(256004)(6506007)(66446008)(6116002)(81166006)(52536014)(102836004)(186003)(81156014)(66066001)(446003)(476003)(99286004)(53546011)(8676002)(229853002)(11346002)(486006)(26005)(8936002)(14454004)(54906003)(53936002)(7736002)(74316002)(9686003)(6246003)(316002)(305945005)(478600001)(2906002)(66946007)(55016002)(110136005)(4326008)(3846002)(76116006)(33656002)(64756008)(66476007)(66556008);DIR:OUT;SFP:1102;SCL:1;SRVR:AT5PR8401MB0641;H:AT5PR8401MB0578.NAMPRD84.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: hpe.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: H0zif1Ne3t+yUKwn/tV+UjNwtsbTd9Otu0ZWGYSKqemE/nMuVHJ0LEMM+jQEWIgbjt7ADwtbPY5k83DbIUoQiCHzxfkbm8dXOV3rZLY6mW/r0426qoJNXXwzdlHl88Csz7e3S4NRlIyEnGr5udl+6hFgAVoiHCbl+XPkcjCWLfuPYr8N1JSLhGPCC6+L2bc/4IUrtT9Dwj5GO0WOm308YEGcbK3iONE+8bDZuoyCnMcFl3VIv6Saa8hNd7ie24F1qw0DQpVP0xAPunjd8m5CDo596778+Ja+U7i8o7C2LxhNVpjIiTwFdymsSDYGHWW3+fTF+XE3rNJ/lRte1ahGY1kgdS5gyFEju5hnN2kZXwXrbPF8hbcjYoucObIUk9IX3xQEYUZ8tbQfgeqH4OjanBFUkHpIXbvwArPOmfUMcXE=
Content-Type: text/plain; charset="us-ascii"
X-MS-Exchange-CrossTenant-Network-Message-Id: c5fce7bb-94e7-4476-33ec-08d721d5c774
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 23:10:35.2917
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rxBjit5dTFCSOsd50r3DRNY4RvR5iMd24S8qERTH0B4LYa14R/QUiSZRIohpaFDIXAdOooZO48o3u8f690+41g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AT5PR8401MB0641
X-OriginatorOrg: hpe.com
Content-Transfer-Encoding: 8BIT
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-15_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908150221
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Ming,

In the customer case, the cpu_list file was not needed.   It was just part of a SAP Hana script to collect all the block device data (similar to sosreport).    So they were just dumping everything, and it picks up the mq-related files.  

I know with IRQs, we have bitmaps/mask, and can represent the list such as "0-27", without listing every CPU.   I'm sure there's lots of options to address this, and getting rid of the cpu_list is one of them.

Best Regards,

Mark Ray
HPE Global Solutions Engineering
mark.ray@hpe.com



-----Original Message-----
From: Ming Lei [mailto:ming.lei@redhat.com] 
Sent: Thursday, August 15, 2019 9:43 PM
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Jens Axboe <axboe@kernel.dk>; linux-block@vger.kernel.org; stable@vger.kernel.org; Ray, Mark C (Global Solutions Engineering (GSE)) <mark.ray@hpe.com>
Subject: Re: [PATCH] blk-mq: avoid sysfs buffer overflow by too many CPU cores

On Thu, Aug 15, 2019 at 02:35:35PM +0200, Greg KH wrote:
> On Thu, Aug 15, 2019 at 08:29:10PM +0800, Ming Lei wrote:
> > On Thu, Aug 15, 2019 at 02:24:19PM +0200, Greg KH wrote:
> > > On Thu, Aug 15, 2019 at 08:15:18PM +0800, Ming Lei wrote:
> > > > It is reported that sysfs buffer overflow can be triggered in 
> > > > case of too many CPU cores(>841 on 4K PAGE_SIZE) when showing 
> > > > CPUs in one hctx.
> > > > 
> > > > So use snprintf for avoiding the potential buffer overflow.
> > > > 
> > > > Cc: stable@vger.kernel.org
> > > > Cc: Mark Ray <mark.ray@hpe.com>
> > > > Fixes: 676141e48af7("blk-mq: don't dump CPU -> hw queue map on 
> > > > driver load")
> > > > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > > > ---
> > > >  block/blk-mq-sysfs.c | 30 ++++++++++++++++++------------
> > > >  1 file changed, 18 insertions(+), 12 deletions(-)
> > > > 
> > > > diff --git a/block/blk-mq-sysfs.c b/block/blk-mq-sysfs.c index 
> > > > d6e1a9bd7131..e75f41a98415 100644
> > > > --- a/block/blk-mq-sysfs.c
> > > > +++ b/block/blk-mq-sysfs.c
> > > > @@ -164,22 +164,28 @@ static ssize_t blk_mq_hw_sysfs_nr_reserved_tags_show(struct blk_mq_hw_ctx *hctx,
> > > >  	return sprintf(page, "%u\n", hctx->tags->nr_reserved_tags);  }
> > > >  
> > > > +/* avoid overflow by too many CPU cores */
> > > >  static ssize_t blk_mq_hw_sysfs_cpus_show(struct blk_mq_hw_ctx 
> > > > *hctx, char *page)  {
> > > > -	unsigned int i, first = 1;
> > > > -	ssize_t ret = 0;
> > > > -
> > > > -	for_each_cpu(i, hctx->cpumask) {
> > > > -		if (first)
> > > > -			ret += sprintf(ret + page, "%u", i);
> > > > -		else
> > > > -			ret += sprintf(ret + page, ", %u", i);
> > > > -
> > > > -		first = 0;
> > > > +	unsigned int cpu = cpumask_first(hctx->cpumask);
> > > > +	ssize_t len = snprintf(page, PAGE_SIZE - 1, "%u", cpu);
> > > > +	int last_len = len;
> > > > +
> > > > +	while ((cpu = cpumask_next(cpu, hctx->cpumask)) < nr_cpu_ids) {
> > > > +		int cur_len = snprintf(page + len, PAGE_SIZE - 1 - len,
> > > > +				       ", %u", cpu);
> > > > +		if (cur_len >= PAGE_SIZE - 1 - len) {
> > > > +			len -= last_len;
> > > > +			len += snprintf(page + len, PAGE_SIZE - 1 - len,
> > > > +					"...");
> > > > +			break;
> > > > +		}
> > > > +		len += cur_len;
> > > > +		last_len = cur_len;
> > > >  	}
> > > >  
> > > > -	ret += sprintf(ret + page, "\n");
> > > > -	return ret;
> > > > +	len += snprintf(page + len, PAGE_SIZE - 1 - len, "\n");
> > > > +	return len;
> > > >  }
> > > >
> > > 
> > > What????
> > > 
> > > sysfs is "one value per file".  You should NEVER have to care 
> > > about the size of the sysfs buffer.  If you do, you are doing something wrong.
> > > 
> > > What excatly are you trying to show in this sysfs file?  I can't 
> > > seem to find the Documenatation/ABI/ entry for it, am I just 
> > > missing it because I don't know the filename for it?
> > 
> > It is /sys/block/$DEV/mq/$N/cpu_list, all CPUs in this hctx($N) will 
> > be shown via sysfs buffer. The buffer size is one PAGE, how can it 
> > hold when there are too many CPUs(close to 1K)?
> 
> Looks like I only see 1 cpu listed on my machines in those files, what 
> am I doing wrong?

It depends on machine. The issue is reported on one machine with 896 CPU cores, when 4K buffer can only hold 841 cores.

> 
> Also, I don't see cpu_list in any of the documentation files, so I 
> have no idea what you are trying to have this file show.
> 
> And again, "one value per file" is the sysfs rule.  "all cpus in the 
> system" is not "one value" :)

I agree, and this file shouldn't be there, given each CPU will have one kobject dir under the hctx dir.

We may kill the 'cpu_list' attribute, is there anyone who objects?


Thanks,
Ming
