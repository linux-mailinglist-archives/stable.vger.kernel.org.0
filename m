Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B33069101D
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 19:13:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbjBISNb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 13:13:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbjBISN2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 13:13:28 -0500
X-Greylist: delayed 1460 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 09 Feb 2023 10:13:09 PST
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2A25EBCC;
        Thu,  9 Feb 2023 10:13:09 -0800 (PST)
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 319HaPC4009716;
        Thu, 9 Feb 2023 09:48:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=proofpoint20171006;
 bh=xL7awbJObVbc2nRJTOIIb3UurSH7DRGDnYjHphwmBAQ=;
 b=iEZCGb+IzMmn2uwL6wgKKdP64P3E8s31C87kXkr6DiQod65GWqjGGypm8AzKZh68tCBi
 1x3OBTg3w1N4YjrmIttsekvTXlkNru1cW2UcUwPqbgNDBbFGnM/2EJZIInQPNSB27zf6
 L3YegAWizCeqefuy1Tr+LR1DLR3332ABgPJFTTUjnjG7dQ/HTObAGkdoILBYxAsZytUV
 p4oIpbUeBMSOOyt8s/Fln6rzzTBsHwr5aK7AW/m68xQJNnALIEatF9OuUZFAg6i2fYn2
 Zc/DELfmkHQ+QbEHvOqq5Kz+3RwZPP8nZDikQR1BlOpSiFI4ufohVAEdED2brN2GHrwq Qg== 
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2042.outbound.protection.outlook.com [104.47.51.42])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3nhm5j0n5w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 09:48:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nL2s8vJ1kpdWrnVZZTUXNHR8y7r5PJzmA6VyjU2rKtH1YaK2mpE0aLQRrz5ZKfFNQtUPiFXKjiQ2taGEO1+J2I7+vcvYexlkMHeXFluyDg4nu7s0912eYO5vTOKQJAomkYNvdJRG5zEcXCn7rV1YUJk+UeKopRdfulAnzfNRMt5hP56sX0UTqZG3gXvVvRw+co7YDDn61GEaCDScq/7pw8J1RqWC0BbBju+TPC/SvIn7h6fEMKrd7xkZg89ZPx9HvO+iDJmijsHhdhTHLbWZdKFQmfGR+HMiJRnY0/csbRMy/XHiawTGRO2qHZdQd/NDMNWB58XuligLVXW3/Ixhwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xL7awbJObVbc2nRJTOIIb3UurSH7DRGDnYjHphwmBAQ=;
 b=eYdbies08SFyG6vGB7q3PgXbVFgnCklQpwmt/HMZ5ATe02gNEY1VNwdOdALHsyjR4XamWjXtcw0HDVe/bGte1J3N6zVuMI3JE6Mdl1HO9c7pU3/qU2Fg0U3fRVshw4ZH5pkwmbAODlW2EgItkXl5NrHOIhSkgHJlH+EtxH5MonHc/n0N2OD/TCJ4j7k9VNNOhjp/irKH0GghcoPoda5cseLnCbpzQat2GtYQyDyiAIONpbW8glGD1+b68wp0LWe5nb7dlZiN1p++LmYCj0m45q8+NQnChcEE64yV22chWqMWvzjWv/tj/9QVt/+jxPEc7HfYBUn0y4TPHI9Kqfby+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xL7awbJObVbc2nRJTOIIb3UurSH7DRGDnYjHphwmBAQ=;
 b=DzxgYRsv24slc87b+MkIzyWBUO74HN0EikyoCWcB2nuRfXaiabd9II7Tkq+4pXzFNsq71jCo9BhpVA/jinUv4jLtIJBhfX9PyVAZcFIyEdoVHMgm947PpTKspSV2z0QoxMrCbYMDMGOoCnRW/4HzH87kvm4wpFiL3MA85rbfi2aRk66Xi93Lh++hhfaM1DlNuK5O4mEnE3Hmh73XUGRIqtZIM2tiEpjjBRGsUGLT0afX72N5CzPtbIgToLSvTRydmxelg1Wi76MrBG1lKAWf4Z4gbzRHPrig6uf3naKAmqJorZhyzbwCLTNaJ2nGzJ4iINLlt3hVEmndhFx6UPN9xg==
Received: from BYAPR02MB4488.namprd02.prod.outlook.com (2603:10b6:a03:57::28)
 by BN0PR02MB7936.namprd02.prod.outlook.com (2603:10b6:408:166::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Thu, 9 Feb
 2023 17:48:29 +0000
Received: from BYAPR02MB4488.namprd02.prod.outlook.com
 ([fe80::8ca2:b10b:6212:28f4]) by BYAPR02MB4488.namprd02.prod.outlook.com
 ([fe80::8ca2:b10b:6212:28f4%5]) with mapi id 15.20.6086.017; Thu, 9 Feb 2023
 17:48:28 +0000
From:   David Chen <david.chen@nutanix.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH] Fix page corruption caused by racy check in __free_pages
Thread-Topic: [PATCH] Fix page corruption caused by racy check in __free_pages
Thread-Index: Adk8reA65mQ6l+W5TEuqm6ZJpEFBNQ==
Date:   Thu, 9 Feb 2023 17:48:28 +0000
Message-ID: <BYAPR02MB448855960A9656EEA81141FC94D99@BYAPR02MB4488.namprd02.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR02MB4488:EE_|BN0PR02MB7936:EE_
x-ms-office365-filtering-correlation-id: fb7cc447-b7bb-43b9-ef39-08db0ac5da37
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tG1aYfQi0DkDUnZJ+rT38VRsaf1PChxxe8jS3+DQWWtlQCO4kfN2B0sEojP6rDfNhZwthKenTLwoYppq5UwgnD357UAqkiivchd/q0jw/YsV9dcBAOJLJ3cSiLcaH0ibDFg1tEbHCWGM9yN2FWEHkVdqw6CHZiAvSCk+HlPbsx/nI+L6sTbnZz1Cn/8RBVAyg3adqdoRZCEwwRmmRKZ5Cy9Jio1POwsSisd6AhrPl9HhJqB4eamKwlgBRTjEWItC9Zu9P7yjUp7J/WJdkLAUnA8gd7KCt17ePGaDpHnd8IOTYYjODS2SZXqxLM2P9/h0kKs0u0n4dRYho9ht6xvzCN2MdPSPszxta1mOsAZGrLVxhR6id+y4cc759JGi9Sw5V+/wbJkx9KQCNFjaEDr2PImn2yFxpUVeplnI0aPZJrg4/NyobIH366Q9aZYhIWin/lWbHs2x0RECW95gUKeKTQOoPv5wIP9W5V8p0jq1bPE4UAiAf5Tm8Tx/ZsNMC2orDxRK+LGY5MBJ8AlDS8aL7M9yJAjn8qV7W2/XRcWhfrE69HB1uFA0xSo3qn1U0tb0QMYhEFvqE1SjTjfVcee/4jMjGeYRbt0mAqKmi4CfaMjIh5pdfwvvTtKovoyXhk+CkSVH/YQD0/97IpRoOqyNFP4aROxtQABzK12Ts7uqMMAONz/8rL/jnPGrlDFUFfaH31GqOLuNIcdIabxmQ1XdRA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR02MB4488.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(39860400002)(136003)(366004)(376002)(346002)(451199018)(76116006)(66556008)(66476007)(6916009)(66946007)(41300700001)(478600001)(33656002)(54906003)(316002)(83380400001)(38070700005)(38100700002)(7696005)(44832011)(8676002)(9686003)(186003)(86362001)(71200400001)(55016003)(26005)(66446008)(122000001)(52536014)(8936002)(5660300002)(64756008)(2906002)(6506007)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XlFg6ijqmqOi8+NuUZQoin5XY9xTCDRAZSndDehKxet5zw/bRy3/ATGo7/y9?=
 =?us-ascii?Q?eIWvJlTPqxK52LDWCfIRFoM9KW1y5jrMGqO+sePAhUuA6IERccvWnj5wZN/S?=
 =?us-ascii?Q?Mv/wJE3kfAgWr7tm1VQckYVkbT3XF8/yPAn1MBk/Idpf1L8Tkv9D0XR/jOK6?=
 =?us-ascii?Q?hCNnuwIa4TIS57d2q/nw0tf312m6Fo3ybgn6skxgVAO0t3guCHtW32DAR0KI?=
 =?us-ascii?Q?QjIe1iQVtzlN80lP8xVFrMw+bN/LbgcCuhFU1zFHKCuHk4OyBX2lOFYyLU4N?=
 =?us-ascii?Q?tnW97pwUHTCp3kEgJT/yR/LwWd0sxP2X8XRE7vCEq1ZzH5Xw3oECDKoTwczt?=
 =?us-ascii?Q?SE7tYe1Fr7MzkBWInwBDSHXxZKo3fkkjO0XEd557xrd0kPHZJF8Lc5TJkNxT?=
 =?us-ascii?Q?ninRPc1ENmJJFCiG+xgEJNoFpaPIB/0swp5c2jvz2TfwFd6isr/ycuEonnyX?=
 =?us-ascii?Q?7GpL80MCeQ72Fy2ACsoi/h8AI7T49pQ47kHrAuqbdqWGYCEGpwwfDwCVx5Zn?=
 =?us-ascii?Q?jTnDYkjjxllOch7B9YVBtPbrQ7paaLEbvn8+qOolUh+0iUNU2dvW3p3XR0xl?=
 =?us-ascii?Q?laHg1qa4IKBY0bOO5+9E51KNLGmgszZ4SOyVgHQPGFxM86hVzC02tBB9EwWo?=
 =?us-ascii?Q?Elh2lCfRgNMX5Agps6wbtRC6kbyB+kZrsplNNbEhJrkWTGjZS+QMawbxRH2B?=
 =?us-ascii?Q?FIvcawa9srmaWSP8aWx+SMRHE/uOqe3ykETfOdfsVoTvrWkBfgLRwkdsMQ37?=
 =?us-ascii?Q?ucyJ9Yl8Yx4CBkUtwD/uub61RF08/lGsPdg4I+qLQZApz8aItweUgMZ9BiLT?=
 =?us-ascii?Q?CtE5khFytgx3T+ZLX1OKMmVv+d4TSA/QHpnr0pCZ+0wXhzFLfOBtMAm1MVsA?=
 =?us-ascii?Q?/Yl2f89XLYlH9onJ4m1sCdNfm1maT2UDlvb3wrW+rvGEM4ZzkofmLME28NBS?=
 =?us-ascii?Q?LhDRSeEZWWsTbi75lZgwSFnq3KrNoMhfwmUHT18SvkhTc+0YNcX9JZBPoKtT?=
 =?us-ascii?Q?9M4UVaFkoKYKb1bid0aotSIschG0qCZ8QHFwFDf1iYdjyCUsULz6rshQ38iT?=
 =?us-ascii?Q?8LRK6xWT7pqxC9lzyL7MBud5jFXpsPBpotNVDblpmA1PIEtIxII7BUWIllUD?=
 =?us-ascii?Q?3zju1ri90fxmAaPzxBqHH926tRikHKnXCkT1QO3Z8fCpD+abLCYe3Mw0KWfZ?=
 =?us-ascii?Q?zcHPzCGNSVIJawwaATRoNmCSTl3lgtNDZRIlGWgBTigDC0rlONd5226BWB7R?=
 =?us-ascii?Q?1J3C7RqVmXgeWovkiTEbtutsC9ry/s2AMpBcdQaDj1tDwg2AVsSfQ+I9TYQs?=
 =?us-ascii?Q?6iUEieIGNvmf7lCDEJp6VK61iXeVrpynyQJnHZYUK5oUO0orUsQqxSxFXmOu?=
 =?us-ascii?Q?zaVuajEhFtL4WfW/UeBWhhCfwyaDHiuqrFFAtMKl8zkse7l8K6SH/RAvamww?=
 =?us-ascii?Q?gSVLk5x3RASIMk79KrLBFossqZh6q+XFWpWXhtVZ0iVRWohG5YMTjoBJm2ww?=
 =?us-ascii?Q?1GdkSIm0SIdY1PPLO4sq5OATCHA/bHBk6DSF5U77d3hMRX3D+ofKB/smqxAy?=
 =?us-ascii?Q?x7tLT/GucP7PHeYN0MDgbgEtY5ffR/TCnRxb6VIl?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR02MB4488.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb7cc447-b7bb-43b9-ef39-08db0ac5da37
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2023 17:48:28.8522
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qn53YpWb60AGsHa6NAk7gkbe2te41rpvGfAHTEuws6h4uglGTDvZJtb3Yo2eiWHtyD+O7+brq++dXUfShMFr5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR02MB7936
X-Proofpoint-GUID: qDqEsuMsGq48t1PnPidx8s2Flp-VXRJa
X-Proofpoint-ORIG-GUID: qDqEsuMsGq48t1PnPidx8s2Flp-VXRJa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-09_13,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When we upgraded our kernel, we started seeing some page corruption like
the following consistently:

 BUG: Bad page state in process ganesha.nfsd  pfn:1304ca
 page:0000000022261c55 refcount:0 mapcount:-128 mapping:0000000000000000 in=
dex:0x0 pfn:0x1304ca
 flags: 0x17ffffc0000000()
 raw: 0017ffffc0000000 ffff8a513ffd4c98 ffffeee24b35ec08 0000000000000000
 raw: 0000000000000000 0000000000000001 00000000ffffff7f 0000000000000000
 page dumped because: nonzero mapcount
 CPU: 0 PID: 15567 Comm: ganesha.nfsd Kdump: loaded Tainted: P    B      O =
     5.10.158-1.nutanix.20221209.el7.x86_64 #1
 Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Referenc=
e Platform, BIOS 6.00 04/05/2016
 Call Trace:
  dump_stack+0x74/0x96
  bad_page.cold+0x63/0x94
  check_new_page_bad+0x6d/0x80
  rmqueue+0x46e/0x970
  get_page_from_freelist+0xcb/0x3f0
  ? _cond_resched+0x19/0x40
  __alloc_pages_nodemask+0x164/0x300
  alloc_pages_current+0x87/0xf0
  skb_page_frag_refill+0x84/0x110
  ...

Sometimes, it would also show up as corruption in the free list pointer and
cause crashes.

After bisecting the issue, we found the issue started from e320d3012d25:

	if (put_page_testzero(page))
		free_the_page(page, order);
	else if (!PageHead(page))
		while (order-- > 0)
			free_the_page(page + (1 << order), order);

So the problem is the check PageHead is racy because at this point we
already dropped our reference to the page. So even if we came in with
compound page, the page can already be freed and PageHead can return
false and we will end up freeing all the tail pages causing double free.

Fixes: e320d3012d25 ("mm/page_alloc.c: fix freeing non-compound pages")
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: linux-mm@kvack.org
Cc: stable@vger.kernel.org
Signed-off-by: Chunwei Chen <david.chen@nutanix.com>
---
 mm/page_alloc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 0745aedebb37..3bb3484563ed 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5631,9 +5631,12 @@ EXPORT_SYMBOL(get_zeroed_page);
  */
 void __free_pages(struct page *page, unsigned int order)
 {
+	/* get PageHead before we drop reference */
+	int head =3D PageHead(page);
+
 	if (put_page_testzero(page))
 		free_the_page(page, order);
-	else if (!PageHead(page))
+	else if (!head)
 		while (order-- > 0)
 			free_the_page(page + (1 << order), order);
 }
--=20
2.22.3
