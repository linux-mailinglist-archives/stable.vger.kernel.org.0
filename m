Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C95FE5401B3
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 16:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244660AbiFGOrB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 10:47:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243135AbiFGOrA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 10:47:00 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 148B111459;
        Tue,  7 Jun 2022 07:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654613219; x=1686149219;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=odwdWlnQ9jRF9jWN7q93T9igP7HxtCpuPP7OPv+3EpE=;
  b=mGaAKf7hMnOiO8eWT2hvBQpl0fTtg0yvVoJ5TDjALlcVLFXA5ZmhVhT3
   Pw5p38D3XWSx7EpHPmozkAj2BPaK7F2REbokP7n0Xs4v1WRDDyhXEXT7E
   qYMjUAXdaGgOG4arNL00GVu1pZjnDh/9VyBOT78x4g2PUM+ePGHiDEeh9
   2pLzPsbtzZvd0vFUFxpjRPJvPYYoajky1EchZzsD3mNbWV82duASiDhl0
   yxPmJ63GaHSu9xfDTl+xV19aR3/qbOkFA9QBp6LLCaFu+it096DJ31hl5
   XKuZxSnEgZAMVyJcK5Dv09gRVtlY4WFH1PYYED6ih+fFJs0Fmwr7Epuen
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10371"; a="274260366"
X-IronPort-AV: E=Sophos;i="5.91,284,1647327600"; 
   d="scan'208";a="274260366"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2022 07:46:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,284,1647327600"; 
   d="scan'208";a="669999355"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 07 Jun 2022 07:46:56 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nyaTv-000DiX-De;
        Tue, 07 Jun 2022 14:46:55 +0000
Date:   Tue, 7 Jun 2022 22:46:03 +0800
From:   kernel test robot <lkp@intel.com>
To:     gregkh@linuxfoundation.org, brauner@kernel.org, amir73il@gmail.com,
        gscrivan@redhat.com, hch@lst.de, linux-fsdevel@vger.kernel.org,
        mszeredi@redhat.com, stable@vger.kernel.org
Cc:     kbuild-all@lists.01.org
Subject: Re: FAILED: patch "[PATCH] exportfs: support idmapped mounts" failed
 to apply to 5.4-stable tree
Message-ID: <202206072252.SYRt38ih-lkp@intel.com>
References: <165451866750136@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165451866750136@kroah.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I love your patch! Perhaps something to improve:

[auto build test WARNING on hch-configfs/for-next]
[cannot apply to linus/master v5.19-rc1 next-20220607]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/gregkh-linuxfoundation-org/FAILED-patch-PATCH-exportfs-support-idmapped-mounts-failed-to-apply-to-5-4-stable-tree/20220606-203330
base:   git://git.infradead.org/users/hch/configfs.git for-next
config: x86_64-rhel-8.3 (https://download.01.org/0day-ci/archive/20220607/202206072252.SYRt38ih-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-1) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/cda5e21742a0ec193c2dfd7e445a2024f9685eb9
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review gregkh-linuxfoundation-org/FAILED-patch-PATCH-exportfs-support-idmapped-mounts-failed-to-apply-to-5-4-stable-tree/20220606-203330
        git checkout cda5e21742a0ec193c2dfd7e445a2024f9685eb9
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash fs/exportfs/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   fs/exportfs/expfs.c: In function 'reconnect_one':
   fs/exportfs/expfs.c:148:15: error: implicit declaration of function 'lookup_one_unlocked'; did you mean 'lookup_one_len_unlocked'? [-Werror=implicit-function-declaration]
     148 |         tmp = lookup_one_unlocked(mnt_user_ns(mnt), nbuf, parent, strlen(nbuf));
         |               ^~~~~~~~~~~~~~~~~~~
         |               lookup_one_len_unlocked
>> fs/exportfs/expfs.c:148:13: warning: assignment to 'struct dentry *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     148 |         tmp = lookup_one_unlocked(mnt_user_ns(mnt), nbuf, parent, strlen(nbuf));
         |             ^
   cc1: some warnings being treated as errors


vim +148 fs/exportfs/expfs.c

   108	
   109	/*
   110	 * Reconnect a directory dentry with its parent.
   111	 *
   112	 * This can return a dentry, or NULL, or an error.
   113	 *
   114	 * In the first case the returned dentry is the parent of the given
   115	 * dentry, and may itself need to be reconnected to its parent.
   116	 *
   117	 * In the NULL case, a concurrent VFS operation has either renamed or
   118	 * removed this directory.  The concurrent operation has reconnected our
   119	 * dentry, so we no longer need to.
   120	 */
   121	static struct dentry *reconnect_one(struct vfsmount *mnt,
   122			struct dentry *dentry, char *nbuf)
   123	{
   124		struct dentry *parent;
   125		struct dentry *tmp;
   126		int err;
   127	
   128		parent = ERR_PTR(-EACCES);
   129		inode_lock(dentry->d_inode);
   130		if (mnt->mnt_sb->s_export_op->get_parent)
   131			parent = mnt->mnt_sb->s_export_op->get_parent(dentry);
   132		inode_unlock(dentry->d_inode);
   133	
   134		if (IS_ERR(parent)) {
   135			dprintk("%s: get_parent of %ld failed, err %d\n",
   136				__func__, dentry->d_inode->i_ino, PTR_ERR(parent));
   137			return parent;
   138		}
   139	
   140		dprintk("%s: find name of %lu in %lu\n", __func__,
   141			dentry->d_inode->i_ino, parent->d_inode->i_ino);
   142		err = exportfs_get_name(mnt, parent, nbuf, dentry);
   143		if (err == -ENOENT)
   144			goto out_reconnected;
   145		if (err)
   146			goto out_err;
   147		dprintk("%s: found name: %s\n", __func__, nbuf);
 > 148		tmp = lookup_one_unlocked(mnt_user_ns(mnt), nbuf, parent, strlen(nbuf));
   149		if (IS_ERR(tmp)) {
   150			dprintk("%s: lookup failed: %d\n", __func__, PTR_ERR(tmp));
   151			err = PTR_ERR(tmp);
   152			goto out_err;
   153		}
   154		if (tmp != dentry) {
   155			/*
   156			 * Somebody has renamed it since exportfs_get_name();
   157			 * great, since it could've only been renamed if it
   158			 * got looked up and thus connected, and it would
   159			 * remain connected afterwards.  We are done.
   160			 */
   161			dput(tmp);
   162			goto out_reconnected;
   163		}
   164		dput(tmp);
   165		if (IS_ROOT(dentry)) {
   166			err = -ESTALE;
   167			goto out_err;
   168		}
   169		return parent;
   170	
   171	out_err:
   172		dput(parent);
   173		return ERR_PTR(err);
   174	out_reconnected:
   175		dput(parent);
   176		/*
   177		 * Someone must have renamed our entry into another parent, in
   178		 * which case it has been reconnected by the rename.
   179		 *
   180		 * Or someone removed it entirely, in which case filehandle
   181		 * lookup will succeed but the directory is now IS_DEAD and
   182		 * subsequent operations on it will fail.
   183		 *
   184		 * Alternatively, maybe there was no race at all, and the
   185		 * filesystem is just corrupt and gave us a parent that doesn't
   186		 * actually contain any entry pointing to this inode.  So,
   187		 * double check that this worked and return -ESTALE if not:
   188		 */
   189		if (!dentry_connected(dentry))
   190			return ERR_PTR(-ESTALE);
   191		return NULL;
   192	}
   193	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
