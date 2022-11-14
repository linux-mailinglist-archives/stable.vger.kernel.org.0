Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 458996280CE
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237897AbiKNNJZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:09:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237841AbiKNNJZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:09:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C9C69FCD
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:08:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668431306;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+RATmLDqy4Cb3/OcvezxdmIEs6SpBnhwsQ/KyFcaC8s=;
        b=HlDIQtv50WJ9414i6XrUhkVRuTmOYu5yXxQLbdPkt+AGCEG258Vxem31k3ZqDcRXLPadOP
        xX623oEK9yNytA6DywpviG30IOQpfxdEl3h7FBSCdhzGKIf6J/o79ShURQlGlbk5kB6C0b
        rRK6NnhgfUgAFZA+mLEm15tAQUuDGPI=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-364-amARygVZPeKalYas9Tykdw-1; Mon, 14 Nov 2022 08:08:25 -0500
X-MC-Unique: amARygVZPeKalYas9Tykdw-1
Received: by mail-pj1-f71.google.com with SMTP id r10-20020a17090a1bca00b002137a500398so5765160pjr.5
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:08:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+RATmLDqy4Cb3/OcvezxdmIEs6SpBnhwsQ/KyFcaC8s=;
        b=VXLJJCU/p2ip4Cn8lUvwasDmu/yScP+hQ13yrx+Q8TlFI7lJbkfW5+cQQD0TUqsVfq
         eONepKJPvktq/V1AoqwEWW9V/N5twRf3B/NDT8L7c5pYDNERguJicwSsR4XNJ4XTXcal
         yoELdqBJi0sJrPo/rBPyDyhrzMSscSePZBuhPcWC6jUjKn/Ymx+q1q5N0qBkPISCsX8F
         7Qadz3syiVdvrahs7TjfK4vN8sIqe8LJIEWu7VnHTbla/0k9On0rQoANpZePGkzfPNV1
         Z1J4YENajrx9ZUpjL4stbY2OzlyxuHBiIqT18UDyo1yrbesGqBt358N7xRu8Irf+z3fk
         W/zw==
X-Gm-Message-State: ANoB5plFO3ey6ztW8k/o+A/FeCp5K4zTl0cznWecv8GyXGy4A3Q6aauM
        AqrlKVfTi2cdUZgtEi/y61TBWuXzJemBMXdz8P5VNB4L/b8NG7NosHbbXTI/kO2qbIBaCGWucJp
        JGN5U7r/fYW9YGGhkf+S8WCTtMHgRIl0X849ucuJd0+nlCTXxOAuCxfeK932q0+U1mA==
X-Received: by 2002:a17:903:26c6:b0:178:b4b7:d74d with SMTP id jg6-20020a17090326c600b00178b4b7d74dmr13500438plb.83.1668431304068;
        Mon, 14 Nov 2022 05:08:24 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7ob3Ev+cayEQvYpWckntbw+lZQjPtkPLBPRk6Vc4NEjns+KhCv3GjW+SN4cqEFsbDBtq/xsg==
X-Received: by 2002:a17:903:26c6:b0:178:b4b7:d74d with SMTP id jg6-20020a17090326c600b00178b4b7d74dmr13500391plb.83.1668431303643;
        Mon, 14 Nov 2022 05:08:23 -0800 (PST)
Received: from [10.72.12.148] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id m1-20020a17090ade0100b0020dc318a43esm6479211pjv.25.2022.11.14.05.08.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Nov 2022 05:08:23 -0800 (PST)
Subject: Re: [PATCH 2/2 v2] ceph: use a xarray to record all the opened files
 for each inode
To:     kernel test robot <lkp@intel.com>, ceph-devel@vger.kernel.org,
        jlayton@kernel.org, idryomov@gmail.com, viro@zeniv.linux.org.uk
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        lhenriques@suse.de, mchangir@redhat.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org
References: <20221114051901.15371-3-xiubli@redhat.com>
 <202211141614.dhSgZRvB-lkp@intel.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <a7243d03-da3a-8df5-1c5c-b4540fb1a91a@redhat.com>
Date:   Mon, 14 Nov 2022 21:08:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <202211141614.dhSgZRvB-lkp@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

Thanks for reporting this.

I will fix it in the next version.

- Xiubo

On 14/11/2022 16:54, kernel test robot wrote:
> Hi,
>
> I love your patch! Perhaps something to improve:
>
> [auto build test WARNING on ceph-client/testing]
> [also build test WARNING on ceph-client/for-linus linus/master v6.1-rc5 next-20221111]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/xiubli-redhat-com/ceph-fix-the-use-after-free-bug-for-file_lock/20221114-132233
> base:   https://github.com/ceph/ceph-client.git testing
> patch link:    https://lore.kernel.org/r/20221114051901.15371-3-xiubli%40redhat.com
> patch subject: [PATCH 2/2 v2] ceph: use a xarray to record all the opened files for each inode
> config: hexagon-randconfig-r041-20221114
> compiler: clang version 16.0.0 (https://github.com/llvm/llvm-project 463da45892e2d2a262277b91b96f5f8c05dc25d0)
> reproduce (this is a W=1 build):
>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          # https://github.com/intel-lab-lkp/linux/commit/232cc8f1dbeddb308946202a7c67ee4d20451ae7
>          git remote add linux-review https://github.com/intel-lab-lkp/linux
>          git fetch --no-tags linux-review xiubli-redhat-com/ceph-fix-the-use-after-free-bug-for-file_lock/20221114-132233
>          git checkout 232cc8f1dbeddb308946202a7c67ee4d20451ae7
>          # save the config file
>          mkdir build_dir && cp config build_dir/.config
>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash fs/ceph/
>
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>):
>
>     In file included from fs/ceph/locks.c:8:
>     In file included from fs/ceph/super.h:8:
>     In file included from include/linux/backing-dev.h:16:
>     In file included from include/linux/writeback.h:13:
>     In file included from include/linux/blk_types.h:10:
>     In file included from include/linux/bvec.h:10:
>     In file included from include/linux/highmem.h:12:
>     In file included from include/linux/hardirq.h:11:
>     In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
>     In file included from include/asm-generic/hardirq.h:17:
>     In file included from include/linux/irq.h:20:
>     In file included from include/linux/io.h:13:
>     In file included from arch/hexagon/include/asm/io.h:334:
>     include/asm-generic/io.h:547:31: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
>             val = __raw_readb(PCI_IOBASE + addr);
>                               ~~~~~~~~~~ ^
>     include/asm-generic/io.h:560:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
>             val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
>                                                             ~~~~~~~~~~ ^
>     include/uapi/linux/byteorder/little_endian.h:37:51: note: expanded from macro '__le16_to_cpu'
>     #define __le16_to_cpu(x) ((__force __u16)(__le16)(x))
>                                                       ^
>     In file included from fs/ceph/locks.c:8:
>     In file included from fs/ceph/super.h:8:
>     In file included from include/linux/backing-dev.h:16:
>     In file included from include/linux/writeback.h:13:
>     In file included from include/linux/blk_types.h:10:
>     In file included from include/linux/bvec.h:10:
>     In file included from include/linux/highmem.h:12:
>     In file included from include/linux/hardirq.h:11:
>     In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
>     In file included from include/asm-generic/hardirq.h:17:
>     In file included from include/linux/irq.h:20:
>     In file included from include/linux/io.h:13:
>     In file included from arch/hexagon/include/asm/io.h:334:
>     include/asm-generic/io.h:573:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
>             val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
>                                                             ~~~~~~~~~~ ^
>     include/uapi/linux/byteorder/little_endian.h:35:51: note: expanded from macro '__le32_to_cpu'
>     #define __le32_to_cpu(x) ((__force __u32)(__le32)(x))
>                                                       ^
>     In file included from fs/ceph/locks.c:8:
>     In file included from fs/ceph/super.h:8:
>     In file included from include/linux/backing-dev.h:16:
>     In file included from include/linux/writeback.h:13:
>     In file included from include/linux/blk_types.h:10:
>     In file included from include/linux/bvec.h:10:
>     In file included from include/linux/highmem.h:12:
>     In file included from include/linux/hardirq.h:11:
>     In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
>     In file included from include/asm-generic/hardirq.h:17:
>     In file included from include/linux/irq.h:20:
>     In file included from include/linux/io.h:13:
>     In file included from arch/hexagon/include/asm/io.h:334:
>     include/asm-generic/io.h:584:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
>             __raw_writeb(value, PCI_IOBASE + addr);
>                                 ~~~~~~~~~~ ^
>     include/asm-generic/io.h:594:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
>             __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
>                                                           ~~~~~~~~~~ ^
>     include/asm-generic/io.h:604:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
>             __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
>                                                           ~~~~~~~~~~ ^
>>> fs/ceph/locks.c:66:6: warning: variable 'fi' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
>             if (val == CEPH_FILP_AVAILABLE) {
>                 ^~~~~~~~~~~~~~~~~~~~~~~~~~
>     fs/ceph/locks.c:79:14: note: uninitialized use occurs here
>             atomic_dec(&fi->num_locks);
>                         ^~
>     fs/ceph/locks.c:66:2: note: remove the 'if' if its condition is always true
>             if (val == CEPH_FILP_AVAILABLE) {
>             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>     fs/ceph/locks.c:47:27: note: initialize the variable 'fi' to silence this warning
>             struct ceph_file_info *fi;
>                                      ^
>                                       = NULL
>     7 warnings generated.
>
>
> vim +66 fs/ceph/locks.c
>
>      42	
>      43	static void ceph_fl_release_lock(struct file_lock *fl)
>      44	{
>      45		struct inode *inode = fl->fl_u.ceph_fl.fl_inode;
>      46		struct ceph_inode_info *ci;
>      47		struct ceph_file_info *fi;
>      48		void *val;
>      49	
>      50		/*
>      51		 * If inode is NULL it should be a request file_lock,
>      52		 * nothing we can do.
>      53		 */
>      54		if (!inode)
>      55			return;
>      56	
>      57		ci = ceph_inode(inode);
>      58	
>      59		/*
>      60		 * For Posix-style locks, it may race between filp_close()s,
>      61		 * and it's possible that the 'file' memory pointed by
>      62		 * 'fl->fl_file' has been released. If so just skip it.
>      63		 */
>      64		rcu_read_lock();
>      65		val = xa_load(&ci->i_opened_files, (unsigned long)fl->fl_file);
>    > 66		if (val == CEPH_FILP_AVAILABLE) {
>      67			fi = fl->fl_file->private_data;
>      68			atomic_dec(&fi->num_locks);
>      69		}
>      70		rcu_read_unlock();
>      71	
>      72		if (atomic_dec_and_test(&ci->i_filelock_ref)) {
>      73			/* clear error when all locks are released */
>      74			spin_lock(&ci->i_ceph_lock);
>      75			ci->i_ceph_flags &= ~CEPH_I_ERROR_FILELOCK;
>      76			spin_unlock(&ci->i_ceph_lock);
>      77		}
>      78		iput(inode);
>      79		atomic_dec(&fi->num_locks);
>      80	}
>      81	
>

