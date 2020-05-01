Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6DA1C0B93
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 03:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727908AbgEABPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 21:15:37 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46378 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727114AbgEABPg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Apr 2020 21:15:36 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04119SoL083963;
        Fri, 1 May 2020 01:15:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=pBuU+RCLaqVpy+s6o/A5oeo7wautScBrEGmXR33kavo=;
 b=DzgllCfesSD8YjdNEbZx6Yh1/6Qt2pFmiLtOHkM4irGgTkoSijKQBGcJTCKLA1PcPvjp
 g2ohs0IAwZ9nZlGIkDU5/U7YEyFyCncoIOTKvMiRCYLucBO+BV7uGNosef5pvQllx1Z+
 lt5ibico+F5bjU4LQmYRcLSGhJRWzYo00UCi1+6Sj48I0tnufrzZDtul3nBtdMoT7qfK
 TPUQAvQo5r/EeT9ORNlgURGG8bj245bWeAzZULd0I/W5k6kidPufVG70ZSKpxxjKX4GK
 Ljt2kcz8vgUJJXRo47SHs+eblU4QJUYOCdnNMl+wXxBU9BYEtyEggyMAuh0OGKYNfP/U xQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30r7f80d4n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 May 2020 01:15:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04116uFJ061776;
        Fri, 1 May 2020 01:15:34 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 30r7f8pa24-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 May 2020 01:15:34 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0411FWKV031522;
        Fri, 1 May 2020 01:15:33 GMT
Received: from revenge.us.oracle.com (/10.135.188.124)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 18:15:32 -0700
Date:   Fri, 1 May 2020 01:13:18 +0000
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.4] bcache: initialize 'sb_page' in register_bcache()
Message-ID: <20200501011318.pwcjic2jsvotxebd@revenge.us.oracle.com>
References: <041443374fde130be3bc864b6ac8ffba6640c2b0.1588184799.git.tom.saeger@oracle.com>
 <20200430064421.GF2377651@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200430064421.GF2377651@kroah.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=5
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005010004
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 clxscore=1011 phishscore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=5 adultscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005010004
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 30, 2020 at 08:44:21AM +0200, Greg KH wrote:
> On Wed, Apr 29, 2020 at 06:38:17PM +0000, Tom Saeger wrote:
> > commit 393b8509be33 (bcache: rework error unwinding in register_bcache)
> > 
> > introduced compile warning:
> > warning: 'sb_page' may be used uninitialized in this function [-Wmaybe-uninitialized]
> > 
> > Use 'sb_page' initialization prior to 393b8509be33.
> > 
> > Fixes: 393b8509be33 (bcache: rework error unwinding in register_bcache)
> > Cc: <stable@vger.kernel.org> # 5.4.x
> > Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
> > ---
> > 
> > This addresses warning only seen in 5.4.22+.  Upstream avoids
> > this in a different way.
> 
> What is the "different way"?

The mainline commits marked "+" below appear to go together.  Perhaps a
refactoring series?

git log upstream/master v5.4.. --format="%>(16)%h %<(30)%ae %s" -- drivers/md/bcache/super.c
    3d745ea5b095 hch@lst.de                     block: simplify queue allocation
    ff27668ce809 hch@lst.de                     bcache: pass the make_request methods to blk_queue_make_request
    309cc719a2c8 colyli@suse.de                 bcache: Revert "bcache: shrink btree node cache after bch_btree_check()"
    49d08d596e85 colyli@suse.de                 bcache: check return value of prio_read()
+   6321bef028de hch@lst.de                     bcache: use read_cache_page_gfp to read the superblock
+ - 475389ae5c08 hch@lst.de                     bcache: store a pointer to the on-disk sb in the cache and cached_dev structures
+ - cfa0c56db9c0 hch@lst.de                     bcache: return a pointer to the on-disk sb from read_super
+ - fc8f19cc5dce hch@lst.de                     bcache: transfer the sb_page reference to register_{bdev,cache}
+ - ae3cd299919a colyli@suse.de                 bcache: fix use-after-free in register_bcache()
+ - 29cda393bcaa colyli@suse.de                 bcache: properly initialize 'path' and 'err' in register_bcache()
+ - 50246693f81f hch@lst.de                     bcache: rework error unwinding in register_bcache
+   a702a692cd75 hch@lst.de                     bcache: use a separate data structure for the on-disk super block
    e8547d42095e liangchen.linux@gmail.com      bcache: cached_dev_free needs to put the sb page
    c5fcdedcee4e colyli@suse.de                 bcache: add idle_max_writeback_rate sysfs interface
    84c529aea182 andrea.righi@canonical.com     bcache: fix deadlock in bcache_allocator
    aaf8dbeab586 colyli@suse.de                 bcache: add more accurate error messages in read_super()
    2d8869518a52 colyli@suse.de                 bcache: fix static checker warning in bcache_device_free()
    34cf78bf34d4 fangguoju@gmail.com            bcache: fix a lost wake-up problem caused by mca_cannibalize_lock

Bisecting these commits produced similar warnings.  Those marked "-"
all had warnings (for me), and all warnings were resolved with commit:

    6321bef028de hch@lst.de                     bcache: use read_cache_page_gfp to read the superblock


5.4 has 50246693f81f backported as 393b8509be3 (v5.4.22), but doesn't have:

+   6321bef028de hch@lst.de                     bcache: use read_cache_page_gfp to read the superblock
+ - 475389ae5c08 hch@lst.de                     bcache: store a pointer to the on-disk sb in the cache and cached_dev structures
+ - cfa0c56db9c0 hch@lst.de                     bcache: return a pointer to the on-disk sb from read_super
+ - fc8f19cc5dce hch@lst.de                     bcache: transfer the sb_page reference to register_{bdev,cache}

And perhaps 5.4 should continue to exclude these??

Thus the reason for my patch :)

5.6 already has 6321bef028de and won't see this issue.


> 
> And why am I not seeing this warning in my builds?  What version of gcc
> are you using?

Hmm - did I mention this was on arm64 system?

First I was using Oracle Linux 8 (gcc 8.3.1) aarch64.
But I've recreated the same using Fedora 31 (gcc 9.3.1) aarch64.

In file included from ./include/linux/export.h:42,
                 from ./include/linux/linkage.h:7,
                 from ./include/linux/fs.h:5,
                 from ./include/linux/highmem.h:5,
                 from ./include/linux/bio.h:8,
                 from drivers/md/bcache/bcache.h:182,
                 from drivers/md/bcache/super.c:10:
drivers/md/bcache/super.c: In function ‘register_bcache’:
./include/linux/compiler.h:188:26: warning: ‘sb_page’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  188 |  case 8: *(__u64 *)res = *(volatile __u64 *)p; break;  \
      |                          ^
drivers/md/bcache/super.c:2379:15: note: ‘sb_page’ was declared here
 2379 |  struct page *sb_page;
      |               ^~~~~~~
  AR      drivers/md/bcache/built-in.a

Let me know if you need more info.

Regards,

--Tom
