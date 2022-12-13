Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84ED764B052
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 08:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234477AbiLMHTs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 02:19:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233753AbiLMHTr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 02:19:47 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B869410050
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 23:19:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670915986; x=1702451986;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=KAhCNlGVwdQi8BUp123AdOk7JKiwwlP0CIs18w2kaeA=;
  b=CR/3K/AuRilM6GWUOs71q+HDzi/QNTWFcaBfqrusSsLbOidR8vh81YaP
   RIis22H07Cr6r8g45rvUuXQSKS6vwNezDnb9FjK58UyUfz6F4/U1ir1PC
   dQrrI9t5D9PkUzJMGGqAyQciE3QHOOuSZc2WHrVHg6ixIaxMM3HkiokCX
   7xn10y2jXPoRCNh3a3xDgs+9MfRFAlnzp9z017ke3CvCGJo1obiD/hfAZ
   g9F4pfKrlPDRcdrQHmIdT6HIC/xdWs0qZleaQyAe/NwPARhJjj27hl/MJ
   GO1JuMzXCOZjP+uDiVFvEoLniuGdBnPZ8XRucStvj9wnzyIOpeIcOQXRU
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="316765498"
X-IronPort-AV: E=Sophos;i="5.96,240,1665471600"; 
   d="scan'208";a="316765498"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2022 23:19:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="648464789"
X-IronPort-AV: E=Sophos;i="5.96,240,1665471600"; 
   d="scan'208";a="648464789"
Received: from lkp-server01.sh.intel.com (HELO b5d47979f3ad) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 12 Dec 2022 23:19:45 -0800
Received: from kbuild by b5d47979f3ad with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1p4zZo-00049v-0z;
        Tue, 13 Dec 2022 07:19:44 +0000
Date:   Tue, 13 Dec 2022 15:18:30 +0800
From:   kernel test robot <lkp@intel.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH stable 5.4.y/4.19.y] block: unhash blkdev part inode when
 the part is deleted
Message-ID: <Y5gnRplT8Tll/g+W@0d7994225921>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221213071603.1197703-1-ming.lei@redhat.com>
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
Subject: [PATCH stable 5.4.y/4.19.y] block: unhash blkdev part inode when the part is deleted
Link: https://lore.kernel.org/stable/20221213071603.1197703-1-ming.lei%40redhat.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



