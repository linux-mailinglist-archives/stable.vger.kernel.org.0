Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CAB950730A
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 18:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351893AbiDSQif (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 12:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345022AbiDSQid (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 12:38:33 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE7B13DED;
        Tue, 19 Apr 2022 09:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1650386148; x=1681922148;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=UAQS9Ucc97ixoCAa/GXdHOtE5eTmLEglP5XSzWrlsIs=;
  b=rK/m0bGQ9cDm8G9ckp2t5NMpPxCCOiMn+Y/6FWUwUm8yYzRm3Nslww5A
   hvKH+XSdCI0XfGUiQtMItj3x4puTYgIY8Xrk0jUEAtwLPzP9qg1LvDdgT
   NjvsG4ho4z52seBtjfvup/miRf2y0XQQwHoTk8MZCskMGzQ8IpSdoPhXx
   uBulWOicPV2X6929a05XOpcrD77ymnqmIn15GXFlGOUb+1Nn3O5uDGC9k
   9WeSBxu6VgLGFCNxfUE/5bA83sqmeK7GCR1/2B0ZSrA2zeri9iCOIqEp1
   nIihwFNLBZv2SAePtN8N9Cycv/LzLQ9scp/C9ZMAqNqzarTumqHK97C4/
   g==;
X-IronPort-AV: E=Sophos;i="5.90,273,1643644800"; 
   d="scan'208";a="310252242"
Received: from mail-bn8nam11lp2172.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.172])
  by ob1.hgst.iphmx.com with ESMTP; 20 Apr 2022 00:35:46 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZAkHbKaA71uh1Ch2Lrv50jTLoFoRKJMMlWy34I5tFPiRWnWNx92TvdbfbOALPINVmCOl4PMTOTuqIPzGtJI/7Es3E5Q4P80oX1a16bPR+LIN8lNUqmrC66z2UEOMxkK84yHtl3yOBhrCbp273mCwegYINt48Rx9pSKVHkes0EFKUhxFMw26V9vYgQMyyG5fm+jp/krfvDAL8jS3/GvSFzlj2FvDF3GpbaRXh03nZrplfvcylZQcBhneU6KCKqxr1Tq6WfVYVL3lU1pEYn7HWCZC+H414hd4psPdlWxy0tOAsh3leZZluucGvdI98USSWOVNjgYrGLDzKng4v4cWghg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qAxqHUS29GSzwlbRMFoL+BkrFyYWLQnr4T5wEo+d+yA=;
 b=jMfEKQkaP7J8GdmTfZP5EjzJN54eNyKzQUl9KEAyaa4K3ShCcCi8KewzySzzTdGByPBZkcjRUeFpHNIKrDGfWQUR+wlHNhsXn5KMeYWymbQWGtMxf7ZY7ZPIxeMqHSZezn48ovaGZIGxG+MVrGdpAn0v8Ru4JX0sbOy4QFdmCOafHTIPRndIDHHAqtr97RJBx+oJ/oejv40TK3L0MoKY0aNOcK+x/mGbAvwt0dP+kaZ9ZW3jEl8S3m3o2rNF+iSCNIvlBdzw2cnsti/TKWq/uBFQ6o4tG+cyeDMxuvwz9qthsLjSnReaF/oHNpW850TQgtHMvu/DyKzbFMHc4gSPRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qAxqHUS29GSzwlbRMFoL+BkrFyYWLQnr4T5wEo+d+yA=;
 b=rCCYEwTZ0IEmkDWiz4u2Zs3sQ9SPbvd8XDJ1ec5aBzcQVVavNzWDlCtA//qLgjFQqsTu8+ruF1aEuVgiBO/vseCZ0MH+frXctjPSIXLbdt4ntxLezQJCrfPZwUXvV4VcrSj0kXnSsuea/m6KuOSEUdvm0DhUziGCHeTX10im5rM=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by DM6PR04MB6314.namprd04.prod.outlook.com (2603:10b6:5:1ef::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Tue, 19 Apr
 2022 16:35:45 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::3cff:7ee8:c1b5:b4e7]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::3cff:7ee8:c1b5:b4e7%4]) with mapi id 15.20.5186.013; Tue, 19 Apr 2022
 16:35:44 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
CC:     Kees Cook <keescook@chromium.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Greg Ungerer <gerg@linux-m68k.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        kernel test robot <lkp@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] binfmt_flat; Drop vestigates of coredump support
Thread-Topic: [PATCH] binfmt_flat; Drop vestigates of coredump support
Thread-Index: AQHYU/gtbXs+dU6bFkyg1y8SngPsT6z3bxaA
Date:   Tue, 19 Apr 2022 16:35:44 +0000
Message-ID: <Yl7k3zlbHfmdbYGu@x1-carbon>
References: <20220418200834.1501454-1-Niklas.Cassel@wdc.com>
 <202204181501.D55C8D2A@keescook>
 <87mtgh17li.fsf_-_@email.froward.int.ebiederm.org>
In-Reply-To: <87mtgh17li.fsf_-_@email.froward.int.ebiederm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 81979c96-53cc-421b-0ef2-08da2222a6bf
x-ms-traffictypediagnostic: DM6PR04MB6314:EE_
x-microsoft-antispam-prvs: <DM6PR04MB631409AEDDA0323FA1E4D524F2F29@DM6PR04MB6314.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mOEvisWSx7IuM4irnXoAJkRU/8NHpzRBT55Fl1+lFNEkAPcgNtQL1TUf9EKWpwxEpMUbkGD2kC/mb8fux04USbA9wjhmQlbJOyCo/oBe7pBrPAOfavJ1S55CbbxAegXPbHiei+7Khp6x3fACjIIC3qVSqMqGLHLxsa9DAmPJkco4xWAWcwWAuHKnyZv4YI0S7HH99zLiJq936QbEJBflrdl3Mi2EDTMavHWWEC9GP73MCueh4425OUlTDELqPJUJVanccBg2YPzNgqOnSKd1cHXfwzvtXgliEpqEPEt8sJnkWkRgM1nYGTUkdRJSDFnAH1m3KFM26SLYUhD9jJKtiwyD3wE2v3PUEmFDicU2Qs9B7bUQaC2f/0ahdpZK9Do6PtlOWlCmuh0IF2rGsGJ4jErvSG4shBqGhVarjsRHokceKFmyoCHiu8okI7ERbhsbJfDhHlVlC9ZHrIojfG1t0uXnx0h2S8lqoExpmossMlgW8qAbWXW6SD6rFjm+2eJocgJdfzXK2q2/HVg9Q/z+v0cWlAq131eCh5NpD69pi8u9GhNQQkHNtBxevx/7TpzC78n955PcJHX2IfaD3TFxaFIJGno2aVoy5dIeNbL2JD0VuINMhYZUw9D72ng5WY1r6JCtJmzLYe00ANonP5SmV9XRcJP2dzEqMIeGNGpkEQccfCNXXy6a2eoGInlIMm+u+n9kacfmuOSOhXHj8Sp8cw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(38070700005)(2906002)(6506007)(9686003)(6512007)(26005)(186003)(33716001)(83380400001)(38100700002)(122000001)(8936002)(6916009)(316002)(54906003)(4326008)(66946007)(8676002)(66556008)(66476007)(66446008)(64756008)(91956017)(508600001)(86362001)(5660300002)(6486002)(82960400001)(71200400001)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Kkeeb4BNClesNXgiONDkQkrCqNbupPDvP8+U2L0sNGMkA9VDBzgBk00YQ3MS?=
 =?us-ascii?Q?qh1iCkxcNJYdtl4h1NxYjIcwfLwV+CdbqJ9UumCx0DHwgBsdRMpW3N+JKKBx?=
 =?us-ascii?Q?9x0JAgtiE9qKFD4jw1vuSWi4KxQfjcqFloI0MeVWJiNU+cMxeSkjUqHqM4fE?=
 =?us-ascii?Q?T9rf9PR3cAIstWYscpT0PV+vfs2MpfFguijb42HVkknuatwXiLqtdBxkSLW2?=
 =?us-ascii?Q?GzLPva6VYMRScbvUxgSMzdgP9GOyAU5wejCpkbG8x/vpRS79l1JKtwDMQ8ae?=
 =?us-ascii?Q?60F8xeVnAJ1yfv6fMlXAydOhbtxamHEnn1omAC1/MHGKZ/PfuIvFZFY+lHLg?=
 =?us-ascii?Q?LfcVN/yMG3if/cBQ+eCErventdE1PfQvjreeSIAbOCuFSykqP89rOIB7hqdU?=
 =?us-ascii?Q?wLYR4CKr3+S5QXs1d3ZUCn1nfd0FxBcDsxTLr7gkoRa4aBxDFUfTqQjhbtWU?=
 =?us-ascii?Q?wpxnNvPhjeuVxEs2gWlRRVteXUgXmISUIqvBRYwvwFFeit5wF3hMLCnqrMpa?=
 =?us-ascii?Q?kTuz97N2RL5czL59AsptKjv8ImIKx7hqj8M6DnMB7kdb6SSewMK+yGtzV2px?=
 =?us-ascii?Q?5ayow1l4ovIcmL2tgdEPqN/FYvGbOoaZABjvbtXWOOd8OK2VprttofPwnlj5?=
 =?us-ascii?Q?ts4mF3JSbdVIZdCTEv3xuM0sGm6WrdrU8TV5acbcgWI9+2JSR/kxrSoQO8Hu?=
 =?us-ascii?Q?mahaJ+Q/xyL3bRbWe6bfMcGNSZaB+91+WA+Q3HgBVIwG1+OZm51W9CjPliby?=
 =?us-ascii?Q?Yz5INkeVCXrmrJkAVroZUoLfUNshJQlsDY5WIhfP0Hg6bfvLcjXOulZV0A5D?=
 =?us-ascii?Q?TbY6c1Wku7VD61CZoUZm7tY6PzMYp0n/5wJBrxbuUU2jCRP5Fa6dmsXS1fBx?=
 =?us-ascii?Q?dfIDeHZkbTpDRlDHqa3f6FpeVJsPaRW5SA00riUj8fdt3sfjKBx3OcZbT96H?=
 =?us-ascii?Q?LtvlI14bLQY1dzNgssPRNyDx2D2QA3fWhcKlqE/qD2E9pvzcedwli+vNMP5C?=
 =?us-ascii?Q?f5a3PBMJI8CNT4zStI9Ufch+luxpJ7/BjeeyBsOJFFi1Ihu81C+jn8mlA6kp?=
 =?us-ascii?Q?sRdZcbTbMVaGZ+lt4pv0JLykm/gcj7l0GYl2SxQS8BNu+R1vliLtRsTN+uN0?=
 =?us-ascii?Q?dfvMVHCmPdZ9huwb0F7yMAGgm/KDaZBq//5oQJuPU91+Mhooe+CgRy9Twe/P?=
 =?us-ascii?Q?yxzgncfEJdzQj8/TdKiSU0IKDODJozNrY2aXO1iyhztmk+J6Oa5WSyQR/RU1?=
 =?us-ascii?Q?4xe4MZp3Bg6dfmA5cUwfyheEquINw7VG/HbbjFTu6JR8GdX/wOTFkDNu+bbd?=
 =?us-ascii?Q?CWyga231d8QvnHf+uHQ3/UcMmm8nCdcKdn/CzbkmrqoETbKK4YxjivuS4AOw?=
 =?us-ascii?Q?nVBv8mTv922GjCN1WgHeBQ1x/0bQmXlKKniG3ZHq1ugcRss8IM+oS0lBN+Zt?=
 =?us-ascii?Q?9dSDpH7aYz3e3XWPbi5k1NpHtFvNPoNZm6N4N/I8Y+njEii5ol178+FGRdgi?=
 =?us-ascii?Q?dMdH4VESJ5nQOM8EYAU5Sk5yNp3EakIsNSb3s6enUIYOyI1qCP9smLEtIyA+?=
 =?us-ascii?Q?/Tt8VKFdtKigPdLAFZdumU7nlFReeqtDlQKy16ET9V7lBHhgQZSqCEnQ7aSc?=
 =?us-ascii?Q?oeIVRsLxwGEA7z3BRl/tiBpQzbVNiLVvkkXGWpKzqNPT9JF1nx4btHWCw96y?=
 =?us-ascii?Q?tHxbltBIUMwz1gtE35CKMzIdjopJsOOgK/j+vvtIET4KgsyOosA68LghWS5l?=
 =?us-ascii?Q?gCwWphkn9w2lb+l1xn3cGP5Gkuda8XU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2078BB13AD909A4A83D53B0DC88C500F@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81979c96-53cc-421b-0ef2-08da2222a6bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2022 16:35:44.7806
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UD0fvYuSRR6jFmKOzp4LU0LKqz62BKr7Sm42haKXO6PJyH4z5FD+sydHcFUw8pMHUX4khp5bveAECNFcl9X6zQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6314
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 19, 2022 at 09:16:41AM -0500, Eric W. Biederman wrote:
>=20
> There is the briefest start of coredump support in binfmt_flat.  It is
> actually a pain to maintain as binfmt_flat is not built on most
> architectures so it is easy to overlook.
>=20
> Since the support does not do anything remove it.
>=20
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>=20
> Apologies for hijacking this thread but it looks like we have people who
> are actively using binfmt_flat on it.
>=20
> Does anyone have any objections to simply removing what little there
> is of coredump support from binfmt_flat?
>=20
> Eric
>=20
>  fs/binfmt_flat.c | 22 ----------------------
>  1 file changed, 22 deletions(-)
>=20
> diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
> index 626898150011..0ad2c7bbaddd 100644
> --- a/fs/binfmt_flat.c
> +++ b/fs/binfmt_flat.c
> @@ -37,7 +37,6 @@
>  #include <linux/flat.h>
>  #include <linux/uaccess.h>
>  #include <linux/vmalloc.h>
> -#include <linux/coredump.h>
> =20
>  #include <asm/byteorder.h>
>  #include <asm/unaligned.h>
> @@ -98,33 +97,12 @@ static int load_flat_shared_library(int id, struct li=
b_info *p);
>  #endif
> =20
>  static int load_flat_binary(struct linux_binprm *);
> -#ifdef CONFIG_COREDUMP
> -static int flat_core_dump(struct coredump_params *cprm);
> -#endif
> =20
>  static struct linux_binfmt flat_format =3D {
>  	.module		=3D THIS_MODULE,
>  	.load_binary	=3D load_flat_binary,
> -#ifdef CONFIG_COREDUMP
> -	.core_dump	=3D flat_core_dump,
> -	.min_coredump	=3D PAGE_SIZE
> -#endif
>  };
> =20
> -/***********************************************************************=
*****/
> -/*
> - * Routine writes a core dump image in the current directory.
> - * Currently only a stub-function.
> - */
> -
> -#ifdef CONFIG_COREDUMP
> -static int flat_core_dump(struct coredump_params *cprm)
> -{
> -	pr_warn("Process %s:%d received signr %d and should have core dumped\n"=
,
> -		current->comm, current->pid, cprm->siginfo->si_signo);
> -	return 1;
> -}
> -#endif

Since this only prints a warning that the process "should have core dumped"=
,
I agree, I don't really see the point of keeping this code.

nit: $subject: "binfmt_flat; Drop vestigates of coredump support"
s/;/:/

Other than that:
Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
