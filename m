Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C69564B053
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 08:20:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233753AbiLMHT6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 02:19:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234571AbiLMHTz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 02:19:55 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9015017E1C
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 23:19:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670915994; x=1702451994;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=zqDMgtQXnqkvpk2b9FoxSOfx9PTSNuJMB8Mlp3TKJRQ=;
  b=ELcyYJrn4uddGv0ME2McK12ssFBAH+FKcGqIw2DGe0hf7IWyPq85D7cm
   vtxKAzmCA6sR+hU7o+tnYp2TH0H5+VB5fYM+tmv2tatWVZZox9d+UZxTR
   gImwXmFCLexQGkurilvzk+s1TELslelhOG1c6KjtoRiVvWlhrqfP48NEW
   O+LSJ4ucvnF4LQ1CpUG29HM61w7OOAjHPE9CJe14/G8sHehm8UE2QQTDG
   7PJX7BZxnY0k2xA9qGbdOWvlN96wI25HWlY7bVmk10nd18GScxdajhvA8
   Shgk5LvRB4G2Oghm0tXUsD+FW9CAi8eD/h7o96WeGh+e9c8zjSXtiuyEF
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="298406377"
X-IronPort-AV: E=Sophos;i="5.96,240,1665471600"; 
   d="scan'208";a="298406377"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2022 23:19:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="822781309"
X-IronPort-AV: E=Sophos;i="5.96,240,1665471600"; 
   d="scan'208";a="822781309"
Received: from lkp-server01.sh.intel.com (HELO b5d47979f3ad) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 12 Dec 2022 23:19:51 -0800
Received: from kbuild by b5d47979f3ad with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1p4zZu-00049z-3A;
        Tue, 13 Dec 2022 07:19:50 +0000
Date:   Tue, 13 Dec 2022 15:18:35 +0800
From:   kernel test robot <lkp@intel.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH stable 4.9.y] block: unhash blkdev part inode when the
 part is deleted
Message-ID: <Y5gnSzLa+xEbcbpZ@0d7994225921>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221213071655.1197875-1-ming.lei@redhat.com>
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
Subject: [PATCH stable 4.9.y] block: unhash blkdev part inode when the part is deleted
Link: https://lore.kernel.org/stable/20221213071655.1197875-1-ming.lei%40redhat.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



