Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6144B64B054
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 08:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234571AbiLMHUI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 02:20:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234605AbiLMHUF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 02:20:05 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA36F17E1C
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 23:20:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670916005; x=1702452005;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=g2atN8N6qCMYT8DVlQ9M4nawF2F97wrUoAqEdbLgsZk=;
  b=nmRDt99dFaBWlzWfxUzPsi4DGb6Yf66fWmNrVgnFsShHVi/IXfhFNsbo
   JpSj3bQGKNQqvUP1oTGLeXsmk6hWNt0w1oiWtGMivy2v4bFMdcaSdeWSx
   R4n638ZLKXoKsspuS8fiJAnYaEk3pk2+b0Zu1AeYgg7rRJ9MPtmSYVyNC
   eh0RNOq47FSPMpmh9AvV6y/5hCbjWuiLUdnAPfUe2IizgH9oV/EYgbbOF
   bFS32PHgZiHSRMR+W2w1W4cRiLnqDzbQzbrC4K3Za0M5MnDrlUUXcbvfa
   pmuEZiDF/W79N2nQNXzKUxTGx1MU1iebNmS1HupGOrEKE2BtK+iYIc+e7
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="345125002"
X-IronPort-AV: E=Sophos;i="5.96,240,1665471600"; 
   d="scan'208";a="345125002"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2022 23:19:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="679213027"
X-IronPort-AV: E=Sophos;i="5.96,240,1665471600"; 
   d="scan'208";a="679213027"
Received: from lkp-server01.sh.intel.com (HELO b5d47979f3ad) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 12 Dec 2022 23:19:51 -0800
Received: from kbuild by b5d47979f3ad with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1p4zZv-0004A2-0I;
        Tue, 13 Dec 2022 07:19:51 +0000
Date:   Tue, 13 Dec 2022 15:18:33 +0800
From:   kernel test robot <lkp@intel.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH stable 4.14.y] block: unhash blkdev part inode when the
 part is deleted
Message-ID: <Y5gnSTtTxQArNZuI@0d7994225921>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221213071627.1197786-1-ming.lei@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Thanks for your patch.

FYI: kernel test robot notices the stable kernel rule is not satisfied.

Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
Subject: [PATCH stable 4.14.y] block: unhash blkdev part inode when the part is deleted
Link: https://lore.kernel.org/stable/20221213071627.1197786-1-ming.lei%40redhat.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



