Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 733D495817
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 09:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728898AbfHTHR2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 03:17:28 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3971 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726049AbfHTHR2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 03:17:28 -0400
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.54])
        by Forcepoint Email with ESMTP id 5C1EF788C0609428E3B8;
        Tue, 20 Aug 2019 15:17:23 +0800 (CST)
Received: from dggeme762-chm.china.huawei.com (10.3.19.108) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 20 Aug 2019 15:17:22 +0800
Received: from architecture4 (10.140.130.215) by
 dggeme762-chm.china.huawei.com (10.3.19.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Tue, 20 Aug 2019 15:17:22 +0800
Date:   Tue, 20 Aug 2019 15:16:45 +0800
From:   Gao Xiang <gaoxiang25@huawei.com>
To:     "Li, Philip" <philip.li@intel.com>
CC:     Gao Xiang <hsiangkao@aol.com>, lkp <lkp@intel.com>,
        "kbuild-all@01.org" <kbuild-all@01.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-erofs@lists.ozlabs.org" <linux-erofs@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Fang Wei <fangwei1@huawei.com>, Miao Xie <miaoxie@huawei.com>
Subject: Re: [PATCH] staging: erofs: fix an error handling in erofs_readdir()
Message-ID: <20190820071645.GH159846@architecture4>
References: <20190818031855.9723-1-hsiangkao@aol.com>
 <201908182116.RRufKUpl%lkp@intel.com>
 <20190818132503.GA26232@hsiangkao-HP-ZHAN-66-Pro-G1>
 <20190820065038.GG4479@intel.com>
 <20190820065010.GG159846@architecture4>
 <831EE4E5E37DCC428EB295A351E66249520C70FE@shsmsx102.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <831EE4E5E37DCC428EB295A351E66249520C70FE@shsmsx102.ccr.corp.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.140.130.215]
X-ClientProxiedBy: dggeme703-chm.china.huawei.com (10.1.199.99) To
 dggeme762-chm.china.huawei.com (10.3.19.108)
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 20, 2019 at 06:58:00AM +0000, Li, Philip wrote:
> > Subject: Re: [PATCH] staging: erofs: fix an error handling in erofs_readdir()
> > 
> > Hi Philip,
> > 
> > On Tue, Aug 20, 2019 at 02:50:38PM +0800, Philip Li wrote:
> > > On Sun, Aug 18, 2019 at 09:25:04PM +0800, Gao Xiang wrote:
> > > > On Sun, Aug 18, 2019 at 09:17:52PM +0800, kbuild test robot wrote:
> > > > > Hi Gao,
> > > > >
> > > > > I love your patch! Yet something to improve:
> > > > >
> > > > > [auto build test ERROR on linus/master]
> > > > > [cannot apply to v5.3-rc4 next-20190816]
> > > > > [if your patch is applied to the wrong git tree, please drop us a note to help
> > improve the system]
> > > >
> > > > ... those patches should be applied to staging tree
> > > > since linux-next has not been updated yet...
> > > thanks for the feedback, we will consider this to our todo list.
> > 
> > Yes, many confusing reports anyway...
> > (Just my personal suggestion, maybe we can add some hints on the patch email
> > to indicate which tree can be applied successfully for ci in the future...)
> thanks, this is good idea. On the other side, we support to add --base option to git format-patch
> to automatically suggest the base, refer to https://stackoverflow.com/a/37406982 for detail.

Thanks for your information :) It seems a new patch format,
I will take a try later.

Thanks,
Gao Xiang

> Meanwhile, we will enhance the internal logic to find suitable base if possible.
> 
> > 
> > Thanks,
> > Gao Xiang
> > 
> > >
> > > >
> > > > Thanks,
> > > > Gao Xiang
> > > >
> > > > >
> > > > > url:    https://github.com/0day-ci/linux/commits/Gao-Xiang/staging-erofs-fix-
> > an-error-handling-in-erofs_readdir/20190818-191344
> > > > > config: arm64-allyesconfig (attached as .config)
> > > > > compiler: aarch64-linux-gcc (GCC) 7.4.0
> > > > > reproduce:
> > > > >         wget https://raw.githubusercontent.com/intel/lkp-
> > tests/master/sbin/make.cross -O ~/bin/make.cross
> > > > >         chmod +x ~/bin/make.cross
> > > > >         # save the attached .config to linux build tree
> > > > >         GCC_VERSION=7.4.0 make.cross ARCH=arm64
> > > > >
> > > > > If you fix the issue, kindly add following tag
> > > > > Reported-by: kbuild test robot <lkp@intel.com>
> > > > >
> > > > > All errors (new ones prefixed by >>):
> > > > >
> > > > >    drivers/staging/erofs/dir.c: In function 'erofs_readdir':
> > > > > >> drivers/staging/erofs/dir.c:110:11: error: 'EFSCORRUPTED' undeclared
> > (first use in this function); did you mean 'FS_NRSUPER'?
> > > > >        err = -EFSCORRUPTED;
> > > > >               ^~~~~~~~~~~~
> > > > >               FS_NRSUPER
> > > > >    drivers/staging/erofs/dir.c:110:11: note: each undeclared identifier is
> > reported only once for each function it appears in
> > > > >
> > > > > vim +110 drivers/staging/erofs/dir.c
> > > > >
> > > > >     85
> > > > >     86	static int erofs_readdir(struct file *f, struct dir_context *ctx)
> > > > >     87	{
> > > > >     88		struct inode *dir = file_inode(f);
> > > > >     89		struct address_space *mapping = dir->i_mapping;
> > > > >     90		const size_t dirsize = i_size_read(dir);
> > > > >     91		unsigned int i = ctx->pos / EROFS_BLKSIZ;
> > > > >     92		unsigned int ofs = ctx->pos % EROFS_BLKSIZ;
> > > > >     93		int err = 0;
> > > > >     94		bool initial = true;
> > > > >     95
> > > > >     96		while (ctx->pos < dirsize) {
> > > > >     97			struct page *dentry_page;
> > > > >     98			struct erofs_dirent *de;
> > > > >     99			unsigned int nameoff, maxsize;
> > > > >    100
> > > > >    101			dentry_page = read_mapping_page(mapping, i,
> > NULL);
> > > > >    102			if (dentry_page == ERR_PTR(-ENOMEM)) {
> > > > >    103				errln("no memory to readdir of logical
> > block %u of nid %llu",
> > > > >    104				      i, EROFS_V(dir)->nid);
> > > > >    105				err = -ENOMEM;
> > > > >    106				break;
> > > > >    107			} else if (IS_ERR(dentry_page)) {
> > > > >    108				errln("fail to readdir of logical block %u of
> > nid %llu",
> > > > >    109				      i, EROFS_V(dir)->nid);
> > > > >  > 110				err = -EFSCORRUPTED;
> > > > >    111				break;
> > > > >    112			}
> > > > >    113
> > > > >    114			de = (struct erofs_dirent *)kmap(dentry_page);
> > > > >    115
> > > > >    116			nameoff = le16_to_cpu(de->nameoff);
> > > > >    117
> > > > >    118			if (unlikely(nameoff < sizeof(struct erofs_dirent) ||
> > > > >    119				     nameoff >= PAGE_SIZE)) {
> > > > >    120				errln("%s, invalid de[0].nameoff %u",
> > > > >    121				      __func__, nameoff);
> > > > >    122
> > > > >    123				err = -EIO;
> > > > >    124				goto skip_this;
> > > > >    125			}
> > > > >    126
> > > > >    127			maxsize = min_t(unsigned int,
> > > > >    128					dirsize - ctx->pos + ofs,
> > PAGE_SIZE);
> > > > >    129
> > > > >    130			/* search dirents at the arbitrary position */
> > > > >    131			if (unlikely(initial)) {
> > > > >    132				initial = false;
> > > > >    133
> > > > >    134				ofs = roundup(ofs, sizeof(struct
> > erofs_dirent));
> > > > >    135				if (unlikely(ofs >= nameoff))
> > > > >    136					goto skip_this;
> > > > >    137			}
> > > > >    138
> > > > >    139			err = erofs_fill_dentries(ctx, de, &ofs, nameoff,
> > maxsize);
> > > > >    140	skip_this:
> > > > >    141			kunmap(dentry_page);
> > > > >    142
> > > > >    143			put_page(dentry_page);
> > > > >    144
> > > > >    145			ctx->pos = blknr_to_addr(i) + ofs;
> > > > >    146
> > > > >    147			if (unlikely(err))
> > > > >    148				break;
> > > > >    149			++i;
> > > > >    150			ofs = 0;
> > > > >    151		}
> > > > >    152		return err < 0 ? err : 0;
> > > > >    153	}
> > > > >    154
> > > > >
> > > > > ---
> > > > > 0-DAY kernel test infrastructure                Open Source Technology Center
> > > > > https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> > > >
> > > >
