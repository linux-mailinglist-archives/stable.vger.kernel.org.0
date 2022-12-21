Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4200652B85
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 03:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbiLUChn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Dec 2022 21:37:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiLUChm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Dec 2022 21:37:42 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91F975FF8
        for <stable@vger.kernel.org>; Tue, 20 Dec 2022 18:37:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671590261; x=1703126261;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=fqFh9WRIdcZwu6xC+cE5qkJh2a3IarwiQ8SFtG479hY=;
  b=HoLafM3WT3JZBgAfgnYahqha2FSuexTxnYV15TWSTm8pI78UXW7TroUV
   p2gR+DsuLdrif/iJdqGpphSl0nY6UMFQY0fQbr+3tvVl/fNdKtDb5DFO3
   steEergKlLseXqPnPYINlTiTJBW3DcOGUpalzWs2uh7RWNfUH9H/630wb
   c8eSs9a7ioGgpjQge1viOmdpSxGXnEo9ZZtOkws6cTVmQVqWdRtqbb+hR
   4VowXC1Cm+09OpW2M8upVh13SUIzD+3Xs4OM/U3ar4cf357dEk/dxOP/X
   rZD4Ey3/05JJYQq3pMFZTkTXQvZBB95vF70cgFNI43ID5XN+k9o6kGEtM
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="321675538"
X-IronPort-AV: E=Sophos;i="5.96,261,1665471600"; 
   d="scan'208";a="321675538"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2022 18:37:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="681867738"
X-IronPort-AV: E=Sophos;i="5.96,261,1665471600"; 
   d="scan'208";a="681867738"
Received: from lkp-server01.sh.intel.com (HELO b5d47979f3ad) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 20 Dec 2022 18:37:38 -0800
Received: from kbuild by b5d47979f3ad with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1p7ozB-0009nb-1k;
        Wed, 21 Dec 2022 02:37:37 +0000
Date:   Wed, 21 Dec 2022 10:37:07 +0800
From:   kernel test robot <lkp@intel.com>
To:     Ronak Doshi <doshir@vmware.com>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH net ] vmxnet3: correctly report csum_level for
 encapsulated packet
Message-ID: <Y6JxUzQZJ5pV9GBc@416bcb91c936>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221220202556.24421-1-doshir@vmware.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Thanks for your patch.

FYI: kernel test robot notices the stable kernel rule is not satisfied.

Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
Subject: [PATCH net ] vmxnet3: correctly report csum_level for encapsulated packet
Link: https://lore.kernel.org/stable/20221220202556.24421-1-doshir%40vmware.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



