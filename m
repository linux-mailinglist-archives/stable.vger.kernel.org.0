Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86A78957B8
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 08:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729273AbfHTG6E convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 20 Aug 2019 02:58:04 -0400
Received: from mga14.intel.com ([192.55.52.115]:20327 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726049AbfHTG6E (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 02:58:04 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Aug 2019 23:58:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,407,1559545200"; 
   d="scan'208";a="262076234"
Received: from fmsmsx104.amr.corp.intel.com ([10.18.124.202])
  by orsmga001.jf.intel.com with ESMTP; 19 Aug 2019 23:58:02 -0700
Received: from fmsmsx111.amr.corp.intel.com (10.18.116.5) by
 fmsmsx104.amr.corp.intel.com (10.18.124.202) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 19 Aug 2019 23:58:02 -0700
Received: from shsmsx108.ccr.corp.intel.com (10.239.4.97) by
 fmsmsx111.amr.corp.intel.com (10.18.116.5) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 19 Aug 2019 23:58:02 -0700
Received: from shsmsx102.ccr.corp.intel.com ([169.254.2.19]) by
 SHSMSX108.ccr.corp.intel.com ([169.254.8.163]) with mapi id 14.03.0439.000;
 Tue, 20 Aug 2019 14:58:00 +0800
From:   "Li, Philip" <philip.li@intel.com>
To:     Gao Xiang <gaoxiang25@huawei.com>
CC:     Gao Xiang <hsiangkao@aol.com>, lkp <lkp@intel.com>,
        "kbuild-all@01.org" <kbuild-all@01.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-erofs@lists.ozlabs.org" <linux-erofs@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Fang Wei <fangwei1@huawei.com>, Miao Xie <miaoxie@huawei.com>
Subject: RE: [PATCH] staging: erofs: fix an error handling in erofs_readdir()
Thread-Topic: [PATCH] staging: erofs: fix an error handling in
 erofs_readdir()
Thread-Index: AQHVVciSAydYtdJuwUarX+BT1XqKVqcDFXgA////3wCAAIa24A==
Date:   Tue, 20 Aug 2019 06:58:00 +0000
Message-ID: <831EE4E5E37DCC428EB295A351E66249520C70FE@shsmsx102.ccr.corp.intel.com>
References: <20190818031855.9723-1-hsiangkao@aol.com>
 <201908182116.RRufKUpl%lkp@intel.com>
 <20190818132503.GA26232@hsiangkao-HP-ZHAN-66-Pro-G1>
 <20190820065038.GG4479@intel.com> <20190820065010.GG159846@architecture4>
In-Reply-To: <20190820065010.GG159846@architecture4>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNDcxM2U4NjEtNmJjNS00OWM4LTllYjgtYzNhZmJhMjQwY2JlIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiS0YrbEh1azRwaVQ0b0RWbSszQVwvSHNpNVZqNmpGK0hHTjh5Z2l5TndJMFhYdWFWVE10S0txTHdJOWRFZ2dxcWcifQ==
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Subject: Re: [PATCH] staging: erofs: fix an error handling in erofs_readdir()
> 
> Hi Philip,
> 
> On Tue, Aug 20, 2019 at 02:50:38PM +0800, Philip Li wrote:
> > On Sun, Aug 18, 2019 at 09:25:04PM +0800, Gao Xiang wrote:
> > > On Sun, Aug 18, 2019 at 09:17:52PM +0800, kbuild test robot wrote:
> > > > Hi Gao,
> > > >
> > > > I love your patch! Yet something to improve:
> > > >
> > > > [auto build test ERROR on linus/master]
> > > > [cannot apply to v5.3-rc4 next-20190816]
> > > > [if your patch is applied to the wrong git tree, please drop us a note to help
> improve the system]
> > >
> > > ... those patches should be applied to staging tree
> > > since linux-next has not been updated yet...
> > thanks for the feedback, we will consider this to our todo list.
> 
> Yes, many confusing reports anyway...
> (Just my personal suggestion, maybe we can add some hints on the patch email
> to indicate which tree can be applied successfully for ci in the future...)
thanks, this is good idea. On the other side, we support to add --base option to git format-patch
to automatically suggest the base, refer to https://stackoverflow.com/a/37406982 for detail.
Meanwhile, we will enhance the internal logic to find suitable base if possible.

> 
> Thanks,
> Gao Xiang
> 
> >
> > >
> > > Thanks,
> > > Gao Xiang
> > >
> > > >
> > > > url:    https://github.com/0day-ci/linux/commits/Gao-Xiang/staging-erofs-fix-
> an-error-handling-in-erofs_readdir/20190818-191344
> > > > config: arm64-allyesconfig (attached as .config)
> > > > compiler: aarch64-linux-gcc (GCC) 7.4.0
> > > > reproduce:
> > > >         wget https://raw.githubusercontent.com/intel/lkp-
> tests/master/sbin/make.cross -O ~/bin/make.cross
> > > >         chmod +x ~/bin/make.cross
> > > >         # save the attached .config to linux build tree
> > > >         GCC_VERSION=7.4.0 make.cross ARCH=arm64
> > > >
> > > > If you fix the issue, kindly add following tag
> > > > Reported-by: kbuild test robot <lkp@intel.com>
> > > >
> > > > All errors (new ones prefixed by >>):
> > > >
> > > >    drivers/staging/erofs/dir.c: In function 'erofs_readdir':
> > > > >> drivers/staging/erofs/dir.c:110:11: error: 'EFSCORRUPTED' undeclared
> (first use in this function); did you mean 'FS_NRSUPER'?
> > > >        err = -EFSCORRUPTED;
> > > >               ^~~~~~~~~~~~
> > > >               FS_NRSUPER
> > > >    drivers/staging/erofs/dir.c:110:11: note: each undeclared identifier is
> reported only once for each function it appears in
> > > >
> > > > vim +110 drivers/staging/erofs/dir.c
> > > >
> > > >     85
> > > >     86	static int erofs_readdir(struct file *f, struct dir_context *ctx)
> > > >     87	{
> > > >     88		struct inode *dir = file_inode(f);
> > > >     89		struct address_space *mapping = dir->i_mapping;
> > > >     90		const size_t dirsize = i_size_read(dir);
> > > >     91		unsigned int i = ctx->pos / EROFS_BLKSIZ;
> > > >     92		unsigned int ofs = ctx->pos % EROFS_BLKSIZ;
> > > >     93		int err = 0;
> > > >     94		bool initial = true;
> > > >     95
> > > >     96		while (ctx->pos < dirsize) {
> > > >     97			struct page *dentry_page;
> > > >     98			struct erofs_dirent *de;
> > > >     99			unsigned int nameoff, maxsize;
> > > >    100
> > > >    101			dentry_page = read_mapping_page(mapping, i,
> NULL);
> > > >    102			if (dentry_page == ERR_PTR(-ENOMEM)) {
> > > >    103				errln("no memory to readdir of logical
> block %u of nid %llu",
> > > >    104				      i, EROFS_V(dir)->nid);
> > > >    105				err = -ENOMEM;
> > > >    106				break;
> > > >    107			} else if (IS_ERR(dentry_page)) {
> > > >    108				errln("fail to readdir of logical block %u of
> nid %llu",
> > > >    109				      i, EROFS_V(dir)->nid);
> > > >  > 110				err = -EFSCORRUPTED;
> > > >    111				break;
> > > >    112			}
> > > >    113
> > > >    114			de = (struct erofs_dirent *)kmap(dentry_page);
> > > >    115
> > > >    116			nameoff = le16_to_cpu(de->nameoff);
> > > >    117
> > > >    118			if (unlikely(nameoff < sizeof(struct erofs_dirent) ||
> > > >    119				     nameoff >= PAGE_SIZE)) {
> > > >    120				errln("%s, invalid de[0].nameoff %u",
> > > >    121				      __func__, nameoff);
> > > >    122
> > > >    123				err = -EIO;
> > > >    124				goto skip_this;
> > > >    125			}
> > > >    126
> > > >    127			maxsize = min_t(unsigned int,
> > > >    128					dirsize - ctx->pos + ofs,
> PAGE_SIZE);
> > > >    129
> > > >    130			/* search dirents at the arbitrary position */
> > > >    131			if (unlikely(initial)) {
> > > >    132				initial = false;
> > > >    133
> > > >    134				ofs = roundup(ofs, sizeof(struct
> erofs_dirent));
> > > >    135				if (unlikely(ofs >= nameoff))
> > > >    136					goto skip_this;
> > > >    137			}
> > > >    138
> > > >    139			err = erofs_fill_dentries(ctx, de, &ofs, nameoff,
> maxsize);
> > > >    140	skip_this:
> > > >    141			kunmap(dentry_page);
> > > >    142
> > > >    143			put_page(dentry_page);
> > > >    144
> > > >    145			ctx->pos = blknr_to_addr(i) + ofs;
> > > >    146
> > > >    147			if (unlikely(err))
> > > >    148				break;
> > > >    149			++i;
> > > >    150			ofs = 0;
> > > >    151		}
> > > >    152		return err < 0 ? err : 0;
> > > >    153	}
> > > >    154
> > > >
> > > > ---
> > > > 0-DAY kernel test infrastructure                Open Source Technology Center
> > > > https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> > >
> > >
